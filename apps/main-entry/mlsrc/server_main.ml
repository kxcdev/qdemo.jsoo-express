module Pjv = Prr.Jv
open Kxclib.Json
open Log0

type http_response = {
    status_code : int;
    body        : jv;
  }

let json_of_http_response : http_response -> jv =
  fun { status_code; body } ->
  `obj [ "status_code", `num (float_of_int status_code);
         "body", body ]

let jsobj_of_http_response : http_response -> Pjv.t =
  json_of_http_response &> Kxclib_jsoo.Json_ext.to_xjv
  &> (Obj.magic : Kxclib_jsoo.Json_ext.xjv -> Pjv.t)

let json_of_jsobj : Pjv.t -> jv =
  (Obj.magic : Pjv.t -> Kxclib_jsoo.Json_ext.xjv)
  &> Kxclib_jsoo.Json_ext.of_xjv

module Resp = struct
  let msg ?(status_code=200) s = {
      status_code; body = `obj [ "message", `str s ]
    }
  let msg' ?status_code fmt =
    Format.kasprintf (msg ?status_code) fmt
  let ret ?(status_code=200) ?wrap body =
    let body = match wrap with
      | Some (`in_field fname) -> `obj [ fname, body ]
      | None -> body in
    { status_code; body }
end

let () =
  info "%s loaded" __FILE__;

  object%js

    val handle_get_ =
      fun path_js ->
      let path = Pjv.to_string path_js in
      verbose "handle_get[%s]" path;
      (match path with
       | "/" -> Resp.msg "hello?"
       | _ -> Resp.msg' ~status_code:404 "path not found: %s" path
      ) |> jsobj_of_http_response

    val handle_post_ =
      fun path_js reqbody_js ->
      let path = Pjv.to_string path_js in
      let reqbody = json_of_jsobj reqbody_js in
      verbose "handle_post[%s]@\n @[%a@]" path Json.pp_lit reqbody;
      (match path with
       | "/addxy" -> (
         match
           reqbody
           |> Jv.(pump_field "y" &> pump_field "x")
         with
         | `obj ["x", `num x; "y", `num y] ->
            verbose "/addxy parsed x=%f, y=%f" x y;
            Resp.ret ~wrap:(`in_field "result") (`num (x +. y))
         | _ ->
            Resp.msg ~status_code:400 {|bad request. example: { "x": 1, "y": 2 }|}
       )
       | _ -> Resp.msg' ~status_code:404 "path not found: %s" path
      ) |> jsobj_of_http_response

  end |> Js_of_ocaml.Js.export_all
