# FUN_00466e14
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00466e14
# extent:       0x00466e14-0x004674a6 (1682 code bytes)
# span:         0x00466e14-0x004674b0 (code 1682, tables 0, padding 10)
# sha256:       378c72019e9fb42e804d93fd8559729a65dfa9a327713c6e264c9e73d8045d8e
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00466e14
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_1c, local_20
# fields:       [eax + n] field_42, field_78, field_f8, field_178, field_2b8; [ecx + n] field_42, field_f8, field_178; [edx + n] field_42, field_f8, field_178, field_218, field_258, field_30a
# callees:      calls FUN_00466db1, FUN_004c5377, FUN_004c5d4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 454 instruction(s), 22 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ field_42, 0x42  # offset +0x42
.equ field_78, 0x78  # offset +0x78
.equ field_f8, 0xf8  # offset +0xf8
.equ field_178, 0x178  # offset +0x178
.equ field_218, 0x218  # offset +0x218
.equ field_258, 0x258  # offset +0x258
.equ field_2b8, 0x2b8  # offset +0x2b8
.equ field_30a, 0x30a  # offset +0x30a

# --- external targets -----------------------------------------------
.set FUN_00466db1, .text + (0x00466db1 - 0x401000)
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)

.org 0x00466e14 - 0x401000
.globl FUN_00466e14
FUN_00466e14:
    # block 0x00466e14: entry, 34 instruction(s), calls FUN_00466db1, FUN_004c5377, ends with je to 0x00466f37 (forward)
    push ebp                                     # 00466e14
    {load} mov ebp, esp                          # 00466e15
    sub esp, 0x20                                # 00466e17
    movsx eax, word ptr [0x61d741]               # 00466e1a
    imul eax, eax, 0x8d                          # 00466e21
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00466e27
    mov dword ptr [ebp - local_c], ecx           # 00466e2d
    lea edx, [ebp - local_1c]                    # 00466e30
    push edx                                     # 00466e33
    movsx eax, word ptr [0x61d74d]               # 00466e34
    shl eax, 0x4                                 # 00466e3b
    mov ecx, dword ptr [ebp - local_c]           # 00466e3e
    lea edx, [ecx + eax + field_178]             # 00466e41
    push edx                                     # 00466e48
    mov ecx, 0x61d723                            # 00466e49
    call FUN_00466db1                            # 00466e4e
    push 0x54b658                                # 00466e53
    lea eax, [ebp - local_1c]                    # 00466e58
    push eax                                     # 00466e5b
    movsx ecx, word ptr [0x61d74d]               # 00466e5c
    shl ecx, 0x4                                 # 00466e63
    mov edx, dword ptr [ebp - local_c]           # 00466e66
    lea eax, [edx + ecx + field_178]             # 00466e69
    push eax                                     # 00466e70
    mov ecx, dword ptr [0x5cf665]                # 00466e71
    push ecx                                     # 00466e77
    mov edx, dword ptr [0x5d15e3]                # 00466e78
    push edx                                     # 00466e7e
    mov ecx, 0x5cf659                            # 00466e7f
    call FUN_004c5377                            # 00466e84
    {load} xor eax, eax                          # 00466e89
    mov al, byte ptr [0x61d761]                  # 00466e8b
    test eax, eax                                # 00466e90
    je.d32 L_00466f37                            # 00466e92
    # block 0x00466e98: entered by fall-through of je at 0x00466e92, 2 instruction(s), ends with jne to 0x00466f37 (forward)
    cmp dword ptr [0x61d768], 0x0                # 00466e98
    jne.d32 L_00466f37                           # 00466e9f
    # block 0x00466ea5: entered by fall-through of jne at 0x00466e9f, 41 instruction(s), calls FUN_00466db1, FUN_004c5377, ends with forward jump to 0x0046700a
    lea ecx, [ebp - local_1c]                    # 00466ea5
    push ecx                                     # 00466ea8
    mov edx, dword ptr [ebp - local_c]           # 00466ea9
    add edx, 0x68                                # 00466eac
    push edx                                     # 00466eaf
    mov ecx, 0x61d723                            # 00466eb0
    call FUN_00466db1                            # 00466eb5
    push 0x54b678                                # 00466eba
    lea eax, [ebp - local_1c]                    # 00466ebf
    push eax                                     # 00466ec2
    mov ecx, dword ptr [ebp - local_c]           # 00466ec3
    add ecx, 0x248                               # 00466ec6
    push ecx                                     # 00466ecc
    mov edx, dword ptr [0x5cf665]                # 00466ecd
    push edx                                     # 00466ed3
    mov eax, dword ptr [0x61d743]                # 00466ed4
    push eax                                     # 00466ed9
    mov ecx, 0x5cf659                            # 00466eda
    call FUN_004c5377                            # 00466edf
    lea ecx, [ebp - local_1c]                    # 00466ee4
    push ecx                                     # 00466ee7
    mov edx, dword ptr [ebp - local_c]           # 00466ee8
    add edx, 0x1f8                               # 00466eeb
    push edx                                     # 00466ef1
    mov ecx, 0x61d723                            # 00466ef2
    call FUN_00466db1                            # 00466ef7
    push 0x54b694                                # 00466efc
    lea eax, [ebp - local_1c]                    # 00466f01
    push eax                                     # 00466f04
    movsx ecx, word ptr [0x61d766]               # 00466f05
    shl ecx, 0x4                                 # 00466f0c
    mov edx, dword ptr [ebp - local_c]           # 00466f0f
    lea eax, [edx + ecx + field_30a]             # 00466f12
    push eax                                     # 00466f19
    mov ecx, dword ptr [0x5cf665]                # 00466f1a
    push ecx                                     # 00466f20
    mov edx, dword ptr [0x61d747]                # 00466f21
    push edx                                     # 00466f27
    mov ecx, 0x5cf659                            # 00466f28
    call FUN_004c5377                            # 00466f2d
    jmp.d32 L_0046700a                           # 00466f32
