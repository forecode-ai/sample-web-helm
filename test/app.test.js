import assert from "node:assert/strict";
import { test } from "node:test";
import { handle } from "../src/app.js";

test("health check answers ok", () => {
  assert.deepEqual(handle("/healthz"), { status: 200, body: "ok" });
});

test("unknown paths are not found", () => {
  assert.equal(handle("/nope").status, 404);
});
