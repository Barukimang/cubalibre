# CubaLibre Demo — Development Log

**Date:** 2026-03-24
**Project:** CubaLibre — El Paladar Investment Demo
**Site:** https://barukimang.github.io/cubalibre/

---

## Goal
Full milestone demo for Synthesis hackathon: M1 → M2 → Release, with agent signing Safe transactions via the demo UI.

---

## Working Commit
`c5400d2` (gh-pages + dev)

---

## Architecture

### Signing Flow (modalVerify)
1. Browser computes EIP-712 Safe transaction hash using ethers.js v5
2. POSTs hash to signer server at cloudflare tunnel URL
3. Signer server returns 65-byte ECDSA signature (agent private key never in browser)
4. Proposes to Safe Transaction Service API with agent signature + origin metadata
5. Shows Safe app link for investor to sign and execute

### Demo Embed
- Main page (`/cubalibre/`) shows a browser-chrome iframe (`demo-embed`)
- Iframe loads `?embed=1` which auto-opens the paladar modal
- Embed URL: `https://barukimang.github.io/cubalibre/?embed=1`

### Signer Server
- Running at port 18888 on the server
- Cloudflare tunnel for public access (URL changes on restart)
- Endpoint: `POST /sign` with `{"hash": "0x..."}` → `{"signature": "0x..."}`

### Key Addresses
- **Safe:** `0x8948F10E9f3389b428891Df35d68CB031a83d731` (Base Sepolia)
- **Agent wallet:** `0xDf6fdf1a1D9a1eDd6236fD1169268096E9d300A6`
- **Business:** `0x00c8160b76E960247bE5ab5A50782C4bb2D45E54`

---

## Fixes Applied (2026-03-24)

### Demo Embed Iframe
- Was pointing to dead cloudflare tunnel (`attract-neil-slim-rise.trycloudflare.com`)
- Fixed to load from GitHub Pages: `https://barukimang.github.io/cubalibre/?embed=1`
- Embed mode: hides nav, hero, demo-section, cta, partners, footer — auto-opens paladar modal

### Trust Headline (English page)
- Was showing Spanish: "Un agente IA en el que realmente puedes confiar."
- Fixed to: "An AI agent you can actually trust."

### ethers.js v5 Compatibility
- v6 UMD bundle doesn't include `SigningKey` API
- Switched to ethers v5.7.2 CDN
- Fixed: `ethers.providers.JsonRpcProvider`, `ethers.constants.ZeroAddress`, `ethers.utils.parseEther`, `ethers.utils.keccak256`, `ethers.utils.id`, `ethers.utils.concat`

---

## Open Issues

- [ ] wow factors: dot animation, ambient glow, confetti burst, "Try clicking me!" hint pulse
- [ ] Safe Escrow section: 3 fields side by side in one row
- [ ] Safe address clickable (link to Safe web app)
- [ ] Merge gh-pages into main when hackathon ends
- [ ] Persistent tunnel solution needed (cloudflare quick tunnels change URL on restart)
- [ ] Tunnel URL refresh — current: `https://musicians-avi-translation-thousands.trycloudflare.com`

---

## Commands

```bash
# Push to gh-pages and dev
git add index.html && git commit -m "message" && git push origin gh-pages
git push origin gh-pages:dev --force

# Copy to live workspace
cp /root/.openclaw/workspace/cubalibre-git/index.html /root/.openclaw/workspace/cubalibre/index.html

# Signer server
curl -X POST http://localhost:18888/sign -H "Content-Type: application/json" -d '{"hash":"0x..."}'

# Restart cloudflare tunnel
pkill -f cloudflared; cloudflared tunnel --url http://localhost:18888
```