L_00466f37:
    # block 0x00466f37: entered by je at 0x00466e92; jne at 0x00466e9f, 23 instruction(s), calls FUN_00466db1, FUN_004c5377, ends with je to 0x0046700a (forward)
    lea eax, [ebp - local_1c]                    # 00466f37
    push eax                                     # 00466f3a
    mov ecx, dword ptr [ebp - local_c]           # 00466f3b
    add ecx, 0x48                                # 00466f3e
    push ecx                                     # 00466f41
    mov ecx, 0x61d723                            # 00466f42
    call FUN_00466db1                            # 00466f47
    push 0x54b6b0                                # 00466f4c
    lea edx, [ebp - local_1c]                    # 00466f51
    push edx                                     # 00466f54
    mov eax, dword ptr [ebp - local_c]           # 00466f55
    add eax, 0x208                               # 00466f58
    push eax                                     # 00466f5d
    mov ecx, dword ptr [0x5cf665]                # 00466f5e
    push ecx                                     # 00466f64
    mov edx, dword ptr [0x61d743]                # 00466f65
    push edx                                     # 00466f6b
    mov ecx, 0x5cf659                            # 00466f6c
    call FUN_004c5377                            # 00466f71
    {load} xor eax, eax                          # 00466f76
    mov al, byte ptr [0x61d765]                  # 00466f78
    test eax, eax                                # 00466f7d
    je.d32 L_0046700a                            # 00466f7f
    # block 0x00466f85: entered by fall-through of je at 0x00466f7f, 39 instruction(s), calls FUN_00466db1, FUN_004c5377, falls into the block at 0x0046700a
    lea ecx, [ebp - local_1c]                    # 00466f85
    push ecx                                     # 00466f88
    mov edx, dword ptr [ebp - local_c]           # 00466f89
    add edx, 0x1f8                               # 00466f8c
    push edx                                     # 00466f92
    mov ecx, 0x61d723                            # 00466f93
    call FUN_00466db1                            # 00466f98
    push 0x54b6c8                                # 00466f9d
    lea eax, [ebp - local_1c]                    # 00466fa2
    push eax                                     # 00466fa5
    mov ecx, dword ptr [ebp - local_c]           # 00466fa6
    add ecx, 0x1f8                               # 00466fa9
    push ecx                                     # 00466faf
    mov edx, dword ptr [0x5cf665]                # 00466fb0
    push edx                                     # 00466fb6
    mov eax, dword ptr [0x5d15e3]                # 00466fb7
    push eax                                     # 00466fbc
    mov ecx, 0x5cf659                            # 00466fbd
    call FUN_004c5377                            # 00466fc2
    lea ecx, [ebp - local_1c]                    # 00466fc7
    push ecx                                     # 00466fca
    mov edx, dword ptr [ebp - local_c]           # 00466fcb
    add edx, 0x68                                # 00466fce
    push edx                                     # 00466fd1
    mov ecx, 0x61d723                            # 00466fd2
    call FUN_00466db1                            # 00466fd7
    push 0x54b6e4                                # 00466fdc
    lea eax, [ebp - local_1c]                    # 00466fe1
    push eax                                     # 00466fe4
    mov ecx, dword ptr [ebp - local_c]           # 00466fe5
    add ecx, 0x68                                # 00466fe8
    push ecx                                     # 00466feb
    mov edx, dword ptr [0x5cf665]                # 00466fec
    push edx                                     # 00466ff2
    mov eax, dword ptr [0x5d15e3]                # 00466ff3
    push eax                                     # 00466ff8
    mov ecx, 0x5cf659                            # 00466ff9
    call FUN_004c5377                            # 00466ffe
    mov byte ptr [0x61d765], 0x0                 # 00467003
