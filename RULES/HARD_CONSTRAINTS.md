# HARD CONSTRAINTS (V4.0)

**Type:** Absolute Rules  
**Enforcement:** NON-NEGOTIABLE  
**Violation Consequences:** Automatic rejection by Auditor

---

## PURPOSE

These are the immutable laws of the system. They cannot be violated under any circumstances, even if the user requests it or if it seems convenient.

---

## LIBRARY CONSTRAINTS

### FORBIDDEN LIBRARIES

**Rule:** These libraries are NEVER permitted in any code.

```python
# ❌ ABSOLUTELY FORBIDDEN
import os.system  # Security risk
import eval  # Code injection risk
import exec  # Code injection risk
import pickle  # Arbitrary code execution risk
import __import__  # Dynamic import abuse
```

**Reasoning:**

- Security vulnerabilities
- Unpredictable behavior
- Maintenance nightmares
- Known CVEs

---

### APPROVED LIBRARIES ONLY

**Rule:** Only libraries in the approved list may be used.

**Standard Library (Always Approved):**

- `typing`, `collections`, `itertools`
- `datetime`, `time`
- `json`, `csv`
- `pathlib`, `os.path`
- `logging`
- `subprocess` (with restrictions - see Security Skill)
- `re`, `string`
- `math`, `statistics`
- `hashlib`, `secrets`
- `dataclasses`, `enum`

**Third-Party (Project-Specific - Check API_MAP.md):** [This section should be customized per project]

**To Add New Library:**

1. Must be requested explicitly
2. Must be approved by human
3. Must be added to API_MAP.md
4. Must pass security review

---

## PATTERN CONSTRAINTS

### NO GLOBAL MUTABLE STATE

**Rule:** No global variables except constants.

```python
# ❌ FORBIDDEN
counter = 0

def increment():
    global counter
    counter += 1

# ✅ ALLOWED (constants)
MAX_RETRIES = 3
API_VERSION = "v1"

# ✅ ALLOWED (class state)
class Counter:
    def __init__(self):
        self.value = 0
    
    def increment(self):
        self.value += 1
```

**Reasoning:**

- Thread safety issues
- Testing difficulties
- Hidden dependencies
- State management chaos

---

### NO MONKEY PATCHING

**Rule:** Never modify existing classes/modules at runtime.

```python
# ❌ FORBIDDEN
str.new_method = lambda self: self.upper()
datetime.datetime.now = lambda: fixed_time

# ✅ ALLOWED (inheritance)
class CustomStr(str):
    def new_method(self):
        return self.upper()
```

**Reasoning:**

- Breaks expectations
- Hard to debug
- Fragile code
- Testing nightmares

---

### NO CIRCULAR IMPORTS

**Rule:** Module dependencies must form a directed acyclic graph (DAG).

```python
# ❌ FORBIDDEN
# File: module_a.py
from module_b import func_b

# File: module_b.py
from module_a import func_a  # Circular dependency!

# ✅ ALLOWED
# File: module_a.py
from module_c import shared_func

# File: module_b.py
from module_c import shared_func

# File: module_c.py (base module)
def shared_func():
    pass
```

**Reasoning:**

- Import failures
- Initialization problems
- Poor architecture

---

### NO WILDCARD IMPORTS

**Rule:** Always import specific names, never use `*`.

```python
# ❌ FORBIDDEN
from module import *
from typing import *

# ✅ REQUIRED
from module import specific_function, SpecificClass
from typing import Optional, List, Dict
```

**Reasoning:**

- Namespace pollution
- Hidden dependencies
- IDE/linter confusion

---

## CODE STRUCTURE CONSTRAINTS

### MAXIMUM FUNCTION LENGTH

**Rule:** No function may exceed 50 lines of code.

**Enforcement:**

- Count only executable lines (not comments/docstrings)
- If function exceeds limit: Extract helper functions
- If unavoidable: Requires explicit justification comment

```python
# ❌ FORBIDDEN
def massive_function():
    # ... 100 lines of code ...
    pass

# ✅ REQUIRED
def main_function():
    result1 = _helper_step_1()
    result2 = _helper_step_2(result1)
    return _helper_step_3(result2)

def _helper_step_1():
    # ... 20 lines ...
    pass

def _helper_step_2(data):
    # ... 15 lines ...
    pass

def _helper_step_3(data):
    # ... 12 lines ...
    pass
```

**Reasoning:**

- Cognitive load
- Testability
- Maintainability

---

### MAXIMUM FILE LENGTH

**Rule:** No Python file may exceed 500 lines of code.

**Enforcement:**

- If file exceeds limit: Split into multiple modules
- Group related functionality
- Use subpackages if needed

**Reasoning:**

- Code organization
- Module cohesion
- Review difficulty

---

### MAXIMUM CLASS COMPLEXITY

**Rule:** Classes may have maximum 10 public methods.

**Enforcement:**

- If exceeded: Split into multiple classes
- Use composition over inheritance
- Follow Single Responsibility Principle

```python
# ❌ FORBIDDEN (god object)
class User:
    def login(self): pass
    def logout(self): pass
    def change_password(self): pass
    def update_profile(self): pass
    def send_email(self): pass
    def generate_report(self): pass
    def process_payment(self): pass
    def manage_permissions(self): pass
    def audit_log(self): pass
    def export_data(self): pass
    def import_data(self): pass  # 11th method!

# ✅ REQUIRED (composition)
class User:
    def __init__(self):
        self.auth = AuthManager()
        self.profile = ProfileManager()
        self.email = EmailService()
    
    def login(self): return self.auth.login()
    def logout(self): return self.auth.logout()
    def update_profile(self): return self.profile.update()
```

