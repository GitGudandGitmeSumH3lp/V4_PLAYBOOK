# PLAYBOOK: LEGACY CODEBASE MODERNIZATION (V4.0)

**Playbook Type:** Brownfield Project Workflow  
**Integration:** Packet Prompting V4.0 Agent System  
**Strategy:** Strangler Pattern + Contract-First Refactoring  
**Context Philosophy:** "Smart Juice" Conservation via Chunked Analysis

---

## TABLE OF CONTENTS

1. [Overview](https://claude.ai/chat/a50aed89-2c7e-4b28-8eb7-3ca3d29a3b4b#1-overview)
2. [Pre-Flight Checklist](https://claude.ai/chat/a50aed89-2c7e-4b28-8eb7-3ca3d29a3b4b#2-pre-flight-checklist)
3. [Phase 1: Reconnaissance](https://claude.ai/chat/a50aed89-2c7e-4b28-8eb7-3ca3d29a3b4b#3-phase-1-reconnaissance)
4. [Phase 2: Dependency Mapping](https://claude.ai/chat/a50aed89-2c7e-4b28-8eb7-3ca3d29a3b4b#4-phase-2-dependency-mapping)
5. [Phase 3: Contract Extraction](https://claude.ai/chat/a50aed89-2c7e-4b28-8eb7-3ca3d29a3b4b#5-phase-3-contract-extraction)
6. [Phase 4: Strangler Adapter Creation](https://claude.ai/chat/a50aed89-2c7e-4b28-8eb7-3ca3d29a3b4b#6-phase-4-strangler-adapter-creation)
7. [Phase 5: Incremental Replacement](https://claude.ai/chat/a50aed89-2c7e-4b28-8eb7-3ca3d29a3b4b#7-phase-5-incremental-replacement)
8. [Phase 6: Validation & Cutover](https://claude.ai/chat/a50aed89-2c7e-4b28-8eb7-3ca3d29a3b4b#8-phase-6-validation--cutover)
9. [Drag-and-Drop Prompts](https://claude.ai/chat/a50aed89-2c7e-4b28-8eb7-3ca3d29a3b4b#9-drag-and-drop-prompts)
10. [Emergency Rollback Procedures](https://claude.ai/chat/a50aed89-2c7e-4b28-8eb7-3ca3d29a3b4b#10-emergency-rollback-procedures)

---

# 1. OVERVIEW

## The Legacy Challenge

**Problem:** You have a working-but-messy codebase. Pasting 5,000 lines into the Implementer violates context hygiene and produces hallucinations.

**Solution:** Use the **Researcher** agent to create a high-level map, then modernize incrementally using the **Strangler Pattern**.

## The Strangler Pattern

```
OLD SYSTEM (Legacy)
      ↓
   ADAPTER LAYER ← New code calls through here
      ↓
NEW SYSTEM (Modern)
```

**Phases:**

1. **Wrap:** Create adapters that call legacy code
2. **Test:** Validate adapters match legacy behavior
3. **Replace:** Swap legacy implementation with modern version
4. **Remove:** Delete old code after cutover

## Key Principles

✅ **Never refactor and change behavior simultaneously**  
✅ **Never paste massive files into Implementer** (use Researcher first)  
✅ **Always write contracts before touching legacy code**  
✅ **Test adapters before replacing internals**  
✅ **Keep legacy system running until new system proven**

---

# 2. PRE-FLIGHT CHECKLIST

Run this checklist BEFORE starting legacy modernization.

```
═══════════════════════════════════════════════════════════
LEGACY PROJECT ASSESSMENT
═══════════════════════════════════════════════════════════

[ ] Do I have access to the full legacy codebase?
    Location: _____________________________________________
    Total files: __________
    Total lines: __________

[ ] Is the legacy system currently running in production?
    Yes / No
    If yes, do I have a rollback plan? Yes / No

[ ] Do I have test coverage for the legacy system?
    Coverage: _____% 
    If <50%, STOP and write integration tests first.

[ ] Can I run the legacy system locally?
    Yes / No
    If no, set up local environment first.

[ ] Do I have documentation for the legacy system?
    [ ] API documentation
    [ ] Database schema
    [ ] Configuration files
    [ ] Deployment procedures
    If none, proceed to Reconnaissance phase.

═══════════════════════════════════════════════════════════
SCOPE DEFINITION
═══════════════════════════════════════════════════════════

[ ] What is the modernization goal?
    [ ] Add type hints and documentation
    [ ] Refactor for testability
    [ ] Port to new framework
    [ ] Extract microservices
    [ ] Security hardening
    [ ] Performance optimization
    [ ] Other: _______________________________________

[ ] What is the priority order?
    1. _______________________________________________
    2. _______________________________________________
    3. _______________________________________________

[ ] What is the time constraint?
    Deadline: _____________
    Available hours: _______

[ ] What is the risk tolerance?
    [ ] High (can tolerate downtime)
    [ ] Medium (minimal downtime acceptable)
    [ ] Low (zero downtime required)

═══════════════════════════════════════════════════════════
RESOURCE PREPARATION
═══════════════════════════════════════════════════════════

[ ] Have I created the project workspace?
    [ ] docs/legacy/ (for analysis artifacts)
    [ ] docs/contracts/ (for extracted contracts)
    [ ] src/adapters/ (for strangler adapters)
    [ ] tests/legacy_compat/ (for compatibility tests)

[ ] Have I prepared the required V4.0 files?
    [ ] docs/system_constraints.md
    [ ] docs/API_MAP_lite.md (will be built during recon)
    [ ] _memory_snippet.txt (will be populated during work)
    [ ] specs/ (for new feature specs)

[ ] Which accounts will I use?
    [ ] Account C (Claude Sonnet 4) - Researcher, Architect
    [ ] Account D (DeepSeek V3) - Implementer
    [ ] Account G (Gemini Flash) - Refiner, Auditor (first pass)

═══════════════════════════════════════════════════════════
GO/NO-GO DECISION
═══════════════════════════════════════════════════════════

✅ GO - Proceed to Phase 1 (Reconnaissance)
   All checks passed. Ready to analyze legacy codebase.

⚠️ CONDITIONAL GO - Proceed with caution
   [ ] Missing documentation (will create during recon)
   [ ] Low test coverage (will add tests during modernization)
   [ ] Unclear scope (will refine during analysis)

❌ NO-GO - Do not proceed yet
   [ ] Cannot run legacy system locally
   [ ] No rollback plan for production system
   [ ] No access to full codebase
   [ ] Deadline too aggressive for safe refactoring

═══════════════════════════════════════════════════════════
```

**NEXT STEP:** If ✅ GO → Proceed to Phase 1

---

# 3. PHASE 1: RECONNAISSANCE

**Goal:** Create a high-level map of the legacy codebase WITHOUT loading entire files into context.

**Agent:** Researcher (Account C - Claude Sonnet 4)  
**Output:** `docs/legacy/SYSTEM_MAP.md`

## Step 1.1: File Structure Analysis

**Drag-and-Drop Prompt:**

```
# ROLE: RESEARCHER (V4.0)

# TASK: Legacy System Reconnaissance

You are analyzing a legacy codebase to create a high-level map. DO NOT read full file contents yet. Focus on structure first.

## REQUIRED CONTEXT
/verify-context: [legacy_project_root]

## INSTRUCTIONS

1. List all Python files in the project (use `find . -name "*.py"`)
2. For each file, extract ONLY:
   - File path
   - File size (lines)
   - Top-level classes (class names only)
   - Top-level functions (function names only)
   - Import statements (what external dependencies exist)

3. Create a visual tree structure showing:
   - Directory hierarchy
   - Module relationships (based on imports)
   - Approximate complexity (lines of code)

4. Identify potential "entry points":
   - Main scripts (if __name__ == "__main__")
   - API route handlers
   - CLI commands

## OUTPUT FORMAT

Create `docs/legacy/SYSTEM_MAP.md` with:

### Section 1: File Inventory


Total Files: N Total Lines: ~M Entry Points: [list]


### Section 2: Module Tree

project/ ├── module_a/ │ ├── file1.py (120 lines, 3 classes, 5 functions) │ └── file2.py (80 lines, 1 class, 8 functions) ├── module_b/ │ └── file3.py (200 lines, 2 classes, 12 functions)


### Section 3: Dependency Graph (Import Analysis)


file1.py imports: [module_b.file3, external_lib_x] file2.py imports: [module_a.file1, external_lib_y] file3.py imports: [external_lib_z]


### Section 4: Complexity Hotspots


Files > 300 lines:

- file_x.py (450 lines) ← HIGH PRIORITY for refactoring
- file_y.py (380 lines)

Files with >10 functions:

- file_z.py (15 functions) ← Likely doing too much



### Section 5: External Dependencies


third_party_libs = [lib1, lib2, lib3] stdlib_modules = [os, sys, json, ...]



## CONSTRAINTS
- Do NOT read full file contents (wastes context)
- Do NOT analyze logic yet (next phase)
- Focus on STRUCTURE and RELATIONSHIPS
```

## Step 1.2: Identify Critical Paths

**Drag-and-Drop Prompt:**

```
# ROLE: RESEARCHER (V4.0)

# TASK: Identify Critical Execution Paths

Using the SYSTEM_MAP.md you just created, identify the most important code paths.

## REQUIRED CONTEXT
/verify-context: docs/legacy/SYSTEM_MAP.md

## INSTRUCTIONS

1. Trace execution from entry points to external I/O:
   - What happens when the main script runs?
   - What are the key API endpoints and their handlers?
   - What database operations occur?

2. Identify "God Objects" or "God Functions":
   - Files with excessive responsibilities
   - Functions with >50 lines
   - Classes with >10 methods

3. Flag anti-patterns:
   - Global mutable state
   - Circular imports
   - Tight coupling (file A imports B, B imports A indirectly)

## OUTPUT FORMAT

Append to `docs/legacy/SYSTEM_MAP.md`:

### Section 6: Critical Execution Paths

**Path 1: User Authentication**


main.py:handle_login() → auth/validator.py:validate_credentials() → db/users.py:fetch_user() → auth/session.py:create_session()

 

**Path 2: Data Processing Pipeline**
 

[trace the flow]

 

### Section 7: Refactoring Priorities

**HIGH PRIORITY (God Objects):**
1. `module_x/file_y.py` - 450 lines, 15 methods, does auth + DB + email
2. `utils/helpers.py` - 380 lines, 20 unrelated utility functions

**MEDIUM PRIORITY (Coupling Issues):**
1. Circular import: `module_a` ↔ `module_b`
2. Global state: `config.py` has mutable globals used by 12 files

**LOW PRIORITY (Just Messy):**
1. Missing docstrings (all files)
2. No type hints (all files)
3. Inconsistent naming (mix of camelCase and snake_case)
```

## Expected Output

After Phase 1, you should have:

✅ `docs/legacy/SYSTEM_MAP.md` - Complete structural map  
✅ List of critical execution paths  
✅ Prioritized refactoring targets  
✅ Dependency graph

**DO NOT PROCEED TO PHASE 2** until this map is complete and reviewed.

---

# 4. PHASE 2: DEPENDENCY MAPPING

**Goal:** Build `API_MAP_lite.md` for the legacy system by analyzing actual usage patterns.

**Agent:** Researcher (Account C - Claude Sonnet 4)  
**Output:** `docs/legacy/API_MAP_legacy.md`

## Step 2.1: Extract Public Interfaces

**Drag-and-Drop Prompt:**

```
# ROLE: RESEARCHER (V4.0)

# TASK: Extract Public Interfaces from Legacy Code

Using SYSTEM_MAP.md, you will now analyze ACTUAL function signatures.

## REQUIRED CONTEXT
/verify-context: docs/legacy/SYSTEM_MAP.md, [legacy_codebase_root]

## INSTRUCTIONS

For each module identified in SYSTEM_MAP.md:

1. Extract public function signatures:
   - Function name
   - Parameters (names only, ignore types for now)
   - Return behavior (what it returns, if obvious)
   - Side effects (DB writes, file I/O, API calls)

2. DO THIS IN CHUNKS (3-5 files at a time):
   - Read file 1
   - Extract signatures
   - Read file 2
   - Extract signatures
   - [repeat]
   - Output batch results
   - Clear context (do NOT accumulate)

3. For each function, note:
   - Is it called by other modules? (check imports)
   - Does it have obvious bugs or anti-patterns?

## OUTPUT FORMAT

Create `docs/legacy/API_MAP_legacy.md`:

### Module: auth.validator

**Function: `validate_credentials(username, password)`**
- **Parameters:** `username` (str?), `password` (str?)
- **Returns:** `True/False` (bool?)
- **Side Effects:** Queries database (`db.users.fetch_user`)
- **Called By:** `main.py`, `api/login.py`
- **Issues:** 
  - No input validation (potential SQL injection?)
  - Plaintext password comparison (CRITICAL SECURITY ISSUE)

**Function: `check_permissions(user_id, resource)`**
- **Parameters:** `user_id` (int?), `resource` (str?)
- **Returns:** `True/False`
- **Side Effects:** Queries database
- **Called By:** `api/handlers.py` (12 different endpoints)
- **Issues:** None obvious

[Repeat for all public functions]

## CRITICAL RULE
Process files in batches. After every 5 files, output results and ask:
"Ready for next batch? Files 6-10?"

This prevents context overflow.
```

## Step 2.2: Identify Hidden Contracts

**Drag-and-Drop Prompt:**

```
# ROLE: RESEARCHER (V4.0)

# TASK: Identify Implicit Contracts and Assumptions

Legacy code has IMPLICIT contracts that aren't written down. Find them.

## REQUIRED CONTEXT
/verify-context: docs/legacy/API_MAP_legacy.md, docs/legacy/SYSTEM_MAP.md

## INSTRUCTIONS

1. Look for patterns in the legacy code:
   - **Validation Assumptions:** "This function assumes `user_id` is always positive"
   - **State Assumptions:** "This must be called after `initialize_session()`"
   - **Format Assumptions:** "Expects ISO 8601 timestamps as strings"

2. Check for error handling patterns:
   - What exceptions are raised?
   - What error codes are returned?
   - Are errors logged?

3. Identify data flow contracts:
   - What format does `fetch_user()` return?
   - Is it a dict? A custom object? A tuple?

## OUTPUT FORMAT

Append to `docs/legacy/API_MAP_legacy.md`:

### Section: Implicit Contracts

**Contract: User ID Format**
- **Observed Pattern:** All functions expect `user_id` to be a positive integer
- **Violation Handling:** No validation; will crash if given string or negative
- **Evidence:** Lines 45, 67, 89 in `auth/validator.py`

**Contract: Session State Dependency**
- **Observed Pattern:** `get_current_user()` must be called after `create_session()`
- **Violation Handling:** Returns `None` if no session exists (not documented)
- **Evidence:** `auth/session.py:25-40`

**Contract: Database Return Format**
- **Observed Pattern:** `fetch_user()` returns `dict` with keys: `id`, `username`, `email`
- **Violation Handling:** No error if user not found; returns `None`
- **Evidence:** `db/users.py:15-20`
```

## Expected Output

After Phase 2, you should have:

✅ `docs/legacy/API_MAP_legacy.md` - Complete interface documentation  
✅ List of implicit contracts and assumptions  
✅ Known bugs and security issues flagged

**CRITICAL:** If you discover security issues (SQL injection, hardcoded secrets, etc.), FLAG IMMEDIATELY and consider pausing refactoring to fix.

---

# 5. PHASE 3: CONTRACT EXTRACTION

**Goal:** Convert legacy implicit contracts into formal V4.0 contracts.

**Agent:** Architect (Account C - Claude Sonnet 4)  
**Output:** `docs/contracts/legacy_*.md` (one per module)

## Step 3.1: Formalize Interfaces

**Drag-and-Drop Prompt:**

````
# ROLE: ARCHITECT (V4.0)

# TASK: Extract Formal Contracts from Legacy Code

You will transform the informal API_MAP_legacy.md into formal V4.0 contracts.

## REQUIRED CONTEXT
/verify-context: docs/legacy/API_MAP_legacy.md, docs/system_constraints.md, docs/API_MAP_lite.md

## INSTRUCTIONS

For each module in API_MAP_legacy.md:

1. Create a CONTRACT file following the standard V4.0 template
2. Formalize signatures with type hints:
   - Infer types from usage patterns
   - Use `Any` if truly unknown
   - Add `Optional` for nullable values
3. Document implicit contracts as explicit behavior specs
4. Define error handling based on observed patterns
5. Add acceptance criteria based on actual usage

## CRITICAL RULES

**DO NOT change behavior.** If legacy code:
- Accepts `None` → Contract must allow `Optional`
- Returns `None` on error → Contract must specify this
- Has no validation → Contract must note "No validation (legacy behavior)"

**DO flag issues** in a separate "Legacy Issues" section.

## OUTPUT FORMAT

For each module, create `docs/contracts/legacy_[module_name].md`:

# CONTRACT: Legacy Auth Validator (Extracted)
**Version:** 1.0 (Legacy Compatibility)
**Last Updated:** [Date]
**Status:** Extracted (Not Yet Modernized)

## 1. PURPOSE
[What this module does - copied from legacy behavior]

## 2. PUBLIC INTERFACE

### Method: `validate_credentials`
**Signature:**
```python
def validate_credentials(
    username: str | None,  # Legacy accepts None (bug)
    password: str | None   # Legacy accepts None (bug)
) -> bool:
    """Validate user credentials against database.
    
    LEGACY BEHAVIOR: No input validation. Crashes if username is not str.
    LEGACY BEHAVIOR: Compares passwords in plaintext (SECURITY ISSUE).
    """
````

**Behavior Specification:**

- **Input Validation:** NONE (legacy bug - accepts any type)
- **Processing Logic:**
    1. Query database for user by username (SQL concatenation - INJECTION RISK)
    2. Compare password strings directly (plaintext)
    3. Return `True` if match, `False` otherwise
- **Output Guarantee:** Boolean (True = valid, False = invalid)
- **Side Effects:**
    - Database query (SELECT * FROM users WHERE username='[input]')
    - No logging

**Error Handling:**

- **Database Error:** Crashes (no try/except)
- **Invalid Input:** Crashes with TypeError if username not str
- **User Not Found:** Returns `False` (treats as invalid credentials)

**Performance Requirements:**

- Time Complexity: O(1) - single DB query
- Space Complexity: O(1)

## 3. DEPENDENCIES

**This module CALLS:**

- `db.users.fetch_user(username)` - Direct SQL query

**This module is CALLED BY:**

- `main.py:handle_login()`
- `api/login.py:post_login()`

## 4. LEGACY ISSUES (DO NOT REPLICATE)

⚠️ **CRITICAL SECURITY:**

- SQL Injection vulnerability (line 45: string concatenation)
- Plaintext password storage/comparison (line 52)

⚠️ **HIGH SEVERITY:**

- No input validation (crashes on `None`)
- No error handling (crashes on DB errors)

⚠️ **MEDIUM SEVERITY:**

- No logging (can't audit login attempts)
- Returns `False` for both "wrong password" and "user not found" (information disclosure)

## 5. STRANGLER ADAPTER REQUIREMENTS

To maintain compatibility while fixing issues:

1. **Phase 1 (Adapter):**
    
    - Wrap legacy function
    - Add input validation (raise ValueError on None)
    - Add logging
    - Keep existing behavior otherwise
2. **Phase 2 (Modernization):**
    
    - Use parameterized queries
    - Hash password comparisons
    - Proper error handling
    - Return detailed error info (not just bool)

## 6. ACCEPTANCE CRITERIA (Legacy Behavior)

**Test Case 1: Valid Credentials**

- Input: username="alice", password="secret123"
- Expected: `True`
- Actual Behavior: Queries DB, compares plaintext, returns True

**Test Case 2: Invalid Password**

- Input: username="alice", password="wrong"
- Expected: `False`
- Actual Behavior: Returns False

**Test Case 3: User Not Found**

- Input: username="nonexistent", password="anything"
- Expected: `False` (legacy behavior)
- Actual Behavior: Returns False (same as invalid password)

**Test Case 4: None Input (Bug)**

- Input: username=None, password="anything"
- Expected: TypeError (crashes)
- Actual Behavior: Crashes with TypeError

```

## Step 3.2: Create Compatibility Test Suite

**Drag-and-Drop Prompt:**

```

# ROLE: IMPLEMENTER (V4.0)

# TASK: Create Legacy Compatibility Tests

Before we touch the legacy code, we need a test suite that proves the adapters maintain exact legacy behavior.

## REQUIRED CONTEXT

/verify-context: docs/contracts/legacy_[module].md, [legacy_source_file].py

## INSTRUCTIONS

Create `tests/legacy_compat/test_[module]_compat.py`:

1. For each function in the legacy contract:
    
    - Test happy path (valid inputs → expected output)
    - Test edge cases documented in contract
    - Test error cases (including crashes)
2. Use pytest and capture EXACT legacy behavior:
    
    - If legacy crashes, test should expect the crash
    - If legacy returns wrong type, test should expect wrong type
    - If legacy has bug, test should document the bug
3. Mark tests with:
    
    ```python
    @pytest.mark.legacy_compat
    @pytest.mark.parametrize(...)
    ```
    

## OUTPUT FORMAT

```python
import pytest
from legacy_module import validate_credentials  # Direct import of legacy code

class TestLegacyValidateCredentials:
    """Test suite documenting EXACT legacy behavior.
    
    These tests will be used to verify strangler adapters maintain compatibility.
    """
    
    def test_valid_credentials_returns_true(self):
        """Legacy behavior: Valid creds return True."""
        result = validate_credentials("alice", "secret123")
        assert result is True
    
    def test_invalid_password_returns_false(self):
        """Legacy behavior: Wrong password returns False."""
        result = validate_credentials("alice", "wrong")
        assert result is False
    
    def test_nonexistent_user_returns_false(self):
        """Legacy behavior: Nonexistent user returns False (same as wrong password)."""
        result = validate_credentials("ghost", "anything")
        assert result is False
    
    @pytest.mark.xfail(reason="Legacy bug: crashes on None input")
    def test_none_username_crashes(self):
        """Legacy bug: No validation causes crash on None."""
        with pytest.raises(TypeError):
            validate_credentials(None, "password")
    
    @pytest.mark.xfail(reason="Legacy security issue: SQL injection possible")
    def test_sql_injection_vulnerability(self):
        """Legacy vulnerability: SQL injection in username field.
        
        This test documents the vulnerability but doesn't exploit it.
        Adapter should fix this while maintaining API compatibility.
        """
        # This would cause SQL injection in legacy code
        malicious_input = "admin' OR '1'='1"
        # We don't actually run this test, just document the issue
        pytest.skip("Documenting vulnerability, not exploiting")
```

## CRITICAL RULE

Run this test suite against the ACTUAL legacy code BEFORE creating adapters.

**Expected Results:**

- Most tests should PASS (documenting working behavior)
- Some tests should XFAIL (documenting known bugs)
- Save test output: `pytest tests/legacy_compat/ > docs/legacy/BASELINE_TEST_RESULTS.txt`

This baseline proves the adapter maintains compatibility.

```

## Expected Output

After Phase 3, you should have:

✅ Formal contracts for all legacy modules (`docs/contracts/legacy_*.md`)  
✅ Compatibility test suite (`tests/legacy_compat/`)  
✅ Baseline test results (`docs/legacy/BASELINE_TEST_RESULTS.txt`)  
✅ List of bugs and security issues to fix during modernization  

**DO NOT PROCEED TO PHASE 4** until tests pass against legacy code.

---

# 6. PHASE 4: STRANGLER ADAPTER CREATION

**Goal:** Create adapter layer that wraps legacy code and provides modern interface.

**Agent:** Architect → Implementer → Refiner → Auditor  
**Output:** `src/adapters/[module]_adapter.py`

## Step 4.1: Design Adapter Contract

**Drag-and-Drop Prompt:**

```

# ROLE: ARCHITECT (V4.0)

# TASK: Design Strangler Adapter Contract

Create a NEW contract for the adapter that:

1. Fixes legacy issues (validation, security, error handling)
2. Maintains API compatibility (same function names, similar signatures)
3. Calls through to legacy code (doesn't replace it yet)

## REQUIRED CONTEXT

/verify-context: docs/contracts/legacy_[module].md, docs/system_constraints.md, SKILLS/security_hardening.md, SKILLS/python_strict_typing.md

## INSTRUCTIONS

Create `docs/contracts/adapter_[module].md`:

1. **Keep function names same** (for drop-in compatibility)
2. **Improve signatures** (add type hints, stricter types)
3. **Add validation layer** (fix bugs from legacy)
4. **Add error handling** (wrap legacy crashes)
5. **Keep return types compatible** (or provide conversion)

## OUTPUT FORMAT

# CONTRACT: Auth Validator Adapter

**Version:** 1.0 (Adapter Layer) **Last Updated:** [Date] **Status:** Draft

## 1. PURPOSE

Provide a safe, validated interface to legacy auth validation while maintaining API compatibility.

## 2. PUBLIC INTERFACE

### Method: `validate_credentials`

**Signature:**

```python
def validate_credentials(
    username: str,
    password: str
) -> bool:
    """Validate user credentials (adapter wrapping legacy implementation).
    
    ADAPTER IMPROVEMENTS:
    - Input validation added (raises ValueError on invalid input)
    - Error handling added (catches DB errors, returns False)
    - Logging added (audit trail)
    - SQL injection protection added (parameter validation)
    
    LEGACY COMPATIBILITY:
    - Still returns bool (True/False)
    - Still treats "user not found" as False
    - Function name unchanged
    """
```

**Behavior Specification:**

**Input Validation:**

- `username` must be non-empty string, alphanumeric + underscore only, max 50 chars
- `password` must be non-empty string, max 128 chars
- Raise `ValueError` with descriptive message if validation fails

**Processing Logic:**

1. Validate inputs (NEW - fixes legacy bug)
2. Log authentication attempt (NEW - audit trail)
3. Call legacy `_legacy_validate_credentials(username, password)`
4. Catch any exceptions from legacy code (NEW - error handling)
5. Log result (NEW)
6. Return bool

**Output Guarantee:**

- Returns `bool` (same as legacy)
- `True` = credentials valid
- `False` = credentials invalid OR error occurred

**Side Effects:**

- Calls legacy validation (DB query)
- Logs to `auth.log` (NEW)

**Error Handling:**

- **Invalid Input:** Raise `ValueError` with specific message (NEW)
- **Database Error:** Log error, return `False` (NEW - wraps legacy crash)
- **Unexpected Error:** Log error, return `False` (NEW - wraps legacy crash)

## 3. DEPENDENCIES

**This module CALLS:**

- `legacy_auth.validator._legacy_validate_credentials()` - Original legacy function (renamed)

**This module is CALLED BY:**

- `main.py:handle_login()` (replace legacy import)
- `api/login.py:post_login()` (replace legacy import)

## 4. IMPLEMENTATION STRATEGY

### Phase 1: Rename Legacy (No Logic Changes)

```python
# In legacy_auth/validator.py
# Rename: validate_credentials → _legacy_validate_credentials
# Add underscore to mark as internal
```

### Phase 2: Create Adapter (Wraps Legacy)

```python
# In src/adapters/auth_adapter.py
def validate_credentials(username: str, password: str) -> bool:
    # Validation layer (NEW)
    if not username or not isinstance(username, str):
        raise ValueError("Username must be non-empty string")
    # ... more validation ...
    
    # Call legacy (SAME BEHAVIOR)
    try:
        return _legacy_validate_credentials(username, password)
    except Exception as e:
        logger.error(f"Auth error: {e}")
        return False
```

### Phase 3: Update Imports (Swap to Adapter)

```python
# In main.py
# OLD: from legacy_auth.validator import validate_credentials
# NEW: from src.adapters.auth_adapter import validate_credentials
```

## 5. ACCEPTANCE CRITERIA

**Adapter Must Pass Legacy Compatibility Tests:**

- All tests in `tests/legacy_compat/test_validator_compat.py` must pass
- Same outputs for same inputs (except fixed bugs)

**Adapter Must Add Improvements:**

- Invalid input now raises `ValueError` instead of crashing
- DB errors now return `False` instead of crashing
- All calls logged to audit trail

**Test Case: Legacy Bug Fix**

- Input: username=None, password="test"
- Legacy: Crashes with TypeError
- Adapter: Raises ValueError("Username must be non-empty string")

```

## Step 4.2: Implement Adapter

**Drag-and-Drop Prompt:**

```

# ROLE: IMPLEMENTER (V4.0)

# TASK: Implement Strangler Adapter

## REQUIRED CONTEXT

/verify-context: docs/contracts/adapter_[module].md, docs/contracts/legacy_[module].md, SKILLS/python_strict_typing.md, SKILLS/security_hardening.md, _memory_snippet.txt

## INSTRUCTIONS

Create `src/adapters/[module]_adapter.py`:

1. Import legacy module (with renamed function)
2. Implement adapter functions per contract
3. Add validation layer (fix legacy bugs)
4. Add error handling (wrap legacy crashes)
5. Add logging (audit trail)
6. Maintain API compatibility (same function names)

## IMPLEMENTATION CHECKLIST

- [ ] All type hints added
- [ ] Input validation for all parameters
- [ ] Error handling wraps all legacy calls
- [ ] Logging added (authentication, errors)
- [ ] Legacy function calls preserved (don't change logic)
- [ ] No new dependencies (use stdlib only)

## OUTPUT FORMAT

```python
"""Auth validation adapter (strangler pattern).

This module wraps the legacy auth validator, adding:
- Input validation
- Error handling
- Logging/audit trail
- Type safety

Maintains API compatibility with legacy code.
"""

import logging
import re
from typing import Optional

# Import legacy function (renamed to mark as internal)
from legacy_auth.validator import validate_credentials as _legacy_validate_credentials


logger = logging.getLogger(__name__)


def validate_credentials(username: str, password: str) -> bool:
    """Validate user credentials with improved safety.
    
    This is an adapter wrapping the legacy validation function.
    Adds input validation and error handling while maintaining
    compatible behavior.
    
    Args:
        username: User's username (alphanumeric + underscore, max 50 chars).
        password: User's password (max 128 chars).
    
    Returns:
        True if credentials are valid, False otherwise.
        Returns False on any error (logged for audit).
    
    Raises:
        ValueError: If username or password format is invalid.
    
    Example:
        >>> validate_credentials("alice", "secret123")
        True
        >>> validate_credentials("bob", "wrong")
        False
    """
    # Input validation (NEW - fixes legacy bug)
    if not isinstance(username, str) or not username:
        raise ValueError("Username must be a non-empty string")
    
    if not isinstance(password, str) or not password:
        raise ValueError("Password must be a non-empty string")
    
    # Security validation
    if len(username) > 50:
        raise ValueError("Username too long (max 50 characters)")
    
    if len(password) > 128:
        raise ValueError("Password too long (max 128 characters)")
    
    # Username format validation (alphanumeric + underscore only)
    if not re.match(r'^[a-zA-Z0-9_]+$', username):
        raise ValueError("Username must be alphanumeric (underscores allowed)")
    
    # Log authentication attempt (NEW - audit trail)
    logger.info(f"Authentication attempt for user: {username}")
    
    # Call legacy validation (SAME BEHAVIOR)
    try:
        result = _legacy_validate_credentials(username, password)
        logger.info(f"Authentication {'succeeded' if result else 'failed'} for user: {username}")
        return result
    
    except Exception as e:
        # Error handling (NEW - wraps legacy crashes)
        logger.error(f"Authentication error for user {username}: {e}", exc_info=True)
        return False  # Fail safe
```

## CRITICAL RULES

1. **DO NOT change legacy function logic** - only wrap it
2. **DO validate inputs before calling legacy** - this fixes bugs
3. **DO catch all exceptions from legacy** - this prevents crashes
4. **DO log all authentication attempts** - this creates audit trail
5. **DO maintain same return type** - this preserves compatibility

```

## Step 4.3: Test Adapter Compatibility

**Drag-and-Drop Prompt:**

```

# ROLE: IMPLEMENTER (V4.0)

# TASK: Create Adapter Tests

Create tests proving the adapter maintains legacy compatibility while adding improvements.

## REQUIRED CONTEXT

/verify-context: src/adapters/[module]_adapter.py, tests/legacy_compat/test_[module]_compat.py

## INSTRUCTIONS

Create `tests/adapters/test_[module]_adapter.py`:

1. Import same test cases from legacy_compat tests
2. Run against adapter instead of legacy
3. Verify:
    - Same outputs for valid inputs
    - BETTER handling for invalid inputs (raises ValueError instead of crashes)
    - Logs created for audit trail

## OUTPUT FORMAT

```python
import pytest
from src.adapters.auth_adapter import validate_credentials

class TestAuthAdapterCompatibility:
    """Verify adapter maintains legacy compatibility with improvements."""
    
    def test_valid_credentials_returns_true(self):
        """Adapter: Valid creds return True (same as legacy)."""
        result = validate_credentials("alice", "secret123")
        assert result is True
    
    def test_invalid_password_returns_false(self):
        """Adapter: Wrong password returns False (same as legacy)."""
        result = validate_credentials("alice", "wrong")
        assert result is False
    
    def test_none_username_raises_valueerror(self):
        """Adapter improvement: None input raises ValueError (not crash)."""
        with pytest.raises(ValueError, match="Username must be a non-empty string"):
            validate_credentials(None, "password")
    
    def test_empty_username_raises_valueerror(self):
        """Adapter improvement: Empty string raises ValueError."""
        with pytest.raises(ValueError, match="Username must be a non-empty string"):
            validate_credentials("", "password")
    
    def test_special_chars_in_username_raises_valueerror(self):
        """Adapter improvement: SQL injection chars rejected."""
        with pytest.raises(ValueError, match="Username must be alphanumeric"):
            validate_credentials("admin' OR '1'='1", "password")
    
    def test_audit_log_created(self, caplog):
        """Adapter improvement: Authentication attempts logged."""
        validate_credentials("alice", "secret123")
        assert "Authentication attempt for user: alice" in caplog.text
        assert "Authentication succeeded for user: alice" in caplog.text
```

## RUN TESTS

```bash
# Run legacy compatibility tests (baseline)
pytest tests/legacy_compat/ -v

# Run adapter tests (with improvements)
pytest tests/adapters/ -v

# Compare results:
# - Adapter should pass ALL legacy tests (except xfail bugs)
# - Adapter should pass NEW validation tests (that legacy fails)
```

**ACCEPTANCE CRITERIA:** ✅ Adapter passes all legacy compatibility tests ✅ Adapter handles edge cases better (no crashes) ✅ Audit logs created for all calls

```

## Expected Output

After Phase 4, you should have:

✅ Adapter contracts (`docs/contracts/adapter_*.md`)  
✅ Adapter implementations (`src/adapters/*_adapter.py`)  
✅ Adapter test suite (`tests/adapters/`)  
✅ Test comparison showing adapter improves on legacy while maintaining compatibility  

**CRITICAL CHECKPOINT:** Do NOT proceed to Phase 5 until adapters pass all compatibility tests.

---

# 7. PHASE 5: INCREMENTAL REPLACEMENT

**Goal:** Replace legacy implementations module-by-module with modern code.

**Agent:** Architect → Implementer → Refiner → Auditor  
**Strategy:** Adapter stays in place, but internal implementation gets replaced

## Step 5.1: Design Modern Contract

**Drag-and-Drop Prompt:**

```

# ROLE: ARCHITECT (V4.0)

# TASK: Design Modern Replacement Contract

Now that the adapter is working, design the MODERN replacement for the legacy internals.

## REQUIRED CONTEXT

/verify-context: docs/contracts/adapter_[module].md, docs/contracts/legacy_[module].md, docs/system_constraints.md, SKILLS/python_strict_typing.md, SKILLS/security_hardening.md

## INSTRUCTIONS

Create `docs/contracts/modern_[module].md`:

1. **Fix all legacy security issues:**
    
    - SQL injection → Parameterized queries
    - Plaintext passwords → Bcrypt hashing
    - No error handling → Proper exception hierarchy
2. **Improve architecture:**
    
    - Separate validation from business logic
    - Use dependency injection for database
    - Return rich error types (not just bool)
3. **Maintain adapter compatibility:**
    
    - Adapter can still call this
    - Adapter translates modern response to legacy bool

## OUTPUT FORMAT

# CONTRACT: Modern Auth Validator

**Version:** 2.0 (Modern Implementation) **Last Updated:** [Date] **Status:** Draft

## 1. PURPOSE

Provide secure, maintainable user authentication with proper error handling and security best practices.

## 2. PUBLIC INTERFACE

### Method: `authenticate_user`

**Signature:**

```python
def authenticate_user(
    username: str,
    password: str,
    db_connection: DatabaseConnection
) -> AuthenticationResult:
    """Authenticate user credentials securely.
    
    IMPROVEMENTS FROM LEGACY:
    - Parameterized queries (no SQL injection)
    - Bcrypt password hashing (no plaintext)
    - Rich error types (not just bool)
    - Dependency injection (testable)
    - Proper error handling
    """
```

**Behavior Specification:**

**Input Validation:**

- All validation from adapter contract
- Additional: Check username against blocklist
- Additional: Password complexity requirements

**Processing Logic:**

1. Validate inputs (reuse adapter validation)
2. Query database with parameterized query
3. Compare hashed password using bcrypt
4. Return rich result object

**Output Guarantee:**

- Returns `AuthenticationResult` (dataclass):
    - `success: bool`
    - `user_id: Optional[int]`
    - `error_code: Optional[str]`
    - `error_message: Optional[str]`

**Error Handling:**

- **Invalid Input:** Raise `ValidationError`
- **User Not Found:** Return `AuthenticationResult(success=False, error_code="USER_NOT_FOUND")`
- **Invalid Password:** Return `AuthenticationResult(success=False, error_code="INVALID_PASSWORD")`
- **Database Error:** Raise `DatabaseError`

## 3. INTEGRATION WITH ADAPTER

The adapter will wrap this modern function:

```python
# In adapter:
def validate_credentials(username: str, password: str) -> bool:
    result = authenticate_user(username, password, get_db_connection())
    return result.success  # Convert rich result to legacy bool
```

## 4. ACCEPTANCE CRITERIA

**Modern Tests (New Behavior):**

- Returns `AuthenticationResult` with error codes
- Uses bcrypt for password hashing
- Uses parameterized queries
- Handles all error cases gracefully

**Adapter Still Works:**

- Adapter wraps modern function
- Adapter still returns bool
- Adapter still passes compatibility tests

```

## Step 5.2: Implement Modern Module

**Drag-and-Drop Prompt:**

```

# ROLE: IMPLEMENTER (V4.0)

# TASK: Implement Modern Replacement

Create modern implementation following the new contract.

## REQUIRED CONTEXT

/verify-context: docs/contracts/modern_[module].md, SKILLS/python_strict_typing.md, SKILLS/security_hardening.md, docs/system_constraints.md

## INSTRUCTIONS

Create `src/auth/modern_validator.py`:

1. Implement per modern contract
2. Use parameterized queries
3. Use bcrypt for passwords
4. Return rich error types
5. Add comprehensive tests

## OUTPUT FORMAT

```python
"""Modern authentication validator.

Replaces legacy implementation with security improvements:
- Parameterized queries (no SQL injection)
- Bcrypt password hashing
- Rich error reporting
- Dependency injection for testability
"""

from dataclasses import dataclass
from typing import Optional
import bcrypt
import logging

from db.connection import DatabaseConnection
from exceptions import ValidationError, DatabaseError


logger = logging.getLogger(__name__)


@dataclass
class AuthenticationResult:
    """Result of authentication attempt."""
    success: bool
    user_id: Optional[int] = None
    error_code: Optional[str] = None
    error_message: Optional[str] = None


def authenticate_user(
    username: str,
    password: str,
    db_connection: DatabaseConnection
) -> AuthenticationResult:
    """Authenticate user with secure password handling.
    
    Args:
        username: User's username (validated).
        password: User's password (plaintext - will be hashed for comparison).
        db_connection: Database connection (dependency injection).
    
    Returns:
        AuthenticationResult with success status and optional error details.
    
    Raises:
        ValidationError: If inputs fail validation.
        DatabaseError: If database query fails.
    """
    # Query user with parameterized query (SQL injection safe)
    try:
        cursor = db_connection.execute(
            "SELECT id, username, password_hash FROM users WHERE username = ?",
            (username,)
        )
        user = cursor.fetchone()
    except Exception as e:
        logger.error(f"Database error during authentication: {e}")
        raise DatabaseError(f"Failed to query user: {e}") from e
    
    # User not found
    if not user:
        logger.warning(f"Authentication failed: User not found: {username}")
        return AuthenticationResult(
            success=False,
            error_code="USER_NOT_FOUND",
            error_message="Invalid username or password"  # Vague for security
        )
    
    user_id, db_username, password_hash = user
    
    # Compare passwords using bcrypt (secure hash comparison)
    try:
        password_matches = bcrypt.checkpw(
            password.encode('utf-8'),
            password_hash.encode('utf-8')
        )
    except Exception as e:
        logger.error(f"Password comparison error: {e}")
        raise DatabaseError(f"Password verification failed: {e}") from e
    
    # Invalid password
    if not password_matches:
        logger.warning(f"Authentication failed: Invalid password for user: {username}")
        return AuthenticationResult(
            success=False,
            error_code="INVALID_PASSWORD",
            error_message="Invalid username or password"  # Vague for security
        )
    
    # Success
    logger.info(f"Authentication succeeded for user: {username}")
    return AuthenticationResult(
        success=True,
        user_id=user_id
    )
```

```

## Step 5.3: Update Adapter to Use Modern Implementation

**Drag-and-Drop Prompt:**

```

# ROLE: IMPLEMENTER (V4.0)

# TASK: Rewire Adapter to Modern Implementation

Update the adapter to call the new modern function instead of legacy.

## REQUIRED CONTEXT

/verify-context: src/adapters/[module]_adapter.py, src/auth/modern_validator.py

## INSTRUCTIONS

1. Update adapter to import modern function
2. Change internal call from legacy to modern
3. Translate modern result back to legacy bool
4. Keep all validation and error handling

## OUTPUT FORMAT

```python
# In src/adapters/auth_adapter.py

# OLD IMPORT (commented out):
# from legacy_auth.validator import validate_credentials as _legacy_validate_credentials

# NEW IMPORT:
from src.auth.modern_validator import authenticate_user
from db.connection import get_db_connection


def validate_credentials(username: str, password: str) -> bool:
    """Validate user credentials (adapter wrapping modern implementation).
    
    This adapter maintains legacy API compatibility while using
    the modern secure implementation internally.
    """
    # [Keep all validation code - unchanged]
    if not isinstance(username, str) or not username:
        raise ValueError("Username must be a non-empty string")
    # ... etc ...
    
    logger.info(f"Authentication attempt for user: {username}")
    
    # Call MODERN implementation (NEW)
    try:
        result = authenticate_user(username, password, get_db_connection())
        
        # Translate modern result to legacy bool
        legacy_result = result.success
        
        logger.info(f"Authentication {'succeeded' if legacy_result else 'failed'} for user: {username}")
        return legacy_result
    
    except Exception as e:
        logger.error(f"Authentication error for user {username}: {e}", exc_info=True)
        return False
```

## CRITICAL TEST

Run adapter tests again:

```bash
pytest tests/adapters/test_auth_adapter.py -v
```

**Expected:** All tests still pass (adapter maintains compatibility even though internals changed)

```

## Expected Output

After Phase 5, you should have:

✅ Modern contracts (`docs/contracts/modern_*.md`)  
✅ Modern implementations (`src/auth/modern_*.py`)  
✅ Updated adapters (now calling modern code)  
✅ All adapter tests still passing (compatibility maintained)  
✅ All legacy security issues fixed in modern layer  

**CRITICAL:** Adapter tests must STILL PASS after rewiring to modern implementation.

---

# 8. PHASE 6: VALIDATION & CUTOVER

**Goal:** Verify modern system works in production, then remove legacy code.

## Step 6.1: Shadow Mode Testing

**Strategy:** Run both legacy and modern in parallel, compare results.

**Drag-and-Drop Prompt:**

```

# ROLE: IMPLEMENTER (V4.0)

# TASK: Create Shadow Mode Wrapper

Create a wrapper that calls BOTH legacy and modern, compares results, logs discrepancies.

## INSTRUCTIONS

Create `src/adapters/shadow_validator.py`:

```python
"""Shadow mode validator.

Calls both legacy and modern implementations,
compares results, logs discrepancies.

Use this in production to verify modern code
matches legacy behavior before full cutover.
"""

import logging
from legacy_auth.validator import validate_credentials as legacy_validate
from src.auth.modern_validator import authenticate_user
from db.connection import get_db_connection


logger = logging.getLogger(__name__)


def validate_credentials_shadow(username: str, password: str) -> bool:
    """Validate credentials in shadow mode (legacy + modern comparison).
    
    Returns legacy result (for compatibility) but logs if modern differs.
    """
    # Call legacy (this is what users currently see)
    try:
        legacy_result = legacy_validate(username, password)
    except Exception as e:
        logger.error(f"Legacy validation error: {e}")
        legacy_result = None
    
    # Call modern (shadow - not returned yet)
    try:
        modern_result_obj = authenticate_user(username, password, get_db_connection())
        modern_result = modern_result_obj.success
    except Exception as e:
        logger.error(f"Modern validation error: {e}")
        modern_result = None
    
    # Compare results
    if legacy_result != modern_result:
        logger.warning(
            f"SHADOW MODE DISCREPANCY: username={username}, "
            f"legacy={legacy_result}, modern={modern_result}"
        )
    
    # Return legacy result (for now)
    return legacy_result if legacy_result is not None else False
```

## DEPLOYMENT STRATEGY

1. **Week 1:** Deploy shadow mode to production
2. **Monitor logs:** Check for discrepancies
3. **Investigate:** Any mismatch between legacy/modern?
4. **Fix:** If modern is wrong, fix and redeploy
5. **Week 2:** If no discrepancies, proceed to cutover

```

## Step 6.2: Full Cutover

**When to Cut Over:**
- Shadow mode shows 0 discrepancies for 7+ days
- Modern code has 0 crashes
- Modern code performance is acceptable

**Drag-and-Drop Prompt:**

```

# ROLE: IMPLEMENTER (V4.0)

# TASK: Cut Over to Modern Implementation

## CHECKLIST

- [ ] Shadow mode logs show 0 discrepancies for 7 days
- [ ] Modern code has 0 crashes in logs
- [ ] Performance metrics acceptable (response time, throughput)
- [ ] Rollback plan prepared

## CUTOVER STEPS

1. **Update adapter to return modern result:**
    
    ```python
    # In src/adapters/auth_adapter.py
    def validate_credentials(username: str, password: str) -> bool:
        result = authenticate_user(username, password, get_db_connection())
        return result.success  # NOW RETURNING MODERN RESULT
    ```
    
2. **Deploy to production:**
    
    - Deploy during low-traffic window
    - Monitor error rates closely
    - Be ready to rollback
3. **Monitor for 24 hours:**
    
    - Check error logs
    - Check performance metrics
    - Check user reports
4. **If successful after 24 hours:**
    
    - Mark as stable
    - Proceed to legacy removal
5. **If issues detected:**
    
    - Rollback to shadow mode
    - Investigate discrepancies
    - Fix modern code
    - Retry cutover

```

## Step 6.3: Remove Legacy Code

**ONLY AFTER successful cutover and 30-day stability period:**

**Drag-and-Drop Prompt:**

```

# TASK: Remove Legacy Code

## CRITICAL RULES

1. **Wait 30 days after cutover** before removing legacy
2. **Tag legacy code** in version control before deletion
3. **Archive legacy code** in separate branch
4. **Remove in phases:**
    - Phase 1: Comment out legacy imports (don't delete yet)
    - Phase 2: Monitor for 7 days (any crashes?)
    - Phase 3: Delete commented code
    - Phase 4: Remove legacy files

## REMOVAL CHECKLIST

- [ ] 30 days since cutover with 0 issues
- [ ] Legacy code tagged in git: `git tag legacy-archive-auth-validator`
- [ ] Legacy code archived: `git checkout -b archive/legacy-auth`
- [ ] All imports updated to modern
- [ ] All tests updated to modern
- [ ] Documentation updated

## FINAL CLEANUP

Delete files:

- `legacy_auth/validator.py`
- `tests/legacy_compat/test_validator_compat.py`

Keep files (for history):

- `docs/legacy/SYSTEM_MAP.md`
- `docs/legacy/API_MAP_legacy.md`
- `docs/contracts/legacy_auth_validator.md` (mark as "DEPRECATED - See modern_auth_validator.md")

```

## Expected Output

After Phase 6, you should have:

✅ Shadow mode deployed and validated  
✅ Modern code running in production  
✅ 30-day stability period completed  
✅ Legacy code archived and removed  
✅ Documentation updated  
✅ System fully modernized  

---

# 9. DRAG-AND-DROP PROMPTS

## Quick Reference: All Prompts by Phase

### Phase 1: Reconnaissance
```

[Copy from Section 3: Step 1.1 and 1.2]

```

### Phase 2: Dependency Mapping
```

[Copy from Section 4: Step 2.1 and 2.2]

```

### Phase 3: Contract Extraction
```

[Copy from Section 5: Step 3.1 and 3.2]

```

### Phase 4: Adapter Creation
```

[Copy from Section 6: Step 4.1, 4.2, and 4.3]

```

### Phase 5: Modern Replacement
```

[Copy from Section 7: Step 5.1, 5.2, and 5.3]

```

### Phase 6: Validation & Cutover
```

[Copy from Section 8: Step 6.1, 6.2, and 6.3]

```

## Prompt Template: Batch Processing

**Use this when analyzing large legacy codebases in chunks:**

```

# ROLE: RESEARCHER (V4.0)

# TASK: Batch Analysis [Batch N of M]

## CONTEXT WINDOW MANAGEMENT

This is batch N of M. Process only files [X-Y] in this session.

## REQUIRED CONTEXT

/verify-context: docs/legacy/SYSTEM_MAP.md

## INSTRUCTIONS

Analyze files X through Y:

1. Extract signatures
2. Identify dependencies
3. Note issues
4. Output results

DO NOT accumulate context from previous batches. At end, ask: "Ready for batch N+1?"

## OUTPUT

Append to `docs/legacy/API_MAP_legacy.md` (Section: Batch N)

````

---

# 10. EMERGENCY ROLLBACK PROCEDURES

## If Modern Code Fails in Production

### Immediate Rollback (< 5 minutes)

```bash
# 1. Revert adapter to legacy
git revert [commit-hash-of-cutover]
git push

# 2. Deploy immediately
./deploy.sh

# 3. Verify rollback successful
curl -X POST /api/login -d '{"username":"test","password":"test"}'

# 4. Check logs
tail -f /var/log/app.log | grep "Authentication"
````

### Post-Rollback Analysis

1. **Capture error logs:**
    
    ```bash
    journalctl -u app-service --since "10 minutes ago" > rollback-errors.log
    ```
    
2. **Identify root cause:**
    
    - What inputs caused failure?
    - Was it a logic error or performance issue?
    - Did modern code have a bug?
3. **Fix and retry:**
    
    - Fix modern implementation
    - Re-run shadow mode
    - Wait for stability
    - Retry cutover

## If Shadow Mode Shows Discrepancies

### Investigation Checklist

```
[ ] What inputs trigger discrepancy?
    Examples: __________________________________________

[ ] Is modern code wrong or legacy code wrong?
    Analysis: __________________________________________

[ ] Is it an edge case bug?
    Description: __________________________________________

[ ] Is it a data inconsistency (e.g., password hash format)?
    Description: __________________________________________
```

### Resolution Steps

1. **Create reproduction test:**
    
    ```python
    def test_shadow_discrepancy_case():
        """Reproduce the exact discrepancy from logs."""
        username = "problematic_user"
        password = "problematic_password"
        
        legacy_result = legacy_validate(username, password)
        modern_result = authenticate_user(username, password, db).success
        
        assert legacy_result == modern_result, "Discrepancy reproduced"
    ```
    
2. **Fix the bug** (in modern code if legacy is correct, or document if legacy is wrong)
    
3. **Re-deploy shadow mode**
    
4. **Monitor for 7 more days**
    

---

# APPENDIX A: MEMORY ENTRIES FOR LEGACY WORK

Add these to `project_memory.md` as you complete phases:

```markdown
# MEMORY ENTRY: Legacy Modernization

**Date:** [YYYY-MM-DD]
**Context:** Strangler Pattern refactoring of legacy auth module

## DECISIONS MADE

1. **Adapter Pattern:** 
   - All legacy code wrapped in adapters before modernization
   - Adapters maintain API compatibility while adding validation

2. **Shadow Mode Required:**
   - New code must run in shadow mode for 7+ days before cutover
   - Zero discrepancies required for cutover approval

3. **Security Fixes Non-Negotiable:**
   - SQL injection fixes applied in adapter layer
   - Password hashing fixes applied in modern layer
   - No security issues allowed to persist

## ANTI-PATTERNS TO AVOID

1. ❌ **Do NOT refactor and change behavior simultaneously**
   - Always extract contract first
   - Always test compatibility
   - Then modernize internals

2. ❌ **Do NOT paste massive files into Implementer**
   - Use Researcher to map first
   - Process in batches
   - Respect context window limits

3. ❌ **Do NOT skip shadow mode**
   - Modern code must prove compatibility
   - Production data is unpredictable
   - Shadow mode catches edge cases

## PATTERNS TO REUSE

1. ✅ **Batch processing for large codebases**
   - 5 files per batch maximum
   - Clear context between batches
   - Append results incrementally

2. ✅ **Compatibility test baseline**
   - Run tests against legacy FIRST
   - Save baseline results
   - Adapter must match baseline

3. ✅ **Incremental cutover**
   - Adapter → Shadow → Cutover → Remove
   - 30-day stability window required
   - Keep legacy archived for 90 days
```

---

# APPENDIX B: SUCCESS METRICS

## How to Know if Modernization Succeeded

### Phase Completion Metrics

|Phase|Success Criteria|Output Artifacts|
|---|---|---|
|1. Reconnaissance|✅ Complete SYSTEM_MAP.md<br>✅ All critical paths identified<br>✅ Complexity hotspots prioritized|`docs/legacy/SYSTEM_MAP.md`|
|2. Dependency Mapping|✅ All public interfaces documented<br>✅ All implicit contracts identified<br>✅ Security issues flagged|`docs/legacy/API_MAP_legacy.md`|
|3. Contract Extraction|✅ Formal contracts created<br>✅ Compatibility tests passing<br>✅ Baseline results saved|`docs/contracts/legacy_*.md`<br>`tests/legacy_compat/`|
|4. Adapter Creation|✅ Adapters pass compatibility tests<br>✅ Validation added<br>✅ Error handling added|`src/adapters/*_adapter.py`<br>`tests/adapters/`|
|5. Modern Replacement|✅ Security issues fixed<br>✅ Modern tests passing<br>✅ Adapter rewired|`src/auth/modern_*.py`<br>`docs/contracts/modern_*.md`|
|6. Validation & Cutover|✅ Shadow mode: 0 discrepancies<br>✅ Cutover successful<br>✅ Legacy code removed|Production logs<br>Git tags|

### Overall Success Indicators

✅ **Quality Improvements:**

- Type hints: 0% → 100%
- Test coverage: <50% → >80%
- Security issues: 10+ → 0
- Documentation: 0% → 100%

✅ **Operational Improvements:**

- Error rate: Same or better
- Performance: Same or better
- Maintainability: Significantly better
- Developer confidence: High

✅ **Process Improvements:**

- No production incidents during modernization
- No rollbacks required
- All phases completed on schedule
- Documentation complete and accurate

---

# CONCLUSION

You now have a complete playbook for modernizing legacy codebases using the V4.0 agent system.

## Key Takeaways

1. **Never paste massive files into agents** - Use Researcher to map first
2. **Contract-first applies to legacy too** - Extract contracts before refactoring
3. **Strangler Pattern is your friend** - Wrap, test, replace, remove
4. **Context hygiene is critical** - Process in batches, clear context frequently
5. **Compatibility is non-negotiable** - Shadow mode before cutover

## When to Use This Playbook

✅ Modernizing legacy code with poor documentation  
✅ Adding type hints to untyped codebase  
✅ Refactoring monoliths incrementally  
✅ Fixing security issues in production code  
✅ Porting to new framework while maintaining compatibility

## When NOT to Use This Playbook

❌ Greenfield projects (use standard V4.0 workflow)  
❌ Throwaway prototypes  
❌ Code you can afford to rewrite from scratch

---

**Remember:** Legacy code is often poorly documented BECAUSE it works. Respect it. Understand it. Then modernize it carefully.

**Good luck with your modernization project!**