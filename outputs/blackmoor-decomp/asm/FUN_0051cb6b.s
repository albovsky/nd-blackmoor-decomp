# FUN_0051cb6b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051cb6b
# extent:       0x0051cb6b-0x0051cd20 (437 code bytes)
# span:         0x0051cb6b-0x0051cd20 (code 437, tables 0, padding 0)
# sha256:       c4ccbebe689ee8134a8e8501433486a93ed191987e189d7f34e5ecd4e734ae2d
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051cb6b
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       17 ebp-relative slot(s): local_1, local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c and 5 more
# fields:       [eax + n] field_1c; [esi + n] field_1c
# callees:      calls FUN_0051d526, USER32.dll!GetParent, USER32.dll!GetWindow, USER32.dll!SendMessageA, USER32.dll!GetWindowLongA, FUN_0050c193, FUN_0050c07e, FUN_0050c0e9, USER32.dll!CopyRect, USER32.dll!MapWindowPoints, FUN_0051d5e1; plus 6 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 174 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
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
.equ local_4c, 0x4c  # offset -0x4c
.equ local_60, 0x60  # offset -0x60
.equ arg_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0050c07e, .text + (0x0050c07e - 0x401000)
.set FUN_0050c0e9, .text + (0x0050c0e9 - 0x401000)
.set FUN_0050c193, .text + (0x0050c193 - 0x401000)
.set FUN_0051d526, .text + (0x0051d526 - 0x401000)
.set FUN_0051d5e1, .text + (0x0051d5e1 - 0x401000)

.org 0x0051cb6b - 0x401000
.globl FUN_0051cb6b
FUN_0051cb6b:
    # block 0x0051cb6b: entry, 13 instruction(s), calls FUN_0051d526, ends with je to 0x0051cb8d (forward)
    push ebp                                     # 0051cb6b
    {load} mov ebp, esp                          # 0051cb6c
    sub esp, 0x60                                # 0051cb6e
    push ebx                                     # 0051cb71
    push esi                                     # 0051cb72
    {load} mov esi, ecx                          # 0051cb73
    push edi                                     # 0051cb75
    mov dword ptr [ebp - local_8], esi           # 0051cb76
    call FUN_0051d526                            # 0051cb79
    mov dword ptr [ebp - local_4], eax           # 0051cb7e
    mov eax, dword ptr [ebp + arg_8]             # 0051cb81
    test eax, eax                                # 0051cb84
    je.d8 L_0051cb8d                             # 0051cb86
    # block 0x0051cb88: entered by fall-through of je at 0x0051cb86, 2 instruction(s), ends with forward jump to 0x0051cbc5
    mov edi, dword ptr [eax + field_1c]          # 0051cb88
    jmp.d8 L_0051cbc5                            # 0051cb8b
L_0051cb8d:
    # block 0x0051cb8d: entered by je at 0x0051cb86, 2 instruction(s), ends with je to 0x0051cb9e (forward)
    test byte ptr [ebp - local_1], 0x40          # 0051cb8d
    je.d8 L_0051cb9e                             # 0051cb91
    # block 0x0051cb93: entered by fall-through of je at 0x0051cb91, 3 instruction(s), calls USER32.dll!GetParent, ends with forward jump to 0x0051cba9
    push dword ptr [esi + field_1c]              # 0051cb93
    call dword ptr [0x52a3dc]                    # 0051cb96
    jmp.d8 L_0051cba9                            # 0051cb9c
L_0051cb9e:
    # block 0x0051cb9e: entered by je at 0x0051cb91, 3 instruction(s), calls USER32.dll!GetWindow, falls into the block at 0x0051cba9
    push 0x4                                     # 0051cb9e
    push dword ptr [esi + field_1c]              # 0051cba0
    call dword ptr [0x52a450]                    # 0051cba3
