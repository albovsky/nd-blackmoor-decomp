# FUN_00488319
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00488319
# extent:       0x00488319-0x004889cc (1715 code bytes)
# span:         0x00488319-0x004889e0 (code 1715, tables 20, padding 0)
# sha256:       cacbb2bccced5cb98ba3b5975cd52ac76b1c351a2f67b462f4761d8d1f276db8
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00488319
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_1c, field_24, field_25, field_66, field_6c, field_70, field_71, field_540, field_546, field_552, field_554, field_57a and 4 more; [ecx + n] field_1c, field_1e, field_20, field_65, field_68, field_6c, field_70, field_75, field_76, field_53e, field_544, field_54e and 7 more; [edx + n] field_4, field_8, field_c, field_1c, field_1e, field_24, field_6a, field_6c, field_75, field_53e, field_542, field_54a and 5 more
# callees:      calls FUN_004e8d96, FUN_004d39f9, FUN_004c2790, FUN_004fb77a, KERNEL32.dll!GetTickCount, FUN_004881c9, FUN_004fb2e3, FUN_004f6334, FUN_004fba69, FUN_0042ba3a, FUN_00487b4f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 416 instruction(s), 26 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_25, 0x25  # offset +0x25
.equ field_65, 0x65  # offset +0x65
.equ field_66, 0x66  # offset +0x66
.equ field_68, 0x68  # offset +0x68
.equ field_6a, 0x6a  # offset +0x6a
.equ field_6c, 0x6c  # offset +0x6c
.equ field_70, 0x70  # offset +0x70
.equ field_71, 0x71  # offset +0x71
.equ field_75, 0x75  # offset +0x75
.equ field_76, 0x76  # offset +0x76
.equ field_53e, 0x53e  # offset +0x53e
.equ field_540, 0x540  # offset +0x540
.equ field_542, 0x542  # offset +0x542
.equ field_544, 0x544  # offset +0x544
.equ field_546, 0x546  # offset +0x546
.equ field_54a, 0x54a  # offset +0x54a
.equ field_54e, 0x54e  # offset +0x54e
.equ field_552, 0x552  # offset +0x552
.equ field_554, 0x554  # offset +0x554
.equ field_556, 0x556  # offset +0x556
.equ field_557, 0x557  # offset +0x557
.equ field_57a, 0x57a  # offset +0x57a
.equ field_58a, 0x58a  # offset +0x58a
.equ field_58c, 0x58c  # offset +0x58c
.equ field_58e, 0x58e  # offset +0x58e
.equ field_590, 0x590  # offset +0x590
.equ field_592, 0x592  # offset +0x592
.equ field_596, 0x596  # offset +0x596
.equ field_59a, 0x59a  # offset +0x59a
.equ field_59e, 0x59e  # offset +0x59e
.equ field_5a0, 0x5a0  # offset +0x5a0
.equ field_5a2, 0x5a2  # offset +0x5a2

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_00487b4f, .text + (0x00487b4f - 0x401000)
.set FUN_004881c9, .text + (0x004881c9 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)

.org 0x00488319 - 0x401000
.globl FUN_00488319
FUN_00488319:
    # block 0x00488319: entry, 16 instruction(s), ends with je to 0x00488369 (forward)
    push ebp                                     # 00488319
    {load} mov ebp, esp                          # 0048831a
    sub esp, 0x14                                # 0048831c
    push esi                                     # 0048831f
    push edi                                     # 00488320
    mov dword ptr [ebp - local_c], ecx           # 00488321
    movsx eax, word ptr [ebp + arg_8]            # 00488324
    imul eax, eax, 0x8d                          # 00488328
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0048832e
    mov dword ptr [ebp - local_4], ecx           # 00488334
    movsx edx, word ptr [ebp + arg_8]            # 00488337
    imul edx, edx, 0x8d                          # 0048833b
    mov eax, dword ptr [edx + 0x5bb632]          # 00488341
    mov dword ptr [ebp - local_10], eax          # 00488347
    cmp dword ptr [ebp - local_10], 0x0          # 0048834a
    je.d8 L_00488369                             # 0048834e
    # block 0x00488350: entered by fall-through of je at 0x0048834e, 2 instruction(s), ends with je to 0x004885ab (forward)
    cmp dword ptr [ebp - local_10], 0x1          # 00488350
    je.d32 L_004885ab                            # 00488354
    # block 0x0048835a: entered by fall-through of je at 0x00488354, 2 instruction(s), ends with je to 0x0048873e (forward)
    cmp dword ptr [ebp - local_10], 0x2          # 0048835a
    je.d32 L_0048873e                            # 0048835e
    # block 0x00488364: entered by fall-through of je at 0x0048835e, 1 instruction(s), ends with forward jump to 0x004889c4
    jmp.d32 L_004889c4                           # 00488364
