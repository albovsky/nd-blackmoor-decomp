# FUN_00508180
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00508180
# extent:       0x00508180-0x005083ea (618 code bytes)
# span:         0x00508180-0x005083f0 (code 618, tables 0, padding 6)
# sha256:       0387193c26b2785f896bc68a43d408f9dd0f8037af25c1c1f61b8502059bce76
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00508180
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebx + n] field_8, field_10, field_14, field_20, field_24; [ecx + n] field_4, field_8, field_c; [edx + n] field_4, field_14; [esp + n] stk_10, stk_14, stk_18, stk_1c, stk_20, stk_24, stk_28, stk_2c, stk_30, stk_34, stk_38, stk_3c and 9 more
# callees:      calls FUN_00503060; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 188 instruction(s), 19 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x005083f0
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ field_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ field_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ field_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ stk_30, 0x30  # offset +0x30
.equ stk_34, 0x34  # offset +0x34
.equ stk_38, 0x38  # offset +0x38
.equ stk_3c, 0x3c  # offset +0x3c
.equ stk_40, 0x40  # offset +0x40
.equ stk_48, 0x48  # offset +0x48
.equ stk_240, 0x240  # offset +0x240
.equ stk_43c, 0x43c  # offset +0x43c
.equ stk_444, 0x444  # offset +0x444
.equ stk_44c, 0x44c  # offset +0x44c
.equ stk_450, 0x450  # offset +0x450
.equ stk_454, 0x454  # offset +0x454
.equ stk_46c, 0x46c  # offset +0x46c

# --- external targets -----------------------------------------------
.set FUN_00503060, .text + (0x00503060 - 0x401000)

.org 0x00508180 - 0x401000
.globl FUN_00508180
FUN_00508180:
    # block 0x00508180: entry, 33 instruction(s), ends with jle to 0x005083dd (forward)
    sub esp, 0x430                               # 00508180
    push ebx                                     # 00508186
    mov ebx, dword ptr [esp + stk_43c]           # 00508187
    push ebp                                     # 0050818e
    push esi                                     # 0050818f
    mov ecx, dword ptr [ebx]                     # 00508190
    mov edx, dword ptr [ebx + field_10]          # 00508192
    push edi                                     # 00508195
    mov dword ptr [esp + stk_28], ecx            # 00508196
    mov eax, dword ptr [ecx + field_c]           # 0050819a
    mov ebp, dword ptr [edx]                     # 0050819d
    mov edx, dword ptr [ecx]                     # 0050819f
    mov esi, dword ptr [ecx + field_8]           # 005081a1
    mov dword ptr [esp + stk_38], eax            # 005081a4
    mov eax, dword ptr [ecx + field_4]           # 005081a8
    {load} sub eax, edx                          # 005081ab
    mov ecx, 0x80                                # 005081ad
    cdq                                          # 005081b2
    idiv esi                                     # 005081b3
    lea edi, [esp + stk_240]                     # 005081b5
    mov dword ptr [esp + stk_1c], esi            # 005081bc
    mov dword ptr [esp + stk_34], ebp            # 005081c0
    {load} mov edx, eax                          # 005081c4
    {load} xor eax, eax                          # 005081c6
    rep stosd dword ptr es:[edi], eax            # 005081c8
    mov ecx, 0x80                                # 005081ca
    lea edi, [esp + stk_40]                      # 005081cf
    rep stosd dword ptr es:[edi], eax            # 005081d3
    mov dword ptr [esp + stk_14], eax            # 005081d5
    mov eax, dword ptr [ebx + field_8]           # 005081d9
    test eax, eax                                # 005081dc
    mov dword ptr [esp + stk_20], edx            # 005081de
    jle.d32 L_005083dd                           # 005081e2
L_005081e8:
    # block 0x005081e8: entered by jl at 0x005083d7; fall-through of jle at 0x005081e2, 4 instruction(s), ends with jle to 0x005083c9 (forward)
    {load} xor esi, esi                          # 005081e8
    test edx, edx                                # 005081ea
    mov dword ptr [esp + stk_24], esi            # 005081ec
    jle.d32 L_005083c9                           # 005081f0
