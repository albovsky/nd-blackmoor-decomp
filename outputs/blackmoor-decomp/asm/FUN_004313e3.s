# FUN_004313e3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004313e3
# extent:       0x004313e3-0x00431b4a (1895 code bytes)
# span:         0x004313e3-0x00431b5a (code 1895, tables 16, padding 0)
# sha256:       d840f292fef6bcd0e4e8cd4a97a0e71e5f4a2662c3f7db6e3a1a296258a6756f
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004313e3
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_111, field_114, field_179, field_17b, field_17d, field_17f, field_181, field_185, field_189, field_18d, field_1b5; [ecx + n] field_192, field_1b5; [edx + n] field_18f, field_191, field_1c5, field_1c7, field_1c9, field_1cb, field_1cd, field_1d1, field_1d5, field_1d9, field_1db, field_1dd
# callees:      calls FUN_004e8d96, FUN_004c2dfb, FUN_004c2790, FUN_004fb77a, KERNEL32.dll!GetTickCount, FUN_004fb2e3, FUN_004f6334, FUN_004fba69, FUN_0042ba3a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 382 instruction(s), 22 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ arg_8, 0x8  # offset +0x8
.equ field_111, 0x111  # offset +0x111
.equ field_114, 0x114  # offset +0x114
.equ field_179, 0x179  # offset +0x179
.equ field_17b, 0x17b  # offset +0x17b
.equ field_17d, 0x17d  # offset +0x17d
.equ field_17f, 0x17f  # offset +0x17f
.equ field_181, 0x181  # offset +0x181
.equ field_185, 0x185  # offset +0x185
.equ field_189, 0x189  # offset +0x189
.equ field_18d, 0x18d  # offset +0x18d
.equ field_18f, 0x18f  # offset +0x18f
.equ field_191, 0x191  # offset +0x191
.equ field_192, 0x192  # offset +0x192
.equ field_1b5, 0x1b5  # offset +0x1b5
.equ field_1c5, 0x1c5  # offset +0x1c5
.equ field_1c7, 0x1c7  # offset +0x1c7
.equ field_1c9, 0x1c9  # offset +0x1c9
.equ field_1cb, 0x1cb  # offset +0x1cb
.equ field_1cd, 0x1cd  # offset +0x1cd
.equ field_1d1, 0x1d1  # offset +0x1d1
.equ field_1d5, 0x1d5  # offset +0x1d5
.equ field_1d9, 0x1d9  # offset +0x1d9
.equ field_1db, 0x1db  # offset +0x1db
.equ field_1dd, 0x1dd  # offset +0x1dd

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)

.org 0x004313e3 - 0x401000
.globl FUN_004313e3
FUN_004313e3:
    # block 0x004313e3: entry, 12 instruction(s), ends with je to 0x0043141e (forward)
    push ebp                                     # 004313e3
    {load} mov ebp, esp                          # 004313e4
    sub esp, 0x10                                # 004313e6
    push ebx                                     # 004313e9
    push esi                                     # 004313ea
    push edi                                     # 004313eb
    movsx eax, word ptr [ebp + arg_8]            # 004313ec
    imul eax, eax, 0x8d                          # 004313f0
    mov ecx, dword ptr [eax + 0x5bb632]          # 004313f6
    mov dword ptr [ebp - local_c], ecx           # 004313fc
    cmp dword ptr [ebp - local_c], 0x0           # 004313ff
    je.d8 L_0043141e                             # 00431403
    # block 0x00431405: entered by fall-through of je at 0x00431403, 2 instruction(s), ends with je to 0x004315aa (forward)
    cmp dword ptr [ebp - local_c], 0x1           # 00431405
    je.d32 L_004315aa                            # 00431409
    # block 0x0043140f: entered by fall-through of je at 0x00431409, 2 instruction(s), ends with je to 0x004317cc (forward)
    cmp dword ptr [ebp - local_c], 0x2           # 0043140f
    je.d32 L_004317cc                            # 00431413
    # block 0x00431419: entered by fall-through of je at 0x00431413, 1 instruction(s), ends with forward jump to 0x00431b43
    jmp.d32 L_00431b43                           # 00431419
