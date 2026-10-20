# FUN_0041c544
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041c544
# extent:       0x0041c544-0x0041c770 (556 code bytes)
# span:         0x0041c544-0x0041c770 (code 556, tables 0, padding 0)
# sha256:       8fc0e546a1d150c81da998a294be229b9b654916c674a1ae2f6b1460ee840632
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m41c544_init_record
# naming:       native port src/original_methods_fl28b.c:m41c544_init_record (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      Initialises a record: the constant string copies, the field stores from the source, the 0x423259 text pointer with its debug-report arm and the missing-text fallback; fully executed. See tasks/fl28b-handoff.md.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_21, field_22, field_23, field_24, field_26, field_76c, field_778, field_783, field_78d, field_793, field_799; [ecx + n] field_28, field_768, field_76e, field_77c, field_785, field_791, field_79b; [edx + n] field_76a, field_770, field_779, field_77a, field_77b, field_77d, field_77f, field_781, field_789
# callees:      calls FUN_00423259, FUN_0050ca3e, FUN_0052139c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl28b.c:copy_string (function ledger class native_oracle_verified; also m41c544_init_record; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 155 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_21, 0x21  # offset +0x21
.equ field_22, 0x22  # offset +0x22
.equ field_23, 0x23  # offset +0x23
.equ field_24, 0x24  # offset +0x24
.equ field_26, 0x26  # offset +0x26
.equ field_28, 0x28  # offset +0x28
.equ field_768, 0x768  # offset +0x768
.equ field_76a, 0x76a  # offset +0x76a
.equ field_76c, 0x76c  # offset +0x76c
.equ field_76e, 0x76e  # offset +0x76e
.equ field_770, 0x770  # offset +0x770
.equ field_778, 0x778  # offset +0x778
.equ field_779, 0x779  # offset +0x779
.equ field_77a, 0x77a  # offset +0x77a
.equ field_77b, 0x77b  # offset +0x77b
.equ field_77c, 0x77c  # offset +0x77c
.equ field_77d, 0x77d  # offset +0x77d
.equ field_77f, 0x77f  # offset +0x77f
.equ field_781, 0x781  # offset +0x781
.equ field_783, 0x783  # offset +0x783
.equ field_785, 0x785  # offset +0x785
.equ field_789, 0x789  # offset +0x789
.equ field_78d, 0x78d  # offset +0x78d
.equ field_791, 0x791  # offset +0x791
.equ field_793, 0x793  # offset +0x793
.equ field_799, 0x799  # offset +0x799
.equ field_79b, 0x79b  # offset +0x79b

