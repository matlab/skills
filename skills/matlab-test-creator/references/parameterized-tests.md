# Parameterized Tests

Data-driven testing using `TestParameter` properties.

## Basic Parameterized Test

```matlab
properties (TestParameter)
    format = {'png', 'jpg', 'bmp'};
end

methods (Test)
    function testExportCreatesFile(testCase, format)
        exportChart('test', format);
        testCase.verifyTrue(isfile(['test.' format]));
    end
end
```

## Named Parameters with Structs

Use structs for clearer test names and grouped input/expected data.

```matlab
properties (TestParameter)
    rectangleCase = struct(...
        'small', struct('input', [2 3], 'expected', 6), ...
        'large', struct('input', [10 20], 'expected', 200));
end

methods (Test)
    function testRectangleArea(testCase, rectangleCase)
        area = calculateArea(rectangleCase.input(1), rectangleCase.input(2));
        testCase.verifyEqual(area, rectangleCase.expected);
    end
end
```

## Parameter Combinations

| Mode | What it does | When to use |
|------|-------------|-------------|
| `exhaustive` (default) | Every combination of all parameters | 1-2 parameters, or when every combination genuinely matters (e.g., data type × array shape) |
| `sequential` | Zips parameters positionally (1st with 1st, 2nd with 2nd, etc.) | Input-output pairs that must stay aligned. All parameters must have the same number of values. |
| `pairwise` | Covers all 2-way interactions between parameters, skipping redundant higher-order combinations | 3+ parameters where exhaustive produces too many tests |

> **MATLAB Test add-on (R2023a+):** If you have a MATLAB Test license, you can set `ParameterCombination` to an integer between 2 and 10 to test every n-tuple of parameter values — e.g., `ParameterCombination = 3` covers all 3-way interactions. This generalizes `pairwise` (which is equivalent to n = 2) for cases where higher-order interactions matter.

**Watch for combinatorial explosion with `exhaustive`**: 4 parameters × 5 values each = 625 tests. If that's excessive, use `pairwise`, an n-wise integer (MATLAB Test required), or reduce parameters.

```matlab
% exhaustive (default) — every combination
methods (Test)
    function testConversion(testCase, dataType, arrayShape)
        % test logic here
    end
end

% sequential — paired (must be same length)
methods (Test, ParameterCombination = 'sequential')
    function testPairedInputs(testCase, input, expected)
        testCase.verifyEqual(myFunction(input), expected);
    end
end

% pairwise — all 2-way interactions, fewer tests than exhaustive
methods (Test, ParameterCombination = 'pairwise')
    function testMultipleFactors(testCase, dataType, arrayShape, solver, tolerance)
        % test logic here
    end
end
```

> **Sequential alternative**: If your inputs and expected outputs are paired, a single struct parameter (see Named Parameters above) is often cleaner than `sequential` — it keeps pairs together, avoids length-mismatch errors, and produces more descriptive test names.

## Edge Case Parameters

Include edge cases relevant to the function under test — don't add every possible edge case. Pick from the function's input domain:

```matlab
properties (TestParameter)
    numericEdge = struct('zero', 0, 'negative', -1, 'large', 1e15, 'nan', NaN);
    arrayEdge = struct('empty', [], 'scalar', 5, 'row', [1 2 3], 'column', [1; 2; 3]);
end
```

## Dynamic Parameters with TestParameterDefinition

Use when parameters should refresh each run (e.g., files in a folder) or depend on a higher-level parameter. Property defaults are fixed at class load; `TestParameterDefinition` methods recompute each time you create the suite.

Rules:
- Method must be `Static` with attribute `TestParameterDefinition`
- Output variable name must match the `TestParameter` property (declared with no default)
- Inputs can reference `TestParameter` properties at a higher parameterization level (e.g., a `ClassSetupParameter` or `MethodSetupParameter` property)

**Example 1 — parameters from the filesystem:**

```matlab
properties (TestParameter)
    dataFile  % No default — populated by method below
end

methods (Static, TestParameterDefinition)
    function dataFile = getDataFiles()
        listing = dir('testdata/*.mat');
        dataFile = struct();
        for i = 1:numel(listing)
            [~, name] = fileparts(listing(i).name);
            dataFile.(matlab.lang.makeValidName(name)) = ...
                fullfile(listing(i).folder, listing(i).name);
        end
    end
end
```

**Example 2 — test parameters that depend on a higher-level (`ClassSetupParameter`) value:**

```matlab
properties (ClassSetupParameter)
    precision = {'single', 'double'};
end

properties (TestParameter)
    tolerance  % No default — depends on precision
end

methods (Static, TestParameterDefinition)
    function tolerance = getTolerance(precision)
        if strcmp(precision, 'single')
            tolerance = struct('loose', 1e-4, 'tight', 1e-6);
        else
            tolerance = struct('loose', 1e-10, 'tight', 1e-14);
        end
    end
end
```

Here `getTolerance` receives the `ClassSetupParameter` value as input, so test-parameter values are computed per class-level setup combination.

## Best Practices

0. **Parameterize only when assertion logic is identical across all cases** — if the test body would need an `if/switch` to handle a value differently, use a separate test instead
1. **Use meaningful parameter names** — They appear in test results and serve as documentation
2. **Group related values in structs** — Keeps input/expected together, avoids misaligned `sequential` pairs
3. **Keep parameter tables small** — If a table keeps growing, consider whether all rows truly test the same logic
4. **Use the right parameterization level** — `TestParameter` is for test data; use `ClassSetupParameter` for expensive shared fixtures (e.g., opening a connection) and `MethodSetupParameter` for per-test configuration
