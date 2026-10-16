# FUN_005110a9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005110a9
# extent:       0x005110a9-0x005117ca (1825 code bytes)
# span:         0x005110a9-0x005117ea (code 1825, tables 32, padding 0)
# sha256:       ca8bc72f378d0e4faf533e20844815dc66c89460e5924d92c41e38c6118e4c3e
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005110a9
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       23 ebp-relative slot(s): local_3, local_4, local_8, local_c, local_10, local_14, local_15, local_16, local_1c, local_20, local_24, local_28 and 11 more
# fields:       [eax + n] field_4, field_minus_1, field_minus_4, field_minus_8; [ecx + n] field_1, field_minus_30; [edi + n] field_1
# callees:      calls FUN_00511888, FUN_005117ea, FUN_005118a5, FUN_005166d4, FUN_00511f30, FUN_00511895, FUN_00516810, FUN_005167a0, FUN_0051181f, FUN_00511850; plus 3 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 595 instruction(s), 96 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_3, 0x3  # offset -0x3
.equ local_4, 0x4  # offset -0x4
.equ field_minus_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_minus_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_15, 0x15  # offset -0x15
.equ local_16, 0x16  # offset -0x16
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ field_minus_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ local_49, 0x49  # offset -0x49
.equ local_247, 0x247  # offset -0x247
.equ local_248, 0x248  # offset -0x248
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_005117ea, .text + (0x005117ea - 0x401000)
.set FUN_0051181f, .text + (0x0051181f - 0x401000)
.set FUN_00511850, .text + (0x00511850 - 0x401000)
.set FUN_00511888, .text + (0x00511888 - 0x401000)
.set FUN_00511895, .text + (0x00511895 - 0x401000)
.set FUN_005118a5, .text + (0x005118a5 - 0x401000)
.set FUN_00511f30, .text + (0x00511f30 - 0x401000)
.set FUN_005166d4, .text + (0x005166d4 - 0x401000)
.set FUN_005167a0, .text + (0x005167a0 - 0x401000)
.set FUN_00516810, .text + (0x00516810 - 0x401000)

.org 0x005110a9 - 0x401000
.globl FUN_005110a9
FUN_005110a9:
    # block 0x005110a9: entry, 15 instruction(s), ends with je to 0x005117c2 (forward)
    push ebp                                     # 005110a9
    {load} mov ebp, esp                          # 005110aa
    sub esp, 0x248                               # 005110ac
    push ebx                                     # 005110b2
    push esi                                     # 005110b3
    push edi                                     # 005110b4
    mov edi, dword ptr [ebp + arg_c]             # 005110b5
    {load} xor esi, esi                          # 005110b8
    mov bl, byte ptr [edi]                       # 005110ba
    inc edi                                      # 005110bc
    test bl, bl                                  # 005110bd
    mov dword ptr [ebp - local_c], esi           # 005110bf
    mov dword ptr [ebp - local_14], esi          # 005110c2
    mov dword ptr [ebp + arg_c], edi             # 005110c5
    je.d32 L_005117c2                            # 005110c8
    # block 0x005110ce: entered by fall-through of je at 0x005110c8, 3 instruction(s), ends with forward jump to 0x005110dd
    mov ecx, dword ptr [ebp - local_10]          # 005110ce
    {load} xor edx, edx                          # 005110d1
    jmp.d8 L_005110dd                            # 005110d3
L_005110d5:
    # block 0x005110d5: entered by jne at 0x005117bc, 3 instruction(s), falls into the block at 0x005110dd
    mov ecx, dword ptr [ebp - local_10]          # 005110d5
    mov esi, dword ptr [ebp - local_30]          # 005110d8
    {load} xor edx, edx                          # 005110db
L_005110dd:
    # block 0x005110dd: entered by jmp at 0x005110d3, 2 instruction(s), ends with jl to 0x005117c2 (forward)
    cmp dword ptr [ebp - local_14], edx          # 005110dd
    jl.d32 L_005117c2                            # 005110e0
    # block 0x005110e6: entered by fall-through of jl at 0x005110e0, 2 instruction(s), ends with jl to 0x005110fe (forward)
    cmp bl, 0x20                                 # 005110e6
    jl.d8 L_005110fe                             # 005110e9
    # block 0x005110eb: entered by fall-through of jl at 0x005110e9, 2 instruction(s), ends with jg to 0x005110fe (forward)
    cmp bl, 0x78                                 # 005110eb
    jg.d8 L_005110fe                             # 005110ee
    # block 0x005110f0: entered by fall-through of jg at 0x005110ee, 4 instruction(s), ends with forward jump to 0x00511100
    movsx eax, bl                                # 005110f0
    mov al, byte ptr [eax + 0x530418]            # 005110f3
    and eax, 0xf                                 # 005110f9
    jmp.d8 L_00511100                            # 005110fc
L_005110fe:
    # block 0x005110fe: entered by jl at 0x005110e9; jg at 0x005110ee, 1 instruction(s), falls into the block at 0x00511100
    {load} xor eax, eax                          # 005110fe
L_00511100:
    # block 0x00511100: entered by jmp at 0x005110fc, 5 instruction(s), ends with ja to 0x005117b1 (forward)
    movsx eax, byte ptr [esi + 8*eax + 0x530438] # 00511100
    sar eax, 0x4                                 # 00511108
    cmp eax, 0x7                                 # 0051110b
    mov dword ptr [ebp - local_30], eax          # 0051110e
    ja.d32 L_005117b1                            # 00511111
    # block 0x00511117: entered by fall-through of ja at 0x00511111, 1 instruction(s), ends with indirect jump dword ptr [4*eax + 0x5117ca]
    jmp dword ptr [4*eax + SWTAB_005117ca_VA]    # 00511117
L_0051111e:
    # block 0x0051111e: entered by switch case, 8 instruction(s), ends with forward jump to 0x005117b1
    or dword ptr [ebp - local_10], -0x1          # 0051111e
    mov dword ptr [ebp - local_34], edx          # 00511122
    mov dword ptr [ebp - local_28], edx          # 00511125
    mov dword ptr [ebp - local_20], edx          # 00511128
    mov dword ptr [ebp - local_1c], edx          # 0051112b
    mov dword ptr [ebp - local_4], edx           # 0051112e
    mov dword ptr [ebp - local_24], edx          # 00511131
    jmp.d32 L_005117b1                           # 00511134
L_00511139:
    # block 0x00511139: entered by switch case, 3 instruction(s), ends with je to 0x0051117c (forward)
    movsx eax, bl                                # 00511139
    sub eax, 0x20                                # 0051113c
    je.d8 L_0051117c                             # 0051113f
    # block 0x00511141: entered by fall-through of je at 0x0051113f, 2 instruction(s), ends with je to 0x00511173 (forward)
    sub eax, 0x3                                 # 00511141
    je.d8 L_00511173                             # 00511144
    # block 0x00511146: entered by fall-through of je at 0x00511144, 2 instruction(s), ends with je to 0x0051116a (forward)
    sub eax, 0x8                                 # 00511146
    je.d8 L_0051116a                             # 00511149
    # block 0x0051114b: entered by fall-through of je at 0x00511149, 3 instruction(s), ends with je to 0x00511161 (forward)
    dec eax                                      # 0051114b
    dec eax                                      # 0051114c
    je.d8 L_00511161                             # 0051114d
    # block 0x0051114f: entered by fall-through of je at 0x0051114d, 2 instruction(s), ends with jne to 0x005117b1 (forward)
    sub eax, 0x3                                 # 0051114f
    jne.d32 L_005117b1                           # 00511152
    # block 0x00511158: entered by fall-through of jne at 0x00511152, 2 instruction(s), ends with forward jump to 0x005117b1
    or dword ptr [ebp - local_4], 0x8            # 00511158
    jmp.d32 L_005117b1                           # 0051115c
