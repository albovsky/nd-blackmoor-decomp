# FUN_004a835c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a835c
# extent:       0x004a835c-0x004a8697 (827 code bytes)
# span:         0x004a835c-0x004a8697 (code 827, tables 0, padding 0)
# sha256:       f5b0c1945a046602a9fe24a9067617173768e41e88bd9bd1dc24b59eff78b870
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a835c
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_446, field_e5e, field_e72, field_e84, field_e88, field_e8c, field_e90, field_e94; [ecx + n] field_4, field_8, field_c, field_1e, field_43e, field_442, field_e7a; [edx + n] field_4, field_8, field_c, field_43, field_45, field_43a, field_e7c
# callees:      calls FUN_004a8007, FUN_004a8697
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 207 instruction(s), 18 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1e, 0x1e  # offset +0x1e
.equ field_43, 0x43  # offset +0x43
.equ field_45, 0x45  # offset +0x45
.equ field_43a, 0x43a  # offset +0x43a
.equ field_43e, 0x43e  # offset +0x43e
.equ field_442, 0x442  # offset +0x442
.equ field_446, 0x446  # offset +0x446
.equ field_e5e, 0xe5e  # offset +0xe5e
.equ field_e72, 0xe72  # offset +0xe72
.equ field_e7a, 0xe7a  # offset +0xe7a
.equ field_e7c, 0xe7c  # offset +0xe7c
.equ field_e84, 0xe84  # offset +0xe84
.equ field_e88, 0xe88  # offset +0xe88
.equ field_e8c, 0xe8c  # offset +0xe8c
.equ field_e90, 0xe90  # offset +0xe90
.equ field_e94, 0xe94  # offset +0xe94

# --- external targets -----------------------------------------------
.set FUN_004a8007, .text + (0x004a8007 - 0x401000)
.set FUN_004a8697, .text + (0x004a8697 - 0x401000)

.org 0x004a835c - 0x401000
.globl FUN_004a835c
FUN_004a835c:
    # block 0x004a835c: entry, 7 instruction(s), ends with je to 0x004a868f (forward)
    push ebp                                     # 004a835c
    {load} mov ebp, esp                          # 004a835d
    sub esp, 0x10                                # 004a835f
    mov dword ptr [ebp - local_10], ecx          # 004a8362
    mov eax, dword ptr [ebp - local_10]          # 004a8365
    cmp dword ptr [eax + field_e72], 0x0         # 004a8368
    je.d32 L_004a868f                            # 004a836f
    # block 0x004a8375: entered by fall-through of je at 0x004a836f, 28 instruction(s), ends with je to 0x004a8542 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004a8375
    movsx edx, word ptr [ecx + field_1e]         # 004a8378
    imul edx, edx, 0x8d                          # 004a837c
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004a8382
    mov dword ptr [ebp - local_c], eax           # 004a8388
    mov ecx, dword ptr [ebp - local_10]          # 004a838b
    mov word ptr [ecx + field_e7a], 0xffff       # 004a838e
    mov edx, dword ptr [ebp - local_10]          # 004a8397
    mov word ptr [edx + field_e7c], 0xffff       # 004a839a
    mov eax, dword ptr [ebp - local_10]          # 004a83a3
    mov ecx, dword ptr [ebp + arg_10]            # 004a83a6
    mov edx, dword ptr [ecx + field_4]           # 004a83a9
    mov dword ptr [eax + field_e88], edx         # 004a83ac
    mov eax, dword ptr [ebp - local_10]          # 004a83b2
    mov ecx, dword ptr [ebp + arg_10]            # 004a83b5
    mov edx, dword ptr [ecx + field_c]           # 004a83b8
    mov dword ptr [eax + field_e90], edx         # 004a83bb
    mov eax, dword ptr [ebp - local_10]          # 004a83c1
    mov ecx, dword ptr [ebp + arg_10]            # 004a83c4
    mov edx, dword ptr [ecx]                     # 004a83c7
    mov dword ptr [eax + field_e84], edx         # 004a83c9
    mov eax, dword ptr [ebp - local_10]          # 004a83cf
    mov ecx, dword ptr [ebp + arg_10]            # 004a83d2
    mov edx, dword ptr [ecx + field_8]           # 004a83d5
    mov dword ptr [eax + field_e8c], edx         # 004a83d8
    mov eax, dword ptr [ebp - local_10]          # 004a83de
    cmp dword ptr [eax + field_e5e], 0x0         # 004a83e1
    je.d32 L_004a8542                            # 004a83e8
    # block 0x004a83ee: entered by fall-through of je at 0x004a83e8, 4 instruction(s), calls FUN_004a8007, ends with forward jump to 0x004a8408
    mov ecx, dword ptr [ebp - local_10]          # 004a83ee
    call FUN_004a8007                            # 004a83f1
    mov dword ptr [ebp - local_4], 0x0           # 004a83f6
    jmp.d8 L_004a8408                            # 004a83fd
