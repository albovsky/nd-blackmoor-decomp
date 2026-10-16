# FUN_00520cb7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520cb7
# extent:       0x00520cb7-0x00520ce5 (46 code bytes)
# span:         0x00520cb7-0x00520ce5 (code 46, tables 0, padding 0)
# sha256:       cd113cf1f21c1509b3c91dd549e50b6d309029a169debe4a0dd71fd9ae312f70
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520cb7
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

.org 0x00520cb7 - 0x401000
.globl FUN_00520cb7
FUN_00520cb7:
    # block 0x00520cb7: entry, 8 instruction(s), ends with je to 0x00520cd2 (forward)
    push esi                                     # 00520cb7
    {load} mov esi, ecx                          # 00520cb8
    {load} xor eax, eax                          # 00520cba
    push edi                                     # 00520cbc
    mov ecx, dword ptr [esi + field_4]           # 00520cbd
    mov edi, dword ptr [0x52a074]                # 00520cc0
    cmp ecx, dword ptr [esi + field_8]           # 00520cc6
    je.d8 L_00520cd2                             # 00520cc9
    # block 0x00520ccb: entered by fall-through of je at 0x00520cc9, 3 instruction(s), calls indirect edi, falls into the block at 0x00520cd2
    push dword ptr [esp + stk_c]                 # 00520ccb
    push ecx                                     # 00520ccf
    call edi                                     # 00520cd0
L_00520cd2:
    # block 0x00520cd2: entered by je at 0x00520cc9, 3 instruction(s), ends with je to 0x00520ce0 (forward)
    mov esi, dword ptr [esi + field_8]           # 00520cd2
    test esi, esi                                # 00520cd5
    je.d8 L_00520ce0                             # 00520cd7
    # block 0x00520cd9: entered by fall-through of je at 0x00520cd7, 3 instruction(s), calls indirect edi, falls into the block at 0x00520ce0
    push dword ptr [esp + stk_c]                 # 00520cd9
    push esi                                     # 00520cdd
    call edi                                     # 00520cde
L_00520ce0:
    # block 0x00520ce0: entered by je at 0x00520cd7, 3 instruction(s), ends with ret 0x4
    pop edi                                      # 00520ce0
    pop esi                                      # 00520ce1
    ret 0x4                                      # 00520ce2

