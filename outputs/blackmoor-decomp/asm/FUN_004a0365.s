# FUN_004a0365
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a0365
# extent:       0x004a0365-0x004a0ac4 (1887 code bytes)
# span:         0x004a0365-0x004a0ac4 (code 1887, tables 0, padding 0)
# sha256:       8ed26b59b43fe819d09500c6cdda72e42348794a308eb04f35b0f8fafa5c8b48
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a0365
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       19 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_3c, local_40, local_44, local_48, local_4c, local_50, local_54 and 7 more
# fields:       [eax + n] field_4, field_1c, field_20, field_24, field_f0, field_e38, field_minus_4, field_minus_8; [ecx + n] field_4, field_1c, field_e1c, field_e20, field_e2c, field_e38, field_minus_4; [edx + n] field_4, field_8, field_1c, field_2c, field_184, field_e38, field_minus_4
# callees:      calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, FUN_0050ce04, FUN_0050cd50
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 521 instruction(s), 44 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_minus_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_minus_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ local_4c, 0x4c  # offset -0x4c
.equ local_50, 0x50  # offset -0x50
.equ local_54, 0x54  # offset -0x54
.equ local_58, 0x58  # offset -0x58
.equ local_5c, 0x5c  # offset -0x5c
.equ local_60, 0x60  # offset -0x60
.equ local_64, 0x64  # offset -0x64
.equ local_68, 0x68  # offset -0x68
.equ local_6c, 0x6c  # offset -0x6c
.equ local_70, 0x70  # offset -0x70
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_2c, 0x2c  # offset +0x2c
.equ field_f0, 0xf0  # offset +0xf0
.equ field_184, 0x184  # offset +0x184
.equ field_e1c, 0xe1c  # offset +0xe1c
.equ field_e20, 0xe20  # offset +0xe20
.equ field_e2c, 0xe2c  # offset +0xe2c
.equ field_e38, 0xe38  # offset +0xe38

# --- external targets -----------------------------------------------
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004a0365 - 0x401000
.globl FUN_004a0365
FUN_004a0365:
    # block 0x004a0365: entry, 7 instruction(s), ends with forward jump to 0x004a0387
    push ebp                                     # 004a0365
    {load} mov ebp, esp                          # 004a0366
    sub esp, 0x70                                # 004a0368
    mov dword ptr [ebp - local_64], ecx          # 004a036b
    mov dword ptr [ebp - local_50], 0x0          # 004a036e
    mov dword ptr [ebp - local_10], 0x0          # 004a0375
    jmp.d8 L_004a0387                            # 004a037c
L_004a037e:
    # block 0x004a037e: entered by jmp at 0x004a03b0; jmp at 0x004a03d8, 3 instruction(s), falls into the block at 0x004a0387
    mov eax, dword ptr [ebp - local_10]          # 004a037e
    add eax, 0x1                                 # 004a0381
    mov dword ptr [ebp - local_10], eax          # 004a0384
L_004a0387:
    # block 0x004a0387: entered by jmp at 0x004a037c, 2 instruction(s), ends with jge to 0x004a03da (forward)
    cmp dword ptr [ebp - local_10], 0xa          # 004a0387
    jge.d8 L_004a03da                            # 004a038b
    # block 0x004a038d: entered by fall-through of jge at 0x004a038b, 9 instruction(s), ends with jne to 0x004a03b2 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004a038d
    imul ecx, ecx, 0x15e                         # 004a0390
    mov edx, dword ptr [ebp - local_64]          # 004a0396
    lea eax, [edx + ecx + field_2c]              # 004a0399
    mov ecx, dword ptr [ebp - local_10]          # 004a039d
    mov edx, dword ptr [eax + 4*ecx + field_f0]  # 004a03a0
    mov dword ptr [ebp - local_8], edx           # 004a03a7
    cmp dword ptr [ebp - local_8], -0x1          # 004a03aa
    jne.d8 L_004a03b2                            # 004a03ae
    # block 0x004a03b0: entered by fall-through of jne at 0x004a03ae, 1 instruction(s), ends with backward jump to 0x004a037e
    jmp.d8 L_004a037e                            # 004a03b0
L_004a03b2:
    # block 0x004a03b2: entered by jne at 0x004a03ae, 12 instruction(s), ends with backward jump to 0x004a037e
    mov eax, dword ptr [ebp - local_50]          # 004a03b2
    mov ecx, dword ptr [ebp - local_8]           # 004a03b5
    mov dword ptr [ebp + 4*eax - local_3c], ecx  # 004a03b8
    mov edx, dword ptr [ebp - local_50]          # 004a03bc
    mov eax, dword ptr [ebp + 4*edx - local_3c]  # 004a03bf
    and eax, 0xffffff                            # 004a03c3
    mov ecx, dword ptr [ebp - local_50]          # 004a03c8
    mov dword ptr [ebp + 4*ecx - local_3c], eax  # 004a03cb
    mov edx, dword ptr [ebp - local_50]          # 004a03cf
    add edx, 0x1                                 # 004a03d2
    mov dword ptr [ebp - local_50], edx          # 004a03d5
    jmp.d8 L_004a037e                            # 004a03d8
L_004a03da:
    # block 0x004a03da: entered by jge at 0x004a038b, 2 instruction(s), ends with jne to 0x004a040e (forward)
    cmp dword ptr [ebp - local_50], 0x0          # 004a03da
    jne.d8 L_004a040e                            # 004a03de
    # block 0x004a03e0: entered by fall-through of jne at 0x004a03de, 12 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x004a040e
    mov eax, dword ptr [ebp + arg_8]             # 004a03e0
    push eax                                     # 004a03e3
    push 0x550018                                # 004a03e4
    push 0x63888b                                # 004a03e9
    call FUN_0050ca3e                            # 004a03ee
    add esp, 0xc                                 # 004a03f3
    push 0x0                                     # 004a03f6
    push 0x0                                     # 004a03f8
    push 0x63888b                                # 004a03fa
    call FUN_0052139c                            # 004a03ff
    mov ecx, 0x5cf659                            # 004a0404
    call FUN_004c97b4                            # 004a0409
