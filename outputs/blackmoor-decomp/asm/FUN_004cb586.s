# FUN_004cb586
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cb586
# extent:       0x004cb586-0x004cb8d5 (847 code bytes)
# span:         0x004cb586-0x004cb8d5 (code 847, tables 0, padding 0)
# sha256:       91e675c3a72629218d9b961ae84b177a59581568d0f19b4e52b8f4110288ab76
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004cb586
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       10 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_19, local_1a, local_20, local_24
# fields:       [eax + n] field_1, field_8, field_c, field_12, field_16, field_14e; [ecx + n] field_1, field_8, field_c, field_e, field_12, field_16, field_14a, field_152; [edx + n] field_c, field_12, field_1a, field_21, field_14a, field_152, field_154, field_15c
# callees:      calls FUN_004cbba9, FUN_004c0c2c, FUN_004c0c18, FUN_004d39f9, FUN_004c0c54, FUN_004cb944, FUN_004cb9d1, FUN_004caf8a, FUN_0042ba3a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 214 instruction(s), 18 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class static_navigation_only is a native-touch record, not a counterpart claim
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
.equ local_19, 0x19  # offset -0x19
.equ local_1a, 0x1a  # offset -0x1a
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ field_1, 0x1  # offset +0x1
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_e, 0xe  # offset +0xe
.equ field_12, 0x12  # offset +0x12
.equ field_16, 0x16  # offset +0x16
.equ field_1a, 0x1a  # offset +0x1a
.equ field_21, 0x21  # offset +0x21
.equ field_14a, 0x14a  # offset +0x14a
.equ field_14e, 0x14e  # offset +0x14e
.equ field_152, 0x152  # offset +0x152
.equ field_154, 0x154  # offset +0x154
.equ field_15c, 0x15c  # offset +0x15c

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_004c0c18, .text + (0x004c0c18 - 0x401000)
.set FUN_004c0c2c, .text + (0x004c0c2c - 0x401000)
.set FUN_004c0c54, .text + (0x004c0c54 - 0x401000)
.set FUN_004caf8a, .text + (0x004caf8a - 0x401000)
.set FUN_004cb944, .text + (0x004cb944 - 0x401000)
.set FUN_004cb9d1, .text + (0x004cb9d1 - 0x401000)
.set FUN_004cbba9, .text + (0x004cbba9 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)

.org 0x004cb586 - 0x401000
.globl FUN_004cb586
FUN_004cb586:
    # block 0x004cb586: entry, 17 instruction(s), ends with je to 0x004cb5d9 (forward)
    push ebp                                     # 004cb586
    {load} mov ebp, esp                          # 004cb587
    sub esp, 0x24                                # 004cb589
    push esi                                     # 004cb58c
    push edi                                     # 004cb58d
    mov dword ptr [ebp - local_c], ecx           # 004cb58e
    movsx eax, word ptr [ebp + arg_8]            # 004cb591
    imul eax, eax, 0x8d                          # 004cb595
    mov ecx, dword ptr [ebp - local_c]           # 004cb59b
    mov edx, dword ptr [eax + 0x5bb5e5]          # 004cb59e
    mov dword ptr [ecx + field_16], edx          # 004cb5a4
    movsx eax, word ptr [ebp + arg_8]            # 004cb5a7
    imul eax, eax, 0x8d                          # 004cb5ab
    mov ecx, dword ptr [eax + 0x5bb632]          # 004cb5b1
    mov dword ptr [ebp - local_10], ecx          # 004cb5b7
    cmp dword ptr [ebp - local_10], 0x0          # 004cb5ba
    je.d8 L_004cb5d9                             # 004cb5be
    # block 0x004cb5c0: entered by fall-through of je at 0x004cb5be, 2 instruction(s), ends with je to 0x004cb7ff (forward)
    cmp dword ptr [ebp - local_10], 0x1          # 004cb5c0
    je.d32 L_004cb7ff                            # 004cb5c4
    # block 0x004cb5ca: entered by fall-through of je at 0x004cb5c4, 2 instruction(s), ends with je to 0x004cb8a7 (forward)
    cmp dword ptr [ebp - local_10], 0x2          # 004cb5ca
    je.d32 L_004cb8a7                            # 004cb5ce
    # block 0x004cb5d4: entered by fall-through of je at 0x004cb5ce, 1 instruction(s), ends with forward jump to 0x004cb8cd
    jmp.d32 L_004cb8cd                           # 004cb5d4