L_005081f6:
    # block 0x005081f6: entered by jl at 0x005083c3; fall-through of jle at 0x005081f0, 3 instruction(s), ends with jne to 0x00508285 (forward)
    mov eax, dword ptr [esp + stk_14]            # 005081f6
    test eax, eax                                # 005081fa
    jne.d32 L_00508285                           # 005081fc
    # block 0x00508202: entered by fall-through of jne at 0x005081fc, 3 instruction(s), ends with jle to 0x00508285 (forward)
    mov eax, dword ptr [esp + stk_450]           # 00508202
    test eax, eax                                # 00508209
    jle.d8 L_00508285                            # 0050820b
    # block 0x0050820d: entered by fall-through of jle at 0x0050820b, 3 instruction(s), falls into the block at 0x0050821c
    mov ecx, dword ptr [esp + stk_454]           # 0050820d
    mov dword ptr [esp + stk_18], eax            # 00508214
    mov dword ptr [esp + stk_10], ecx            # 00508218
L_0050821c:
    # block 0x0050821c: entered by jne at 0x00508283, 6 instruction(s), ends with jle to 0x0050824a (forward)
    mov edx, dword ptr [esp + stk_10]            # 0050821c
    mov ecx, 0x1                                 # 00508220
    {load} cmp ebp, ecx                          # 00508225
    mov edx, dword ptr [edx]                     # 00508227
    mov eax, dword ptr [edx + 4*esi]             # 00508229
    jle.d8 L_0050824a                            # 0050822c
    # block 0x0050822e: entered by fall-through of jle at 0x0050822c, 1 instruction(s), falls into the block at 0x00508232
    lea edx, [edx + 4*esi + field_4]             # 0050822e
L_00508232:
    # block 0x00508232: entered by jl at 0x00508248, 4 instruction(s), ends with jge to 0x00508242 (forward)
    imul eax, dword ptr [esp + stk_38]           # 00508232
    lea edi, [ecx + esi]                         # 00508237
    cmp edi, dword ptr [esp + stk_20]            # 0050823a
    jge.d8 L_00508242                            # 0050823e
    # block 0x00508240: entered by fall-through of jge at 0x0050823e, 1 instruction(s), falls into the block at 0x00508242
    add eax, dword ptr [edx]                     # 00508240
L_00508242:
    # block 0x00508242: entered by jge at 0x0050823e, 4 instruction(s), ends with jl to 0x00508232 (backward)
    inc ecx                                      # 00508242
    add edx, 0x4                                 # 00508243
    {load} cmp ecx, ebp                          # 00508246
    jl.d8 L_00508232                             # 00508248
L_0050824a:
    # block 0x0050824a: entered by jle at 0x0050822c; fall-through of jl at 0x00508248, 3 instruction(s), ends with jge to 0x0050826f (forward)
    mov ecx, dword ptr [ebx + field_10]          # 0050824a
    cmp eax, dword ptr [ecx + field_4]           # 0050824d
    jge.d8 L_0050826f                            # 00508250
    # block 0x00508252: entered by fall-through of jge at 0x00508250, 10 instruction(s), calls FUN_00503060, falls into the block at 0x0050826f
    mov edx, dword ptr [esp + stk_444]           # 00508252
    add edx, 0x4                                 # 00508259
    push edx                                     # 0050825c
    push eax                                     # 0050825d
    push ecx                                     # 0050825e
    call FUN_00503060                            # 0050825f
    mov ecx, dword ptr [ebx + field_24]          # 00508264
    add esp, 0xc                                 # 00508267
    {load} add ecx, eax                          # 0050826a
    mov dword ptr [ebx + field_24], ecx          # 0050826c
L_0050826f:
    # block 0x0050826f: entered by jge at 0x00508250, 7 instruction(s), ends with jne to 0x0050821c (backward)
    mov ecx, dword ptr [esp + stk_10]            # 0050826f
    mov eax, dword ptr [esp + stk_18]            # 00508273
    add ecx, 0x4                                 # 00508277
    dec eax                                      # 0050827a
    mov dword ptr [esp + stk_10], ecx            # 0050827b
    mov dword ptr [esp + stk_18], eax            # 0050827f
    jne.d8 L_0050821c                            # 00508283
