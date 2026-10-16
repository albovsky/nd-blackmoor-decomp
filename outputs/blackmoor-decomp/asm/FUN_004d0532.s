# FUN_004d0532
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d0532
# extent:       0x004d0532-0x004d07e7 (693 code bytes)
# span:         0x004d0532-0x004d07e7 (code 693, tables 0, padding 0)
# sha256:       335e1f27b5d90c1bbcd05e182086a2ee658bd1c3e63846993bb3f57b72430ebe
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d0532
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       12 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_26c
# fields:       [eax + n] field_25, field_265; [ecx + n] field_21, field_23, field_25; [edx + n] field_4, field_8, field_c
# callees:      calls FUN_004c5377
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 171 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_26c, 0x26c  # offset -0x26c
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_25, 0x25  # offset +0x25
.equ field_265, 0x265  # offset +0x265

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)

.org 0x004d0532 - 0x401000
.globl FUN_004d0532
FUN_004d0532:
    # block 0x004d0532: entry, 17 instruction(s), ends with forward jump to 0x004d0587
    push ebp                                     # 004d0532
    {load} mov ebp, esp                          # 004d0533
    sub esp, 0x26c                               # 004d0535
    push esi                                     # 004d053b
    push edi                                     # 004d053c
    movsx eax, word ptr [0x5b615f]               # 004d053d
    imul eax, eax, 0x8d                          # 004d0544
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004d054a
    mov dx, word ptr [ecx + field_21]            # 004d0550
    mov word ptr [ebp - local_4], dx             # 004d0554
    movsx eax, word ptr [0x5b615f]               # 004d0558
    imul eax, eax, 0x8d                          # 004d055f
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004d0565
    mov dx, word ptr [ecx + field_23]            # 004d056b
    mov word ptr [ebp - local_24], dx            # 004d056f
    mov word ptr [ebp - local_20], 0x0           # 004d0573
    jmp.d8 L_004d0587                            # 004d0579
L_004d057b:
    # block 0x004d057b: entered by jmp at 0x004d07dc, 3 instruction(s), falls into the block at 0x004d0587
    mov ax, word ptr [ebp - local_20]            # 004d057b
    .insn 0x66, 0x05, 0x0001{:u16}               # 004d057f
    mov word ptr [ebp - local_20], ax            # 004d0583
L_004d0587:
    # block 0x004d0587: entered by jmp at 0x004d0579, 4 instruction(s), ends with jge to 0x004d07e1 (forward)
    movsx ecx, word ptr [ebp - local_20]         # 004d0587
    movsx edx, word ptr [ebp - local_24]         # 004d058b
    {load} cmp ecx, edx                          # 004d058f
    jge.d32 L_004d07e1                           # 004d0591
    # block 0x004d0597: entered by fall-through of jge at 0x004d0591, 2 instruction(s), ends with forward jump to 0x004d05ab
    mov word ptr [ebp - local_1c], 0x0           # 004d0597
    jmp.d8 L_004d05ab                            # 004d059d
L_004d059f:
    # block 0x004d059f: entered by jmp at 0x004d07d7, 3 instruction(s), falls into the block at 0x004d05ab
    mov ax, word ptr [ebp - local_1c]            # 004d059f
    .insn 0x66, 0x05, 0x0001{:u16}               # 004d05a3
    mov word ptr [ebp - local_1c], ax            # 004d05a7
L_004d05ab:
    # block 0x004d05ab: entered by jmp at 0x004d059d, 4 instruction(s), ends with jge to 0x004d07dc (forward)
    movsx ecx, word ptr [ebp - local_1c]         # 004d05ab
    movsx edx, word ptr [ebp - local_4]          # 004d05af
    {load} cmp ecx, edx                          # 004d05b3
    jge.d32 L_004d07dc                           # 004d05b5
    # block 0x004d05bb: entered by fall-through of jge at 0x004d05b5, 8 instruction(s), ends with jne to 0x004d05ea (forward)
    movsx eax, word ptr [ebp - local_20]         # 004d05bb
    imul eax, eax, 0xc                           # 004d05bf
    movsx ecx, word ptr [ebp - local_1c]         # 004d05c2
    mov dx, word ptr [eax + 2*ecx + 0x591992]    # 004d05c6
    mov word ptr [ebp - local_8], dx             # 004d05ce
    movsx eax, word ptr [ebp - local_8]          # 004d05d2
    test eax, eax                                # 004d05d6
    jne.d8 L_004d05ea                            # 004d05d8
    # block 0x004d05da: entered by fall-through of jne at 0x004d05d8, 4 instruction(s), ends with forward jump to 0x004d0627
    mov word ptr [ebp - local_28], 0x0           # 004d05da
    mov cx, word ptr [ebp - local_28]            # 004d05e0
    mov word ptr [ebp - local_2c], cx            # 004d05e4
    jmp.d8 L_004d0627                            # 004d05e8
