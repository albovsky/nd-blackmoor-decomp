# FUN_0048d5f4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048d5f4
# extent:       0x0048d5f4-0x0048d89e (682 code bytes)
# span:         0x0048d5f4-0x0048d89e (code 682, tables 0, padding 0)
# sha256:       3087d9d66981870381180468e94cfb417d6e69f7a59f9cebfe0ae9f682198e7c
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0048d5f4
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_d8, local_dc, local_e0
# fields:       [eax + n] field_1e, field_24, field_27, field_29, field_33, field_317, field_337, field_736; [ecx + n] field_27, field_2b, field_2f, field_37, field_39, field_3d, field_317, field_358, field_736; [edi + n] field_minus_1; [edx + n] field_1e, field_26, field_27, field_3b; [esi + n] field_3f
# callees:      calls FUN_004f6334, FUN_004fb77a, FUN_004fb2e3, KERNEL32.dll!GetTickCount, FUN_00423259, FUN_00448d11
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 172 instruction(s), 12 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_d8, 0xd8  # offset -0xd8
.equ local_dc, 0xdc  # offset -0xdc
.equ local_e0, 0xe0  # offset -0xe0
.equ field_1e, 0x1e  # offset +0x1e
.equ field_24, 0x24  # offset +0x24
.equ field_26, 0x26  # offset +0x26
.equ field_27, 0x27  # offset +0x27
.equ field_29, 0x29  # offset +0x29
.equ field_2b, 0x2b  # offset +0x2b
.equ field_2f, 0x2f  # offset +0x2f
.equ field_33, 0x33  # offset +0x33
.equ field_37, 0x37  # offset +0x37
.equ field_39, 0x39  # offset +0x39
.equ field_3b, 0x3b  # offset +0x3b
.equ field_3d, 0x3d  # offset +0x3d
.equ field_3f, 0x3f  # offset +0x3f
.equ field_317, 0x317  # offset +0x317
.equ field_337, 0x337  # offset +0x337
.equ field_358, 0x358  # offset +0x358
.equ field_736, 0x736  # offset +0x736

# --- external targets -----------------------------------------------
.set FUN_00423259, .text + (0x00423259 - 0x401000)
.set FUN_00448d11, .text + (0x00448d11 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)

.org 0x0048d5f4 - 0x401000
.globl FUN_0048d5f4
FUN_0048d5f4:
    # block 0x0048d5f4: entry, 15 instruction(s), ends with je to 0x0048d898 (forward)
    push ebp                                     # 0048d5f4
    {load} mov ebp, esp                          # 0048d5f5
    sub esp, 0xe0                                # 0048d5f7
    push esi                                     # 0048d5fd
    push edi                                     # 0048d5fe
    mov dword ptr [ebp - local_e0], ecx          # 0048d5ff
    mov dword ptr [ebp - local_c], 0x0           # 0048d605
    mov eax, dword ptr [ebp - local_e0]          # 0048d60c
    movsx ecx, word ptr [eax + field_1e]         # 0048d612
    imul ecx, ecx, 0x8d                          # 0048d616
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0048d61c
    mov dword ptr [ebp - local_4], edx           # 0048d622
    mov eax, dword ptr [ebp - local_e0]          # 0048d625
    cmp dword ptr [eax + field_33], 0x0          # 0048d62b
    je.d32 L_0048d898                            # 0048d62f
    # block 0x0048d635: entered by fall-through of je at 0x0048d62f, 3 instruction(s), ends with jne to 0x0048d898 (forward)
    mov ecx, dword ptr [ebp - local_e0]          # 0048d635
    cmp dword ptr [ecx + field_2b], 0x1          # 0048d63b
    jne.d32 L_0048d898                           # 0048d63f
    # block 0x0048d645: entered by fall-through of jne at 0x0048d63f, 5 instruction(s), ends with jne to 0x0048d898 (forward)
    mov edx, dword ptr [ebp - local_e0]          # 0048d645
    movsx eax, word ptr [edx + field_1e]         # 0048d64b
    imul eax, eax, 0x8d                          # 0048d64f
    cmp dword ptr [eax + 0x5bb632], 0x1          # 0048d655
    jne.d32 L_0048d898                           # 0048d65c
    # block 0x0048d662: entered by fall-through of jne at 0x0048d65c, 2 instruction(s), ends with jne to 0x0048d697 (forward)
    cmp dword ptr [0x5c39e5], 0x2766             # 0048d662
    jne.d8 L_0048d697                            # 0048d66c
    # block 0x0048d66e: entered by fall-through of jne at 0x0048d66c, 7 instruction(s), ends with forward jump to 0x0048d898
    mov ecx, dword ptr [ebp - local_e0]          # 0048d66e
    mov byte ptr [ecx + field_37], 0x1           # 0048d674
    mov edx, dword ptr [ebp - local_e0]          # 0048d678
    movsx eax, word ptr [edx + field_1e]         # 0048d67e
    imul eax, eax, 0x8d                          # 0048d682
    mov dword ptr [eax + 0x5bb632], 0x2          # 0048d688
    jmp.d32 L_0048d898                           # 0048d692
