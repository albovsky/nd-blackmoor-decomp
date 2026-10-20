# FUN_004aa3d2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004aa3d2
# extent:       0x004aa3d2-0x004aa81e (1100 code bytes)
# span:         0x004aa3d2-0x004aa81e (code 1100, tables 0, padding 0)
# sha256:       69638bf74dc9f2ed560a0b157b47f91d59fff4acba0da96eb8a6206fd1aabc12
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4aa3d2_click_276f_2771
# naming:       native port src/original_methods_fl25c.c:m4aa3d2_click_276f_2771 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      Matches arm by arm, host calls in order, except two rejections: S longer than 200 bytes (201..0x9c40) or unresolvable returns early (original overruns its frame). Direct, differential, oracle: 1800 fixtures, 262/262, both jcc ways.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_d8, local_dc
# fields:       [eax + n] field_21, field_23, field_25, field_2b, field_2c, field_42, field_44, field_45, field_48, field_73, field_119, field_13a and 1 more; [ecx + n] field_23, field_25, field_2b, field_40, field_42, field_47, field_48, field_83, field_f7, field_14a; [edi + n] field_minus_1; [edx + n] field_21, field_23, field_25, field_2c, field_42, field_46, field_119, field_233
# callees:      calls FUN_004fb2e3, FUN_004fb77a, FUN_00423259, FUN_00448d11
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl25c.c:m4aa3d2_click_276f_2771 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 262 instruction(s), 19 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
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
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_25, 0x25  # offset +0x25
.equ field_2b, 0x2b  # offset +0x2b
.equ field_2c, 0x2c  # offset +0x2c
.equ field_40, 0x40  # offset +0x40
.equ field_42, 0x42  # offset +0x42
.equ field_44, 0x44  # offset +0x44
.equ field_45, 0x45  # offset +0x45
.equ field_46, 0x46  # offset +0x46
.equ field_47, 0x47  # offset +0x47
.equ field_48, 0x48  # offset +0x48
.equ field_73, 0x73  # offset +0x73
.equ field_83, 0x83  # offset +0x83
.equ field_f7, 0xf7  # offset +0xf7
.equ field_119, 0x119  # offset +0x119
.equ field_13a, 0x13a  # offset +0x13a
.equ field_14a, 0x14a  # offset +0x14a
.equ field_16b, 0x16b  # offset +0x16b
.equ field_233, 0x233  # offset +0x233

# --- external targets -----------------------------------------------
.set FUN_00423259, .text + (0x00423259 - 0x401000)
.set FUN_00448d11, .text + (0x00448d11 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)