L_004d05ea:
    # block 0x004d05ea: entered by jne at 0x004d05d8, 3 instruction(s), ends with jne to 0x004d0603 (forward)
    movsx edx, word ptr [ebp - local_8]          # 004d05ea
    cmp edx, -0xa                                # 004d05ee
    jne.d8 L_004d0603                            # 004d05f1
    # block 0x004d05f3: entered by fall-through of jne at 0x004d05f1, 4 instruction(s), ends with forward jump to 0x004d0627
    mov word ptr [ebp - local_28], 0xfff6        # 004d05f3
    mov ax, word ptr [ebp - local_28]            # 004d05f9
    mov word ptr [ebp - local_2c], ax            # 004d05fd
    jmp.d8 L_004d0627                            # 004d0601
L_004d0603:
    # block 0x004d0603: entered by jne at 0x004d05f1, 11 instruction(s), falls into the block at 0x004d0627
    movsx eax, word ptr [ebp - local_8]          # 004d0603
    movsx ecx, word ptr [ebp - local_4]          # 004d0607
    cdq                                          # 004d060b
    idiv ecx                                     # 004d060c
    mov word ptr [ebp - local_2c], ax            # 004d060e
    movsx edx, word ptr [ebp - local_8]          # 004d0612
    movsx eax, word ptr [ebp - local_2c]         # 004d0616
    movsx ecx, word ptr [ebp - local_4]          # 004d061a
    imul eax, ecx                                # 004d061e
    {load} sub edx, eax                          # 004d0621
    mov word ptr [ebp - local_28], dx            # 004d0623
L_004d0627:
    # block 0x004d0627: entered by jmp at 0x004d05e8; jmp at 0x004d0601, 47 instruction(s), ends with jne to 0x004d075a (forward)
    movsx edx, word ptr [0x5b615f]               # 004d0627
    imul edx, edx, 0x8d                          # 004d062e
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004d0634
    movsx ecx, word ptr [ebp - local_20]         # 004d063a
    imul ecx, ecx, 0x60                          # 004d063e
    lea edx, [eax + ecx + field_265]             # 004d0641
    movsx eax, word ptr [ebp - local_1c]         # 004d0648
    shl eax, 0x4                                 # 004d064c
    mov ecx, dword ptr [edx + eax + field_4]     # 004d064f
    add ecx, dword ptr [0x58318a]                # 004d0653
    mov dword ptr [ebp - local_14], ecx          # 004d0659
    movsx edx, word ptr [0x5b615f]               # 004d065c
    imul edx, edx, 0x8d                          # 004d0663
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004d0669
    movsx ecx, word ptr [ebp - local_20]         # 004d066f
    imul ecx, ecx, 0x60                          # 004d0673
    lea edx, [eax + ecx + field_265]             # 004d0676
    movsx eax, word ptr [ebp - local_1c]         # 004d067d
    shl eax, 0x4                                 # 004d0681
    mov ecx, dword ptr [edx + eax + field_c]     # 004d0684
    add ecx, dword ptr [0x58318a]                # 004d0688
    mov dword ptr [ebp - local_c], ecx           # 004d068e
    movsx edx, word ptr [0x5b615f]               # 004d0691
    imul edx, edx, 0x8d                          # 004d0698
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004d069e
    movsx ecx, word ptr [ebp - local_20]         # 004d06a4
    imul ecx, ecx, 0x60                          # 004d06a8
    lea edx, [eax + ecx + field_265]             # 004d06ab
    movsx eax, word ptr [ebp - local_1c]         # 004d06b2
    shl eax, 0x4                                 # 004d06b6
    mov ecx, dword ptr [edx + eax]               # 004d06b9
    add ecx, dword ptr [0x583186]                # 004d06bc
    mov dword ptr [ebp - local_18], ecx          # 004d06c2
    movsx edx, word ptr [0x5b615f]               # 004d06c5
    imul edx, edx, 0x8d                          # 004d06cc
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004d06d2
    movsx ecx, word ptr [ebp - local_20]         # 004d06d8
    imul ecx, ecx, 0x60                          # 004d06dc
    lea edx, [eax + ecx + field_265]             # 004d06df
    movsx eax, word ptr [ebp - local_1c]         # 004d06e6
    shl eax, 0x4                                 # 004d06ea
    mov ecx, dword ptr [edx + eax + field_8]     # 004d06ed
    add ecx, dword ptr [0x583186]                # 004d06f1
    mov dword ptr [ebp - local_10], ecx          # 004d06f7
    movsx edx, word ptr [ebp - local_28]         # 004d06fa
    cmp edx, -0xa                                # 004d06fe
    jne.d8 L_004d075a                            # 004d0701
    # block 0x004d0703: entered by fall-through of jne at 0x004d0701, 3 instruction(s), ends with jne to 0x004d075a (forward)
    movsx eax, word ptr [ebp - local_2c]         # 004d0703
    cmp eax, -0xa                                # 004d0707
    jne.d8 L_004d075a                            # 004d070a
    # block 0x004d070c: entered by fall-through of jne at 0x004d070a, 20 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004d07d7
    push 0x559fc0                                # 004d070c
    lea ecx, [ebp - local_18]                    # 004d0711
    push ecx                                     # 004d0714
    movsx edx, word ptr [0x5b615f]               # 004d0715
    imul edx, edx, 0x8d                          # 004d071c
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004d0722
    movsx ecx, word ptr [ebp - local_20]         # 004d0728
    imul ecx, ecx, 0x60                          # 004d072c
    lea edx, [eax + ecx + field_265]             # 004d072f
    movsx eax, word ptr [ebp - local_1c]         # 004d0736
    shl eax, 0x4                                 # 004d073a
    {load} add edx, eax                          # 004d073d
    push edx                                     # 004d073f
    mov ecx, dword ptr [0x5cf665]                # 004d0740
    push ecx                                     # 004d0746
    mov edx, dword ptr [0x5d15e3]                # 004d0747
    push edx                                     # 004d074d
    mov ecx, 0x5cf659                            # 004d074e
    call FUN_004c5377                            # 004d0753
    jmp.d8 L_004d07d7                            # 004d0758
