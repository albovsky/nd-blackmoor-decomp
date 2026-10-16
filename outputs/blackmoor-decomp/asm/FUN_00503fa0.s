# FUN_00503fa0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00503fa0
# extent:       0x00503fa0-0x00504402 (1122 code bytes)
# span:         0x00503fa0-0x00504410 (code 1122, tables 0, padding 14)
# sha256:       9198ab3dd0f01e0ab1402f49475361e6e4ef3757287f34b55d4977fa1e03ef5e
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00503fa0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_minus_1, field_minus_4; [ebp + n] field_minus_4; [ebx + n] field_minus_4; [ecx + n] field_4, field_minus_4; [edi + n] field_minus_4; [edx + n] field_minus_4; [esi + n] field_minus_4; [esp + n] stk_10, stk_14, stk_18, stk_1c, stk_20, stk_24, stk_28, stk_2c, stk_30, stk_34, stk_38, stk_3c and 18 more
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 333 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ field_minus_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ stk_30, 0x30  # offset +0x30
.equ stk_34, 0x34  # offset +0x34
.equ stk_38, 0x38  # offset +0x38
.equ stk_3c, 0x3c  # offset +0x3c
.equ stk_40, 0x40  # offset +0x40
.equ stk_44, 0x44  # offset +0x44
.equ stk_48, 0x48  # offset +0x48
.equ stk_4c, 0x4c  # offset +0x4c
.equ stk_50, 0x50  # offset +0x50
.equ stk_54, 0x54  # offset +0x54
.equ stk_58, 0x58  # offset +0x58
.equ stk_5c, 0x5c  # offset +0x5c
.equ stk_60, 0x60  # offset +0x60
.equ stk_64, 0x64  # offset +0x64
.equ stk_68, 0x68  # offset +0x68
.equ stk_70, 0x70  # offset +0x70
.equ stk_74, 0x74  # offset +0x74
.equ stk_78, 0x78  # offset +0x78
.equ stk_7c, 0x7c  # offset +0x7c
.equ stk_80, 0x80  # offset +0x80
.equ stk_84, 0x84  # offset +0x84
.equ stk_88, 0x88  # offset +0x88

# --- external targets -----------------------------------------------

.org 0x00503fa0 - 0x401000
.globl FUN_00503fa0
FUN_00503fa0:
    # block 0x00503fa0: entry, 15 instruction(s), ends with jle to 0x0050408e (forward)
    sub esp, 0x5c                                # 00503fa0
    mov eax, dword ptr [esp + stk_60]            # 00503fa3
    push ebx                                     # 00503fa7
    mov ebx, dword ptr [esp + stk_68]            # 00503fa8
    push ebp                                     # 00503fac
    {load} mov ebp, eax                          # 00503fad
    mov edx, dword ptr [esp + stk_74]            # 00503faf
    imul ebp, ebx                                # 00503fb3
    push esi                                     # 00503fb6
    mov esi, dword ptr [esp + stk_74]            # 00503fb7
    test ebx, ebx                                # 00503fbb
    push edi                                     # 00503fbd
    mov dword ptr [esp + stk_50], ebp            # 00503fbe
    mov dword ptr [esp + stk_1c], 0x0            # 00503fc2
    jle.d32 L_0050408e                           # 00503fca
    # block 0x00503fd0: entered by fall-through of jle at 0x00503fca, 11 instruction(s), falls into the block at 0x00503ffc
    {disp8} lea ecx, [ebp + 2*ebp]               # 00503fd0
    lea ebx, [esi + 4*ebp]                       # 00503fd4
    lea edi, [4*eax]                             # 00503fd7
    mov dword ptr [esp + stk_10], esi            # 00503fde
    lea ecx, [esi + 4*ecx]                       # 00503fe2
    mov dword ptr [esp + stk_28], ebx            # 00503fe5
    mov dword ptr [esp + stk_18], ecx            # 00503fe9
    lea ecx, [esi + 8*ebp]                       # 00503fed
    mov dword ptr [esp + stk_14], ecx            # 00503ff0
    mov ecx, dword ptr [esp + stk_74]            # 00503ff4
    mov dword ptr [esp + stk_24], ecx            # 00503ff8