L_004a040e:
    # block 0x004a040e: entered by jne at 0x004a03de, 13 instruction(s), calls FUN_0050ce04, falls into the block at 0x004a0446
    mov ecx, dword ptr [ebp + arg_8]             # 004a040e
    imul ecx, ecx, 0x15e                         # 004a0411
    mov edx, dword ptr [ebp - local_64]          # 004a0417
    movsx eax, word ptr [edx + ecx + field_184]  # 004a041a
    mov dword ptr [ebp - local_68], eax          # 004a0422
    fild dword ptr [ebp - local_68]              # 004a0425
    fstp dword ptr [ebp - local_6c]              # 004a0428
    mov ecx, dword ptr [ebp - local_64]          # 004a042b
    fld dword ptr [ebp - local_6c]               # 004a042e
    fmul dword ptr [ecx + field_e2c]             # 004a0431
    call FUN_0050ce04                            # 004a0437
    mov dword ptr [ebp - local_c], eax           # 004a043c
    mov dword ptr [ebp - local_4c], 0x0          # 004a043f
L_004a0446:
    # block 0x004a0446: entered by jmp at 0x004a0ab9, 3 instruction(s), ends with jge to 0x004a0abe (forward)
    mov edx, dword ptr [ebp - local_4c]          # 004a0446
    cmp edx, dword ptr [ebp - local_c]           # 004a0449
    jge.d32 L_004a0abe                           # 004a044c
    # block 0x004a0452: entered by fall-through of jge at 0x004a044c, 3 instruction(s), calls FUN_0050cd50, ends with jns to 0x004a0463 (forward)
    call FUN_0050cd50                            # 004a0452
    and eax, 0x80000001                          # 004a0457
    jns.d8 L_004a0463                            # 004a045c
    # block 0x004a045e: entered by fall-through of jns at 0x004a045c, 3 instruction(s), falls into the block at 0x004a0463
    dec eax                                      # 004a045e
    or eax, -0x2                                 # 004a045f
    inc eax                                      # 004a0462
L_004a0463:
    # block 0x004a0463: entered by jns at 0x004a045c, 12 instruction(s), falls into the block at 0x004a048f
    mov dword ptr [ebp - local_4], eax           # 004a0463
    mov dword ptr [ebp - local_5c], 0x0          # 004a0466
    mov eax, dword ptr [ebp - local_5c]          # 004a046d
    mov dword ptr [ebp - local_44], eax          # 004a0470
    mov ecx, dword ptr [ebp - local_44]          # 004a0473
    mov dword ptr [ebp - local_54], ecx          # 004a0476
    mov edx, dword ptr [ebp - local_54]          # 004a0479
    mov dword ptr [ebp - local_14], edx          # 004a047c
    mov eax, dword ptr [ebp - local_64]          # 004a047f
    mov ecx, dword ptr [eax + field_24]          # 004a0482
    mov dword ptr [ebp - local_58], ecx          # 004a0485
    mov dword ptr [ebp - local_40], 0x0          # 004a0488
L_004a048f:
    # block 0x004a048f: entered by jmp at 0x004a04fd; jmp at 0x004a0527; jmp at 0x004a0a1e, 2 instruction(s), ends with jne to 0x004a0a23 (forward)
    cmp dword ptr [ebp - local_40], 0x0          # 004a048f
    jne.d32 L_004a0a23                           # 004a0493
    # block 0x004a0499: entered by fall-through of jne at 0x004a0493, 5 instruction(s), ends with jg to 0x004a04ad (forward)
    mov edx, dword ptr [ebp - local_58]          # 004a0499
    sub edx, 0x1                                 # 004a049c
    mov dword ptr [ebp - local_58], edx          # 004a049f
    cmp dword ptr [ebp - local_58], 0x0          # 004a04a2
    jg.d8 L_004a04ad                             # 004a04a6
    # block 0x004a04a8: entered by fall-through of jg at 0x004a04a6, 1 instruction(s), ends with forward jump to 0x004a0a23
    jmp.d32 L_004a0a23                           # 004a04a8
L_004a04ad:
    # block 0x004a04ad: entered by jg at 0x004a04a6, 23 instruction(s), calls FUN_0050cd50, ends with jne to 0x004a04ff (forward)
    call FUN_0050cd50                            # 004a04ad
    mov ecx, dword ptr [ebp - local_64]          # 004a04b2
    cdq                                          # 004a04b5
    idiv dword ptr [ecx + field_e20]             # 004a04b6
    add edx, dword ptr [ebp + arg_c]             # 004a04bc
    mov dword ptr [ebp - local_14], edx          # 004a04bf
    call FUN_0050cd50                            # 004a04c2
    mov ecx, dword ptr [ebp - local_64]          # 004a04c7
    cdq                                          # 004a04ca
    idiv dword ptr [ecx + field_e1c]             # 004a04cb
    add edx, dword ptr [ebp + arg_10]            # 004a04d1
    mov dword ptr [ebp - local_44], edx          # 004a04d4
    mov edx, dword ptr [ebp - local_64]          # 004a04d7
    mov eax, dword ptr [ebp - local_14]          # 004a04da
    imul eax, dword ptr [edx + field_1c]         # 004a04dd
    mov ecx, dword ptr [ebp - local_64]          # 004a04e1
    mov edx, dword ptr [ecx + field_e38]         # 004a04e4
    lea eax, [edx + 4*eax]                       # 004a04ea
    mov ecx, dword ptr [ebp - local_44]          # 004a04ed
    mov edx, dword ptr [eax + 4*ecx]             # 004a04f0
    and edx, 0x1000000                           # 004a04f3
    test edx, edx                                # 004a04f9
    jne.d8 L_004a04ff                            # 004a04fb
    # block 0x004a04fd: entered by fall-through of jne at 0x004a04fb, 1 instruction(s), ends with backward jump to 0x004a048f
    jmp.d8 L_004a048f                            # 004a04fd
