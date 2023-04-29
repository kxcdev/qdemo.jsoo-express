import express from "express";
import { answerForPing } from "./lib/ping-pong";

const app = express();
app.use(express.json({ strict: false }));

app.get("/_ping", (req, res) => {
  res.send(answerForPing());
});

const port = process.env.port || 4000;
const server = app.listen(port, () => {
  console.log(`Listening at http://localhost:${port}`);
});
server.on("error", console.error);
