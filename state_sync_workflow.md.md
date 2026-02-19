# 📦 STATE SYNC WORKFLOW DOCUMENTATION

---

```markdown
---
title: "State Sync Workflow (V4.2.1)"
tags: [workflow, state-management, persistence, orchestrator]
version: "4.2.1"
purpose: "Complete guide to automatic state synchronization in the V4.2.1 orchestrator workflow"
audience: "Project operator using multi-agent orchestration"
---

# STATE SYNC WORKFLOW (V4.2.1)

## 🎯 CORE PRINCIPLE

**"Every move logs itself before the next move starts."**

This ensures:
- ✅ Zero context loss across sessions
- ✅ Perfect Baton Pass coherence
- ✅ Audit trail of all decisions
- ✅ Recovery from failures
- ✅ Multi-session continuity

---

## 🔄 THE SYNC LOOP (Visual)

```

┌─────────────────────────────────────────────────────────┐ │ 1. ORCHESTRATOR: Generate Agent Packet │ │ - Selects appropriate agent │ │ - Builds verification command │ │ - Specifies exact files needed │ │ - Creates precise prompt │ └──────────────────┬──────────────────────────────────────┘ │ ▼ ┌─────────────────────────────────────────────────────────┐ │ 2. OPERATOR: Execute Agent Task │ │ - Copy verification command │ │ - Paste to chosen model/provider │ │ - Copy exact files specified │ │ - Paste prompt │ │ - Capture output │ └──────────────────┬──────────────────────────────────────┘ │ ▼ ┌─────────────────────────────────────────────────────────┐ │ 3. OPERATOR: Report Outcome to Orchestrator │ │ - "Task completed successfully" OR │ │ - "Failed with error: [description]" OR │ │ - Paste relevant output/error messages │ └──────────────────┬──────────────────────────────────────┘ │ ▼ ┌─────────────────────────────────────────────────────────┐ │ 4. ORCHESTRATOR: Auto-Generate State Update Packet │ │ - Analyzes what was completed │ │ - Lists files created/modified │ │ - Identifies checklist items to update │ │ - Notes any new blockers │ │ - Outputs complete State Update Packet │ └──────────────────┬──────────────────────────────────────┘ │ ▼ ┌─────────────────────────────────────────────────────────┐ │ 5. OPERATOR: Execute State Update │ │ - Copy State Update prompt │ │ - Paste to Local Qwen OR ChatGPT 4o-mini │ │ - Paste current _STATE.md contents │ │ - Copy updated _STATE.md output │ │ - Replace _STATE.md file │ └──────────────────┬──────────────────────────────────────┘ │ ▼ ┌─────────────────────────────────────────────────────────┐ │ 6. OPERATOR: Confirm Sync to Orchestrator │ │ - Message: "State synced to [timestamp]" │ │ - Orchestrator verifies confirmation │ │ - Ready for next move │ └──────────────────┬──────────────────────────────────────┘ │ ▼ [LOOP REPEATS]

````

---
"Generate a Meta-Baton Pass to transfer orchestration to a new context window"

## 🔍 SESSION DISCOVERIES (Context-Only) - **Attempted:** [Approach X] - Failed due to [reason] - **Learned:** [Insight Y] - Affects future [task] - **Decided:** Using [Strategy Z] instead of [Alternative] ```

# STEP 0: PRE-FLIGHT (Do This First)
Ask current orchestrator:
1. "Flush session to State update block"
2. "List session discoveries not in State"
3. "Generate Meta-Baton Pass with session notes"

# STEP 1: Update Your Files
- Apply State update to `_STATE.md`
- Save session notes to `docs/session_notes/YYYY-MM-DD.md`

# STEP 2: Generate Baton Pass
(Now includes fresh State + session context)

# STEP 3: Transfer to New Context
Paste: Orchestrator Seed + Baton Pass + Current _STATE.md

---

## 📋 DETAILED STEP BREAKDOWN

### **Step 1: Orchestrator Generates Agent Packet**

**What happens:**
- Orchestrator analyzes pending tasks from `_STATE.md`
- Selects appropriate agent based on task type
- Constructs packet following OUTPUT TEMPLATE format
- Includes verification command, file paths, and precise prompt

