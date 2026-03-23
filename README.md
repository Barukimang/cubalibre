# CubaLibre

**Diaspora investment infrastructure for Cuban businesses — without middlemen.**

> ⚠️ **Power outage fallback:** If the primary demo URL is unreachable, use: https://barukimang.github.io/cubalibre/

## Live Demo

- **Primary:** https://methods-leisure-extremely-montgomery.trycloudflare.com/
- **Backup (GitHub Pages):** https://barukimang.github.io/cubalibre/

## The Problem

Cuban diaspora and international investors want to support Cuban businesses but lack trustworthy mechanisms:
- No access to traditional banking for cross-border investment
- Platforms take cuts and offer no transparency
- No protection for either party if things go wrong
- Verification of milestone completion is manual and opaque

## The Solution

CubaLibre combines:
- **Safe multisig escrow** — funds held until milestones are verified
- **AI agent coordination** — agent verifies milestones, co-signs fund releases
- **Diaspora-first UX** — EN/ES bilingual, mobile-friendly

## How It Works

```
1. InvestorBrowse businesses, commits to Safe escrow
2. Business completes milestones, submits evidence
3. AI agent (Satoshi Nakaboto) verifies milestone completion
4. Agent co-signs Safe transaction → funds release on-chain
5. Full on-chain audit trail, no middlemen
```

## Tech Stack

- **Frontend:** Vanilla JS + Google Fonts
- **Blockchain:** Base Sepolia (Ethers.js v6)
- **Escrow:** Safe{Wallet} 2-of-2 multisig
- **AI Agent:** OpenClaw + Venice AI (MiniMax M2.7)
- **Infrastructure:** Cloudflare Tunnel + GitHub Pages

## Project Addresses (Base Sepolia)

- **Safe Escrow:** `0x8948F10E9f3389b428891Df35d68CB031a83d731`
- **AI Agent (Satoshi):** `0xDf6fdf1a1D9a1eDd6236fD1169268096E9d300A6`
- **Restaurant:** `0x00c8160b76E960247bE5ab5A50782C4bb2D45E54`

## For Hackathon

Built for the Synthesis Hackathon (March 2026). The agent acts as a neutral, incorruptible middleman — verifying milestone completion and co-signing Safe releases. Cuba as the beachhead market, architected to expand.

## Status

Live on Base Sepolia testnet with real Safe escrow.