L_00488369:
    # block 0x00488369: entered by je at 0x0048834e, 89 instruction(s), calls FUN_004e8d96, FUN_004d39f9, ends with jne to 0x004884ea (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00488369
    mov dx, word ptr [ebp + arg_8]               # 0048836c
    mov word ptr [ecx + field_1e], dx            # 00488370
    mov eax, dword ptr [ebp - local_c]           # 00488374
    mov dword ptr [eax + field_71], 0x1          # 00488377
    mov ecx, dword ptr [ebp - local_c]           # 0048837e
    mov byte ptr [ecx + field_65], 0x0           # 00488381
    mov edx, dword ptr [ebp - local_c]           # 00488385
    mov word ptr [edx + field_6a], 0x0           # 00488388
    mov eax, dword ptr [ebp - local_c]           # 0048838e
    mov byte ptr [eax + field_24], 0x0           # 00488391
    mov dword ptr [0x5bb1ca], 0x1                # 00488395
    mov ecx, 0x571442                            # 0048839f
    call FUN_004e8d96                            # 004883a4
    {load} xor ecx, ecx                          # 004883a9
    mov edx, dword ptr [ebp - local_c]           # 004883ab
    add edx, 0x7a                                # 004883ae
    mov dword ptr [edx], ecx                     # 004883b1
    mov dword ptr [edx + field_4], ecx           # 004883b3
    mov dword ptr [edx + field_8], ecx           # 004883b6
    mov dword ptr [edx + field_c], ecx           # 004883b9
    mov eax, dword ptr [ebp - local_c]           # 004883bc
    mov word ptr [eax + field_66], 0xffff        # 004883bf
    mov ecx, 0x10                                # 004883c5
    {load} xor eax, eax                          # 004883ca
    mov edi, dword ptr [ebp - local_c]           # 004883cc
    add edi, 0x25                                # 004883cf
    rep stosd dword ptr es:[edi], eax            # 004883d2
    mov ecx, dword ptr [ebp - local_c]           # 004883d4
    mov byte ptr [ecx + field_70], 0x0           # 004883d7
    mov edx, dword ptr [ebp - local_c]           # 004883db
    mov byte ptr [edx + field_75], 0x0           # 004883de
    call FUN_004d39f9                            # 004883e2
    mov ecx, dword ptr [ebp - local_c]           # 004883e7
    mov word ptr [ecx + field_1c], ax            # 004883ea
    mov edx, dword ptr [ebp - local_c]           # 004883ee
    movsx eax, word ptr [edx + field_1c]         # 004883f1
    imul eax, eax, 0x4a                          # 004883f5
    mov dword ptr [eax + 0x5d1591], 0xa          # 004883f8
    mov ecx, dword ptr [ebp - local_c]           # 00488402
    movsx edx, word ptr [ecx + field_1c]         # 00488405
    imul edx, edx, 0x4a                          # 00488409
    mov dword ptr [edx + 0x5d1595], 0x4889f0     # 0048840c
    mov eax, dword ptr [ebp - local_c]           # 00488416
    movsx ecx, word ptr [eax + field_1c]         # 00488419
    imul ecx, ecx, 0x4a                          # 0048841d
    mov dword ptr [ecx + 0x5d1599], 0x0          # 00488420
    mov edx, dword ptr [ebp - local_c]           # 0048842a
    movsx eax, word ptr [edx + field_1c]         # 0048842d
    imul eax, eax, 0x4a                          # 00488431
    mov dword ptr [eax + 0x5d159d], 0x0          # 00488434
    mov ecx, dword ptr [ebp - local_c]           # 0048843e
    movsx edx, word ptr [ecx + field_1c]         # 00488441
    imul edx, edx, 0x4a                          # 00488445
    mov dword ptr [edx + 0x5d15a1], 0x0          # 00488448
    mov eax, dword ptr [ebp - local_c]           # 00488452
    movsx ecx, word ptr [eax + field_1c]         # 00488455
    imul ecx, ecx, 0x4a                          # 00488459
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 0048845c
    mov edx, dword ptr [ebp - local_c]           # 00488466
    movsx eax, word ptr [edx + field_1c]         # 00488469
    imul eax, eax, 0x4a                          # 0048846d
    mov dword ptr [eax + 0x5d15a9], 0x1          # 00488470
    mov ecx, dword ptr [ebp - local_c]           # 0048847a
    movsx edx, word ptr [ecx + field_1c]         # 0048847d
    imul edx, edx, 0x4a                          # 00488481
    mov word ptr [edx + 0x5d15ad], 0x0           # 00488484
    mov edi, 0x54de28                            # 0048848d
    mov eax, dword ptr [ebp - local_c]           # 00488492
    movsx ecx, word ptr [eax + field_1c]         # 00488495
    imul ecx, ecx, 0x4a                          # 00488499
    add ecx, 0x5d15b3                            # 0048849c
    {load} mov edx, ecx                          # 004884a2
    or ecx, -0x1                                 # 004884a4
    {load} xor eax, eax                          # 004884a7
    repne scasb al, byte ptr es:[edi]            # 004884a9
    not ecx                                      # 004884ab
    {load} sub edi, ecx                          # 004884ad
    {load} mov esi, edi                          # 004884af
    {load} mov eax, ecx                          # 004884b1
    {load} mov edi, edx                          # 004884b3
    shr ecx, 0x2                                 # 004884b5
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004884b8
    {load} mov ecx, eax                          # 004884ba
    and ecx, 0x3                                 # 004884bc
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004884bf
    mov ecx, dword ptr [ebp - local_c]           # 004884c1
    cmp dword ptr [ecx + field_20], 0x0          # 004884c4
    jne.d8 L_004884ea                            # 004884c8
    # block 0x004884ca: entered by fall-through of jne at 0x004884c8, 9 instruction(s), calls FUN_004c2790, falls into the block at 0x004884ea
    push 0x54de44                                # 004884ca
    push 0x6                                     # 004884cf
    mov edx, dword ptr [ebp - local_4]           # 004884d1
    push edx                                     # 004884d4
    push 0x54de5c                                # 004884d5
    mov ecx, 0x5cf659                            # 004884da
    call FUN_004c2790                            # 004884df
    mov ecx, dword ptr [ebp - local_c]           # 004884e4
    mov dword ptr [ecx + field_20], eax          # 004884e7
