# CubaLibre

**AI-verified milestone escrow for Cuban businesses — without middlemen.**

CubaLibre enables diaspora investors to fund Cuban small businesses through Safe multisig escrow + an AI agent that verifies milestone completion and co-signs every fund release. No bank. No platform custody. No opacity.

> 🤖 **Built with an AI agent** — Satoshi Nakaboto (OpenClaw + Venice AI MiniMax M2.7) co-designed, co-built, and co-deployed this project.
> 📖 **Follow the build:** https://www.moltbook.com/post/343d4e0c-7266-445a-a17c-19e2fbf6d05d

---

## Live Demo

**https://barukimang.github.io/cubalibre/**

Click **"Invertir"** → explore a live investment opportunity on Base Sepolia with a real Safe escrow.

---

## How It Works

```
InvestorBrowse             Fund Safe escrow            Complete milestone
    │                           │                           │
    ▼                           ▼                           ▼
┌─────────────────────────────────────────────────────────────┐
│  Safe{Wallet} 2-of-2 Multisig                              │
│  Co-signer 1: Investor (you)   Co-signer 2: Satoshi (AI)  │
└─────────────────────────────────────────────────────────────┘
    │                           │                           │
    ▼                           ▼                           ▼
 Business gets paid        Funds held in escrow    AI verifies → co-signs → release
```

1. **Browse** — Investor selects a verified Cuban business
2. **Fund** — ETH/stables sent to a Safe 2-of-2 multisig (investor + AI)
3. **Milestones** — Business completes work, submits evidence
4. **Verify** — AI agent (Satoshi) reviews milestone evidence
5. **Release** — Satoshi co-signs the Safe transaction → funds go to business
6. **Audit** — Full on-chain trail, transparent to everyone

---

## Why It Works

| Traditional Finance | CubaLibre |
|---|---|
| Bank decides who gets capital | Investor + AI co-decide |
| Platform takes 5-15% cut | Zero middleman fees |
| Manual, opaque verification | AI verifies, on-chain proof |
| Business has no recourse | Funds held in transparent escrow |
| Cross-border is nearly impossible | Anyone with ETH wallet can invest |

**The AI agent can't be bribed. Doesn't sleep. Maintains a perfect audit trail. Charges nothing.**

---

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Vanilla JS + CSS + Google Fonts |
| Blockchain | Base Sepolia (Ethers.js v6) |
| Escrow | Safe{Wallet} 2-of-2 multisig |
| AI Agent | OpenClaw + Venice AI (MiniMax M2.7) |
| Hosting | Cloudflare Tunnel + GitHub Pages |
| Version Control | Git + GitHub |

---

## On-Chain Addresses (Base Sepolia)

| Role | Address |
|---|---|
| **Safe Escrow** | `0x8948F10E9f3389b428891Df35d68CB031a83d731` |
| **AI Agent (Satoshi)** | `0xDf6fdf1a1D9a1eDd6236fD1169268096E9d300A6` |
| **Restaurant (El Paladar)** | `0x00c8160b76E960247bE5ab5A50782C4bb2D45E54` |

View on [Basescan](https://sepolia.basescan.org/address/0x8948F10E9f3389b428891Df35d68CB031a83d731).

---

## The Demo

The live site includes an interactive investment modal:

- **Live Safe data** — balance, threshold, nonce pulled directly from Base Sepolia
- **Investment panel** — shows your investment amount and milestone progress
- **Demo controls** — simulate the full flow: fund escrow → complete milestone → AI verifies and co-signs
- **Activity log** — console-style audit trail of every step
- **EN ↔ ES toggle** — full bilingual support for global diaspora

---

## Tracks

- 🏆 **Synthesis Open Track**
- 🤖 **Agent Services on Base**
- 📈 **Autonomous Trading Agent**

---

## For Hackathon

Built at [Synthesis Hackathon](https://synthesis.devfolio.co) (March 2026).

Cuba as the beachhead market — architected to expand to other countries with large diaspora + capital gap (Venezuela, Nicaragua, Haiti). The model is the same: AI agent as neutral middleman, Safe escrow as the trust layer, diaspora as the capital source.

**Team:** Satoshi Nakaboto's Team  
**Participants:** barukimang + Satoshi Nakaboto 🤖
