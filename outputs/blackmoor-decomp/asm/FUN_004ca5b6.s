# FUN_004ca5b6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ca5b6
# extent:       0x004ca5b6-0x004ca81e (616 code bytes)
# span:         0x004ca5b6-0x004ca81e (code 616, tables 0, padding 0)
# sha256:       709b90641781998453fc4a20c04a555b7a0dba4ecee71f820f789f5cd7b2a0c6
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_ddraw_enumerate_callback
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4ca5b6.c.txt, not original source) refers to the data labelled s_DirectDrawEnumerateCallback_____D_00558164
# name-note:    DirectDrawEnumerate callback: creates a DirectDraw object per driver, copies description and name, queries caps, and logs DirectDrawEnumerateCallback results.
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x14 (callee pops 20 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_4, field_8, field_c, field_10, field_20, field_2c, field_304, field_1758; [ecx + n] field_4, field_8, field_c, field_300, field_308, field_1758; [edx + n] field_4, field_10, field_184, field_300, field_304, field_1758
# callees:      calls FUN_004fcebe, FUN_0050ca3e, FUN_0044a2b7, FUN_0050d960; plus 3 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 183 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_20, 0x20  # offset +0x20
.equ field_2c, 0x2c  # offset +0x2c
.equ field_184, 0x184  # offset +0x184
.equ field_300, 0x300  # offset +0x300
.equ field_304, 0x304  # offset +0x304
.equ field_308, 0x308  # offset +0x308
.equ field_1758, 0x1758  # offset +0x1758

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004fcebe, .text + (0x004fcebe - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050d960, .text + (0x0050d960 - 0x401000)

.org 0x004ca5b6 - 0x401000
.globl FUN_004ca5b6
FUN_004ca5b6:
    # block 0x004ca5b6: entry, 27 instruction(s), calls FUN_004fcebe, ends with jge to 0x004ca646 (forward)
    push ebp                                     # 004ca5b6
    {load} mov ebp, esp                          # 004ca5b7
    sub esp, 0x10                                # 004ca5b9
    push edi                                     # 004ca5bc
    mov dword ptr [ebp - local_8], 0x0           # 004ca5bd
    mov eax, dword ptr [ebp + arg_14]            # 004ca5c4
    mov dword ptr [ebp - local_c], eax           # 004ca5c7
    mov ecx, dword ptr [ebp - local_c]           # 004ca5ca
    mov edx, dword ptr [ecx + field_1758]        # 004ca5cd
    imul edx, edx, 0x3e4                         # 004ca5d3
    mov eax, dword ptr [ebp - local_c]           # 004ca5d9
    {load} add eax, edx                          # 004ca5dc
    mov dword ptr [ebp - local_10], eax          # 004ca5de
    mov ecx, 0xf9                                # 004ca5e1
    {load} xor eax, eax                          # 004ca5e6
    mov edi, dword ptr [ebp - local_10]          # 004ca5e8
    rep stosd dword ptr es:[edi], eax            # 004ca5eb
    push 0x0                                     # 004ca5ed
    push 0x52e56c                                # 004ca5ef
    lea ecx, [ebp - local_8]                     # 004ca5f4
    push ecx                                     # 004ca5f7
    mov edx, dword ptr [ebp + arg_8]             # 004ca5f8
    push edx                                     # 004ca5fb
    call FUN_004fcebe                            # 004ca5fc
    mov dword ptr [ebp - local_4], eax           # 004ca601
    cmp dword ptr [ebp - local_4], 0x0           # 004ca604
    jge.d8 L_004ca646                            # 004ca608
    # block 0x004ca60a: entered by fall-through of jge at 0x004ca608, 3 instruction(s), ends with je to 0x004ca63c (forward)
    movsx eax, word ptr [0x63a4cd]               # 004ca60a
    test eax, eax                                # 004ca611
    je.d8 L_004ca63c                             # 004ca613
    # block 0x004ca615: entered by fall-through of je at 0x004ca613, 11 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004ca63c
    mov ecx, dword ptr [ebp + arg_c]             # 004ca615
    push ecx                                     # 004ca618
    mov edx, dword ptr [ebp + arg_10]            # 004ca619
    push edx                                     # 004ca61c
    push 0x558164                                # 004ca61d
    push 0x63888b                                # 004ca622
    call FUN_0050ca3e                            # 004ca627
    add esp, 0x10                                # 004ca62c
    push 0x63888b                                # 004ca62f
    call FUN_0044a2b7                            # 004ca634
    add esp, 0x4                                 # 004ca639
L_004ca63c:
    # block 0x004ca63c: entered by je at 0x004ca613, 2 instruction(s), ends with forward jump to 0x004ca817
    mov eax, 0x1                                 # 004ca63c
    jmp.d32 L_004ca817                           # 004ca641
L_004ca646:
    # block 0x004ca646: entered by jge at 0x004ca608, 3 instruction(s), ends with je to 0x004ca678 (forward)
    movsx eax, word ptr [0x63a4cd]               # 004ca646
    test eax, eax                                # 004ca64d
    je.d8 L_004ca678                             # 004ca64f
    # block 0x004ca651: entered by fall-through of je at 0x004ca64f, 11 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004ca678
    mov ecx, dword ptr [ebp + arg_c]             # 004ca651
    push ecx                                     # 004ca654
    mov edx, dword ptr [ebp + arg_10]            # 004ca655
    push edx                                     # 004ca658
    push 0x5581b4                                # 004ca659
    push 0x63888b                                # 004ca65e
    call FUN_0050ca3e                            # 004ca663
    add esp, 0x10                                # 004ca668
    push 0x63888b                                # 004ca66b
    call FUN_0044a2b7                            # 004ca670
    add esp, 0x4                                 # 004ca675
L_004ca678:
    # block 0x004ca678: entered by je at 0x004ca64f, 21 instruction(s), calls FUN_0050d960, ends with je to 0x004ca6db (forward)
    push 0x63                                    # 004ca678
    mov eax, dword ptr [ebp + arg_10]            # 004ca67a
    push eax                                     # 004ca67d
    mov ecx, dword ptr [ebp - local_10]          # 004ca67e
    add ecx, 0x380                               # 004ca681
    push ecx                                     # 004ca687
    call FUN_0050d960                            # 004ca688
    add esp, 0xc                                 # 004ca68d
    push 0x63                                    # 004ca690
    mov edx, dword ptr [ebp + arg_c]             # 004ca692
    push edx                                     # 004ca695
    mov eax, dword ptr [ebp - local_10]          # 004ca696
    add eax, 0x31c                               # 004ca699
    push eax                                     # 004ca69e
    call FUN_0050d960                            # 004ca69f
    add esp, 0xc                                 # 004ca6a4
    mov ecx, dword ptr [ebp - local_10]          # 004ca6a7
    mov edx, dword ptr [ebp + arg_8]             # 004ca6aa
    mov dword ptr [ecx + field_308], edx         # 004ca6ad
    cmp dword ptr [ebp + arg_8], 0x0             # 004ca6b3
    je.d8 L_004ca6db                             # 004ca6b7
    # block 0x004ca6b9: entered by fall-through of je at 0x004ca6b7, 11 instruction(s), falls into the block at 0x004ca6db
    mov eax, dword ptr [ebp + arg_8]             # 004ca6b9
    mov ecx, dword ptr [ebp - local_10]          # 004ca6bc
    add ecx, 0x30c                               # 004ca6bf
    mov edx, dword ptr [eax]                     # 004ca6c5
    mov dword ptr [ecx], edx                     # 004ca6c7
    mov edx, dword ptr [eax + field_4]           # 004ca6c9
    mov dword ptr [ecx + field_4], edx           # 004ca6cc
    mov edx, dword ptr [eax + field_8]           # 004ca6cf
    mov dword ptr [ecx + field_8], edx           # 004ca6d2
    mov eax, dword ptr [eax + field_c]           # 004ca6d5
    mov dword ptr [ecx + field_c], eax           # 004ca6d8
L_004ca6db:
    # block 0x004ca6db: entered by je at 0x004ca6b7, 20 instruction(s), calls indirect dword ptr [eax + 0x2c], ends with je to 0x004ca72c (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004ca6db
    mov dword ptr [ecx + field_8], 0x17c         # 004ca6de
    mov edx, dword ptr [ebp - local_10]          # 004ca6e5
    mov dword ptr [edx + field_184], 0x17c       # 004ca6e8
    mov eax, dword ptr [ebp - local_10]          # 004ca6f2
    add eax, 0x184                               # 004ca6f5
    push eax                                     # 004ca6fa
    mov ecx, dword ptr [ebp - local_10]          # 004ca6fb
    add ecx, 0x8                                 # 004ca6fe
    push ecx                                     # 004ca701
    mov edx, dword ptr [ebp - local_8]           # 004ca702
    mov eax, dword ptr [edx]                     # 004ca705
    mov ecx, dword ptr [ebp - local_8]           # 004ca707
    push ecx                                     # 004ca70a
    call dword ptr [eax + field_2c]              # 004ca70b
    mov edx, dword ptr [ebp - local_10]          # 004ca70e
    mov eax, dword ptr [edx + field_10]          # 004ca711
    and eax, 0x100000                            # 004ca714
    test eax, eax                                # 004ca719
    je.d8 L_004ca72c                             # 004ca71b
    # block 0x004ca71d: entered by fall-through of je at 0x004ca71b, 3 instruction(s), ends with forward jump to 0x004ca739
    mov ecx, dword ptr [ebp - local_10]          # 004ca71d
    mov dword ptr [ecx + field_300], 0x1         # 004ca720
    jmp.d8 L_004ca739                            # 004ca72a
L_004ca72c:
    # block 0x004ca72c: entered by je at 0x004ca71b, 2 instruction(s), falls into the block at 0x004ca739
    mov edx, dword ptr [ebp - local_10]          # 004ca72c
    mov dword ptr [edx + field_300], 0x0         # 004ca72f
L_004ca739:
    # block 0x004ca739: entered by jmp at 0x004ca72a, 5 instruction(s), ends with je to 0x004ca758 (forward)
    mov eax, dword ptr [ebp - local_10]          # 004ca739
    mov ecx, dword ptr [eax + field_10]          # 004ca73c
    and ecx, 0x20000                             # 004ca73f
    test ecx, ecx                                # 004ca745
    je.d8 L_004ca758                             # 004ca747
    # block 0x004ca749: entered by fall-through of je at 0x004ca747, 3 instruction(s), ends with forward jump to 0x004ca765
    mov edx, dword ptr [ebp - local_10]          # 004ca749
    mov dword ptr [edx + field_304], 0x1         # 004ca74c
    jmp.d8 L_004ca765                            # 004ca756
L_004ca758:
    # block 0x004ca758: entered by je at 0x004ca747, 2 instruction(s), falls into the block at 0x004ca765
    mov eax, dword ptr [ebp - local_10]          # 004ca758
    mov dword ptr [eax + field_304], 0x0         # 004ca75b
L_004ca765:
    # block 0x004ca765: entered by jmp at 0x004ca756, 13 instruction(s), calls indirect dword ptr [eax + 0x20], ends with jne to 0x004ca7bb (forward)
    push 0x4ca81e                                # 004ca765
    mov ecx, dword ptr [ebp - local_10]          # 004ca76a
    push ecx                                     # 004ca76d
    push 0x0                                     # 004ca76e
    push 0x0                                     # 004ca770
    mov edx, dword ptr [ebp - local_8]           # 004ca772
    mov eax, dword ptr [edx]                     # 004ca775
    mov ecx, dword ptr [ebp - local_8]           # 004ca777
    push ecx                                     # 004ca77a
    call dword ptr [eax + field_20]              # 004ca77b
    mov edx, dword ptr [ebp - local_10]          # 004ca77e
    cmp dword ptr [edx + field_4], 0x0           # 004ca781
    jne.d8 L_004ca7bb                            # 004ca785
    # block 0x004ca787: entered by fall-through of jne at 0x004ca785, 3 instruction(s), ends with je to 0x004ca7b9 (forward)
    movsx eax, word ptr [0x63a4cd]               # 004ca787
    test eax, eax                                # 004ca78e
    je.d8 L_004ca7b9                             # 004ca790
    # block 0x004ca792: entered by fall-through of je at 0x004ca790, 11 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004ca7b9
    mov ecx, dword ptr [ebp + arg_c]             # 004ca792
    push ecx                                     # 004ca795
    mov edx, dword ptr [ebp + arg_10]            # 004ca796
    push edx                                     # 004ca799
    push 0x558204                                # 004ca79a
    push 0x63888b                                # 004ca79f
    call FUN_0050ca3e                            # 004ca7a4
    add esp, 0x10                                # 004ca7a9
    push 0x63888b                                # 004ca7ac
    call FUN_0044a2b7                            # 004ca7b1
    add esp, 0x4                                 # 004ca7b6
L_004ca7b9:
    # block 0x004ca7b9: entered by je at 0x004ca790, 1 instruction(s), ends with forward jump to 0x004ca815
    jmp.d8 L_004ca815                            # 004ca7b9
L_004ca7bb:
    # block 0x004ca7bb: entered by jne at 0x004ca785, 3 instruction(s), ends with je to 0x004ca7ed (forward)
    movsx eax, word ptr [0x63a4cd]               # 004ca7bb
    test eax, eax                                # 004ca7c2
    je.d8 L_004ca7ed                             # 004ca7c4
    # block 0x004ca7c6: entered by fall-through of je at 0x004ca7c4, 11 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004ca7ed
    mov ecx, dword ptr [ebp + arg_c]             # 004ca7c6
    push ecx                                     # 004ca7c9
    mov edx, dword ptr [ebp + arg_10]            # 004ca7ca
    push edx                                     # 004ca7cd
    push 0x558270                                # 004ca7ce
    push 0x63888b                                # 004ca7d3
    call FUN_0050ca3e                            # 004ca7d8
    add esp, 0x10                                # 004ca7dd
    push 0x63888b                                # 004ca7e0
    call FUN_0044a2b7                            # 004ca7e5
    add esp, 0x4                                 # 004ca7ea
L_004ca7ed:
    # block 0x004ca7ed: entered by je at 0x004ca7c4, 5 instruction(s), falls into the block at 0x004ca802
    mov eax, dword ptr [ebp - local_c]           # 004ca7ed
    mov ecx, dword ptr [eax + field_1758]        # 004ca7f0
    add ecx, 0x1                                 # 004ca7f6
    mov edx, dword ptr [ebp - local_c]           # 004ca7f9
    mov dword ptr [edx + field_1758], ecx        # 004ca7fc
L_004ca802:
    # block 0x004ca802: entered by jmp at 0x004ca815, 7 instruction(s), calls indirect dword ptr [ecx + 0x8], ends with forward jump to 0x004ca817
    mov eax, dword ptr [ebp - local_8]           # 004ca802
    mov ecx, dword ptr [eax]                     # 004ca805
    mov edx, dword ptr [ebp - local_8]           # 004ca807
    push edx                                     # 004ca80a
    call dword ptr [ecx + field_8]               # 004ca80b
    mov eax, 0x1                                 # 004ca80e
    jmp.d8 L_004ca817                            # 004ca813
L_004ca815:
    # block 0x004ca815: entered by jmp at 0x004ca7b9, 1 instruction(s), ends with backward jump to 0x004ca802
    jmp.d8 L_004ca802                            # 004ca815
L_004ca817:
    # block 0x004ca817: entered by jmp at 0x004ca641; jmp at 0x004ca813, 4 instruction(s), ends with ret 0x14
    pop edi                                      # 004ca817
    {load} mov esp, ebp                          # 004ca818
    pop ebp                                      # 004ca81a
    ret 0x14                                     # 004ca81b