L_00503ffc:
    # block 0x00503ffc: entered by jne at 0x00504084, 46 instruction(s), ends with jne to 0x00503ffc (backward)
    mov ecx, dword ptr [esp + stk_18]            # 00503ffc
    fld dword ptr [ebx]                          # 00504000
    fadd dword ptr [ecx]                         # 00504002
    mov ecx, dword ptr [esp + stk_14]            # 00504004
    fld dword ptr [ecx]                          # 00504008
    mov ecx, dword ptr [esp + stk_10]            # 0050400a
    fadd dword ptr [ecx]                         # 0050400e
    mov ecx, dword ptr [esp + stk_1c]            # 00504010
    shl ecx, 0x2                                 # 00504014
    fld st(0)                                    # 00504017
    fadd st, st(2)                               # 00504019
    lea ebx, [edi + ecx]                         # 0050401b
    fstp dword ptr [edx + 4*ecx]                 # 0050401e
    fsub st, st(1)                               # 00504021
    fstp dword ptr [edx + 4*ebx - field_minus_4] # 00504023
    lea ebx, [eax + eax]                         # 00504027
    {load} add ecx, ebx                          # 0050402a
    mov ebx, dword ptr [esp + stk_10]            # 0050402c
    fstp st(0)                                   # 00504030
    fld dword ptr [ebx]                          # 00504032
    mov ebx, dword ptr [esp + stk_14]            # 00504034
    fsub dword ptr [ebx]                         # 00504038
    mov ebx, dword ptr [esp + stk_18]            # 0050403a
    fstp dword ptr [edx + 4*ecx - field_minus_4] # 0050403e
    fld dword ptr [ebx]                          # 00504042
    mov ebx, dword ptr [esp + stk_28]            # 00504044
    fsub dword ptr [ebx]                         # 00504048
    {load} add ebx, edi                          # 0050404a
    mov dword ptr [esp + stk_28], ebx            # 0050404c
    fstp dword ptr [edx + 4*ecx]                 # 00504050
    mov ecx, dword ptr [esp + stk_1c]            # 00504053
    {load} add ecx, eax                          # 00504057
    mov dword ptr [esp + stk_1c], ecx            # 00504059
    mov ecx, dword ptr [esp + stk_10]            # 0050405d
    {load} add ecx, edi                          # 00504061
    mov dword ptr [esp + stk_10], ecx            # 00504063
    mov ecx, dword ptr [esp + stk_14]            # 00504067
    {load} add ecx, edi                          # 0050406b
    mov dword ptr [esp + stk_14], ecx            # 0050406d
    mov ecx, dword ptr [esp + stk_18]            # 00504071
    {load} add ecx, edi                          # 00504075
    mov dword ptr [esp + stk_18], ecx            # 00504077
    mov ecx, dword ptr [esp + stk_24]            # 0050407b
    dec ecx                                      # 0050407f
    mov dword ptr [esp + stk_24], ecx            # 00504080
    jne.d32 L_00503ffc                           # 00504084
    # block 0x0050408a: entered by fall-through of jne at 0x00504084, 1 instruction(s), falls into the block at 0x0050408e
    mov ebx, dword ptr [esp + stk_74]            # 0050408a
L_0050408e:
    # block 0x0050408e: entered by jle at 0x00503fca, 2 instruction(s), ends with jl to 0x005043fa (forward)
    cmp eax, 0x2                                 # 0050408e
    jl.d32 L_005043fa                            # 00504091
    # block 0x00504097: entered by fall-through of jl at 0x00504091, 1 instruction(s), ends with je to 0x0050433c (forward)
    je.d32 L_0050433c                            # 00504097
    # block 0x0050409d: entered by fall-through of je at 0x00504097, 4 instruction(s), ends with jle to 0x00504334 (forward)
    {load} xor edi, edi                          # 0050409d
    test ebx, ebx                                # 0050409f
    mov dword ptr [esp + stk_54], edi            # 005040a1
    jle.d32 L_00504334                           # 005040a5
    # block 0x005040ab: entered by fall-through of jle at 0x005040a5, 16 instruction(s), ends with forward jump to 0x005040ea
    lea ecx, [4*eax]                             # 005040ab
    lea ebx, [eax + eax]                         # 005040b2
    mov dword ptr [esp + stk_68], ecx            # 005040b5
    {load} mov ecx, eax                          # 005040b9
    shl ecx, 0x4                                 # 005040bb
    mov dword ptr [esp + stk_64], ecx            # 005040be
    {disp8} lea ecx, [ebp + 2*ebp]               # 005040c2
    mov dword ptr [esp + stk_5c], ebx            # 005040c6
    mov dword ptr [esp + stk_20], edx            # 005040ca
    lea ecx, [esi + 4*ecx]                       # 005040ce
    mov dword ptr [esp + stk_28], ecx            # 005040d1
    lea ecx, [esi + 4*ebp]                       # 005040d5
    mov dword ptr [esp + stk_24], ecx            # 005040d8
    mov ecx, dword ptr [esp + stk_74]            # 005040dc
    mov dword ptr [esp + stk_58], ecx            # 005040e0
    jmp.d8 L_005040ea                            # 005040e4
