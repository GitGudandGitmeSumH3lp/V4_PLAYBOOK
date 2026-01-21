PRE-VALIDATION CHECKLIST (V4.0)
Run this checklist BEFORE invoking the Architect

═══════════════════════════════════════════════════════════

CONTEXT AVAILABILITY CHECK
═══════════════════════════════════════════════════════════

[ ] Do I have _STATE.md?
    Location: _____________
    Last updated: _____________

[ ] Do I have docs/system_constraints.md?
    Location: _____________
    Contains forbidden libraries? Yes / No

[ ] Do I have docs/API_MAP_lite.md?
    Location: _____________
    Number of modules documented: _____

[ ] Do I have project_memory.md?
    Location: _____________
    Number of memory entries: _____
    Any relevant to this task? Yes / No

[ ] Do I have the feature specification?
    Location: _____________
    Contains interface sketches? Yes / No

═══════════════════════════════════════════════════════════
FEATURE REQUEST CLARITY CHECK
═══════════════════════════════════════════════════════════

[ ] Is the feature request specific?
    ❌ Vague: "Make auth better"
    ✅ Specific: "Add token refresh mechanism with 7-day expiry"

[ ] Are acceptance criteria defined?
    What does "done" look like?
    _____________________________________________
    _____________________________________________

[ ] Are integration points identified?
    What existing modules will this touch?
    _____________________________________________
    _____________________________________________

[ ] Are there any blockers or dependencies?
    List any unresolved issues:
    _____________________________________________
    _____________________________________________

═══════════════════════════════════════════════════════════
CONSTRAINT COMPLIANCE PRE-CHECK
═══════════════════════════════════════════════════════════

[ ] Does this feature require any NEW libraries?
    If yes, list them: _________________________
    Are they in system_constraints.md? Yes / No
    If no, need approval before proceeding.

[ ] Does this feature conflict with any memory entries?
    Checked project_memory.md? Yes / No
    Any conflicts found? Yes / No
    If yes, describe: __________________________

[ ] Does this feature violate any hard constraints?
    Checked RULES/HARD_CONSTRAINTS.md? Yes / No
    Any violations? Yes / No
    If yes, describe: __________________________

═══════════════════════════════════════════════════════════
ARCHITECT PREPARATION
═══════════════════════════════════════════════════════════

[ ] Have I created the verification command?
    Format: /verify-context: file1, file2, file3
    
    My verification command:
    /verify-context: _______________________________
                    _______________________________
                    _______________________________

[ ] Have I prepared all required files?
    Total files to provide: _____
    All files ready? Yes / No

[ ] Have I identified which account to use?
    Account C (Claude Sonnet) for Architect? Yes / No
    If no, why? ______________________________

═══════════════════════════════════════════════════════════
MEMORY SNIPPET PREPARATION
═══════════════════════════════════════════════════════════

[ ] Does this task require memory injection?
    Relevant keywords: _________________________
    Memory entries found: ______________________
    
[ ] Have I created _memory_snippet.txt?
    Location: __________________________________
    Number of entries: _________________________
    Included in verification command? Yes / No

═══════════════════════════════════════════════════════════
FINAL GO/NO-GO DECISION
═══════════════════════════════════════════════════════════

✅ GO - Proceed to Architect
   All checks passed. Ready to invoke Architect.

⚠️ CONDITIONAL GO - Proceed with warnings
   [ ] Missing optional files (document which): ____________
   [ ] Feature request needs minor clarification: _________
   [ ] Waiting on library approval: _____________________

❌ NO-GO - Do not proceed
   [ ] Missing critical files: ___________________________
   [ ] Feature violates constraints: _____________________
   [ ] Unclear requirements: _____________________________
   [ ] Dependency blockers: ______________________________

═══════════════════════════════════════════════════════════
NOTES / COMMENTS
═══════════════════════════════════════════════════════════

________________________________________________________
________________________________________________________
________________________________________________________
________________________________________________________

═══════════════════════════════════════════════════════════
TIMESTAMP
═══════════════════════════════════════════════════════════

Date: ________________  Time: ________________
Prepared by: ______________________________________

═══════════════════════════════════════════════════════════

NEXT STEP:
If ✅ GO → Invoke Architect (AGENTS/01_architect.md)
If ⚠️ CONDITIONAL → Resolve warnings, then proceed
If ❌ NO-GO → Resolve blockers before attempting