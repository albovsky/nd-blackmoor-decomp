# FUN_004e8d96
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e8d96
# extent:       0x004e8d96-0x004e8dc8 (50 code bytes)
# span:         0x004e8d96-0x004e8dc8 (code 50, tables 0, padding 0)
# sha256:       0a9074007cc3fee89ce7cc198feb0e4edc21c07abe5dd53b4953a7c304cb2f85
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         put_back
# naming:       native port src/action_family_78_runtime.c:put_back (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-15); the summary is the acceptance note
# summary:      Static put_back. RT-19 oracle: 3,646 cases, ordered effect log incl. putback and all modeled cells, 0 mismatches. Native adds bounds failures (full list, id past presence array) that the original lacks.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004e9e84
# track-n:      outputs/blackmoor-decomp/src/action_family_3f_runtime.c:phase0 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 16 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004e9e84, .text + (0x004e9e84 - 0x401000)

.org 0x004e8d96 - 0x401000
.globl FUN_004e8d96
FUN_004e8d96:
    # block 0x004e8d96: entry, 7 instruction(s), ends with je to 0x004e8dc4 (forward)
    push ebp                                     # 004e8d96
    {load} mov ebp, esp                          # 004e8d97
    push ecx                                     # 004e8d99
    mov dword ptr [ebp - local_4], ecx           # 004e8d9a
    movsx eax, word ptr [0x583a29]               # 004e8d9d
    cmp eax, -0x1                                # 004e8da4
    je.d8 L_004e8dc4                             # 004e8da7
    # block 0x004e8da9: entered by fall-through of je at 0x004e8da7, 6 instruction(s), calls FUN_004e9e84, falls into the block at 0x004e8dc4
    push 0x0                                     # 004e8da9
    mov cx, word ptr [0x583a29]                  # 004e8dab
    push ecx                                     # 004e8db2
    mov ecx, dword ptr [ebp - local_4]           # 004e8db3
    call FUN_004e9e84                            # 004e8db6
    mov word ptr [0x583a29], 0xffff              # 004e8dbb
L_004e8dc4:
    # block 0x004e8dc4: entered by je at 0x004e8da7, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004e8dc4
    pop ebp                                      # 004e8dc6
    ret                                          # 004e8dc7