L_00511161:
    # block 0x00511161: entered by je at 0x0051114d, 2 instruction(s), ends with forward jump to 0x005117b1
    or dword ptr [ebp - local_4], 0x4            # 00511161
    jmp.d32 L_005117b1                           # 00511165
L_0051116a:
    # block 0x0051116a: entered by je at 0x00511149, 2 instruction(s), ends with forward jump to 0x005117b1
    or dword ptr [ebp - local_4], 0x1            # 0051116a
    jmp.d32 L_005117b1                           # 0051116e
L_00511173:
    # block 0x00511173: entered by je at 0x00511144, 2 instruction(s), ends with forward jump to 0x005117b1
    or byte ptr [ebp - local_4], -0x80           # 00511173
    jmp.d32 L_005117b1                           # 00511177
L_0051117c:
    # block 0x0051117c: entered by je at 0x0051113f, 2 instruction(s), ends with forward jump to 0x005117b1
    or dword ptr [ebp - local_4], 0x2            # 0051117c
    jmp.d32 L_005117b1                           # 00511180
L_00511185:
    # block 0x00511185: entered by switch case, 2 instruction(s), ends with jne to 0x005111ad (forward)
    cmp bl, 0x2a                                 # 00511185
    jne.d8 L_005111ad                            # 00511188
    # block 0x0051118a: entered by fall-through of jne at 0x00511188, 7 instruction(s), calls FUN_00511888, ends with jge to 0x005117b1 (forward)
    lea eax, [ebp + arg_10]                      # 0051118a
    push eax                                     # 0051118d
    call FUN_00511888                            # 0051118e
    test eax, eax                                # 00511193
    pop ecx                                      # 00511195
    mov dword ptr [ebp - local_20], eax          # 00511196
    jge.d32 L_005117b1                           # 00511199
    # block 0x0051119f: entered by fall-through of jge at 0x00511199, 2 instruction(s), falls into the block at 0x005111a5
    or dword ptr [ebp - local_4], 0x4            # 0051119f
    neg eax                                      # 005111a3
L_005111a5:
    # block 0x005111a5: entered by jmp at 0x005111ba, 2 instruction(s), ends with forward jump to 0x005117b1
    mov dword ptr [ebp - local_20], eax          # 005111a5
    jmp.d32 L_005117b1                           # 005111a8
L_005111ad:
    # block 0x005111ad: entered by jne at 0x00511188, 5 instruction(s), ends with backward jump to 0x005111a5
    mov eax, dword ptr [ebp - local_20]          # 005111ad
    movsx ecx, bl                                # 005111b0
    lea eax, [eax + 4*eax]                       # 005111b3
    lea eax, [ecx + 2*eax - field_minus_30]      # 005111b6
    jmp.d8 L_005111a5                            # 005111ba
L_005111bc:
    # block 0x005111bc: entered by switch case, 2 instruction(s), ends with forward jump to 0x005117b1
    mov dword ptr [ebp - local_10], edx          # 005111bc
    jmp.d32 L_005117b1                           # 005111bf
L_005111c4:
    # block 0x005111c4: entered by switch case, 2 instruction(s), ends with jne to 0x005111e7 (forward)
    cmp bl, 0x2a                                 # 005111c4
    jne.d8 L_005111e7                            # 005111c7
    # block 0x005111c9: entered by fall-through of jne at 0x005111c7, 7 instruction(s), calls FUN_00511888, ends with jge to 0x005117b1 (forward)
    lea eax, [ebp + arg_10]                      # 005111c9
    push eax                                     # 005111cc
    call FUN_00511888                            # 005111cd
    test eax, eax                                # 005111d2
    pop ecx                                      # 005111d4
    mov dword ptr [ebp - local_10], eax          # 005111d5
    jge.d32 L_005117b1                           # 005111d8
    # block 0x005111de: entered by fall-through of jge at 0x005111d8, 2 instruction(s), ends with forward jump to 0x005117b1
    or dword ptr [ebp - local_10], -0x1          # 005111de
    jmp.d32 L_005117b1                           # 005111e2
L_005111e7:
    # block 0x005111e7: entered by jne at 0x005111c7, 5 instruction(s), ends with forward jump to 0x005117b1
    lea eax, [ecx + 4*ecx]                       # 005111e7
    movsx ecx, bl                                # 005111ea
    lea eax, [ecx + 2*eax - field_minus_30]      # 005111ed
    mov dword ptr [ebp - local_10], eax          # 005111f1
    jmp.d32 L_005117b1                           # 005111f4
L_005111f9:
    # block 0x005111f9: entered by switch case, 2 instruction(s), ends with je to 0x0051122c (forward)
    cmp bl, 0x49                                 # 005111f9
    je.d8 L_0051122c                             # 005111fc
    # block 0x005111fe: entered by fall-through of je at 0x005111fc, 2 instruction(s), ends with je to 0x00511223 (forward)
    cmp bl, 0x68                                 # 005111fe
    je.d8 L_00511223                             # 00511201
    # block 0x00511203: entered by fall-through of je at 0x00511201, 2 instruction(s), ends with je to 0x0051121a (forward)
    cmp bl, 0x6c                                 # 00511203
    je.d8 L_0051121a                             # 00511206
    # block 0x00511208: entered by fall-through of je at 0x00511206, 2 instruction(s), ends with jne to 0x005117b1 (forward)
    cmp bl, 0x77                                 # 00511208
    jne.d32 L_005117b1                           # 0051120b
    # block 0x00511211: entered by fall-through of jne at 0x0051120b, 2 instruction(s), ends with forward jump to 0x005117b1
    or byte ptr [ebp - local_3], 0x8             # 00511211
    jmp.d32 L_005117b1                           # 00511215
L_0051121a:
    # block 0x0051121a: entered by je at 0x00511206, 2 instruction(s), ends with forward jump to 0x005117b1
    or dword ptr [ebp - local_4], 0x10           # 0051121a
    jmp.d32 L_005117b1                           # 0051121e
L_00511223:
    # block 0x00511223: entered by je at 0x00511201, 2 instruction(s), ends with forward jump to 0x005117b1
    or dword ptr [ebp - local_4], 0x20           # 00511223
    jmp.d32 L_005117b1                           # 00511227
L_0051122c:
    # block 0x0051122c: entered by je at 0x005111fc, 2 instruction(s), ends with jne to 0x00511245 (forward)
    cmp byte ptr [edi], 0x36                     # 0051122c
    jne.d8 L_00511245                            # 0051122f
    # block 0x00511231: entered by fall-through of jne at 0x0051122f, 2 instruction(s), ends with jne to 0x00511245 (forward)
    cmp byte ptr [edi + field_1], 0x34           # 00511231
    jne.d8 L_00511245                            # 00511235
    # block 0x00511237: entered by fall-through of jne at 0x00511235, 5 instruction(s), ends with forward jump to 0x005117b1
    inc edi                                      # 00511237
    inc edi                                      # 00511238
    or byte ptr [ebp - local_3], -0x80           # 00511239
    mov dword ptr [ebp + arg_c], edi             # 0051123d
    jmp.d32 L_005117b1                           # 00511240
L_00511245:
    # block 0x00511245: entered by jne at 0x0051122f; jne at 0x00511235, 1 instruction(s), falls into the block at 0x00511248
    mov dword ptr [ebp - local_30], edx          # 00511245
