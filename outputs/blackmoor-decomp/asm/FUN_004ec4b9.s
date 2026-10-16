# FUN_004ec4b9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ec4b9
# extent:       0x004ec4b9-0x004ec9a2 (1257 code bytes)
# span:         0x004ec4b9-0x004ec9a2 (code 1257, tables 0, padding 0)
# sha256:       f02b011cf95ef86a288c2b62322f87e3e7401e0a08975f9bb885edadf3d12d2b
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ec4b9
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       17 ebp-relative slot(s): local_4, local_9c44, local_9c48, local_9c4c, local_9c50, local_9c54, local_9c58, local_9c5c, local_9c60, local_9c64, local_9c68, local_9c6c and 5 more
# fields:       [eax + n] field_4, field_8, field_c, field_b7f, field_fca, field_fde, field_fe6, field_28da, field_28dc, field_28e4, field_28ec; [ecx + n] field_b77, field_b85, field_28de, field_28e4; [edi + n] field_minus_1; [edx + n] field_b87, field_fde, field_fe6, field_28da, field_28e4, field_28ec, field_28f8
# callees:      calls FUN_0050c920, FUN_004ee69e, FUN_0050ce04, FUN_00423259, FUN_005193ca, FUN_00413187
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 265 instruction(s), 13 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_9c44, 0x9c44  # offset -0x9c44
.equ local_9c48, 0x9c48  # offset -0x9c48
.equ local_9c4c, 0x9c4c  # offset -0x9c4c
.equ local_9c50, 0x9c50  # offset -0x9c50
.equ local_9c54, 0x9c54  # offset -0x9c54
.equ local_9c58, 0x9c58  # offset -0x9c58
.equ local_9c5c, 0x9c5c  # offset -0x9c5c
.equ local_9c60, 0x9c60  # offset -0x9c60
.equ local_9c64, 0x9c64  # offset -0x9c64
.equ local_9c68, 0x9c68  # offset -0x9c68
.equ local_9c6c, 0x9c6c  # offset -0x9c6c
.equ local_9c70, 0x9c70  # offset -0x9c70
.equ local_9c74, 0x9c74  # offset -0x9c74
.equ local_9c78, 0x9c78  # offset -0x9c78
.equ local_9c7c, 0x9c7c  # offset -0x9c7c
.equ local_9c80, 0x9c80  # offset -0x9c80
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_b77, 0xb77  # offset +0xb77
.equ field_b7f, 0xb7f  # offset +0xb7f
.equ field_b85, 0xb85  # offset +0xb85
.equ field_b87, 0xb87  # offset +0xb87
.equ field_fca, 0xfca  # offset +0xfca
.equ field_fde, 0xfde  # offset +0xfde
.equ field_fe6, 0xfe6  # offset +0xfe6
.equ field_28da, 0x28da  # offset +0x28da
.equ field_28dc, 0x28dc  # offset +0x28dc
.equ field_28de, 0x28de  # offset +0x28de
.equ field_28e4, 0x28e4  # offset +0x28e4
.equ field_28ec, 0x28ec  # offset +0x28ec
.equ field_28f8, 0x28f8  # offset +0x28f8

# --- external targets -----------------------------------------------
.set FUN_00413187, .text + (0x00413187 - 0x401000)
.set FUN_00423259, .text + (0x00423259 - 0x401000)
.set FUN_004ee69e, .text + (0x004ee69e - 0x401000)
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)
.set FUN_005193ca, .text + (0x005193ca - 0x401000)