L_0043141e:
    # block 0x0043141e: entered by je at 0x00431403, 10 instruction(s), calls FUN_004e8d96, ends with forward jump to 0x00431466
    mov byte ptr [0x5b51c6], 0x1                 # 0043141e
    mov byte ptr [0x5b51e0], 0x0                 # 00431425
    mov dword ptr [0x5bb1ca], 0x1                # 0043142c
    mov dx, word ptr [ebp + arg_8]               # 00431436
    mov word ptr [0x5b51c7], dx                  # 0043143a
    mov byte ptr [0x5b51cb], 0x0                 # 00431441
    mov ecx, 0x571442                            # 00431448
    call FUN_004e8d96                            # 0043144d
    mov word ptr [ebp - local_4], 0x0            # 00431452
    jmp.d8 L_00431466                            # 00431458
L_0043145a:
    # block 0x0043145a: entered by jmp at 0x004314a6, 3 instruction(s), falls into the block at 0x00431466
    mov ax, word ptr [ebp - local_4]             # 0043145a
    .insn 0x66, 0x05, 0x0001{:u16}               # 0043145e
    mov word ptr [ebp - local_4], ax             # 00431462
L_00431466:
    # block 0x00431466: entered by jmp at 0x00431458, 3 instruction(s), ends with jge to 0x004314a8 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 00431466
    cmp ecx, 0x3                                 # 0043146a
    jge.d8 L_004314a8                            # 0043146d
    # block 0x0043146f: entered by fall-through of jge at 0x0043146d, 11 instruction(s), ends with backward jump to 0x0043145a
    movsx edx, word ptr [ebp + arg_8]            # 0043146f
    imul edx, edx, 0x8d                          # 00431473
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00431479
    movsx ecx, word ptr [ebp - local_4]          # 0043147f
    {load} xor edx, edx                          # 00431483
    mov dl, byte ptr [eax + ecx + field_111]     # 00431485
    movsx eax, word ptr [ebp - local_4]          # 0043148c
    mov dword ptr [4*eax + 0x5b51ba], edx        # 00431490
    movsx ecx, word ptr [ebp - local_4]          # 00431497
    mov dword ptr [4*ecx + 0x5b51d4], 0x1        # 0043149b
    jmp.d8 L_0043145a                            # 004314a6
L_004314a8:
    # block 0x004314a8: entered by jge at 0x0043146d, 25 instruction(s), calls FUN_004c2dfb, FUN_004c2790, ends with je to 0x00431540 (forward)
    push 0x5d03d7                                # 004314a8
    mov ecx, 0x5cf659                            # 004314ad
    call FUN_004c2dfb                            # 004314b2
    push 0x545c9c                                # 004314b7
    push 0x6                                     # 004314bc
    movsx edx, word ptr [ebp + arg_8]            # 004314be
    imul edx, edx, 0x8d                          # 004314c2
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004314c8
    push eax                                     # 004314ce
    push 0x545cb4                                # 004314cf
    mov ecx, 0x5cf659                            # 004314d4
    call FUN_004c2790                            # 004314d9
    mov dword ptr [0x5d03d7], eax                # 004314de
    mov ecx, dword ptr [0x5d03d7]                # 004314e3
    mov dword ptr [0x5d1b17], ecx                # 004314e9
    mov dword ptr [0x5d1b23], 0x1                # 004314ef
    mov edi, 0x545cbc                            # 004314f9
    movsx edx, word ptr [ebp + arg_8]            # 004314fe
    imul edx, edx, 0x8d                          # 00431502
    mov esi, dword ptr [edx + 0x5bb5e5]          # 00431508
    add esi, 0x117                               # 0043150e
    mov ecx, 0x9                                 # 00431514
    {load} xor eax, eax                          # 00431519
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0043151b
    je.d8 L_00431540                             # 0043151d
    # block 0x0043151f: entered by fall-through of je at 0x0043151d, 7 instruction(s), calls FUN_004fb77a, falls into the block at 0x00431540
    movsx ecx, word ptr [ebp + arg_8]            # 0043151f
    imul ecx, ecx, 0x8d                          # 00431523
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00431529
    add edx, 0x117                               # 0043152f
    push edx                                     # 00431535
    mov ecx, 0x5c3a67                            # 00431536
    call FUN_004fb77a                            # 0043153b
