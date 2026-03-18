% collectCoverageGaps — Build a gaps struct from coverage results.
%
% Inputs (must exist in the caller's workspace from the Collect step):
%   covResults  — array of CoverageResult objects
%   filenames   — string column vector of filenames from covResults
%
% Output:
%   gaps        — struct with fields: statement, function, decision,
%                 condition, mcdc (tables of uncovered items)
%
% Include tiers up to the MetricLevel used in the Collect step.
% Cut the block at the comment matching your MetricLevel:
%   default (no MetricLevel) → keep statement & function only
%   "decision"               → keep through decision
%   "condition"              → keep through condition
%   "mcdc"                   → keep all

gaps = struct();

% --- statement & function (always available) ---
for type = ["statement", "function"]
    File = string.empty; Line = double.empty; FunctionName = string.empty;
    for r = 1:numel(covResults)
        [~, desc] = coverageSummary(covResults(r), type);
        items = desc.(type);
        for i = 1:numel(items)
            if items(i).ExecutionCount == 0
                File(end+1,1) = filenames(r);
                Line(end+1,1) = items(i).SourceLocation.StartLine;
                FunctionName(end+1,1) = items(i).FunctionName;
            end
        end
    end
    gaps.(type) = table(File, Line, FunctionName);
end

% --- decision (MetricLevel "decision"+) ---
File = string.empty; Line = double.empty; Dec = string.empty; MissedOutcome = string.empty;
for r = 1:numel(covResults)
    [~, desc] = coverageSummary(covResults(r), "decision");
    for i = 1:numel(desc.decision)
        d = desc.decision(i); missed = string.empty;
        for j = 1:numel(d.Outcome)
            if d.Outcome(j).ExecutionCount == 0, missed(end+1) = d.Outcome(j).Text; end
        end
        if ~isempty(missed)
            File(end+1,1) = filenames(r); Line(end+1,1) = d.SourceLocation.StartLine;
            Dec(end+1,1) = d.Text; MissedOutcome(end+1,1) = join(missed, ", ");
        end
    end
end
gaps.decision = table(File, Line, Dec, MissedOutcome);

% --- condition (MetricLevel "condition"+) ---
File = string.empty; Line = double.empty; Cond = string.empty; Missed = string.empty;
for r = 1:numel(covResults)
    [~, desc] = coverageSummary(covResults(r), "condition");
    for i = 1:numel(desc.condition)
        d = desc.condition(i); m = string.empty;
        if d.TrueCount == 0, m(end+1) = "true"; end
        if d.FalseCount == 0, m(end+1) = "false"; end
        if ~isempty(m)
            File(end+1,1) = filenames(r); Line(end+1,1) = d.SourceLocation.StartLine;
            Cond(end+1,1) = d.Text; Missed(end+1,1) = join(m, ", ");
        end
    end
end
gaps.condition = table(File, Line, Cond, Missed);

% --- mcdc (MetricLevel "mcdc") ---
File = string.empty; Line = double.empty; Dec = string.empty; Cond = string.empty;
for r = 1:numel(covResults)
    [~, desc] = coverageSummary(covResults(r), "mcdc");
    for i = 1:numel(desc.mcdc)
        d = desc.mcdc(i);
        for j = 1:numel(d.Condition)
            if ~d.Condition(j).Achieved
                File(end+1,1) = filenames(r); Line(end+1,1) = d.SourceLocation.StartLine;
                Dec(end+1,1) = d.Text; Cond(end+1,1) = d.Condition(j).Text;
            end
        end
    end
end
gaps.mcdc = table(File, Line, Dec, Cond);