L_00511248:
    # block 0x00511248: entered by switch case, 5 instruction(s), ends with je to 0x00511274 (forward)
    mov ecx, dword ptr [0x568200]                # 00511248
    mov dword ptr [ebp - local_24], edx          # 0051124e
    movzx eax, bl                                # 00511251
    test byte ptr [ecx + 2*eax + field_1], -0x80 # 00511254
    je.d8 L_00511274                             # 00511259
    # block 0x0051125b: entered by fall-through of je at 0x00511259, 10 instruction(s), calls FUN_005117ea, falls into the block at 0x00511274
    lea eax, [ebp - local_14]                    # 0051125b
    push eax                                     # 0051125e
    push dword ptr [ebp + arg_8]                 # 0051125f
    movsx eax, bl                                # 00511262
    push eax                                     # 00511265
    call FUN_005117ea                            # 00511266
    mov bl, byte ptr [edi]                       # 0051126b
    add esp, 0xc                                 # 0051126d
    inc edi                                      # 00511270
    mov dword ptr [ebp + arg_c], edi             # 00511271
L_00511274:
    # block 0x00511274: entered by je at 0x00511259, 8 instruction(s), calls FUN_005117ea, ends with forward jump to 0x005117b1
    lea eax, [ebp - local_14]                    # 00511274
    push eax                                     # 00511277
    push dword ptr [ebp + arg_8]                 # 00511278
    movsx eax, bl                                # 0051127b
    push eax                                     # 0051127e
    call FUN_005117ea                            # 0051127f
    add esp, 0xc                                 # 00511284
    jmp.d32 L_005117b1                           # 00511287
L_0051128c:
    # block 0x0051128c: entered by switch case, 3 instruction(s), ends with jg to 0x005114b4 (forward)
    movsx eax, bl                                # 0051128c
    cmp eax, 0x67                                # 0051128f
    jg.d32 L_005114b4                            # 00511292
    # block 0x00511298: entered by fall-through of jg at 0x00511292, 2 instruction(s), ends with jge to 0x00511337 (forward)
    cmp eax, 0x65                                # 00511298
    jge.d32 L_00511337                           # 0051129b
    # block 0x005112a1: entered by fall-through of jge at 0x0051129b, 2 instruction(s), ends with jg to 0x00511395 (forward)
    cmp eax, 0x58                                # 005112a1
    jg.d32 L_00511395                            # 005112a4
    # block 0x005112aa: entered by fall-through of jg at 0x005112a4, 1 instruction(s), ends with je to 0x00511528 (forward)
    je.d32 L_00511528                            # 005112aa
    # block 0x005112b0: entered by fall-through of je at 0x005112aa, 2 instruction(s), ends with je to 0x00511358 (forward)
    sub eax, 0x43                                # 005112b0
    je.d32 L_00511358                            # 005112b3
    # block 0x005112b9: entered by fall-through of je at 0x005112b3, 3 instruction(s), ends with je to 0x0051132d (forward)
    dec eax                                      # 005112b9
    dec eax                                      # 005112ba
    je.d8 L_0051132d                             # 005112bb
    # block 0x005112bd: entered by fall-through of je at 0x005112bb, 3 instruction(s), ends with je to 0x0051132d (forward)
    dec eax                                      # 005112bd
    dec eax                                      # 005112be
    je.d8 L_0051132d                             # 005112bf
    # block 0x005112c1: entered by fall-through of je at 0x005112bf, 2 instruction(s), ends with jne to 0x005116b3 (forward)
    sub eax, 0xc                                 # 005112c1
    jne.d32 L_005116b3                           # 005112c4
    # block 0x005112ca: entered by fall-through of jne at 0x005112c4, 2 instruction(s), ends with jne to 0x005112d6 (forward)
    test word ptr [ebp - local_4], 0x830         # 005112ca
    jne.d8 L_005112d6                            # 005112d0
    # block 0x005112d2: entered by fall-through of jne at 0x005112d0, 1 instruction(s), falls into the block at 0x005112d6
    or byte ptr [ebp - local_3], 0x8             # 005112d2
L_005112d6:
    # block 0x005112d6: entered by jne at 0x005112d0; je at 0x005114d3, 3 instruction(s), ends with jne to 0x005112e3 (forward)
    mov esi, dword ptr [ebp - local_10]          # 005112d6
    cmp esi, -0x1                                # 005112d9
    jne.d8 L_005112e3                            # 005112dc
    # block 0x005112de: entered by fall-through of jne at 0x005112dc, 1 instruction(s), falls into the block at 0x005112e3
    mov esi, 0x7fffffff                          # 005112de
L_005112e3:
    # block 0x005112e3: entered by jne at 0x005112dc, 8 instruction(s), calls FUN_00511888, ends with je to 0x005114fc (forward)
    lea eax, [ebp + arg_10]                      # 005112e3
    push eax                                     # 005112e6
    call FUN_00511888                            # 005112e7
    test word ptr [ebp - local_4], 0x810         # 005112ec
    pop ecx                                      # 005112f2
    {load} mov ecx, eax                          # 005112f3
    mov dword ptr [ebp - local_8], ecx           # 005112f5
    je.d32 L_005114fc                            # 005112f8
    # block 0x005112fe: entered by fall-through of je at 0x005112f8, 2 instruction(s), ends with jne to 0x0051130b (forward)
    test ecx, ecx                                # 005112fe
    jne.d8 L_0051130b                            # 00511300
    # block 0x00511302: entered by fall-through of jne at 0x00511300, 2 instruction(s), falls into the block at 0x0051130b
    mov ecx, dword ptr [0x5681fc]                # 00511302
    mov dword ptr [ebp - local_8], ecx           # 00511308
L_0051130b:
    # block 0x0051130b: entered by jne at 0x00511300, 2 instruction(s), falls into the block at 0x00511314
    mov dword ptr [ebp - local_24], 0x1          # 0051130b
    {load} mov eax, ecx                          # 00511312
L_00511314:
    # block 0x00511314: entered by jmp at 0x0051132b, 4 instruction(s), ends with je to 0x005114f3 (forward)
    {load} mov edx, esi                          # 00511314
    dec esi                                      # 00511316
    test edx, edx                                # 00511317
    je.d32 L_005114f3                            # 00511319
    # block 0x0051131f: entered by fall-through of je at 0x00511319, 2 instruction(s), ends with je to 0x005114f3 (forward)
    cmp word ptr [eax], 0x0                      # 0051131f
    je.d32 L_005114f3                            # 00511323
    # block 0x00511329: entered by fall-through of je at 0x00511323, 3 instruction(s), ends with backward jump to 0x00511314
    inc eax                                      # 00511329
    inc eax                                      # 0051132a
    jmp.d8 L_00511314                            # 0051132b
L_0051132d:
    # block 0x0051132d: entered by je at 0x005112bb; je at 0x005112bf, 2 instruction(s), falls into the block at 0x00511337
    mov dword ptr [ebp - local_34], 0x1          # 0051132d
    add bl, 0x20                                 # 00511334
L_00511337:
    # block 0x00511337: entered by jge at 0x0051129b, 5 instruction(s), ends with jge to 0x0051141b (forward)
    or dword ptr [ebp - local_4], 0x40           # 00511337
    lea edi, [ebp - local_248]                   # 0051133b
    {load} cmp ecx, edx                          # 00511341
    mov dword ptr [ebp - local_8], edi           # 00511343
    jge.d32 L_0051141b                           # 00511346
    # block 0x0051134c: entered by fall-through of jge at 0x00511346, 2 instruction(s), ends with forward jump to 0x00511429
    mov dword ptr [ebp - local_10], 0x6          # 0051134c
    jmp.d32 L_00511429                           # 00511353
