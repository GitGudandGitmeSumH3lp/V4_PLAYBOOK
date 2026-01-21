# SKILL: PYTHON STRICT TYPING (V4.0)

**Type:** Core Language Skill  
**Injectable Into:** Architect, Implementer, Refiner, Auditor  
**Mandatory:** Yes (for all Python code)

---

## DESCRIPTION

This skill enforces comprehensive type hinting and type safety in Python code. When injected, agents must ensure all code has complete, accurate type annotations.

---

## TYPE HINTING RULES

### 1. ALL FUNCTIONS MUST HAVE TYPE HINTS

**Rule:** Every function parameter and return value must be type-annotated.

**Enforcement:**

```python
# ❌ FORBIDDEN (no type hints)
def process_data(items, count):
    return items[:count]

# ❌ FORBIDDEN (incomplete)
def process_data(items: list, count):
    return items[:count]

# ✅ REQUIRED (complete)
def process_data(items: list[str], count: int) -> list[str]:
    return items[:count]
```

**Exceptions:**

- `self` and `cls` parameters (implied by context)
- `*args` and `**kwargs` when types truly vary
- Decorators that transform signatures

---

### 2. USE SPECIFIC COLLECTION TYPES

**Rule:** Use generic types with type parameters, not bare `list`, `dict`, `set`.

**Enforcement:**

```python
# ❌ FORBIDDEN (too vague)
def get_users() -> list:
    pass

def get_config() -> dict:
    pass

# ✅ REQUIRED (specific)
def get_users() -> list[User]:
    pass

def get_config() -> dict[str, Any]:
    pass

def get_mapping() -> dict[str, list[int]]:
    pass
```

---

### 3. OPTIONAL TYPES

**Rule:** Use `Optional[T]` or `T | None` for nullable values. Be explicit.

**Enforcement:**

```python
from typing import Optional

# ❌ FORBIDDEN (ambiguous default)
def fetch_user(user_id: str) -> User:
    pass  # What if user not found?

# ✅ REQUIRED (explicit)
def fetch_user(user_id: str) -> Optional[User]:
    pass

# ✅ ALTERNATIVE (Python 3.10+)
def fetch_user(user_id: str) -> User | None:
    pass

# ✅ REQUIRED (optional parameter)
def create_user(
    name: str,
    email: Optional[str] = None
) -> User:
    pass
```

---

### 4. UNION TYPES

**Rule:** Use `Union[T1, T2]` or `T1 | T2` for multiple possible types.

**Enforcement:**

```python
from typing import Union

# ✅ REQUIRED (Python 3.9)
def parse_value(value: Union[str, int, float]) -> float:
    return float(value)

# ✅ ALTERNATIVE (Python 3.10+)
def parse_value(value: str | int | float) -> float:
    return float(value)
```

---

### 5. TYPE ALIASES

**Rule:** Create type aliases for complex repeated types.

**Enforcement:**

```python
from typing import Dict, List, Tuple

# ❌ MESSY (repeated complex type)
def process(data: Dict[str, List[Tuple[int, str]]]) -> Dict[str, List[Tuple[int, str]]]:
    pass

# ✅ CLEAN (type alias)
UserData = Dict[str, List[Tuple[int, str]]]

def process(data: UserData) -> UserData:
    pass
```

---

### 6. CALLABLE TYPES

**Rule:** Type hint function parameters that accept callables.

**Enforcement:**

```python
from typing import Callable

# ❌ FORBIDDEN
def apply_transform(data: list, func):
    pass

# ✅ REQUIRED
def apply_transform(
    data: list[int],
    func: Callable[[int], str]
) -> list[str]:
    return [func(item) for item in data]

# Format: Callable[[arg1_type, arg2_type], return_type]
```

---

### 7. GENERIC CLASSES

**Rule:** Type parameterize generic classes.

**Enforcement:**

```python
from typing import Generic, TypeVar

T = TypeVar('T')

class Container(Generic[T]):
    def __init__(self, value: T) -> None:
        self._value = T
    
    def get(self) -> T:
        return self._value
    
    def set(self, value: T) -> None:
        self._value = value

# Usage
int_container: Container[int] = Container(42)
str_container: Container[str] = Container("hello")
```

---

### 8. PROTOCOL TYPES (Structural Subtyping)

**Rule:** Use Protocol for duck typing with type safety.

**Enforcement:**

```python
from typing import Protocol

class Drawable(Protocol):
    def draw(self) -> None:
        ...

def render(obj: Drawable) -> None:
    obj.draw()

# Any class with draw() method is accepted
class Circle:
    def draw(self) -> None:
        print("Drawing circle")

render(Circle())  # Type-safe
```

---

### 9. LITERAL TYPES

**Rule:** Use Literal for fixed set of values.

**Enforcement:**

```python
from typing import Literal

# ✅ REQUIRED
def set_mode(mode: Literal["read", "write", "append"]) -> None:
    pass

# ✅ REQUIRED (with type alias)
Mode = Literal["read", "write", "append"]

def set_mode(mode: Mode) -> None:
    pass
```

---

### 10. TYPE GUARDS

**Rule:** Use TypeGuard for runtime type checking.

**Enforcement:**

