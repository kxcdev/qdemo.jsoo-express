import { answerForPing } from "./ping-pong";

describe("ping-pong answerForPing", () => {
  it("returns 'pong'", () => {
    expect(answerForPing()).toStrictEqual({ message: "pong" });
  });
});
