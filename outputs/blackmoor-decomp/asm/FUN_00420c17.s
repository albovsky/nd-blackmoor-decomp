# FUN_00420c17
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00420c17
# extent:       0x00420c17-0x00422920 (7433 code bytes)
# span:         0x00420c17-0x00422970 (code 7433, tables 80, padding 0)
# sha256:       d06d5f9282abd3275dc31826fb9b03e687564a9736545c18ec737ec5b3a1f29a
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00420c17
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       24 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30, local_34 and 12 more
# fields:       [eax + n] field_2, field_6, field_c, field_16, field_a8, field_68e, field_692, field_694, field_696, field_698, field_69c, field_6a2 and 28 more; [ecx + n] field_4, field_8, field_a, field_c, field_12, field_a8, field_aa, field_690, field_692, field_694, field_696, field_69c and 47 more; [edx + n] field_4, field_8, field_c, field_e, field_21, field_aa, field_ac, field_68e, field_690, field_692, field_694, field_696 and 32 more; [esi + n] field_75d
# callees:      calls FUN_0050ca3e, FUN_0044a2b7, FUN_004eb96e, FUN_004e7d04, FUN_004e7728, FUN_004e7786, FUN_004db993, FUN_0041f986, FUN_004e8d96, FUN_0044c479, FUN_00449a94, FUN_0044c4ab, FUN_004c948f, FUN_004c2898, FUN_0041de29, FUN_004205c1 and 33 more; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      outputs/blackmoor-decomp/src/action_family_3f_runtime.c:cel_sync_frame (function ledger class candidate_port; also phase0, phase0_cel, phase2; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 1764 instruction(s), 114 conditional branch(es) and 3 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ local_4c, 0x4c  # offset -0x4c
.equ local_50, 0x50  # offset -0x50
.equ local_54, 0x54  # offset -0x54
.equ local_58, 0x58  # offset -0x58
.equ local_5c, 0x5c  # offset -0x5c
.equ local_60, 0x60  # offset -0x60
.equ local_64, 0x64  # offset -0x64
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ field_c, 0xc  # offset +0xc
.equ field_e, 0xe  # offset +0xe
.equ field_12, 0x12  # offset +0x12
.equ field_16, 0x16  # offset +0x16
.equ field_21, 0x21  # offset +0x21
.equ field_a8, 0xa8  # offset +0xa8
.equ field_aa, 0xaa  # offset +0xaa
.equ field_ac, 0xac  # offset +0xac
.equ field_68e, 0x68e  # offset +0x68e
.equ field_690, 0x690  # offset +0x690
.equ field_692, 0x692  # offset +0x692
.equ field_694, 0x694  # offset +0x694
.equ field_696, 0x696  # offset +0x696
.equ field_698, 0x698  # offset +0x698
.equ field_69c, 0x69c  # offset +0x69c
.equ field_69e, 0x69e  # offset +0x69e
.equ field_6a2, 0x6a2  # offset +0x6a2
.equ field_6a4, 0x6a4  # offset +0x6a4
.equ field_6a6, 0x6a6  # offset +0x6a6
.equ field_6aa, 0x6aa  # offset +0x6aa
.equ field_6b2, 0x6b2  # offset +0x6b2
.equ field_6b6, 0x6b6  # offset +0x6b6
.equ field_6da, 0x6da  # offset +0x6da
.equ field_6de, 0x6de  # offset +0x6de
.equ field_6e2, 0x6e2  # offset +0x6e2
.equ field_6e6, 0x6e6  # offset +0x6e6
.equ field_71a, 0x71a  # offset +0x71a
.equ field_71e, 0x71e  # offset +0x71e
.equ field_722, 0x722  # offset +0x722
.equ field_726, 0x726  # offset +0x726
.equ field_75a, 0x75a  # offset +0x75a
.equ field_75b, 0x75b  # offset +0x75b
.equ field_75d, 0x75d  # offset +0x75d
.equ field_778, 0x778  # offset +0x778
.equ field_77b, 0x77b  # offset +0x77b
.equ field_77c, 0x77c  # offset +0x77c
.equ field_77d, 0x77d  # offset +0x77d
.equ field_77e, 0x77e  # offset +0x77e
.equ field_77f, 0x77f  # offset +0x77f
.equ field_781, 0x781  # offset +0x781
.equ field_782, 0x782  # offset +0x782
.equ field_783, 0x783  # offset +0x783
.equ field_784, 0x784  # offset +0x784
.equ field_785, 0x785  # offset +0x785
.equ field_786, 0x786  # offset +0x786
.equ field_788, 0x788  # offset +0x788
.equ field_789, 0x789  # offset +0x789
.equ field_78a, 0x78a  # offset +0x78a
.equ field_78c, 0x78c  # offset +0x78c
.equ field_78d, 0x78d  # offset +0x78d
.equ field_78e, 0x78e  # offset +0x78e
.equ field_799, 0x799  # offset +0x799
.equ field_79b, 0x79b  # offset +0x79b
.equ field_7a7, 0x7a7  # offset +0x7a7
.equ field_7c0, 0x7c0  # offset +0x7c0
.equ field_7fa, 0x7fa  # offset +0x7fa
.equ field_7fc, 0x7fc  # offset +0x7fc
.equ field_7fe, 0x7fe  # offset +0x7fe
.equ field_800, 0x800  # offset +0x800
.equ field_802, 0x802  # offset +0x802
.equ field_806, 0x806  # offset +0x806
.equ field_80a, 0x80a  # offset +0x80a
.equ field_80e, 0x80e  # offset +0x80e
.equ field_810, 0x810  # offset +0x810
.equ field_f21, 0xf21  # offset +0xf21
.equ field_f73, 0xf73  # offset +0xf73
.equ field_f75, 0xf75  # offset +0xf75
.equ field_f9b, 0xf9b  # offset +0xf9b
.equ field_f9d, 0xf9d  # offset +0xf9d
.equ field_fa1, 0xfa1  # offset +0xfa1
.equ field_fa5, 0xfa5  # offset +0xfa5
.equ field_fa9, 0xfa9  # offset +0xfa9
.equ field_fad, 0xfad  # offset +0xfad
.equ field_fb1, 0xfb1  # offset +0xfb1
.equ field_fb5, 0xfb5  # offset +0xfb5
.equ field_20d5, 0x20d5  # offset +0x20d5
.equ field_20d9, 0x20d9  # offset +0x20d9

