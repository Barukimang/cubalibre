# CubaLibre

**Diaspora investment infrastructure for Cuban businesses — without middlemen.**

CubaLibre enables trustless, milestone-based investment from international investors into Cuban businesses, powered by AI agents and smart contracts.

## 🔗 Live Demo

**Frontend**: [https://cubalibre.vercel.app](https://cubalibre.vercel.app) (or open `index.html` directly)

**Safe Escrow**: [https://app.safe.global/home?safe=basesep:0xDEe832DBCC6fF79c9b296cA6006BfEdE75F88448](https://app.safe.global/home?safe=basesep:0xDEe832DBCC6fF79c9b296cA6006BfEdE75F88448)

## The Problem

Cuban diaspora and international investors want to support Cuban businesses but lack trustworthy mechanisms:
- No access to traditional banking for cross-border investment
- Platforms take cuts and offer no transparency
- No protection for either party if things go wrong
- Verification of milestone completion is manual and opaque

## The Solution

CubaLibre combines:
- **ERC-8004 identity** — both investor and business have on-chain identity
- **Smart contract escrow** — funds held until milestones are verified
- **AI agent coordination** — agent (Satoshi Nakaboto) verifies milestones, releases funds, provides transparency
- **Safe multisig** — investors never fully lose control of committed capital

## How It Works

```
1. Business creates profile with ERC-8004 identity
2. Business posts investment ask with milestones
3. Investor browses businesses, commits stablecoins to Safe escrow
4. AI Agent monitors milestone completion
5. Agent releases funds as milestones are verified (via 2-of-2 Safe signature)
6. Both parties build on-chain reputation
```

## Demo: El Paladar

A live demo showcasing diaspora investment from Miami → Havana:

- **Business**: El Paladar — Cuban restaurant in Old Havana seeking $500 to expand
- **Investor**: Cuban-American in Miami committing $500 via Safe escrow
- **AI Agent**: Satoshi Nakaboto verifies milestone evidence and co-signs fund releases
- **Network**: Base Sepolia (testnet)

### Milestones
1. ✅ $200 — Purchase kitchen equipment (verified & released)
2. 🔄 $150 — Hire 2 additional staff (in progress)
3. ⏳ $150 — Launch expanded menu (pending)

## Tech Stack

- **Smart Contracts**: Solidity (Base Sepolia)
- **Frontend**: Vanilla JS + ethers.js (single `index.html`, no build required)
- **Wallet / Escrow**: Safe multisig (2-of-2: investor + AI agent)
- **Agent**: OpenClaw (AI agent as Safe co-signer)
- **Identity**: ERC-8004

## Smart Contract

The `CubaLibre.sol` contract handles:
- Investment creation with milestone arrays
- Funding via Safe escrow
- Milestone completion by business
- Agent verification → fund release via Safe execTransaction
- Dispute resolution

See `contracts/CubaLibre.sol` for full implementation.

## AI Agent

Satoshi Nakaboto is an OpenClaw agent that:
- Reviews milestone completion evidence submitted by businesses
- Verifies evidence legitimacy before triggering releases
- Co-signs Safe transactions (2-of-2 multisig)
- Provides transparency to both investor and business

See `agent/AGENT.md` for full agent instructions.

## Setup

```bash
# Install dependencies
yarn install

# Compile contracts
npx hardhat compile

# Run local node
npx hardhat node

# Deploy to Base Sepolia
npx hardhat run scripts/deploy.js --network baseSepolia
```

## Files

```
├── index.html          # Full demo frontend (open directly in browser)
├── contracts/
│   └── CubaLibre.sol   # Escrow + milestone smart contract
├── agent/
│   └── AGENT.md        # AI agent instructions
├── package.json
└── hardhat.config.js   # Base Sepolia + local networks
```

## Tracks

- �pay: Agents that pay
- 🤝trust: Agents that trust
- 🤖cooperate: Agents that cooperate

## Hackathon

Built for **The Synthesis** hackathon (March 2026).

Cuba as the beachhead market — architected to expand to other countries with diaspora + capital gap (Venezuela, Nicaragua, etc.).
