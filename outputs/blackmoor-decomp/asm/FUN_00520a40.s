# FUN_00520a40
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520a40
# extent:       0x00520a40-0x00520a5c (28 code bytes)
# span:         0x00520a40-0x00520a5c (code 28, tables 0, padding 0)
# sha256:       6d66e381200d94f159ea31a19d4b482dffa76706580c954f66402b52b3696e2a
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520a40
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_00520b14, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)
.set FUN_00520b14, .text + (0x00520b14 - 0x401000)

.org 0x00520a40 - 0x401000
.globl FUN_00520a40
FUN_00520a40:
    # block 0x00520a40: entry, 5 instruction(s), calls FUN_00520b14, ends with je to 0x00520a56 (forward)
    push esi                                     # 00520a40
    {load} mov esi, ecx                          # 00520a41
    call FUN_00520b14                            # 00520a43
    test byte ptr [esp + stk_8], 0x1             # 00520a48
    je.d8 L_00520a56                             # 00520a4d
    # block 0x00520a4f: entered by fall-through of je at 0x00520a4d, 3 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00520a56
    push esi                                     # 00520a4f
    call FUN_0051dc6c                            # 00520a50
    pop ecx                                      # 00520a55
L_00520a56:
    # block 0x00520a56: entered by je at 0x00520a4d, 3 instruction(s), ends with ret 0x4
    {load} mov eax, esi                          # 00520a56
    pop esi                                      # 00520a58
    ret 0x4                                      # 00520a59