L_00511358:
    # block 0x00511358: entered by je at 0x005112b3, 2 instruction(s), ends with jne to 0x00511364 (forward)
    test word ptr [ebp - local_4], 0x830         # 00511358
    jne.d8 L_00511364                            # 0051135e
    # block 0x00511360: entered by fall-through of jne at 0x0051135e, 1 instruction(s), falls into the block at 0x00511364
    or byte ptr [ebp - local_3], 0x8             # 00511360
L_00511364:
    # block 0x00511364: entered by jne at 0x0051135e; je at 0x0051139d, 4 instruction(s), ends with je to 0x005113ab (forward)
    test word ptr [ebp - local_4], 0x810         # 00511364
    lea eax, [ebp + arg_10]                      # 0051136a
    push eax                                     # 0051136d
    je.d8 L_005113ab                             # 0051136e
    # block 0x00511370: entered by fall-through of je at 0x0051136e, 9 instruction(s), calls FUN_005118a5, FUN_005166d4, ends with jge to 0x005113be (forward)
    call FUN_005118a5                            # 00511370
    push eax                                     # 00511375
    lea eax, [ebp - local_248]                   # 00511376
    push eax                                     # 0051137c
    call FUN_005166d4                            # 0051137d
    add esp, 0xc                                 # 00511382
    mov dword ptr [ebp - local_c], eax           # 00511385
    test eax, eax                                # 00511388
    jge.d8 L_005113be                            # 0051138a
    # block 0x0051138c: entered by fall-through of jge at 0x0051138a, 2 instruction(s), ends with forward jump to 0x005113be
    mov dword ptr [ebp - local_28], 0x1          # 0051138c
    jmp.d8 L_005113be                            # 00511393
L_00511395:
    # block 0x00511395: entered by jg at 0x005112a4, 2 instruction(s), ends with je to 0x005113cc (forward)
    sub eax, 0x5a                                # 00511395
    je.d8 L_005113cc                             # 00511398
    # block 0x0051139a: entered by fall-through of je at 0x00511398, 2 instruction(s), ends with je to 0x00511364 (backward)
    sub eax, 0x9                                 # 0051139a
    je.d8 L_00511364                             # 0051139d
    # block 0x0051139f: entered by fall-through of je at 0x0051139d, 2 instruction(s), ends with je to 0x0051158e (forward)
    dec eax                                      # 0051139f
    je.d32 L_0051158e                            # 005113a0
    # block 0x005113a6: entered by fall-through of je at 0x005113a0, 1 instruction(s), ends with forward jump to 0x005116b3
    jmp.d32 L_005116b3                           # 005113a6
L_005113ab:
    # block 0x005113ab: entered by je at 0x0051136e, 4 instruction(s), calls FUN_00511888, falls into the block at 0x005113be
    call FUN_00511888                            # 005113ab
    pop ecx                                      # 005113b0
    mov byte ptr [ebp - local_248], al           # 005113b1
    mov dword ptr [ebp - local_c], 0x1           # 005113b7
L_005113be:
    # block 0x005113be: entered by jge at 0x0051138a; jmp at 0x00511393, 3 instruction(s), ends with forward jump to 0x005116b3
    lea eax, [ebp - local_248]                   # 005113be
    mov dword ptr [ebp - local_8], eax           # 005113c4
    jmp.d32 L_005116b3                           # 005113c7
L_005113cc:
    # block 0x005113cc: entered by je at 0x00511398, 6 instruction(s), calls FUN_00511888, ends with je to 0x0051140d (forward)
    lea eax, [ebp + arg_10]                      # 005113cc
    push eax                                     # 005113cf
    call FUN_00511888                            # 005113d0
    test eax, eax                                # 005113d5
    pop ecx                                      # 005113d7
    je.d8 L_0051140d                             # 005113d8
    # block 0x005113da: entered by fall-through of je at 0x005113d8, 3 instruction(s), ends with je to 0x0051140d (forward)
    mov ecx, dword ptr [eax + field_4]           # 005113da
    test ecx, ecx                                # 005113dd
    je.d8 L_0051140d                             # 005113df
    # block 0x005113e1: entered by fall-through of je at 0x005113df, 2 instruction(s), ends with je to 0x005113fe (forward)
    test byte ptr [ebp - local_3], 0x8           # 005113e1
    je.d8 L_005113fe                             # 005113e5
    # block 0x005113e7: entered by fall-through of je at 0x005113e5, 6 instruction(s), ends with forward jump to 0x005116b3
    movsx eax, word ptr [eax]                    # 005113e7
    shr eax                                      # 005113ea
    mov dword ptr [ebp - local_8], ecx           # 005113ec
    mov dword ptr [ebp - local_c], eax           # 005113ef
    mov dword ptr [ebp - local_24], 0x1          # 005113f2
    jmp.d32 L_005116b3                           # 005113f9
L_005113fe:
    # block 0x005113fe: entered by je at 0x005113e5, 4 instruction(s), ends with forward jump to 0x005116b0
    and dword ptr [ebp - local_24], 0x0          # 005113fe
    mov dword ptr [ebp - local_8], ecx           # 00511402
    movsx eax, word ptr [eax]                    # 00511405
    jmp.d32 L_005116b0                           # 00511408
L_0051140d:
    # block 0x0051140d: entered by je at 0x005113d8; je at 0x005113df, 4 instruction(s), ends with forward jump to 0x005114a9
    mov eax, dword ptr [0x5681f8]                # 0051140d
    mov dword ptr [ebp - local_8], eax           # 00511412
    push eax                                     # 00511415
    jmp.d32 L_005114a9                           # 00511416
L_0051141b:
    # block 0x0051141b: entered by jge at 0x00511346, 1 instruction(s), ends with jne to 0x00511429 (forward)
    jne.d8 L_00511429                            # 0051141b
    # block 0x0051141d: entered by fall-through of jne at 0x0051141b, 2 instruction(s), ends with jne to 0x00511429 (forward)
    cmp bl, 0x67                                 # 0051141d
    jne.d8 L_00511429                            # 00511420
    # block 0x00511422: entered by fall-through of jne at 0x00511420, 1 instruction(s), falls into the block at 0x00511429
    mov dword ptr [ebp - local_10], 0x1          # 00511422
L_00511429:
    # block 0x00511429: entered by jmp at 0x00511353; jne at 0x0051141b; jne at 0x00511420, 20 instruction(s), calls indirect dword ptr [0x568418], ends with je to 0x0051147b (forward)
    mov eax, dword ptr [ebp + arg_10]            # 00511429
    push dword ptr [ebp - local_34]              # 0051142c
    add eax, 0x8                                 # 0051142f
    mov dword ptr [ebp + arg_10], eax            # 00511432
    push dword ptr [ebp - local_10]              # 00511435
    mov ecx, dword ptr [eax - field_minus_8]     # 00511438
    mov dword ptr [ebp - local_48], ecx          # 0051143b
    mov eax, dword ptr [eax - field_minus_4]     # 0051143e
    mov dword ptr [ebp - local_44], eax          # 00511441
    movsx eax, bl                                # 00511444
    push eax                                     # 00511447
    lea eax, [ebp - local_248]                   # 00511448
    push eax                                     # 0051144e
    lea eax, [ebp - local_48]                    # 0051144f
    push eax                                     # 00511452
    call dword ptr [0x568418]                    # 00511453
    mov esi, dword ptr [ebp - local_4]           # 00511459
    add esp, 0x14                                # 0051145c
    and esi, 0x80                                # 0051145f
    je.d8 L_0051147b                             # 00511465
    # block 0x00511467: entered by fall-through of je at 0x00511465, 2 instruction(s), ends with jne to 0x0051147b (forward)
    cmp dword ptr [ebp - local_10], 0x0          # 00511467
    jne.d8 L_0051147b                            # 0051146b
    # block 0x0051146d: entered by fall-through of jne at 0x0051146b, 4 instruction(s), calls indirect dword ptr [0x568424], falls into the block at 0x0051147b
    lea eax, [ebp - local_248]                   # 0051146d
    push eax                                     # 00511473
    call dword ptr [0x568424]                    # 00511474
    pop ecx                                      # 0051147a
