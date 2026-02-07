
**Version:** 1.0  
**Target System:** Windows 10, Git Bash, Ollama  
**Hardware:** Ryzen 3 3200G, 16GB RAM (4GB allocated to AI)  
**Model:** Qwen2.5:3b-instruct-q4_K_M  
**Purpose:** Local state-aware orchestration for Packet Prompting V4.0 workflow

---

## SYSTEM OVERVIEW

This guide sets up a **local LLM orchestrator** that runs on your machine to handle:

- ✅ State management and tracking
- ✅ Simple routing decisions ("What agent runs next?")
- ✅ Prerequisite validation
- ✅ Context budget monitoring
- ✅ Session compression guidance

**What it DOESN'T handle** (escalate to DeepSeek/Claude):

- ❌ Complex failure diagnosis
- ❌ Multi-scenario strategic planning
- ❌ Code generation or review
- ❌ Detailed architectural decisions

---

## PART 1: VERIFICATION & MODEL INSTALLATION

### Step 1.1: Verify Ollama Installation

Open **Git Bash** and verify Ollama is accessible:

```bash
# Add Ollama to PATH for this session
export PATH="/f/Ollama/Bin:$PATH"

# Verify installation
ollama --version
```

**Expected Output:**

```
ollama version is 0.x.x
```

**If command not found:**

```bash
# Make PATH permanent by adding to .bashrc
echo 'export PATH="/f/Ollama/Bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Try again
ollama --version
```

---

### Step 1.2: Start Ollama Server

Ollama requires a background server to be running.

```bash
# Start Ollama server (keep this terminal open)
ollama serve
```

**Expected Output:**

```
Listening on 127.0.0.1:11434
```

**IMPORTANT:**

- Keep this terminal window open while using the orchestrator
- Open a NEW Git Bash window for all subsequent commands

**Alternative (if serve fails on Windows):**

- Ollama may auto-start as a Windows service
- Check system tray for Ollama icon
- If present, skip `ollama serve` and proceed

---

### Step 1.3: Pull the Optimized Model

Open a **NEW Git Bash window** (keep server running in first window).

```bash
# Pull Qwen2.5 3B with Q4_K_M quantization (optimized for 4GB RAM)
ollama pull qwen2.5:3b-instruct-q4_K_M
```

**Expected Output:**

```
pulling manifest
pulling [hash]... 100%
verifying sha256 digest
success
```

**Download Size:** ~2.3GB  
**Estimated Time:** 5-15 minutes (depending on connection)

**If model not found, try alternative name:**

```bash
ollama pull qwen2.5:3b
```

---

### Step 1.4: Verify Model Installation

```bash
# List installed models
ollama list
```

**Expected Output:**

```
NAME                        ID              SIZE      MODIFIED
qwen2.5:3b-instruct-q4_K_M  [hash]         2.3 GB    X seconds ago
```

---

### Step 1.5: Test Model (Quick Sanity Check)

```bash
# Run a simple test
ollama run qwen2.5:3b-instruct-q4_K_M "What is 2+2?"
```

**Expected Output:**

```
The answer is 4.
```

**If you see output:** ✅ Model is working!  
**If error:** See Troubleshooting section at end of this document.

---

## PART 2: CUSTOM MODELFILE CONFIGURATION

### Step 2.1: Create Custom Modelfile

We need to create a custom configuration to:

- Set 16K context window (essential for state awareness)
- Optimize temperature for routing (not creativity)
- Inject system prompt automatically

**Create file:** `F:\PORTFOLIO\ps_rcs_project\Modelfile`

```bash
# Navigate to your project
cd /f/PORTFOLIO/ps_rcs_project

# Create Modelfile
cat > Modelfile << 'EOF'
FROM qwen2.5:3b-instruct-q4_K_M

# Set context window to 16K tokens (enough for state + recent context)
PARAMETER num_ctx 16384

# Optimize for routing/logic (not creative writing)
PARAMETER temperature 0.3
PARAMETER top_p 0.9
PARAMETER top_k 40

# Reduce repetition
PARAMETER repeat_penalty 1.1

# System prompt will be loaded from agent file
SYSTEM You are a local state-aware orchestrator for a multi-agent development workflow. Your role is to track project state, validate prerequisites, and provide simple routing guidance. You focus on efficiency and brevity.
EOF
```

**Verify file created:**

```bash
cat Modelfile
```

---

### Step 2.2: Create Custom Model from Modelfile

```bash
# Build custom model named "orchestrator-local"
ollama create orchestrator-local -f Modelfile
```

**Expected Output:**

```
transferring model data
using existing layer [hash]
creating new layer [hash]
writing manifest
success
```

