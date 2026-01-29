# PLAYBOOK: LEGACY MODERNIZATION (V4.0)

**Strategy:** "The Strangler Fig Pattern"
**Core Philosophy:** Do not rewrite. Wrap, then replace.
**Source:** Adapted from "AI-Assisted Legacy Code Modernization (2025)"

---

##  PHASE 1: CODE ARCHAEOLOGY (The Dig)
**Goal:** Map the "Blast Radius." Understand what breaks if we touch `X`.
**Agent:** [[04_researcher]] (Gemini 1.5 Pro - High Context)
**Input:** The entire legacy file (e.g., `old_motor_controller.py`).

**Prompt Protocol:**
> "Analyze this legacy code. Do not rewrite it.
> 1. List every **External Dependency** (libraries, globals, other files).
> 2. List every **Public Method** and its expected inputs/outputs.
> 3. Identify **'Magic Numbers'** or hardcoded business logic.
> 4. Create a **Dependency Graph** text description."

**Output Artifact:** `docs/legacy_maps/[module]_map.md`

---

## PHASE 2: THE INTERVIEW (Contract Extraction)
**Goal:** Create a contract based on *current behavior*, not *ideal behavior*.
**Agent:** [[01_architect]] (GLM 4.5 or Claude Sonnet)
**Input:** The `legacy_map.md` from Phase 1 + `system_constraints.md`.

**Prompt Protocol:**
> "I need to replace this legacy module.
> 1. Create an **Interface Contract** (`InterfaceClass`) that mirrors the *exact* public methods of the legacy code.
> 2. Define a **Wrapper/Adapter Class** that implements this interface but calls the old code internally.
> 3. Ensure the new interface enforces our `system_constraints.md` (e.g., adding Type Hints where missing)."

**Output Artifact:** `docs/contracts/[module]_contract.md`

---

## PHASE 3: THE QUARANTINE (The Adapter)
**Goal:** Stop the bleeding. Isolate the legacy code behind a clean API.
**Agent:** [[02_implementer]] (DeepSeek V3)
**Input:** The Contract + The Legacy File.

**Prompt Protocol:**
> "Write the **Adapter Class** defined in the contract.
> - Import the legacy module as `_legacy`.
> - Route all calls from the clean Interface to `_legacy`.
> - **CRITICAL:** Add logging to every call so we can see what the legacy code is actually doing in production."

**Action:** Update `main.py` to use the **Adapter**, not the legacy file directly.

---

## PHASE 4: THE SWAP (Transformation)
**Goal:** Rewrite the logic inside the Adapter, piece by piece.
**Trigger:** Once the Adapter is working and we have logs.
**Agent:** [[02_implementer]] (DeepSeek V3)

**Prompt Protocol:**
> "Refactor the `forward()` method in the Adapter.
> - Replace the `_legacy.forward()` call with new, clean logic using `HardwareManager`.
> - Keep the method signature exactly the same.
> - Remove the dependency on `_legacy` for this specific method."

---

## 🚦 "SMART JUICE" RULES (Context Hygiene)
*   **Don't Paste the Monolith:** When rewriting a specific function in Phase 4, do **NOT** paste the entire legacy file. Paste only the **Contract** and the **one specific function** from the legacy map.
*   **Test First:** Before Phase 4, ask [[05_auditor]] to "Write a Unit Test that passes against the Legacy Adapter." Use this test to verify the new code.