L_004a04ff:
    # block 0x004a04ff: entered by jne at 0x004a04fb, 2 instruction(s), ends with jle to 0x004a0527 (forward)
    cmp dword ptr [ebp - local_14], 0x3          # 004a04ff
    jle.d8 L_004a0527                            # 004a0503
    # block 0x004a0505: entered by fall-through of jle at 0x004a0503, 5 instruction(s), ends with jge to 0x004a0527 (forward)
    mov eax, dword ptr [ebp - local_64]          # 004a0505
    mov ecx, dword ptr [eax + field_20]          # 004a0508
    sub ecx, 0x4                                 # 004a050b
    cmp dword ptr [ebp - local_14], ecx          # 004a050e
    jge.d8 L_004a0527                            # 004a0511
    # block 0x004a0513: entered by fall-through of jge at 0x004a0511, 2 instruction(s), ends with jle to 0x004a0527 (forward)
    cmp dword ptr [ebp - local_44], 0x3          # 004a0513
    jle.d8 L_004a0527                            # 004a0517
    # block 0x004a0519: entered by fall-through of jle at 0x004a0517, 5 instruction(s), ends with jl to 0x004a052c (forward)
    mov edx, dword ptr [ebp - local_64]          # 004a0519
    mov eax, dword ptr [edx + field_1c]          # 004a051c
    sub eax, 0x4                                 # 004a051f
    cmp dword ptr [ebp - local_44], eax          # 004a0522
    jl.d8 L_004a052c                             # 004a0525
L_004a0527:
    # block 0x004a0527: entered by jle at 0x004a0503; jge at 0x004a0511; jle at 0x004a0517; fall-through of jl at 0x004a0525, 1 instruction(s), ends with backward jump to 0x004a048f
    jmp.d32 L_004a048f                           # 004a0527
L_004a052c:
    # block 0x004a052c: entered by jl at 0x004a0525, 4 instruction(s), ends with je to 0x004a0547 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004a052c
    mov dword ptr [ebp - local_70], ecx          # 004a052f
    cmp dword ptr [ebp - local_70], 0x0          # 004a0532
    je.d8 L_004a0547                             # 004a0536
    # block 0x004a0538: entered by fall-through of je at 0x004a0536, 2 instruction(s), ends with je to 0x004a07b5 (forward)
    cmp dword ptr [ebp - local_70], 0x1          # 004a0538
    je.d32 L_004a07b5                            # 004a053c
    # block 0x004a0542: entered by fall-through of je at 0x004a053c, 1 instruction(s), ends with forward jump to 0x004a0a1e
    jmp.d32 L_004a0a1e                           # 004a0542