L_0051cba9:
    # block 0x0051cba9: entered by jmp at 0x0051cb9c, 3 instruction(s), ends with je to 0x0051cbc5 (forward)
    {load} mov edi, eax                          # 0051cba9
    test edi, edi                                # 0051cbab
    je.d8 L_0051cbc5                             # 0051cbad
    # block 0x0051cbaf: entered by fall-through of je at 0x0051cbad, 7 instruction(s), calls USER32.dll!SendMessageA, ends with je to 0x0051cbc5 (forward)
    push 0x0                                     # 0051cbaf
    push 0x0                                     # 0051cbb1
    push 0x36b                                   # 0051cbb3
    push edi                                     # 0051cbb8
    call dword ptr [0x52a4c8]                    # 0051cbb9
    test eax, eax                                # 0051cbbf
    je.d8 L_0051cbc5                             # 0051cbc1
    # block 0x0051cbc3: entered by fall-through of je at 0x0051cbc1, 1 instruction(s), falls into the block at 0x0051cbc5
    {load} mov edi, eax                          # 0051cbc3
L_0051cbc5:
    # block 0x0051cbc5: entered by jmp at 0x0051cb8b; je at 0x0051cbad; je at 0x0051cbc1, 7 instruction(s), calls indirect ebx, ends with jne to 0x0051cc69 (forward)
    mov ebx, dword ptr [0x52a46c]                # 0051cbc5
    lea eax, [ebp - local_28]                    # 0051cbcb
    push eax                                     # 0051cbce
    push dword ptr [esi + field_1c]              # 0051cbcf
    call ebx                                     # 0051cbd2
    test byte ptr [ebp - local_1], 0x40          # 0051cbd4
    jne.d32 L_0051cc69                           # 0051cbd8
    # block 0x0051cbde: entered by fall-through of jne at 0x0051cbd8, 2 instruction(s), ends with je to 0x0051cbfb (forward)
    test edi, edi                                # 0051cbde
    je.d8 L_0051cbfb                             # 0051cbe0
    # block 0x0051cbe2: entered by fall-through of je at 0x0051cbe0, 5 instruction(s), calls USER32.dll!GetWindowLongA, ends with je to 0x0051cbf9 (forward)
    push -0x10                                   # 0051cbe2
    push edi                                     # 0051cbe4
    call dword ptr [0x52a454]                    # 0051cbe5
    test eax, 0x10000000                         # 0051cbeb
    je.d8 L_0051cbf9                             # 0051cbf0
    # block 0x0051cbf2: entered by fall-through of je at 0x0051cbf0, 2 instruction(s), ends with je to 0x0051cbfb (forward)
    test eax, 0x20000000                         # 0051cbf2
    je.d8 L_0051cbfb                             # 0051cbf7
L_0051cbf9:
    # block 0x0051cbf9: entered by je at 0x0051cbf0; fall-through of je at 0x0051cbf7, 1 instruction(s), falls into the block at 0x0051cbfb
    {load} xor edi, edi                          # 0051cbf9
L_0051cbfb:
    # block 0x0051cbfb: entered by je at 0x0051cbe0; je at 0x0051cbf7, 3 instruction(s), ends with jne to 0x0051cc40 (forward)
    test edi, edi                                # 0051cbfb
    mov dword ptr [ebp - local_60], 0x28         # 0051cbfd
    jne.d8 L_0051cc40                            # 0051cc04
    # block 0x0051cc06: entered by fall-through of jne at 0x0051cc04, 3 instruction(s), calls FUN_0050c193, ends with je to 0x0051cc12 (forward)
    call FUN_0050c193                            # 0051cc06
    test eax, eax                                # 0051cc0b
    je.d8 L_0051cc12                             # 0051cc0d
    # block 0x0051cc0f: entered by fall-through of je at 0x0051cc0d, 1 instruction(s), falls into the block at 0x0051cc12
    mov eax, dword ptr [eax + field_1c]          # 0051cc0f
