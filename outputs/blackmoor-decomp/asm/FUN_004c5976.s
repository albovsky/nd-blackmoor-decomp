# FUN_004c5976
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c5976
# extent:       0x004c5976-0x004c5b3a (452 code bytes)
# span:         0x004c5976-0x004c5b3a (code 452, tables 0, padding 0)
# sha256:       11fbfe0a89cf889969ccefa40b81437157b936950980ed6c801aca695535f73c
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c5976
# arguments:    6 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c; ret 0x18 (callee pops 24 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       11 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_114, local_118, local_11c, local_120, local_124
# fields:       [eax + n] field_4, field_c, field_2f; [ecx + n] field_4, field_8, field_c, field_2f; [edx + n] field_4, field_8, field_c
# callees:      calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 148 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_114, 0x114  # offset -0x114
.equ local_118, 0x118  # offset -0x118
.equ local_11c, 0x11c  # offset -0x11c
.equ local_120, 0x120  # offset -0x120
.equ local_124, 0x124  # offset -0x124
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ field_2f, 0x2f  # offset +0x2f

# --- external targets -----------------------------------------------
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004c5976 - 0x401000
.globl FUN_004c5976
FUN_004c5976:
    # block 0x004c5976: entry, 9 instruction(s), ends with je to 0x004c5a6c (forward)
    push ebp                                     # 004c5976
    {load} mov ebp, esp                          # 004c5977
    sub esp, 0x124                               # 004c5979
    push esi                                     # 004c597f
    push edi                                     # 004c5980
    mov dword ptr [ebp - local_124], ecx         # 004c5981
    movsx eax, word ptr [0x63a4cd]               # 004c5987
    test eax, eax                                # 004c598e
    je.d32 L_004c5a6c                            # 004c5990
    # block 0x004c5996: entered by fall-through of je at 0x004c5990, 23 instruction(s), ends with jne to 0x004c59fe (forward)
    mov ecx, dword ptr [ebp + arg_10]            # 004c5996
    mov edx, dword ptr [ebp + arg_10]            # 004c5999
    mov eax, dword ptr [ecx + field_8]           # 004c599c
    sub eax, dword ptr [edx]                     # 004c599f
    mov dword ptr [ebp - local_120], eax         # 004c59a1
    mov ecx, dword ptr [ebp + arg_10]            # 004c59a7
    mov edx, dword ptr [ebp + arg_10]            # 004c59aa
    mov eax, dword ptr [ecx + field_c]           # 004c59ad
    sub eax, dword ptr [edx + field_4]           # 004c59b0
    mov dword ptr [ebp - local_11c], eax         # 004c59b3
    mov ecx, dword ptr [ebp + arg_14]            # 004c59b9
    mov edx, dword ptr [ebp + arg_14]            # 004c59bc
    mov eax, dword ptr [ecx + field_8]           # 004c59bf
    sub eax, dword ptr [edx]                     # 004c59c2
    mov dword ptr [ebp - local_18], eax          # 004c59c4
    mov ecx, dword ptr [ebp + arg_14]            # 004c59c7
    mov edx, dword ptr [ebp + arg_14]            # 004c59ca
    mov eax, dword ptr [ecx + field_c]           # 004c59cd
    sub eax, dword ptr [edx + field_4]           # 004c59d0
    mov dword ptr [ebp - local_118], eax         # 004c59d3
    mov ecx, dword ptr [ebp - local_120]         # 004c59d9
    cmp ecx, dword ptr [ebp - local_18]          # 004c59df
    jne.d8 L_004c59fe                            # 004c59e2
    # block 0x004c59e4: entered by fall-through of jne at 0x004c59e2, 3 instruction(s), ends with jne to 0x004c59fe (forward)
    mov edx, dword ptr [ebp - local_11c]         # 004c59e4
    cmp edx, dword ptr [ebp - local_118]         # 004c59ea
    jne.d8 L_004c59fe                            # 004c59f0
    # block 0x004c59f2: entered by fall-through of jne at 0x004c59f0, 2 instruction(s), ends with je to 0x004c59fe (forward)
    cmp dword ptr [ebp + arg_8], 0x0             # 004c59f2
    je.d8 L_004c59fe                             # 004c59f6
    # block 0x004c59f8: entered by fall-through of je at 0x004c59f6, 2 instruction(s), ends with jne to 0x004c5a6c (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 004c59f8
    jne.d8 L_004c5a6c                            # 004c59fc
