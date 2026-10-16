# FUN_0051ddf7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051ddf7
# extent:       0x0051ddf7-0x0051de13 (28 code bytes)
# span:         0x0051ddf7-0x0051de13 (code 28, tables 0, padding 0)
# sha256:       06565f506459f7fa76d205aeb182c559113e8bb6c6d6385357df2e92aa0387be
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051ddf7
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_0051de13, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)
.set FUN_0051de13, .text + (0x0051de13 - 0x401000)

.org 0x0051ddf7 - 0x401000
.globl FUN_0051ddf7
FUN_0051ddf7:
    # block 0x0051ddf7: entry, 5 instruction(s), calls FUN_0051de13, ends with je to 0x0051de0d (forward)
    push esi                                     # 0051ddf7
    {load} mov esi, ecx                          # 0051ddf8
    call FUN_0051de13                            # 0051ddfa
    test byte ptr [esp + stk_8], 0x1             # 0051ddff
    je.d8 L_0051de0d                             # 0051de04
    # block 0x0051de06: entered by fall-through of je at 0x0051de04, 3 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0051de0d
    push esi                                     # 0051de06
    call FUN_0051dc6c                            # 0051de07
    pop ecx                                      # 0051de0c
L_0051de0d:
    # block 0x0051de0d: entered by je at 0x0051de04, 3 instruction(s), ends with ret 0x4
    {load} mov eax, esi                          # 0051de0d
    pop esi                                      # 0051de0f
    ret 0x4                                      # 0051de10

