# Mocking

Mock objects and stubs for isolating code under test.

**Test classes that use mocks must extend `matlab.mock.TestCase`**, not `matlab.unittest.TestCase`. `matlab.mock.TestCase` is a subclass of `matlab.unittest.TestCase`, so all standard assertions and verifications still work.

## Creating Mocks

| Pattern | Syntax |
|---|---|
| Abstract class/interface | `testCase.createMock(?IDataService)` |
| Concrete class | `testCase.createMock(?MException, 'ConstructorInputs', {'My:ID', 'msg'})` |
| Implicit interface (no superclass) | `testCase.createMock('AddedMethods', {'buy', 'sell'})` |

All return `[mock, behavior]`. For concrete classes, only non-`Sealed` methods can be overridden. Use `'MockedMethods', {'fetch', 'connect'}` to limit which methods are mocked (improves performance).

## Defining Mock Behavior

### Return Values

```matlab
import matlab.mock.withAnyInputs
import matlab.mock.withExactInputs

testCase.assignOutputsWhen(behavior.calculate(5), 25);               % specific input
testCase.assignOutputsWhen(withAnyInputs(behavior.calculate), 0);    % any input
testCase.assignOutputsWhen(withExactInputs(behavior.calculate), -1); % exact arguments match
testCase.assignOutputsWhen(behavior.divide(10, 2), 5, 0);            % multiple outputs
```

More specific conditions override general ones (e.g., `behavior.calculate(5)` takes precedence over `withAnyInputs(behavior.calculate)`).

### Throwing Errors

```matlab
testCase.throwExceptionWhen( ...
    behavior.connect(), ...
    MException('Network:Timeout', 'Connection timed out'));
```

### Returning Sequence of Values

Use `when()` directly (not `testCase.assignOutputsWhen`) when chaining actions with `.then()` or using `StoreValue`/`ReturnStoredValue`. `testCase.assignOutputsWhen(spec, val)` is a convenience wrapper for the simple case of `when(spec, AssignOutputs(val))`.

```matlab
import matlab.mock.actions.AssignOutputs

when(behavior.getNext(), ...
    AssignOutputs(1).then(AssignOutputs(2)).then(AssignOutputs(3)));
```

## Property Behavior

Use `get(behavior.Prop)` and `set(behavior.Prop)` to control mock properties. **Warning:** bare `behavior.Prop` (without `get`/`set`) is only valid for verification — using it to define behavior silently does nothing.

```matlab
% Return a value when property is read
testCase.assignOutputsWhen(get(behavior.Name), "Alice");

% Throw when property is read
testCase.throwExceptionWhen(get(behavior.Status), ...
    MException('Mock:Denied', 'Access denied'));

% Store values when property is set (enables round-trip get/set)
import matlab.mock.actions.StoreValue
import matlab.mock.actions.ReturnStoredValue
when(set(behavior.Name), StoreValue);
when(get(behavior.Name), ReturnStoredValue);
```

## Verifying Interactions

Prefer informal APIs — the direct qualification methods on `matlab.mock.TestCase`: `verifyCalled`, `verifyNotCalled`, `verifyAccessed`, `verifyNotAccessed`, `verifySet`, `verifyNotSet`. Use `verifyThat` with constraints only for call counts, value-specific property checks, or when no informal API exists.

```matlab
import matlab.mock.withAnyInputs
import matlab.mock.constraints.WasCalled
import matlab.mock.constraints.WasSet

% Method calls - Informal APIs
testCase.verifyCalled(behavior.log('Processing started'));
testCase.verifyNotCalled(behavior.delete());

% Call count (requires constraint)
testCase.verifyThat(withAnyInputs(behavior.save), WasCalled('WithCount', 3));

% Property access - Informal APIs
testCase.verifyAccessed(behavior.Name);
testCase.verifyNotAccessed(behavior.Cache);
testCase.verifySet(behavior.Color);
testCase.verifyNotSet(behavior.ReadOnlyProp);

% Property set to specific value (requires constraint)
testCase.verifyThat(behavior.Color, WasSet('ToValue', "red"));
```

## Input Matchers

```matlab
import matlab.mock.withAnyInputs
import matlab.mock.AnyArguments
import matlab.unittest.constraints.IsGreaterThan

% Match any input
testCase.assignOutputsWhen(withAnyInputs(behavior.process), result);

% Match specific criteria using unittest constraints as argument matchers
testCase.assignOutputsWhen( ...
    behavior.deposit(IsGreaterThan(0)), ...
    true);

% Match any trailing arguments
testCase.assignOutputsWhen(behavior.log('error', AnyArguments), true);
```

## Partial Mocks (Spies)

**Use sparingly.** Needing to mock some methods of a class while keeping others often signals the class has mixed responsibilities. Prefer redesigning the code to inject dependencies instead. Use partial mocks only when you cannot change the production code:

```matlab
[mock, behavior] = testCase.createMock(?Calculator, ...
    'ConstructorInputs', {}, ...
    'MockedMethods', {'expensiveOperation'});

testCase.assignOutputsWhen(behavior.expensiveOperation(), 42);

result = mock.add(2, 3);              % Returns 5 (real method)
expensive = mock.expensiveOperation(); % Returns 42 (mocked)
```

## Simple Stub (No Mock Framework)

For simple cases, use function handles:

```matlab
function testWithStub(testCase)
    stubFetch = @(id) struct('name', 'Test', 'value', 42);

    result = processData(stubFetch);

    testCase.verifyEqual(result.value, 42);
end
```

## Best Practices

1. **Mock at boundaries** — External services, not internal classes
2. **Verify interactions sparingly** — Focus on outcomes, not implementation
3. **Keep mocks simple** — Complex mock setup = design smell
4. **Prefer stubs over mocks** — When you don't need to verify calls