.org 0x004aa3d2 - 0x401000
.globl FUN_004aa3d2
FUN_004aa3d2:
    # block 0x004aa3d2: entry, 17 instruction(s), ends with je to 0x004aa818 (forward)
    push ebp                                     # 004aa3d2
    {load} mov ebp, esp                          # 004aa3d3
    sub esp, 0xdc                                # 004aa3d5
    push esi                                     # 004aa3db
    push edi                                     # 004aa3dc
    mov dword ptr [ebp - local_dc], ecx          # 004aa3dd
    mov dword ptr [ebp - local_c], 0x0           # 004aa3e3
    mov eax, dword ptr [ebp - local_dc]          # 004aa3ea
    movsx ecx, word ptr [eax + field_21]         # 004aa3f0
    imul ecx, ecx, 0x8d                          # 004aa3f4
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004aa3fa
    mov dword ptr [ebp - local_8], edx           # 004aa400
    mov eax, dword ptr [ebp - local_dc]          # 004aa403
    {load} xor ecx, ecx                          # 004aa409
    mov cl, byte ptr [eax + field_45]            # 004aa40b
    test ecx, ecx                                # 004aa40e
    je.d32 L_004aa818                            # 004aa410
    # block 0x004aa416: entered by fall-through of je at 0x004aa410, 5 instruction(s), ends with jne to 0x004aa818 (forward)
    mov edx, dword ptr [ebp - local_dc]          # 004aa416
    movsx eax, word ptr [edx + field_21]         # 004aa41c
    imul eax, eax, 0x8d                          # 004aa420
    cmp dword ptr [eax + 0x5bb632], 0x1          # 004aa426
    jne.d32 L_004aa818                           # 004aa42d
    # block 0x004aa433: entered by fall-through of jne at 0x004aa42d, 5 instruction(s), ends with jne to 0x004aa5d2 (forward)
    mov ecx, dword ptr [ebp - local_dc]          # 004aa433
    {load} xor edx, edx                          # 004aa439
    mov dl, byte ptr [ecx + field_47]            # 004aa43b
    test edx, edx                                # 004aa43e
    jne.d32 L_004aa5d2                           # 004aa440
    # block 0x004aa446: entered by fall-through of jne at 0x004aa440, 2 instruction(s), ends with jne to 0x004aa5d2 (forward)
    cmp dword ptr [0x5c39e5], 0x276f             # 004aa446
    jne.d32 L_004aa5d2                           # 004aa450
    # block 0x004aa456: entered by fall-through of jne at 0x004aa450, 13 instruction(s), ends with jne to 0x004aa527 (forward)
    mov eax, dword ptr [ebp - local_dc]          # 004aa456
    mov ecx, dword ptr [ebp - local_dc]          # 004aa45c
    mov dx, word ptr [ecx + field_23]            # 004aa462
    mov word ptr [eax + field_42], dx            # 004aa466
    mov eax, dword ptr [ebp - local_dc]          # 004aa46a
    movsx ecx, word ptr [eax + field_42]         # 004aa470
    imul ecx, ecx, 0x15c                         # 004aa474
    mov edx, dword ptr [ebp - local_8]           # 004aa47a
    movsx eax, word ptr [edx + ecx + field_233]  # 004aa47d
    mov ecx, dword ptr [ebp - local_dc]          # 004aa485
    movsx edx, word ptr [ecx + field_40]         # 004aa48b
    {load} cmp eax, edx                          # 004aa48f
    jne.d32 L_004aa527                           # 004aa491
    # block 0x004aa497: entered by fall-through of jne at 0x004aa491, 7 instruction(s), ends with jne to 0x004aa527 (forward)
    mov eax, dword ptr [ebp - local_dc]          # 004aa497
    movsx ecx, word ptr [eax + field_42]         # 004aa49d
    mov edx, dword ptr [ebp - local_dc]          # 004aa4a1
    {load} xor eax, eax                          # 004aa4a7
    mov al, byte ptr [edx + ecx + field_2c]      # 004aa4a9
    test eax, eax                                # 004aa4ad
    jne.d8 L_004aa527                            # 004aa4af
    # block 0x004aa4b1: entered by fall-through of jne at 0x004aa4af, 16 instruction(s), ends with je to 0x004aa515 (forward)
    mov ecx, dword ptr [ebp - local_dc]          # 004aa4b1
    mov dx, word ptr [ecx + field_48]            # 004aa4b7
    add dx, 0x1                                  # 004aa4bb
    mov eax, dword ptr [ebp - local_dc]          # 004aa4bf
    mov word ptr [eax + field_48], dx            # 004aa4c5
    mov ecx, dword ptr [ebp - local_dc]          # 004aa4c9
    movsx edx, word ptr [ecx + field_42]         # 004aa4cf
    mov eax, dword ptr [ebp - local_dc]          # 004aa4d3
    mov byte ptr [eax + edx + field_2c], 0x1     # 004aa4d9
    mov edi, 0x550e2c                            # 004aa4de
    mov esi, dword ptr [ebp - local_8]           # 004aa4e3
    add esi, 0x52                                # 004aa4e6
    mov ecx, 0x9                                 # 004aa4e9
    {load} xor edx, edx                          # 004aa4ee
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004aa4f0
    je.d8 L_004aa515                             # 004aa4f2
    # block 0x004aa4f4: entered by fall-through of je at 0x004aa4f2, 8 instruction(s), calls FUN_004fb2e3, ends with forward jump to 0x004aa522
    mov eax, dword ptr [ebp - local_8]           # 004aa4f4
    mov cx, word ptr [eax + field_73]            # 004aa4f7
    push ecx                                     # 004aa4fb
    mov ecx, 0x5c3a67                            # 004aa4fc
    call FUN_004fb2e3                            # 004aa501
    mov edx, dword ptr [ebp - local_dc]          # 004aa506
    mov dword ptr [edx + field_25], 0x1          # 004aa50c
    jmp.d8 L_004aa522                            # 004aa513
