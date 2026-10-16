# FUN_00509230
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00509230
# extent:       0x00509230-0x005096bf (1167 code bytes)
# span:         0x00509230-0x005096c0 (code 1167, tables 0, padding 1)
# sha256:       e4d3b80f4e0897d84500f2c98e9ae4445d62470bd2c7c7f3a9677a3696500b44
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00509230
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_344; [ebp + n] field_208, field_210, field_30c, field_504, field_508, field_510; [ebx + n] field_1, field_344, field_34c, field_minus_1; [edi + n] field_fc; [esi + n] field_4, field_8; [esp + n] stk_10, stk_14, stk_18, stk_1c, stk_20, stk_24, stk_28, stk_2c, stk_30, stk_34, stk_38, stk_3c and 28 more
# callees:      calls FUN_00509710, FUN_00509940, FUN_00509d70, FUN_00509b40, FUN_004fee30, FUN_005096c0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 342 instruction(s), 27 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
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
.equ field_fc, 0xfc  # offset +0xfc
.equ stk_144, 0x144  # offset +0x144
.equ stk_148, 0x148  # offset +0x148
.equ stk_14c, 0x14c  # offset +0x14c
.equ stk_150, 0x150  # offset +0x150
.equ stk_158, 0x158  # offset +0x158
.equ field_208, 0x208  # offset +0x208
.equ field_210, 0x210  # offset +0x210
.equ stk_248, 0x248  # offset +0x248
.equ field_30c, 0x30c  # offset +0x30c
.equ field_344, 0x344  # offset +0x344
.equ stk_34c, 0x34c  # offset +0x34c
.equ field_34c, 0x34c  # offset +0x34c
.equ stk_450, 0x450  # offset +0x450
.equ stk_45c, 0x45c  # offset +0x45c
.equ field_504, 0x504  # offset +0x504
.equ field_508, 0x508  # offset +0x508
.equ field_510, 0x510  # offset +0x510
.equ stk_554, 0x554  # offset +0x554
.equ stk_558, 0x558  # offset +0x558
.equ stk_55c, 0x55c  # offset +0x55c
.equ stk_570, 0x570  # offset +0x570
.equ stk_e54, 0xe54  # offset +0xe54
.equ stk_e58, 0xe58  # offset +0xe58
.equ stk_e5c, 0xe5c  # offset +0xe5c
.equ stk_e60, 0xe60  # offset +0xe60
.equ stk_e68, 0xe68  # offset +0xe68
.equ stk_e74, 0xe74  # offset +0xe74
.equ stk_e78, 0xe78  # offset +0xe78
.equ stk_e80, 0xe80  # offset +0xe80

# --- external targets -----------------------------------------------
.set FUN_004fee30, .text + (0x004fee30 - 0x401000)
.set FUN_005096c0, .text + (0x005096c0 - 0x401000)
.set FUN_00509710, .text + (0x00509710 - 0x401000)
.set FUN_00509940, .text + (0x00509940 - 0x401000)
.set FUN_00509b40, .text + (0x00509b40 - 0x401000)
.set FUN_00509d70, .text + (0x00509d70 - 0x401000)

.org 0x00509230 - 0x401000
.globl FUN_00509230
FUN_00509230:
    # block 0x00509230: entry, 15 instruction(s), ends with jle to 0x005092bc (forward)
    sub esp, 0xe44                               # 00509230
    push ebx                                     # 00509236
    push ebp                                     # 00509237
    mov ebp, dword ptr [esp + stk_e54]           # 00509238
    push esi                                     # 0050923f
    push edi                                     # 00509240
    mov dword ptr [esp + stk_10], 0x0            # 00509241
    mov ebx, dword ptr [ebp + field_504]         # 00509249
    mov esi, dword ptr [ebp + field_510]         # 0050924f
    mov edx, dword ptr [ebp + field_508]         # 00509255
    mov dword ptr [esp + stk_24], esi            # 0050925b
    test ebx, ebx                                # 0050925f
    mov dword ptr [esp + stk_20], edx            # 00509261
    mov dword ptr [esp + stk_1c], ebx            # 00509265
    jle.d8 L_005092bc                            # 00509269
    # block 0x0050926b: entered by fall-through of jle at 0x00509269, 5 instruction(s), ends with jle to 0x00509285 (forward)
    {load} mov ecx, ebx                          # 0050926b
    mov eax, 0xffffff38                          # 0050926d
    lea edi, [esp + stk_40]                      # 00509272
    rep stosd dword ptr es:[edi], eax            # 00509276
    jle.d8 L_00509285                            # 00509278
    # block 0x0050927a: entered by fall-through of jle at 0x00509278, 3 instruction(s), falls into the block at 0x00509285
    {load} mov ecx, ebx                          # 0050927a
    lea edi, [esp + stk_144]                     # 0050927c
    rep stosd dword ptr es:[edi], eax            # 00509283