L_004a0547:
    # block 0x004a0547: entered by je at 0x004a0536, 12 instruction(s), ends with je to 0x004a067e (forward)
    mov edx, dword ptr [ebp - local_14]          # 004a0547
    sub edx, 0x1                                 # 004a054a
    mov eax, dword ptr [ebp - local_64]          # 004a054d
    imul edx, dword ptr [eax + field_1c]         # 004a0550
    mov ecx, dword ptr [ebp - local_64]          # 004a0554
    mov eax, dword ptr [ecx + field_e38]         # 004a0557
    lea ecx, [eax + 4*edx]                       # 004a055d
    mov edx, dword ptr [ebp - local_44]          # 004a0560
    mov eax, dword ptr [ecx + 4*edx]             # 004a0563
    and eax, 0x1000000                           # 004a0566
    test eax, eax                                # 004a056b
    je.d32 L_004a067e                            # 004a056d
    # block 0x004a0573: entered by fall-through of je at 0x004a056d, 10 instruction(s), ends with jne to 0x004a067e (forward)
    mov ecx, dword ptr [ebp - local_14]          # 004a0573
    sub ecx, 0x2                                 # 004a0576
    mov edx, dword ptr [ebp - local_64]          # 004a0579
    imul ecx, dword ptr [edx + field_1c]         # 004a057c
    mov eax, dword ptr [ebp - local_64]          # 004a0580
    mov edx, dword ptr [eax + field_e38]         # 004a0583
    lea eax, [edx + 4*ecx]                       # 004a0589
    mov ecx, dword ptr [ebp - local_44]          # 004a058c
    cmp dword ptr [eax + 4*ecx], 0x0             # 004a058f
    jne.d32 L_004a067e                           # 004a0593
    # block 0x004a0599: entered by fall-through of jne at 0x004a0593, 10 instruction(s), ends with jne to 0x004a067e (forward)
    mov edx, dword ptr [ebp - local_14]          # 004a0599
    add edx, 0x1                                 # 004a059c
    mov eax, dword ptr [ebp - local_64]          # 004a059f
    imul edx, dword ptr [eax + field_1c]         # 004a05a2
    mov ecx, dword ptr [ebp - local_64]          # 004a05a6
    mov eax, dword ptr [ecx + field_e38]         # 004a05a9
    lea ecx, [eax + 4*edx]                       # 004a05af
    mov edx, dword ptr [ebp - local_44]          # 004a05b2
    cmp dword ptr [ecx + 4*edx], 0x0             # 004a05b5
    jne.d32 L_004a067e                           # 004a05b9
    # block 0x004a05bf: entered by fall-through of jne at 0x004a05b9, 16 instruction(s), ends with je to 0x004a0679 (forward)
    mov eax, dword ptr [ebp - local_14]          # 004a05bf
    sub eax, 0x1                                 # 004a05c2
    mov dword ptr [ebp - local_54], eax          # 004a05c5
    mov ecx, dword ptr [ebp - local_44]          # 004a05c8
    mov dword ptr [ebp - local_5c], ecx          # 004a05cb
    mov edx, dword ptr [ebp - local_64]          # 004a05ce
    mov eax, dword ptr [ebp - local_14]          # 004a05d1
    imul eax, dword ptr [edx + field_1c]         # 004a05d4
    mov ecx, dword ptr [ebp - local_64]          # 004a05d8
    mov edx, dword ptr [ecx + field_e38]         # 004a05db
    lea eax, [edx + 4*eax]                       # 004a05e1
    mov ecx, dword ptr [ebp - local_44]          # 004a05e4
    mov edx, dword ptr [eax + 4*ecx - field_minus_4] # 004a05e7
    and edx, 0x1000000                           # 004a05eb
    test edx, edx                                # 004a05f1
    je.d32 L_004a0679                            # 004a05f3
    # block 0x004a05f9: entered by fall-through of je at 0x004a05f3, 11 instruction(s), ends with je to 0x004a0679 (forward)
    mov eax, dword ptr [ebp - local_64]          # 004a05f9
    mov ecx, dword ptr [ebp - local_14]          # 004a05fc
    imul ecx, dword ptr [eax + field_1c]         # 004a05ff
    mov edx, dword ptr [ebp - local_64]          # 004a0603
    mov eax, dword ptr [edx + field_e38]         # 004a0606
    lea ecx, [eax + 4*ecx]                       # 004a060c
    mov edx, dword ptr [ebp - local_44]          # 004a060f
    mov eax, dword ptr [ecx + 4*edx + field_4]   # 004a0612
    and eax, 0x1000000                           # 004a0616
    test eax, eax                                # 004a061b
    je.d8 L_004a0679                             # 004a061d
    # block 0x004a061f: entered by fall-through of je at 0x004a061d, 11 instruction(s), ends with je to 0x004a0679 (forward)
    mov ecx, dword ptr [ebp - local_64]          # 004a061f
    mov edx, dword ptr [ebp - local_54]          # 004a0622
    imul edx, dword ptr [ecx + field_1c]         # 004a0625
    mov eax, dword ptr [ebp - local_64]          # 004a0629
    mov ecx, dword ptr [eax + field_e38]         # 004a062c
    lea edx, [ecx + 4*edx]                       # 004a0632
    mov eax, dword ptr [ebp - local_5c]          # 004a0635
    mov ecx, dword ptr [edx + 4*eax - field_minus_4] # 004a0638
    and ecx, 0x1000000                           # 004a063c
    test ecx, ecx                                # 004a0642
    je.d8 L_004a0679                             # 004a0644
    # block 0x004a0646: entered by fall-through of je at 0x004a0644, 11 instruction(s), ends with je to 0x004a0679 (forward)
    mov edx, dword ptr [ebp - local_64]          # 004a0646
    mov eax, dword ptr [ebp - local_54]          # 004a0649
    imul eax, dword ptr [edx + field_1c]         # 004a064c
    mov ecx, dword ptr [ebp - local_64]          # 004a0650
    mov edx, dword ptr [ecx + field_e38]         # 004a0653
    lea eax, [edx + 4*eax]                       # 004a0659
    mov ecx, dword ptr [ebp - local_5c]          # 004a065c
    mov edx, dword ptr [eax + 4*ecx + field_4]   # 004a065f
    and edx, 0x1000000                           # 004a0663
    test edx, edx                                # 004a0669
    je.d8 L_004a0679                             # 004a066b
    # block 0x004a066d: entered by fall-through of je at 0x004a066b, 2 instruction(s), ends with forward jump to 0x004a0a1e
    mov dword ptr [ebp - local_40], 0x1          # 004a066d
    jmp.d32 L_004a0a1e                           # 004a0674
L_004a0679:
    # block 0x004a0679: entered by je at 0x004a05f3; je at 0x004a061d; je at 0x004a0644; je at 0x004a066b, 1 instruction(s), ends with forward jump to 0x004a07b0
    jmp.d32 L_004a07b0                           # 004a0679
