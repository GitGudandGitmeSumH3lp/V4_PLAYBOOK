---
tags: [packet-prompting, v4, master-guide, system-architecture]
created: 2026-01-22
status: Active
version: 4.0
---

# Packet Prompting V4.0: Master Playbook

## 1. System Philosophy
**From Monolith to Swarm.**
Previous versions (V3.x) relied on linear, long-context conversations with a single model. **V4.0** shifts to a **Contract-First, Multi-Agent Swarm** architecture.

**Core Principles:**
1.  **Specialization:** Different models for different tasks (Reasoning vs. Coding vs. Polish).
2.  **Cost Optimization:** Use premium models (Claude Sonnet) *only* for Architecture and final Auditing. Use high-volume/free models (DeepSeek, Gemini Flash) for Implementation and Refinement.
3.  **Contract Law:** No implementation begins without a strict Interface Contract defined by the Architect.
4.  **Adversarial Quality:** The [[05_auditor]] is an enemy of the [[02_implementer]]. Approval is earned, not assumed.

---

## 2. Quick Start Strategy
To start a new feature immediately:

1.  **Run the Pre-Flight:** Execute the checklist in [[pre_session_check]].
2.  **Design (Account C):** Paste `AGENTS/01_architect.md` + your specs. Get a **Contract**.
3.  **Build (Account E):** Paste `AGENTS/02_implementer.md` + the Contract. Get **Raw Code**.
4.  **Verify (Account A/C):** Paste `AGENTS/05_auditor.md` + Contract + Code. Get **Pass/Fail**.

---

## 3. The Architecture

### The Agents (The "Who")
The workforce is divided into specialized roles. See [[02_AGENT_ROSTER]] for details.
*   **The Brain:** [[01_architect]] (Defines *what* to build).
*   **The Hands:** [[02_implementer]] (Writes the logic).
*   **The Stylist:** [[03_refiner]] (Fixes formatting and docs).
*   **The Judge:** [[05_auditor]] (Pass/Fail authority).
*   **The Librarian:** [[04_researcher]] (Explains context).

### The Skills (The "How")
Modular prompt injections that add specific capabilities to agents.
*   [[python_strict_typing]]: Enforces type hints.
*   [[security_hardening]]: Enforces OWASP standards.
*   [[reflection_logic]]: Forces agents to "think twice" before outputting.

### The Governance (The Rules)
*   [[HARD_CONSTRAINTS]]: Non-negotiable system laws (Forbidden libraries, file limits).
*   [[pre_session_check]]: Checklist before starting.
*   [[post_imp_audit]]: Checklist before auditing.

---

## 4. Account Strategy & Model Allocation
V4.0 is designed to save costs while increasing quality by leveraging specific model strengths.

| Account ID | Model Family | Role | Assigned Agents |
| :--- | :--- | :--- | :--- |
| **Account C** | **Claude 3.5 Sonnet / o1** | **High Intelligence** | [[01_architect]], [[04_researcher]], [[05_auditor]] (Escalation) |
| **Account E** | **DeepSeek V3 / Qwen 2.5** | **High Volume Logic** | [[02_implementer]] |
| **Account A** | **Gemini 2.0 Flash** | **Fast Context/Refine** | [[03_refiner]], [[05_auditor]] (First Pass) |

> [!TIP] Cost Saving Strategy
> Never use **Account C** for generating docstrings or formatting code. That is a waste of "intelligence tokens." Use **Account A** ([[03_refiner]]) for all polish tasks.