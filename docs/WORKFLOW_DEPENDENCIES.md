---
tags: [workflow, dependencies, diagnostics, v4.3]
version: 4.3.0
---

# PACKET PROMPTING V4.3 — SYSTEM DEPENDENCY MAP

> **V4.3 Update:** All "Account A/B/C/D/E" labels retired. Provider names used throughout. Context budget constraints documented for DeepSeek agents.

---

## 1. AGENT CHAINING RULES

- **Rule 1:** You cannot run Implementer (DeepSeek V3) without a Contract from Architect (Claude Sonnet or R1 fallback).
- **Rule 2:** Refiner (Gemini Flash) must receive *raw* code from Implementer. Do not feed it a Contract.
- **Rule 3:** Auditor (DeepSeek R1) requires TWO inputs: Code AND Contract. Without both, it cannot judge Pass/Fail.
- **Rule 4:** When `API_MAP_lite.md` exceeds 20K tokens, Map Generator must produce `API_MAP_micro.md` before Implementer runs.
- **Rule 5:** Claude Sonnet is authorized for Architect only. Route everything else to free models.

---

## 2. PROVIDER REQUIREMENTS (The "Missing Model" List)

If an agent asks for something you don't have, here's why:

| Symptom | Cause | Fix |
|:--------|:------|:----|
| Architect asks for `api_map_micro.md` but it doesn't exist | API_MAP_lite.md has grown >20K | Run Map Generator → API_MAP_micro first |
| Implementer output has hallucinated imports | `API_MAP_micro.md` not provided, or lite was too large | Always verify Implementer got the map |
| Researcher says "I cannot analyze the codebase" | You're using DuckDuckGo AI or Flash for a massive input | Switch to Gemini 1.5 Pro (Student Gmail) |
| Auditor output seems shallow / misses logic issues | Wrong model used (e.g., Flash instead of R1) | Use DeepSeek R1 for Auditor — chain-of-thought is required |
| Context cutoff mid-generation | Input exceeded model limit | DeepSeek: stay under 30K; Flash: stay under 40K |

---

## 3. PROVIDER STRATEGY LOGIC

| Agent | Provider | Why |
|:------|:---------|:----|
| Architect | Claude 3.7 Sonnet | Highest reasoning depth; contracts are the most critical artifact |
| Implementer | DeepSeek V3 | Best free code generation; unlimited web access |
| Auditor | DeepSeek R1 | Chain-of-thought reasoning catches logic flaws standard models miss |
| Researcher | Gemini 1.5 Pro | Only free model with 2M context window for large codebase analysis |
| Map Generator | Gemini 1.5 Pro | Must read all contracts simultaneously |
| Scout | Gemini 2.0 Flash | File trees are <10K tokens; Pro is wasted here |
| Analyst | Gemini 2.0 Flash | Spec inputs are small; Pro is wasted here |
| Refiner | Gemini 2.0 Flash | Text generation and formatting don't require premium reasoning |
| Doc Scribe | Gemini 2.0 Flash | Same as Refiner |
| State Updater | Gemini 2.0 Flash | Templated task; minimal intelligence required |
| Code Merger | DeepSeek V3 | Surgical diff task; precision over reasoning |
| Wisdom Miner | DeepSeek R1 | Session analysis benefits from chain-of-thought reasoning |

---

## 4. CONTEXT BUDGET QUICK REFERENCE

| Agent | Model | Hard Limit | Recommended Max | Overflow Protocol |
|:------|:------|:----------|:----------------|:-----------------|
| Implementer | DeepSeek V3 | 64K tokens | 30K | Use API_MAP_micro; drop _memory_snippet; describe source verbally |
| Auditor | DeepSeek R1 | 64K tokens | 25K | Two-pass audit (contract compliance first, style second) |
| Code Merger | DeepSeek V3 | 64K tokens | 40K | Split file into sections if original >20K |
| Wisdom Miner | DeepSeek R1 | 64K tokens | 30K | Summarize transcript before passing |
| Architect | Claude Sonnet | 200K tokens | 50K | Use API_MAP_micro instead of lite if lite >20K |
| All Flash agents | Gemini 2.0 Flash | 1M tokens | 40K | Split large files into class/module sections |
| Researcher | Gemini 1.5 Pro | 2M tokens | 500K | Virtually no practical limit for codebase work |

---

## 5. DAILY QUOTA MANAGEMENT

```
DAILY QUOTA TRACKER
Date: ___________

[ ] Claude 3.7 Sonnet (claude.ai)
    Used: ___ / ~30 msgs
    Remaining: ___
    Rule: Reserve for Architect only. Never use for formatting/docs/state.

[ ] Gemini 1.5 Pro (Student Gmail — 50 RPD)
    Used: ___ / 50
    Breakdown: ~20-25 Researcher calls + ~15-20 Map Generator runs + ~10 spare

[ ] DeepSeek web (unlimited)
    Status: [ ] Fast  [ ] Slow (peak: 9am–6pm CST)
    Fallback if slow: Qwen 2.5 72B (HuggingChat)

[ ] Gemini 2.0 Flash (Main Gmail — 1,500 RPD)
    Used: ___ (rarely matters)
    Role: Orchestrator, Analyst, Refiner, Scout, State Updater

[ ] Gemini 2.0 Flash (Work Gmail — 1,500 RPD)
    Used: ___ (backup / Doc Scribe overflow)
```

---

## 6. COMMON FAILURE MODES & DIAGNOSTICS

| Symptom | Cause | Fix |
|:--------|:------|:----|
| "Code generation cut off halfway." | Prompt exceeded model context limit | Remove non-essential files; split the task |
| "Agent refuses and asks for permissions." | Trying to use code execution on a text-only agent | Remind agent it's a text simulator; run code locally |
| "Agent hallucinated a library that doesn't exist." | Missing `system_constraints.md` or API_MAP in prompt | Always paste constraints and API map |
| "Implementer changed code it wasn't supposed to touch." | Too many files in context caused scope confusion | Apply The Diet strictly: contract + work order + micro map only |
| "Auditor passed code that later had bugs." | Used Flash instead of R1 for auditing | DeepSeek R1 chain-of-thought is required for quality auditing |
| "DeepSeek is taking forever." | Peak hours (9am–6pm CST, China timezone) | Switch to Qwen 2.5 72B (HuggingChat) as fallback |
| "Claude ran out of messages mid-pipeline." | Claude quota (~30/day) was not conserved | Follow Claude Conservation Protocol; route Architect to R1 fallback |
| "Gemini Pro quota hit 50 before end of day." | Pro used for Scout/Analyst tasks that don't need it | Scout and Analyst must use Gemini Flash |