L_004aa515:
    # block 0x004aa515: entered by je at 0x004aa4f2, 2 instruction(s), falls into the block at 0x004aa522
    mov eax, dword ptr [ebp - local_dc]          # 004aa515
    mov dword ptr [eax + field_25], 0x0          # 004aa51b
L_004aa522:
    # block 0x004aa522: entered by jmp at 0x004aa513, 1 instruction(s), ends with forward jump to 0x004aa5c3
    jmp.d32 L_004aa5c3                           # 004aa522
L_004aa527:
    # block 0x004aa527: entered by jne at 0x004aa491; jne at 0x004aa4af, 5 instruction(s), ends with je to 0x004aa57f (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004aa527
    {load} xor edx, edx                          # 004aa52a
    mov dl, byte ptr [ecx + field_83]            # 004aa52c
    test edx, edx                                # 004aa532
    je.d8 L_004aa57f                             # 004aa534
    # block 0x004aa536: entered by fall-through of je at 0x004aa534, 6 instruction(s), ends with forward jump to 0x004aa560
    mov eax, dword ptr [ebp - local_dc]          # 004aa536
    mov byte ptr [eax + field_44], 0x1           # 004aa53c
    mov ecx, dword ptr [ebp - local_dc]          # 004aa540
    mov word ptr [ecx + field_48], 0x0           # 004aa546
    mov word ptr [ebp - local_4], 0x0            # 004aa54c
    jmp.d8 L_004aa560                            # 004aa552
L_004aa554:
    # block 0x004aa554: entered by jmp at 0x004aa57d, 3 instruction(s), falls into the block at 0x004aa560
    mov dx, word ptr [ebp - local_4]             # 004aa554
    add dx, 0x1                                  # 004aa558
    mov word ptr [ebp - local_4], dx             # 004aa55c
L_004aa560:
    # block 0x004aa560: entered by jmp at 0x004aa552, 5 instruction(s), ends with jge to 0x004aa57f (forward)
    movsx eax, word ptr [ebp - local_4]          # 004aa560
    mov ecx, dword ptr [ebp - local_8]           # 004aa564
    movsx edx, word ptr [ecx + field_f7]         # 004aa567
    {load} cmp eax, edx                          # 004aa56e
    jge.d8 L_004aa57f                            # 004aa570
    # block 0x004aa572: entered by fall-through of jge at 0x004aa570, 3 instruction(s), ends with backward jump to 0x004aa554
    movsx eax, word ptr [ebp - local_4]          # 004aa572
    mov byte ptr [eax + 0x630a60], 0x0           # 004aa576
    jmp.d8 L_004aa554                            # 004aa57d
L_004aa57f:
    # block 0x004aa57f: entered by je at 0x004aa534; jge at 0x004aa570, 7 instruction(s), ends with je to 0x004aa5b6 (forward)
    mov edi, 0x550e38                            # 004aa57f
    mov esi, dword ptr [ebp - local_8]           # 004aa584
    add esi, 0x21                                # 004aa587
    mov ecx, 0x9                                 # 004aa58a
    {load} xor edx, edx                          # 004aa58f
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004aa591
    je.d8 L_004aa5b6                             # 004aa593
    # block 0x004aa595: entered by fall-through of je at 0x004aa593, 8 instruction(s), calls FUN_004fb2e3, ends with forward jump to 0x004aa5c3
    mov eax, dword ptr [ebp - local_8]           # 004aa595
    mov cx, word ptr [eax + field_42]            # 004aa598
    push ecx                                     # 004aa59c
    mov ecx, 0x5c3a67                            # 004aa59d
    call FUN_004fb2e3                            # 004aa5a2
    mov edx, dword ptr [ebp - local_dc]          # 004aa5a7
    mov dword ptr [edx + field_25], 0x1          # 004aa5ad
    jmp.d8 L_004aa5c3                            # 004aa5b4
