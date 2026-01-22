# designfilt Reference Card

Open this card **before** writing any `designfilt(...)` call.

## Response Type Quick Reference

| Filter type | Response string | Key parameters |
|-------------|-----------------|----------------|
| Lowpass FIR | `"lowpassfir"` | `PassbandFrequency`, `StopbandFrequency` |
| Lowpass IIR | `"lowpassiir"` | `PassbandFrequency`, `StopbandFrequency` |
| Highpass FIR | `"highpassfir"` | `StopbandFrequency`, `PassbandFrequency` |
| Highpass IIR | `"highpassiir"` | `StopbandFrequency`, `PassbandFrequency` |
| Bandpass FIR | `"bandpassfir"` | `PassbandFrequency=[f1 f2]` (vector OK) |
| Bandpass IIR | `"bandpassiir"` | `PassbandFrequency1`, `PassbandFrequency2` (scalar!) |
| Bandstop FIR | `"bandstopfir"` | `StopbandFrequency=[f1 f2]` (vector OK) |
| Bandstop IIR | `"bandstopiir"` | `StopbandFrequency1`, `StopbandFrequency2` (scalar!) |
| **Notch (single tone)** | `"notchiir"` | `CenterFrequency`, `QualityFactor` |
| Peak (boost) | `"peakiir"` | `CenterFrequency`, `QualityFactor`, `PassbandRipple` |

## Core Patterns

### FIR (linear phase by default)

```matlab
d = designfilt("lowpassfir", ...
    PassbandFrequency=Fpass, StopbandFrequency=Fstop, ...
    PassbandRipple=Rp, StopbandAttenuation=Rs, ...
    SampleRate=Fs, DesignMethod="equiripple");
```

### IIR (minimum order)

```matlab
d = designfilt("lowpassiir", ...
    PassbandFrequency=Fpass, StopbandFrequency=Fstop, ...
    PassbandRipple=Rp, StopbandAttenuation=Rs, ...
    SampleRate=Fs, DesignMethod="ellip");
```

### Notch (single tone removal)

```matlab
d = designfilt("notchiir", ...
    CenterFrequency=f0, QualityFactor=Q, ...
    SampleRate=Fs);
```

**Q guidelines**: 10-50 typical. Higher Q = sharper notch but more ringing.

### Bandpass IIR (scalar edges required!)

```matlab
d = designfilt("bandpassiir", ...
    StopbandFrequency1=fs1, PassbandFrequency1=f1, ...
    PassbandFrequency2=f2,  StopbandFrequency2=fs2, ...
    PassbandRipple=Rp, ...
    StopbandAttenuation1=Rs, StopbandAttenuation2=Rs, ...
    SampleRate=Fs, DesignMethod="ellip");
```

## Design Methods

| Method | Characteristics |
|--------|-----------------|
| `"ellip"` | Minimum order, equiripple in pass & stop |
| `"butter"` | Maximally flat, monotonic response |
| `"cheby1"` | Ripple in passband only |
| `"cheby2"` | Ripple in stopband only |
| `"equiripple"` | Parks-McClellan (FIR only) |

## SystemObject=true (streaming)

For streaming applications, get a System object directly:

```matlab
% Returns dsp.SOSFilter (IIR) or dsp.FIRFilter (FIR)
sosFilter = designfilt("lowpassiir", ...
    PassbandFrequency=Fpass, StopbandFrequency=Fstop, ...
    SampleRate=Fs, DesignMethod="ellip", ...
    SystemObject=true);

y = sosFilter(x);  % Stateful, ready for streaming
```

---

## Gotchas

### IIR bandpass/bandstop vector error

**Wrong**:
```matlab
d = designfilt("bandpassiir", ...
    PassbandFrequency=[300 3400], ...);  % ERROR! Vector not allowed for IIR
```

**Correct**: Use scalar properties with `...1`/`...2` suffixes.

**Note**: FIR bandpass/bandstop CAN use vectors: `PassbandFrequency=[f1 f2]`

### Deprecated Coefficients property

**Wrong**: `sos = d.Coefficients;` (removed in recent versions)

**Correct**:
```matlab
B = d.Numerator;      % Lx3 per-section
A = d.Denominator;    % Lx3 per-section
sos = [B A];          % Lx6 if needed
```

### Manual dsp.SOSFilter vs SystemObject=true

Don't manually extract coefficients to create a System object:
```matlab
% Inefficient
d = designfilt(...); B = d.Numerator; A = d.Denominator;
sosFilter = dsp.SOSFilter('Numerator', B, 'Denominator', A);

% Efficient - get System object directly
sosFilter = designfilt(..., SystemObject=true);
```

### Ultra-high-Q notch (excessive ringing)

**Problematic**: `QualityFactor=1000` causes long ringing

**Better**: Use moderate Q (10-50). For multiple tones, use several moderate notches instead of one ultra-sharp notch.

---

## iirnotch / iircomb (alternative to designfilt)

For simple notch filters, `iirnotch` is a quick alternative:

```matlab
wo = f0/(Fs/2);      % Normalized frequency
bw = bandwidth/(Fs/2);  % Normalized bandwidth
[b, a] = iirnotch(wo, bw);
y = filter(b, a, x);
```

**Note**: Returns `[b, a]` coefficients, not a digitalFilter object.