L_004884ea:
    # block 0x004884ea: entered by jne at 0x004884c8, 13 instruction(s), ends with je to 0x0048852d (forward)
    mov edx, dword ptr [ebp - local_c]           # 004884ea
    movsx eax, word ptr [edx + field_1c]         # 004884ed
    imul eax, eax, 0x4a                          # 004884f1
    mov ecx, dword ptr [ebp - local_c]           # 004884f4
    mov edx, dword ptr [ecx + field_20]          # 004884f7
    mov dword ptr [eax + 0x5d1599], edx          # 004884fa
    mov edi, 0x54de64                            # 00488500
    mov esi, dword ptr [ebp - local_4]           # 00488505
    add esi, 0x4ab                               # 00488508
    mov ecx, 0x9                                 # 0048850e
    {load} xor eax, eax                          # 00488513
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00488515
    je.d8 L_0048852d                             # 00488517
    # block 0x00488519: entered by fall-through of je at 0x00488517, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x0048852d
    mov ecx, dword ptr [ebp - local_4]           # 00488519
    add ecx, 0x4ab                               # 0048851c
    push ecx                                     # 00488522
    mov ecx, 0x5c3a67                            # 00488523
    call FUN_004fb77a                            # 00488528
L_0048852d:
    # block 0x0048852d: entered by je at 0x00488517, 7 instruction(s), ends with je to 0x00488559 (forward)
    mov edi, 0x54de70                            # 0048852d
    mov esi, dword ptr [ebp - local_4]           # 00488532
    add esi, 0x4dc                               # 00488535
    mov ecx, 0x9                                 # 0048853b
    {load} xor edx, edx                          # 00488540
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00488542
    je.d8 L_00488559                             # 00488544
    # block 0x00488546: entered by fall-through of je at 0x00488544, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x00488559
    mov eax, dword ptr [ebp - local_4]           # 00488546
    add eax, 0x4dc                               # 00488549
    push eax                                     # 0048854e
    mov ecx, 0x5c3a67                            # 0048854f
    call FUN_004fb77a                            # 00488554
