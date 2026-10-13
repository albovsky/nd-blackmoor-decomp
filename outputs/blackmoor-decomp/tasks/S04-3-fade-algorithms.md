# S04-3: Sound fade algorithms

**Status:** OPEN. Parent S04 remains open.

**Goal:** Recover the bodies and state effects of the three update-time calls reached when slot flags contain `0x20`: `0x4f9f92`, `0x4f8f94`, and `0x4f9040`.

**Starting evidence:** `outputs/blackmoor-decomp/tasks/S04-1-sound-control.md` proves call order only. Its native API keeps explicit injectable fade boundaries and does not claim their semantics.

**Scope:** Trace source bytes, state fields, timing and arithmetic for each branch; identify interaction with random-repeat and restart. Compare original x86 and native code using deterministic tick inputs. Keep original assets immutable and use no output device.

**Acceptance:** Record code-window hashes, test positive/negative/zero timing boundaries and wrap behavior found in source, preserve original mutation order/errors, add meaningful native/oracle comparisons, list hooks and unverified branches, and propose a reviewed host contract. No GUI or hardware output.

**Files:** New fade-specific child module/tests/evidence only. Shared audio and app files remain integrator-owned.