L_004a83ff:
    # block 0x004a83ff: entered by jmp at 0x004a84ed, 3 instruction(s), falls into the block at 0x004a8408
    mov ecx, dword ptr [ebp - local_4]           # 004a83ff
    add ecx, 0x1                                 # 004a8402
    mov dword ptr [ebp - local_4], ecx           # 004a8405
L_004a8408:
    # block 0x004a8408: entered by jmp at 0x004a83fd, 4 instruction(s), ends with jge to 0x004a84f2 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004a8408
    movsx eax, word ptr [edx + field_43]         # 004a840b
    cmp dword ptr [ebp - local_4], eax           # 004a840f
    jge.d32 L_004a84f2                           # 004a8412
    # block 0x004a8418: entered by fall-through of jge at 0x004a8412, 2 instruction(s), ends with forward jump to 0x004a842a
    mov dword ptr [ebp - local_8], 0x0           # 004a8418
    jmp.d8 L_004a842a                            # 004a841f
L_004a8421:
    # block 0x004a8421: entered by jmp at 0x004a84e8, 3 instruction(s), falls into the block at 0x004a842a
    mov ecx, dword ptr [ebp - local_8]           # 004a8421
    add ecx, 0x1                                 # 004a8424
    mov dword ptr [ebp - local_8], ecx           # 004a8427
