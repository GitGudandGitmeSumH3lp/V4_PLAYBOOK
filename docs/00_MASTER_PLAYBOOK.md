---
tags: [packet-prompting, v4.3, master-guide, system-architecture]
created: 2026-03-06
status: Active
version: 4.3.0
---

# Packet Prompting V4.3: Master Playbook

> **V4.3 Changes from V4.0:** Retired fictional Account A/B/C/D/E labels. All agents now mapped to real, named free-tier providers. Context budgets added. API_MAP_micro pattern introduced.

---

## 1. System Philosophy

**From Monolith to Swarm.**
V4.3 is a **Contract-First, Multi-Agent Swarm** powered entirely by free-tier models across three Gmail accounts and two unlimited web tools.

**Core Principles:**
1. **Specialization:** Each agent has one job and one model fit for that job.
2. **Cost Discipline:** Claude is platinum. DeepSeek is the workhorse. Flash is the backbone.
3. **Contract Law:** No implementation begins without a signed Interface Contract.
4. **Context Hygiene (The Diet):** Never feed the Implementer more than 3 files. Never exceed context budgets.
5. **State is God:** If it isn't in `_STATE.md`, it didn't happen.

---

## 2. Provider Registry (The Real Model Map)

This replaces all "Account A/B/C/D/E" references. Use provider names directly.

| Provider | Model | Free Tier Limit | Gmail Used | Primary Role |
|:---------|:------|:----------------|:-----------|:-------------|
| Google AI Studio | Gemini 2.0 Flash | 1,500 RPD / 15 RPM | **Main Gmail** | Orchestrator, Analyst, Refiner, Scout, State Updater |
| Google AI Studio | Gemini 2.0 Flash | 1,500 RPD / 15 RPM | **Work Gmail** | Doc Scribe, Refiner overflow, backup |
| Google AI Studio | Gemini 1.5 Pro | **50 RPD** / 2 RPM | **Student Gmail** | Researcher (large context), Map Generator |
| claude.ai | Claude 3.7 Sonnet | ~20–40 msgs/day | **Main account** | Architect (primary only) |
| deepseek.com (web) | DeepSeek V3 | Unlimited | No account needed | Implementer, Code Merger |
| deepseek.com (web) | DeepSeek R1 | Unlimited | No account needed | Auditor, Wisdom Miner |
| huggingchat.co | Qwen 2.5 72B | Generous | No account needed | Analyst fallback, Architect fallback |

> **⚠️ Quota warnings:**
> - Gemini 1.5 Pro: 50 calls/day total on Student Gmail. Budget ~20 for Researcher, ~20 for Map Generator, ~10 spare.
> - Claude Sonnet: ~20–40 messages/day. Reserve for Architect exclusively. When exhausted → DeepSeek R1 fallback.
> - DeepSeek web can be slow during China peak hours (9am–6pm CST). Fallback: HuggingChat Qwen 2.5 72B.

---

## 3. Agent Roster

| Agent | File | Primary Provider | Fallback | Context Budget |
|:------|:-----|:----------------|:---------|:--------------|
| **Orchestrator** | `00_orchestratorV2.md` | Gemini 2.0 Flash (Main) | Any Flash | 1M tokens |
| **Analyst** | `00_analyst.md` | Gemini 2.0 Flash (Main) | Qwen 2.5 72B | 1M tokens |
| **Architect** | `01_architect.md` | Claude 3.7 Sonnet | DeepSeek R1 | 200K tokens |
| **Implementer** | `02_implementer.md` | DeepSeek V3 | Qwen 2.5 72B | **64K tokens ⚠️** |
| **Refiner** | `03_refiner.md` | Gemini 2.0 Flash (Main) | Work Gmail Flash | 1M tokens |
| **Researcher** | `04_researcher.md` | Gemini 1.5 Pro (Student) | Gemini 2.0 Flash | 2M tokens |
| **Auditor** | `05_auditor.md` | DeepSeek R1 | Gemini Flash Thinking | **64K tokens ⚠️** |
| **Scout** | `06_scout.md` | Gemini 2.0 Flash (Main) | Any Flash | 1M tokens |

> **⚠️ = Hard context ceiling.** Implementer and Auditor both run on DeepSeek (64K). Apply The Diet strictly for these two agents.

---

## 4. Utility Roster

