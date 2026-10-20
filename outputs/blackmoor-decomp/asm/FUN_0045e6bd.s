# FUN_0045e6bd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045e6bd
# extent:       0x0045e6bd-0x0045e906 (585 code bytes)
# span:         0x0045e6bd-0x0045e906 (code 585, tables 0, padding 0)
# sha256:       452200c3bf1142d45745079f992410a797d8736359aff13ed1755bc3a35e32bd
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_random_caption_line_player
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_f6_runtime.c:151 says "0x45e6bd(names, record, count): pick a line, play it and show its caption."
# name-note:    Picks a line from a name list at random, plays it and shows its caption.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       9 ebp-relative slot(s): local_4, local_28, local_50, local_54, local_58, local_5c, local_128, local_12c, local_130
# fields:       [eax + n] field_3aa; [ecx + n] field_373, field_39e; [edi + n] field_minus_1; [edx + n] field_21
# callees:      calls FUN_0050cd50, FUN_0045e67d, FUN_004fb77a, FUN_004fb2e3, FUN_00423259, FUN_00448d11
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 174 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_28, 0x28  # offset -0x28
.equ local_50, 0x50  # offset -0x50
.equ local_54, 0x54  # offset -0x54
.equ local_58, 0x58  # offset -0x58
.equ local_5c, 0x5c  # offset -0x5c
.equ local_128, 0x128  # offset -0x128
.equ local_12c, 0x12c  # offset -0x12c
.equ local_130, 0x130  # offset -0x130
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_21, 0x21  # offset +0x21
.equ field_373, 0x373  # offset +0x373
.equ field_39e, 0x39e  # offset +0x39e
.equ field_3aa, 0x3aa  # offset +0x3aa

