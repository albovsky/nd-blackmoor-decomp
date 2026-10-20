# FUN_004e0978
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e0978
# extent:       0x004e0978-0x004e0e1b (1187 code bytes)
# span:         0x004e0978-0x004e0e2b (code 1187, tables 16, padding 0)
# sha256:       a021853142a31e9402655b15f99f12232f816d94d679589d125437530804eadb
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_taskbar_click_handler
# naming:       INFERRED (lower confidence, not verified): the repository text src/inventory_button_runtime.h:177 says "0x4e0978 for one left click, now = GetTickCount()."; src/inventory_button_runtime.h:37 says "0x4e0978 (needs +0xf2a"
# name-note:    Task bar left-click handler, asking each button in order via 0x4e26fc.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       9 ebp-relative slot(s): local_4, local_17, local_38, local_3c, local_40, local_44, local_48, local_4c, local_50
# fields:       [eax + n] field_ff, field_164, field_185, field_1a6, field_753, field_f2a; [ecx + n] field_65, field_753; [edi + n] field_minus_1; [edx + n] field_65, field_ff, field_123, field_164, field_185, field_1a6, field_753, field_757
# callees:      calls FUN_004e26fc, FUN_004e2956, FUN_004e1b79, FUN_0050cd50, FUN_004fb77a, FUN_004fb2e3, FUN_004e2967, FUN_0050ca3e, FUN_0044a2b7, FUN_00427a40
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 311 instruction(s), 18 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_17, 0x17  # offset -0x17
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ local_4c, 0x4c  # offset -0x4c
.equ local_50, 0x50  # offset -0x50
.equ field_65, 0x65  # offset +0x65
.equ field_ff, 0xff  # offset +0xff
.equ field_123, 0x123  # offset +0x123
.equ field_164, 0x164  # offset +0x164
.equ field_185, 0x185  # offset +0x185
.equ field_1a6, 0x1a6  # offset +0x1a6
.equ field_753, 0x753  # offset +0x753
.equ field_757, 0x757  # offset +0x757
.equ field_f2a, 0xf2a  # offset +0xf2a