| Utility | File | Primary Provider | Context Budget |
|:--------|:-----|:----------------|:--------------|
| **State Updater** | `state_updater.md` | Gemini 2.0 Flash (Main) | 1M tokens |
| **Map Generator** | `map_generator.md` | Gemini 1.5 Pro (Student) | 2M tokens |
| **Wisdom Miner** | `wisdom_miner.md` | DeepSeek R1 | 64K tokens |
| **Code Merger** | `code_merger.md` | DeepSeek V3 | 64K tokens |
| **Doc Scribe** | `doc_scribe.md` | Gemini 2.0 Flash (Work) | 1M tokens |

---

## 5. Quick Start: New Feature

```
1. Pre-Flight      → Paste _STATE.md to Orchestrator (Gemini Flash, Main)
2. Analyze         → Analyst (Gemini Flash, Main)         → Feature Spec
3. Design          → Architect (Claude Sonnet)             → Contract + Work Order
4. Map             → [if API_MAP > 20K] Map Generator      → API_MAP_micro.md
5. Build           → Implementer (DeepSeek V3)             → Raw Code
6. Polish          → Refiner (Gemini Flash, Main)          → Clean Code
7. Document        → Doc Scribe (Gemini Flash, Work)       → Documented Code
8. Audit           → Auditor (DeepSeek R1)                 → Pass/Fail
9. Sync            → State Updater (Gemini Flash, Main)    → Updated _STATE.md
10. Map Update     → Map Generator (Gemini Pro, Student)   → Updated API Maps
```

---

## 6. Context Hygiene (The Diet)

**Axiom:** "The more context you feed, the dumber the model gets."

| Agent | Max Files | What to Include | What to Drop |
|:------|:----------|:----------------|:-------------|
| Implementer | 3 files | Contract, Work Order, API_MAP_micro | Source repo, full API map, style guide |
| Auditor | 2 files | Code under review, Contract | Everything else |
| Architect | 4 files | Spec, API_MAP_lite, Constraints, Memory | Source files |
| Refiner | 2 files | Raw code, Style guide | Contracts, API maps |
| Researcher | Unlimited | As many source files as needed | Nothing (2M context) |

**The API_MAP_micro Rule:**
When `API_MAP_lite.md` exceeds 20K tokens, do NOT pass it to the Implementer.
Instead: ask the Map Generator to produce `API_MAP_micro.md` — a filtered version containing only the target module and its direct dependencies.

---

## 7. Claude Conservation Protocol

Claude Sonnet is your scarcest daily resource. Protect it.

**Allowed Claude uses:**
- Architect (primary — this is the only mandatory use)
- Code Merger for extremely complex surgical merges (rare)

**Never use Claude for:**
- Refinement / Doc Scribe (use Gemini Flash)
- State updates (use Gemini Flash)
- Auditing (use DeepSeek R1)
- Analyst / Scout (use Gemini Flash)

**When Claude quota is exhausted:**
- Route Architect tasks to DeepSeek R1
- R1 produces ~85% quality contracts for standard modules
- For security-critical or distributed-systems contracts: wait for next day's quota
- Document the fallback in _STATE.md

---

## 8. Baton Pass Protocol

When context approaches limit or switching sessions:

1. Generate cumulative State Update first
2. Confirm State sync
3. Generate Baton Pass document (see Orchestrator for template)
4. New context opens with: "Demand `_STATE.md` paste"

**Context thresholds (Orchestrator running on Gemini 2.0 Flash):**
- Green Zone (0–600K tokens): Continue normally
- Yellow Zone (600K–900K tokens): Prepare Baton Pass
- Red Zone (900K+): Initiate Baton Pass sequence

---

## 9. Anti-Patterns

| ❌ Anti-Pattern | ✅ Correct Pattern |
|:---------------|:------------------|
| Pasting full repo to Implementer | Pass Contract + Work Order + API_MAP_micro only |
| Using Claude for Doc Scribe | Use Gemini Flash (Work Gmail) |
| Using Gemini 1.5 Pro for Scout | Use Gemini 2.0 Flash (file trees are small) |
| Using Gemini 1.5 Pro for Analyst | Use Gemini 2.0 Flash (specs are small) |
| Skipping State Update after a move | State Update is non-optional |
| Referencing "Account C" or "Account E" | Use provider names: "Claude Sonnet", "DeepSeek V3" |
| Passing full API_MAP_lite when >20K | Generate API_MAP_micro first |
| Using DuckDuckGo AI for Researcher | DuckDuckGo has no file upload; use Gemini 1.5 Pro |