# --- external targets -----------------------------------------------
.set FUN_00418e52, .text + (0x00418e52 - 0x401000)
.set FUN_0041a216, .text + (0x0041a216 - 0x401000)
.set FUN_0041db40, .text + (0x0041db40 - 0x401000)
.set FUN_0041de29, .text + (0x0041de29 - 0x401000)
.set FUN_0041e1e4, .text + (0x0041e1e4 - 0x401000)
.set FUN_0041e3c0, .text + (0x0041e3c0 - 0x401000)
.set FUN_0041e647, .text + (0x0041e647 - 0x401000)
.set FUN_0041f986, .text + (0x0041f986 - 0x401000)
.set FUN_004205c1, .text + (0x004205c1 - 0x401000)
.set FUN_00420737, .text + (0x00420737 - 0x401000)
.set FUN_004209e8, .text + (0x004209e8 - 0x401000)
.set FUN_00420b9e, .text + (0x00420b9e - 0x401000)
.set FUN_00422970, .text + (0x00422970 - 0x401000)
.set FUN_004229b5, .text + (0x004229b5 - 0x401000)
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0042e493, .text + (0x0042e493 - 0x401000)
.set FUN_0043dbd5, .text + (0x0043dbd5 - 0x401000)
.set FUN_004497a0, .text + (0x004497a0 - 0x401000)
.set FUN_00449a94, .text + (0x00449a94 - 0x401000)
.set FUN_00449bff, .text + (0x00449bff - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0044c479, .text + (0x0044c479 - 0x401000)
.set FUN_0044c4ab, .text + (0x0044c4ab - 0x401000)
.set FUN_004c2898, .text + (0x004c2898 - 0x401000)
.set FUN_004c51a5, .text + (0x004c51a5 - 0x401000)
.set FUN_004c946b, .text + (0x004c946b - 0x401000)
.set FUN_004c948f, .text + (0x004c948f - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004d36ed, .text + (0x004d36ed - 0x401000)
.set FUN_004dadff, .text + (0x004dadff - 0x401000)
.set FUN_004db993, .text + (0x004db993 - 0x401000)
.set FUN_004e7728, .text + (0x004e7728 - 0x401000)
.set FUN_004e7757, .text + (0x004e7757 - 0x401000)
.set FUN_004e7786, .text + (0x004e7786 - 0x401000)
.set FUN_004e7d04, .text + (0x004e7d04 - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004eb96e, .text + (0x004eb96e - 0x401000)
.set FUN_004ee673, .text + (0x004ee673 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004f6cdc, .text + (0x004f6cdc - 0x401000)
.set FUN_004f6ef4, .text + (0x004f6ef4 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x00420c17 - 0x401000
.globl FUN_00420c17
FUN_00420c17:
    # block 0x00420c17: entry, 17 instruction(s), ends with je to 0x00420c69 (forward)
    push ebp                                     # 00420c17
    {load} mov ebp, esp                          # 00420c18
    push -0x1                                    # 00420c1a
    push 0x5273b7                                # 00420c1c
    mov eax, dword ptr fs:[0x0]                  # 00420c21
    push eax                                     # 00420c27
    mov dword ptr fs:[0x0], esp                  # 00420c28
    sub esp, 0x58                                # 00420c2f
    push esi                                     # 00420c32
    push edi                                     # 00420c33
    mov dword ptr [ebp - local_38], ecx          # 00420c34
    movsx eax, word ptr [ebp + arg_8]            # 00420c37
    imul eax, eax, 0x8d                          # 00420c3b
    mov ecx, dword ptr [eax + 0x5bb632]          # 00420c41
    mov dword ptr [ebp - local_3c], ecx          # 00420c47
    cmp dword ptr [ebp - local_3c], 0x0          # 00420c4a
    je.d8 L_00420c69                             # 00420c4e
    # block 0x00420c50: entered by fall-through of je at 0x00420c4e, 2 instruction(s), ends with je to 0x004218d3 (forward)
    cmp dword ptr [ebp - local_3c], 0x1          # 00420c50
    je.d32 L_004218d3                            # 00420c54
    # block 0x00420c5a: entered by fall-through of je at 0x00420c54, 2 instruction(s), ends with je to 0x004221fe (forward)
    cmp dword ptr [ebp - local_3c], 0x2          # 00420c5a
    je.d32 L_004221fe                            # 00420c5e
    # block 0x00420c64: entered by fall-through of je at 0x00420c5e, 1 instruction(s), ends with forward jump to 0x0042290e
    jmp.d32 L_0042290e                           # 00420c64
L_00420c69:
    # block 0x00420c69: entered by je at 0x00420c4e, 2 instruction(s), ends with jne to 0x00420c7b (forward)
    cmp dword ptr [0x5c39e9], 0x0                # 00420c69
    jne.d8 L_00420c7b                            # 00420c70
    # block 0x00420c72: entered by fall-through of jne at 0x00420c70, 2 instruction(s), ends with je to 0x00420c80 (forward)
    cmp dword ptr [0x5c39ed], 0x0                # 00420c72
    je.d8 L_00420c80                             # 00420c79
L_00420c7b:
    # block 0x00420c7b: entered by jne at 0x00420c70; fall-through of je at 0x00420c79, 1 instruction(s), ends with forward jump to 0x0042290e
    jmp.d32 L_0042290e                           # 00420c7b
L_00420c80:
    # block 0x00420c80: entered by je at 0x00420c79, 28 instruction(s), ends with ja to 0x00420d2b (forward)
    mov edx, dword ptr [ebp - local_38]          # 00420c80
    mov ax, word ptr [ebp + arg_8]               # 00420c83
    mov word ptr [edx + field_75b], ax           # 00420c87
    mov ecx, dword ptr [ebp - local_38]          # 00420c8e
    movsx edx, word ptr [ecx + field_75b]        # 00420c91
    imul edx, edx, 0x8d                          # 00420c98
    mov eax, dword ptr [ebp - local_38]          # 00420c9e
    mov ecx, dword ptr [edx + 0x5bb5e5]          # 00420ca1
    mov dword ptr [eax + field_20d5], ecx        # 00420ca7
    mov edx, dword ptr [ebp - local_38]          # 00420cad
    mov eax, dword ptr [ebp - local_38]          # 00420cb0
    mov ecx, dword ptr [eax + field_20d5]        # 00420cb3
    mov dword ptr [edx + field_20d9], ecx        # 00420cb9
    mov edx, dword ptr [ebp - local_38]          # 00420cbf
    movsx eax, word ptr [edx + field_75b]        # 00420cc2
    imul eax, eax, 0x8d                          # 00420cc9
    mov ecx, dword ptr [ebp - local_38]          # 00420ccf
    mov dl, byte ptr [eax + 0x5bb5e3]            # 00420cd2
    mov byte ptr [ecx + field_75a], dl           # 00420cd8
    mov eax, dword ptr [ebp - local_38]          # 00420cde
    {load} xor ecx, ecx                          # 00420ce1
    mov cl, byte ptr [eax + field_75a]           # 00420ce3
    mov dword ptr [ebp - local_40], ecx          # 00420ce9
    mov edx, dword ptr [ebp - local_40]          # 00420cec
    sub edx, 0x39                                # 00420cef
    mov dword ptr [ebp - local_40], edx          # 00420cf2
    cmp dword ptr [ebp - local_40], 0x6          # 00420cf5
    ja.d8 L_00420d2b                             # 00420cf9
    # block 0x00420cfb: entered by fall-through of ja at 0x00420cf9, 2 instruction(s), ends with indirect jump dword ptr [4*eax + 0x422920]
    mov eax, dword ptr [ebp - local_40]          # 00420cfb
    jmp dword ptr [4*eax + SWTAB_00422920_VA]    # 00420cfe
L_00420d05:
    # block 0x00420d05: entered by switch case, 5 instruction(s), ends with forward jump to 0x00420d2b
    mov ecx, dword ptr [ebp - local_38]          # 00420d05
    mov edx, dword ptr [ebp - local_38]          # 00420d08
    mov eax, dword ptr [edx + field_20d9]        # 00420d0b
    mov dword ptr [ecx + field_fad], eax         # 00420d11
    jmp.d8 L_00420d2b                            # 00420d17
L_00420d19:
    # block 0x00420d19: entered by switch case, 4 instruction(s), falls into the block at 0x00420d2b
    mov ecx, dword ptr [ebp - local_38]          # 00420d19
    mov edx, dword ptr [ebp - local_38]          # 00420d1c
    mov eax, dword ptr [edx + field_20d9]        # 00420d1f
    mov dword ptr [ecx + field_fb1], eax         # 00420d25
L_00420d2b:
    # block 0x00420d2b: entered by ja at 0x00420cf9; jmp at 0x00420d17; switch case, 2 instruction(s), ends with je to 0x00420d39 (forward)
    cmp dword ptr [0x583999], 0x3                # 00420d2b
    je.d8 L_00420d39                             # 00420d32
    # block 0x00420d34: entered by fall-through of je at 0x00420d32, 1 instruction(s), ends with forward jump to 0x0042290e
    jmp.d32 L_0042290e                           # 00420d34
L_00420d39:
    # block 0x00420d39: entered by je at 0x00420d32, 3 instruction(s), ends with je to 0x00420d78 (forward)
    movsx ecx, word ptr [0x63a4cd]               # 00420d39
    test ecx, ecx                                # 00420d40
    je.d8 L_00420d78                             # 00420d42
    # block 0x00420d44: entered by fall-through of je at 0x00420d42, 14 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00420d78
    mov edx, dword ptr [ebp - local_38]          # 00420d44
    movsx eax, word ptr [edx + field_75b]        # 00420d47
    push eax                                     # 00420d4e
    push 0x543bb0                                # 00420d4f
    mov ecx, dword ptr [ebp - local_38]          # 00420d54
    add ecx, 0x1fd1                              # 00420d57
    push ecx                                     # 00420d5d
    call FUN_0050ca3e                            # 00420d5e
    add esp, 0xc                                 # 00420d63
    mov edx, dword ptr [ebp - local_38]          # 00420d66
    add edx, 0x1fd1                              # 00420d69
    push edx                                     # 00420d6f
    call FUN_0044a2b7                            # 00420d70
    add esp, 0x4                                 # 00420d75
L_00420d78:
    # block 0x00420d78: entered by je at 0x00420d42, 4 instruction(s), ends with jne to 0x00420da1 (forward)
    mov dword ptr [0x5c39e9], 0x1                # 00420d78
    mov dword ptr [0x5c39ed], 0x1                # 00420d82
    cmp dword ptr [0x583204], 0x4                # 00420d8c
    jne.d8 L_00420da1                            # 00420d93
    # block 0x00420d95: entered by fall-through of jne at 0x00420d93, 3 instruction(s), calls FUN_004eb96e, ends with forward jump to 0x00420db4
    mov ecx, 0x57fd34                            # 00420d95
    call FUN_004eb96e                            # 00420d9a
    jmp.d8 L_00420db4                            # 00420d9f
L_00420da1:
    # block 0x00420da1: entered by jne at 0x00420d93, 2 instruction(s), ends with jne to 0x00420db4 (forward)
    cmp dword ptr [0x583204], 0x3                # 00420da1
    jne.d8 L_00420db4                            # 00420da8
    # block 0x00420daa: entered by fall-through of jne at 0x00420da8, 2 instruction(s), calls FUN_004e7d04, falls into the block at 0x00420db4
    mov ecx, 0x571442                            # 00420daa
    call FUN_004e7d04                            # 00420daf
L_00420db4:
    # block 0x00420db4: entered by jmp at 0x00420d9f; jne at 0x00420da8, 10 instruction(s), calls FUN_004e7728, FUN_004e7786, ends with jge to 0x00420dfd (forward)
    mov dword ptr [0x583204], 0x2                # 00420db4
    push 0x2                                     # 00420dbe
    mov ecx, 0x582711                            # 00420dc0
    call FUN_004e7728                            # 00420dc5
    push 0x0                                     # 00420dca
    mov ecx, 0x582711                            # 00420dcc
    call FUN_004e7786                            # 00420dd1
    mov eax, dword ptr [0x583106]                # 00420dd6
    cmp eax, dword ptr [0x5b3788]                # 00420ddb
    jge.d8 L_00420dfd                            # 00420de1
    # block 0x00420de3: entered by fall-through of jge at 0x00420de1, 6 instruction(s), calls FUN_004db993, falls into the block at 0x00420dfd
    movsx ecx, word ptr [0x5b378e]               # 00420de3
    push ecx                                     # 00420dea
    movsx edx, word ptr [0x5b378c]               # 00420deb
    push edx                                     # 00420df2
    mov ecx, 0x5830ce                            # 00420df3
    call FUN_004db993                            # 00420df8
L_00420dfd:
    # block 0x00420dfd: entered by jge at 0x00420de1, 3 instruction(s), ends with forward jump to 0x00420e1a
    mov word ptr [0x570374], 0x1f                # 00420dfd
    mov word ptr [ebp - local_14], 0x0           # 00420e06
    jmp.d8 L_00420e1a                            # 00420e0c
L_00420e0e:
    # block 0x00420e0e: entered by jmp at 0x00420e32, 3 instruction(s), falls into the block at 0x00420e1a
    mov ax, word ptr [ebp - local_14]            # 00420e0e
    .insn 0x66, 0x05, 0x0001{:u16}               # 00420e12
    mov word ptr [ebp - local_14], ax            # 00420e16
L_00420e1a:
    # block 0x00420e1a: entered by jmp at 0x00420e0c, 3 instruction(s), ends with jge to 0x00420e34 (forward)
    movsx ecx, word ptr [ebp - local_14]         # 00420e1a
    cmp ecx, 0x1e                                # 00420e1e
    jge.d8 L_00420e34                            # 00420e21
    # block 0x00420e23: entered by fall-through of jge at 0x00420e21, 3 instruction(s), ends with backward jump to 0x00420e0e
    movsx edx, word ptr [ebp - local_14]         # 00420e23
    mov dword ptr [4*edx + 0x5839b1], 0x0        # 00420e27
    jmp.d8 L_00420e0e                            # 00420e32
L_00420e34:
    # block 0x00420e34: entered by jge at 0x00420e21, 6 instruction(s), ends with jne to 0x00420e5d (forward)
    mov eax, dword ptr [ebp - local_38]          # 00420e34
    mov ecx, dword ptr [eax + field_20d9]        # 00420e37
    {load} xor edx, edx                          # 00420e3d
    mov dl, byte ptr [ecx + field_778]           # 00420e3f
    test edx, edx                                # 00420e45
    jne.d8 L_00420e5d                            # 00420e47
    # block 0x00420e49: entered by fall-through of jne at 0x00420e47, 4 instruction(s), calls FUN_0041f986, falls into the block at 0x00420e5d
    mov ecx, dword ptr [ebp - local_38]          # 00420e49
    call FUN_0041f986                            # 00420e4c
    mov eax, dword ptr [ebp - local_38]          # 00420e51
    mov word ptr [eax + field_f21], 0x0          # 00420e54
L_00420e5d:
    # block 0x00420e5d: entered by jne at 0x00420e47, 2 instruction(s), ends with forward jump to 0x00420e71
    mov word ptr [ebp - local_14], 0x0           # 00420e5d
    jmp.d8 L_00420e71                            # 00420e63
L_00420e65:
    # block 0x00420e65: entered by jmp at 0x00420e89, 3 instruction(s), falls into the block at 0x00420e71
    mov cx, word ptr [ebp - local_14]            # 00420e65
    add cx, 0x1                                  # 00420e69
    mov word ptr [ebp - local_14], cx            # 00420e6d
L_00420e71:
    # block 0x00420e71: entered by jmp at 0x00420e63, 3 instruction(s), ends with jge to 0x00420e8b (forward)
    movsx edx, word ptr [ebp - local_14]         # 00420e71
    cmp edx, 0x19                                # 00420e75
    jge.d8 L_00420e8b                            # 00420e78
    # block 0x00420e7a: entered by fall-through of jge at 0x00420e78, 4 instruction(s), ends with backward jump to 0x00420e65
    movsx eax, word ptr [ebp - local_14]         # 00420e7a
    mov ecx, dword ptr [ebp - local_38]          # 00420e7e
    mov byte ptr [ecx + eax + field_78e], 0x0    # 00420e81
    jmp.d8 L_00420e65                            # 00420e89
L_00420e8b:
    # block 0x00420e8b: entered by jge at 0x00420e78, 2 instruction(s), ends with forward jump to 0x00420e9f
    mov word ptr [ebp - local_14], 0x0           # 00420e8b
    jmp.d8 L_00420e9f                            # 00420e91
L_00420e93:
    # block 0x00420e93: entered by jmp at 0x00420eb7, 3 instruction(s), falls into the block at 0x00420e9f
    mov dx, word ptr [ebp - local_14]            # 00420e93
    add dx, 0x1                                  # 00420e97
    mov word ptr [ebp - local_14], dx            # 00420e9b
L_00420e9f:
    # block 0x00420e9f: entered by jmp at 0x00420e91, 3 instruction(s), ends with jge to 0x00420eb9 (forward)
    movsx eax, word ptr [ebp - local_14]         # 00420e9f
    cmp eax, 0x19                                # 00420ea3
    jge.d8 L_00420eb9                            # 00420ea6
    # block 0x00420ea8: entered by fall-through of jge at 0x00420ea6, 4 instruction(s), ends with backward jump to 0x00420e93
    movsx ecx, word ptr [ebp - local_14]         # 00420ea8
    mov edx, dword ptr [ebp - local_38]          # 00420eac
    mov byte ptr [edx + ecx + field_7a7], 0x0    # 00420eaf
    jmp.d8 L_00420e93                            # 00420eb7
L_00420eb9:
    # block 0x00420eb9: entered by jge at 0x00420ea6, 2 instruction(s), ends with forward jump to 0x00420ecd
    mov word ptr [ebp - local_14], 0x0           # 00420eb9
    jmp.d8 L_00420ecd                            # 00420ebf
L_00420ec1:
    # block 0x00420ec1: entered by jmp at 0x00420ee5, 3 instruction(s), falls into the block at 0x00420ecd
    mov ax, word ptr [ebp - local_14]            # 00420ec1
    .insn 0x66, 0x05, 0x0001{:u16}               # 00420ec5
    mov word ptr [ebp - local_14], ax            # 00420ec9
L_00420ecd:
    # block 0x00420ecd: entered by jmp at 0x00420ebf, 3 instruction(s), ends with jge to 0x00420ee7 (forward)
    movsx ecx, word ptr [ebp - local_14]         # 00420ecd
    cmp ecx, 0x19                                # 00420ed1
    jge.d8 L_00420ee7                            # 00420ed4
    # block 0x00420ed6: entered by fall-through of jge at 0x00420ed4, 4 instruction(s), ends with backward jump to 0x00420ec1
    movsx edx, word ptr [ebp - local_14]         # 00420ed6
    mov eax, dword ptr [ebp - local_38]          # 00420eda
    mov byte ptr [eax + edx + field_7c0], 0x0    # 00420edd
    jmp.d8 L_00420ec1                            # 00420ee5
L_00420ee7:
    # block 0x00420ee7: entered by jge at 0x00420ed4, 12 instruction(s), calls FUN_004e8d96, ends with je to 0x00420fa7 (forward)
    mov ecx, 0x8                                 # 00420ee7
    {load} xor eax, eax                          # 00420eec
    mov edi, dword ptr [ebp - local_38]          # 00420eee
    add edi, 0x75d                               # 00420ef1
    rep stosd dword ptr es:[edi], eax            # 00420ef7
    stosb byte ptr es:[edi], al                  # 00420ef9
    mov ecx, 0x571442                            # 00420efa
    call FUN_004e8d96                            # 00420eff
    mov dword ptr [0x5d191d], 0x0                # 00420f04
    mov ecx, dword ptr [ebp - local_38]          # 00420f0e
    cmp dword ptr [ecx + field_6b2], 0x0         # 00420f11
    je.d32 L_00420fa7                            # 00420f18
    # block 0x00420f1e: entered by fall-through of je at 0x00420f18, 17 instruction(s), calls FUN_0044c479, FUN_00449a94, ends with je to 0x00420f74 (forward)
    mov edx, dword ptr [ebp - local_38]          # 00420f1e
    add edx, 0x698                               # 00420f21
    push edx                                     # 00420f27
    call FUN_0044c479                            # 00420f28
    add esp, 0x4                                 # 00420f2d
    mov eax, dword ptr [ebp - local_38]          # 00420f30
    mov dword ptr [eax + field_698], 0x2         # 00420f33
    mov ecx, dword ptr [ebp - local_38]          # 00420f3d
    mov ecx, dword ptr [ecx + field_6b2]         # 00420f40
    call FUN_00449a94                            # 00420f46
    mov edx, dword ptr [ebp - local_38]          # 00420f4b
    mov eax, dword ptr [edx + field_6b2]         # 00420f4e
    mov dword ptr [ebp - local_20], eax          # 00420f54
    mov ecx, dword ptr [ebp - local_20]          # 00420f57
    mov dword ptr [ebp - local_1c], ecx          # 00420f5a
    cmp dword ptr [ebp - local_1c], 0x0          # 00420f5d
    je.d8 L_00420f74                             # 00420f61
    # block 0x00420f63: entered by fall-through of je at 0x00420f61, 7 instruction(s), calls indirect dword ptr [eax], ends with forward jump to 0x00420f7b
    push 0x1                                     # 00420f63
    mov edx, dword ptr [ebp - local_1c]          # 00420f65
    mov eax, dword ptr [edx]                     # 00420f68
    mov ecx, dword ptr [ebp - local_1c]          # 00420f6a
    call dword ptr [eax]                         # 00420f6d
    mov dword ptr [ebp - local_44], eax          # 00420f6f
    jmp.d8 L_00420f7b                            # 00420f72
L_00420f74:
    # block 0x00420f74: entered by je at 0x00420f61, 1 instruction(s), falls into the block at 0x00420f7b
    mov dword ptr [ebp - local_44], 0x0          # 00420f74
L_00420f7b:
    # block 0x00420f7b: entered by jmp at 0x00420f72, 9 instruction(s), calls FUN_0044c4ab, falls into the block at 0x00420fa7
    mov ecx, dword ptr [ebp - local_38]          # 00420f7b
    mov dword ptr [ecx + field_6b2], 0x0         # 00420f7e
    mov edx, dword ptr [ebp - local_38]          # 00420f88
    add edx, 0x698                               # 00420f8b
    push edx                                     # 00420f91
    call FUN_0044c4ab                            # 00420f92
    add esp, 0x4                                 # 00420f97
    mov eax, dword ptr [ebp - local_38]          # 00420f9a
    mov dword ptr [eax + field_698], 0x0         # 00420f9d
L_00420fa7:
    # block 0x00420fa7: entered by je at 0x00420f18, 10 instruction(s), ends with forward jump to 0x00420fef
    mov ecx, dword ptr [ebp - local_38]          # 00420fa7
    mov dword ptr [ecx + field_6de], 0x0         # 00420faa
    mov edx, dword ptr [ebp - local_38]          # 00420fb4
    mov dword ptr [edx + field_6da], 0x0         # 00420fb7
    mov eax, dword ptr [ebp - local_38]          # 00420fc1
    mov dword ptr [eax + field_6e2], 0x1         # 00420fc4
    mov ecx, dword ptr [ebp - local_38]          # 00420fce
    mov dword ptr [ecx + field_6e6], 0x1         # 00420fd1
    mov word ptr [ebp - local_14], 0x1           # 00420fdb
    jmp.d8 L_00420fef                            # 00420fe1
L_00420fe3:
    # block 0x00420fe3: entered by jmp at 0x00421028, 3 instruction(s), falls into the block at 0x00420fef
    mov dx, word ptr [ebp - local_14]            # 00420fe3
    add dx, 0x1                                  # 00420fe7
    mov word ptr [ebp - local_14], dx            # 00420feb
L_00420fef:
    # block 0x00420fef: entered by jmp at 0x00420fe1, 3 instruction(s), ends with jge to 0x0042102a (forward)
    movsx eax, word ptr [ebp - local_14]         # 00420fef
    cmp eax, 0x4                                 # 00420ff3
    jge.d8 L_0042102a                            # 00420ff6
    # block 0x00420ff8: entered by fall-through of jge at 0x00420ff6, 15 instruction(s), ends with backward jump to 0x00420fe3
    mov ecx, dword ptr [ebp - local_38]          # 00420ff8
    add ecx, 0x6da                               # 00420ffb
    movsx edx, word ptr [ebp - local_14]         # 00421001
    shl edx, 0x4                                 # 00421005
    mov eax, dword ptr [ebp - local_38]          # 00421008
    lea edx, [eax + edx + field_6da]             # 0042100b
    mov eax, dword ptr [ecx]                     # 00421012
    mov dword ptr [edx], eax                     # 00421014
    mov eax, dword ptr [ecx + field_4]           # 00421016
    mov dword ptr [edx + field_4], eax           # 00421019
    mov eax, dword ptr [ecx + field_8]           # 0042101c
    mov dword ptr [edx + field_8], eax           # 0042101f
    mov ecx, dword ptr [ecx + field_c]           # 00421022
    mov dword ptr [edx + field_c], ecx           # 00421025
    jmp.d8 L_00420fe3                            # 00421028
L_0042102a:
    # block 0x0042102a: entered by jge at 0x00420ff6, 22 instruction(s), ends with forward jump to 0x0042109e
    mov edx, dword ptr [ebp - local_38]          # 0042102a
    mov eax, dword ptr [edx + field_6de]         # 0042102d
    add eax, dword ptr [0x58318a]                # 00421033
    mov ecx, dword ptr [ebp - local_38]          # 00421039
    mov dword ptr [ecx + field_71e], eax         # 0042103c
    mov edx, dword ptr [ebp - local_38]          # 00421042
    mov eax, dword ptr [edx + field_6e6]         # 00421045
    add eax, dword ptr [0x58318a]                # 0042104b
    mov ecx, dword ptr [ebp - local_38]          # 00421051
    mov dword ptr [ecx + field_726], eax         # 00421054
    mov edx, dword ptr [ebp - local_38]          # 0042105a
    mov eax, dword ptr [edx + field_6da]         # 0042105d
    add eax, dword ptr [0x583186]                # 00421063
    mov ecx, dword ptr [ebp - local_38]          # 00421069
    mov dword ptr [ecx + field_71a], eax         # 0042106c
    mov edx, dword ptr [ebp - local_38]          # 00421072
    mov eax, dword ptr [edx + field_6e2]         # 00421075
    add eax, dword ptr [0x583186]                # 0042107b
    mov ecx, dword ptr [ebp - local_38]          # 00421081
    mov dword ptr [ecx + field_722], eax         # 00421084
    mov word ptr [ebp - local_14], 0x1           # 0042108a
    jmp.d8 L_0042109e                            # 00421090
L_00421092:
    # block 0x00421092: entered by jmp at 0x004210d7, 3 instruction(s), falls into the block at 0x0042109e
    mov dx, word ptr [ebp - local_14]            # 00421092
    add dx, 0x1                                  # 00421096
    mov word ptr [ebp - local_14], dx            # 0042109a
L_0042109e:
    # block 0x0042109e: entered by jmp at 0x00421090, 3 instruction(s), ends with jge to 0x004210d9 (forward)
    movsx eax, word ptr [ebp - local_14]         # 0042109e
    cmp eax, 0x4                                 # 004210a2
    jge.d8 L_004210d9                            # 004210a5
    # block 0x004210a7: entered by fall-through of jge at 0x004210a5, 15 instruction(s), ends with backward jump to 0x00421092
    mov ecx, dword ptr [ebp - local_38]          # 004210a7
    add ecx, 0x71a                               # 004210aa
    movsx edx, word ptr [ebp - local_14]         # 004210b0
    shl edx, 0x4                                 # 004210b4
    mov eax, dword ptr [ebp - local_38]          # 004210b7
    lea edx, [eax + edx + field_71a]             # 004210ba
    mov eax, dword ptr [ecx]                     # 004210c1
    mov dword ptr [edx], eax                     # 004210c3
    mov eax, dword ptr [ecx + field_4]           # 004210c5
    mov dword ptr [edx + field_4], eax           # 004210c8
    mov eax, dword ptr [ecx + field_8]           # 004210cb
    mov dword ptr [edx + field_8], eax           # 004210ce
    mov ecx, dword ptr [ecx + field_c]           # 004210d1
    mov dword ptr [edx + field_c], ecx           # 004210d4
    jmp.d8 L_00421092                            # 004210d7
L_004210d9:
    # block 0x004210d9: entered by jge at 0x004210a5, 53 instruction(s), calls FUN_004c948f, FUN_004c2898, FUN_0041de29, FUN_004205c1, ends with forward jump to 0x004211e3
    mov ecx, 0x5cf659                            # 004210d9
    call FUN_004c948f                            # 004210de
    mov edx, dword ptr [ebp - local_38]          # 004210e3
    mov word ptr [edx + field_f73], ax           # 004210e6
    push 0x543be8                                # 004210ed
    push 0x8                                     # 004210f2
    mov ax, word ptr [0x5b0a76]                  # 004210f4
    push eax                                     # 004210fa
    mov cx, word ptr [0x5b0a74]                  # 004210fb
    push ecx                                     # 00421102
    mov edx, dword ptr [ebp - local_38]          # 00421103
    movsx eax, word ptr [edx + field_f73]        # 00421106
    lea ecx, [4*eax + 0x5d02cb]                  # 0042110d
    push ecx                                     # 00421114
    mov ecx, 0x5cf659                            # 00421115
    call FUN_004c2898                            # 0042111a
    mov ecx, 0x5cf659                            # 0042111f
    call FUN_004c948f                            # 00421124
    mov edx, dword ptr [ebp - local_38]          # 00421129
    mov word ptr [edx + field_f75], ax           # 0042112c
    push 0x543c14                                # 00421133
    push 0x8                                     # 00421138
    mov ax, word ptr [0x5b0a76]                  # 0042113a
    push eax                                     # 00421140
    mov cx, word ptr [0x5b0a74]                  # 00421141
    push ecx                                     # 00421148
    mov edx, dword ptr [ebp - local_38]          # 00421149
    movsx eax, word ptr [edx + field_f75]        # 0042114c
    lea ecx, [4*eax + 0x5d02cb]                  # 00421153
    push ecx                                     # 0042115a
    mov ecx, 0x5cf659                            # 0042115b
    call FUN_004c2898                            # 00421160
    mov dword ptr [0x5b15da], 0x0                # 00421165
    mov edx, dword ptr [ebp - local_38]          # 0042116f
    mov word ptr [edx + field_78a], 0x0          # 00421172
    mov eax, dword ptr [ebp - local_38]          # 0042117b
    mov word ptr [eax + field_788], 0x0          # 0042117e
    mov ecx, dword ptr [ebp - local_38]          # 00421187
    mov word ptr [ecx + field_78c], 0x0          # 0042118a
    mov edx, dword ptr [ebp - local_38]          # 00421193
    mov word ptr [edx + field_690], 0xffff       # 00421196
    mov eax, dword ptr [ebp - local_38]          # 0042119f
    mov word ptr [eax + field_696], 0x0          # 004211a2
    mov ecx, dword ptr [ebp - local_38]          # 004211ab
    call FUN_0041de29                            # 004211ae
    mov ecx, dword ptr [ebp - local_38]          # 004211b3
    mov dx, word ptr [ecx + field_75b]           # 004211b6
    push edx                                     # 004211bd
    mov ecx, dword ptr [ebp - local_38]          # 004211be
    call FUN_004205c1                            # 004211c1
    mov word ptr [0x5b0a8e], 0x0                 # 004211c6
    mov word ptr [ebp - local_14], 0x0           # 004211cf
    jmp.d8 L_004211e3                            # 004211d5
L_004211d7:
    # block 0x004211d7: entered by jmp at 0x00421203, 3 instruction(s), falls into the block at 0x004211e3
    mov ax, word ptr [ebp - local_14]            # 004211d7
    .insn 0x66, 0x05, 0x0001{:u16}               # 004211db
    mov word ptr [ebp - local_14], ax            # 004211df
L_004211e3:
    # block 0x004211e3: entered by jmp at 0x004211d5, 3 instruction(s), ends with jge to 0x00421205 (forward)
    movsx ecx, word ptr [ebp - local_14]         # 004211e3
    cmp ecx, 0x3c                                # 004211e7
    jge.d8 L_00421205                            # 004211ea
    # block 0x004211ec: entered by fall-through of jge at 0x004211ea, 8 instruction(s), ends with backward jump to 0x004211d7
    mov ecx, 0x8                                 # 004211ec
    {load} xor eax, eax                          # 004211f1
    movsx edi, word ptr [ebp - local_14]         # 004211f3
    imul edi, edi, 0x29                          # 004211f7
    add edi, 0x5b0a9a                            # 004211fa
    rep stosd dword ptr es:[edi], eax            # 00421200
    stosb byte ptr es:[edi], al                  # 00421202
    jmp.d8 L_004211d7                            # 00421203
L_00421205:
    # block 0x00421205: entered by jge at 0x004211ea, 3 instruction(s), ends with forward jump to 0x00421222
    mov word ptr [0x5b0a90], 0x0                 # 00421205
    mov word ptr [ebp - local_14], 0x0           # 0042120e
    jmp.d8 L_00421222                            # 00421214
L_00421216:
    # block 0x00421216: entered by jmp at 0x00421239, 3 instruction(s), falls into the block at 0x00421222
    mov dx, word ptr [ebp - local_14]            # 00421216
    add dx, 0x1                                  # 0042121a
    mov word ptr [ebp - local_14], dx            # 0042121e
L_00421222:
    # block 0x00421222: entered by jmp at 0x00421214, 3 instruction(s), ends with jge to 0x0042123b (forward)
    movsx eax, word ptr [ebp - local_14]         # 00421222
    cmp eax, 0xa                                 # 00421226
    jge.d8 L_0042123b                            # 00421229
    # block 0x0042122b: entered by fall-through of jge at 0x00421229, 4 instruction(s), ends with backward jump to 0x00421216
    movsx ecx, word ptr [ebp - local_14]         # 0042122b
    imul ecx, ecx, 0x29                          # 0042122f
    mov byte ptr [ecx + 0x5b1436], 0x0           # 00421232
    jmp.d8 L_00421216                            # 00421239
L_0042123b:
    # block 0x0042123b: entered by jge at 0x00421229, 2 instruction(s), ends with jne to 0x0042128a (forward)
    cmp dword ptr [0x5bb202], 0x0                # 0042123b
    jne.d8 L_0042128a                            # 00421242
    # block 0x00421244: entered by fall-through of jne at 0x00421242, 4 instruction(s), ends with jne to 0x0042128a (forward)
    mov edx, dword ptr [ebp - local_38]          # 00421244
    movsx eax, word ptr [edx + field_f21]        # 00421247
    test eax, eax                                # 0042124e
    jne.d8 L_0042128a                            # 00421250
    # block 0x00421252: entered by fall-through of jne at 0x00421250, 9 instruction(s), ends with forward jump to 0x0042133a
    movsx ecx, word ptr [0x5b0a76]               # 00421252
    mov edx, dword ptr [0x5b0a1e]                # 00421259
    sub edx, dword ptr [0x5b0a16]                # 0042125f
    add edx, 0x1                                 # 00421265
    {load} sub ecx, edx                          # 00421268
    mov word ptr [0x5b0a7c], cx                  # 0042126a
    mov dword ptr [0x5b15c8], 0x1                # 00421271
    mov dword ptr [0x5b15d6], 0x0                # 0042127b
    jmp.d32 L_0042133a                           # 00421285
L_0042128a:
    # block 0x0042128a: entered by jne at 0x00421242; jne at 0x00421250, 44 instruction(s), calls FUN_0041e3c0, FUN_0041e647, FUN_004c51a5, falls into the block at 0x0042133a
    mov eax, dword ptr [ebp - local_38]          # 0042128a
    mov cx, word ptr [eax + field_75b]           # 0042128d
    push ecx                                     # 00421294
    mov ecx, dword ptr [ebp - local_38]          # 00421295
    call FUN_0041e3c0                            # 00421298
    mov dx, word ptr [0x5b0a66]                  # 0042129d
    push edx                                     # 004212a4
    mov al, byte ptr [0x5b0a70]                  # 004212a5
    push eax                                     # 004212aa
    mov cl, byte ptr [0x5b0a6f]                  # 004212ab
    push ecx                                     # 004212b1
    mov dl, byte ptr [0x5b0a6e]                  # 004212b2
    push edx                                     # 004212b8
    mov eax, dword ptr [ebp - local_38]          # 004212b9
    movsx ecx, word ptr [eax + field_f73]        # 004212bc
    mov edx, dword ptr [4*ecx + 0x5d02cb]        # 004212c3
    push edx                                     # 004212ca
    mov ecx, dword ptr [ebp - local_38]          # 004212cb
    call FUN_0041e647                            # 004212ce
    mov ax, word ptr [0x5b0a68]                  # 004212d3
    push eax                                     # 004212d9
    mov cl, byte ptr [0x5b0a73]                  # 004212da
    push ecx                                     # 004212e0
    mov dl, byte ptr [0x5b0a72]                  # 004212e1
    push edx                                     # 004212e7
    mov al, byte ptr [0x5b0a71]                  # 004212e8
    push eax                                     # 004212ed
    mov ecx, dword ptr [ebp - local_38]          # 004212ee
    movsx edx, word ptr [ecx + field_f75]        # 004212f1
    mov eax, dword ptr [4*edx + 0x5d02cb]        # 004212f8
    push eax                                     # 004212ff
    mov ecx, dword ptr [ebp - local_38]          # 00421300
    call FUN_0041e647                            # 00421303
    push 0x543c40                                # 00421308
    push 0x5b0a22                                # 0042130d
    push 0x5b0a22                                # 00421312
    mov ecx, dword ptr [0x5d03af]                # 00421317
    push ecx                                     # 0042131d
    mov edx, dword ptr [ebp - local_38]          # 0042131e
    movsx eax, word ptr [edx + field_f73]        # 00421321
    mov ecx, dword ptr [4*eax + 0x5d02cb]        # 00421328
    push ecx                                     # 0042132f
    mov ecx, 0x5cf659                            # 00421330
    call FUN_004c51a5                            # 00421335
L_0042133a:
    # block 0x0042133a: entered by jmp at 0x00421285, 9 instruction(s), ends with ja to 0x004218b4 (forward)
    mov edx, dword ptr [ebp - local_38]          # 0042133a
    {load} xor eax, eax                          # 0042133d
    mov al, byte ptr [edx + field_75a]           # 0042133f
    mov dword ptr [ebp - local_48], eax          # 00421345
    mov ecx, dword ptr [ebp - local_48]          # 00421348
    sub ecx, 0x39                                # 0042134b
    mov dword ptr [ebp - local_48], ecx          # 0042134e
    cmp dword ptr [ebp - local_48], 0x6          # 00421351
    ja.d32 L_004218b4                            # 00421355
    # block 0x0042135b: entered by fall-through of ja at 0x00421355, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x42293c]
    mov edx, dword ptr [ebp - local_48]          # 0042135b
    jmp dword ptr [4*edx + SWTAB_0042293c_VA]    # 0042135e
L_00421365:
    # block 0x00421365: entered by switch case, 12 instruction(s), calls FUN_004fb77a, ends with forward jump to 0x004213a5
    mov eax, dword ptr [ebp - local_38]          # 00421365
    mov ecx, dword ptr [eax + field_fad]         # 00421368
    add ecx, 0x13a                               # 0042136e
    mov edx, dword ptr [ebp - local_38]          # 00421374
    mov dword ptr [edx + field_6aa], ecx         # 00421377
    mov eax, dword ptr [ebp - local_38]          # 0042137d
    mov ecx, dword ptr [eax + field_6aa]         # 00421380
    push ecx                                     # 00421386
    mov ecx, 0x5c3a67                            # 00421387
    call FUN_004fb77a                            # 0042138c
    mov word ptr [ebp - local_14], 0x0           # 00421391
    jmp.d8 L_004213a5                            # 00421397
L_00421399:
    # block 0x00421399: entered by jmp at 0x004213f3, 3 instruction(s), falls into the block at 0x004213a5
    mov dx, word ptr [ebp - local_14]            # 00421399
    add dx, 0x1                                  # 0042139d
    mov word ptr [ebp - local_14], dx            # 004213a1
L_004213a5:
    # block 0x004213a5: entered by jmp at 0x00421397, 3 instruction(s), ends with jge to 0x004213f5 (forward)
    movsx eax, word ptr [ebp - local_14]         # 004213a5
    cmp eax, 0x21                                # 004213a9
    jge.d8 L_004213f5                            # 004213ac
    # block 0x004213ae: entered by fall-through of jge at 0x004213ac, 6 instruction(s), ends with je to 0x004213e4 (forward)
    movsx ecx, word ptr [ebp - local_14]         # 004213ae
    mov edx, dword ptr [ebp - local_38]          # 004213b2
    mov eax, dword ptr [edx + field_fad]         # 004213b5
    movsx ecx, byte ptr [eax + ecx]              # 004213bb
    cmp ecx, 0x5f                                # 004213bf
    je.d8 L_004213e4                             # 004213c2
    # block 0x004213c4: entered by fall-through of je at 0x004213c2, 8 instruction(s), ends with forward jump to 0x004213f3
    movsx edx, word ptr [ebp - local_14]         # 004213c4
    mov eax, dword ptr [ebp - local_38]          # 004213c8
    mov ecx, dword ptr [eax + field_fad]         # 004213cb
    movsx eax, word ptr [ebp - local_14]         # 004213d1
    mov esi, dword ptr [ebp - local_38]          # 004213d5
    mov cl, byte ptr [ecx + edx]                 # 004213d8
    mov byte ptr [esi + eax + field_75d], cl     # 004213db
    jmp.d8 L_004213f3                            # 004213e2
L_004213e4:
    # block 0x004213e4: entered by je at 0x004213c2, 3 instruction(s), falls into the block at 0x004213f3
    movsx edx, word ptr [ebp - local_14]         # 004213e4
    mov eax, dword ptr [ebp - local_38]          # 004213e8
    mov byte ptr [eax + edx + field_75d], 0x20   # 004213eb
L_004213f3:
    # block 0x004213f3: entered by jmp at 0x004213e2, 1 instruction(s), ends with backward jump to 0x00421399
    jmp.d8 L_00421399                            # 004213f3
L_004213f5:
    # block 0x004213f5: entered by jge at 0x004213ac, 7 instruction(s), ends with jle to 0x00421483 (forward)
    mov ecx, dword ptr [ebp - local_38]          # 004213f5
    mov edx, dword ptr [ecx + field_fad]         # 004213f8
    mov eax, dword ptr [ebp - local_38]          # 004213fe
    movsx ecx, word ptr [eax + field_786]        # 00421401
    movsx edx, word ptr [edx + 2*ecx + field_ac] # 00421408
    test edx, edx                                # 00421410
    jle.d8 L_00421483                            # 00421412
    # block 0x00421414: entered by fall-through of jle at 0x00421412, 26 instruction(s), calls FUN_0050ce04, falls into the block at 0x00421483
    mov eax, dword ptr [ebp - local_38]          # 00421414
    mov ecx, dword ptr [eax + field_fad]         # 00421417
    movsx edx, word ptr [ecx + field_aa]         # 0042141d
    mov eax, dword ptr [ebp - local_38]          # 00421424
    mov ecx, dword ptr [eax + field_fad]         # 00421427
    movsx eax, word ptr [ecx + field_a8]         # 0042142d
    {load} sub edx, eax                          # 00421434
    add edx, 0x1                                 # 00421436
    mov dword ptr [ebp - local_4c], edx          # 00421439
    fild dword ptr [ebp - local_4c]              # 0042143c
    fstp dword ptr [ebp - local_50]              # 0042143f
    fld dword ptr [ebp - local_50]               # 00421442
    mov ecx, dword ptr [ebp - local_38]          # 00421445
    mov edx, dword ptr [ecx + field_fad]         # 00421448
    mov eax, dword ptr [ebp - local_38]          # 0042144e
    movsx ecx, word ptr [eax + field_786]        # 00421451
    movsx edx, word ptr [edx + 2*ecx + field_ac] # 00421458
    mov dword ptr [ebp - local_54], edx          # 00421460
    fild dword ptr [ebp - local_54]              # 00421463
    fstp dword ptr [ebp - local_58]              # 00421466
    fld dword ptr [ebp - local_58]               # 00421469
    fdiv qword ptr [0x52c680]                    # 0042146c
    fmulp st(1), st                              # 00421472
    call FUN_0050ce04                            # 00421474
    mov ecx, dword ptr [ebp - local_38]          # 00421479
    mov word ptr [ecx + field_696], ax           # 0042147c
L_00421483:
    # block 0x00421483: entered by jle at 0x00421412, 4 instruction(s), ends with jle to 0x0042149e (forward)
    mov edx, dword ptr [ebp - local_38]          # 00421483
    movsx eax, word ptr [edx + field_696]        # 00421486
    cmp eax, 0x4b                                # 0042148d
    jle.d8 L_0042149e                            # 00421490
    # block 0x00421492: entered by fall-through of jle at 0x00421490, 2 instruction(s), falls into the block at 0x0042149e
    mov ecx, dword ptr [ebp - local_38]          # 00421492
    mov word ptr [ecx + field_696], 0x4b         # 00421495
L_0042149e:
    # block 0x0042149e: entered by jle at 0x00421490, 4 instruction(s), ends with jge to 0x004214b9 (forward)
    mov edx, dword ptr [ebp - local_38]          # 0042149e
    movsx eax, word ptr [edx + field_696]        # 004214a1
    cmp eax, 0x4                                 # 004214a8
    jge.d8 L_004214b9                            # 004214ab
    # block 0x004214ad: entered by fall-through of jge at 0x004214ab, 2 instruction(s), falls into the block at 0x004214b9
    mov ecx, dword ptr [ebp - local_38]          # 004214ad
    mov word ptr [ecx + field_696], 0x4          # 004214b0
L_004214b9:
    # block 0x004214b9: entered by jge at 0x004214ab, 3 instruction(s), ends with je to 0x00421502 (forward)
    movsx edx, word ptr [0x63a4cd]               # 004214b9
    test edx, edx                                # 004214c0
    je.d8 L_00421502                             # 004214c2
    # block 0x004214c4: entered by fall-through of je at 0x004214c2, 17 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00421502
    mov eax, dword ptr [ebp - local_38]          # 004214c4
    movsx ecx, word ptr [eax + field_696]        # 004214c7
    push ecx                                     # 004214ce
    mov edx, dword ptr [ebp - local_38]          # 004214cf
    mov eax, dword ptr [edx + field_fad]         # 004214d2
    push eax                                     # 004214d8
    push 0x543c5c                                # 004214d9
    mov ecx, dword ptr [ebp - local_38]          # 004214de
    add ecx, 0x1fd1                              # 004214e1
    push ecx                                     # 004214e7
    call FUN_0050ca3e                            # 004214e8
    add esp, 0x10                                # 004214ed
    mov edx, dword ptr [ebp - local_38]          # 004214f0
    add edx, 0x1fd1                              # 004214f3
    push edx                                     # 004214f9
    call FUN_0044a2b7                            # 004214fa
    add esp, 0x4                                 # 004214ff
L_00421502:
    # block 0x00421502: entered by je at 0x004214c2, 14 instruction(s), calls FUN_00418e52, ends with jne to 0x00421582 (forward)
    mov eax, dword ptr [ebp - local_38]          # 00421502
    add eax, 0xfa9                               # 00421505
    push eax                                     # 0042150a
    mov ecx, dword ptr [ebp - local_38]          # 0042150b
    mov edx, dword ptr [ecx + field_fad]         # 0042150e
    push edx                                     # 00421514
    push 0x543ca4                                # 00421515
    mov ecx, 0x5d2f31                            # 0042151a
    call FUN_00418e52                            # 0042151f
    mov ecx, dword ptr [ebp - local_38]          # 00421524
    mov dword ptr [ecx + field_fa5], eax         # 00421527
    mov edx, dword ptr [ebp - local_38]          # 0042152d
    cmp dword ptr [edx + field_fa5], 0x0         # 00421530
    jne.d8 L_00421582                            # 00421537
    # block 0x00421539: entered by fall-through of jne at 0x00421537, 20 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x00421582
    mov eax, dword ptr [ebp - local_38]          # 00421539
    movsx ecx, word ptr [eax + field_75b]        # 0042153c
    push ecx                                     # 00421543
    mov edx, dword ptr [ebp - local_38]          # 00421544
    mov eax, dword ptr [edx + field_fad]         # 00421547
    push eax                                     # 0042154d
    push 0x543cac                                # 0042154e
    mov ecx, dword ptr [ebp - local_38]          # 00421553
    add ecx, 0x1fd1                              # 00421556
    push ecx                                     # 0042155c
    call FUN_0050ca3e                            # 0042155d
    add esp, 0x10                                # 00421562
    push 0x0                                     # 00421565
    push 0x0                                     # 00421567
    mov edx, dword ptr [ebp - local_38]          # 00421569
    add edx, 0x1fd1                              # 0042156c
    push edx                                     # 00421572
    call FUN_0052139c                            # 00421573
    mov ecx, 0x5cf659                            # 00421578
    call FUN_004c97b4                            # 0042157d
L_00421582:
    # block 0x00421582: entered by jne at 0x00421537, 33 instruction(s), ends with forward jump to 0x00421624
    mov eax, dword ptr [ebp - local_38]          # 00421582
    mov esi, dword ptr [eax + field_fa5]         # 00421585
    mov edi, dword ptr [ebp - local_38]          # 0042158b
    add edi, 0xf77                               # 0042158e
    mov ecx, 0xa                                 # 00421594
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00421599
    movsw word ptr es:[edi], word ptr [esi]      # 0042159b
    mov ecx, dword ptr [ebp - local_38]          # 0042159d
    mov edx, dword ptr [ecx + field_fa5]         # 004215a0
    add edx, 0x2a                                # 004215a6
    mov eax, dword ptr [ebp - local_38]          # 004215a9
    mov dword ptr [eax + field_fa1], edx         # 004215ac
    mov ecx, dword ptr [ebp - local_38]          # 004215b2
    mov edx, dword ptr [ebp - local_38]          # 004215b5
    mov eax, dword ptr [edx + field_f9d]         # 004215b8
    mov dword ptr [ecx + field_69e], eax         # 004215be
    mov ecx, dword ptr [ebp - local_38]          # 004215c4
    mov edx, dword ptr [ecx + field_fad]         # 004215c7
    mov eax, dword ptr [ebp - local_38]          # 004215cd
    mov cx, word ptr [edx + field_aa]            # 004215d0
    mov word ptr [eax + field_6a4], cx           # 004215d7
    mov edx, dword ptr [ebp - local_38]          # 004215de
    mov eax, dword ptr [edx + field_fad]         # 004215e1
    mov ecx, dword ptr [ebp - local_38]          # 004215e7
    mov dx, word ptr [eax + field_a8]            # 004215ea
    mov word ptr [ecx + field_6a2], dx           # 004215f1
    mov eax, dword ptr [ebp - local_38]          # 004215f8
    mov ecx, dword ptr [eax + field_fad]         # 004215fb
    add ecx, 0xa5                                # 00421601
    mov edx, dword ptr [ebp - local_38]          # 00421607
    mov dword ptr [edx + field_6a6], ecx         # 0042160a
    mov word ptr [ebp - local_14], 0x0           # 00421610
    jmp.d8 L_00421624                            # 00421616
L_00421618:
    # block 0x00421618: entered by jmp at 0x004216d4, 3 instruction(s), falls into the block at 0x00421624
    mov ax, word ptr [ebp - local_14]            # 00421618
    .insn 0x66, 0x05, 0x0001{:u16}               # 0042161c
    mov word ptr [ebp - local_14], ax            # 00421620
L_00421624:
    # block 0x00421624: entered by jmp at 0x00421616, 5 instruction(s), ends with jge to 0x004216d9 (forward)
    movsx ecx, word ptr [ebp - local_14]         # 00421624
    mov edx, dword ptr [ebp - local_38]          # 00421628
    movsx eax, word ptr [edx + field_f9b]        # 0042162b
    {load} cmp ecx, eax                          # 00421632
    jge.d32 L_004216d9                           # 00421634
    # block 0x0042163a: entered by fall-through of jge at 0x00421634, 16 instruction(s), calls FUN_0041a216, ends with jne to 0x004216d4 (forward)
    mov ecx, dword ptr [ebp - local_38]          # 0042163a
    mov edx, dword ptr [ecx + field_fad]         # 0042163d
    movsx eax, word ptr [ebp - local_14]         # 00421643
    imul eax, eax, 0x21                          # 00421647
    lea ecx, [edx + eax + field_21]              # 0042164a
    push ecx                                     # 0042164e
    mov ecx, 0x5d2f31                            # 0042164f
    call FUN_0041a216                            # 00421654
    movsx edx, word ptr [ebp - local_14]         # 00421659
    mov ecx, dword ptr [ebp - local_38]          # 0042165d
    mov word ptr [ecx + 2*edx + field_fb5], ax   # 00421660
    movsx edx, word ptr [ebp - local_14]         # 00421668
    mov eax, dword ptr [ebp - local_38]          # 0042166c
    movsx ecx, word ptr [eax + 2*edx + field_fb5] # 0042166f
    cmp ecx, -0x1                                # 00421677
    jne.d8 L_004216d4                            # 0042167a
    # block 0x0042167c: entered by fall-through of jne at 0x0042167a, 25 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x004216d4
    mov edx, dword ptr [ebp - local_38]          # 0042167c
    movsx eax, word ptr [edx + field_75b]        # 0042167f
    push eax                                     # 00421686
    mov ecx, dword ptr [ebp - local_38]          # 00421687
    mov edx, dword ptr [ecx + field_fad]         # 0042168a
    movsx eax, word ptr [ebp - local_14]         # 00421690
    imul eax, eax, 0x21                          # 00421694
    lea ecx, [edx + eax + field_21]              # 00421697
    push ecx                                     # 0042169b
    movsx edx, word ptr [ebp - local_14]         # 0042169c
    push edx                                     # 004216a0
    push 0x543d00                                # 004216a1
    mov eax, dword ptr [ebp - local_38]          # 004216a6
    add eax, 0x1fd1                              # 004216a9
    push eax                                     # 004216ae
    call FUN_0050ca3e                            # 004216af
    add esp, 0x14                                # 004216b4
    push 0x0                                     # 004216b7
    push 0x0                                     # 004216b9
    mov ecx, dword ptr [ebp - local_38]          # 004216bb
    add ecx, 0x1fd1                              # 004216be
    push ecx                                     # 004216c4
    call FUN_0052139c                            # 004216c5
    mov ecx, 0x5cf659                            # 004216ca
    call FUN_004c97b4                            # 004216cf
L_004216d4:
    # block 0x004216d4: entered by jne at 0x0042167a, 1 instruction(s), ends with backward jump to 0x00421618
    jmp.d32 L_00421618                           # 004216d4
L_004216d9:
    # block 0x004216d9: entered by jge at 0x00421634, 13 instruction(s), calls FUN_0050ca3e, FUN_0051dc43, ends with je to 0x0042172d (forward)
    mov edx, dword ptr [0x5bb57b]                # 004216d9
    push edx                                     # 004216df
    push 0x543d70                                # 004216e0
    push 0x63888b                                # 004216e5
    call FUN_0050ca3e                            # 004216ea
    add esp, 0xc                                 # 004216ef
    push 0x46                                    # 004216f2
    call FUN_0051dc43                            # 004216f4
    add esp, 0x4                                 # 004216f9
    mov dword ptr [ebp - local_28], eax          # 004216fc
    mov dword ptr [ebp - local_4], 0x0           # 004216ff
    cmp dword ptr [ebp - local_28], 0x0          # 00421706
    je.d8 L_0042172d                             # 0042170a
    # block 0x0042170c: entered by fall-through of je at 0x0042170a, 9 instruction(s), calls FUN_004497a0, ends with forward jump to 0x00421734
    push 0x4                                     # 0042170c
    movsx eax, word ptr [0x5b016f]               # 0042170e
    push eax                                     # 00421715
    push 0x63888b                                # 00421716
    push 0x422e4a                                # 0042171b
    mov ecx, dword ptr [ebp - local_28]          # 00421720
    call FUN_004497a0                            # 00421723
    mov dword ptr [ebp - local_5c], eax          # 00421728
    jmp.d8 L_00421734                            # 0042172b
L_0042172d:
    # block 0x0042172d: entered by je at 0x0042170a, 1 instruction(s), falls into the block at 0x00421734
    mov dword ptr [ebp - local_5c], 0x0          # 0042172d
L_00421734:
    # block 0x00421734: entered by jmp at 0x0042172b, 8 instruction(s), ends with jne to 0x00421771 (forward)
    mov ecx, dword ptr [ebp - local_5c]          # 00421734
    mov dword ptr [ebp - local_24], ecx          # 00421737
    mov dword ptr [ebp - local_4], 0xffffffff    # 0042173a
    mov edx, dword ptr [ebp - local_38]          # 00421741
    mov eax, dword ptr [ebp - local_24]          # 00421744
    mov dword ptr [edx + field_6b2], eax         # 00421747
    cmp dword ptr [ebp - local_24], 0x0          # 0042174d
    jne.d8 L_00421771                            # 00421751
    # block 0x00421753: entered by fall-through of jne at 0x00421751, 6 instruction(s), calls FUN_0042639d, FUN_004c97b4, falls into the block at 0x00421771
    push 0x63888b                                # 00421753
    push 0x543d9c                                # 00421758
    mov ecx, 0x583979                            # 0042175d
    call FUN_0042639d                            # 00421762
    mov ecx, 0x5cf659                            # 00421767
    call FUN_004c97b4                            # 0042176c
L_00421771:
    # block 0x00421771: entered by jne at 0x00421751, 22 instruction(s), calls FUN_00449bff, ends with je to 0x0042180c (forward)
    mov ecx, dword ptr [ebp - local_38]          # 00421771
    mov word ptr [ecx + field_782], 0xfff6       # 00421774
    mov edx, dword ptr [ebp - local_38]          # 0042177d
    mov word ptr [edx + field_77e], 0xfff6       # 00421780
    mov eax, dword ptr [ebp - local_38]          # 00421789
    mov ecx, dword ptr [ebp - local_38]          # 0042178c
    mov dx, word ptr [ecx + field_6a2]           # 0042178f
    mov word ptr [eax + field_69c], dx           # 00421796
    mov eax, dword ptr [ebp - local_38]          # 0042179d
    mov ecx, dword ptr [ebp - local_38]          # 004217a0
    mov dx, word ptr [ecx + field_69c]           # 004217a3
    mov word ptr [eax + field_692], dx           # 004217aa
    mov eax, dword ptr [ebp - local_38]          # 004217b1
    mov dword ptr [eax + field_6b6], 0x1         # 004217b4
    mov ecx, dword ptr [ebp - local_38]          # 004217be
    mov word ptr [ecx + field_784], 0x0          # 004217c1
    mov edx, dword ptr [ebp - local_38]          # 004217ca
    mov ecx, dword ptr [edx + field_6b2]         # 004217cd
    call FUN_00449bff                            # 004217d3
    movsx eax, word ptr [0x63a4cd]               # 004217d8
    test eax, eax                                # 004217df
    je.d8 L_0042180c                             # 004217e1
    # block 0x004217e3: entered by fall-through of je at 0x004217e1, 11 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x0042180c
    push 0x543dc0                                # 004217e3
    mov ecx, dword ptr [ebp - local_38]          # 004217e8
    add ecx, 0x1fd1                              # 004217eb
    push ecx                                     # 004217f1
    call FUN_0050ca3e                            # 004217f2
    add esp, 0x8                                 # 004217f7
    mov edx, dword ptr [ebp - local_38]          # 004217fa
    add edx, 0x1fd1                              # 004217fd
    push edx                                     # 00421803
    call FUN_0044a2b7                            # 00421804
    add esp, 0x4                                 # 00421809
L_0042180c:
    # block 0x0042180c: entered by je at 0x004217e1, 1 instruction(s), ends with forward jump to 0x004218b4
    jmp.d32 L_004218b4                           # 0042180c
L_00421811:
    # block 0x00421811: entered by switch case, 14 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x00421857
    mov eax, dword ptr [ebp - local_38]          # 00421811
    mov ecx, dword ptr [ebp - local_38]          # 00421814
    mov edx, dword ptr [ecx + field_fb1]         # 00421817
    mov dword ptr [eax + field_6aa], edx         # 0042181d
    mov eax, dword ptr [ebp - local_38]          # 00421823
    mov ecx, dword ptr [eax + field_6aa]         # 00421826
    push ecx                                     # 0042182c
    mov ecx, 0x5c3a67                            # 0042182d
    call FUN_004fb77a                            # 00421832
    push 0xc                                     # 00421837
    mov ecx, 0x5c3a67                            # 00421839
    call FUN_004fb2e3                            # 0042183e
    mov word ptr [ebp - local_14], 0x0           # 00421843
    jmp.d8 L_00421857                            # 00421849
L_0042184b:
    # block 0x0042184b: entered by jmp at 0x004218a5, 3 instruction(s), falls into the block at 0x00421857
    mov dx, word ptr [ebp - local_14]            # 0042184b
    add dx, 0x1                                  # 0042184f
    mov word ptr [ebp - local_14], dx            # 00421853
L_00421857:
    # block 0x00421857: entered by jmp at 0x00421849, 3 instruction(s), ends with jge to 0x004218a7 (forward)
    movsx eax, word ptr [ebp - local_14]         # 00421857
    cmp eax, 0x21                                # 0042185b
    jge.d8 L_004218a7                            # 0042185e
    # block 0x00421860: entered by fall-through of jge at 0x0042185e, 6 instruction(s), ends with je to 0x00421896 (forward)
    movsx ecx, word ptr [ebp - local_14]         # 00421860
    mov edx, dword ptr [ebp - local_38]          # 00421864
    mov eax, dword ptr [edx + field_fb1]         # 00421867
    movsx ecx, byte ptr [eax + ecx]              # 0042186d
    cmp ecx, 0x5f                                # 00421871
    je.d8 L_00421896                             # 00421874
    # block 0x00421876: entered by fall-through of je at 0x00421874, 8 instruction(s), ends with forward jump to 0x004218a5
    movsx edx, word ptr [ebp - local_14]         # 00421876
    mov eax, dword ptr [ebp - local_38]          # 0042187a
    mov ecx, dword ptr [eax + field_fb1]         # 0042187d
    movsx eax, word ptr [ebp - local_14]         # 00421883
    mov esi, dword ptr [ebp - local_38]          # 00421887
    mov cl, byte ptr [ecx + edx]                 # 0042188a
    mov byte ptr [esi + eax + field_75d], cl     # 0042188d
    jmp.d8 L_004218a5                            # 00421894
L_00421896:
    # block 0x00421896: entered by je at 0x00421874, 3 instruction(s), falls into the block at 0x004218a5
    movsx edx, word ptr [ebp - local_14]         # 00421896
    mov eax, dword ptr [ebp - local_38]          # 0042189a
    mov byte ptr [eax + edx + field_75d], 0x20   # 0042189d
L_004218a5:
    # block 0x004218a5: entered by jmp at 0x00421894, 1 instruction(s), ends with backward jump to 0x0042184b
    jmp.d8 L_0042184b                            # 004218a5
L_004218a7:
    # block 0x004218a7: entered by jge at 0x0042185e, 2 instruction(s), falls into the block at 0x004218b4
    mov ecx, dword ptr [ebp - local_38]          # 004218a7
    mov dword ptr [ecx + field_6b6], 0x4         # 004218aa
L_004218b4:
    # block 0x004218b4: entered by ja at 0x00421355; jmp at 0x0042180c; switch case, 5 instruction(s), ends with forward jump to 0x0042290e
    mov edx, dword ptr [ebp - local_38]          # 004218b4
    movsx eax, word ptr [edx + field_75b]        # 004218b7
    imul eax, eax, 0x8d                          # 004218be
    mov dword ptr [eax + 0x5bb632], 0x1          # 004218c4
    jmp.d32 L_0042290e                           # 004218ce
L_004218d3:
    # block 0x004218d3: entered by je at 0x00420c54, 2 instruction(s), ends with je to 0x004218ee (forward)
    cmp dword ptr [0x5b15da], 0x0                # 004218d3
    je.d8 L_004218ee                             # 004218da
    # block 0x004218dc: entered by fall-through of je at 0x004218da, 3 instruction(s), calls FUN_00420b9e, falls into the block at 0x004218ee
    mov dword ptr [0x5b15da], 0x0                # 004218dc
    mov ecx, dword ptr [ebp - local_38]          # 004218e6
    call FUN_00420b9e                            # 004218e9
L_004218ee:
    # block 0x004218ee: entered by je at 0x004218da, 10 instruction(s), calls FUN_004dadff, ends with ja to 0x004221f9 (forward)
    mov ecx, 0x5830a6                            # 004218ee
    call FUN_004dadff                            # 004218f3
    mov ecx, dword ptr [ebp - local_38]          # 004218f8
    mov edx, dword ptr [ecx + field_6b6]         # 004218fb
    mov dword ptr [ebp - local_60], edx          # 00421901
    mov eax, dword ptr [ebp - local_60]          # 00421904
    sub eax, 0x1                                 # 00421907
    mov dword ptr [ebp - local_60], eax          # 0042190a
    cmp dword ptr [ebp - local_60], 0x5          # 0042190d
    ja.d32 L_004221f9                            # 00421911
    # block 0x00421917: entered by fall-through of ja at 0x00421911, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x422958]
    mov ecx, dword ptr [ebp - local_60]          # 00421917
    jmp dword ptr [4*ecx + SWTAB_00422958_VA]    # 0042191a
L_00421921:
    # block 0x00421921: entered by switch case, 6 instruction(s), ends with je to 0x00421955 (forward)
    mov edx, dword ptr [ebp - local_38]          # 00421921
    movsx eax, word ptr [edx + field_68e]        # 00421924
    mov ecx, dword ptr [ebp - local_38]          # 0042192b
    movsx edx, word ptr [ecx + field_696]        # 0042192e
    {load} cmp eax, edx                          # 00421935
    je.d8 L_00421955                             # 00421937
    # block 0x00421939: entered by fall-through of je at 0x00421937, 6 instruction(s), ends with jl to 0x00421a4f (forward)
    mov eax, dword ptr [ebp - local_38]          # 00421939
    movsx ecx, word ptr [eax + field_68e]        # 0042193c
    mov edx, dword ptr [ebp - local_38]          # 00421943
    movsx eax, word ptr [edx + field_6a4]        # 00421946
    {load} cmp ecx, eax                          # 0042194d
    jl.d32 L_00421a4f                            # 0042194f
L_00421955:
    # block 0x00421955: entered by je at 0x00421937; fall-through of jl at 0x0042194f, 9 instruction(s), calls FUN_0041e1e4, ends with jne to 0x0042197a (forward)
    mov ecx, dword ptr [ebp - local_38]          # 00421955
    mov dx, word ptr [ecx + field_69c]           # 00421958
    push edx                                     # 0042195f
    mov ecx, dword ptr [ebp - local_38]          # 00421960
    call FUN_0041e1e4                            # 00421963
    mov word ptr [ebp - local_10], ax            # 00421968
    movsx eax, word ptr [ebp - local_10]         # 0042196c
    cmp eax, -0x1                                # 00421970
    jne.d8 L_0042197a                            # 00421973
    # block 0x00421975: entered by fall-through of jne at 0x00421973, 1 instruction(s), ends with forward jump to 0x004221f9
    jmp.d32 L_004221f9                           # 00421975
L_0042197a:
    # block 0x0042197a: entered by jne at 0x00421973, 23 instruction(s), calls FUN_00422970, FUN_004f6cdc, ends with jne to 0x00421a0e (forward)
    mov ecx, dword ptr [ebp - local_38]          # 0042197a
    mov dx, word ptr [ebp - local_10]            # 0042197d
    mov word ptr [ecx + field_690], dx           # 00421981
    mov eax, dword ptr [ebp - local_38]          # 00421988
    mov cx, word ptr [eax + field_75b]           # 0042198b
    push ecx                                     # 00421992
    mov ecx, dword ptr [ebp - local_38]          # 00421993
    call FUN_00422970                            # 00421996
    mov edx, dword ptr [ebp - local_38]          # 0042199b
    mov eax, dword ptr [edx + field_69e]         # 0042199e
    push eax                                     # 004219a4
    mov ecx, dword ptr [ebp - local_38]          # 004219a5
    movsx edx, word ptr [ecx + field_6a4]        # 004219a8
    mov eax, dword ptr [ebp - local_38]          # 004219af
    movsx ecx, word ptr [eax + field_6a2]        # 004219b2
    {load} sub edx, ecx                          # 004219b9
    add edx, 0x1                                 # 004219bb
    push edx                                     # 004219be
    push 0xc                                     # 004219bf
    mov ecx, 0x5cf1eb                            # 004219c1
    call FUN_004f6cdc                            # 004219c6
    test eax, eax                                # 004219cb
    jne.d8 L_00421a0e                            # 004219cd
    # block 0x004219cf: entered by fall-through of jne at 0x004219cd, 17 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x00421a0e
    mov edx, dword ptr [ebp - local_38]          # 004219cf
    movsx eax, word ptr [edx + field_75b]        # 004219d2
    push eax                                     # 004219d9
    push 0x543e18                                # 004219da
    mov ecx, dword ptr [ebp - local_38]          # 004219df
    add ecx, 0x1fd1                              # 004219e2
    push ecx                                     # 004219e8
    call FUN_0050ca3e                            # 004219e9
    add esp, 0xc                                 # 004219ee
    push 0x0                                     # 004219f1
    push 0x0                                     # 004219f3
    mov edx, dword ptr [ebp - local_38]          # 004219f5
    add edx, 0x1fd1                              # 004219f8
    push edx                                     # 004219fe
    call FUN_0052139c                            # 004219ff
    mov ecx, 0x5cf659                            # 00421a04
    call FUN_004c97b4                            # 00421a09
L_00421a0e:
    # block 0x00421a0e: entered by jne at 0x004219cd, 3 instruction(s), ends with je to 0x00421a42 (forward)
    movsx eax, word ptr [0x63a4cd]               # 00421a0e
    test eax, eax                                # 00421a15
    je.d8 L_00421a42                             # 00421a17
    # block 0x00421a19: entered by fall-through of je at 0x00421a17, 11 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00421a42
    push 0x543e7c                                # 00421a19
    mov ecx, dword ptr [ebp - local_38]          # 00421a1e
    add ecx, 0x1fd1                              # 00421a21
    push ecx                                     # 00421a27
    call FUN_0050ca3e                            # 00421a28
    add esp, 0x8                                 # 00421a2d
    mov edx, dword ptr [ebp - local_38]          # 00421a30
    add edx, 0x1fd1                              # 00421a33
    push edx                                     # 00421a39
    call FUN_0044a2b7                            # 00421a3a
    add esp, 0x4                                 # 00421a3f
L_00421a42:
    # block 0x00421a42: entered by je at 0x00421a17, 2 instruction(s), falls into the block at 0x00421a4f
    mov eax, dword ptr [ebp - local_38]          # 00421a42
    mov dword ptr [eax + field_6b6], 0x4         # 00421a45
L_00421a4f:
    # block 0x00421a4f: entered by jl at 0x0042194f, 1 instruction(s), ends with forward jump to 0x004221f9
    jmp.d32 L_004221f9                           # 00421a4f
L_00421a54:
    # block 0x00421a54: entered by switch case, 6 instruction(s), ends with je to 0x00421aa6 (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 00421a54
    mov ecx, dword ptr [ebp - local_38]          # 00421a5e
    {load} xor edx, edx                          # 00421a61
    mov dl, byte ptr [ecx + field_75a]           # 00421a63
    cmp edx, 0x3a                                # 00421a69
    je.d8 L_00421aa6                             # 00421a6c
    # block 0x00421a6e: entered by fall-through of je at 0x00421a6c, 5 instruction(s), ends with je to 0x00421aa6 (forward)
    mov eax, dword ptr [ebp - local_38]          # 00421a6e
    {load} xor ecx, ecx                          # 00421a71
    mov cl, byte ptr [eax + field_75a]           # 00421a73
    cmp ecx, 0x3c                                # 00421a79
    je.d8 L_00421aa6                             # 00421a7c
    # block 0x00421a7e: entered by fall-through of je at 0x00421a7c, 5 instruction(s), ends with je to 0x00421aa6 (forward)
    mov edx, dword ptr [ebp - local_38]          # 00421a7e
    {load} xor eax, eax                          # 00421a81
    mov al, byte ptr [edx + field_75a]           # 00421a83
    cmp eax, 0x3f                                # 00421a89
    je.d8 L_00421aa6                             # 00421a8c
    # block 0x00421a8e: entered by fall-through of je at 0x00421a8c, 6 instruction(s), ends with je to 0x00421af6 (forward)
    mov ecx, dword ptr [ebp - local_38]          # 00421a8e
    movsx edx, word ptr [ecx + field_77e]        # 00421a91
    mov eax, dword ptr [ebp - local_38]          # 00421a98
    movsx ecx, word ptr [eax + field_6a4]        # 00421a9b
    {load} cmp edx, ecx                          # 00421aa2
    je.d8 L_00421af6                             # 00421aa4
L_00421aa6:
    # block 0x00421aa6: entered by je at 0x00421a6c; je at 0x00421a7c; je at 0x00421a8c; fall-through of je at 0x00421aa4, 5 instruction(s), ends with je to 0x00421ad6 (forward)
    mov edx, dword ptr [ebp - local_38]          # 00421aa6
    {load} xor eax, eax                          # 00421aa9
    mov al, byte ptr [edx + field_75a]           # 00421aab
    cmp eax, 0x3a                                # 00421ab1
    je.d8 L_00421ad6                             # 00421ab4
    # block 0x00421ab6: entered by fall-through of je at 0x00421ab4, 5 instruction(s), ends with je to 0x00421ad6 (forward)
    mov ecx, dword ptr [ebp - local_38]          # 00421ab6
    {load} xor edx, edx                          # 00421ab9
    mov dl, byte ptr [ecx + field_75a]           # 00421abb
    cmp edx, 0x3c                                # 00421ac1
    je.d8 L_00421ad6                             # 00421ac4
    # block 0x00421ac6: entered by fall-through of je at 0x00421ac4, 5 instruction(s), ends with jne to 0x00421ae6 (forward)
    mov eax, dword ptr [ebp - local_38]          # 00421ac6
    {load} xor ecx, ecx                          # 00421ac9
    mov cl, byte ptr [eax + field_75a]           # 00421acb
    cmp ecx, 0x3f                                # 00421ad1
    jne.d8 L_00421ae6                            # 00421ad4
L_00421ad6:
    # block 0x00421ad6: entered by je at 0x00421ab4; je at 0x00421ac4; fall-through of jne at 0x00421ad4, 5 instruction(s), calls FUN_004f6334, ends with je to 0x00421af6 (forward)
    push 0xc                                     # 00421ad6
    mov ecx, 0x5cf1eb                            # 00421ad8
    call FUN_004f6334                            # 00421add
    test eax, eax                                # 00421ae2
    je.d8 L_00421af6                             # 00421ae4
L_00421ae6:
    # block 0x00421ae6: entered by jne at 0x00421ad4; fall-through of je at 0x00421ae4, 4 instruction(s), ends with je to 0x00421c75 (forward)
    {load} xor edx, edx                          # 00421ae6
    mov dl, byte ptr [0x58322a]                  # 00421ae8
    test edx, edx                                # 00421aee
    je.d32 L_00421c75                            # 00421af0
L_00421af6:
    # block 0x00421af6: entered by je at 0x00421aa4; je at 0x00421ae4; fall-through of je at 0x00421af0, 4 instruction(s), ends with jne to 0x00421b5e (forward)
    mov eax, dword ptr [ebp - local_38]          # 00421af6
    movsx ecx, word ptr [eax + field_f21]        # 00421af9
    test ecx, ecx                                # 00421b00
    jne.d8 L_00421b5e                            # 00421b02
    # block 0x00421b04: entered by fall-through of jne at 0x00421b02, 4 instruction(s), ends with jne to 0x00421b5e (forward)
    {load} xor edx, edx                          # 00421b04
    mov dl, byte ptr [0x58322a]                  # 00421b06
    test edx, edx                                # 00421b0c
    jne.d8 L_00421b5e                            # 00421b0e
    # block 0x00421b10: entered by fall-through of jne at 0x00421b0e, 6 instruction(s), ends with je to 0x00421b59 (forward)
    mov word ptr [0x570374], 0x1f                # 00421b10
    mov eax, dword ptr [ebp - local_38]          # 00421b19
    mov dword ptr [eax + field_6b6], 0x5         # 00421b1c
    movsx ecx, word ptr [0x63a4cd]               # 00421b26
    test ecx, ecx                                # 00421b2d
    je.d8 L_00421b59                             # 00421b2f
    # block 0x00421b31: entered by fall-through of je at 0x00421b2f, 11 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00421b59
    push 0x543edc                                # 00421b31
    mov edx, dword ptr [ebp - local_38]          # 00421b36
    add edx, 0x1fd1                              # 00421b39
    push edx                                     # 00421b3f
    call FUN_0050ca3e                            # 00421b40
    add esp, 0x8                                 # 00421b45
    mov eax, dword ptr [ebp - local_38]          # 00421b48
    add eax, 0x1fd1                              # 00421b4b
    push eax                                     # 00421b50
    call FUN_0044a2b7                            # 00421b51
    add esp, 0x4                                 # 00421b56
L_00421b59:
    # block 0x00421b59: entered by je at 0x00421b2f, 1 instruction(s), ends with forward jump to 0x004221f9
    jmp.d32 L_004221f9                           # 00421b59
L_00421b5e:
    # block 0x00421b5e: entered by jne at 0x00421b02; jne at 0x00421b0e, 4 instruction(s), ends with jne to 0x00421bd3 (forward)
    mov ecx, dword ptr [ebp - local_38]          # 00421b5e
    movsx edx, word ptr [ecx + field_f21]        # 00421b61
    test edx, edx                                # 00421b68
    jne.d8 L_00421bd3                            # 00421b6a
    # block 0x00421b6c: entered by fall-through of jne at 0x00421b6a, 4 instruction(s), ends with je to 0x00421bd3 (forward)
    {load} xor eax, eax                          # 00421b6c
    mov al, byte ptr [0x58322a]                  # 00421b6e
    test eax, eax                                # 00421b73
    je.d8 L_00421bd3                             # 00421b75
    # block 0x00421b77: entered by fall-through of je at 0x00421b75, 4 instruction(s), ends with jne to 0x00421bd3 (forward)
    {load} xor ecx, ecx                          # 00421b77
    mov cl, byte ptr [0x58321d]                  # 00421b79
    cmp ecx, 0x1                                 # 00421b7f
    jne.d8 L_00421bd3                            # 00421b82
    # block 0x00421b84: entered by fall-through of jne at 0x00421b82, 6 instruction(s), ends with je to 0x00421bce (forward)
    mov word ptr [0x570374], 0x1f                # 00421b84
    mov edx, dword ptr [ebp - local_38]          # 00421b8d
    mov dword ptr [edx + field_6b6], 0x5         # 00421b90
    movsx eax, word ptr [0x63a4cd]               # 00421b9a
    test eax, eax                                # 00421ba1
    je.d8 L_00421bce                             # 00421ba3
    # block 0x00421ba5: entered by fall-through of je at 0x00421ba3, 11 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00421bce
    push 0x543f38                                # 00421ba5
    mov ecx, dword ptr [ebp - local_38]          # 00421baa
    add ecx, 0x1fd1                              # 00421bad
    push ecx                                     # 00421bb3
    call FUN_0050ca3e                            # 00421bb4
    add esp, 0x8                                 # 00421bb9
    mov edx, dword ptr [ebp - local_38]          # 00421bbc
    add edx, 0x1fd1                              # 00421bbf
    push edx                                     # 00421bc5
    call FUN_0044a2b7                            # 00421bc6
    add esp, 0x4                                 # 00421bcb
L_00421bce:
    # block 0x00421bce: entered by je at 0x00421ba3, 1 instruction(s), ends with forward jump to 0x004221f9
    jmp.d32 L_004221f9                           # 00421bce
L_00421bd3:
    # block 0x00421bd3: entered by jne at 0x00421b6a; je at 0x00421b75; jne at 0x00421b82, 4 instruction(s), ends with jle to 0x00421c75 (forward)
    mov eax, dword ptr [ebp - local_38]          # 00421bd3
    movsx ecx, word ptr [eax + field_f21]        # 00421bd6
    test ecx, ecx                                # 00421bdd
    jle.d32 L_00421c75                           # 00421bdf
    # block 0x00421be5: entered by fall-through of jle at 0x00421bdf, 2 instruction(s), ends with forward jump to 0x00421bf9
    mov word ptr [ebp - local_14], 0x0           # 00421be5
    jmp.d8 L_00421bf9                            # 00421beb
L_00421bed:
    # block 0x00421bed: entered by jmp at 0x00421c62, 3 instruction(s), falls into the block at 0x00421bf9
    mov dx, word ptr [ebp - local_14]            # 00421bed
    add dx, 0x1                                  # 00421bf1
    mov word ptr [ebp - local_14], dx            # 00421bf5
L_00421bf9:
    # block 0x00421bf9: entered by jmp at 0x00421beb, 3 instruction(s), ends with jge to 0x00421c64 (forward)
    movsx eax, word ptr [ebp - local_14]         # 00421bf9
    cmp eax, 0x1e                                # 00421bfd
    jge.d8 L_00421c64                            # 00421c00
    # block 0x00421c02: entered by fall-through of jge at 0x00421c00, 3 instruction(s), ends with jne to 0x00421c62 (forward)
    movsx ecx, word ptr [ebp - local_14]         # 00421c02
    cmp dword ptr [4*ecx + 0x5839b1], 0x1        # 00421c06
    jne.d8 L_00421c62                            # 00421c0e
    # block 0x00421c10: entered by fall-through of jne at 0x00421c0e, 7 instruction(s), ends with je to 0x00421c60 (forward)
    mov dx, word ptr [ebp - local_14]            # 00421c10
    mov word ptr [0x570374], dx                  # 00421c14
    mov eax, dword ptr [ebp - local_38]          # 00421c1b
    mov dword ptr [eax + field_6b6], 0x5         # 00421c1e
    movsx ecx, word ptr [0x63a4cd]               # 00421c28
    test ecx, ecx                                # 00421c2f
    je.d8 L_00421c60                             # 00421c31
    # block 0x00421c33: entered by fall-through of je at 0x00421c31, 13 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00421c60
    movsx edx, word ptr [ebp - local_14]         # 00421c33
    push edx                                     # 00421c37
    push 0x543f94                                # 00421c38
    mov eax, dword ptr [ebp - local_38]          # 00421c3d
    add eax, 0x1fd1                              # 00421c40
    push eax                                     # 00421c45
    call FUN_0050ca3e                            # 00421c46
    add esp, 0xc                                 # 00421c4b
    mov ecx, dword ptr [ebp - local_38]          # 00421c4e
    add ecx, 0x1fd1                              # 00421c51
    push ecx                                     # 00421c57
    call FUN_0044a2b7                            # 00421c58
    add esp, 0x4                                 # 00421c5d
L_00421c60:
    # block 0x00421c60: entered by je at 0x00421c31, 1 instruction(s), ends with forward jump to 0x00421c64
    jmp.d8 L_00421c64                            # 00421c60
L_00421c62:
    # block 0x00421c62: entered by jne at 0x00421c0e, 1 instruction(s), ends with backward jump to 0x00421bed
    jmp.d8 L_00421bed                            # 00421c62
L_00421c64:
    # block 0x00421c64: entered by jge at 0x00421c00; jmp at 0x00421c60, 3 instruction(s), ends with jne to 0x00421c75 (forward)
    mov edx, dword ptr [ebp - local_38]          # 00421c64
    cmp dword ptr [edx + field_6b6], 0x5         # 00421c67
    jne.d8 L_00421c75                            # 00421c6e
    # block 0x00421c70: entered by fall-through of jne at 0x00421c6e, 1 instruction(s), ends with forward jump to 0x004221f9
    jmp.d32 L_004221f9                           # 00421c70
L_00421c75:
    # block 0x00421c75: entered by je at 0x00421af0; jle at 0x00421bdf; jne at 0x00421c6e, 5 instruction(s), ends with je to 0x00421fdd (forward)
    mov eax, dword ptr [ebp - local_38]          # 00421c75
    {load} xor ecx, ecx                          # 00421c78
    mov cl, byte ptr [eax + field_75a]           # 00421c7a
    cmp ecx, 0x3a                                # 00421c80
    je.d32 L_00421fdd                            # 00421c83
    # block 0x00421c89: entered by fall-through of je at 0x00421c83, 5 instruction(s), ends with je to 0x00421fdd (forward)
    mov edx, dword ptr [ebp - local_38]          # 00421c89
    {load} xor eax, eax                          # 00421c8c
    mov al, byte ptr [edx + field_75a]           # 00421c8e
    cmp eax, 0x3c                                # 00421c94
    je.d32 L_00421fdd                            # 00421c97
    # block 0x00421c9d: entered by fall-through of je at 0x00421c97, 5 instruction(s), ends with je to 0x00421fdd (forward)
    mov ecx, dword ptr [ebp - local_38]          # 00421c9d
    {load} xor edx, edx                          # 00421ca0
    mov dl, byte ptr [ecx + field_75a]           # 00421ca2
    cmp edx, 0x3f                                # 00421ca8
    je.d32 L_00421fdd                            # 00421cab
    # block 0x00421cb1: entered by fall-through of je at 0x00421cab, 14 instruction(s), calls FUN_0044c479, FUN_004f6ef4, ends with je to 0x00421cff (forward)
    mov eax, dword ptr [ebp - local_38]          # 00421cb1
    add eax, 0x698                               # 00421cb4
    push eax                                     # 00421cb9
    call FUN_0044c479                            # 00421cba
    add esp, 0x4                                 # 00421cbf
    push 0xc                                     # 00421cc2
    mov ecx, 0x5cf1eb                            # 00421cc4
    call FUN_004f6ef4                            # 00421cc9
    mov ecx, dword ptr [ebp - local_38]          # 00421cce
    mov word ptr [ecx + field_69c], ax           # 00421cd1
    mov edx, dword ptr [ebp - local_38]          # 00421cd8
    movsx eax, word ptr [edx + field_69c]        # 00421cdb
    cmp eax, -0x1                                # 00421ce2
    je.d8 L_00421cff                             # 00421ce5
    # block 0x00421ce7: entered by fall-through of je at 0x00421ce5, 6 instruction(s), ends with jle to 0x00421d13 (forward)
    mov ecx, dword ptr [ebp - local_38]          # 00421ce7
    movsx edx, word ptr [ecx + field_69c]        # 00421cea
    mov eax, dword ptr [ebp - local_38]          # 00421cf1
    movsx ecx, word ptr [eax + field_6a4]        # 00421cf4
    {load} cmp edx, ecx                          # 00421cfb
    jle.d8 L_00421d13                            # 00421cfd
L_00421cff:
    # block 0x00421cff: entered by je at 0x00421ce5; fall-through of jle at 0x00421cfd, 4 instruction(s), falls into the block at 0x00421d13
    mov edx, dword ptr [ebp - local_38]          # 00421cff
    mov eax, dword ptr [ebp - local_38]          # 00421d02
    mov cx, word ptr [eax + field_6a4]           # 00421d05
    mov word ptr [edx + field_69c], cx           # 00421d0c
L_00421d13:
    # block 0x00421d13: entered by jle at 0x00421cfd, 14 instruction(s), calls FUN_0044c4ab, FUN_0041e1e4, ends with je to 0x00421e33 (forward)
    mov edx, dword ptr [ebp - local_38]          # 00421d13
    add edx, 0x698                               # 00421d16
    push edx                                     # 00421d1c
    call FUN_0044c4ab                            # 00421d1d
    add esp, 0x4                                 # 00421d22
    mov eax, dword ptr [ebp - local_38]          # 00421d25
    mov cx, word ptr [eax + field_69c]           # 00421d28
    push ecx                                     # 00421d2f
    mov ecx, dword ptr [ebp - local_38]          # 00421d30
    call FUN_0041e1e4                            # 00421d33
    mov word ptr [ebp - local_10], ax            # 00421d38
    movsx edx, word ptr [ebp - local_10]         # 00421d3c
    cmp edx, -0x1                                # 00421d40
    je.d32 L_00421e33                            # 00421d43
    # block 0x00421d49: entered by fall-through of je at 0x00421d43, 6 instruction(s), ends with je to 0x00421e33 (forward)
    mov eax, dword ptr [ebp - local_38]          # 00421d49
    movsx ecx, word ptr [eax + field_77e]        # 00421d4c
    mov edx, dword ptr [ebp - local_38]          # 00421d53
    movsx eax, word ptr [edx + field_6a4]        # 00421d56
    {load} cmp ecx, eax                          # 00421d5d
    je.d32 L_00421e33                            # 00421d5f
    # block 0x00421d65: entered by fall-through of je at 0x00421d5f, 9 instruction(s), calls FUN_0044c479, ends with jle to 0x00421dfc (forward)
    mov ecx, dword ptr [ebp - local_38]          # 00421d65
    add ecx, 0x698                               # 00421d68
    push ecx                                     # 00421d6e
    call FUN_0044c479                            # 00421d6f
    add esp, 0x4                                 # 00421d74
    mov edx, dword ptr [ebp - local_38]          # 00421d77
    movsx eax, word ptr [edx + field_78c]        # 00421d7a
    test eax, eax                                # 00421d81
    jle.d8 L_00421dfc                            # 00421d83
    # block 0x00421d85: entered by fall-through of jle at 0x00421d83, 10 instruction(s), ends with jl to 0x00421dfc (forward)
    mov ecx, dword ptr [ebp - local_38]          # 00421d85
    mov dx, word ptr [ecx + field_78a]           # 00421d88
    add dx, 0x1                                  # 00421d8f
    mov eax, dword ptr [ebp - local_38]          # 00421d93
    mov word ptr [eax + field_78a], dx           # 00421d96
    mov ecx, dword ptr [ebp - local_38]          # 00421d9d
    movsx edx, word ptr [ecx + field_78a]        # 00421da0
    movsx eax, word ptr [0x5b028e]               # 00421da7
    {load} cmp edx, eax                          # 00421dae
    jl.d8 L_00421dfc                             # 00421db0
    # block 0x00421db2: entered by fall-through of jl at 0x00421db0, 9 instruction(s), ends with jge to 0x00421de4 (forward)
    mov ecx, dword ptr [ebp - local_38]          # 00421db2
    mov dx, word ptr [ecx + field_78c]           # 00421db5
    sub dx, 0x1                                  # 00421dbc
    mov eax, dword ptr [ebp - local_38]          # 00421dc0
    mov word ptr [eax + field_78c], dx           # 00421dc3
    mov ecx, dword ptr [ebp - local_38]          # 00421dca
    movsx edx, word ptr [ecx + field_78c]        # 00421dcd
    test edx, edx                                # 00421dd4
    jge.d8 L_00421de4                            # 00421dd6
    # block 0x00421dd8: entered by fall-through of jge at 0x00421dd6, 2 instruction(s), falls into the block at 0x00421de4
    mov eax, dword ptr [ebp - local_38]          # 00421dd8
    mov word ptr [eax + field_78c], 0x0          # 00421ddb
L_00421de4:
    # block 0x00421de4: entered by jge at 0x00421dd6, 4 instruction(s), falls into the block at 0x00421dfc
    mov ecx, dword ptr [ebp - local_38]          # 00421de4
    mov word ptr [ecx + field_78a], 0x0          # 00421de7
    mov edx, dword ptr [ebp - local_38]          # 00421df0
    mov word ptr [edx + field_788], 0x0          # 00421df3
L_00421dfc:
    # block 0x00421dfc: entered by jle at 0x00421d83; jl at 0x00421db0, 14 instruction(s), calls FUN_0044c4ab, FUN_00422970, ends with forward jump to 0x00421fca
    mov eax, dword ptr [ebp - local_38]          # 00421dfc
    add eax, 0x698                               # 00421dff
    push eax                                     # 00421e04
    call FUN_0044c4ab                            # 00421e05
    add esp, 0x4                                 # 00421e0a
    mov ecx, dword ptr [ebp - local_38]          # 00421e0d
    mov dx, word ptr [ebp - local_10]            # 00421e10
    mov word ptr [ecx + field_690], dx           # 00421e14
    mov eax, dword ptr [ebp - local_38]          # 00421e1b
    mov cx, word ptr [eax + field_75b]           # 00421e1e
    push ecx                                     # 00421e25
    mov ecx, dword ptr [ebp - local_38]          # 00421e26
    call FUN_00422970                            # 00421e29
    jmp.d32 L_00421fca                           # 00421e2e
L_00421e33:
    # block 0x00421e33: entered by je at 0x00421d43; je at 0x00421d5f, 3 instruction(s), ends with jne to 0x00421f8e (forward)
    movsx edx, word ptr [ebp - local_10]         # 00421e33
    cmp edx, -0x1                                # 00421e37
    jne.d32 L_00421f8e                           # 00421e3a
    # block 0x00421e40: entered by fall-through of jne at 0x00421e3a, 6 instruction(s), ends with je to 0x00421f8e (forward)
    mov eax, dword ptr [ebp - local_38]          # 00421e40
    movsx ecx, word ptr [eax + field_77e]        # 00421e43
    mov edx, dword ptr [ebp - local_38]          # 00421e4a
    movsx eax, word ptr [edx + field_6a4]        # 00421e4d
    {load} cmp ecx, eax                          # 00421e54
    je.d32 L_00421f8e                            # 00421e56
    # block 0x00421e5c: entered by fall-through of je at 0x00421e56, 3 instruction(s), ends with je to 0x00421ea5 (forward)
    movsx ecx, word ptr [0x63a4cd]               # 00421e5c
    test ecx, ecx                                # 00421e63
    je.d8 L_00421ea5                             # 00421e65
    # block 0x00421e67: entered by fall-through of je at 0x00421e65, 17 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00421ea5
    mov edx, dword ptr [ebp - local_38]          # 00421e67
    movsx eax, word ptr [edx + field_692]        # 00421e6a
    push eax                                     # 00421e71
    mov ecx, dword ptr [ebp - local_38]          # 00421e72
    movsx edx, word ptr [ecx + field_69c]        # 00421e75
    push edx                                     # 00421e7c
    push 0x543ff8                                # 00421e7d
    mov eax, dword ptr [ebp - local_38]          # 00421e82
    add eax, 0x1fd1                              # 00421e85
    push eax                                     # 00421e8a
    call FUN_0050ca3e                            # 00421e8b
    add esp, 0x10                                # 00421e90
    mov ecx, dword ptr [ebp - local_38]          # 00421e93
    add ecx, 0x1fd1                              # 00421e96
    push ecx                                     # 00421e9c
    call FUN_0044a2b7                            # 00421e9d
    add esp, 0x4                                 # 00421ea2
L_00421ea5:
    # block 0x00421ea5: entered by je at 0x00421e65, 15 instruction(s), calls FUN_0044c479, ends with jl to 0x00421f2f (forward)
    mov edx, dword ptr [ebp - local_38]          # 00421ea5
    add edx, 0x698                               # 00421ea8
    push edx                                     # 00421eae
    call FUN_0044c479                            # 00421eaf
    add esp, 0x4                                 # 00421eb4
    mov eax, dword ptr [ebp - local_38]          # 00421eb7
    mov cx, word ptr [eax + field_788]           # 00421eba
    add cx, 0x1                                  # 00421ec1
    mov edx, dword ptr [ebp - local_38]          # 00421ec5
    mov word ptr [edx + field_788], cx           # 00421ec8
    mov eax, dword ptr [ebp - local_38]          # 00421ecf
    movsx ecx, word ptr [eax + field_788]        # 00421ed2
    movsx edx, word ptr [0x5b028e]               # 00421ed9
    {load} cmp ecx, edx                          # 00421ee0
    jl.d8 L_00421f2f                             # 00421ee2
    # block 0x00421ee4: entered by fall-through of jl at 0x00421ee2, 9 instruction(s), ends with jle to 0x00421f17 (forward)
    mov eax, dword ptr [ebp - local_38]          # 00421ee4
    mov cx, word ptr [eax + field_78c]           # 00421ee7
    add cx, 0x1                                  # 00421eee
    mov edx, dword ptr [ebp - local_38]          # 00421ef2
    mov word ptr [edx + field_78c], cx           # 00421ef5
    mov eax, dword ptr [ebp - local_38]          # 00421efc
    movsx ecx, word ptr [eax + field_78c]        # 00421eff
    cmp ecx, 0x5                                 # 00421f06
    jle.d8 L_00421f17                            # 00421f09
    # block 0x00421f0b: entered by fall-through of jle at 0x00421f09, 2 instruction(s), falls into the block at 0x00421f17
    mov edx, dword ptr [ebp - local_38]          # 00421f0b
    mov word ptr [edx + field_78c], 0x5          # 00421f0e
L_00421f17:
    # block 0x00421f17: entered by jle at 0x00421f09, 4 instruction(s), falls into the block at 0x00421f2f
    mov eax, dword ptr [ebp - local_38]          # 00421f17
    mov word ptr [eax + field_78a], 0x0          # 00421f1a
    mov ecx, dword ptr [ebp - local_38]          # 00421f23
    mov word ptr [ecx + field_788], 0x0          # 00421f26
L_00421f2f:
    # block 0x00421f2f: entered by jl at 0x00421ee2, 13 instruction(s), ends with jle to 0x00421f7b (forward)
    mov edx, dword ptr [ebp - local_38]          # 00421f2f
    movsx eax, word ptr [edx + field_69c]        # 00421f32
    mov ecx, dword ptr [ebp - local_38]          # 00421f39
    movsx edx, word ptr [ecx + field_78c]        # 00421f3c
    {load} add eax, edx                          # 00421f43
    mov ecx, dword ptr [ebp - local_38]          # 00421f45
    mov word ptr [ecx + field_694], ax           # 00421f48
    mov edx, dword ptr [ebp - local_38]          # 00421f4f
    movsx eax, word ptr [edx + field_694]        # 00421f52
    mov ecx, dword ptr [ebp - local_38]          # 00421f59
    movsx edx, word ptr [ecx + field_6a4]        # 00421f5c
    {load} cmp eax, edx                          # 00421f63
    jle.d8 L_00421f7b                            # 00421f65
    # block 0x00421f67: entered by fall-through of jle at 0x00421f65, 4 instruction(s), falls into the block at 0x00421f7b
    mov eax, dword ptr [ebp - local_38]          # 00421f67
    mov ecx, dword ptr [ebp - local_38]          # 00421f6a
    mov dx, word ptr [ecx + field_6a4]           # 00421f6d
    mov word ptr [eax + field_694], dx           # 00421f74
L_00421f7b:
    # block 0x00421f7b: entered by jle at 0x00421f65, 6 instruction(s), calls FUN_0044c4ab, ends with forward jump to 0x00421fca
    mov eax, dword ptr [ebp - local_38]          # 00421f7b
    add eax, 0x698                               # 00421f7e
    push eax                                     # 00421f83
    call FUN_0044c4ab                            # 00421f84
    add esp, 0x4                                 # 00421f89
    jmp.d8 L_00421fca                            # 00421f8c
L_00421f8e:
    # block 0x00421f8e: entered by jne at 0x00421e3a; je at 0x00421e56, 6 instruction(s), ends with jle to 0x00421fca (forward)
    mov ecx, dword ptr [ebp - local_38]          # 00421f8e
    movsx edx, word ptr [ecx + field_692]        # 00421f91
    mov eax, dword ptr [ebp - local_38]          # 00421f98
    movsx ecx, word ptr [eax + field_69c]        # 00421f9b
    {load} cmp edx, ecx                          # 00421fa2
    jle.d8 L_00421fca                            # 00421fa4
    # block 0x00421fa6: entered by fall-through of jle at 0x00421fa4, 6 instruction(s), ends with jne to 0x00421fca (forward)
    mov edx, dword ptr [ebp - local_38]          # 00421fa6
    movsx eax, word ptr [edx + field_69c]        # 00421fa9
    mov ecx, dword ptr [ebp - local_38]          # 00421fb0
    movsx edx, word ptr [ecx + field_6a4]        # 00421fb3
    {load} cmp eax, edx                          # 00421fba
    jne.d8 L_00421fca                            # 00421fbc
    # block 0x00421fbe: entered by fall-through of jne at 0x00421fbc, 2 instruction(s), falls into the block at 0x00421fca
    mov eax, dword ptr [ebp - local_38]          # 00421fbe
    mov word ptr [eax + field_784], 0x1          # 00421fc1
L_00421fca:
    # block 0x00421fca: entered by jmp at 0x00421e2e; jmp at 0x00421f8c; jle at 0x00421fa4; jne at 0x00421fbc, 5 instruction(s), calls FUN_004229b5, falls into the block at 0x00421fdd
    mov ecx, dword ptr [ebp - local_38]          # 00421fca
    mov dx, word ptr [ecx + field_75b]           # 00421fcd
    push edx                                     # 00421fd4
    mov ecx, dword ptr [ebp - local_38]          # 00421fd5
    call FUN_004229b5                            # 00421fd8
L_00421fdd:
    # block 0x00421fdd: entered by je at 0x00421c83; je at 0x00421c97; je at 0x00421cab, 1 instruction(s), ends with forward jump to 0x004221f9
    jmp.d32 L_004221f9                           # 00421fdd
L_00421fe2:
    # block 0x00421fe2: entered by switch case, 13 instruction(s), calls FUN_004fba69, ends with je to 0x00422132 (forward)
    mov eax, dword ptr [ebp - local_38]          # 00421fe2
    mov ecx, dword ptr [eax + field_6aa]         # 00421fe5
    push ecx                                     # 00421feb
    mov ecx, 0x5c3a67                            # 00421fec
    call FUN_004fba69                            # 00421ff1
    mov edi, 0x544054                            # 00421ff6
    movsx esi, word ptr [0x570374]               # 00421ffb
    imul esi, esi, 0x29                          # 00422002
    add esi, 0x5b0a9a                            # 00422005
    mov ecx, 0x9                                 # 0042200b
    {load} xor edx, edx                          # 00422010
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00422012
    je.d32 L_00422132                            # 00422014
    # block 0x0042201a: entered by fall-through of je at 0x00422014, 10 instruction(s), ends with je to 0x00422132 (forward)
    movsx edi, word ptr [0x570374]               # 0042201a
    imul edi, edi, 0x29                          # 00422021
    add edi, 0x5b0a9a                            # 00422024
    or ecx, -0x1                                 # 0042202a
    {load} xor eax, eax                          # 0042202d
    repne scasb al, byte ptr es:[edi]            # 0042202f
    not ecx                                      # 00422031
    add ecx, -0x1                                # 00422033
    test ecx, ecx                                # 00422036
    je.d32 L_00422132                            # 00422038
    # block 0x0042203e: entered by fall-through of je at 0x00422038, 3 instruction(s), ends with je to 0x0042208a (forward)
    movsx eax, word ptr [0x63a4cd]               # 0042203e
    test eax, eax                                # 00422045
    je.d8 L_0042208a                             # 00422047
    # block 0x00422049: entered by fall-through of je at 0x00422047, 17 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x0042208a
    movsx ecx, word ptr [0x570374]               # 00422049
    imul ecx, ecx, 0x29                          # 00422050
    add ecx, 0x5b0a9a                            # 00422053
    push ecx                                     # 00422059
    movsx edx, word ptr [0x570374]               # 0042205a
    push edx                                     # 00422061
    push 0x544060                                # 00422062
    mov eax, dword ptr [ebp - local_38]          # 00422067
    add eax, 0x1fd1                              # 0042206a
    push eax                                     # 0042206f
    call FUN_0050ca3e                            # 00422070
    add esp, 0x10                                # 00422075
    mov ecx, dword ptr [ebp - local_38]          # 00422078
    add ecx, 0x1fd1                              # 0042207b
    push ecx                                     # 00422081
    call FUN_0044a2b7                            # 00422082
    add esp, 0x4                                 # 00422087
L_0042208a:
    # block 0x0042208a: entered by je at 0x00422047, 35 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with je to 0x00422130 (forward)
    movsx edx, word ptr [0x570374]               # 0042208a
    imul edx, edx, 0x29                          # 00422091
    add edx, 0x5b0a9a                            # 00422094
    {load} mov edi, edx                          # 0042209a
    mov eax, dword ptr [ebp - local_38]          # 0042209c
    mov ecx, dword ptr [eax + field_20d9]        # 0042209f
    add ecx, 0x747                               # 004220a5
    {load} mov edx, ecx                          # 004220ab
    or ecx, -0x1                                 # 004220ad
    {load} xor eax, eax                          # 004220b0
    repne scasb al, byte ptr es:[edi]            # 004220b2
    not ecx                                      # 004220b4
    {load} sub edi, ecx                          # 004220b6
    {load} mov esi, edi                          # 004220b8
    {load} mov eax, ecx                          # 004220ba
    {load} mov edi, edx                          # 004220bc
    shr ecx, 0x2                                 # 004220be
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004220c1
    {load} mov ecx, eax                          # 004220c3
    and ecx, 0x3                                 # 004220c5
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004220c8
    mov ecx, dword ptr [ebp - local_38]          # 004220ca
    mov edx, dword ptr [ecx + field_20d9]        # 004220cd
    add edx, 0x747                               # 004220d3
    push edx                                     # 004220d9
    mov ecx, 0x5c3a67                            # 004220da
    call FUN_004fb77a                            # 004220df
    push 0xd                                     # 004220e4
    mov ecx, 0x5c3a67                            # 004220e6
    call FUN_004fb2e3                            # 004220eb
    mov eax, dword ptr [ebp - local_38]          # 004220f0
    mov dword ptr [eax + field_6b6], 0x6         # 004220f3
    movsx ecx, word ptr [0x63a4cd]               # 004220fd
    test ecx, ecx                                # 00422104
    je.d8 L_00422130                             # 00422106
    # block 0x00422108: entered by fall-through of je at 0x00422106, 11 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00422130
    push 0x5440c0                                # 00422108
    mov edx, dword ptr [ebp - local_38]          # 0042210d
    add edx, 0x1fd1                              # 00422110
    push edx                                     # 00422116
    call FUN_0050ca3e                            # 00422117
    add esp, 0x8                                 # 0042211c
    mov eax, dword ptr [ebp - local_38]          # 0042211f
    add eax, 0x1fd1                              # 00422122
    push eax                                     # 00422127
    call FUN_0044a2b7                            # 00422128
    add esp, 0x4                                 # 0042212d
L_00422130:
    # block 0x00422130: entered by je at 0x00422106, 1 instruction(s), ends with forward jump to 0x00422180
    jmp.d8 L_00422180                            # 00422130
L_00422132:
    # block 0x00422132: entered by je at 0x00422014; je at 0x00422038, 7 instruction(s), ends with je to 0x00422180 (forward)
    mov ecx, dword ptr [ebp - local_38]          # 00422132
    movsx edx, word ptr [ecx + field_75b]        # 00422135
    imul edx, edx, 0x8d                          # 0042213c
    mov dword ptr [edx + 0x5bb632], 0x2          # 00422142
    movsx eax, word ptr [0x63a4cd]               # 0042214c
    test eax, eax                                # 00422153
    je.d8 L_00422180                             # 00422155
    # block 0x00422157: entered by fall-through of je at 0x00422155, 11 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00422180
    push 0x54411c                                # 00422157
    mov ecx, dword ptr [ebp - local_38]          # 0042215c
    add ecx, 0x1fd1                              # 0042215f
    push ecx                                     # 00422165
    call FUN_0050ca3e                            # 00422166
    add esp, 0x8                                 # 0042216b
    mov edx, dword ptr [ebp - local_38]          # 0042216e
    add edx, 0x1fd1                              # 00422171
    push edx                                     # 00422177
    call FUN_0044a2b7                            # 00422178
    add esp, 0x4                                 # 0042217d
L_00422180:
    # block 0x00422180: entered by jmp at 0x00422130; je at 0x00422155, 1 instruction(s), ends with forward jump to 0x004221f9
    jmp.d8 L_004221f9                            # 00422180
L_00422182:
    # block 0x00422182: entered by switch case, 5 instruction(s), calls FUN_004f6334, ends with jne to 0x004221f9 (forward)
    push 0xd                                     # 00422182
    mov ecx, 0x5cf1eb                            # 00422184
    call FUN_004f6334                            # 00422189
    test eax, eax                                # 0042218e
    jne.d8 L_004221f9                            # 00422190
    # block 0x00422192: entered by fall-through of jne at 0x00422190, 13 instruction(s), calls FUN_004fba69, ends with je to 0x004221f9 (forward)
    mov eax, dword ptr [ebp - local_38]          # 00422192
    mov ecx, dword ptr [eax + field_20d9]        # 00422195
    add ecx, 0x747                               # 0042219b
    push ecx                                     # 004221a1
    mov ecx, 0x5c3a67                            # 004221a2
    call FUN_004fba69                            # 004221a7
    mov edx, dword ptr [ebp - local_38]          # 004221ac
    movsx eax, word ptr [edx + field_75b]        # 004221af
    imul eax, eax, 0x8d                          # 004221b6
    mov dword ptr [eax + 0x5bb632], 0x2          # 004221bc
    movsx ecx, word ptr [0x63a4cd]               # 004221c6
    test ecx, ecx                                # 004221cd
    je.d8 L_004221f9                             # 004221cf
    # block 0x004221d1: entered by fall-through of je at 0x004221cf, 11 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004221f9
    push 0x544174                                # 004221d1
    mov edx, dword ptr [ebp - local_38]          # 004221d6
    add edx, 0x1fd1                              # 004221d9
    push edx                                     # 004221df
    call FUN_0050ca3e                            # 004221e0
    add esp, 0x8                                 # 004221e5
    mov eax, dword ptr [ebp - local_38]          # 004221e8
    add eax, 0x1fd1                              # 004221eb
    push eax                                     # 004221f0
    call FUN_0044a2b7                            # 004221f1
    add esp, 0x4                                 # 004221f6
L_004221f9:
    # block 0x004221f9: entered by ja at 0x00421911; jmp at 0x00421975; jmp at 0x00421a4f; jmp at 0x00421b59; more, 1 instruction(s), ends with forward jump to 0x0042290e
    jmp.d32 L_0042290e                           # 004221f9
L_004221fe:
    # block 0x004221fe: entered by je at 0x00420c5e, 3 instruction(s), ends with je to 0x00422231 (forward)
    movsx ecx, word ptr [0x63a4cd]               # 004221fe
    test ecx, ecx                                # 00422205
    je.d8 L_00422231                             # 00422207
    # block 0x00422209: entered by fall-through of je at 0x00422207, 11 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00422231
    push 0x5441d8                                # 00422209
    mov edx, dword ptr [ebp - local_38]          # 0042220e
    add edx, 0x1fd1                              # 00422211
    push edx                                     # 00422217
    call FUN_0050ca3e                            # 00422218
    add esp, 0x8                                 # 0042221d
    mov eax, dword ptr [ebp - local_38]          # 00422220
    add eax, 0x1fd1                              # 00422223
    push eax                                     # 00422228
    call FUN_0044a2b7                            # 00422229
    add esp, 0x4                                 # 0042222e
L_00422231:
    # block 0x00422231: entered by je at 0x00422207, 3 instruction(s), ends with je to 0x004222ca (forward)
    mov ecx, dword ptr [ebp - local_38]          # 00422231
    cmp dword ptr [ecx + field_6b2], 0x0         # 00422234
    je.d32 L_004222ca                            # 0042223b
    # block 0x00422241: entered by fall-through of je at 0x0042223b, 17 instruction(s), calls FUN_0044c479, FUN_00449a94, ends with je to 0x00422297 (forward)
    mov edx, dword ptr [ebp - local_38]          # 00422241
    add edx, 0x698                               # 00422244
    push edx                                     # 0042224a
    call FUN_0044c479                            # 0042224b
    add esp, 0x4                                 # 00422250
    mov eax, dword ptr [ebp - local_38]          # 00422253
    mov dword ptr [eax + field_698], 0x2         # 00422256
    mov ecx, dword ptr [ebp - local_38]          # 00422260
    mov ecx, dword ptr [ecx + field_6b2]         # 00422263
    call FUN_00449a94                            # 00422269
    mov edx, dword ptr [ebp - local_38]          # 0042226e
    mov eax, dword ptr [edx + field_6b2]         # 00422271
    mov dword ptr [ebp - local_30], eax          # 00422277
    mov ecx, dword ptr [ebp - local_30]          # 0042227a
    mov dword ptr [ebp - local_2c], ecx          # 0042227d
    cmp dword ptr [ebp - local_2c], 0x0          # 00422280
    je.d8 L_00422297                             # 00422284
    # block 0x00422286: entered by fall-through of je at 0x00422284, 7 instruction(s), calls indirect dword ptr [eax], ends with forward jump to 0x0042229e
    push 0x1                                     # 00422286
    mov edx, dword ptr [ebp - local_2c]          # 00422288
    mov eax, dword ptr [edx]                     # 0042228b
    mov ecx, dword ptr [ebp - local_2c]          # 0042228d
    call dword ptr [eax]                         # 00422290
    mov dword ptr [ebp - local_64], eax          # 00422292
    jmp.d8 L_0042229e                            # 00422295
L_00422297:
    # block 0x00422297: entered by je at 0x00422284, 1 instruction(s), falls into the block at 0x0042229e
    mov dword ptr [ebp - local_64], 0x0          # 00422297
L_0042229e:
    # block 0x0042229e: entered by jmp at 0x00422295, 9 instruction(s), calls FUN_0044c4ab, falls into the block at 0x004222ca
    mov ecx, dword ptr [ebp - local_38]          # 0042229e
    mov dword ptr [ecx + field_6b2], 0x0         # 004222a1
    mov edx, dword ptr [ebp - local_38]          # 004222ab
    add edx, 0x698                               # 004222ae
    push edx                                     # 004222b4
    call FUN_0044c4ab                            # 004222b5
    add esp, 0x4                                 # 004222ba
    mov eax, dword ptr [ebp - local_38]          # 004222bd
    mov dword ptr [eax + field_698], 0x0         # 004222c0
L_004222ca:
    # block 0x004222ca: entered by je at 0x0042223b, 3 instruction(s), ends with je to 0x004222fd (forward)
    movsx ecx, word ptr [0x63a4cd]               # 004222ca
    test ecx, ecx                                # 004222d1
    je.d8 L_004222fd                             # 004222d3
    # block 0x004222d5: entered by fall-through of je at 0x004222d3, 11 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004222fd
    push 0x544240                                # 004222d5
    mov edx, dword ptr [ebp - local_38]          # 004222da
    add edx, 0x1fd1                              # 004222dd
    push edx                                     # 004222e3
    call FUN_0050ca3e                            # 004222e4
    add esp, 0x8                                 # 004222e9
    mov eax, dword ptr [ebp - local_38]          # 004222ec
    add eax, 0x1fd1                              # 004222ef
    push eax                                     # 004222f4
    call FUN_0044a2b7                            # 004222f5
    add esp, 0x4                                 # 004222fa
L_004222fd:
    # block 0x004222fd: entered by je at 0x004222d3, 6 instruction(s), calls FUN_0041de29, ends with je to 0x00422335 (forward)
    mov ecx, dword ptr [ebp - local_38]          # 004222fd
    call FUN_0041de29                            # 00422300
    mov ecx, dword ptr [ebp - local_38]          # 00422305
    movsx edx, word ptr [ecx + field_f73]        # 00422308
    cmp edx, -0x1                                # 0042230f
    je.d8 L_00422335                             # 00422312
    # block 0x00422314: entered by fall-through of je at 0x00422312, 7 instruction(s), calls FUN_004c946b, falls into the block at 0x00422335
    mov eax, dword ptr [ebp - local_38]          # 00422314
    mov cx, word ptr [eax + field_f73]           # 00422317
    push ecx                                     # 0042231e
    mov ecx, 0x5cf659                            # 0042231f
    call FUN_004c946b                            # 00422324
    mov edx, dword ptr [ebp - local_38]          # 00422329
    mov word ptr [edx + field_f73], 0xffff       # 0042232c
L_00422335:
    # block 0x00422335: entered by je at 0x00422312, 4 instruction(s), ends with je to 0x00422365 (forward)
    mov eax, dword ptr [ebp - local_38]          # 00422335
    movsx ecx, word ptr [eax + field_f75]        # 00422338
    cmp ecx, -0x1                                # 0042233f
    je.d8 L_00422365                             # 00422342
    # block 0x00422344: entered by fall-through of je at 0x00422342, 7 instruction(s), calls FUN_004c946b, falls into the block at 0x00422365
    mov edx, dword ptr [ebp - local_38]          # 00422344
    mov ax, word ptr [edx + field_f75]           # 00422347
    push eax                                     # 0042234e
    mov ecx, 0x5cf659                            # 0042234f
    call FUN_004c946b                            # 00422354
    mov ecx, dword ptr [ebp - local_38]          # 00422359
    mov word ptr [ecx + field_f75], 0xffff       # 0042235c
L_00422365:
    # block 0x00422365: entered by je at 0x00422342, 4 instruction(s), ends with je to 0x004223a0 (forward)
    mov dword ptr [0x5b15da], 0x0                # 00422365
    mov edx, dword ptr [ebp - local_38]          # 0042236f
    cmp dword ptr [edx + field_fa5], 0x0         # 00422372
    je.d8 L_004223a0                             # 00422379
    # block 0x0042237b: entered by fall-through of je at 0x00422379, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004223a0
    mov eax, dword ptr [ebp - local_38]          # 0042237b
    mov ecx, dword ptr [eax + field_fa5]         # 0042237e
    mov dword ptr [ebp - local_34], ecx          # 00422384
    mov edx, dword ptr [ebp - local_34]          # 00422387
    push edx                                     # 0042238a
    call FUN_0051dc6c                            # 0042238b
    add esp, 0x4                                 # 00422390
    mov eax, dword ptr [ebp - local_38]          # 00422393
    mov dword ptr [eax + field_fa5], 0x0         # 00422396
L_004223a0:
    # block 0x004223a0: entered by je at 0x00422379, 17 instruction(s), calls FUN_004209e8, ends with je to 0x0042243a (forward)
    mov ecx, 0xa                                 # 004223a0
    {load} xor eax, eax                          # 004223a5
    mov edi, dword ptr [ebp - local_38]          # 004223a7
    add edi, 0xf77                               # 004223aa
    rep stosd dword ptr es:[edi], eax            # 004223b0
    stosw word ptr es:[edi], ax                  # 004223b2
    mov ecx, dword ptr [ebp - local_38]          # 004223b4
    mov dword ptr [ecx + field_fa9], 0x0         # 004223b7
    mov edx, dword ptr [ebp - local_38]          # 004223c1
    mov ax, word ptr [edx + field_75b]           # 004223c4
    push eax                                     # 004223cb
    mov ecx, dword ptr [ebp - local_38]          # 004223cc
    call FUN_004209e8                            # 004223cf
    mov ecx, dword ptr [ebp - local_38]          # 004223d4
    movsx edx, word ptr [ecx + field_f21]        # 004223d7
    test edx, edx                                # 004223de
    je.d8 L_0042243a                             # 004223e0
    # block 0x004223e2: entered by fall-through of je at 0x004223e0, 3 instruction(s), ends with je to 0x0042243a (forward)
    movsx eax, word ptr [0x570374]               # 004223e2
    cmp eax, 0x1f                                # 004223e9
    je.d8 L_0042243a                             # 004223ec
    # block 0x004223ee: entered by fall-through of je at 0x004223ec, 6 instruction(s), ends with je to 0x0042243a (forward)
    movsx ecx, word ptr [0x570374]               # 004223ee
    imul ecx, ecx, 0x3a                          # 004223f5
    mov edx, dword ptr [ebp - local_38]          # 004223f8
    movsx eax, word ptr [edx + ecx + field_80e]  # 004223fb
    cmp eax, -0x1                                # 00422403
    je.d8 L_0042243a                             # 00422406
    # block 0x00422408: entered by fall-through of je at 0x00422406, 10 instruction(s), falls into the block at 0x0042243a
    movsx ecx, word ptr [0x570374]               # 00422408
    imul ecx, ecx, 0x3a                          # 0042240f
    mov edx, dword ptr [ebp - local_38]          # 00422412
    {load} xor eax, eax                          # 00422415
    mov al, byte ptr [edx + ecx + field_810]     # 00422417
    movsx ecx, word ptr [0x570374]               # 0042241e
    imul ecx, ecx, 0x3a                          # 00422425
    mov edx, dword ptr [ebp - local_38]          # 00422428
    movsx ecx, word ptr [edx + ecx + field_80e]  # 0042242b
    mov dword ptr [4*ecx + 0x585801], eax        # 00422433
L_0042243a:
    # block 0x0042243a: entered by je at 0x004223e0; je at 0x004223ec; je at 0x00422406, 4 instruction(s), ends with je to 0x00422450 (forward)
    {load} xor edx, edx                          # 0042243a
    mov dl, byte ptr [0x58322b]                  # 0042243c
    test edx, edx                                # 00422442
    je.d8 L_00422450                             # 00422444
    # block 0x00422446: entered by fall-through of je at 0x00422444, 2 instruction(s), calls FUN_0042e493, ends with forward jump to 0x004227dc
    call FUN_0042e493                            # 00422446
    jmp.d32 L_004227dc                           # 0042244b
L_00422450:
    # block 0x00422450: entered by je at 0x00422444, 4 instruction(s), ends with je to 0x0042255f (forward)
    mov eax, dword ptr [ebp - local_38]          # 00422450
    movsx ecx, word ptr [eax + field_f21]        # 00422453
    test ecx, ecx                                # 0042245a
    je.d32 L_0042255f                            # 0042245c
    # block 0x00422462: entered by fall-through of je at 0x0042245c, 3 instruction(s), ends with je to 0x0042255f (forward)
    movsx edx, word ptr [0x570374]               # 00422462
    cmp edx, 0x1f                                # 00422469
    je.d32 L_0042255f                            # 0042246c
    # block 0x00422472: entered by fall-through of je at 0x0042246c, 6 instruction(s), ends with je to 0x0042255f (forward)
    movsx eax, word ptr [0x570374]               # 00422472
    imul eax, eax, 0x3a                          # 00422479
    mov ecx, dword ptr [ebp - local_38]          # 0042247c
    movsx edx, word ptr [ecx + eax + field_7fa]  # 0042247f
    cmp edx, 0x270f                              # 00422487
    je.d32 L_0042255f                            # 0042248d
    # block 0x00422493: entered by fall-through of je at 0x0042248d, 37 instruction(s), ends with forward jump to 0x004227dc
    movsx eax, word ptr [0x570374]               # 00422493
    imul eax, eax, 0x3a                          # 0042249a
    mov ecx, dword ptr [ebp - local_38]          # 0042249d
    movsx edx, word ptr [ecx + eax + field_7fa]  # 004224a0
    mov dword ptr [0x5bb57b], edx                # 004224a8
    movsx eax, word ptr [0x570374]               # 004224ae
    imul eax, eax, 0x3a                          # 004224b5
    mov ecx, dword ptr [ebp - local_38]          # 004224b8
    mov dx, word ptr [ecx + eax + field_7fc]     # 004224bb
    mov word ptr [0x5bb599], dx                  # 004224c3
    movsx eax, word ptr [0x570374]               # 004224ca
    imul eax, eax, 0x3a                          # 004224d1
    mov ecx, dword ptr [ebp - local_38]          # 004224d4
    mov dx, word ptr [ecx + eax + field_7fe]     # 004224d7
    mov word ptr [0x5bb595], dx                  # 004224df
    movsx eax, word ptr [0x570374]               # 004224e6
    imul eax, eax, 0x3a                          # 004224ed
    mov ecx, dword ptr [ebp - local_38]          # 004224f0
    mov dx, word ptr [ecx + eax + field_800]     # 004224f3
    mov word ptr [0x5c39ff], dx                  # 004224fb
    movsx eax, word ptr [0x570374]               # 00422502
    imul eax, eax, 0x3a                          # 00422509
    mov ecx, dword ptr [ebp - local_38]          # 0042250c
    mov edx, dword ptr [ecx + eax + field_802]   # 0042250f
    mov dword ptr [0x5bb59b], edx                # 00422516
    movsx eax, word ptr [0x570374]               # 0042251c
    imul eax, eax, 0x3a                          # 00422523
    mov ecx, dword ptr [ebp - local_38]          # 00422526
    mov edx, dword ptr [ecx + eax + field_806]   # 00422529
    mov dword ptr [0x5bb59f], edx                # 00422530
    movsx eax, word ptr [0x570374]               # 00422536
    imul eax, eax, 0x3a                          # 0042253d
    mov ecx, dword ptr [ebp - local_38]          # 00422540
    mov edx, dword ptr [ecx + eax + field_80a]   # 00422543
    mov dword ptr [0x5bb5a3], edx                # 0042254a
    mov dword ptr [0x583999], 0x4                # 00422550
    jmp.d32 L_004227dc                           # 0042255a
L_0042255f:
    # block 0x0042255f: entered by je at 0x0042245c; je at 0x0042246c; je at 0x0042248d, 3 instruction(s), ends with forward jump to 0x00422579
    mov word ptr [ebp - local_18], 0x0           # 0042255f
    mov word ptr [ebp - local_14], 0x0           # 00422565
    jmp.d8 L_00422579                            # 0042256b
L_0042256d:
    # block 0x0042256d: entered by jmp at 0x004226de, 3 instruction(s), falls into the block at 0x00422579
    mov ax, word ptr [ebp - local_14]            # 0042256d
    .insn 0x66, 0x05, 0x0001{:u16}               # 00422571
    mov word ptr [ebp - local_14], ax            # 00422575
L_00422579:
    # block 0x00422579: entered by jmp at 0x0042256b, 6 instruction(s), ends with jge to 0x004226e3 (forward)
    movsx ecx, word ptr [ebp - local_14]         # 00422579
    mov edx, dword ptr [ebp - local_38]          # 0042257d
    mov eax, dword ptr [edx + field_20d5]        # 00422580
    movsx edx, word ptr [eax + field_799]        # 00422586
    {load} cmp ecx, edx                          # 0042258d
    jge.d32 L_004226e3                           # 0042258f
    # block 0x00422595: entered by fall-through of jge at 0x0042258f, 22 instruction(s), calls FUN_00420737, ends with je to 0x004226de (forward)
    mov eax, dword ptr [ebp - local_38]          # 00422595
    add eax, 0x7a7                               # 00422598
    push eax                                     # 0042259d
    mov ecx, dword ptr [ebp - local_38]          # 0042259e
    mov edx, dword ptr [ecx + field_20d5]        # 004225a1
    movsx eax, word ptr [ebp - local_14]         # 004225a7
    imul eax, eax, 0x1c                          # 004225ab
    mov ecx, dword ptr [edx + field_79b]         # 004225ae
    mov dx, word ptr [ecx + eax]                 # 004225b4
    push edx                                     # 004225b8
    mov eax, dword ptr [ebp - local_38]          # 004225b9
    mov ecx, dword ptr [eax + field_20d5]        # 004225bc
    movsx edx, word ptr [ebp - local_14]         # 004225c2
    imul edx, edx, 0x1c                          # 004225c6
    mov eax, dword ptr [ecx + field_79b]         # 004225c9
    mov ecx, dword ptr [eax + edx + field_2]     # 004225cf
    push ecx                                     # 004225d3
    mov ecx, dword ptr [ebp - local_38]          # 004225d4
    call FUN_00420737                            # 004225d7
    movsx edx, ax                                # 004225dc
    test edx, edx                                # 004225df
    je.d32 L_004226de                            # 004225e1
    # block 0x004225e7: entered by fall-through of je at 0x004225e1, 52 instruction(s), ends with forward jump to 0x004226e3
    mov eax, dword ptr [ebp - local_38]          # 004225e7
    mov ecx, dword ptr [eax + field_20d5]        # 004225ea
    movsx edx, word ptr [ebp - local_14]         # 004225f0
    imul edx, edx, 0x1c                          # 004225f4
    mov eax, dword ptr [ecx + field_79b]         # 004225f7
    movsx ecx, word ptr [eax + edx + field_6]    # 004225fd
    mov dword ptr [0x5bb57b], ecx                # 00422602
    mov edx, dword ptr [ebp - local_38]          # 00422608
    mov eax, dword ptr [edx + field_20d5]        # 0042260b
    movsx ecx, word ptr [ebp - local_14]         # 00422611
    imul ecx, ecx, 0x1c                          # 00422615
    mov edx, dword ptr [eax + field_79b]         # 00422618
    mov ax, word ptr [edx + ecx + field_8]       # 0042261e
    mov word ptr [0x5bb599], ax                  # 00422623
    mov ecx, dword ptr [ebp - local_38]          # 00422629
    mov edx, dword ptr [ecx + field_20d5]        # 0042262c
    movsx eax, word ptr [ebp - local_14]         # 00422632
    imul eax, eax, 0x1c                          # 00422636
    mov ecx, dword ptr [edx + field_79b]         # 00422639
    mov dx, word ptr [ecx + eax + field_a]       # 0042263f
    mov word ptr [0x5bb595], dx                  # 00422644
    mov eax, dword ptr [ebp - local_38]          # 0042264b
    mov ecx, dword ptr [eax + field_20d5]        # 0042264e
    movsx edx, word ptr [ebp - local_14]         # 00422654
    imul edx, edx, 0x1c                          # 00422658
    mov eax, dword ptr [ecx + field_79b]         # 0042265b
    mov cx, word ptr [eax + edx + field_c]       # 00422661
    mov word ptr [0x5c39ff], cx                  # 00422666
    mov edx, dword ptr [ebp - local_38]          # 0042266d
    mov eax, dword ptr [edx + field_20d5]        # 00422670
    movsx ecx, word ptr [ebp - local_14]         # 00422676
    imul ecx, ecx, 0x1c                          # 0042267a
    mov edx, dword ptr [eax + field_79b]         # 0042267d
    mov eax, dword ptr [edx + ecx + field_e]     # 00422683
    mov dword ptr [0x5bb59b], eax                # 00422687
    mov ecx, dword ptr [ebp - local_38]          # 0042268c
    mov edx, dword ptr [ecx + field_20d5]        # 0042268f
    movsx eax, word ptr [ebp - local_14]         # 00422695
    imul eax, eax, 0x1c                          # 00422699
    mov ecx, dword ptr [edx + field_79b]         # 0042269c
    mov edx, dword ptr [ecx + eax + field_12]    # 004226a2
    mov dword ptr [0x5bb59f], edx                # 004226a6
    mov eax, dword ptr [ebp - local_38]          # 004226ac
    mov ecx, dword ptr [eax + field_20d5]        # 004226af
    movsx edx, word ptr [ebp - local_14]         # 004226b5
    imul edx, edx, 0x1c                          # 004226b9
    mov eax, dword ptr [ecx + field_79b]         # 004226bc
    mov ecx, dword ptr [eax + edx + field_16]    # 004226c2
    mov dword ptr [0x5bb5a3], ecx                # 004226c6
    mov dword ptr [0x583999], 0x4                # 004226cc
    mov word ptr [ebp - local_18], 0x1           # 004226d6
    jmp.d8 L_004226e3                            # 004226dc
L_004226de:
    # block 0x004226de: entered by je at 0x004225e1, 1 instruction(s), ends with backward jump to 0x0042256d
    jmp.d32 L_0042256d                           # 004226de
L_004226e3:
    # block 0x004226e3: entered by jge at 0x0042258f; jmp at 0x004226dc, 3 instruction(s), ends with jne to 0x004227b3 (forward)
    movsx edx, word ptr [ebp - local_18]         # 004226e3
    test edx, edx                                # 004226e7
    jne.d32 L_004227b3                           # 004226e9
    # block 0x004226ef: entered by fall-through of jne at 0x004226e9, 6 instruction(s), ends with jne to 0x004227b3 (forward)
    mov eax, dword ptr [ebp - local_38]          # 004226ef
    mov ecx, dword ptr [eax + field_20d9]        # 004226f2
    {load} xor edx, edx                          # 004226f8
    mov dl, byte ptr [ecx + field_77b]           # 004226fa
    cmp edx, 0x1                                 # 00422700
    jne.d32 L_004227b3                           # 00422703
    # block 0x00422709: entered by fall-through of jne at 0x00422703, 30 instruction(s), falls into the block at 0x004227b3
    mov eax, dword ptr [ebp - local_38]          # 00422709
    mov ecx, dword ptr [eax + field_20d9]        # 0042270c
    movsx edx, word ptr [ecx + field_77d]        # 00422712
    mov dword ptr [0x5bb57b], edx                # 00422719
    mov eax, dword ptr [ebp - local_38]          # 0042271f
    mov ecx, dword ptr [eax + field_20d9]        # 00422722
    mov dx, word ptr [ecx + field_77f]           # 00422728
    mov word ptr [0x5bb599], dx                  # 0042272f
    mov eax, dword ptr [ebp - local_38]          # 00422736
    mov ecx, dword ptr [eax + field_20d9]        # 00422739
    mov dx, word ptr [ecx + field_781]           # 0042273f
    mov word ptr [0x5bb595], dx                  # 00422746
    mov eax, dword ptr [ebp - local_38]          # 0042274d
    mov ecx, dword ptr [eax + field_20d9]        # 00422750
    mov dx, word ptr [ecx + field_783]           # 00422756
    mov word ptr [0x5c39ff], dx                  # 0042275d
    mov eax, dword ptr [ebp - local_38]          # 00422764
    mov ecx, dword ptr [eax + field_20d9]        # 00422767
    mov edx, dword ptr [ecx + field_785]         # 0042276d
    mov dword ptr [0x5bb59b], edx                # 00422773
    mov eax, dword ptr [ebp - local_38]          # 00422779
    mov ecx, dword ptr [eax + field_20d9]        # 0042277c
    mov edx, dword ptr [ecx + field_789]         # 00422782
    mov dword ptr [0x5bb59f], edx                # 00422788
    mov eax, dword ptr [ebp - local_38]          # 0042278e
    mov ecx, dword ptr [eax + field_20d9]        # 00422791
    mov edx, dword ptr [ecx + field_78d]         # 00422797
    mov dword ptr [0x5bb5a3], edx                # 0042279d
    mov dword ptr [0x583999], 0x4                # 004227a3
    mov word ptr [ebp - local_18], 0x1           # 004227ad
L_004227b3:
    # block 0x004227b3: entered by jne at 0x004226e9; jne at 0x00422703, 3 instruction(s), ends with jne to 0x004227dc (forward)
    movsx eax, word ptr [ebp - local_18]         # 004227b3
    test eax, eax                                # 004227b7
    jne.d8 L_004227dc                            # 004227b9
    # block 0x004227bb: entered by fall-through of jne at 0x004227b9, 6 instruction(s), ends with jne to 0x004227dc (forward)
    mov ecx, dword ptr [ebp - local_38]          # 004227bb
    mov edx, dword ptr [ecx + field_20d9]        # 004227be
    {load} xor eax, eax                          # 004227c4
    mov al, byte ptr [edx + field_77c]           # 004227c6
    cmp eax, 0x1                                 # 004227cc
    jne.d8 L_004227dc                            # 004227cf
    # block 0x004227d1: entered by fall-through of jne at 0x004227cf, 2 instruction(s), calls FUN_0042e493, falls into the block at 0x004227dc
    call FUN_0042e493                            # 004227d1
    mov word ptr [ebp - local_18], 0x1           # 004227d6
L_004227dc:
    # block 0x004227dc: entered by jmp at 0x0042244b; jmp at 0x0042255a; jne at 0x004227b9; jne at 0x004227cf, 3 instruction(s), ends with je to 0x0042280f (forward)
    movsx ecx, word ptr [0x63a4cd]               # 004227dc
    test ecx, ecx                                # 004227e3
    je.d8 L_0042280f                             # 004227e5
    # block 0x004227e7: entered by fall-through of je at 0x004227e5, 11 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x0042280f
    push 0x544298                                # 004227e7
    mov edx, dword ptr [ebp - local_38]          # 004227ec
    add edx, 0x1fd1                              # 004227ef
    push edx                                     # 004227f5
    call FUN_0050ca3e                            # 004227f6
    add esp, 0x8                                 # 004227fb
    mov eax, dword ptr [ebp - local_38]          # 004227fe
    add eax, 0x1fd1                              # 00422801
    push eax                                     # 00422806
    call FUN_0044a2b7                            # 00422807
    add esp, 0x4                                 # 0042280c
L_0042280f:
    # block 0x0042280f: entered by je at 0x004227e5, 34 instruction(s), calls FUN_004ee673, FUN_004e7757, FUN_004d36ed, FUN_0043dbd5, FUN_0041db40, ends with je to 0x00422902 (forward)
    movsx ecx, word ptr [0x5b0a76]               # 0042280f
    mov edx, dword ptr [0x5b0a1e]                # 00422816
    sub edx, dword ptr [0x5b0a16]                # 0042281c
    add edx, 0x1                                 # 00422822
    {load} sub ecx, edx                          # 00422825
    mov word ptr [0x5b0a7c], cx                  # 00422827
    push 0x0                                     # 0042282e
    mov ecx, 0x582711                            # 00422830
    call FUN_004ee673                            # 00422835
    mov dword ptr [0x583204], 0x0                # 0042283a
    mov ecx, 0x582711                            # 00422844
    call FUN_004e7757                            # 00422849
    mov dword ptr [0x5b15d6], 0x0                # 0042284e
    call FUN_004d36ed                            # 00422858
    mov dword ptr [0x5bb1ca], 0x0                # 0042285d
    mov dword ptr [0x5c39e9], 0x0                # 00422867
    mov dword ptr [0x5c39ed], 0x0                # 00422871
    call FUN_0043dbd5                            # 0042287b
    mov eax, dword ptr [ebp - local_38]          # 00422880
    mov cx, word ptr [eax + field_75b]           # 00422883
    push ecx                                     # 0042288a
    mov ecx, dword ptr [ebp - local_38]          # 0042288b
    call FUN_0041db40                            # 0042288e
    mov edx, dword ptr [ebp - local_38]          # 00422893
    movsx eax, word ptr [edx + field_75b]        # 00422896
    imul eax, eax, 0x8d                          # 0042289d
    mov dword ptr [eax + 0x5bb632], 0x0          # 004228a3
    mov ecx, dword ptr [ebp - local_38]          # 004228ad
    movsx edx, word ptr [ecx + field_75b]        # 004228b0
    imul edx, edx, 0x8d                          # 004228b7
    mov byte ptr [edx + 0x5bb625], 0x1           # 004228bd
    movsx eax, word ptr [0x63a4cd]               # 004228c4
    test eax, eax                                # 004228cb
    je.d8 L_00422902                             # 004228cd
    # block 0x004228cf: entered by fall-through of je at 0x004228cd, 14 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00422902
    mov ecx, dword ptr [ebp - local_38]          # 004228cf
    movsx edx, word ptr [ecx + field_75b]        # 004228d2
    push edx                                     # 004228d9
    push 0x5442f8                                # 004228da
    mov eax, dword ptr [ebp - local_38]          # 004228df
    add eax, 0x1fd1                              # 004228e2
    push eax                                     # 004228e7
    call FUN_0050ca3e                            # 004228e8
    add esp, 0xc                                 # 004228ed
    mov ecx, dword ptr [ebp - local_38]          # 004228f0
    add ecx, 0x1fd1                              # 004228f3
    push ecx                                     # 004228f9
    call FUN_0044a2b7                            # 004228fa
    add esp, 0x4                                 # 004228ff
L_00422902:
    # block 0x00422902: entered by je at 0x004228cd, 2 instruction(s), falls into the block at 0x0042290e
    mov edx, dword ptr [ebp - local_38]          # 00422902
    mov word ptr [edx + field_75b], 0xffff       # 00422905
L_0042290e:
    # block 0x0042290e: entered by jmp at 0x00420c64; jmp at 0x00420c7b; jmp at 0x00420d34; jmp at 0x004218ce; more, 7 instruction(s), ends with ret 0x4
    mov ecx, dword ptr [ebp - local_c]           # 0042290e
    mov dword ptr fs:[0x0], ecx                  # 00422911
    pop edi                                      # 00422918
    pop esi                                      # 00422919
    {load} mov esp, ebp                          # 0042291a
    pop ebp                                      # 0042291c
    ret 0x4                                      # 0042291d

# --- data items (not part of the function) -------------------------
.org 0x00422920 - 0x401000
SWTAB_00422920:  # 7 case address(es)
    .long L_00420d05 - .text + 0x401000
    .long L_00420d19 - .text + 0x401000
    .long L_00420d05 - .text + 0x401000
    .long L_00420d19 - .text + 0x401000
    .long L_00420d2b - .text + 0x401000
    .long L_00420d05 - .text + 0x401000
    .long L_00420d19 - .text + 0x401000
.org 0x0042293c - 0x401000
SWTAB_0042293c:  # 7 case address(es)
    .long L_00421365 - .text + 0x401000
    .long L_00421811 - .text + 0x401000
    .long L_00421365 - .text + 0x401000
    .long L_00421811 - .text + 0x401000
    .long L_004218b4 - .text + 0x401000
    .long L_00421365 - .text + 0x401000
    .long L_00421811 - .text + 0x401000
.org 0x00422958 - 0x401000
SWTAB_00422958:  # 6 case address(es)
    .long L_00421921 - .text + 0x401000
    .long L_004221f9 - .text + 0x401000
    .long L_004221f9 - .text + 0x401000
    .long L_00421a54 - .text + 0x401000
    .long L_00421fe2 - .text + 0x401000
    .long L_00422182 - .text + 0x401000
.set SWTAB_00422920_VA, SWTAB_00422920 - .text + 0x401000
.set SWTAB_0042293c_VA, SWTAB_0042293c - .text + 0x401000
.set SWTAB_00422958_VA, SWTAB_00422958 - .text + 0x401000