L_0046700a:
    # block 0x0046700a: entered by jmp at 0x00466f32; je at 0x00466f7f, 4 instruction(s), ends with je to 0x004670e3 (forward)
    {load} xor ecx, ecx                          # 0046700a
    mov cl, byte ptr [0x61d763]                  # 0046700c
    test ecx, ecx                                # 00467012
    je.d32 L_004670e3                            # 00467014
    # block 0x0046701a: entered by fall-through of je at 0x00467014, 52 instruction(s), calls FUN_00466db1, FUN_004c5377, ends with forward jump to 0x004671b7
    lea edx, [ebp - local_1c]                    # 0046701a
    push edx                                     # 0046701d
    movsx eax, word ptr [0x61d74d]               # 0046701e
    sub eax, 0x1                                 # 00467025
    shl eax, 0x4                                 # 00467028
    mov ecx, dword ptr [ebp - local_c]           # 0046702b
    lea edx, [ecx + eax + field_f8]              # 0046702e
    push edx                                     # 00467035
    mov ecx, 0x61d723                            # 00467036
    call FUN_00466db1                            # 0046703b
    push 0x54b6f8                                # 00467040
    lea eax, [ebp - local_1c]                    # 00467045
    push eax                                     # 00467048
    movsx ecx, word ptr [0x61d74d]               # 00467049
    sub ecx, 0x1                                 # 00467050
    shl ecx, 0x4                                 # 00467053
    mov edx, dword ptr [ebp - local_c]           # 00467056
    lea eax, [edx + ecx + field_f8]              # 00467059
    push eax                                     # 00467060
    mov ecx, dword ptr [0x5cf665]                # 00467061
    push ecx                                     # 00467067
    mov edx, dword ptr [0x5d15e3]                # 00467068
    push edx                                     # 0046706e
    mov ecx, 0x5cf659                            # 0046706f
    call FUN_004c5377                            # 00467074
    lea eax, [ebp - local_1c]                    # 00467079
    push eax                                     # 0046707c
    movsx ecx, word ptr [0x61d74d]               # 0046707d
    sub ecx, 0x1                                 # 00467084
    shl ecx, 0x4                                 # 00467087
    mov edx, dword ptr [ebp - local_c]           # 0046708a
    lea eax, [edx + ecx + field_178]             # 0046708d
    push eax                                     # 00467094
    mov ecx, 0x61d723                            # 00467095
    call FUN_00466db1                            # 0046709a
    push 0x54b714                                # 0046709f
    lea ecx, [ebp - local_1c]                    # 004670a4
    push ecx                                     # 004670a7
    movsx edx, word ptr [0x61d74d]               # 004670a8
    sub edx, 0x1                                 # 004670af
    shl edx, 0x4                                 # 004670b2
    mov eax, dword ptr [ebp - local_c]           # 004670b5
    lea ecx, [eax + edx + field_178]             # 004670b8
    push ecx                                     # 004670bf
    mov edx, dword ptr [0x5cf665]                # 004670c0
    push edx                                     # 004670c6
    mov eax, dword ptr [0x5d15e3]                # 004670c7
    push eax                                     # 004670cc
    mov ecx, 0x5cf659                            # 004670cd
    call FUN_004c5377                            # 004670d2
    mov byte ptr [0x61d763], 0x0                 # 004670d7
    jmp.d32 L_004671b7                           # 004670de
