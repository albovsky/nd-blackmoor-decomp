# FUN_0044b3c8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044b3c8
# extent:       0x0044b3c8-0x0044b641 (633 code bytes)
# span:         0x0044b3c8-0x0044b641 (code 633, tables 0, padding 0)
# sha256:       bbb8faa8936805077289b618d4b353bc146088a9561d75b6a3dd45994f388152
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44b3c8_sum_kinds
# naming:       native port src/original_methods_fl30a.c:m44b3c8_sum_kinds (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Sums up to ten (kind, value) triples into the float cells at 0x58c91d in 53-bit x87 order (divide then multiply), re-reads the kind byte; all instructions run, one jump direction allowlisted.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       11 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c
# fields:       [eax + n] field_1, field_2; [ecx + n] field_1, field_2; [edx + n] field_1
# callees:      calls FUN_0050ca3e, FUN_0052139c, FUN_0042ba3a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl30a.c:m44b3c8_sum_kinds (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 181 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ field_1, 0x1  # offset +0x1
.equ field_2, 0x2  # offset +0x2
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x0044b3c8 - 0x401000
.globl FUN_0044b3c8
FUN_0044b3c8:
    # block 0x0044b3c8: entry, 13 instruction(s), ends with jl to 0x0044b3fc (forward)
    push ebp                                     # 0044b3c8
    {load} mov ebp, esp                          # 0044b3c9
    sub esp, 0x2c                                # 0044b3cb
    mov dword ptr [ebp - local_10], ecx          # 0044b3ce
    movsx eax, word ptr [ebp + arg_8]            # 0044b3d1
    imul eax, eax, 0x8d                          # 0044b3d5
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0044b3db
    mov dword ptr [ebp - local_c], ecx           # 0044b3e1
    mov edx, dword ptr [ebp - local_c]           # 0044b3e4
    {load} xor eax, eax                          # 0044b3e7
    mov al, byte ptr [edx]                       # 0044b3e9
    cmp eax, 0x1e                                # 0044b3eb
    jl.d8 L_0044b3fc                             # 0044b3ee
    # block 0x0044b3f0: entered by fall-through of jl at 0x0044b3ee, 5 instruction(s), ends with jle to 0x0044b434 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0044b3f0
    {load} xor edx, edx                          # 0044b3f3
    mov dl, byte ptr [ecx]                       # 0044b3f5
    cmp edx, 0x27                                # 0044b3f7
    jle.d8 L_0044b434                            # 0044b3fa
L_0044b3fc:
    # block 0x0044b3fc: entered by jl at 0x0044b3ee; fall-through of jle at 0x0044b3fa, 3 instruction(s), ends with je to 0x0044b42f (forward)
    movsx eax, word ptr [0x63a4cd]               # 0044b3fc
    test eax, eax                                # 0044b403
    je.d8 L_0044b42f                             # 0044b405
    # block 0x0044b407: entered by fall-through of je at 0x0044b405, 12 instruction(s), calls FUN_0050ca3e, FUN_0052139c, falls into the block at 0x0044b42f
    mov ecx, dword ptr [ebp - local_c]           # 0044b407
    {load} xor edx, edx                          # 0044b40a
    mov dl, byte ptr [ecx]                       # 0044b40c
    push edx                                     # 0044b40e
    push 0x549054                                # 0044b40f
    push 0x63888b                                # 0044b414
    call FUN_0050ca3e                            # 0044b419
    add esp, 0xc                                 # 0044b41e
    push 0x0                                     # 0044b421
    push 0x0                                     # 0044b423
    push 0x63888b                                # 0044b425
    call FUN_0052139c                            # 0044b42a
L_0044b42f:
    # block 0x0044b42f: entered by je at 0x0044b405, 1 instruction(s), ends with forward jump to 0x0044b62e
    jmp.d32 L_0044b62e                           # 0044b42f
L_0044b434:
    # block 0x0044b434: entered by jle at 0x0044b3fa, 6 instruction(s), ends with forward jump to 0x0044b45a
    mov eax, dword ptr [ebp - local_c]           # 0044b434
    {load} xor ecx, ecx                          # 0044b437
    mov cl, byte ptr [eax]                       # 0044b439
    mov dword ptr [4*ecx + 0x58c91d], 0x0        # 0044b43b
    mov word ptr [ebp - local_8], 0x0            # 0044b446
    jmp.d8 L_0044b45a                            # 0044b44c
