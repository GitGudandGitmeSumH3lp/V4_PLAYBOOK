POST-IMPLEMENTATION AUDIT (V4.0)
Run this checklist AFTER Implementer/Refiner, BEFORE Auditor

═══════════════════════════════════════════════════════════

BASIC SANITY CHECKS
═══════════════════════════════════════════════════════════

[ ] Does the code file exist?
    File path: ______________________________________
    File size: __________ lines

[ ] Does the code compile/parse?
    Syntax errors? Yes / No
    If yes, return to Implementer immediately.

[ ] Are there obvious placeholder comments?
    [ ] "TODO" found? Yes / No
    [ ] "FIXME" found? Yes / No
    [ ] "HACK" found? Yes / No
    If yes, these must be resolved before Auditor.

═══════════════════════════════════════════════════════════
IMPORT VALIDATION CHECK
═══════════════════════════════════════════════════════════

[ ] List all imports in the code:
    1. _______________________________________________
    2. _______________________________________________
    3. _______________________________________________
    4. _______________________________________________
    5. _______________________________________________

[ ] Are all imports in API_MAP_lite.md OR standard library?
    Checked each import? Yes / No
    Any hallucinated imports? Yes / No
    If yes, which: ___________________________________

[ ] Are there any forbidden library imports?
    Checked against HARD_CONSTRAINTS.md? Yes / No
    Any violations? Yes / No
    If yes, which: ___________________________________

═══════════════════════════════════════════════════════════
CONTRACT COMPLIANCE QUICK CHECK
═══════════════════════════════════════════════════════════

[ ] Contract file available?
    File path: ______________________________________

[ ] Quick signature comparison:
    
    Method 1 from contract: _________________________
    Method 1 in code exists? Yes / No
    Signature matches? Yes / No
    
    Method 2 from contract: _________________________
    Method 2 in code exists? Yes / No
    Signature matches? Yes / No
    
    [Repeat for critical methods]
    
    All methods present? Yes / No
    If no, return to Implementer.

═══════════════════════════════════════════════════════════
TYPE HINT SPOT CHECK
═══════════════════════════════════════════════════════════

[ ] Random function check 1:
    Function name: __________________________________
    All parameters have type hints? Yes / No
    Return type specified? Yes / No

[ ] Random function check 2:
    Function name: __________________________________
    All parameters have type hints? Yes / No
    Return type specified? Yes / No

[ ] Overall impression:
    Type hints seem complete? Yes / No / Partially
    If no/partially, note for Auditor: ______________

═══════════════════════════════════════════════════════════
SECURITY QUICK SCAN
═══════════════════════════════════════════════════════════

[ ] Search for hardcoded secrets:
    Pattern: [A-Za-z0-9]{20,} in strings
    Found suspicious strings? Yes / No
    If yes, flag for immediate review: ______________

[ ] Search for SQL concatenation:
    Pattern: f"SELECT * FROM {variable}"
    Found? Yes / No
    If yes, CRITICAL - return to Implementer.

[ ] Search for dangerous functions:
    [ ] eval() found? Yes / No
    [ ] exec() found? Yes / No
    [ ] os.system() found? Yes / No
    If any yes, CRITICAL - return to Implementer.

═══════════════════════════════════════════════════════════
ERROR HANDLING SPOT CHECK
═══════════════════════════════════════════════════════════

[ ] Are there try-except blocks?
    Count: _____
    
[ ] Do exceptions have specific types?
    Bare "except:" found? Yes / No
    If yes, note for Auditor: ____________________

[ ] Do error messages expose sensitive info?
    Any stack traces in user-facing errors? Yes / No
    If yes, CRITICAL issue.

═══════════════════════════════════════════════════════════
DOCUMENTATION COMPLETENESS (If Refiner was run)
═══════════════════════════════════════════════════════════

[ ] Public functions have docstrings?
    Spot check count: _____
    All have docstrings? Yes / No / Partially

[ ] Docstrings follow style guide format?
    Format used: Google / NumPy / Sphinx / Other
    Matches system_style.md? Yes / No

═══════════════════════════════════════════════════════════
MEMORY COMPLIANCE SPOT CHECK
═══════════════════════════════════════════════════════════

[ ] Was _memory_snippet.txt provided to Implementer?
    Yes / No
    
    If yes:
    [ ] Memory entry 1: ______________________________
        Evidence of compliance in code? Yes / No
        
    [ ] Memory entry 2: ______________________________
        Evidence of compliance in code? Yes / No

═══════════════════════════════════════════════════════════
AUDITOR PREPARATION
═══════════════════════════════════════════════════════════

[ ] Which Auditor tier to use?
    [ ] Free (Gemini 2.0 Flash Thinking) - First attempt
    [ ] Premium (Claude Sonnet 4) - After 2+ failures
    
[ ] Have I prepared all files for Auditor?
    [ ] system_style.md
    [ ] contracts/[target].md
    [ ] src/[new_code].py
    [ ] _memory_snippet.txt (if applicable)

[ ] Have I created the verification command?
    /verify-context: _______________________________
                    _______________________________
                    _______________________________

═══════════════════════════════════════════════════════════
CRITICAL ISSUES FOUND
═══════════════════════════════════════════════════════════

If ANY of these are checked, DO NOT proceed to Auditor.
Return to Implementer immediately.

[ ] Syntax errors
[ ] Hallucinated imports
[ ] Forbidden library usage
[ ] SQL injection vulnerability
[ ] Command injection vulnerability
[ ] Hardcoded secrets
[ ] Missing critical methods from contract
[ ] Security function usage (eval, exec, etc.)

Describe critical issues:
________________________________________________________
________________________________________________________
________________________________________________________

═══════════════════════════════════════════════════════════
DECISION
═══════════════════════════════════════════════════════════

✅ PROCEED TO AUDITOR
   All basic checks passed. Ready for formal audit.
   Use: [ ] Free Auditor [ ] Premium Auditor

⚠️ MINOR ISSUES - STILL PROCEED
   Non-critical issues found, but code is functional.
   Note for Auditor: ___________________________________
   ____________________________________________________

❌ CRITICAL ISSUES - DO NOT PROCEED
   Must return to Implementer to fix:
   1. ________________________________________________
   2. ________________________________________________
   3. ________________________________________________

═══════════════════════════════════════════════════════════
AUDIT HISTORY (For tracking escalations)
═══════════════════════════════════════════════════════════

Attempt 1: Date ________ Auditor: Free / Premium
Result: Pass / Conditional / Fail
Issues: ________________________________________________

Attempt 2: Date ________ Auditor: Free / Premium
Result: Pass / Conditional / Fail
Issues: ________________________________________________

Attempt 3: Date ________ Auditor: Free / Premium
Result: Pass / Conditional / Fail
Issues: ________________________________________________

[If 3+ attempts with Free Auditor, escalate to Premium]

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
Reviewed by: ______________________________________

═══════════════════════════════════════════════════════════

NEXT STEP:
If ✅ PROCEED → Invoke Auditor (AGENTS/05_auditor.md)
If ⚠️ MINOR → Proceed with notes for Auditor
If ❌ CRITICAL → Return to Implementer with issues list