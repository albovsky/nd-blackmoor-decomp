# FUN_0042e006
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042e006
# extent:       0x0042e006-0x0042e34e (840 code bytes)
# span:         0x0042e006-0x0042e34e (code 840, tables 0, padding 0)
# sha256:       52887b8e0830dbb90d53766bffe985ad40da2c5e1c612979827f109d0fcbd24b
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0042e006
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_4, field_c, field_22, field_26, field_2a, field_2e, field_36, field_3e; [ecx + n] field_4, field_c, field_22, field_2a, field_2e, field_36, field_3e; [edx + n] field_4, field_c, field_32, field_36, field_3a, field_3e
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 197 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_22, 0x22  # offset +0x22
.equ field_26, 0x26  # offset +0x26
.equ field_2a, 0x2a  # offset +0x2a
.equ field_2e, 0x2e  # offset +0x2e
.equ field_32, 0x32  # offset +0x32
.equ field_36, 0x36  # offset +0x36
.equ field_3a, 0x3a  # offset +0x3a
.equ field_3e, 0x3e  # offset +0x3e

# --- external targets -----------------------------------------------

.org 0x0042e006 - 0x401000
.globl FUN_0042e006
FUN_0042e006:
    # block 0x0042e006: entry, 10 instruction(s), ends with jg to 0x0042e126 (forward)
    push ebp                                     # 0042e006
    {load} mov ebp, esp                          # 0042e007
    push esi                                     # 0042e009
    movsx eax, word ptr [ebp + arg_8]            # 0042e00a
    imul eax, eax, 0x42                          # 0042e00e
    mov ecx, dword ptr [0x5b5120]                # 0042e011
    mov edx, dword ptr [ebp + arg_c]             # 0042e017
    mov eax, dword ptr [ecx + eax + field_3e]    # 0042e01a
    cmp eax, dword ptr [edx + field_c]           # 0042e01e
    jg.d32 L_0042e126                            # 0042e021
    # block 0x0042e027: entered by fall-through of jg at 0x0042e021, 7 instruction(s), ends with jl to 0x0042e126 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0042e027
    imul ecx, ecx, 0x42                          # 0042e02b
    mov edx, dword ptr [0x5b5120]                # 0042e02e
    mov eax, dword ptr [ebp + arg_c]             # 0042e034
    mov ecx, dword ptr [edx + ecx + field_36]    # 0042e037
    cmp ecx, dword ptr [eax + field_4]           # 0042e03b
    jl.d32 L_0042e126                            # 0042e03e
    # block 0x0042e044: entered by fall-through of jl at 0x0042e03e, 50 instruction(s), ends with forward jump to 0x0042e305
    movsx edx, word ptr [ebp + arg_8]            # 0042e044
    imul edx, edx, 0x42                          # 0042e048
    mov eax, dword ptr [0x5b5120]                # 0042e04b
    mov ecx, dword ptr [eax + edx + field_26]    # 0042e050
    mov dword ptr [0x5b50b3], ecx                # 0042e054
    movsx edx, word ptr [ebp + arg_8]            # 0042e05a
    imul edx, edx, 0x42                          # 0042e05e
    mov eax, dword ptr [0x5b5120]                # 0042e061
    mov ecx, dword ptr [eax + edx + field_2e]    # 0042e066
    mov dword ptr [0x5b50bb], ecx                # 0042e06a
    movsx edx, word ptr [ebp + arg_8]            # 0042e070
    imul edx, edx, 0x42                          # 0042e074
    mov eax, dword ptr [0x5b5120]                # 0042e077
    mov ecx, dword ptr [eax + edx + field_22]    # 0042e07c
    mov dword ptr [0x5b50af], ecx                # 0042e080
    movsx edx, word ptr [ebp + arg_8]            # 0042e086
    imul edx, edx, 0x42                          # 0042e08a
    mov eax, dword ptr [0x5b5120]                # 0042e08d
    mov ecx, dword ptr [eax + edx + field_2a]    # 0042e092
    mov dword ptr [0x5b50b7], ecx                # 0042e096
    movsx edx, word ptr [ebp + arg_8]            # 0042e09c
    imul edx, edx, 0x42                          # 0042e0a0
    mov eax, dword ptr [0x5b5120]                # 0042e0a3
    mov ecx, dword ptr [ebp + arg_c]             # 0042e0a8
    mov edx, dword ptr [eax + edx + field_36]    # 0042e0ab
    sub edx, dword ptr [ecx + field_4]           # 0042e0af
    add edx, dword ptr [0x58318a]                # 0042e0b2
    mov dword ptr [0x5b50c3], edx                # 0042e0b8
    movsx eax, word ptr [ebp + arg_8]            # 0042e0be
    imul eax, eax, 0x42                          # 0042e0c2
    mov ecx, dword ptr [0x5b5120]                # 0042e0c5
    mov edx, dword ptr [ebp + arg_c]             # 0042e0cb
    mov eax, dword ptr [ecx + eax + field_3e]    # 0042e0ce
    sub eax, dword ptr [edx + field_4]           # 0042e0d2
    add eax, dword ptr [0x58318a]                # 0042e0d5
    mov dword ptr [0x5b50cb], eax                # 0042e0db
    movsx ecx, word ptr [ebp + arg_8]            # 0042e0e0
    imul ecx, ecx, 0x42                          # 0042e0e4
    mov edx, dword ptr [0x5b5120]                # 0042e0e7
    mov eax, dword ptr [edx + ecx + field_32]    # 0042e0ed
    add eax, dword ptr [0x583186]                # 0042e0f1
    mov dword ptr [0x5b50bf], eax                # 0042e0f7
    movsx ecx, word ptr [ebp + arg_8]            # 0042e0fc
    imul ecx, ecx, 0x42                          # 0042e100
    mov edx, dword ptr [0x5b5120]                # 0042e103
    mov eax, dword ptr [edx + ecx + field_3a]    # 0042e109
    add eax, dword ptr [0x583186]                # 0042e10d
    mov dword ptr [0x5b50c7], eax                # 0042e113
    mov word ptr [0x5b5104], 0x1                 # 0042e118
    jmp.d32 L_0042e305                           # 0042e121
