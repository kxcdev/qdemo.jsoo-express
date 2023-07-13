module Pjv = Prr.Jv
open Kxclib.Json
open Kxclib.Log0
open Opstic.Monad

let ( let* ) = Opstic.Monad.bind

type http_response = {
  status_code : int;
  body : jv;
}

let json_of_http_response : http_response -> jv =
 fun { status_code; body } ->
  `obj
    [ ("status_code", `num (float_of_int status_code)); ("body", body) ]

let jsobj_of_http_response : http_response -> Pjv.t =
  json_of_http_response &> Kxclib_jsoo.Json_ext.to_xjv
  &> (Obj.magic : Kxclib_jsoo.Json_ext.xjv -> Pjv.t)

let json_of_jsobj : Pjv.t -> jv =
  (Obj.magic : Pjv.t -> Kxclib_jsoo.Json_ext.xjv)
  &> Kxclib_jsoo.Json_ext.of_xjv

module Resp = struct
  let msg ?(status_code = 200) s =
    { status_code; body = `obj [ ("message", `str s) ] }

  let msg' ?status_code fmt = Format.kasprintf (msg ?status_code) fmt

  let ret ?(status_code = 200) ?wrap body =
    let body =
      match wrap with
      | Some (`in_field fname) -> `obj [ (fname, body) ]
      | None -> body
    in
    { status_code; body }
end

let coverage_helper_js =
  object%js
    method reset_counters_js =
      info "Bisect.Runtime.reset_counters";
      Bisect.Runtime.reset_counters ();
      Pjv.undefined

    method write_coverage_data_js =
      info "Bisect.Runtime.write_coverage_data";
      Bisect.Runtime.write_coverage_data ();
      Pjv.undefined

    method get_coverage_data_js =
      info "Bisect.Runtime.get_coverage_data";
      Bisect.Runtime.get_coverage_data () >? Pjv.of_string |? Pjv.null
  end
  [@@coverage off]

let server = Opstic.Server.create ()

let to_promise : http_response Prr.Fut.or_error -> Pjv.t =
 fun m -> Prr.Fut.to_promise ~ok:jsobj_of_http_response m

let () =
  info "%s loaded" __FILE__;
  let obj =
    object%js
      val coverage_helper_js = coverage_helper_js

      val handle_get_ =
        fun path_js ->
          let path = Pjv.to_string path_js in
          verbose "handle_get[%s]" path;
          (match path with
          | "/" -> return (Resp.msg "hello?")
          | _ ->
              return
                (Resp.msg' ~status_code:404 "path not found: %s" path))
          |> to_promise

      val handle_post_ =
        fun path_js reqbody_js _req_js ->
          let path = Pjv.to_string path_js in
          let reqbody = json_of_jsobj reqbody_js in
          verbose "handle_post[%s]@\n @[%a@]" path Json.pp_lit reqbody;
          (match path with
          | "/adder" ->
              Opstic.Monad.then_
                (fun () ->
                  Opstic.Server.handle_request server ~path reqbody
                    reqbody_js)
                (function
                  | Ok body -> return { status_code = 200; body }
                  | Error err ->
                      return
                        {
                          status_code = 500;
                          body = `str (Opstic.Monad.error_to_string err);
                        })
          | "/hello" ->
              Opstic.Monad.return
                { status_code = 200; body = `str "hello" }
          | "/addxy" -> (
              match
                reqbody |> Jv.(pump_field "y" &> pump_field "x")
              with
              | `obj [ ("x", `num x); ("y", `num y) ] ->
                  verbose "/addxy parsed x=%f, y=%f" x y;
                  return
                    (Resp.ret ~wrap:(`in_field "result")
                       (`num (x +. y)))
              | _ ->
                  return
                    (Resp.msg ~status_code:400 (Json.unparse reqbody))
                  (* {|bad request. example: { "x": 1, "y": 2 }|} *))
          | _ -> return (Resp.msg ~status_code:404 "path not found"))
          |> to_promise
    end
  in
  obj |> Js_of_ocaml.Js.export_all

open Opstic

[@@@ocaml.warning "-11-32"]

let%global g =
  let rec loop =
    b#args = "/adder" => a :: `obj (("x", `num __):: ("y", `num __) :: __ );
    a
    *>> ( (a#ans ==> b :: `obj [ ("ans", `num __) ];
           loop),
          a#err ==> b :: `obj [ ("msg", `str __) ] )
  in
  loop

let spec = [%project_global g a]

let () =
  let open Opstic.Comm in
  let rec loop (`b (`args ((x, y, _), ep))) =
    if x > 0. && y > 0. then
      let* ep = send ep (fun x -> x#b#ans) (x +. y) in
      let* vars = receive ep in
      loop vars
    else
      let* ep =
        send ep
          (fun x -> x#b#err)
          "Oops, both x and y should be positive"
      in
      close ep;
      return ()
  in
  start_service server spec loop
