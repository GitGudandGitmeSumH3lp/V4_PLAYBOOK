# SKILL: REFLECTION LOGIC (V4.0)

**Type:** Core Quality Skill  
**Injectable Into:** Implementer, Architect, Refiner  
**Mandatory:** Yes (for all agents that generate artifacts)

---

## DESCRIPTION

This skill implements the "Draft & Critique" pattern for self-improving output quality. When injected, agents perform internal quality loops before outputting.

---

## THE REFLECTION PROTOCOL

### Core Principle

**NEVER output on first pass.** Always draft internally, critique against standards, and refine before producing final output.

### Iteration Limits

- **Maximum:** 2 iterations
- **Minimum:** 1 iteration
- **No exceptions:** Exit after 2 iterations regardless of state

---

## ITERATION 1: DRAFT & CRITIQUE

### Step 1: Draft (Mental Model)

Generate complete artifact in working memory. Do NOT output yet.

**For Code:**

- Write complete implementation
- Include all required methods
- Add basic error handling
- Ensure logic flow is complete

**For Contracts:**

- Define all interfaces
- Specify all constraints
- List all acceptance criteria
- Map all dependencies

**For Documentation:**

- Write all docstrings
- Add all type hints
- Include all examples
- Cover all edge cases

---

### Step 2: Multi-Dimensional Critique

Evaluate draft against ALL applicable standards:

#### A. CONTRACT COMPLIANCE (If Applicable)

```
Checklist:
- [ ] Every method in contract is implemented?
- [ ] Every signature matches exactly (names, types, params)?
- [ ] Return types match contract?
- [ ] Error handling matches contract?
- [ ] All acceptance criteria addressed?

Score: [X]/5
Issues Found: [List specific problems]
```

#### B. STYLE COMPLIANCE (Always)

```
Checklist:
- [ ] Naming conventions followed (snake_case, PascalCase)?
- [ ] Type hints present and complete?
- [ ] Docstrings formatted per style guide?
- [ ] Import organization correct?
- [ ] Line length within limits?

Score: [X]/5
Issues Found: [List specific problems]
```

#### C. IMPORT VALIDATION (For Code)

```
Checklist:
- [ ] Every import exists in API_MAP_lite.md OR stdlib?
- [ ] No hallucinated module names?
- [ ] No forbidden libraries from constraints?
- [ ] Imports organized correctly?

Score: [X]/4
Issues Found: [List specific problems]
```

#### D. MEMORY COMPLIANCE (If _memory_snippet.txt Exists)

```
Checklist:
- [ ] All memory rules applied?
- [ ] No violations of anti-patterns?
- [ ] Decisions aligned with memory?
- [ ] Patterns reused correctly?

Score: [X]/4
Issues Found: [List specific problems]
```

#### E. LOGIC & SAFETY (For Code)

```
Checklist:
- [ ] No infinite loops?
- [ ] All edge cases handled?
- [ ] Input validation present?
- [ ] Error messages clear and specific?
- [ ] No security anti-patterns?

Score: [X]/5
Issues Found: [List specific problems]
```

---

### Step 3: Decision Point

**Calculate Total Score:**

```
Total = Contract + Style + Imports + Memory + Logic
Pass Threshold = 100% (all checks ✅)
```

**IF ALL CHECKS PASS (Perfect Score):** → SKIP to Output Phase (no refinement needed)

**IF ANY CHECKS FAIL:** → Continue to Iteration 2 (Refinement)

---

## ITERATION 2: REFINEMENT

### Step 4: Apply Fixes

For each issue found in Iteration 1:

**High Priority (Fix First):**

1. Contract violations
2. Security issues
3. Memory violations
4. Import errors

**Medium Priority:** 5. Style violations 6. Missing documentation 7. Type hint issues

**Low Priority:** 8. Minor formatting 9. Comment improvements

### Step 5: Re-Critique

Run ALL checklists again:

- Contract Compliance: [X]/5
- Style Compliance: [X]/5
- Import Validation: [X]/4
- Memory Compliance: [X]/4
- Logic & Safety: [X]/5

**Total: [X]/23**

---

### Step 6: Final Decision

**IF PERFECT SCORE (23/23):** → Proceed to Output Phase

**IF NOT PERFECT (<23/23):** → Proceed to Output Phase ANYWAY (max 2 iterations) → Flag remaining issues in output

**LOOP EXIT:** Mandatory after iteration 2

---

## OUTPUT PHASE

### Primary Output

[The final artifact - code, contract, documentation, etc.]

### Reflection Log (Optional - For Debugging Only)

Only output if explicitly required by agent prompt or if flagging issues:

```markdown
## REFLECTION LOG

### Iteration 1 Results
**Contract Compliance:** [X]/5
- ✅/❌ [Check 1]: [Result]
- ✅/❌ [Check 2]: [Result]
[etc.]

**Issues Found:** [N]
**Decision:** [Proceed to Iteration 2 / Skip to Output]

### Iteration 2 Actions (If Performed)
**Fixes Applied:**
1. [Issue from Iteration 1] → [Fix description]
2. [Issue from Iteration 1] → [Fix description]

**Final Score:** [X]/23

**Remaining Issues (If Any):**
- ⚠️ [Issue that couldn't be fixed]
- ⚠️ [Issue that couldn't be fixed]
```

---

