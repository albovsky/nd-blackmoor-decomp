# FUN_004b8a27
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b8a27
# extent:       0x004b8a27-0x004b8d5e (823 code bytes)
# span:         0x004b8a27-0x004b8d5e (code 823, tables 0, padding 0)
# sha256:       e5513c74173b872d934d00fa4e70224b80ad23ba086b696c810f13b938123bfa
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b8a27
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_4, field_8, field_c, field_23, field_48, field_5a, field_5e, field_62, field_6b, field_6f, field_7b; [ecx + n] field_4, field_8, field_c, field_48, field_4a, field_5a, field_6a, field_77, field_7d, field_452, field_454, field_456; [edi + n] field_5a, field_5e; [edx + n] field_4, field_8, field_c, field_21, field_48, field_62, field_66, field_173, field_452, field_456, field_458; [esi + n] field_62, field_66, field_175
# callees:      calls FUN_0050cd50, FUN_004b866e, FUN_004b85f6, KERNEL32.dll!GetTickCount
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 242 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_48, 0x48  # offset +0x48
.equ field_4a, 0x4a  # offset +0x4a
.equ field_5a, 0x5a  # offset +0x5a
.equ field_5e, 0x5e  # offset +0x5e
.equ field_62, 0x62  # offset +0x62
.equ field_66, 0x66  # offset +0x66
.equ field_6a, 0x6a  # offset +0x6a
.equ field_6b, 0x6b  # offset +0x6b
.equ field_6f, 0x6f  # offset +0x6f
.equ field_77, 0x77  # offset +0x77
.equ field_7b, 0x7b  # offset +0x7b
.equ field_7d, 0x7d  # offset +0x7d
.equ field_173, 0x173  # offset +0x173
.equ field_175, 0x175  # offset +0x175
.equ field_452, 0x452  # offset +0x452
.equ field_454, 0x454  # offset +0x454
.equ field_456, 0x456  # offset +0x456
.equ field_458, 0x458  # offset +0x458