.org 0x004ec4b9 - 0x401000
.globl FUN_004ec4b9
FUN_004ec4b9:
    # block 0x004ec4b9: entry, 29 instruction(s), calls FUN_0050c920, FUN_004ee69e, ends with jne to 0x004ec551 (forward)
    push ebp                                     # 004ec4b9
    {load} mov ebp, esp                          # 004ec4ba
    mov eax, 0x9c80                              # 004ec4bc
    call FUN_0050c920                            # 004ec4c1
    push ebx                                     # 004ec4c6
    push esi                                     # 004ec4c7
    push edi                                     # 004ec4c8
    mov dword ptr [ebp - local_9c70], ecx        # 004ec4c9
    mov eax, dword ptr [ebp - local_9c70]        # 004ec4cf
    add eax, 0x28e0                              # 004ec4d5
    mov ecx, dword ptr [eax]                     # 004ec4da
    mov dword ptr [ebp - local_9c54], ecx        # 004ec4dc
    mov edx, dword ptr [eax + field_4]           # 004ec4e2
    mov dword ptr [ebp - local_9c50], edx        # 004ec4e5
    mov ecx, dword ptr [eax + field_8]           # 004ec4eb
    mov dword ptr [ebp - local_9c4c], ecx        # 004ec4ee
    mov edx, dword ptr [eax + field_c]           # 004ec4f4
    mov dword ptr [ebp - local_9c48], edx        # 004ec4f7
    mov ecx, dword ptr [ebp - local_9c70]        # 004ec4fd
    call FUN_004ee69e                            # 004ec503
    mov dword ptr [ebp - local_9c74], eax        # 004ec508
    fild dword ptr [ebp - local_9c74]            # 004ec50e
    fstp dword ptr [ebp - local_9c78]            # 004ec514
    fld dword ptr [ebp - local_9c78]             # 004ec51a
    fdiv dword ptr [0x52cbec]                    # 004ec520
    fstp dword ptr [ebp - local_9c68]            # 004ec526
    mov eax, dword ptr [ebp - local_9c70]        # 004ec52c
    cmp dword ptr [eax + field_fca], 0x1         # 004ec532
    jne.d8 L_004ec551                            # 004ec539
    # block 0x004ec53b: entered by fall-through of jne at 0x004ec539, 4 instruction(s), ends with forward jump to 0x004ec565
    mov ecx, dword ptr [ebp - local_9c70]        # 004ec53b
    mov dx, word ptr [ecx + field_28de]          # 004ec541
    mov word ptr [ebp - local_9c60], dx          # 004ec548
    jmp.d8 L_004ec565                            # 004ec54f
L_004ec551:
    # block 0x004ec551: entered by jne at 0x004ec539, 3 instruction(s), falls into the block at 0x004ec565
    mov eax, dword ptr [ebp - local_9c70]        # 004ec551
    mov cx, word ptr [eax + field_28dc]          # 004ec557
    mov word ptr [ebp - local_9c60], cx          # 004ec55e
L_004ec565:
    # block 0x004ec565: entered by jmp at 0x004ec54f, 18 instruction(s), calls FUN_0050ce04, ends with jle to 0x004ec5f7 (forward)
    movsx edx, word ptr [ebp - local_9c60]       # 004ec565
    mov dword ptr [ebp - local_9c7c], edx        # 004ec56c
    fild dword ptr [ebp - local_9c7c]            # 004ec572
    fstp dword ptr [ebp - local_9c80]            # 004ec578
    fld dword ptr [ebp - local_9c68]             # 004ec57e
    fmul dword ptr [ebp - local_9c80]            # 004ec584
    call FUN_0050ce04                            # 004ec58a
    mov ecx, dword ptr [ebp - local_9c70]        # 004ec58f
    mov dword ptr [ecx + field_28e4], eax        # 004ec595
    movsx edx, word ptr [ebp - local_9c60]       # 004ec59b
    mov eax, dword ptr [ebp - local_9c70]        # 004ec5a2
    mov ecx, dword ptr [ebp - local_9c70]        # 004ec5a8
    mov eax, dword ptr [eax + field_b7f]         # 004ec5ae
    sub eax, dword ptr [ecx + field_b77]         # 004ec5b4
    {load} sub edx, eax                          # 004ec5ba
    mov ecx, dword ptr [ebp - local_9c70]        # 004ec5bc
    cmp dword ptr [ecx + field_28e4], edx        # 004ec5c2
    jle.d8 L_004ec5f7                            # 004ec5c8
    # block 0x004ec5ca: entered by fall-through of jle at 0x004ec5c8, 8 instruction(s), falls into the block at 0x004ec5f7
    movsx edx, word ptr [ebp - local_9c60]       # 004ec5ca
    mov eax, dword ptr [ebp - local_9c70]        # 004ec5d1
    mov ecx, dword ptr [ebp - local_9c70]        # 004ec5d7
    mov eax, dword ptr [eax + field_b7f]         # 004ec5dd
    sub eax, dword ptr [ecx + field_b77]         # 004ec5e3
    {load} sub edx, eax                          # 004ec5e9
    mov ecx, dword ptr [ebp - local_9c70]        # 004ec5eb
    mov dword ptr [ecx + field_28e4], edx        # 004ec5f1
