# FUN_0050c4cc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c4cc
# extent:       0x0050c4cc-0x0050c4e8 (28 code bytes)
# span:         0x0050c4cc-0x0050c4e8 (code 28, tables 0, padding 0)
# sha256:       2778c0d668182d9dadb30db0bd7b59f568cc653460688637146c8be818c9137b
# evidence:     ev_6b87ed72115c87fed1179d88fa97974f93d6f22889e386bb49899d21464413f2
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c4cc
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_0050c4e8, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050c4e8, .text + (0x0050c4e8 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0050c4cc - 0x401000
.globl FUN_0050c4cc
FUN_0050c4cc:
    # block 0x0050c4cc: entry, 5 instruction(s), calls FUN_0050c4e8, ends with je to 0x0050c4e2 (forward)
    push esi                                     # 0050c4cc
    {load} mov esi, ecx                          # 0050c4cd
    call FUN_0050c4e8                            # 0050c4cf
    test byte ptr [esp + stk_8], 0x1             # 0050c4d4
    je.d8 L_0050c4e2                             # 0050c4d9
    # block 0x0050c4db: entered by fall-through of je at 0x0050c4d9, 3 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0050c4e2
    push esi                                     # 0050c4db
    call FUN_0051dc6c                            # 0050c4dc
    pop ecx                                      # 0050c4e1
L_0050c4e2:
    # block 0x0050c4e2: entered by je at 0x0050c4d9, 3 instruction(s), ends with ret 0x4
    {load} mov eax, esi                          # 0050c4e2
    pop esi                                      # 0050c4e4
    ret 0x4                                      # 0050c4e5