**Example Output:**
```markdown
# 🟢 ORCHESTRATION REPORT

## 📊 STATUS CHECK
**Current Phase:** DESIGN
**State Health:** ✅ Synced
**Last Sync:** 2025-02-12 14:30:00

## 👉 TACTICAL MOVE: Create Service Contract
**Agent:** `[[01_architect]]`
**Provider:** Claude Sonnet (or GLM 4.5)

## 📦 PACKET CONSTRUCTION

**1. Verification Command:**
/verify-context: system_constraints.md, specs/lidar_integration.md

**2. Files to Copy:**
- F:\PORTFOLIO\ps_rcs_project\docs\system_constraints.md
- F:\PORTFOLIO\ps_rcs_project\docs\specs\lidar_integration.md

**3. Prompt:**
Design a contract for LidarManager service following the attached spec and system constraints.
````

---

### **Step 2: Operator Executes Agent Task**

**What you do:**

1. Open your chosen provider (Claude.ai, DeepSeek web, etc.)
2. Paste the verification command first
3. Attach/paste the exact files listed
4. Paste the prompt
5. Review output for quality
6. Save output if it's a file (contract, code, etc.)

**Example Execution:**

```
[In Claude Sonnet]

/verify-context: system_constraints.md, specs/lidar_integration.md

[Paste system_constraints.md contents]
[Paste lidar_integration.md contents]

Design a contract for LidarManager service following the attached spec and system constraints.

[Claude generates contract]
[Save as docs/contracts/lidar_manager.md]
```

---

### **Step 3: Operator Reports Outcome**

**What you do:** Return to orchestrator and report results.

**Success Example:**

```
Contract created successfully. Saved as:
F:\PORTFOLIO\ps_rcs_project\docs\contracts\lidar_manager.md
```

**Failure Example:**

```
Agent failed with error: "Contract conflicts with existing ROS2Manager interface.
Needs clarification on node lifecycle handling."
```

**Partial Success:**

```
Contract created but needs refinement. Agent suggested using async/await
instead of callbacks. Should we proceed or revise spec first?
```

---

### **Step 4: Orchestrator Auto-Generates State Update**

**What happens:**

- Orchestrator analyzes your outcome report
- Extracts what was accomplished
- Identifies files created/modified
- Determines checklist updates needed
- Generates complete State Update Packet

**Example Output:**

```markdown
---
🔄 STATE UPDATE REQUIRED

**Agent:** `[[state_updater]]`
**Provider:** Local Qwen / ChatGPT 4o-mini

📦 PACKET FOR STATE UPDATER:

**1. Verification Command:**
/verify-context: _STATE.md

**2. Files to Copy:**
- F:\PORTFOLIO\ps_rcs_project\_STATE.md

**3. Prompt:**
You are the State Scribe for PS_RCS_PROJECT. Update `_STATE.md` with the following changes:

COMPLETED TASKS:
- Created LidarManager contract - 2025-02-12 14:45:00 - Success

FILES CREATED/MODIFIED:
- `docs/contracts/lidar_manager.md` - Service contract for LIDAR integration

CHECKLIST UPDATES:
- Mark complete: "Design LidarManager contract"
- Add new pending: "Implement LidarManager class per contract"

BLOCKERS/ISSUES:
- None

PHASE STATUS:
- Phase transition: DESIGN → BUILD

---
INSTRUCTIONS:
1. Read the current _STATE.md pasted below
2. Apply the updates listed above
3. Maintain existing structure and formatting
4. Output the COMPLETE updated _STATE.md file
5. Preserve all sections (do not delete anything)

**Execution Instructions:**
1. Copy the prompt above
2. Paste to Local Qwen or ChatGPT 4o-mini
3. Paste current _STATE.md contents below the prompt
4. Copy the output and replace your _STATE.md file
5. Confirm to orchestrator: "State synced to [current timestamp]"

---
⏸️ ORCHESTRATOR PAUSED - Awaiting State sync confirmation.
```

---

### **Step 5: Operator Executes State Update**

**What you do:**

1. **Copy the State Update prompt** (everything in the "Prompt:" section)
    
2. **Open your State Updater model:**
    
    - Local Qwen (if running locally), OR
    - ChatGPT 4o-mini (fast and cheap)
3. **Paste the prompt**
    
4. **Paste your current `_STATE.md` contents** below the prompt
    
5. **Copy the complete output**
    
6. **Replace your `_STATE.md` file** with the new version
    
7. **Verify the changes** (quick scan to ensure updates applied correctly)
    

**Example Execution:**

```
[In ChatGPT 4o-mini]

