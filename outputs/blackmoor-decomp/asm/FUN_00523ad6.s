# FUN_00523ad6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00523ad6
# extent:       0x00523ad6-0x00523c57 (385 code bytes)
# span:         0x00523ad6-0x00523c57 (code 385, tables 0, padding 0)
# sha256:       da933f20cafa062907226e3e8cdd251cf322575c41bd73aeb056d3307ffaeddf
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00523ad6
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       8 ebp-relative slot(s): local_4, local_8, local_c, local_1c, local_20, local_24, local_28, local_2c
# fields:       [eax + n] field_4, field_1c, field_54, field_74; [ebx + n] field_1c, field_3c, field_68; [esi + n] field_4
# callees:      calls FUN_00521188, FUN_0051da03, FUN_0052513f, FUN_0051c14c, USER32.dll!GetMenuItemCount, USER32.dll!GetSubMenu, FUN_0051fa37, FUN_0051dbc8; plus 6 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 138 instruction(s), 22 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c
.equ field_3c, 0x3c  # offset +0x3c
.equ field_54, 0x54  # offset +0x54
.equ field_68, 0x68  # offset +0x68
.equ field_74, 0x74  # offset +0x74

# --- external targets -----------------------------------------------
.set FUN_0051c14c, .text + (0x0051c14c - 0x401000)
.set FUN_0051da03, .text + (0x0051da03 - 0x401000)
.set FUN_0051dbc8, .text + (0x0051dbc8 - 0x401000)
.set FUN_0051fa37, .text + (0x0051fa37 - 0x401000)
.set FUN_00521188, .text + (0x00521188 - 0x401000)
.set FUN_0052513f, .text + (0x0052513f - 0x401000)

.org 0x00523ad6 - 0x401000
.globl FUN_00523ad6
FUN_00523ad6:
    # block 0x00523ad6: entry, 12 instruction(s), calls FUN_00521188, ends with jne to 0x00523c50 (forward)
    push ebp                                     # 00523ad6
    {load} mov ebp, esp                          # 00523ad7
    sub esp, 0x2c                                # 00523ad9
    push ebx                                     # 00523adc
    push esi                                     # 00523add
    {load} mov ebx, ecx                          # 00523ade
    push edi                                     # 00523ae0
    mov dword ptr [ebp - local_4], ebx           # 00523ae1
    push dword ptr [ebx + field_1c]              # 00523ae4
    call FUN_00521188                            # 00523ae7
    cmp dword ptr [ebp + arg_10], 0x0            # 00523aec
    jne.d32 L_00523c50                           # 00523af0
    # block 0x00523af6: entered by fall-through of jne at 0x00523af0, 4 instruction(s), ends with je to 0x00523b13 (forward)
    mov ecx, dword ptr [ebx + field_68]          # 00523af6
    mov esi, dword ptr [ebp + arg_8]             # 00523af9
    test ecx, ecx                                # 00523afc
    je.d8 L_00523b13                             # 00523afe
    # block 0x00523b00: entered by fall-through of je at 0x00523afe, 7 instruction(s), calls indirect dword ptr [eax + 0x74], ends with jne to 0x00523c50 (forward)
    mov eax, dword ptr [ecx]                     # 00523b00
    push 0x0                                     # 00523b02
    push dword ptr [ebp + arg_c]                 # 00523b04
    push esi                                     # 00523b07
    call dword ptr [eax + field_74]              # 00523b08
    test eax, eax                                # 00523b0b
    jne.d32 L_00523c50                           # 00523b0d
