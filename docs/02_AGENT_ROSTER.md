---
tags: [reference, agents]
---

# V4.0 Agent Roster

A quick reference guide for the Packet Prompting Agent Swarm.

| Agent File | Role | Persona | Best Model (Tier) | Skills to Inject |
| :--- | :--- | :--- | :--- | :--- |
| [[01_architect]] | **System Design** | Contract-First Designer | **Claude 3.5 Sonnet** (Premium) | N/A |
| [[02_implementer]] | **Coding** | Logic-Focused Generator | **DeepSeek V3 / Qwen** (High Vol) | [[reflection_logic]] |
| [[03_refiner]] | **Polish** | Stylist & Documenter | **Gemini 2.0 Flash** (Fast) | [[python_strict_typing]] |
| [[04_researcher]] | **Analysis** | Knowledge Advisor | **Claude 3.5 Sonnet** (Premium) | N/A |
| [[05_auditor]] | **QA** | Adversarial Reviewer | **Gemini Flash** (L1) / **Claude** (L2) | [[security_hardening]] |

---

## Agent Capabilities & Scopes

### [[01_architect]]
*   **Scope:** Interface design, data structures, integration mapping.
*   **Output:** Markdown Contracts (`docs/contracts/*.md`).
*   **Authority:** Highest. Defines the "Truth" of the system.

### [[02_implementer]]
*   **Scope:** Logic implementation, algorithm writing.
*   **Output:** Python Code (`src/*.py`).
*   **Constraint:** Cannot change method signatures defined by Architect.

### [[03_refiner]]
*   **Scope:** Docstrings, PEP-8 formatting, import sorting.
*   **Output:** Python Code (Polished).
*   **Constraint:** **NEVER** changes logic or control flow.

### [[04_researcher]]
*   **Scope:** Explaining concepts, finding files, architectural archaeology.
*   **Output:** Explanations and Citations.
*   **Constraint:** Read-only access. Does not generate code.

### [[05_auditor]]
*   **Scope:** Contract verification, security checks, style enforcement.
*   **Output:** Pass/Fail Decision + Score (0-100).
*   **Authority:** Can reject work from any other agent.