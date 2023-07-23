import * as camlimpl from "./server_main.bc.js";
import { coverage_helper } from "./server_main.bc.js";

describe("mlsrc/server_main correctness", () => {
  afterAll(() => {
    coverage_helper.write_coverage_data();
    coverage_helper.reset_counters();
  });
  it("gives 404 on non-existing GET paths", () => {
    const { status_code, body } = camlimpl.handle_get(
      "/this-path-should-not-exists-or-we-are-screwed"
    );
    expect(status_code).toEqual(404);
    expect(body).toHaveProperty("message");
    expect((body as { message: string }).message).toContain("path not found");
  });
});