L_004ec5f7:
    # block 0x004ec5f7: entered by jle at 0x004ec5c8, 3 instruction(s), ends with jge to 0x004ec616 (forward)
    mov edx, dword ptr [ebp - local_9c70]        # 004ec5f7
    cmp dword ptr [edx + field_28e4], 0x0        # 004ec5fd
    jge.d8 L_004ec616                            # 004ec604
    # block 0x004ec606: entered by fall-through of jge at 0x004ec604, 2 instruction(s), falls into the block at 0x004ec616
    mov eax, dword ptr [ebp - local_9c70]        # 004ec606
    mov dword ptr [eax + field_28e4], 0x0        # 004ec60c
L_004ec616:
    # block 0x004ec616: entered by jge at 0x004ec604, 13 instruction(s), ends with je to 0x004ec99b (forward)
    mov ecx, dword ptr [ebp - local_9c70]        # 004ec616
    mov edx, dword ptr [ecx + field_28e4]        # 004ec61c
    mov eax, dword ptr [ebp - local_9c70]        # 004ec622
    add edx, dword ptr [eax + field_b7f]         # 004ec628
    mov ecx, dword ptr [ebp - local_9c70]        # 004ec62e
    sub edx, dword ptr [ecx + field_b77]         # 004ec634
    mov eax, dword ptr [ebp - local_9c70]        # 004ec63a
    mov dword ptr [eax + field_28ec], edx        # 004ec640
    mov ecx, dword ptr [ebp - local_9c70]        # 004ec646
    mov edx, dword ptr [ecx + field_28e4]        # 004ec64c
    sub edx, dword ptr [ebp - local_9c50]        # 004ec652
    test edx, edx                                # 004ec658
    je.d32 L_004ec99b                            # 004ec65a
    # block 0x004ec660: entered by fall-through of je at 0x004ec65a, 3 instruction(s), ends with jne to 0x004ec99b (forward)
    mov eax, dword ptr [ebp - local_9c70]        # 004ec660
    cmp dword ptr [eax + field_fca], 0x2         # 004ec666
    jne.d32 L_004ec99b                           # 004ec66d
    # block 0x004ec673: entered by fall-through of jne at 0x004ec66d, 3 instruction(s), ends with je to 0x004ec693 (forward)
    movsx ecx, word ptr [0x58c94f]               # 004ec673
    test ecx, ecx                                # 004ec67a
    je.d8 L_004ec693                             # 004ec67c
    # block 0x004ec67e: entered by fall-through of je at 0x004ec67c, 4 instruction(s), ends with jne to 0x004ec99b (forward)
    mov edx, dword ptr [ebp - local_9c70]        # 004ec67e
    movsx eax, word ptr [edx + field_b87]        # 004ec684
    test eax, eax                                # 004ec68b
    jne.d32 L_004ec99b                           # 004ec68d
L_004ec693:
    # block 0x004ec693: entered by je at 0x004ec67c; fall-through of jne at 0x004ec68d, 3 instruction(s), ends with forward jump to 0x004ec6b9
    mov word ptr [ebp - local_9c6c], 0x0         # 004ec693
    mov word ptr [ebp - local_9c58], 0x0         # 004ec69c
    jmp.d8 L_004ec6b9                            # 004ec6a5
L_004ec6a7:
    # block 0x004ec6a7: entered by jmp at 0x004ec71b, 3 instruction(s), falls into the block at 0x004ec6b9
    mov cx, word ptr [ebp - local_9c58]          # 004ec6a7
    add cx, 0x1                                  # 004ec6ae
    mov word ptr [ebp - local_9c58], cx          # 004ec6b2
