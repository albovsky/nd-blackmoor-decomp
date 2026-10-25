# FUN_0041137f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041137f
# extent:       0x0041137f-0x0041166e (751 code bytes)
# span:         0x0041137f-0x0041166e (code 751, tables 0, padding 0)
# sha256:       543f0a6228cc60dbd94f1ecc0ff90035600e5103a0d3ffe5e75893798be68123
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_autotext_43_row_object_builder
# naming:       INFERRED (lower confidence, not verified): the repository text tasks/RT-32b-autotext-43-runtime.md:7 says "builds the row object with `0x41137f`"
# name-note:    Builds the raw 0x43 AUTOTEXT row object (301-byte prefix, then the resolved or inline text).
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_2, field_12b; [ecx + n] field_2, field_12b; [edx + n] field_109, field_12b
# callees:      calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, FUN_0051dc43, FUN_0042639d, FUN_0044a2b7, FUN_00423259
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl56_unverified.c:m40b34a_lifted (function ledger class candidate_port; also m41137f_lifted; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 224 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ field_2, 0x2  # offset +0x2
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_109, 0x109  # offset +0x109
.equ field_12b, 0x12b  # offset +0x12b

# --- external targets -----------------------------------------------
.set FUN_00423259, .text + (0x00423259 - 0x401000)
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x0041137f - 0x401000
.globl FUN_0041137f
FUN_0041137f:
    # block 0x0041137f: entry, 14 instruction(s), ends with jne to 0x00411508 (forward)
    push ebp                                     # 0041137f
    {load} mov ebp, esp                          # 00411380
    sub esp, 0x18                                # 00411382
    push esi                                     # 00411385
    push edi                                     # 00411386
    mov dword ptr [ebp - local_18], ecx          # 00411387
    mov eax, dword ptr [ebp + arg_c]             # 0041138a
    mov ecx, dword ptr [eax]                     # 0041138d
    mov dword ptr [ebp - local_c], ecx           # 0041138f
    mov edx, dword ptr [ebp - local_c]           # 00411392
    {load} xor eax, eax                          # 00411395
    mov al, byte ptr [edx + field_109]           # 00411397
    test eax, eax                                # 0041139d
    jne.d32 L_00411508                           # 0041139f
    # block 0x004113a5: entered by fall-through of jne at 0x0041139f, 4 instruction(s), ends with jle to 0x004113e3 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004113a5
    movsx edx, word ptr [ecx + field_2]          # 004113a8
    cmp edx, 0x2                                 # 004113ac
    jle.d8 L_004113e3                            # 004113af
    # block 0x004113b1: entered by fall-through of jle at 0x004113af, 13 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x004113e3
    mov eax, dword ptr [ebp - local_c]           # 004113b1
    movsx ecx, word ptr [eax + field_2]          # 004113b4
    push ecx                                     # 004113b8
    push 0x54103c                                # 004113b9
    push 0x63888b                                # 004113be
    call FUN_0050ca3e                            # 004113c3
    add esp, 0xc                                 # 004113c8
    push 0x0                                     # 004113cb
    push 0x0                                     # 004113cd
    push 0x63888b                                # 004113cf
    call FUN_0052139c                            # 004113d4
    mov ecx, 0x5cf659                            # 004113d9
    call FUN_004c97b4                            # 004113de
L_004113e3:
    # block 0x004113e3: entered by jle at 0x004113af, 4 instruction(s), ends with jl to 0x00411429 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004113e3
    movsx eax, word ptr [edx + field_12b]        # 004113e6
    cmp eax, 0x9c40                              # 004113ed
    jl.d8 L_00411429                             # 004113f2
    # block 0x004113f4: entered by fall-through of jl at 0x004113f2, 13 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x00411429
    mov ecx, dword ptr [ebp - local_c]           # 004113f4
    movsx edx, word ptr [ecx + field_12b]        # 004113f7
    push edx                                     # 004113fe
    push 0x541074                                # 004113ff
    push 0x63888b                                # 00411404
    call FUN_0050ca3e                            # 00411409
    add esp, 0xc                                 # 0041140e
    push 0x0                                     # 00411411
    push 0x0                                     # 00411413
    push 0x63888b                                # 00411415
    call FUN_0052139c                            # 0041141a
    mov ecx, 0x5cf659                            # 0041141f
    call FUN_004c97b4                            # 00411424
L_00411429:
    # block 0x00411429: entered by jl at 0x004113f2, 14 instruction(s), calls FUN_0051dc43, ends with jne to 0x00411497 (forward)
    mov eax, dword ptr [ebp - local_c]           # 00411429
    movsx ecx, word ptr [eax + field_12b]        # 0041142c
    add ecx, 0x12d                               # 00411433
    mov dword ptr [ebp - local_8], ecx           # 00411439
    mov edx, dword ptr [ebp - local_8]           # 0041143c
    push edx                                     # 0041143f
    call FUN_0051dc43                            # 00411440
    add esp, 0x4                                 # 00411445
    mov dword ptr [ebp - local_10], eax          # 00411448
    mov eax, dword ptr [ebp + arg_8]             # 0041144b
    mov ecx, dword ptr [ebp - local_10]          # 0041144e
    mov dword ptr [eax], ecx                     # 00411451
    cmp dword ptr [ebp - local_10], 0x0          # 00411453
    jne.d8 L_00411497                            # 00411457
    # block 0x00411459: entered by fall-through of jne at 0x00411457, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x00411497
    movsx edx, word ptr [0x5c39e3]               # 00411459
    push edx                                     # 00411460
    mov eax, dword ptr [0x5bb57b]                # 00411461
    push eax                                     # 00411466
    push 0x5410b4                                # 00411467
    push 0x63888b                                # 0041146c
    call FUN_0050ca3e                            # 00411471
    add esp, 0x10                                # 00411476
    push 0x63888b                                # 00411479
    push 0x5410e0                                # 0041147e
    mov ecx, 0x583979                            # 00411483
    call FUN_0042639d                            # 00411488
    mov ecx, 0x5cf659                            # 0041148d
    call FUN_004c97b4                            # 00411492
L_00411497:
    # block 0x00411497: entered by jne at 0x00411457, 33 instruction(s), ends with je to 0x00411503 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00411497
    mov edx, dword ptr [ebp + arg_c]             # 0041149a
    mov esi, dword ptr [edx]                     # 0041149d
    mov eax, dword ptr [ebp + arg_8]             # 0041149f
    mov edi, dword ptr [eax]                     # 004114a2
    {load} mov edx, ecx                          # 004114a4
    shr ecx, 0x2                                 # 004114a6
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004114a9
    {load} mov ecx, edx                          # 004114ab
    and ecx, 0x3                                 # 004114ad
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004114b0
    mov eax, dword ptr [ebp + arg_10]            # 004114b2
    mov ecx, dword ptr [eax]                     # 004114b5
    add ecx, dword ptr [ebp - local_8]           # 004114b7
    mov edx, dword ptr [ebp + arg_10]            # 004114ba
    mov dword ptr [edx], ecx                     # 004114bd
    mov eax, dword ptr [ebp + arg_c]             # 004114bf
    mov ecx, dword ptr [eax]                     # 004114c2
    add ecx, dword ptr [ebp - local_8]           # 004114c4
    mov edx, dword ptr [ebp + arg_c]             # 004114c7
    mov dword ptr [edx], ecx                     # 004114ca
    mov edi, dword ptr [ebp - local_c]           # 004114cc
    add edi, 0x12d                               # 004114cf
    or ecx, -0x1                                 # 004114d5
    {load} xor eax, eax                          # 004114d8
    repne scasb al, byte ptr es:[edi]            # 004114da
    not ecx                                      # 004114dc
    add ecx, -0x1                                # 004114de
    mov eax, dword ptr [ebp - local_c]           # 004114e1
    mov word ptr [eax + field_12b], cx           # 004114e4
    movsx ecx, word ptr [0x63a4cd]               # 004114eb
    test ecx, ecx                                # 004114f2
    je.d8 L_00411503                             # 004114f4
    # block 0x004114f6: entered by fall-through of je at 0x004114f4, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00411503
    push 0x5410fc                                # 004114f6
    call FUN_0044a2b7                            # 004114fb
    add esp, 0x4                                 # 00411500
L_00411503:
    # block 0x00411503: entered by je at 0x004114f4, 1 instruction(s), ends with forward jump to 0x00411666
    jmp.d32 L_00411666                           # 00411503
L_00411508:
    # block 0x00411508: entered by jne at 0x0041139f, 9 instruction(s), calls FUN_00423259, ends with jne to 0x00411539 (forward)
    mov edx, dword ptr [ebp - local_c]           # 00411508
    add edx, 0x10a                               # 0041150b
    push edx                                     # 00411511
    mov ecx, dword ptr [ebp - local_18]          # 00411512
    add ecx, 0x2a                                # 00411515
    call FUN_00423259                            # 00411518
    mov dword ptr [ebp - local_4], eax           # 0041151d
    cmp dword ptr [ebp - local_4], 0x0           # 00411520
    jne.d8 L_00411539                            # 00411524
    # block 0x00411526: entered by fall-through of jne at 0x00411524, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x00411666
    push 0x0                                     # 00411526
    push 0x0                                     # 00411528
    push 0x541130                                # 0041152a
    call FUN_0052139c                            # 0041152f
    jmp.d32 L_00411666                           # 00411534
L_00411539:
    # block 0x00411539: entered by jne at 0x00411524, 8 instruction(s), ends with jbe to 0x0041157a (forward)
    mov edi, dword ptr [ebp - local_4]           # 00411539
    or ecx, -0x1                                 # 0041153c
    {load} xor eax, eax                          # 0041153f
    repne scasb al, byte ptr es:[edi]            # 00411541
    not ecx                                      # 00411543
    add ecx, -0x1                                # 00411545
    cmp ecx, 0x9c40                              # 00411548
    jbe.d8 L_0041157a                            # 0041154e
    # block 0x00411550: entered by fall-through of jbe at 0x0041154e, 10 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x0041157a
    push 0x54114c                                # 00411550
    push 0x63888b                                # 00411555
    call FUN_0050ca3e                            # 0041155a
    add esp, 0x8                                 # 0041155f
    push 0x0                                     # 00411562
    push 0x0                                     # 00411564
    push 0x63888b                                # 00411566
    call FUN_0052139c                            # 0041156b
    mov ecx, 0x5cf659                            # 00411570
    call FUN_004c97b4                            # 00411575
L_0041157a:
    # block 0x0041157a: entered by jbe at 0x0041154e, 17 instruction(s), calls FUN_0051dc43, ends with jne to 0x004115eb (forward)
    mov edi, dword ptr [ebp - local_4]           # 0041157a
    or ecx, -0x1                                 # 0041157d
    {load} xor eax, eax                          # 00411580
    repne scasb al, byte ptr es:[edi]            # 00411582
    not ecx                                      # 00411584
    add ecx, 0x12d                               # 00411586
    mov dword ptr [ebp - local_8], ecx           # 0041158c
    mov eax, dword ptr [ebp - local_8]           # 0041158f
    push eax                                     # 00411592
    call FUN_0051dc43                            # 00411593
    add esp, 0x4                                 # 00411598
    mov dword ptr [ebp - local_14], eax          # 0041159b
    mov ecx, dword ptr [ebp + arg_8]             # 0041159e
    mov edx, dword ptr [ebp - local_14]          # 004115a1
    mov dword ptr [ecx], edx                     # 004115a4
    cmp dword ptr [ebp - local_14], 0x0          # 004115a6
    jne.d8 L_004115eb                            # 004115aa
    # block 0x004115ac: entered by fall-through of jne at 0x004115aa, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004115eb
    movsx eax, word ptr [0x5c39e3]               # 004115ac
    push eax                                     # 004115b3
    mov ecx, dword ptr [0x5bb57b]                # 004115b4
    push ecx                                     # 004115ba
    push 0x541198                                # 004115bb
    push 0x63888b                                # 004115c0
    call FUN_0050ca3e                            # 004115c5
    add esp, 0x10                                # 004115ca
    push 0x63888b                                # 004115cd
    push 0x5411c4                                # 004115d2
    mov ecx, 0x583979                            # 004115d7
    call FUN_0042639d                            # 004115dc
    mov ecx, 0x5cf659                            # 004115e1
    call FUN_004c97b4                            # 004115e6
L_004115eb:
    # block 0x004115eb: entered by jne at 0x004115aa, 43 instruction(s), falls into the block at 0x00411666
    mov edx, dword ptr [ebp + arg_c]             # 004115eb
    mov esi, dword ptr [edx]                     # 004115ee
    mov eax, dword ptr [ebp + arg_8]             # 004115f0
    mov edi, dword ptr [eax]                     # 004115f3
    mov ecx, 0x4a                                # 004115f5
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004115fa
    movsw word ptr es:[edi], word ptr [esi]      # 004115fc
    movsb byte ptr es:[edi], byte ptr [esi]      # 004115fe
    mov ecx, dword ptr [ebp + arg_8]             # 004115ff
    mov edx, dword ptr [ecx]                     # 00411602
    mov dword ptr [ebp - local_c], edx           # 00411604
    mov edi, dword ptr [ebp - local_4]           # 00411607
    or ecx, -0x1                                 # 0041160a
    {load} xor eax, eax                          # 0041160d
    repne scasb al, byte ptr es:[edi]            # 0041160f
    not ecx                                      # 00411611
    add ecx, -0x1                                # 00411613
    mov eax, dword ptr [ebp - local_c]           # 00411616
    mov word ptr [eax + field_12b], cx           # 00411619
    mov edi, dword ptr [ebp - local_4]           # 00411620
    or ecx, -0x1                                 # 00411623
    {load} xor eax, eax                          # 00411626
    repne scasb al, byte ptr es:[edi]            # 00411628
    not ecx                                      # 0041162a
    mov esi, dword ptr [ebp - local_4]           # 0041162c
    mov edi, dword ptr [ebp - local_c]           # 0041162f
    add edi, 0x12d                               # 00411632
    {load} mov edx, ecx                          # 00411638
    shr ecx, 0x2                                 # 0041163a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041163d
    {load} mov ecx, edx                          # 0041163f
    and ecx, 0x3                                 # 00411641
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00411644
    mov eax, dword ptr [ebp + arg_10]            # 00411646
    mov ecx, dword ptr [eax]                     # 00411649
    add ecx, 0x12d                               # 0041164b
    mov edx, dword ptr [ebp + arg_10]            # 00411651
    mov dword ptr [edx], ecx                     # 00411654
    mov eax, dword ptr [ebp + arg_c]             # 00411656
    mov ecx, dword ptr [eax]                     # 00411659
    add ecx, 0x12d                               # 0041165b
    mov edx, dword ptr [ebp + arg_c]             # 00411661
    mov dword ptr [edx], ecx                     # 00411664
L_00411666:
    # block 0x00411666: entered by jmp at 0x00411503; jmp at 0x00411534, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 00411666
    pop esi                                      # 00411667
    {load} mov esp, ebp                          # 00411668
    pop ebp                                      # 0041166a
    ret 0xc                                      # 0041166b

