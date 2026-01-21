---
tags:
  - workflow
  - sop
  - how-to
  - battle-plans
---
---

# V4.0 Workflow Scenario Guide (Battle Plans)

---
## 🏗️ Scenario 1: Feature Development (The Full Assembly)
**Context:** Building a new module. Rigorous "Clean Room" process.
**Cost Profile:** ⭐⭐⭐ (High)

| Step | Agent | Account | Input | Output |
| :--- | :--- | :--- | :--- | :--- |
| **1** | [[00_analyst]] | **B** | Raw Idea + Constraints | **Feature Spec** |
| **2** | [[01_architect]] | **C** | Feature Spec | **The Contract** |
| **3** | [[02_implementer]] | **E** | Contract + Work Order | **Raw Code** |
| **4** | [[03_refiner]] | **A** | Raw Code + Style Guide | **Clean Code** |
| **5** | [[doc_scribe]] | **A** | Clean Code | **Documented Code** |
| **6** | [[05_auditor]] | **C** | Code + Contract | **Pass/Fail** |
| **7** | [[map_generator]] | **B** | All Contracts | **Updated API Maps** |
> [!WARNING] Context Drift
> Step 6 and 7 are critical. If you skip them, the next feature you build will be missing context about what you just finished.

---

## 🚑 Scenario 2: The Hotfix (Emergency Patch)
**Context:** Critical bug in production. Speed is priority.
**Cost Profile:** ⭐ (Low)

| Step | Tool | Account | Action / Input | Output |
| :--- | :--- | :--- | :--- | :--- |
| **1** | [[04_researcher]] | **B** | Logs + Code | Root Cause |
| **2** | [[02_implementer]] | **E** | Code + Fix Request | **Patched Code** |
| **3** | [[code_merger]] | **C** | Original File + Patch | **Merged File** |
| **4** | [[05_auditor]] | **D** | Merged File | **Pass/Fail** |

---

## 🧹 Scenario 3: Refactoring & Cleanup
**Context:** Code works but is messy.
**Cost Profile:** ⭐ (Low)

| Step | Tool | Account | Action / Input | Output |
| :--- | :--- | :--- | :--- | :--- |
| **1** | [[03_refiner]] | **A** | Messy Code | **Formatted Code** |
| **2** | [[doc_scribe]] | **A** | Formatted Code | **Docstrings Added** |
| **3** | [[state_updater]] | **A** | "Refactored module X" | **Updated _STATE.md** |

---

## 🕵️ Scenario 4: Deep Debugging & Learning
**Context:** Complex architectural flaw. We need to fix it AND learn from it.
**Cost Profile:** ⭐⭐⭐⭐ (Very High)

| Step | Tool | Account | Action / Input | Output |
| :--- | :--- | :--- | :--- | :--- |
| **1** | [[05_auditor]] | **C** | Broken Code | Diagnostic Report |
| **2** | [[01_architect]] | **C** | Report + Specs | **Redesigned Contract** |
| **3** | [[02_implementer]] | **E** | New Contract | **New Code** |
| **4** | [[wisdom_miner]] | **D** | Session Transcript | **Updated Memory** |

---

## ⚡ Quick Select Decision Matrix

| Current Problem | **Select Scenario** | **Primary Utils Used** |
| :--- | :---: | :--- |
| "I need a new feature." | **Scenario 1** | Scribe, Map Gen, State Updater |
| "Production is broken!" | **Scenario 2** | Code Merger |
| "This code is ugly." | **Scenario 3** | Scribe |
| "Why did we fail?" | **Scenario 4** | Wisdom Miner |