L_005040e6:
    # block 0x005040e6: entered by jne at 0x0050432a, 1 instruction(s), falls into the block at 0x005040ea
    mov ebx, dword ptr [esp + stk_5c]            # 005040e6
L_005040ea:
    # block 0x005040ea: entered by jmp at 0x005040e4, 3 instruction(s), ends with jle to 0x005042f5 (forward)
    cmp eax, 0x2                                 # 005040ea
    lea ecx, [ebx + 4*edi]                       # 005040ed
    jle.d32 L_005042f5                           # 005040f0
    # block 0x005040f6: entered by fall-through of jle at 0x005040f0, 36 instruction(s), falls into the block at 0x00504186
    lea eax, [edx + 4*ecx]                       # 005040f6
    {load} add ecx, ebx                          # 005040f9
    lea ebx, [ebx + 4*edi]                       # 005040fb
    mov dword ptr [esp + stk_18], eax            # 005040fe
    lea eax, [edx + 4*ecx]                       # 00504102
    lea ebp, [esi + 4*edi]                       # 00504105
    lea edx, [edx + 4*ebx]                       # 00504108
    mov ebx, dword ptr [esp + stk_80]            # 0050410b
    mov dword ptr [esp + stk_14], edx            # 00504112
    mov edx, dword ptr [esp + stk_50]            # 00504116
    mov dword ptr [esp + stk_10], eax            # 0050411a
    mov eax, dword ptr [esp + stk_88]            # 0050411e
    lea edx, [edi + 2*edx]                       # 00504125
    mov ecx, dword ptr [esp + stk_20]            # 00504128
    mov dword ptr [esp + stk_48], eax            # 0050412c
    mov eax, dword ptr [esp + stk_80]            # 00504130
    lea esi, [esi + 4*edx]                       # 00504137
    mov edx, dword ptr [esp + stk_84]            # 0050413a
    {load} sub edx, ebx                          # 00504141
    mov edi, dword ptr [esp + stk_28]            # 00504143
    mov dword ptr [esp + stk_30], edx            # 00504147
    mov edx, dword ptr [esp + stk_88]            # 0050414b
    {load} sub edx, ebx                          # 00504152
    mov ebx, dword ptr [esp + stk_88]            # 00504154
    mov dword ptr [esp + stk_60], edx            # 0050415b
    mov edx, dword ptr [esp + stk_84]            # 0050415f
    {load} sub edx, ebx                          # 00504166
    add eax, 0x4                                 # 00504168
    mov dword ptr [esp + stk_2c], edx            # 0050416b
    mov edx, dword ptr [esp + stk_70]            # 0050416f
    dec edx                                      # 00504173
    mov dword ptr [esp + stk_1c], ecx            # 00504174
    mov ecx, dword ptr [esp + stk_24]            # 00504178
    shr edx                                      # 0050417c
    mov dword ptr [esp + stk_4c], edx            # 0050417e
    mov edx, dword ptr [esp + stk_48]            # 00504182