L_004670e3:
    # block 0x004670e3: entered by je at 0x00467014, 4 instruction(s), ends with je to 0x004671b7 (forward)
    {load} xor ecx, ecx                          # 004670e3
    mov cl, byte ptr [0x61d762]                  # 004670e5
    test ecx, ecx                                # 004670eb
    je.d32 L_004671b7                            # 004670ed
    # block 0x004670f3: entered by fall-through of je at 0x004670ed, 51 instruction(s), calls FUN_00466db1, FUN_004c5377, falls into the block at 0x004671b7
    lea edx, [ebp - local_1c]                    # 004670f3
    push edx                                     # 004670f6
    movsx eax, word ptr [0x61d74d]               # 004670f7
    add eax, 0x1                                 # 004670fe
    shl eax, 0x4                                 # 00467101
    mov ecx, dword ptr [ebp - local_c]           # 00467104
    lea edx, [ecx + eax + field_f8]              # 00467107
    push edx                                     # 0046710e
    mov ecx, 0x61d723                            # 0046710f
    call FUN_00466db1                            # 00467114
    push 0x54b72c                                # 00467119
    lea eax, [ebp - local_1c]                    # 0046711e
    push eax                                     # 00467121
    movsx ecx, word ptr [0x61d74d]               # 00467122
    add ecx, 0x1                                 # 00467129
    shl ecx, 0x4                                 # 0046712c
    mov edx, dword ptr [ebp - local_c]           # 0046712f
    lea eax, [edx + ecx + field_f8]              # 00467132
    push eax                                     # 00467139
    mov ecx, dword ptr [0x5cf665]                # 0046713a
    push ecx                                     # 00467140
    mov edx, dword ptr [0x5d15e3]                # 00467141
    push edx                                     # 00467147
    mov ecx, 0x5cf659                            # 00467148
    call FUN_004c5377                            # 0046714d
    lea eax, [ebp - local_1c]                    # 00467152
    push eax                                     # 00467155
    movsx ecx, word ptr [0x61d74d]               # 00467156
    add ecx, 0x1                                 # 0046715d
    shl ecx, 0x4                                 # 00467160
    mov edx, dword ptr [ebp - local_c]           # 00467163
    lea eax, [edx + ecx + field_178]             # 00467166
    push eax                                     # 0046716d
    mov ecx, 0x61d723                            # 0046716e
    call FUN_00466db1                            # 00467173
    push 0x54b748                                # 00467178
    lea ecx, [ebp - local_1c]                    # 0046717d
    push ecx                                     # 00467180
    movsx edx, word ptr [0x61d74d]               # 00467181
    add edx, 0x1                                 # 00467188
    shl edx, 0x4                                 # 0046718b
    mov eax, dword ptr [ebp - local_c]           # 0046718e
    lea ecx, [eax + edx + field_178]             # 00467191
    push ecx                                     # 00467198
    mov edx, dword ptr [0x5cf665]                # 00467199
    push edx                                     # 0046719f
    mov eax, dword ptr [0x5d15e3]                # 004671a0
    push eax                                     # 004671a5
    mov ecx, 0x5cf659                            # 004671a6
    call FUN_004c5377                            # 004671ab
    mov byte ptr [0x61d762], 0x0                 # 004671b0