L_0051147b:
    # block 0x0051147b: entered by je at 0x00511465; jne at 0x0051146b, 2 instruction(s), ends with jne to 0x00511492 (forward)
    cmp bl, 0x67                                 # 0051147b
    jne.d8 L_00511492                            # 0051147e
    # block 0x00511480: entered by fall-through of jne at 0x0051147e, 2 instruction(s), ends with jne to 0x00511492 (forward)
    test esi, esi                                # 00511480
    jne.d8 L_00511492                            # 00511482
    # block 0x00511484: entered by fall-through of jne at 0x00511482, 4 instruction(s), calls indirect dword ptr [0x56841c], falls into the block at 0x00511492
    lea eax, [ebp - local_248]                   # 00511484
    push eax                                     # 0051148a
    call dword ptr [0x56841c]                    # 0051148b
    pop ecx                                      # 00511491
L_00511492:
    # block 0x00511492: entered by jne at 0x0051147e; jne at 0x00511482, 2 instruction(s), ends with jne to 0x005114a8 (forward)
    cmp byte ptr [ebp - local_248], 0x2d         # 00511492
    jne.d8 L_005114a8                            # 00511499
    # block 0x0051149b: entered by fall-through of jne at 0x00511499, 3 instruction(s), falls into the block at 0x005114a8
    or byte ptr [ebp - local_3], 0x1             # 0051149b
    lea edi, [ebp - local_247]                   # 0051149f
    mov dword ptr [ebp - local_8], edi           # 005114a5
L_005114a8:
    # block 0x005114a8: entered by jne at 0x00511499, 1 instruction(s), falls into the block at 0x005114a9
    push edi                                     # 005114a8
L_005114a9:
    # block 0x005114a9: entered by jmp at 0x00511416, 3 instruction(s), calls FUN_00511f30, ends with forward jump to 0x005116b0
    call FUN_00511f30                            # 005114a9
    pop ecx                                      # 005114ae
    jmp.d32 L_005116b0                           # 005114af
L_005114b4:
    # block 0x005114b4: entered by jg at 0x00511292, 2 instruction(s), ends with je to 0x0051158e (forward)
    sub eax, 0x69                                # 005114b4
    je.d32 L_0051158e                            # 005114b7
    # block 0x005114bd: entered by fall-through of je at 0x005114b7, 2 instruction(s), ends with je to 0x00511564 (forward)
    sub eax, 0x5                                 # 005114bd
    je.d32 L_00511564                            # 005114c0
    # block 0x005114c6: entered by fall-through of je at 0x005114c0, 2 instruction(s), ends with je to 0x00511551 (forward)
    dec eax                                      # 005114c6
    je.d32 L_00511551                            # 005114c7
    # block 0x005114cd: entered by fall-through of je at 0x005114c7, 2 instruction(s), ends with je to 0x00511521 (forward)
    dec eax                                      # 005114cd
    je.d8 L_00511521                             # 005114ce
    # block 0x005114d0: entered by fall-through of je at 0x005114ce, 2 instruction(s), ends with je to 0x005112d6 (backward)
    sub eax, 0x3                                 # 005114d0
    je.d32 L_005112d6                            # 005114d3
    # block 0x005114d9: entered by fall-through of je at 0x005114d3, 3 instruction(s), ends with je to 0x00511592 (forward)
    dec eax                                      # 005114d9
    dec eax                                      # 005114da
    je.d32 L_00511592                            # 005114db
    # block 0x005114e1: entered by fall-through of je at 0x005114db, 2 instruction(s), ends with jne to 0x005116b3 (forward)
    sub eax, 0x3                                 # 005114e1
    jne.d32 L_005116b3                           # 005114e4
    # block 0x005114ea: entered by fall-through of jne at 0x005114e4, 2 instruction(s), ends with forward jump to 0x0051152f
    mov dword ptr [ebp - local_2c], 0x27         # 005114ea
    jmp.d8 L_0051152f                            # 005114f1
L_005114f3:
    # block 0x005114f3: entered by je at 0x00511319; je at 0x00511323, 3 instruction(s), ends with forward jump to 0x005116b0
    {load} sub eax, ecx                          # 005114f3
    sar eax                                      # 005114f5
    jmp.d32 L_005116b0                           # 005114f7
L_005114fc:
    # block 0x005114fc: entered by je at 0x005112f8, 2 instruction(s), ends with jne to 0x00511509 (forward)
    test ecx, ecx                                # 005114fc
    jne.d8 L_00511509                            # 005114fe
    # block 0x00511500: entered by fall-through of jne at 0x005114fe, 2 instruction(s), falls into the block at 0x00511509
    mov ecx, dword ptr [0x5681f8]                # 00511500
    mov dword ptr [ebp - local_8], ecx           # 00511506
L_00511509:
    # block 0x00511509: entered by jne at 0x005114fe, 1 instruction(s), falls into the block at 0x0051150b
    {load} mov eax, ecx                          # 00511509
L_0051150b:
    # block 0x0051150b: entered by jmp at 0x00511518, 4 instruction(s), ends with je to 0x0051151a (forward)
    {load} mov edx, esi                          # 0051150b
    dec esi                                      # 0051150d
    test edx, edx                                # 0051150e
    je.d8 L_0051151a                             # 00511510
    # block 0x00511512: entered by fall-through of je at 0x00511510, 2 instruction(s), ends with je to 0x0051151a (forward)
    cmp byte ptr [eax], 0x0                      # 00511512
    je.d8 L_0051151a                             # 00511515
    # block 0x00511517: entered by fall-through of je at 0x00511515, 2 instruction(s), ends with backward jump to 0x0051150b
    inc eax                                      # 00511517
    jmp.d8 L_0051150b                            # 00511518
L_0051151a:
    # block 0x0051151a: entered by je at 0x00511510; je at 0x00511515, 2 instruction(s), ends with forward jump to 0x005116b0
    {load} sub eax, ecx                          # 0051151a
    jmp.d32 L_005116b0                           # 0051151c
L_00511521:
    # block 0x00511521: entered by je at 0x005114ce, 1 instruction(s), falls into the block at 0x00511528
    mov dword ptr [ebp - local_10], 0x8          # 00511521
L_00511528:
    # block 0x00511528: entered by je at 0x005112aa, 1 instruction(s), falls into the block at 0x0051152f
    mov dword ptr [ebp - local_2c], 0x7          # 00511528
L_0051152f:
    # block 0x0051152f: entered by jmp at 0x005114f1, 3 instruction(s), ends with je to 0x00511599 (forward)
    test byte ptr [ebp - local_4], -0x80         # 0051152f
    mov dword ptr [ebp - local_c], 0x10          # 00511533
    je.d8 L_00511599                             # 0051153a
    # block 0x0051153c: entered by fall-through of je at 0x0051153a, 6 instruction(s), ends with forward jump to 0x00511599
    mov al, byte ptr [ebp - local_2c]            # 0051153c
    mov byte ptr [ebp - local_16], 0x30          # 0051153f
    add al, 0x51                                 # 00511543
    mov dword ptr [ebp - local_1c], 0x2          # 00511545
    mov byte ptr [ebp - local_15], al            # 0051154c
    jmp.d8 L_00511599                            # 0051154f
