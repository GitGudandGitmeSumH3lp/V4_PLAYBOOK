#!/bin/bash

# PACKET PROMPTING V4.0 - DIRECTORY GENERATOR
# ==========================================

# Define the root directory name
ROOT_DIR="V4_PLAYBOOK"

echo "🏗️  Creating Packet Prompting V4.0 structure in: ./$ROOT_DIR"

# 1. Create Directory Structure
# =============================
mkdir -p "$ROOT_DIR/AGENTS"
mkdir -p "$ROOT_DIR/SKILLS/core"
mkdir -p "$ROOT_DIR/SKILLS/langs"
mkdir -p "$ROOT_DIR/RULES"
mkdir -p "$ROOT_DIR/HOOKS"
mkdir -p "$ROOT_DIR/CONTEXT"
mkdir -p "$ROOT_DIR/docs" # For the Obsidian Playbooks

# 2. Create Agent Files (The "WHO")
# ================================
echo "📝 Creating Agent files..."
touch "$ROOT_DIR/AGENTS/01_architect.md"
echo "# AGENT: 01_ARCHITECT" > "$ROOT_DIR/AGENTS/01_architect.md"
echo "**Model Assignment:** Claude Sonnet (Account C)" >> "$ROOT_DIR/AGENTS/01_architect.md"
echo "---" >> "$ROOT_DIR/AGENTS/01_architect.md"
echo "# PASTE PROMPT CONTENT BELOW" >> "$ROOT_DIR/AGENTS/01_architect.md"

touch "$ROOT_DIR/AGENTS/02_implementer.md"
echo "# AGENT: 02_IMPLEMENTER" > "$ROOT_DIR/AGENTS/02_implementer.md"
echo "**Model Assignment:** DeepSeek V3 (Account E)" >> "$ROOT_DIR/AGENTS/02_implementer.md"
echo "---" >> "$ROOT_DIR/AGENTS/02_implementer.md"
echo "# PASTE PROMPT CONTENT BELOW" >> "$ROOT_DIR/AGENTS/02_implementer.md"

touch "$ROOT_DIR/AGENTS/03_refiner.md"
echo "# AGENT: 03_REFINER" > "$ROOT_DIR/AGENTS/03_refiner.md"
echo "**Model Assignment:** Gemini 2.0 Flash (Account A)" >> "$ROOT_DIR/AGENTS/03_refiner.md"
echo "---" >> "$ROOT_DIR/AGENTS/03_refiner.md"
echo "# PASTE PROMPT CONTENT BELOW" >> "$ROOT_DIR/AGENTS/03_refiner.md"

touch "$ROOT_DIR/AGENTS/04_researcher.md"
echo "# AGENT: 04_RESEARCHER" > "$ROOT_DIR/AGENTS/04_researcher.md"
echo "**Model Assignment:** Gemini 1.5 Pro (Account B)" >> "$ROOT_DIR/AGENTS/04_researcher.md"
echo "---" >> "$ROOT_DIR/AGENTS/04_researcher.md"
echo "# PASTE PROMPT CONTENT BELOW" >> "$ROOT_DIR/AGENTS/04_researcher.md"

touch "$ROOT_DIR/AGENTS/05_auditor.md"
echo "# AGENT: 05_AUDITOR" > "$ROOT_DIR/AGENTS/05_auditor.md"
echo "**Model Assignment:** Gemini 2.0 Flash Thinking (Account D)" >> "$ROOT_DIR/AGENTS/05_auditor.md"
echo "---" >> "$ROOT_DIR/AGENTS/05_auditor.md"
echo "# PASTE PROMPT CONTENT BELOW" >> "$ROOT_DIR/AGENTS/05_auditor.md"

# 3. Create Skill Files (The "HOW")
# ================================
echo "🔧 Creating Skill files..."
touch "$ROOT_DIR/SKILLS/core/security_hardening.md"
touch "$ROOT_DIR/SKILLS/core/python_strict_typing.md"
touch "$ROOT_DIR/SKILLS/core/reflection_logic.md"
touch "$ROOT_DIR/SKILLS/langs/react_hooks.md"
touch "$ROOT_DIR/SKILLS/langs/rust_ownership.md"

# 4. Create Rules & Hooks (The "CONSTRAINTS")
# ==========================================
echo "🛡️  Creating Rules and Hooks..."
touch "$ROOT_DIR/RULES/HARD_CONSTRAINTS.md"
touch "$ROOT_DIR/RULES/SOFT_GUIDELINES.md"
touch "$ROOT_DIR/HOOKS/pre_session_check.md"
touch "$ROOT_DIR/HOOKS/post_imp_audit.md"

# 5. Create Context Files
# =======================
echo "🧠 Creating Context files..."
touch "$ROOT_DIR/CONTEXT/project_memory.md"
touch "$ROOT_DIR/CONTEXT/api_map_lite.md"

# 6. Create Obsidian Documentation Files
# ======================================
echo "📚 Creating Obsidian Playbooks..."
touch "$ROOT_DIR/docs/00_MASTER_PLAYBOOK.md"
touch "$ROOT_DIR/docs/01_WORKFLOW_GUIDE.md"
touch "$ROOT_DIR/docs/02_AGENT_ROSTER.md"
touch "$ROOT_DIR/README.md"

# 7. Finalize
# ============
echo "✅ Structure created successfully!"
echo "🚀 Next Steps:"
echo "   1. cd $ROOT_DIR"
echo "   2. Open the .md files and paste your generated prompts."
echo "   3. Open the 'docs' folder in Obsidian."