L_00431540:
    # block 0x00431540: entered by je at 0x0043151d, 9 instruction(s), ends with je to 0x00431587 (forward)
    mov edi, 0x545cc8                            # 00431540
    movsx eax, word ptr [ebp + arg_8]            # 00431545
    imul eax, eax, 0x8d                          # 00431549
    mov esi, dword ptr [eax + 0x5bb5e5]          # 0043154f
    add esi, 0x148                               # 00431555
    mov ecx, 0x9                                 # 0043155b
    {load} xor edx, edx                          # 00431560
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00431562
    je.d8 L_00431587                             # 00431564
    # block 0x00431566: entered by fall-through of je at 0x00431564, 7 instruction(s), calls FUN_004fb77a, falls into the block at 0x00431587
    movsx eax, word ptr [ebp + arg_8]            # 00431566
    imul eax, eax, 0x8d                          # 0043156a
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00431570
    add ecx, 0x148                               # 00431576
    push ecx                                     # 0043157c
    mov ecx, 0x5c3a67                            # 0043157d
    call FUN_004fb77a                            # 00431582
L_00431587:
    # block 0x00431587: entered by je at 0x00431564, 5 instruction(s), ends with forward jump to 0x00431b43
    mov dword ptr [0x5b51d0], 0x0                # 00431587
    movsx edx, word ptr [ebp + arg_8]            # 00431591
    imul edx, edx, 0x8d                          # 00431595
    mov dword ptr [edx + 0x5bb632], 0x1          # 0043159b
    jmp.d32 L_00431b43                           # 004315a5
L_004315aa:
    # block 0x004315aa: entered by je at 0x00431409, 4 instruction(s), ends with ja to 0x004317c7 (forward)
    mov eax, dword ptr [0x5b51d0]                # 004315aa
    mov dword ptr [ebp - local_10], eax          # 004315af
    cmp dword ptr [ebp - local_10], 0x3          # 004315b2
    ja.d32 L_004317c7                            # 004315b6
    # block 0x004315bc: entered by fall-through of ja at 0x004315b6, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x431b4a]
    mov ecx, dword ptr [ebp - local_10]          # 004315bc
    jmp dword ptr [4*ecx + SWTAB_00431b4a_VA]    # 004315bf
L_004315c6:
    # block 0x004315c6: entered by switch case, 3 instruction(s), ends with forward jump to 0x004315e1
    mov byte ptr [0x5b51e0], 0x1                 # 004315c6
    mov word ptr [ebp - local_4], 0x0            # 004315cd
    jmp.d8 L_004315e1                            # 004315d3
L_004315d5:
    # block 0x004315d5: entered by jmp at 0x0043161d, 3 instruction(s), falls into the block at 0x004315e1
    mov dx, word ptr [ebp - local_4]             # 004315d5
    add dx, 0x1                                  # 004315d9
    mov word ptr [ebp - local_4], dx             # 004315dd
L_004315e1:
    # block 0x004315e1: entered by jmp at 0x004315d3, 3 instruction(s), ends with jge to 0x0043161f (forward)
    movsx eax, word ptr [ebp - local_4]          # 004315e1
    cmp eax, 0x3                                 # 004315e5
    jge.d8 L_0043161f                            # 004315e8
    # block 0x004315ea: entered by fall-through of jge at 0x004315e8, 9 instruction(s), ends with je to 0x0043161d (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004315ea
    movsx edx, word ptr [ebp + arg_8]            # 004315ee
    imul edx, edx, 0x8d                          # 004315f2
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004315f8
    movsx edx, word ptr [ebp - local_4]          # 004315fe
    {load} xor ebx, ebx                          # 00431602
    mov bl, byte ptr [eax + edx + field_114]     # 00431604
    cmp dword ptr [4*ecx + 0x5b51ba], ebx        # 0043160b
    je.d8 L_0043161d                             # 00431612
    # block 0x00431614: entered by fall-through of je at 0x00431612, 2 instruction(s), ends with forward jump to 0x0043161f
    mov byte ptr [0x5b51e0], 0x0                 # 00431614
    jmp.d8 L_0043161f                            # 0043161b
