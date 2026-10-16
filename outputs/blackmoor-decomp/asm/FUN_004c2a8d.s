# FUN_004c2a8d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c2a8d
# extent:       0x004c2a8d-0x004c2c3a (429 code bytes)
# span:         0x004c2a8d-0x004c2c3a (code 429, tables 0, padding 0)
# sha256:       9e30a70ee2613a1ea7fb608e88a98b56478e5c3e71814992f28c9609cc451f75
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c2a8d
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_4, field_8, field_c, field_18, field_21, field_31, field_39; [ecx + n] field_4, field_23, field_27, field_2d, field_41, field_55; [edx + n] field_2b, field_2f, field_33, field_35, field_3d
# callees:      calls FUN_0051dc43, FUN_0042639d, FUN_004c97b4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 136 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_27, 0x27  # offset +0x27
.equ field_2b, 0x2b  # offset +0x2b
.equ field_2d, 0x2d  # offset +0x2d
.equ field_2f, 0x2f  # offset +0x2f
.equ field_31, 0x31  # offset +0x31
.equ field_33, 0x33  # offset +0x33
.equ field_35, 0x35  # offset +0x35
.equ field_39, 0x39  # offset +0x39
.equ field_3d, 0x3d  # offset +0x3d
.equ field_41, 0x41  # offset +0x41
.equ field_55, 0x55  # offset +0x55

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004c2a8d - 0x401000
.globl FUN_004c2a8d
FUN_004c2a8d:
    # block 0x004c2a8d: entry, 14 instruction(s), calls FUN_0051dc43, ends with jne to 0x004c2ad3 (forward)
    push ebp                                     # 004c2a8d
    {load} mov ebp, esp                          # 004c2a8e
    sub esp, 0x14                                # 004c2a90
    push esi                                     # 004c2a93
    push edi                                     # 004c2a94
    mov dword ptr [ebp - local_14], ecx          # 004c2a95
    push 0x59                                    # 004c2a98
    call FUN_0051dc43                            # 004c2a9a
    add esp, 0x4                                 # 004c2a9f
    mov dword ptr [ebp - local_c], eax           # 004c2aa2
    mov eax, dword ptr [ebp - local_c]           # 004c2aa5
    mov dword ptr [ebp - local_8], eax           # 004c2aa8
    cmp dword ptr [ebp - local_8], 0x0           # 004c2aab
    jne.d8 L_004c2ad3                            # 004c2aaf
    # block 0x004c2ab1: entered by fall-through of jne at 0x004c2aaf, 9 instruction(s), calls FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004c2c32
    mov ecx, dword ptr [ebp + arg_14]            # 004c2ab1
    push ecx                                     # 004c2ab4
    push 0x553dbc                                # 004c2ab5
    mov ecx, 0x583979                            # 004c2aba
    call FUN_0042639d                            # 004c2abf
    mov ecx, dword ptr [ebp - local_14]          # 004c2ac4
    call FUN_004c97b4                            # 004c2ac7
    {load} xor eax, eax                          # 004c2acc
    jmp.d32 L_004c2c32                           # 004c2ace
L_004c2ad3:
    # block 0x004c2ad3: entered by jne at 0x004c2aaf, 21 instruction(s), calls FUN_0051dc43, ends with jne to 0x004c2b37 (forward)
    mov ecx, 0x16                                # 004c2ad3
    {load} xor eax, eax                          # 004c2ad8
    mov edi, dword ptr [ebp - local_8]           # 004c2ada
    rep stosd dword ptr es:[edi], eax            # 004c2add
    stosb byte ptr es:[edi], al                  # 004c2adf
    movsx edx, word ptr [ebp + arg_8]            # 004c2ae0
    movsx eax, word ptr [0x639895]               # 004c2ae4
    imul edx, eax                                # 004c2aeb
    movsx ecx, word ptr [ebp + arg_c]            # 004c2aee
    imul edx, ecx                                # 004c2af2
    mov dword ptr [ebp - local_4], edx           # 004c2af5
    mov edx, dword ptr [ebp - local_4]           # 004c2af8
    push edx                                     # 004c2afb
    call FUN_0051dc43                            # 004c2afc
    add esp, 0x4                                 # 004c2b01
    mov dword ptr [ebp - local_10], eax          # 004c2b04
    mov eax, dword ptr [ebp - local_8]           # 004c2b07
    mov ecx, dword ptr [ebp - local_10]          # 004c2b0a
    mov dword ptr [eax], ecx                     # 004c2b0d
    cmp dword ptr [ebp - local_10], 0x0          # 004c2b0f
    jne.d8 L_004c2b37                            # 004c2b13
    # block 0x004c2b15: entered by fall-through of jne at 0x004c2b13, 9 instruction(s), calls FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004c2c32
    mov edx, dword ptr [ebp + arg_14]            # 004c2b15
    push edx                                     # 004c2b18
    push 0x553e14                                # 004c2b19
    mov ecx, 0x583979                            # 004c2b1e
    call FUN_0042639d                            # 004c2b23
    mov ecx, dword ptr [ebp - local_14]          # 004c2b28
    call FUN_004c97b4                            # 004c2b2b
    {load} xor eax, eax                          # 004c2b30
    jmp.d32 L_004c2c32                           # 004c2b32
