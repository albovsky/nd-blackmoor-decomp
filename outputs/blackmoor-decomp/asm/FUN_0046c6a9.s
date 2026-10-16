# FUN_0046c6a9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046c6a9
# extent:       0x0046c6a9-0x0046cc8b (1506 code bytes)
# span:         0x0046c6a9-0x0046cc8b (code 1506, tables 0, padding 0)
# sha256:       f889dc8129791671c212c676e24c3a6c1f8523d444220066e49b956f9ced942b
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0046c6a9
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_1e, field_62d, field_65e, field_48a0, field_48a4, field_48a8, field_48aa, field_48ac, field_48ae, field_49e0, field_49e2, field_4a28 and 5 more; [ecx + n] field_1e, field_48aa, field_48ac, field_48ae, field_49e0, field_49e2, field_4a24, field_4a2c, field_4a34, field_4a3c, field_4a3e, field_4a50 and 2 more; [edx + n] field_1e, field_48a0, field_48a4, field_48a8, field_48ac, field_48ae, field_49e0, field_49e2, field_4a2c, field_4a30, field_4a34, field_4a3c and 2 more
# callees:      calls FUN_0046cc8b, FUN_004f6334, FUN_004fb2e3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 304 instruction(s), 32 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_1e, 0x1e  # offset +0x1e
.equ field_62d, 0x62d  # offset +0x62d
.equ field_65e, 0x65e  # offset +0x65e
.equ field_48a0, 0x48a0  # offset +0x48a0
.equ field_48a4, 0x48a4  # offset +0x48a4
.equ field_48a8, 0x48a8  # offset +0x48a8
.equ field_48aa, 0x48aa  # offset +0x48aa
.equ field_48ac, 0x48ac  # offset +0x48ac
.equ field_48ae, 0x48ae  # offset +0x48ae
.equ field_49e0, 0x49e0  # offset +0x49e0
.equ field_49e2, 0x49e2  # offset +0x49e2
.equ field_4a24, 0x4a24  # offset +0x4a24
.equ field_4a28, 0x4a28  # offset +0x4a28
.equ field_4a2c, 0x4a2c  # offset +0x4a2c
.equ field_4a30, 0x4a30  # offset +0x4a30
.equ field_4a34, 0x4a34  # offset +0x4a34
.equ field_4a3c, 0x4a3c  # offset +0x4a3c
.equ field_4a3e, 0x4a3e  # offset +0x4a3e
.equ field_4a48, 0x4a48  # offset +0x4a48
.equ field_4a4c, 0x4a4c  # offset +0x4a4c
.equ field_4a50, 0x4a50  # offset +0x4a50
.equ field_4a52, 0x4a52  # offset +0x4a52
.equ field_4a54, 0x4a54  # offset +0x4a54
.equ field_4a55, 0x4a55  # offset +0x4a55
.equ field_4a59, 0x4a59  # offset +0x4a59