L_0044b44e:
    # block 0x0044b44e: entered by jmp at 0x0044b629, 3 instruction(s), falls into the block at 0x0044b45a
    mov dx, word ptr [ebp - local_8]             # 0044b44e
    add dx, 0x1                                  # 0044b452
    mov word ptr [ebp - local_8], dx             # 0044b456
L_0044b45a:
    # block 0x0044b45a: entered by jmp at 0x0044b44c, 3 instruction(s), ends with jge to 0x0044b62e (forward)
    movsx eax, word ptr [ebp - local_8]          # 0044b45a
    cmp eax, 0xa                                 # 0044b45e
    jge.d32 L_0044b62e                           # 0044b461
    # block 0x0044b467: entered by fall-through of jge at 0x0044b461, 7 instruction(s), ends with je to 0x0044b629 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 0044b467
    imul ecx, ecx, 0x3                           # 0044b46b
    mov edx, dword ptr [ebp - local_c]           # 0044b46e
    {load} xor eax, eax                          # 0044b471
    mov al, byte ptr [edx + ecx + field_1]       # 0044b473
    cmp eax, 0x63                                # 0044b477
    je.d32 L_0044b629                            # 0044b47a
    # block 0x0044b480: entered by fall-through of je at 0x0044b47a, 7 instruction(s), ends with jl to 0x0044b5a3 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 0044b480
    imul ecx, ecx, 0x3                           # 0044b484
    mov edx, dword ptr [ebp - local_c]           # 0044b487
    {load} xor eax, eax                          # 0044b48a
    mov al, byte ptr [edx + ecx + field_1]       # 0044b48c
    test eax, eax                                # 0044b490
    jl.d32 L_0044b5a3                            # 0044b492
    # block 0x0044b498: entered by fall-through of jl at 0x0044b492, 7 instruction(s), ends with jg to 0x0044b5a3 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 0044b498
    imul ecx, ecx, 0x3                           # 0044b49c
    mov edx, dword ptr [ebp - local_c]           # 0044b49f
    {load} xor eax, eax                          # 0044b4a2
    mov al, byte ptr [edx + ecx + field_1]       # 0044b4a4
    cmp eax, 0x27                                # 0044b4a8
    jg.d32 L_0044b5a3                            # 0044b4ab
    # block 0x0044b4b1: entered by fall-through of jg at 0x0044b4ab, 7 instruction(s), ends with jg to 0x0044b539 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 0044b4b1
    imul ecx, ecx, 0x3                           # 0044b4b5
    mov edx, dword ptr [ebp - local_c]           # 0044b4b8
    {load} xor eax, eax                          # 0044b4bb
    mov al, byte ptr [edx + ecx + field_1]       # 0044b4bd
    cmp eax, 0x1d                                # 0044b4c1
    jg.d8 L_0044b539                             # 0044b4c4
    # block 0x0044b4c6: entered by fall-through of jg at 0x0044b4c4, 8 instruction(s), ends with jne to 0x0044b4ef (forward)
    movsx ecx, word ptr [ebp - local_8]          # 0044b4c6
    imul ecx, ecx, 0x3                           # 0044b4ca
    mov edx, dword ptr [ebp - local_c]           # 0044b4cd
    {load} xor eax, eax                          # 0044b4d0
    mov al, byte ptr [edx + ecx + field_1]       # 0044b4d2
    movsx ecx, word ptr [2*eax + 0x58c959]       # 0044b4d6
    cmp ecx, 0x270f                              # 0044b4de
    jne.d8 L_0044b4ef                            # 0044b4e4
    # block 0x0044b4e6: entered by fall-through of jne at 0x0044b4e4, 2 instruction(s), ends with forward jump to 0x0044b537
    mov dword ptr [ebp - local_4], 0x0           # 0044b4e6
    jmp.d8 L_0044b537                            # 0044b4ed
