# WORKFLOW: MODULAR LEGACY INTEGRATION PIPELINE (V4.0)

**Version:** Modular 3-Phase Pipeline  
**Purpose:** Systematic brownfield-to-greenfield transformation  
**Complexity:** Intermediate  
**Recommended Team Size:** 1-2 developers  
**Time Per Module:** 30-60 minutes (vs 20-45 min monolithic)

---

## OVERVIEW

### The Problem Solved

The original monolithic `legacy_integrator.md` suffered from **"lost in the middle" syndrome**:
- Large files overwhelmed single-pass analysis
- Quality degraded with complexity
- All-or-nothing approach (succeed completely or fail)
- Difficult to debug which analysis step failed

### The Modular Solution

**3-Phase Pipeline Architecture:**

```
Phase 1: DISCOVERY (Gemini Flash - Fast)
   ↓ [Structural JSON]
Phase 2: FORENSICS (Claude Sonnet - Deep)
   ↓ [Behavioral Analysis]
Phase 3: CONTRACT GEN (Gemini Flash - Synthesis)
   ↓ [V4.0 Contract + Report]
```

**Key Advantages:**
- ✅ Each phase focuses on ONE task (better accuracy)
- ✅ Large files can be processed incrementally
- ✅ Failures are isolated (easier to debug)
- ✅ Parallel processing possible (forensics can run per-method)
- ✅ Model-optimized (fast models for structure, smart models for logic)

---

## WHEN TO USE MODULAR VS MONOLITHIC

### Use MODULAR Pipeline (This Workflow) When:

✅ Files are > 300 lines  
✅ Code is complex or poorly documented  
✅ You need high accuracy (critical modules)  
✅ You're integrating incrementally (one method at a time)  
✅ Previous monolithic integration produced low-quality results  
✅ You have 3+ accounts available (can parallelize)  

### Use MONOLITHIC Legacy Integrator When:

✅ Files are < 200 lines  
✅ Code is simple and well-structured  
✅ You need speed over depth  
✅ You're doing bulk integration (many small files)  
✅ You only have 1 account available  

**Rule of Thumb:** Modular for quality, Monolithic for speed.

---

## THE COMPLETE WORKFLOW

### Prerequisites

**Required Utilities:**
- ✅ `UTILS/legacy_integration/01_discovery.md`
- ✅ `UTILS/legacy_integration/02_forensics.md`
- ✅ `UTILS/legacy_integration/03_contract_gen.md`

**Required Accounts:**
- **Account A:** Gemini Flash (Phases 1 & 3)
- **Account C:** Claude Sonnet (Phase 2)

**Required Context Files:**
- `docs/system_constraints.md`
- `docs/API_MAP_lite.md`

**Optional but Recommended:**
- `docs/project_memory.md` (for recording anti-patterns)

---

## PHASE 1: DISCOVERY (5-10 minutes)

### Goal
Extract structural skeleton without analyzing logic.

### Account Setup
```
Account: Gemini Flash (Account A)
Temperature: 0.1 (maximum precision)
Load: UTILS/legacy_integration/01_discovery.md
```

### Input Prompt
```markdown
/discover-structure
File: src/user_service.py
Language: python

[PASTE ENTIRE SOURCE CODE HERE]
```

### Expected Output

**Two artifacts:**

1. **JSON Discovery Data:**
   ```json
   {
     "metadata": {...},
     "imports": [...],
     "classes": [...],
     "public_methods": [...],
     "summary": {...}
   }
   ```

2. **Human-Readable Summary:**
   ```markdown
   # DISCOVERY REPORT
   - 3 imports
   - 1 class (UserService)
   - 5 public methods
   - ⚠️ Global state detected
   ```

### Success Criteria
- [ ] All public methods listed with line numbers
- [ ] All imports captured
- [ ] Global state flagged (if present)
- [ ] Method signatures extracted exactly

### Common Issues

**Issue:** "File too large"  
**Solution:** Discovery should handle up to 2000 lines. If larger, split file first.

**Issue:** "Syntax errors detected"  
**Solution:** Fix syntax in original code before proceeding.