## INJECTION INSTRUCTIONS

### For Implementer (Code Generation)

```markdown
# INJECT: REFLECTION LOGIC

Before outputting code:

1. **DRAFT:** Write complete implementation mentally
2. **CRITIQUE:** Check against:
   - Contract (exact signatures)
   - Imports (all exist in API_MAP_lite.md)
   - Memory (all rules applied)
   - Style (type hints, naming)
   - Logic (edge cases, errors)
3. **REFINE:** Fix issues found (max 1 refinement pass)
4. **OUTPUT:** Final code + flag if issues remain

DO NOT output intermediate drafts.
DO NOT output detailed reflection logs (wastes tokens).
```

---

### For Architect (Contract Design)

```markdown
# INJECT: REFLECTION LOGIC

Before outputting contracts:

1. **DRAFT:** Write complete contract mentally
2. **CRITIQUE:** Check against:
   - System constraints (no forbidden patterns)
   - Memory compliance (no anti-patterns)
   - Interface completeness (all methods specified)
   - Acceptance criteria (testable)
3. **REFINE:** Fix issues found
4. **OUTPUT:** Final contract + work order

Focus on interface clarity and constraint enforcement.
```

---

### For Refiner (Documentation)

```markdown
# INJECT: REFLECTION LOGIC

Before outputting refined code:

1. **DRAFT:** Add all docs/style mentally
2. **CRITIQUE:** Check against:
   - Style guide (docstring format)
   - Accuracy (docs match actual behavior)
   - Completeness (all functions documented)
   - Safety (no logic changes)
3. **REFINE:** Fix issues found
4. **OUTPUT:** Refined code

CRITICAL: Verify no logic changes made.
```

---

## BEHAVIORAL RULES

### DO

- Draft internally before outputting
- Critique against ALL applicable standards
- Apply fixes systematically (high priority first)
- Exit after maximum 2 iterations
- Flag issues that couldn't be fixed

### DO NOT

- Output first draft directly
- Skip critique phase
- Perform more than 2 iterations
- Ignore contract violations
- Ignore security issues
- Continue iterating indefinitely

### CRITICAL: Token Optimization

For high-volume agents (Implementer, Refiner):

- Perform reflection SILENTLY
- Do NOT output iteration logs unless debugging
- Do NOT output detailed critique unless errors found
- Focus on producing final artifact efficiently

---

## REFLECTION DECISION TREE

```
START
  │
  ├─> ITERATION 1
  │     ├─> Draft artifact mentally
  │     ├─> Critique (5 dimensions)
  │     ├─> Calculate score
  │     │
  │     └─> Score = 100%?
  │           ├─> YES → OUTPUT (skip iteration 2)
  │           └─> NO  → Continue to ITERATION 2
  │
  ├─> ITERATION 2
  │     ├─> Apply fixes (priority order)
  │     ├─> Re-critique
  │     ├─> Calculate final score
  │     │
  │     └─> OUTPUT (regardless of score)
  │           ├─> If score < 100%: FLAG issues
  │           └─> If score = 100%: Clean output
  │
  └─> END (max 2 iterations)
```

---

## QUALITY METRICS

### Success Metrics

- **Perfect First Pass:** Score 100% on iteration 1 (skip iteration 2)
- **Successful Refinement:** Score improved from iteration 1 to 2
- **Acceptable Output:** Score ≥85% after iteration 2

### Failure Metrics

- **Critical Failure:** Score <70% after iteration 2
- **Contract Violation:** Any contract check fails after iteration 2
- **Security Violation:** Any security check fails after iteration 2

---

## INTEGRATION WITH OTHER SKILLS

### Security Hardening

Add to Logic & Safety critique:

```
- [ ] No hardcoded secrets?
- [ ] Input validation present?
- [ ] No SQL injection vectors?
- [ ] No path traversal vulnerabilities?
```

### Python Strict Typing

Add to Style Compliance critique:

```
- [ ] All functions have type hints?
- [ ] Collections are parameterized?
- [ ] Optional types used correctly?
- [ ] No bare list/dict?
```

---

## EXAMPLE: IMPLEMENTER USING REFLECTION

```python
# ITERATION 1 (Mental - Not Output)

# Draft:
def process_user(user_id: str) -> dict:
    user = database.query(f"SELECT * FROM users WHERE id={user_id}")
    return user

# Critique:
# ❌ Contract: Missing type hints on return (should be dict[str, Any])
# ❌ Security: SQL injection vulnerability
# ❌ Logic: No error handling for missing user
# Score: 0/5 Contract, 2/5 Style, 4/4 Imports, 2/5 Logic = 8/19
# Decision: Proceed to Iteration 2

# ITERATION 2 (Mental - Not Output)

# Refined:
def process_user(user_id: str) -> dict[str, Any]:
    if not user_id or not user_id.isalnum():
        raise ValueError("Invalid user ID")
    
    user = database.query("SELECT * FROM users WHERE id=?", (user_id,))
    
    if not user:
        raise UserNotFoundError(f"User {user_id} not found")
    
    return user

# Re-critique:
# ✅ Contract: Matches signature
# ✅ Security: Parameterized query, input validation
# ✅ Logic: Error handling present
# ✅ Style: Type hints complete
# Score: 19/19
# Decision: Output

# OUTPUT PHASE
[Output the refined code above]
```