L_0043161d:
    # block 0x0043161d: entered by je at 0x00431612, 1 instruction(s), ends with backward jump to 0x004315d5
    jmp.d8 L_004315d5                            # 0043161d
L_0043161f:
    # block 0x0043161f: entered by jge at 0x004315e8; jmp at 0x0043161b, 4 instruction(s), ends with je to 0x00431639 (forward)
    {load} xor eax, eax                          # 0043161f
    mov al, byte ptr [0x5b51e0]                  # 00431621
    test eax, eax                                # 00431626
    je.d8 L_00431639                             # 00431628
    # block 0x0043162a: entered by fall-through of je at 0x00431628, 2 instruction(s), ends with forward jump to 0x004317c7
    mov dword ptr [0x5b51d0], 0x1                # 0043162a
    jmp.d32 L_004317c7                           # 00431634
L_00431639:
    # block 0x00431639: entered by je at 0x00431628, 1 instruction(s), ends with forward jump to 0x004317c7
    jmp.d32 L_004317c7                           # 00431639
L_0043163e:
    # block 0x0043163e: entered by switch case, 6 instruction(s), ends with je to 0x00431690 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0043163e
    imul ecx, ecx, 0x8d                          # 00431642
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00431648
    movsx eax, word ptr [edx + field_18f]        # 0043164e
    cmp eax, -0x1                                # 00431655
    je.d8 L_00431690                             # 00431658
    # block 0x0043165a: entered by fall-through of je at 0x00431658, 10 instruction(s), falls into the block at 0x00431690
    movsx ecx, word ptr [ebp + arg_8]            # 0043165a
    imul ecx, ecx, 0x8d                          # 0043165e
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00431664
    {load} xor eax, eax                          # 0043166a
    mov al, byte ptr [edx + field_191]           # 0043166c
    movsx ecx, word ptr [ebp + arg_8]            # 00431672
    imul ecx, ecx, 0x8d                          # 00431676
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0043167c
    movsx ecx, word ptr [edx + field_18f]        # 00431682
    mov dword ptr [4*ecx + 0x585801], eax        # 00431689
L_00431690:
    # block 0x00431690: entered by je at 0x00431658, 10 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x004317c7
    call dword ptr [0x52a23c]                    # 00431690
    movsx edx, word ptr [ebp + arg_8]            # 00431696
    imul edx, edx, 0x8d                          # 0043169a
    mov ecx, dword ptr [edx + 0x5bb5e5]          # 004316a0
    movsx edx, word ptr [ecx + field_192]        # 004316a6
    imul edx, edx, 0x3e8                         # 004316ad
    {load} add eax, edx                          # 004316b3
    mov dword ptr [0x5b51cc], eax                # 004316b5
    mov dword ptr [0x5b51d0], 0x2                # 004316ba
    jmp.d32 L_004317c7                           # 004316c4