L_004d075a:
    # block 0x004d075a: entered by jne at 0x004d0701; jne at 0x004d070a, 31 instruction(s), calls FUN_004c5377, falls into the block at 0x004d07d7
    movsx eax, word ptr [0x5b615f]               # 004d075a
    imul eax, eax, 0x8d                          # 004d0761
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004d0767
    movsx edx, word ptr [ebp - local_2c]         # 004d076d
    imul edx, edx, 0x60                          # 004d0771
    lea esi, [ecx + edx + field_25]              # 004d0774
    movsx eax, word ptr [ebp - local_28]         # 004d0778
    shl eax, 0x4                                 # 004d077c
    {load} add esi, eax                          # 004d077f
    mov ecx, 0x9                                 # 004d0781
    lea edi, [ebp - local_26c]                   # 004d0786
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d078c
    push 0x559fe8                                # 004d078e
    lea ecx, [ebp - local_18]                    # 004d0793
    push ecx                                     # 004d0796
    movsx edx, word ptr [0x5b615f]               # 004d0797
    imul edx, edx, 0x8d                          # 004d079e
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004d07a4
    movsx ecx, word ptr [ebp - local_2c]         # 004d07aa
    imul ecx, ecx, 0x60                          # 004d07ae
    lea edx, [eax + ecx + field_25]              # 004d07b1
    movsx eax, word ptr [ebp - local_28]         # 004d07b5
    shl eax, 0x4                                 # 004d07b9
    {load} add edx, eax                          # 004d07bc
    push edx                                     # 004d07be
    mov ecx, dword ptr [0x5cf665]                # 004d07bf
    push ecx                                     # 004d07c5
    mov edx, dword ptr [0x5d1bab]                # 004d07c6
    push edx                                     # 004d07cc
    mov ecx, 0x5cf659                            # 004d07cd
    call FUN_004c5377                            # 004d07d2
L_004d07d7:
    # block 0x004d07d7: entered by jmp at 0x004d0758, 1 instruction(s), ends with backward jump to 0x004d059f
    jmp.d32 L_004d059f                           # 004d07d7
L_004d07dc:
    # block 0x004d07dc: entered by jge at 0x004d05b5, 1 instruction(s), ends with backward jump to 0x004d057b
    jmp.d32 L_004d057b                           # 004d07dc
L_004d07e1:
    # block 0x004d07e1: entered by jge at 0x004d0591, 5 instruction(s), ends with ret
    pop edi                                      # 004d07e1
    pop esi                                      # 004d07e2
    {load} mov esp, ebp                          # 004d07e3
    pop ebp                                      # 004d07e5
    ret                                          # 004d07e6