L_00509285:
    # block 0x00509285: entered by jle at 0x00509278, 2 instruction(s), ends with jle to 0x005092bc (forward)
    test ebx, ebx                                # 00509285
    jle.d8 L_005092bc                            # 00509287
    # block 0x00509289: entered by fall-through of jle at 0x00509287, 6 instruction(s), ends with jle to 0x005092bc (forward)
    {load} mov ecx, ebx                          # 00509289
    {load} xor eax, eax                          # 0050928b
    lea edi, [esp + stk_34c]                     # 0050928d
    test ebx, ebx                                # 00509294
    rep stosd dword ptr es:[edi], eax            # 00509296
    jle.d8 L_005092bc                            # 00509298
    # block 0x0050929a: entered by fall-through of jle at 0x00509298, 5 instruction(s), ends with jle to 0x005092ba (forward)
    {load} mov ecx, ebx                          # 0050929a
    mov eax, 0x1                                 # 0050929c
    lea edi, [esp + stk_248]                     # 005092a1
    rep stosd dword ptr es:[edi], eax            # 005092a8
    jle.d8 L_005092ba                            # 005092aa
    # block 0x005092ac: entered by fall-through of jle at 0x005092aa, 4 instruction(s), falls into the block at 0x005092ba
    {load} mov ecx, ebx                          # 005092ac
    or eax, -0x1                                 # 005092ae
    lea edi, [esp + stk_450]                     # 005092b1
    rep stosd dword ptr es:[edi], eax            # 005092b8
L_005092ba:
    # block 0x005092ba: entered by jle at 0x005092aa, 1 instruction(s), falls into the block at 0x005092bc
    test ebx, ebx                                # 005092ba
L_005092bc:
    # block 0x005092bc: entered by jle at 0x00509269; jle at 0x00509287; jle at 0x00509298, 1 instruction(s), ends with jne to 0x005092e5 (forward)
    jne.d8 L_005092e5                            # 005092bc
    # block 0x005092be: entered by fall-through of jne at 0x005092bc, 13 instruction(s), calls FUN_00509710, ends with forward jump to 0x00509344
    mov ecx, dword ptr [esp + stk_e60]           # 005092be
    push esi                                     # 005092c5
    lea eax, [esp + stk_558]                     # 005092c6
    push edx                                     # 005092cd
    push eax                                     # 005092ce
    push edx                                     # 005092cf
    mov edx, dword ptr [esp + stk_e74]           # 005092d0
    push 0x0                                     # 005092d7
    push ecx                                     # 005092d9
    push edx                                     # 005092da
    call FUN_00509710                            # 005092db
    add esp, 0x1c                                # 005092e0
    jmp.d8 L_00509344                            # 005092e3
L_005092e5:
    # block 0x005092e5: entered by jne at 0x005092bc, 3 instruction(s), ends with jle to 0x005096b2 (forward)
    lea eax, [ebx - field_minus_1]               # 005092e5
    test eax, eax                                # 005092e8
    jle.d32 L_005096b2                           # 005092ea
    # block 0x005092f0: entered by fall-through of jle at 0x005092ea, 3 instruction(s), falls into the block at 0x005092fd
    {load} mov esi, ebp                          # 005092f0
    lea edi, [esp + stk_554]                     # 005092f2
    mov dword ptr [esp + stk_14], eax            # 005092f9
