import express from "express";
import { answerForPing } from "./lib/ping-pong";
import * as camlimpl from "../mlsrc/server_main.bc";

export const app = express();
app.use(express.json({ strict: false }));

app.get("/_ping", (req, res) => {
  res.send(answerForPing());
});

app.get("/*", async (req, res) => {
  const { status_code, body } = await camlimpl.handle_get(req.path);;
  return res.status(status_code).send(body);
});

app.post("/*", async (req, res) => {
  console.log(req.body)
  try {
    const { status_code, body } = await camlimpl.handle_post(req.path, req.body, req);
    return res.status(status_code).send(body);
  } catch (err) {
    console.log("Error:" + (err as any));
    if (err instanceof Error) {
      if (err.name == "OpsticError") {
        return res.status(500).send(err.name + ": " + err.message);
      }
    }
    throw err;
  }

});

/* istanbul ignore next */
if (process.env.NODE_ENV !== "test") {
  const port = process.env.port || 4000;
  const server = app.listen(port, () => {
    console.log(`Listening at http://localhost:${port}`);
  });
  server.on("error", console.error);
}