**Verify custom model:**

```bash
ollama list
```

**Should now show:**

```
NAME                        ID              SIZE      MODIFIED
orchestrator-local          [hash]         2.3 GB    X seconds ago
qwen2.5:3b-instruct-q4_K_M  [hash]         2.3 GB    X minutes ago
```

---

### Step 2.3: Test Custom Model

```bash
ollama run orchestrator-local "Respond with: Ready"
```

**Expected Output:**

```
Ready
```

---

## PART 3: PROJECT INTEGRATION

### Step 3.1: Create Orchestrator Agent File

The full orchestrator prompt is in `AGENTS/00_orchestrator_local.md` (see separate file).

For quick access, create a session starter script:

```bash
# Create launch script
cat > /f/PORTFOLIO/ps_rcs_project/start_orchestrator.sh << 'EOF'
#!/bin/bash

# Local Orchestrator Launcher
# Usage: ./start_orchestrator.sh

echo "🚀 Starting Local Orchestrator..."
echo "📍 Project: ps_rcs_project"
echo "📊 Loading state from: _STATE.md"
echo ""

# Load state file
if [ -f "_STATE.md" ]; then
    echo "✅ State file found"
    STATE_CONTENT=$(cat _STATE.md)
else
    echo "⚠️  State file not found - creating template"
    STATE_CONTENT="No state file present. Initialize project first."
fi

# Launch orchestrator with state pre-loaded
echo ""
echo "════════════════════════════════════════════"
echo "LOCAL ORCHESTRATOR - SESSION START"
echo "════════════════════════════════════════════"
echo ""
echo "State loaded. Type your query or command."
echo "(Type /exit to quit)"
echo ""

# Start interactive session
ollama run orchestrator-local
EOF

# Make executable
chmod +x start_orchestrator.sh
```

---

### Step 3.2: Create Quick Command Aliases (Optional)

Add to your `~/.bashrc` for quick access:

```bash
cat >> ~/.bashrc << 'EOF'

# Local Orchestrator Aliases
alias orch='cd /f/PORTFOLIO/ps_rcs_project && ollama run orchestrator-local'
alias orch-start='/f/PORTFOLIO/ps_rcs_project/start_orchestrator.sh'
alias orch-state='cat /f/PORTFOLIO/ps_rcs_project/_STATE.md | ollama run orchestrator-local "Analyze this state and tell me what to do next:"'
EOF

# Reload bashrc
source ~/.bashrc
```

**Usage after aliases:**

```bash
# Quick launch
orch

# Launch with state auto-load
orch-start

# Quick state analysis
orch-state
```

---

## PART 4: DAILY WORKFLOW INTEGRATION

### Step 4.1: Session Start Routine

**Morning (or start of dev session):**

```bash
# Terminal Window 1: Start Ollama server (if not auto-started)
ollama serve

# Terminal Window 2: Navigate to project
cd /f/PORTFOLIO/ps_rcs_project

# Launch orchestrator
./start_orchestrator.sh
```

**In orchestrator prompt:**

```
You: "Session start. Analyze my current state and route my first task."
```

**Orchestrator will:**

- Read your _STATE.md
- Identify current phase
- Suggest next agent to run
- Provide exact prompt template

---

### Step 4.2: During Development (Alt-Tab Workflow)

**Window Layout:**

```
[Git Bash - Orchestrator]     [Browser - LLM Tabs]
┌────────────────────┐        ┌──────────────────────┐
│ > ollama run...    │        │ Tab1: Analyst        │
│                    │  ←→    │ Tab2: Architect      │
│ Orchestrator: Run  │        │ Tab3: Implementer    │
│ Architect next...  │        │ Tab4: DeepSeek Chat  │
│                    │        │                      │
└────────────────────┘        └──────────────────────┘
```

**Workflow:**

1. **Get guidance** from local orchestrator (terminal)
2. **Alt+Tab** to browser
3. **Switch to appropriate LLM tab** (Analyst, Architect, etc.)
4. **Paste prompt** from orchestrator
5. **Run agent** in browser
6. **Copy output** from browser
7. **Alt+Tab back** to terminal
8. **Paste result** to orchestrator
9. **Get next routing** from orchestrator
10. **Repeat**

---

### Step 4.3: Context Compression (When Conversation Gets Heavy)

**Trigger:** After ~20-30 exchanges, conversation may slow down.

```bash
# In orchestrator
You: "Compress this session into a summary for handoff."

Orchestrator: [Generates 500-token summary]

# Copy summary, then exit
You: /exit

# Start fresh session
./start_orchestrator.sh

# Paste summary
You: "Continuing from previous session. Summary: [paste]"
```

---

