# SYSTEM CONSTRAINTS (V4.0)

**Type:** Absolute Rules
**Enforcement:** NON-NEGOTIABLE
**Violation Consequences:** Automatic rejection by Auditor

---

## 1. LIBRARY CONSTRAINTS

### 🔴 FORBIDDEN LIBRARIES
**Rule:** These libraries are NEVER permitted in source code.
*   `os.system` (Security risk - use `subprocess` with list args)
*   `eval()` / `exec()` (Code injection risk)
*   `pickle` (Arbitrary code execution risk)
*   `__import__` (Dynamic import abuse)
*   `requests` (Unless explicitly authorized - prefer `httpx` for async future-proofing)

### 🟢 APPROVED STANDARDS
**Rule:** Prefer standard library first.
*   **Typing:** `typing`, `collections.abc`
*   **Time:** `datetime`, `time`, `zoneinfo`
*   **Data:** `json`, `csv`, `dataclasses`, `pydantic` (if external allowed)
*   **Files:** `pathlib` (NEVER use string concatenation for paths)
*   **Logging:** `logging` (NEVER use `print` in production code)

---

## 2. PATTERN CONSTRAINTS

### NO GLOBAL MUTABLE STATE
**Rule:** Global variables are forbidden except for uppercase CONSTANTS.
*   ❌ `counter = 0`
*   ✅ `MAX_RETRIES = 3`

### NO CIRCULAR IMPORTS
**Rule:** Dependencies must form a Directed Acyclic Graph (DAG).
*   If Module A needs Module B, and Module B needs Module A -> **Refactor** into Module C (Shared).

### NO WILDCARD IMPORTS
**Rule:** Explicit imports only.
*   ❌ `from module import *`
*   ✅ `from module import specific_function`

---

## 3. CODE STRUCTURE CONSTRAINTS

### SIZE LIMITS
*   **Max Function Length:** 50 lines (Target: 20-30). *Extract helper functions.*
*   **Max File Length:** 500 lines. *Split into sub-modules if exceeded.*
*   **Max Class Complexity:** 10 public methods. *Use composition over inheritance.*

### TYPE SAFETY (Strict)
*   **Mandatory:** All function signatures must have type hints.
*   **No Raw Collections:** ❌ `list`, `dict` -> ✅ `list[str]`, `dict[str, int]`.
*   **No Any:** Avoid `Any` unless absolutely necessary (must be commented).

---

## 4. DOCUMENTATION CONSTRAINTS

### MANDATORY DOCSTRINGS
**Rule:** Every public function and class must have a Google-style docstring.
*   Must describe **Args**, **Returns**, and **Raises**.
*   Private functions (`_helper`) may omit docs if logic is trivial.

---

## 5. SECURITY CONSTRAINTS

### NO HARDCODED SECRETS
**Rule:** Zero tolerance for credentials in code.
*   ❌ `API_KEY = "sk-..."`
*   ✅ `API_KEY = os.environ.get("API_KEY")`

### INPUT VALIDATION
**Rule:** All external inputs (API args, user input, file reads) must be validated immediately.
*   Fail fast. Raise `ValueError` or `TypeError` with clear messages.

### SQL INJECTION
**Rule:** No string formatting in SQL queries.
*   ❌ `f"SELECT * FROM users WHERE name='{name}'"`
*   ✅ `cursor.execute("SELECT * FROM users WHERE name=?", (name,))`

---

## 6. VERSION CONTROL CONSTRAINTS

### COMMIT MESSAGES
**Rule:** Follow Conventional Commits.
*   `feat(auth): add login logic`
*   `fix(api): handle timeout error`
*   `docs(readme): update setup guide`
*   `refactor(db): split connection logic`

### BRANCHING
*   No direct commits to `main`.
*   All features require a dedicated branch.
* 

## 🖥️ WORK ENVIRONMENT (Windows)
**Project Root:** `F:\PORTFOLIO\ps_rcs_project`

### 📋 OUTPUT FORMATTING RULES
1.  **File References:** When listing target files, created artifacts, or work orders in Markdown, you MUST use the **Windows Absolute Path**.
    *   ❌ `docs/contracts/auth.md`
    *   ✅ `F:\PORTFOLIO\ps_rcs_project\docs\contracts\auth.md`
2.  **Code Paths:** Inside Python/JS code, continue using relative paths or `pathlib` to ensure cross-platform compatibility.
    *   ✅ `Path("docs") / "contracts"`