L_005092fd:
    # block 0x005092fd: entered by jne at 0x00509340, 24 instruction(s), calls FUN_00509710, ends with jne to 0x005092fd (backward)
    mov eax, dword ptr [esp + stk_24]            # 005092fd
    mov ecx, dword ptr [esp + stk_20]            # 00509301
    mov edx, dword ptr [esi + field_4]           # 00509305
    push eax                                     # 00509308
    mov eax, dword ptr [esi]                     # 00509309
    push ecx                                     # 0050930b
    mov ecx, dword ptr [esp + stk_e68]           # 0050930c
    push edi                                     # 00509313
    push edx                                     # 00509314
    mov edx, dword ptr [esp + stk_e74]           # 00509315
    push eax                                     # 0050931c
    push ecx                                     # 0050931d
    push edx                                     # 0050931e
    call FUN_00509710                            # 0050931f
    mov edx, dword ptr [esp + stk_2c]            # 00509324
    add esp, 0x1c                                # 00509328
    {load} add edx, eax                          # 0050932b
    mov eax, dword ptr [esp + stk_14]            # 0050932d
    add edi, 0x24                                # 00509331
    add esi, 0x4                                 # 00509334
    dec eax                                      # 00509337
    mov dword ptr [esp + stk_10], edx            # 00509338
    mov dword ptr [esp + stk_14], eax            # 0050933c
    jne.d8 L_005092fd                            # 00509340
    # block 0x00509342: entered by fall-through of jne at 0x00509340, 1 instruction(s), falls into the block at 0x00509344
    {load} mov eax, edx                          # 00509342
L_00509344:
    # block 0x00509344: entered by jmp at 0x005092e3, 2 instruction(s), ends with je to 0x005096b2 (forward)
    test eax, eax                                # 00509344
    je.d32 L_005096b2                            # 00509346
    # block 0x0050934c: entered by fall-through of je at 0x00509346, 22 instruction(s), calls FUN_00509940, ends with jle to 0x0050959e (forward)
    mov eax, 0xffffff38                          # 0050934c
    lea ecx, [esp + stk_3c]                      # 00509351
    mov dword ptr [esp + stk_3c], eax            # 00509355
    mov dword ptr [esp + stk_38], eax            # 00509359
    lea eax, [esp + stk_38]                      # 0050935d
    lea edx, [ebx - field_minus_1]               # 00509361
    push eax                                     # 00509364
    push ecx                                     # 00509365
    lea eax, [esp + stk_55c]                     # 00509366
    push edx                                     # 0050936d
    push eax                                     # 0050936e
    call FUN_00509940                            # 0050936f
    mov eax, dword ptr [esp + stk_4c]            # 00509374
    add esp, 0x10                                # 00509378
    mov dword ptr [esp + stk_40], eax            # 0050937b
    mov dword ptr [esp + stk_144], eax           # 0050937f
    mov eax, dword ptr [esp + stk_38]            # 00509386
    cmp ebx, 0x2                                 # 0050938a
    mov dword ptr [esp + stk_148], eax           # 0050938d
    mov dword ptr [esp + stk_44], eax            # 00509394
    mov dword ptr [esp + stk_18], 0x2            # 00509398
    jle.d32 L_0050959e                           # 005093a0
    # block 0x005093a6: entered by fall-through of jle at 0x005093a0, 3 instruction(s), falls into the block at 0x005093b8
    lea ecx, [ebp + field_210]                   # 005093a6
    mov dword ptr [esp + stk_10], 0x0            # 005093ac
    mov dword ptr [esp + stk_14], ecx            # 005093b4
