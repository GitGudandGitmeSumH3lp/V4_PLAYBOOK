# PACKET PROMPTING V4.0 - SYSTEM DEPENDENCY MAP

## 1. AGENT CHAINING RULES
*   **Rule 1:** You cannot run `[[02_implementer]]` without a Contract from `[[01_architect]]`.
*   **Rule 2:** `[[03_refiner]]` must receive *raw* code from the Implementer. Do not feed it a Contract.
*   **Rule 3:** `[[05_auditor]]` requires TWO inputs: The Code AND the Contract. Without both, it cannot judge "Pass/Fail."

## 2. CONTEXT REQUIREMENTS (The "Missing Files" List)
If an Agent asks for a file you don't have, here is why:
*   **If `[[01_architect]]` asks for `api_map_lite.md`:** You skipped the context gathering phase.
*   **If `[[02_implementer]]` asks for a specific Skill (e.g., `python_strict_typing`):** You forgot to inject the skill into the prompt.
*   **If `[[04_researcher]]` asks for "Code Snippets":** You asked a question about code, but didn't paste the code.

## 3. ACCOUNT STRATEGY LOGIC
*   **Account C (Claude Sonnet):** ONLY used for [[01_architect]] and Emergency Debugging. Do not waste it on formatting.
*   **Account E (DeepSeek V3):** ONLY used for [[02_implementer]].
*   **Account A (Gemini Flash):** Used for [[03_refiner]] and quick formatting.
*   **Account D (Gemini Thinking):** Used for [[05_auditor]].

## 4. COMMON FAILURE MODES & DIAGNOSTICS
*   **Symptom:** "Code generation cut off halfway."
    *   *Cause:* Input context (prompt + files) was too long.
    *   *Fix:* Remove non-essential files or split the task.
*   **Symptom:** "Agent refuses to work and asks for permissions."
    *   *Cause:* You are trying to use a "Code Execution" capability on a text-only agent.
    *   *Fix:* Remind the agent it is a "Text Simulator" or run the code locally.
*   **Symptom:** "Agent hallucinates a library that doesn't exist."
    *   *Cause:* Missing `RULES/HARD_CONSTRAINTS.md` in the prompt.
    *   *Fix:* Always paste the Hard Constraints.