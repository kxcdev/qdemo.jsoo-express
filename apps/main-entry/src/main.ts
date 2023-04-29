import express from "express";
import { answerForPing } from "./lib/ping-pong";
import * as camlimpl from "../mlsrc/server_main.bc";

export const app = express();
app.use(express.json({ strict: false }));

app.get("/_ping", (req, res) => {
  res.send(answerForPing());
});

app.get("/*", (req, res) => {
  const { status_code, body } = camlimpl.handle_get(req.path);
  res.status(status_code).send(body);
});

app.post("/*", (req, res) => {
  const { status_code, body } = camlimpl.handle_post(req.path, req.body);
  res.status(status_code).send(body);
});

/* istanbul ignore next */
if (process.env.NODE_ENV !== "test") {
  const port = process.env.port || 4000;
  const server = app.listen(port, () => {
    console.log(`Listening at http://localhost:${port}`);
  });
  server.on("error", console.error);
}
