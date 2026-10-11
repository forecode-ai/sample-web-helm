import { createServer } from "node:http";
import { handle } from "./app.js";

const port = Number(process.env.PORT ?? 8080);
createServer((req, res) => {
  const { status, body } = handle(req.url ?? "/");
  res.writeHead(status, { "content-type": status === 200 && req.url === "/" ? "text/html" : "text/plain" });
  res.end(body);
}).listen(port, () => console.log(`listening on ${port}`));