L_00488559:
    # block 0x00488559: entered by je at 0x00488544, 7 instruction(s), ends with je to 0x00488585 (forward)
    mov edi, 0x54de7c                            # 00488559
    mov esi, dword ptr [ebp - local_4]           # 0048855e
    add esi, 0x50d                               # 00488561
    mov ecx, 0x9                                 # 00488567
    {load} xor edx, edx                          # 0048856c
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0048856e
    je.d8 L_00488585                             # 00488570
    # block 0x00488572: entered by fall-through of je at 0x00488570, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x00488585
    mov eax, dword ptr [ebp - local_4]           # 00488572
    add eax, 0x50d                               # 00488575
    push eax                                     # 0048857a
    mov ecx, 0x5c3a67                            # 0048857b
    call FUN_004fb77a                            # 00488580
L_00488585:
    # block 0x00488585: entered by je at 0x00488570, 7 instruction(s), ends with forward jump to 0x004889c4
    mov ecx, dword ptr [ebp - local_c]           # 00488585
    mov dword ptr [ecx + field_6c], 0x1          # 00488588
    mov edx, dword ptr [ebp - local_c]           # 0048858f
    movsx eax, word ptr [edx + field_1e]         # 00488592
    imul eax, eax, 0x8d                          # 00488596
    mov dword ptr [eax + 0x5bb632], 0x1          # 0048859c
    jmp.d32 L_004889c4                           # 004885a6
L_004885ab:
    # block 0x004885ab: entered by je at 0x00488354, 5 instruction(s), ends with ja to 0x00488739 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004885ab
    mov edx, dword ptr [ecx + field_6c]          # 004885ae
    mov dword ptr [ebp - local_14], edx          # 004885b1
    cmp dword ptr [ebp - local_14], 0x4          # 004885b4
    ja.d32 L_00488739                            # 004885b8
    # block 0x004885be: entered by fall-through of ja at 0x004885b8, 2 instruction(s), ends with indirect jump dword ptr [4*eax + 0x4889cc]
    mov eax, dword ptr [ebp - local_14]          # 004885be
    jmp dword ptr [4*eax + SWTAB_004889cc_VA]    # 004885c1
L_004885c8:
    # block 0x004885c8: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x0048864a (forward)
    call dword ptr [0x52a23c]                    # 004885c8
    mov ecx, dword ptr [ebp - local_c]           # 004885ce
    cmp eax, dword ptr [ecx + field_76]          # 004885d1
    jb.d8 L_0048864a                             # 004885d4
    # block 0x004885d6: entered by fall-through of jb at 0x004885d4, 11 instruction(s), ends with jne to 0x00488642 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004885d6
    mov dword ptr [edx + field_6c], 0x1          # 004885d9
    mov eax, dword ptr [ebp - local_c]           # 004885e0
    mov byte ptr [eax + field_24], 0x1           # 004885e3
    mov ecx, dword ptr [ebp - local_c]           # 004885e7
    mov byte ptr [ecx + field_65], 0x0           # 004885ea
    mov edx, dword ptr [ebp - local_4]           # 004885ee
    {load} xor eax, eax                          # 004885f1
    mov al, byte ptr [edx + field_24]            # 004885f3
    test eax, eax                                # 004885f6
    jne.d8 L_00488642                            # 004885f8
    # block 0x004885fa: entered by fall-through of jne at 0x004885f8, 5 instruction(s), ends with jne to 0x0048861f (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004885fa
    movsx edx, word ptr [ecx + field_68]         # 004885fd
    mov eax, dword ptr [ebp - local_c]           # 00488601
    cmp dword ptr [eax + 4*edx + field_25], 0x3  # 00488604
    jne.d8 L_0048861f                            # 00488609
    # block 0x0048860b: entered by fall-through of jne at 0x00488609, 5 instruction(s), ends with forward jump to 0x00488642
    mov ecx, dword ptr [ebp - local_c]           # 0048860b
    movsx edx, word ptr [ecx + field_68]         # 0048860e
    mov eax, dword ptr [ebp - local_c]           # 00488612
    mov dword ptr [eax + 4*edx + field_25], 0x2  # 00488615
    jmp.d8 L_00488642                            # 0048861d
L_0048861f:
    # block 0x0048861f: entered by jne at 0x00488609, 5 instruction(s), ends with jne to 0x00488642 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0048861f
    movsx edx, word ptr [ecx + field_68]         # 00488622
    mov eax, dword ptr [ebp - local_c]           # 00488626
    cmp dword ptr [eax + 4*edx + field_25], 0x1  # 00488629
    jne.d8 L_00488642                            # 0048862e
    # block 0x00488630: entered by fall-through of jne at 0x0048862e, 4 instruction(s), falls into the block at 0x00488642
    mov ecx, dword ptr [ebp - local_c]           # 00488630
    movsx edx, word ptr [ecx + field_68]         # 00488633
    mov eax, dword ptr [ebp - local_c]           # 00488637
    mov dword ptr [eax + 4*edx + field_25], 0x0  # 0048863a