### Step 4.4: Session End Routine

**End of day:**

```bash
# In orchestrator
You: "End session. Generate summary for tomorrow."

Orchestrator: [Provides summary]

# Save summary to logs
You: /exit

# Update _STATE.md with completed tasks
# (Use state_manager.py - see separate utility guide)
```

---

## PART 5: PERFORMANCE OPTIMIZATION

### Memory Management

**Monitor RAM usage:**

```bash
# Check Ollama memory usage (in separate terminal)
tasklist | grep ollama
```

**If model runs slow:**

- Close unnecessary browser tabs
- Reduce context window in Modelfile (try 12288 instead of 16384)
- Restart Ollama: `taskkill /F /IM ollama.exe` then `ollama serve`

---

### Response Speed Tuning

**If responses are too slow:**

Edit `Modelfile` and reduce context:

```
PARAMETER num_ctx 12288  # Instead of 16384
```

Rebuild model:

```bash
ollama create orchestrator-local -f Modelfile
```

---

## PART 6: TROUBLESHOOTING

### Issue: "ollama: command not found"

**Fix:**

```bash
export PATH="/f/Ollama/Bin:$PATH"
echo 'export PATH="/f/Ollama/Bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

---

### Issue: "Failed to connect to server"

**Diagnosis:** Ollama server not running.

**Fix:**

```bash
# Start server in separate terminal
ollama serve
```

**Or:** Check Windows Task Manager → Services for "Ollama" service.

---

### Issue: Model pulls but crashes on run

**Diagnosis:** Insufficient RAM.

**Fix:**

1. Close all other applications
2. Use smaller quantization:
    
    ```bash
    ollama pull qwen2.5:3b-instruct-q4_0  # Even lighter
    ```
    
3. Update Modelfile to use new model
4. Rebuild custom model

---

### Issue: Responses are gibberish

**Diagnosis:** Model hallucinating or context overflow.

**Fix:**

1. Reduce context window in Modelfile to 8192
2. Compress session more frequently
3. Clear conversation: `/clear` then restart

---

### Issue: Model is too slow (>10 seconds per response)

**Diagnosis:** Context window too large or RAM pressure.

**Fix:**

```bash
# In Modelfile, reduce context
PARAMETER num_ctx 8192

# Rebuild
ollama create orchestrator-local -f Modelfile
```

---

### Issue: Can't paste state file (too large)

**Diagnosis:** _STATE.md exceeds context limit.

**Fix:**

1. Compress state file (remove old session data)
2. Use state_manager.py to generate lite summary
3. Paste summary instead of full state

---

## PART 7: VERIFICATION CHECKLIST

**Before using in production, verify:**

- [ ] Ollama server starts without errors
- [ ] Model responds to simple queries in <5 seconds
- [ ] Custom model "orchestrator-local" appears in `ollama list`
- [ ] Can read _STATE.md without crashing
- [ ] Aliases work (if created)
- [ ] Start script launches successfully
- [ ] Alt+Tab workflow comfortable

---

## PART 8: NEXT STEPS

Once setup is complete:

1. **Read:** `AGENTS/00_orchestrator_local.md` - Full prompt and capabilities
2. **Read:** `WORKFLOWS/local_orchestrator_usage.md` - Detailed workflow guide
3. **Install:** `UTILITIES/state_manager.py` - State management automation
4. **Test:** Run one complete feature workflow with local orchestrator
5. **Optimize:** Adjust Modelfile parameters based on performance

---

## QUICK REFERENCE COMMANDS

```bash
# Start server
ollama serve

# Launch orchestrator (from project dir)
./start_orchestrator.sh

# Or direct launch
ollama run orchestrator-local

# List models
ollama list

# Remove model (if needed)
ollama rm orchestrator-local

# Exit interactive session
/exit

# Clear conversation context
/clear
```

---

## COST & PERFORMANCE ESTIMATES

**RAM Usage:** ~2.5-3.5GB (with 16K context)  
**Response Time:** 2-8 seconds (depending on query complexity)  
**Token Processing Speed:** ~10-20 tokens/sec  
**Context Limit:** 16K tokens (~12K words)  
**Cost:** $0 (fully local)

---

## SUPPORT & UPDATES

**Official Ollama Docs:** https://ollama.com/docs  
**Model Card:** https://ollama.com/library/qwen2.5  
**Troubleshooting:** Check Ollama GitHub issues

**For workflow-specific questions:**

- Refer to `WORKFLOWS/local_orchestrator_usage.md`
- Check project documentation in `docs/`

---

**END OF SETUP GUIDE**

Once complete, you should have a fully functional local orchestrator running on your machine, ready to guide your multi-agent workflow.