L_004cb5d9:
    # block 0x004cb5d9: entered by je at 0x004cb5be, 3 instruction(s), ends with jne to 0x004cb5f1 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004cb5d9
    cmp dword ptr [edx + field_1a], 0x0          # 004cb5dc
    jne.d8 L_004cb5f1                            # 004cb5e0
    # block 0x004cb5e2: entered by fall-through of jne at 0x004cb5e0, 5 instruction(s), calls FUN_004cbba9, falls into the block at 0x004cb5f1
    mov eax, dword ptr [ebp - local_c]           # 004cb5e2
    mov ecx, dword ptr [eax + field_16]          # 004cb5e5
    push ecx                                     # 004cb5e8
    mov ecx, dword ptr [ebp - local_c]           # 004cb5e9
    call FUN_004cbba9                            # 004cb5ec
L_004cb5f1:
    # block 0x004cb5f1: entered by jne at 0x004cb5e0, 5 instruction(s), calls FUN_004c0c2c, ends with je to 0x004cb609 (forward)
    mov ecx, 0x637fcf                            # 004cb5f1
    call FUN_004c0c2c                            # 004cb5f6
    mov dword ptr [ebp - local_4], eax           # 004cb5fb
    cmp dword ptr [ebp - local_4], 0x2           # 004cb5fe
    je.d8 L_004cb609                             # 004cb602
    # block 0x004cb604: entered by fall-through of je at 0x004cb602, 1 instruction(s), ends with forward jump to 0x004cb8cd
    jmp.d32 L_004cb8cd                           # 004cb604
L_004cb609:
    # block 0x004cb609: entered by je at 0x004cb602, 6 instruction(s), calls FUN_004c0c18, falls into the block at 0x004cb61f
    mov ecx, 0x637fcf                            # 004cb609
    call FUN_004c0c18                            # 004cb60e
    mov dword ptr [ebp - local_14], eax          # 004cb613
    mov edx, dword ptr [ebp - local_c]           # 004cb616
    mov eax, dword ptr [edx + field_1a]          # 004cb619
    mov dword ptr [ebp - local_18], eax          # 004cb61c
L_004cb61f:
    # block 0x004cb61f: entered by jne at 0x004cb651, 6 instruction(s), ends with jne to 0x004cb65c (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004cb61f
    mov dl, byte ptr [ecx]                       # 004cb622
    mov byte ptr [ebp - local_19], dl            # 004cb624
    mov eax, dword ptr [ebp - local_14]          # 004cb627
    cmp dl, byte ptr [eax]                       # 004cb62a
    jne.d8 L_004cb65c                            # 004cb62c
    # block 0x004cb62e: entered by fall-through of jne at 0x004cb62c, 2 instruction(s), ends with je to 0x004cb653 (forward)
    cmp byte ptr [ebp - local_19], 0x0           # 004cb62e
    je.d8 L_004cb653                             # 004cb632
    # block 0x004cb634: entered by fall-through of je at 0x004cb632, 6 instruction(s), ends with jne to 0x004cb65c (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004cb634
    mov dl, byte ptr [ecx + field_1]             # 004cb637
    mov byte ptr [ebp - local_1a], dl            # 004cb63a
    mov eax, dword ptr [ebp - local_14]          # 004cb63d
    cmp dl, byte ptr [eax + field_1]             # 004cb640
    jne.d8 L_004cb65c                            # 004cb643
    # block 0x004cb645: entered by fall-through of jne at 0x004cb643, 4 instruction(s), ends with jne to 0x004cb61f (backward)
    add dword ptr [ebp - local_18], 0x2          # 004cb645
    add dword ptr [ebp - local_14], 0x2          # 004cb649
    cmp byte ptr [ebp - local_1a], 0x0           # 004cb64d
    jne.d8 L_004cb61f                            # 004cb651
L_004cb653:
    # block 0x004cb653: entered by je at 0x004cb632; fall-through of jne at 0x004cb651, 2 instruction(s), ends with forward jump to 0x004cb664
    mov dword ptr [ebp - local_20], 0x0          # 004cb653
    jmp.d8 L_004cb664                            # 004cb65a