L_00511551:
    # block 0x00511551: entered by je at 0x005114c7, 3 instruction(s), ends with je to 0x00511599 (forward)
    test byte ptr [ebp - local_4], -0x80         # 00511551
    mov dword ptr [ebp - local_c], 0x8           # 00511555
    je.d8 L_00511599                             # 0051155c
    # block 0x0051155e: entered by fall-through of je at 0x0051155c, 2 instruction(s), ends with forward jump to 0x00511599
    or byte ptr [ebp - local_3], 0x2             # 0051155e
    jmp.d8 L_00511599                            # 00511562
L_00511564:
    # block 0x00511564: entered by je at 0x005114c0, 6 instruction(s), calls FUN_00511888, ends with je to 0x0051157d (forward)
    lea eax, [ebp + arg_10]                      # 00511564
    push eax                                     # 00511567
    call FUN_00511888                            # 00511568
    test byte ptr [ebp - local_4], 0x20          # 0051156d
    pop ecx                                      # 00511571
    je.d8 L_0051157d                             # 00511572
    # block 0x00511574: entered by fall-through of je at 0x00511572, 3 instruction(s), ends with forward jump to 0x00511582
    mov cx, word ptr [ebp - local_14]            # 00511574
    mov word ptr [eax], cx                       # 00511578
    jmp.d8 L_00511582                            # 0051157b
L_0051157d:
    # block 0x0051157d: entered by je at 0x00511572, 2 instruction(s), falls into the block at 0x00511582
    mov ecx, dword ptr [ebp - local_14]          # 0051157d
    mov dword ptr [eax], ecx                     # 00511580
L_00511582:
    # block 0x00511582: entered by jmp at 0x0051157b, 2 instruction(s), ends with forward jump to 0x005117b1
    mov dword ptr [ebp - local_28], 0x1          # 00511582
    jmp.d32 L_005117b1                           # 00511589
L_0051158e:
    # block 0x0051158e: entered by je at 0x005113a0; je at 0x005114b7, 1 instruction(s), falls into the block at 0x00511592
    or dword ptr [ebp - local_4], 0x40           # 0051158e
L_00511592:
    # block 0x00511592: entered by je at 0x005114db, 1 instruction(s), falls into the block at 0x00511599
    mov dword ptr [ebp - local_c], 0xa           # 00511592
L_00511599:
    # block 0x00511599: entered by je at 0x0051153a; jmp at 0x0051154f; je at 0x0051155c; jmp at 0x00511562, 2 instruction(s), ends with je to 0x005115ab (forward)
    test byte ptr [ebp - local_3], -0x80         # 00511599
    je.d8 L_005115ab                             # 0051159d
    # block 0x0051159f: entered by fall-through of je at 0x0051159d, 5 instruction(s), calls FUN_00511895, ends with forward jump to 0x005115ec
    lea eax, [ebp + arg_10]                      # 0051159f
    push eax                                     # 005115a2
    call FUN_00511895                            # 005115a3
    pop ecx                                      # 005115a8
    jmp.d8 L_005115ec                            # 005115a9
L_005115ab:
    # block 0x005115ab: entered by je at 0x0051159d, 2 instruction(s), ends with je to 0x005115d2 (forward)
    test byte ptr [ebp - local_4], 0x20          # 005115ab
    je.d8 L_005115d2                             # 005115af
    # block 0x005115b1: entered by fall-through of je at 0x005115af, 4 instruction(s), ends with je to 0x005115c7 (forward)
    test byte ptr [ebp - local_4], 0x40          # 005115b1
    lea eax, [ebp + arg_10]                      # 005115b5
    push eax                                     # 005115b8
    je.d8 L_005115c7                             # 005115b9
    # block 0x005115bb: entered by fall-through of je at 0x005115b9, 3 instruction(s), calls FUN_00511888, falls into the block at 0x005115c4
    call FUN_00511888                            # 005115bb
    pop ecx                                      # 005115c0
    movsx eax, ax                                # 005115c1
L_005115c4:
    # block 0x005115c4: entered by jmp at 0x005115d0; jmp at 0x005115e2, 2 instruction(s), ends with forward jump to 0x005115ec
    cdq                                          # 005115c4
    jmp.d8 L_005115ec                            # 005115c5
L_005115c7:
    # block 0x005115c7: entered by je at 0x005115b9, 4 instruction(s), calls FUN_00511888, ends with backward jump to 0x005115c4
    call FUN_00511888                            # 005115c7
    pop ecx                                      # 005115cc
    movzx eax, ax                                # 005115cd
    jmp.d8 L_005115c4                            # 005115d0
L_005115d2:
    # block 0x005115d2: entered by je at 0x005115af, 4 instruction(s), ends with je to 0x005115e4 (forward)
    test byte ptr [ebp - local_4], 0x40          # 005115d2
    lea eax, [ebp + arg_10]                      # 005115d6
    push eax                                     # 005115d9
    je.d8 L_005115e4                             # 005115da
    # block 0x005115dc: entered by fall-through of je at 0x005115da, 3 instruction(s), calls FUN_00511888, ends with backward jump to 0x005115c4
    call FUN_00511888                            # 005115dc
    pop ecx                                      # 005115e1
    jmp.d8 L_005115c4                            # 005115e2
L_005115e4:
    # block 0x005115e4: entered by je at 0x005115da, 3 instruction(s), calls FUN_00511888, falls into the block at 0x005115ec
    call FUN_00511888                            # 005115e4
    pop ecx                                      # 005115e9
    {load} xor edx, edx                          # 005115ea
L_005115ec:
    # block 0x005115ec: entered by jmp at 0x005115a9; jmp at 0x005115c5, 2 instruction(s), ends with je to 0x0051160d (forward)
    test byte ptr [ebp - local_4], 0x40          # 005115ec
    je.d8 L_0051160d                             # 005115f0
    # block 0x005115f2: entered by fall-through of je at 0x005115f0, 2 instruction(s), ends with jg to 0x0051160d (forward)
    test edx, edx                                # 005115f2
    jg.d8 L_0051160d                             # 005115f4
    # block 0x005115f6: entered by fall-through of jg at 0x005115f4, 1 instruction(s), ends with jl to 0x005115fc (forward)
    jl.d8 L_005115fc                             # 005115f6
    # block 0x005115f8: entered by fall-through of jl at 0x005115f6, 2 instruction(s), ends with jae to 0x0051160d (forward)
    test eax, eax                                # 005115f8
    jae.d8 L_0051160d                            # 005115fa
L_005115fc:
    # block 0x005115fc: entered by jl at 0x005115f6; fall-through of jae at 0x005115fa, 7 instruction(s), ends with forward jump to 0x00511611
    neg eax                                      # 005115fc
    adc edx, 0x0                                 # 005115fe
    {load} mov esi, eax                          # 00511601
    neg edx                                      # 00511603
    or byte ptr [ebp - local_3], 0x1             # 00511605
    {load} mov edi, edx                          # 00511609
    jmp.d8 L_00511611                            # 0051160b
L_0051160d:
    # block 0x0051160d: entered by je at 0x005115f0; jg at 0x005115f4; jae at 0x005115fa, 2 instruction(s), falls into the block at 0x00511611
    {load} mov esi, eax                          # 0051160d
    {load} mov edi, edx                          # 0051160f
L_00511611:
    # block 0x00511611: entered by jmp at 0x0051160b, 2 instruction(s), ends with jne to 0x0051161a (forward)
    test byte ptr [ebp - local_3], -0x80         # 00511611
    jne.d8 L_0051161a                            # 00511615
    # block 0x00511617: entered by fall-through of jne at 0x00511615, 1 instruction(s), falls into the block at 0x0051161a
    and edi, 0x0                                 # 00511617