L_00523b13:
    # block 0x00523b13: entered by je at 0x00523afe; fall-through of jne at 0x00523b0d, 7 instruction(s), calls FUN_0051da03, FUN_0052513f, ends with jne to 0x00523b30 (forward)
    lea ecx, [ebp - local_2c]                    # 00523b13
    call FUN_0051da03                            # 00523b16
    mov dword ptr [ebp - local_20], esi          # 00523b1b
    call FUN_0052513f                            # 00523b1e
    mov eax, dword ptr [eax + field_54]          # 00523b23
    cmp eax, dword ptr [esi + field_4]           # 00523b26
    jne.d8 L_00523b30                            # 00523b29
    # block 0x00523b2b: entered by fall-through of jne at 0x00523b29, 2 instruction(s), ends with forward jump to 0x00523b86
    mov dword ptr [ebp - local_8], esi           # 00523b2b
    jmp.d8 L_00523b86                            # 00523b2e
L_00523b30:
    # block 0x00523b30: entered by jne at 0x00523b29, 5 instruction(s), calls indirect edi, ends with je to 0x00523b86 (forward)
    push dword ptr [ebx + field_1c]              # 00523b30
    mov edi, dword ptr [0x52a3f4]                # 00523b33
    call edi                                     # 00523b39
    test eax, eax                                # 00523b3b
    je.d8 L_00523b86                             # 00523b3d
    # block 0x00523b3f: entered by fall-through of je at 0x00523b3d, 4 instruction(s), calls FUN_0051c14c, ends with je to 0x00523b86 (forward)
    {load} mov ecx, ebx                          # 00523b3f
    call FUN_0051c14c                            # 00523b41
    test eax, eax                                # 00523b46
    je.d8 L_00523b86                             # 00523b48
    # block 0x00523b4a: entered by fall-through of je at 0x00523b48, 5 instruction(s), calls indirect edi, ends with je to 0x00523b86 (forward)
    push dword ptr [eax + field_1c]              # 00523b4a
    call edi                                     # 00523b4d
    {load} mov edi, eax                          # 00523b4f
    test edi, edi                                # 00523b51
    je.d8 L_00523b86                             # 00523b53
    # block 0x00523b55: entered by fall-through of je at 0x00523b53, 6 instruction(s), calls USER32.dll!GetMenuItemCount, ends with jle to 0x00523b83 (forward)
    push edi                                     # 00523b55
    call dword ptr [0x52a3f8]                    # 00523b56
    {load} xor ebx, ebx                          # 00523b5c
    mov dword ptr [ebp + arg_10], eax            # 00523b5e
    test eax, eax                                # 00523b61
    jle.d8 L_00523b83                            # 00523b63
L_00523b65:
    # block 0x00523b65: entered by jl at 0x00523b76; fall-through of jle at 0x00523b63, 5 instruction(s), calls USER32.dll!GetSubMenu, ends with je to 0x00523b7a (forward)
    push ebx                                     # 00523b65
    push edi                                     # 00523b66
    call dword ptr [0x52a3fc]                    # 00523b67
    cmp eax, dword ptr [esi + field_4]           # 00523b6d
    je.d8 L_00523b7a                             # 00523b70
    # block 0x00523b72: entered by fall-through of je at 0x00523b70, 3 instruction(s), ends with jl to 0x00523b65 (backward)
    inc ebx                                      # 00523b72
    cmp ebx, dword ptr [ebp + arg_10]            # 00523b73
    jl.d8 L_00523b65                             # 00523b76
    # block 0x00523b78: entered by fall-through of jl at 0x00523b76, 1 instruction(s), ends with forward jump to 0x00523b83
    jmp.d8 L_00523b83                            # 00523b78
L_00523b7a:
    # block 0x00523b7a: entered by je at 0x00523b70, 3 instruction(s), calls FUN_0051fa37, falls into the block at 0x00523b83
    push edi                                     # 00523b7a
    call FUN_0051fa37                            # 00523b7b
    mov dword ptr [ebp - local_8], eax           # 00523b80
L_00523b83:
    # block 0x00523b83: entered by jle at 0x00523b63; jmp at 0x00523b78, 1 instruction(s), falls into the block at 0x00523b86
    mov ebx, dword ptr [ebp - local_4]           # 00523b83
