# FUN_004416a2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004416a2
# extent:       0x004416a2-0x00441931 (655 code bytes)
# span:         0x004416a2-0x00441931 (code 655, tables 0, padding 0)
# sha256:       c6d52ce4c3e5f32c6240df092ea2cd45b5aa7a181af743972f6e8dec46acdfef
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004416a2
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       13 ebp-relative slot(s): local_5, local_6, local_8, local_c, local_10, local_14, local_16, local_18, local_1a, local_1c, local_3e, local_1ce and 1 more
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0043f210, FUN_0041fa11
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 162 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_5, 0x5  # offset -0x5
.equ local_6, 0x6  # offset -0x6
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_16, 0x16  # offset -0x16
.equ local_18, 0x18  # offset -0x18
.equ local_1a, 0x1a  # offset -0x1a
.equ local_1c, 0x1c  # offset -0x1c
.equ local_3e, 0x3e  # offset -0x3e
.equ local_1ce, 0x1ce  # offset -0x1ce
.equ local_1d4, 0x1d4  # offset -0x1d4

# --- external targets -----------------------------------------------
.set FUN_0041fa11, .text + (0x0041fa11 - 0x401000)
.set FUN_0043f210, .text + (0x0043f210 - 0x401000)

.org 0x004416a2 - 0x401000
.globl FUN_004416a2
FUN_004416a2:
    # block 0x004416a2: entry, 7 instruction(s), ends with jne to 0x00441753 (forward)
    push ebp                                     # 004416a2
    {load} mov ebp, esp                          # 004416a3
    sub esp, 0x1d4                               # 004416a5
    push esi                                     # 004416ab
    push edi                                     # 004416ac
    cmp dword ptr [0x58759d], 0x1                # 004416ad
    jne.d32 L_00441753                           # 004416b4
    # block 0x004416ba: entered by fall-through of jne at 0x004416b4, 2 instruction(s), ends with jne to 0x00441753 (forward)
    cmp dword ptr [0x5869ad], 0x0                # 004416ba
    jne.d32 L_00441753                           # 004416c1
    # block 0x004416c7: entered by fall-through of jne at 0x004416c1, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00441753
    push 0x547c18                                # 004416c7
    push 0x63a6c4                                # 004416cc
    lea eax, [ebp - local_1ce]                   # 004416d1
    push eax                                     # 004416d7
    call FUN_0043f210                            # 004416d8
    add esp, 0xc                                 # 004416dd
    mov edi, 0x547c20                            # 004416e0
    lea edx, [ebp - local_3e]                    # 004416e5
    or ecx, -0x1                                 # 004416e8
    {load} xor eax, eax                          # 004416eb
    repne scasb al, byte ptr es:[edi]            # 004416ed
    not ecx                                      # 004416ef
    {load} sub edi, ecx                          # 004416f1
    {load} mov esi, edi                          # 004416f3
    {load} mov eax, ecx                          # 004416f5
    {load} mov edi, edx                          # 004416f7
    shr ecx, 0x2                                 # 004416f9
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004416fc
    {load} mov ecx, eax                          # 004416fe
    and ecx, 0x3                                 # 00441700
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00441703
    mov word ptr [ebp - local_1c], 0x5aa         # 00441705
    mov word ptr [ebp - local_1a], 0x0           # 0044170b
    mov word ptr [ebp - local_18], 0x0           # 00441711
    mov word ptr [ebp - local_16], 0x1           # 00441717
    mov word ptr [ebp - local_8], 0xffff         # 0044171d
    mov byte ptr [ebp - local_6], 0x0            # 00441723
    mov word ptr [ebp - local_5], 0x2            # 00441727
    mov dword ptr [ebp - local_14], 0x0          # 0044172d
    mov dword ptr [ebp - local_10], 0x0          # 00441734
    mov dword ptr [ebp - local_c], 0x1           # 0044173b
    lea ecx, [ebp - local_1d4]                   # 00441742
    push ecx                                     # 00441748
    mov ecx, 0x6177e8                            # 00441749
    call FUN_0041fa11                            # 0044174e
