# FUN_004e26fc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e26fc
# extent:       0x004e26fc-0x004e2913 (535 code bytes)
# span:         0x004e26fc-0x004e2913 (code 535, tables 0, padding 0)
# sha256:       39ab172bb9e0efc573705f5647d7bd4ef4c8c86cebc8515edc26b3db890cc2c7
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e26fc
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_c, field_20, field_30, field_7a, field_17f, field_183; [ecx + n] field_4, field_10, field_18, field_2c, field_30, field_f2, field_117, field_17b, field_183; [edi + n] field_minus_1; [edx + n] field_8, field_20, field_2c, field_30, field_f2, field_117, field_17f
# callees:      calls KERNEL32.dll!GetTickCount, FUN_004fb77a, FUN_004fb2e3, FUN_0050ca3e, FUN_0044a2b7, FUN_00427a40
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 146 instruction(s), 19 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_18, 0x18  # offset +0x18
.equ field_20, 0x20  # offset +0x20
.equ field_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30
.equ field_7a, 0x7a  # offset +0x7a
.equ field_f2, 0xf2  # offset +0xf2
.equ field_117, 0x117  # offset +0x117
.equ field_17b, 0x17b  # offset +0x17b
.equ field_17f, 0x17f  # offset +0x17f
.equ field_183, 0x183  # offset +0x183

