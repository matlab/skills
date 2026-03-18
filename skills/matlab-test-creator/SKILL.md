---
name: matlab-test-creator
description: Create comprehensive MATLAB unit tests using the MATLAB Testing Framework. Use when generating test files, test cases, unit tests, or when the user requests testing for MATLAB code, functions, or classes.
license: MathWorks BSD-3-Clause (see LICENSE)
---

# MATLAB Test Generator

Generate robust unit tests using the MATLAB Testing Framework. This skill covers:

- **Test Creation**: Writing test classes, methods, fixtures, assertions, and mocks

## Must-Follow Rules

- **Present a test plan if needed** - Create a user-approved test plan before writing test code unless the scope is limited and straightforward.
- **Show diff before updating** - For existing test files, always show the user a diff and wait for approval before editing.
- **Always use class-based tests** - Every test file must define a class inheriting from `matlab.unittest.TestCase`. Never use function-based or script-based tests.
- **Do not guess requirements** - If scope or expected behaviors are unclear, **ask**

---

# Test Creation

## Test Class Template

Add properties, `TestParameter`, and setup/teardown blocks as needed.

```matlab
classdef MyFunctionTest < matlab.unittest.TestCase

    methods (Test)
        % Individual test methods
    end
end
```

## Critical Rules

### File Naming
- Test files MUST end with `Test.m` (e.g., `myFunctionTest.m`)
- Class name must match filename

### Test Method Naming
- Descriptive camelCase names starting with lowercase
- Example: `testAdditionWithPositiveNumbers`

### Test location
Ideally, add all test files to a `tests/` folder alongside the source

### Properties
Use Mixed case unless it's a TestParameter. For a TestParameter, use camelCase. Only use properties if local variables won't suffice.

### Assertions / Qualifications
- Prefer `verify*` methods (continue on failure) over `assert*` (stop on failure)
- Use `verifyError(@() func(args), "errorID")` for error testing
- Use `verifyWarningFree(@() func(args))` for clean execution
- Prefer informal APIs over `verifyThat` calls
- **Floating-point comparisons should use tolerance:**
  ```matlab
  testCase.verifyEqual(actual, expected, AbsTol=1e-10);
  testCase.verifyEqual(actual, expected, RelTol=1e-6);
  ```
- For advanced verification, constraint objects, and custom constraints see [references/constraints.md](references/constraints.md)

### No Logic in Tests
- **No `if`, `switch`, `for`, or `try/catch` in test methods.** If a test needs conditionals, split into separate methods.
- Follow the **Arrange-Act-Assert** pattern: set up inputs, call the code under test, verify the result. Nothing else.

### Using TestParameter
Parameterize only when **assertion logic is identical** across all cases — only the data varies. Use separate test methods when cases need different assertions, tolerances, setup, or when you'd need conditionals to distinguish them.

### Test Scope
- **Test public interfaces, not implementation.** Never test private methods directly — verify correctness through the public API.
- If a private method seems complex enough to need its own tests, the user should refactor it into a separate, publicly testable function.

### Determinism
For tests involving randomness, seed the RNG and restore it:
```matlab
methods (TestMethodSetup)
    function resetRandomSeed(testCase)
        originalRng = rng;
        testCase.addTeardown(@() rng(originalRng));
        rng(42, "twister");
    end
end
```

### Test Assumptions
Most tests do not need assumptions. Only add `assume*` when a test absolutely requires specific environment prerequisites that may not be present on all machines:
```matlab
testCase.assumeTrue(canUseGPU(), "Requires GPU");
```

### Test Tagging
Use `TestTags` attribute (e.g., `'Unit'`, `'Integration'`, `'Slow'`, `'GPU'`) on `methods (Test)` blocks for selective execution.

### Test independence
Each test should be able to run independently and be compatible with running tests in parallel.

### Adding path to source files
Use PathFixture to add paths so the tests have access to the source if needed. Use `IncludingSubfolders` when there are nested packages or subdirectories that also need to be on the path:

```matlab
methods (TestClassSetup)
    function addSourceToPath(testCase)
        srcFolder = fullfile(fileparts(fileparts(mfilename('fullpath'))), 'src');
        testCase.applyFixture(matlab.unittest.fixtures.PathFixture(srcFolder, ...
            IncludingSubfolders=true));
    end
end
```

For more details, if necessary, see [references/fixtures.md](references/fixtures.md).

### Diagnostics
Add additional diagnostics for clarity where the framework diagnostic may be insufficient.

# Test Planning

**Assess complexity first, then follow the appropriate path.**

### Simple tests (source code provided, clear behavior, no mocks/fixtures/parameterization)

1. Briefly state what you'll test (methods + key edge cases)
2. Write the test file after user confirms

### Standard tests (Large codebase, multiple comprehensive test files) — 3-phase workflow: Gather → Plan → Implement

## Phase 1: Gather Requirements

### Checklist: Information needed (ask if unknown)

- [ ] **Code to test** - Provide path or content of the function/class to test
- [ ] **Expected behaviors** - What should the code do in normal cases?
- [ ] **Error conditions** - What inputs should cause errors/warnings?
- [ ] **Test scope**: Unit (isolated), Integration (with dependencies), or System?
- [ ] **External dependencies**: Files, databases, network, hardware?
- [ ] **Determinism needs**: Random numbers, timestamps, or other non-deterministic behavior?
- [ ] **Deployment targets**: MATLAB Coder or Compiler SDK? If yes, recommend equivalence testing via `matlabtest.coder.TestCase` / `matlabtest.compiler.TestCase`.

## Phase 2: Present Test Plan for Approval

Present a test plan. Do NOT write any test files until the user confirms the plan. A plan may include: list of test methods with names, which behaviors each covers, parameterization strategy, fixtures needed, and edge cases selected

### Edge Cases to Consider

- Empty inputs (`[]`, `''`, `{}`)
- Boundary values (0, 1, -1, max, min)
- Invalid types (string instead of number, etc.)
- Large inputs (performance/memory)
- Special values (NaN, Inf, -Inf)

## Phase 3: Implement Approved Plan

Apply reference card patterns. Write new test files or show diffs for existing files (per Must-Follow Rules).

# References

In many cases, what's present in this file should be sufficient. Do not read the references cards unless the conditions stated in the table are met.

| Load when code under test... | Card |
|---|---|
| Uses setup/teardown, temp files, figures, database connections, shared state, or needs built-in fixtures | [references/fixtures.md](references/fixtures.md) |
| Involves floating-point math needing tolerance selection, constraint objects (`verifyThat`), or custom constraints | [references/constraints.md](references/constraints.md) |
| Needs multiple `TestParameter` properties, dynamic parameters (`TestParameterDefinition`), or help with cross-product pitfalls | [references/parameterized-tests.md](references/parameterized-tests.md) |
| Depends on external services, needs mock objects, or requires dependency injection | [references/mocking.md](references/mocking.md) |
