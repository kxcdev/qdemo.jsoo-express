export type Http_response = {
  status_code: number;
  body: unknown;
};

export declare function handle_get(path: string): Http_response;
export declare function handle_post(
  path: string,
  reqbody: unknown
): Http_response;