L_004a067e:
    # block 0x004a067e: entered by je at 0x004a056d; jne at 0x004a0593; jne at 0x004a05b9, 12 instruction(s), ends with je to 0x004a07b0 (forward)
    mov eax, dword ptr [ebp - local_14]          # 004a067e
    add eax, 0x1                                 # 004a0681
    mov ecx, dword ptr [ebp - local_64]          # 004a0684
    imul eax, dword ptr [ecx + field_1c]         # 004a0687
    mov edx, dword ptr [ebp - local_64]          # 004a068b
    mov ecx, dword ptr [edx + field_e38]         # 004a068e
    lea edx, [ecx + 4*eax]                       # 004a0694
    mov eax, dword ptr [ebp - local_44]          # 004a0697
    mov ecx, dword ptr [edx + 4*eax]             # 004a069a
    and ecx, 0x1000000                           # 004a069d
    test ecx, ecx                                # 004a06a3
    je.d32 L_004a07b0                            # 004a06a5
    # block 0x004a06ab: entered by fall-through of je at 0x004a06a5, 10 instruction(s), ends with jne to 0x004a07b0 (forward)
    mov edx, dword ptr [ebp - local_14]          # 004a06ab
    add edx, 0x2                                 # 004a06ae
    mov eax, dword ptr [ebp - local_64]          # 004a06b1
    imul edx, dword ptr [eax + field_1c]         # 004a06b4
    mov ecx, dword ptr [ebp - local_64]          # 004a06b8
    mov eax, dword ptr [ecx + field_e38]         # 004a06bb
    lea ecx, [eax + 4*edx]                       # 004a06c1
    mov edx, dword ptr [ebp - local_44]          # 004a06c4
    cmp dword ptr [ecx + 4*edx], 0x0             # 004a06c7
    jne.d32 L_004a07b0                           # 004a06cb
    # block 0x004a06d1: entered by fall-through of jne at 0x004a06cb, 10 instruction(s), ends with jne to 0x004a07b0 (forward)
    mov eax, dword ptr [ebp - local_14]          # 004a06d1
    sub eax, 0x1                                 # 004a06d4
    mov ecx, dword ptr [ebp - local_64]          # 004a06d7
    imul eax, dword ptr [ecx + field_1c]         # 004a06da
    mov edx, dword ptr [ebp - local_64]          # 004a06de
    mov ecx, dword ptr [edx + field_e38]         # 004a06e1
    lea edx, [ecx + 4*eax]                       # 004a06e7
    mov eax, dword ptr [ebp - local_44]          # 004a06ea
    cmp dword ptr [edx + 4*eax], 0x0             # 004a06ed
    jne.d32 L_004a07b0                           # 004a06f1
    # block 0x004a06f7: entered by fall-through of jne at 0x004a06f1, 16 instruction(s), ends with je to 0x004a07b0 (forward)
    mov ecx, dword ptr [ebp - local_14]          # 004a06f7
    add ecx, 0x1                                 # 004a06fa
    mov dword ptr [ebp - local_54], ecx          # 004a06fd
    mov edx, dword ptr [ebp - local_44]          # 004a0700
    mov dword ptr [ebp - local_5c], edx          # 004a0703
    mov eax, dword ptr [ebp - local_64]          # 004a0706
    mov ecx, dword ptr [ebp - local_14]          # 004a0709
    imul ecx, dword ptr [eax + field_1c]         # 004a070c
    mov edx, dword ptr [ebp - local_64]          # 004a0710
    mov eax, dword ptr [edx + field_e38]         # 004a0713
    lea ecx, [eax + 4*ecx]                       # 004a0719
    mov edx, dword ptr [ebp - local_44]          # 004a071c
    mov eax, dword ptr [ecx + 4*edx - field_minus_4] # 004a071f
    and eax, 0x1000000                           # 004a0723
    test eax, eax                                # 004a0728
    je.d32 L_004a07b0                            # 004a072a
    # block 0x004a0730: entered by fall-through of je at 0x004a072a, 11 instruction(s), ends with je to 0x004a07b0 (forward)
    mov ecx, dword ptr [ebp - local_64]          # 004a0730
    mov edx, dword ptr [ebp - local_14]          # 004a0733
    imul edx, dword ptr [ecx + field_1c]         # 004a0736
    mov eax, dword ptr [ebp - local_64]          # 004a073a
    mov ecx, dword ptr [eax + field_e38]         # 004a073d
    lea edx, [ecx + 4*edx]                       # 004a0743
    mov eax, dword ptr [ebp - local_44]          # 004a0746
    mov ecx, dword ptr [edx + 4*eax + field_4]   # 004a0749
    and ecx, 0x1000000                           # 004a074d
    test ecx, ecx                                # 004a0753
    je.d8 L_004a07b0                             # 004a0755
    # block 0x004a0757: entered by fall-through of je at 0x004a0755, 11 instruction(s), ends with je to 0x004a07b0 (forward)
    mov edx, dword ptr [ebp - local_64]          # 004a0757
    mov eax, dword ptr [ebp - local_54]          # 004a075a
    imul eax, dword ptr [edx + field_1c]         # 004a075d
    mov ecx, dword ptr [ebp - local_64]          # 004a0761
    mov edx, dword ptr [ecx + field_e38]         # 004a0764
    lea eax, [edx + 4*eax]                       # 004a076a
    mov ecx, dword ptr [ebp - local_5c]          # 004a076d
    mov edx, dword ptr [eax + 4*ecx - field_minus_4] # 004a0770
    and edx, 0x1000000                           # 004a0774
    test edx, edx                                # 004a077a
    je.d8 L_004a07b0                             # 004a077c
    # block 0x004a077e: entered by fall-through of je at 0x004a077c, 11 instruction(s), ends with je to 0x004a07b0 (forward)
    mov eax, dword ptr [ebp - local_64]          # 004a077e
    mov ecx, dword ptr [ebp - local_54]          # 004a0781
    imul ecx, dword ptr [eax + field_1c]         # 004a0784
    mov edx, dword ptr [ebp - local_64]          # 004a0788
    mov eax, dword ptr [edx + field_e38]         # 004a078b
    lea ecx, [eax + 4*ecx]                       # 004a0791
    mov edx, dword ptr [ebp - local_5c]          # 004a0794
    mov eax, dword ptr [ecx + 4*edx + field_4]   # 004a0797
    and eax, 0x1000000                           # 004a079b
    test eax, eax                                # 004a07a0
    je.d8 L_004a07b0                             # 004a07a2
    # block 0x004a07a4: entered by fall-through of je at 0x004a07a2, 2 instruction(s), ends with forward jump to 0x004a0a1e
    mov dword ptr [ebp - local_40], 0x1          # 004a07a4
    jmp.d32 L_004a0a1e                           # 004a07ab
L_004a07b0:
    # block 0x004a07b0: entered by jmp at 0x004a0679; je at 0x004a06a5; jne at 0x004a06cb; jne at 0x004a06f1; more, 1 instruction(s), ends with forward jump to 0x004a0a1e
    jmp.d32 L_004a0a1e                           # 004a07b0
