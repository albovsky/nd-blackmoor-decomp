# FUN_0045de8a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045de8a
# extent:       0x0045de8a-0x0045e1ca (832 code bytes)
# span:         0x0045de8a-0x0045e1ca (code 832, tables 0, padding 0)
# sha256:       31bd788872d2086862f98ecbfffe4993ece6da2e3ee4bce5f42ea612cfe007a3
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0045de8a
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_24, field_d0, field_262, field_264, field_2a6, field_2a8, field_31d; [ecx + n] field_24, field_25, field_27, field_142, field_262, field_2a6, field_2a8, field_31d, field_3a2; [edx + n] field_24, field_25, field_142, field_264, field_2a6, field_2a8, field_2a9, field_31d, field_f22; [esi + n] field_24
# callees:      calls FUN_0045e6bd, FUN_0050cd50
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 214 instruction(s), 12 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ arg_8, 0x8  # offset +0x8
.equ field_24, 0x24  # offset +0x24
.equ field_25, 0x25  # offset +0x25
.equ field_27, 0x27  # offset +0x27
.equ field_d0, 0xd0  # offset +0xd0
.equ field_142, 0x142  # offset +0x142
.equ field_262, 0x262  # offset +0x262
.equ field_264, 0x264  # offset +0x264
.equ field_2a6, 0x2a6  # offset +0x2a6
.equ field_2a8, 0x2a8  # offset +0x2a8
.equ field_2a9, 0x2a9  # offset +0x2a9
.equ field_31d, 0x31d  # offset +0x31d
.equ field_3a2, 0x3a2  # offset +0x3a2
.equ field_f22, 0xf22  # offset +0xf22