L_004ec6b9:
    # block 0x004ec6b9: entered by jmp at 0x004ec6a5, 5 instruction(s), ends with jge to 0x004ec71d (forward)
    movsx edx, word ptr [ebp - local_9c58]       # 004ec6b9
    mov eax, dword ptr [ebp - local_9c70]        # 004ec6c0
    movsx ecx, word ptr [eax + field_28da]       # 004ec6c6
    {load} cmp edx, ecx                          # 004ec6cd
    jge.d8 L_004ec71d                            # 004ec6cf
    # block 0x004ec6d1: entered by fall-through of jge at 0x004ec6cf, 6 instruction(s), ends with jne to 0x004ec71b (forward)
    movsx edx, word ptr [ebp - local_9c6c]       # 004ec6d1
    imul edx, edx, 0x320                         # 004ec6d8
    movsx eax, word ptr [ebp - local_9c58]       # 004ec6de
    movsx ecx, word ptr [edx + 2*eax + 0x59f27b] # 004ec6e5
    cmp ecx, 0x8                                 # 004ec6ed
    jne.d8 L_004ec71b                            # 004ec6f0
    # block 0x004ec6f2: entered by fall-through of jne at 0x004ec6f0, 6 instruction(s), falls into the block at 0x004ec71b
    movsx edx, word ptr [ebp - local_9c6c]       # 004ec6f2
    imul edx, edx, 0x320                         # 004ec6f9
    movsx eax, word ptr [ebp - local_9c58]       # 004ec6ff
    mov ecx, dword ptr [ebp - local_9c70]        # 004ec706
    mov cx, word ptr [ecx + field_b85]           # 004ec70c
    mov word ptr [edx + 2*eax + 0x59f27b], cx    # 004ec713
L_004ec71b:
    # block 0x004ec71b: entered by jne at 0x004ec6f0, 1 instruction(s), ends with backward jump to 0x004ec6a7
    jmp.d8 L_004ec6a7                            # 004ec71b
L_004ec71d:
    # block 0x004ec71d: entered by jge at 0x004ec6cf, 11 instruction(s), ends with forward jump to 0x004ec768
    mov edx, dword ptr [ebp - local_9c70]        # 004ec71d
    mov word ptr [edx + field_28f8], 0x3         # 004ec723
    mov ecx, 0x2710                              # 004ec72c
    {load} xor eax, eax                          # 004ec731
    lea edi, [ebp - local_9c44]                  # 004ec733
    rep stosd dword ptr es:[edi], eax            # 004ec739
    movsx eax, word ptr [ebp - local_9c6c]       # 004ec73b
    movsx ecx, word ptr [2*eax + 0x59fbdb]       # 004ec742
    sub ecx, 0x1                                 # 004ec74a
    mov word ptr [ebp - local_9c58], cx          # 004ec74d
    jmp.d8 L_004ec768                            # 004ec754
L_004ec756:
    # block 0x004ec756: entered by jmp at 0x004ec8a6, 3 instruction(s), falls into the block at 0x004ec768
    mov dx, word ptr [ebp - local_9c58]          # 004ec756
    sub dx, 0x1                                  # 004ec75d
    mov word ptr [ebp - local_9c58], dx          # 004ec761
