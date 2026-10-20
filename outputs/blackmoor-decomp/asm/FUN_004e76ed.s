# FUN_004e76ed
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e76ed
# extent:       0x004e76ed-0x004e7700 (19 code bytes)
# span:         0x004e76ed-0x004e7700 (code 19, tables 0, padding 0)
# sha256:       e3b792ee2e09a04bcc3505aae5545003d9e0362e54db12da064c90e74da9f1b4
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e76ed_clear_991
# naming:       native port src/original_methods_fl16.c:m4e76ed_clear_991 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m4e76ed_clear_991 (calls 0x4e76d5 on this; direct call).
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004e76d5
# track-n:      outputs/blackmoor-decomp/src/action_family_3f_runtime.c:phase2 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004e76d5, .text + (0x004e76d5 - 0x401000)

.org 0x004e76ed - 0x401000
.globl FUN_004e76ed
FUN_004e76ed:
    # block 0x004e76ed: entry, 9 instruction(s), calls FUN_004e76d5, ends with ret
    push ebp                                     # 004e76ed
    {load} mov ebp, esp                          # 004e76ee
    push ecx                                     # 004e76f0
    mov dword ptr [ebp - local_4], ecx           # 004e76f1
    mov ecx, dword ptr [ebp - local_4]           # 004e76f4
    call FUN_004e76d5                            # 004e76f7
    {load} mov esp, ebp                          # 004e76fc
    pop ebp                                      # 004e76fe
    ret                                          # 004e76ff

