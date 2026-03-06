---
tags: [workflow, sop, battle-plans, v4.3]
created: 2026-03-06
status: Active
version: 4.3.0
description: "Provider-accurate workflow battle plans for V4.3"
---

# V4.3 Workflow Scenario Guide (Battle Plans)

> **V4.3 Update:** All "Account A/B/C/D/E" labels replaced with real provider names. Context budgets added to each step. New Scenario 6: Claude Quota Exhausted.

---

## Quick Select Decision Matrix

| Current Problem | Scenario | Claude Used? | Primary Provider |
|:----------------|:--------:|:------------:|:-----------------|
| "I need a new feature." | **1** | ✅ 1 call (Architect) | DeepSeek V3 + Gemini Flash |
| "Production is broken!" | **2** | ❌ | DeepSeek R1 + DeepSeek V3 |
| "This code is ugly." | **3** | ❌ | Gemini Flash |
| "Why does this fail?" | **4** | ✅ 1 call (Architect) | DeepSeek R1 + Gemini Pro |
| "Onboard this old codebase." | **5** | ✅ 1 call (Architect) | Gemini Pro + DeepSeek V3 |
| "Claude quota is gone." | **6** | ❌ | DeepSeek R1 for all |

---

## 🏗️ Scenario 1: Feature Development (The Full Assembly)

**Context:** Building a new module from scratch.  
**Cost Profile:** 1 Claude call + DeepSeek (unlimited) + Gemini Flash (cheap)

| Step | Agent | Provider | Gmail | Input Files | Output |
|:-----|:------|:---------|:------|:-----------|:-------|
| **1** | Analyst | Gemini 2.0 Flash | Main | Raw idea + constraints (~5K) | Feature Spec |
| **2** | Architect | Claude 3.7 Sonnet | claude.ai | Spec + API_MAP_lite/micro + constraints (~20K) | Contract + Work Order |
| **2a** | *(if API_MAP_lite >20K)* Map Generator | Gemini 1.5 Pro | Student | API_MAP_lite + contract | API_MAP_micro |
| **3** | Implementer | DeepSeek V3 | Web | Contract + Work Order + API_MAP_micro (~20K) | Raw Code |
| **4** | Refiner | Gemini 2.0 Flash | Main | Raw Code + style guide (~30K) | Polished Code |
| **5** | Doc Scribe | Gemini 2.0 Flash | Work | Polished Code (~30K) | Documented Code |
| **6** | Auditor | DeepSeek R1 | Web | Code + Contract (~25K) | Pass/Fail |
| **7** | State Updater | Gemini 2.0 Flash | Main | _STATE.md + activity (~8K) | Updated State |
| **8** | Map Generator | Gemini 1.5 Pro | Student | All contracts | Updated API Maps |

> **⚠️ After Step 2:** Check `API_MAP_lite.md` size. If it's >20K tokens, run Step 2a before Step 3.
>
> **⚠️ After Step 6 (FAIL):** Return to Implementer with audit report. Do NOT proceed to Step 7 yet.

---

## 🚑 Scenario 2: The Hotfix (Emergency Patch)

**Context:** Critical bug in production. Speed is priority. Skip Architect and Refiner.  
**Cost Profile:** Zero Claude calls.

| Step | Agent | Provider | Gmail | Input | Output |
|:-----|:------|:---------|:------|:------|:-------|
| **1** | Researcher | Gemini 1.5 Pro | Student | Error logs + broken code | Root Cause Analysis |
| **2** | Implementer | DeepSeek V3 | Web | Broken code + bug report (~20K) | Patched Code |
| **3** | Auditor | DeepSeek R1 | Web | Patched code + original contract (~25K) | Pass/Fail |
| **4** | State Updater | Gemini 2.0 Flash | Main | _STATE.md + patch summary | Updated State |

> **⚠️ Minimal Change Rule:** Instruct Implementer explicitly: "Fix the logic defect with the minimum line changes. Do NOT reformat or restructure unchanged sections."

---

## 🧹 Scenario 3: Refactoring & Cleanup

**Context:** Code works but is messy. No logic changes intended.  
**Cost Profile:** Zero Claude calls. All Gemini Flash.

| Step | Agent | Provider | Gmail | Input | Output |
|:-----|:------|:---------|:------|:------|:-------|
| **1** | Researcher | Gemini 2.0 Flash | Main | Messy code (~30K, Flash is sufficient) | Cleanup list |
| **2** | Refiner | Gemini 2.0 Flash | Main | Messy code + style guide | Formatted code |
| **3** | Doc Scribe | Gemini 2.0 Flash | Work | Formatted code | Documented code |
| **4** | Auditor | DeepSeek R1 | Web | Clean code + contract | Verify logic unchanged |
| **5** | State Updater | Gemini 2.0 Flash | Main | _STATE.md + summary | Updated State |

> Use Gemini 1.5 Pro (Student) for Step 1 only if the codebase exceeds 50K tokens. Under that threshold, Flash handles it fine.

---

## 🕵️ Scenario 4: Deep Debugging (The Consultant)

**Context:** Complex architectural flaw — not patchable. Needs redesign.  
**Cost Profile:** 1 Claude call (Architect redesign).

