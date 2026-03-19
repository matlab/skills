% printCoverageGaps — Print uncovered items from coverage results.
%
% Inputs (must exist in the caller's workspace from the Collect step):
%   covResults  — array of CoverageResult objects
%
% Include tiers up to the MetricLevel used in the Collect step.
% Cut the block at the comment matching your MetricLevel:
%   default (no MetricLevel) → keep statement & function only
%   "decision"               → keep through decision
%   "condition"              → keep through condition
%   "mcdc"                   → keep all

% --- statement & function (always available) ---
for type = ["statement", "function"]
    [~, desc] = coverageSummary(covResults, type);
    items = desc.(type);
    uncov = items([items.ExecutionCount] == 0);
    for i = 1:numel(uncov)
        fprintf('Uncovered %s: %s:%d (%s)\n', type, uncov(i).Filename, ...
            uncov(i).SourceLocation.StartLine, uncov(i).FunctionName);
    end
end

% --- decision (MetricLevel "decision"+) ---
[~, desc] = coverageSummary(covResults, "decision");
for i = 1:numel(desc.decision)
    d = desc.decision(i);
    for j = 1:numel(d.Outcome)
        if d.Outcome(j).ExecutionCount == 0
            fprintf('Uncovered decision: %s:%d — %s → %s\n', ...
                d.Filename, d.SourceLocation.StartLine, d.Text, d.Outcome(j).Text);
        end
    end
end

% --- condition (MetricLevel "condition"+) ---
[~, desc] = coverageSummary(covResults, "condition");
for i = 1:numel(desc.condition)
    d = desc.condition(i); m = string.empty;
    if d.TrueCount == 0, m(end+1) = "true"; end
    if d.FalseCount == 0, m(end+1) = "false"; end
    if ~isempty(m)
        fprintf('Uncovered condition: %s:%d — %s → %s\n', ...
            d.Filename, d.SourceLocation.StartLine, d.Text, join(m, ", "));
    end
end

% --- mcdc (MetricLevel "mcdc") ---
[~, desc] = coverageSummary(covResults, "mcdc");
for i = 1:numel(desc.mcdc)
    d = desc.mcdc(i);
    for j = 1:numel(d.Condition)
        if ~d.Condition(j).Achieved
            fprintf('Unachieved MC/DC: %s:%d — %s → %s\n', ...
                d.Filename, d.SourceLocation.StartLine, d.Text, d.Condition(j).Text);
        end
    end
end