L_00441753:
    # block 0x00441753: entered by jne at 0x004416b4; jne at 0x004416c1, 2 instruction(s), ends with jne to 0x004417f9 (forward)
    cmp dword ptr [0x5875e5], 0x1                # 00441753
    jne.d32 L_004417f9                           # 0044175a
    # block 0x00441760: entered by fall-through of jne at 0x0044175a, 2 instruction(s), ends with jne to 0x004417f9 (forward)
    cmp dword ptr [0x5869b1], 0x0                # 00441760
    jne.d32 L_004417f9                           # 00441767
    # block 0x0044176d: entered by fall-through of jne at 0x00441767, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x004417f9
    push 0x547c28                                # 0044176d
    push 0x63a6c8                                # 00441772
    lea edx, [ebp - local_1ce]                   # 00441777
    push edx                                     # 0044177d
    call FUN_0043f210                            # 0044177e
    add esp, 0xc                                 # 00441783
    mov edi, 0x547c30                            # 00441786
    lea edx, [ebp - local_3e]                    # 0044178b
    or ecx, -0x1                                 # 0044178e
    {load} xor eax, eax                          # 00441791
    repne scasb al, byte ptr es:[edi]            # 00441793
    not ecx                                      # 00441795
    {load} sub edi, ecx                          # 00441797
    {load} mov esi, edi                          # 00441799
    {load} mov eax, ecx                          # 0044179b
    {load} mov edi, edx                          # 0044179d
    shr ecx, 0x2                                 # 0044179f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004417a2
    {load} mov ecx, eax                          # 004417a4
    and ecx, 0x3                                 # 004417a6
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004417a9
    mov word ptr [ebp - local_1c], 0x5ab         # 004417ab
    mov word ptr [ebp - local_1a], 0x0           # 004417b1
    mov word ptr [ebp - local_18], 0x0           # 004417b7
    mov word ptr [ebp - local_16], 0x1           # 004417bd
    mov word ptr [ebp - local_8], 0xffff         # 004417c3
    mov byte ptr [ebp - local_6], 0x0            # 004417c9
    mov word ptr [ebp - local_5], 0x2            # 004417cd
    mov dword ptr [ebp - local_14], 0x0          # 004417d3
    mov dword ptr [ebp - local_10], 0x0          # 004417da
    mov dword ptr [ebp - local_c], 0x1           # 004417e1
    lea ecx, [ebp - local_1d4]                   # 004417e8
    push ecx                                     # 004417ee
    mov ecx, 0x6177e8                            # 004417ef
    call FUN_0041fa11                            # 004417f4