L_0051161a:
    # block 0x0051161a: entered by jne at 0x00511615, 2 instruction(s), ends with jge to 0x00511629 (forward)
    cmp dword ptr [ebp - local_10], 0x0          # 0051161a
    jge.d8 L_00511629                            # 0051161e
    # block 0x00511620: entered by fall-through of jge at 0x0051161e, 2 instruction(s), ends with forward jump to 0x0051162d
    mov dword ptr [ebp - local_10], 0x1          # 00511620
    jmp.d8 L_0051162d                            # 00511627
L_00511629:
    # block 0x00511629: entered by jge at 0x0051161e, 1 instruction(s), falls into the block at 0x0051162d
    and dword ptr [ebp - local_4], -0x9          # 00511629
L_0051162d:
    # block 0x0051162d: entered by jmp at 0x00511627, 3 instruction(s), ends with jne to 0x00511637 (forward)
    {load} mov eax, esi                          # 0051162d
    {load} or eax, edi                           # 0051162f
    jne.d8 L_00511637                            # 00511631
    # block 0x00511633: entered by fall-through of jne at 0x00511631, 1 instruction(s), falls into the block at 0x00511637
    and dword ptr [ebp - local_1c], 0x0          # 00511633
L_00511637:
    # block 0x00511637: entered by jne at 0x00511631, 2 instruction(s), falls into the block at 0x0051163d
    lea eax, [ebp - local_49]                    # 00511637
    mov dword ptr [ebp - local_8], eax           # 0051163a
L_0051163d:
    # block 0x0051163d: entered by jmp at 0x00511686, 4 instruction(s), ends with jg to 0x0051164d (forward)
    mov eax, dword ptr [ebp - local_10]          # 0051163d
    dec dword ptr [ebp - local_10]               # 00511640
    test eax, eax                                # 00511643
    jg.d8 L_0051164d                             # 00511645
    # block 0x00511647: entered by fall-through of jg at 0x00511645, 3 instruction(s), ends with je to 0x00511688 (forward)
    {load} mov eax, esi                          # 00511647
    {load} or eax, edi                           # 00511649
    je.d8 L_00511688                             # 0051164b
L_0051164d:
    # block 0x0051164d: entered by jg at 0x00511645; fall-through of je at 0x0051164b, 20 instruction(s), calls FUN_00516810, FUN_005167a0, ends with jle to 0x0051167e (forward)
    mov eax, dword ptr [ebp - local_c]           # 0051164d
    cdq                                          # 00511650
    push edx                                     # 00511651
    push eax                                     # 00511652
    push edi                                     # 00511653
    push esi                                     # 00511654
    mov dword ptr [ebp - local_40], eax          # 00511655
    mov dword ptr [ebp - local_3c], edx          # 00511658
    call FUN_00516810                            # 0051165b
    push dword ptr [ebp - local_3c]              # 00511660
    {load} mov ebx, eax                          # 00511663
    add ebx, 0x30                                # 00511665
    push dword ptr [ebp - local_40]              # 00511668
    push edi                                     # 0051166b
    push esi                                     # 0051166c
    call FUN_005167a0                            # 0051166d
    cmp ebx, 0x39                                # 00511672
    {load} mov esi, eax                          # 00511675
    {load} mov edi, edx                          # 00511677
    jle.d8 L_0051167e                            # 00511679
    # block 0x0051167b: entered by fall-through of jle at 0x00511679, 1 instruction(s), falls into the block at 0x0051167e
    add ebx, dword ptr [ebp - local_2c]          # 0051167b
L_0051167e:
    # block 0x0051167e: entered by jle at 0x00511679, 4 instruction(s), ends with backward jump to 0x0051163d
    mov eax, dword ptr [ebp - local_8]           # 0051167e
    dec dword ptr [ebp - local_8]                # 00511681
    mov byte ptr [eax], bl                       # 00511684
    jmp.d8 L_0051163d                            # 00511686
L_00511688:
    # block 0x00511688: entered by je at 0x0051164b, 6 instruction(s), ends with je to 0x005116b3 (forward)
    lea eax, [ebp - local_49]                    # 00511688
    sub eax, dword ptr [ebp - local_8]           # 0051168b
    inc dword ptr [ebp - local_8]                # 0051168e
    test byte ptr [ebp - local_3], 0x2           # 00511691
    mov dword ptr [ebp - local_c], eax           # 00511695
    je.d8 L_005116b3                             # 00511698
    # block 0x0051169a: entered by fall-through of je at 0x00511698, 3 instruction(s), ends with jne to 0x005116a6 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0051169a
    cmp byte ptr [ecx], 0x30                     # 0051169d
    jne.d8 L_005116a6                            # 005116a0
    # block 0x005116a2: entered by fall-through of jne at 0x005116a0, 2 instruction(s), ends with jne to 0x005116b3 (forward)
    test eax, eax                                # 005116a2
    jne.d8 L_005116b3                            # 005116a4
L_005116a6:
    # block 0x005116a6: entered by jne at 0x005116a0; fall-through of jne at 0x005116a4, 4 instruction(s), falls into the block at 0x005116b0
    dec dword ptr [ebp - local_8]                # 005116a6
    inc eax                                      # 005116a9
    mov ecx, dword ptr [ebp - local_8]           # 005116aa
    mov byte ptr [ecx], 0x30                     # 005116ad
L_005116b0:
    # block 0x005116b0: entered by jmp at 0x00511408; jmp at 0x005114af; jmp at 0x005114f7; jmp at 0x0051151c, 1 instruction(s), falls into the block at 0x005116b3
    mov dword ptr [ebp - local_c], eax           # 005116b0
L_005116b3:
    # block 0x005116b3: entered by jne at 0x005112c4; jmp at 0x005113a6; jmp at 0x005113c7; jmp at 0x005113f9; more, 2 instruction(s), ends with jne to 0x005117b1 (forward)
    cmp dword ptr [ebp - local_28], 0x0          # 005116b3
    jne.d32 L_005117b1                           # 005116b7
    # block 0x005116bd: entered by fall-through of jne at 0x005116b7, 3 instruction(s), ends with je to 0x005116eb (forward)
    mov ebx, dword ptr [ebp - local_4]           # 005116bd
    test bl, 0x40                                # 005116c0
    je.d8 L_005116eb                             # 005116c3
    # block 0x005116c5: entered by fall-through of je at 0x005116c3, 2 instruction(s), ends with je to 0x005116d0 (forward)
    test bh, 0x1                                 # 005116c5
    je.d8 L_005116d0                             # 005116c8
    # block 0x005116ca: entered by fall-through of je at 0x005116c8, 2 instruction(s), ends with forward jump to 0x005116e4
    mov byte ptr [ebp - local_16], 0x2d          # 005116ca
    jmp.d8 L_005116e4                            # 005116ce
L_005116d0:
    # block 0x005116d0: entered by je at 0x005116c8, 2 instruction(s), ends with je to 0x005116db (forward)
    test bl, 0x1                                 # 005116d0
    je.d8 L_005116db                             # 005116d3
    # block 0x005116d5: entered by fall-through of je at 0x005116d3, 2 instruction(s), ends with forward jump to 0x005116e4
    mov byte ptr [ebp - local_16], 0x2b          # 005116d5
    jmp.d8 L_005116e4                            # 005116d9
L_005116db:
    # block 0x005116db: entered by je at 0x005116d3, 2 instruction(s), ends with je to 0x005116eb (forward)
    test bl, 0x2                                 # 005116db
    je.d8 L_005116eb                             # 005116de
    # block 0x005116e0: entered by fall-through of je at 0x005116de, 1 instruction(s), falls into the block at 0x005116e4
    mov byte ptr [ebp - local_16], 0x20          # 005116e0
L_005116e4:
    # block 0x005116e4: entered by jmp at 0x005116ce; jmp at 0x005116d9, 1 instruction(s), falls into the block at 0x005116eb
    mov dword ptr [ebp - local_1c], 0x1          # 005116e4