**Issue:** "Language not supported"  
**Solution:** Currently supports Python, JS, TS, Java, Rust, Go. For others, manual contract creation required.

### Save Output
```
Discovery Data → discovery_[module].json
Summary → discovery_[module]_summary.md
```

**CHECKPOINT:** Do NOT proceed to Phase 2 if discovery failed.

---

## PHASE 2: FORENSICS (15-30 minutes)

### Goal
Deep analysis of behavior, dependencies, and technical debt.

### Account Setup
```
Account: Claude Sonnet (Account C)
Temperature: 0.3 (balanced reasoning)
Load: UTILS/legacy_integration/02_forensics.md
```

### Decision Point: Full File vs Per-Method

**For Small Files (< 300 lines):**

```markdown
/analyze-forensics

Discovery Data:
[PASTE discovery_[module].json]

Source Code:
[PASTE ENTIRE SOURCE CODE]
```

**For Large Files (> 300 lines):**

Analyze methods individually:

```markdown
/analyze-forensics-method

Method: get_user (Line 25)

Discovery Entry:
{
  "line": 25,
  "name": "get_user",
  "signature": "def get_user(self, user_id: int) -> dict",
  "class": "UserService"
}

Source Code (Method Only):
def get_user(self, user_id: int) -> dict:
    """Retrieve user by ID."""
    if user_id <= 0:
        raise ValueError(f"Invalid user_id: {user_id}")
    
    try:
        result = session.execute(f"SELECT * FROM users WHERE id={user_id}")
        row = result.fetchone()
        return self._row_to_dict(row) if row else None
    except DatabaseError as e:
        logging.error(f"Database error: {e}")
        raise

Context:
- Global variables: session
- Imports: logging, DatabaseError
```

**Then repeat for each method.**

### Expected Output

**Per-Method Forensics Report:**

```markdown
## METHOD: get_user

### BEHAVIOR SPECIFICATION
[Detailed behavior analysis]

### SIDE EFFECTS
[Database reads, logging, etc.]

### DEPENDENCIES
[What this calls]

### ERROR HANDLING
[Implemented and missing cases]

### TECHNICAL DEBT
🔴 CRITICAL: [Security/correctness issues]
🟡 HIGH: [Important issues]
🟠 MEDIUM: [Nice to fix]
🔵 LOW: [Optional improvements]

### BEHAVIORAL QUIRKS
[Gotchas and edge cases]
```

**Plus Aggregate Analysis:**

```markdown
## AGGREGATE ANALYSIS

Total Methods: 5
Critical Issues: 1 (SQL injection in update_user)
Overall Debt Level: 🔴 CRITICAL

Recommended Action: ❌ DO NOT PROCEED (fix security issue)
```

### Success Criteria
- [ ] Each method analyzed for behavior
- [ ] All dependencies mapped
- [ ] Technical debt catalogued with severity
- [ ] Security issues flagged prominently
- [ ] Integration decision provided (SAFE/WARNINGS/BLOCKED)

### Common Issues

**Issue:** "Cannot determine behavior"  
**Solution:** Provide additional context (what the module does in production, domain knowledge).

**Issue:** "Method too complex to analyze"  
**Solution:** This is a signal the code needs refactoring. Document complexity, mark for rewrite.

**Issue:** "Critical security issue found"  
**Solution:** STOP. Fix the security issue in original code, then re-run forensics.

### Save Output
```
Forensics Report → forensics_[module].md
```

### CRITICAL CHECKPOINT

**If forensics reports 🔴 CRITICAL or BLOCKING issues:**

❌ **STOP - DO NOT PROCEED TO PHASE 3**

**Required Actions:**
1. Fix critical issues in original source code
2. Re-run Phase 2 (forensics) on fixed code
3. Verify issues resolved
4. Then proceed to Phase 3

**Alternative Path (Not Recommended):**
- Proceed to Phase 3 anyway
- Contract will be marked "🔴 UNSAFE - DO NOT INTEGRATE"
- Module cannot be used in V4.0 system until fixed

---

## PHASE 3: CONTRACT GENERATION (10-15 minutes)

