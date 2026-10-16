# FUN_00439822
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00439822
# extent:       0x00439822-0x0043a7ca (4008 code bytes)
# span:         0x00439822-0x0043a7ca (code 4008, tables 0, padding 0)
# sha256:       0f4c5aed17f4307b1663a81e4ac018e673411db0188e8932b5009f4eb3be2e07
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00439822
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       18 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_114, local_118, local_11c, local_4f5c, local_4f68, local_6088, local_608c, local_6090 and 6 more
# fields:       [eax + n] field_76, field_minus_1; [ecx + n] field_74, field_7c; [edx + n] field_7a
# callees:      calls FUN_0050c920, FUN_0044a2b7, KERNEL32.dll!GetTickCount, FUN_0050ca3e, FUN_004264e8, FUN_004c97b4, FUN_00433c60, FUN_00433e63, FUN_004343a2, FUN_0042639d, FUN_0043dbe3, FUN_004163b4, FUN_004f70b0, FUN_00415176, FUN_004bf1f0, FUN_0052139c and 12 more
# track-n:      outputs/blackmoor-decomp/src/blackmoor_app.mm:load_viewport (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 868 instruction(s), 73 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_114, 0x114  # offset -0x114
.equ local_118, 0x118  # offset -0x118
.equ local_11c, 0x11c  # offset -0x11c
.equ local_4f5c, 0x4f5c  # offset -0x4f5c
.equ local_4f68, 0x4f68  # offset -0x4f68
.equ local_6088, 0x6088  # offset -0x6088
.equ local_608c, 0x608c  # offset -0x608c
.equ local_6090, 0x6090  # offset -0x6090
.equ local_6094, 0x6094  # offset -0x6094
.equ local_6098, 0x6098  # offset -0x6098
.equ local_609c, 0x609c  # offset -0x609c
.equ local_60a0, 0x60a0  # offset -0x60a0
.equ local_60a4, 0x60a4  # offset -0x60a4
.equ local_60a8, 0x60a8  # offset -0x60a8
.equ field_74, 0x74  # offset +0x74
.equ field_76, 0x76  # offset +0x76
.equ field_7a, 0x7a  # offset +0x7a
.equ field_7c, 0x7c  # offset +0x7c