You are the State Scribe for PS_RCS_PROJECT. Update `_STATE.md` with the following changes:

COMPLETED TASKS:
- Created LidarManager contract - 2025-02-12 14:45:00 - Success

FILES CREATED/MODIFIED:
- `docs/contracts/lidar_manager.md` - Service contract for LIDAR integration

[... rest of prompt ...]

---
[Paste entire _STATE.md file contents]

[ChatGPT outputs updated _STATE.md]
[Copy and replace your _STATE.md file]
```

---

### **Step 6: Operator Confirms Sync**

**What you do:** Return to orchestrator with confirmation message.

**Confirmation Format:**

```
State synced to 2025-02-12 14:50:00
```

**What orchestrator does:**

- ✅ Acknowledges sync
- ✅ Unlocks for next move
- ✅ Presents next tactical options

---

## 🎯 WORKFLOW VARIANTS

### **Variant A: Single Move (Standard)**

```
1. Orchestrator → Agent Packet
2. Execute → Report outcome
3. Orchestrator → State Update Packet
4. Execute State Update → Confirm
5. Ready for next move
```

**Time:** ~5-10 minutes per move  
**Use when:** Standard feature development

---

### **Variant B: Rapid Iteration (Small Changes)**

```
1. Orchestrator → Agent Packet
2. Execute → Report outcome
3. Orchestrator → "Skip State Update - minor change"
4. Ready for next move
[After 3-5 minor moves]
5. Orchestrator → Cumulative State Update
```

**Time:** ~2-3 minutes per move, ~10 minutes for cumulative update  
**Use when:** Debugging, refining, small tweaks  
**⚠️ Risk:** If session crashes, last 3-5 moves are lost

---

### **Variant C: Batch Execution (Advanced)**

```
1. Orchestrator → Agent Packet 1
2. Orchestrator → Agent Packet 2
3. Orchestrator → Agent Packet 3
4. Execute all 3 → Report outcomes
5. Orchestrator → Cumulative State Update
6. Execute State Update → Confirm
```

**Time:** ~15-20 minutes total  
**Use when:** Related tasks that don't depend on each other  
**⚠️ Risk:** If one fails, may need to redo State Update  
**Note:** Only use when orchestrator explicitly offers batch mode

---

## 🛡️ ERROR HANDLING

### **Scenario 1: Agent Task Failed**

**What to do:**

```
Report to orchestrator: "Task failed with error: [description]"
```

**What orchestrator does:**

- Analyzes failure reason
- May generate State Update noting the blocker
- Suggests alternative approach or debugging steps
- Does NOT mark task as complete

**Example State Update for Failure:**

```
COMPLETED TASKS:
- None (attempted LidarManager implementation - failed)