L_004aa5b6:
    # block 0x004aa5b6: entered by je at 0x004aa593, 2 instruction(s), falls into the block at 0x004aa5c3
    mov eax, dword ptr [ebp - local_dc]          # 004aa5b6
    mov dword ptr [eax + field_25], 0x0          # 004aa5bc
L_004aa5c3:
    # block 0x004aa5c3: entered by jmp at 0x004aa522; jmp at 0x004aa5b4, 3 instruction(s), ends with forward jump to 0x004aa7e8
    mov ecx, dword ptr [ebp - local_dc]          # 004aa5c3
    mov byte ptr [ecx + field_2b], 0x0           # 004aa5c9
    jmp.d32 L_004aa7e8                           # 004aa5cd
L_004aa5d2:
    # block 0x004aa5d2: entered by jne at 0x004aa440; jne at 0x004aa450, 2 instruction(s), ends with jne to 0x004aa7e8 (forward)
    cmp dword ptr [0x5c39e5], 0x2770             # 004aa5d2
    jne.d32 L_004aa7e8                           # 004aa5dc
    # block 0x004aa5e2: entered by fall-through of jne at 0x004aa5dc, 21 instruction(s), ends with je to 0x004aa7d1 (forward)
    mov edx, dword ptr [ebp - local_dc]          # 004aa5e2
    mov eax, dword ptr [ebp - local_dc]          # 004aa5e8
    mov cx, word ptr [eax + field_23]            # 004aa5ee
    mov word ptr [edx + field_42], cx            # 004aa5f2
    mov edx, dword ptr [ebp - local_dc]          # 004aa5f6
    movsx eax, word ptr [edx + field_23]         # 004aa5fc
    imul eax, eax, 0x15c                         # 004aa600
    mov ecx, dword ptr [ebp - local_dc]          # 004aa606
    mov edx, dword ptr [ebp - local_8]           # 004aa60c
    mov ax, word ptr [edx + eax + field_233]     # 004aa60f
    mov word ptr [ecx + field_40], ax            # 004aa617
    mov edi, 0x550e44                            # 004aa61b
    mov ecx, dword ptr [ebp - local_dc]          # 004aa620
    movsx edx, word ptr [ecx + field_23]         # 004aa626
    imul edx, edx, 0x15c                         # 004aa62a
    mov eax, dword ptr [ebp - local_8]           # 004aa630
    lea esi, [eax + edx + field_119]             # 004aa633
    mov ecx, 0x9                                 # 004aa63a
    {load} xor edx, edx                          # 004aa63f
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004aa641
    je.d32 L_004aa7d1                            # 004aa643
    # block 0x004aa649: entered by fall-through of je at 0x004aa643, 18 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with je to 0x004aa7d1 (forward)
    mov eax, dword ptr [ebp - local_dc]          # 004aa649
    movsx ecx, word ptr [eax + field_23]         # 004aa64f
    imul ecx, ecx, 0x15c                         # 004aa653
    mov edx, dword ptr [ebp - local_8]           # 004aa659
    lea eax, [edx + ecx + field_119]             # 004aa65c
    push eax                                     # 004aa663
    mov ecx, 0x5c3a67                            # 004aa664
    call FUN_004fb77a                            # 004aa669
    mov ecx, dword ptr [ebp - local_dc]          # 004aa66e
    movsx edx, word ptr [ecx + field_23]         # 004aa674
    imul edx, edx, 0x15c                         # 004aa678
    mov eax, dword ptr [ebp - local_8]           # 004aa67e
    mov cx, word ptr [eax + edx + field_13a]     # 004aa681
    push ecx                                     # 004aa689
    mov ecx, 0x5c3a67                            # 004aa68a
    call FUN_004fb2e3                            # 004aa68f
    cmp dword ptr [0x5bb202], 0x0                # 004aa694
    je.d32 L_004aa7d1                            # 004aa69b
    # block 0x004aa6a1: entered by fall-through of je at 0x004aa69b, 12 instruction(s), ends with jbe to 0x004aa771 (forward)
    mov edx, dword ptr [ebp - local_dc]          # 004aa6a1
    movsx eax, word ptr [edx + field_23]         # 004aa6a7
    imul eax, eax, 0x15c                         # 004aa6ab
    mov ecx, dword ptr [ebp - local_8]           # 004aa6b1
    lea edi, [ecx + eax + field_14a]             # 004aa6b4
    or ecx, -0x1                                 # 004aa6bb
    {load} xor eax, eax                          # 004aa6be
    repne scasb al, byte ptr es:[edi]            # 004aa6c0
    not ecx                                      # 004aa6c2
    add ecx, -0x1                                # 004aa6c4
    test ecx, ecx                                # 004aa6c7
    jbe.d32 L_004aa771                           # 004aa6c9
    # block 0x004aa6cf: entered by fall-through of jbe at 0x004aa6c9, 11 instruction(s), calls FUN_00423259, ends with je to 0x004aa76a (forward)
    mov edx, dword ptr [ebp - local_dc]          # 004aa6cf
    movsx eax, word ptr [edx + field_23]         # 004aa6d5
    imul eax, eax, 0x15c                         # 004aa6d9
    mov ecx, dword ptr [ebp - local_8]           # 004aa6df
    lea edx, [ecx + eax + field_14a]             # 004aa6e2
    push edx                                     # 004aa6e9
    mov ecx, 0x619a6b                            # 004aa6ea
    call FUN_00423259                            # 004aa6ef
    mov dword ptr [ebp - local_c], eax           # 004aa6f4
    cmp dword ptr [ebp - local_c], 0x0           # 004aa6f7
    je.d8 L_004aa76a                             # 004aa6fb
    # block 0x004aa6fd: entered by fall-through of je at 0x004aa6fb, 8 instruction(s), ends with ja to 0x004aa76a (forward)
    mov edi, dword ptr [ebp - local_c]           # 004aa6fd
    or ecx, -0x1                                 # 004aa700
    {load} xor eax, eax                          # 004aa703
    repne scasb al, byte ptr es:[edi]            # 004aa705
    not ecx                                      # 004aa707
    add ecx, -0x1                                # 004aa709
    cmp ecx, 0x9c40                              # 004aa70c
    ja.d8 L_004aa76a                             # 004aa712
    # block 0x004aa714: entered by fall-through of ja at 0x004aa712, 28 instruction(s), calls FUN_00448d11, ends with forward jump to 0x004aa771
    mov edi, dword ptr [ebp - local_c]           # 004aa714
    or ecx, -0x1                                 # 004aa717
    {load} xor eax, eax                          # 004aa71a
    repne scasb al, byte ptr es:[edi]            # 004aa71c
    not ecx                                      # 004aa71e
    mov esi, dword ptr [ebp - local_c]           # 004aa720
    lea edi, [ebp - local_d8]                    # 004aa723
    {load} mov eax, ecx                          # 004aa729
    shr ecx, 0x2                                 # 004aa72b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004aa72e
    {load} mov ecx, eax                          # 004aa730
    and ecx, 0x3                                 # 004aa732
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004aa735
    lea edi, [ebp - local_d8]                    # 004aa737
    or ecx, -0x1                                 # 004aa73d
    {load} xor eax, eax                          # 004aa740
    repne scasb al, byte ptr es:[edi]            # 004aa742
    mov ecx, dword ptr [0x550e50]                # 004aa744
    mov dword ptr [edi - field_minus_1], ecx     # 004aa74a
    push 0x0                                     # 004aa74d
    push -0x1                                    # 004aa74f
    lea edx, [ebp - local_d8]                    # 004aa751
    push edx                                     # 004aa757
    mov eax, dword ptr [0x5d03b3]                # 004aa758
    push eax                                     # 004aa75d
    mov ecx, 0x619a05                            # 004aa75e
    call FUN_00448d11                            # 004aa763
    jmp.d8 L_004aa771                            # 004aa768
