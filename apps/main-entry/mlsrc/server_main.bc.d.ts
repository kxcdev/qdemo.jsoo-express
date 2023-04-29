export type Http_response = {
  status_code: number;
  body: unknown;
};

export declare function handle_get(path: string): Http_response;