### Goal
Synthesize Discovery + Forensics into V4.0-compliant contract.

### Account Setup
```
Account: Gemini Flash (Account A)
Temperature: 0.1 (maximum precision)
Load: UTILS/legacy_integration/03_contract_gen.md
```

### Input Prompt
```markdown
/generate-contract

Discovery Data (from Phase 1):
[PASTE discovery_[module].json]

Forensics Report (from Phase 2):
[PASTE forensics_[module].md]

Additional Context (optional):
- Original file path: src/user_service.py
- Known issues: SQL injection in update_user method (P0)
- Domain context: User management for authentication system
```

### Expected Output

**Two artifacts:**

1. **Full V4.0 Legacy Contract:**
   ```markdown
   # CONTRACT: UserService (LEGACY)
   
   [Complete contract with all sections]
   - Purpose
   - Public Interface
   - Dependencies
   - Technical Debt
   - Acceptance Criteria
   - Migration Roadmap
   - Integration Status
   ```

2. **Migration Report:**
   ```markdown
   # MIGRATION REPORT
   
   Integration Status: 🔴 BLOCKED
   Reason: Critical SQL injection vulnerability
   Required Actions: [Fix list]
   Next Steps: [Action plan]
   ```

### Success Criteria
- [ ] Contract has all required sections
- [ ] All methods from discovery are documented
- [ ] All forensics findings are included
- [ ] Technical debt is prioritized (P0/P1/P2/P3)
- [ ] Clear integration decision provided
- [ ] Migration roadmap included (if needed)

### Common Issues

**Issue:** "Missing forensics data"  
**Solution:** Ensure all methods were analyzed in Phase 2. Re-run forensics for missing methods.

**Issue:** "Contradictory data"  
**Solution:** Contract generator will document the contradiction and recommend manual review.

**Issue:** "Contract too large"  
**Solution:** This is expected for large modules. Contract can be 1000+ lines for complex code.

### Save Output
```
Contract → contracts/legacy_[module].md
Migration Report → reports/migration_[module].md
```

### Integration Decision Matrix

| Forensics Result | Contract Status | Action |
|-----------------|----------------|---------|
| No Critical Issues | ✅ SAFE TO INTEGRATE | Proceed to mapping |
| P1-P2 Issues Only | ⚠️ INTEGRATE WITH WARNINGS | Proceed with monitoring |
| P0 Critical Issues | 🔴 DO NOT INTEGRATE | Fix issues, re-run pipeline |
| Security Vulnerabilities | 🔴 UNSAFE | Mandatory fix before integration |

---

## POST-PIPELINE INTEGRATION (15-20 minutes)

### Step 1: Context Mapping (5 min)

**Goal:** Register module in V4.0 ecosystem

**Account:** Gemini Pro (Account B)  
**Load:** `UTILS/map_generator.md`

**Input:**
```markdown
/update-map

New Module Integration:
[PASTE contracts/legacy_[module].md]

Current Map:
[PASTE docs/API_MAP_lite.md]
```

**Output:**
- Updated `docs/API_MAP_lite.md` with legacy module entry

**Verification:**
- [ ] Module listed in API_MAP_lite.md
- [ ] Dependencies correctly linked
- [ ] Legacy flag (⚠️) present

---

### Step 2: Memory Recording (3 min)

**Goal:** Document anti-patterns to avoid in future code

**When Required:**
- Technical debt includes systemic anti-patterns
- Global state usage detected
- Security vulnerabilities found (now fixed)

**Manual Edit:** `docs/project_memory.md`

**Example Entry:**
```markdown
## [2026-01-22] Legacy Anti-Pattern: Global Database Session

**Context:** During integration of `user_service`, found all methods using global `session` variable.

**Rule:** New V4.0 modules MUST use dependency injection for database connections.

**Bad (Legacy Pattern):**
```python
def get_user(user_id):
    return session.query(User).get(user_id)
```

**Good (V4.0 Pattern):**
```python
def get_user(user_id: int, db: Session) -> User:
    return db.query(User).get(user_id)