L_004aa76a:
    # block 0x004aa76a: entered by je at 0x004aa6fb; ja at 0x004aa712, 1 instruction(s), falls into the block at 0x004aa771
    mov dword ptr [ebp - local_c], 0x0           # 004aa76a
L_004aa771:
    # block 0x004aa771: entered by jbe at 0x004aa6c9; jmp at 0x004aa768, 2 instruction(s), ends with jne to 0x004aa7d1 (forward)
    cmp dword ptr [ebp - local_c], 0x0           # 004aa771
    jne.d8 L_004aa7d1                            # 004aa775
    # block 0x004aa777: entered by fall-through of jne at 0x004aa775, 12 instruction(s), ends with jbe to 0x004aa7d1 (forward)
    mov ecx, dword ptr [ebp - local_dc]          # 004aa777
    movsx edx, word ptr [ecx + field_23]         # 004aa77d
    imul edx, edx, 0x15c                         # 004aa781
    mov eax, dword ptr [ebp - local_8]           # 004aa787
    lea edi, [eax + edx + field_16b]             # 004aa78a
    or ecx, -0x1                                 # 004aa791
    {load} xor eax, eax                          # 004aa794
    repne scasb al, byte ptr es:[edi]            # 004aa796
    not ecx                                      # 004aa798
    add ecx, -0x1                                # 004aa79a
    test ecx, ecx                                # 004aa79d
    jbe.d8 L_004aa7d1                            # 004aa79f
    # block 0x004aa7a1: entered by fall-through of jbe at 0x004aa79f, 12 instruction(s), calls FUN_00448d11, falls into the block at 0x004aa7d1
    push 0x0                                     # 004aa7a1
    push -0x1                                    # 004aa7a3
    mov ecx, dword ptr [ebp - local_dc]          # 004aa7a5
    movsx edx, word ptr [ecx + field_23]         # 004aa7ab
    imul edx, edx, 0x15c                         # 004aa7af
    mov eax, dword ptr [ebp - local_8]           # 004aa7b5
    lea ecx, [eax + edx + field_16b]             # 004aa7b8
    push ecx                                     # 004aa7bf
    mov edx, dword ptr [0x5d03b3]                # 004aa7c0
    push edx                                     # 004aa7c6
    mov ecx, 0x619a05                            # 004aa7c7
    call FUN_00448d11                            # 004aa7cc