L_00488642:
    # block 0x00488642: entered by jne at 0x004885f8; jmp at 0x0048861d; jne at 0x0048862e, 2 instruction(s), calls FUN_004881c9, falls into the block at 0x0048864a
    mov ecx, dword ptr [ebp - local_c]           # 00488642
    call FUN_004881c9                            # 00488645
L_0048864a:
    # block 0x0048864a: entered by jb at 0x004885d4, 1 instruction(s), ends with forward jump to 0x00488739
    jmp.d32 L_00488739                           # 0048864a
L_0048864f:
    # block 0x0048864f: entered by switch case, 10 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x00488739
    call dword ptr [0x52a23c]                    # 0048864f
    mov ecx, dword ptr [ebp - local_4]           # 00488655
    movsx edx, word ptr [ecx + field_557]        # 00488658
    imul edx, edx, 0x3e8                         # 0048865f
    {load} add eax, edx                          # 00488665
    mov ecx, dword ptr [ebp - local_c]           # 00488667
    mov dword ptr [ecx + field_76], eax          # 0048866a
    mov edx, dword ptr [ebp - local_c]           # 0048866d
    mov dword ptr [edx + field_6c], 0x3          # 00488670
    jmp.d32 L_00488739                           # 00488677
L_0048867c:
    # block 0x0048867c: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x004886ee (forward)
    call dword ptr [0x52a23c]                    # 0048867c
    mov ecx, dword ptr [ebp - local_c]           # 00488682
    cmp eax, dword ptr [ecx + field_76]          # 00488685
    jb.d8 L_004886ee                             # 00488688
    # block 0x0048868a: entered by fall-through of jb at 0x00488688, 7 instruction(s), ends with je to 0x004886d7 (forward)
    mov edi, 0x54de88                            # 0048868a
    mov esi, dword ptr [ebp - local_4]           # 0048868f
    add esi, 0x559                               # 00488692
    mov ecx, 0x9                                 # 00488698
    {load} xor edx, edx                          # 0048869d
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0048869f
    je.d8 L_004886d7                             # 004886a1
    # block 0x004886a3: entered by fall-through of je at 0x004886a1, 13 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x004886ee
    mov eax, dword ptr [ebp - local_4]           # 004886a3
    add eax, 0x559                               # 004886a6
    push eax                                     # 004886ab
    mov ecx, 0x5c3a67                            # 004886ac
    call FUN_004fb77a                            # 004886b1
    mov ecx, dword ptr [ebp - local_4]           # 004886b6
    mov dx, word ptr [ecx + field_57a]           # 004886b9
    push edx                                     # 004886c0
    mov ecx, 0x5c3a67                            # 004886c1
    call FUN_004fb2e3                            # 004886c6
    mov eax, dword ptr [ebp - local_c]           # 004886cb
    mov dword ptr [eax + field_6c], 0x4          # 004886ce
    jmp.d8 L_004886ee                            # 004886d5
L_004886d7:
    # block 0x004886d7: entered by je at 0x004886a1, 4 instruction(s), falls into the block at 0x004886ee
    mov ecx, dword ptr [ebp - local_c]           # 004886d7
    movsx edx, word ptr [ecx + field_1e]         # 004886da
    imul edx, edx, 0x8d                          # 004886de
    mov dword ptr [edx + 0x5bb632], 0x2          # 004886e4
L_004886ee:
    # block 0x004886ee: entered by jb at 0x00488688; jmp at 0x004886d5, 1 instruction(s), ends with forward jump to 0x00488739
    jmp.d8 L_00488739                            # 004886ee