BLOCKERS/ISSUES:
- LidarManager implementation failed: Missing ROS2 dependencies in build system
```

---

### **Scenario 2: State Update Failed**

**What to do:**

```
Report to orchestrator: "State update failed - [error message]"
```

**What orchestrator does:**

- Requests you paste the error
- May regenerate State Update with different approach
- May ask you to verify _STATE.md structure
- Helps debug the update issue

**Recovery steps:**

1. Check _STATE.md syntax (valid Markdown)
2. Try different State Updater model
3. Manual update as last resort (then confirm to orchestrator)

---

### **Scenario 3: Forgot to Update State**

**What to do:**

```
Tell orchestrator: "I forgot to update State after last move. Can you regenerate?"
```

**What orchestrator does:**

- Asks what was accomplished in last move
- Regenerates State Update Packet
- You execute and confirm
- Workflow continues

---

### **Scenario 4: State Desync (Multiple Moves Behind)**

**What to do:**

```
Tell orchestrator: "State is 3 moves behind. Last synced: [timestamp]"
```

**What orchestrator does:**

- Generates cumulative State Update for all missed moves
- Lists each move explicitly
- You execute comprehensive update
- Verifies coherence before continuing

---

## 📊 STATE UPDATE ANATOMY

### **What Gets Logged:**

#### **1. Completed Tasks**

```
COMPLETED TASKS:
- [Task description] - [timestamp] - [Success/Failed/Partial]
```

**Examples:**

- `Created LidarManager contract - 2025-02-12 14:45:00 - Success`
- `Implemented point cloud processing - 2025-02-12 15:30:00 - Success`
- `Fixed camera calibration bug - 2025-02-12 16:15:00 - Success`

---

#### **2. Files Created/Modified**

```
FILES CREATED/MODIFIED:
- `exact/path/to/file.ext` - [what it is/does]
```

**Examples:**

- `docs/contracts/lidar_manager.md` - Service contract for LIDAR integration
- `src/backend/services/lidar_manager.py` - LidarManager implementation
- `tests/test_lidar_manager.py` - Unit tests for LidarManager

---

#### **3. Checklist Updates**

```
CHECKLIST UPDATES:
- Mark complete: [Existing task from checklist]
- Add new pending: [New task discovered]
```

**Examples:**

- Mark complete: "Design LidarManager contract"
- Add new pending: "Implement LidarManager class per contract"
- Add new pending: "Write integration tests for LIDAR data flow"

---

#### **4. Blockers/Issues**

```
BLOCKERS/ISSUES:
- [Description of blocker] OR "None"
```

**Examples:**

- `ROS2 dependencies missing from requirements.txt - blocking LIDAR build`
- `Camera calibration data format unclear - needs spec clarification`
- `None` (if no blockers)

---

#### **5. Phase Status**

```
PHASE STATUS:
- Current phase remains: [PLANNING/DESIGN/BUILD/AUDIT]
OR
- Phase transition: [OLD_PHASE] → [NEW_PHASE]
```

**Examples:**

- `Current phase remains: BUILD`
- `Phase transition: DESIGN → BUILD`
- `Phase transition: BUILD → AUDIT`

---

## 🎓 BEST PRACTICES

### **✅ DO:**

1. **Always confirm State sync before closing session**
    
    - Prevents context loss
    - Ensures clean handoff if you need Baton Pass later
2. **Use descriptive task descriptions in State**
    
    - "Created contract" ❌
    - "Created LidarManager contract for ROS2 integration" ✅
3. **Note partial successes honestly**
    
    - Better to log "Partial - needs refinement" than skip update
4. **Update State even for failed attempts**
    
    - Documents what NOT to do
    - Prevents repeating same mistake
5. **Keep State Updater fast (Local Qwen or 4o-mini)**
    
    - State updates should be <30 seconds
    - Don't use slow/expensive models for this

---

### **❌ DON'T:**

1. **Don't skip State updates "to save time"**
    
    - 2 minutes now saves 20 minutes later when context is lost
2. **Don't batch >5 moves without State update**
    
    - Risk of forgetting details increases exponentially
3. **Don't manually edit _STATE.md without telling orchestrator**
    
    - Causes sync issues
    - Orchestrator assumes State is authoritative
4. **Don't use vague task descriptions**
    
    - "Fixed bug" tells future-you nothing
    - "Fixed null pointer in camera feed parser" is useful
5. **Don't update State without orchestrator knowing**
    
    - Orchestrator tracks sync status
    - Manual updates break the chain of custody

---

## 🔄 INTEGRATION WITH BATON PASS

### **Pre-Baton Pass State Flush**

Before generating Baton Pass, orchestrator will:

1. **Check State freshness:**
    
    ```
    "How many moves since last State sync?"
    ```
    
2. **If N > 0, generate cumulative update:**
    
    ```
    "Generating cumulative State Update for last 3 moves before Baton Pass"
    ```
    
3. **Wait for sync confirmation:**
    
    ```
    "State synced to 2025-02-12 17:00:00"
    ```
    
4. **Then generate Baton Pass:**
    
    ```
    "State is current. Generating Baton Pass document..."
    ```
    

**Result:** New orchestrator receives perfectly synced State

---

## 📈 STATE EVOLUTION EXAMPLE

### **Initial State (Session Start):**

```markdown
## Current Phase
DESIGN

## Pending Tasks
- [ ] Design LidarManager contract
- [ ] Design CameraManager contract

## Completed Tasks
- [2025-02-11] Created system architecture diagram

## Active Blockers
- None
```

---

### **After Move 1 (Contract Created):**

```markdown
## Current Phase
DESIGN → BUILD (transition in progress)