L_004a07b5:
    # block 0x004a07b5: entered by je at 0x004a053c, 11 instruction(s), ends with je to 0x004a08ef (forward)
    mov ecx, dword ptr [ebp - local_64]          # 004a07b5
    mov edx, dword ptr [ebp - local_14]          # 004a07b8
    imul edx, dword ptr [ecx + field_1c]         # 004a07bb
    mov eax, dword ptr [ebp - local_64]          # 004a07bf
    mov ecx, dword ptr [eax + field_e38]         # 004a07c2
    lea edx, [ecx + 4*edx]                       # 004a07c8
    mov eax, dword ptr [ebp - local_44]          # 004a07cb
    mov ecx, dword ptr [edx + 4*eax - field_minus_4] # 004a07ce
    and ecx, 0x1000000                           # 004a07d2
    test ecx, ecx                                # 004a07d8
    je.d32 L_004a08ef                            # 004a07da
    # block 0x004a07e0: entered by fall-through of je at 0x004a07da, 9 instruction(s), ends with jne to 0x004a08ef (forward)
    mov edx, dword ptr [ebp - local_64]          # 004a07e0
    mov eax, dword ptr [ebp - local_14]          # 004a07e3
    imul eax, dword ptr [edx + field_1c]         # 004a07e6
    mov ecx, dword ptr [ebp - local_64]          # 004a07ea
    mov edx, dword ptr [ecx + field_e38]         # 004a07ed
    lea eax, [edx + 4*eax]                       # 004a07f3
    mov ecx, dword ptr [ebp - local_44]          # 004a07f6
    cmp dword ptr [eax + 4*ecx - field_minus_8], 0x0 # 004a07f9
    jne.d32 L_004a08ef                           # 004a07fe
    # block 0x004a0804: entered by fall-through of jne at 0x004a07fe, 9 instruction(s), ends with jne to 0x004a08ef (forward)
    mov edx, dword ptr [ebp - local_64]          # 004a0804
    mov eax, dword ptr [ebp - local_14]          # 004a0807
    imul eax, dword ptr [edx + field_1c]         # 004a080a
    mov ecx, dword ptr [ebp - local_64]          # 004a080e
    mov edx, dword ptr [ecx + field_e38]         # 004a0811
    lea eax, [edx + 4*eax]                       # 004a0817
    mov ecx, dword ptr [ebp - local_44]          # 004a081a
    cmp dword ptr [eax + 4*ecx + field_4], 0x0   # 004a081d
    jne.d32 L_004a08ef                           # 004a0822
    # block 0x004a0828: entered by fall-through of jne at 0x004a0822, 17 instruction(s), ends with je to 0x004a08ea (forward)
    mov edx, dword ptr [ebp - local_14]          # 004a0828
    mov dword ptr [ebp - local_54], edx          # 004a082b
    mov eax, dword ptr [ebp - local_44]          # 004a082e
    sub eax, 0x1                                 # 004a0831
    mov dword ptr [ebp - local_5c], eax          # 004a0834
    mov ecx, dword ptr [ebp - local_14]          # 004a0837
    sub ecx, 0x1                                 # 004a083a
    mov edx, dword ptr [ebp - local_64]          # 004a083d
    imul ecx, dword ptr [edx + field_1c]         # 004a0840
    mov eax, dword ptr [ebp - local_64]          # 004a0844
    mov edx, dword ptr [eax + field_e38]         # 004a0847
    lea eax, [edx + 4*ecx]                       # 004a084d
    mov ecx, dword ptr [ebp - local_44]          # 004a0850
    mov edx, dword ptr [eax + 4*ecx]             # 004a0853
    and edx, 0x1000000                           # 004a0856
    test edx, edx                                # 004a085c
    je.d32 L_004a08ea                            # 004a085e
    # block 0x004a0864: entered by fall-through of je at 0x004a085e, 12 instruction(s), ends with je to 0x004a08ea (forward)
    mov eax, dword ptr [ebp - local_14]          # 004a0864
    add eax, 0x1                                 # 004a0867
    mov ecx, dword ptr [ebp - local_64]          # 004a086a
    imul eax, dword ptr [ecx + field_1c]         # 004a086d
    mov edx, dword ptr [ebp - local_64]          # 004a0871
    mov ecx, dword ptr [edx + field_e38]         # 004a0874
    lea edx, [ecx + 4*eax]                       # 004a087a
    mov eax, dword ptr [ebp - local_44]          # 004a087d
    mov ecx, dword ptr [edx + 4*eax]             # 004a0880
    and ecx, 0x1000000                           # 004a0883
    test ecx, ecx                                # 004a0889
    je.d8 L_004a08ea                             # 004a088b
    # block 0x004a088d: entered by fall-through of je at 0x004a088b, 12 instruction(s), ends with je to 0x004a08ea (forward)
    mov edx, dword ptr [ebp - local_54]          # 004a088d
    sub edx, 0x1                                 # 004a0890
    mov eax, dword ptr [ebp - local_64]          # 004a0893
    imul edx, dword ptr [eax + field_1c]         # 004a0896
    mov ecx, dword ptr [ebp - local_64]          # 004a089a
    mov eax, dword ptr [ecx + field_e38]         # 004a089d
    lea ecx, [eax + 4*edx]                       # 004a08a3
    mov edx, dword ptr [ebp - local_5c]          # 004a08a6
    mov eax, dword ptr [ecx + 4*edx]             # 004a08a9
    and eax, 0x1000000                           # 004a08ac
    test eax, eax                                # 004a08b1
    je.d8 L_004a08ea                             # 004a08b3
    # block 0x004a08b5: entered by fall-through of je at 0x004a08b3, 12 instruction(s), ends with je to 0x004a08ea (forward)
    mov ecx, dword ptr [ebp - local_54]          # 004a08b5
    add ecx, 0x1                                 # 004a08b8
    mov edx, dword ptr [ebp - local_64]          # 004a08bb
    imul ecx, dword ptr [edx + field_1c]         # 004a08be
    mov eax, dword ptr [ebp - local_64]          # 004a08c2
    mov edx, dword ptr [eax + field_e38]         # 004a08c5
    lea eax, [edx + 4*ecx]                       # 004a08cb
    mov ecx, dword ptr [ebp - local_5c]          # 004a08ce
    mov edx, dword ptr [eax + 4*ecx]             # 004a08d1
    and edx, 0x1000000                           # 004a08d4
    test edx, edx                                # 004a08da
    je.d8 L_004a08ea                             # 004a08dc
    # block 0x004a08de: entered by fall-through of je at 0x004a08dc, 2 instruction(s), ends with forward jump to 0x004a0a1e
    mov dword ptr [ebp - local_40], 0x1          # 004a08de
    jmp.d32 L_004a0a1e                           # 004a08e5