L_004cb65c:
    # block 0x004cb65c: entered by jne at 0x004cb62c; jne at 0x004cb643, 3 instruction(s), falls into the block at 0x004cb664
    {load} sbb ecx, ecx                          # 004cb65c
    sbb ecx, -0x1                                # 004cb65e
    mov dword ptr [ebp - local_20], ecx          # 004cb661
L_004cb664:
    # block 0x004cb664: entered by jmp at 0x004cb65a, 4 instruction(s), ends with je to 0x004cb675 (forward)
    mov edx, dword ptr [ebp - local_20]          # 004cb664
    mov dword ptr [ebp - local_24], edx          # 004cb667
    cmp dword ptr [ebp - local_24], 0x0          # 004cb66a
    je.d8 L_004cb675                             # 004cb66e
    # block 0x004cb670: entered by fall-through of je at 0x004cb66e, 1 instruction(s), ends with forward jump to 0x004cb8cd
    jmp.d32 L_004cb8cd                           # 004cb670
L_004cb675:
    # block 0x004cb675: entered by je at 0x004cb66e, 7 instruction(s), ends with je to 0x004cb76f (forward)
    mov eax, dword ptr [ebp - local_c]           # 004cb675
    mov word ptr [eax + field_c], 0xffff         # 004cb678
    mov ecx, dword ptr [ebp - local_c]           # 004cb67e
    mov edx, dword ptr [ecx + field_16]          # 004cb681
    movsx eax, word ptr [edx + field_21]         # 004cb684
    test eax, eax                                # 004cb688
    je.d32 L_004cb76f                            # 004cb68a
    # block 0x004cb690: entered by fall-through of je at 0x004cb68a, 54 instruction(s), calls FUN_004d39f9, falls into the block at 0x004cb76f
    call FUN_004d39f9                            # 004cb690
    mov ecx, dword ptr [ebp - local_c]           # 004cb695
    mov word ptr [ecx + field_c], ax             # 004cb698
    mov edx, dword ptr [ebp - local_c]           # 004cb69c
    movsx eax, word ptr [edx + field_c]          # 004cb69f
    imul eax, eax, 0x4a                          # 004cb6a3
    mov dword ptr [eax + 0x5d1591], 0xf          # 004cb6a6
    mov ecx, dword ptr [ebp - local_c]           # 004cb6b0
    movsx edx, word ptr [ecx + field_c]          # 004cb6b3
    imul edx, edx, 0x4a                          # 004cb6b7
    mov dword ptr [edx + 0x5d1595], 0x4cc79a     # 004cb6ba
    mov eax, dword ptr [ebp - local_c]           # 004cb6c4
    movsx ecx, word ptr [eax + field_c]          # 004cb6c7
    imul ecx, ecx, 0x4a                          # 004cb6cb
    mov dword ptr [ecx + 0x5d1599], 0x0          # 004cb6ce
    mov edx, dword ptr [ebp - local_c]           # 004cb6d8
    movsx eax, word ptr [edx + field_c]          # 004cb6db
    imul eax, eax, 0x4a                          # 004cb6df
    mov dword ptr [eax + 0x5d159d], 0x0          # 004cb6e2
    mov ecx, dword ptr [ebp - local_c]           # 004cb6ec
    movsx edx, word ptr [ecx + field_c]          # 004cb6ef
    imul edx, edx, 0x4a                          # 004cb6f3
    mov dword ptr [edx + 0x5d15a1], 0x0          # 004cb6f6
    mov eax, dword ptr [ebp - local_c]           # 004cb700
    movsx ecx, word ptr [eax + field_c]          # 004cb703
    imul ecx, ecx, 0x4a                          # 004cb707
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 004cb70a
    mov edx, dword ptr [ebp - local_c]           # 004cb714
    movsx eax, word ptr [edx + field_c]          # 004cb717
    imul eax, eax, 0x4a                          # 004cb71b
    mov dword ptr [eax + 0x5d15a9], 0x1          # 004cb71e
    mov ecx, dword ptr [ebp - local_c]           # 004cb728
    movsx edx, word ptr [ecx + field_c]          # 004cb72b
    imul edx, edx, 0x4a                          # 004cb72f
    mov word ptr [edx + 0x5d15ad], 0x0           # 004cb732
    mov edi, 0x558c30                            # 004cb73b
    mov eax, dword ptr [ebp - local_c]           # 004cb740
    movsx ecx, word ptr [eax + field_c]          # 004cb743
    imul ecx, ecx, 0x4a                          # 004cb747
    add ecx, 0x5d15b3                            # 004cb74a
    {load} mov edx, ecx                          # 004cb750
    or ecx, -0x1                                 # 004cb752
    {load} xor eax, eax                          # 004cb755
    repne scasb al, byte ptr es:[edi]            # 004cb757
    not ecx                                      # 004cb759
    {load} sub edi, ecx                          # 004cb75b
    {load} mov esi, edi                          # 004cb75d
    {load} mov eax, ecx                          # 004cb75f
    {load} mov edi, edx                          # 004cb761
    shr ecx, 0x2                                 # 004cb763
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004cb766
    {load} mov ecx, eax                          # 004cb768
    and ecx, 0x3                                 # 004cb76a
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004cb76d
L_004cb76f:
    # block 0x004cb76f: entered by je at 0x004cb68a, 3 instruction(s), ends with je to 0x004cb78d (forward)
    movsx ecx, word ptr [0x583a29]               # 004cb76f
    cmp ecx, -0x1                                # 004cb776
    je.d8 L_004cb78d                             # 004cb779
    # block 0x004cb77b: entered by fall-through of je at 0x004cb779, 4 instruction(s), ends with forward jump to 0x004cb799
    mov edx, dword ptr [ebp - local_c]           # 004cb77b
    mov ax, word ptr [0x583a29]                  # 004cb77e
    mov word ptr [edx + field_152], ax           # 004cb784
    jmp.d8 L_004cb799                            # 004cb78b