L_005093b8:
    # block 0x005093b8: entered by jl at 0x00509598, 7 instruction(s), ends with je to 0x00509574 (forward)
    mov edx, dword ptr [esp + stk_14]            # 005093b8
    mov eax, dword ptr [edx]                     # 005093bc
    mov dword ptr [esp + stk_34], eax            # 005093be
    mov edi, dword ptr [esp + 4*eax + stk_34c]   # 005093c2
    mov esi, dword ptr [esp + 4*eax + stk_248]   # 005093c9
    cmp dword ptr [esp + 4*edi + stk_450], esi   # 005093d0
    je.d32 L_00509574                            # 005093d7
    # block 0x005093dd: entered by fall-through of je at 0x005093d7, 38 instruction(s), calls FUN_00509d70, FUN_00509b40, ends with je to 0x00509555 (forward)
    mov eax, dword ptr [esp + stk_24]            # 005093dd
    mov ebx, dword ptr [ebp + 4*edi + field_208] # 005093e1
    mov ebp, dword ptr [ebp + 4*esi + field_208] # 005093e8
    push edi                                     # 005093ef
    mov ecx, dword ptr [eax + 4*edi + field_344] # 005093f0
    mov edx, dword ptr [eax + 4*esi + field_344] # 005093f7
    mov dword ptr [esp + stk_2c], ecx            # 005093fe
    lea eax, [esp + stk_148]                     # 00509402
    lea ecx, [esp + stk_44]                      # 00509409
    push eax                                     # 0050940d
    push ecx                                     # 0050940e
    mov dword ptr [esp + 4*edi + stk_45c], esi   # 0050940f
    mov dword ptr [esp + stk_38], edx            # 00509416
    call FUN_00509d70                            # 0050941a
    mov dword ptr [esp + stk_2c], eax            # 0050941f
    lea edx, [esp + stk_150]                     # 00509423
    push esi                                     # 0050942a
    lea eax, [esp + stk_50]                      # 0050942b
    push edx                                     # 0050942f
    push eax                                     # 00509430
    call FUN_00509d70                            # 00509431
    mov ecx, dword ptr [esp + stk_3c]            # 00509436
    mov edx, dword ptr [esp + stk_e78]           # 0050943a
    push ecx                                     # 00509441
    mov ecx, dword ptr [esp + stk_e80]           # 00509442
    push edx                                     # 00509449
    mov edx, dword ptr [esp + stk_40]            # 0050944a
    push ecx                                     # 0050944e
    mov ecx, dword ptr [esp + stk_4c]            # 0050944f
    push eax                                     # 00509453
    mov eax, dword ptr [esp + stk_54]            # 00509454
    push edx                                     # 00509458
    push eax                                     # 00509459
    push ecx                                     # 0050945a
    call FUN_00509b40                            # 0050945b
    add esp, 0x34                                # 00509460
    test eax, eax                                # 00509463
    je.d32 L_00509555                            # 00509465
    # block 0x0050946b: entered by fall-through of je at 0x00509465, 32 instruction(s), calls FUN_00509940, ends with jne to 0x005094d8 (forward)
    mov ecx, dword ptr [esp + stk_34]            # 0050946b
    mov eax, 0xffffff38                          # 0050946f
    lea edx, [esp + stk_28]                      # 00509474
    mov dword ptr [esp + stk_30], eax            # 00509478
    mov dword ptr [esp + stk_28], eax            # 0050947c
    mov dword ptr [esp + stk_2c], eax            # 00509480
    mov dword ptr [esp + stk_20], eax            # 00509484
    push edx                                     # 00509488
    lea eax, [esp + stk_34]                      # 00509489
    lea edx, [ebx + 8*ebx]                       # 0050948d
    push eax                                     # 00509490
    {load} sub ecx, ebx                          # 00509491
    lea eax, [esp + 4*edx + stk_55c]             # 00509493
    push ecx                                     # 0050949a
    push eax                                     # 0050949b
    call FUN_00509940                            # 0050949c
    mov ebx, dword ptr [esp + stk_44]            # 005094a1
    lea ecx, [esp + stk_30]                      # 005094a5
    lea edx, [esp + stk_3c]                      # 005094a9
    push ecx                                     # 005094ad
    lea eax, [ebx + 8*ebx]                       # 005094ae
    {load} sub ebp, ebx                          # 005094b1
    push edx                                     # 005094b3
    push ebp                                     # 005094b4
    lea ecx, [esp + 4*eax + stk_570]             # 005094b5
    push ecx                                     # 005094bc
    call FUN_00509940                            # 005094bd
    mov eax, dword ptr [esp + stk_50]            # 005094c2
    add esp, 0x20                                # 005094c6
    test edi, edi                                # 005094c9
    mov dword ptr [esp + 4*edi + stk_144], eax   # 005094cb
    jne.d8 L_005094d8                            # 005094d2
    # block 0x005094d4: entered by fall-through of jne at 0x005094d2, 1 instruction(s), falls into the block at 0x005094d8
    mov dword ptr [esp + stk_40], eax            # 005094d4
