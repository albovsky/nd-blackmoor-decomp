# S05-2: Framed text box and caption presentation lifecycle

**Parent:** S05 (caption layout and font rendering). S05-1, the text writer `0x448d11` and its layout, glyph, blit and font code, is implemented in `src/caption_layout.[ch]` and checked against the original code. This child packet holds the UI lifecycle around that writer. **S05 stays incomplete until this packet passes.**

**Spec:** `../PROJECT-SPEC.md`. Read `work/analysis/slices/S05.recovery.md` first.

## Scope

Recover and implement the original lifecycle that S05-1 reaches only through typed backend callbacks:

1. **Framed text box UI** on object `0x61f864`:
   - **Open** `0x4de24f(mode, text)`. It writes the text through `0x448d11(*0x5d03af, text, -2, 0)` when the text is non-empty, sets `0x5b15d6`, `0x5d17f5` and `0x5a161f`, and calls `0x43dbd5`, `0x4ee673(0)`, `+0x991 = mode` and `0x4edf96(mode)`, then `0x4e053f(2)`.
   - **Close** `0x4de2d8`: `+0x991 = 1`, `0x4e053f(1)`, `0x4e1113`, clears `0x5b15d6` and `0x5d17f5`, then `0x4de214` → `0x4de1f5` (clears `0x5a161f`).
   - **Per-frame poll.** The main loop (`0x43cfa3`) calls `0x4de4f9` while `0x5a161f` is set. In UI modes 2..3, `0x4ee6c7(0) == 0` closes the box; `0x4de440` updates it, including scrolling by `0x5b0a7c`.
   - **Dismissal input.** Identify which input or UI control makes `0x4ee6c7` return 0.
2. **Caption presentation:**
   - `CUITaskBar::RestoreCCTextBox` `0x4e1157` → `0x4c5377`: how the caption surface reaches the screen and where.
   - The main-loop flags `0x5d1889` and `0x5d18d3`.
   - The two-frame clear `0x42ae0a` (counter `0x5b160a`) and its sibling `0x42ad90`, which also marks a slot as done.
   - The timed dismiss on `0x571442` (`0x4ea361`, armed at `0x4e93b1`/`0x4eb5b3`).
3. **Other writer callers.** Inventory every other `0x448d11` caller, including the sound-caption path (`0x41c7f4`, `<h>`/`<o>` fallback text), and its mode and measure use.

## Boundaries

- **New files only:** `src/caption_lifecycle.[ch]`, `tests/test_caption_lifecycle.py`, `tests/caption_lifecycle_original_oracle.py`, `scripts/build_caption_lifecycle.sh`, and `work/analysis/slices/S05-2.*`.
- `caption_layout.[ch]` and the A-51 module are read-only. Propose interface changes separately.
- Keep host input and presentation as typed commands.
- **Do not invent completion behaviour for A-51 wait-mode-0 records.** Their text is dismissed only by the owners listed in `S05.recovery.md`.

## Acceptance

- Each recovered branch above is compared against the original code: open and close state, poll and close, the clear sequence, and the timed dismiss.
- Host input and presentation stay explicit commands.
- The S5900 action 11 sequence is modelled with original-derived state: frame open with `CURL00` = `"<n>"`, waiting with no completion, and dismissal by the frame UI or scene change.
- An independent review is obtained.