L_00504186:
    # block 0x00504186: entered by jne at 0x005042db, 110 instruction(s), ends with jne to 0x00504186 (backward)
    fld dword ptr [ecx + field_4]                # 00504186
    fmul dword ptr [eax - field_minus_4]         # 00504189
    fld dword ptr [eax]                          # 0050418c
    add ecx, 0x8                                 # 0050418e
    mov ebx, dword ptr [esp + stk_1c]            # 00504191
    add ebx, 0x8                                 # 00504195
    add esi, 0x8                                 # 00504198
    fmul dword ptr [ecx]                         # 0050419b
    mov dword ptr [esp + stk_1c], ebx            # 0050419d
    mov ebx, dword ptr [esp + stk_14]            # 005041a1
    add ebx, 0x8                                 # 005041a5
    add edi, 0x8                                 # 005041a8
    faddp st(1), st                              # 005041ab
    fld dword ptr [eax - field_minus_4]          # 005041ad
    fmul dword ptr [ecx]                         # 005041b0
    fld dword ptr [eax]                          # 005041b2
    fmul dword ptr [ecx - field_minus_4]         # 005041b4
    mov dword ptr [esp + stk_14], ebx            # 005041b7
    mov ebx, dword ptr [esp + stk_18]            # 005041bb
    sub ebx, 0x8                                 # 005041bf
    add ebp, 0x8                                 # 005041c2
    mov dword ptr [esp + stk_18], ebx            # 005041c5
    mov ebx, dword ptr [esp + stk_10]            # 005041c9
    fsubp st(1), st                              # 005041cd
    sub ebx, 0x8                                 # 005041cf
    mov dword ptr [esp + stk_10], ebx            # 005041d2
    mov ebx, dword ptr [esp + stk_2c]            # 005041d6
    fstp dword ptr [esp + stk_34]                # 005041da
    fld dword ptr [esi - field_minus_4]          # 005041de
    fmul dword ptr [ebx + edx]                   # 005041e1
    mov ebx, dword ptr [esp + stk_30]            # 005041e4
    fld dword ptr [ebx + eax]                    # 005041e8
    fmul dword ptr [esi]                         # 005041eb
    mov ebx, dword ptr [esp + stk_2c]            # 005041ed
    faddp st(1), st                              # 005041f1
    fstp dword ptr [esp + stk_40]                # 005041f3
    fld dword ptr [esi]                          # 005041f7
    fmul dword ptr [ebx + edx]                   # 005041f9
    mov ebx, dword ptr [esp + stk_30]            # 005041fc
    fld dword ptr [esi - field_minus_4]          # 00504200
    fmul dword ptr [ebx + eax]                   # 00504203
    mov ebx, dword ptr [esp + stk_60]            # 00504206
    fsubp st(1), st                              # 0050420a
    fstp dword ptr [esp + stk_3c]                # 0050420c
    fld dword ptr [ebx + eax]                    # 00504210
    fmul dword ptr [edi]                         # 00504213
    fld dword ptr [edi - field_minus_4]          # 00504215
    fmul dword ptr [edx]                         # 00504218
    faddp st(1), st                              # 0050421a
    fld dword ptr [edi]                          # 0050421c
    fmul dword ptr [edx]                         # 0050421e
    fld dword ptr [edi - field_minus_4]          # 00504220
    fmul dword ptr [ebx + eax]                   # 00504223
    mov ebx, dword ptr [esp + stk_1c]            # 00504226
    fsubp st(1), st                              # 0050422a
    fstp dword ptr [esp + stk_38]                # 0050422c
    fld st(0)                                    # 00504230
    fadd st, st(2)                               # 00504232
    fstp dword ptr [esp + stk_44]                # 00504234
    fsubrp st(1), st                             # 00504238
    fld dword ptr [esp + stk_38]                 # 0050423a
    fadd dword ptr [esp + stk_34]                # 0050423e
    fstp dword ptr [esp + stk_48]                # 00504242
    fld dword ptr [esp + stk_34]                 # 00504246
    fsub dword ptr [esp + stk_38]                # 0050424a
    fld dword ptr [esp + stk_3c]                 # 0050424e
    {disp8} fadd dword ptr [ebp]                 # 00504252
    fstp dword ptr [esp + stk_34]                # 00504255
    {disp8} fld dword ptr [ebp]                  # 00504259
    fsub dword ptr [esp + stk_3c]                # 0050425c
    fstp dword ptr [esp + stk_3c]                # 00504260
    fld dword ptr [esp + stk_40]                 # 00504264
    fadd dword ptr [ebp - field_minus_4]         # 00504268
    fstp dword ptr [esp + stk_38]                # 0050426b
    fld dword ptr [ebp - field_minus_4]          # 0050426f
    fsub dword ptr [esp + stk_40]                # 00504272
    fld dword ptr [esp + stk_38]                 # 00504276
    fadd dword ptr [esp + stk_44]                # 0050427a
    fstp dword ptr [ebx - field_minus_4]         # 0050427e
    fld dword ptr [esp + stk_34]                 # 00504281
    fadd dword ptr [esp + stk_48]                # 00504285
    fstp dword ptr [ebx]                         # 00504289
    mov ebx, dword ptr [esp + stk_18]            # 0050428b
    add eax, 0x8                                 # 0050428f
    fld st(0)                                    # 00504292
    fsub st, st(2)                               # 00504294
    add edx, 0x8                                 # 00504296
    fstp dword ptr [ebx - field_minus_4]         # 00504299
    fld st(2)                                    # 0050429c
    fsub dword ptr [esp + stk_3c]                # 0050429e
    fstp dword ptr [ebx]                         # 005042a2
    mov ebx, dword ptr [esp + stk_14]            # 005042a4
    fadd st, st(1)                               # 005042a8
    fstp dword ptr [ebx - field_minus_4]         # 005042aa
    fstp st(0)                                   # 005042ad
    fld dword ptr [esp + stk_3c]                 # 005042af
    fadd st, st(1)                               # 005042b3
    fstp dword ptr [ebx]                         # 005042b5
    mov ebx, dword ptr [esp + stk_10]            # 005042b7
    fstp st(0)                                   # 005042bb
    fld dword ptr [esp + stk_38]                 # 005042bd
    fsub dword ptr [esp + stk_44]                # 005042c1
    fstp dword ptr [ebx - field_minus_4]         # 005042c5
    fld dword ptr [esp + stk_48]                 # 005042c8
    fsub dword ptr [esp + stk_34]                # 005042cc
    fstp dword ptr [ebx]                         # 005042d0
    mov ebx, dword ptr [esp + stk_4c]            # 005042d2
    dec ebx                                      # 005042d6
    mov dword ptr [esp + stk_4c], ebx            # 005042d7
    jne.d32 L_00504186                           # 005042db
    # block 0x005042e1: entered by fall-through of jne at 0x005042db, 5 instruction(s), falls into the block at 0x005042f5
    mov esi, dword ptr [esp + stk_78]            # 005042e1
    mov edx, dword ptr [esp + stk_7c]            # 005042e5
    mov edi, dword ptr [esp + stk_54]            # 005042e9
    mov ebp, dword ptr [esp + stk_50]            # 005042ed
    mov eax, dword ptr [esp + stk_70]            # 005042f1
