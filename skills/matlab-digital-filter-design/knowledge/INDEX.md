# Knowledge Index

**Cards contain critical gotchas. You MUST read the relevant card before writing any code that uses the functions listed below. Skipping cards causes errors.**

- **Cards**: Short, task-focused. Read before calling specific functions.
- **Guides**: Deep reference. Read when you need full context.

---

## Function-Level Routing (read the card or you WILL hit errors)

| Function / Pattern | Card to read |
|--------------------|--------------|
| `designfilt(...)` any response | `cards/designfilt.md` |
| `iirnotch(...)`, `iircomb(...)` | `cards/designfilt.md` |
| `ifir(...)`, `design(..., 'ifir')` | `cards/multistage-ifir.md` |
| `filterAnalyzer(...)` | `cards/filter-analyzer.md` |
| `dsp.FIRDecimator`, `dsp.FIRInterpolator` | `cards/multirate-streaming.md` |
| `resample(...)` for filtering | `cards/multirate-offline.md` |
| High-order IIR (>8), long FIR (>100 taps), `freqz`/`grpdelay` | `cards/general-iir-fir.md` |

---

## Task-Level Routing

| Trigger / task | Card to read | Guide (if needed) |
|----------------|--------------|-------------------|
| `trans_pct < 2%` or "very sharp / tight transition" | `cards/efficient-filtering.md` | `efficient-filtering.md` |
| Cost comparison / "fastest/cheapest" / MPIS | `cards/efficient-filtering.md` | `efficient-filtering.md` |
| Using **Filter Analyzer** (`filterAnalyzer`, session mgmt, overlays) | `cards/filter-analyzer.md` | `filter-analyzer.md` |
| **Multirate OFFLINE** (rate change + zero-phase) | `cards/multirate-offline.md` | `multirate.md` |
| **Multirate STREAMING** (polyphase System objects) | `cards/multirate-streaming.md` | `multirate.md` |
| **Constant-rate multistage FIR** (IFIR method) | `cards/multistage-ifir.md` | `multistage-ifir.md` |

---

## Card Summary

| Card | Purpose | ~Lines |
|------|---------|--------|
| `cards/designfilt.md` | Response types, params, gotchas | ~110 |
| `cards/general-iir-fir.md` | High-order IIR, long FIR, freqz, filtfilt | ~80 |
| `cards/efficient-filtering.md` | Narrow transitions, MPIS comparison | ~130 |
| `cards/filter-analyzer.md` | Filter Analyzer API | ~100 |
| `cards/multirate-offline.md` | Offline zero-phase with rate change | ~60 |
| `cards/multirate-streaming.md` | Streaming polyphase pipelines | ~75 |
| `cards/multistage-ifir.md` | IFIR at constant rate | ~95 |

---

## Guides (deep reference, rarely needed full)

| Guide | Content | ~Lines |
|-------|---------|--------|
| `patterns.md` | Streaming wrappers, advanced patterns | ~400 |
| `best-practices.md` | Methodology, validation flow | ~375 |
| `filter-analyzer.md` | Full Filter Analyzer reference | ~515 |
| `multirate.md` | Complete multirate theory + examples | ~405 |
| `efficient-filtering.md` | Deep dive on narrow transitions | ~375 |
| `multistage-ifir.md` | IFIR theory and variants | ~290 |