```

**Applies to:** All new implementations via 02_implementer.md
```

---

### Step 3: Validation (10 min)

**Goal:** Verify contract matches reality

**Account:** GPT-4 (Account D)  
**Load:** `AGENTS/05_auditor.md`

**Input:**
```markdown
/audit-legacy-contract

Contract to Validate:
[PASTE contracts/legacy_[module].md]

Original Source Code:
[PASTE original source file]

Verification Checklist:
- Contract signatures match code?
- Behaviors accurately described?
- Dependencies correctly mapped?
- Technical debt honestly catalogued?
```

**Possible Outcomes:**

✅ **APPROVED:**
```
âœ… CONTRACT APPROVED
Status: Ready for production use
```

🔄 **CORRECTIONS NEEDED:**
```
🔄 MINOR CORRECTIONS REQUIRED
Issues:
1. Method signature mismatch on line X
2. Missing dependency: module_y

Action: Update contract, re-submit for approval
```

❌ **REJECTED:**
```
❌ CONTRACT REJECTED
Critical Inaccuracies:
1. [Issue]
2. [Issue]

Action: Re-run Phase 2 (Forensics) with corrections
```

---

### Step 4: Code Tagging (2 min)

**Goal:** Link original code to contract

**Manual Edit:** Add header to original source file

**Python:**
```python
"""
V4.0 MODULAR LEGACY INTEGRATION
Contract: docs/contracts/legacy_user_service.md v1.0
Integration Date: 2026-01-22
Pipeline: 3-Phase Modular (Discovery → Forensics → Contract Gen)
Status: ✅ Integrated

⚠️ LEGACY MODULE
Technical Debt Level: Medium
Refactor Priority: P1-High
See contract for details.
"""
```

---

## INTEGRATION COMPLETE ✅

### What You Now Have

**Before Pipeline:**
- ❌ Code without documentation
- ❌ Unknown behavior and quirks
- ❌ Unmapped dependencies
- ❌ Hidden technical debt

**After Pipeline:**
- ✅ Complete V4.0 contract (`contracts/legacy_[module].md`)
- ✅ Behavioral analysis (`reports/migration_[module].md`)
- ✅ Registered in API map (`docs/API_MAP_lite.md`)
- ✅ Anti-patterns documented (`docs/project_memory.md`)
- ✅ Auditor approval (from `05_auditor.md`)
- ✅ Original code tagged

### What You Can Now Do

1. **Safe Refactoring:**
   - Use `02_implementer.md` with contract as spec
   - Make changes without breaking callers
   - Contract defines the boundary

2. **Testing:**
   - Use acceptance criteria from contract
   - Verify behavior matches documented quirks
   - Test both happy path and error cases

3. **Integration:**
   - New modules can call this one safely
   - Dependencies are known and documented
   - Breaking changes are preventable

4. **Planning:**
   - Migration roadmap provides clear path
   - Technical debt is prioritized
   - Effort estimates are available

---

## MODULAR PIPELINE ADVANTAGES

### vs Monolithic Integration

| Aspect | Monolithic | Modular (3-Phase) |
|--------|-----------|-------------------|
| **Speed** | Faster (20-45 min) | Slower (30-60 min) |
| **Accuracy** | Good for simple files | Excellent for complex files |
| **Large Files** | Struggles > 500 lines | Handles > 2000 lines |
| **Debugging** | Hard to pinpoint failures | Easy (isolated phases) |
| **Incremental** | All-or-nothing | Can process per-method |
| **Parallelization** | No | Yes (forensics per-method) |
| **Quality** | Sufficient | Superior |

**Recommendation:** Use modular for critical modules, monolithic for bulk integration.

---

## ADVANCED PATTERNS

### Pattern 1: Parallel Forensics (Large Files)

**Scenario:** 1500-line file with 20 methods

**Strategy:**
1. Run Phase 1 (Discovery) - get all 20 method signatures
2. Divide methods across multiple sessions:
   - Session A: Methods 1-7
   - Session B: Methods 8-14
   - Session C: Methods 15-20
3. Merge forensics reports
4. Run Phase 3 with combined data