# --- external targets -----------------------------------------------
.set FUN_004b85f6, .text + (0x004b85f6 - 0x401000)
.set FUN_004b866e, .text + (0x004b866e - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x004b8a27 - 0x401000
.globl FUN_004b8a27
FUN_004b8a27:
    # block 0x004b8a27: entry, 15 instruction(s), ends with jge to 0x004b8a66 (forward)
    push ebp                                     # 004b8a27
    {load} mov ebp, esp                          # 004b8a28
    sub esp, 0x10                                # 004b8a2a
    push esi                                     # 004b8a2d
    push edi                                     # 004b8a2e
    mov dword ptr [ebp - local_10], ecx          # 004b8a2f
    mov eax, dword ptr [ebp - local_10]          # 004b8a32
    movsx ecx, word ptr [eax + field_48]         # 004b8a35
    movsx edx, word ptr [ebp + arg_8]            # 004b8a39
    {load} add ecx, edx                          # 004b8a3d
    mov eax, dword ptr [ebp - local_10]          # 004b8a3f
    mov edx, dword ptr [eax + field_8]           # 004b8a42
    movsx eax, word ptr [edx + field_456]        # 004b8a45
    {load} cmp ecx, eax                          # 004b8a4c
    jge.d8 L_004b8a66                            # 004b8a4e
    # block 0x004b8a50: entered by fall-through of jge at 0x004b8a4e, 6 instruction(s), ends with forward jump to 0x004b8adc
    mov ecx, dword ptr [ebp - local_10]          # 004b8a50
    mov edx, dword ptr [ecx + field_8]           # 004b8a53
    mov eax, dword ptr [ebp - local_10]          # 004b8a56
    mov cx, word ptr [edx + field_456]           # 004b8a59
    mov word ptr [eax + field_48], cx            # 004b8a60
    jmp.d8 L_004b8adc                            # 004b8a64
L_004b8a66:
    # block 0x004b8a66: entered by jge at 0x004b8a4e, 6 instruction(s), calls FUN_0050cd50, falls into the block at 0x004b8a79
    call FUN_0050cd50                            # 004b8a66
    movsx ecx, word ptr [ebp + arg_8]            # 004b8a6b
    add ecx, 0x1                                 # 004b8a6f
    cdq                                          # 004b8a72
    idiv ecx                                     # 004b8a73
    mov word ptr [ebp - local_c], dx             # 004b8a75
L_004b8a79:
    # block 0x004b8a79: entered by jmp at 0x004b8ac8, 9 instruction(s), ends with jl to 0x004b8ab5 (forward)
    mov edx, dword ptr [ebp - local_10]          # 004b8a79
    movsx eax, word ptr [edx + field_48]         # 004b8a7c
    movsx ecx, word ptr [ebp - local_c]          # 004b8a80
    {load} add eax, ecx                          # 004b8a84
    mov edx, dword ptr [ebp - local_10]          # 004b8a86
    mov ecx, dword ptr [edx + field_8]           # 004b8a89
    movsx edx, word ptr [ecx + field_456]        # 004b8a8c
    {load} cmp eax, edx                          # 004b8a93
    jl.d8 L_004b8ab5                             # 004b8a95
    # block 0x004b8a97: entered by fall-through of jl at 0x004b8a95, 9 instruction(s), ends with jle to 0x004b8aca (forward)
    mov eax, dword ptr [ebp - local_10]          # 004b8a97
    movsx ecx, word ptr [eax + field_48]         # 004b8a9a
    movsx edx, word ptr [ebp - local_c]          # 004b8a9e
    {load} add ecx, edx                          # 004b8aa2
    mov eax, dword ptr [ebp - local_10]          # 004b8aa4
    mov edx, dword ptr [eax + field_8]           # 004b8aa7
    movsx eax, word ptr [edx + field_458]        # 004b8aaa
    {load} cmp ecx, eax                          # 004b8ab1
    jle.d8 L_004b8aca                            # 004b8ab3
L_004b8ab5:
    # block 0x004b8ab5: entered by jl at 0x004b8a95; fall-through of jle at 0x004b8ab3, 7 instruction(s), calls FUN_0050cd50, ends with backward jump to 0x004b8a79
    call FUN_0050cd50                            # 004b8ab5
    movsx ecx, word ptr [ebp + arg_8]            # 004b8aba
    add ecx, 0x1                                 # 004b8abe
    cdq                                          # 004b8ac1
    idiv ecx                                     # 004b8ac2
    mov word ptr [ebp - local_c], dx             # 004b8ac4
    jmp.d8 L_004b8a79                            # 004b8ac8
L_004b8aca:
    # block 0x004b8aca: entered by jle at 0x004b8ab3, 5 instruction(s), falls into the block at 0x004b8adc
    mov edx, dword ptr [ebp - local_10]          # 004b8aca
    mov ax, word ptr [edx + field_48]            # 004b8acd
    add ax, word ptr [ebp - local_c]             # 004b8ad1
    mov ecx, dword ptr [ebp - local_10]          # 004b8ad5
    mov word ptr [ecx + field_48], ax            # 004b8ad8
L_004b8adc:
    # block 0x004b8adc: entered by jmp at 0x004b8a64, 2 instruction(s), ends with forward jump to 0x004b8af0
    mov word ptr [ebp - local_8], 0x0            # 004b8adc
    jmp.d8 L_004b8af0                            # 004b8ae2
L_004b8ae4:
    # block 0x004b8ae4: entered by jmp at 0x004b8d51, 3 instruction(s), falls into the block at 0x004b8af0
    mov dx, word ptr [ebp - local_8]             # 004b8ae4
    add dx, 0x1                                  # 004b8ae8
    mov word ptr [ebp - local_8], dx             # 004b8aec
L_004b8af0:
    # block 0x004b8af0: entered by jmp at 0x004b8ae2, 6 instruction(s), ends with jge to 0x004b8d56 (forward)
    movsx eax, word ptr [ebp - local_8]          # 004b8af0
    mov ecx, dword ptr [ebp - local_10]          # 004b8af4
    mov edx, dword ptr [ecx + field_8]           # 004b8af7
    movsx ecx, word ptr [edx + field_173]        # 004b8afa
    {load} cmp eax, ecx                          # 004b8b01
    jge.d32 L_004b8d56                           # 004b8b03
    # block 0x004b8b09: entered by fall-through of jge at 0x004b8b03, 3 instruction(s), ends with jle to 0x004b8d56 (forward)
    movsx edx, word ptr [ebp - local_c]          # 004b8b09
    test edx, edx                                # 004b8b0d
    jle.d32 L_004b8d56                           # 004b8b0f
    # block 0x004b8b15: entered by fall-through of jle at 0x004b8b0f, 5 instruction(s), ends with jne to 0x004b8d51 (forward)
    movsx eax, word ptr [ebp - local_8]          # 004b8b15
    imul eax, eax, 0x37                          # 004b8b19
    mov ecx, dword ptr [ebp - local_10]          # 004b8b1c
    cmp dword ptr [ecx + eax + field_7d], 0x0    # 004b8b1f
    jne.d32 L_004b8d51                           # 004b8b24
    # block 0x004b8b2a: entered by fall-through of jne at 0x004b8b24, 160 instruction(s), calls FUN_004b866e, FUN_0050cd50, FUN_004b85f6, KERNEL32.dll!GetTickCount, falls into the block at 0x004b8d51
    mov edx, dword ptr [ebp - local_10]          # 004b8b2a
    mov esi, dword ptr [edx + field_8]           # 004b8b2d
    mov ecx, dword ptr [ebp - local_10]          # 004b8b30
    call FUN_004b866e                            # 004b8b33
    movsx eax, ax                                # 004b8b38
    shl eax, 0x4                                 # 004b8b3b
    lea ecx, [esi + eax + field_175]             # 004b8b3e
    movsx edx, word ptr [ebp - local_8]          # 004b8b45
    imul edx, edx, 0x37                          # 004b8b49
    mov eax, dword ptr [ebp - local_10]          # 004b8b4c
    lea edx, [eax + edx + field_5a]              # 004b8b4f
    mov eax, dword ptr [ecx]                     # 004b8b53
    mov dword ptr [edx], eax                     # 004b8b55
    mov eax, dword ptr [ecx + field_4]           # 004b8b57
    mov dword ptr [edx + field_4], eax           # 004b8b5a
    mov eax, dword ptr [ecx + field_8]           # 004b8b5d
    mov dword ptr [edx + field_8], eax           # 004b8b60
    mov ecx, dword ptr [ecx + field_c]           # 004b8b63
    mov dword ptr [edx + field_c], ecx           # 004b8b66
    movsx edx, word ptr [ebp - local_8]          # 004b8b69
    imul edx, edx, 0x37                          # 004b8b6d
    mov eax, dword ptr [ebp - local_10]          # 004b8b70
    mov ecx, dword ptr [eax + edx + field_5e]    # 004b8b73
    add ecx, dword ptr [0x58318a]                # 004b8b77
    movsx edx, word ptr [ebp - local_8]          # 004b8b7d
    imul edx, edx, 0x37                          # 004b8b81
    mov eax, dword ptr [ebp - local_10]          # 004b8b84
    mov dword ptr [eax + edx + field_5e], ecx    # 004b8b87
    movsx ecx, word ptr [ebp - local_8]          # 004b8b8b
    imul ecx, ecx, 0x37                          # 004b8b8f
    mov edx, dword ptr [ebp - local_10]          # 004b8b92
    mov eax, dword ptr [edx + ecx + field_66]    # 004b8b95
    add eax, dword ptr [0x58318a]                # 004b8b99
    movsx ecx, word ptr [ebp - local_8]          # 004b8b9f
    imul ecx, ecx, 0x37                          # 004b8ba3
    mov edx, dword ptr [ebp - local_10]          # 004b8ba6
    mov dword ptr [edx + ecx + field_66], eax    # 004b8ba9
    movsx eax, word ptr [ebp - local_8]          # 004b8bad
    imul eax, eax, 0x37                          # 004b8bb1
    mov ecx, dword ptr [ebp - local_10]          # 004b8bb4
    mov edx, dword ptr [ecx + eax + field_5a]    # 004b8bb7
    add edx, dword ptr [0x583186]                # 004b8bbb
    movsx eax, word ptr [ebp - local_8]          # 004b8bc1
    imul eax, eax, 0x37                          # 004b8bc5
    mov ecx, dword ptr [ebp - local_10]          # 004b8bc8
    mov dword ptr [ecx + eax + field_5a], edx    # 004b8bcb
    movsx edx, word ptr [ebp - local_8]          # 004b8bcf
    imul edx, edx, 0x37                          # 004b8bd3
    mov eax, dword ptr [ebp - local_10]          # 004b8bd6
    mov ecx, dword ptr [eax + edx + field_62]    # 004b8bd9
    add ecx, dword ptr [0x583186]                # 004b8bdd
    movsx edx, word ptr [ebp - local_8]          # 004b8be3
    imul edx, edx, 0x37                          # 004b8be7
    mov eax, dword ptr [ebp - local_10]          # 004b8bea
    mov dword ptr [eax + edx + field_62], ecx    # 004b8bed
    movsx ecx, word ptr [ebp - local_8]          # 004b8bf1
    imul ecx, ecx, 0x37                          # 004b8bf5
    movsx edx, word ptr [ebp - local_8]          # 004b8bf8
    imul edx, edx, 0x37                          # 004b8bfc
    movsx eax, word ptr [ebp - local_8]          # 004b8bff
    imul eax, eax, 0x37                          # 004b8c03
    mov esi, dword ptr [ebp - local_10]          # 004b8c06
    mov edi, dword ptr [ebp - local_10]          # 004b8c09
    mov edx, dword ptr [esi + edx + field_66]    # 004b8c0c
    sub edx, dword ptr [edi + eax + field_5e]    # 004b8c10
    {load} mov eax, edx                          # 004b8c14
    cdq                                          # 004b8c16
    {load} sub eax, edx                          # 004b8c17
    sar eax                                      # 004b8c19
    mov edx, dword ptr [ebp - local_10]          # 004b8c1b
    mov ecx, dword ptr [edx + ecx + field_66]    # 004b8c1e
    {load} sub ecx, eax                          # 004b8c22
    add ecx, 0x6                                 # 004b8c24
    movsx edx, word ptr [ebp - local_8]          # 004b8c27
    imul edx, edx, 0x37                          # 004b8c2b
    mov eax, dword ptr [ebp - local_10]          # 004b8c2e
    mov dword ptr [eax + edx + field_6f], ecx    # 004b8c31
    movsx ecx, word ptr [ebp - local_8]          # 004b8c35
    imul ecx, ecx, 0x37                          # 004b8c39
    movsx edx, word ptr [ebp - local_8]          # 004b8c3c
    imul edx, edx, 0x37                          # 004b8c40
    movsx eax, word ptr [ebp - local_8]          # 004b8c43
    imul eax, eax, 0x37                          # 004b8c47
    mov esi, dword ptr [ebp - local_10]          # 004b8c4a
    mov edi, dword ptr [ebp - local_10]          # 004b8c4d
    mov edx, dword ptr [esi + edx + field_62]    # 004b8c50
    sub edx, dword ptr [edi + eax + field_5a]    # 004b8c54
    {load} mov eax, edx                          # 004b8c58
    cdq                                          # 004b8c5a
    {load} sub eax, edx                          # 004b8c5b
    sar eax                                      # 004b8c5d
    mov edx, dword ptr [ebp - local_10]          # 004b8c5f
    mov ecx, dword ptr [edx + ecx + field_62]    # 004b8c62
    {load} sub ecx, eax                          # 004b8c66
    sub ecx, 0x8                                 # 004b8c68
    movsx edx, word ptr [ebp - local_8]          # 004b8c6b
    imul edx, edx, 0x37                          # 004b8c6f
    mov eax, dword ptr [ebp - local_10]          # 004b8c72
    mov dword ptr [eax + edx + field_6b], ecx    # 004b8c75
    call FUN_0050cd50                            # 004b8c79
    mov ecx, dword ptr [ebp - local_10]          # 004b8c7e
    mov edx, dword ptr [ecx + field_8]           # 004b8c81
    movsx ecx, word ptr [edx + field_21]         # 004b8c84
    cdq                                          # 004b8c88
    idiv ecx                                     # 004b8c89
    mov word ptr [ebp - local_4], dx             # 004b8c8b
    mov edx, dword ptr [ebp - local_10]          # 004b8c8f
    mov eax, dword ptr [edx + field_8]           # 004b8c92
    movsx ecx, word ptr [ebp - local_4]          # 004b8c95
    shl ecx, 0x4                                 # 004b8c99
    lea edx, [eax + ecx + field_23]              # 004b8c9c
    movsx eax, word ptr [ebp - local_8]          # 004b8ca0
    imul eax, eax, 0x37                          # 004b8ca4
    mov ecx, dword ptr [ebp - local_10]          # 004b8ca7
    lea eax, [ecx + eax + field_4a]              # 004b8caa
    mov ecx, dword ptr [edx]                     # 004b8cae
    mov dword ptr [eax], ecx                     # 004b8cb0
    mov ecx, dword ptr [edx + field_4]           # 004b8cb2
    mov dword ptr [eax + field_4], ecx           # 004b8cb5
    mov ecx, dword ptr [edx + field_8]           # 004b8cb8
    mov dword ptr [eax + field_8], ecx           # 004b8cbb
    mov edx, dword ptr [edx + field_c]           # 004b8cbe
    mov dword ptr [eax + field_c], edx           # 004b8cc1
    movsx eax, word ptr [ebp - local_8]          # 004b8cc4
    imul eax, eax, 0x37                          # 004b8cc8
    mov ecx, dword ptr [ebp - local_10]          # 004b8ccb
    mov dword ptr [ecx + eax + field_7d], 0x1    # 004b8cce
    mov ecx, dword ptr [ebp - local_10]          # 004b8cd6
    call FUN_004b85f6                            # 004b8cd9
    movsx edx, word ptr [ebp - local_8]          # 004b8cde
    imul edx, edx, 0x37                          # 004b8ce2
    mov ecx, dword ptr [ebp - local_10]          # 004b8ce5
    mov byte ptr [ecx + edx + field_6a], al      # 004b8ce8
    call dword ptr [0x52a23c]                    # 004b8cec
    movsx edx, word ptr [ebp - local_8]          # 004b8cf2
    imul edx, edx, 0x37                          # 004b8cf6
    mov ecx, dword ptr [ebp - local_10]          # 004b8cf9
    mov dword ptr [ecx + edx + field_77], eax    # 004b8cfc
    call FUN_0050cd50                            # 004b8d00
    mov edx, dword ptr [ebp - local_10]          # 004b8d05
    mov ecx, dword ptr [edx + field_8]           # 004b8d08
    movsx ecx, word ptr [ecx + field_454]        # 004b8d0b
    add ecx, 0x1                                 # 004b8d12
    mov edx, dword ptr [ebp - local_10]          # 004b8d15
    mov edx, dword ptr [edx + field_8]           # 004b8d18
    movsx edx, word ptr [edx + field_452]        # 004b8d1b
    {load} sub ecx, edx                          # 004b8d22
    cdq                                          # 004b8d24
    idiv ecx                                     # 004b8d25
    mov eax, dword ptr [ebp - local_10]          # 004b8d27
    mov ecx, dword ptr [eax + field_8]           # 004b8d2a
    movsx eax, word ptr [ecx + field_452]        # 004b8d2d
    {load} add edx, eax                          # 004b8d34
    movsx ecx, word ptr [ebp - local_8]          # 004b8d36
    imul ecx, ecx, 0x37                          # 004b8d3a
    mov eax, dword ptr [ebp - local_10]          # 004b8d3d
    mov word ptr [eax + ecx + field_7b], dx      # 004b8d40
    mov cx, word ptr [ebp - local_c]             # 004b8d45
    sub cx, 0x1                                  # 004b8d49
    mov word ptr [ebp - local_c], cx             # 004b8d4d
L_004b8d51:
    # block 0x004b8d51: entered by jne at 0x004b8b24, 1 instruction(s), ends with backward jump to 0x004b8ae4
    jmp.d32 L_004b8ae4                           # 004b8d51
L_004b8d56:
    # block 0x004b8d56: entered by jge at 0x004b8b03; jle at 0x004b8b0f, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004b8d56
    pop esi                                      # 004b8d57
    {load} mov esp, ebp                          # 004b8d58
    pop ebp                                      # 004b8d5a
    ret 0x4                                      # 004b8d5b