L_004316c9:
    # block 0x004316c9: entered by switch case, 3 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x00431764 (forward)
    call dword ptr [0x52a23c]                    # 004316c9
    cmp eax, dword ptr [0x5b51cc]                # 004316cf
    jb.d32 L_00431764                            # 004316d5
    # block 0x004316db: entered by fall-through of jb at 0x004316d5, 9 instruction(s), ends with je to 0x00431750 (forward)
    mov edi, 0x545cd4                            # 004316db
    movsx eax, word ptr [ebp + arg_8]            # 004316e0
    imul eax, eax, 0x8d                          # 004316e4
    mov esi, dword ptr [eax + 0x5bb5e5]          # 004316ea
    add esi, 0x194                               # 004316f0
    mov ecx, 0x9                                 # 004316f6
    {load} xor edx, edx                          # 004316fb
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004316fd
    je.d8 L_00431750                             # 004316ff
    # block 0x00431701: entered by fall-through of je at 0x004316ff, 16 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x00431764
    movsx eax, word ptr [ebp + arg_8]            # 00431701
    imul eax, eax, 0x8d                          # 00431705
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0043170b
    add ecx, 0x194                               # 00431711
    push ecx                                     # 00431717
    mov ecx, 0x5c3a67                            # 00431718
    call FUN_004fb77a                            # 0043171d
    movsx edx, word ptr [ebp + arg_8]            # 00431722
    imul edx, edx, 0x8d                          # 00431726
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0043172c
    mov cx, word ptr [eax + field_1b5]           # 00431732
    push ecx                                     # 00431739
    mov ecx, 0x5c3a67                            # 0043173a
    call FUN_004fb2e3                            # 0043173f
    mov dword ptr [0x5b51d0], 0x3                # 00431744
    jmp.d8 L_00431764                            # 0043174e
L_00431750:
    # block 0x00431750: entered by je at 0x004316ff, 3 instruction(s), falls into the block at 0x00431764
    movsx edx, word ptr [ebp + arg_8]            # 00431750
    imul edx, edx, 0x8d                          # 00431754
    mov dword ptr [edx + 0x5bb632], 0x2          # 0043175a
L_00431764:
    # block 0x00431764: entered by jb at 0x004316d5; jmp at 0x0043174e, 1 instruction(s), ends with forward jump to 0x004317c7
    jmp.d8 L_004317c7                            # 00431764
L_00431766:
    # block 0x00431766: entered by switch case, 11 instruction(s), calls FUN_004f6334, ends with jne to 0x004317c7 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 00431766
    imul eax, eax, 0x8d                          # 0043176a
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00431770
    movsx edx, word ptr [ecx + field_1b5]        # 00431776
    mov dword ptr [ebp - local_8], edx           # 0043177d
    mov eax, dword ptr [ebp - local_8]           # 00431780
    push eax                                     # 00431783
    mov ecx, 0x5cf1eb                            # 00431784
    call FUN_004f6334                            # 00431789
    test eax, eax                                # 0043178e
    jne.d8 L_004317c7                            # 00431790
    # block 0x00431792: entered by fall-through of jne at 0x00431790, 10 instruction(s), calls FUN_004fba69, falls into the block at 0x004317c7
    movsx ecx, word ptr [ebp + arg_8]            # 00431792
    imul ecx, ecx, 0x8d                          # 00431796
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0043179c
    add edx, 0x194                               # 004317a2
    push edx                                     # 004317a8
    mov ecx, 0x5c3a67                            # 004317a9
    call FUN_004fba69                            # 004317ae
    movsx eax, word ptr [ebp + arg_8]            # 004317b3
    imul eax, eax, 0x8d                          # 004317b7
    mov dword ptr [eax + 0x5bb632], 0x2          # 004317bd
L_004317c7:
    # block 0x004317c7: entered by ja at 0x004315b6; jmp at 0x00431634; jmp at 0x00431639; jmp at 0x004316c4; more, 1 instruction(s), ends with forward jump to 0x00431b43
    jmp.d32 L_00431b43                           # 004317c7
