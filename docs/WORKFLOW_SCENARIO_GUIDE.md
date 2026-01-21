---
tags: [packet-prompting, v4, workflows, scenarios, sop]
created: 2026-01-17
status: Active
description: "If-Then operational guide for V4.0 agents and account allocation"
---

# V4.0 Workflow Scenario Guide (Battle Plans)

## Introduction
This manual provides tactical "Battle Plans" for common software development scenarios. In the Packet Prompting V4.0 architecture, you do not simply "ask the AI to code." You **assemble a packet**.

**A Packet consists of:**
1.  **Context:** The necessary files (Specs, Constraints, API Maps).
2.  **The Agent:** The specific persona prompt (e.g., `[[01_architect]]`).
3.  **The Skill:** An injectable capability module (e.g., `[[security_hardening]]`).

Choose your scenario below to determine the assembly order.

---

## 🏗️ Scenario 1: Feature Development (The Assembly Line)
**Context:** Building a new module or functionality from scratch. This is the rigorous "Clean Room" process ensuring stability and contract adherence.

**Cost Profile:** ⭐⭐⭐ (High - Uses Premium Models)

| Step | Agent | Account (Model) | Skill Injection | Action / Input | Output Artifact |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **1** | [[04_researcher]] | **B** (Gemini Pro) | N/A | **Optional:** "Analyze these specs and `docs/API_MAP_lite.md`. Identify dependencies." | Context Brief |
| **2** | [[01_architect]] | **C** (Claude Sonnet) | N/A | **Input:** Feature Spec + Context Brief + `docs/system_constraints.md`. | **The Contract** (`docs/contracts/*.md`) |
| **3** | [[02_implementer]] | **E** (DeepSeek V3) | [[reflection_logic]] | **Input:** The Contract + Work Order. "Implement strictly." | **Raw Code** (`src/*.py`) |
| **4** | [[03_refiner]] | **A** (Gemini Flash) | [[python_strict_typing]] | **Input:** Raw Code + `docs/system_style.md`. "Polish this." | **Refined Code** |
| **5** | [[05_auditor]] | **D** (Gemini Thinking) | [[security_hardening]] | **Input:** Refined Code + Contract. "Pass/Fail?" | **Audit Decision** |

> [!WARNING] Chain of Custody
> Do not modify the **Contract** after Step 2. If the Implementer discovers the Contract is impossible, you must halt and return to Step 2 (Architect) to revise the design.

---

## 🚑 Scenario 2: The Hotfix (Emergency Patch)
**Context:** Critical bug in production. Speed is the priority. We skip the Architect and Refiner unless absolutely necessary.

**Cost Profile:** ⭐ (Low - Mostly Free Models)

| Step | Agent | Account (Model) | Skill Injection | Action / Input | Output Artifact |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **1** | [[04_researcher]] | **B** (Gemini Pro) | N/A | **Input:** Error logs + Code. "Locate the root cause." | Root Cause Analysis |
| **2** | [[02_implementer]] | **E** (DeepSeek V3) | [[reflection_logic]] | **Input:** Existing Code + Bug Report. "Fix logic ONLY. Do not refactor." | **Patched Code** |
| **3** | [[05_auditor]] | **D** (Gemini Thinking) | [[security_hardening]] | **Input:** Patched Code. "Verify fix and check for regressions." | **Audit Decision** |

> [!TIP] Minimal Change Rule
> In Step 2, explicitly instruct the Implementer: *"Apply the fix with the minimum number of line changes. Do not reformat the rest of the file."*

---

## 🧹 Scenario 3: Refactoring & Cleanup
**Context:** The code works, but it's messy, lacks types, or has dead imports. No logic changes intended.

**Cost Profile:** ⭐ (Low - Free Models)

| Step | Agent | Account (Model) | Skill Injection | Action / Input | Output Artifact |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **1** | [[04_researcher]] | **B** (Gemini Pro) | N/A | **Optional:** "Identify circular imports or unused functions." | Cleanup List |
| **2** | [[03_refiner]] | **A** (Gemini Flash) | [[python_strict_typing]] | **Input:** Messy Code + `docs/system_style.md`. | **Clean Code** |
| **3** | [[05_auditor]] | **D** (Gemini Thinking) | N/A | **Input:** Clean Code. "Verify logic flow is IDENTICAL to original." | **Audit Decision** |

---

## 🕵️ Scenario 4: Deep Debugging (The Consultant)
**Context:** A complex architectural flaw, race condition, or performance bottleneck that simple patching won't fix. Requires high intelligence.

**Cost Profile:** ⭐⭐⭐⭐ (Very High - Extensive Premium Usage)

| Step | Agent | Account (Model) | Skill Injection | Action / Input | Output Artifact |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **1** | [[05_auditor]] | **D** (Gemini Thinking) | [[security_hardening]] | **Input:** Broken Code. "Run a deep diagnostic pass." | **Diagnostic Report** |
| **2** | [[01_architect]] | **C** (Claude Sonnet) | [[reflection_logic]] | **Input:** Diagnostic Report + Original Specs. "Redesign this module." | **Revised Contract** |
| **3** | [[02_implementer]] | **E** (DeepSeek V3) | N/A | **Input:** Revised Contract. "Rebuild module from scratch." | **New Code** |

> [!INFO] The "Consultant" Pattern
> This scenario treats the **Architect** as an expensive outside consultant. Use this only when you are stuck.

---

## 📚 Scenario 5: Documentation Updates
**Context:** The code is functional, but docstrings are missing or the README is outdated.

**Cost Profile:** ⭐ (Low - Free Models)

| Step | Agent | Account (Model) | Skill Injection | Action / Input | Output Artifact |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **1** | [[03_refiner]] | **A** (Gemini Flash) | N/A | **Input:** Code. "Add Google-style docstrings to all functions." | **Documented Code** |
| **2** | [[04_researcher]] | **B** (Gemini Pro) | N/A | **Input:** All Code Files. "Generate a `README.md` explaining usage." | **Documentation.md** |

---

## ⚡ Quick Select Decision Matrix

Use this table to quickly decide which battle plan to execute.

| Current Problem | **Select Scenario** | **Primary Account** | **Est. Token Cost** |
| :--- | :---: | :--- | :--- |
| "I need a new feature." | **Scenario 1** | C + E | High |
| "Production is broken!" | **Scenario 2** | E + D | Low |
| "This code is ugly." | **Scenario 3** | A | Low |
| "I don't know why this fails." | **Scenario 4** | D + C | Very High |
| "I need to explain this code." | **Scenario 5** | A + B | Low |

---

## 🛑 Common Pitfalls

1.  **Skipping the Architect in Scenario 1:** Result = "Spaghetti Code." The Implementer (DeepSeek) is fast but needs direction.
2.  **Using Account C (Claude) for Refinement:** Result = Wasted Money. Claude is too smart to just fix indentation. Use Gemini Flash (Account A).
3.  **Forgetting Skills:** The Agents are competent base models, but `[[security_hardening]]` and `[[python_strict_typing]]` are what make them production-grade. Always inject skills.