| Step | Agent | Provider | Gmail | Input | Output |
|:-----|:------|:---------|:------|:------|:-------|
| **1** | Auditor | DeepSeek R1 | Web | Broken code + contract (~25K) | Diagnostic Report |
| **2** | Researcher | Gemini 1.5 Pro | Student | Full codebase context | Context Brief |
| **3** | Architect | Claude 3.7 Sonnet | claude.ai | Diagnostic + original specs (~30K) | Revised Contract |
| **4** | Implementer | DeepSeek V3 | Web | Revised contract + work order (~20K) | New Code |
| **5** | Auditor | DeepSeek R1 | Web | New code + revised contract | Pass/Fail |
| **6** | Wisdom Miner | DeepSeek R1 | Web | Session transcript | Updated project_memory.md |
| **7** | State Updater | Gemini 2.0 Flash | Main | _STATE.md + summary | Updated State |

---

## 🏛️ Scenario 5: Legacy Modernization (The Archaeologist)

**Context:** Onboarding an existing codebase into the V4.3 system.  
**Cost Profile:** 1 Claude call (Architect designs adapter contract).

| Step | Agent | Provider | Gmail | Input | Output |
|:-----|:------|:---------|:------|:------|:-------|
| **1** | Scout | Gemini 2.0 Flash | Main | Directory tree (~5K) | Target List |
| **2** | Researcher | Gemini 1.5 Pro | Student | Tier 1 + Tier 2 files (can be 100K+) | Dependency Map |
| **3** | Analyst | Gemini 2.0 Flash | Main | Dependency Map + user intent (~15K) | Integration Spec |
| **4** | Architect | Claude 3.7 Sonnet | claude.ai | Integration Spec + constraints (~25K) | Adapter Contract |
| **5** | Implementer | DeepSeek V3 | Web | Adapter Contract + work order (~20K) | Wrapper Code |
| **6** | Auditor | DeepSeek R1 | Web | Wrapper + contract (~25K) | Baseline Status |
| **7** | Map Generator | Gemini 1.5 Pro | Student | New contract | Updated API Maps |
| **8** | State Updater | Gemini 2.0 Flash | Main | _STATE.md + summary | Updated State |

> **⚠️ Do NOT** paste the full legacy source into Implementer. Researcher distills it into a dependency map first. Implementer only sees the contract.

---

## 🔴 Scenario 6: Claude Quota Exhausted (New in V4.3)

**Context:** Claude's ~20–40 daily messages are used up before an Architect task arrives.  
**Cost Profile:** Zero Claude calls. DeepSeek R1 handles Architect role.

| Step | Agent | Provider | Gmail | Input | Output |
|:-----|:------|:---------|:------|:------|:-------|
| **1** | Analyst | Gemini 2.0 Flash | Main | Raw idea + constraints | Feature Spec |
| **2** | Architect (R1 mode) | DeepSeek R1 | Web | Spec + 01_architect.md persona + constraints (~25K) | Contract (R1-generated) |
| **3** | Auditor | DeepSeek R1 | Web | R1 Contract + spec (~20K) | Contract Quality Check |
| **4** | Implementer | DeepSeek V3 | Web | Verified contract + work order | Raw Code |
| **5** | Refiner + Doc Scribe | Gemini Flash | Main + Work | Code + style guide | Documented Code |
| **6** | Auditor | DeepSeek R1 | Web | Code + contract | Pass/Fail |
| **7** | State Updater | Gemini 2.0 Flash | Main | _STATE.md | Updated State |

**How to invoke R1 as Architect fallback:**

Paste this prefix into DeepSeek R1 before the normal Architect prompt:

```
You are acting as a Systems Architect under contract-first development principles.
Your SOLE job is to design the interface contract. DO NOT write implementation code.
Output format: Follow the CONTRACT template and WORK ORDER template exactly as shown below.
[Paste 01_architect.md OUTPUT STRUCTURE section]
```

**When to wait for Claude instead of using R1:**
- Contracts involving distributed systems or complex concurrency
- Security-critical authentication/authorization designs
- Revising a previously failed R1-generated contract
- When the spec has high ambiguity that requires back-and-forth clarification

**Always log R1 fallback in `_STATE.md`:**
```
[Date] Architect used DeepSeek R1 fallback (Claude quota exhausted).
Contract: docs/contracts/[filename].md — verify before Build phase.
```

---

## 🛑 Common Pitfalls

| Pitfall | Impact | Fix |
|:--------|:-------|:----|
| Using Gemini Pro for Scout or Analyst | Wastes 50 RPD Pro quota | Use Gemini Flash for both |
| Passing full API_MAP_lite (>20K) to Implementer | Silent context overflow → hallucinations | Generate API_MAP_micro first |
| Using Claude for Refiner or Doc Scribe | Wastes platinum daily budget | Use Gemini Flash (it's faster for text) |
| Using DuckDuckGo AI as Researcher | Has no file upload → cannot analyze code | Use Gemini 1.5 Pro (Student Gmail) |
| Skipping State Update between steps | Next session starts blind | State Update is non-optional |
| Feeding Auditor >25K token input | R1 reasoning gets truncated | Use two-pass audit if code+contract >25K |
| Not checking DeepSeek peak hours | Long wait times kill productivity | Fallback: Qwen 2.5 72B (HuggingChat) |