L_005094d8:
    # block 0x005094d8: entered by jne at 0x005094d2, 9 instruction(s), ends with jne to 0x00509503 (forward)
    mov eax, dword ptr [esp + stk_10]            # 005094d8
    mov ecx, dword ptr [esp + stk_28]            # 005094dc
    mov edx, dword ptr [esp + stk_2c]            # 005094e0
    cmp esi, 0x1                                 # 005094e4
    mov dword ptr [esp + eax + stk_48], ecx      # 005094e7
    mov dword ptr [esp + eax + stk_14c], edx     # 005094eb
    mov eax, dword ptr [esp + stk_20]            # 005094f2
    mov dword ptr [esp + 4*esi + stk_40], eax    # 005094f6
    jne.d8 L_00509503                            # 005094fa
    # block 0x005094fc: entered by fall-through of jne at 0x005094fa, 1 instruction(s), falls into the block at 0x00509503
    mov dword ptr [esp + stk_148], eax           # 005094fc
L_00509503:
    # block 0x00509503: entered by jne at 0x005094fa, 2 instruction(s), ends with jge to 0x0050950b (forward)
    test ecx, ecx                                # 00509503
    jge.d8 L_0050950b                            # 00509505
    # block 0x00509507: entered by fall-through of jge at 0x00509505, 2 instruction(s), ends with jl to 0x00509569 (forward)
    test edx, edx                                # 00509507
    jl.d8 L_00509569                             # 00509509
L_0050950b:
    # block 0x0050950b: entered by jge at 0x00509505; fall-through of jl at 0x00509509, 3 instruction(s), ends with jl to 0x0050952b (forward)
    lea eax, [ebx - field_minus_1]               # 0050950b
    test eax, eax                                # 0050950e
    jl.d8 L_0050952b                             # 00509510
    # block 0x00509512: entered by fall-through of jl at 0x00509510, 1 instruction(s), falls into the block at 0x00509519
    lea ecx, [esp + 4*eax + stk_248]             # 00509512
L_00509519:
    # block 0x00509519: entered by jge at 0x00509529, 2 instruction(s), ends with jne to 0x0050952b (forward)
    cmp dword ptr [ecx], esi                     # 00509519
    jne.d8 L_0050952b                            # 0050951b
    # block 0x0050951d: entered by fall-through of jne at 0x0050951b, 6 instruction(s), ends with jge to 0x00509519 (backward)
    mov edx, dword ptr [esp + stk_18]            # 0050951d
    dec eax                                      # 00509521
    mov dword ptr [ecx], edx                     # 00509522
    sub ecx, 0x4                                 # 00509524
    test eax, eax                                # 00509527
    jge.d8 L_00509519                            # 00509529
L_0050952b:
    # block 0x0050952b: entered by jl at 0x00509510; jne at 0x0050951b; fall-through of jge at 0x00509529, 4 instruction(s), ends with jge to 0x00509569 (forward)
    mov ecx, dword ptr [esp + stk_1c]            # 0050952b
    lea eax, [ebx + field_1]                     # 0050952f
    {load} cmp eax, ecx                          # 00509532
    jge.d8 L_00509569                            # 00509534
    # block 0x00509536: entered by fall-through of jge at 0x00509534, 1 instruction(s), falls into the block at 0x0050953d
    lea ecx, [esp + 4*eax + stk_34c]             # 00509536
L_0050953d:
    # block 0x0050953d: entered by jl at 0x00509551, 2 instruction(s), ends with jne to 0x00509569 (forward)
    cmp dword ptr [ecx], edi                     # 0050953d
    jne.d8 L_00509569                            # 0050953f
    # block 0x00509541: entered by fall-through of jne at 0x0050953f, 7 instruction(s), ends with jl to 0x0050953d (backward)
    mov edx, dword ptr [esp + stk_18]            # 00509541
    inc eax                                      # 00509545
    mov dword ptr [ecx], edx                     # 00509546
    mov edx, dword ptr [esp + stk_1c]            # 00509548
    add ecx, 0x4                                 # 0050954c
    {load} cmp eax, edx                          # 0050954f
    jl.d8 L_0050953d                             # 00509551
    # block 0x00509553: entered by fall-through of jl at 0x00509551, 1 instruction(s), ends with forward jump to 0x00509569
    jmp.d8 L_00509569                            # 00509553