L_004886f0:
    # block 0x004886f0: entered by switch case, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x00488739 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004886f0
    movsx ecx, word ptr [eax + field_57a]        # 004886f3
    mov dword ptr [ebp - local_8], ecx           # 004886fa
    mov edx, dword ptr [ebp - local_8]           # 004886fd
    push edx                                     # 00488700
    mov ecx, 0x5cf1eb                            # 00488701
    call FUN_004f6334                            # 00488706
    test eax, eax                                # 0048870b
    jne.d8 L_00488739                            # 0048870d
    # block 0x0048870f: entered by fall-through of jne at 0x0048870d, 9 instruction(s), calls FUN_004fba69, falls into the block at 0x00488739
    mov eax, dword ptr [ebp - local_4]           # 0048870f
    add eax, 0x559                               # 00488712
    push eax                                     # 00488717
    mov ecx, 0x5c3a67                            # 00488718
    call FUN_004fba69                            # 0048871d
    mov ecx, dword ptr [ebp - local_c]           # 00488722
    movsx edx, word ptr [ecx + field_1e]         # 00488725
    imul edx, edx, 0x8d                          # 00488729
    mov dword ptr [edx + 0x5bb632], 0x2          # 0048872f
L_00488739:
    # block 0x00488739: entered by ja at 0x004885b8; jmp at 0x0048864a; jmp at 0x00488677; jmp at 0x004886ee; more, 1 instruction(s), ends with forward jump to 0x004889c4
    jmp.d32 L_004889c4                           # 00488739
L_0048873e:
    # block 0x0048873e: entered by je at 0x0048835e, 8 instruction(s), ends with je to 0x00488775 (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 0048873e
    mov edi, 0x54de94                            # 00488748
    mov esi, dword ptr [ebp - local_4]           # 0048874d
    add esi, 0x4ab                               # 00488750
    mov ecx, 0x9                                 # 00488756
    {load} xor eax, eax                          # 0048875b
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0048875d
    je.d8 L_00488775                             # 0048875f
    # block 0x00488761: entered by fall-through of je at 0x0048875f, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x00488775
    mov ecx, dword ptr [ebp - local_4]           # 00488761
    add ecx, 0x4ab                               # 00488764
    push ecx                                     # 0048876a
    mov ecx, 0x5c3a67                            # 0048876b
    call FUN_004fba69                            # 00488770
L_00488775:
    # block 0x00488775: entered by je at 0x0048875f, 7 instruction(s), ends with je to 0x004887a1 (forward)
    mov edi, 0x54dea0                            # 00488775
    mov esi, dword ptr [ebp - local_4]           # 0048877a
    add esi, 0x4dc                               # 0048877d
    mov ecx, 0x9                                 # 00488783
    {load} xor edx, edx                          # 00488788
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0048878a
    je.d8 L_004887a1                             # 0048878c
    # block 0x0048878e: entered by fall-through of je at 0x0048878c, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004887a1
    mov eax, dword ptr [ebp - local_4]           # 0048878e
    add eax, 0x4dc                               # 00488791
    push eax                                     # 00488796
    mov ecx, 0x5c3a67                            # 00488797
    call FUN_004fba69                            # 0048879c
L_004887a1:
    # block 0x004887a1: entered by je at 0x0048878c, 7 instruction(s), ends with je to 0x004887cd (forward)
    mov edi, 0x54deac                            # 004887a1
    mov esi, dword ptr [ebp - local_4]           # 004887a6
    add esi, 0x50d                               # 004887a9
    mov ecx, 0x9                                 # 004887af
    {load} xor edx, edx                          # 004887b4
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004887b6
    je.d8 L_004887cd                             # 004887b8
    # block 0x004887ba: entered by fall-through of je at 0x004887b8, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004887cd
    mov eax, dword ptr [ebp - local_4]           # 004887ba
    add eax, 0x50d                               # 004887bd
    push eax                                     # 004887c2
    mov ecx, 0x5c3a67                            # 004887c3
    call FUN_004fba69                            # 004887c8
