---
tags: [packet-prompting, v4, master-guide, system-architecture]
created: 2026-01-22
status: Active
version: 4.0
---

---

# Packet Prompting V4.0: Master Playbook

## 1. System Philosophy
**From Monolith to Swarm.**
V4.0 shifts from linear, long-context conversations to a **Contract-First, Multi-Agent Swarm** architecture supported by specialized **Utilities**.

**Core Principles:**
1.  **Specialization:** Agents (Reasoning) vs. Utilities (Infrastructure).
2.  **Cost Optimization:** Use premium models (Account C) only for Architecture/Auditing. Use fast models (Account A) for Scribing and State updates.
3.  **Contract Law:** No implementation begins without a strict Interface Contract.
4.  **Context Hygiene:** Utilities run automatically to keep maps and state files fresh.

---

## 2. Quick Start Strategy
To start a new feature immediately:

1.  **Run Pre-Flight:** Execute [[pre_session_check]].
2. ** Define (Account B):** Run [[00_analyst]] with your raw idea. Get a **Spec**.
3.  **Design (Account C):** Run [[01_architect]]. Get a **Contract**.
4.  **Build (Account E):** Run [[02_implementer]]. Get **Raw Code**.
5.  **Refine (Account A):** Run [[03_refiner]] + [[doc_scribe]]. Get **Polished Code**.
6.  **Verify (Account C):** Run [[05_auditor]]. Get **Pass**.
7.  **Cleanup (Account A/B):** Run [[state_updater]] and [[map_generator]].

---

## 3. The Architecture

### The Agents (The "Who")
The reasoning workforce. See [[02_AGENT_ROSTER]] for details.
*   **The Brain:** [[01_architect]]
*   **The Hands:** [[02_implementer]]
*   **The Stylist:** [[03_refiner]]
*   **The Judge:** [[05_auditor]]
*   **The Librarian:** [[04_researcher]]

### The Utilities (The Infrastructure)
Automated tools that maintain the system state.
*   [[state_updater]]: Updates `_STATE.md`.
*   [[map_generator]]: Updates `API_MAP.md`.
*   [[wisdom_miner]]: Updates `project_memory.md`.
*   [[code_merger]]: Safely patches existing files.
*   [[doc_scribe]]: Adds documentation (non-intrusive).

### The Skills (The "How")
Modular prompt injections.
*   [[python_strict_typing]]
*   [[security_hardening]]
*   [[reflection_logic]]

---

## 4. Account Strategy & Model Allocation

| Account ID | Model Family | Role | Assigned Tools |
| :--- | :--- | :--- | :--- |
| **Account C** | **Claude 3.5 Sonnet / o1** | **High Intelligence** | [[01_architect]], [[05_auditor]], [[code_merger]] |
| **Account E** | **DeepSeek V3 / Qwen 2.5** | **High Volume Logic** | [[02_implementer]] |
| **Account A** | **Gemini 2.0 Flash** | **Fast Context/Admin** | [[03_refiner]], [[doc_scribe]], [[state_updater]] |
| **Account B** | **Gemini 1.5 Pro** | **Large Context** | [[04_researcher]], [[map_generator]] |

> [!TIP] Cost Saving Strategy
> Never use **Account C** for `[[doc_scribe]]` or `[[state_updater]]`. It is a waste of "intelligence tokens." Use **Account A** for these infrastructure tasks.