# --- external targets -----------------------------------------------
.set FUN_0040b34a, .text + (0x0040b34a - 0x401000)
.set FUN_00415011, .text + (0x00415011 - 0x401000)
.set FUN_00415176, .text + (0x00415176 - 0x401000)
.set FUN_004163b4, .text + (0x004163b4 - 0x401000)
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_00433c60, .text + (0x00433c60 - 0x401000)
.set FUN_00433e63, .text + (0x00433e63 - 0x401000)
.set FUN_004343a2, .text + (0x004343a2 - 0x401000)
.set FUN_004344bf, .text + (0x004344bf - 0x401000)
.set FUN_00434630, .text + (0x00434630 - 0x401000)
.set FUN_0043dbe3, .text + (0x0043dbe3 - 0x401000)
.set FUN_0043e484, .text + (0x0043e484 - 0x401000)
.set FUN_0043e776, .text + (0x0043e776 - 0x401000)
.set FUN_0043e8b8, .text + (0x0043e8b8 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0044a696, .text + (0x0044a696 - 0x401000)
.set FUN_004bedfa, .text + (0x004bedfa - 0x401000)
.set FUN_004bf1f0, .text + (0x004bf1f0 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004d36ed, .text + (0x004d36ed - 0x401000)
.set FUN_004e812f, .text + (0x004e812f - 0x401000)
.set FUN_004f52a9, .text + (0x004f52a9 - 0x401000)
.set FUN_004f70b0, .text + (0x004f70b0 - 0x401000)
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x00439822 - 0x401000
.globl FUN_00439822
FUN_00439822:
    # block 0x00439822: entry, 16 instruction(s), calls FUN_0050c920, ends with je to 0x00439872 (forward)
    push ebp                                     # 00439822
    {load} mov ebp, esp                          # 00439823
    push -0x1                                    # 00439825
    push 0x527e7c                                # 00439827
    mov eax, dword ptr fs:[0x0]                  # 0043982c
    push eax                                     # 00439832
    mov dword ptr fs:[0x0], esp                  # 00439833
    mov eax, 0x609c                              # 0043983a
    call FUN_0050c920                            # 0043983f
    push esi                                     # 00439844
    push edi                                     # 00439845
    mov dword ptr [ebp - local_6090], 0x0        # 00439846
    mov dword ptr [ebp - local_608c], 0x0        # 00439850
    movsx eax, word ptr [0x63a4cd]               # 0043985a
    test eax, eax                                # 00439861
    je.d8 L_00439872                             # 00439863
    # block 0x00439865: entered by fall-through of je at 0x00439863, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00439872
    push 0x546d30                                # 00439865
    call FUN_0044a2b7                            # 0043986a
    add esp, 0x4                                 # 0043986f
L_00439872:
    # block 0x00439872: entered by je at 0x00439863, 2 instruction(s), ends with je to 0x00439887 (forward)
    cmp dword ptr [0x5e32b5], 0x0                # 00439872
    je.d8 L_00439887                             # 00439879
    # block 0x0043987b: entered by fall-through of je at 0x00439879, 2 instruction(s), falls into the block at 0x00439887
    mov ecx, dword ptr [0x5bb57f]                # 0043987b
    mov dword ptr [0x5bb57b], ecx                # 00439881
L_00439887:
    # block 0x00439887: entered by je at 0x00439879, 8 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jle to 0x0043991b (forward)
    call dword ptr [0x52a23c]                    # 00439887
    mov dword ptr [ebp - local_10], eax          # 0043988d
    mov dword ptr [0x5c3a01], 0x0                # 00439890
    mov dx, word ptr [0x5bb57b]                  # 0043989a
    mov word ptr [0x5c3a4f], dx                  # 004398a1
    mov dword ptr [ebp - local_6098], 0x0        # 004398a8
    cmp dword ptr [0x5bb57b], 0x2706             # 004398b2
    jle.d8 L_0043991b                            # 004398bc
    # block 0x004398be: entered by fall-through of jle at 0x004398bc, 13 instruction(s), calls FUN_0050ca3e, FUN_004264e8, ends with je to 0x00439902 (forward)
    push 0x2706                                  # 004398be
    mov eax, dword ptr [0x5bb57b]                # 004398c3
    push eax                                     # 004398c8
    push 0x546d54                                # 004398c9
    push 0x63888b                                # 004398ce
    call FUN_0050ca3e                            # 004398d3
    add esp, 0x10                                # 004398d8
    push 0x63888b                                # 004398db
    mov ecx, 0x583979                            # 004398e0
    call FUN_004264e8                            # 004398e5
    movsx ecx, word ptr [0x63a4cd]               # 004398ea
    test ecx, ecx                                # 004398f1
    je.d8 L_00439902                             # 004398f3
    # block 0x004398f5: entered by fall-through of je at 0x004398f3, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00439902
    push 0x63888b                                # 004398f5
    call FUN_0044a2b7                            # 004398fa
    add esp, 0x4                                 # 004398ff
L_00439902:
    # block 0x00439902: entered by je at 0x004398f3, 4 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x0043a7ba
    mov dword ptr [0x63a58a], 0x1                # 00439902
    mov ecx, 0x5cf659                            # 0043990c
    call FUN_004c97b4                            # 00439911
    jmp.d32 L_0043a7ba                           # 00439916
L_0043991b:
    # block 0x0043991b: entered by jle at 0x004398bc, 15 instruction(s), calls FUN_0050ca3e, FUN_00433c60, ends with je to 0x00439975 (forward)
    movsx edx, word ptr [0x5bb57b]               # 0043991b
    push edx                                     # 00439922
    push 0x546d9c                                # 00439923
    push 0x546da0                                # 00439928
    lea eax, [ebp - local_114]                   # 0043992d
    push eax                                     # 00439933
    call FUN_0050ca3e                            # 00439934
    add esp, 0x10                                # 00439939
    lea ecx, [ebp - local_114]                   # 0043993c
    push ecx                                     # 00439942
    lea ecx, [ebp - local_6088]                  # 00439943
    call FUN_00433c60                            # 00439949
    mov dword ptr [ebp - local_4], 0x0           # 0043994e
    cmp dword ptr [0x63a58a], 0x0                # 00439955
    je.d8 L_00439975                             # 0043995c
    # block 0x0043995e: entered by fall-through of je at 0x0043995c, 4 instruction(s), calls FUN_00433e63, ends with forward jump to 0x0043a7ba
    mov dword ptr [ebp - local_4], 0xffffffff    # 0043995e
    lea ecx, [ebp - local_6088]                  # 00439965
    call FUN_00433e63                            # 0043996b
    jmp.d32 L_0043a7ba                           # 00439970
L_00439975:
    # block 0x00439975: entered by je at 0x0043995c, 5 instruction(s), calls FUN_004343a2, ends with jne to 0x00439a2c (forward)
    push 0x546da8                                # 00439975
    lea ecx, [ebp - local_6088]                  # 0043997a
    call FUN_004343a2                            # 00439980
    test eax, eax                                # 00439985
    jne.d32 L_00439a2c                           # 00439987
    # block 0x0043998d: entered by fall-through of jne at 0x00439987, 5 instruction(s), calls FUN_004343a2, ends with jne to 0x00439a14 (forward)
    push 0x546db0                                # 0043998d
    lea ecx, [ebp - local_6088]                  # 00439992
    call FUN_004343a2                            # 00439998
    test eax, eax                                # 0043999d
    jne.d8 L_00439a14                            # 0043999f
    # block 0x004399a1: entered by fall-through of jne at 0x0043999f, 13 instruction(s), calls FUN_0050ca3e, FUN_0042639d, ends with je to 0x004399e9 (forward)
    push 0x546db8                                # 004399a1
    push 0x546dc0                                # 004399a6
    push 0x546dc8                                # 004399ab
    push 0x63888b                                # 004399b0
    call FUN_0050ca3e                            # 004399b5
    add esp, 0x10                                # 004399ba
    push 0x546dd8                                # 004399bd
    push 0x546de0                                # 004399c2
    mov ecx, 0x583979                            # 004399c7
    call FUN_0042639d                            # 004399cc
    movsx edx, word ptr [0x63a4cd]               # 004399d1
    test edx, edx                                # 004399d8
    je.d8 L_004399e9                             # 004399da
    # block 0x004399dc: entered by fall-through of je at 0x004399da, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004399e9
    push 0x63888b                                # 004399dc
    call FUN_0044a2b7                            # 004399e1
    add esp, 0x4                                 # 004399e6
L_004399e9:
    # block 0x004399e9: entered by je at 0x004399da, 7 instruction(s), calls FUN_004c97b4, FUN_00433e63, ends with forward jump to 0x0043a7ba
    mov dword ptr [0x63a58a], 0x1                # 004399e9
    mov ecx, 0x5cf659                            # 004399f3
    call FUN_004c97b4                            # 004399f8
    mov dword ptr [ebp - local_4], 0xffffffff    # 004399fd
    lea ecx, [ebp - local_6088]                  # 00439a04
    call FUN_00433e63                            # 00439a0a
    jmp.d32 L_0043a7ba                           # 00439a0f
L_00439a14:
    # block 0x00439a14: entered by jne at 0x0043999f, 4 instruction(s), ends with forward jump to 0x00439a38
    mov dword ptr [ebp - local_6098], 0x1        # 00439a14
    mov eax, dword ptr [ebp - local_4f68]        # 00439a1e
    mov dword ptr [ebp - local_608c], eax        # 00439a24
    jmp.d8 L_00439a38                            # 00439a2a
L_00439a2c:
    # block 0x00439a2c: entered by jne at 0x00439987, 2 instruction(s), falls into the block at 0x00439a38
    mov ecx, dword ptr [ebp - local_4f68]        # 00439a2c
    mov dword ptr [ebp - local_6090], ecx        # 00439a32
L_00439a38:
    # block 0x00439a38: entered by jmp at 0x00439a2a, 3 instruction(s), ends with je to 0x00439a6f (forward)
    mov byte ptr [0x63888b], 0x0                 # 00439a38
    cmp dword ptr [ebp - local_4f5c], 0xa5       # 00439a3f
    je.d8 L_00439a6f                             # 00439a49
    # block 0x00439a4b: entered by fall-through of je at 0x00439a49, 2 instruction(s), ends with jne to 0x00439a6f (forward)
    cmp dword ptr [ebp - local_6098], 0x0        # 00439a4b
    jne.d8 L_00439a6f                            # 00439a52
    # block 0x00439a54: entered by fall-through of jne at 0x00439a52, 7 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x00439a9a
    lea edx, [ebp - local_114]                   # 00439a54
    push edx                                     # 00439a5a
    push 0x546df4                                # 00439a5b
    push 0x63888b                                # 00439a60
    call FUN_0050ca3e                            # 00439a65
    add esp, 0xc                                 # 00439a6a
    jmp.d8 L_00439a9a                            # 00439a6d
L_00439a6f:
    # block 0x00439a6f: entered by je at 0x00439a49; jne at 0x00439a52, 2 instruction(s), ends with je to 0x00439a9a (forward)
    cmp dword ptr [ebp - local_4f5c], 0x7e       # 00439a6f
    je.d8 L_00439a9a                             # 00439a76
    # block 0x00439a78: entered by fall-through of je at 0x00439a76, 2 instruction(s), ends with je to 0x00439a9a (forward)
    cmp dword ptr [ebp - local_6098], 0x0        # 00439a78
    je.d8 L_00439a9a                             # 00439a7f
    # block 0x00439a81: entered by fall-through of je at 0x00439a7f, 6 instruction(s), calls FUN_0050ca3e, falls into the block at 0x00439a9a
    lea eax, [ebp - local_114]                   # 00439a81
    push eax                                     # 00439a87
    push 0x546e3c                                # 00439a88
    push 0x63888b                                # 00439a8d
    call FUN_0050ca3e                            # 00439a92
    add esp, 0xc                                 # 00439a97
L_00439a9a:
    # block 0x00439a9a: entered by jmp at 0x00439a6d; je at 0x00439a76; je at 0x00439a7f, 8 instruction(s), ends with jbe to 0x00439b01 (forward)
    mov edi, 0x63888b                            # 00439a9a
    or ecx, -0x1                                 # 00439a9f
    {load} xor eax, eax                          # 00439aa2
    repne scasb al, byte ptr es:[edi]            # 00439aa4
    not ecx                                      # 00439aa6
    add ecx, -0x1                                # 00439aa8
    test ecx, ecx                                # 00439aab
    jbe.d8 L_00439b01                            # 00439aad
    # block 0x00439aaf: entered by fall-through of jbe at 0x00439aad, 6 instruction(s), calls FUN_004264e8, ends with je to 0x00439ad6 (forward)
    push 0x63888b                                # 00439aaf
    mov ecx, 0x583979                            # 00439ab4
    call FUN_004264e8                            # 00439ab9
    movsx ecx, word ptr [0x63a4cd]               # 00439abe
    test ecx, ecx                                # 00439ac5
    je.d8 L_00439ad6                             # 00439ac7
    # block 0x00439ac9: entered by fall-through of je at 0x00439ac7, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00439ad6
    push 0x63888b                                # 00439ac9
    call FUN_0044a2b7                            # 00439ace
    add esp, 0x4                                 # 00439ad3
L_00439ad6:
    # block 0x00439ad6: entered by je at 0x00439ac7, 7 instruction(s), calls FUN_004c97b4, FUN_00433e63, ends with forward jump to 0x0043a7ba
    mov dword ptr [0x63a58a], 0x1                # 00439ad6
    mov ecx, 0x5cf659                            # 00439ae0
    call FUN_004c97b4                            # 00439ae5
    mov dword ptr [ebp - local_4], 0xffffffff    # 00439aea
    lea ecx, [ebp - local_6088]                  # 00439af1
    call FUN_00433e63                            # 00439af7
    jmp.d32 L_0043a7ba                           # 00439afc
L_00439b01:
    # block 0x00439b01: entered by jbe at 0x00439aad, 2 instruction(s), ends with je to 0x00439b54 (forward)
    cmp dword ptr [ebp - local_6098], 0x0        # 00439b01
    je.d8 L_00439b54                             # 00439b08
    # block 0x00439b0a: entered by fall-through of je at 0x00439b08, 7 instruction(s), ends with jne to 0x00439b2f (forward)
    mov edi, 0x546e8c                            # 00439b0a
    mov esi, dword ptr [ebp - local_608c]        # 00439b0f
    add esi, 0x32                                # 00439b15
    mov ecx, 0xd                                 # 00439b18
    {load} xor edx, edx                          # 00439b1d
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00439b1f
    jne.d8 L_00439b2f                            # 00439b21
    # block 0x00439b23: entered by fall-through of jne at 0x00439b21, 2 instruction(s), ends with forward jump to 0x00439b52
    mov dword ptr [0x5c3a01], 0x1                # 00439b23
    jmp.d8 L_00439b52                            # 00439b2d
L_00439b2f:
    # block 0x00439b2f: entered by jne at 0x00439b21, 7 instruction(s), ends with jne to 0x00439b52 (forward)
    mov edi, 0x546e9c                            # 00439b2f
    mov esi, dword ptr [ebp - local_608c]        # 00439b34
    add esi, 0x32                                # 00439b3a
    mov ecx, 0x11                                # 00439b3d
    {load} xor eax, eax                          # 00439b42
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00439b44
    jne.d8 L_00439b52                            # 00439b46
    # block 0x00439b48: entered by fall-through of jne at 0x00439b46, 1 instruction(s), falls into the block at 0x00439b52
    mov dword ptr [0x5c3a01], 0x2                # 00439b48
L_00439b52:
    # block 0x00439b52: entered by jmp at 0x00439b2d; jne at 0x00439b46, 1 instruction(s), ends with forward jump to 0x00439b9c
    jmp.d8 L_00439b9c                            # 00439b52
L_00439b54:
    # block 0x00439b54: entered by je at 0x00439b08, 7 instruction(s), ends with jne to 0x00439b79 (forward)
    mov edi, 0x546eb0                            # 00439b54
    mov esi, dword ptr [ebp - local_6090]        # 00439b59
    add esi, 0x32                                # 00439b5f
    mov ecx, 0xd                                 # 00439b62
    {load} xor edx, edx                          # 00439b67
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00439b69
    jne.d8 L_00439b79                            # 00439b6b
    # block 0x00439b6d: entered by fall-through of jne at 0x00439b6b, 2 instruction(s), ends with forward jump to 0x00439b9c
    mov dword ptr [0x5c3a01], 0x1                # 00439b6d
    jmp.d8 L_00439b9c                            # 00439b77
L_00439b79:
    # block 0x00439b79: entered by jne at 0x00439b6b, 7 instruction(s), ends with jne to 0x00439b9c (forward)
    mov edi, 0x546ec0                            # 00439b79
    mov esi, dword ptr [ebp - local_6090]        # 00439b7e
    add esi, 0x32                                # 00439b84
    mov ecx, 0x11                                # 00439b87
    {load} xor eax, eax                          # 00439b8c
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00439b8e
    jne.d8 L_00439b9c                            # 00439b90
    # block 0x00439b92: entered by fall-through of jne at 0x00439b90, 1 instruction(s), falls into the block at 0x00439b9c
    mov dword ptr [0x5c3a01], 0x2                # 00439b92
L_00439b9c:
    # block 0x00439b9c: entered by jmp at 0x00439b52; jmp at 0x00439b77; jne at 0x00439b90, 3 instruction(s), ends with je to 0x00439cab (forward)
    movsx ecx, word ptr [0x63a4cd]               # 00439b9c
    test ecx, ecx                                # 00439ba3
    je.d32 L_00439cab                            # 00439ba5
    # block 0x00439bab: entered by fall-through of je at 0x00439ba5, 25 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, ends with je to 0x00439c31 (forward)
    push 0x546ed4                                # 00439bab
    push 0x63888b                                # 00439bb0
    call FUN_0050ca3e                            # 00439bb5
    add esp, 0x8                                 # 00439bba
    push 0x63888b                                # 00439bbd
    call FUN_0044a2b7                            # 00439bc2
    add esp, 0x4                                 # 00439bc7
    push 0x546ed8                                # 00439bca
    push 0x63888b                                # 00439bcf
    call FUN_0050ca3e                            # 00439bd4
    add esp, 0x8                                 # 00439bd9
    push 0x63888b                                # 00439bdc
    call FUN_0044a2b7                            # 00439be1
    add esp, 0x4                                 # 00439be6
    push 0x546edc                                # 00439be9
    push 0x63888b                                # 00439bee
    call FUN_0050ca3e                            # 00439bf3
    add esp, 0x8                                 # 00439bf8
    push 0x63888b                                # 00439bfb
    call FUN_0044a2b7                            # 00439c00
    add esp, 0x4                                 # 00439c05
    mov edx, dword ptr [0x5c3a01]                # 00439c08
    mov dword ptr [ebp - local_609c], edx        # 00439c0e
    cmp dword ptr [ebp - local_609c], 0x0        # 00439c14
    je.d8 L_00439c31                             # 00439c1b
    # block 0x00439c1d: entered by fall-through of je at 0x00439c1b, 2 instruction(s), ends with je to 0x00439c4b (forward)
    cmp dword ptr [ebp - local_609c], 0x1        # 00439c1d
    je.d8 L_00439c4b                             # 00439c24
    # block 0x00439c26: entered by fall-through of je at 0x00439c24, 2 instruction(s), ends with je to 0x00439c66 (forward)
    cmp dword ptr [ebp - local_609c], 0x2        # 00439c26
    je.d8 L_00439c66                             # 00439c2d
    # block 0x00439c2f: entered by fall-through of je at 0x00439c2d, 1 instruction(s), ends with forward jump to 0x00439c7f
    jmp.d8 L_00439c7f                            # 00439c2f
L_00439c31:
    # block 0x00439c31: entered by je at 0x00439c1b, 7 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x00439c7f
    mov eax, dword ptr [0x5bb57b]                # 00439c31
    push eax                                     # 00439c36
    push 0x546f08                                # 00439c37
    push 0x63888b                                # 00439c3c
    call FUN_0050ca3e                            # 00439c41
    add esp, 0xc                                 # 00439c46
    jmp.d8 L_00439c7f                            # 00439c49
L_00439c4b:
    # block 0x00439c4b: entered by je at 0x00439c24, 7 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x00439c7f
    mov ecx, dword ptr [0x5bb57b]                # 00439c4b
    push ecx                                     # 00439c51
    push 0x546f34                                # 00439c52
    push 0x63888b                                # 00439c57
    call FUN_0050ca3e                            # 00439c5c
    add esp, 0xc                                 # 00439c61
    jmp.d8 L_00439c7f                            # 00439c64
L_00439c66:
    # block 0x00439c66: entered by je at 0x00439c2d, 6 instruction(s), calls FUN_0050ca3e, falls into the block at 0x00439c7f
    mov edx, dword ptr [0x5bb57b]                # 00439c66
    push edx                                     # 00439c6c
    push 0x546f60                                # 00439c6d
    push 0x63888b                                # 00439c72
    call FUN_0050ca3e                            # 00439c77
    add esp, 0xc                                 # 00439c7c
L_00439c7f:
    # block 0x00439c7f: entered by jmp at 0x00439c2f; jmp at 0x00439c49; jmp at 0x00439c64, 10 instruction(s), calls FUN_0044a2b7, FUN_0050ca3e, falls into the block at 0x00439cab
    push 0x63888b                                # 00439c7f
    call FUN_0044a2b7                            # 00439c84
    add esp, 0x4                                 # 00439c89
    push 0x546f8c                                # 00439c8c
    push 0x63888b                                # 00439c91
    call FUN_0050ca3e                            # 00439c96
    add esp, 0x8                                 # 00439c9b
    push 0x63888b                                # 00439c9e
    call FUN_0044a2b7                            # 00439ca3
    add esp, 0x4                                 # 00439ca8
L_00439cab:
    # block 0x00439cab: entered by je at 0x00439ba5, 2 instruction(s), ends with jne to 0x0043a576 (forward)
    cmp dword ptr [0x5c3a01], 0x0                # 00439cab
    jne.d32 L_0043a576                           # 00439cb2
    # block 0x00439cb8: entered by fall-through of jne at 0x00439cb2, 5 instruction(s), calls FUN_0043dbe3, ends with jne to 0x00439cef (forward)
    push 0x0                                     # 00439cb8
    call FUN_0043dbe3                            # 00439cba
    add esp, 0x4                                 # 00439cbf
    cmp dword ptr [ebp - local_6098], 0x0        # 00439cc2
    jne.d8 L_00439cef                            # 00439cc9
    # block 0x00439ccb: entered by fall-through of jne at 0x00439cc9, 10 instruction(s), ends with forward jump to 0x00439e4c
    mov ecx, dword ptr [ebp - local_4f5c]        # 00439ccb
    mov esi, dword ptr [ebp - local_6090]        # 00439cd1
    mov edi, 0x5bb22e                            # 00439cd7
    {load} mov eax, ecx                          # 00439cdc
    shr ecx, 0x2                                 # 00439cde
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00439ce1
    {load} mov ecx, eax                          # 00439ce3
    and ecx, 0x3                                 # 00439ce5
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00439ce8
    jmp.d32 L_00439e4c                           # 00439cea
L_00439cef:
    # block 0x00439cef: entered by jne at 0x00439cc9, 78 instruction(s), falls into the block at 0x00439e4c
    mov edi, dword ptr [ebp - local_608c]        # 00439cef
    mov edx, 0x5bb22e                            # 00439cf5
    or ecx, -0x1                                 # 00439cfa
    {load} xor eax, eax                          # 00439cfd
    repne scasb al, byte ptr es:[edi]            # 00439cff
    not ecx                                      # 00439d01
    {load} sub edi, ecx                          # 00439d03
    {load} mov esi, edi                          # 00439d05
    {load} mov eax, ecx                          # 00439d07
    {load} mov edi, edx                          # 00439d09
    shr ecx, 0x2                                 # 00439d0b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00439d0e
    {load} mov ecx, eax                          # 00439d10
    and ecx, 0x3                                 # 00439d12
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00439d15
    mov ecx, dword ptr [ebp - local_608c]        # 00439d17
    add ecx, 0x32                                # 00439d1d
    {load} mov edi, ecx                          # 00439d20
    mov edx, 0x5bb260                            # 00439d22
    or ecx, -0x1                                 # 00439d27
    {load} xor eax, eax                          # 00439d2a
    repne scasb al, byte ptr es:[edi]            # 00439d2c
    not ecx                                      # 00439d2e
    {load} sub edi, ecx                          # 00439d30
    {load} mov esi, edi                          # 00439d32
    {load} mov eax, ecx                          # 00439d34
    {load} mov edi, edx                          # 00439d36
    shr ecx, 0x2                                 # 00439d38
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00439d3b
    {load} mov ecx, eax                          # 00439d3d
    and ecx, 0x3                                 # 00439d3f
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00439d42
    mov ecx, dword ptr [ebp - local_608c]        # 00439d44
    add ecx, 0x53                                # 00439d4a
    {load} mov edi, ecx                          # 00439d4d
    mov edx, 0x5bb285                            # 00439d4f
    or ecx, -0x1                                 # 00439d54
    {load} xor eax, eax                          # 00439d57
    repne scasb al, byte ptr es:[edi]            # 00439d59
    not ecx                                      # 00439d5b
    {load} sub edi, ecx                          # 00439d5d
    {load} mov esi, edi                          # 00439d5f
    {load} mov eax, ecx                          # 00439d61
    {load} mov edi, edx                          # 00439d63
    shr ecx, 0x2                                 # 00439d65
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00439d68
    {load} mov ecx, eax                          # 00439d6a
    and ecx, 0x3                                 # 00439d6c
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00439d6f
    mov ecx, dword ptr [ebp - local_608c]        # 00439d71
    mov dx, word ptr [ecx + field_74]            # 00439d77
    mov word ptr [0x5bb2aa], dx                  # 00439d7b
    mov eax, dword ptr [ebp - local_608c]        # 00439d82
    mov ecx, dword ptr [eax + field_76]          # 00439d88
    mov dword ptr [0x5bb2ae], ecx                # 00439d8b
    mov edx, dword ptr [ebp - local_608c]        # 00439d91
    mov ax, word ptr [edx + field_7a]            # 00439d97
    mov word ptr [0x5bb2b2], ax                  # 00439d9b
    mov ecx, dword ptr [ebp - local_608c]        # 00439da1
    mov dx, word ptr [ecx + field_7c]            # 00439da7
    mov word ptr [0x5bb2b4], dx                  # 00439dab
    mov word ptr [0x5bb281], 0x2                 # 00439db2
    mov word ptr [0x5bb283], 0x2                 # 00439dbb
    mov word ptr [0x5bb2a6], 0x2                 # 00439dc4
    mov word ptr [0x5bb2a8], 0x2                 # 00439dcd
    mov word ptr [0x5bb2ac], 0x1                 # 00439dd6
    mov word ptr [0x5bb2b6], 0x1                 # 00439ddf
    mov word ptr [0x5bb2b8], 0x12                # 00439de8
    mov dword ptr [0x5bb2ba], 0x0                # 00439df1
    mov dword ptr [0x5bb2be], 0x0                # 00439dfb
    mov dword ptr [0x5bb2c2], 0x0                # 00439e05
    mov word ptr [0x5bb2c6], 0x1                 # 00439e0f
    mov word ptr [0x5bb2c8], 0xa                 # 00439e18
    mov word ptr [0x5bb2ca], 0xf                 # 00439e21
    mov word ptr [0x5bb2cc], 0xf                 # 00439e2a
    mov word ptr [0x5bb2ce], 0x190               # 00439e33
    mov word ptr [0x5bb2d0], 0x42                # 00439e3c
    mov byte ptr [0x5bb2d2], 0x1                 # 00439e45
L_00439e4c:
    # block 0x00439e4c: entered by jmp at 0x00439cea, 24 instruction(s), calls FUN_004163b4, ends with jne to 0x00439ebe (forward)
    mov word ptr [0x5bb283], 0x2                 # 00439e4c
    mov dword ptr [0x5bb4df], 0xffffffff         # 00439e55
    mov edi, 0x5bb260                            # 00439e5f
    mov edx, 0x5bb424                            # 00439e64
    or ecx, -0x1                                 # 00439e69
    {load} xor eax, eax                          # 00439e6c
    repne scasb al, byte ptr es:[edi]            # 00439e6e
    not ecx                                      # 00439e70
    {load} sub edi, ecx                          # 00439e72
    {load} mov esi, edi                          # 00439e74
    {load} mov eax, ecx                          # 00439e76
    {load} mov edi, edx                          # 00439e78
    shr ecx, 0x2                                 # 00439e7a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00439e7d
    {load} mov ecx, eax                          # 00439e7f
    and ecx, 0x3                                 # 00439e81
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00439e84
    mov cx, word ptr [0x5bb281]                  # 00439e86
    mov word ptr [0x5bb575], cx                  # 00439e8d
    push 0x5bb2d3                                # 00439e94
    mov ecx, 0x5e2dbe                            # 00439e99
    call FUN_004163b4                            # 00439e9e
    test eax, eax                                # 00439ea3
    jne.d8 L_00439ebe                            # 00439ea5
    # block 0x00439ea7: entered by fall-through of jne at 0x00439ea5, 4 instruction(s), calls FUN_00433e63, ends with forward jump to 0x0043a7ba
    mov dword ptr [ebp - local_4], 0xffffffff    # 00439ea7
    lea ecx, [ebp - local_6088]                  # 00439eae
    call FUN_00433e63                            # 00439eb4
    jmp.d32 L_0043a7ba                           # 00439eb9
L_00439ebe:
    # block 0x00439ebe: entered by jne at 0x00439ea5, 5 instruction(s), ends with je to 0x00439efb (forward)
    mov edx, dword ptr [0x5bb57b]                # 00439ebe
    mov dword ptr [0x5bb57f], edx                # 00439ec4
    movsx eax, word ptr [0x63a4cd]               # 00439eca
    test eax, eax                                # 00439ed1
    je.d8 L_00439efb                             # 00439ed3
    # block 0x00439ed5: entered by fall-through of je at 0x00439ed3, 9 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00439efb
    mov ecx, dword ptr [0x5bb57f]                # 00439ed5
    push ecx                                     # 00439edb
    push 0x546fb8                                # 00439edc
    push 0x63888b                                # 00439ee1
    call FUN_0050ca3e                            # 00439ee6
    add esp, 0xc                                 # 00439eeb
    push 0x63888b                                # 00439eee
    call FUN_0044a2b7                            # 00439ef3
    add esp, 0x4                                 # 00439ef8
L_00439efb:
    # block 0x00439efb: entered by je at 0x00439ed3, 3 instruction(s), ends with jne to 0x00439f17 (forward)
    mov dword ptr [0x5a4c20], 0x0                # 00439efb
    cmp dword ptr [0x5bb4e7], 0x1                # 00439f05
    jne.d8 L_00439f17                            # 00439f0c
    # block 0x00439f0e: entered by fall-through of jne at 0x00439f0c, 1 instruction(s), falls into the block at 0x00439f17
    mov word ptr [0x5bb2ca], 0x0                 # 00439f0e
L_00439f17:
    # block 0x00439f17: entered by jne at 0x00439f0c, 2 instruction(s), ends with jne to 0x00439f6a (forward)
    cmp dword ptr [0x5e32b5], 0x0                # 00439f17
    jne.d8 L_00439f6a                            # 00439f1e
    # block 0x00439f20: entered by fall-through of jne at 0x00439f1e, 12 instruction(s), falls into the block at 0x00439f6a
    mov dx, word ptr [0x5bb599]                  # 00439f20
    mov word ptr [0x5bb597], dx                  # 00439f27
    mov ax, word ptr [0x5bb595]                  # 00439f2e
    mov word ptr [0x5bb593], ax                  # 00439f34
    mov cx, word ptr [0x5bb597]                  # 00439f3a
    mov word ptr [0x5bb50b], cx                  # 00439f41
    mov edx, dword ptr [0x5bb59b]                # 00439f48
    mov dword ptr [0x5bb5a7], edx                # 00439f4e
    mov eax, dword ptr [0x5bb59f]                # 00439f54
    mov dword ptr [0x5bb5ab], eax                # 00439f59
    mov ecx, dword ptr [0x5bb5a3]                # 00439f5e
    mov dword ptr [0x5bb5af], ecx                # 00439f64
L_00439f6a:
    # block 0x00439f6a: entered by jne at 0x00439f1e, 3 instruction(s), ends with jne to 0x00439f98 (forward)
    mov word ptr [0x5bb509], 0x2710              # 00439f6a
    cmp dword ptr [0x5bb5a7], 0x0                # 00439f73
    jne.d8 L_00439f98                            # 00439f7a
    # block 0x00439f7c: entered by fall-through of jne at 0x00439f7a, 2 instruction(s), ends with jne to 0x00439f98 (forward)
    cmp dword ptr [0x5bb5ab], 0x0                # 00439f7c
    jne.d8 L_00439f98                            # 00439f83
    # block 0x00439f85: entered by fall-through of jne at 0x00439f83, 2 instruction(s), ends with jne to 0x00439f98 (forward)
    cmp dword ptr [0x5bb5af], 0x0                # 00439f85
    jne.d8 L_00439f98                            # 00439f8c
    # block 0x00439f8e: entered by fall-through of jne at 0x00439f8c, 1 instruction(s), falls into the block at 0x00439f98
    mov dword ptr [0x5bb5af], 0x1                # 00439f8e
L_00439f98:
    # block 0x00439f98: entered by jne at 0x00439f7a; jne at 0x00439f83; jne at 0x00439f8c, 26 instruction(s), calls FUN_004f70b0, ends with jbe to 0x0043a1b1 (forward)
    mov edx, dword ptr [0x5bb5af]                # 00439f98
    push edx                                     # 00439f9e
    mov eax, dword ptr [0x5bb5ab]                # 00439f9f
    push eax                                     # 00439fa4
    mov ecx, dword ptr [0x5bb5a7]                # 00439fa5
    push ecx                                     # 00439fab
    mov edx, dword ptr [0x5bb2c2]                # 00439fac
    push edx                                     # 00439fb2
    mov eax, dword ptr [0x5bb2be]                # 00439fb3
    push eax                                     # 00439fb8
    mov ecx, dword ptr [0x5bb2ba]                # 00439fb9
    push ecx                                     # 00439fbf
    mov dx, word ptr [0x5bb2b8]                  # 00439fc0
    push edx                                     # 00439fc7
    mov ax, word ptr [0x5bb597]                  # 00439fc8
    push eax                                     # 00439fce
    mov ecx, 0x5cf1eb                            # 00439fcf
    call FUN_004f70b0                            # 00439fd4
    movsx ecx, word ptr [0x5b027c]               # 00439fd9
    mov edx, dword ptr [ebp - local_10]          # 00439fe0
    {load} add edx, ecx                          # 00439fe3
    mov dword ptr [0x5bb1e6], edx                # 00439fe5
    movsx eax, word ptr [0x5b027e]               # 00439feb
    shl eax                                      # 00439ff2
    cmp dword ptr [0x5bb4e7], eax                # 00439ff4
    jbe.d32 L_0043a1b1                           # 00439ffa
    # block 0x0043a000: entered by fall-through of jbe at 0x00439ffa, 5 instruction(s), ends with forward jump to 0x0043a026
    movsx ecx, word ptr [0x5b027e]               # 0043a000
    {load} xor edx, edx                          # 0043a007
    {load} sub edx, ecx                          # 0043a009
    mov word ptr [ebp - local_6094], dx          # 0043a00b
    jmp.d8 L_0043a026                            # 0043a012
L_0043a014:
    # block 0x0043a014: entered by jmp at 0x0043a1a7, 3 instruction(s), falls into the block at 0x0043a026
    mov ax, word ptr [ebp - local_6094]          # 0043a014
    .insn 0x66, 0x05, 0x0001{:u16}               # 0043a01b
    mov word ptr [ebp - local_6094], ax          # 0043a01f
L_0043a026:
    # block 0x0043a026: entered by jmp at 0x0043a012, 4 instruction(s), ends with jg to 0x0043a1ac (forward)
    movsx ecx, word ptr [ebp - local_6094]       # 0043a026
    movsx edx, word ptr [0x5b027e]               # 0043a02d
    {load} cmp ecx, edx                          # 0043a034
    jg.d32 L_0043a1ac                            # 0043a036
    # block 0x0043a03c: entered by fall-through of jg at 0x0043a036, 8 instruction(s), ends with jge to 0x0043a07e (forward)
    movsx eax, word ptr [0x5bb50b]               # 0043a03c
    movsx ecx, word ptr [ebp - local_6094]       # 0043a043
    {load} add eax, ecx                          # 0043a04a
    mov word ptr [ebp - local_14], ax            # 0043a04c
    movsx edx, word ptr [ebp - local_14]         # 0043a050
    movsx eax, word ptr [0x5bb4e3]               # 0043a054
    {load} cmp edx, eax                          # 0043a05b
    jge.d8 L_0043a07e                            # 0043a05d
    # block 0x0043a05f: entered by fall-through of jge at 0x0043a05d, 8 instruction(s), ends with forward jump to 0x0043a0a9
    movsx ecx, word ptr [0x5bb4e5]               # 0043a05f
    movsx edx, word ptr [0x5bb4e3]               # 0043a066
    movsx eax, word ptr [ebp - local_14]         # 0043a06d
    {load} sub edx, eax                          # 0043a071
    sub edx, 0x1                                 # 0043a073
    {load} sub ecx, edx                          # 0043a076
    mov word ptr [ebp - local_14], cx            # 0043a078
    jmp.d8 L_0043a0a9                            # 0043a07c
L_0043a07e:
    # block 0x0043a07e: entered by jge at 0x0043a05d, 4 instruction(s), ends with jle to 0x0043a0a9 (forward)
    movsx ecx, word ptr [ebp - local_14]         # 0043a07e
    movsx edx, word ptr [0x5bb4e5]               # 0043a082
    {load} cmp ecx, edx                          # 0043a089
    jle.d8 L_0043a0a9                            # 0043a08b
    # block 0x0043a08d: entered by fall-through of jle at 0x0043a08b, 6 instruction(s), falls into the block at 0x0043a0a9
    movsx eax, word ptr [ebp - local_14]         # 0043a08d
    movsx ecx, word ptr [0x5bb4e5]               # 0043a091
    {load} sub eax, ecx                          # 0043a098
    movsx edx, word ptr [0x5bb4e3]               # 0043a09a
    lea eax, [eax + edx - field_minus_1]         # 0043a0a1
    mov word ptr [ebp - local_14], ax            # 0043a0a5
L_0043a0a9:
    # block 0x0043a0a9: entered by jmp at 0x0043a07c; jle at 0x0043a08b, 4 instruction(s), ends with je to 0x0043a0f2 (forward)
    mov ecx, dword ptr [0x5bb4df]                # 0043a0a9
    mov dword ptr [ebp - local_60a0], ecx        # 0043a0af
    cmp dword ptr [ebp - local_60a0], 0x1        # 0043a0b5
    je.d8 L_0043a0f2                             # 0043a0bc
    # block 0x0043a0be: entered by fall-through of je at 0x0043a0bc, 13 instruction(s), calls FUN_00415176, ends with forward jump to 0x0043a198
    push 0x0                                     # 0043a0be
    push 0x0                                     # 0043a0c0
    movsx edx, word ptr [ebp - local_14]         # 0043a0c2
    lea eax, [2*edx + 0x5bb4a9]                  # 0043a0c6
    push eax                                     # 0043a0cd
    mov cx, word ptr [ebp - local_14]            # 0043a0ce
    push ecx                                     # 0043a0d2
    push 0x5bb2d3                                # 0043a0d3
    mov ecx, 0x5e2dbe                            # 0043a0d8
    call FUN_00415176                            # 0043a0dd
    movsx edx, word ptr [ebp - local_14]         # 0043a0e2
    mov dword ptr [4*edx + 0x5bb445], eax        # 0043a0e6
    jmp.d32 L_0043a198                           # 0043a0ed
L_0043a0f2:
    # block 0x0043a0f2: entered by je at 0x0043a0bc, 12 instruction(s), calls FUN_004bf1f0, ends with jne to 0x0043a198 (forward)
    movsx eax, word ptr [ebp - local_14]         # 0043a0f2
    add eax, 0x1                                 # 0043a0f6
    push eax                                     # 0043a0f9
    mov ecx, dword ptr [0x5bb4db]                # 0043a0fa
    push ecx                                     # 0043a100
    mov ecx, 0x6201f9                            # 0043a101
    call FUN_004bf1f0                            # 0043a106
    movsx edx, word ptr [ebp - local_14]         # 0043a10b
    mov dword ptr [4*edx + 0x5bb445], eax        # 0043a10f
    movsx eax, word ptr [ebp - local_14]         # 0043a116
    cmp dword ptr [4*eax + 0x5bb445], 0x0        # 0043a11a
    jne.d8 L_0043a198                            # 0043a122
    # block 0x0043a124: entered by fall-through of jne at 0x0043a122, 16 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with je to 0x0043a16d (forward)
    push 0x5bb320                                # 0043a124
    movsx ecx, word ptr [ebp - local_14]         # 0043a129
    push ecx                                     # 0043a12d
    lea edx, [ebp - local_114]                   # 0043a12e
    push edx                                     # 0043a134
    push 0x546fd4                                # 0043a135
    push 0x63888b                                # 0043a13a
    call FUN_0050ca3e                            # 0043a13f
    add esp, 0x14                                # 0043a144
    push 0x0                                     # 0043a147
    push 0x0                                     # 0043a149
    push 0x63888b                                # 0043a14b
    call FUN_0052139c                            # 0043a150
    movsx eax, word ptr [0x63a4cd]               # 0043a155
    test eax, eax                                # 0043a15c
    je.d8 L_0043a16d                             # 0043a15e
    # block 0x0043a160: entered by fall-through of je at 0x0043a15e, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0043a16d
    push 0x63888b                                # 0043a160
    call FUN_0044a2b7                            # 0043a165
    add esp, 0x4                                 # 0043a16a
L_0043a16d:
    # block 0x0043a16d: entered by je at 0x0043a15e, 7 instruction(s), calls FUN_004c97b4, FUN_00433e63, ends with forward jump to 0x0043a7ba
    mov dword ptr [0x63a58a], 0x4                # 0043a16d
    mov ecx, 0x5cf659                            # 0043a177
    call FUN_004c97b4                            # 0043a17c
    mov dword ptr [ebp - local_4], 0xffffffff    # 0043a181
    lea ecx, [ebp - local_6088]                  # 0043a188
    call FUN_00433e63                            # 0043a18e
    jmp.d32 L_0043a7ba                           # 0043a193
L_0043a198:
    # block 0x0043a198: entered by jmp at 0x0043a0ed; jne at 0x0043a122, 3 instruction(s), ends with backward jump to 0x0043a014
    movsx ecx, word ptr [ebp - local_14]         # 0043a198
    mov dword ptr [4*ecx + 0x5bb50d], 0x1        # 0043a19c
    jmp.d32 L_0043a014                           # 0043a1a7
L_0043a1ac:
    # block 0x0043a1ac: entered by jg at 0x0043a036, 1 instruction(s), ends with forward jump to 0x0043a2de
    jmp.d32 L_0043a2de                           # 0043a1ac
L_0043a1b1:
    # block 0x0043a1b1: entered by jbe at 0x00439ffa, 3 instruction(s), ends with forward jump to 0x0043a1ca
    mov dx, word ptr [0x5bb4e3]                  # 0043a1b1
    mov word ptr [ebp - local_14], dx            # 0043a1b8
    jmp.d8 L_0043a1ca                            # 0043a1bc
L_0043a1be:
    # block 0x0043a1be: entered by jmp at 0x0043a2d9, 3 instruction(s), falls into the block at 0x0043a1ca
    mov ax, word ptr [ebp - local_14]            # 0043a1be
    .insn 0x66, 0x05, 0x0001{:u16}               # 0043a1c2
    mov word ptr [ebp - local_14], ax            # 0043a1c6
L_0043a1ca:
    # block 0x0043a1ca: entered by jmp at 0x0043a1bc, 4 instruction(s), ends with jg to 0x0043a2de (forward)
    movsx ecx, word ptr [ebp - local_14]         # 0043a1ca
    movsx edx, word ptr [0x5bb4e5]               # 0043a1ce
    {load} cmp ecx, edx                          # 0043a1d5
    jg.d32 L_0043a2de                            # 0043a1d7
    # block 0x0043a1dd: entered by fall-through of jg at 0x0043a1d7, 4 instruction(s), ends with je to 0x0043a225 (forward)
    mov eax, dword ptr [0x5bb4df]                # 0043a1dd
    mov dword ptr [ebp - local_60a4], eax        # 0043a1e2
    cmp dword ptr [ebp - local_60a4], 0x1        # 0043a1e8
    je.d8 L_0043a225                             # 0043a1ef
    # block 0x0043a1f1: entered by fall-through of je at 0x0043a1ef, 13 instruction(s), calls FUN_00415176, ends with forward jump to 0x0043a2ca
    push 0x0                                     # 0043a1f1
    push 0x0                                     # 0043a1f3
    movsx ecx, word ptr [ebp - local_14]         # 0043a1f5
    lea edx, [2*ecx + 0x5bb4a9]                  # 0043a1f9
    push edx                                     # 0043a200
    mov ax, word ptr [ebp - local_14]            # 0043a201
    push eax                                     # 0043a205
    push 0x5bb2d3                                # 0043a206
    mov ecx, 0x5e2dbe                            # 0043a20b
    call FUN_00415176                            # 0043a210
    movsx ecx, word ptr [ebp - local_14]         # 0043a215
    mov dword ptr [4*ecx + 0x5bb445], eax        # 0043a219
    jmp.d32 L_0043a2ca                           # 0043a220
L_0043a225:
    # block 0x0043a225: entered by je at 0x0043a1ef, 12 instruction(s), calls FUN_004bf1f0, ends with jne to 0x0043a2ca (forward)
    movsx edx, word ptr [ebp - local_14]         # 0043a225
    add edx, 0x1                                 # 0043a229
    push edx                                     # 0043a22c
    mov eax, dword ptr [0x5bb4db]                # 0043a22d
    push eax                                     # 0043a232
    mov ecx, 0x6201f9                            # 0043a233
    call FUN_004bf1f0                            # 0043a238
    movsx ecx, word ptr [ebp - local_14]         # 0043a23d
    mov dword ptr [4*ecx + 0x5bb445], eax        # 0043a241
    movsx edx, word ptr [ebp - local_14]         # 0043a248
    cmp dword ptr [4*edx + 0x5bb445], 0x0        # 0043a24c
    jne.d8 L_0043a2ca                            # 0043a254
    # block 0x0043a256: entered by fall-through of jne at 0x0043a254, 16 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with je to 0x0043a29f (forward)
    push 0x5bb320                                # 0043a256
    movsx eax, word ptr [ebp - local_14]         # 0043a25b
    push eax                                     # 0043a25f
    lea ecx, [ebp - local_114]                   # 0043a260
    push ecx                                     # 0043a266
    push 0x547024                                # 0043a267
    push 0x63888b                                # 0043a26c
    call FUN_0050ca3e                            # 0043a271
    add esp, 0x14                                # 0043a276
    push 0x0                                     # 0043a279
    push 0x0                                     # 0043a27b
    push 0x63888b                                # 0043a27d
    call FUN_0052139c                            # 0043a282
    movsx edx, word ptr [0x63a4cd]               # 0043a287
    test edx, edx                                # 0043a28e
    je.d8 L_0043a29f                             # 0043a290
    # block 0x0043a292: entered by fall-through of je at 0x0043a290, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0043a29f
    push 0x63888b                                # 0043a292
    call FUN_0044a2b7                            # 0043a297
    add esp, 0x4                                 # 0043a29c
L_0043a29f:
    # block 0x0043a29f: entered by je at 0x0043a290, 7 instruction(s), calls FUN_004c97b4, FUN_00433e63, ends with forward jump to 0x0043a7ba
    mov dword ptr [0x63a58a], 0x4                # 0043a29f
    mov ecx, 0x5cf659                            # 0043a2a9
    call FUN_004c97b4                            # 0043a2ae
    mov dword ptr [ebp - local_4], 0xffffffff    # 0043a2b3
    lea ecx, [ebp - local_6088]                  # 0043a2ba
    call FUN_00433e63                            # 0043a2c0
    jmp.d32 L_0043a7ba                           # 0043a2c5
L_0043a2ca:
    # block 0x0043a2ca: entered by jmp at 0x0043a220; jne at 0x0043a254, 3 instruction(s), ends with backward jump to 0x0043a1be
    movsx eax, word ptr [ebp - local_14]         # 0043a2ca
    mov dword ptr [4*eax + 0x5bb50d], 0x1        # 0043a2ce
    jmp.d32 L_0043a1be                           # 0043a2d9
L_0043a2de:
    # block 0x0043a2de: entered by jmp at 0x0043a1ac; jg at 0x0043a1d7, 4 instruction(s), ends with forward jump to 0x0043a306
    mov dword ptr [0x5bb571], 0x1                # 0043a2de
    movsx ecx, word ptr [0x5bb4e3]               # 0043a2e8
    mov dword ptr [ebp - local_118], ecx         # 0043a2ef
    jmp.d8 L_0043a306                            # 0043a2f5
L_0043a2f7:
    # block 0x0043a2f7: entered by jmp at 0x0043a331, 3 instruction(s), falls into the block at 0x0043a306
    mov edx, dword ptr [ebp - local_118]         # 0043a2f7
    add edx, 0x1                                 # 0043a2fd
    mov dword ptr [ebp - local_118], edx         # 0043a300
L_0043a306:
    # block 0x0043a306: entered by jmp at 0x0043a2f5, 3 instruction(s), ends with jg to 0x0043a333 (forward)
    movsx eax, word ptr [0x5bb4e5]               # 0043a306
    cmp dword ptr [ebp - local_118], eax         # 0043a30d
    jg.d8 L_0043a333                             # 0043a313
    # block 0x0043a315: entered by fall-through of jg at 0x0043a313, 3 instruction(s), ends with jne to 0x0043a331 (forward)
    mov ecx, dword ptr [ebp - local_118]         # 0043a315
    cmp dword ptr [4*ecx + 0x5bb50d], 0x0        # 0043a31b
    jne.d8 L_0043a331                            # 0043a323
    # block 0x0043a325: entered by fall-through of jne at 0x0043a323, 2 instruction(s), ends with forward jump to 0x0043a333
    mov dword ptr [0x5bb571], 0x0                # 0043a325
    jmp.d8 L_0043a333                            # 0043a32f
L_0043a331:
    # block 0x0043a331: entered by jne at 0x0043a323, 1 instruction(s), ends with backward jump to 0x0043a2f7
    jmp.d8 L_0043a2f7                            # 0043a331
L_0043a333:
    # block 0x0043a333: entered by jg at 0x0043a313; jmp at 0x0043a32f, 2 instruction(s), ends with je to 0x0043a393 (forward)
    cmp dword ptr [0x5bb571], 0x0                # 0043a333
    je.d8 L_0043a393                             # 0043a33a
    # block 0x0043a33c: entered by fall-through of je at 0x0043a33a, 4 instruction(s), ends with je to 0x0043a362 (forward)
    mov edx, dword ptr [0x5bb4df]                # 0043a33c
    mov dword ptr [ebp - local_60a8], edx        # 0043a342
    cmp dword ptr [ebp - local_60a8], 0x1        # 0043a348
    je.d8 L_0043a362                             # 0043a34f
    # block 0x0043a351: entered by fall-through of je at 0x0043a34f, 4 instruction(s), calls FUN_00415011, ends with forward jump to 0x0043a371
    push 0x5bb2d3                                # 0043a351
    mov ecx, 0x5e2dbe                            # 0043a356
    call FUN_00415011                            # 0043a35b
    jmp.d8 L_0043a371                            # 0043a360
L_0043a362:
    # block 0x0043a362: entered by je at 0x0043a34f, 3 instruction(s), calls FUN_004bedfa, falls into the block at 0x0043a371
    push 0x5bb4db                                # 0043a362
    mov ecx, 0x6201f9                            # 0043a367
    call FUN_004bedfa                            # 0043a36c
L_0043a371:
    # block 0x0043a371: entered by jmp at 0x0043a360, 4 instruction(s), ends with je to 0x0043a393 (forward)
    mov dword ptr [0x5a4c20], 0x1                # 0043a371
    movsx eax, word ptr [0x63a4cd]               # 0043a37b
    test eax, eax                                # 0043a382
    je.d8 L_0043a393                             # 0043a384
    # block 0x0043a386: entered by fall-through of je at 0x0043a384, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0043a393
    push 0x547074                                # 0043a386
    call FUN_0044a2b7                            # 0043a38b
    add esp, 0x4                                 # 0043a390
L_0043a393:
    # block 0x0043a393: entered by je at 0x0043a33a; je at 0x0043a384, 2 instruction(s), ends with jne to 0x0043a4bc (forward)
    cmp dword ptr [0x5e32b5], 0x0                # 0043a393
    jne.d32 L_0043a4bc                           # 0043a39a
    # block 0x0043a3a0: entered by fall-through of jne at 0x0043a39a, 17 instruction(s), ends with jle to 0x0043a43b (forward)
    movsx ecx, word ptr [0x5bb593]               # 0043a3a0
    mov dword ptr [0x5bb587], ecx                # 0043a3a7
    mov edx, dword ptr [0x5831b2]                # 0043a3ad
    sub edx, dword ptr [0x5831aa]                # 0043a3b3
    mov eax, dword ptr [0x5bb587]                # 0043a3b9
    {load} add eax, edx                          # 0043a3be
    mov dword ptr [0x5bb58f], eax                # 0043a3c0
    mov dword ptr [0x5bb583], 0x0                # 0043a3c5
    mov ecx, dword ptr [0x5bb583]                # 0043a3cf
    add ecx, dword ptr [0x5831ae]                # 0043a3d5
    sub ecx, dword ptr [0x5831a6]                # 0043a3db
    mov dword ptr [0x5bb58b], ecx                # 0043a3e1
    mov dx, word ptr [0x5bb2c8]                  # 0043a3e7
    mov word ptr [0x5c39fd], dx                  # 0043a3ee
    mov eax, dword ptr [0x5bb58f]                # 0043a3f5
    cmp eax, dword ptr [0x5bb4fd]                # 0043a3fa
    jle.d8 L_0043a43b                            # 0043a400
    # block 0x0043a402: entered by fall-through of jle at 0x0043a400, 11 instruction(s), calls FUN_0052139c, FUN_004c97b4, FUN_00433e63, ends with forward jump to 0x0043a7ba
    push 0x0                                     # 0043a402
    push 0x0                                     # 0043a404
    push 0x5470ac                                # 0043a406
    call FUN_0052139c                            # 0043a40b
    mov dword ptr [0x63a58a], 0x4                # 0043a410
    mov ecx, 0x5cf659                            # 0043a41a
    call FUN_004c97b4                            # 0043a41f
    mov dword ptr [ebp - local_4], 0xffffffff    # 0043a424
    lea ecx, [ebp - local_6088]                  # 0043a42b
    call FUN_00433e63                            # 0043a431
    jmp.d32 L_0043a7ba                           # 0043a436
L_0043a43b:
    # block 0x0043a43b: entered by jle at 0x0043a400, 3 instruction(s), ends with jne to 0x0043a457 (forward)
    mov ecx, dword ptr [0x5bb583]                # 0043a43b
    cmp ecx, dword ptr [0x5bb4f1]                # 0043a441
    jne.d8 L_0043a457                            # 0043a447
    # block 0x0043a449: entered by fall-through of jne at 0x0043a447, 3 instruction(s), ends with je to 0x0043a4bc (forward)
    mov edx, dword ptr [0x5bb58b]                # 0043a449
    cmp edx, dword ptr [0x5bb4f9]                # 0043a44f
    je.d8 L_0043a4bc                             # 0043a455
L_0043a457:
    # block 0x0043a457: entered by jne at 0x0043a447; fall-through of je at 0x0043a455, 23 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, FUN_00433e63, ends with forward jump to 0x0043a7ba
    mov eax, dword ptr [0x5bb4f9]                # 0043a457
    push eax                                     # 0043a45c
    mov ecx, dword ptr [0x5bb58b]                # 0043a45d
    push ecx                                     # 0043a463
    mov edx, dword ptr [0x5bb4f1]                # 0043a464
    push edx                                     # 0043a46a
    mov eax, dword ptr [0x5bb583]                # 0043a46b
    push eax                                     # 0043a470
    push 0x5470e0                                # 0043a471
    push 0x63888b                                # 0043a476
    call FUN_0050ca3e                            # 0043a47b
    add esp, 0x18                                # 0043a480
    push 0x0                                     # 0043a483
    push 0x0                                     # 0043a485
    push 0x63888b                                # 0043a487
    call FUN_0052139c                            # 0043a48c
    mov dword ptr [0x63a58a], 0x4                # 0043a491
    mov ecx, 0x5cf659                            # 0043a49b
    call FUN_004c97b4                            # 0043a4a0
    mov dword ptr [ebp - local_4], 0xffffffff    # 0043a4a5
    lea ecx, [ebp - local_6088]                  # 0043a4ac
    call FUN_00433e63                            # 0043a4b2
    jmp.d32 L_0043a7ba                           # 0043a4b7
L_0043a4bc:
    # block 0x0043a4bc: entered by jne at 0x0043a39a; je at 0x0043a455, 3 instruction(s), ends with jne to 0x0043a4fc (forward)
    mov ecx, dword ptr [0x5bb4f5]                # 0043a4bc
    cmp ecx, dword ptr [0x5831aa]                # 0043a4c2
    jne.d8 L_0043a4fc                            # 0043a4c8
    # block 0x0043a4ca: entered by fall-through of jne at 0x0043a4c8, 3 instruction(s), ends with jne to 0x0043a4fc (forward)
    mov edx, dword ptr [0x5bb4fd]                # 0043a4ca
    cmp edx, dword ptr [0x5831b2]                # 0043a4d0
    jne.d8 L_0043a4fc                            # 0043a4d6
    # block 0x0043a4d8: entered by fall-through of jne at 0x0043a4d6, 3 instruction(s), ends with jne to 0x0043a4fc (forward)
    mov eax, dword ptr [0x5bb4f1]                # 0043a4d8
    cmp eax, dword ptr [0x5831a6]                # 0043a4dd
    jne.d8 L_0043a4fc                            # 0043a4e3
    # block 0x0043a4e5: entered by fall-through of jne at 0x0043a4e3, 3 instruction(s), ends with jne to 0x0043a4fc (forward)
    mov ecx, dword ptr [0x5bb4f9]                # 0043a4e5
    cmp ecx, dword ptr [0x5831ae]                # 0043a4eb
    jne.d8 L_0043a4fc                            # 0043a4f1
    # block 0x0043a4f3: entered by fall-through of jne at 0x0043a4f1, 1 instruction(s), falls into the block at 0x0043a4fc
    mov word ptr [0x5bb2cc], 0x0                 # 0043a4f3
L_0043a4fc:
    # block 0x0043a4fc: entered by jne at 0x0043a4c8; jne at 0x0043a4d6; jne at 0x0043a4e3; jne at 0x0043a4f1, 25 instruction(s), ends with forward jump to 0x0043a599
    mov dword ptr [0x5d15db], 0x9                # 0043a4fc
    mov dword ptr [0x5d15df], 0x0                # 0043a506
    mov edx, dword ptr [0x5d03bb]                # 0043a510
    mov dword ptr [0x5d15e3], edx                # 0043a516
    mov dword ptr [0x5d15e7], 0x583196           # 0043a51c
    mov dword ptr [0x5d15eb], 0x583186           # 0043a526
    mov dword ptr [0x5d15ef], 0x0                # 0043a530
    mov dword ptr [0x5d15f3], 0x1                # 0043a53a
    mov word ptr [0x5d15f7], 0x1                 # 0043a544
    mov edi, 0x547160                            # 0043a54d
    mov edx, 0x5d15fd                            # 0043a552
    or ecx, -0x1                                 # 0043a557
    {load} xor eax, eax                          # 0043a55a
    repne scasb al, byte ptr es:[edi]            # 0043a55c
    not ecx                                      # 0043a55e
    {load} sub edi, ecx                          # 0043a560
    {load} mov esi, edi                          # 0043a562
    {load} mov eax, ecx                          # 0043a564
    {load} mov edi, edx                          # 0043a566
    shr ecx, 0x2                                 # 0043a568
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043a56b
    {load} mov ecx, eax                          # 0043a56d
    and ecx, 0x3                                 # 0043a56f
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043a572
    jmp.d8 L_0043a599                            # 0043a574
L_0043a576:
    # block 0x0043a576: entered by jne at 0x00439cb2, 2 instruction(s), ends with jne to 0x0043a58b (forward)
    cmp dword ptr [0x5c3a01], 0x1                # 0043a576
    jne.d8 L_0043a58b                            # 0043a57d
    # block 0x0043a57f: entered by fall-through of jne at 0x0043a57d, 4 instruction(s), calls FUN_0043e484, ends with forward jump to 0x0043a599
    push 0x0                                     # 0043a57f
    call FUN_0043e484                            # 0043a581
    add esp, 0x4                                 # 0043a586
    jmp.d8 L_0043a599                            # 0043a589
L_0043a58b:
    # block 0x0043a58b: entered by jne at 0x0043a57d, 2 instruction(s), ends with jne to 0x0043a599 (forward)
    cmp dword ptr [0x5c3a01], 0x2                # 0043a58b
    jne.d8 L_0043a599                            # 0043a592
    # block 0x0043a594: entered by fall-through of jne at 0x0043a592, 1 instruction(s), calls FUN_0043e776, falls into the block at 0x0043a599
    call FUN_0043e776                            # 0043a594
L_0043a599:
    # block 0x0043a599: entered by jmp at 0x0043a574; jmp at 0x0043a589; jne at 0x0043a592, 5 instruction(s), calls FUN_0043e8b8, FUN_004344bf, falls into the block at 0x0043a5b4
    call FUN_0043e8b8                            # 0043a599
    push 0x547170                                # 0043a59e
    lea ecx, [ebp - local_6088]                  # 0043a5a3
    call FUN_004344bf                            # 0043a5a9
    mov dword ptr [ebp - local_11c], eax         # 0043a5ae
L_0043a5b4:
    # block 0x0043a5b4: entered by jmp at 0x0043a671, 2 instruction(s), ends with je to 0x0043a676 (forward)
    cmp dword ptr [ebp - local_11c], 0x0         # 0043a5b4
    je.d32 L_0043a676                            # 0043a5bb
    # block 0x0043a5c1: entered by fall-through of je at 0x0043a5bb, 2 instruction(s), ends with jne to 0x0043a5d6 (forward)
    cmp dword ptr [0x5c3a01], 0x0                # 0043a5c1
    jne.d8 L_0043a5d6                            # 0043a5c8
    # block 0x0043a5ca: entered by fall-through of jne at 0x0043a5c8, 3 instruction(s), ends with jge to 0x0043a5ee (forward)
    movsx ecx, word ptr [0x5c39e3]               # 0043a5ca
    cmp ecx, 0x78                                # 0043a5d1
    jge.d8 L_0043a5ee                            # 0043a5d4
L_0043a5d6:
    # block 0x0043a5d6: entered by jne at 0x0043a5c8; fall-through of jge at 0x0043a5d4, 2 instruction(s), ends with je to 0x0043a645 (forward)
    cmp dword ptr [0x5c3a01], 0x0                # 0043a5d6
    je.d8 L_0043a645                             # 0043a5dd
    # block 0x0043a5df: entered by fall-through of je at 0x0043a5dd, 3 instruction(s), ends with jl to 0x0043a645 (forward)
    movsx edx, word ptr [0x5c39e3]               # 0043a5df
    cmp edx, 0xf0                                # 0043a5e6
    jl.d8 L_0043a645                             # 0043a5ec
L_0043a5ee:
    # block 0x0043a5ee: entered by jge at 0x0043a5d4; fall-through of jl at 0x0043a5ec, 17 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_00433e63, ends with forward jump to 0x0043a7ba
    mov eax, dword ptr [0x5bb57b]                # 0043a5ee
    push eax                                     # 0043a5f3
    push 0x547174                                # 0043a5f4
    push 0x63888b                                # 0043a5f9
    call FUN_0050ca3e                            # 0043a5fe
    add esp, 0xc                                 # 0043a603
    push 0x63888b                                # 0043a606
    push 0x547180                                # 0043a60b
    mov ecx, 0x583979                            # 0043a610
    call FUN_0042639d                            # 0043a615
    mov dword ptr [0x63a58a], 0x1                # 0043a61a
    mov ecx, 0x5cf659                            # 0043a624
    call FUN_004c97b4                            # 0043a629
    mov dword ptr [ebp - local_4], 0xffffffff    # 0043a62e
    lea ecx, [ebp - local_6088]                  # 0043a635
    call FUN_00433e63                            # 0043a63b
    jmp.d32 L_0043a7ba                           # 0043a640
L_0043a645:
    # block 0x0043a645: entered by je at 0x0043a5dd; jl at 0x0043a5ec, 11 instruction(s), calls FUN_0040b34a, FUN_00434630, ends with backward jump to 0x0043a5b4
    mov ecx, dword ptr [ebp - local_4f5c]        # 0043a645
    push ecx                                     # 0043a64b
    mov edx, dword ptr [ebp - local_4f68]        # 0043a64c
    push edx                                     # 0043a652
    call FUN_0040b34a                            # 0043a653
    add esp, 0x8                                 # 0043a658
    push 0x5471a4                                # 0043a65b
    lea ecx, [ebp - local_6088]                  # 0043a660
    call FUN_00434630                            # 0043a666
    mov dword ptr [ebp - local_11c], eax         # 0043a66b
    jmp.d32 L_0043a5b4                           # 0043a671
L_0043a676:
    # block 0x0043a676: entered by je at 0x0043a5bb, 2 instruction(s), ends with jne to 0x0043a693 (forward)
    cmp dword ptr [0x5bb210], 0x0                # 0043a676
    jne.d8 L_0043a693                            # 0043a67d
    # block 0x0043a67f: entered by fall-through of jne at 0x0043a67d, 2 instruction(s), falls into the block at 0x0043a693
    mov dword ptr [0x5bb1ca], 0x1                # 0043a67f
    mov dword ptr [0x5bb210], 0x1                # 0043a689
L_0043a693:
    # block 0x0043a693: entered by jne at 0x0043a67d, 6 instruction(s), calls FUN_004e812f, FUN_004d36ed, FUN_0044a696, ends with jne to 0x0043a6cf (forward)
    mov ecx, 0x571442                            # 0043a693
    call FUN_004e812f                            # 0043a698
    call FUN_004d36ed                            # 0043a69d
    call FUN_0044a696                            # 0043a6a2
    cmp dword ptr [0x5e32b5], 0x0                # 0043a6a7
    jne.d8 L_0043a6cf                            # 0043a6ae
    # block 0x0043a6b0: entered by fall-through of jne at 0x0043a6ae, 5 instruction(s), falls into the block at 0x0043a6cf
    mov eax, dword ptr [0x5bb57b]                # 0043a6b0
    mov cx, word ptr [2*eax + 0x587b2d]          # 0043a6b5
    add cx, 0x1                                  # 0043a6bd
    mov edx, dword ptr [0x5bb57b]                # 0043a6c1
    mov word ptr [2*edx + 0x587b2d], cx          # 0043a6c7
L_0043a6cf:
    # block 0x0043a6cf: entered by jne at 0x0043a6ae, 4 instruction(s), ends with je to 0x0043a6f6 (forward)
    {load} xor eax, eax                          # 0043a6cf
    mov al, byte ptr [0x5b0288]                  # 0043a6d1
    test eax, eax                                # 0043a6d6
    je.d8 L_0043a6f6                             # 0043a6d8
    # block 0x0043a6da: entered by fall-through of je at 0x0043a6d8, 4 instruction(s), falls into the block at 0x0043a6f6
    mov cx, word ptr [0x5b0289]                  # 0043a6da
    mov word ptr [0x5bb2ce], cx                  # 0043a6e1
    mov dx, word ptr [0x5b028b]                  # 0043a6e8
    mov word ptr [0x5bb2d0], dx                  # 0043a6ef
L_0043a6f6:
    # block 0x0043a6f6: entered by je at 0x0043a6d8, 5 instruction(s), calls FUN_004f52a9, ends with je to 0x0043a745 (forward)
    mov ecx, 0x5cf1eb                            # 0043a6f6
    call FUN_004f52a9                            # 0043a6fb
    movsx eax, word ptr [0x63a4cd]               # 0043a700
    test eax, eax                                # 0043a707
    je.d8 L_0043a745                             # 0043a709
    # block 0x0043a70b: entered by fall-through of je at 0x0043a709, 15 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x0043a745
    mov ecx, dword ptr [0x5bb58b]                # 0043a70b
    push ecx                                     # 0043a711
    mov edx, dword ptr [0x5bb583]                # 0043a712
    push edx                                     # 0043a718
    mov eax, dword ptr [0x5bb58f]                # 0043a719
    push eax                                     # 0043a71e
    mov ecx, dword ptr [0x5bb587]                # 0043a71f
    push ecx                                     # 0043a725
    push 0x5471a8                                # 0043a726
    push 0x63888b                                # 0043a72b
    call FUN_0050ca3e                            # 0043a730
    add esp, 0x18                                # 0043a735
    push 0x63888b                                # 0043a738
    call FUN_0044a2b7                            # 0043a73d
    add esp, 0x4                                 # 0043a742
L_0043a745:
    # block 0x0043a745: entered by je at 0x0043a709, 2 instruction(s), ends with jne to 0x0043a773 (forward)
    cmp dword ptr [0x5e32b5], 0x0                # 0043a745
    jne.d8 L_0043a773                            # 0043a74c
    # block 0x0043a74e: entered by fall-through of jne at 0x0043a74c, 2 instruction(s), ends with jne to 0x0043a773 (forward)
    cmp dword ptr [0x5e32b9], 0x0                # 0043a74e
    jne.d8 L_0043a773                            # 0043a755
    # block 0x0043a757: entered by fall-through of jne at 0x0043a755, 2 instruction(s), ends with je to 0x0043a773 (forward)
    cmp dword ptr [0x5bb57b], 0x0                # 0043a757
    je.d8 L_0043a773                             # 0043a75e
    # block 0x0043a760: entered by fall-through of je at 0x0043a75e, 2 instruction(s), ends with jne to 0x0043a773 (forward)
    cmp dword ptr [0x5bb1de], 0x0                # 0043a760
    jne.d8 L_0043a773                            # 0043a767
    # block 0x0043a769: entered by fall-through of jne at 0x0043a767, 1 instruction(s), falls into the block at 0x0043a773
    mov dword ptr [0x5e32b9], 0x1                # 0043a769
L_0043a773:
    # block 0x0043a773: entered by jne at 0x0043a74c; jne at 0x0043a755; je at 0x0043a75e; jne at 0x0043a767, 3 instruction(s), ends with je to 0x0043a790 (forward)
    mov dword ptr [0x5e32b5], 0x0                # 0043a773
    cmp dword ptr [0x63a4d9], 0x0                # 0043a77d
    je.d8 L_0043a790                             # 0043a784
    # block 0x0043a786: entered by fall-through of je at 0x0043a784, 1 instruction(s), falls into the block at 0x0043a790
    mov dword ptr [0x63a4e9], 0x0                # 0043a786
L_0043a790:
    # block 0x0043a790: entered by je at 0x0043a784, 3 instruction(s), ends with je to 0x0043a7a8 (forward)
    movsx edx, word ptr [0x63a4cd]               # 0043a790
    test edx, edx                                # 0043a797
    je.d8 L_0043a7a8                             # 0043a799
    # block 0x0043a79b: entered by fall-through of je at 0x0043a799, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0043a7a8
    push 0x5471e4                                # 0043a79b
    call FUN_0044a2b7                            # 0043a7a0
    add esp, 0x4                                 # 0043a7a5
L_0043a7a8:
    # block 0x0043a7a8: entered by je at 0x0043a799, 3 instruction(s), calls FUN_00433e63, falls into the block at 0x0043a7ba
    mov dword ptr [ebp - local_4], 0xffffffff    # 0043a7a8
    lea ecx, [ebp - local_6088]                  # 0043a7af
    call FUN_00433e63                            # 0043a7b5
L_0043a7ba:
    # block 0x0043a7ba: entered by jmp at 0x00439916; jmp at 0x00439970; jmp at 0x00439a0f; jmp at 0x00439afc; more, 7 instruction(s), ends with ret
    mov ecx, dword ptr [ebp - local_c]           # 0043a7ba
    mov dword ptr fs:[0x0], ecx                  # 0043a7bd
    pop edi                                      # 0043a7c4
    pop esi                                      # 0043a7c5
    {load} mov esp, ebp                          # 0043a7c6
    pop ebp                                      # 0043a7c8
    ret                                          # 0043a7c9