L_0051cc12:
    # block 0x0051cc12: entered by je at 0x0051cc0d, 19 instruction(s), calls FUN_0050c07e, FUN_0050c0e9, indirect esi, ends with forward jump to 0x0051cc96
    lea ecx, [ebp - local_60]                    # 0051cc12
    push ecx                                     # 0051cc15
    push 0x1                                     # 0051cc16
    push eax                                     # 0051cc18
    call FUN_0050c07e                            # 0051cc19
    push eax                                     # 0051cc1e
    call FUN_0050c0e9                            # 0051cc1f
    mov esi, dword ptr [0x52a4ac]                # 0051cc24
    lea eax, [ebp - local_4c]                    # 0051cc2a
    push eax                                     # 0051cc2d
    lea eax, [ebp - local_38]                    # 0051cc2e
    push eax                                     # 0051cc31
    call esi                                     # 0051cc32
    lea eax, [ebp - local_4c]                    # 0051cc34
    push eax                                     # 0051cc37
    lea eax, [ebp - local_18]                    # 0051cc38
    push eax                                     # 0051cc3b
    call esi                                     # 0051cc3c
    jmp.d8 L_0051cc96                            # 0051cc3e
L_0051cc40:
    # block 0x0051cc40: entered by jne at 0x0051cc04, 17 instruction(s), calls indirect ebx, FUN_0050c07e, FUN_0050c0e9, USER32.dll!CopyRect, ends with forward jump to 0x0051cc96
    lea eax, [ebp - local_38]                    # 0051cc40
    push eax                                     # 0051cc43
    push edi                                     # 0051cc44
    call ebx                                     # 0051cc45
    lea eax, [ebp - local_60]                    # 0051cc47
    push eax                                     # 0051cc4a
    push 0x2                                     # 0051cc4b
    push edi                                     # 0051cc4d
    call FUN_0050c07e                            # 0051cc4e
    push eax                                     # 0051cc53
    call FUN_0050c0e9                            # 0051cc54
    lea eax, [ebp - local_4c]                    # 0051cc59
    push eax                                     # 0051cc5c
    lea eax, [ebp - local_18]                    # 0051cc5d
    push eax                                     # 0051cc60
    call dword ptr [0x52a4ac]                    # 0051cc61
    jmp.d8 L_0051cc96                            # 0051cc67
L_0051cc69:
    # block 0x0051cc69: entered by jne at 0x0051cbd8, 18 instruction(s), calls USER32.dll!GetParent, indirect esi, USER32.dll!MapWindowPoints, falls into the block at 0x0051cc96
    push dword ptr [esi + field_1c]              # 0051cc69
    call dword ptr [0x52a3dc]                    # 0051cc6c
    mov esi, dword ptr [0x52a4d8]                # 0051cc72
    {load} mov ebx, eax                          # 0051cc78
    lea eax, [ebp - local_18]                    # 0051cc7a
    push eax                                     # 0051cc7d
    push ebx                                     # 0051cc7e
    call esi                                     # 0051cc7f
    lea eax, [ebp - local_38]                    # 0051cc81
    push eax                                     # 0051cc84
    push edi                                     # 0051cc85
    call esi                                     # 0051cc86
    lea eax, [ebp - local_38]                    # 0051cc88
    push 0x2                                     # 0051cc8b
    push eax                                     # 0051cc8d
    push ebx                                     # 0051cc8e
    push edi                                     # 0051cc8f
    call dword ptr [0x52a314]                    # 0051cc90
