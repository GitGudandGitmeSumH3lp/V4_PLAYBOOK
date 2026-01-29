# 🧠 PROJECT MEMORY
**Status:** Active

## 🛑 HARD CONSTRAINTS (Recurring)
1. No `os.system` calls allowed.
2. All functions must use Type Hints (Strict).
3. Max file length: 500 lines.

## 💡 LESSONS LEARNED
- **[Date]:** We tried `requests` but switched to `httpx` for async support. Never suggest `requests` again.
- **[Date]:** The authentication module requires the `User` object to be initialized *before* the DB connection.

## 🏛️ ARCHITECTURAL DECISIONS
- Use Factory Pattern for all Database connections.
- All timestamps must be UTC.