# FUN_004c2c3a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c2c3a
# extent:       0x004c2c3a-0x004c2dfb (449 code bytes)
# span:         0x004c2c3a-0x004c2dfb (code 449, tables 0, padding 0)
# sha256:       85c06c99894a04187283cd32d1bcf32df9e8508bfdc8bfe52413829c60398775
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c2c3a
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; ret 0x14 (callee pops 20 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_21, field_31, field_35, field_3d; [ecx + n] field_4, field_8, field_c, field_23, field_27, field_2d, field_39, field_55; [edx + n] field_18, field_2b, field_2f, field_33, field_41
# callees:      calls FUN_0051dc43, FUN_0042639d, FUN_004c97b4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 144 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ arg_18, 0x18  # offset +0x18
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

.org 0x004c2c3a - 0x401000
.globl FUN_004c2c3a
FUN_004c2c3a:
    # block 0x004c2c3a: entry, 14 instruction(s), calls FUN_0051dc43, ends with jne to 0x004c2c80 (forward)
    push ebp                                     # 004c2c3a
    {load} mov ebp, esp                          # 004c2c3b
    sub esp, 0x14                                # 004c2c3d
    push esi                                     # 004c2c40
    push edi                                     # 004c2c41
    mov dword ptr [ebp - local_14], ecx          # 004c2c42
    push 0x59                                    # 004c2c45
    call FUN_0051dc43                            # 004c2c47
    add esp, 0x4                                 # 004c2c4c
    mov dword ptr [ebp - local_c], eax           # 004c2c4f
    mov eax, dword ptr [ebp - local_c]           # 004c2c52
    mov dword ptr [ebp - local_8], eax           # 004c2c55
    cmp dword ptr [ebp - local_8], 0x0           # 004c2c58
    jne.d8 L_004c2c80                            # 004c2c5c
    # block 0x004c2c5e: entered by fall-through of jne at 0x004c2c5c, 9 instruction(s), calls FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004c2df3
    mov ecx, dword ptr [ebp + arg_18]            # 004c2c5e
    push ecx                                     # 004c2c61
    push 0x553e68                                # 004c2c62
    mov ecx, 0x583979                            # 004c2c67
    call FUN_0042639d                            # 004c2c6c
    mov ecx, dword ptr [ebp - local_14]          # 004c2c71
    call FUN_004c97b4                            # 004c2c74
    {load} xor eax, eax                          # 004c2c79
    jmp.d32 L_004c2df3                           # 004c2c7b
L_004c2c80:
    # block 0x004c2c80: entered by jne at 0x004c2c5c, 15 instruction(s), ends with jne to 0x004c2cf0 (forward)
    mov ecx, 0x16                                # 004c2c80
    {load} xor eax, eax                          # 004c2c85
    mov edi, dword ptr [ebp - local_8]           # 004c2c87
    rep stosd dword ptr es:[edi], eax            # 004c2c8a
    stosb byte ptr es:[edi], al                  # 004c2c8c
    movsx edx, word ptr [ebp + arg_8]            # 004c2c8d
    movsx eax, word ptr [0x639895]               # 004c2c91
    imul edx, eax                                # 004c2c98
    movsx ecx, word ptr [ebp + arg_c]            # 004c2c9b
    imul edx, ecx                                # 004c2c9f
    mov dword ptr [ebp - local_4], edx           # 004c2ca2
    mov edx, dword ptr [ebp + arg_14]            # 004c2ca5
    and edx, 0x1                                 # 004c2ca8
    test edx, edx                                # 004c2cab
    jne.d8 L_004c2cf0                            # 004c2cad
    # block 0x004c2caf: entered by fall-through of jne at 0x004c2cad, 10 instruction(s), calls FUN_0051dc43, ends with jne to 0x004c2cee (forward)
    mov eax, dword ptr [ebp - local_4]           # 004c2caf
    push eax                                     # 004c2cb2
    call FUN_0051dc43                            # 004c2cb3
    add esp, 0x4                                 # 004c2cb8
    mov dword ptr [ebp - local_10], eax          # 004c2cbb
    mov ecx, dword ptr [ebp - local_8]           # 004c2cbe
    mov edx, dword ptr [ebp - local_10]          # 004c2cc1
    mov dword ptr [ecx], edx                     # 004c2cc4
    cmp dword ptr [ebp - local_10], 0x0          # 004c2cc6
    jne.d8 L_004c2cee                            # 004c2cca
    # block 0x004c2ccc: entered by fall-through of jne at 0x004c2cca, 9 instruction(s), calls FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004c2df3
    mov eax, dword ptr [ebp + arg_18]            # 004c2ccc
    push eax                                     # 004c2ccf
    push 0x553ec0                                # 004c2cd0
    mov ecx, 0x583979                            # 004c2cd5
    call FUN_0042639d                            # 004c2cda
    mov ecx, dword ptr [ebp - local_14]          # 004c2cdf
    call FUN_004c97b4                            # 004c2ce2
    {load} xor eax, eax                          # 004c2ce7
    jmp.d32 L_004c2df3                           # 004c2ce9
L_004c2cee:
    # block 0x004c2cee: entered by jne at 0x004c2cca, 1 instruction(s), ends with forward jump to 0x004c2cf9
    jmp.d8 L_004c2cf9                            # 004c2cee
L_004c2cf0:
    # block 0x004c2cf0: entered by jne at 0x004c2cad, 2 instruction(s), falls into the block at 0x004c2cf9
    mov ecx, dword ptr [ebp - local_8]           # 004c2cf0
    mov dword ptr [ecx], 0x0                     # 004c2cf3
L_004c2cf9:
    # block 0x004c2cf9: entered by jmp at 0x004c2cee, 8 instruction(s), ends with jb to 0x004c2d14 (forward)
    mov edi, dword ptr [ebp + arg_18]            # 004c2cf9
    or ecx, -0x1                                 # 004c2cfc
    {load} xor eax, eax                          # 004c2cff
    repne scasb al, byte ptr es:[edi]            # 004c2d01
    not ecx                                      # 004c2d03
    add ecx, -0x1                                # 004c2d05
    cmp ecx, 0x19                                # 004c2d08
    jb.d8 L_004c2d14                             # 004c2d0b
    # block 0x004c2d0d: entered by fall-through of jb at 0x004c2d0b, 2 instruction(s), falls into the block at 0x004c2d14
    mov edx, dword ptr [ebp + arg_18]            # 004c2d0d
    mov byte ptr [edx + field_18], 0x0           # 004c2d10
L_004c2d14:
    # block 0x004c2d14: entered by jb at 0x004c2d0b, 69 instruction(s), falls into the block at 0x004c2df3
    mov edi, dword ptr [ebp + arg_18]            # 004c2d14
    mov eax, dword ptr [ebp - local_8]           # 004c2d17
    add eax, 0x8                                 # 004c2d1a
    {load} mov edx, eax                          # 004c2d1d
    or ecx, -0x1                                 # 004c2d1f
    {load} xor eax, eax                          # 004c2d22
    repne scasb al, byte ptr es:[edi]            # 004c2d24
    not ecx                                      # 004c2d26
    {load} sub edi, ecx                          # 004c2d28
    {load} mov esi, edi                          # 004c2d2a
    {load} mov eax, ecx                          # 004c2d2c
    {load} mov edi, edx                          # 004c2d2e
    shr ecx, 0x2                                 # 004c2d30
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004c2d33
    {load} mov ecx, eax                          # 004c2d35
    and ecx, 0x3                                 # 004c2d37
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004c2d3a
    mov ecx, dword ptr [ebp - local_8]           # 004c2d3c
    mov edx, dword ptr [ebp + arg_10]            # 004c2d3f
    mov dword ptr [ecx + field_4], edx           # 004c2d42
    mov eax, dword ptr [ebp - local_8]           # 004c2d45
    mov word ptr [eax + field_21], 0x59          # 004c2d48
    mov ecx, dword ptr [ebp - local_8]           # 004c2d4e
    mov edx, dword ptr [ebp - local_4]           # 004c2d51
    mov dword ptr [ecx + field_23], edx          # 004c2d54
    mov eax, dword ptr [ebp - local_4]           # 004c2d57
    add eax, 0x59                                # 004c2d5a
    mov ecx, dword ptr [ebp - local_8]           # 004c2d5d
    mov dword ptr [ecx + field_27], eax          # 004c2d60
    mov edx, dword ptr [ebp - local_8]           # 004c2d63
    mov ax, word ptr [ebp + arg_8]               # 004c2d66
    mov word ptr [edx + field_2b], ax            # 004c2d6a
    mov ecx, dword ptr [ebp - local_8]           # 004c2d6e
    mov dx, word ptr [ebp + arg_c]               # 004c2d71
    mov word ptr [ecx + field_2d], dx            # 004c2d75
    movsx eax, word ptr [ebp + arg_8]            # 004c2d79
    movsx ecx, word ptr [0x639895]               # 004c2d7d
    imul eax, ecx                                # 004c2d84
    mov edx, dword ptr [ebp - local_8]           # 004c2d87
    mov word ptr [edx + field_2f], ax            # 004c2d8a
    mov eax, dword ptr [ebp - local_8]           # 004c2d8e
    mov cx, word ptr [ebp + arg_c]               # 004c2d91
    mov word ptr [eax + field_31], cx            # 004c2d95
    mov edx, dword ptr [ebp - local_8]           # 004c2d99
    mov ax, word ptr [0x639893]                  # 004c2d9c
    mov word ptr [edx + field_33], ax            # 004c2da2
    mov ecx, dword ptr [ebp - local_8]           # 004c2da6
    mov edx, dword ptr [ebp + arg_14]            # 004c2da9
    mov dword ptr [ecx + field_55], edx          # 004c2dac
    mov eax, dword ptr [ebp - local_8]           # 004c2daf
    mov dword ptr [eax + field_35], 0x0          # 004c2db2
    mov ecx, dword ptr [ebp - local_8]           # 004c2db9
    mov dword ptr [ecx + field_39], 0x0          # 004c2dbc
    movsx edx, word ptr [ebp + arg_8]            # 004c2dc3
    sub edx, 0x1                                 # 004c2dc7
    mov eax, dword ptr [ebp - local_8]           # 004c2dca
    mov dword ptr [eax + field_3d], edx          # 004c2dcd
    movsx ecx, word ptr [ebp + arg_c]            # 004c2dd0
    sub ecx, 0x1                                 # 004c2dd4
    mov edx, dword ptr [ebp - local_8]           # 004c2dd7
    mov dword ptr [edx + field_41], ecx          # 004c2dda
    {load} xor eax, eax                          # 004c2ddd
    mov ecx, dword ptr [ebp - local_8]           # 004c2ddf
    add ecx, 0x45                                # 004c2de2
    mov dword ptr [ecx], eax                     # 004c2de5
    mov dword ptr [ecx + field_4], eax           # 004c2de7
    mov dword ptr [ecx + field_8], eax           # 004c2dea
    mov dword ptr [ecx + field_c], eax           # 004c2ded
    mov eax, dword ptr [ebp - local_8]           # 004c2df0
L_004c2df3:
    # block 0x004c2df3: entered by jmp at 0x004c2c7b; jmp at 0x004c2ce9, 5 instruction(s), ends with ret 0x14
    pop edi                                      # 004c2df3
    pop esi                                      # 004c2df4
    {load} mov esp, ebp                          # 004c2df5
    pop ebp                                      # 004c2df7
    ret 0x14                                     # 004c2df8

