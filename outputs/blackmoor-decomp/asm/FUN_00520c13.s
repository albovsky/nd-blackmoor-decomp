# FUN_00520c13
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520c13
# extent:       0x00520c13-0x00520c59 (70 code bytes)
# span:         0x00520c13-0x00520c59 (code 70, tables 0, padding 0)
# sha256:       05430e83ca25eb890153654cc288049e67342cc7d99179575de9138b7a965ebf
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520c13
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebx + n] field_4; [esi + n] field_4, field_8; [esp + n] stk_8
# callees:      calls FUN_00520fbf; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 33 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00520fbf, .text + (0x00520fbf - 0x401000)

.org 0x00520c13 - 0x401000
.globl FUN_00520c13
FUN_00520c13:
    # block 0x00520c13: entry, 10 instruction(s), ends with je to 0x00520c37 (forward)
    push ebx                                     # 00520c13
    mov ebx, dword ptr [esp + stk_8]             # 00520c14
    push esi                                     # 00520c18
    {load} mov esi, ecx                          # 00520c19
    {load} xor eax, eax                          # 00520c1b
    push edi                                     # 00520c1d
    mov ecx, dword ptr [esi + field_4]           # 00520c1e
    mov edi, dword ptr [0x52a070]                # 00520c21
    cmp ecx, dword ptr [esi + field_8]           # 00520c27
    je.d8 L_00520c37                             # 00520c2a
    # block 0x00520c2c: entered by fall-through of je at 0x00520c2a, 2 instruction(s), ends with je to 0x00520c33 (forward)
    test ebx, ebx                                # 00520c2c
    je.d8 L_00520c33                             # 00520c2e
    # block 0x00520c30: entered by fall-through of je at 0x00520c2e, 1 instruction(s), falls into the block at 0x00520c33
    mov eax, dword ptr [ebx + field_4]           # 00520c30
L_00520c33:
    # block 0x00520c33: entered by je at 0x00520c2e, 3 instruction(s), calls indirect edi, falls into the block at 0x00520c37
    push eax                                     # 00520c33
    push ecx                                     # 00520c34
    call edi                                     # 00520c35
L_00520c37:
    # block 0x00520c37: entered by je at 0x00520c2a, 3 instruction(s), ends with je to 0x00520c4d (forward)
    mov esi, dword ptr [esi + field_8]           # 00520c37
    test esi, esi                                # 00520c3a
    je.d8 L_00520c4d                             # 00520c3c
    # block 0x00520c3e: entered by fall-through of je at 0x00520c3c, 2 instruction(s), ends with jne to 0x00520c46 (forward)
    test ebx, ebx                                # 00520c3e
    jne.d8 L_00520c46                            # 00520c40
    # block 0x00520c42: entered by fall-through of jne at 0x00520c40, 2 instruction(s), ends with forward jump to 0x00520c49
    {load} xor eax, eax                          # 00520c42
    jmp.d8 L_00520c49                            # 00520c44
L_00520c46:
    # block 0x00520c46: entered by jne at 0x00520c40, 1 instruction(s), falls into the block at 0x00520c49
    mov eax, dword ptr [ebx + field_4]           # 00520c46
L_00520c49:
    # block 0x00520c49: entered by jmp at 0x00520c44, 3 instruction(s), calls indirect edi, falls into the block at 0x00520c4d
    push eax                                     # 00520c49
    push esi                                     # 00520c4a
    call edi                                     # 00520c4b
L_00520c4d:
    # block 0x00520c4d: entered by je at 0x00520c3c, 6 instruction(s), calls FUN_00520fbf, ends with ret 0x4
    push eax                                     # 00520c4d
    call FUN_00520fbf                            # 00520c4e
    pop edi                                      # 00520c53
    pop esi                                      # 00520c54
    pop ebx                                      # 00520c55
    ret 0x4                                      # 00520c56

