// index.js - Vulkan Scanner Aggregator (Express)
const express = require("express");
const bodyParser = require("body-parser");
const app = express();
app.use(bodyParser.json());

const store = {}; // in-memory: { instanceId: { ts, placeId, brainrots } }

app.get("/", (req, res) => res.send("Vulkan Scanner Aggregator alive"));

app.post("/submit", (req, res) => {
  const payload = req.body || {};
  const instanceId = String(payload.instanceId || "");
  if (!instanceId) return res.status(400).json({ ok:false, error: "missing instanceId" });
  store[instanceId] = {
    ts: payload.ts || Date.now(),
    placeId: payload.placeId || null,
    brainrots: payload.brainrots || []
  };
  return res.json({ ok:true });
});

app.get("/all", (req, res) => {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.json(store);
});

const port = process.env.PORT || 3000;
app.listen(port, () => console.log("Aggregator running on port", port));