L_004317cc:
    # block 0x004317cc: entered by je at 0x00431413, 15 instruction(s), calls FUN_004c2dfb, ends with je to 0x0043183d (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 004317cc
    mov byte ptr [0x5b51c6], 0x0                 # 004317d6
    push 0x5d03d7                                # 004317dd
    mov ecx, 0x5cf659                            # 004317e2
    call FUN_004c2dfb                            # 004317e7
    mov dword ptr [0x5d1b23], 0x0                # 004317ec
    mov edi, 0x545ce0                            # 004317f6
    movsx ecx, word ptr [ebp + arg_8]            # 004317fb
    imul ecx, ecx, 0x8d                          # 004317ff
    mov esi, dword ptr [ecx + 0x5bb5e5]          # 00431805
    add esi, 0x117                               # 0043180b
    mov ecx, 0x9                                 # 00431811
    {load} xor edx, edx                          # 00431816
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00431818
    je.d8 L_0043183d                             # 0043181a
    # block 0x0043181c: entered by fall-through of je at 0x0043181a, 7 instruction(s), calls FUN_004fba69, falls into the block at 0x0043183d
    movsx eax, word ptr [ebp + arg_8]            # 0043181c
    imul eax, eax, 0x8d                          # 00431820
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00431826
    add ecx, 0x117                               # 0043182c
    push ecx                                     # 00431832
    mov ecx, 0x5c3a67                            # 00431833
    call FUN_004fba69                            # 00431838
L_0043183d:
    # block 0x0043183d: entered by je at 0x0043181a, 9 instruction(s), ends with je to 0x00431884 (forward)
    mov edi, 0x545cec                            # 0043183d
    movsx edx, word ptr [ebp + arg_8]            # 00431842
    imul edx, edx, 0x8d                          # 00431846
    mov esi, dword ptr [edx + 0x5bb5e5]          # 0043184c
    add esi, 0x148                               # 00431852
    mov ecx, 0x9                                 # 00431858
    {load} xor eax, eax                          # 0043185d
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0043185f
    je.d8 L_00431884                             # 00431861
    # block 0x00431863: entered by fall-through of je at 0x00431861, 7 instruction(s), calls FUN_004fba69, falls into the block at 0x00431884
    movsx ecx, word ptr [ebp + arg_8]            # 00431863
    imul ecx, ecx, 0x8d                          # 00431867
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0043186d
    add edx, 0x148                               # 00431873
    push edx                                     # 00431879
    mov ecx, 0x5c3a67                            # 0043187a
    call FUN_004fba69                            # 0043187f
L_00431884:
    # block 0x00431884: entered by je at 0x00431861, 4 instruction(s), ends with je to 0x00431a0c (forward)
    {load} xor eax, eax                          # 00431884
    mov al, byte ptr [0x5b51cb]                  # 00431886
    test eax, eax                                # 0043188b
    je.d32 L_00431a0c                            # 0043188d
    # block 0x00431893: entered by fall-through of je at 0x0043188d, 6 instruction(s), ends with je to 0x004319b5 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00431893
    imul ecx, ecx, 0x8d                          # 00431897
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0043189d
    movsx eax, word ptr [edx + field_1c5]        # 004318a3
    cmp eax, 0x270f                              # 004318aa
    je.d32 L_004319b5                            # 004318af
    # block 0x004318b5: entered by fall-through of je at 0x004318af, 41 instruction(s), ends with jne to 0x004319a1 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004318b5
    imul ecx, ecx, 0x8d                          # 004318b9
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004318bf
    movsx eax, word ptr [edx + field_1c5]        # 004318c5
    mov dword ptr [0x5bb57b], eax                # 004318cc
    movsx ecx, word ptr [ebp + arg_8]            # 004318d1
    imul ecx, ecx, 0x8d                          # 004318d5
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004318db
    mov ax, word ptr [edx + field_1c7]           # 004318e1
    mov word ptr [0x5bb599], ax                  # 004318e8
    movsx ecx, word ptr [ebp + arg_8]            # 004318ee
    imul ecx, ecx, 0x8d                          # 004318f2
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004318f8
    mov ax, word ptr [edx + field_1c9]           # 004318fe
    mov word ptr [0x5bb595], ax                  # 00431905
    movsx ecx, word ptr [ebp + arg_8]            # 0043190b
    imul ecx, ecx, 0x8d                          # 0043190f
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00431915
    mov ax, word ptr [edx + field_1cb]           # 0043191b
    mov word ptr [0x5c39ff], ax                  # 00431922
    movsx ecx, word ptr [ebp + arg_8]            # 00431928
    imul ecx, ecx, 0x8d                          # 0043192c
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00431932
    mov eax, dword ptr [edx + field_1cd]         # 00431938
    mov dword ptr [0x5bb59b], eax                # 0043193e
    movsx ecx, word ptr [ebp + arg_8]            # 00431943
    imul ecx, ecx, 0x8d                          # 00431947
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0043194d
    mov eax, dword ptr [edx + field_1d1]         # 00431953
    mov dword ptr [0x5bb59f], eax                # 00431959
    movsx ecx, word ptr [ebp + arg_8]            # 0043195e
    imul ecx, ecx, 0x8d                          # 00431962
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00431968
    mov eax, dword ptr [edx + field_1d5]         # 0043196e
    mov dword ptr [0x5bb5a3], eax                # 00431974
    movsx ecx, word ptr [ebp + arg_8]            # 00431979
    imul ecx, ecx, 0x8d                          # 0043197d
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00431983
    movsx eax, word ptr [edx + field_1d9]        # 00431989
    cmp eax, 0x1                                 # 00431990
    jne.d8 L_004319a1                            # 00431993
    # block 0x00431995: entered by fall-through of jne at 0x00431993, 2 instruction(s), ends with forward jump to 0x004319ab
    mov dword ptr [0x5bb1ca], 0x0                # 00431995
    jmp.d8 L_004319ab                            # 0043199f