---

## DOCUMENTATION CONSTRAINTS

### MANDATORY DOCSTRINGS

**Rule:** All public functions/classes MUST have docstrings.

**Enforcement:**

```python
# ❌ FORBIDDEN
def public_function(param):
    return param * 2

# ✅ REQUIRED
def public_function(param: int) -> int:
    """Double the input parameter.
    
    Args:
        param: Integer to double.
    
    Returns:
        The input multiplied by 2.
    """
    return param * 2
```

**Exception:** Private functions (prefixed with `_`) may omit docstrings if logic is obvious.

---

### MANDATORY TYPE HINTS

**Rule:** All function signatures MUST be fully type-hinted.

**Enforcement:** See SKILLS/core/python_strict_typing.md for complete rules.

**No Exceptions:** Even for trivial functions.

---

## TESTING CONSTRAINTS

### TEST COVERAGE MINIMUM

**Rule:** All new code must have ≥80% test coverage.

**Enforcement:**

- Unit tests for all public functions
- Integration tests for workflows
- Edge case tests for validation logic

**Exception:** UI code, configuration files, simple getters/setters may have lower coverage if justified.

---

### NO SKIPPED TESTS

**Rule:** No `@pytest.skip` or `@unittest.skip` in committed code.

**Enforcement:**

```python
# ❌ FORBIDDEN (in main branch)
@pytest.skip("TODO: Fix this later")
def test_important_feature():
    pass

# ✅ ALLOWED (in feature branch with issue reference)
@pytest.mark.xfail(reason="Blocked by issue #123")
def test_future_feature():
    pass

# ✅ REQUIRED
def test_important_feature():
    result = important_feature()
    assert result == expected
```

---

## PERFORMANCE CONSTRAINTS

### NO PREMATURE OPTIMIZATION

**Rule:** Do not optimize until profiling proves it necessary.

**Enforcement:**

- Write clear, correct code first
- Optimize only if benchmarks show problem
- Document optimization with profiling data

```python
# ❌ FORBIDDEN (premature optimization)
def process(items):
    # Using obscure bit manipulation to save 0.001ms
    return [x << 1 for x in items]  # Why???

# ✅ REQUIRED (clear code)
def process(items: list[int]) -> list[int]:
    """Double all items in list."""
    return [x * 2 for x in items]
```

---

### AVOID N+1 QUERIES

**Rule:** Database queries inside loops are forbidden.

```python
# ❌ FORBIDDEN
def get_user_posts(user_ids: list[int]) -> list[Post]:
    posts = []
    for user_id in user_ids:
        posts.extend(db.query(f"SELECT * FROM posts WHERE user_id={user_id}"))
    return posts

# ✅ REQUIRED
def get_user_posts(user_ids: list[int]) -> list[Post]:
    """Fetch posts for multiple users with single query."""
    return db.query(
        "SELECT * FROM posts WHERE user_id IN (?)",
        (user_ids,)
    )
```

---

## VERSION CONTROL CONSTRAINTS

### NO DIRECT COMMITS TO MAIN

**Rule:** All changes must go through pull request review.

**Enforcement:**

- Feature branches required
- At least 1 reviewer approval
- CI/CD must pass
- Auditor approval required

**Exception:** Hotfixes may skip PR if approved by tech lead AND documented in hotfix log.

---

### COMMIT MESSAGE FORMAT

**Rule:** All commits must follow conventional commits format.

```bash
# ❌ FORBIDDEN
git commit -m "fixed stuff"
git commit -m "updates"

# ✅ REQUIRED
git commit -m "feat(auth): add token refresh mechanism"
git commit -m "fix(api): handle null user in /profile endpoint"
git commit -m "docs(readme): update installation instructions"
```

**Format:** `<type>(<scope>): <description>`

**Types:** feat, fix, docs, style, refactor, test, chore

---

## SECURITY CONSTRAINTS

### NO SECRETS IN CODE

**Rule:** Absolutely no hardcoded secrets, API keys, passwords, or tokens.

**Enforcement:** See SKILLS/core/security_hardening.md for complete rules.

**Violation Consequence:** Immediate rejection + security incident report.

---

### INPUT VALIDATION REQUIRED

**Rule:** All external input MUST be validated.

**Enforcement:** See SKILLS/core/security_hardening.md for complete rules.

**No Exceptions:** Even for "trusted" inputs.

---

## CONSTRAINT VIOLATION HANDLING

### For Architect

If constraint prevents implementation of feature:

1. Document the constraint violation
2. Propose alternative approach
3. Request human approval for exception (if justified)
4. Never silently ignore constraint

### For Implementer

If you detect constraint violation during implementation:

1. HALT immediately
2. Output error explaining constraint
3. Request clarification or alternative approach
4. Do NOT attempt to work around constraint

### For Auditor

If code violates any constraint:

1. **Automatic FAIL** (no negotiation)
2. Cite specific constraint violated
3. Provide corrected example
4. Require resubmission

---

## ADDING NEW CONSTRAINTS

**Process:**

1. Propose constraint with rationale
2. Add to project_memory.md as "Constraint" entry
3. After 3+ successful uses, promote to HARD_CONSTRAINTS.md
4. Document in system_constraints.md
5. Update API_MAP.md if affects libraries

**Criteria for Hard Constraint:**

- Security-critical
- System stability-critical
- Prevents known major issues
- Broadly applicable across codebase
- Has clear, objective criteria