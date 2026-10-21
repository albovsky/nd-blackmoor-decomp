# FUN_0040190d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040190d
# extent:       0x0040190d-0x0040192a (29 code bytes)
# span:         0x0040190d-0x0040192a (code 29, tables 0, padding 0)
# sha256:       118ed0208d7bc488c0a9c7b345264c7ee6ee4e4520c472f1a7c2ed9bd9709f5c
# evidence:     ev_455a1567ac014214df64acbf5361dabf30a6cc1d06d560bab71935befaaf0a54
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m40190d_set_mode_call
# naming:       native port src/original_methods_fl36c.c:m40190d_set_mode_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x16u in 0x569138, returns 0x401526(this). No branch; all 10 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00401526
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m40190d_set_mode_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00401526, .text + (0x00401526 - 0x401000)

.org 0x0040190d - 0x401000
.globl FUN_0040190d
FUN_0040190d:
    # block 0x0040190d: entry, 10 instruction(s), calls FUN_00401526, ends with ret
    push ebp                                     # 0040190d
    {load} mov ebp, esp                          # 0040190e
    push ecx                                     # 00401910
    mov dword ptr [ebp - local_4], ecx           # 00401911
    mov dword ptr [0x569138], 0x16               # 00401914
    mov ecx, dword ptr [ebp - local_4]           # 0040191e
    call FUN_00401526                            # 00401921
    {load} mov esp, ebp                          # 00401926
    pop ebp                                      # 00401928
    ret                                          # 00401929

