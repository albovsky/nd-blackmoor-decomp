# FUN_00520c59
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520c59
# extent:       0x00520c59-0x00520c88 (47 code bytes)
# span:         0x00520c59-0x00520c88 (code 47, tables 0, padding 0)
# sha256:       f95b403ff53463d44928613c4bfcd9895cf3e52c9590c4f6f4f82aeee0dcf3df
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520c59
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_4, field_8; [esp + n] stk_c
# callees:      none direct; 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x00520c59 - 0x401000
.globl FUN_00520c59
FUN_00520c59:
    # block 0x00520c59: entry, 8 instruction(s), ends with je to 0x00520c75 (forward)
    push esi                                     # 00520c59
    {load} mov esi, ecx                          # 00520c5a
    or eax, -0x1                                 # 00520c5c
    push edi                                     # 00520c5f
    mov ecx, dword ptr [esi + field_4]           # 00520c60
    mov edi, dword ptr [0x52a050]                # 00520c63
    cmp ecx, dword ptr [esi + field_8]           # 00520c69
    je.d8 L_00520c75                             # 00520c6c
    # block 0x00520c6e: entered by fall-through of je at 0x00520c6c, 3 instruction(s), calls indirect edi, falls into the block at 0x00520c75
    push dword ptr [esp + stk_c]                 # 00520c6e
    push ecx                                     # 00520c72
    call edi                                     # 00520c73
L_00520c75:
    # block 0x00520c75: entered by je at 0x00520c6c, 3 instruction(s), ends with je to 0x00520c83 (forward)
    mov esi, dword ptr [esi + field_8]           # 00520c75
    test esi, esi                                # 00520c78
    je.d8 L_00520c83                             # 00520c7a
    # block 0x00520c7c: entered by fall-through of je at 0x00520c7a, 3 instruction(s), calls indirect edi, falls into the block at 0x00520c83
    push dword ptr [esp + stk_c]                 # 00520c7c
    push esi                                     # 00520c80
    call edi                                     # 00520c81
L_00520c83:
    # block 0x00520c83: entered by je at 0x00520c7a, 3 instruction(s), ends with ret 0x4
    pop edi                                      # 00520c83
    pop esi                                      # 00520c84
    ret 0x4                                      # 00520c85

