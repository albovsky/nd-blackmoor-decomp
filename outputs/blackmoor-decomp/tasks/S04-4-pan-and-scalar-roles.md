# S04-4: Sound pan and attenuation scalar roles

**Status:** OPEN. Parent S04 remains open.

**Goal:** Establish whether the original's two stored attenuation values represent pan/left-right behavior or another pair, and recover every consumer that makes the distinction observable.

**Starting evidence:** `0x4fadc4` computes and stores two separate values; `0x4f684a` passes the first value to DirectSound SetVolume. No left/right interpretation is established. The S04-1 scene corpus scan found no unequal scalar pairs among 3,570 type-0x9f commands.

**Scope:** Trace original constructors, structure aliases, calls and all readers/writers of the two scalar/attenuation offsets. Use pinned code and controlled original-x86 probes. Do not infer pan from field order or names.

**Acceptance:** Provide hashed code windows and reader/writer map; demonstrate both equal and unequal input behavior through original x86 where reachable; separate observed pan, volume and channel roles; add native tests only after semantics are proved; state any unreachable/unverified behavior. Keep `first_*`/`second_*` names until evidence supports a stronger mapping.

**Files:** New child evidence or isolated tests only; existing and shared audio modules remain integrator-owned.