L_004a842a:
    # block 0x004a842a: entered by jmp at 0x004a841f, 4 instruction(s), ends with jge to 0x004a84ed (forward)
    mov edx, dword ptr [ebp - local_c]           # 004a842a
    movsx eax, word ptr [edx + field_45]         # 004a842d
    cmp dword ptr [ebp - local_8], eax           # 004a8431
    jge.d32 L_004a84ed                           # 004a8434
    # block 0x004a843a: entered by fall-through of jge at 0x004a8434, 9 instruction(s), ends with jl to 0x004a84e8 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004a843a
    mov edx, dword ptr [ebp - local_4]           # 004a843e
    imul edx, edx, 0x90                          # 004a8441
    mov eax, dword ptr [ebp - local_10]          # 004a8447
    lea edx, [eax + edx + field_e94]             # 004a844a
    mov eax, dword ptr [ebp - local_8]           # 004a8451
    shl eax, 0x4                                 # 004a8454
    cmp ecx, dword ptr [edx + eax + field_4]     # 004a8457
    jl.d32 L_004a84e8                            # 004a845b
    # block 0x004a8461: entered by fall-through of jl at 0x004a845b, 9 instruction(s), ends with jg to 0x004a84e8 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004a8461
    mov edx, dword ptr [ebp - local_4]           # 004a8465
    imul edx, edx, 0x90                          # 004a8468
    mov eax, dword ptr [ebp - local_10]          # 004a846e
    lea edx, [eax + edx + field_e94]             # 004a8471
    mov eax, dword ptr [ebp - local_8]           # 004a8478
    shl eax, 0x4                                 # 004a847b
    cmp ecx, dword ptr [edx + eax + field_c]     # 004a847e
    jg.d8 L_004a84e8                             # 004a8482
    # block 0x004a8484: entered by fall-through of jg at 0x004a8482, 9 instruction(s), ends with jl to 0x004a84e8 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004a8484
    mov edx, dword ptr [ebp - local_4]           # 004a8488
    imul edx, edx, 0x90                          # 004a848b
    mov eax, dword ptr [ebp - local_10]          # 004a8491
    lea edx, [eax + edx + field_e94]             # 004a8494
    mov eax, dword ptr [ebp - local_8]           # 004a849b
    shl eax, 0x4                                 # 004a849e
    cmp ecx, dword ptr [edx + eax]               # 004a84a1
    jl.d8 L_004a84e8                             # 004a84a4
    # block 0x004a84a6: entered by fall-through of jl at 0x004a84a4, 9 instruction(s), ends with jg to 0x004a84e8 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004a84a6
    mov edx, dword ptr [ebp - local_4]           # 004a84aa
    imul edx, edx, 0x90                          # 004a84ad
    mov eax, dword ptr [ebp - local_10]          # 004a84b3
    lea edx, [eax + edx + field_e94]             # 004a84b6
    mov eax, dword ptr [ebp - local_8]           # 004a84bd
    shl eax, 0x4                                 # 004a84c0
    cmp ecx, dword ptr [edx + eax + field_8]     # 004a84c3
    jg.d8 L_004a84e8                             # 004a84c7
    # block 0x004a84c9: entered by fall-through of jg at 0x004a84c7, 9 instruction(s), calls FUN_004a8697, ends with forward jump to 0x004a8691
    mov ecx, dword ptr [ebp - local_8]           # 004a84c9
    push ecx                                     # 004a84cc
    mov edx, dword ptr [ebp - local_4]           # 004a84cd
    push edx                                     # 004a84d0
    push 0x2799                                  # 004a84d1
    mov ecx, dword ptr [ebp - local_10]          # 004a84d6
    call FUN_004a8697                            # 004a84d9
    mov eax, 0x1                                 # 004a84de
    jmp.d32 L_004a8691                           # 004a84e3
L_004a84e8:
    # block 0x004a84e8: entered by jl at 0x004a845b; jg at 0x004a8482; jl at 0x004a84a4; jg at 0x004a84c7, 1 instruction(s), ends with backward jump to 0x004a8421
    jmp.d32 L_004a8421                           # 004a84e8
L_004a84ed:
    # block 0x004a84ed: entered by jge at 0x004a8434, 1 instruction(s), ends with backward jump to 0x004a83ff
    jmp.d32 L_004a83ff                           # 004a84ed
L_004a84f2:
    # block 0x004a84f2: entered by jge at 0x004a8412, 13 instruction(s), ends with forward jump to 0x004a8691
    mov dword ptr [0x5b44f0], 0x24               # 004a84f2
    mov dword ptr [0x5b44f4], 0x0                # 004a84fc
    mov eax, dword ptr [0x5d0377]                # 004a8506
    mov dword ptr [0x5d162d], eax                # 004a850b
    mov ecx, dword ptr [0x5b44f0]                # 004a8510
    shl ecx, 0x5                                 # 004a8516
    mov edx, dword ptr [0x5b44f4]                # 004a8519
    shl edx, 0x4                                 # 004a851f
    lea eax, [ecx + edx + 0x5b160c]              # 004a8522
    mov dword ptr [0x5d1631], eax                # 004a8529
    mov dword ptr [0x5d1639], 0x1                # 004a852e
    mov eax, 0x1                                 # 004a8538
    jmp.d32 L_004a8691                           # 004a853d
L_004a8542:
    # block 0x004a8542: entered by je at 0x004a83e8, 2 instruction(s), ends with forward jump to 0x004a8554
    mov dword ptr [ebp - local_4], 0x0           # 004a8542
    jmp.d8 L_004a8554                            # 004a8549
L_004a854b:
    # block 0x004a854b: entered by jmp at 0x004a8636, 3 instruction(s), falls into the block at 0x004a8554
    mov ecx, dword ptr [ebp - local_4]           # 004a854b
    add ecx, 0x1                                 # 004a854e
    mov dword ptr [ebp - local_4], ecx           # 004a8551