L_00509555:
    # block 0x00509555: entered by je at 0x00509465, 4 instruction(s), falls into the block at 0x00509569
    mov eax, dword ptr [esp + stk_10]            # 00509555
    mov ecx, 0xffffff38                          # 00509559
    mov dword ptr [esp + eax + stk_48], ecx      # 0050955e
    mov dword ptr [esp + eax + stk_14c], ecx     # 00509562
L_00509569:
    # block 0x00509569: entered by jl at 0x00509509; jge at 0x00509534; jne at 0x0050953f; jmp at 0x00509553, 2 instruction(s), falls into the block at 0x00509574
    mov ebp, dword ptr [esp + stk_e5c]           # 00509569
    mov ebx, dword ptr [esp + stk_1c]            # 00509570
L_00509574:
    # block 0x00509574: entered by je at 0x005093d7, 12 instruction(s), ends with jl to 0x005093b8 (backward)
    mov eax, dword ptr [esp + stk_18]            # 00509574
    mov esi, dword ptr [esp + stk_14]            # 00509578
    mov edx, dword ptr [esp + stk_10]            # 0050957c
    mov ecx, 0x4                                 # 00509580
    inc eax                                      # 00509585
    {load} add esi, ecx                          # 00509586
    {load} add edx, ecx                          # 00509588
    {load} cmp eax, ebx                          # 0050958a
    mov dword ptr [esp + stk_18], eax            # 0050958c
    mov dword ptr [esp + stk_14], esi            # 00509590
    mov dword ptr [esp + stk_10], edx            # 00509594
    jl.d32 L_005093b8                            # 00509598
L_0050959e:
    # block 0x0050959e: entered by jle at 0x005093a0; fall-through of jl at 0x00509598, 24 instruction(s), calls FUN_004fee30, FUN_00509d70, ends with jle to 0x005096a5 (forward)
    mov ecx, dword ptr [esp + stk_e58]           # 0050959e
    lea eax, [4*ebx]                             # 005095a5
    push eax                                     # 005095ac
    push ecx                                     # 005095ad
    call FUN_004fee30                            # 005095ae
    {load} mov esi, eax                          # 005095b3
    lea edx, [esp + stk_14c]                     # 005095b5
    push 0x0                                     # 005095bc
    lea eax, [esp + stk_4c]                      # 005095be
    push edx                                     # 005095c2
    push eax                                     # 005095c3
    call FUN_00509d70                            # 005095c4
    lea ecx, [esp + stk_158]                     # 005095c9
    push 0x1                                     # 005095d0
    lea edx, [esp + stk_58]                      # 005095d2
    push ecx                                     # 005095d6
    push edx                                     # 005095d7
    mov dword ptr [esi], eax                     # 005095d8
    call FUN_00509d70                            # 005095da
    add esp, 0x20                                # 005095df
    cmp ebx, 0x2                                 # 005095e2
    mov dword ptr [esi + field_4], eax           # 005095e5
    mov dword ptr [esp + stk_18], 0x2            # 005095e8
    jle.d32 L_005096a5                           # 005095f0
    # block 0x005095f6: entered by fall-through of jle at 0x005095f0, 7 instruction(s), ends with forward jump to 0x00509617
    mov ebx, dword ptr [esp + stk_24]            # 005095f6
    lea eax, [esi + field_8]                     # 005095fa
    mov dword ptr [esp + stk_10], eax            # 005095fd
    lea edi, [ebp + field_30c]                   # 00509601
    lea ecx, [ebx + field_34c]                   # 00509607
    mov dword ptr [esp + stk_14], ecx            # 0050960d
    jmp.d8 L_00509617                            # 00509611
L_00509613:
    # block 0x00509613: entered by jl at 0x0050969f, 1 instruction(s), falls into the block at 0x00509617
    mov ebx, dword ptr [esp + stk_24]            # 00509613