L_005042f5:
    # block 0x005042f5: entered by jle at 0x005040f0, 17 instruction(s), ends with jne to 0x005040e6 (backward)
    mov ecx, dword ptr [esp + stk_64]            # 005042f5
    mov ebx, dword ptr [esp + stk_20]            # 005042f9
    {load} add ebx, ecx                          # 005042fd
    mov ecx, dword ptr [esp + stk_68]            # 005042ff
    mov dword ptr [esp + stk_20], ebx            # 00504303
    mov ebx, dword ptr [esp + stk_24]            # 00504307
    {load} add ebx, ecx                          # 0050430b
    {load} add edi, eax                          # 0050430d
    mov dword ptr [esp + stk_24], ebx            # 0050430f
    mov ebx, dword ptr [esp + stk_28]            # 00504313
    {load} add ebx, ecx                          # 00504317
    mov ecx, dword ptr [esp + stk_58]            # 00504319
    dec ecx                                      # 0050431d
    mov dword ptr [esp + stk_54], edi            # 0050431e
    mov dword ptr [esp + stk_28], ebx            # 00504322
    mov dword ptr [esp + stk_58], ecx            # 00504326
    jne.d32 L_005040e6                           # 0050432a
    # block 0x00504330: entered by fall-through of jne at 0x0050432a, 1 instruction(s), falls into the block at 0x00504334
    mov ebx, dword ptr [esp + stk_74]            # 00504330
L_00504334:
    # block 0x00504334: entered by jle at 0x005040a5, 2 instruction(s), ends with jne to 0x005043fa (forward)
    test al, 0x1                                 # 00504334
    jne.d32 L_005043fa                           # 00504336
