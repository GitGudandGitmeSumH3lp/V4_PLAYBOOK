---
tags:
  - reference
  - agents
  - roster
---

---

# V4.0 System Roster

## 1. The Core Agents (Reasoning)

| Agent File | Role | Best Model | Purpose |
| :--- | :--- | :--- | :--- |
| [[00_analyst]] | Product Owner | **Gemini 1.5 Pro** | Turns "Ideas" into "Specs". |
| [[01_architect]] | System Designer | **Claude Sonnet** | Turns "Specs" into "Contracts". |
| [[02_implementer]] | Logic Generator | **DeepSeek V3** | Turns "Contracts" into "Code". |
| [[03_refiner]] | Stylist | **Gemini Flash** | Formats and polishes code. |
| [[05_auditor]] | QA Judge | **Claude Sonnet** | Verifies Quality & Security. |
| [[04_researcher]] | Context Hunter | **Gemini 1.5 Pro** | Finds information. |

---

## 2. The Utilities (Infrastructure)
These prompts require **Compliance**. They perform administrative tasks, formatting, and file management.

| Utility File | Role | Best Model | Trigger When... |
| :--- | :--- | :--- | :--- |
| [[state_updater]] | Clerk | **Gemini Flash** | You finish a task and need to log it. |
| [[map_generator]] | Cartographer | **Gemini 1.5 Pro** | You create or update a Contract. |
| [[doc_scribe]] | Documenter | **Gemini Flash** | You have working code that needs comments. |
| [[code_merger]] | Patcher | **Claude Sonnet** | You need to insert a fix into a large file. |
| [[wisdom_miner]] | Historian | **Gemini Thinking** | You solved a hard bug and want to remember how. |

---

## 3. The Skills (Injectables)
Modular capabilities to paste into the Agent's prompt based on the situation.

| Skill File | Description | Usage |
| :--- | :--- | :--- |
| [[python_strict_typing]] | Enforces `List[str]`, `Optional[int]`, etc. | Inject into **Implementer** & **Refiner**. |
| [[security_hardening]] | Enforces OWASP standards (No SQLi, Secrets). | Inject into **Implementer** & **Auditor**. |
| [[reflection_logic]] | Forces "Draft -> Critique -> Output" loop. | Inject into **Implementer** for complex tasks. |