**Time Savings:** 45 minutes → 20 minutes (parallelized)

---

### Pattern 2: Iterative Refinement

**Scenario:** Initial forensics identifies critical issues

**Strategy:**
1. Phase 1: Discovery (unchanged)
2. Phase 2: Forensics → finds P0 SQL injection
3. **FIX CODE** (patch vulnerability)
4. Phase 2: Re-run forensics on fixed code
5. Phase 3: Generate contract from corrected analysis

**Benefit:** Contract reflects fixed code, not broken code

---

### Pattern 3: Incremental Integration (Massive Projects)

**Scenario:** Integrating 50-file legacy system

**Strategy:**

**Week 1:** Dependency Leaves (no dependencies)
- Run pipeline on 10 leaf modules
- Learn process, build confidence

**Week 2:** Mid-Tier (depend on leaves)
- Run pipeline on 15 mid-tier modules
- Now can reference leaf contracts

**Week 3:** Core Components
- Run pipeline on 10 core modules
- Complex but now have context

**Week 4:** Root Modules
- Run pipeline on remaining 15
- Complete ecosystem

**Week 5:** Full System Audit
- Run 05_auditor on all contracts
- Verify system coherence

**Total Time:** 5 weeks vs 3+ months for full rewrite

---

## TROUBLESHOOTING

### Pipeline Failure Diagnosis

**Symptom:** Phase 1 fails  
**Diagnosis:** Syntax errors or unsupported language  
**Fix:** Correct syntax, verify language support

**Symptom:** Phase 2 produces shallow analysis  
**Diagnosis:** Insufficient context or method too complex  
**Fix:** Provide domain context, consider manual analysis supplement

**Symptom:** Phase 3 generates incomplete contract  
**Diagnosis:** Missing forensics data  
**Fix:** Re-run Phase 2, ensure all methods analyzed

**Symptom:** Auditor rejects contract  
**Diagnosis:** Contract doesn't match code reality  
**Fix:** Re-run Phase 2 with corrections, regenerate contract

---

### Quality Assurance Checks

**After Phase 1:**
- [ ] Method count matches manual count
- [ ] No public methods missing
- [ ] Global state flagged if present

**After Phase 2:**
- [ ] Every method has behavior description
- [ ] Technical debt severity is realistic
- [ ] Security issues prominently flagged

**After Phase 3:**
- [ ] Contract has all required sections
- [ ] Integration decision is clear
- [ ] Migration roadmap exists (if needed)

---

## TEAM WORKFLOW

### Single Developer

**Time:** 30-60 min per module

**Process:**
1. Phase 1 (Gemini Flash) - 5 min
2. Phase 2 (Claude Sonnet) - 20 min
3. Phase 3 (Gemini Flash) - 10 min
4. Post-pipeline (Map, Memory, Audit, Tag) - 15 min

**Advantage:** Full control, deep understanding

---

### Two Developers (Parallel)

**Time:** 20-30 min per module

**Developer A:**
- Runs Phase 1 (Discovery)
- Runs Phase 3 (Contract Gen)
- Updates API Map
- Tags code

**Developer B:**
- Runs Phase 2 (Forensics)
- Updates Project Memory
- Runs Auditor

**Advantage:** Faster throughput, cross-validation

---

### Team of 3+ (Assembly Line)

**Time:** 15-20 min per module (sustained rate)

**Developer A:** Discovery Pipeline
- Queues: 5 files for discovery
- Outputs: 5 JSON packages

**Developer B:** Forensics Pipeline
- Receives: JSON from Dev A
- Outputs: 5 Forensics reports

**Developer C:** Contract Pipeline
- Receives: JSON + Forensics
- Outputs: 5 Contracts + Reports

**Developer D:** Integration Pipeline
- Receives: Contracts
- Outputs: Mapped, Audited, Tagged

**Advantage:** Maximum throughput (20+ modules/day)

---

## SUCCESS METRICS

### Pipeline Quality

**Excellent Integration:**
- Discovery: 100% method coverage
- Forensics: All debt catalogued honestly
- Contract: A