L_004c59fe:
    # block 0x004c59fe: entered by jne at 0x004c59e2; jne at 0x004c59f0; je at 0x004c59f6; fall-through of jne at 0x004c59fc, 39 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, ends with forward jump to 0x004c5b32
    mov eax, dword ptr [ebp + arg_14]            # 004c59fe
    mov ecx, dword ptr [eax + field_c]           # 004c5a01
    push ecx                                     # 004c5a04
    mov edx, dword ptr [ebp + arg_14]            # 004c5a05
    mov eax, dword ptr [edx + field_8]           # 004c5a08
    push eax                                     # 004c5a0b
    mov ecx, dword ptr [ebp + arg_14]            # 004c5a0c
    mov edx, dword ptr [ecx + field_4]           # 004c5a0f
    push edx                                     # 004c5a12
    mov eax, dword ptr [ebp + arg_14]            # 004c5a13
    mov ecx, dword ptr [eax]                     # 004c5a16
    push ecx                                     # 004c5a18
    mov edx, dword ptr [ebp + arg_10]            # 004c5a19
    mov eax, dword ptr [edx + field_c]           # 004c5a1c
    push eax                                     # 004c5a1f
    mov ecx, dword ptr [ebp + arg_10]            # 004c5a20
    mov edx, dword ptr [ecx + field_8]           # 004c5a23
    push edx                                     # 004c5a26
    mov eax, dword ptr [ebp + arg_10]            # 004c5a27
    mov ecx, dword ptr [eax + field_4]           # 004c5a2a
    push ecx                                     # 004c5a2d
    mov edx, dword ptr [ebp + arg_10]            # 004c5a2e
    mov eax, dword ptr [edx]                     # 004c5a31
    push eax                                     # 004c5a33
    mov ecx, dword ptr [ebp + arg_1c]            # 004c5a34
    push ecx                                     # 004c5a37
    push 0x554b44                                # 004c5a38
    lea edx, [ebp - local_114]                   # 004c5a3d
    push edx                                     # 004c5a43
    call FUN_0050ca3e                            # 004c5a44
    add esp, 0x2c                                # 004c5a49
    push 0x0                                     # 004c5a4c
    push 0x0                                     # 004c5a4e
    lea eax, [ebp - local_114]                   # 004c5a50
    push eax                                     # 004c5a56
    call FUN_0052139c                            # 004c5a57
    mov ecx, dword ptr [ebp - local_124]         # 004c5a5c
    call FUN_004c97b4                            # 004c5a62
    jmp.d32 L_004c5b32                           # 004c5a67