L_0042e126:
    # block 0x0042e126: entered by jg at 0x0042e021; jl at 0x0042e03e, 7 instruction(s), ends with jg to 0x0042e157 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0042e126
    imul ecx, ecx, 0x42                          # 0042e12a
    mov edx, dword ptr [0x5b5120]                # 0042e12d
    mov eax, dword ptr [ebp + arg_c]             # 0042e133
    mov ecx, dword ptr [edx + ecx + field_36]    # 0042e136
    cmp ecx, dword ptr [eax + field_c]           # 0042e13a
    jg.d8 L_0042e157                             # 0042e13d
    # block 0x0042e13f: entered by fall-through of jg at 0x0042e13d, 7 instruction(s), ends with jge to 0x0042e191 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0042e13f
    imul edx, edx, 0x42                          # 0042e143
    mov eax, dword ptr [0x5b5120]                # 0042e146
    mov ecx, dword ptr [ebp + arg_c]             # 0042e14b
    mov edx, dword ptr [eax + edx + field_3e]    # 0042e14e
    cmp edx, dword ptr [ecx + field_c]           # 0042e152
    jge.d8 L_0042e191                            # 0042e155
L_0042e157:
    # block 0x0042e157: entered by jg at 0x0042e13d; fall-through of jge at 0x0042e155, 7 instruction(s), ends with jg to 0x0042e305 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0042e157
    imul eax, eax, 0x42                          # 0042e15b
    mov ecx, dword ptr [0x5b5120]                # 0042e15e
    mov edx, dword ptr [ebp + arg_c]             # 0042e164
    mov eax, dword ptr [ecx + eax + field_36]    # 0042e167
    cmp eax, dword ptr [edx + field_4]           # 0042e16b
    jg.d32 L_0042e305                            # 0042e16e
    # block 0x0042e174: entered by fall-through of jg at 0x0042e16e, 7 instruction(s), ends with jl to 0x0042e305 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0042e174
    imul ecx, ecx, 0x42                          # 0042e178
    mov edx, dword ptr [0x5b5120]                # 0042e17b
    mov eax, dword ptr [ebp + arg_c]             # 0042e181
    mov ecx, dword ptr [edx + ecx + field_3e]    # 0042e184
    cmp ecx, dword ptr [eax + field_4]           # 0042e188
    jl.d32 L_0042e305                            # 0042e18b