L_004cb78d:
    # block 0x004cb78d: entered by je at 0x004cb779, 2 instruction(s), falls into the block at 0x004cb799
    mov ecx, dword ptr [ebp - local_c]           # 004cb78d
    mov word ptr [ecx + field_152], 0xffff       # 004cb790
L_004cb799:
    # block 0x004cb799: entered by jmp at 0x004cb78b, 17 instruction(s), falls into the block at 0x004cb7ff
    mov edx, dword ptr [ebp - local_c]           # 004cb799
    mov dword ptr [edx + field_14a], 0xffffffff  # 004cb79c
    mov eax, dword ptr [ebp - local_c]           # 004cb7a6
    mov dword ptr [eax + field_8], 0x0           # 004cb7a9
    mov ecx, dword ptr [ebp - local_c]           # 004cb7b0
    mov dword ptr [ecx + field_12], 0x0          # 004cb7b3
    mov edx, dword ptr [ebp - local_c]           # 004cb7ba
    mov dword ptr [edx + field_154], 0x0         # 004cb7bd
    mov eax, dword ptr [ebp - local_c]           # 004cb7c7
    mov dword ptr [eax + field_14e], 0x0         # 004cb7ca
    mov ecx, dword ptr [ebp - local_c]           # 004cb7d4
    mov dword ptr [ecx + field_e], 0x1           # 004cb7d7
    mov edx, dword ptr [ebp - local_c]           # 004cb7de
    mov dword ptr [edx + field_15c], 0x0         # 004cb7e1
    movsx eax, word ptr [ebp + arg_8]            # 004cb7eb
    imul eax, eax, 0x8d                          # 004cb7ef
    mov dword ptr [eax + 0x5bb632], 0x1          # 004cb7f5
L_004cb7ff:
    # block 0x004cb7ff: entered by je at 0x004cb5c4, 9 instruction(s), calls FUN_004c0c2c, ends with je to 0x004cb845 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004cb7ff
    mov dword ptr [ecx + field_8], 0x0           # 004cb802
    mov edx, dword ptr [ebp - local_c]           # 004cb809
    mov dword ptr [edx + field_12], 0x0          # 004cb80c
    mov ecx, 0x637fcf                            # 004cb813
    call FUN_004c0c2c                            # 004cb818
    mov dword ptr [ebp - local_4], eax           # 004cb81d
    cmp dword ptr [ebp - local_4], 0x2           # 004cb820
    je.d8 L_004cb845                             # 004cb824
    # block 0x004cb826: entered by fall-through of je at 0x004cb824, 2 instruction(s), ends with je to 0x004cb845 (forward)
    cmp dword ptr [ebp - local_4], 0x3           # 004cb826
    je.d8 L_004cb845                             # 004cb82a
    # block 0x004cb82c: entered by fall-through of je at 0x004cb82a, 4 instruction(s), ends with forward jump to 0x004cb8cd
    movsx eax, word ptr [ebp + arg_8]            # 004cb82c
    imul eax, eax, 0x8d                          # 004cb830
    mov dword ptr [eax + 0x5bb632], 0x2          # 004cb836
    jmp.d32 L_004cb8cd                           # 004cb840