L_004c5a6c:
    # block 0x004c5a6c: entered by je at 0x004c5990; jne at 0x004c59fc, 41 instruction(s), ends with forward jump to 0x004c5af9
    mov ecx, dword ptr [ebp + arg_10]            # 004c5a6c
    mov edx, dword ptr [ecx + field_4]           # 004c5a6f
    imul edx, dword ptr [ebp + arg_18]           # 004c5a72
    mov eax, dword ptr [ebp + arg_8]             # 004c5a76
    {load} add eax, edx                          # 004c5a79
    movsx ecx, word ptr [0x639895]               # 004c5a7b
    mov edx, dword ptr [ebp + arg_10]            # 004c5a82
    mov edx, dword ptr [edx]                     # 004c5a85
    imul edx, ecx                                # 004c5a87
    {load} add eax, edx                          # 004c5a8a
    mov dword ptr [ebp - local_4], eax           # 004c5a8c
    mov eax, dword ptr [ebp + arg_c]             # 004c5a8f
    movsx ecx, word ptr [eax + field_2f]         # 004c5a92
    mov edx, dword ptr [ebp + arg_14]            # 004c5a96
    mov eax, dword ptr [edx + field_4]           # 004c5a99
    imul eax, ecx                                # 004c5a9c
    mov ecx, dword ptr [ebp + arg_c]             # 004c5a9f
    mov edx, dword ptr [ecx]                     # 004c5aa2
    {load} add edx, eax                          # 004c5aa4
    movsx eax, word ptr [0x639895]               # 004c5aa6
    mov ecx, dword ptr [ebp + arg_14]            # 004c5aad
    mov ecx, dword ptr [ecx]                     # 004c5ab0
    imul ecx, eax                                # 004c5ab2
    {load} add edx, ecx                          # 004c5ab5
    mov dword ptr [ebp - local_c], edx           # 004c5ab7
    mov edx, dword ptr [ebp + arg_10]            # 004c5aba
    mov eax, dword ptr [ebp + arg_10]            # 004c5abd
    mov ecx, dword ptr [edx + field_c]           # 004c5ac0
    sub ecx, dword ptr [eax + field_4]           # 004c5ac3
    add ecx, 0x1                                 # 004c5ac6
    mov dword ptr [ebp - local_10], ecx          # 004c5ac9
    mov edx, dword ptr [ebp + arg_10]            # 004c5acc
    mov eax, dword ptr [ebp + arg_10]            # 004c5acf
    mov ecx, dword ptr [edx + field_8]           # 004c5ad2
    sub ecx, dword ptr [eax]                     # 004c5ad5
    add ecx, 0x1                                 # 004c5ad7
    movsx edx, word ptr [0x639895]               # 004c5ada
    imul ecx, edx                                # 004c5ae1
    mov dword ptr [ebp - local_8], ecx           # 004c5ae4
    mov dword ptr [ebp - local_14], 0x0          # 004c5ae7
    jmp.d8 L_004c5af9                            # 004c5aee
L_004c5af0:
    # block 0x004c5af0: entered by jmp at 0x004c5b30, 3 instruction(s), falls into the block at 0x004c5af9
    mov eax, dword ptr [ebp - local_14]          # 004c5af0
    add eax, 0x1                                 # 004c5af3
    mov dword ptr [ebp - local_14], eax          # 004c5af6
L_004c5af9:
    # block 0x004c5af9: entered by jmp at 0x004c5aee, 3 instruction(s), ends with jge to 0x004c5b32 (forward)
    mov ecx, dword ptr [ebp - local_14]          # 004c5af9
    cmp ecx, dword ptr [ebp - local_10]          # 004c5afc
    jge.d8 L_004c5b32                            # 004c5aff
    # block 0x004c5b01: entered by fall-through of jge at 0x004c5aff, 18 instruction(s), ends with backward jump to 0x004c5af0
    mov ecx, dword ptr [ebp - local_8]           # 004c5b01
    mov esi, dword ptr [ebp - local_4]           # 004c5b04
    mov edi, dword ptr [ebp - local_c]           # 004c5b07
    {load} mov edx, ecx                          # 004c5b0a
    shr ecx, 0x2                                 # 004c5b0c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004c5b0f
    {load} mov ecx, edx                          # 004c5b11
    and ecx, 0x3                                 # 004c5b13
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004c5b16
    mov eax, dword ptr [ebp - local_4]           # 004c5b18
    add eax, dword ptr [ebp + arg_18]            # 004c5b1b
    mov dword ptr [ebp - local_4], eax           # 004c5b1e
    mov ecx, dword ptr [ebp + arg_c]             # 004c5b21
    movsx edx, word ptr [ecx + field_2f]         # 004c5b24
    mov eax, dword ptr [ebp - local_c]           # 004c5b28
    {load} add eax, edx                          # 004c5b2b
    mov dword ptr [ebp - local_c], eax           # 004c5b2d
    jmp.d8 L_004c5af0                            # 004c5b30
L_004c5b32:
    # block 0x004c5b32: entered by jmp at 0x004c5a67; jge at 0x004c5aff, 5 instruction(s), ends with ret 0x18
    pop edi                                      # 004c5b32
    pop esi                                      # 004c5b33
    {load} mov esp, ebp                          # 004c5b34
    pop ebp                                      # 004c5b36
    ret 0x18                                     # 004c5b37