L_0048d697:
    # block 0x0048d697: entered by jne at 0x0048d66c, 2 instruction(s), ends with jne to 0x0048d898 (forward)
    cmp dword ptr [0x5c39e5], 0x2765             # 0048d697
    jne.d32 L_0048d898                           # 0048d6a1
    # block 0x0048d6a7: entered by fall-through of jne at 0x0048d6a1, 3 instruction(s), ends with je to 0x0048d6bd (forward)
    mov ecx, dword ptr [ebp - local_e0]          # 0048d6a7
    cmp dword ptr [ecx + field_2f], 0x0          # 0048d6ad
    je.d8 L_0048d6bd                             # 0048d6b1
    # block 0x0048d6b3: entered by fall-through of je at 0x0048d6b1, 2 instruction(s), falls into the block at 0x0048d6bd
    mov edx, dword ptr [ebp - local_e0]          # 0048d6b3
    mov byte ptr [edx + field_26], 0x1           # 0048d6b9
L_0048d6bd:
    # block 0x0048d6bd: entered by je at 0x0048d6b1, 6 instruction(s), ends with forward jump to 0x0048d6e3
    mov eax, dword ptr [ebp - local_e0]          # 0048d6bd
    mov ecx, dword ptr [ebp - local_e0]          # 0048d6c3
    mov dx, word ptr [ecx + field_27]            # 0048d6c9
    mov word ptr [eax + field_29], dx            # 0048d6cd
    mov dword ptr [ebp - local_8], 0x0           # 0048d6d1
    jmp.d8 L_0048d6e3                            # 0048d6d8
L_0048d6da:
    # block 0x0048d6da: entered by jmp at 0x0048d711, 3 instruction(s), falls into the block at 0x0048d6e3
    mov eax, dword ptr [ebp - local_8]           # 0048d6da
    add eax, 0x1                                 # 0048d6dd
    mov dword ptr [ebp - local_8], eax           # 0048d6e0
L_0048d6e3:
    # block 0x0048d6e3: entered by jmp at 0x0048d6d8, 5 instruction(s), ends with jge to 0x0048d713 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0048d6e3
    movsx edx, word ptr [ecx + field_317]        # 0048d6e6
    sub edx, 0x1                                 # 0048d6ed
    cmp dword ptr [ebp - local_8], edx           # 0048d6f0
    jge.d8 L_0048d713                            # 0048d6f3
    # block 0x0048d6f5: entered by fall-through of jge at 0x0048d6f3, 7 instruction(s), ends with backward jump to 0x0048d6da
    mov eax, dword ptr [ebp - local_8]           # 0048d6f5
    mov ecx, dword ptr [ebp - local_e0]          # 0048d6f8
    mov edx, dword ptr [ebp - local_8]           # 0048d6fe
    mov esi, dword ptr [ebp - local_e0]          # 0048d701
    mov dx, word ptr [esi + 2*edx + field_3f]    # 0048d707
    mov word ptr [ecx + 2*eax + field_3d], dx    # 0048d70c
    jmp.d8 L_0048d6da                            # 0048d711