L_004887cd:
    # block 0x004887cd: entered by je at 0x004887b8, 5 instruction(s), ends with je to 0x004888bf (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004887cd
    {load} xor edx, edx                          # 004887d0
    mov dl, byte ptr [ecx + field_75]            # 004887d2
    test edx, edx                                # 004887d5
    je.d32 L_004888bf                            # 004887d7
    # block 0x004887dd: entered by fall-through of je at 0x004887d7, 4 instruction(s), ends with je to 0x0048888f (forward)
    mov eax, dword ptr [ebp - local_4]           # 004887dd
    movsx ecx, word ptr [eax + field_58a]        # 004887e0
    cmp ecx, 0x270f                              # 004887e7
    je.d32 L_0048888f                            # 004887ed
    # block 0x004887f3: entered by fall-through of je at 0x004887ed, 25 instruction(s), ends with jne to 0x0048887b (forward)
    mov edx, dword ptr [ebp - local_4]           # 004887f3
    movsx eax, word ptr [edx + field_58a]        # 004887f6
    mov dword ptr [0x5bb57b], eax                # 004887fd
    mov ecx, dword ptr [ebp - local_4]           # 00488802
    mov dx, word ptr [ecx + field_58c]           # 00488805
    mov word ptr [0x5bb599], dx                  # 0048880c
    mov eax, dword ptr [ebp - local_4]           # 00488813
    mov cx, word ptr [eax + field_58e]           # 00488816
    mov word ptr [0x5bb595], cx                  # 0048881d
    mov edx, dword ptr [ebp - local_4]           # 00488824
    mov ax, word ptr [edx + field_590]           # 00488827
    mov word ptr [0x5c39ff], ax                  # 0048882e
    mov ecx, dword ptr [ebp - local_4]           # 00488834
    mov edx, dword ptr [ecx + field_592]         # 00488837
    mov dword ptr [0x5bb59b], edx                # 0048883d
    mov eax, dword ptr [ebp - local_4]           # 00488843
    mov ecx, dword ptr [eax + field_596]         # 00488846
    mov dword ptr [0x5bb59f], ecx                # 0048884c
    mov edx, dword ptr [ebp - local_4]           # 00488852
    mov eax, dword ptr [edx + field_59a]         # 00488855
    mov dword ptr [0x5bb5a3], eax                # 0048885b
    mov ecx, dword ptr [ebp - local_4]           # 00488860
    movsx edx, word ptr [ecx + field_59e]        # 00488863
    cmp edx, 0x1                                 # 0048886a
    jne.d8 L_0048887b                            # 0048886d
    # block 0x0048886f: entered by fall-through of jne at 0x0048886d, 2 instruction(s), ends with forward jump to 0x00488885
    mov dword ptr [0x5bb1ca], 0x0                # 0048886f
    jmp.d8 L_00488885                            # 00488879
L_0048887b:
    # block 0x0048887b: entered by jne at 0x0048886d, 1 instruction(s), falls into the block at 0x00488885
    mov dword ptr [0x5bb1ca], 0x1                # 0048887b
L_00488885:
    # block 0x00488885: entered by jmp at 0x00488879, 1 instruction(s), falls into the block at 0x0048888f
    mov dword ptr [0x583999], 0x4                # 00488885
L_0048888f:
    # block 0x0048888f: entered by je at 0x004887ed, 4 instruction(s), ends with je to 0x004888ba (forward)
    mov eax, dword ptr [ebp - local_4]           # 0048888f
    movsx ecx, word ptr [eax + field_5a0]        # 00488892
    cmp ecx, -0x1                                # 00488899
    je.d8 L_004888ba                             # 0048889c
    # block 0x0048889e: entered by fall-through of je at 0x0048889c, 6 instruction(s), falls into the block at 0x004888ba
    mov edx, dword ptr [ebp - local_4]           # 0048889e
    {load} xor eax, eax                          # 004888a1
    mov al, byte ptr [edx + field_5a2]           # 004888a3
    mov ecx, dword ptr [ebp - local_4]           # 004888a9
    movsx edx, word ptr [ecx + field_5a0]        # 004888ac
    mov dword ptr [4*edx + 0x585801], eax        # 004888b3
L_004888ba:
    # block 0x004888ba: entered by je at 0x0048889c, 1 instruction(s), ends with forward jump to 0x004889ac
    jmp.d32 L_004889ac                           # 004888ba
