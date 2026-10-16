# FUN_00520121
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520121
# extent:       0x00520121-0x0052013d (28 code bytes)
# span:         0x00520121-0x0052013d (code 28, tables 0, padding 0)
# sha256:       80beee5024b0752f93a4b35bcd880291e6120da0ea8de96534010b198a13af1d
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520121
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_00520188, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)
.set FUN_00520188, .text + (0x00520188 - 0x401000)

.org 0x00520121 - 0x401000
.globl FUN_00520121
FUN_00520121:
    # block 0x00520121: entry, 5 instruction(s), calls FUN_00520188, ends with je to 0x00520137 (forward)
    push esi                                     # 00520121
    {load} mov esi, ecx                          # 00520122
    call FUN_00520188                            # 00520124
    test byte ptr [esp + stk_8], 0x1             # 00520129
    je.d8 L_00520137                             # 0052012e
    # block 0x00520130: entered by fall-through of je at 0x0052012e, 3 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00520137
    push esi                                     # 00520130
    call FUN_0051dc6c                            # 00520131
    pop ecx                                      # 00520136
L_00520137:
    # block 0x00520137: entered by je at 0x0052012e, 3 instruction(s), ends with ret 0x4
    {load} mov eax, esi                          # 00520137
    pop esi                                      # 00520139
    ret 0x4                                      # 0052013a

