import request from "supertest";
import { app } from "../src/main";
import { coverage_helper } from "../mlsrc/server_main.bc.js";

describe("main-entry e2e-api", () => {
  afterAll(() => {
    coverage_helper.write_coverage_data();
    coverage_helper.reset_counters();
  });
  it("ping pong", async () => {
    const res = await request(app).get("/_ping").send();
    expect(res.statusCode).toEqual(200);
    expect(res.body).toStrictEqual({ message: "pong" });
  });
  it("handles GET requests", async () => {
    const res = await request(app).get("/").send();
    expect(res.statusCode).toEqual(200);
    expect(res.body).toStrictEqual({ message: "hello?" });
  });
  it("handles POST requests", async () => {
    {
      const res = await request(app).post("/addxy").send({ x: 3, y: 5 });
      expect(res.statusCode).toEqual(200);
      expect(res.body).toStrictEqual({ result: 8 });
    }

    {
      const res = await request(app).post("/addxy").send({ a: 3, b: 5 });
      expect(res.statusCode).toEqual(400);
      expect((res.body as { message: string }).message).toContain(
        "bad request"
      );
    }
  });
  it("handles 404 (GET)", async () => {
    const res = await request(app).get("/it-should-not-exists").send();
    expect(res.statusCode).toEqual(404);
    expect(res.body).toHaveProperty("message");
    expect((res.body as { message: string }).message).toContain("not found");
  });
  it("handles 404 (POST)", async () => {
    const res = await request(app).post("/it-should-not-exists").send({ x: 0 });
    expect(res.statusCode).toEqual(404);
    expect(res.body).toHaveProperty("message");
    expect((res.body as { message: string }).message).toContain("not found");
  });
});
