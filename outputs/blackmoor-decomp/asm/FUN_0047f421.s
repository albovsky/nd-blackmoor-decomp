# FUN_0047f421
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047f421
# extent:       0x0047f421-0x0047fa11 (1520 code bytes)
# span:         0x0047f421-0x0047fa11 (code 1520, tables 0, padding 0)
# sha256:       9e496459dbcdb7480059d914af9ae193f5d8b7cf3d0058410a31f0df0eabbccf
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m47f421_pointer_hit
# naming:       native port src/original_methods_fl21b.c:m47f421_pointer_hit (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m47f421_pointer_hit. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 1520 bytes.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       8 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20
# fields:       [eax + n] field_2, field_4, field_8, field_c, field_24, field_48, field_5f, field_7b4, field_7b6, field_7c2, field_a18, field_a1c and 10 more; [ecx + n] field_6, field_e, field_1e, field_4a, field_4e, field_52, field_56, field_5a, field_5e, field_e9, field_7b4, field_7b6 and 11 more; [edx + n] field_2, field_6, field_a, field_23, field_49, field_4c, field_5e, field_7a0, field_7ba, field_7be, field_a20, field_a28 and 13 more; [esi + n] field_7b6, field_7ba
# callees:      calls FUN_0047f275, FUN_0047ec06, FUN_0047fd65
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl21b.c:m47f421_pointer_hit (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 409 instruction(s), 50 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ field_e, 0xe  # offset +0xe
.equ arg_10, 0x10  # offset +0x10
.equ field_1e, 0x1e  # offset +0x1e
.equ field_23, 0x23  # offset +0x23
.equ field_24, 0x24  # offset +0x24
.equ field_48, 0x48  # offset +0x48
.equ field_49, 0x49  # offset +0x49
.equ field_4a, 0x4a  # offset +0x4a
.equ field_4c, 0x4c  # offset +0x4c
.equ field_4e, 0x4e  # offset +0x4e
.equ field_52, 0x52  # offset +0x52
.equ field_56, 0x56  # offset +0x56
.equ field_5a, 0x5a  # offset +0x5a
.equ field_5e, 0x5e  # offset +0x5e
.equ field_5f, 0x5f  # offset +0x5f
.equ field_e9, 0xe9  # offset +0xe9
.equ field_7a0, 0x7a0  # offset +0x7a0
.equ field_7b4, 0x7b4  # offset +0x7b4
.equ field_7b6, 0x7b6  # offset +0x7b6
.equ field_7ba, 0x7ba  # offset +0x7ba
.equ field_7be, 0x7be  # offset +0x7be
.equ field_7c2, 0x7c2  # offset +0x7c2
.equ field_a14, 0xa14  # offset +0xa14
.equ field_a18, 0xa18  # offset +0xa18
.equ field_a1c, 0xa1c  # offset +0xa1c
.equ field_a20, 0xa20  # offset +0xa20
.equ field_a24, 0xa24  # offset +0xa24
.equ field_a28, 0xa28  # offset +0xa28
.equ field_a2c, 0xa2c  # offset +0xa2c
.equ field_a30, 0xa30  # offset +0xa30
.equ field_1344, 0x1344  # offset +0x1344
.equ field_1350, 0x1350  # offset +0x1350
.equ field_1352, 0x1352  # offset +0x1352
.equ field_1356, 0x1356  # offset +0x1356
.equ field_135a, 0x135a  # offset +0x135a
.equ field_135e, 0x135e  # offset +0x135e
.equ field_13a2, 0x13a2  # offset +0x13a2
.equ field_13b1, 0x13b1  # offset +0x13b1
.equ field_13c5, 0x13c5  # offset +0x13c5
.equ field_13cf, 0x13cf  # offset +0x13cf
.equ field_13d3, 0x13d3  # offset +0x13d3
.equ field_13d7, 0x13d7  # offset +0x13d7
.equ field_13db, 0x13db  # offset +0x13db
.equ field_13df, 0x13df  # offset +0x13df
.equ field_13ef, 0x13ef  # offset +0x13ef
.equ field_1417, 0x1417  # offset +0x1417
.equ field_1419, 0x1419  # offset +0x1419
.equ field_1441, 0x1441  # offset +0x1441

# --- external targets -----------------------------------------------
.set FUN_0047ec06, .text + (0x0047ec06 - 0x401000)
.set FUN_0047f275, .text + (0x0047f275 - 0x401000)
.set FUN_0047fd65, .text + (0x0047fd65 - 0x401000)

.org 0x0047f421 - 0x401000
.globl FUN_0047f421
FUN_0047f421:
    # block 0x0047f421: entry, 9 instruction(s), ends with je to 0x0047fa07 (forward)
    push ebp                                     # 0047f421
    {load} mov ebp, esp                          # 0047f422
    sub esp, 0x20                                # 0047f424
    push esi                                     # 0047f427
    push edi                                     # 0047f428
    mov dword ptr [ebp - local_20], ecx          # 0047f429
    mov eax, dword ptr [ebp - local_20]          # 0047f42c
    cmp dword ptr [eax + field_13c5], 0x0        # 0047f42f
    je.d32 L_0047fa07                            # 0047f436
    # block 0x0047f43c: entered by fall-through of je at 0x0047f436, 30 instruction(s), ends with je to 0x0047f760 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 0047f43c
    movsx edx, word ptr [ecx + field_1e]         # 0047f43f
    imul edx, edx, 0x8d                          # 0047f443
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0047f449
    mov dword ptr [ebp - local_8], eax           # 0047f44f
    mov ecx, dword ptr [ebp - local_20]          # 0047f452
    movsx edx, word ptr [ecx + field_1350]       # 0047f455
    imul edx, edx, 0x25                          # 0047f45c
    mov eax, dword ptr [ebp - local_20]          # 0047f45f
    lea ecx, [eax + edx + field_7b4]             # 0047f462
    mov dword ptr [ebp - local_1c], ecx          # 0047f469
    mov edx, dword ptr [ebp - local_20]          # 0047f46c
    mov eax, dword ptr [ebp + arg_10]            # 0047f46f
    mov ecx, dword ptr [eax + field_4]           # 0047f472
    mov dword ptr [edx + field_13d3], ecx        # 0047f475
    mov edx, dword ptr [ebp - local_20]          # 0047f47b
    mov eax, dword ptr [ebp + arg_10]            # 0047f47e
    mov ecx, dword ptr [eax + field_c]           # 0047f481
    mov dword ptr [edx + field_13db], ecx        # 0047f484
    mov edx, dword ptr [ebp - local_20]          # 0047f48a
    mov eax, dword ptr [ebp + arg_10]            # 0047f48d
    mov ecx, dword ptr [eax]                     # 0047f490
    mov dword ptr [edx + field_13cf], ecx        # 0047f492
    mov edx, dword ptr [ebp - local_20]          # 0047f498
    mov eax, dword ptr [ebp + arg_10]            # 0047f49b
    mov ecx, dword ptr [eax + field_8]           # 0047f49e
    mov dword ptr [edx + field_13d7], ecx        # 0047f4a1
    mov edx, dword ptr [ebp - local_20]          # 0047f4a7
    cmp dword ptr [edx + field_1344], 0x0        # 0047f4aa
    je.d32 L_0047f760                            # 0047f4b1
    # block 0x0047f4b7: entered by fall-through of je at 0x0047f4b1, 5 instruction(s), ends with jne to 0x0047f760 (forward)
    mov eax, dword ptr [ebp - local_20]          # 0047f4b7
    {load} xor ecx, ecx                          # 0047f4ba
    mov cl, byte ptr [eax + field_13b1]          # 0047f4bc
    test ecx, ecx                                # 0047f4c2
    jne.d32 L_0047f760                           # 0047f4c4
    # block 0x0047f4ca: entered by fall-through of jne at 0x0047f4c4, 36 instruction(s), calls FUN_0047f275, ends with jle to 0x0047f588 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 0047f4ca
    call FUN_0047f275                            # 0047f4cd
    mov edx, dword ptr [ebp - local_20]          # 0047f4d2
    movsx eax, word ptr [edx + field_1350]       # 0047f4d5
    imul eax, eax, 0x25                          # 0047f4dc
    mov ecx, dword ptr [ebp - local_20]          # 0047f4df
    movsx edx, word ptr [ecx + field_1350]       # 0047f4e2
    imul edx, edx, 0x25                          # 0047f4e9
    mov ecx, dword ptr [ebp - local_20]          # 0047f4ec
    mov esi, dword ptr [ebp - local_20]          # 0047f4ef
    mov eax, dword ptr [ecx + eax + field_7c2]   # 0047f4f2
    sub eax, dword ptr [esi + edx + field_7ba]   # 0047f4f9
    cdq                                          # 0047f500
    {load} sub eax, edx                          # 0047f501
    sar eax                                      # 0047f503
    mov word ptr [ebp - local_4], ax             # 0047f505
    mov edx, dword ptr [ebp - local_20]          # 0047f509
    movsx eax, word ptr [edx + field_1350]       # 0047f50c
    imul eax, eax, 0x25                          # 0047f513
    mov ecx, dword ptr [ebp - local_20]          # 0047f516
    movsx edx, word ptr [ecx + field_1350]       # 0047f519
    imul edx, edx, 0x25                          # 0047f520
    mov ecx, dword ptr [ebp - local_20]          # 0047f523
    mov esi, dword ptr [ebp - local_20]          # 0047f526
    mov eax, dword ptr [ecx + eax + field_7be]   # 0047f529
    sub eax, dword ptr [esi + edx + field_7b6]   # 0047f530
    cdq                                          # 0047f537
    {load} sub eax, edx                          # 0047f538
    sar eax                                      # 0047f53a
    mov word ptr [ebp - local_18], ax            # 0047f53c
    movsx edx, word ptr [ebp + arg_c]            # 0047f540
    movsx eax, word ptr [ebp - local_4]          # 0047f544
    {load} sub edx, eax                          # 0047f548
    mov ecx, dword ptr [ebp - local_8]           # 0047f54a
    cmp edx, dword ptr [ecx + field_52]          # 0047f54d
    jle.d8 L_0047f588                            # 0047f550
    # block 0x0047f552: entered by fall-through of jle at 0x0047f550, 6 instruction(s), ends with jge to 0x0047f588 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0047f552
    movsx eax, word ptr [ebp - local_4]          # 0047f556
    {load} add edx, eax                          # 0047f55a
    mov ecx, dword ptr [ebp - local_8]           # 0047f55c
    cmp edx, dword ptr [ecx + field_5a]          # 0047f55f
    jge.d8 L_0047f588                            # 0047f562
    # block 0x0047f564: entered by fall-through of jge at 0x0047f562, 6 instruction(s), ends with jle to 0x0047f588 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0047f564
    movsx eax, word ptr [ebp - local_18]         # 0047f568
    {load} sub edx, eax                          # 0047f56c
    mov ecx, dword ptr [ebp - local_8]           # 0047f56e
    cmp edx, dword ptr [ecx + field_4e]          # 0047f571
    jle.d8 L_0047f588                            # 0047f574
    # block 0x0047f576: entered by fall-through of jle at 0x0047f574, 6 instruction(s), ends with jl to 0x0047f5b3 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0047f576
    movsx eax, word ptr [ebp - local_18]         # 0047f57a
    {load} add edx, eax                          # 0047f57e
    mov ecx, dword ptr [ebp - local_8]           # 0047f580
    cmp edx, dword ptr [ecx + field_56]          # 0047f583
    jl.d8 L_0047f5b3                             # 0047f586
L_0047f588:
    # block 0x0047f588: entered by jle at 0x0047f550; jge at 0x0047f562; jle at 0x0047f574; fall-through of jl at 0x0047f586, 5 instruction(s), ends with jne to 0x0047f73c (forward)
    mov edx, dword ptr [ebp - local_8]           # 0047f588
    {load} xor eax, eax                          # 0047f58b
    mov al, byte ptr [edx + field_5e]            # 0047f58d
    cmp eax, 0x1                                 # 0047f590
    jne.d32 L_0047f73c                           # 0047f593
    # block 0x0047f599: entered by fall-through of jne at 0x0047f593, 8 instruction(s), calls FUN_0047ec06, ends with je to 0x0047f73c (forward)
    mov cx, word ptr [ebp + arg_c]               # 0047f599
    push ecx                                     # 0047f59d
    mov dx, word ptr [ebp + arg_8]               # 0047f59e
    push edx                                     # 0047f5a2
    mov ecx, dword ptr [ebp - local_20]          # 0047f5a3
    call FUN_0047ec06                            # 0047f5a6
    test eax, eax                                # 0047f5ab
    je.d32 L_0047f73c                            # 0047f5ad
L_0047f5b3:
    # block 0x0047f5b3: entered by jl at 0x0047f586; fall-through of je at 0x0047f5ad, 7 instruction(s), ends with jne to 0x0047f73a (forward)
    mov eax, dword ptr [ebp - local_20]          # 0047f5b3
    mov dword ptr [eax + field_13df], 0x1        # 0047f5b6
    mov ecx, dword ptr [ebp - local_8]           # 0047f5c0
    {load} xor edx, edx                          # 0047f5c3
    mov dl, byte ptr [ecx + field_5e]            # 0047f5c5
    test edx, edx                                # 0047f5c8
    jne.d32 L_0047f73a                           # 0047f5ca
    # block 0x0047f5d0: entered by fall-through of jne at 0x0047f5ca, 5 instruction(s), ends with je to 0x0047f73a (forward)
    mov eax, dword ptr [ebp - local_8]           # 0047f5d0
    {load} xor ecx, ecx                          # 0047f5d3
    mov cl, byte ptr [eax + field_5f]            # 0047f5d5
    test ecx, ecx                                # 0047f5d8
    je.d32 L_0047f73a                            # 0047f5da
    # block 0x0047f5e0: entered by fall-through of je at 0x0047f5da, 2 instruction(s), ends with forward jump to 0x0047f5f2
    mov dword ptr [ebp - local_c], 0x0           # 0047f5e0
    jmp.d8 L_0047f5f2                            # 0047f5e7
L_0047f5e9:
    # block 0x0047f5e9: entered by jmp at 0x0047f633; jmp at 0x0047f735, 3 instruction(s), falls into the block at 0x0047f5f2
    mov edx, dword ptr [ebp - local_c]           # 0047f5e9
    add edx, 0x1                                 # 0047f5ec
    mov dword ptr [ebp - local_c], edx           # 0047f5ef
L_0047f5f2:
    # block 0x0047f5f2: entered by jmp at 0x0047f5e7, 4 instruction(s), ends with jge to 0x0047f73a (forward)
    mov eax, dword ptr [ebp - local_20]          # 0047f5f2
    movsx ecx, word ptr [eax + field_13a2]       # 0047f5f5
    cmp dword ptr [ebp - local_c], ecx           # 0047f5fc
    jge.d32 L_0047f73a                           # 0047f5ff
    # block 0x0047f605: entered by fall-through of jge at 0x0047f5ff, 7 instruction(s), ends with je to 0x0047f633 (forward)
    mov dword ptr [ebp - local_10], 0x0          # 0047f605
    mov edx, dword ptr [ebp - local_10]          # 0047f60c
    mov dword ptr [ebp - local_14], edx          # 0047f60f
    mov eax, dword ptr [ebp - local_20]          # 0047f612
    movsx ecx, word ptr [eax + field_1350]       # 0047f615
    cmp dword ptr [ebp - local_c], ecx           # 0047f61c
    je.d8 L_0047f633                             # 0047f61f
    # block 0x0047f621: entered by fall-through of je at 0x0047f61f, 6 instruction(s), ends with jne to 0x0047f635 (forward)
    mov edx, dword ptr [ebp - local_20]          # 0047f621
    add edx, dword ptr [ebp - local_c]           # 0047f624
    {load} xor eax, eax                          # 0047f627
    mov al, byte ptr [edx + field_7a0]           # 0047f629
    test eax, eax                                # 0047f62f
    jne.d8 L_0047f635                            # 0047f631
L_0047f633:
    # block 0x0047f633: entered by je at 0x0047f61f; fall-through of jne at 0x0047f631, 1 instruction(s), ends with backward jump to 0x0047f5e9
    jmp.d8 L_0047f5e9                            # 0047f633
L_0047f635:
    # block 0x0047f635: entered by jne at 0x0047f631, 7 instruction(s), ends with jge to 0x0047f677 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0047f635
    imul ecx, ecx, 0x25                          # 0047f638
    mov edx, dword ptr [ebp - local_20]          # 0047f63b
    mov eax, dword ptr [ebp - local_20]          # 0047f63e
    mov edx, dword ptr [edx + field_1352]        # 0047f641
    cmp edx, dword ptr [eax + ecx + field_7b6]   # 0047f647
    jge.d8 L_0047f677                            # 0047f64e
    # block 0x0047f650: entered by fall-through of jge at 0x0047f64e, 8 instruction(s), ends with jl to 0x0047f675 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0047f650
    imul eax, eax, 0x25                          # 0047f653
    mov ecx, dword ptr [ebp - local_20]          # 0047f656
    mov edx, dword ptr [ecx + eax + field_7b6]   # 0047f659
    add edx, 0x3                                 # 0047f660
    mov eax, dword ptr [ebp - local_20]          # 0047f663
    cmp dword ptr [eax + field_135a], edx        # 0047f666
    jl.d8 L_0047f675                             # 0047f66c
    # block 0x0047f66e: entered by fall-through of jl at 0x0047f66c, 1 instruction(s), falls into the block at 0x0047f675
    mov dword ptr [ebp - local_14], 0x1          # 0047f66e
L_0047f675:
    # block 0x0047f675: entered by jl at 0x0047f66c, 1 instruction(s), ends with forward jump to 0x0047f69c
    jmp.d8 L_0047f69c                            # 0047f675
L_0047f677:
    # block 0x0047f677: entered by jge at 0x0047f64e, 8 instruction(s), ends with jg to 0x0047f69c (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0047f677
    imul ecx, ecx, 0x25                          # 0047f67a
    mov edx, dword ptr [ebp - local_20]          # 0047f67d
    mov eax, dword ptr [edx + ecx + field_7be]   # 0047f680
    sub eax, 0x3                                 # 0047f687
    mov ecx, dword ptr [ebp - local_20]          # 0047f68a
    cmp dword ptr [ecx + field_1352], eax        # 0047f68d
    jg.d8 L_0047f69c                             # 0047f693
    # block 0x0047f695: entered by fall-through of jg at 0x0047f693, 1 instruction(s), falls into the block at 0x0047f69c
    mov dword ptr [ebp - local_14], 0x1          # 0047f695
L_0047f69c:
    # block 0x0047f69c: entered by jmp at 0x0047f675; jg at 0x0047f693, 2 instruction(s), ends with je to 0x0047f6e4 (forward)
    cmp dword ptr [ebp - local_14], 0x0          # 0047f69c
    je.d8 L_0047f6e4                             # 0047f6a0
    # block 0x0047f6a2: entered by fall-through of je at 0x0047f6a0, 7 instruction(s), ends with jge to 0x0047f6e4 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0047f6a2
    imul edx, edx, 0x25                          # 0047f6a5
    mov eax, dword ptr [ebp - local_20]          # 0047f6a8
    mov ecx, dword ptr [ebp - local_20]          # 0047f6ab
    mov eax, dword ptr [eax + field_1356]        # 0047f6ae
    cmp eax, dword ptr [ecx + edx + field_7ba]   # 0047f6b4
    jge.d8 L_0047f6e4                            # 0047f6bb
    # block 0x0047f6bd: entered by fall-through of jge at 0x0047f6bb, 8 instruction(s), ends with jl to 0x0047f6e2 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0047f6bd
    imul ecx, ecx, 0x25                          # 0047f6c0
    mov edx, dword ptr [ebp - local_20]          # 0047f6c3
    mov eax, dword ptr [edx + ecx + field_7ba]   # 0047f6c6
    add eax, 0x3                                 # 0047f6cd
    mov ecx, dword ptr [ebp - local_20]          # 0047f6d0
    cmp dword ptr [ecx + field_135e], eax        # 0047f6d3
    jl.d8 L_0047f6e2                             # 0047f6d9
    # block 0x0047f6db: entered by fall-through of jl at 0x0047f6d9, 1 instruction(s), falls into the block at 0x0047f6e2
    mov dword ptr [ebp - local_10], 0x1          # 0047f6db
L_0047f6e2:
    # block 0x0047f6e2: entered by jl at 0x0047f6d9, 1 instruction(s), ends with forward jump to 0x0047f70f
    jmp.d8 L_0047f70f                            # 0047f6e2
L_0047f6e4:
    # block 0x0047f6e4: entered by je at 0x0047f6a0; jge at 0x0047f6bb, 2 instruction(s), ends with je to 0x0047f70f (forward)
    cmp dword ptr [ebp - local_14], 0x0          # 0047f6e4
    je.d8 L_0047f70f                             # 0047f6e8
    # block 0x0047f6ea: entered by fall-through of je at 0x0047f6e8, 8 instruction(s), ends with jg to 0x0047f70f (forward)
    mov edx, dword ptr [ebp - local_c]           # 0047f6ea
    imul edx, edx, 0x25                          # 0047f6ed
    mov eax, dword ptr [ebp - local_20]          # 0047f6f0
    mov ecx, dword ptr [eax + edx + field_7c2]   # 0047f6f3
    sub ecx, 0x3                                 # 0047f6fa
    mov edx, dword ptr [ebp - local_20]          # 0047f6fd
    cmp dword ptr [edx + field_1356], ecx        # 0047f700
    jg.d8 L_0047f70f                             # 0047f706
    # block 0x0047f708: entered by fall-through of jg at 0x0047f706, 1 instruction(s), falls into the block at 0x0047f70f
    mov dword ptr [ebp - local_10], 0x1          # 0047f708
L_0047f70f:
    # block 0x0047f70f: entered by jmp at 0x0047f6e2; je at 0x0047f6e8; jg at 0x0047f706, 2 instruction(s), ends with je to 0x0047f735 (forward)
    cmp dword ptr [ebp - local_14], 0x0          # 0047f70f
    je.d8 L_0047f735                             # 0047f713
    # block 0x0047f715: entered by fall-through of je at 0x0047f713, 2 instruction(s), ends with je to 0x0047f735 (forward)
    cmp dword ptr [ebp - local_10], 0x0          # 0047f715
    je.d8 L_0047f735                             # 0047f719
    # block 0x0047f71b: entered by fall-through of je at 0x0047f719, 5 instruction(s), falls into the block at 0x0047f735
    mov eax, dword ptr [ebp - local_20]          # 0047f71b
    mov dword ptr [eax + field_13df], 0x0        # 0047f71e
    mov ecx, dword ptr [ebp - local_20]          # 0047f728
    movsx edx, word ptr [ecx + field_13a2]       # 0047f72b
    mov dword ptr [ebp - local_c], edx           # 0047f732
L_0047f735:
    # block 0x0047f735: entered by je at 0x0047f713; je at 0x0047f719, 1 instruction(s), ends with backward jump to 0x0047f5e9
    jmp.d32 L_0047f5e9                           # 0047f735
L_0047f73a:
    # block 0x0047f73a: entered by jne at 0x0047f5ca; je at 0x0047f5da; jge at 0x0047f5ff, 1 instruction(s), ends with forward jump to 0x0047f749
    jmp.d8 L_0047f749                            # 0047f73a
L_0047f73c:
    # block 0x0047f73c: entered by jne at 0x0047f593; je at 0x0047f5ad, 2 instruction(s), falls into the block at 0x0047f749
    mov eax, dword ptr [ebp - local_20]          # 0047f73c
    mov dword ptr [eax + field_13df], 0x0        # 0047f73f
L_0047f749:
    # block 0x0047f749: entered by jmp at 0x0047f73a, 5 instruction(s), calls FUN_0047fd65, ends with forward jump to 0x0047fa09
    push 0x2791                                  # 0047f749
    mov ecx, dword ptr [ebp - local_20]          # 0047f74e
    call FUN_0047fd65                            # 0047f751
    mov eax, 0x1                                 # 0047f756
    jmp.d32 L_0047fa09                           # 0047f75b
L_0047f760:
    # block 0x0047f760: entered by je at 0x0047f4b1; jne at 0x0047f4c4, 11 instruction(s), ends with forward jump to 0x0047f79c
    mov ecx, 0xa                                 # 0047f760
    {load} xor eax, eax                          # 0047f765
    mov edi, dword ptr [ebp - local_20]          # 0047f767
    add edi, 0x13ef                              # 0047f76a
    rep stosd dword ptr es:[edi], eax            # 0047f770
    mov ecx, dword ptr [ebp - local_20]          # 0047f772
    mov word ptr [ecx + field_1417], 0x0         # 0047f775
    mov edx, dword ptr [ebp - local_20]          # 0047f77e
    mov word ptr [edx + field_1441], 0x0         # 0047f781
    mov dword ptr [ebp - local_c], 0x0           # 0047f78a
    jmp.d8 L_0047f79c                            # 0047f791
L_0047f793:
    # block 0x0047f793: entered by jmp at 0x0047f918, 3 instruction(s), falls into the block at 0x0047f79c
    mov eax, dword ptr [ebp - local_c]           # 0047f793
    add eax, 0x1                                 # 0047f796
    mov dword ptr [ebp - local_c], eax           # 0047f799
L_0047f79c:
    # block 0x0047f79c: entered by jmp at 0x0047f791, 4 instruction(s), ends with jge to 0x0047f91d (forward)
    mov ecx, dword ptr [ebp - local_20]          # 0047f79c
    movsx edx, word ptr [ecx + field_13a2]       # 0047f79f
    cmp dword ptr [ebp - local_c], edx           # 0047f7a6
    jge.d32 L_0047f91d                           # 0047f7a9
    # block 0x0047f7af: entered by fall-through of jge at 0x0047f7a9, 10 instruction(s), ends with je to 0x0047f7f7 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0047f7af
    imul eax, eax, 0x25                          # 0047f7b2
    mov ecx, dword ptr [ebp - local_20]          # 0047f7b5
    lea edx, [ecx + eax + field_7b4]             # 0047f7b8
    mov dword ptr [ebp - local_1c], edx          # 0047f7bf
    mov eax, dword ptr [ebp - local_20]          # 0047f7c2
    {load} xor ecx, ecx                          # 0047f7c5
    mov cl, byte ptr [eax + field_13b1]          # 0047f7c7
    test ecx, ecx                                # 0047f7cd
    je.d8 L_0047f7f7                             # 0047f7cf
    # block 0x0047f7d1: entered by fall-through of je at 0x0047f7cf, 5 instruction(s), ends with je to 0x0047f918 (forward)
    mov edx, dword ptr [ebp - local_20]          # 0047f7d1
    {load} xor eax, eax                          # 0047f7d4
    mov al, byte ptr [edx + field_13b1]          # 0047f7d6
    test eax, eax                                # 0047f7dc
    je.d32 L_0047f918                            # 0047f7de
    # block 0x0047f7e4: entered by fall-through of je at 0x0047f7de, 4 instruction(s), ends with jne to 0x0047f918 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 0047f7e4
    movsx edx, word ptr [ecx + field_1350]       # 0047f7e7
    cmp dword ptr [ebp - local_c], edx           # 0047f7ee
    jne.d32 L_0047f918                           # 0047f7f1
L_0047f7f7:
    # block 0x0047f7f7: entered by je at 0x0047f7cf; fall-through of jne at 0x0047f7f1, 5 instruction(s), ends with je to 0x0047f822 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 0047f7f7
    {load} xor ecx, ecx                          # 0047f7fa
    mov cl, byte ptr [eax + field_24]            # 0047f7fc
    test ecx, ecx                                # 0047f7ff
    je.d8 L_0047f822                             # 0047f801
    # block 0x0047f803: entered by fall-through of je at 0x0047f801, 9 instruction(s), ends with jne to 0x0047f918 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 0047f803
    {load} xor eax, eax                          # 0047f806
    mov al, byte ptr [edx + field_23]            # 0047f808
    imul eax, eax, 0x53                          # 0047f80b
    mov ecx, dword ptr [ebp - local_8]           # 0047f80e
    {load} xor edx, edx                          # 0047f811
    mov dl, byte ptr [ecx + eax + field_e9]      # 0047f813
    test edx, edx                                # 0047f81a
    jne.d32 L_0047f918                           # 0047f81c
L_0047f822:
    # block 0x0047f822: entered by je at 0x0047f801; fall-through of jne at 0x0047f81c, 5 instruction(s), ends with je to 0x0047f8b7 (forward)
    mov eax, dword ptr [ebp - local_8]           # 0047f822
    {load} xor ecx, ecx                          # 0047f825
    mov cl, byte ptr [eax + field_48]            # 0047f827
    test ecx, ecx                                # 0047f82a
    je.d32 L_0047f8b7                            # 0047f82c
    # block 0x0047f832: entered by fall-through of je at 0x0047f82c, 5 instruction(s), ends with je to 0x0047f8b7 (forward)
    mov edx, dword ptr [ebp - local_8]           # 0047f832
    {load} xor eax, eax                          # 0047f835
    mov al, byte ptr [edx + field_49]            # 0047f837
    test eax, eax                                # 0047f83a
    je.d8 L_0047f8b7                             # 0047f83c
    # block 0x0047f83e: entered by fall-through of je at 0x0047f83c, 4 instruction(s), ends with jl to 0x0047f8b7 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0047f83e
    mov edx, dword ptr [ebp - local_1c]          # 0047f842
    cmp ecx, dword ptr [edx + field_6]           # 0047f845
    jl.d8 L_0047f8b7                             # 0047f848
    # block 0x0047f84a: entered by fall-through of jl at 0x0047f848, 8 instruction(s), ends with jg to 0x0047f8b7 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 0047f84a
    mov ecx, dword ptr [ebp - local_8]           # 0047f84e
    movsx edx, word ptr [ecx + field_4a]         # 0047f851
    mov ecx, dword ptr [ebp - local_1c]          # 0047f855
    mov ecx, dword ptr [ecx + field_6]           # 0047f858
    {load} add ecx, edx                          # 0047f85b
    {load} cmp eax, ecx                          # 0047f85d
    jg.d8 L_0047f8b7                             # 0047f85f
    # block 0x0047f861: entered by fall-through of jg at 0x0047f85f, 4 instruction(s), ends with jl to 0x0047f8b7 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0047f861
    mov eax, dword ptr [ebp - local_1c]          # 0047f865
    cmp edx, dword ptr [eax + field_2]           # 0047f868
    jl.d8 L_0047f8b7                             # 0047f86b
    # block 0x0047f86d: entered by fall-through of jl at 0x0047f86b, 8 instruction(s), ends with jg to 0x0047f8b7 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0047f86d
    mov edx, dword ptr [ebp - local_8]           # 0047f871
    movsx eax, word ptr [edx + field_4c]         # 0047f874
    mov edx, dword ptr [ebp - local_1c]          # 0047f878
    mov edx, dword ptr [edx + field_2]           # 0047f87b
    {load} add edx, eax                          # 0047f87e
    {load} cmp ecx, edx                          # 0047f880
    jg.d8 L_0047f8b7                             # 0047f882
    # block 0x0047f884: entered by fall-through of jg at 0x0047f882, 11 instruction(s), ends with forward jump to 0x0047f918
    mov eax, dword ptr [ebp - local_20]          # 0047f884
    movsx ecx, word ptr [eax + field_1441]       # 0047f887
    mov edx, dword ptr [ebp - local_20]          # 0047f88e
    mov ax, word ptr [ebp - local_c]             # 0047f891
    mov word ptr [edx + 2*ecx + field_1419], ax  # 0047f895
    mov ecx, dword ptr [ebp - local_20]          # 0047f89d
    mov dx, word ptr [ecx + field_1441]          # 0047f8a0
    add dx, 0x1                                  # 0047f8a7
    mov eax, dword ptr [ebp - local_20]          # 0047f8ab
    mov word ptr [eax + field_1441], dx          # 0047f8ae
    jmp.d8 L_0047f918                            # 0047f8b5
L_0047f8b7:
    # block 0x0047f8b7: entered by je at 0x0047f82c; je at 0x0047f83c; jl at 0x0047f848; jg at 0x0047f85f; more, 4 instruction(s), ends with jl to 0x0047f918 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0047f8b7
    mov edx, dword ptr [ebp - local_1c]          # 0047f8bb
    cmp ecx, dword ptr [edx + field_6]           # 0047f8be
    jl.d8 L_0047f918                             # 0047f8c1
    # block 0x0047f8c3: entered by fall-through of jl at 0x0047f8c1, 4 instruction(s), ends with jg to 0x0047f918 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 0047f8c3
    mov ecx, dword ptr [ebp - local_1c]          # 0047f8c7
    cmp eax, dword ptr [ecx + field_e]           # 0047f8ca
    jg.d8 L_0047f918                             # 0047f8cd
    # block 0x0047f8cf: entered by fall-through of jg at 0x0047f8cd, 4 instruction(s), ends with jl to 0x0047f918 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0047f8cf
    mov eax, dword ptr [ebp - local_1c]          # 0047f8d3
    cmp edx, dword ptr [eax + field_2]           # 0047f8d6
    jl.d8 L_0047f918                             # 0047f8d9
    # block 0x0047f8db: entered by fall-through of jl at 0x0047f8d9, 4 instruction(s), ends with jg to 0x0047f918 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0047f8db
    mov edx, dword ptr [ebp - local_1c]          # 0047f8df
    cmp ecx, dword ptr [edx + field_a]           # 0047f8e2
    jg.d8 L_0047f918                             # 0047f8e5
    # block 0x0047f8e7: entered by fall-through of jg at 0x0047f8e5, 10 instruction(s), falls into the block at 0x0047f918
    mov eax, dword ptr [ebp - local_20]          # 0047f8e7
    movsx ecx, word ptr [eax + field_1417]       # 0047f8ea
    mov edx, dword ptr [ebp - local_20]          # 0047f8f1
    mov ax, word ptr [ebp - local_c]             # 0047f8f4
    mov word ptr [edx + 2*ecx + field_13ef], ax  # 0047f8f8
    mov ecx, dword ptr [ebp - local_20]          # 0047f900
    mov dx, word ptr [ecx + field_1417]          # 0047f903
    add dx, 0x1                                  # 0047f90a
    mov eax, dword ptr [ebp - local_20]          # 0047f90e
    mov word ptr [eax + field_1417], dx          # 0047f911
L_0047f918:
    # block 0x0047f918: entered by je at 0x0047f7de; jne at 0x0047f7f1; jne at 0x0047f81c; jmp at 0x0047f8b5; more, 1 instruction(s), ends with backward jump to 0x0047f793
    jmp.d32 L_0047f793                           # 0047f918
L_0047f91d:
    # block 0x0047f91d: entered by jge at 0x0047f7a9, 4 instruction(s), ends with je to 0x0047f942 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 0047f91d
    movsx edx, word ptr [ecx + field_1441]       # 0047f920
    test edx, edx                                # 0047f927
    je.d8 L_0047f942                             # 0047f929
    # block 0x0047f92b: entered by fall-through of je at 0x0047f929, 5 instruction(s), calls FUN_0047fd65, ends with forward jump to 0x0047fa09
    push 0x278e                                  # 0047f92b
    mov ecx, dword ptr [ebp - local_20]          # 0047f930
    call FUN_0047fd65                            # 0047f933
    mov eax, 0x1                                 # 0047f938
    jmp.d32 L_0047fa09                           # 0047f93d
L_0047f942:
    # block 0x0047f942: entered by je at 0x0047f929, 4 instruction(s), ends with je to 0x0047f967 (forward)
    mov eax, dword ptr [ebp - local_20]          # 0047f942
    movsx ecx, word ptr [eax + field_1417]       # 0047f945
    test ecx, ecx                                # 0047f94c
    je.d8 L_0047f967                             # 0047f94e
    # block 0x0047f950: entered by fall-through of je at 0x0047f94e, 5 instruction(s), calls FUN_0047fd65, ends with forward jump to 0x0047fa09
    push 0x278d                                  # 0047f950
    mov ecx, dword ptr [ebp - local_20]          # 0047f955
    call FUN_0047fd65                            # 0047f958
    mov eax, 0x1                                 # 0047f95d
    jmp.d32 L_0047fa09                           # 0047f962
L_0047f967:
    # block 0x0047f967: entered by je at 0x0047f94e, 4 instruction(s), ends with jl to 0x0047f9b7 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0047f967
    mov eax, dword ptr [ebp - local_8]           # 0047f96b
    cmp edx, dword ptr [eax + field_a18]         # 0047f96e
    jl.d8 L_0047f9b7                             # 0047f974
    # block 0x0047f976: entered by fall-through of jl at 0x0047f974, 4 instruction(s), ends with jg to 0x0047f9b7 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0047f976
    mov edx, dword ptr [ebp - local_8]           # 0047f97a
    cmp ecx, dword ptr [edx + field_a20]         # 0047f97d
    jg.d8 L_0047f9b7                             # 0047f983
    # block 0x0047f985: entered by fall-through of jg at 0x0047f983, 4 instruction(s), ends with jl to 0x0047f9b7 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0047f985
    mov ecx, dword ptr [ebp - local_8]           # 0047f989
    cmp eax, dword ptr [ecx + field_a14]         # 0047f98c
    jl.d8 L_0047f9b7                             # 0047f992
    # block 0x0047f994: entered by fall-through of jl at 0x0047f992, 4 instruction(s), ends with jg to 0x0047f9b7 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0047f994
    mov eax, dword ptr [ebp - local_8]           # 0047f998
    cmp edx, dword ptr [eax + field_a1c]         # 0047f99b
    jg.d8 L_0047f9b7                             # 0047f9a1
    # block 0x0047f9a3: entered by fall-through of jg at 0x0047f9a1, 5 instruction(s), calls FUN_0047fd65, ends with forward jump to 0x0047fa09
    push 0x278f                                  # 0047f9a3
    mov ecx, dword ptr [ebp - local_20]          # 0047f9a8
    call FUN_0047fd65                            # 0047f9ab
    mov eax, 0x1                                 # 0047f9b0
    jmp.d8 L_0047fa09                            # 0047f9b5
L_0047f9b7:
    # block 0x0047f9b7: entered by jl at 0x0047f974; jg at 0x0047f983; jl at 0x0047f992; jg at 0x0047f9a1, 4 instruction(s), ends with jl to 0x0047fa07 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0047f9b7
    mov edx, dword ptr [ebp - local_8]           # 0047f9bb
    cmp ecx, dword ptr [edx + field_a28]         # 0047f9be
    jl.d8 L_0047fa07                             # 0047f9c4
    # block 0x0047f9c6: entered by fall-through of jl at 0x0047f9c4, 4 instruction(s), ends with jg to 0x0047fa07 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 0047f9c6
    mov ecx, dword ptr [ebp - local_8]           # 0047f9ca
    cmp eax, dword ptr [ecx + field_a30]         # 0047f9cd
    jg.d8 L_0047fa07                             # 0047f9d3
    # block 0x0047f9d5: entered by fall-through of jg at 0x0047f9d3, 4 instruction(s), ends with jl to 0x0047fa07 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0047f9d5
    mov eax, dword ptr [ebp - local_8]           # 0047f9d9
    cmp edx, dword ptr [eax + field_a24]         # 0047f9dc
    jl.d8 L_0047fa07                             # 0047f9e2
    # block 0x0047f9e4: entered by fall-through of jl at 0x0047f9e2, 4 instruction(s), ends with jg to 0x0047fa07 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0047f9e4
    mov edx, dword ptr [ebp - local_8]           # 0047f9e8
    cmp ecx, dword ptr [edx + field_a2c]         # 0047f9eb
    jg.d8 L_0047fa07                             # 0047f9f1
    # block 0x0047f9f3: entered by fall-through of jg at 0x0047f9f1, 5 instruction(s), calls FUN_0047fd65, ends with forward jump to 0x0047fa09
    push 0x2790                                  # 0047f9f3
    mov ecx, dword ptr [ebp - local_20]          # 0047f9f8
    call FUN_0047fd65                            # 0047f9fb
    mov eax, 0x1                                 # 0047fa00
    jmp.d8 L_0047fa09                            # 0047fa05
L_0047fa07:
    # block 0x0047fa07: entered by je at 0x0047f436; jl at 0x0047f9c4; jg at 0x0047f9d3; jl at 0x0047f9e2; jg at 0x0047f9f1, 1 instruction(s), falls into the block at 0x0047fa09
    {load} xor eax, eax                          # 0047fa07
L_0047fa09:
    # block 0x0047fa09: entered by jmp at 0x0047f75b; jmp at 0x0047f93d; jmp at 0x0047f962; jmp at 0x0047f9b5; more, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 0047fa09
    pop esi                                      # 0047fa0a
    {load} mov esp, ebp                          # 0047fa0b
    pop ebp                                      # 0047fa0d
    ret 0xc                                      # 0047fa0e