# --- external targets -----------------------------------------------
.set FUN_0046cc8b, .text + (0x0046cc8b - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x0046c6a9 - 0x401000
.globl FUN_0046c6a9
FUN_0046c6a9:
    # block 0x0046c6a9: entry, 14 instruction(s), ends with je to 0x0046cc85 (forward)
    push ebp                                     # 0046c6a9
    {load} mov ebp, esp                          # 0046c6aa
    sub esp, 0x10                                # 0046c6ac
    push esi                                     # 0046c6af
    push edi                                     # 0046c6b0
    mov dword ptr [ebp - local_10], ecx          # 0046c6b1
    mov eax, dword ptr [ebp - local_10]          # 0046c6b4
    movsx ecx, word ptr [eax + field_1e]         # 0046c6b7
    imul ecx, ecx, 0x8d                          # 0046c6bb
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046c6c1
    mov dword ptr [ebp - local_4], edx           # 0046c6c7
    mov eax, dword ptr [ebp - local_10]          # 0046c6ca
    cmp dword ptr [eax + field_4a48], 0x0        # 0046c6cd
    je.d32 L_0046cc85                            # 0046c6d4
    # block 0x0046c6da: entered by fall-through of je at 0x0046c6d4, 5 instruction(s), ends with jne to 0x0046cc85 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0046c6da
    {load} xor edx, edx                          # 0046c6dd
    mov dl, byte ptr [ecx + field_4a59]          # 0046c6df
    test edx, edx                                # 0046c6e5
    jne.d32 L_0046cc85                           # 0046c6e7
    # block 0x0046c6ed: entered by fall-through of jne at 0x0046c6e7, 3 instruction(s), ends with jne to 0x0046cc85 (forward)
    mov eax, dword ptr [ebp - local_10]          # 0046c6ed
    cmp dword ptr [eax + field_4a55], 0x0        # 0046c6f0
    jne.d32 L_0046cc85                           # 0046c6f7
    # block 0x0046c6fd: entered by fall-through of jne at 0x0046c6f7, 5 instruction(s), ends with jne to 0x0046cc85 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0046c6fd
    movsx edx, word ptr [ecx + field_1e]         # 0046c700
    imul edx, edx, 0x8d                          # 0046c704
    cmp dword ptr [edx + 0x5bb632], 0x1          # 0046c70a
    jne.d32 L_0046cc85                           # 0046c711
    # block 0x0046c717: entered by fall-through of jne at 0x0046c711, 3 instruction(s), ends with jne to 0x0046c755 (forward)
    mov eax, dword ptr [ebp - local_10]          # 0046c717
    cmp dword ptr [eax + field_4a2c], 0x0        # 0046c71a
    jne.d8 L_0046c755                            # 0046c721
    # block 0x0046c723: entered by fall-through of jne at 0x0046c721, 2 instruction(s), ends with jne to 0x0046c755 (forward)
    cmp dword ptr [0x5c39e5], 0x27ea             # 0046c723
    jne.d8 L_0046c755                            # 0046c72d
    # block 0x0046c72f: entered by fall-through of jne at 0x0046c72d, 7 instruction(s), ends with forward jump to 0x0046cb7c
    mov ecx, dword ptr [ebp - local_10]          # 0046c72f
    mov byte ptr [ecx + field_4a54], 0x1         # 0046c732
    mov edx, dword ptr [ebp - local_10]          # 0046c739
    movsx eax, word ptr [edx + field_1e]         # 0046c73c
    imul eax, eax, 0x8d                          # 0046c740
    mov dword ptr [eax + 0x5bb632], 0x2          # 0046c746
    jmp.d32 L_0046cb7c                           # 0046c750
L_0046c755:
    # block 0x0046c755: entered by jne at 0x0046c721; jne at 0x0046c72d, 3 instruction(s), ends with jne to 0x0046c8b3 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0046c755
    cmp dword ptr [ecx + field_4a2c], 0x0        # 0046c758
    jne.d32 L_0046c8b3                           # 0046c75f
    # block 0x0046c765: entered by fall-through of jne at 0x0046c75f, 2 instruction(s), ends with je to 0x0046c781 (forward)
    cmp dword ptr [0x5c39e5], 0x27e6             # 0046c765
    je.d8 L_0046c781                             # 0046c76f
    # block 0x0046c771: entered by fall-through of je at 0x0046c76f, 2 instruction(s), ends with jne to 0x0046c8b3 (forward)
    cmp dword ptr [0x5c39e5], 0x27e8             # 0046c771
    jne.d32 L_0046c8b3                           # 0046c77b
L_0046c781:
    # block 0x0046c781: entered by je at 0x0046c76f; fall-through of jne at 0x0046c77b, 12 instruction(s), ends with jne to 0x0046c836 (forward)
    mov edx, dword ptr [ebp - local_10]          # 0046c781
    mov eax, dword ptr [ebp - local_10]          # 0046c784
    mov cx, word ptr [eax + field_49e2]          # 0046c787
    mov word ptr [edx + field_49e0], cx          # 0046c78e
    mov edx, dword ptr [ebp - local_10]          # 0046c795
    mov dword ptr [edx + field_4a4c], 0x0        # 0046c798
    mov eax, dword ptr [ebp - local_10]          # 0046c7a2
    mov dword ptr [eax + field_4a2c], 0x1        # 0046c7a5
    mov ecx, dword ptr [ebp - local_10]          # 0046c7af
    mov dword ptr [ecx + field_4a24], 0x1        # 0046c7b2
    cmp dword ptr [0x5c39e5], 0x27e6             # 0046c7bc
    jne.d8 L_0046c836                            # 0046c7c6
    # block 0x0046c7c8: entered by fall-through of jne at 0x0046c7c6, 22 instruction(s), ends with forward jump to 0x0046c8ae
    mov edx, dword ptr [ebp - local_10]          # 0046c7c8
    mov dword ptr [edx + field_4a30], 0x1        # 0046c7cb
    mov eax, dword ptr [ebp - local_10]          # 0046c7d5
    movsx ecx, word ptr [eax + field_49e2]       # 0046c7d8
    shl ecx, 0x4                                 # 0046c7df
    mov edx, dword ptr [ebp - local_10]          # 0046c7e2
    mov eax, dword ptr [ebp - local_10]          # 0046c7e5
    mov cx, word ptr [eax + ecx + field_48aa]    # 0046c7e8
    mov word ptr [edx + field_4a3c], cx          # 0046c7f0
    mov edx, dword ptr [ebp - local_10]          # 0046c7f7
    movsx eax, word ptr [edx + field_49e2]       # 0046c7fa
    shl eax, 0x4                                 # 0046c801
    mov ecx, dword ptr [ebp - local_10]          # 0046c804
    mov edx, dword ptr [ebp - local_10]          # 0046c807
    mov ax, word ptr [edx + eax + field_48a8]    # 0046c80a
    mov word ptr [ecx + field_4a3e], ax          # 0046c812
    mov ecx, dword ptr [ebp - local_10]          # 0046c819
    movsx edx, word ptr [ecx + field_49e0]       # 0046c81c
    shl edx, 0x4                                 # 0046c823
    mov eax, dword ptr [ebp - local_10]          # 0046c826
    mov dword ptr [eax + edx + field_48a0], 0x0  # 0046c829
    jmp.d8 L_0046c8ae                            # 0046c834
L_0046c836:
    # block 0x0046c836: entered by jne at 0x0046c7c6, 2 instruction(s), ends with jne to 0x0046c8ae (forward)
    cmp dword ptr [0x5c39e5], 0x27e8             # 0046c836
    jne.d8 L_0046c8ae                            # 0046c840
    # block 0x0046c842: entered by fall-through of jne at 0x0046c840, 21 instruction(s), falls into the block at 0x0046c8ae
    mov ecx, dword ptr [ebp - local_10]          # 0046c842
    mov dword ptr [ecx + field_4a34], 0x1        # 0046c845
    mov edx, dword ptr [ebp - local_10]          # 0046c84f
    movsx eax, word ptr [edx + field_49e2]       # 0046c852
    shl eax, 0x4                                 # 0046c859
    mov ecx, dword ptr [ebp - local_10]          # 0046c85c
    mov edx, dword ptr [ebp - local_10]          # 0046c85f
    mov ax, word ptr [edx + eax + field_48ae]    # 0046c862
    mov word ptr [ecx + field_4a3c], ax          # 0046c86a
    mov ecx, dword ptr [ebp - local_10]          # 0046c871
    movsx edx, word ptr [ecx + field_49e2]       # 0046c874
    shl edx, 0x4                                 # 0046c87b
    mov eax, dword ptr [ebp - local_10]          # 0046c87e
    mov ecx, dword ptr [ebp - local_10]          # 0046c881
    mov dx, word ptr [ecx + edx + field_48ac]    # 0046c884
    mov word ptr [eax + field_4a3e], dx          # 0046c88c
    mov eax, dword ptr [ebp - local_10]          # 0046c893
    movsx ecx, word ptr [eax + field_49e0]       # 0046c896
    shl ecx, 0x4                                 # 0046c89d
    mov edx, dword ptr [ebp - local_10]          # 0046c8a0
    mov dword ptr [edx + ecx + field_48a4], 0x0  # 0046c8a3
L_0046c8ae:
    # block 0x0046c8ae: entered by jmp at 0x0046c834; jne at 0x0046c840, 1 instruction(s), ends with forward jump to 0x0046cb7c
    jmp.d32 L_0046cb7c                           # 0046c8ae
L_0046c8b3:
    # block 0x0046c8b3: entered by jne at 0x0046c75f; jne at 0x0046c77b, 3 instruction(s), ends with je to 0x0046cb7c (forward)
    mov eax, dword ptr [ebp - local_10]          # 0046c8b3
    cmp dword ptr [eax + field_4a2c], 0x0        # 0046c8b6
    je.d32 L_0046cb7c                            # 0046c8bd
    # block 0x0046c8c3: entered by fall-through of je at 0x0046c8bd, 2 instruction(s), ends with je to 0x0046c8df (forward)
    cmp dword ptr [0x5c39e5], 0x27e2             # 0046c8c3
    je.d8 L_0046c8df                             # 0046c8cd
    # block 0x0046c8cf: entered by fall-through of je at 0x0046c8cd, 2 instruction(s), ends with jne to 0x0046ca26 (forward)
    cmp dword ptr [0x5c39e5], 0x27e3             # 0046c8cf
    jne.d32 L_0046ca26                           # 0046c8d9
L_0046c8df:
    # block 0x0046c8df: entered by je at 0x0046c8cd; fall-through of jne at 0x0046c8d9, 21 instruction(s), ends with jne to 0x0046c995 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0046c8df
    movsx edx, word ptr [ecx + field_49e0]       # 0046c8e2
    shl edx, 0x4                                 # 0046c8e9
    mov eax, dword ptr [ebp - local_10]          # 0046c8ec
    mov dword ptr [eax + edx + field_48a0], 0x1  # 0046c8ef
    mov ecx, dword ptr [ebp - local_10]          # 0046c8fa
    movsx edx, word ptr [ecx + field_49e0]       # 0046c8fd
    shl edx, 0x4                                 # 0046c904
    mov eax, dword ptr [ebp - local_10]          # 0046c907
    mov ecx, dword ptr [ebp - local_10]          # 0046c90a
    mov cx, word ptr [ecx + field_4a50]          # 0046c90d
    mov word ptr [eax + edx + field_48a8], cx    # 0046c914
    mov edx, dword ptr [ebp - local_10]          # 0046c91c
    movsx eax, word ptr [edx + field_49e0]       # 0046c91f
    shl eax, 0x4                                 # 0046c926
    mov ecx, dword ptr [ebp - local_10]          # 0046c929
    mov edx, dword ptr [ebp - local_10]          # 0046c92c
    mov dx, word ptr [edx + field_4a52]          # 0046c92f
    mov word ptr [ecx + eax + field_48aa], dx    # 0046c936
    cmp dword ptr [0x5c39e5], 0x27e2             # 0046c93e
    jne.d8 L_0046c995                            # 0046c948
    # block 0x0046c94a: entered by fall-through of jne at 0x0046c948, 14 instruction(s), ends with forward jump to 0x0046c9b6
    mov eax, dword ptr [ebp - local_10]          # 0046c94a
    mov ecx, dword ptr [ebp - local_10]          # 0046c94d
    mov dx, word ptr [ecx + field_49e2]          # 0046c950
    mov word ptr [eax + field_49e0], dx          # 0046c957
    mov eax, dword ptr [ebp - local_10]          # 0046c95e
    movsx ecx, word ptr [eax + field_49e0]       # 0046c961
    shl ecx, 0x4                                 # 0046c968
    mov edx, dword ptr [ebp - local_10]          # 0046c96b
    mov dword ptr [edx + ecx + field_48a0], 0x0  # 0046c96e
    mov eax, dword ptr [ebp - local_10]          # 0046c979
    mov dword ptr [eax + field_4a4c], 0x0        # 0046c97c
    mov ecx, dword ptr [ebp - local_10]          # 0046c986
    mov dword ptr [ecx + field_4a2c], 0x1        # 0046c989
    jmp.d8 L_0046c9b6                            # 0046c993
L_0046c995:
    # block 0x0046c995: entered by jne at 0x0046c948, 2 instruction(s), ends with jne to 0x0046c9b6 (forward)
    cmp dword ptr [0x5c39e5], 0x27e3             # 0046c995
    jne.d8 L_0046c9b6                            # 0046c99f
    # block 0x0046c9a1: entered by fall-through of jne at 0x0046c99f, 4 instruction(s), calls FUN_0046cc8b, falls into the block at 0x0046c9b6
    mov edx, dword ptr [ebp - local_10]          # 0046c9a1
    mov dword ptr [edx + field_4a2c], 0x0        # 0046c9a4
    mov ecx, dword ptr [ebp - local_10]          # 0046c9ae
    call FUN_0046cc8b                            # 0046c9b1
L_0046c9b6:
    # block 0x0046c9b6: entered by jmp at 0x0046c993; jne at 0x0046c99f, 21 instruction(s), ends with forward jump to 0x0046cb7c
    mov eax, dword ptr [ebp - local_10]          # 0046c9b6
    mov dword ptr [eax + field_4a28], 0x1        # 0046c9b9
    mov ecx, dword ptr [ebp - local_10]          # 0046c9c3
    mov dword ptr [ecx + field_4a24], 0x1        # 0046c9c6
    mov edx, dword ptr [ebp - local_10]          # 0046c9d0
    mov dword ptr [edx + field_4a30], 0x1        # 0046c9d3
    mov eax, dword ptr [ebp - local_10]          # 0046c9dd
    movsx ecx, word ptr [eax + field_49e2]       # 0046c9e0
    shl ecx, 0x4                                 # 0046c9e7
    mov edx, dword ptr [ebp - local_10]          # 0046c9ea
    mov eax, dword ptr [ebp - local_10]          # 0046c9ed
    mov cx, word ptr [eax + ecx + field_48aa]    # 0046c9f0
    mov word ptr [edx + field_4a3c], cx          # 0046c9f8
    mov edx, dword ptr [ebp - local_10]          # 0046c9ff
    movsx eax, word ptr [edx + field_49e2]       # 0046ca02
    shl eax, 0x4                                 # 0046ca09
    mov ecx, dword ptr [ebp - local_10]          # 0046ca0c
    mov edx, dword ptr [ebp - local_10]          # 0046ca0f
    mov ax, word ptr [edx + eax + field_48a8]    # 0046ca12
    mov word ptr [ecx + field_4a3e], ax          # 0046ca1a
    jmp.d32 L_0046cb7c                           # 0046ca21
L_0046ca26:
    # block 0x0046ca26: entered by jne at 0x0046c8d9, 2 instruction(s), ends with je to 0x0046ca42 (forward)
    cmp dword ptr [0x5c39e5], 0x27e4             # 0046ca26
    je.d8 L_0046ca42                             # 0046ca30
    # block 0x0046ca32: entered by fall-through of je at 0x0046ca30, 2 instruction(s), ends with jne to 0x0046cb7c (forward)
    cmp dword ptr [0x5c39e5], 0x27e5             # 0046ca32
    jne.d32 L_0046cb7c                           # 0046ca3c
L_0046ca42:
    # block 0x0046ca42: entered by je at 0x0046ca30; fall-through of jne at 0x0046ca3c, 21 instruction(s), ends with jne to 0x0046caf8 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0046ca42
    movsx edx, word ptr [ecx + field_49e0]       # 0046ca45
    shl edx, 0x4                                 # 0046ca4c
    mov eax, dword ptr [ebp - local_10]          # 0046ca4f
    mov dword ptr [eax + edx + field_48a4], 0x1  # 0046ca52
    mov ecx, dword ptr [ebp - local_10]          # 0046ca5d
    movsx edx, word ptr [ecx + field_49e0]       # 0046ca60
    shl edx, 0x4                                 # 0046ca67
    mov eax, dword ptr [ebp - local_10]          # 0046ca6a
    mov ecx, dword ptr [ebp - local_10]          # 0046ca6d
    mov cx, word ptr [ecx + field_4a50]          # 0046ca70
    mov word ptr [eax + edx + field_48ac], cx    # 0046ca77
    mov edx, dword ptr [ebp - local_10]          # 0046ca7f
    movsx eax, word ptr [edx + field_49e0]       # 0046ca82
    shl eax, 0x4                                 # 0046ca89
    mov ecx, dword ptr [ebp - local_10]          # 0046ca8c
    mov edx, dword ptr [ebp - local_10]          # 0046ca8f
    mov dx, word ptr [edx + field_4a52]          # 0046ca92
    mov word ptr [ecx + eax + field_48ae], dx    # 0046ca99
    cmp dword ptr [0x5c39e5], 0x27e4             # 0046caa1
    jne.d8 L_0046caf8                            # 0046caab
    # block 0x0046caad: entered by fall-through of jne at 0x0046caab, 14 instruction(s), ends with forward jump to 0x0046cb11
    mov eax, dword ptr [ebp - local_10]          # 0046caad
    mov ecx, dword ptr [ebp - local_10]          # 0046cab0
    mov dx, word ptr [ecx + field_49e2]          # 0046cab3
    mov word ptr [eax + field_49e0], dx          # 0046caba
    mov eax, dword ptr [ebp - local_10]          # 0046cac1
    movsx ecx, word ptr [eax + field_49e0]       # 0046cac4
    shl ecx, 0x4                                 # 0046cacb
    mov edx, dword ptr [ebp - local_10]          # 0046cace
    mov dword ptr [edx + ecx + field_48a4], 0x0  # 0046cad1
    mov eax, dword ptr [ebp - local_10]          # 0046cadc
    mov dword ptr [eax + field_4a4c], 0x0        # 0046cadf
    mov ecx, dword ptr [ebp - local_10]          # 0046cae9
    mov dword ptr [ecx + field_4a2c], 0x1        # 0046caec
    jmp.d8 L_0046cb11                            # 0046caf6
L_0046caf8:
    # block 0x0046caf8: entered by jne at 0x0046caab, 2 instruction(s), ends with jne to 0x0046cb11 (forward)
    cmp dword ptr [0x5c39e5], 0x27e5             # 0046caf8
    jne.d8 L_0046cb11                            # 0046cb02
    # block 0x0046cb04: entered by fall-through of jne at 0x0046cb02, 2 instruction(s), falls into the block at 0x0046cb11
    mov edx, dword ptr [ebp - local_10]          # 0046cb04
    mov dword ptr [edx + field_4a2c], 0x0        # 0046cb07
L_0046cb11:
    # block 0x0046cb11: entered by jmp at 0x0046caf6; jne at 0x0046cb02, 20 instruction(s), falls into the block at 0x0046cb7c
    mov eax, dword ptr [ebp - local_10]          # 0046cb11
    mov dword ptr [eax + field_4a28], 0x1        # 0046cb14
    mov ecx, dword ptr [ebp - local_10]          # 0046cb1e
    mov dword ptr [ecx + field_4a24], 0x1        # 0046cb21
    mov edx, dword ptr [ebp - local_10]          # 0046cb2b
    mov dword ptr [edx + field_4a34], 0x1        # 0046cb2e
    mov eax, dword ptr [ebp - local_10]          # 0046cb38
    movsx ecx, word ptr [eax + field_49e2]       # 0046cb3b
    shl ecx, 0x4                                 # 0046cb42
    mov edx, dword ptr [ebp - local_10]          # 0046cb45
    mov eax, dword ptr [ebp - local_10]          # 0046cb48
    mov cx, word ptr [eax + ecx + field_48ae]    # 0046cb4b
    mov word ptr [edx + field_4a3c], cx          # 0046cb53
    mov edx, dword ptr [ebp - local_10]          # 0046cb5a
    movsx eax, word ptr [edx + field_49e2]       # 0046cb5d
    shl eax, 0x4                                 # 0046cb64
    mov ecx, dword ptr [ebp - local_10]          # 0046cb67
    mov edx, dword ptr [ebp - local_10]          # 0046cb6a
    mov ax, word ptr [edx + eax + field_48ac]    # 0046cb6d
    mov word ptr [ecx + field_4a3e], ax          # 0046cb75
L_0046cb7c:
    # block 0x0046cb7c: entered by jmp at 0x0046c750; jmp at 0x0046c8ae; je at 0x0046c8bd; jmp at 0x0046ca21; more, 2 instruction(s), ends with je to 0x0046cbac (forward)
    cmp dword ptr [0x5c39e5], 0x27e2             # 0046cb7c
    je.d8 L_0046cbac                             # 0046cb86
    # block 0x0046cb88: entered by fall-through of je at 0x0046cb86, 2 instruction(s), ends with je to 0x0046cbac (forward)
    cmp dword ptr [0x5c39e5], 0x27e3             # 0046cb88
    je.d8 L_0046cbac                             # 0046cb92
    # block 0x0046cb94: entered by fall-through of je at 0x0046cb92, 2 instruction(s), ends with je to 0x0046cbac (forward)
    cmp dword ptr [0x5c39e5], 0x27e4             # 0046cb94
    je.d8 L_0046cbac                             # 0046cb9e
    # block 0x0046cba0: entered by fall-through of je at 0x0046cb9e, 2 instruction(s), ends with jne to 0x0046cc02 (forward)
    cmp dword ptr [0x5c39e5], 0x27e5             # 0046cba0
    jne.d8 L_0046cc02                            # 0046cbaa
L_0046cbac:
    # block 0x0046cbac: entered by je at 0x0046cb86; je at 0x0046cb92; je at 0x0046cb9e; fall-through of jne at 0x0046cbaa, 2 instruction(s), ends with je to 0x0046cc02 (forward)
    cmp dword ptr [0x5bb1ca], 0x0                # 0046cbac
    je.d8 L_0046cc02                             # 0046cbb3
    # block 0x0046cbb5: entered by fall-through of je at 0x0046cbb3, 7 instruction(s), ends with je to 0x0046cc02 (forward)
    mov edi, 0x54bd00                            # 0046cbb5
    mov esi, dword ptr [ebp - local_4]           # 0046cbba
    add esi, 0x63d                               # 0046cbbd
    mov ecx, 0x9                                 # 0046cbc3
    {load} xor edx, edx                          # 0046cbc8
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0046cbca
    je.d8 L_0046cc02                             # 0046cbcc
    # block 0x0046cbce: entered by fall-through of je at 0x0046cbcc, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x0046cc02 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0046cbce
    movsx ecx, word ptr [eax + field_65e]        # 0046cbd1
    mov dword ptr [ebp - local_8], ecx           # 0046cbd8
    mov edx, dword ptr [ebp - local_8]           # 0046cbdb
    push edx                                     # 0046cbde
    mov ecx, 0x5cf1eb                            # 0046cbdf
    call FUN_004f6334                            # 0046cbe4
    test eax, eax                                # 0046cbe9
    jne.d8 L_0046cc02                            # 0046cbeb
    # block 0x0046cbed: entered by fall-through of jne at 0x0046cbeb, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x0046cc02
    mov eax, dword ptr [ebp - local_4]           # 0046cbed
    mov cx, word ptr [eax + field_65e]           # 0046cbf0
    push ecx                                     # 0046cbf7
    mov ecx, 0x5c3a67                            # 0046cbf8
    call FUN_004fb2e3                            # 0046cbfd
L_0046cc02:
    # block 0x0046cc02: entered by jne at 0x0046cbaa; je at 0x0046cbb3; je at 0x0046cbcc; jne at 0x0046cbeb, 2 instruction(s), ends with je to 0x0046cc1a (forward)
    cmp dword ptr [0x5c39e5], 0x27e6             # 0046cc02
    je.d8 L_0046cc1a                             # 0046cc0c
    # block 0x0046cc0e: entered by fall-through of je at 0x0046cc0c, 2 instruction(s), ends with jne to 0x0046cc70 (forward)
    cmp dword ptr [0x5c39e5], 0x27e8             # 0046cc0e
    jne.d8 L_0046cc70                            # 0046cc18
L_0046cc1a:
    # block 0x0046cc1a: entered by je at 0x0046cc0c; fall-through of jne at 0x0046cc18, 2 instruction(s), ends with je to 0x0046cc70 (forward)
    cmp dword ptr [0x5bb1ca], 0x0                # 0046cc1a
    je.d8 L_0046cc70                             # 0046cc21
    # block 0x0046cc23: entered by fall-through of je at 0x0046cc21, 7 instruction(s), ends with je to 0x0046cc70 (forward)
    mov edi, 0x54bd0c                            # 0046cc23
    mov esi, dword ptr [ebp - local_4]           # 0046cc28
    add esi, 0x60c                               # 0046cc2b
    mov ecx, 0x9                                 # 0046cc31
    {load} xor edx, edx                          # 0046cc36
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0046cc38
    je.d8 L_0046cc70                             # 0046cc3a
    # block 0x0046cc3c: entered by fall-through of je at 0x0046cc3a, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x0046cc70 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0046cc3c
    movsx ecx, word ptr [eax + field_62d]        # 0046cc3f
    mov dword ptr [ebp - local_c], ecx           # 0046cc46
    mov edx, dword ptr [ebp - local_c]           # 0046cc49
    push edx                                     # 0046cc4c
    mov ecx, 0x5cf1eb                            # 0046cc4d
    call FUN_004f6334                            # 0046cc52
    test eax, eax                                # 0046cc57
    jne.d8 L_0046cc70                            # 0046cc59
    # block 0x0046cc5b: entered by fall-through of jne at 0x0046cc59, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x0046cc70
    mov eax, dword ptr [ebp - local_4]           # 0046cc5b
    mov cx, word ptr [eax + field_62d]           # 0046cc5e
    push ecx                                     # 0046cc65
    mov ecx, 0x5c3a67                            # 0046cc66
    call FUN_004fb2e3                            # 0046cc6b
L_0046cc70:
    # block 0x0046cc70: entered by jne at 0x0046cc18; je at 0x0046cc21; je at 0x0046cc3a; jne at 0x0046cc59, 5 instruction(s), falls into the block at 0x0046cc85
    mov esi, dword ptr [ebp - local_10]          # 0046cc70
    add esi, 0x48a0                              # 0046cc73
    mov ecx, 0x50                                # 0046cc79
    mov edi, 0x5a14df                            # 0046cc7e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0046cc83
L_0046cc85:
    # block 0x0046cc85: entered by je at 0x0046c6d4; jne at 0x0046c6e7; jne at 0x0046c6f7; jne at 0x0046c711, 5 instruction(s), ends with ret
    pop edi                                      # 0046cc85
    pop esi                                      # 0046cc86
    {load} mov esp, ebp                          # 0046cc87
    pop ebp                                      # 0046cc89
    ret                                          # 0046cc8a