L_0044b4ef:
    # block 0x0044b4ef: entered by jne at 0x0044b4e4, 20 instruction(s), falls into the block at 0x0044b537
    movsx edx, word ptr [ebp - local_8]          # 0044b4ef
    imul edx, edx, 0x3                           # 0044b4f3
    mov eax, dword ptr [ebp - local_c]           # 0044b4f6
    movsx ecx, word ptr [eax + edx + field_2]    # 0044b4f9
    mov dword ptr [ebp - local_14], ecx          # 0044b4fe
    fild dword ptr [ebp - local_14]              # 0044b501
    fstp dword ptr [ebp - local_18]              # 0044b504
    fld dword ptr [ebp - local_18]               # 0044b507
    fdiv dword ptr [0x52cbec]                    # 0044b50a
    movsx edx, word ptr [ebp - local_8]          # 0044b510
    imul edx, edx, 0x3                           # 0044b514
    mov eax, dword ptr [ebp - local_c]           # 0044b517
    {load} xor ecx, ecx                          # 0044b51a
    mov cl, byte ptr [eax + edx + field_1]       # 0044b51c
    movsx edx, word ptr [2*ecx + 0x58c959]       # 0044b520
    mov dword ptr [ebp - local_1c], edx          # 0044b528
    fild dword ptr [ebp - local_1c]              # 0044b52b
    fstp dword ptr [ebp - local_20]              # 0044b52e
    fmul dword ptr [ebp - local_20]              # 0044b531
    fstp dword ptr [ebp - local_4]               # 0044b534
L_0044b537:
    # block 0x0044b537: entered by jmp at 0x0044b4ed, 1 instruction(s), ends with forward jump to 0x0044b5a1
    jmp.d8 L_0044b5a1                            # 0044b537
L_0044b539:
    # block 0x0044b539: entered by jg at 0x0044b4c4, 10 instruction(s), ends with je to 0x0044b566 (forward)
    movsx eax, word ptr [ebp - local_8]          # 0044b539
    imul eax, eax, 0x3                           # 0044b53d
    mov ecx, dword ptr [ebp - local_c]           # 0044b540
    {load} xor edx, edx                          # 0044b543
    mov dl, byte ptr [ecx + eax + field_1]       # 0044b545
    fld dword ptr [4*edx + 0x58c91d]             # 0044b549
    fcomp dword ptr [0x52cbe8]                   # 0044b550
    fnstsw ax                                    # 0044b556
    test ah, 0x40                                # 0044b558
    je.d8 L_0044b566                             # 0044b55b
    # block 0x0044b55d: entered by fall-through of je at 0x0044b55b, 2 instruction(s), ends with forward jump to 0x0044b5a1
    mov dword ptr [ebp - local_4], 0x0           # 0044b55d
    jmp.d8 L_0044b5a1                            # 0044b564
L_0044b566:
    # block 0x0044b566: entered by je at 0x0044b55b, 16 instruction(s), falls into the block at 0x0044b5a1
    movsx eax, word ptr [ebp - local_8]          # 0044b566
    imul eax, eax, 0x3                           # 0044b56a
    mov ecx, dword ptr [ebp - local_c]           # 0044b56d
    movsx edx, word ptr [ecx + eax + field_2]    # 0044b570
    mov dword ptr [ebp - local_24], edx          # 0044b575
    fild dword ptr [ebp - local_24]              # 0044b578
    fstp dword ptr [ebp - local_28]              # 0044b57b
    fld dword ptr [ebp - local_28]               # 0044b57e
    fdiv dword ptr [0x52cbec]                    # 0044b581
    movsx eax, word ptr [ebp - local_8]          # 0044b587
    imul eax, eax, 0x3                           # 0044b58b
    mov ecx, dword ptr [ebp - local_c]           # 0044b58e
    {load} xor edx, edx                          # 0044b591
    mov dl, byte ptr [ecx + eax + field_1]       # 0044b593
    fmul dword ptr [4*edx + 0x58c91d]            # 0044b597
    fstp dword ptr [ebp - local_4]               # 0044b59e
L_0044b5a1:
    # block 0x0044b5a1: entered by jmp at 0x0044b537; jmp at 0x0044b564, 1 instruction(s), ends with forward jump to 0x0044b60a
    jmp.d8 L_0044b60a                            # 0044b5a1