L_004888bf:
    # block 0x004888bf: entered by je at 0x004887d7, 5 instruction(s), ends with je to 0x004889ac (forward)
    mov eax, dword ptr [ebp - local_c]           # 004888bf
    {load} xor ecx, ecx                          # 004888c2
    mov cl, byte ptr [eax + field_70]            # 004888c4
    test ecx, ecx                                # 004888c7
    je.d32 L_004889ac                            # 004888c9
    # block 0x004888cf: entered by fall-through of je at 0x004888c9, 4 instruction(s), ends with je to 0x00488981 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004888cf
    movsx eax, word ptr [edx + field_53e]        # 004888d2
    cmp eax, 0x270f                              # 004888d9
    je.d32 L_00488981                            # 004888de
    # block 0x004888e4: entered by fall-through of je at 0x004888de, 25 instruction(s), ends with jne to 0x0048896d (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004888e4
    movsx edx, word ptr [ecx + field_53e]        # 004888e7
    mov dword ptr [0x5bb57b], edx                # 004888ee
    mov eax, dword ptr [ebp - local_4]           # 004888f4
    mov cx, word ptr [eax + field_540]           # 004888f7
    mov word ptr [0x5bb599], cx                  # 004888fe
    mov edx, dword ptr [ebp - local_4]           # 00488905
    mov ax, word ptr [edx + field_542]           # 00488908
    mov word ptr [0x5bb595], ax                  # 0048890f
    mov ecx, dword ptr [ebp - local_4]           # 00488915
    mov dx, word ptr [ecx + field_544]           # 00488918
    mov word ptr [0x5c39ff], dx                  # 0048891f
    mov eax, dword ptr [ebp - local_4]           # 00488926
    mov ecx, dword ptr [eax + field_546]         # 00488929
    mov dword ptr [0x5bb59b], ecx                # 0048892f
    mov edx, dword ptr [ebp - local_4]           # 00488935
    mov eax, dword ptr [edx + field_54a]         # 00488938
    mov dword ptr [0x5bb59f], eax                # 0048893e
    mov ecx, dword ptr [ebp - local_4]           # 00488943
    mov edx, dword ptr [ecx + field_54e]         # 00488946
    mov dword ptr [0x5bb5a3], edx                # 0048894c
    mov eax, dword ptr [ebp - local_4]           # 00488952
    movsx ecx, word ptr [eax + field_552]        # 00488955
    cmp ecx, 0x1                                 # 0048895c
    jne.d8 L_0048896d                            # 0048895f
    # block 0x00488961: entered by fall-through of jne at 0x0048895f, 2 instruction(s), ends with forward jump to 0x00488977
    mov dword ptr [0x5bb1ca], 0x0                # 00488961
    jmp.d8 L_00488977                            # 0048896b
L_0048896d:
    # block 0x0048896d: entered by jne at 0x0048895f, 1 instruction(s), falls into the block at 0x00488977
    mov dword ptr [0x5bb1ca], 0x1                # 0048896d
L_00488977:
    # block 0x00488977: entered by jmp at 0x0048896b, 1 instruction(s), falls into the block at 0x00488981
    mov dword ptr [0x583999], 0x4                # 00488977
L_00488981:
    # block 0x00488981: entered by je at 0x004888de, 4 instruction(s), ends with je to 0x004889ac (forward)
    mov edx, dword ptr [ebp - local_4]           # 00488981
    movsx eax, word ptr [edx + field_554]        # 00488984
    cmp eax, -0x1                                # 0048898b
    je.d8 L_004889ac                             # 0048898e
    # block 0x00488990: entered by fall-through of je at 0x0048898e, 6 instruction(s), falls into the block at 0x004889ac
    mov ecx, dword ptr [ebp - local_4]           # 00488990
    {load} xor edx, edx                          # 00488993
    mov dl, byte ptr [ecx + field_556]           # 00488995
    mov eax, dword ptr [ebp - local_4]           # 0048899b
    movsx ecx, word ptr [eax + field_554]        # 0048899e
    mov dword ptr [4*ecx + 0x585801], edx        # 004889a5
L_004889ac:
    # block 0x004889ac: entered by jmp at 0x004888ba; je at 0x004888c9; je at 0x0048898e, 7 instruction(s), calls FUN_0042ba3a, FUN_00487b4f, falls into the block at 0x004889c4
    mov edx, dword ptr [ebp - local_c]           # 004889ac
    mov ax, word ptr [edx + field_1e]            # 004889af
    push eax                                     # 004889b3
    call FUN_0042ba3a                            # 004889b4
    add esp, 0x4                                 # 004889b9
    mov ecx, dword ptr [ebp - local_c]           # 004889bc
    call FUN_00487b4f                            # 004889bf
L_004889c4:
    # block 0x004889c4: entered by jmp at 0x00488364; jmp at 0x004885a6; jmp at 0x00488739, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004889c4
    pop esi                                      # 004889c5
    {load} mov esp, ebp                          # 004889c6
    pop ebp                                      # 004889c8
    ret 0x4                                      # 004889c9

# --- data items (not part of the function) -------------------------
.org 0x004889cc - 0x401000
SWTAB_004889cc:  # 5 case address(es)
    .long L_004885c8 - .text + 0x401000
    .long L_00488739 - .text + 0x401000
    .long L_0048864f - .text + 0x401000
    .long L_0048867c - .text + 0x401000
    .long L_004886f0 - .text + 0x401000
.set SWTAB_004889cc_VA, SWTAB_004889cc - .text + 0x401000