L_004671b7:
    # block 0x004671b7: entered by jmp at 0x004670de; je at 0x004670ed, 24 instruction(s), calls FUN_00466db1, FUN_004c5d4b, ends with je to 0x0046725f (forward)
    lea ecx, [ebp - local_1c]                    # 004671b7
    push ecx                                     # 004671ba
    movsx edx, word ptr [0x61d74d]               # 004671bb
    shl edx, 0x4                                 # 004671c2
    mov eax, dword ptr [ebp - local_c]           # 004671c5
    lea ecx, [eax + edx + field_f8]              # 004671c8
    push ecx                                     # 004671cf
    mov ecx, 0x61d723                            # 004671d0
    call FUN_00466db1                            # 004671d5
    push 0x54b760                                # 004671da
    lea edx, [ebp - local_1c]                    # 004671df
    push edx                                     # 004671e2
    mov eax, dword ptr [ebp - local_c]           # 004671e3
    add eax, 0x2f8                               # 004671e6
    push eax                                     # 004671eb
    mov ecx, dword ptr [0x5cf665]                # 004671ec
    push ecx                                     # 004671f2
    mov edx, dword ptr [0x61d743]                # 004671f3
    push edx                                     # 004671f9
    mov ecx, 0x5cf659                            # 004671fa
    call FUN_004c5d4b                            # 004671ff
    movsx eax, word ptr [0x61d74f]               # 00467204
    test eax, eax                                # 0046720b
    je.d8 L_0046725f                             # 0046720d
    # block 0x0046720f: entered by fall-through of je at 0x0046720d, 23 instruction(s), calls FUN_00466db1, FUN_004c5377, ends with forward jump to 0x004672ad
    lea ecx, [ebp - local_1c]                    # 0046720f
    push ecx                                     # 00467212
    mov edx, dword ptr [ebp - local_c]           # 00467213
    add edx, 0x58                                # 00467216
    push edx                                     # 00467219
    mov ecx, 0x61d723                            # 0046721a
    call FUN_00466db1                            # 0046721f
    push 0x54b774                                # 00467224
    lea eax, [ebp - local_1c]                    # 00467229
    push eax                                     # 0046722c
    movsx ecx, word ptr [0x61d74f]               # 0046722d
    sub ecx, 0x1                                 # 00467234
    shl ecx, 0x4                                 # 00467237
    mov edx, dword ptr [ebp - local_c]           # 0046723a
    lea eax, [edx + ecx + field_218]             # 0046723d
    push eax                                     # 00467244
    mov ecx, dword ptr [0x5cf665]                # 00467245
    push ecx                                     # 0046724b
    mov edx, dword ptr [0x61d743]                # 0046724c
    push edx                                     # 00467252
    mov ecx, 0x5cf659                            # 00467253
    call FUN_004c5377                            # 00467258
    jmp.d8 L_004672ad                            # 0046725d
L_0046725f:
    # block 0x0046725f: entered by je at 0x0046720d, 4 instruction(s), ends with je to 0x004672ad (forward)
    {load} xor eax, eax                          # 0046725f
    mov al, byte ptr [0x61d764]                  # 00467261
    test eax, eax                                # 00467266
    je.d8 L_004672ad                             # 00467268
    # block 0x0046726a: entered by fall-through of je at 0x00467268, 20 instruction(s), calls FUN_00466db1, FUN_004c5377, falls into the block at 0x004672ad
    lea ecx, [ebp - local_1c]                    # 0046726a
    push ecx                                     # 0046726d
    mov edx, dword ptr [ebp - local_c]           # 0046726e
    add edx, 0x58                                # 00467271
    push edx                                     # 00467274
    mov ecx, 0x61d723                            # 00467275
    call FUN_00466db1                            # 0046727a
    push 0x54b78c                                # 0046727f
    lea eax, [ebp - local_1c]                    # 00467284
    push eax                                     # 00467287
    mov ecx, dword ptr [ebp - local_c]           # 00467288
    add ecx, 0x58                                # 0046728b
    push ecx                                     # 0046728e
    mov edx, dword ptr [0x5cf665]                # 0046728f
    push edx                                     # 00467295
    mov eax, dword ptr [0x5d15e3]                # 00467296
    push eax                                     # 0046729b
    mov ecx, 0x5cf659                            # 0046729c
    call FUN_004c5377                            # 004672a1
    mov byte ptr [0x61d764], 0x0                 # 004672a6