L_0044b5a3:
    # block 0x0044b5a3: entered by jl at 0x0044b492; jg at 0x0044b4ab, 7 instruction(s), ends with jne to 0x0044b5d2 (forward)
    movsx eax, word ptr [ebp - local_8]          # 0044b5a3
    imul eax, eax, 0x3                           # 0044b5a7
    mov ecx, dword ptr [ebp - local_c]           # 0044b5aa
    {load} xor edx, edx                          # 0044b5ad
    mov dl, byte ptr [ecx + eax + field_1]       # 0044b5af
    cmp edx, 0x64                                # 0044b5b3
    jne.d8 L_0044b5d2                            # 0044b5b6
    # block 0x0044b5b8: entered by fall-through of jne at 0x0044b5b6, 8 instruction(s), ends with forward jump to 0x0044b60a
    movsx eax, word ptr [ebp - local_8]          # 0044b5b8
    imul eax, eax, 0x3                           # 0044b5bc
    mov ecx, dword ptr [ebp - local_c]           # 0044b5bf
    movsx edx, word ptr [ecx + eax + field_2]    # 0044b5c2
    mov dword ptr [ebp - local_2c], edx          # 0044b5c7
    fild dword ptr [ebp - local_2c]              # 0044b5ca
    fstp dword ptr [ebp - local_4]               # 0044b5cd
    jmp.d8 L_0044b60a                            # 0044b5d0
L_0044b5d2:
    # block 0x0044b5d2: entered by jne at 0x0044b5b6, 15 instruction(s), calls FUN_0050ca3e, FUN_0052139c, falls into the block at 0x0044b60a
    movsx eax, word ptr [ebp - local_8]          # 0044b5d2
    imul eax, eax, 0x3                           # 0044b5d6
    mov ecx, dword ptr [ebp - local_c]           # 0044b5d9
    {load} xor edx, edx                          # 0044b5dc
    mov dl, byte ptr [ecx + eax + field_1]       # 0044b5de
    push edx                                     # 0044b5e2
    push 0x549088                                # 0044b5e3
    push 0x63888b                                # 0044b5e8
    call FUN_0050ca3e                            # 0044b5ed
    add esp, 0xc                                 # 0044b5f2
    push 0x0                                     # 0044b5f5
    push 0x0                                     # 0044b5f7
    push 0x63888b                                # 0044b5f9
    call FUN_0052139c                            # 0044b5fe
    mov dword ptr [ebp - local_4], 0x0           # 0044b603
L_0044b60a:
    # block 0x0044b60a: entered by jmp at 0x0044b5a1; jmp at 0x0044b5d0, 9 instruction(s), falls into the block at 0x0044b629
    mov eax, dword ptr [ebp - local_c]           # 0044b60a
    {load} xor ecx, ecx                          # 0044b60d
    mov cl, byte ptr [eax]                       # 0044b60f
    fld dword ptr [ebp - local_4]                # 0044b611
    fadd dword ptr [4*ecx + 0x58c91d]            # 0044b614
    mov edx, dword ptr [ebp - local_c]           # 0044b61b
    {load} xor eax, eax                          # 0044b61e
    mov al, byte ptr [edx]                       # 0044b620
    fstp dword ptr [4*eax + 0x58c91d]            # 0044b622
L_0044b629:
    # block 0x0044b629: entered by je at 0x0044b47a, 1 instruction(s), ends with backward jump to 0x0044b44e
    jmp.d32 L_0044b44e                           # 0044b629
L_0044b62e:
    # block 0x0044b62e: entered by jmp at 0x0044b42f; jge at 0x0044b461, 7 instruction(s), calls FUN_0042ba3a, ends with ret 0x4
    mov cx, word ptr [ebp + arg_8]               # 0044b62e
    push ecx                                     # 0044b632
    call FUN_0042ba3a                            # 0044b633
    add esp, 0x4                                 # 0044b638
    {load} mov esp, ebp                          # 0044b63b
    pop ebp                                      # 0044b63d
    ret 0x4                                      # 0044b63e

