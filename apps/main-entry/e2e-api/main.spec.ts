import request from "supertest";
import { app } from "../src/main";
import { describe } from "node:test";

describe("main-entry e2e-api", () => {
  it("ping pong", async () => {
    const res = await request(app).get("/_ping").send();
    expect(res.statusCode).toEqual(200);
    expect(res.body).toStrictEqual({ message: "pong" });
  });
});
