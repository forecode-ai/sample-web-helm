// Request handler, kept apart from the server so tests can call it directly.
export function handle(url) {
  if (url === "/healthz") return { status: 200, body: "ok" };
  if (url === "/") return { status: 200, body: "<h1>Storefront</h1>" };
  return { status: 404, body: "not found" };
}
