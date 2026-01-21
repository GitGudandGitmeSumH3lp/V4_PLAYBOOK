#docs/API_MAP_lite
*Strict formatting required. Agents use this to validate imports.*

Format:
```markdown
# API MAP LITE
**Purpose:** Import Validation

## MODULE INDEX
- `module_name`
  - `method_name`
  - `method_name`
- `another_module`
  - `method_a`

[Alphabetical order. No descriptions.]
```

## BEHAVIORAL RULES
- If a method is in the contract, it MUST be in the map.
- Do not hallucinate methods not present in the contracts.
- Output both files in separate code blocks.