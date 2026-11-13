const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};
const PRODUCT = /^https:\/\/www\.dedeman\.ro\/ro\/[a-z0-9-]+\/p\/\d+\/?$/;
const UA = "Mozilla/5.0 (compatible; ElectroPlan-pret/1.0)";

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), { status, headers: { ...CORS, "content-type": "application/json" } });

const num = (m: RegExpMatchArray | null) => (m ? Number(m[1]) : NaN);

async function readPrice(url: string) {
  const res = await fetch(url, {
    headers: { "User-Agent": UA, "Accept-Language": "ro-RO,ro;q=0.9" },
    redirect: "follow",
    signal: AbortSignal.timeout(15000),
  });
  if (!res.ok) return { url, error: `http ${res.status}` };
  const html = await res.text();
  const gross = num(html.match(/"price_info":\{"final_price":([\d.]+)/));
  const net = num(html.match(/"tax_adjustments":\{"final_price":([\d.]+)/));
  const title = (html.match(/<title>([^<|]+)/) || [])[1]?.trim() || "";
  if (!isFinite(gross) || gross <= 0) return { url, title, error: "fara pret" };
  const n = isFinite(net) && net > 0 ? net : gross / 1.21;
  return { url, title, gross: Math.round(gross * 100) / 100, net: Math.round(n * 100) / 100 };
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });
  if (req.method !== "POST") return json({ error: "method" }, 405);

  const base = Deno.env.get("SUPABASE_URL") || "";
  const key = Deno.env.get("SUPABASE_ANON_KEY") || req.headers.get("apikey") || "";
  const who = await fetch(`${base}/auth/v1/user`, {
    headers: { Authorization: req.headers.get("Authorization") || "", apikey: key },
  });
  if (!who.ok) return json({ error: "auth" }, 401);
  const user = await who.json();
  const admins = (Deno.env.get("ADMIN_EMAILS") || "").toLowerCase().split(",").map((s) => s.trim()).filter(Boolean);
  if (!admins.includes(String(user.email || "").toLowerCase())) return json({ error: "forbidden" }, 403);

  const body = await req.json().catch(() => ({}));
  const urls: unknown = body.urls;
  if (!Array.isArray(urls) || !urls.length || urls.length > 150) return json({ error: "urls" }, 400);

  const out = [];
  for (const u of [...new Set(urls.map(String))]) {
    if (!PRODUCT.test(u)) { out.push({ url: u, error: "link invalid" }); continue; }
    try { out.push(await readPrice(u)); } catch (e) { out.push({ url: u, error: String((e as Error).name || "eroare") }); }
    await new Promise((r) => setTimeout(r, 400));
  }
  return json({ at: Date.now(), results: out });
});
