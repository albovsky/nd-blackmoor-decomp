# FUN_00520c88
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520c88
# extent:       0x00520c88-0x00520cb7 (47 code bytes)
# span:         0x00520c88-0x00520cb7 (code 47, tables 0, padding 0)
# sha256:       08f996097135ca5b71ed07208c2ecf29b8383efbb871d8cd50d964963556f61a
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520c88
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

.org 0x00520c88 - 0x401000
.globl FUN_00520c88
FUN_00520c88:
    # block 0x00520c88: entry, 8 instruction(s), ends with je to 0x00520ca4 (forward)
    push esi                                     # 00520c88
    {load} mov esi, ecx                          # 00520c89
    or eax, -0x1                                 # 00520c8b
    push edi                                     # 00520c8e
    mov ecx, dword ptr [esi + field_4]           # 00520c8f
    mov edi, dword ptr [0x52a04c]                # 00520c92
    cmp ecx, dword ptr [esi + field_8]           # 00520c98
    je.d8 L_00520ca4                             # 00520c9b
    # block 0x00520c9d: entered by fall-through of je at 0x00520c9b, 3 instruction(s), calls indirect edi, falls into the block at 0x00520ca4
    push dword ptr [esp + stk_c]                 # 00520c9d
    push ecx                                     # 00520ca1
    call edi                                     # 00520ca2
L_00520ca4:
    # block 0x00520ca4: entered by je at 0x00520c9b, 3 instruction(s), ends with je to 0x00520cb2 (forward)
    mov esi, dword ptr [esi + field_8]           # 00520ca4
    test esi, esi                                # 00520ca7
    je.d8 L_00520cb2                             # 00520ca9
    # block 0x00520cab: entered by fall-through of je at 0x00520ca9, 3 instruction(s), calls indirect edi, falls into the block at 0x00520cb2
    push dword ptr [esp + stk_c]                 # 00520cab
    push esi                                     # 00520caf
    call edi                                     # 00520cb0
L_00520cb2:
    # block 0x00520cb2: entered by je at 0x00520ca9, 3 instruction(s), ends with ret 0x4
    pop edi                                      # 00520cb2
    pop esi                                      # 00520cb3
    ret 0x4                                      # 00520cb4