L_00508285:
    # block 0x00508285: entered by jne at 0x005081fc; jle at 0x0050820b; fall-through of jne at 0x00508283, 3 instruction(s), ends with jle to 0x005083bd (forward)
    test ebp, ebp                                # 00508285
    mov dword ptr [esp + stk_10], 0x0            # 00508287
    jle.d32 L_005083bd                           # 0050828f
    # block 0x00508295: entered by fall-through of jle at 0x0050828f, 4 instruction(s), falls into the block at 0x005082a7
    {load} mov eax, esi                          # 00508295
    lea edi, [4*esi]                             # 00508297
    imul eax, dword ptr [esp + stk_1c]           # 0050829e
    mov dword ptr [esp + stk_2c], eax            # 005082a3
L_005082a7:
    # block 0x005082a7: entered by jl at 0x005083b7, 3 instruction(s), ends with jge to 0x005083c9 (forward)
    mov edx, dword ptr [esp + stk_20]            # 005082a7
    {load} cmp esi, edx                          # 005082ab
    jge.d32 L_005083c9                           # 005082ad
    # block 0x005082b3: entered by fall-through of jge at 0x005082ad, 7 instruction(s), ends with jle to 0x0050839a (forward)
    mov edx, dword ptr [esp + stk_28]            # 005082b3
    {load} mov ecx, eax                          # 005082b7
    add ecx, dword ptr [edx]                     # 005082b9
    mov edx, dword ptr [esp + stk_450]           # 005082bb
    test edx, edx                                # 005082c2
    mov dword ptr [esp + stk_3c], ecx            # 005082c4
    jle.d32 L_0050839a                           # 005082c8
    # block 0x005082ce: entered by fall-through of jle at 0x005082c8, 8 instruction(s), falls into the block at 0x005082f1
    mov ecx, dword ptr [esp + stk_14]            # 005082ce
    mov esi, dword ptr [esp + stk_454]           # 005082d2
    mov eax, dword ptr [esp + stk_44c]           # 005082d9
    mov ebp, 0x1                                 # 005082e0
    shl ebp, cl                                  # 005082e5
    {load} sub eax, esi                          # 005082e7
    mov dword ptr [esp + stk_18], edx            # 005082e9
    mov dword ptr [esp + stk_30], eax            # 005082ed
L_005082f1:
    # block 0x005082f1: entered by jne at 0x00508388, 3 instruction(s), ends with jne to 0x0050830e (forward)
    mov eax, dword ptr [esp + stk_14]            # 005082f1
    test eax, eax                                # 005082f5
    jne.d8 L_0050830e                            # 005082f7
    # block 0x005082f9: entered by fall-through of jne at 0x005082f7, 7 instruction(s), falls into the block at 0x0050830e
    mov eax, dword ptr [esi]                     # 005082f9
    mov edx, dword ptr [esp + stk_1c]            # 005082fb
    mov ecx, dword ptr [edi + eax]               # 005082ff
    lea eax, [esp + 4*ecx + stk_40]              # 00508302
    mov ecx, dword ptr [esp + 4*ecx + stk_40]    # 00508306
    {load} add ecx, edx                          # 0050830a
    mov dword ptr [eax], ecx                     # 0050830c
L_0050830e:
    # block 0x0050830e: entered by jne at 0x005082f7, 6 instruction(s), ends with je to 0x0050837c (forward)
    mov eax, dword ptr [esi]                     # 0050830e
    mov edx, dword ptr [esp + stk_28]            # 00508310
    {load} add eax, edi                          # 00508314
    mov ecx, dword ptr [eax]                     # 00508316
    test dword ptr [edx + 4*ecx + field_14], ebp # 00508318
    je.d8 L_0050837c                             # 0050831c
    # block 0x0050831e: entered by fall-through of je at 0x0050831c, 7 instruction(s), ends with je to 0x0050837c (forward)
    {load} mov eax, ecx                          # 0050831e
    mov ecx, dword ptr [ebx + field_14]          # 00508320
    mov edx, dword ptr [ecx + 4*eax]             # 00508323
    mov eax, dword ptr [esp + stk_14]            # 00508326
    mov eax, dword ptr [edx + 4*eax]             # 0050832a
    test eax, eax                                # 0050832d
    je.d8 L_0050837c                             # 0050832f
    # block 0x00508331: entered by fall-through of je at 0x0050832f, 23 instruction(s), calls indirect dword ptr [esp + 0x46c], falls into the block at 0x0050837c
    mov ecx, dword ptr [esp + stk_1c]            # 00508331
    mov edx, dword ptr [esp + stk_30]            # 00508335
    push 0x0                                     # 00508339
    push eax                                     # 0050833b
    mov eax, dword ptr [edx + esi]               # 0050833c
    push ecx                                     # 0050833f
    mov ecx, dword ptr [esp + stk_48]            # 00508340
    lea edx, [eax + 4*ecx]                       # 00508344
    mov eax, dword ptr [esp + stk_450]           # 00508347
    add eax, 0x4                                 # 0050834e
    push edx                                     # 00508351
    push eax                                     # 00508352
    call dword ptr [esp + stk_46c]               # 00508353
    mov ecx, dword ptr [ebx + field_20]          # 0050835a
    add esp, 0x14                                # 0050835d
    {load} add ecx, eax                          # 00508360
    mov dword ptr [ebx + field_20], ecx          # 00508362
    mov ecx, dword ptr [esi]                     # 00508365
    mov edx, dword ptr [edi + ecx]               # 00508367
    lea ecx, [esp + 4*edx + stk_240]             # 0050836a
    mov edx, dword ptr [esp + 4*edx + stk_240]   # 00508371
    {load} add edx, eax                          # 00508378
    mov dword ptr [ecx], edx                     # 0050837a
