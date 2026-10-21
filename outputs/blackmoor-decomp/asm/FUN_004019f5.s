# FUN_004019f5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004019f5
# extent:       0x004019f5-0x00401a12 (29 code bytes)
# span:         0x004019f5-0x00401a12 (code 29, tables 0, padding 0)
# sha256:       e13e82e2f1149a20bb6830cc6a35de41af2dcdf87069992a48ed30a3aad4594b
# evidence:     ev_455a1567ac014214df64acbf5361dabf30a6cc1d06d560bab71935befaaf0a54
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4019f5_set_mode_call
# naming:       native port src/original_methods_fl36c.c:m4019f5_set_mode_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x1eu in 0x569138, returns 0x401526(this). No branch; all 10 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00401526
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m4019f5_set_mode_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00401526, .text + (0x00401526 - 0x401000)

.org 0x004019f5 - 0x401000
.globl FUN_004019f5
FUN_004019f5:
    # block 0x004019f5: entry, 10 instruction(s), calls FUN_00401526, ends with ret
    push ebp                                     # 004019f5
    {load} mov ebp, esp                          # 004019f6
    push ecx                                     # 004019f8
    mov dword ptr [ebp - local_4], ecx           # 004019f9
    mov dword ptr [0x569138], 0x1e               # 004019fc
    mov ecx, dword ptr [ebp - local_4]           # 00401a06
    call FUN_00401526                            # 00401a09
    {load} mov esp, ebp                          # 00401a0e
    pop ebp                                      # 00401a10
    ret                                          # 00401a11