L_004a08ea:
    # block 0x004a08ea: entered by je at 0x004a085e; je at 0x004a088b; je at 0x004a08b3; je at 0x004a08dc, 1 instruction(s), ends with forward jump to 0x004a0a1e
    jmp.d32 L_004a0a1e                           # 004a08ea
L_004a08ef:
    # block 0x004a08ef: entered by je at 0x004a07da; jne at 0x004a07fe; jne at 0x004a0822, 11 instruction(s), ends with je to 0x004a0a1e (forward)
    mov eax, dword ptr [ebp - local_64]          # 004a08ef
    mov ecx, dword ptr [ebp - local_14]          # 004a08f2
    imul ecx, dword ptr [eax + field_1c]         # 004a08f5
    mov edx, dword ptr [ebp - local_64]          # 004a08f9
    mov eax, dword ptr [edx + field_e38]         # 004a08fc
    lea ecx, [eax + 4*ecx]                       # 004a0902
    mov edx, dword ptr [ebp - local_44]          # 004a0905
    mov eax, dword ptr [ecx + 4*edx + field_4]   # 004a0908
    and eax, 0x1000000                           # 004a090c
    test eax, eax                                # 004a0911
    je.d32 L_004a0a1e                            # 004a0913
    # block 0x004a0919: entered by fall-through of je at 0x004a0913, 9 instruction(s), ends with jne to 0x004a0a1e (forward)
    mov ecx, dword ptr [ebp - local_64]          # 004a0919
    mov edx, dword ptr [ebp - local_14]          # 004a091c
    imul edx, dword ptr [ecx + field_1c]         # 004a091f
    mov eax, dword ptr [ebp - local_64]          # 004a0923
    mov ecx, dword ptr [eax + field_e38]         # 004a0926
    lea edx, [ecx + 4*edx]                       # 004a092c
    mov eax, dword ptr [ebp - local_44]          # 004a092f
    cmp dword ptr [edx + 4*eax + field_8], 0x0   # 004a0932
    jne.d32 L_004a0a1e                           # 004a0937
    # block 0x004a093d: entered by fall-through of jne at 0x004a0937, 9 instruction(s), ends with jne to 0x004a0a1e (forward)
    mov ecx, dword ptr [ebp - local_64]          # 004a093d
    mov edx, dword ptr [ebp - local_14]          # 004a0940
    imul edx, dword ptr [ecx + field_1c]         # 004a0943
    mov eax, dword ptr [ebp - local_64]          # 004a0947
    mov ecx, dword ptr [eax + field_e38]         # 004a094a
    lea edx, [ecx + 4*edx]                       # 004a0950
    mov eax, dword ptr [ebp - local_44]          # 004a0953
    cmp dword ptr [edx + 4*eax - field_minus_4], 0x0 # 004a0956
    jne.d32 L_004a0a1e                           # 004a095b
    # block 0x004a0961: entered by fall-through of jne at 0x004a095b, 17 instruction(s), ends with je to 0x004a0a1e (forward)
    mov ecx, dword ptr [ebp - local_14]          # 004a0961
    mov dword ptr [ebp - local_54], ecx          # 004a0964
    mov edx, dword ptr [ebp - local_44]          # 004a0967
    add edx, 0x1                                 # 004a096a
    mov dword ptr [ebp - local_5c], edx          # 004a096d
    mov eax, dword ptr [ebp - local_14]          # 004a0970
    sub eax, 0x1                                 # 004a0973
    mov ecx, dword ptr [ebp - local_64]          # 004a0976
    imul eax, dword ptr [ecx + field_1c]         # 004a0979
    mov edx, dword ptr [ebp - local_64]          # 004a097d
    mov ecx, dword ptr [edx + field_e38]         # 004a0980
    lea edx, [ecx + 4*eax]                       # 004a0986
    mov eax, dword ptr [ebp - local_44]          # 004a0989
    mov ecx, dword ptr [edx + 4*eax]             # 004a098c
    and ecx, 0x1000000                           # 004a098f
    test ecx, ecx                                # 004a0995
    je.d32 L_004a0a1e                            # 004a0997
    # block 0x004a099d: entered by fall-through of je at 0x004a0997, 12 instruction(s), ends with je to 0x004a0a1e (forward)
    mov edx, dword ptr [ebp - local_14]          # 004a099d
    add edx, 0x1                                 # 004a09a0
    mov eax, dword ptr [ebp - local_64]          # 004a09a3
    imul edx, dword ptr [eax + field_1c]         # 004a09a6
    mov ecx, dword ptr [ebp - local_64]          # 004a09aa
    mov eax, dword ptr [ecx + field_e38]         # 004a09ad
    lea ecx, [eax + 4*edx]                       # 004a09b3
    mov edx, dword ptr [ebp - local_44]          # 004a09b6
    mov eax, dword ptr [ecx + 4*edx]             # 004a09b9
    and eax, 0x1000000                           # 004a09bc
    test eax, eax                                # 004a09c1
    je.d8 L_004a0a1e                             # 004a09c3
    # block 0x004a09c5: entered by fall-through of je at 0x004a09c3, 12 instruction(s), ends with je to 0x004a0a1e (forward)
    mov ecx, dword ptr [ebp - local_54]          # 004a09c5
    sub ecx, 0x1                                 # 004a09c8
    mov edx, dword ptr [ebp - local_64]          # 004a09cb
    imul ecx, dword ptr [edx + field_1c]         # 004a09ce
    mov eax, dword ptr [ebp - local_64]          # 004a09d2
    mov edx, dword ptr [eax + field_e38]         # 004a09d5
    lea eax, [edx + 4*ecx]                       # 004a09db
    mov ecx, dword ptr [ebp - local_5c]          # 004a09de
    mov edx, dword ptr [eax + 4*ecx]             # 004a09e1
    and edx, 0x1000000                           # 004a09e4
    test edx, edx                                # 004a09ea
    je.d8 L_004a0a1e                             # 004a09ec
    # block 0x004a09ee: entered by fall-through of je at 0x004a09ec, 12 instruction(s), ends with je to 0x004a0a1e (forward)
    mov eax, dword ptr [ebp - local_54]          # 004a09ee
    add eax, 0x1                                 # 004a09f1
    mov ecx, dword ptr [ebp - local_64]          # 004a09f4
    imul eax, dword ptr [ecx + field_1c]         # 004a09f7
    mov edx, dword ptr [ebp - local_64]          # 004a09fb
    mov ecx, dword ptr [edx + field_e38]         # 004a09fe
    lea edx, [ecx + 4*eax]                       # 004a0a04
    mov eax, dword ptr [ebp - local_5c]          # 004a0a07
    mov ecx, dword ptr [edx + 4*eax]             # 004a0a0a
    and ecx, 0x1000000                           # 004a0a0d
    test ecx, ecx                                # 004a0a13
    je.d8 L_004a0a1e                             # 004a0a15
    # block 0x004a0a17: entered by fall-through of je at 0x004a0a15, 1 instruction(s), falls into the block at 0x004a0a1e
    mov dword ptr [ebp - local_40], 0x1          # 004a0a17