L_004417f9:
    # block 0x004417f9: entered by jne at 0x0044175a; jne at 0x00441767, 2 instruction(s), ends with jne to 0x00441892 (forward)
    cmp dword ptr [0x5869a9], 0x0                # 004417f9
    jne.d32 L_00441892                           # 00441800
    # block 0x00441806: entered by fall-through of jne at 0x00441800, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x00441892
    push 0x547c38                                # 00441806
    push 0x63a6cc                                # 0044180b
    lea edx, [ebp - local_1ce]                   # 00441810
    push edx                                     # 00441816
    call FUN_0043f210                            # 00441817
    add esp, 0xc                                 # 0044181c
    mov edi, 0x547c40                            # 0044181f
    lea edx, [ebp - local_3e]                    # 00441824
    or ecx, -0x1                                 # 00441827
    {load} xor eax, eax                          # 0044182a
    repne scasb al, byte ptr es:[edi]            # 0044182c
    not ecx                                      # 0044182e
    {load} sub edi, ecx                          # 00441830
    {load} mov esi, edi                          # 00441832
    {load} mov eax, ecx                          # 00441834
    {load} mov edi, edx                          # 00441836
    shr ecx, 0x2                                 # 00441838
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044183b
    {load} mov ecx, eax                          # 0044183d
    and ecx, 0x3                                 # 0044183f
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00441842
    mov word ptr [ebp - local_1c], 0x5ae         # 00441844
    mov word ptr [ebp - local_1a], 0x0           # 0044184a
    mov word ptr [ebp - local_18], 0x0           # 00441850
    mov word ptr [ebp - local_16], 0x1           # 00441856
    mov word ptr [ebp - local_8], 0xffff         # 0044185c
    mov byte ptr [ebp - local_6], 0x0            # 00441862
    mov word ptr [ebp - local_5], 0x2            # 00441866
    mov dword ptr [ebp - local_14], 0x0          # 0044186c
    mov dword ptr [ebp - local_10], 0x0          # 00441873
    mov dword ptr [ebp - local_c], 0x1           # 0044187a
    lea ecx, [ebp - local_1d4]                   # 00441881
    push ecx                                     # 00441887
    mov ecx, 0x6177e8                            # 00441888
    call FUN_0041fa11                            # 0044188d
L_00441892:
    # block 0x00441892: entered by jne at 0x00441800, 2 instruction(s), ends with jne to 0x0044192b (forward)
    cmp dword ptr [0x5869b5], 0x0                # 00441892
    jne.d32 L_0044192b                           # 00441899
    # block 0x0044189f: entered by fall-through of jne at 0x00441899, 35 instruction(s), calls FUN_0043f210, FUN_0041fa11, falls into the block at 0x0044192b
    push 0x547c48                                # 0044189f
    push 0x63a6d0                                # 004418a4
    lea edx, [ebp - local_1ce]                   # 004418a9
    push edx                                     # 004418af
    call FUN_0043f210                            # 004418b0
    add esp, 0xc                                 # 004418b5
    mov edi, 0x547c50                            # 004418b8
    lea edx, [ebp - local_3e]                    # 004418bd
    or ecx, -0x1                                 # 004418c0
    {load} xor eax, eax                          # 004418c3
    repne scasb al, byte ptr es:[edi]            # 004418c5
    not ecx                                      # 004418c7
    {load} sub edi, ecx                          # 004418c9
    {load} mov esi, edi                          # 004418cb
    {load} mov eax, ecx                          # 004418cd
    {load} mov edi, edx                          # 004418cf
    shr ecx, 0x2                                 # 004418d1
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004418d4
    {load} mov ecx, eax                          # 004418d6
    and ecx, 0x3                                 # 004418d8
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004418db
    mov word ptr [ebp - local_1c], 0x5af         # 004418dd
    mov word ptr [ebp - local_1a], 0x0           # 004418e3
    mov word ptr [ebp - local_18], 0x0           # 004418e9
    mov word ptr [ebp - local_16], 0x1           # 004418ef
    mov word ptr [ebp - local_8], 0xffff         # 004418f5
    mov byte ptr [ebp - local_6], 0x0            # 004418fb
    mov word ptr [ebp - local_5], 0x2            # 004418ff
    mov dword ptr [ebp - local_14], 0x0          # 00441905
    mov dword ptr [ebp - local_10], 0x0          # 0044190c
    mov dword ptr [ebp - local_c], 0x1           # 00441913
    lea ecx, [ebp - local_1d4]                   # 0044191a
    push ecx                                     # 00441920
    mov ecx, 0x6177e8                            # 00441921
    call FUN_0041fa11                            # 00441926
L_0044192b:
    # block 0x0044192b: entered by jne at 0x00441899, 5 instruction(s), ends with ret
    pop edi                                      # 0044192b
    pop esi                                      # 0044192c
    {load} mov esp, ebp                          # 0044192d
    pop ebp                                      # 0044192f
    ret                                          # 00441930

