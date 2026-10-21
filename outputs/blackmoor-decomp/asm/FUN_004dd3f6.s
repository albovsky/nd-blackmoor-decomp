# FUN_004dd3f6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004dd3f6
# extent:       0x004dd3f6-0x004dd409 (19 code bytes)
# span:         0x004dd3f6-0x004dd409 (code 19, tables 0, padding 0)
# sha256:       2bfd021033b6d5c831de2562768a676c43a9e91f5657abc903f790a5ad46a6b1
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4dd3f6_forward_call
# naming:       native port src/original_methods_fl36e.c:m4dd3f6_forward_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns 0x4dd3eb(this). No branch; all 9 instructions run. Nothing else is read or written.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004dd3eb
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m4dd3f6_forward_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004dd3eb, .text + (0x004dd3eb - 0x401000)

.org 0x004dd3f6 - 0x401000
.globl FUN_004dd3f6
FUN_004dd3f6:
    # block 0x004dd3f6: entry, 9 instruction(s), calls FUN_004dd3eb, ends with ret
    push ebp                                     # 004dd3f6
    {load} mov ebp, esp                          # 004dd3f7
    push ecx                                     # 004dd3f9
    mov dword ptr [ebp - local_4], ecx           # 004dd3fa
    mov ecx, dword ptr [ebp - local_4]           # 004dd3fd
    call FUN_004dd3eb                            # 004dd400
    {load} mov esp, ebp                          # 004dd405
    pop ebp                                      # 004dd407
    ret                                          # 004dd408