L_0050433c:
    # block 0x0050433c: entered by je at 0x00504097; fall-through of jne at 0x00504336, 4 instruction(s), ends with jle to 0x005043fa (forward)
    test ebx, ebx                                # 0050433c
    lea edi, [eax + ebp - field_minus_1]         # 0050433e
    lea ecx, [4*eax]                             # 00504342
    jle.d32 L_005043fa                           # 00504349
    # block 0x0050434f: entered by fall-through of jle at 0x00504349, 20 instruction(s), ends with forward jump to 0x005043a4
    shl ecx, 0x2                                 # 0050434f
    mov dword ptr [esp + stk_80], ecx            # 00504352
    lea ecx, [4*eax]                             # 00504359
    lea eax, [eax + 2*eax]                       # 00504360
    lea ebx, [ecx + edx]                         # 00504363
    mov dword ptr [esp + stk_70], ebx            # 00504366
    lea ebx, [edi + 2*ebp]                       # 0050436a
    lea edx, [edx + 4*eax]                       # 0050436d
    lea eax, [edi + ebp]                         # 00504370
    lea ebx, [esi + 4*ebx]                       # 00504373
    mov dword ptr [esp + stk_88], ebx            # 00504376
    lea ebx, [esi + 4*edi]                       # 0050437d
    {load} sub edi, ebp                          # 00504380
    mov ebp, dword ptr [esp + stk_70]            # 00504382
    lea eax, [esi + 4*eax]                       # 00504386
    lea esi, [esi + 4*edi]                       # 00504389
    mov edi, dword ptr [esp + stk_74]            # 0050438c
    mov dword ptr [esp + stk_74], edi            # 00504390
    mov edi, dword ptr [esp + stk_88]            # 00504394
    jmp.d8 L_005043a4                            # 0050439b
L_0050439d:
    # block 0x0050439d: entered by jne at 0x005043f8, 1 instruction(s), falls into the block at 0x005043a4
    mov edi, dword ptr [esp + stk_88]            # 0050439d
L_005043a4:
    # block 0x005043a4: entered by jmp at 0x0050439b, 31 instruction(s), ends with jne to 0x0050439d (backward)
    fld dword ptr [edi]                          # 005043a4
    fadd dword ptr [ebx]                         # 005043a6
    fmul dword ptr [0x566a0c]                    # 005043a8
    fchs                                         # 005043ae
    fld dword ptr [ebx]                          # 005043b0
    fsub dword ptr [edi]                         # 005043b2
    {load} add edi, ecx                          # 005043b4
    {load} add ebx, ecx                          # 005043b6
    mov dword ptr [esp + stk_88], edi            # 005043b8
    mov edi, dword ptr [esp + stk_80]            # 005043bf
    fmul dword ptr [0x566a0c]                    # 005043c6
    fld st(0)                                    # 005043cc
    fadd dword ptr [esi]                         # 005043ce
    fstp dword ptr [ebp - field_minus_4]         # 005043d0
    fld dword ptr [esi]                          # 005043d3
    fsub st, st(1)                               # 005043d5
    {load} add esi, ecx                          # 005043d7
    fstp dword ptr [edx - field_minus_4]         # 005043d9
    fstp st(0)                                   # 005043dc
    fld st(0)                                    # 005043de
    fsub dword ptr [eax]                         # 005043e0
    {disp8} fstp dword ptr [ebp]                 # 005043e2
    {load} add ebp, edi                          # 005043e5
    fadd dword ptr [eax]                         # 005043e7
    {load} add eax, ecx                          # 005043e9
    fstp dword ptr [edx]                         # 005043eb
    {load} add edx, edi                          # 005043ed
    mov edi, dword ptr [esp + stk_74]            # 005043ef
    dec edi                                      # 005043f3
    mov dword ptr [esp + stk_74], edi            # 005043f4
    jne.d8 L_0050439d                            # 005043f8
L_005043fa:
    # block 0x005043fa: entered by jl at 0x00504091; jne at 0x00504336; jle at 0x00504349; fall-through of jne at 0x005043f8, 6 instruction(s), ends with ret
    pop edi                                      # 005043fa
    pop esi                                      # 005043fb
    pop ebp                                      # 005043fc
    pop ebx                                      # 005043fd
    add esp, 0x5c                                # 005043fe
    ret                                          # 00504401

# --- data items (not part of the function) -------------------------
.org 0x00504402 - 0x401000
PAD_00504402:  # 14 byte(s) of nop padding
    .fill 14, 1, 0x90

