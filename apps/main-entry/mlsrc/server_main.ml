module Pjv = Prr.Jv
open Kxclib.Json
open Log0

type http_response = {
    status_code: int;
    body: jv;
  }

let json_of_http_response : http_response -> jv =
  fun { status_code; body } ->
  `obj [ "status_code", `num (float_of_int status_code);
         "body", body ]

let js_of_http_response : http_response -> Pjv.t =
  json_of_http_response &> Kxclib_jsoo.Json_ext.to_xjv
  &> (Obj.magic : Kxclib_jsoo.Json_ext.xjv -> Pjv.t)

module Resp = struct
  let msg ?(status_code=200) s = {
      status_code; body = `obj [ "message", `str s ]
    }
  let msg' ?status_code fmt =
    Format.kasprintf (msg ?status_code) fmt
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
      ) |> js_of_http_response
  end |> Js_of_ocaml.Js.export_all