L_0042e191:
    # block 0x0042e191: entered by jge at 0x0042e155; fall-through of jl at 0x0042e18b, 7 instruction(s), ends with jge to 0x0042e1b7 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0042e191
    imul edx, edx, 0x42                          # 0042e195
    mov eax, dword ptr [0x5b5120]                # 0042e198
    mov ecx, dword ptr [ebp + arg_c]             # 0042e19d
    mov edx, dword ptr [eax + edx + field_36]    # 0042e1a0
    cmp edx, dword ptr [ecx + field_4]           # 0042e1a4
    jge.d8 L_0042e1b7                            # 0042e1a7
    # block 0x0042e1a9: entered by fall-through of jge at 0x0042e1a7, 4 instruction(s), ends with forward jump to 0x0042e1cd
    mov eax, dword ptr [ebp + arg_c]             # 0042e1a9
    mov ecx, dword ptr [eax + field_4]           # 0042e1ac
    mov dword ptr [0x5b50c3], ecx                # 0042e1af
    jmp.d8 L_0042e1cd                            # 0042e1b5
L_0042e1b7:
    # block 0x0042e1b7: entered by jge at 0x0042e1a7, 5 instruction(s), falls into the block at 0x0042e1cd
    movsx edx, word ptr [ebp + arg_8]            # 0042e1b7
    imul edx, edx, 0x42                          # 0042e1bb
    mov eax, dword ptr [0x5b5120]                # 0042e1be
    mov ecx, dword ptr [eax + edx + field_36]    # 0042e1c3
    mov dword ptr [0x5b50c3], ecx                # 0042e1c7
L_0042e1cd:
    # block 0x0042e1cd: entered by jmp at 0x0042e1b5, 7 instruction(s), ends with jle to 0x0042e1f3 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0042e1cd
    imul edx, edx, 0x42                          # 0042e1d1
    mov eax, dword ptr [0x5b5120]                # 0042e1d4
    mov ecx, dword ptr [ebp + arg_c]             # 0042e1d9
    mov edx, dword ptr [eax + edx + field_3e]    # 0042e1dc
    cmp edx, dword ptr [ecx + field_c]           # 0042e1e0
    jle.d8 L_0042e1f3                            # 0042e1e3
    # block 0x0042e1e5: entered by fall-through of jle at 0x0042e1e3, 4 instruction(s), ends with forward jump to 0x0042e209
    mov eax, dword ptr [ebp + arg_c]             # 0042e1e5
    mov ecx, dword ptr [eax + field_c]           # 0042e1e8
    mov dword ptr [0x5b50cb], ecx                # 0042e1eb
    jmp.d8 L_0042e209                            # 0042e1f1
L_0042e1f3:
    # block 0x0042e1f3: entered by jle at 0x0042e1e3, 5 instruction(s), falls into the block at 0x0042e209
    movsx edx, word ptr [ebp + arg_8]            # 0042e1f3
    imul edx, edx, 0x42                          # 0042e1f7
    mov eax, dword ptr [0x5b5120]                # 0042e1fa
    mov ecx, dword ptr [eax + edx + field_3e]    # 0042e1ff
    mov dword ptr [0x5b50cb], ecx                # 0042e203