L_00523b86:
    # block 0x00523b86: entered by jmp at 0x00523b2e; je at 0x00523b3d; je at 0x00523b48; je at 0x00523b53, 6 instruction(s), calls USER32.dll!GetMenuItemCount, ends with jbe to 0x00523c50 (forward)
    push dword ptr [esi + field_4]               # 00523b86
    call dword ptr [0x52a3f8]                    # 00523b89
    and dword ptr [ebp - local_24], 0x0          # 00523b8f
    mov dword ptr [ebp - local_c], eax           # 00523b93
    test eax, eax                                # 00523b96
    jbe.d32 L_00523c50                           # 00523b98
    # block 0x00523b9e: entered by fall-through of jbe at 0x00523b98, 1 instruction(s), falls into the block at 0x00523ba4
    mov edi, dword ptr [0x52a400]                # 00523b9e
L_00523ba4:
    # block 0x00523ba4: entered by jb at 0x00523c4a, 6 instruction(s), calls indirect edi, ends with je to 0x00523c41 (forward)
    push dword ptr [ebp - local_24]              # 00523ba4
    push dword ptr [esi + field_4]               # 00523ba7
    call edi                                     # 00523baa
    test eax, eax                                # 00523bac
    mov dword ptr [ebp - local_28], eax          # 00523bae
    je.d32 L_00523c41                            # 00523bb1
    # block 0x00523bb7: entered by fall-through of je at 0x00523bb1, 2 instruction(s), ends with jne to 0x00523bec (forward)
    cmp eax, -0x1                                # 00523bb7
    jne.d8 L_00523bec                            # 00523bba
    # block 0x00523bbc: entered by fall-through of jne at 0x00523bba, 8 instruction(s), calls USER32.dll!GetSubMenu, FUN_0051fa37, ends with je to 0x00523c41 (forward)
    push dword ptr [ebp - local_24]              # 00523bbc
    push dword ptr [esi + field_4]               # 00523bbf
    call dword ptr [0x52a3fc]                    # 00523bc2
    push eax                                     # 00523bc8
    call FUN_0051fa37                            # 00523bc9
    test eax, eax                                # 00523bce
    mov dword ptr [ebp - local_1c], eax          # 00523bd0
    je.d8 L_00523c41                             # 00523bd3
    # block 0x00523bd5: entered by fall-through of je at 0x00523bd3, 6 instruction(s), calls indirect edi, ends with je to 0x00523c41 (forward)
    push 0x0                                     # 00523bd5
    push dword ptr [eax + field_4]               # 00523bd7
    call edi                                     # 00523bda
    test eax, eax                                # 00523bdc
    mov dword ptr [ebp - local_28], eax          # 00523bde
    je.d8 L_00523c41                             # 00523be1
    # block 0x00523be3: entered by fall-through of je at 0x00523be1, 2 instruction(s), ends with je to 0x00523c41 (forward)
    cmp eax, -0x1                                # 00523be3
    je.d8 L_00523c41                             # 00523be6
    # block 0x00523be8: entered by fall-through of je at 0x00523be6, 2 instruction(s), ends with forward jump to 0x00523c05
    push 0x0                                     # 00523be8
    jmp.d8 L_00523c05                            # 00523bea
L_00523bec:
    # block 0x00523bec: entered by jne at 0x00523bba, 3 instruction(s), ends with je to 0x00523c02 (forward)
    and dword ptr [ebp - local_1c], 0x0          # 00523bec
    cmp dword ptr [ebx + field_3c], 0x0          # 00523bf0
    je.d8 L_00523c02                             # 00523bf4
    # block 0x00523bf6: entered by fall-through of je at 0x00523bf4, 2 instruction(s), ends with jae to 0x00523c02 (forward)
    cmp eax, 0xf000                              # 00523bf6
    jae.d8 L_00523c02                            # 00523bfb
    # block 0x00523bfd: entered by fall-through of jae at 0x00523bfb, 3 instruction(s), ends with forward jump to 0x00523c04
    push 0x1                                     # 00523bfd
    pop eax                                      # 00523bff
    jmp.d8 L_00523c04                            # 00523c00
