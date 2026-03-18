---
name: matlab-test-execution
description: Run MATLAB tests, analyze results, collect code coverage, and set up CI/CD pipelines. Use when executing tests, filtering test suites, debugging test failures, generating coverage reports, or configuring buildtool and CI systems for MATLAB projects.
license: MathWorks BSD-3-Clause (see LICENSE)
metadata:
  author: MathWorks
  version: "1.0"
---

# MATLAB Test Execution

## Must-Follow Rules

- **Execute MATLAB via MCP** — If the MATLAB MCP core server is available, use its `evaluate_matlab_code` tool to run MATLAB commands. Fall back to `matlab -batch` only if the MCP server is not available.
- **Use buildtool for CI** — When running tests in CI/CD, always use `buildtool` with a `buildfile.m`. Do not use manual `runtests` or `TestRunner` scripts in CI.
- **Do not guess** — If the test folder location, source folder, or desired output format is unclear, **ask**.

---

## Running Tests

```matlab
results = runtests('tests');                          % All tests in a directory
results = runtests('myFunctionTest');                  % Specific test file
results = runtests('myFunctionTest/testAddition');     % Specific test method
```

### Filtering

```matlab
results = runtests('tests', 'Name', '*Calculator*');   % By name pattern
results = runtests('tests', 'Tag', 'Unit');            % By tag
results = runtests('tests', 'ExcludeTag', 'Slow');     % Exclude tag
results = runtests('tests', 'ProcedureName', 'testX'); % By procedure name
results = runtests('tests', 'UseParallel', true);      % Parallel execution
results = runtests('tests', 'Strict', true);            % Treat warnings as failures
results = runtests('tests', 'Debug', true);             % Enter debugger on failure
results = runtests('tests', 'OutputDetail', 'Detailed');% Verbose diagnostics
```

**Parallel requirements**: Tests must be independent — no shared state, no order dependence, no shared file system artifacts.

For advanced control (custom plugins, programmatic suite manipulation), use `matlab.unittest.TestRunner` with `testsuite` and `runner.run(suite)`. See the Code Coverage section for an example.

## Analyzing Test Results

```matlab
results = runtests('tests');

nPassed = sum([results.Passed]);
nFailed = sum([results.Failed]);
nIncomplete = sum([results.Incomplete]);

% Inspect failures
failedResults = results([results.Failed]);
for i = 1:numel(failedResults)
    failedTestPoint = failedResults(i).Name;
    diagnostics = failedResults(i).Details.DiagnosticRecord;
    % if user needs to see the results, use the following as a guide to display results
    fprintf('\nFAILED: %s\n', failedTestPoint);
    disp(diagnostics.Report);
end
```

---

## Code Coverage

If code coverage is required (explicitly requested or clearly implied), follow these steps: **Collect** → **Display** (when user should see results) → **Identify gaps** (only when user asks to generate tests for missing coverage).

### 1. Collect

Run tests with coverage and extract per-file percentages in one pass. Include `CoverageResult` (programmatic) and `CoverageReport` (HTML). Add `CoberturaFormat` for CI. Use the highest `MetricLevel` available — `"mcdc"` if "MATLAB Test" is installed, otherwise omit it.

```matlab
import matlab.unittest.TestRunner
import matlab.unittest.plugins.CodeCoveragePlugin
import matlab.unittest.plugins.codecoverage.CoverageResult
import matlab.unittest.plugins.codecoverage.CoverageReport

runner = TestRunner.withTextOutput;
covFormat = CoverageResult;
runner.addPlugin(CodeCoveragePlugin.forFolder('src', ... % use forFile or forNamespace if needed
    'Producing', [covFormat, CoverageReport('coverage-report')], ...
    'MetricLevel', 'mcdc'));          % omit MetricLevel if MATLAB Test is unavailable
results = runner.run(testsuite('tests'));

% --- Extract percentages ---
covResults = covFormat.Result;
filenames = [covResults.Filename]';
% Set types to match MetricLevel: mcdc→all five, condition→first four,
% decision→first three, default (statement)→["statement","function"]
types = ["statement", "function", "decision", "condition", "mcdc"];
[covData, covTotals] = deal(NaN(numel(covResults), numel(types)), NaN(1, numel(types)));
for k = 1:numel(types)
    for j = 1:numel(covResults)
        [s, ~] = coverageSummary(covResults(j), types(k));
        if s(2) > 0, covData(j,k) = 100 * s(1) / s(2); end
    end
    [s, ~] = coverageSummary(covResults, types(k));
    ex = sum(s(:,1)); tot = sum(s(:,2));
    if tot > 0, covTotals(k) = 100 * ex / tot; end
end
```

### 2. Display summary — only when showing results to user

```matlab
File = [filenames; "TOTAL"];
T = array2table([covData; covTotals], 'VariableNames', types);
T = addvars(T, File, 'Before', 1);
disp(T);
```

### 3. Identify gaps — only when generating tests for missing coverage

Read [scripts/collectCoverageGaps.m](scripts/collectCoverageGaps.m) for the full implementation. It expects `covResults` and `filenames` from the Collect step and produces a `gaps` struct. Include tiers up to the `MetricLevel` used (the script has comments marking where to cut).

#### Display gaps — only when showing to user

```matlab
labels = struct('statement',"Uncovered Statements", 'function',"Uncovered Functions", ...
    'decision',"Uncovered Decision Outcomes", 'condition',"Uncovered Condition Outcomes", ...
    'mcdc',"Unachieved MC/DC Conditions");
for f = string(fieldnames(gaps))'
    if height(gaps.(f)) > 0, fprintf('\n%s:\n', labels.(f)); disp(gaps.(f)); end
end
```

### 4. Act on gaps if requested by the user

Use `gaps` from step 3 to target test generation — each table's `File` and `Line` columns pinpoint what needs coverage. Defer to the MATLAB test generation skill for writing tests.

---

## CI/CD Integration

Always use `buildtool` with a `buildfile.m` for CI.

### Example buildfile.m

```matlab
function plan = buildfile
    plan = buildplan(localfunctions);

    plan("clean") = matlab.buildtool.tasks.CleanTask;

    plan("check") = matlab.buildtool.tasks.CodeIssuesTask("src");

    plan("test") = matlab.buildtool.tasks.TestTask("tests", ...
        SourceFiles = "src", ...
        ReportFormat = ["html", "cobertura"], ...
        OutputDirectory = "reports");

    plan("package") = matlab.buildtool.tasks.PackageTask("toolbox.prj");

    plan("ci") = matlab.buildtool.Task( ...
        Description = "Full CI pipeline", ...
        Dependencies = ["check", "test", "package"]);

    plan.DefaultTasks = "test";
end
```

### Running buildtool

```matlab
buildtool              % Run default task
buildtool test         % Run specific task
```

### CI Pipeline Configurations

#### GitHub Actions

```yaml
# .github/workflows/matlab.yml
name: MATLAB Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: matlab-actions/setup-matlab@v2
      - uses: matlab-actions/run-build@v2
```

#### Azure DevOps

```yaml
# azure-pipelines.yml
trigger: [main]
pool:
  vmImage: 'ubuntu-latest'
steps:
  - task: InstallMATLAB@1
  - task: RunMATLABBuild@1
```

#### GitLab CI example

```yaml
# .gitlab-ci.yml
test:
  image: mathworks/matlab:r2024a
  script:
    - matlab -batch "buildtool"
```
