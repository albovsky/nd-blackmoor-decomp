# FUN_0051d3d5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051d3d5
# extent:       0x0051d3d5-0x0051d43c (103 code bytes)
# span:         0x0051d3d5-0x0051d43c (code 103, tables 0, padding 0)
# sha256:       d6fa846028d3770cdc2b005a3b33e9a17b15b05988d9d67402f93ccd9fcd9b54
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051d3d5
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_50; [edi + n] field_20; [esi + n] field_1c, field_34; [esp + n] stk_10
# callees:      calls USER32.dll!GetDlgItem, FUN_0051d392, USER32.dll!GetParent, FUN_0051d6f7; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 41 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_34, 0x34  # offset +0x34
.equ field_50, 0x50  # offset +0x50

# --- external targets -----------------------------------------------
.set FUN_0051d392, .text + (0x0051d392 - 0x401000)
.set FUN_0051d6f7, .text + (0x0051d6f7 - 0x401000)

.org 0x0051d3d5 - 0x401000
.globl FUN_0051d3d5
FUN_0051d3d5:
    # block 0x0051d3d5: entry, 10 instruction(s), calls USER32.dll!GetDlgItem, ends with je to 0x0051d3f9 (forward)
    push ebx                                     # 0051d3d5
    push esi                                     # 0051d3d6
    mov esi, dword ptr [esp + stk_10]            # 0051d3d7
    push edi                                     # 0051d3db
    push dword ptr [esp + stk_10]                # 0051d3dc
    {load} mov ebx, ecx                          # 0051d3e0
    push dword ptr [esi + field_1c]              # 0051d3e2
    call dword ptr [0x52a404]                    # 0051d3e5
    test eax, eax                                # 0051d3eb
    je.d8 L_0051d3f9                             # 0051d3ed
    # block 0x0051d3ef: entered by fall-through of je at 0x0051d3ed, 4 instruction(s), calls FUN_0051d392, ends with forward jump to 0x0051d436
    push eax                                     # 0051d3ef
    {load} mov ecx, ebx                          # 0051d3f0
    call FUN_0051d392                            # 0051d3f2
    jmp.d8 L_0051d436                            # 0051d3f7
L_0051d3f9:
    # block 0x0051d3f9: entered by je at 0x0051d3ed, 3 instruction(s), ends with je to 0x0051d434 (forward)
    mov ecx, dword ptr [esi + field_34]          # 0051d3f9
    test ecx, ecx                                # 0051d3fc
    je.d8 L_0051d434                             # 0051d3fe
    # block 0x0051d400: entered by fall-through of je at 0x0051d3fe, 6 instruction(s), calls indirect dword ptr [eax + 0x50], ends with je to 0x0051d434 (forward)
    mov eax, dword ptr [ecx]                     # 0051d400
    push dword ptr [esp + stk_10]                # 0051d402
    call dword ptr [eax + field_50]              # 0051d406
    {load} mov edi, eax                          # 0051d409
    test edi, edi                                # 0051d40b
    je.d8 L_0051d434                             # 0051d40d
    # block 0x0051d40f: entered by fall-through of je at 0x0051d40d, 7 instruction(s), calls FUN_0051d392, USER32.dll!GetParent, ends with je to 0x0051d42f (forward)
    push dword ptr [edi + field_20]              # 0051d40f
    {load} mov ecx, ebx                          # 0051d412
    call FUN_0051d392                            # 0051d414
    push dword ptr [edi + field_20]              # 0051d419
    call dword ptr [0x52a3dc]                    # 0051d41c
    cmp dword ptr [esi + field_1c], eax          # 0051d422
    je.d8 L_0051d42f                             # 0051d425
    # block 0x0051d427: entered by fall-through of je at 0x0051d425, 3 instruction(s), calls FUN_0051d6f7, falls into the block at 0x0051d42f
    push esi                                     # 0051d427
    {load} mov ecx, ebx                          # 0051d428
    call FUN_0051d6f7                            # 0051d42a
L_0051d42f:
    # block 0x0051d42f: entered by je at 0x0051d425, 3 instruction(s), ends with forward jump to 0x0051d436
    push 0x1                                     # 0051d42f
    pop eax                                      # 0051d431
    jmp.d8 L_0051d436                            # 0051d432
L_0051d434:
    # block 0x0051d434: entered by je at 0x0051d3fe; je at 0x0051d40d, 1 instruction(s), falls into the block at 0x0051d436
    {load} xor eax, eax                          # 0051d434
L_0051d436:
    # block 0x0051d436: entered by jmp at 0x0051d3f7; jmp at 0x0051d432, 4 instruction(s), ends with ret 0x8
    pop edi                                      # 0051d436
    pop esi                                      # 0051d437
    pop ebx                                      # 0051d438
    ret 0x8                                      # 0051d439

