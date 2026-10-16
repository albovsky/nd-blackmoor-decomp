# FUN_0050f8fe
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050f8fe
# extent:       0x0050f8fe-0x0050f91a (28 code bytes)
# span:         0x0050f8fe-0x0050f920 (code 28, tables 0, padding 6)
# sha256:       75d2d88a3fc766f2b9b93b3677752ddbc8abdb215c9c305a4bfdec13e161f437
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050f8fe
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_0050f8d5, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050f8d5, .text + (0x0050f8d5 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0050f8fe - 0x401000
.globl FUN_0050f8fe
FUN_0050f8fe:
    # block 0x0050f8fe: entry, 5 instruction(s), calls FUN_0050f8d5, ends with je to 0x0050f914 (forward)
    push esi                                     # 0050f8fe
    {load} mov esi, ecx                          # 0050f8ff
    call FUN_0050f8d5                            # 0050f901
    test byte ptr [esp + stk_8], 0x1             # 0050f906
    je.d8 L_0050f914                             # 0050f90b
    # block 0x0050f90d: entered by fall-through of je at 0x0050f90b, 3 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0050f914
    push esi                                     # 0050f90d
    call FUN_0051dc6c                            # 0050f90e
    pop ecx                                      # 0050f913
L_0050f914:
    # block 0x0050f914: entered by je at 0x0050f90b, 3 instruction(s), ends with ret 0x4
    {load} mov eax, esi                          # 0050f914
    pop esi                                      # 0050f916
    ret 0x4                                      # 0050f917

# --- data items (not part of the function) -------------------------
.org 0x0050f91a - 0x401000
PAD_0050f91a:  # 6 byte(s) of int3 padding
    .fill 6, 1, 0xcc