L_004a8554:
    # block 0x004a8554: entered by jmp at 0x004a8549, 4 instruction(s), ends with jge to 0x004a863b (forward)
    mov edx, dword ptr [ebp - local_c]           # 004a8554
    movsx eax, word ptr [edx + field_43]         # 004a8557
    cmp dword ptr [ebp - local_4], eax           # 004a855b
    jge.d32 L_004a863b                           # 004a855e
    # block 0x004a8564: entered by fall-through of jge at 0x004a855e, 2 instruction(s), ends with forward jump to 0x004a8576
    mov dword ptr [ebp - local_8], 0x0           # 004a8564
    jmp.d8 L_004a8576                            # 004a856b
L_004a856d:
    # block 0x004a856d: entered by jmp at 0x004a8631, 3 instruction(s), falls into the block at 0x004a8576
    mov ecx, dword ptr [ebp - local_8]           # 004a856d
    add ecx, 0x1                                 # 004a8570
    mov dword ptr [ebp - local_8], ecx           # 004a8573
L_004a8576:
    # block 0x004a8576: entered by jmp at 0x004a856b, 4 instruction(s), ends with jge to 0x004a8636 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004a8576
    movsx eax, word ptr [edx + field_45]         # 004a8579
    cmp dword ptr [ebp - local_8], eax           # 004a857d
    jge.d32 L_004a8636                           # 004a8580
    # block 0x004a8586: entered by fall-through of jge at 0x004a8580, 9 instruction(s), ends with jl to 0x004a8631 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004a8586
    mov edx, dword ptr [ebp - local_4]           # 004a858a
    imul edx, edx, 0x90                          # 004a858d
    mov eax, dword ptr [ebp - local_10]          # 004a8593
    lea edx, [eax + edx + field_e94]             # 004a8596
    mov eax, dword ptr [ebp - local_8]           # 004a859d
    shl eax, 0x4                                 # 004a85a0
    cmp ecx, dword ptr [edx + eax + field_4]     # 004a85a3
    jl.d32 L_004a8631                            # 004a85a7
    # block 0x004a85ad: entered by fall-through of jl at 0x004a85a7, 9 instruction(s), ends with jg to 0x004a8631 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004a85ad
    mov edx, dword ptr [ebp - local_4]           # 004a85b1
    imul edx, edx, 0x90                          # 004a85b4
    mov eax, dword ptr [ebp - local_10]          # 004a85ba
    lea edx, [eax + edx + field_e94]             # 004a85bd
    mov eax, dword ptr [ebp - local_8]           # 004a85c4
    shl eax, 0x4                                 # 004a85c7
    cmp ecx, dword ptr [edx + eax + field_c]     # 004a85ca
    jg.d8 L_004a8631                             # 004a85ce
    # block 0x004a85d0: entered by fall-through of jg at 0x004a85ce, 9 instruction(s), ends with jl to 0x004a8631 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004a85d0
    mov edx, dword ptr [ebp - local_4]           # 004a85d4
    imul edx, edx, 0x90                          # 004a85d7
    mov eax, dword ptr [ebp - local_10]          # 004a85dd
    lea edx, [eax + edx + field_e94]             # 004a85e0
    mov eax, dword ptr [ebp - local_8]           # 004a85e7
    shl eax, 0x4                                 # 004a85ea
    cmp ecx, dword ptr [edx + eax]               # 004a85ed
    jl.d8 L_004a8631                             # 004a85f0
    # block 0x004a85f2: entered by fall-through of jl at 0x004a85f0, 9 instruction(s), ends with jg to 0x004a8631 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004a85f2
    mov edx, dword ptr [ebp - local_4]           # 004a85f6
    imul edx, edx, 0x90                          # 004a85f9
    mov eax, dword ptr [ebp - local_10]          # 004a85ff
    lea edx, [eax + edx + field_e94]             # 004a8602
    mov eax, dword ptr [ebp - local_8]           # 004a8609
    shl eax, 0x4                                 # 004a860c
    cmp ecx, dword ptr [edx + eax + field_8]     # 004a860f
    jg.d8 L_004a8631                             # 004a8613
    # block 0x004a8615: entered by fall-through of jg at 0x004a8613, 9 instruction(s), calls FUN_004a8697, ends with forward jump to 0x004a8691
    mov ecx, dword ptr [ebp - local_8]           # 004a8615
    push ecx                                     # 004a8618
    mov edx, dword ptr [ebp - local_4]           # 004a8619
    push edx                                     # 004a861c
    push 0x2798                                  # 004a861d
    mov ecx, dword ptr [ebp - local_10]          # 004a8622
    call FUN_004a8697                            # 004a8625
    mov eax, 0x1                                 # 004a862a
    jmp.d8 L_004a8691                            # 004a862f