L_004ec768:
    # block 0x004ec768: entered by jmp at 0x004ec754, 3 instruction(s), ends with jl to 0x004ec8ab (forward)
    movsx eax, word ptr [ebp - local_9c58]       # 004ec768
    test eax, eax                                # 004ec76f
    jl.d32 L_004ec8ab                            # 004ec771
    # block 0x004ec777: entered by fall-through of jl at 0x004ec771, 11 instruction(s), calls FUN_00423259, ends with je to 0x004ec8a6 (forward)
    movsx ecx, word ptr [ebp - local_9c6c]       # 004ec777
    imul ecx, ecx, 0x3390                        # 004ec77e
    movsx edx, word ptr [ebp - local_9c58]       # 004ec784
    imul edx, edx, 0x21                          # 004ec78b
    lea eax, [ecx + edx + 0x5957cb]              # 004ec78e
    push eax                                     # 004ec795
    mov ecx, 0x619a6b                            # 004ec796
    call FUN_00423259                            # 004ec79b
    mov dword ptr [ebp - local_9c5c], eax        # 004ec7a0
    cmp dword ptr [ebp - local_9c5c], 0x0        # 004ec7a6
    je.d32 L_004ec8a6                            # 004ec7ad
    # block 0x004ec7b3: entered by fall-through of je at 0x004ec7ad, 6 instruction(s), ends with je to 0x004ec871 (forward)
    movsx ecx, word ptr [ebp - local_9c6c]       # 004ec7b3
    imul ecx, ecx, 0x320                         # 004ec7ba
    movsx edx, word ptr [ebp - local_9c58]       # 004ec7c0
    movsx eax, word ptr [ecx + 2*edx + 0x59f27b] # 004ec7c7
    test eax, eax                                # 004ec7cf
    je.d32 L_004ec871                            # 004ec7d1
    # block 0x004ec7d7: entered by fall-through of je at 0x004ec7d1, 44 instruction(s), calls FUN_005193ca, falls into the block at 0x004ec871
    lea edi, [ebp - local_9c44]                  # 004ec7d7
    or ecx, -0x1                                 # 004ec7dd
    {load} xor eax, eax                          # 004ec7e0
    repne scasb al, byte ptr es:[edi]            # 004ec7e2
    mov cx, word ptr [0x55ccb0]                  # 004ec7e4
    mov word ptr [edi - field_minus_1], cx       # 004ec7eb
    movsx edx, word ptr [ebp - local_9c6c]       # 004ec7ef
    imul edx, edx, 0x320                         # 004ec7f6
    movsx eax, word ptr [ebp - local_9c58]       # 004ec7fc
    mov cx, word ptr [edx + 2*eax + 0x59f27b]    # 004ec803
    mov word ptr [ebp - local_4], cx             # 004ec80b
    push 0xa                                     # 004ec80f
    lea edx, [ebp - local_9c64]                  # 004ec811
    push edx                                     # 004ec817
    movsx eax, word ptr [ebp - local_4]          # 004ec818
    push eax                                     # 004ec81c
    call FUN_005193ca                            # 004ec81d
    add esp, 0xc                                 # 004ec822
    lea edi, [ebp - local_9c64]                  # 004ec825
    lea edx, [ebp - local_9c44]                  # 004ec82b
    or ecx, -0x1                                 # 004ec831
    {load} xor eax, eax                          # 004ec834
    repne scasb al, byte ptr es:[edi]            # 004ec836
    not ecx                                      # 004ec838
    {load} sub edi, ecx                          # 004ec83a
    {load} mov esi, edi                          # 004ec83c
    {load} mov ebx, ecx                          # 004ec83e
    {load} mov edi, edx                          # 004ec840
    or ecx, -0x1                                 # 004ec842
    {load} xor eax, eax                          # 004ec845
    repne scasb al, byte ptr es:[edi]            # 004ec847
    add edi, -0x1                                # 004ec849
    {load} mov ecx, ebx                          # 004ec84c
    shr ecx, 0x2                                 # 004ec84e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004ec851
    {load} mov ecx, ebx                          # 004ec853
    and ecx, 0x3                                 # 004ec855
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004ec858
    lea edi, [ebp - local_9c44]                  # 004ec85a
    or ecx, -0x1                                 # 004ec860
    {load} xor eax, eax                          # 004ec863
    repne scasb al, byte ptr es:[edi]            # 004ec865
    mov ax, word ptr [0x55ccb4]                  # 004ec867
    mov word ptr [edi - field_minus_1], ax       # 004ec86d
L_004ec871:
    # block 0x004ec871: entered by je at 0x004ec7d1, 20 instruction(s), falls into the block at 0x004ec8a6
    mov edi, dword ptr [ebp - local_9c5c]        # 004ec871
    lea edx, [ebp - local_9c44]                  # 004ec877
    or ecx, -0x1                                 # 004ec87d
    {load} xor eax, eax                          # 004ec880
    repne scasb al, byte ptr es:[edi]            # 004ec882
    not ecx                                      # 004ec884
    {load} sub edi, ecx                          # 004ec886
    {load} mov esi, edi                          # 004ec888
    {load} mov ebx, ecx                          # 004ec88a
    {load} mov edi, edx                          # 004ec88c
    or ecx, -0x1                                 # 004ec88e
    {load} xor eax, eax                          # 004ec891
    repne scasb al, byte ptr es:[edi]            # 004ec893
    add edi, -0x1                                # 004ec895
    {load} mov ecx, ebx                          # 004ec898
    shr ecx, 0x2                                 # 004ec89a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004ec89d
    {load} mov ecx, ebx                          # 004ec89f
    and ecx, 0x3                                 # 004ec8a1
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004ec8a4
L_004ec8a6:
    # block 0x004ec8a6: entered by je at 0x004ec7ad, 1 instruction(s), ends with backward jump to 0x004ec756
    jmp.d32 L_004ec756                           # 004ec8a6