L_004319a1:
    # block 0x004319a1: entered by jne at 0x00431993, 1 instruction(s), falls into the block at 0x004319ab
    mov dword ptr [0x5bb1ca], 0x1                # 004319a1
L_004319ab:
    # block 0x004319ab: entered by jmp at 0x0043199f, 1 instruction(s), falls into the block at 0x004319b5
    mov dword ptr [0x583999], 0x4                # 004319ab
L_004319b5:
    # block 0x004319b5: entered by je at 0x004318af, 6 instruction(s), ends with je to 0x00431a07 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004319b5
    imul ecx, ecx, 0x8d                          # 004319b9
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004319bf
    movsx eax, word ptr [edx + field_1db]        # 004319c5
    cmp eax, -0x1                                # 004319cc
    je.d8 L_00431a07                             # 004319cf
    # block 0x004319d1: entered by fall-through of je at 0x004319cf, 10 instruction(s), falls into the block at 0x00431a07
    movsx ecx, word ptr [ebp + arg_8]            # 004319d1
    imul ecx, ecx, 0x8d                          # 004319d5
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004319db
    {load} xor eax, eax                          # 004319e1
    mov al, byte ptr [edx + field_1dd]           # 004319e3
    movsx ecx, word ptr [ebp + arg_8]            # 004319e9
    imul ecx, ecx, 0x8d                          # 004319ed
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004319f3
    movsx ecx, word ptr [edx + field_1db]        # 004319f9
    mov dword ptr [4*ecx + 0x585801], eax        # 00431a00
L_00431a07:
    # block 0x00431a07: entered by je at 0x004319cf, 1 instruction(s), ends with forward jump to 0x00431b36
    jmp.d32 L_00431b36                           # 00431a07
