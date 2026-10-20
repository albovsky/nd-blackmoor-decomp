# FUN_0045be7f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045be7f
# extent:       0x0045be7f-0x0045c18f (784 code bytes)
# span:         0x0045be7f-0x0045c18f (code 784, tables 0, padding 0)
# sha256:       8a75bc3f2dfd3aa29bfefc4e2473c63e2c048a7938dcb3ad9525e136a8253f41
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         caption_pick
# naming:       native port src/action_family_da_runtime.c:caption_pick (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-17); the summary is the acceptance note
# summary:      1:1 with caption_pick (draw until real name). Native-only guards: entry 0..1, count<=10, text 201..0x9c40 -> BUL_ERR_BOUNDS, stuck draw -> BUL_ERR_STUCK.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       10 ebp-relative slot(s): local_4, local_8, local_2c, local_54, local_58, local_5c, local_60, local_12c, local_130, local_134
# fields:       [eax + n] field_1e, field_24, field_1ab, field_1b1; [ecx + n] field_1a5, field_1a7, field_1ad, field_1b3, field_593; [edi + n] field_minus_1; [edx + n] field_1a5, field_1a9, field_591, field_595
# callees:      calls FUN_0050cd50, FUN_0045be3f, FUN_004fb77a, FUN_004fb2e3, FUN_00423259, FUN_00448d11
# track-n:      outputs/blackmoor-decomp/src/action_family_da_runtime.c:caption_pick (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 205 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_2c, 0x2c  # offset -0x2c
.equ local_54, 0x54  # offset -0x54
.equ local_58, 0x58  # offset -0x58
.equ local_5c, 0x5c  # offset -0x5c
.equ local_60, 0x60  # offset -0x60
.equ local_12c, 0x12c  # offset -0x12c
.equ local_130, 0x130  # offset -0x130
.equ local_134, 0x134  # offset -0x134
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1e, 0x1e  # offset +0x1e
.equ field_24, 0x24  # offset +0x24
.equ field_1a5, 0x1a5  # offset +0x1a5
.equ field_1a7, 0x1a7  # offset +0x1a7
.equ field_1a9, 0x1a9  # offset +0x1a9
.equ field_1ab, 0x1ab  # offset +0x1ab
.equ field_1ad, 0x1ad  # offset +0x1ad
.equ field_1b1, 0x1b1  # offset +0x1b1
.equ field_1b3, 0x1b3  # offset +0x1b3
.equ field_591, 0x591  # offset +0x591
.equ field_593, 0x593  # offset +0x593
.equ field_595, 0x595  # offset +0x595

