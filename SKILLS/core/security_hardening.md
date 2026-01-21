# SKILL: SECURITY HARDENING (V4.0)

**Type:** Core Security Skill  
**Injectable Into:** Architect, Implementer, Auditor  
**Mandatory:** Yes (for all production code)

---

## DESCRIPTION

This skill enforces security best practices and prevents common vulnerabilities. When injected, agents must validate all code against these security constraints.

---

## SECURITY RULES

### 1. NO HARDCODED SECRETS

**Rule:** Never hardcode passwords, API keys, tokens, or credentials in source code.

**Enforcement:**

```python
# ❌ FORBIDDEN
API_KEY = "sk-1234567890abcdef"
PASSWORD = "admin123"
DATABASE_URL = "postgresql://user:password@localhost/db"

# ✅ REQUIRED
import os
API_KEY = os.environ.get("API_KEY")
PASSWORD = os.environ.get("DB_PASSWORD")
DATABASE_URL = os.environ.get("DATABASE_URL")

# ✅ ALTERNATIVE (for development)
from config import settings
API_KEY = settings.API_KEY
```

**Audit Check:**

- Scan code for string literals matching patterns: `[A-Za-z0-9]{20,}`, `sk-`, `token=`
- Flag any hardcoded credentials
- Verify environment variable usage

---

### 2. INPUT VALIDATION (ALWAYS)

**Rule:** All external input must be validated before processing.

**Enforcement:**

```python
# ❌ FORBIDDEN (no validation)
def process_user_input(user_id: str) -> dict:
    return database.query(f"SELECT * FROM users WHERE id={user_id}")

# ✅ REQUIRED
def process_user_input(user_id: str) -> dict:
    # Type validation
    if not isinstance(user_id, str):
        raise TypeError(f"Expected str, got {type(user_id)}")
    
    # Format validation
    if not user_id.isalnum():
        raise ValueError("User ID must be alphanumeric")
    
    # Length validation
    if len(user_id) > 50:
        raise ValueError("User ID too long")
    
    # Use parameterized query
    return database.query("SELECT * FROM users WHERE id=?", (user_id,))
```

**Required Validations:**

- Type checking
- Format/pattern validation
- Range/length validation
- Whitelist validation (when applicable)

---

### 3. SQL INJECTION PREVENTION

**Rule:** Use parameterized queries or ORM. Never concatenate user input into SQL.

**Enforcement:**

```python
# ❌ FORBIDDEN
query = f"SELECT * FROM users WHERE name='{username}'"
query = "SELECT * FROM users WHERE id=" + str(user_id)

# ✅ REQUIRED (parameterized)
query = "SELECT * FROM users WHERE name=?"
cursor.execute(query, (username,))

# ✅ REQUIRED (ORM)
user = User.objects.filter(name=username).first()
```

**Audit Check:**

- Flag any string concatenation in SQL queries
- Flag any f-strings in SQL
- Verify parameterized queries or ORM usage

---

### 4. PATH TRAVERSAL PREVENTION

**Rule:** Validate and sanitize all file paths. Never trust user input for paths.

**Enforcement:**

```python
# ❌ FORBIDDEN
def read_file(filename: str) -> str:
    return open(filename).read()

# ✅ REQUIRED
import os
from pathlib import Path

ALLOWED_DIR = Path("/var/app/uploads")

def read_file(filename: str) -> str:
    # Sanitize input
    filename = os.path.basename(filename)
    
    # Construct safe path
    filepath = ALLOWED_DIR / filename
    
    # Verify path is within allowed directory
    if not filepath.resolve().is_relative_to(ALLOWED_DIR.resolve()):
        raise ValueError("Path traversal attempt detected")
    
    # Verify file exists and is a file
    if not filepath.is_file():
        raise FileNotFoundError(f"File not found: {filename}")
    
    return filepath.read_text()
```

**Required Checks:**

- Use `os.path.basename()` to strip directory components
- Verify resolved path is within allowed directory
- Use `Path.is_relative_to()` for validation

---

### 5. COMMAND INJECTION PREVENTION

**Rule:** Never pass user input directly to shell commands.

**Enforcement:**

```python
# ❌ FORBIDDEN
import os
os.system(f"convert {user_file} output.pdf")
subprocess.call(f"rm {filename}", shell=True)

# ✅ REQUIRED
import subprocess
subprocess.run(["convert", user_file, "output.pdf"], check=True)
subprocess.run(["rm", filename], check=True)
```

