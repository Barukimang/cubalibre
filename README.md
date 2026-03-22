# CubaLibre

**Diaspora investment infrastructure for Cuban businesses — without middlemen.**

CubaLibre enables trustless, milestone-based investment from international investors into Cuban businesses, powered by AI agents and smart contracts.

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
- **AI agent coordination** — agent verifies milestones, releases funds, provides transparency
- **Safe multisig** — investors never fully lose control of committed capital

## How It Works

```
1. Business creates profile with ERC-8004 identity
2. Business posts investment ask with milestones
3. InvestorBrowse businesses, commits stablecoins to escrow
4. Agent monitors milestone completion
5. Agent releases funds as milestones are verified
6. Both parties build on-chain reputation
```

## Tracks

- Agents that pay
- Agents that trust  
- Agents that cooperate

## Tech Stack

- **Smart Contracts**: Solidity (Base)
- **Frontend**: Next.js
- **Wallet**: Safe
- **Agent**: OpenClaw
- **Identity**: ERC-8004

## For Hackathon

Built for The Synthesis hackathon (March 2026). Cuba as the beachhead market, architected to expand to other countries with diaspora + capital gap (Venezuela, Nicaragua, etc.).

## Status

Under development — building towards March 22 submission deadline.

## Testnet ETH Faucet
- **Alchemy Base Sepolia**: https://www.alchemy.com/faucets/base-sepolia (0.1 ETH/day, free account)
- Fund Safe directly: `0xDEe832DBCC6fF79c9b296cA6006BfEdE75F88448`