L_0048d713:
    # block 0x0048d713: entered by jge at 0x0048d6f3, 29 instruction(s), ends with je to 0x0048d802 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0048d713
    movsx ecx, word ptr [eax + field_317]        # 0048d716
    mov edx, dword ptr [ebp - local_e0]          # 0048d71d
    mov eax, dword ptr [ebp - local_e0]          # 0048d723
    mov ax, word ptr [eax + field_27]            # 0048d729
    mov word ptr [edx + 2*ecx + field_3b], ax    # 0048d72d
    mov ecx, dword ptr [ebp - local_e0]          # 0048d732
    movsx edx, word ptr [ecx + field_27]         # 0048d738
    imul edx, edx, 0x42                          # 0048d73c
    mov eax, dword ptr [ebp - local_4]           # 0048d73f
    lea ecx, [eax + edx + field_337]             # 0048d742
    {load} mov edi, ecx                          # 0048d749
    mov edx, dword ptr [ebp - local_4]           # 0048d74b
    add edx, 0x715                               # 0048d74e
    or ecx, -0x1                                 # 0048d754
    {load} xor eax, eax                          # 0048d757
    repne scasb al, byte ptr es:[edi]            # 0048d759
    not ecx                                      # 0048d75b
    {load} sub edi, ecx                          # 0048d75d
    {load} mov esi, edi                          # 0048d75f
    {load} mov eax, ecx                          # 0048d761
    {load} mov edi, edx                          # 0048d763
    shr ecx, 0x2                                 # 0048d765
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0048d768
    {load} mov ecx, eax                          # 0048d76a
    and ecx, 0x3                                 # 0048d76c
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0048d76f
    cmp dword ptr [0x5bb1ca], 0x0                # 0048d771
    je.d32 L_0048d802                            # 0048d778
    # block 0x0048d77e: entered by fall-through of je at 0x0048d778, 7 instruction(s), ends with je to 0x0048d802 (forward)
    mov edi, 0x54e88c                            # 0048d77e
    mov esi, dword ptr [ebp - local_4]           # 0048d783
    add esi, 0x715                               # 0048d786
    mov ecx, 0x9                                 # 0048d78c
    {load} xor edx, edx                          # 0048d791
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0048d793
    je.d8 L_0048d802                             # 0048d795
    # block 0x0048d797: entered by fall-through of je at 0x0048d795, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x0048d802 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0048d797
    movsx ecx, word ptr [eax + field_736]        # 0048d79a
    mov dword ptr [ebp - local_dc], ecx          # 0048d7a1
    mov edx, dword ptr [ebp - local_dc]          # 0048d7a7
    push edx                                     # 0048d7ad
    mov ecx, 0x5cf1eb                            # 0048d7ae
    call FUN_004f6334                            # 0048d7b3
    test eax, eax                                # 0048d7b8
    jne.d8 L_0048d802                            # 0048d7ba
    # block 0x0048d7bc: entered by fall-through of jne at 0x0048d7ba, 16 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, KERNEL32.dll!GetTickCount, falls into the block at 0x0048d802
    mov eax, dword ptr [ebp - local_4]           # 0048d7bc
    add eax, 0x715                               # 0048d7bf
    push eax                                     # 0048d7c4
    mov ecx, 0x5c3a67                            # 0048d7c5
    call FUN_004fb77a                            # 0048d7ca
    mov ecx, dword ptr [ebp - local_4]           # 0048d7cf
    mov dx, word ptr [ecx + field_736]           # 0048d7d2
    push edx                                     # 0048d7d9
    mov ecx, 0x5c3a67                            # 0048d7da
    call FUN_004fb2e3                            # 0048d7df
    mov eax, dword ptr [ebp - local_e0]          # 0048d7e4
    mov byte ptr [eax + field_24], 0x1           # 0048d7ea
    call dword ptr [0x52a23c]                    # 0048d7ee
    add eax, 0x1f4                               # 0048d7f4
    mov ecx, dword ptr [ebp - local_e0]          # 0048d7f9
    mov dword ptr [ecx + field_39], eax          # 0048d7ff