L_005116eb:
    # block 0x005116eb: entered by je at 0x005116c3; je at 0x005116de, 5 instruction(s), ends with jne to 0x0051170b (forward)
    mov esi, dword ptr [ebp - local_20]          # 005116eb
    sub esi, dword ptr [ebp - local_1c]          # 005116ee
    sub esi, dword ptr [ebp - local_c]           # 005116f1
    test bl, 0xc                                 # 005116f4
    jne.d8 L_0051170b                            # 005116f7
    # block 0x005116f9: entered by fall-through of jne at 0x005116f7, 7 instruction(s), calls FUN_0051181f, falls into the block at 0x0051170b
    lea eax, [ebp - local_14]                    # 005116f9
    push eax                                     # 005116fc
    push dword ptr [ebp + arg_8]                 # 005116fd
    push esi                                     # 00511700
    push 0x20                                    # 00511701
    call FUN_0051181f                            # 00511703
    add esp, 0x10                                # 00511708
L_0051170b:
    # block 0x0051170b: entered by jne at 0x005116f7, 10 instruction(s), calls FUN_00511850, ends with je to 0x0051173d (forward)
    lea eax, [ebp - local_14]                    # 0051170b
    push eax                                     # 0051170e
    lea eax, [ebp - local_16]                    # 0051170f
    push dword ptr [ebp + arg_8]                 # 00511712
    push dword ptr [ebp - local_1c]              # 00511715
    push eax                                     # 00511718
    call FUN_00511850                            # 00511719
    add esp, 0x10                                # 0051171e
    test bl, 0x8                                 # 00511721
    je.d8 L_0051173d                             # 00511724
    # block 0x00511726: entered by fall-through of je at 0x00511724, 2 instruction(s), ends with jne to 0x0051173d (forward)
    test bl, 0x4                                 # 00511726
    jne.d8 L_0051173d                            # 00511729
    # block 0x0051172b: entered by fall-through of jne at 0x00511729, 7 instruction(s), calls FUN_0051181f, falls into the block at 0x0051173d
    lea eax, [ebp - local_14]                    # 0051172b
    push eax                                     # 0051172e
    push dword ptr [ebp + arg_8]                 # 0051172f
    push esi                                     # 00511732
    push 0x30                                    # 00511733
    call FUN_0051181f                            # 00511735
    add esp, 0x10                                # 0051173a
L_0051173d:
    # block 0x0051173d: entered by je at 0x00511724; jne at 0x00511729, 2 instruction(s), ends with je to 0x00511784 (forward)
    cmp dword ptr [ebp - local_24], 0x0          # 0051173d
    je.d8 L_00511784                             # 00511741
    # block 0x00511743: entered by fall-through of je at 0x00511741, 2 instruction(s), ends with jle to 0x00511784 (forward)
    cmp dword ptr [ebp - local_c], 0x0           # 00511743
    jle.d8 L_00511784                            # 00511747
    # block 0x00511749: entered by fall-through of jle at 0x00511747, 3 instruction(s), falls into the block at 0x00511752
    mov eax, dword ptr [ebp - local_c]           # 00511749
    mov ebx, dword ptr [ebp - local_8]           # 0051174c
    lea edi, [eax - field_minus_1]               # 0051174f
L_00511752:
    # block 0x00511752: entered by jne at 0x00511780, 11 instruction(s), calls FUN_005166d4, ends with jle to 0x00511799 (forward)
    mov ax, word ptr [ebx]                       # 00511752
    inc ebx                                      # 00511755
    push eax                                     # 00511756
    lea eax, [ebp - local_38]                    # 00511757
    push eax                                     # 0051175a
    inc ebx                                      # 0051175b
    call FUN_005166d4                            # 0051175c
    pop ecx                                      # 00511761
    test eax, eax                                # 00511762
    pop ecx                                      # 00511764
    jle.d8 L_00511799                            # 00511765
    # block 0x00511767: entered by fall-through of jle at 0x00511765, 12 instruction(s), calls FUN_00511850, ends with jne to 0x00511752 (backward)
    lea ecx, [ebp - local_14]                    # 00511767
    push ecx                                     # 0051176a
    push dword ptr [ebp + arg_8]                 # 0051176b
    push eax                                     # 0051176e
    lea eax, [ebp - local_38]                    # 0051176f
    push eax                                     # 00511772
    call FUN_00511850                            # 00511773
    add esp, 0x10                                # 00511778
    {load} mov eax, edi                          # 0051177b
    dec edi                                      # 0051177d
    test eax, eax                                # 0051177e
    jne.d8 L_00511752                            # 00511780
    # block 0x00511782: entered by fall-through of jne at 0x00511780, 1 instruction(s), ends with forward jump to 0x00511799
    jmp.d8 L_00511799                            # 00511782
L_00511784:
    # block 0x00511784: entered by je at 0x00511741; jle at 0x00511747, 7 instruction(s), calls FUN_00511850, falls into the block at 0x00511799
    lea eax, [ebp - local_14]                    # 00511784
    push eax                                     # 00511787
    push dword ptr [ebp + arg_8]                 # 00511788
    push dword ptr [ebp - local_c]               # 0051178b
    push dword ptr [ebp - local_8]               # 0051178e
    call FUN_00511850                            # 00511791
    add esp, 0x10                                # 00511796
L_00511799:
    # block 0x00511799: entered by jle at 0x00511765; jmp at 0x00511782, 2 instruction(s), ends with je to 0x005117b1 (forward)
    test byte ptr [ebp - local_4], 0x4           # 00511799
    je.d8 L_005117b1                             # 0051179d
    # block 0x0051179f: entered by fall-through of je at 0x0051179d, 7 instruction(s), calls FUN_0051181f, falls into the block at 0x005117b1
    lea eax, [ebp - local_14]                    # 0051179f
    push eax                                     # 005117a2
    push dword ptr [ebp + arg_8]                 # 005117a3
    push esi                                     # 005117a6
    push 0x20                                    # 005117a7
    call FUN_0051181f                            # 005117a9
    add esp, 0x10                                # 005117ae
L_005117b1:
    # block 0x005117b1: entered by ja at 0x00511111; jmp at 0x00511134; jne at 0x00511152; jmp at 0x0051115c; more, 6 instruction(s), ends with jne to 0x005110d5 (backward)
    mov edi, dword ptr [ebp + arg_c]             # 005117b1
    mov bl, byte ptr [edi]                       # 005117b4
    inc edi                                      # 005117b6
    test bl, bl                                  # 005117b7
    mov dword ptr [ebp + arg_c], edi             # 005117b9
    jne.d32 L_005110d5                           # 005117bc
L_005117c2:
    # block 0x005117c2: entered by je at 0x005110c8; jl at 0x005110e0; fall-through of jne at 0x005117bc, 6 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_14]          # 005117c2
    pop edi                                      # 005117c5
    pop esi                                      # 005117c6
    pop ebx                                      # 005117c7
    leave                                        # 005117c8
    ret                                          # 005117c9

# --- data items (not part of the function) -------------------------
.org 0x005117ca - 0x401000
SWTAB_005117ca:  # 8 case address(es)
    .long L_00511248 - .text + 0x401000
    .long L_0051111e - .text + 0x401000
    .long L_00511139 - .text + 0x401000
    .long L_00511185 - .text + 0x401000
    .long L_005111bc - .text + 0x401000
    .long L_005111c4 - .text + 0x401000
    .long L_005111f9 - .text + 0x401000
    .long L_0051128c - .text + 0x401000
.set SWTAB_005117ca_VA, SWTAB_005117ca - .text + 0x401000

