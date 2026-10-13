# S04-5: HIS decode and PCM parity

**Status:** OPEN. Parent S04 remains open.

**Goal:** Reconstruct the original HIS resource decode and sample conversion path sufficiently to compare decoded PCM and boundary behavior with the native implementation.

**Starting evidence:** S04-1 hooks `0x4f379c` as a successful HIS resource boundary and does not decode. Existing HIS quantization evidence is `outputs/blackmoor-decomp/his-pcm-quantization-validation.md`.

**Scope:** Recover format/codec control flow and sample conversion from immutable original code/assets, distinguish decoder behavior from native output-device behavior, and retain only derived summaries in private evidence. Do not publish proprietary resource bytes or generated resource dumps.

**Acceptance:** Hash code and native library/executable; compare original and native decoded PCM over representative assets and boundary/malformed inputs; document exact hook list and fidelity limits; add offline tests with no output device; provide an integration proposal. No GUI or hardware playback.

**Files:** New decoder-specific module/tests/evidence only; shared audio/app code remains integrator-owned.