L_00523c02:
    # block 0x00523c02: entered by je at 0x00523bf4; jae at 0x00523bfb, 1 instruction(s), falls into the block at 0x00523c04
    {load} xor eax, eax                          # 00523c02
L_00523c04:
    # block 0x00523c04: entered by jmp at 0x00523c00, 1 instruction(s), falls into the block at 0x00523c05
    push eax                                     # 00523c04
L_00523c05:
    # block 0x00523c05: entered by jmp at 0x00523bea, 8 instruction(s), calls FUN_0051dbc8, USER32.dll!GetMenuItemCount, ends with jae to 0x00523c3b (forward)
    push ebx                                     # 00523c05
    lea ecx, [ebp - local_2c]                    # 00523c06
    call FUN_0051dbc8                            # 00523c09
    push dword ptr [esi + field_4]               # 00523c0e
    call dword ptr [0x52a3f8]                    # 00523c11
    {load} mov ebx, eax                          # 00523c17
    cmp ebx, dword ptr [ebp - local_c]           # 00523c19
    jae.d8 L_00523c3b                            # 00523c1c
    # block 0x00523c1e: entered by fall-through of jae at 0x00523c1c, 2 instruction(s), falls into the block at 0x00523c24
    sub eax, dword ptr [ebp - local_c]           # 00523c1e
    add dword ptr [ebp - local_24], eax          # 00523c21
L_00523c24:
    # block 0x00523c24: entered by jmp at 0x00523c39, 2 instruction(s), ends with jae to 0x00523c3b (forward)
    cmp dword ptr [ebp - local_24], ebx          # 00523c24
    jae.d8 L_00523c3b                            # 00523c27
    # block 0x00523c29: entered by fall-through of jae at 0x00523c27, 5 instruction(s), calls indirect edi, ends with jne to 0x00523c3b (forward)
    push dword ptr [ebp - local_24]              # 00523c29
    push dword ptr [esi + field_4]               # 00523c2c
    call edi                                     # 00523c2f
    cmp eax, dword ptr [ebp - local_28]          # 00523c31
    jne.d8 L_00523c3b                            # 00523c34
    # block 0x00523c36: entered by fall-through of jne at 0x00523c34, 2 instruction(s), ends with backward jump to 0x00523c24
    inc dword ptr [ebp - local_24]               # 00523c36
    jmp.d8 L_00523c24                            # 00523c39
L_00523c3b:
    # block 0x00523c3b: entered by jae at 0x00523c1c; jae at 0x00523c27; jne at 0x00523c34, 2 instruction(s), falls into the block at 0x00523c41
    mov dword ptr [ebp - local_c], ebx           # 00523c3b
    mov ebx, dword ptr [ebp - local_4]           # 00523c3e
L_00523c41:
    # block 0x00523c41: entered by je at 0x00523bb1; je at 0x00523bd3; je at 0x00523be1; je at 0x00523be6, 4 instruction(s), ends with jb to 0x00523ba4 (backward)
    inc dword ptr [ebp - local_24]               # 00523c41
    mov eax, dword ptr [ebp - local_24]          # 00523c44
    cmp eax, dword ptr [ebp - local_c]           # 00523c47
    jb.d32 L_00523ba4                            # 00523c4a
L_00523c50:
    # block 0x00523c50: entered by jne at 0x00523af0; jne at 0x00523b0d; jbe at 0x00523b98; fall-through of jb at 0x00523c4a, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 00523c50
    pop esi                                      # 00523c51
    pop ebx                                      # 00523c52
    leave                                        # 00523c53
    ret 0xc                                      # 00523c54