# --- external targets -----------------------------------------------
.set FUN_0045e6bd, .text + (0x0045e6bd - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x0045de8a - 0x401000
.globl FUN_0045de8a
FUN_0045de8a:
    # block 0x0045de8a: entry, 11 instruction(s), ends with jg to 0x0045e066 (forward)
    push ebp                                     # 0045de8a
    {load} mov ebp, esp                          # 0045de8b
    sub esp, 0x14                                # 0045de8d
    push esi                                     # 0045de90
    mov dword ptr [ebp - local_14], ecx          # 0045de91
    mov dword ptr [ebp - local_4], 0x1           # 0045de94
    mov dword ptr [ebp - local_c], 0x0           # 0045de9b
    mov eax, dword ptr [ebp - local_14]          # 0045dea2
    movsx ecx, word ptr [eax + field_2a6]        # 0045dea5
    test ecx, ecx                                # 0045deac
    jg.d32 L_0045e066                            # 0045deae
    # block 0x0045deb4: entered by fall-through of jg at 0x0045deae, 6 instruction(s), ends with jle to 0x0045defe (forward)
    mov edx, dword ptr [ebp - local_14]          # 0045deb4
    movsx eax, word ptr [edx + field_142]        # 0045deb7
    mov ecx, dword ptr [ebp - local_14]          # 0045debe
    movsx edx, word ptr [ecx + field_262]        # 0045dec1
    {load} cmp eax, edx                          # 0045dec8
    jle.d8 L_0045defe                            # 0045deca
    # block 0x0045decc: entered by fall-through of jle at 0x0045deca, 13 instruction(s), calls FUN_0045e6bd, ends with forward jump to 0x0045e050
    push 0x2                                     # 0045decc
    mov eax, dword ptr [ebp - local_14]          # 0045dece
    add eax, 0x326                               # 0045ded1
    push eax                                     # 0045ded6
    mov ecx, dword ptr [ebp - local_14]          # 0045ded7
    mov edx, dword ptr [ecx + field_31d]         # 0045deda
    add edx, 0xf22                               # 0045dee0
    push edx                                     # 0045dee6
    mov ecx, dword ptr [ebp - local_14]          # 0045dee7
    call FUN_0045e6bd                            # 0045deea
    mov eax, dword ptr [ebp - local_14]          # 0045deef
    mov byte ptr [eax + field_2a8], 0x0          # 0045def2
    jmp.d32 L_0045e050                           # 0045def9
L_0045defe:
    # block 0x0045defe: entered by jle at 0x0045deca, 6 instruction(s), ends with jne to 0x0045e023 (forward)
    mov ecx, dword ptr [ebp - local_14]          # 0045defe
    movsx edx, word ptr [ecx + field_142]        # 0045df01
    mov eax, dword ptr [ebp - local_14]          # 0045df08
    movsx ecx, word ptr [eax + field_262]        # 0045df0b
    {load} cmp edx, ecx                          # 0045df12
    jne.d32 L_0045e023                           # 0045df14
    # block 0x0045df1a: entered by fall-through of jne at 0x0045df14, 6 instruction(s), ends with jne to 0x0045df5a (forward)
    mov edx, dword ptr [ebp - local_14]          # 0045df1a
    mov eax, dword ptr [edx + field_31d]         # 0045df1d
    {load} xor ecx, ecx                          # 0045df23
    mov cl, byte ptr [eax + field_24]            # 0045df25
    cmp ecx, -0x1                                # 0045df28
    jne.d8 L_0045df5a                            # 0045df2b
    # block 0x0045df2d: entered by fall-through of jne at 0x0045df2b, 12 instruction(s), calls FUN_0045e6bd, falls into the block at 0x0045df5a
    mov edx, dword ptr [ebp - local_14]          # 0045df2d
    mov byte ptr [edx + field_2a9], 0x1          # 0045df30
    push 0x3                                     # 0045df37
    mov eax, dword ptr [ebp - local_14]          # 0045df39
    add eax, 0x326                               # 0045df3c
    push eax                                     # 0045df41
    mov ecx, dword ptr [ebp - local_14]          # 0045df42
    mov edx, dword ptr [ecx + field_31d]         # 0045df45
    add edx, 0x12a1                              # 0045df4b
    push edx                                     # 0045df51
    mov ecx, dword ptr [ebp - local_14]          # 0045df52
    call FUN_0045e6bd                            # 0045df55
L_0045df5a:
    # block 0x0045df5a: entered by jne at 0x0045df2b, 6 instruction(s), ends with jne to 0x0045dfb2 (forward)
    mov eax, dword ptr [ebp - local_14]          # 0045df5a
    mov ecx, dword ptr [eax + field_31d]         # 0045df5d
    {load} xor edx, edx                          # 0045df63
    mov dl, byte ptr [ecx + field_24]            # 0045df65
    cmp edx, 0x2                                 # 0045df68
    jne.d8 L_0045dfb2                            # 0045df6b
    # block 0x0045df6d: entered by fall-through of jne at 0x0045df6b, 20 instruction(s), calls FUN_0045e6bd, ends with forward jump to 0x0045e021
    push 0x2                                     # 0045df6d
    mov eax, dword ptr [ebp - local_14]          # 0045df6f
    add eax, 0x326                               # 0045df72
    push eax                                     # 0045df77
    mov ecx, dword ptr [ebp - local_14]          # 0045df78
    mov edx, dword ptr [ecx + field_31d]         # 0045df7b
    movsx eax, word ptr [ebp + arg_8]            # 0045df81
    imul eax, eax, 0x33d                         # 0045df85
    lea ecx, [edx + eax + field_f22]             # 0045df8b
    push ecx                                     # 0045df92
    mov ecx, dword ptr [ebp - local_14]          # 0045df93
    call FUN_0045e6bd                            # 0045df96
    movsx edx, word ptr [ebp + arg_8]            # 0045df9b
    sub edx, 0x1                                 # 0045df9f
    neg edx                                      # 0045dfa2
    {load} sbb edx, edx                          # 0045dfa4
    inc edx                                      # 0045dfa6
    mov eax, dword ptr [ebp - local_14]          # 0045dfa7
    mov byte ptr [eax + field_2a8], dl           # 0045dfaa
    jmp.d8 L_0045e021                            # 0045dfb0
L_0045dfb2:
    # block 0x0045dfb2: entered by jne at 0x0045df6b, 6 instruction(s), ends with jne to 0x0045dff3 (forward)
    mov ecx, dword ptr [ebp - local_14]          # 0045dfb2
    mov edx, dword ptr [ecx + field_31d]         # 0045dfb5
    {load} xor eax, eax                          # 0045dfbb
    mov al, byte ptr [edx + field_24]            # 0045dfbd
    test eax, eax                                # 0045dfc0
    jne.d8 L_0045dff3                            # 0045dfc2
    # block 0x0045dfc4: entered by fall-through of jne at 0x0045dfc2, 13 instruction(s), calls FUN_0045e6bd, ends with forward jump to 0x0045e021
    push 0x2                                     # 0045dfc4
    mov ecx, dword ptr [ebp - local_14]          # 0045dfc6
    add ecx, 0x326                               # 0045dfc9
    push ecx                                     # 0045dfcf
    mov edx, dword ptr [ebp - local_14]          # 0045dfd0
    mov eax, dword ptr [edx + field_31d]         # 0045dfd3
    add eax, 0xf22                               # 0045dfd9
    push eax                                     # 0045dfde
    mov ecx, dword ptr [ebp - local_14]          # 0045dfdf
    call FUN_0045e6bd                            # 0045dfe2
    mov ecx, dword ptr [ebp - local_14]          # 0045dfe7
    mov byte ptr [ecx + field_2a8], 0x0          # 0045dfea
    jmp.d8 L_0045e021                            # 0045dff1
L_0045dff3:
    # block 0x0045dff3: entered by jne at 0x0045dfc2, 12 instruction(s), calls FUN_0045e6bd, falls into the block at 0x0045e021
    push 0x2                                     # 0045dff3
    mov edx, dword ptr [ebp - local_14]          # 0045dff5
    add edx, 0x326                               # 0045dff8
    push edx                                     # 0045dffe
    mov eax, dword ptr [ebp - local_14]          # 0045dfff
    mov ecx, dword ptr [eax + field_31d]         # 0045e002
    add ecx, 0x125f                              # 0045e008
    push ecx                                     # 0045e00e
    mov ecx, dword ptr [ebp - local_14]          # 0045e00f
    call FUN_0045e6bd                            # 0045e012
    mov edx, dword ptr [ebp - local_14]          # 0045e017
    mov byte ptr [edx + field_2a8], 0x1          # 0045e01a
L_0045e021:
    # block 0x0045e021: entered by jmp at 0x0045dfb0; jmp at 0x0045dff1, 1 instruction(s), ends with forward jump to 0x0045e050
    jmp.d8 L_0045e050                            # 0045e021
L_0045e023:
    # block 0x0045e023: entered by jne at 0x0045df14, 12 instruction(s), calls FUN_0045e6bd, falls into the block at 0x0045e050
    push 0x2                                     # 0045e023
    mov eax, dword ptr [ebp - local_14]          # 0045e025
    add eax, 0x326                               # 0045e028
    push eax                                     # 0045e02d
    mov ecx, dword ptr [ebp - local_14]          # 0045e02e
    mov edx, dword ptr [ecx + field_31d]         # 0045e031
    add edx, 0x125f                              # 0045e037
    push edx                                     # 0045e03d
    mov ecx, dword ptr [ebp - local_14]          # 0045e03e
    call FUN_0045e6bd                            # 0045e041
    mov eax, dword ptr [ebp - local_14]          # 0045e046
    mov byte ptr [eax + field_2a8], 0x1          # 0045e049
L_0045e050:
    # block 0x0045e050: entered by jmp at 0x0045def9; jmp at 0x0045e021, 4 instruction(s), ends with forward jump to 0x0045e1c3
    mov ecx, dword ptr [ebp - local_14]          # 0045e050
    mov dword ptr [ecx + field_3a2], 0xc         # 0045e053
    .insn 0x66, 0x0d, 0xffff{:u16}               # 0045e05d
    jmp.d32 L_0045e1c3                           # 0045e061
L_0045e066:
    # block 0x0045e066: entered by jg at 0x0045deae, 7 instruction(s), ends with jle to 0x0045e088 (forward)
    mov edx, dword ptr [ebp - local_14]          # 0045e066
    movsx eax, word ptr [edx + field_2a6]        # 0045e069
    mov ecx, dword ptr [ebp - local_14]          # 0045e070
    mov edx, dword ptr [ecx + field_31d]         # 0045e073
    movsx ecx, word ptr [edx + field_25]         # 0045e079
    {load} cmp eax, ecx                          # 0045e07d
    jle.d8 L_0045e088                            # 0045e07f
    # block 0x0045e081: entered by fall-through of jle at 0x0045e07f, 1 instruction(s), falls into the block at 0x0045e088
    mov dword ptr [ebp - local_4], 0x0           # 0045e081
L_0045e088:
    # block 0x0045e088: entered by jle at 0x0045e07f; jmp at 0x0045e1ba, 2 instruction(s), ends with jne to 0x0045e1bf (forward)
    cmp dword ptr [ebp - local_c], 0x0           # 0045e088
    jne.d32 L_0045e1bf                           # 0045e08c
    # block 0x0045e092: entered by fall-through of jne at 0x0045e08c, 23 instruction(s), calls FUN_0050cd50, ends with je to 0x0045e1ba (forward)
    call FUN_0050cd50                            # 0045e092
    mov edx, dword ptr [ebp - local_14]          # 0045e097
    mov ecx, dword ptr [edx + field_31d]         # 0045e09a
    movsx ecx, word ptr [ecx + field_27]         # 0045e0a0
    cdq                                          # 0045e0a4
    idiv ecx                                     # 0045e0a5
    mov word ptr [ebp - local_8], dx             # 0045e0a7
    call FUN_0050cd50                            # 0045e0ab
    mov edx, dword ptr [ebp - local_14]          # 0045e0b0
    mov ecx, dword ptr [edx + field_31d]         # 0045e0b3
    movsx ecx, word ptr [ecx + field_25]         # 0045e0b9
    cdq                                          # 0045e0bd
    idiv ecx                                     # 0045e0be
    mov word ptr [ebp - local_10], dx            # 0045e0c0
    movsx edx, word ptr [ebp - local_8]          # 0045e0c4
    imul edx, edx, 0xd                           # 0045e0c8
    mov eax, dword ptr [ebp - local_14]          # 0045e0cb
    lea ecx, [eax + edx + field_264]             # 0045e0ce
    movsx edx, word ptr [ebp - local_10]         # 0045e0d5
    {load} xor eax, eax                          # 0045e0d9
    mov al, byte ptr [ecx + edx]                 # 0045e0db
    test eax, eax                                # 0045e0de
    je.d32 L_0045e1ba                            # 0045e0e0
    # block 0x0045e0e6: entered by fall-through of je at 0x0045e0e0, 2 instruction(s), ends with jne to 0x0045e11f (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 0045e0e6
    jne.d8 L_0045e11f                            # 0045e0ea
    # block 0x0045e0ec: entered by fall-through of jne at 0x0045e0ea, 2 instruction(s), ends with jne to 0x0045e1ba (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 0045e0ec
    jne.d32 L_0045e1ba                           # 0045e0f0
    # block 0x0045e0f6: entered by fall-through of jne at 0x0045e0f0, 9 instruction(s), ends with jge to 0x0045e1ba (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0045e0f6
    imul ecx, ecx, 0x120                         # 0045e0fa
    mov edx, dword ptr [ebp - local_14]          # 0045e100
    lea eax, [edx + ecx + field_24]              # 0045e103
    movsx ecx, word ptr [ebp - local_10]         # 0045e107
    movsx edx, word ptr [eax + 2*ecx + field_d0] # 0045e10b
    add edx, 0x1                                 # 0045e113
    cmp edx, 0x3                                 # 0045e116
    jge.d32 L_0045e1ba                           # 0045e119
L_0045e11f:
    # block 0x0045e11f: entered by jne at 0x0045e0ea; fall-through of jge at 0x0045e119, 34 instruction(s), falls into the block at 0x0045e1ba
    movsx eax, word ptr [ebp + arg_8]            # 0045e11f
    imul eax, eax, 0x120                         # 0045e123
    mov ecx, dword ptr [ebp - local_14]          # 0045e129
    lea edx, [ecx + eax + field_24]              # 0045e12c
    movsx eax, word ptr [ebp - local_8]          # 0045e130
    imul eax, eax, 0x34                          # 0045e134
    {load} add edx, eax                          # 0045e137
    movsx ecx, word ptr [ebp - local_10]         # 0045e139
    mov dword ptr [edx + 4*ecx], 0x1             # 0045e13d
    movsx edx, word ptr [ebp - local_10]         # 0045e144
    movsx eax, word ptr [ebp + arg_8]            # 0045e148
    imul eax, eax, 0x120                         # 0045e14c
    mov ecx, dword ptr [ebp - local_14]          # 0045e152
    lea eax, [ecx + eax + field_24]              # 0045e155
    mov cx, word ptr [eax + 2*edx + field_d0]    # 0045e159
    add cx, 0x1                                  # 0045e161
    movsx edx, word ptr [ebp - local_10]         # 0045e165
    movsx eax, word ptr [ebp + arg_8]            # 0045e169
    imul eax, eax, 0x120                         # 0045e16d
    mov esi, dword ptr [ebp - local_14]          # 0045e173
    lea eax, [esi + eax + field_24]              # 0045e176
    mov word ptr [eax + 2*edx + field_d0], cx    # 0045e17a
    movsx ecx, word ptr [ebp - local_8]          # 0045e182
    imul ecx, ecx, 0xd                           # 0045e186
    mov edx, dword ptr [ebp - local_14]          # 0045e189
    lea eax, [edx + ecx + field_264]             # 0045e18c
    movsx ecx, word ptr [ebp - local_10]         # 0045e193
    mov byte ptr [eax + ecx], 0x0                # 0045e197
    mov edx, dword ptr [ebp - local_14]          # 0045e19b
    mov ax, word ptr [edx + field_2a6]           # 0045e19e
    .insn 0x66, 0x2d, 0x0001{:u16}               # 0045e1a5
    mov ecx, dword ptr [ebp - local_14]          # 0045e1a9
    mov word ptr [ecx + field_2a6], ax           # 0045e1ac
    mov dword ptr [ebp - local_c], 0x1           # 0045e1b3
L_0045e1ba:
    # block 0x0045e1ba: entered by je at 0x0045e0e0; jne at 0x0045e0f0; jge at 0x0045e119, 1 instruction(s), ends with backward jump to 0x0045e088
    jmp.d32 L_0045e088                           # 0045e1ba
L_0045e1bf:
    # block 0x0045e1bf: entered by jne at 0x0045e08c, 1 instruction(s), falls into the block at 0x0045e1c3
    mov ax, word ptr [ebp - local_10]            # 0045e1bf
L_0045e1c3:
    # block 0x0045e1c3: entered by jmp at 0x0045e061, 4 instruction(s), ends with ret 0x4
    pop esi                                      # 0045e1c3
    {load} mov esp, ebp                          # 0045e1c4
    pop ebp                                      # 0045e1c6
    ret 0x4                                      # 0045e1c7

