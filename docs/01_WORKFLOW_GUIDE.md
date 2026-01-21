---
tags: [workflow, sop, how-to]
---

# V4.0 Standard Operating Procedures

## Workflow 1: The "Clean Room" Feature Build
**Use case:** New features or complex logic changes.

### Phase 1: Architecture & Design
*   **Actor:** [[01_architect]]
*   **Model:** Account C (Claude Sonnet / o1)
*   **Input:** Feature Spec + `docs/system_constraints.md` + `docs/API_MAP_lite.md`
*   **Action:** Paste the Agent prompt. Ask it to "Generate Contract."
*   **Output:** `docs/contracts/[feature].md` and a Work Order.
*   **Verification:** Run the `/verify-context:` command provided by the agent.

### Phase 2: Implementation (Raw Logic)
*   **Actor:** [[02_implementer]]
*   **Model:** Account E (DeepSeek V3 / Qwen)
*   **Skill Injection:** [[reflection_logic]]
*   **Input:** Contract + Work Order + `docs/API_MAP_lite.md`.
*   **Action:** "Implement the attached contract. Do not add docstrings."
*   **Output:** Raw, working Python code.

> [!WARNING] Stop Point
> Perform the [[post_imp_audit]] **before** moving to the next step. If the code is broken or hallucinates imports, send it back to Phase 2.

### Phase 3: Refinement (Polish)
*   **Actor:** [[03_refiner]]
*   **Model:** Account A (Gemini Flash)
*   **Skill Injection:** [[python_strict_typing]]
*   **Input:** Raw Code + `docs/system_style.md` + Contract (for context).
*   **Action:** "Refine this code. Add docstrings and type hints."
*   **Output:** Production-ready code file.

### Phase 4: Audit (Quality Gate)
*   **Actor:** [[05_auditor]]
*   **Model:** Account A (Gemini Flash) -> Escalate to Account C if needed.
*   **Skill Injection:** [[security_hardening]]
*   **Input:** Refined Code + Contract + `HARD_CONSTRAINTS.md`.
*   **Action:** "Audit this code. Pass or Fail."
*   **Outcome:**
    *   **PASS:** Commit to repo.
    *   **FAIL:** Send critique back to Phase 2 (Implementer).

---

## Workflow 2: The Hotfix
**Use case:** Urgent bug fix on existing code.

1.  **Diagnose:** Use [[04_researcher]] (Account C) to find the root cause.
2.  **Fix:** Use [[02_implementer]] (Account E) with the existing code + bug report.
3.  **Audit:** Use [[05_auditor]] (Account C) for a strict security check.
    *   *Note: Refiner is often skipped in hotfixes to save time, unless the fix is large.*

---

## Troubleshooting Guide

### Issue: "The Agent is hallucinating libraries."
*   **Cause:** The `docs/API_MAP_lite.md` was not provided or is outdated.
*   **Fix:** Halt. Update the API Map. Restart Phase 2.

### Issue: "The code looks good but fails edge cases."
*   **Cause:** The Contract was too vague.
*   **Fix:** Go back to [[01_architect]]. Update the Contract to include specific "Test Cases" and "Error Handling" scenarios.

### Issue: "DeepSeek/Gemini is refusing to output code."
*   **Cause:** Triggered safety filters or context limit.
*   **Fix:** Break the Work Order into two smaller tasks (e.g., "Implement helper functions first").