---
tags: [scenario, legacy, onboarding, brownfield, v4]
purpose: "Strategic Digestion of Legacy Codebases"
estimated_time: "Days to Weeks (Iterative)"
accounts_required: [A, B, C]
---

# SCENARIO: LEGACY SYSTEM ONBOARDING (EATING THE ELEPHANT)

## 1. Introduction
**Do not try to onboard the entire project in one prompt.** You will run out of tokens, get hallucinated results, and waste money.

This scenario breaks a massive legacy codebase (Brownfield) into digestible chunks. The goal is to create a "Shadow Mirror" of the codebase in your `docs/contracts/` folder, allowing V4.0 agents to work on the code without needing to read 10,000 lines of spaghetti every time.

---

## 2. The Onboarding Workflow

### Phase 1: The Commander (Strategy & Filtering)
**Goal:** Analyze the directory structure and create a "Hit List."
**Agent:** [[00_orchestrator]]
**Account:** **B** (Gemini 1.5 Pro)

1.  **Generate a Tree:** Run `tree -L 3` or `ls -R` in your terminal.
2.  **Prompt:** Paste the tree output into the Orchestrator.
    *   *Command:* "Analyze this directory structure. Identify the Entry Points (High Priority), Core Logic (Medium), and Noise (Low - tests, assets, venv). Output a prioritized processing order."
3.  **Output:** A checklist of files to process.
    *   *Example:* `[ ] src/main.py`, `[ ] src/auth/login.py`, etc.

### Phase 2: The Top-Down Scan (Discovery)
**Goal:** Identify interfaces and dependencies without reading line-by-line logic.
**Utility:** `UTILS/legacy_integration/01_discovery.md`
**Account:** **A** (Gemini Flash)

1.  **Action:** Select a batch of 3-5 related files from your Hit List.
2.  **Prompt:** Paste the utility prompt + the file contents.
3.  **Result:** A JSON-like summary of classes, methods, and imports.
    *   *Value:* Very cheap. Use this for 80% of your files.

### Phase 3: Selective Surgery (Forensics)
**Goal:** Deep dive into complex, "Spaghetti" code to understand hidden side effects.
**Utility:** `UTILS/legacy_integration/02_forensics.md`
**Account:** **C** (Claude Sonnet)

1.  **Strategy:** **Only run this on complex files.**
    *   *Criteria:* File > 200 lines? Global variables? No type hints? Logic hard to follow?
2.  **Action:** Run Forensics on these specific "Problem Files."
3.  **Result:** A detailed "Technical Debt Report" and logic flow map.

> [!TIP] Cost Savings
> Skip Phase 3 for simple files (DTOs, config files, simple helpers). Discovery (Phase 2) gives enough info for those.

### Phase 4: The Contract Factory (Generation)
**Goal:** Create the V4.0 Documentation.
**Utility:** `UTILS/legacy_integration/03_contract_gen.md`
**Account:** **A** (Gemini Flash)

1.  **Input:**
    *   The output from Phase 2 (Discovery).
    *   The output from Phase 3 (Forensics) *if applicable*.
    *   The raw code (optional, if context window permits).
2.  **Action:** "Generate the Legacy Contract."
3.  **Output:** `docs/contracts/legacy_[module_name].md`.
    *   *Note:* These contracts define "What Is," not "What Should Be."

### Phase 5: The Registry (Map Generation)
**Goal:** Make the rest of the system aware of these new modules.
**Utility:** [[map_generator]]
**Account:** **B** (Gemini 1.5 Pro)

1.  **Input:** Your newly created `docs/contracts/*.md` files.
2.  **Action:** "Update the API Map."
3.  **Output:** An updated `CONTEXT/api_map_lite.md` that includes your legacy modules.

---

## 3. Tactical Tips (The "How-To")

### 🚫 What to Ignore
Tell the Orchestrator to ignore these folders immediately:
*   `tests/`: The [[02_implementer]] will write new tests based on contracts. Old tests are often flaky.
*   `migrations/`: Database history is rarely needed for active coding.
*   `venv/`, `node_modules/`: Never context dump dependencies.
*   `backup/`, `archive/`: Dead code confuses the Architect.

### 🔄 The "Tracer Bullet" Approach
Don't onboard 100 files at once.
1.  Onboard **3 core files** (e.g., `main.py`, `database.py`, `user_model.py`).
2.  Run Phase 5 (Update Map).
3.  **Test the System:** Ask the [[00_analyst]] to "Add a field to the User model."
4.  If the Agents successfully plan the change using your new Contracts, **proceed**. If they get confused, refine the contracts.

### ⚠️ Handling "God Objects"
If you find a 2,000-line `utils.py`:
1.  Run **Phase 3 (Forensics)**.
2.  Do not try to fix it yet.
3.  Generate a "Warning Contract" that lists all the dangerous globals.
4.  Add a "Refactor" task to your `_STATE.md`.

---

## 4. Completion Criteria

You are done with Onboarding when:
1.  [ ] All "High Priority" and "Medium Priority" files have a corresponding `contracts/legacy_*.md`.
2.  [ ] `CONTEXT/api_map_lite.md` reflects the structure of the legacy project.
3.  [ ] You can ask [[03_implementer]] to modify a legacy function without pasting the source code, and it knows the signature.