L_0042e209:
    # block 0x0042e209: entered by jmp at 0x0042e1f1, 55 instruction(s), falls into the block at 0x0042e305
    movsx edx, word ptr [ebp + arg_8]            # 0042e209
    imul edx, edx, 0x42                          # 0042e20d
    movsx eax, word ptr [ebp + arg_8]            # 0042e210
    imul eax, eax, 0x42                          # 0042e214
    mov ecx, dword ptr [0x5b5120]                # 0042e217
    mov esi, dword ptr [0x5b50c3]                # 0042e21d
    sub esi, dword ptr [ecx + eax + field_36]    # 0042e223
    mov eax, dword ptr [0x5b5120]                # 0042e227
    mov ecx, dword ptr [eax + edx + field_26]    # 0042e22c
    {load} add ecx, esi                          # 0042e230
    mov dword ptr [0x5b50b3], ecx                # 0042e232
    movsx edx, word ptr [ebp + arg_8]            # 0042e238
    imul edx, edx, 0x42                          # 0042e23c
    movsx eax, word ptr [ebp + arg_8]            # 0042e23f
    imul eax, eax, 0x42                          # 0042e243
    mov ecx, dword ptr [0x5b5120]                # 0042e246
    mov eax, dword ptr [ecx + eax + field_3e]    # 0042e24c
    sub eax, dword ptr [0x5b50cb]                # 0042e250
    mov ecx, dword ptr [0x5b5120]                # 0042e256
    mov edx, dword ptr [ecx + edx + field_2e]    # 0042e25c
    {load} sub edx, eax                          # 0042e260
    mov dword ptr [0x5b50bb], edx                # 0042e262
    movsx eax, word ptr [ebp + arg_8]            # 0042e268
    imul eax, eax, 0x42                          # 0042e26c
    mov ecx, dword ptr [0x5b5120]                # 0042e26f
    mov edx, dword ptr [ecx + eax + field_22]    # 0042e275
    mov dword ptr [0x5b50af], edx                # 0042e279
    movsx eax, word ptr [ebp + arg_8]            # 0042e27f
    imul eax, eax, 0x42                          # 0042e283
    mov ecx, dword ptr [0x5b5120]                # 0042e286
    mov edx, dword ptr [ecx + eax + field_2a]    # 0042e28c
    mov dword ptr [0x5b50b7], edx                # 0042e290
    mov eax, dword ptr [ebp + arg_c]             # 0042e296
    mov ecx, dword ptr [0x5b50c3]                # 0042e299
    sub ecx, dword ptr [eax + field_4]           # 0042e29f
    add ecx, dword ptr [0x58318a]                # 0042e2a2
    mov dword ptr [0x5b50c3], ecx                # 0042e2a8
    mov edx, dword ptr [ebp + arg_c]             # 0042e2ae
    mov eax, dword ptr [0x5b50cb]                # 0042e2b1
    sub eax, dword ptr [edx + field_4]           # 0042e2b6
    add eax, dword ptr [0x58318a]                # 0042e2b9
    mov dword ptr [0x5b50cb], eax                # 0042e2bf
    movsx ecx, word ptr [ebp + arg_8]            # 0042e2c4
    imul ecx, ecx, 0x42                          # 0042e2c8
    mov edx, dword ptr [0x5b5120]                # 0042e2cb
    mov eax, dword ptr [edx + ecx + field_32]    # 0042e2d1
    add eax, dword ptr [0x583186]                # 0042e2d5
    mov dword ptr [0x5b50bf], eax                # 0042e2db
    movsx ecx, word ptr [ebp + arg_8]            # 0042e2e0
    imul ecx, ecx, 0x42                          # 0042e2e4
    mov edx, dword ptr [0x5b5120]                # 0042e2e7
    mov eax, dword ptr [edx + ecx + field_3a]    # 0042e2ed
    add eax, dword ptr [0x583186]                # 0042e2f1
    mov dword ptr [0x5b50c7], eax                # 0042e2f7
    mov word ptr [0x5b5104], 0x1                 # 0042e2fc
L_0042e305:
    # block 0x0042e305: entered by jmp at 0x0042e121; jg at 0x0042e16e; jl at 0x0042e18b, 15 instruction(s), ends with ret
    mov ecx, dword ptr [0x5b50c3]                # 0042e305
    sub ecx, dword ptr [0x58318a]                # 0042e30b
    mov dword ptr [0x5b510e], ecx                # 0042e311
    mov edx, dword ptr [0x5b50cb]                # 0042e317
    sub edx, dword ptr [0x58318a]                # 0042e31d
    mov dword ptr [0x5b5116], edx                # 0042e323
    mov eax, dword ptr [0x5b50bf]                # 0042e329
    sub eax, dword ptr [0x583186]                # 0042e32e
    mov dword ptr [0x5b510a], eax                # 0042e334
    mov ecx, dword ptr [0x5b50c7]                # 0042e339
    sub ecx, dword ptr [0x583186]                # 0042e33f
    mov dword ptr [0x5b5112], ecx                # 0042e345
    pop esi                                      # 0042e34b
    pop ebp                                      # 0042e34c
    ret                                          # 0042e34d

