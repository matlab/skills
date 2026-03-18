# Constraints and Assertions

Advanced verification techniques, tolerances, and custom constraints. For basic assertion usage (`verify*`/`assert*`/`assume*`, `verifyError`, `verifyWarningFree`, `AbsTol`/`RelTol` syntax), see SKILL.md.

## Verification Levels

Every informal method exists in all four levels (e.g., `verifyEqual`/`assertEqual`/`assumeEqual`/`fatalAssertEqual`). Additionally, `fatalAssert*` stops the entire test class — use only for critical setup failures.

## Floating-Point Comparisons

**`AbsTol` and `RelTol` are only supported on `*Equal` methods.** No other informal methods accept tolerances.

### Choosing Tolerances

| Scenario | Recommended |
|----------|-------------|
| Small values near zero | AbsTol only |
| Large values | RelTol only |
| Mixed magnitudes | Both |
| Single precision | AbsTol = 1e-6, RelTol = 1e-5 |
| Double precision | AbsTol = 1e-14, RelTol = 1e-12 |

## Warning Verification

```matlab
testCase.verifyWarning(@() processData(edgeCase), 'MyApp:DataTruncated');
```

## Diagnostic Messages

Add a diagnostic message when the failure cause wouldn't be obvious from the assertion alone (e.g., inside parameterized tests or when multiple similar assertions appear in one method):

```matlab
testCase.verifyEqual(result, expected, ...
    sprintf('Failed for input=%d', input));
```

## Constraint Objects

**Prefer informal APIs** (`verifyEqual`, `verifyGreaterThan`, `verifySubstring`, etc.) over `verifyThat` with constraint objects. Only use `verifyThat` when informal APIs cannot express the check.

### Informal API Selection

Most constraints map directly to an informal equivalent matching their name (e.g., `IsTrue` → `verifyTrue`, `IsEmpty` → `verifyEmpty`, `IsGreaterThan` → `verifyGreaterThan`). Only `*Equal` methods support `AbsTol`/`RelTol`.

Non-obvious mappings:

| Constraint class | Informal equivalent |
|---|---|
| `HasElementCount` | `verifyNumElements` |
| `ContainsSubstring` | `verifySubstring` |
| `MatchesRegexp` | `verifyMatches` |
| `Throws` | `verifyError` |
| `IssuesWarnings` | `verifyWarning` |
| `IssuesNoWarnings` | `verifyWarningFree` |

### When to Use `verifyThat`

Use `verifyThat` (or `assertThat`/`assumeThat`/`fatalAssertThat`) only for these — no informal equivalent exists:

- `StartsWithSubstring`, `EndsWithSubstring`
- `IsFinite`, `IsReal`, `IsSameSetAs`
- `EveryElementOf(...)`, `AnyElementOf(...)`
- Boolean combinations (`&`, `|`, `~`)

```matlab
import matlab.unittest.constraints.*

testCase.verifyThat(value, IsEmpty | IsEqualTo(0));
testCase.verifyThat(x, IsGreaterThan(0) & IsLessThan(10));
testCase.verifyThat(array, EveryElementOf(IsGreaterThan(0)));
testCase.verifyThat(email, IsValidEmail);
```

## Custom Constraints

Extend `matlab.unittest.constraints.Constraint` for domain-specific checks. Implement `satisfiedBy(~, actual)` (returns logical) and `getDiagnosticFor(constraint, actual)` (returns `StringDiagnostic`). Use via `testCase.verifyThat(value, MyConstraint)`.
