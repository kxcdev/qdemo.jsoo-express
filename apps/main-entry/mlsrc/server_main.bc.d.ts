export type Http_response = {
  status_code: number;
  body: unknown;
};

export declare function handle_get(path: string): Http_response;
export declare function handle_post(
  path: string,
  reqbody: unknown
): Http_response;

export interface Bisect_ppx_jsoo_coverage_helper {
  reset_counters();
  write_coverage_data();
  get_coverage_data(): string | null;
}

export declare const coverage_helper: Bisect_ppx_jsoo_coverage_helper;
