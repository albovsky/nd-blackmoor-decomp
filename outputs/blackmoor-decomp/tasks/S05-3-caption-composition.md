# S05-3: caption transfer and restore composition

Owner: /root/sound_control_luna6 (GPT-6 Luna Max). Parent S05 stays open; Boot owns shared runtime wiring. Baseline main `bc6f05bc76de492e1e0e0428259e9e40d35abc42` contains reviewed writer/lifecycle and persistent SceneSession.

## Outcome and ownership

Recover the original caption-related pixel transfer, clipping, colour key and saved taskbar surface contract. Implement the portable bounded transfer kernel and an offscreen composition harness used by Boot's real caption lifecycle callbacks. Preserve source-backed behaviour and clearly identify DirectDraw/platform raster boundaries.

Read AGENTS.md, PROJECT-SPEC.md, the local REA skill, caption_layout.h, caption_lifecycle.h and the S05-2 recovery/integration evidence. Use immutable original bytes and existing Ghidra exports. Work in a separate canonical Git worktree, link canonical work/, and claim S05-3 before writing. Own only new src/caption_compositor.[ch], scripts/build_caption_compositor.sh, tests/test_caption_compositor.py, tests/caption_compositor_original_oracle.py, this packet, and unique private S05-3.* evidence. Existing writer/lifecycle/app/session/parser/executor/build files are read-only. Root reviews and collects; Boot supplies actual surfaces and wires callbacks.

## Recovery and interface gate

Start with 0x4c5377 (opaque DFBltNoTrans), 0x4c5d4b (keyed DFBltSrcTrans), 0x4c4067, caption layers in 0x4cf9f4 and taskbar restores 0x4e1157/0x4e1113. Resolve actual callers, input/output layouts and complete reachable transfer helpers. Trace the producer of taskbar object 0x570508 +0x74f saved_surface, including allocation/load/capture, source pixels, rectangles and lifetime. Boot recovered TASK copy to object+4, so area_src/dst/cc_rect map to TASK payload 0x21/0x31/0x51; verify actual uses. VIEW is the full 48-byte payload. Cursor-layer rect 0x583102 is a separate producer/consumer contract.

Return a short original-backed header proposal and producer/consumer map to root before implementation: bounded source/destination spans and pitch, original pixel format/masks/key, inclusive rectangles, clipping rules, overlap/alias rules, origin translation and failure/partial-write ordering. Boot needs persistent raw RGB555 caption/framed surfaces, real SCTB image handles and TASK/TBOX rectangles on a 640×480 back buffer. Establish the saved_surface source; a decoded 620×375 scene background by itself is not proof of original taskbar restore pixels.

If a routine only submits a DirectDraw COM call, original execution proves call order/arguments rather than that external driver's pixels. Enumerate that hook and report the evidence boundary. Execute actual software-transfer helpers in the oracle where present. Do not implement the oracle's comparison target inside its own host hook. Separately verify any native platform transfer against independent reference rules and label it as an adapter, with original external raster parity remaining open where unproved.

## Acceptance

Implement source-backed transfer/restore behaviour after the API gate. Compare opaque/keyed operations, every reachable clipping/format branch, boundaries, nontrivial pitch, same-surface overlapping regions, signed/extreme coordinates, unavailable surfaces and callback failures. Keep deliberate safety rejections separate from valid-original behaviour. Native surfaces own their memory; borrowed views cannot outlive their backing allocation.

Use the actual caption writer plus lifecycle command stream and installed BOOT TASK/TBOX/SCTB/font/image data in offscreen fixtures. Exercise short caption, multiline framed text, scrolling, dismissal/two-frame clear, caption over caption, source-order restore then presentation, and a scene reset/replacement. Compare the actual original raster buffers where callable; otherwise compare original command/state prefixes and retain the precise unresolved external pixel boundary. Keep unrelated scene layers explicitly outside this child rather than declaring whole-frame parity.

Add malformed-span/arithmetic/alias checks and ASan/UBSan. Demonstrate mutation detection for a wrong colour-key or clipping rule and wrong restore/presentation order. Freeze a clean commit with exact commands/counts, zero unexplained valid-input differences, original/source/input/oracle/native hashes, hook list and unverified branches. Request independent review and repair material findings. Return S05-3.handoff.json, S05-3.validation.json and a Boot integration proposal mapping each lifecycle blit/restore request to the verified kernel.

No GUI or hardware audio while the Mac is locked. This slice does not close S05, I01 or the full game by passing a recorder-only fixture; actual integration and its matching verification remain required.
