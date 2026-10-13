# Action UI original-code validation

bounded 0x82 phone/contact and generic 0x1d control-state handlers; not a full scene or game comparison

Original `GAME.EXE` SHA-256: `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45`.
Native library SHA-256: `03922380e33d9de370e3349ffbb2aab86e6c2b96fb9d5716a9ae1e55a701e8fc`.
Compared cases: 13; mismatches: 0.

The original x86 handler entries ran under Unicorn 2.1.4. Phone lookup, sorting, ASCII normalization, UI update, control handling, and the control initializer remained original code. The native implementation matched the compared phone rows and all five serialized control groups for each fixture.

## Excluded paths and limits

- control code 1 immediate UI-mode branch (returns explicit native UNSUPPORTED without mutation).
- nonzero NLS/locale phone-name normalization (native returns explicit UNSUPPORTED).
- debug printing, phone-table overflow behavior, rendering, input handling, and full UI behavior.
- scene scheduling, dependency evaluation, and direct completion-byte behavior in the outer dispatcher.

## Limitations

- original phone-table capacity is unproven; oracle cases keep the table in a small bounded fixture.
- empty-table lookup's decompiled comparison local is uninitialized when the original count is zero, so oracle insert cases seed a nonmatching row and do not claim empty-table insertion behavior.
- control handler exact function end was not recovered; reported control range hash is an enclosing code window.
- generic control code values are retained as observed bytes; code 13 user-facing meaning is unresolved.
- native table count/capacity represents caller-owned storage and does not claim the original table was dynamically sized.

## Compared cases

- `phone-insert` (`0x82`), body `0a007a7a7a7a7a7a7a7a7a7a7a5a756c7500000000000000000000000000000000a1a1a1a1a1a1a1a1`
- `phone-sort-ascii` (`0x82`), body `0a006161616161616161616161616d790000000000000000000000000000000000b2b2b2b2b2b2b2b2`
- `phone-duplicate-replace-and-sort` (`0x82`), body `eeff6b6b6b6b6b6b6b6b6b6b6b4d69726100000000000000000000000000000000d4d4d4d4d4d4d4d4`
- `phone-casefold-tie-keeps-order` (`0x82`), body `0a003232323232323232323232416c6963650000000000000000000000000000005a5a5a5a5a5a5a5a`
- `phone-sort-restarts-after-one-swap-per-pass` (`0x82`), body `0a006161616161616161616161416c7068610000000000000000000000000000005a5a5a5a5a5a5a5a`
- `control-insert` (`0x1d`), body `03000d01f6ff2500`
- `control-duplicate-noop` (`0x1d`), body `0200390104000900`
- `control-remove-range` (`0x1d`), body `0100000004000900`
- `control-full-table-drop-first` (`0x1d`), body `00002a01f9ff0800`
- `control-mode1-enable` (`0x1d`), body `04000d010b270000`
- `control-mode1-disable` (`0x1d`), body `04000d0101000c27`
- `control-mode0-state2` (`0x1d`), body `04000d0000000d27`
- `control-mode0-state0` (`0x1d`), body `04000d000e270000`

## Code hashes

- `0x4e7253..0x4e72f9` 0x4e7253 direct phone handler: `074402f915587c9113344a175666089c9a1b93503d12f561e4be25ccd4ff5619` (static trace anchor).
- `0x4e13e4..0x4e18e5` 0x4e13e4 control-handler code window: `b2e63b99940ec84592abfdfa53fc306482e6ed099a5fce257409f55f0e8c13b3` (window ends at next traced consumer; exact handler end was not recovered).
- `0x4e1a7e..0x4e1b79` 0x4e1a7e control initializer: `191e3ff8bcbcb56e5759ae7be12412d67a7ff52958d1d4297ee88733f6a8f04b` (next traced function entry).