**Required Practices:**

- Use `subprocess.run()` with list arguments (not shell=True)
- Never use `os.system()` with user input
- Validate all arguments before passing to subprocess

---

### 6. XSS PREVENTION (Web Applications)

**Rule:** Escape all user-generated content before rendering in HTML.

**Enforcement:**

```python
# ❌ FORBIDDEN
html = f"<div>Welcome, {username}!</div>"

# ✅ REQUIRED
from html import escape
html = f"<div>Welcome, {escape(username)}!</div>"

# ✅ BETTER (template engine)
template.render(username=username)  # Auto-escapes
```

---

### 7. CSRF PROTECTION (Web Applications)

**Rule:** Use CSRF tokens for all state-changing operations.

**Enforcement:**

- All POST/PUT/DELETE endpoints require CSRF token
- Use framework-provided CSRF protection
- Verify token on every state-changing request

---

### 8. SECURE RANDOM GENERATION

**Rule:** Use cryptographically secure random for security-sensitive operations.

**Enforcement:**

```python
# ❌ FORBIDDEN (predictable)
import random
token = random.randint(1000, 9999)

# ✅ REQUIRED
import secrets
token = secrets.token_urlsafe(32)
session_id = secrets.token_hex(16)
```

---

### 9. PASSWORD HANDLING

**Rule:** Never store plaintext passwords. Always hash with salt.

**Enforcement:**

```python
# ❌ FORBIDDEN
user.password = password

# ✅ REQUIRED
import bcrypt
hashed = bcrypt.hashpw(password.encode(), bcrypt.gensalt())
user.password_hash = hashed

# Verification
if bcrypt.checkpw(input_password.encode(), user.password_hash):
    # Authenticated
```

---

### 10. ERROR HANDLING (NO INFORMATION LEAKAGE)

**Rule:** Never expose stack traces or system details to users.

**Enforcement:**

```python
# ❌ FORBIDDEN
except Exception as e:
    return f"Error: {str(e)}"  # May leak sensitive info

# ✅ REQUIRED
except ValueError as e:
    logger.error(f"Validation error: {e}")
    return "Invalid input provided"
except Exception as e:
    logger.exception("Unexpected error")
    return "An error occurred. Please contact support."
```

---

## INJECTION INSTRUCTIONS

### For Architect

When designing contracts, include:

```markdown
## SECURITY CONSTRAINTS
- All user input must be validated
- SQL queries must use parameterization
- File paths must be sanitized
- No hardcoded secrets permitted
```

### For Implementer

When generating code:

1. Check every external input source
2. Add validation before processing
3. Use secure APIs (parameterized queries, subprocess lists)
4. Use environment variables for secrets
5. Apply all relevant rules from this skill

### For Auditor

When reviewing code, verify:

- [ ] No hardcoded secrets
- [ ] All inputs validated
- [ ] No SQL concatenation
- [ ] No path traversal vulnerabilities
- [ ] No command injection vectors
- [ ] Secure random used where needed
- [ ] Passwords properly hashed
- [ ] Errors don't leak information

---

## COMMON VIOLATIONS

### High Severity

- Hardcoded API keys/passwords
- SQL injection vulnerabilities
- Command injection vulnerabilities
- Path traversal vulnerabilities
- Plaintext password storage

### Medium Severity

- Missing input validation
- Using `random` instead of `secrets`
- Exposing stack traces to users
- Missing CSRF protection

### Low Severity

- Overly permissive file permissions
- Missing rate limiting
- Insufficient logging

---

## AUDIT TEMPLATE

```markdown
## SECURITY AUDIT RESULTS

### Secrets Management
- ✅/❌ No hardcoded credentials
- ✅/❌ Environment variables used
- ✅/❌ Config file properly secured

### Input Validation
- ✅/❌ All external inputs validated
- ✅/❌ Type checking present
- ✅/❌ Range/length limits enforced

### Injection Prevention
- ✅/❌ SQL queries parameterized
- ✅/❌ File paths sanitized
- ✅/❌ Shell commands use list arguments

### Cryptography
- ✅/❌ Secure random used
- ✅/❌ Passwords hashed with salt
- ✅/❌ Sensitive data encrypted

### Error Handling
- ✅/❌ No stack trace exposure
- ✅/❌ Generic error messages to users
- ✅/❌ Detailed logs server-side only

**SECURITY SCORE:** [X]/100
**CRITICAL ISSUES:** [N]
```