L_004672ad:
    # block 0x004672ad: entered by jmp at 0x0046725d; je at 0x00467268, 2 instruction(s), ends with forward jump to 0x004672c1
    mov word ptr [ebp - local_4], 0x0            # 004672ad
    jmp.d8 L_004672c1                            # 004672b3
L_004672b5:
    # block 0x004672b5: entered by jmp at 0x00467445, 3 instruction(s), falls into the block at 0x004672c1
    mov cx, word ptr [ebp - local_4]             # 004672b5
    add cx, 0x1                                  # 004672b9
    mov word ptr [ebp - local_4], cx             # 004672bd
L_004672c1:
    # block 0x004672c1: entered by jmp at 0x004672b3, 5 instruction(s), ends with jge to 0x0046744a (forward)
    movsx edx, word ptr [ebp - local_4]          # 004672c1
    mov eax, dword ptr [ebp - local_c]           # 004672c5
    movsx ecx, word ptr [eax + field_42]         # 004672c8
    {load} cmp edx, ecx                          # 004672cc
    jge.d32 L_0046744a                           # 004672ce
    # block 0x004672d4: entered by fall-through of jge at 0x004672ce, 4 instruction(s), ends with jle to 0x00467445 (forward)
    movsx edx, word ptr [ebp - local_4]          # 004672d4
    movsx eax, word ptr [2*edx + 0x61d751]       # 004672d8
    test eax, eax                                # 004672e0
    jle.d32 L_00467445                           # 004672e2
    # block 0x004672e8: entered by fall-through of jle at 0x004672e2, 14 instruction(s), calls FUN_00466db1, ends with je to 0x0046732b (forward)
    lea ecx, [ebp - local_1c]                    # 004672e8
    push ecx                                     # 004672eb
    movsx edx, word ptr [ebp - local_4]          # 004672ec
    shl edx, 0x4                                 # 004672f0
    mov eax, dword ptr [ebp - local_c]           # 004672f3
    lea ecx, [eax + edx + field_78]              # 004672f6
    push ecx                                     # 004672fa
    mov ecx, 0x61d723                            # 004672fb
    call FUN_00466db1                            # 00467300
    movsx edx, word ptr [ebp - local_4]          # 00467305
    movsx eax, word ptr [2*edx + 0x61d751]       # 00467309
    mov dword ptr [ebp - local_20], eax          # 00467311
    cmp dword ptr [ebp - local_20], 0x1          # 00467314
    je.d8 L_0046732b                             # 00467318
    # block 0x0046731a: entered by fall-through of je at 0x00467318, 2 instruction(s), ends with je to 0x00467336 (forward)
    cmp dword ptr [ebp - local_20], 0x2          # 0046731a
    je.d8 L_00467336                             # 0046731e
    # block 0x00467320: entered by fall-through of je at 0x0046731e, 2 instruction(s), ends with je to 0x00467341 (forward)
    cmp dword ptr [ebp - local_20], 0x3          # 00467320
    je.d8 L_00467341                             # 00467324
    # block 0x00467326: entered by fall-through of je at 0x00467324, 1 instruction(s), ends with forward jump to 0x00467412
    jmp.d32 L_00467412                           # 00467326
L_0046732b:
    # block 0x0046732b: entered by je at 0x00467318, 2 instruction(s), ends with forward jump to 0x00467412
    mov word ptr [ebp - local_8], 0x0            # 0046732b
    jmp.d32 L_00467412                           # 00467331
L_00467336:
    # block 0x00467336: entered by je at 0x0046731e, 2 instruction(s), ends with forward jump to 0x00467412
    mov word ptr [ebp - local_8], 0x1            # 00467336
    jmp.d32 L_00467412                           # 0046733c
L_00467341:
    # block 0x00467341: entered by je at 0x00467324, 3 instruction(s), ends with jne to 0x00467360 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 00467341
    test ecx, ecx                                # 00467345
    jne.d8 L_00467360                            # 00467347
    # block 0x00467349: entered by fall-through of jne at 0x00467347, 3 instruction(s), ends with jne to 0x00467360 (forward)
    movsx edx, word ptr [0x61d753]               # 00467349
    cmp edx, 0x3                                 # 00467350
    jne.d8 L_00467360                            # 00467353
    # block 0x00467355: entered by fall-through of jne at 0x00467353, 2 instruction(s), ends with forward jump to 0x00467412
    mov word ptr [ebp - local_8], 0x4            # 00467355
    jmp.d32 L_00467412                           # 0046735b