L_00431a0c:
    # block 0x00431a0c: entered by je at 0x0043188d, 6 instruction(s), ends with je to 0x00431b36 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 00431a0c
    imul edx, edx, 0x8d                          # 00431a10
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00431a16
    movsx ecx, word ptr [eax + field_179]        # 00431a1c
    cmp ecx, 0x270f                              # 00431a23
    je.d32 L_00431b36                            # 00431a29
    # block 0x00431a2f: entered by fall-through of je at 0x00431a29, 41 instruction(s), ends with jne to 0x00431b22 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 00431a2f
    imul edx, edx, 0x8d                          # 00431a33
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00431a39
    movsx ecx, word ptr [eax + field_179]        # 00431a3f
    mov dword ptr [0x5bb57b], ecx                # 00431a46
    movsx edx, word ptr [ebp + arg_8]            # 00431a4c
    imul edx, edx, 0x8d                          # 00431a50
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00431a56
    mov cx, word ptr [eax + field_17b]           # 00431a5c
    mov word ptr [0x5bb599], cx                  # 00431a63
    movsx edx, word ptr [ebp + arg_8]            # 00431a6a
    imul edx, edx, 0x8d                          # 00431a6e
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00431a74
    mov cx, word ptr [eax + field_17d]           # 00431a7a
    mov word ptr [0x5bb595], cx                  # 00431a81
    movsx edx, word ptr [ebp + arg_8]            # 00431a88
    imul edx, edx, 0x8d                          # 00431a8c
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00431a92
    mov cx, word ptr [eax + field_17f]           # 00431a98
    mov word ptr [0x5c39ff], cx                  # 00431a9f
    movsx edx, word ptr [ebp + arg_8]            # 00431aa6
    imul edx, edx, 0x8d                          # 00431aaa
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00431ab0
    mov ecx, dword ptr [eax + field_181]         # 00431ab6
    mov dword ptr [0x5bb59b], ecx                # 00431abc
    movsx edx, word ptr [ebp + arg_8]            # 00431ac2
    imul edx, edx, 0x8d                          # 00431ac6
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00431acc
    mov ecx, dword ptr [eax + field_185]         # 00431ad2
    mov dword ptr [0x5bb59f], ecx                # 00431ad8
    movsx edx, word ptr [ebp + arg_8]            # 00431ade
    imul edx, edx, 0x8d                          # 00431ae2
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00431ae8
    mov ecx, dword ptr [eax + field_189]         # 00431aee
    mov dword ptr [0x5bb5a3], ecx                # 00431af4
    movsx edx, word ptr [ebp + arg_8]            # 00431afa
    imul edx, edx, 0x8d                          # 00431afe
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00431b04
    movsx ecx, word ptr [eax + field_18d]        # 00431b0a
    cmp ecx, 0x1                                 # 00431b11
    jne.d8 L_00431b22                            # 00431b14
    # block 0x00431b16: entered by fall-through of jne at 0x00431b14, 2 instruction(s), ends with forward jump to 0x00431b2c
    mov dword ptr [0x5bb1ca], 0x0                # 00431b16
    jmp.d8 L_00431b2c                            # 00431b20
L_00431b22:
    # block 0x00431b22: entered by jne at 0x00431b14, 1 instruction(s), falls into the block at 0x00431b2c
    mov dword ptr [0x5bb1ca], 0x1                # 00431b22
L_00431b2c:
    # block 0x00431b2c: entered by jmp at 0x00431b20, 1 instruction(s), falls into the block at 0x00431b36
    mov dword ptr [0x583999], 0x4                # 00431b2c
L_00431b36:
    # block 0x00431b36: entered by jmp at 0x00431a07; je at 0x00431a29, 4 instruction(s), calls FUN_0042ba3a, falls into the block at 0x00431b43
    mov dx, word ptr [ebp + arg_8]               # 00431b36
    push edx                                     # 00431b3a
    call FUN_0042ba3a                            # 00431b3b
    add esp, 0x4                                 # 00431b40
L_00431b43:
    # block 0x00431b43: entered by jmp at 0x00431419; jmp at 0x004315a5; jmp at 0x004317c7, 6 instruction(s), ends with ret
    pop edi                                      # 00431b43
    pop esi                                      # 00431b44
    pop ebx                                      # 00431b45
    {load} mov esp, ebp                          # 00431b46
    pop ebp                                      # 00431b48
    ret                                          # 00431b49

# --- data items (not part of the function) -------------------------
.org 0x00431b4a - 0x401000
SWTAB_00431b4a:  # 4 case address(es)
    .long L_004315c6 - .text + 0x401000
    .long L_0043163e - .text + 0x401000
    .long L_004316c9 - .text + 0x401000
    .long L_00431766 - .text + 0x401000
.set SWTAB_00431b4a_VA, SWTAB_00431b4a - .text + 0x401000