L_004c2b37:
    # block 0x004c2b37: entered by jne at 0x004c2b13, 8 instruction(s), ends with jb to 0x004c2b52 (forward)
    mov edi, dword ptr [ebp + arg_14]            # 004c2b37
    or ecx, -0x1                                 # 004c2b3a
    {load} xor eax, eax                          # 004c2b3d
    repne scasb al, byte ptr es:[edi]            # 004c2b3f
    not ecx                                      # 004c2b41
    add ecx, -0x1                                # 004c2b43
    cmp ecx, 0x19                                # 004c2b46
    jb.d8 L_004c2b52                             # 004c2b49
    # block 0x004c2b4b: entered by fall-through of jb at 0x004c2b49, 2 instruction(s), falls into the block at 0x004c2b52
    mov eax, dword ptr [ebp + arg_14]            # 004c2b4b
    mov byte ptr [eax + field_18], 0x0           # 004c2b4e
L_004c2b52:
    # block 0x004c2b52: entered by jb at 0x004c2b49, 68 instruction(s), falls into the block at 0x004c2c32
    mov edi, dword ptr [ebp + arg_14]            # 004c2b52
    mov ecx, dword ptr [ebp - local_8]           # 004c2b55
    add ecx, 0x8                                 # 004c2b58
    {load} mov edx, ecx                          # 004c2b5b
    or ecx, -0x1                                 # 004c2b5d
    {load} xor eax, eax                          # 004c2b60
    repne scasb al, byte ptr es:[edi]            # 004c2b62
    not ecx                                      # 004c2b64
    {load} sub edi, ecx                          # 004c2b66
    {load} mov esi, edi                          # 004c2b68
    {load} mov eax, ecx                          # 004c2b6a
    {load} mov edi, edx                          # 004c2b6c
    shr ecx, 0x2                                 # 004c2b6e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004c2b71
    {load} mov ecx, eax                          # 004c2b73
    and ecx, 0x3                                 # 004c2b75
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004c2b78
    mov ecx, dword ptr [ebp - local_8]           # 004c2b7a
    mov edx, dword ptr [ebp + arg_10]            # 004c2b7d
    mov dword ptr [ecx + field_4], edx           # 004c2b80
    mov eax, dword ptr [ebp - local_8]           # 004c2b83
    mov word ptr [eax + field_21], 0x59          # 004c2b86
    mov ecx, dword ptr [ebp - local_8]           # 004c2b8c
    mov edx, dword ptr [ebp - local_4]           # 004c2b8f
    mov dword ptr [ecx + field_23], edx          # 004c2b92
    mov eax, dword ptr [ebp - local_4]           # 004c2b95
    add eax, 0x59                                # 004c2b98
    mov ecx, dword ptr [ebp - local_8]           # 004c2b9b
    mov dword ptr [ecx + field_27], eax          # 004c2b9e
    mov edx, dword ptr [ebp - local_8]           # 004c2ba1
    mov ax, word ptr [ebp + arg_8]               # 004c2ba4
    mov word ptr [edx + field_2b], ax            # 004c2ba8
    mov ecx, dword ptr [ebp - local_8]           # 004c2bac
    mov dx, word ptr [ebp + arg_c]               # 004c2baf
    mov word ptr [ecx + field_2d], dx            # 004c2bb3
    movsx eax, word ptr [ebp + arg_8]            # 004c2bb7
    movsx ecx, word ptr [0x639895]               # 004c2bbb
    imul eax, ecx                                # 004c2bc2
    mov edx, dword ptr [ebp - local_8]           # 004c2bc5
    mov word ptr [edx + field_2f], ax            # 004c2bc8
    mov eax, dword ptr [ebp - local_8]           # 004c2bcc
    mov cx, word ptr [ebp + arg_c]               # 004c2bcf
    mov word ptr [eax + field_31], cx            # 004c2bd3
    mov edx, dword ptr [ebp - local_8]           # 004c2bd7
    mov ax, word ptr [0x639893]                  # 004c2bda
    mov word ptr [edx + field_33], ax            # 004c2be0
    mov ecx, dword ptr [ebp - local_8]           # 004c2be4
    mov dword ptr [ecx + field_55], 0x0          # 004c2be7
    mov edx, dword ptr [ebp - local_8]           # 004c2bee
    mov dword ptr [edx + field_35], 0x0          # 004c2bf1
    mov eax, dword ptr [ebp - local_8]           # 004c2bf8
    mov dword ptr [eax + field_39], 0x0          # 004c2bfb
    movsx ecx, word ptr [ebp + arg_8]            # 004c2c02
    sub ecx, 0x1                                 # 004c2c06
    mov edx, dword ptr [ebp - local_8]           # 004c2c09
    mov dword ptr [edx + field_3d], ecx          # 004c2c0c
    movsx eax, word ptr [ebp + arg_c]            # 004c2c0f
    sub eax, 0x1                                 # 004c2c13
    mov ecx, dword ptr [ebp - local_8]           # 004c2c16
    mov dword ptr [ecx + field_41], eax          # 004c2c19
    {load} xor edx, edx                          # 004c2c1c
    mov eax, dword ptr [ebp - local_8]           # 004c2c1e
    add eax, 0x45                                # 004c2c21
    mov dword ptr [eax], edx                     # 004c2c24
    mov dword ptr [eax + field_4], edx           # 004c2c26
    mov dword ptr [eax + field_8], edx           # 004c2c29
    mov dword ptr [eax + field_c], edx           # 004c2c2c
    mov eax, dword ptr [ebp - local_8]           # 004c2c2f
L_004c2c32:
    # block 0x004c2c32: entered by jmp at 0x004c2ace; jmp at 0x004c2b32, 5 instruction(s), ends with ret 0x10
    pop edi                                      # 004c2c32
    pop esi                                      # 004c2c33
    {load} mov esp, ebp                          # 004c2c34
    pop ebp                                      # 004c2c36
    ret 0x10                                     # 004c2c37