L_0051cc96:
    # block 0x0051cc96: entered by jmp at 0x0051cc3e; jmp at 0x0051cc67, 30 instruction(s), ends with jge to 0x0051ccdc (forward)
    mov eax, dword ptr [ebp - local_38]          # 0051cc96
    mov ecx, dword ptr [ebp - local_30]          # 0051cc99
    mov edi, dword ptr [ebp - local_20]          # 0051cc9c
    {load} add eax, ecx                          # 0051cc9f
    sub edi, dword ptr [ebp - local_28]          # 0051cca1
    mov ebx, dword ptr [ebp - local_1c]          # 0051cca4
    cdq                                          # 0051cca7
    {load} sub eax, edx                          # 0051cca8
    sub ebx, dword ptr [ebp - local_24]          # 0051ccaa
    {load} mov ecx, eax                          # 0051ccad
    {load} mov eax, edi                          # 0051ccaf
    cdq                                          # 0051ccb1
    {load} sub eax, edx                          # 0051ccb2
    mov edx, dword ptr [ebp - local_2c]          # 0051ccb4
    sar ecx                                      # 0051ccb7
    sar eax                                      # 0051ccb9
    {load} sub ecx, eax                          # 0051ccbb
    mov eax, dword ptr [ebp - local_34]          # 0051ccbd
    {load} add eax, edx                          # 0051ccc0
    cdq                                          # 0051ccc2
    {load} sub eax, edx                          # 0051ccc3
    {load} mov esi, eax                          # 0051ccc5
    {load} mov eax, ebx                          # 0051ccc7
    cdq                                          # 0051ccc9
    {load} sub eax, edx                          # 0051ccca
    sar esi                                      # 0051cccc
    sar eax                                      # 0051ccce
    {load} sub esi, eax                          # 0051ccd0
    cmp ecx, dword ptr [ebp - local_18]          # 0051ccd2
    jge.d8 L_0051ccdc                            # 0051ccd5
    # block 0x0051ccd7: entered by fall-through of jge at 0x0051ccd5, 2 instruction(s), ends with forward jump to 0x0051cced
    mov ecx, dword ptr [ebp - local_18]          # 0051ccd7
    jmp.d8 L_0051cced                            # 0051ccda
L_0051ccdc:
    # block 0x0051ccdc: entered by jge at 0x0051ccd5, 4 instruction(s), ends with jle to 0x0051cced (forward)
    mov eax, dword ptr [ebp - local_10]          # 0051ccdc
    {load} add edi, ecx                          # 0051ccdf
    {load} cmp edi, eax                          # 0051cce1
    jle.d8 L_0051cced                            # 0051cce3
    # block 0x0051cce5: entered by fall-through of jle at 0x0051cce3, 3 instruction(s), falls into the block at 0x0051cced
    sub eax, dword ptr [ebp - local_20]          # 0051cce5
    add eax, dword ptr [ebp - local_28]          # 0051cce8
    {load} mov ecx, eax                          # 0051cceb
L_0051cced:
    # block 0x0051cced: entered by jmp at 0x0051ccda; jle at 0x0051cce3, 2 instruction(s), ends with jge to 0x0051ccf7 (forward)
    cmp esi, dword ptr [ebp - local_14]          # 0051cced
    jge.d8 L_0051ccf7                            # 0051ccf0
    # block 0x0051ccf2: entered by fall-through of jge at 0x0051ccf0, 2 instruction(s), ends with forward jump to 0x0051cd07
    mov esi, dword ptr [ebp - local_14]          # 0051ccf2
    jmp.d8 L_0051cd07                            # 0051ccf5
L_0051ccf7:
    # block 0x0051ccf7: entered by jge at 0x0051ccf0, 3 instruction(s), ends with jle to 0x0051cd07 (forward)
    {load} add ebx, esi                          # 0051ccf7
    cmp ebx, dword ptr [ebp - local_c]           # 0051ccf9
    jle.d8 L_0051cd07                            # 0051ccfc
    # block 0x0051ccfe: entered by fall-through of jle at 0x0051ccfc, 3 instruction(s), falls into the block at 0x0051cd07
    mov esi, dword ptr [ebp - local_24]          # 0051ccfe
    sub esi, dword ptr [ebp - local_1c]          # 0051cd01
    add esi, dword ptr [ebp - local_c]           # 0051cd04
L_0051cd07:
    # block 0x0051cd07: entered by jmp at 0x0051ccf5; jle at 0x0051ccfc, 13 instruction(s), calls FUN_0051d5e1, ends with ret 0x4
    push 0x15                                    # 0051cd07
    push -0x1                                    # 0051cd09
    push -0x1                                    # 0051cd0b
    push esi                                     # 0051cd0d
    push ecx                                     # 0051cd0e
    mov ecx, dword ptr [ebp - local_8]           # 0051cd0f
    push 0x0                                     # 0051cd12
    call FUN_0051d5e1                            # 0051cd14
    pop edi                                      # 0051cd19
    pop esi                                      # 0051cd1a
    pop ebx                                      # 0051cd1b
    leave                                        # 0051cd1c
    ret 0x4                                      # 0051cd1d