L_004aa7d1:
    # block 0x004aa7d1: entered by je at 0x004aa643; je at 0x004aa69b; jne at 0x004aa775; jbe at 0x004aa79f, 4 instruction(s), falls into the block at 0x004aa7e8
    mov eax, dword ptr [ebp - local_dc]          # 004aa7d1
    mov byte ptr [eax + field_2b], 0x0           # 004aa7d7
    mov ecx, dword ptr [ebp - local_dc]          # 004aa7db
    mov dword ptr [ecx + field_25], 0x2          # 004aa7e1
L_004aa7e8:
    # block 0x004aa7e8: entered by jmp at 0x004aa5cd; jne at 0x004aa5dc, 2 instruction(s), ends with jne to 0x004aa818 (forward)
    cmp dword ptr [0x5c39e5], 0x2771             # 004aa7e8
    jne.d8 L_004aa818                            # 004aa7f2
    # block 0x004aa7f4: entered by fall-through of jne at 0x004aa7f2, 6 instruction(s), falls into the block at 0x004aa818
    mov edx, dword ptr [ebp - local_dc]          # 004aa7f4
    mov byte ptr [edx + field_46], 0x1           # 004aa7fa
    mov eax, dword ptr [ebp - local_dc]          # 004aa7fe
    movsx ecx, word ptr [eax + field_21]         # 004aa804
    imul ecx, ecx, 0x8d                          # 004aa808
    mov dword ptr [ecx + 0x5bb632], 0x2          # 004aa80e
L_004aa818:
    # block 0x004aa818: entered by je at 0x004aa410; jne at 0x004aa42d; jne at 0x004aa7f2, 5 instruction(s), ends with ret
    pop edi                                      # 004aa818
    pop esi                                      # 004aa819
    {load} mov esp, ebp                          # 004aa81a
    pop ebp                                      # 004aa81c
    ret                                          # 004aa81d