L_004a8631:
    # block 0x004a8631: entered by jl at 0x004a85a7; jg at 0x004a85ce; jl at 0x004a85f0; jg at 0x004a8613, 1 instruction(s), ends with backward jump to 0x004a856d
    jmp.d32 L_004a856d                           # 004a8631
L_004a8636:
    # block 0x004a8636: entered by jge at 0x004a8580, 1 instruction(s), ends with backward jump to 0x004a854b
    jmp.d32 L_004a854b                           # 004a8636
L_004a863b:
    # block 0x004a863b: entered by jge at 0x004a855e, 4 instruction(s), ends with jl to 0x004a868f (forward)
    movsx eax, word ptr [ebp + arg_c]            # 004a863b
    mov ecx, dword ptr [ebp - local_c]           # 004a863f
    cmp eax, dword ptr [ecx + field_43e]         # 004a8642
    jl.d8 L_004a868f                             # 004a8648
    # block 0x004a864a: entered by fall-through of jl at 0x004a8648, 4 instruction(s), ends with jg to 0x004a868f (forward)
    movsx edx, word ptr [ebp + arg_c]            # 004a864a
    mov eax, dword ptr [ebp - local_c]           # 004a864e
    cmp edx, dword ptr [eax + field_446]         # 004a8651
    jg.d8 L_004a868f                             # 004a8657
    # block 0x004a8659: entered by fall-through of jg at 0x004a8657, 4 instruction(s), ends with jl to 0x004a868f (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004a8659
    mov edx, dword ptr [ebp - local_c]           # 004a865d
    cmp ecx, dword ptr [edx + field_43a]         # 004a8660
    jl.d8 L_004a868f                             # 004a8666
    # block 0x004a8668: entered by fall-through of jl at 0x004a8666, 4 instruction(s), ends with jg to 0x004a868f (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004a8668
    mov ecx, dword ptr [ebp - local_c]           # 004a866c
    cmp eax, dword ptr [ecx + field_442]         # 004a866f
    jg.d8 L_004a868f                             # 004a8675
    # block 0x004a8677: entered by fall-through of jg at 0x004a8675, 7 instruction(s), calls FUN_004a8697, ends with forward jump to 0x004a8691
    push 0x0                                     # 004a8677
    push 0x0                                     # 004a8679
    push 0x279a                                  # 004a867b
    mov ecx, dword ptr [ebp - local_10]          # 004a8680
    call FUN_004a8697                            # 004a8683
    mov eax, 0x1                                 # 004a8688
    jmp.d8 L_004a8691                            # 004a868d
L_004a868f:
    # block 0x004a868f: entered by je at 0x004a836f; jl at 0x004a8648; jg at 0x004a8657; jl at 0x004a8666; jg at 0x004a8675, 1 instruction(s), falls into the block at 0x004a8691
    {load} xor eax, eax                          # 004a868f
L_004a8691:
    # block 0x004a8691: entered by jmp at 0x004a84e3; jmp at 0x004a853d; jmp at 0x004a862f; jmp at 0x004a868d, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 004a8691
    pop ebp                                      # 004a8693
    ret 0xc                                      # 004a8694