L_004ec8ab:
    # block 0x004ec8ab: entered by jl at 0x004ec771, 13 instruction(s), calls FUN_00413187, ends with forward jump to 0x004ec8f6
    lea eax, [ebp - local_9c44]                  # 004ec8ab
    mov dword ptr [ebp - local_9c5c], eax        # 004ec8b1
    push 0x0                                     # 004ec8b7
    push 0x0                                     # 004ec8b9
    mov ecx, dword ptr [ebp - local_9c5c]        # 004ec8bb
    push ecx                                     # 004ec8c1
    mov edx, dword ptr [ebp - local_9c70]        # 004ec8c2
    add edx, 0x28f6                              # 004ec8c8
    push edx                                     # 004ec8ce
    mov ecx, 0x619a41                            # 004ec8cf
    call FUN_00413187                            # 004ec8d4
    mov word ptr [ebp - local_9c58], 0x0         # 004ec8d9
    jmp.d8 L_004ec8f6                            # 004ec8e2
L_004ec8e4:
    # block 0x004ec8e4: entered by jmp at 0x004ec996, 3 instruction(s), falls into the block at 0x004ec8f6
    mov ax, word ptr [ebp - local_9c58]          # 004ec8e4
    .insn 0x66, 0x05, 0x0001{:u16}               # 004ec8eb
    mov word ptr [ebp - local_9c58], ax          # 004ec8ef
L_004ec8f6:
    # block 0x004ec8f6: entered by jmp at 0x004ec8e2, 5 instruction(s), ends with jge to 0x004ec99b (forward)
    movsx ecx, word ptr [ebp - local_9c58]       # 004ec8f6
    mov edx, dword ptr [ebp - local_9c70]        # 004ec8fd
    movsx eax, word ptr [edx + field_28da]       # 004ec903
    {load} cmp ecx, eax                          # 004ec90a
    jge.d32 L_004ec99b                           # 004ec90c
    # block 0x004ec912: entered by fall-through of jge at 0x004ec90c, 25 instruction(s), ends with backward jump to 0x004ec8e4
    movsx ecx, word ptr [ebp - local_9c58]       # 004ec912
    shl ecx, 0x4                                 # 004ec919
    mov edx, dword ptr [ebp - local_9c70]        # 004ec91c
    mov eax, dword ptr [edx + field_28e4]        # 004ec922
    sub eax, dword ptr [ebp - local_9c50]        # 004ec928
    mov edx, dword ptr [ebp - local_9c70]        # 004ec92e
    mov ecx, dword ptr [edx + ecx + field_fde]   # 004ec934
    {load} sub ecx, eax                          # 004ec93b
    movsx edx, word ptr [ebp - local_9c58]       # 004ec93d
    shl edx, 0x4                                 # 004ec944
    mov eax, dword ptr [ebp - local_9c70]        # 004ec947
    mov dword ptr [eax + edx + field_fde], ecx   # 004ec94d
    movsx ecx, word ptr [ebp - local_9c58]       # 004ec954
    shl ecx, 0x4                                 # 004ec95b
    mov edx, dword ptr [ebp - local_9c70]        # 004ec95e
    mov eax, dword ptr [edx + field_28ec]        # 004ec964
    sub eax, dword ptr [ebp - local_9c48]        # 004ec96a
    mov edx, dword ptr [ebp - local_9c70]        # 004ec970
    mov ecx, dword ptr [edx + ecx + field_fe6]   # 004ec976
    {load} sub ecx, eax                          # 004ec97d
    movsx edx, word ptr [ebp - local_9c58]       # 004ec97f
    shl edx, 0x4                                 # 004ec986
    mov eax, dword ptr [ebp - local_9c70]        # 004ec989
    mov dword ptr [eax + edx + field_fe6], ecx   # 004ec98f
    jmp.d32 L_004ec8e4                           # 004ec996
L_004ec99b:
    # block 0x004ec99b: entered by je at 0x004ec65a; jne at 0x004ec66d; jne at 0x004ec68d; jge at 0x004ec90c, 6 instruction(s), ends with ret
    pop edi                                      # 004ec99b
    pop esi                                      # 004ec99c
    pop ebx                                      # 004ec99d
    {load} mov esp, ebp                          # 004ec99e
    pop ebp                                      # 004ec9a0
    ret                                          # 004ec9a1