# --- external targets -----------------------------------------------
.set FUN_00427a40, .text + (0x00427a40 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004e1b79, .text + (0x004e1b79 - 0x401000)
.set FUN_004e26fc, .text + (0x004e26fc - 0x401000)
.set FUN_004e2956, .text + (0x004e2956 - 0x401000)
.set FUN_004e2967, .text + (0x004e2967 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x004e0978 - 0x401000
.globl FUN_004e0978
FUN_004e0978:
    # block 0x004e0978: entry, 11 instruction(s), ends with jne to 0x004e0e13 (forward)
    push ebp                                     # 004e0978
    {load} mov ebp, esp                          # 004e0979
    sub esp, 0x50                                # 004e097b
    push esi                                     # 004e097e
    push edi                                     # 004e097f
    mov dword ptr [ebp - local_48], ecx          # 004e0980
    mov dword ptr [ebp - local_44], 0x0          # 004e0983
    mov dword ptr [ebp - local_4], 0x1           # 004e098a
    mov eax, dword ptr [ebp - local_48]          # 004e0991
    cmp dword ptr [eax + field_f2a], 0x1         # 004e0994
    jne.d32 L_004e0e13                           # 004e099b
    # block 0x004e09a1: entered by fall-through of jne at 0x004e099b, 3 instruction(s), ends with forward jump to 0x004e09c5
    mov ecx, dword ptr [ebp - local_48]          # 004e09a1
    mov dword ptr [ecx + field_753], 0x0         # 004e09a4
    jmp.d8 L_004e09c5                            # 004e09ae
L_004e09b0:
    # block 0x004e09b0: entered by jmp at 0x004e0e0e, 5 instruction(s), falls into the block at 0x004e09c5
    mov edx, dword ptr [ebp - local_48]          # 004e09b0
    mov eax, dword ptr [edx + field_753]         # 004e09b3
    add eax, 0x1                                 # 004e09b9
    mov ecx, dword ptr [ebp - local_48]          # 004e09bc
    mov dword ptr [ecx + field_753], eax         # 004e09bf
L_004e09c5:
    # block 0x004e09c5: entered by jmp at 0x004e09ae, 3 instruction(s), ends with jge to 0x004e0e13 (forward)
    mov edx, dword ptr [ebp - local_48]          # 004e09c5
    cmp dword ptr [edx + field_753], 0x5         # 004e09c8
    jge.d32 L_004e0e13                           # 004e09cf
    # block 0x004e09d5: entered by fall-through of jge at 0x004e09cf, 8 instruction(s), calls FUN_004e26fc, ends with je to 0x004e0e0e (forward)
    mov eax, dword ptr [ebp - local_48]          # 004e09d5
    mov ecx, dword ptr [eax + field_753]         # 004e09d8
    imul ecx, ecx, 0x18f                         # 004e09de
    mov edx, dword ptr [ebp - local_48]          # 004e09e4
    lea ecx, [edx + ecx + field_757]             # 004e09e7
    call FUN_004e26fc                            # 004e09ee
    test eax, eax                                # 004e09f3
    je.d32 L_004e0e0e                            # 004e09f5
    # block 0x004e09fb: entered by fall-through of je at 0x004e09f5, 8 instruction(s), calls FUN_004e2956, ends with jne to 0x004e0d7f (forward)
    mov eax, dword ptr [ebp - local_48]          # 004e09fb
    mov ecx, dword ptr [eax + field_753]         # 004e09fe
    imul ecx, ecx, 0x18f                         # 004e0a04
    mov edx, dword ptr [ebp - local_48]          # 004e0a0a
    lea ecx, [edx + ecx + field_757]             # 004e0a0d
    call FUN_004e2956                            # 004e0a14
    cmp eax, 0x3                                 # 004e0a19
    jne.d32 L_004e0d7f                           # 004e0a1c
    # block 0x004e0a22: entered by fall-through of jne at 0x004e0a1c, 24 instruction(s), calls FUN_004e1b79, ends with ja to 0x004e0c5f (forward)
    mov ax, word ptr [0x5bb57b]                  # 004e0a22
    push eax                                     # 004e0a28
    mov ecx, dword ptr [ebp - local_48]          # 004e0a29
    mov dx, word ptr [ecx + field_753]           # 004e0a2c
    push edx                                     # 004e0a33
    mov ecx, dword ptr [ebp - local_48]          # 004e0a34
    call FUN_004e1b79                            # 004e0a37
    mov word ptr [ebp - local_3c], ax            # 004e0a3c
    mov eax, dword ptr [ebp - local_48]          # 004e0a40
    mov ecx, dword ptr [eax + field_753]         # 004e0a43
    imul ecx, ecx, 0x162                         # 004e0a49
    mov edx, dword ptr [ebp - local_48]          # 004e0a4f
    lea esi, [edx + ecx + field_123]             # 004e0a52
    mov ecx, 0xc                                 # 004e0a59
    lea edi, [ebp - local_38]                    # 004e0a5e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e0a61
    movsb byte ptr es:[edi], byte ptr [esi]      # 004e0a63
    movsx eax, word ptr [ebp - local_3c]         # 004e0a64
    mov dword ptr [ebp - local_4c], eax          # 004e0a68
    mov ecx, dword ptr [ebp - local_4c]          # 004e0a6b
    sub ecx, 0xa                                 # 004e0a6e
    mov dword ptr [ebp - local_4c], ecx          # 004e0a71
    cmp dword ptr [ebp - local_4c], 0x3          # 004e0a74
    ja.d32 L_004e0c5f                            # 004e0a78
    # block 0x004e0a7e: entered by fall-through of ja at 0x004e0a78, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4e0e1b]
    mov edx, dword ptr [ebp - local_4c]          # 004e0a7e
    jmp dword ptr [4*edx + SWTAB_004e0e1b_VA]    # 004e0a81
L_004e0a88:
    # block 0x004e0a88: entered by switch case, 10 instruction(s), ends with je to 0x004e0b1c (forward)
    mov edi, 0x55bba8                            # 004e0a88
    mov eax, dword ptr [ebp - local_48]          # 004e0a8d
    mov ecx, dword ptr [eax + field_753]         # 004e0a90
    imul ecx, ecx, 0x162                         # 004e0a96
    mov edx, dword ptr [ebp - local_48]          # 004e0a9c
    lea esi, [edx + ecx + field_164]             # 004e0a9f
    mov ecx, 0x9                                 # 004e0aa6
    {load} xor eax, eax                          # 004e0aab
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004e0aad
    je.d8 L_004e0b1c                             # 004e0aaf
    # block 0x004e0ab1: entered by fall-through of je at 0x004e0aaf, 10 instruction(s), ends with je to 0x004e0b1c (forward)
    mov edi, 0x63a9d4                            # 004e0ab1
    mov ecx, dword ptr [ebp - local_48]          # 004e0ab6
    mov edx, dword ptr [ecx + field_753]         # 004e0ab9
    imul edx, edx, 0x162                         # 004e0abf
    mov eax, dword ptr [ebp - local_48]          # 004e0ac5
    lea esi, [eax + edx + field_164]             # 004e0ac8
    mov ecx, 0x1                                 # 004e0acf
    {load} xor edx, edx                          # 004e0ad4
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004e0ad6
    je.d8 L_004e0b1c                             # 004e0ad8
    # block 0x004e0ada: entered by fall-through of je at 0x004e0ad8, 21 instruction(s), falls into the block at 0x004e0b1c
    mov eax, dword ptr [ebp - local_48]          # 004e0ada
    mov ecx, dword ptr [eax + field_753]         # 004e0add
    imul ecx, ecx, 0x162                         # 004e0ae3
    mov edx, dword ptr [ebp - local_48]          # 004e0ae9
    lea eax, [edx + ecx + field_164]             # 004e0aec
    {load} mov edi, eax                          # 004e0af3
    lea edx, [ebp - local_38]                    # 004e0af5
    or ecx, -0x1                                 # 004e0af8
    {load} xor eax, eax                          # 004e0afb
    repne scasb al, byte ptr es:[edi]            # 004e0afd
    not ecx                                      # 004e0aff
    {load} sub edi, ecx                          # 004e0b01
    {load} mov esi, edi                          # 004e0b03
    {load} mov eax, ecx                          # 004e0b05
    {load} mov edi, edx                          # 004e0b07
    shr ecx, 0x2                                 # 004e0b09
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e0b0c
    {load} mov ecx, eax                          # 004e0b0e
    and ecx, 0x3                                 # 004e0b10
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004e0b13
    mov dword ptr [ebp - local_4], 0x1           # 004e0b15
L_004e0b1c:
    # block 0x004e0b1c: entered by je at 0x004e0aaf; je at 0x004e0ad8, 1 instruction(s), ends with forward jump to 0x004e0d57
    jmp.d32 L_004e0d57                           # 004e0b1c
L_004e0b21:
    # block 0x004e0b21: entered by switch case, 10 instruction(s), ends with je to 0x004e0bb5 (forward)
    mov edi, 0x55bbb4                            # 004e0b21
    mov ecx, dword ptr [ebp - local_48]          # 004e0b26
    mov edx, dword ptr [ecx + field_753]         # 004e0b29
    imul edx, edx, 0x162                         # 004e0b2f
    mov eax, dword ptr [ebp - local_48]          # 004e0b35
    lea esi, [eax + edx + field_185]             # 004e0b38
    mov ecx, 0x9                                 # 004e0b3f
    {load} xor edx, edx                          # 004e0b44
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004e0b46
    je.d8 L_004e0bb5                             # 004e0b48
    # block 0x004e0b4a: entered by fall-through of je at 0x004e0b48, 10 instruction(s), ends with je to 0x004e0bb5 (forward)
    mov edi, 0x63a9d8                            # 004e0b4a
    mov eax, dword ptr [ebp - local_48]          # 004e0b4f
    mov ecx, dword ptr [eax + field_753]         # 004e0b52
    imul ecx, ecx, 0x162                         # 004e0b58
    mov edx, dword ptr [ebp - local_48]          # 004e0b5e
    lea esi, [edx + ecx + field_185]             # 004e0b61
    mov ecx, 0x1                                 # 004e0b68
    {load} xor eax, eax                          # 004e0b6d
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004e0b6f
    je.d8 L_004e0bb5                             # 004e0b71
    # block 0x004e0b73: entered by fall-through of je at 0x004e0b71, 21 instruction(s), falls into the block at 0x004e0bb5
    mov ecx, dword ptr [ebp - local_48]          # 004e0b73
    mov edx, dword ptr [ecx + field_753]         # 004e0b76
    imul edx, edx, 0x162                         # 004e0b7c
    mov eax, dword ptr [ebp - local_48]          # 004e0b82
    lea ecx, [eax + edx + field_185]             # 004e0b85
    {load} mov edi, ecx                          # 004e0b8c
    lea edx, [ebp - local_38]                    # 004e0b8e
    or ecx, -0x1                                 # 004e0b91
    {load} xor eax, eax                          # 004e0b94
    repne scasb al, byte ptr es:[edi]            # 004e0b96
    not ecx                                      # 004e0b98
    {load} sub edi, ecx                          # 004e0b9a
    {load} mov esi, edi                          # 004e0b9c
    {load} mov eax, ecx                          # 004e0b9e
    {load} mov edi, edx                          # 004e0ba0
    shr ecx, 0x2                                 # 004e0ba2
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e0ba5
    {load} mov ecx, eax                          # 004e0ba7
    and ecx, 0x3                                 # 004e0ba9
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004e0bac
    mov dword ptr [ebp - local_4], 0x1           # 004e0bae
L_004e0bb5:
    # block 0x004e0bb5: entered by je at 0x004e0b48; je at 0x004e0b71, 1 instruction(s), ends with forward jump to 0x004e0d57
    jmp.d32 L_004e0d57                           # 004e0bb5
L_004e0bba:
    # block 0x004e0bba: entered by switch case, 10 instruction(s), ends with je to 0x004e0c4e (forward)
    mov edi, 0x55bbc0                            # 004e0bba
    mov ecx, dword ptr [ebp - local_48]          # 004e0bbf
    mov edx, dword ptr [ecx + field_753]         # 004e0bc2
    imul edx, edx, 0x162                         # 004e0bc8
    mov eax, dword ptr [ebp - local_48]          # 004e0bce
    lea esi, [eax + edx + field_1a6]             # 004e0bd1
    mov ecx, 0x9                                 # 004e0bd8
    {load} xor edx, edx                          # 004e0bdd
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004e0bdf
    je.d8 L_004e0c4e                             # 004e0be1
    # block 0x004e0be3: entered by fall-through of je at 0x004e0be1, 10 instruction(s), ends with je to 0x004e0c4e (forward)
    mov edi, 0x63a9dc                            # 004e0be3
    mov eax, dword ptr [ebp - local_48]          # 004e0be8
    mov ecx, dword ptr [eax + field_753]         # 004e0beb
    imul ecx, ecx, 0x162                         # 004e0bf1
    mov edx, dword ptr [ebp - local_48]          # 004e0bf7
    lea esi, [edx + ecx + field_1a6]             # 004e0bfa
    mov ecx, 0x1                                 # 004e0c01
    {load} xor eax, eax                          # 004e0c06
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004e0c08
    je.d8 L_004e0c4e                             # 004e0c0a
    # block 0x004e0c0c: entered by fall-through of je at 0x004e0c0a, 21 instruction(s), falls into the block at 0x004e0c4e
    mov ecx, dword ptr [ebp - local_48]          # 004e0c0c
    mov edx, dword ptr [ecx + field_753]         # 004e0c0f
    imul edx, edx, 0x162                         # 004e0c15
    mov eax, dword ptr [ebp - local_48]          # 004e0c1b
    lea ecx, [eax + edx + field_1a6]             # 004e0c1e
    {load} mov edi, ecx                          # 004e0c25
    lea edx, [ebp - local_38]                    # 004e0c27
    or ecx, -0x1                                 # 004e0c2a
    {load} xor eax, eax                          # 004e0c2d
    repne scasb al, byte ptr es:[edi]            # 004e0c2f
    not ecx                                      # 004e0c31
    {load} sub edi, ecx                          # 004e0c33
    {load} mov esi, edi                          # 004e0c35
    {load} mov eax, ecx                          # 004e0c37
    {load} mov edi, edx                          # 004e0c39
    shr ecx, 0x2                                 # 004e0c3b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e0c3e
    {load} mov ecx, eax                          # 004e0c40
    and ecx, 0x3                                 # 004e0c42
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004e0c45
    mov dword ptr [ebp - local_4], 0x1           # 004e0c47
L_004e0c4e:
    # block 0x004e0c4e: entered by je at 0x004e0be1; je at 0x004e0c0a, 1 instruction(s), ends with forward jump to 0x004e0d57
    jmp.d32 L_004e0d57                           # 004e0c4e
L_004e0c53:
    # block 0x004e0c53: entered by switch case, 2 instruction(s), ends with forward jump to 0x004e0d57
    mov dword ptr [ebp - local_4], 0x0           # 004e0c53
    jmp.d32 L_004e0d57                           # 004e0c5a
L_004e0c5f:
    # block 0x004e0c5f: entered by ja at 0x004e0a78; jmp at 0x004e0d52, 2 instruction(s), ends with jne to 0x004e0d57 (forward)
    cmp dword ptr [ebp - local_44], 0x0          # 004e0c5f
    jne.d32 L_004e0d57                           # 004e0c63
    # block 0x004e0c69: entered by fall-through of jne at 0x004e0c63, 18 instruction(s), calls FUN_0050cd50, ends with je to 0x004e0d3c (forward)
    call FUN_0050cd50                            # 004e0c69
    cdq                                          # 004e0c6e
    mov ecx, 0x3                                 # 004e0c6f
    idiv ecx                                     # 004e0c74
    mov word ptr [ebp - local_40], dx            # 004e0c76
    mov edi, 0x55bbcc                            # 004e0c7a
    mov edx, dword ptr [ebp - local_48]          # 004e0c7f
    mov eax, dword ptr [edx + field_753]         # 004e0c82
    imul eax, eax, 0x162                         # 004e0c88
    mov ecx, dword ptr [ebp - local_48]          # 004e0c8e
    lea edx, [ecx + eax + field_65]              # 004e0c91
    movsx eax, word ptr [ebp - local_40]         # 004e0c95
    imul eax, eax, 0x21                          # 004e0c99
    lea esi, [edx + eax + field_ff]              # 004e0c9c
    mov ecx, 0x9                                 # 004e0ca3
    {load} xor edx, edx                          # 004e0ca8
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004e0caa
    je.d32 L_004e0d3c                            # 004e0cac
    # block 0x004e0cb2: entered by fall-through of je at 0x004e0cac, 13 instruction(s), ends with je to 0x004e0d3c (forward)
    mov edi, 0x63a9e0                            # 004e0cb2
    mov eax, dword ptr [ebp - local_48]          # 004e0cb7
    mov ecx, dword ptr [eax + field_753]         # 004e0cba
    imul ecx, ecx, 0x162                         # 004e0cc0
    mov edx, dword ptr [ebp - local_48]          # 004e0cc6
    lea eax, [edx + ecx + field_65]              # 004e0cc9
    movsx ecx, word ptr [ebp - local_40]         # 004e0ccd
    imul ecx, ecx, 0x21                          # 004e0cd1
    lea esi, [eax + ecx + field_ff]              # 004e0cd4
    mov ecx, 0x1                                 # 004e0cdb
    {load} xor edx, edx                          # 004e0ce0
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004e0ce2
    je.d8 L_004e0d3c                             # 004e0ce4
    # block 0x004e0ce6: entered by fall-through of je at 0x004e0ce4, 26 instruction(s), ends with forward jump to 0x004e0d52
    mov eax, dword ptr [ebp - local_48]          # 004e0ce6
    mov ecx, dword ptr [eax + field_753]         # 004e0ce9
    imul ecx, ecx, 0x162                         # 004e0cef
    mov edx, dword ptr [ebp - local_48]          # 004e0cf5
    lea eax, [edx + ecx + field_65]              # 004e0cf8
    movsx ecx, word ptr [ebp - local_40]         # 004e0cfc
    imul ecx, ecx, 0x21                          # 004e0d00
    lea edx, [eax + ecx + field_ff]              # 004e0d03
    {load} mov edi, edx                          # 004e0d0a
    lea edx, [ebp - local_38]                    # 004e0d0c
    or ecx, -0x1                                 # 004e0d0f
    {load} xor eax, eax                          # 004e0d12
    repne scasb al, byte ptr es:[edi]            # 004e0d14
    not ecx                                      # 004e0d16
    {load} sub edi, ecx                          # 004e0d18
    {load} mov esi, edi                          # 004e0d1a
    {load} mov eax, ecx                          # 004e0d1c
    {load} mov edi, edx                          # 004e0d1e
    shr ecx, 0x2                                 # 004e0d20
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e0d23
    {load} mov ecx, eax                          # 004e0d25
    and ecx, 0x3                                 # 004e0d27
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004e0d2a
    mov dword ptr [ebp - local_44], 0x1          # 004e0d2c
    mov dword ptr [ebp - local_4], 0x1           # 004e0d33
    jmp.d8 L_004e0d52                            # 004e0d3a
L_004e0d3c:
    # block 0x004e0d3c: entered by je at 0x004e0cac; je at 0x004e0ce4, 3 instruction(s), ends with jne to 0x004e0d52 (forward)
    movsx ecx, word ptr [ebp - local_40]         # 004e0d3c
    test ecx, ecx                                # 004e0d40
    jne.d8 L_004e0d52                            # 004e0d42
    # block 0x004e0d44: entered by fall-through of jne at 0x004e0d42, 2 instruction(s), falls into the block at 0x004e0d52
    mov dword ptr [ebp - local_4], 0x0           # 004e0d44
    mov dword ptr [ebp - local_44], 0x1          # 004e0d4b
L_004e0d52:
    # block 0x004e0d52: entered by jmp at 0x004e0d3a; jne at 0x004e0d42, 1 instruction(s), ends with backward jump to 0x004e0c5f
    jmp.d32 L_004e0c5f                           # 004e0d52
L_004e0d57:
    # block 0x004e0d57: entered by jmp at 0x004e0b1c; jmp at 0x004e0bb5; jmp at 0x004e0c4e; jmp at 0x004e0c5a; more, 2 instruction(s), ends with je to 0x004e0d7a (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 004e0d57
    je.d8 L_004e0d7a                             # 004e0d5b
    # block 0x004e0d5d: entered by fall-through of je at 0x004e0d5b, 8 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, falls into the block at 0x004e0d7a
    lea edx, [ebp - local_38]                    # 004e0d5d
    push edx                                     # 004e0d60
    mov ecx, 0x5c3a67                            # 004e0d61
    call FUN_004fb77a                            # 004e0d66
    mov ax, word ptr [ebp - local_17]            # 004e0d6b
    push eax                                     # 004e0d6f
    mov ecx, 0x5c3a67                            # 004e0d70
    call FUN_004fb2e3                            # 004e0d75
L_004e0d7a:
    # block 0x004e0d7a: entered by je at 0x004e0d5b, 1 instruction(s), ends with forward jump to 0x004e0e0e
    jmp.d32 L_004e0e0e                           # 004e0d7a
L_004e0d7f:
    # block 0x004e0d7f: entered by jne at 0x004e0a1c, 3 instruction(s), ends with je to 0x004e0e07 (forward)
    movsx ecx, word ptr [0x63a4cd]               # 004e0d7f
    test ecx, ecx                                # 004e0d86
    je.d8 L_004e0e07                             # 004e0d88
    # block 0x004e0d8a: entered by fall-through of je at 0x004e0d88, 25 instruction(s), calls FUN_004e2967, FUN_0050ca3e, FUN_0044a2b7, ends with je to 0x004e0df7 (forward)
    mov edx, dword ptr [0x5bb57b]                # 004e0d8a
    push edx                                     # 004e0d90
    mov eax, dword ptr [ebp - local_48]          # 004e0d91
    mov ecx, dword ptr [eax + field_753]         # 004e0d94
    imul ecx, ecx, 0x18f                         # 004e0d9a
    mov edx, dword ptr [ebp - local_48]          # 004e0da0
    lea ecx, [edx + ecx + field_757]             # 004e0da3
    call FUN_004e2967                            # 004e0daa
    push eax                                     # 004e0daf
    push 0x55bbd8                                # 004e0db0
    push 0x63888b                                # 004e0db5
    call FUN_0050ca3e                            # 004e0dba
    add esp, 0x10                                # 004e0dbf
    push 0x63888b                                # 004e0dc2
    call FUN_0044a2b7                            # 004e0dc7
    add esp, 0x4                                 # 004e0dcc
    mov edi, 0x63888b                            # 004e0dcf
    or ecx, -0x1                                 # 004e0dd4
    {load} xor eax, eax                          # 004e0dd7
    repne scasb al, byte ptr es:[edi]            # 004e0dd9
    mov ax, word ptr [0x55bc34]                  # 004e0ddb
    mov word ptr [edi - field_minus_1], ax       # 004e0de1
    mov ecx, 0x1                                 # 004e0de5
    test ecx, ecx                                # 004e0dea
    je.d8 L_004e0df7                             # 004e0dec
    # block 0x004e0dee: entered by fall-through of je at 0x004e0dec, 2 instruction(s), ends with forward jump to 0x004e0e07
    mov dword ptr [ebp - local_50], 0x0          # 004e0dee
    jmp.d8 L_004e0e07                            # 004e0df5
L_004e0df7:
    # block 0x004e0df7: entered by je at 0x004e0dec, 4 instruction(s), calls FUN_00427a40, falls into the block at 0x004e0e07
    push 0x63888b                                # 004e0df7
    call FUN_00427a40                            # 004e0dfc
    add esp, 0x4                                 # 004e0e01
    mov dword ptr [ebp - local_50], eax          # 004e0e04
L_004e0e07:
    # block 0x004e0e07: entered by je at 0x004e0d88; jmp at 0x004e0df5, 2 instruction(s), ends with forward jump to 0x004e0e15
    mov eax, 0x1                                 # 004e0e07
    jmp.d8 L_004e0e15                            # 004e0e0c
L_004e0e0e:
    # block 0x004e0e0e: entered by je at 0x004e09f5; jmp at 0x004e0d7a, 1 instruction(s), ends with backward jump to 0x004e09b0
    jmp.d32 L_004e09b0                           # 004e0e0e
L_004e0e13:
    # block 0x004e0e13: entered by jne at 0x004e099b; jge at 0x004e09cf, 1 instruction(s), falls into the block at 0x004e0e15
    {load} xor eax, eax                          # 004e0e13
L_004e0e15:
    # block 0x004e0e15: entered by jmp at 0x004e0e0c, 5 instruction(s), ends with ret
    pop edi                                      # 004e0e15
    pop esi                                      # 004e0e16
    {load} mov esp, ebp                          # 004e0e17
    pop ebp                                      # 004e0e19
    ret                                          # 004e0e1a

# --- data items (not part of the function) -------------------------
.org 0x004e0e1b - 0x401000
SWTAB_004e0e1b:  # 4 case address(es)
    .long L_004e0a88 - .text + 0x401000
    .long L_004e0b21 - .text + 0x401000
    .long L_004e0bba - .text + 0x401000
    .long L_004e0c53 - .text + 0x401000
.set SWTAB_004e0e1b_VA, SWTAB_004e0e1b - .text + 0x401000