L_00509617:
    # block 0x00509617: entered by jmp at 0x00509611, 25 instruction(s), calls FUN_005096c0, FUN_00509d70, ends with jl to 0x00509670 (forward)
    mov eax, dword ptr [edi + field_fc]          # 00509617
    mov ecx, dword ptr [edi]                     # 0050961d
    mov ebp, dword ptr [esp + stk_14]            # 0050961f
    mov edx, dword ptr [ebx + 4*eax + field_344] # 00509623
    mov ebx, dword ptr [ebx + 4*ecx + field_344] # 0050962a
    {disp8} mov ebp, dword ptr [ebp]             # 00509631
    mov ecx, dword ptr [esi + 4*ecx]             # 00509634
    mov eax, dword ptr [esi + 4*eax]             # 00509637
    push ebp                                     # 0050963a
    push ecx                                     # 0050963b
    push eax                                     # 0050963c
    push ebx                                     # 0050963d
    push edx                                     # 0050963e
    call FUN_005096c0                            # 0050963f
    mov ebp, dword ptr [esp + stk_2c]            # 00509644
    {load} mov ebx, eax                          # 00509648
    lea edx, [esp + stk_158]                     # 0050964a
    push ebp                                     # 00509651
    lea eax, [esp + stk_58]                      # 00509652
    push edx                                     # 00509656
    push eax                                     # 00509657
    call FUN_00509d70                            # 00509658
    add esp, 0x20                                # 0050965d
    test eax, eax                                # 00509660
    jl.d8 L_00509670                             # 00509662
    # block 0x00509664: entered by fall-through of jl at 0x00509662, 2 instruction(s), ends with je to 0x00509670 (forward)
    {load} cmp ebx, eax                          # 00509664
    je.d8 L_00509670                             # 00509666
    # block 0x00509668: entered by fall-through of je at 0x00509666, 3 instruction(s), ends with forward jump to 0x00509679
    mov ecx, dword ptr [esp + stk_10]            # 00509668
    mov dword ptr [ecx], eax                     # 0050966c
    jmp.d8 L_00509679                            # 0050966e
L_00509670:
    # block 0x00509670: entered by jl at 0x00509662; je at 0x00509666, 3 instruction(s), falls into the block at 0x00509679
    mov edx, dword ptr [esp + stk_10]            # 00509670
    or bh, -0x80                                 # 00509674
    mov dword ptr [edx], ebx                     # 00509677
L_00509679:
    # block 0x00509679: entered by jmp at 0x0050966e, 13 instruction(s), ends with jl to 0x00509613 (backward)
    mov edx, dword ptr [esp + stk_14]            # 00509679
    mov ecx, dword ptr [esp + stk_10]            # 0050967d
    mov eax, 0x4                                 # 00509681
    inc ebp                                      # 00509686
    {load} add edi, eax                          # 00509687
    {load} add edx, eax                          # 00509689
    {load} add ecx, eax                          # 0050968b
    mov eax, dword ptr [esp + stk_1c]            # 0050968d
    {load} cmp ebp, eax                          # 00509691
    mov dword ptr [esp + stk_18], ebp            # 00509693
    mov dword ptr [esp + stk_14], edx            # 00509697
    mov dword ptr [esp + stk_10], ecx            # 0050969b
    jl.d32 L_00509613                            # 0050969f
L_005096a5:
    # block 0x005096a5: entered by jle at 0x005095f0; fall-through of jl at 0x0050969f, 7 instruction(s), ends with ret
    {load} mov eax, esi                          # 005096a5
    pop edi                                      # 005096a7
    pop esi                                      # 005096a8
    pop ebp                                      # 005096a9
    pop ebx                                      # 005096aa
    add esp, 0xe44                               # 005096ab
    ret                                          # 005096b1
L_005096b2:
    # block 0x005096b2: entered by jle at 0x005092ea; je at 0x00509346, 7 instruction(s), ends with ret
    pop edi                                      # 005096b2
    pop esi                                      # 005096b3
    pop ebp                                      # 005096b4
    {load} xor eax, eax                          # 005096b5
    pop ebx                                      # 005096b7
    add esp, 0xe44                               # 005096b8
    ret                                          # 005096be

# --- data items (not part of the function) -------------------------
.org 0x005096bf - 0x401000
PAD_005096bf:  # 1 byte(s) of nop padding
    .fill 1, 1, 0x90