L_0048d802:
    # block 0x0048d802: entered by je at 0x0048d778; je at 0x0048d795; jne at 0x0048d7ba, 11 instruction(s), calls FUN_00423259, ends with je to 0x0048d898 (forward)
    mov edx, dword ptr [ebp - local_e0]          # 0048d802
    movsx eax, word ptr [edx + field_27]         # 0048d808
    imul eax, eax, 0x42                          # 0048d80c
    mov ecx, dword ptr [ebp - local_4]           # 0048d80f
    lea edx, [ecx + eax + field_358]             # 0048d812
    push edx                                     # 0048d819
    mov ecx, 0x619a6b                            # 0048d81a
    call FUN_00423259                            # 0048d81f
    mov dword ptr [ebp - local_c], eax           # 0048d824
    cmp dword ptr [ebp - local_c], 0x0           # 0048d827
    je.d8 L_0048d898                             # 0048d82b
    # block 0x0048d82d: entered by fall-through of je at 0x0048d82b, 8 instruction(s), ends with ja to 0x0048d898 (forward)
    mov edi, dword ptr [ebp - local_c]           # 0048d82d
    or ecx, -0x1                                 # 0048d830
    {load} xor eax, eax                          # 0048d833
    repne scasb al, byte ptr es:[edi]            # 0048d835
    not ecx                                      # 0048d837
    add ecx, -0x1                                # 0048d839
    cmp ecx, 0x9c40                              # 0048d83c
    ja.d8 L_0048d898                             # 0048d842
    # block 0x0048d844: entered by fall-through of ja at 0x0048d842, 27 instruction(s), calls FUN_00448d11, falls into the block at 0x0048d898
    mov edi, dword ptr [ebp - local_c]           # 0048d844
    or ecx, -0x1                                 # 0048d847
    {load} xor eax, eax                          # 0048d84a
    repne scasb al, byte ptr es:[edi]            # 0048d84c
    not ecx                                      # 0048d84e
    mov esi, dword ptr [ebp - local_c]           # 0048d850
    lea edi, [ebp - local_d8]                    # 0048d853
    {load} mov eax, ecx                          # 0048d859
    shr ecx, 0x2                                 # 0048d85b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0048d85e
    {load} mov ecx, eax                          # 0048d860
    and ecx, 0x3                                 # 0048d862
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0048d865
    lea edi, [ebp - local_d8]                    # 0048d867
    or ecx, -0x1                                 # 0048d86d
    {load} xor eax, eax                          # 0048d870
    repne scasb al, byte ptr es:[edi]            # 0048d872
    mov ecx, dword ptr [0x54e898]                # 0048d874
    mov dword ptr [edi - field_minus_1], ecx     # 0048d87a
    push 0x0                                     # 0048d87d
    push -0x1                                    # 0048d87f
    lea edx, [ebp - local_d8]                    # 0048d881
    push edx                                     # 0048d887
    mov eax, dword ptr [0x5d03b3]                # 0048d888
    push eax                                     # 0048d88d
    mov ecx, 0x619a05                            # 0048d88e
    call FUN_00448d11                            # 0048d893
L_0048d898:
    # block 0x0048d898: entered by je at 0x0048d62f; jne at 0x0048d63f; jne at 0x0048d65c; jmp at 0x0048d692; more, 5 instruction(s), ends with ret
    pop edi                                      # 0048d898
    pop esi                                      # 0048d899
    {load} mov esp, ebp                          # 0048d89a
    pop ebp                                      # 0048d89c
    ret                                          # 0048d89d

