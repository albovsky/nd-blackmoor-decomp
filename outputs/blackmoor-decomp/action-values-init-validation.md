# Original 0x44aff2 value-initializer validation

Implemented the proven narrow reset as action_core_initialize_values(ActionCoreWorld *world). It writes 30 int16 values of 9999 and 10 float32 values of 9999.0f, and returns ACTION_CORE_ERR_ARGUMENT for NULL. It does not inspect or modify difficulty, event-flag contents, event-flag pointer, or event-flag count.

The original GAME.EXE function was called directly at VA 0x44aff2 under Unicorn 2.1.4 without function stubs. Its executed code window is [0x0044aff2, 0x0044b05a), 104 bytes, SHA-256 f030cbb26d5dd17c35cc5f9cdc0ca2b8ca447ae2e0c387682b16d0c7fd6e0489. Each run executed 377 instruction steps; no external calls were entered. The full executable SHA-256 is afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45.

Two independent seeded starting states were run through both the original and native initializer. All 100 contiguous value bytes matched in each case: 30 little-endian shorts at 0x58c959 followed by 10 floats at 0x58c995. Output slots are all 9999 (short bits 0x270f; float bits 0x461c3c00). The seeded difficulty word at 0x58c94f and eight event flags at 0x585801 remained byte-identical in both implementations. Native event_flags pointer and event_flag_count also remained unchanged.

The first unit-test run used an incorrect expected float of 10000.0f and failed the exact-byte assertion. The original direct call then showed bytes 00 3c 1c 46 per float, which decode as 9999.0f. I corrected the implementation and test expectation to match the original. The final ActionCore suite passed all 15 tests, including sentinel bytes, preservation of unrelated state, the null-world error, and existing action handlers.

The compiled native ARM64 library SHA-256 for this run is 20018ae171afba1426f1075d2e5ed2b3c9b1bb91fd10679485dac792783c54f9. Machine-readable case details, hashes, and checks are in action-values-init-validation.json. This validates only the isolated sentinel reset, not the complete new-game world initialization.