L_004a0a1e:
    # block 0x004a0a1e: entered by jmp at 0x004a0542; jmp at 0x004a0674; jmp at 0x004a07ab; jmp at 0x004a07b0; more, 1 instruction(s), ends with backward jump to 0x004a048f
    jmp.d32 L_004a048f                           # 004a0a1e
L_004a0a23:
    # block 0x004a0a23: entered by jne at 0x004a0493; jmp at 0x004a04a8, 2 instruction(s), ends with je to 0x004a0ab7 (forward)
    cmp dword ptr [ebp - local_40], 0x0          # 004a0a23
    je.d32 L_004a0ab7                            # 004a0a27
    # block 0x004a0a2d: entered by fall-through of je at 0x004a0a27, 12 instruction(s), calls FUN_0050cd50, ends with jne to 0x004a0a63 (forward)
    call FUN_0050cd50                            # 004a0a2d
    cdq                                          # 004a0a32
    idiv dword ptr [ebp - local_50]              # 004a0a33
    mov dword ptr [ebp - local_60], edx          # 004a0a36
    mov edx, dword ptr [ebp - local_60]          # 004a0a39
    mov eax, dword ptr [ebp + 4*edx - local_3c]  # 004a0a3c
    mov dword ptr [ebp - local_48], eax          # 004a0a40
    mov ecx, dword ptr [ebp - local_48]          # 004a0a43
    or ecx, 0x30000000                           # 004a0a46
    mov dword ptr [ebp - local_48], ecx          # 004a0a4c
    cmp dword ptr [ebp - local_4], 0x0           # 004a0a4f
    jne.d8 L_004a0a63                            # 004a0a53
    # block 0x004a0a55: entered by fall-through of jne at 0x004a0a53, 4 instruction(s), ends with forward jump to 0x004a0a6e
    mov edx, dword ptr [ebp - local_48]          # 004a0a55
    or edx, 0x2000000                            # 004a0a58
    mov dword ptr [ebp - local_48], edx          # 004a0a5e
    jmp.d8 L_004a0a6e                            # 004a0a61
L_004a0a63:
    # block 0x004a0a63: entered by jne at 0x004a0a53, 3 instruction(s), falls into the block at 0x004a0a6e
    mov eax, dword ptr [ebp - local_48]          # 004a0a63
    or eax, 0x4000000                            # 004a0a66
    mov dword ptr [ebp - local_48], eax          # 004a0a6b
L_004a0a6e:
    # block 0x004a0a6e: entered by jmp at 0x004a0a61, 22 instruction(s), ends with forward jump to 0x004a0ab9
    mov ecx, dword ptr [ebp - local_64]          # 004a0a6e
    mov edx, dword ptr [ebp - local_14]          # 004a0a71
    imul edx, dword ptr [ecx + field_1c]         # 004a0a74
    mov eax, dword ptr [ebp - local_64]          # 004a0a78
    mov ecx, dword ptr [eax + field_e38]         # 004a0a7b
    lea edx, [ecx + 4*edx]                       # 004a0a81
    mov eax, dword ptr [ebp - local_44]          # 004a0a84
    mov ecx, dword ptr [ebp - local_48]          # 004a0a87
    mov dword ptr [edx + 4*eax], ecx             # 004a0a8a
    mov edx, dword ptr [ebp - local_64]          # 004a0a8d
    mov eax, dword ptr [ebp - local_54]          # 004a0a90
    imul eax, dword ptr [edx + field_1c]         # 004a0a93
    mov ecx, dword ptr [ebp - local_64]          # 004a0a97
    mov edx, dword ptr [ecx + field_e38]         # 004a0a9a
    lea eax, [edx + 4*eax]                       # 004a0aa0
    mov ecx, dword ptr [ebp - local_5c]          # 004a0aa3
    mov edx, dword ptr [ebp - local_48]          # 004a0aa6
    mov dword ptr [eax + 4*ecx], edx             # 004a0aa9
    mov eax, dword ptr [ebp - local_4c]          # 004a0aac
    add eax, 0x1                                 # 004a0aaf
    mov dword ptr [ebp - local_4c], eax          # 004a0ab2
    jmp.d8 L_004a0ab9                            # 004a0ab5
L_004a0ab7:
    # block 0x004a0ab7: entered by je at 0x004a0a27, 1 instruction(s), ends with forward jump to 0x004a0abe
    jmp.d8 L_004a0abe                            # 004a0ab7
L_004a0ab9:
    # block 0x004a0ab9: entered by jmp at 0x004a0ab5, 1 instruction(s), ends with backward jump to 0x004a0446
    jmp.d32 L_004a0446                           # 004a0ab9
L_004a0abe:
    # block 0x004a0abe: entered by jge at 0x004a044c; jmp at 0x004a0ab7, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 004a0abe
    pop ebp                                      # 004a0ac0
    ret 0xc                                      # 004a0ac1