# --- external targets -----------------------------------------------
.set FUN_00427a40, .text + (0x00427a40 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004e26fc - 0x401000
.globl FUN_004e26fc
FUN_004e26fc:
    # block 0x004e26fc: entry, 8 instruction(s), ends with jne to 0x004e2716 (forward)
    push ebp                                     # 004e26fc
    {load} mov ebp, esp                          # 004e26fd
    sub esp, 0xc                                 # 004e26ff
    push edi                                     # 004e2702
    mov dword ptr [ebp - local_4], ecx           # 004e2703
    mov eax, dword ptr [ebp - local_4]           # 004e2706
    cmp dword ptr [eax + field_30], 0x4          # 004e2709
    jne.d8 L_004e2716                            # 004e270d
    # block 0x004e270f: entered by fall-through of jne at 0x004e270d, 2 instruction(s), ends with forward jump to 0x004e290e
    {load} xor eax, eax                          # 004e270f
    jmp.d32 L_004e290e                           # 004e2711
L_004e2716:
    # block 0x004e2716: entered by jne at 0x004e270d, 5 instruction(s), ends with je to 0x004e2734 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e2716
    mov edx, dword ptr [ecx + field_18]          # 004e2719
    mov dword ptr [ebp - local_8], edx           # 004e271c
    cmp dword ptr [ebp - local_8], 0x0           # 004e271f
    je.d8 L_004e2734                             # 004e2723
    # block 0x004e2725: entered by fall-through of je at 0x004e2723, 2 instruction(s), ends with je to 0x004e2871 (forward)
    cmp dword ptr [ebp - local_8], 0x1           # 004e2725
    je.d32 L_004e2871                            # 004e2729
    # block 0x004e272f: entered by fall-through of je at 0x004e2729, 1 instruction(s), ends with forward jump to 0x004e290c
    jmp.d32 L_004e290c                           # 004e272f
L_004e2734:
    # block 0x004e2734: entered by je at 0x004e2723, 3 instruction(s), ends with je to 0x004e284d (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e2734
    cmp dword ptr [eax + field_183], 0x0         # 004e2737
    je.d32 L_004e284d                            # 004e273e
    # block 0x004e2744: entered by fall-through of je at 0x004e273e, 3 instruction(s), ends with jne to 0x004e284d (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e2744
    cmp dword ptr [ecx + field_17b], 0x0         # 004e2747
    jne.d32 L_004e284d                           # 004e274e
    # block 0x004e2754: entered by fall-through of jne at 0x004e274e, 3 instruction(s), ends with je to 0x004e276a (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e2754
    cmp dword ptr [edx + field_30], 0x0          # 004e2757
    je.d8 L_004e276a                             # 004e275b
    # block 0x004e275d: entered by fall-through of je at 0x004e275b, 3 instruction(s), ends with jne to 0x004e284d (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e275d
    cmp dword ptr [eax + field_30], 0x1          # 004e2760
    jne.d32 L_004e284d                           # 004e2764
L_004e276a:
    # block 0x004e276a: entered by je at 0x004e275b; fall-through of jne at 0x004e2764, 10 instruction(s), calls KERNEL32.dll!GetTickCount, ends with je to 0x004e27bd (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e276a
    mov dword ptr [ecx + field_30], 0x2          # 004e276d
    call dword ptr [0x52a23c]                    # 004e2774
    mov edx, dword ptr [ebp - local_4]           # 004e277a
    add eax, dword ptr [edx + field_f2]          # 004e277d
    mov ecx, dword ptr [ebp - local_4]           # 004e2783
    mov dword ptr [ecx + field_2c], eax          # 004e2786
    mov edx, dword ptr [ebp - local_4]           # 004e2789
    cmp dword ptr [edx + field_17f], 0x0         # 004e278c
    je.d8 L_004e27bd                             # 004e2793
    # block 0x004e2795: entered by fall-through of je at 0x004e2793, 10 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, falls into the block at 0x004e27bd
    mov eax, dword ptr [ebp - local_4]           # 004e2795
    add eax, 0xf6                                # 004e2798
    push eax                                     # 004e279d
    mov ecx, 0x5c3a67                            # 004e279e
    call FUN_004fb77a                            # 004e27a3
    mov ecx, dword ptr [ebp - local_4]           # 004e27a8
    mov dx, word ptr [ecx + field_117]           # 004e27ab
    push edx                                     # 004e27b2
    mov ecx, 0x5c3a67                            # 004e27b3
    call FUN_004fb2e3                            # 004e27b8
L_004e27bd:
    # block 0x004e27bd: entered by je at 0x004e2793, 3 instruction(s), ends with je to 0x004e2843 (forward)
    movsx eax, word ptr [0x63a4cd]               # 004e27bd
    test eax, eax                                # 004e27c4
    je.d8 L_004e2843                             # 004e27c6
    # block 0x004e27c8: entered by fall-through of je at 0x004e27c6, 31 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, ends with je to 0x004e2833 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e27c8
    mov edx, dword ptr [ecx + field_10]          # 004e27cb
    push edx                                     # 004e27ce
    mov eax, dword ptr [ebp - local_4]           # 004e27cf
    mov ecx, dword ptr [eax + field_c]           # 004e27d2
    push ecx                                     # 004e27d5
    mov edx, dword ptr [ebp - local_4]           # 004e27d6
    mov eax, dword ptr [edx + field_8]           # 004e27d9
    push eax                                     # 004e27dc
    mov ecx, dword ptr [ebp - local_4]           # 004e27dd
    mov edx, dword ptr [ecx + field_4]           # 004e27e0
    push edx                                     # 004e27e3
    mov eax, dword ptr [ebp - local_4]           # 004e27e4
    mov ecx, dword ptr [eax + field_7a]          # 004e27e7
    push ecx                                     # 004e27ea
    push 0x55bf20                                # 004e27eb
    push 0x63888b                                # 004e27f0
    call FUN_0050ca3e                            # 004e27f5
    add esp, 0x1c                                # 004e27fa
    push 0x63888b                                # 004e27fd
    call FUN_0044a2b7                            # 004e2802
    add esp, 0x4                                 # 004e2807
    mov edi, 0x63888b                            # 004e280a
    or ecx, -0x1                                 # 004e280f
    {load} xor eax, eax                          # 004e2812
    repne scasb al, byte ptr es:[edi]            # 004e2814
    mov dx, word ptr [0x55bf84]                  # 004e2816
    mov word ptr [edi - field_minus_1], dx       # 004e281d
    mov eax, 0x1                                 # 004e2821
    test eax, eax                                # 004e2826
    je.d8 L_004e2833                             # 004e2828
    # block 0x004e282a: entered by fall-through of je at 0x004e2828, 2 instruction(s), ends with forward jump to 0x004e2843
    mov dword ptr [ebp - local_c], 0x0           # 004e282a
    jmp.d8 L_004e2843                            # 004e2831
L_004e2833:
    # block 0x004e2833: entered by je at 0x004e2828, 4 instruction(s), calls FUN_00427a40, falls into the block at 0x004e2843
    push 0x63888b                                # 004e2833
    call FUN_00427a40                            # 004e2838
    add esp, 0x4                                 # 004e283d
    mov dword ptr [ebp - local_c], eax           # 004e2840
L_004e2843:
    # block 0x004e2843: entered by je at 0x004e27c6; jmp at 0x004e2831, 2 instruction(s), ends with forward jump to 0x004e290e
    mov eax, 0x1                                 # 004e2843
    jmp.d32 L_004e290e                           # 004e2848
L_004e284d:
    # block 0x004e284d: entered by je at 0x004e273e; jne at 0x004e274e; jne at 0x004e2764, 3 instruction(s), ends with je to 0x004e286c (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e284d
    cmp dword ptr [ecx + field_183], 0x0         # 004e2850
    je.d8 L_004e286c                             # 004e2857
    # block 0x004e2859: entered by fall-through of je at 0x004e2857, 3 instruction(s), ends with jne to 0x004e286c (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e2859
    cmp dword ptr [edx + field_30], 0x3          # 004e285c
    jne.d8 L_004e286c                            # 004e2860
    # block 0x004e2862: entered by fall-through of jne at 0x004e2860, 2 instruction(s), ends with forward jump to 0x004e290e
    mov eax, 0x1                                 # 004e2862
    jmp.d32 L_004e290e                           # 004e2867
L_004e286c:
    # block 0x004e286c: entered by je at 0x004e2857; jne at 0x004e2860, 1 instruction(s), ends with forward jump to 0x004e290c
    jmp.d32 L_004e290c                           # 004e286c
L_004e2871:
    # block 0x004e2871: entered by je at 0x004e2729, 3 instruction(s), ends with je to 0x004e290c (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e2871
    cmp dword ptr [eax + field_183], 0x0         # 004e2874
    je.d32 L_004e290c                            # 004e287b
    # block 0x004e2881: entered by fall-through of je at 0x004e287b, 3 instruction(s), ends with jne to 0x004e290c (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e2881
    cmp dword ptr [ecx + field_17b], 0x0         # 004e2884
    jne.d8 L_004e290c                            # 004e288b
    # block 0x004e288d: entered by fall-through of jne at 0x004e288b, 3 instruction(s), ends with jne to 0x004e290c (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e288d
    cmp dword ptr [edx + field_20], 0x0          # 004e2890
    jne.d8 L_004e290c                            # 004e2894
    # block 0x004e2896: entered by fall-through of jne at 0x004e2894, 3 instruction(s), ends with je to 0x004e28b1 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e2896
    cmp dword ptr [eax + field_30], 0x0          # 004e2899
    je.d8 L_004e28b1                             # 004e289d
    # block 0x004e289f: entered by fall-through of je at 0x004e289d, 3 instruction(s), ends with je to 0x004e28b1 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e289f
    cmp dword ptr [ecx + field_30], 0x1          # 004e28a2
    je.d8 L_004e28b1                             # 004e28a6
    # block 0x004e28a8: entered by fall-through of je at 0x004e28a6, 3 instruction(s), ends with jne to 0x004e290c (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e28a8
    cmp dword ptr [edx + field_30], 0x2          # 004e28ab
    jne.d8 L_004e290c                            # 004e28af
L_004e28b1:
    # block 0x004e28b1: entered by je at 0x004e289d; je at 0x004e28a6; fall-through of jne at 0x004e28af, 10 instruction(s), calls KERNEL32.dll!GetTickCount, ends with je to 0x004e2905 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e28b1
    mov dword ptr [eax + field_20], 0x1          # 004e28b4
    call dword ptr [0x52a23c]                    # 004e28bb
    mov ecx, dword ptr [ebp - local_4]           # 004e28c1
    add eax, dword ptr [ecx + field_f2]          # 004e28c4
    mov edx, dword ptr [ebp - local_4]           # 004e28ca
    mov dword ptr [edx + field_2c], eax          # 004e28cd
    mov eax, dword ptr [ebp - local_4]           # 004e28d0
    cmp dword ptr [eax + field_17f], 0x0         # 004e28d3
    je.d8 L_004e2905                             # 004e28da
    # block 0x004e28dc: entered by fall-through of je at 0x004e28da, 10 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, falls into the block at 0x004e2905
    mov ecx, dword ptr [ebp - local_4]           # 004e28dc
    add ecx, 0xf6                                # 004e28df
    push ecx                                     # 004e28e5
    mov ecx, 0x5c3a67                            # 004e28e6
    call FUN_004fb77a                            # 004e28eb
    mov edx, dword ptr [ebp - local_4]           # 004e28f0
    mov ax, word ptr [edx + field_117]           # 004e28f3
    push eax                                     # 004e28fa
    mov ecx, 0x5c3a67                            # 004e28fb
    call FUN_004fb2e3                            # 004e2900
L_004e2905:
    # block 0x004e2905: entered by je at 0x004e28da, 2 instruction(s), ends with forward jump to 0x004e290e
    mov eax, 0x1                                 # 004e2905
    jmp.d8 L_004e290e                            # 004e290a
L_004e290c:
    # block 0x004e290c: entered by jmp at 0x004e272f; jmp at 0x004e286c; je at 0x004e287b; jne at 0x004e288b; more, 1 instruction(s), falls into the block at 0x004e290e
    {load} xor eax, eax                          # 004e290c
L_004e290e:
    # block 0x004e290e: entered by jmp at 0x004e2711; jmp at 0x004e2848; jmp at 0x004e2867; jmp at 0x004e290a, 4 instruction(s), ends with ret
    pop edi                                      # 004e290e
    {load} mov esp, ebp                          # 004e290f
    pop ebp                                      # 004e2911
    ret                                          # 004e2912