L_0050837c:
    # block 0x0050837c: entered by je at 0x0050831c; je at 0x0050832f, 5 instruction(s), ends with jne to 0x005082f1 (backward)
    mov eax, dword ptr [esp + stk_18]            # 0050837c
    add esi, 0x4                                 # 00508380
    dec eax                                      # 00508383
    mov dword ptr [esp + stk_18], eax            # 00508384
    jne.d32 L_005082f1                           # 00508388
    # block 0x0050838e: entered by fall-through of jne at 0x00508388, 3 instruction(s), falls into the block at 0x0050839a
    mov ebp, dword ptr [esp + stk_34]            # 0050838e
    mov esi, dword ptr [esp + stk_24]            # 00508392
    mov eax, dword ptr [esp + stk_2c]            # 00508396
L_0050839a:
    # block 0x0050839a: entered by jle at 0x005082c8, 11 instruction(s), ends with jl to 0x005082a7 (backward)
    mov ecx, dword ptr [esp + stk_10]            # 0050839a
    mov edx, dword ptr [esp + stk_1c]            # 0050839e
    inc ecx                                      # 005083a2
    inc esi                                      # 005083a3
    {load} add eax, edx                          # 005083a4
    add edi, 0x4                                 # 005083a6
    {load} cmp ecx, ebp                          # 005083a9
    mov dword ptr [esp + stk_10], ecx            # 005083ab
    mov dword ptr [esp + stk_24], esi            # 005083af
    mov dword ptr [esp + stk_2c], eax            # 005083b3
    jl.d32 L_005082a7                            # 005083b7
L_005083bd:
    # block 0x005083bd: entered by jle at 0x0050828f; fall-through of jl at 0x005083b7, 3 instruction(s), ends with jl to 0x005081f6 (backward)
    mov edx, dword ptr [esp + stk_20]            # 005083bd
    {load} cmp esi, edx                          # 005083c1
    jl.d32 L_005081f6                            # 005083c3
L_005083c9:
    # block 0x005083c9: entered by jle at 0x005081f0; jge at 0x005082ad; fall-through of jl at 0x005083c3, 6 instruction(s), ends with jl to 0x005081e8 (backward)
    mov eax, dword ptr [esp + stk_14]            # 005083c9
    mov ecx, dword ptr [ebx + field_8]           # 005083cd
    inc eax                                      # 005083d0
    {load} cmp eax, ecx                          # 005083d1
    mov dword ptr [esp + stk_14], eax            # 005083d3
    jl.d32 L_005081e8                            # 005083d7
L_005083dd:
    # block 0x005083dd: entered by jle at 0x005081e2; fall-through of jl at 0x005083d7, 7 instruction(s), ends with ret
    pop edi                                      # 005083dd
    pop esi                                      # 005083de
    pop ebp                                      # 005083df
    {load} xor eax, eax                          # 005083e0
    pop ebx                                      # 005083e2
    add esp, 0x430                               # 005083e3
    ret                                          # 005083e9

# --- data items (not part of the function) -------------------------
.org 0x005083ea - 0x401000
PAD_005083ea:  # 6 byte(s) of nop padding
    .fill 6, 1, 0x90