# --- external targets -----------------------------------------------
.set FUN_00423259, .text + (0x00423259 - 0x401000)
.set FUN_00448d11, .text + (0x00448d11 - 0x401000)
.set FUN_0045be3f, .text + (0x0045be3f - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x0045be7f - 0x401000
.globl FUN_0045be7f
FUN_0045be7f:
    # block 0x0045be7f: entry, 42 instruction(s), ends with jle to 0x0045c06b (forward)
    push ebp                                     # 0045be7f
    {load} mov ebp, esp                          # 0045be80
    sub esp, 0x134                               # 0045be82
    push esi                                     # 0045be88
    push edi                                     # 0045be89
    mov dword ptr [ebp - local_134], ecx         # 0045be8a
    mov dword ptr [ebp - local_5c], 0x0          # 0045be90
    mov dword ptr [ebp - local_60], 0x0          # 0045be97
    mov eax, dword ptr [ebp - local_134]         # 0045be9e
    movsx ecx, word ptr [eax + field_1e]         # 0045bea4
    imul ecx, ecx, 0x8d                          # 0045bea8
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0045beae
    mov dword ptr [ebp - local_8], edx           # 0045beb4
    movsx eax, word ptr [ebp + arg_10]           # 0045beb7
    imul eax, eax, 0x2dc                         # 0045bebb
    mov ecx, dword ptr [ebp - local_134]         # 0045bec1
    mov edx, dword ptr [ebp - local_8]           # 0045bec7
    mov ax, word ptr [edx + eax + field_591]     # 0045beca
    mov word ptr [ecx + field_1a5], ax           # 0045bed2
    mov ecx, dword ptr [ebp - local_134]         # 0045bed9
    mov word ptr [ecx + field_1a7], 0x2          # 0045bedf
    mov edx, dword ptr [ebp - local_134]         # 0045bee8
    mov word ptr [edx + field_1a9], 0x1          # 0045beee
    mov eax, dword ptr [ebp - local_134]         # 0045bef7
    mov word ptr [eax + field_1ab], 0x1          # 0045befd
    mov ecx, dword ptr [ebp - local_134]         # 0045bf06
    mov dword ptr [ecx + field_1ad], 0x1         # 0045bf0c
    movsx edx, word ptr [ebp + arg_10]           # 0045bf16
    imul edx, edx, 0x2dc                         # 0045bf1a
    mov eax, dword ptr [ebp - local_134]         # 0045bf20
    mov ecx, dword ptr [ebp - local_8]           # 0045bf26
    mov dx, word ptr [ecx + edx + field_593]     # 0045bf29
    mov word ptr [eax + field_1b1], dx           # 0045bf31
    movsx eax, word ptr [ebp + arg_10]           # 0045bf38
    imul eax, eax, 0x2dc                         # 0045bf3c
    mov ecx, dword ptr [ebp - local_134]         # 0045bf42
    mov edx, dword ptr [ebp - local_8]           # 0045bf48
    mov ax, word ptr [edx + eax + field_595]     # 0045bf4b
    mov word ptr [ecx + field_1b3], ax           # 0045bf53
    movsx ecx, word ptr [ebp + arg_c]            # 0045bf5a
    cmp ecx, 0x1                                 # 0045bf5e
    jle.d32 L_0045c06b                           # 0045bf61
    # block 0x0045bf67: entered by fall-through of jle at 0x0045bf61, 5 instruction(s), falls into the block at 0x0045bf7a
    mov dword ptr [ebp - local_4], 0x0           # 0045bf67
    mov ecx, 0xa                                 # 0045bf6e
    {load} xor eax, eax                          # 0045bf73
    lea edi, [ebp - local_54]                    # 0045bf75
    rep stosd dword ptr es:[edi], eax            # 0045bf78
L_0045bf7a:
    # block 0x0045bf7a: entered by jmp at 0x0045c064, 2 instruction(s), ends with jne to 0x0045c069 (forward)
    cmp dword ptr [ebp - local_5c], 0x0          # 0045bf7a
    jne.d32 L_0045c069                           # 0045bf7e
    # block 0x0045bf84: entered by fall-through of jne at 0x0045bf7e, 2 instruction(s), ends with jne to 0x0045c069 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 0045bf84
    jne.d32 L_0045c069                           # 0045bf88
    # block 0x0045bf8e: entered by fall-through of jne at 0x0045bf88, 30 instruction(s), calls FUN_0050cd50, FUN_0045be3f, ends with je to 0x0045c01a (forward)
    call FUN_0050cd50                            # 0045bf8e
    movsx ecx, word ptr [ebp + arg_c]            # 0045bf93
    cdq                                          # 0045bf97
    idiv ecx                                     # 0045bf98
    mov word ptr [ebp - local_130], dx           # 0045bf9a
    movsx edx, word ptr [ebp - local_130]        # 0045bfa1
    imul edx, edx, 0x21                          # 0045bfa8
    mov eax, dword ptr [ebp + arg_8]             # 0045bfab
    {load} add eax, edx                          # 0045bfae
    {load} mov edi, eax                          # 0045bfb0
    lea edx, [ebp - local_2c]                    # 0045bfb2
    or ecx, -0x1                                 # 0045bfb5
    {load} xor eax, eax                          # 0045bfb8
    repne scasb al, byte ptr es:[edi]            # 0045bfba
    not ecx                                      # 0045bfbc
    {load} sub edi, ecx                          # 0045bfbe
    {load} mov esi, edi                          # 0045bfc0
    {load} mov eax, ecx                          # 0045bfc2
    {load} mov edi, edx                          # 0045bfc4
    shr ecx, 0x2                                 # 0045bfc6
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0045bfc9
    {load} mov ecx, eax                          # 0045bfcb
    and ecx, 0x3                                 # 0045bfcd
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0045bfd0
    lea ecx, [ebp - local_2c]                    # 0045bfd2
    push ecx                                     # 0045bfd5
    mov ecx, dword ptr [ebp - local_134]         # 0045bfd6
    call FUN_0045be3f                            # 0045bfdc
    test eax, eax                                # 0045bfe1
    je.d8 L_0045c01a                             # 0045bfe3
    # block 0x0045bfe5: entered by fall-through of je at 0x0045bfe3, 18 instruction(s), ends with forward jump to 0x0045c064
    lea edi, [ebp - local_2c]                    # 0045bfe5
    mov edx, dword ptr [ebp - local_134]         # 0045bfe8
    add edx, 0x184                               # 0045bfee
    or ecx, -0x1                                 # 0045bff4
    {load} xor eax, eax                          # 0045bff7
    repne scasb al, byte ptr es:[edi]            # 0045bff9
    not ecx                                      # 0045bffb
    {load} sub edi, ecx                          # 0045bffd
    {load} mov esi, edi                          # 0045bfff
    {load} mov eax, ecx                          # 0045c001
    {load} mov edi, edx                          # 0045c003
    shr ecx, 0x2                                 # 0045c005
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0045c008
    {load} mov ecx, eax                          # 0045c00a
    and ecx, 0x3                                 # 0045c00c
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0045c00f
    mov dword ptr [ebp - local_5c], 0x1          # 0045c011
    jmp.d8 L_0045c064                            # 0045c018
L_0045c01a:
    # block 0x0045c01a: entered by je at 0x0045bfe3, 5 instruction(s), ends with forward jump to 0x0045c044
    movsx ecx, word ptr [ebp - local_130]        # 0045c01a
    mov dword ptr [ebp + 4*ecx - local_54], 0x1  # 0045c021
    mov dword ptr [ebp - local_4], 0x1           # 0045c029
    mov word ptr [ebp - local_58], 0x0           # 0045c030
    jmp.d8 L_0045c044                            # 0045c036
L_0045c038:
    # block 0x0045c038: entered by jmp at 0x0045c062, 3 instruction(s), falls into the block at 0x0045c044
    mov dx, word ptr [ebp - local_58]            # 0045c038
    add dx, 0x1                                  # 0045c03c
    mov word ptr [ebp - local_58], dx            # 0045c040
L_0045c044:
    # block 0x0045c044: entered by jmp at 0x0045c036, 4 instruction(s), ends with jge to 0x0045c064 (forward)
    movsx eax, word ptr [ebp - local_58]         # 0045c044
    movsx ecx, word ptr [ebp + arg_c]            # 0045c048
    {load} cmp eax, ecx                          # 0045c04c
    jge.d8 L_0045c064                            # 0045c04e
    # block 0x0045c050: entered by fall-through of jge at 0x0045c04e, 3 instruction(s), ends with jne to 0x0045c062 (forward)
    movsx edx, word ptr [ebp - local_58]         # 0045c050
    cmp dword ptr [ebp + 4*edx - local_54], 0x0  # 0045c054
    jne.d8 L_0045c062                            # 0045c059
    # block 0x0045c05b: entered by fall-through of jne at 0x0045c059, 1 instruction(s), falls into the block at 0x0045c062
    mov dword ptr [ebp - local_4], 0x0           # 0045c05b
L_0045c062:
    # block 0x0045c062: entered by jne at 0x0045c059, 1 instruction(s), ends with backward jump to 0x0045c038
    jmp.d8 L_0045c038                            # 0045c062
L_0045c064:
    # block 0x0045c064: entered by jmp at 0x0045c018; jge at 0x0045c04e, 1 instruction(s), ends with backward jump to 0x0045bf7a
    jmp.d32 L_0045bf7a                           # 0045c064
L_0045c069:
    # block 0x0045c069: entered by jne at 0x0045bf7e; jne at 0x0045bf88, 1 instruction(s), ends with forward jump to 0x0045c0b3
    jmp.d8 L_0045c0b3                            # 0045c069
L_0045c06b:
    # block 0x0045c06b: entered by jle at 0x0045bf61, 6 instruction(s), calls FUN_0045be3f, ends with je to 0x0045c0b3 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 0045c06b
    push eax                                     # 0045c06e
    mov ecx, dword ptr [ebp - local_134]         # 0045c06f
    call FUN_0045be3f                            # 0045c075
    test eax, eax                                # 0045c07a
    je.d8 L_0045c0b3                             # 0045c07c
    # block 0x0045c07e: entered by fall-through of je at 0x0045c07c, 18 instruction(s), falls into the block at 0x0045c0b3
    mov edi, dword ptr [ebp + arg_8]             # 0045c07e
    mov ecx, dword ptr [ebp - local_134]         # 0045c081
    add ecx, 0x184                               # 0045c087
    {load} mov edx, ecx                          # 0045c08d
    or ecx, -0x1                                 # 0045c08f
    {load} xor eax, eax                          # 0045c092
    repne scasb al, byte ptr es:[edi]            # 0045c094
    not ecx                                      # 0045c096
    {load} sub edi, ecx                          # 0045c098
    {load} mov esi, edi                          # 0045c09a
    {load} mov eax, ecx                          # 0045c09c
    {load} mov edi, edx                          # 0045c09e
    shr ecx, 0x2                                 # 0045c0a0
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0045c0a3
    {load} mov ecx, eax                          # 0045c0a5
    and ecx, 0x3                                 # 0045c0a7
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0045c0aa
    mov dword ptr [ebp - local_5c], 0x1          # 0045c0ac
L_0045c0b3:
    # block 0x0045c0b3: entered by jmp at 0x0045c069; je at 0x0045c07c, 2 instruction(s), ends with je to 0x0045c184 (forward)
    cmp dword ptr [ebp - local_5c], 0x0          # 0045c0b3
    je.d32 L_0045c184                            # 0045c0b7
    # block 0x0045c0bd: entered by fall-through of je at 0x0045c0b7, 18 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, FUN_00423259, ends with je to 0x0045c177 (forward)
    mov ecx, dword ptr [ebp - local_134]         # 0045c0bd
    add ecx, 0x184                               # 0045c0c3
    push ecx                                     # 0045c0c9
    mov ecx, 0x5c3a67                            # 0045c0ca
    call FUN_004fb77a                            # 0045c0cf
    mov edx, dword ptr [ebp - local_134]         # 0045c0d4
    mov ax, word ptr [edx + field_1a5]           # 0045c0da
    push eax                                     # 0045c0e1
    mov ecx, 0x5c3a67                            # 0045c0e2
    call FUN_004fb2e3                            # 0045c0e7
    mov ecx, dword ptr [ebp - local_134]         # 0045c0ec
    add ecx, 0x184                               # 0045c0f2
    push ecx                                     # 0045c0f8
    mov ecx, 0x619a6b                            # 0045c0f9
    call FUN_00423259                            # 0045c0fe
    mov dword ptr [ebp - local_60], eax          # 0045c103
    cmp dword ptr [ebp - local_60], 0x0          # 0045c106
    je.d8 L_0045c177                             # 0045c10a
    # block 0x0045c10c: entered by fall-through of je at 0x0045c10a, 8 instruction(s), ends with ja to 0x0045c177 (forward)
    mov edi, dword ptr [ebp - local_60]          # 0045c10c
    or ecx, -0x1                                 # 0045c10f
    {load} xor eax, eax                          # 0045c112
    repne scasb al, byte ptr es:[edi]            # 0045c114
    not ecx                                      # 0045c116
    add ecx, -0x1                                # 0045c118
    cmp ecx, 0x9c40                              # 0045c11b
    ja.d8 L_0045c177                             # 0045c121
    # block 0x0045c123: entered by fall-through of ja at 0x0045c121, 27 instruction(s), calls FUN_00448d11, falls into the block at 0x0045c177
    mov edi, dword ptr [ebp - local_60]          # 0045c123
    or ecx, -0x1                                 # 0045c126
    {load} xor eax, eax                          # 0045c129
    repne scasb al, byte ptr es:[edi]            # 0045c12b
    not ecx                                      # 0045c12d
    mov esi, dword ptr [ebp - local_60]          # 0045c12f
    lea edi, [ebp - local_12c]                   # 0045c132
    {load} mov edx, ecx                          # 0045c138
    shr ecx, 0x2                                 # 0045c13a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0045c13d
    {load} mov ecx, edx                          # 0045c13f
    and ecx, 0x3                                 # 0045c141
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0045c144
    lea edi, [ebp - local_12c]                   # 0045c146
    or ecx, -0x1                                 # 0045c14c
    {load} xor eax, eax                          # 0045c14f
    repne scasb al, byte ptr es:[edi]            # 0045c151
    mov eax, dword ptr [0x54ab74]                # 0045c153
    mov dword ptr [edi - field_minus_1], eax     # 0045c158
    push 0x0                                     # 0045c15b
    push -0x1                                    # 0045c15d
    lea ecx, [ebp - local_12c]                   # 0045c15f
    push ecx                                     # 0045c165
    mov edx, dword ptr [0x5d03b3]                # 0045c166
    push edx                                     # 0045c16c
    mov ecx, 0x619a05                            # 0045c16d
    call FUN_00448d11                            # 0045c172
L_0045c177:
    # block 0x0045c177: entered by je at 0x0045c10a; ja at 0x0045c121, 2 instruction(s), falls into the block at 0x0045c184
    mov eax, dword ptr [ebp - local_134]         # 0045c177
    mov dword ptr [eax + field_24], 0xa          # 0045c17d
L_0045c184:
    # block 0x0045c184: entered by je at 0x0045c0b7, 6 instruction(s), ends with ret 0xc
    mov eax, dword ptr [ebp - local_5c]          # 0045c184
    pop edi                                      # 0045c187
    pop esi                                      # 0045c188
    {load} mov esp, ebp                          # 0045c189
    pop ebp                                      # 0045c18b
    ret 0xc                                      # 0045c18c