L_004cb845:
    # block 0x004cb845: entered by je at 0x004cb824; je at 0x004cb82a, 2 instruction(s), ends with jne to 0x004cb8a5 (forward)
    cmp dword ptr [ebp - local_4], 0x2           # 004cb845
    jne.d8 L_004cb8a5                            # 004cb849
    # block 0x004cb84b: entered by fall-through of jne at 0x004cb849, 5 instruction(s), calls FUN_004c0c54, ends with je to 0x004cb8a5 (forward)
    mov ecx, 0x637fcf                            # 004cb84b
    call FUN_004c0c54                            # 004cb850
    mov dword ptr [ebp - local_8], eax           # 004cb855
    cmp dword ptr [ebp - local_8], -0x1          # 004cb858
    je.d8 L_004cb8a5                             # 004cb85c
    # block 0x004cb85e: entered by fall-through of je at 0x004cb85c, 9 instruction(s), calls FUN_004cb944, ends with je to 0x004cb8a5 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004cb85e
    push ecx                                     # 004cb861
    mov ecx, dword ptr [ebp - local_c]           # 004cb862
    call FUN_004cb944                            # 004cb865
    mov edx, dword ptr [ebp - local_c]           # 004cb86a
    mov dword ptr [edx + field_12], eax          # 004cb86d
    mov eax, dword ptr [ebp - local_c]           # 004cb870
    cmp dword ptr [eax + field_12], 0x0          # 004cb873
    je.d8 L_004cb8a5                             # 004cb877
    # block 0x004cb879: entered by fall-through of je at 0x004cb877, 4 instruction(s), ends with je to 0x004cb8a5 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004cb879
    mov edx, dword ptr [ebp - local_8]           # 004cb87c
    cmp edx, dword ptr [ecx + field_14a]         # 004cb87f
    je.d8 L_004cb8a5                             # 004cb885
    # block 0x004cb887: entered by fall-through of je at 0x004cb885, 7 instruction(s), calls FUN_004cb9d1, falls into the block at 0x004cb8a5
    mov ecx, dword ptr [ebp - local_c]           # 004cb887
    call FUN_004cb9d1                            # 004cb88a
    mov eax, dword ptr [ebp - local_c]           # 004cb88f
    mov dword ptr [eax + field_8], 0x1           # 004cb892
    mov ecx, dword ptr [ebp - local_c]           # 004cb899
    mov edx, dword ptr [ebp - local_8]           # 004cb89c
    mov dword ptr [ecx + field_14a], edx         # 004cb89f
L_004cb8a5:
    # block 0x004cb8a5: entered by jne at 0x004cb849; je at 0x004cb85c; je at 0x004cb877; je at 0x004cb885, 1 instruction(s), ends with forward jump to 0x004cb8cd
    jmp.d8 L_004cb8cd                            # 004cb8a5
L_004cb8a7:
    # block 0x004cb8a7: entered by je at 0x004cb5ce, 9 instruction(s), calls FUN_004caf8a, FUN_0042ba3a, falls into the block at 0x004cb8cd
    movsx eax, word ptr [ebp + arg_8]            # 004cb8a7
    imul eax, eax, 0x8d                          # 004cb8ab
    mov byte ptr [eax + 0x5bb625], 0x1           # 004cb8b1
    mov ecx, dword ptr [ebp - local_c]           # 004cb8b8
    call FUN_004caf8a                            # 004cb8bb
    mov cx, word ptr [ebp + arg_8]               # 004cb8c0
    push ecx                                     # 004cb8c4
    call FUN_0042ba3a                            # 004cb8c5
    add esp, 0x4                                 # 004cb8ca
L_004cb8cd:
    # block 0x004cb8cd: entered by jmp at 0x004cb5d4; jmp at 0x004cb604; jmp at 0x004cb670; jmp at 0x004cb840; more, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004cb8cd
    pop esi                                      # 004cb8ce
    {load} mov esp, ebp                          # 004cb8cf
    pop ebp                                      # 004cb8d1
    ret 0x4                                      # 004cb8d2

