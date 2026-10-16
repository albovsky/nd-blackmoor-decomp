# FUN_0052013d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052013d
# extent:       0x0052013d-0x00520188 (75 code bytes)
# span:         0x0052013d-0x00520188 (code 75, tables 0, padding 0)
# sha256:       b364dd7f26d4d3bad478ff5c63fad79281f907c37ed113c7a5de51b34be86f70
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052013d
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_minus_4; [esp + n] stk_8
# callees:      calls FUN_0050cba8, FUN_0051dc6c, FUN_0051e7ba
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 32 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050cba8, .text + (0x0050cba8 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)

.org 0x0052013d - 0x401000
.globl FUN_0052013d
FUN_0052013d:
    # block 0x0052013d: entry, 6 instruction(s), ends with je to 0x0052016e (forward)
    push ebx                                     # 0052013d
    mov bl, byte ptr [esp + stk_8]               # 0052013e
    push esi                                     # 00520142
    {load} mov esi, ecx                          # 00520143
    test bl, 0x2                                 # 00520145
    je.d8 L_0052016e                             # 00520148
    # block 0x0052014a: entered by fall-through of je at 0x00520148, 9 instruction(s), calls FUN_0050cba8, ends with je to 0x00520169 (forward)
    push edi                                     # 0052014a
    lea edi, [esi - field_minus_4]               # 0052014b
    push 0x51e7ba                                # 0052014e
    push dword ptr [edi]                         # 00520153
    push 0x4                                     # 00520155
    push esi                                     # 00520157
    call FUN_0050cba8                            # 00520158
    test bl, 0x1                                 # 0052015d
    je.d8 L_00520169                             # 00520160
    # block 0x00520162: entered by fall-through of je at 0x00520160, 3 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00520169
    push edi                                     # 00520162
    call FUN_0051dc6c                            # 00520163
    pop ecx                                      # 00520168
L_00520169:
    # block 0x00520169: entered by je at 0x00520160, 3 instruction(s), ends with forward jump to 0x00520183
    {load} mov eax, edi                          # 00520169
    pop edi                                      # 0052016b
    jmp.d8 L_00520183                            # 0052016c
L_0052016e:
    # block 0x0052016e: entered by je at 0x00520148, 4 instruction(s), calls FUN_0051e7ba, ends with je to 0x00520181 (forward)
    {load} mov ecx, esi                          # 0052016e
    call FUN_0051e7ba                            # 00520170
    test bl, 0x1                                 # 00520175
    je.d8 L_00520181                             # 00520178
    # block 0x0052017a: entered by fall-through of je at 0x00520178, 3 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00520181
    push esi                                     # 0052017a
    call FUN_0051dc6c                            # 0052017b
    pop ecx                                      # 00520180
L_00520181:
    # block 0x00520181: entered by je at 0x00520178, 1 instruction(s), falls into the block at 0x00520183
    {load} mov eax, esi                          # 00520181
L_00520183:
    # block 0x00520183: entered by jmp at 0x0052016c, 3 instruction(s), ends with ret 0x4
    pop esi                                      # 00520183
    pop ebx                                      # 00520184
    ret 0x4                                      # 00520185