```python
from typing import TypeGuard

def is_string_list(val: list) -> TypeGuard[list[str]]:
    return all(isinstance(item, str) for item in val)

def process(items: list) -> None:
    if is_string_list(items):
        # Type checker knows items is list[str] here
        print(items[0].upper())
```

---

## CLASS TYPE HINTS

### 1. INSTANCE ATTRIBUTES

**Rule:** Type hint all instance attributes in `__init__` or as class variables.

**Enforcement:**

```python
# ❌ FORBIDDEN (no type hints)
class User:
    def __init__(self, name, age):
        self.name = name
        self.age = age

# ✅ REQUIRED (method 1: inline)
class User:
    def __init__(self, name: str, age: int) -> None:
        self.name: str = name
        self.age: int = age

# ✅ REQUIRED (method 2: class level)
class User:
    name: str
    age: int
    
    def __init__(self, name: str, age: int) -> None:
        self.name = name
        self.age = age
```

---

### 2. CLASS METHODS AND STATIC METHODS

**Rule:** Type hint `@classmethod` and `@staticmethod`.

**Enforcement:**

```python
from typing import Self  # Python 3.11+

class User:
    def __init__(self, name: str) -> None:
        self.name = name
    
    @classmethod
    def from_dict(cls, data: dict[str, Any]) -> Self:
        return cls(data["name"])
    
    @staticmethod
    def validate_name(name: str) -> bool:
        return len(name) > 0
```

---

### 3. PROPERTY TYPES

**Rule:** Type hint property getters and setters.

**Enforcement:**

```python
class User:
    def __init__(self, name: str) -> None:
        self._name = name
    
    @property
    def name(self) -> str:
        return self._name
    
    @name.setter
    def name(self, value: str) -> None:
        if not value:
            raise ValueError("Name cannot be empty")
        self._name = value
```

---

## ADVANCED PATTERNS

### 1. OVERLOADING

**Rule:** Use `@overload` for functions with multiple signatures.

**Enforcement:**

```python
from typing import overload

@overload
def process(value: int) -> str: ...

@overload
def process(value: str) -> int: ...

def process(value: int | str) -> int | str:
    if isinstance(value, int):
        return str(value)
    return len(value)
```

---

### 2. FORWARD REFERENCES

**Rule:** Use string literals for forward references.

**Enforcement:**

```python
class Node:
    def __init__(self, value: int) -> None:
        self.value = value
        self.next: Optional["Node"] = None  # Forward reference

# Python 3.10+ alternative
from __future__ import annotations

class Node:
    def __init__(self, value: int) -> None:
        self.value = value
        self.next: Optional[Node] = None  # No quotes needed
```

---

### 3. NEVER TYPE

**Rule:** Use `Never` for functions that never return.

**Enforcement:**

```python
from typing import Never

def raise_error(message: str) -> Never:
    raise RuntimeError(message)
```

---

## MYPY INTEGRATION

### Required Configuration

```ini
# mypy.ini
[mypy]
python_version = 3.10
warn_return_any = True
warn_unused_configs = True
disallow_untyped_defs = True
disallow_any_unimported = True
no_implicit_optional = True
warn_redundant_casts = True
warn_unused_ignores = True
warn_no_return = True
check_untyped_defs = True
strict_equality = True
```

---

## INJECTION INSTRUCTIONS

### For Architect

When designing contracts, specify:

```markdown
## TYPE SPECIFICATIONS
- All parameters: [exact types]
- Return types: [exact types]
- Generic constraints: [bounds]
```

### For Implementer

When generating code:

1. Add type hints to every function/method
2. Use specific collection types (not bare `list`/`dict`)
3. Use `Optional` for nullable values
4. Create type aliases for complex types
5. Verify types match contract exactly

### For Refiner

When adding documentation:

1. Verify all type hints present
2. Ensure type hints match actual behavior
3. Add missing type hints
4. Fix incorrect type hints
5. Apply consistent typing style

### For Auditor

When reviewing code, verify:

- [ ] All functions have complete type hints
- [ ] Collection types are specific (not bare)
- [ ] Optional types used for nullables
- [ ] Type aliases used for complex types
- [ ] Types match contract specifications
- [ ] No `Any` without justification

---

## COMMON VIOLATIONS

### Critical (Auto-Fail)

- Missing type hints on public functions
- Type hints don't match contract
- Using `Any` without comment explaining why

### High Severity

- Bare `list`/`dict` instead of parameterized
- Missing `Optional` for nullable values
- Inconsistent typing style

### Medium Severity

- Complex types not aliased
- Missing type hints on private functions
- Redundant type hints (obvious from context)

---

## AUDIT TEMPLATE

```markdown
## TYPE SAFETY AUDIT

### Completeness
- ✅/❌ All public functions typed
- ✅/❌ All parameters typed
- ✅/❌ All return values typed
- ✅/❌ All class attributes typed

### Specificity
- ✅/❌ Collections parameterized
- ✅/❌ Optional types used correctly
- ✅/❌ Union types used where needed
- ✅/❌ Complex types aliased

### Accuracy
- ✅/❌ Types match contract
- ✅/❌ Types match actual behavior
- ✅/❌ No unnecessary `Any`

**TYPE SAFETY SCORE:** [X]/100
**MYPY COMPLIANCE:** [Pass/Fail]
```