# --- external targets -----------------------------------------------
.set FUN_00423259, .text + (0x00423259 - 0x401000)
.set FUN_00448d11, .text + (0x00448d11 - 0x401000)
.set FUN_0045e67d, .text + (0x0045e67d - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x0045e6bd - 0x401000
.globl FUN_0045e6bd
FUN_0045e6bd:
    # block 0x0045e6bd: entry, 11 instruction(s), ends with jle to 0x0045e7e4 (forward)
    push ebp                                     # 0045e6bd
    {load} mov ebp, esp                          # 0045e6be
    sub esp, 0x130                               # 0045e6c0
    push esi                                     # 0045e6c6
    push edi                                     # 0045e6c7
    mov dword ptr [ebp - local_130], ecx         # 0045e6c8
    mov dword ptr [ebp - local_58], 0x0          # 0045e6ce
    mov dword ptr [ebp - local_5c], 0x0          # 0045e6d5
    movsx eax, word ptr [ebp + arg_10]           # 0045e6dc
    cmp eax, 0x1                                 # 0045e6e0
    jle.d32 L_0045e7e4                           # 0045e6e3
    # block 0x0045e6e9: entered by fall-through of jle at 0x0045e6e3, 5 instruction(s), falls into the block at 0x0045e6fc
    mov dword ptr [ebp - local_4], 0x0           # 0045e6e9
    mov ecx, 0xa                                 # 0045e6f0
    {load} xor eax, eax                          # 0045e6f5
    lea edi, [ebp - local_50]                    # 0045e6f7
    rep stosd dword ptr es:[edi], eax            # 0045e6fa
L_0045e6fc:
    # block 0x0045e6fc: entered by jmp at 0x0045e7dd, 2 instruction(s), ends with jne to 0x0045e7e2 (forward)
    cmp dword ptr [ebp - local_58], 0x0          # 0045e6fc
    jne.d32 L_0045e7e2                           # 0045e700
    # block 0x0045e706: entered by fall-through of jne at 0x0045e700, 2 instruction(s), ends with jne to 0x0045e7e2 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 0045e706
    jne.d32 L_0045e7e2                           # 0045e70a
    # block 0x0045e710: entered by fall-through of jne at 0x0045e70a, 30 instruction(s), calls FUN_0050cd50, FUN_0045e67d, ends with je to 0x0045e793 (forward)
    call FUN_0050cd50                            # 0045e710
    movsx ecx, word ptr [ebp + arg_10]           # 0045e715
    cdq                                          # 0045e719
    idiv ecx                                     # 0045e71a
    mov word ptr [ebp - local_12c], dx           # 0045e71c
    movsx edx, word ptr [ebp - local_12c]        # 0045e723
    imul edx, edx, 0x21                          # 0045e72a
    mov eax, dword ptr [ebp + arg_8]             # 0045e72d
    {load} add eax, edx                          # 0045e730
    {load} mov edi, eax                          # 0045e732
    lea edx, [ebp - local_28]                    # 0045e734
    or ecx, -0x1                                 # 0045e737
    {load} xor eax, eax                          # 0045e73a
    repne scasb al, byte ptr es:[edi]            # 0045e73c
    not ecx                                      # 0045e73e
    {load} sub edi, ecx                          # 0045e740
    {load} mov esi, edi                          # 0045e742
    {load} mov eax, ecx                          # 0045e744
    {load} mov edi, edx                          # 0045e746
    shr ecx, 0x2                                 # 0045e748
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0045e74b
    {load} mov ecx, eax                          # 0045e74d
    and ecx, 0x3                                 # 0045e74f
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0045e752
    lea ecx, [ebp - local_28]                    # 0045e754
    push ecx                                     # 0045e757
    mov ecx, dword ptr [ebp - local_130]         # 0045e758
    call FUN_0045e67d                            # 0045e75e
    test eax, eax                                # 0045e763
    je.d8 L_0045e793                             # 0045e765
    # block 0x0045e767: entered by fall-through of je at 0x0045e765, 17 instruction(s), ends with forward jump to 0x0045e7dd
    lea edi, [ebp - local_28]                    # 0045e767
    mov edx, dword ptr [ebp + arg_c]             # 0045e76a
    or ecx, -0x1                                 # 0045e76d
    {load} xor eax, eax                          # 0045e770
    repne scasb al, byte ptr es:[edi]            # 0045e772
    not ecx                                      # 0045e774
    {load} sub edi, ecx                          # 0045e776
    {load} mov esi, edi                          # 0045e778
    {load} mov eax, ecx                          # 0045e77a
    {load} mov edi, edx                          # 0045e77c
    shr ecx, 0x2                                 # 0045e77e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0045e781
    {load} mov ecx, eax                          # 0045e783
    and ecx, 0x3                                 # 0045e785
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0045e788
    mov dword ptr [ebp - local_58], 0x1          # 0045e78a
    jmp.d8 L_0045e7dd                            # 0045e791
L_0045e793:
    # block 0x0045e793: entered by je at 0x0045e765, 5 instruction(s), ends with forward jump to 0x0045e7bd
    movsx ecx, word ptr [ebp - local_12c]        # 0045e793
    mov dword ptr [ebp + 4*ecx - local_50], 0x1  # 0045e79a
    mov dword ptr [ebp - local_4], 0x1           # 0045e7a2
    mov word ptr [ebp - local_54], 0x0           # 0045e7a9
    jmp.d8 L_0045e7bd                            # 0045e7af
L_0045e7b1:
    # block 0x0045e7b1: entered by jmp at 0x0045e7db, 3 instruction(s), falls into the block at 0x0045e7bd
    mov dx, word ptr [ebp - local_54]            # 0045e7b1
    add dx, 0x1                                  # 0045e7b5
    mov word ptr [ebp - local_54], dx            # 0045e7b9
L_0045e7bd:
    # block 0x0045e7bd: entered by jmp at 0x0045e7af, 4 instruction(s), ends with jge to 0x0045e7dd (forward)
    movsx eax, word ptr [ebp - local_54]         # 0045e7bd
    movsx ecx, word ptr [ebp + arg_10]           # 0045e7c1
    {load} cmp eax, ecx                          # 0045e7c5
    jge.d8 L_0045e7dd                            # 0045e7c7
    # block 0x0045e7c9: entered by fall-through of jge at 0x0045e7c7, 3 instruction(s), ends with jne to 0x0045e7db (forward)
    movsx edx, word ptr [ebp - local_54]         # 0045e7c9
    cmp dword ptr [ebp + 4*edx - local_50], 0x0  # 0045e7cd
    jne.d8 L_0045e7db                            # 0045e7d2
    # block 0x0045e7d4: entered by fall-through of jne at 0x0045e7d2, 1 instruction(s), falls into the block at 0x0045e7db
    mov dword ptr [ebp - local_4], 0x0           # 0045e7d4
L_0045e7db:
    # block 0x0045e7db: entered by jne at 0x0045e7d2, 1 instruction(s), ends with backward jump to 0x0045e7b1
    jmp.d8 L_0045e7b1                            # 0045e7db
L_0045e7dd:
    # block 0x0045e7dd: entered by jmp at 0x0045e791; jge at 0x0045e7c7, 1 instruction(s), ends with backward jump to 0x0045e6fc
    jmp.d32 L_0045e6fc                           # 0045e7dd
L_0045e7e2:
    # block 0x0045e7e2: entered by jne at 0x0045e700; jne at 0x0045e70a, 1 instruction(s), ends with forward jump to 0x0045e821
    jmp.d8 L_0045e821                            # 0045e7e2
L_0045e7e4:
    # block 0x0045e7e4: entered by jle at 0x0045e6e3, 6 instruction(s), calls FUN_0045e67d, ends with je to 0x0045e821 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 0045e7e4
    push eax                                     # 0045e7e7
    mov ecx, dword ptr [ebp - local_130]         # 0045e7e8
    call FUN_0045e67d                            # 0045e7ee
    test eax, eax                                # 0045e7f3
    je.d8 L_0045e821                             # 0045e7f5
    # block 0x0045e7f7: entered by fall-through of je at 0x0045e7f5, 16 instruction(s), falls into the block at 0x0045e821
    mov edi, dword ptr [ebp + arg_8]             # 0045e7f7
    mov edx, dword ptr [ebp + arg_c]             # 0045e7fa
    or ecx, -0x1                                 # 0045e7fd
    {load} xor eax, eax                          # 0045e800
    repne scasb al, byte ptr es:[edi]            # 0045e802
    not ecx                                      # 0045e804
    {load} sub edi, ecx                          # 0045e806
    {load} mov esi, edi                          # 0045e808
    {load} mov eax, ecx                          # 0045e80a
    {load} mov edi, edx                          # 0045e80c
    shr ecx, 0x2                                 # 0045e80e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0045e811
    {load} mov ecx, eax                          # 0045e813
    and ecx, 0x3                                 # 0045e815
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0045e818
    mov dword ptr [ebp - local_58], 0x1          # 0045e81a
L_0045e821:
    # block 0x0045e821: entered by jmp at 0x0045e7e2; je at 0x0045e7f5, 2 instruction(s), ends with je to 0x0045e8fe (forward)
    cmp dword ptr [ebp - local_58], 0x0          # 0045e821
    je.d32 L_0045e8fe                            # 0045e825
    # block 0x0045e82b: entered by fall-through of je at 0x0045e825, 20 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, FUN_00423259, ends with je to 0x0045e8ee (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 0045e82b
    push ecx                                     # 0045e82e
    mov ecx, 0x5c3a67                            # 0045e82f
    call FUN_004fb77a                            # 0045e834
    mov edx, dword ptr [ebp + arg_c]             # 0045e839
    mov ax, word ptr [edx + field_21]            # 0045e83c
    push eax                                     # 0045e840
    mov ecx, 0x5c3a67                            # 0045e841
    call FUN_004fb2e3                            # 0045e846
    mov ecx, dword ptr [ebp - local_130]         # 0045e84b
    mov edx, dword ptr [ebp + arg_c]             # 0045e851
    mov ax, word ptr [edx + field_21]            # 0045e854
    mov word ptr [ecx + field_373], ax           # 0045e858
    mov ecx, dword ptr [ebp + arg_c]             # 0045e85f
    push ecx                                     # 0045e862
    mov ecx, 0x619a6b                            # 0045e863
    call FUN_00423259                            # 0045e868
    mov dword ptr [ebp - local_5c], eax          # 0045e86d
    cmp dword ptr [ebp - local_5c], 0x0          # 0045e870
    je.d8 L_0045e8ee                             # 0045e874
    # block 0x0045e876: entered by fall-through of je at 0x0045e874, 8 instruction(s), ends with ja to 0x0045e8ee (forward)
    mov edi, dword ptr [ebp - local_5c]          # 0045e876
    or ecx, -0x1                                 # 0045e879
    {load} xor eax, eax                          # 0045e87c
    repne scasb al, byte ptr es:[edi]            # 0045e87e
    not ecx                                      # 0045e880
    add ecx, -0x1                                # 0045e882
    cmp ecx, 0x9c40                              # 0045e885
    ja.d8 L_0045e8ee                             # 0045e88b
    # block 0x0045e88d: entered by fall-through of ja at 0x0045e88b, 29 instruction(s), calls FUN_00448d11, falls into the block at 0x0045e8ee
    mov edi, dword ptr [ebp - local_5c]          # 0045e88d
    or ecx, -0x1                                 # 0045e890
    {load} xor eax, eax                          # 0045e893
    repne scasb al, byte ptr es:[edi]            # 0045e895
    not ecx                                      # 0045e897
    mov esi, dword ptr [ebp - local_5c]          # 0045e899
    lea edi, [ebp - local_128]                   # 0045e89c
    {load} mov edx, ecx                          # 0045e8a2
    shr ecx, 0x2                                 # 0045e8a4
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0045e8a7
    {load} mov ecx, edx                          # 0045e8a9
    and ecx, 0x3                                 # 0045e8ab
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0045e8ae
    lea edi, [ebp - local_128]                   # 0045e8b0
    or ecx, -0x1                                 # 0045e8b6
    {load} xor eax, eax                          # 0045e8b9
    repne scasb al, byte ptr es:[edi]            # 0045e8bb
    mov eax, dword ptr [0x54af40]                # 0045e8bd
    mov dword ptr [edi - field_minus_1], eax     # 0045e8c2
    push 0x0                                     # 0045e8c5
    push -0x1                                    # 0045e8c7
    lea ecx, [ebp - local_128]                   # 0045e8c9
    push ecx                                     # 0045e8cf
    mov edx, dword ptr [0x5d03b3]                # 0045e8d0
    push edx                                     # 0045e8d6
    mov ecx, 0x619a05                            # 0045e8d7
    call FUN_00448d11                            # 0045e8dc
    mov eax, dword ptr [ebp - local_130]         # 0045e8e1
    mov byte ptr [eax + field_3aa], 0x1          # 0045e8e7
L_0045e8ee:
    # block 0x0045e8ee: entered by je at 0x0045e874; ja at 0x0045e88b, 2 instruction(s), falls into the block at 0x0045e8fe
    mov ecx, dword ptr [ebp - local_130]         # 0045e8ee
    mov dword ptr [ecx + field_39e], 0xa         # 0045e8f4
L_0045e8fe:
    # block 0x0045e8fe: entered by je at 0x0045e825, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 0045e8fe
    pop esi                                      # 0045e8ff
    {load} mov esp, ebp                          # 0045e900
    pop ebp                                      # 0045e902
    ret 0xc                                      # 0045e903