## Pending Tasks
- [ ] Implement LidarManager class per contract
- [ ] Design CameraManager contract

## Completed Tasks
- [2025-02-12 14:45] Created LidarManager contract
- [2025-02-11] Created system architecture diagram

## Files Created
- docs/contracts/lidar_manager.md

## Active Blockers
- None
```

---

### **After Move 2 (Implementation Done):**

```markdown
## Current Phase
BUILD

## Pending Tasks
- [ ] Write unit tests for LidarManager
- [ ] Design CameraManager contract

## Completed Tasks
- [2025-02-12 15:30] Implemented LidarManager class
- [2025-02-12 14:45] Created LidarManager contract
- [2025-02-11] Created system architecture diagram

## Files Created
- src/backend/services/lidar_manager.py
- docs/contracts/lidar_manager.md

## Active Blockers
- None
```

---

### **After Move 3 (Blocker Found):**

```markdown
## Current Phase
BUILD (blocked)

## Pending Tasks
- [ ] Write unit tests for LidarManager (blocked - see issues)
- [ ] Design CameraManager contract

## Completed Tasks
- [2025-02-12 15:30] Implemented LidarManager class
- [2025-02-12 14:45] Created LidarManager contract
- [2025-02-11] Created system architecture diagram

## Files Created
- src/backend/services/lidar_manager.py
- docs/contracts/lidar_manager.md

## Active Blockers
- [2025-02-12 16:00] ROS2 test fixtures missing - blocking LidarManager tests
  Need to create mock LIDAR data generator first
```

---

## 🎯 QUICK REFERENCE

|Situation|State Update Trigger?|Action|
|:--|:--|:--|
|Contract created|✅ Yes|Mark design task complete, add implementation task|
|Code implemented|✅ Yes|Log file, mark task complete, add test task|
|Bug fixed|✅ Yes|Log fix, mark issue resolved|
|Test passed|✅ Yes|Mark test task complete|
|Blocker found|✅ Yes|Add to blockers section|
|Clarification question|❌ No|Just answer, no State change|
|File read/analyzed|❌ No|No State change|
|Mid-task progress|❌ No|Wait for completion|
|Phase transition|✅ Yes|Update phase, log reason|

---

## 🎬 WORKFLOW SUMMARY

**The Golden Rule:**

> "If it changed the project, it goes in State. If it didn't, it doesn't."

**The Sync Promise:**

> "Every major move generates a State Update. No exceptions."

**The Coherence Guarantee:**

> "State is current = Baton Pass is perfect = Zero context loss"

---

## 📞 TROUBLESHOOTING

### **"State Update is taking too long"**

- Switch to ChatGPT 4o-mini (faster than Local Qwen sometimes)
- Or simplify the update (fewer details, just essentials)

### **"I don't understand what to update"**

- Ask orchestrator: "What specifically changed in this move?"
- Orchestrator will list exact changes

### **"State file is getting huge"**

- Archive old completed tasks to `docs/state_archive/YYYY-MM.md`
- Keep only recent ~20 tasks in active _STATE.md

### **"Forgot what model I used for last task"**

- Check orchestrator's "Agent Packet" - it recommends provider
- For State Updates, always use Local Qwen or 4o-mini

---

**End of State Sync Workflow Documentation**

```

---

# ✅ STATE SYNC WORKFLOW COMPLETE

**This document covers:**
- ✅ Visual loop diagram
- ✅ Detailed 6-step breakdown
- ✅ Workflow variants (standard, rapid, batch)
- ✅ Error handling scenarios
- ✅ State update anatomy
- ✅ Best practices (DO/DON'T)
- ✅ Baton Pass integration
- ✅ State evolution example
- ✅ Quick reference table
- ✅ Troubleshooting guide

---

## 📦 NEXT STEPS

**Option A: Create Quick Start Guide**
> "Generate QUICK_START.md for new context bootstrapping"

**Option B: Create Baton Pass Template**
> "Generate BATON_PASS_TEMPLATE.md pre-filled template"

**Option C: Save and Test**
1. Save as `F:\PORTFOLIO\ps_rcs_project\docs\workflows\state_sync_workflow.md`
2. Run one complete loop to verify

**Option D: Create Full Orchestrator Package**
> "Generate all remaining support docs (QUICK_START + templates + examples)"

Which would you like next?
```