L_00467360:
    # block 0x00467360: entered by jne at 0x00467347; jne at 0x00467353, 3 instruction(s), ends with jle to 0x004673de (forward)
    movsx eax, word ptr [ebp - local_4]          # 00467360
    test eax, eax                                # 00467364
    jle.d8 L_004673de                            # 00467366
    # block 0x00467368: entered by fall-through of jle at 0x00467366, 6 instruction(s), ends with jge to 0x004673de (forward)
    movsx ecx, word ptr [ebp - local_4]          # 00467368
    mov edx, dword ptr [ebp - local_c]           # 0046736c
    movsx eax, word ptr [edx + field_42]         # 0046736f
    sub eax, 0x1                                 # 00467373
    {load} cmp ecx, eax                          # 00467376
    jge.d8 L_004673de                            # 00467378
    # block 0x0046737a: entered by fall-through of jge at 0x00467378, 4 instruction(s), ends with jne to 0x004673a4 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0046737a
    movsx edx, word ptr [2*ecx + 0x61d74f]       # 0046737e
    cmp edx, 0x3                                 # 00467386
    jne.d8 L_004673a4                            # 00467389
    # block 0x0046738b: entered by fall-through of jne at 0x00467389, 4 instruction(s), ends with jne to 0x004673a4 (forward)
    movsx eax, word ptr [ebp - local_4]          # 0046738b
    movsx ecx, word ptr [2*eax + 0x61d753]       # 0046738f
    cmp ecx, 0x3                                 # 00467397
    jne.d8 L_004673a4                            # 0046739a
    # block 0x0046739c: entered by fall-through of jne at 0x0046739a, 2 instruction(s), ends with forward jump to 0x004673dc
    mov word ptr [ebp - local_8], 0x5            # 0046739c
    jmp.d8 L_004673dc                            # 004673a2
L_004673a4:
    # block 0x004673a4: entered by jne at 0x00467389; jne at 0x0046739a, 4 instruction(s), ends with jne to 0x004673bd (forward)
    movsx edx, word ptr [ebp - local_4]          # 004673a4
    movsx eax, word ptr [2*edx + 0x61d74f]       # 004673a8
    cmp eax, 0x3                                 # 004673b0
    jne.d8 L_004673bd                            # 004673b3
    # block 0x004673b5: entered by fall-through of jne at 0x004673b3, 2 instruction(s), ends with forward jump to 0x004673dc
    mov word ptr [ebp - local_8], 0x3            # 004673b5
    jmp.d8 L_004673dc                            # 004673bb
L_004673bd:
    # block 0x004673bd: entered by jne at 0x004673b3, 4 instruction(s), ends with jne to 0x004673d6 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004673bd
    movsx edx, word ptr [2*ecx + 0x61d753]       # 004673c1
    cmp edx, 0x3                                 # 004673c9
    jne.d8 L_004673d6                            # 004673cc
    # block 0x004673ce: entered by fall-through of jne at 0x004673cc, 2 instruction(s), ends with forward jump to 0x004673dc
    mov word ptr [ebp - local_8], 0x4            # 004673ce
    jmp.d8 L_004673dc                            # 004673d4
L_004673d6:
    # block 0x004673d6: entered by jne at 0x004673cc, 1 instruction(s), falls into the block at 0x004673dc
    mov word ptr [ebp - local_8], 0x2            # 004673d6
L_004673dc:
    # block 0x004673dc: entered by jmp at 0x004673a2; jmp at 0x004673bb; jmp at 0x004673d4, 1 instruction(s), ends with forward jump to 0x00467412
    jmp.d8 L_00467412                            # 004673dc