# --- external targets -----------------------------------------------
.set FUN_00423259, .text + (0x00423259 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x0041c544 - 0x401000
.globl FUN_0041c544
FUN_0041c544:
    # block 0x0041c544: entry, 77 instruction(s), calls FUN_00423259, ends with jne to 0x0041c718 (forward)
    push ebp                                     # 0041c544
    {load} mov ebp, esp                          # 0041c545
    sub esp, 0x8                                 # 0041c547
    push esi                                     # 0041c54a
    push edi                                     # 0041c54b
    mov dword ptr [ebp - local_8], ecx           # 0041c54c
    mov edi, 0x5431b0                            # 0041c54f
    mov eax, dword ptr [ebp + arg_8]             # 0041c554
    add eax, 0x747                               # 0041c557
    {load} mov edx, eax                          # 0041c55c
    or ecx, -0x1                                 # 0041c55e
    {load} xor eax, eax                          # 0041c561
    repne scasb al, byte ptr es:[edi]            # 0041c563
    not ecx                                      # 0041c565
    {load} sub edi, ecx                          # 0041c567
    {load} mov esi, edi                          # 0041c569
    {load} mov eax, ecx                          # 0041c56b
    {load} mov edi, edx                          # 0041c56d
    shr ecx, 0x2                                 # 0041c56f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041c572
    {load} mov ecx, eax                          # 0041c574
    and ecx, 0x3                                 # 0041c576
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0041c579
    mov ecx, dword ptr [ebp + arg_8]             # 0041c57b
    mov word ptr [ecx + field_768], 0xd          # 0041c57e
    mov edx, dword ptr [ebp + arg_8]             # 0041c587
    mov word ptr [edx + field_76a], 0x2          # 0041c58a
    mov eax, dword ptr [ebp + arg_8]             # 0041c593
    mov word ptr [eax + field_76c], 0x1          # 0041c596
    mov ecx, dword ptr [ebp + arg_8]             # 0041c59f
    mov word ptr [ecx + field_76e], 0x1          # 0041c5a2
    mov edx, dword ptr [ebp + arg_8]             # 0041c5ab
    mov dword ptr [edx + field_770], 0x1         # 0041c5ae
    mov eax, dword ptr [ebp + arg_8]             # 0041c5b8
    mov byte ptr [eax + field_778], 0x0          # 0041c5bb
    mov ecx, dword ptr [ebp + arg_8]             # 0041c5c2
    mov byte ptr [ecx + field_77c], 0x2          # 0041c5c5
    mov edx, dword ptr [ebp + arg_8]             # 0041c5cc
    mov word ptr [edx + field_781], 0x0          # 0041c5cf
    mov eax, dword ptr [ebp + arg_8]             # 0041c5d8
    mov word ptr [eax + field_783], 0x1          # 0041c5db
    mov ecx, dword ptr [ebp + arg_8]             # 0041c5e4
    mov dword ptr [ecx + field_785], 0x0         # 0041c5e7
    mov edx, dword ptr [ebp + arg_8]             # 0041c5f1
    mov dword ptr [edx + field_789], 0x0         # 0041c5f4
    mov eax, dword ptr [ebp + arg_8]             # 0041c5fe
    mov dword ptr [eax + field_78d], 0x1         # 0041c601
    mov ecx, dword ptr [ebp + arg_8]             # 0041c60b
    mov word ptr [ecx + field_791], 0x2          # 0041c60e
    mov edx, dword ptr [ebp + arg_8]             # 0041c617
    mov eax, dword ptr [ebp + arg_c]             # 0041c61a
    mov cl, byte ptr [eax + field_21]            # 0041c61d
    mov byte ptr [edx + field_779], cl           # 0041c620
    mov edx, dword ptr [ebp + arg_8]             # 0041c626
    mov eax, dword ptr [ebp + arg_c]             # 0041c629
    mov cl, byte ptr [eax + field_22]            # 0041c62c
    mov byte ptr [edx + field_77a], cl           # 0041c62f
    mov edx, dword ptr [ebp + arg_8]             # 0041c635
    mov eax, dword ptr [ebp + arg_c]             # 0041c638
    mov cl, byte ptr [eax + field_23]            # 0041c63b
    mov byte ptr [edx + field_77b], cl           # 0041c63e
    mov edx, dword ptr [ebp + arg_8]             # 0041c644
    mov eax, dword ptr [ebp + arg_c]             # 0041c647
    mov cx, word ptr [eax + field_24]            # 0041c64a
    mov word ptr [edx + field_77d], cx           # 0041c64e
    mov edx, dword ptr [ebp + arg_8]             # 0041c655
    mov eax, dword ptr [ebp + arg_c]             # 0041c658
    mov cx, word ptr [eax + field_26]            # 0041c65b
    mov word ptr [edx + field_77f], cx           # 0041c65f
    mov edx, dword ptr [ebp + arg_c]             # 0041c666
    push edx                                     # 0041c669
    mov ecx, dword ptr [ebp - local_8]           # 0041c66a
    add ecx, 0xfd1                               # 0041c66d
    call FUN_00423259                            # 0041c673
    mov dword ptr [ebp - local_4], eax           # 0041c678
    cmp dword ptr [ebp - local_4], 0x0           # 0041c67b
    jne.d32 L_0041c718                           # 0041c67f
    # block 0x0041c685: entered by fall-through of jne at 0x0041c67f, 3 instruction(s), ends with je to 0x0041c6e9 (forward)
    movsx eax, word ptr [0x63a4cd]               # 0041c685
    test eax, eax                                # 0041c68c
    je.d8 L_0041c6e9                             # 0041c68e
    # block 0x0041c690: entered by fall-through of je at 0x0041c68e, 30 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x0041c716
    mov ecx, dword ptr [0x5bb57b]                # 0041c690
    push ecx                                     # 0041c696
    mov edx, dword ptr [ebp + arg_c]             # 0041c697
    push edx                                     # 0041c69a
    push 0x5431b8                                # 0041c69b
    push 0x63888b                                # 0041c6a0
    call FUN_0050ca3e                            # 0041c6a5
    add esp, 0x10                                # 0041c6aa
    push 0x0                                     # 0041c6ad
    push 0x0                                     # 0041c6af
    push 0x63888b                                # 0041c6b1
    call FUN_0052139c                            # 0041c6b6
    mov edi, 0x5431fc                            # 0041c6bb
    mov eax, dword ptr [ebp + arg_8]             # 0041c6c0
    add eax, 0x16b                               # 0041c6c3
    {load} mov edx, eax                          # 0041c6c8
    or ecx, -0x1                                 # 0041c6ca
    {load} xor eax, eax                          # 0041c6cd
    repne scasb al, byte ptr es:[edi]            # 0041c6cf
    not ecx                                      # 0041c6d1
    {load} sub edi, ecx                          # 0041c6d3
    {load} mov esi, edi                          # 0041c6d5
    {load} mov eax, ecx                          # 0041c6d7
    {load} mov edi, edx                          # 0041c6d9
    shr ecx, 0x2                                 # 0041c6db
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041c6de
    {load} mov ecx, eax                          # 0041c6e0
    and ecx, 0x3                                 # 0041c6e2
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0041c6e5
    jmp.d8 L_0041c716                            # 0041c6e7
L_0041c6e9:
    # block 0x0041c6e9: entered by je at 0x0041c68e, 17 instruction(s), falls into the block at 0x0041c716
    mov edi, 0x543240                            # 0041c6e9
    mov ecx, dword ptr [ebp + arg_8]             # 0041c6ee
    add ecx, 0x16b                               # 0041c6f1
    {load} mov edx, ecx                          # 0041c6f7
    or ecx, -0x1                                 # 0041c6f9
    {load} xor eax, eax                          # 0041c6fc
    repne scasb al, byte ptr es:[edi]            # 0041c6fe
    not ecx                                      # 0041c700
    {load} sub edi, ecx                          # 0041c702
    {load} mov esi, edi                          # 0041c704
    {load} mov eax, ecx                          # 0041c706
    {load} mov edi, edx                          # 0041c708
    shr ecx, 0x2                                 # 0041c70a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041c70d
    {load} mov ecx, eax                          # 0041c70f
    and ecx, 0x3                                 # 0041c711
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0041c714
L_0041c716:
    # block 0x0041c716: entered by jmp at 0x0041c6e7, 1 instruction(s), ends with forward jump to 0x0041c73e
    jmp.d8 L_0041c73e                            # 0041c716
L_0041c718:
    # block 0x0041c718: entered by jne at 0x0041c67f, 14 instruction(s), falls into the block at 0x0041c73e
    mov edi, dword ptr [ebp - local_4]           # 0041c718
    or ecx, -0x1                                 # 0041c71b
    {load} xor eax, eax                          # 0041c71e
    repne scasb al, byte ptr es:[edi]            # 0041c720
    not ecx                                      # 0041c722
    mov esi, dword ptr [ebp - local_4]           # 0041c724
    mov edi, dword ptr [ebp + arg_8]             # 0041c727
    add edi, 0x16b                               # 0041c72a
    {load} mov edx, ecx                          # 0041c730
    shr ecx, 0x2                                 # 0041c732
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041c735
    {load} mov ecx, edx                          # 0041c737
    and ecx, 0x3                                 # 0041c739
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0041c73c
L_0041c73e:
    # block 0x0041c73e: entered by jmp at 0x0041c716, 13 instruction(s), ends with ret 0x8
    mov eax, dword ptr [ebp + arg_8]             # 0041c73e
    mov ecx, dword ptr [ebp + arg_c]             # 0041c741
    mov dx, word ptr [ecx + field_28]            # 0041c744
    mov word ptr [eax + field_793], dx           # 0041c748
    mov eax, dword ptr [ebp + arg_8]             # 0041c74f
    mov word ptr [eax + field_799], 0x0          # 0041c752
    mov ecx, dword ptr [ebp + arg_8]             # 0041c75b
    mov dword ptr [ecx + field_79b], 0x0         # 0041c75e
    pop edi                                      # 0041c768
    pop esi                                      # 0041c769
    {load} mov esp, ebp                          # 0041c76a
    pop ebp                                      # 0041c76c
    ret 0x8                                      # 0041c76d