L_004673de:
    # block 0x004673de: entered by jle at 0x00467366; jge at 0x00467378, 6 instruction(s), ends with jne to 0x0046740c (forward)
    movsx eax, word ptr [ebp - local_4]          # 004673de
    mov ecx, dword ptr [ebp - local_c]           # 004673e2
    movsx edx, word ptr [ecx + field_42]         # 004673e5
    sub edx, 0x1                                 # 004673e9
    {load} cmp eax, edx                          # 004673ec
    jne.d8 L_0046740c                            # 004673ee
    # block 0x004673f0: entered by fall-through of jne at 0x004673ee, 5 instruction(s), ends with jne to 0x0046740c (forward)
    mov eax, dword ptr [ebp - local_c]           # 004673f0
    movsx ecx, word ptr [eax + field_42]         # 004673f3
    movsx edx, word ptr [2*ecx + 0x61d74d]       # 004673f7
    cmp edx, 0x3                                 # 004673ff
    jne.d8 L_0046740c                            # 00467402
    # block 0x00467404: entered by fall-through of jne at 0x00467402, 2 instruction(s), ends with forward jump to 0x00467412
    mov word ptr [ebp - local_8], 0x3            # 00467404
    jmp.d8 L_00467412                            # 0046740a
L_0046740c:
    # block 0x0046740c: entered by jne at 0x004673ee; jne at 0x00467402, 1 instruction(s), falls into the block at 0x00467412
    mov word ptr [ebp - local_8], 0x2            # 0046740c
L_00467412:
    # block 0x00467412: entered by jmp at 0x00467326; jmp at 0x00467331; jmp at 0x0046733c; jmp at 0x0046735b; more, 14 instruction(s), calls FUN_004c5377, falls into the block at 0x00467445
    push 0x54b7a8                                # 00467412
    lea eax, [ebp - local_1c]                    # 00467417
    push eax                                     # 0046741a
    movsx ecx, word ptr [ebp - local_8]          # 0046741b
    shl ecx, 0x4                                 # 0046741f
    mov edx, dword ptr [ebp - local_c]           # 00467422
    lea eax, [edx + ecx + field_258]             # 00467425
    push eax                                     # 0046742c
    mov ecx, dword ptr [0x5cf665]                # 0046742d
    push ecx                                     # 00467433
    mov edx, dword ptr [0x61d743]                # 00467434
    push edx                                     # 0046743a
    mov ecx, 0x5cf659                            # 0046743b
    call FUN_004c5377                            # 00467440
L_00467445:
    # block 0x00467445: entered by jle at 0x004672e2, 1 instruction(s), ends with backward jump to 0x004672b5
    jmp.d32 L_004672b5                           # 00467445
L_0046744a:
    # block 0x0046744a: entered by jge at 0x004672ce, 26 instruction(s), calls FUN_00466db1, FUN_004c5d4b, ends with ret
    lea eax, [ebp - local_1c]                    # 0046744a
    push eax                                     # 0046744d
    movsx ecx, word ptr [0x61d74d]               # 0046744e
    shl ecx, 0x4                                 # 00467455
    mov edx, dword ptr [ebp - local_c]           # 00467458
    lea eax, [edx + ecx + field_178]             # 0046745b
    push eax                                     # 00467462
    mov ecx, 0x61d723                            # 00467463
    call FUN_00466db1                            # 00467468
    push 0x54b7c0                                # 0046746d
    lea ecx, [ebp - local_1c]                    # 00467472
    push ecx                                     # 00467475
    movsx edx, word ptr [0x61d74f]               # 00467476
    shl edx, 0x4                                 # 0046747d
    mov eax, dword ptr [ebp - local_c]           # 00467480
    lea ecx, [eax + edx + field_2b8]             # 00467483
    push ecx                                     # 0046748a
    mov edx, dword ptr [0x5cf665]                # 0046748b
    push edx                                     # 00467491
    mov eax, dword ptr [0x61d743]                # 00467492
    push eax                                     # 00467497
    mov ecx, 0x5cf659                            # 00467498
    call FUN_004c5d4b                            # 0046749d
    {load} mov esp, ebp                          # 004674a2
    pop ebp                                      # 004674a4
    ret                                          # 004674a5

# --- data items (not part of the function) -------------------------
.org 0x004674a6 - 0x401000
PAD_004674a6:  # 10 byte(s) of int3 padding
    .fill 10, 1, 0xcc

