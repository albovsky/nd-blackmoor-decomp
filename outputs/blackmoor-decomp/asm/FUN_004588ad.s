# FUN_004588ad
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004588ad
# extent:       0x004588ad-0x00458c32 (901 code bytes)
# span:         0x004588ad-0x00458c32 (code 901, tables 0, padding 0)
# sha256:       0ce0ac3209c4155426fbd706037ad8391ac35108bf60f8be98a62dbbf674a546
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4588ad_click_279f_27a5
# naming:       native port src/original_methods_fl25b.c:m4588ad_click_279f_27a5 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4588ad_click_279f_27a5. Direct, Unicorn differential and oracle: every instruction reached, both jcc ways (untaken edges allowlisted in the handoff). See tasks/fl25b-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_20, field_21, field_26, field_32, field_3a, field_3c, field_98, field_ae, field_b4; [ecx + n] field_20, field_2d, field_2e, field_31, field_3a, field_3c, field_94, field_9c, field_9d, field_b0, field_b2, field_b4 and 3 more; [edx + n] field_20, field_26, field_2e, field_3a, field_3c; [esi + n] field_25, field_29
# callees:      calls FUN_00448d11, FUN_004fb77a, FUN_004fb2e3, KERNEL32.dll!GetTickCount, FUN_00458c32
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl25b.c:m4588ad_click_279f_27a5 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 215 instruction(s), 16 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_20, 0x20  # offset +0x20
.equ field_21, 0x21  # offset +0x21
.equ field_25, 0x25  # offset +0x25
.equ field_26, 0x26  # offset +0x26
.equ field_29, 0x29  # offset +0x29
.equ field_2d, 0x2d  # offset +0x2d
.equ field_2e, 0x2e  # offset +0x2e
.equ field_31, 0x31  # offset +0x31
.equ field_32, 0x32  # offset +0x32
.equ field_3a, 0x3a  # offset +0x3a
.equ field_3c, 0x3c  # offset +0x3c
.equ field_94, 0x94  # offset +0x94
.equ field_98, 0x98  # offset +0x98
.equ field_9c, 0x9c  # offset +0x9c
.equ field_9d, 0x9d  # offset +0x9d
.equ field_ae, 0xae  # offset +0xae
.equ field_b0, 0xb0  # offset +0xb0
.equ field_b2, 0xb2  # offset +0xb2
.equ field_b4, 0xb4  # offset +0xb4
.equ field_bc, 0xbc  # offset +0xbc
.equ field_54b, 0x54b  # offset +0x54b
.equ field_57c, 0x57c  # offset +0x57c

# --- external targets -----------------------------------------------
.set FUN_00448d11, .text + (0x00448d11 - 0x401000)
.set FUN_00458c32, .text + (0x00458c32 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)

.org 0x004588ad - 0x401000
.globl FUN_004588ad
FUN_004588ad:
    # block 0x004588ad: entry, 14 instruction(s), ends with je to 0x00458c2c (forward)
    push ebp                                     # 004588ad
    {load} mov ebp, esp                          # 004588ae
    sub esp, 0x8                                 # 004588b0
    push esi                                     # 004588b3
    push edi                                     # 004588b4
    mov dword ptr [ebp - local_8], ecx           # 004588b5
    mov eax, dword ptr [ebp - local_8]           # 004588b8
    movsx ecx, word ptr [eax + field_26]         # 004588bb
    imul ecx, ecx, 0x8d                          # 004588bf
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004588c5
    mov dword ptr [ebp - local_4], edx           # 004588cb
    mov eax, dword ptr [ebp - local_8]           # 004588ce
    cmp dword ptr [eax + field_98], 0x0          # 004588d1
    je.d32 L_00458c2c                            # 004588d8
    # block 0x004588de: entered by fall-through of je at 0x004588d8, 5 instruction(s), ends with jne to 0x00458c2c (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004588de
    {load} xor edx, edx                          # 004588e1
    mov dl, byte ptr [ecx + field_9d]            # 004588e3
    test edx, edx                                # 004588e9
    jne.d32 L_00458c2c                           # 004588eb
    # block 0x004588f1: entered by fall-through of jne at 0x004588eb, 3 instruction(s), ends with je to 0x00458907 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004588f1
    cmp dword ptr [eax + field_20], 0x0          # 004588f4
    je.d8 L_00458907                             # 004588f8
    # block 0x004588fa: entered by fall-through of je at 0x004588f8, 3 instruction(s), ends with jne to 0x00458c2c (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004588fa
    cmp dword ptr [ecx + field_20], 0x5          # 004588fd
    jne.d32 L_00458c2c                           # 00458901
L_00458907:
    # block 0x00458907: entered by je at 0x004588f8; fall-through of jne at 0x00458901, 5 instruction(s), ends with jne to 0x00458c2c (forward)
    mov edx, dword ptr [ebp - local_8]           # 00458907
    movsx eax, word ptr [edx + field_26]         # 0045890a
    imul eax, eax, 0x8d                          # 0045890e
    cmp dword ptr [eax + 0x5bb632], 0x1          # 00458914
    jne.d32 L_00458c2c                           # 0045891b
    # block 0x00458921: entered by fall-through of jne at 0x0045891b, 2 instruction(s), ends with jne to 0x00458953 (forward)
    cmp dword ptr [0x5c39e5], 0x279f             # 00458921
    jne.d8 L_00458953                            # 0045892b
    # block 0x0045892d: entered by fall-through of jne at 0x0045892b, 7 instruction(s), ends with forward jump to 0x00458c2c
    mov ecx, dword ptr [ebp - local_8]           # 0045892d
    mov byte ptr [ecx + field_9c], 0x1           # 00458930
    mov edx, dword ptr [ebp - local_8]           # 00458937
    movsx eax, word ptr [edx + field_26]         # 0045893a
    imul eax, eax, 0x8d                          # 0045893e
    mov dword ptr [eax + 0x5bb632], 0x2          # 00458944
    jmp.d32 L_00458c2c                           # 0045894e
L_00458953:
    # block 0x00458953: entered by jne at 0x0045892b, 2 instruction(s), ends with jne to 0x00458b48 (forward)
    cmp dword ptr [0x5c39e5], 0x27a4             # 00458953
    jne.d32 L_00458b48                           # 0045895d
    # block 0x00458963: entered by fall-through of jne at 0x0045895d, 3 instruction(s), ends with jne to 0x004589d4 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00458963
    cmp dword ptr [ecx + field_20], 0x5          # 00458966
    jne.d8 L_004589d4                            # 0045896a
    # block 0x0045896c: entered by fall-through of jne at 0x0045896a, 21 instruction(s), calls FUN_00448d11, ends with forward jump to 0x00458b43
    mov edx, dword ptr [ebp - local_8]           # 0045896c
    mov dword ptr [edx + field_20], 0x0          # 0045896f
    push 0x0                                     # 00458976
    push -0x1                                    # 00458978
    push 0x54a5f0                                # 0045897a
    mov eax, dword ptr [0x5d03b3]                # 0045897f
    push eax                                     # 00458984
    mov ecx, 0x619a05                            # 00458985
    call FUN_00448d11                            # 0045898a
    mov ecx, dword ptr [ebp - local_8]           # 0045898f
    mov dword ptr [ecx + field_94], 0x1          # 00458992
    movsx edx, word ptr [0x5a4c08]               # 0045899c
    mov word ptr [2*edx + 0x5a4bd4], 0xffff      # 004589a3
    mov ax, word ptr [0x5a4c08]                  # 004589ad
    .insn 0x66, 0x2d, 0x0001{:u16}               # 004589b3
    mov word ptr [0x5a4c08], ax                  # 004589b7
    mov ecx, dword ptr [ebp - local_8]           # 004589bd
    mov word ptr [ecx + field_3c], 0xffff        # 004589c0
    mov edx, dword ptr [ebp - local_8]           # 004589c6
    mov word ptr [edx + field_3a], 0xffff        # 004589c9
    jmp.d32 L_00458b43                           # 004589cf
L_004589d4:
    # block 0x004589d4: entered by jne at 0x0045896a, 3 instruction(s), ends with jne to 0x00458a95 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004589d4
    cmp dword ptr [eax + field_b4], 0x0          # 004589d7
    jne.d32 L_00458a95                           # 004589de
    # block 0x004589e4: entered by fall-through of jne at 0x004589de, 3 instruction(s), ends with jle to 0x00458a95 (forward)
    movsx ecx, word ptr [0x5a4c08]               # 004589e4
    test ecx, ecx                                # 004589eb
    jle.d32 L_00458a95                           # 004589ed
    # block 0x004589f3: entered by fall-through of jle at 0x004589ed, 7 instruction(s), ends with je to 0x00458a34 (forward)
    mov edi, 0x54a5f8                            # 004589f3
    mov esi, dword ptr [ebp - local_4]           # 004589f8
    add esi, 0x55b                               # 004589fb
    mov ecx, 0x9                                 # 00458a01
    {load} xor edx, edx                          # 00458a06
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00458a08
    je.d8 L_00458a34                             # 00458a0a
    # block 0x00458a0c: entered by fall-through of je at 0x00458a0a, 10 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, falls into the block at 0x00458a34
    mov eax, dword ptr [ebp - local_4]           # 00458a0c
    add eax, 0x55b                               # 00458a0f
    push eax                                     # 00458a14
    mov ecx, 0x5c3a67                            # 00458a15
    call FUN_004fb77a                            # 00458a1a
    mov ecx, dword ptr [ebp - local_4]           # 00458a1f
    mov dx, word ptr [ecx + field_57c]           # 00458a22
    push edx                                     # 00458a29
    mov ecx, 0x5c3a67                            # 00458a2a
    call FUN_004fb2e3                            # 00458a2f
L_00458a34:
    # block 0x00458a34: entered by je at 0x00458a0a, 19 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x00458b43
    movsx eax, word ptr [0x5a4c08]               # 00458a34
    mov ecx, dword ptr [ebp - local_8]           # 00458a3b
    mov dx, word ptr [2*eax + 0x5a4bd4]          # 00458a3e
    mov word ptr [ecx + field_3a], dx            # 00458a46
    mov eax, dword ptr [ebp - local_8]           # 00458a4a
    mov cx, word ptr [0x5a4c08]                  # 00458a4d
    mov word ptr [eax + field_3c], cx            # 00458a54
    mov dx, word ptr [0x5a4c08]                  # 00458a58
    sub dx, 0x1                                  # 00458a5f
    mov word ptr [0x5a4c08], dx                  # 00458a63
    mov eax, dword ptr [ebp - local_8]           # 00458a6a
    mov dword ptr [eax + field_20], 0x2          # 00458a6d
    call dword ptr [0x52a23c]                    # 00458a74
    add eax, 0x28                                # 00458a7a
    mov ecx, dword ptr [ebp - local_8]           # 00458a7d
    mov dword ptr [ecx + field_bc], eax          # 00458a80
    mov edx, dword ptr [ebp - local_8]           # 00458a86
    mov dword ptr [edx + field_2e], 0x0          # 00458a89
    jmp.d32 L_00458b43                           # 00458a90
L_00458a95:
    # block 0x00458a95: entered by jne at 0x004589de; jle at 0x004589ed, 7 instruction(s), ends with je to 0x00458ad0 (forward)
    mov edi, 0x54a604                            # 00458a95
    mov esi, dword ptr [ebp - local_4]           # 00458a9a
    add esi, 0x4f9                               # 00458a9d
    mov ecx, 0x9                                 # 00458aa3
    {load} xor eax, eax                          # 00458aa8
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00458aaa
    je.d8 L_00458ad0                             # 00458aac
    # block 0x00458aae: entered by fall-through of je at 0x00458aac, 9 instruction(s), calls FUN_00458c32, falls into the block at 0x00458ad0
    mov esi, dword ptr [ebp - local_4]           # 00458aae
    add esi, 0x4f9                               # 00458ab1
    mov edi, dword ptr [ebp - local_8]           # 00458ab7
    add edi, 0xc0                                # 00458aba
    mov ecx, 0xc                                 # 00458ac0
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00458ac5
    movsb byte ptr es:[edi], byte ptr [esi]      # 00458ac7
    mov ecx, dword ptr [ebp - local_8]           # 00458ac8
    call FUN_00458c32                            # 00458acb
L_00458ad0:
    # block 0x00458ad0: entered by je at 0x00458aac, 30 instruction(s), falls into the block at 0x00458b43
    mov ecx, dword ptr [ebp - local_8]           # 00458ad0
    mov dword ptr [ecx + field_2e], 0x1          # 00458ad3
    mov edx, dword ptr [ebp - local_8]           # 00458ada
    mov eax, dword ptr [ebp - local_8]           # 00458add
    mov cx, word ptr [eax + field_ae]            # 00458ae0
    mov word ptr [edx + field_3a], cx            # 00458ae7
    mov edx, dword ptr [ebp - local_8]           # 00458aeb
    movsx eax, word ptr [edx + field_3a]         # 00458aee
    shl eax, 0x4                                 # 00458af2
    mov ecx, dword ptr [ebp - local_8]           # 00458af5
    movsx edx, word ptr [ecx + field_3a]         # 00458af8
    shl edx, 0x4                                 # 00458afc
    mov ecx, dword ptr [ebp - local_4]           # 00458aff
    mov esi, dword ptr [ebp - local_4]           # 00458b02
    mov eax, dword ptr [ecx + eax + field_2d]    # 00458b05
    sub eax, dword ptr [esi + edx + field_25]    # 00458b09
    mov ecx, dword ptr [ebp - local_8]           # 00458b0d
    mov word ptr [ecx + field_b0], ax            # 00458b10
    mov edx, dword ptr [ebp - local_8]           # 00458b17
    movsx eax, word ptr [edx + field_3a]         # 00458b1a
    shl eax, 0x4                                 # 00458b1e
    mov ecx, dword ptr [ebp - local_8]           # 00458b21
    movsx edx, word ptr [ecx + field_3a]         # 00458b24
    shl edx, 0x4                                 # 00458b28
    mov ecx, dword ptr [ebp - local_4]           # 00458b2b
    mov esi, dword ptr [ebp - local_4]           # 00458b2e
    mov eax, dword ptr [ecx + eax + field_31]    # 00458b31
    sub eax, dword ptr [esi + edx + field_29]    # 00458b35
    mov ecx, dword ptr [ebp - local_8]           # 00458b39
    mov word ptr [ecx + field_b2], ax            # 00458b3c
L_00458b43:
    # block 0x00458b43: entered by jmp at 0x004589cf; jmp at 0x00458a90, 1 instruction(s), ends with forward jump to 0x00458c2c
    jmp.d32 L_00458c2c                           # 00458b43
L_00458b48:
    # block 0x00458b48: entered by jne at 0x0045895d, 2 instruction(s), ends with jne to 0x00458c2c (forward)
    cmp dword ptr [0x5c39e5], 0x27a5             # 00458b48
    jne.d32 L_00458c2c                           # 00458b52
    # block 0x00458b58: entered by fall-through of jne at 0x00458b52, 7 instruction(s), ends with je to 0x00458bbe (forward)
    mov edx, dword ptr [ebp - local_8]           # 00458b58
    mov dword ptr [edx + field_2e], 0x0          # 00458b5b
    mov eax, dword ptr [ebp - local_8]           # 00458b62
    mov dword ptr [eax + field_32], 0x1          # 00458b65
    mov ecx, dword ptr [ebp - local_8]           # 00458b6c
    cmp dword ptr [ecx + field_b4], 0x0          # 00458b6f
    je.d8 L_00458bbe                             # 00458b76
    # block 0x00458b78: entered by fall-through of je at 0x00458b76, 7 instruction(s), ends with je to 0x00458bb3 (forward)
    mov edi, 0x54a610                            # 00458b78
    mov esi, dword ptr [ebp - local_4]           # 00458b7d
    add esi, 0x4f9                               # 00458b80
    mov ecx, 0x9                                 # 00458b86
    {load} xor edx, edx                          # 00458b8b
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00458b8d
    je.d8 L_00458bb3                             # 00458b8f
    # block 0x00458b91: entered by fall-through of je at 0x00458b8f, 9 instruction(s), calls FUN_00458c32, falls into the block at 0x00458bb3
    mov esi, dword ptr [ebp - local_4]           # 00458b91
    add esi, 0x4f9                               # 00458b94
    mov edi, dword ptr [ebp - local_8]           # 00458b9a
    add edi, 0xc0                                # 00458b9d
    mov ecx, 0xc                                 # 00458ba3
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00458ba8
    movsb byte ptr es:[edi], byte ptr [esi]      # 00458baa
    mov ecx, dword ptr [ebp - local_8]           # 00458bab
    call FUN_00458c32                            # 00458bae
L_00458bb3:
    # block 0x00458bb3: entered by je at 0x00458b8f, 3 instruction(s), ends with forward jump to 0x00458c2c
    mov eax, dword ptr [ebp - local_8]           # 00458bb3
    mov word ptr [eax + field_3a], 0xffff        # 00458bb6
    jmp.d8 L_00458c2c                            # 00458bbc
L_00458bbe:
    # block 0x00458bbe: entered by je at 0x00458b76, 7 instruction(s), ends with je to 0x00458bff (forward)
    mov edi, 0x54a61c                            # 00458bbe
    mov esi, dword ptr [ebp - local_4]           # 00458bc3
    add esi, 0x52a                               # 00458bc6
    mov ecx, 0x9                                 # 00458bcc
    {load} xor edx, edx                          # 00458bd1
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00458bd3
    je.d8 L_00458bff                             # 00458bd5
    # block 0x00458bd7: entered by fall-through of je at 0x00458bd5, 10 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, falls into the block at 0x00458bff
    mov eax, dword ptr [ebp - local_4]           # 00458bd7
    add eax, 0x52a                               # 00458bda
    push eax                                     # 00458bdf
    mov ecx, 0x5c3a67                            # 00458be0
    call FUN_004fb77a                            # 00458be5
    mov ecx, dword ptr [ebp - local_4]           # 00458bea
    mov dx, word ptr [ecx + field_54b]           # 00458bed
    push edx                                     # 00458bf4
    mov ecx, 0x5c3a67                            # 00458bf5
    call FUN_004fb2e3                            # 00458bfa
L_00458bff:
    # block 0x00458bff: entered by je at 0x00458bd5, 11 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x00458c2c
    mov eax, dword ptr [ebp - local_4]           # 00458bff
    movsx ecx, word ptr [eax + field_21]         # 00458c02
    sub ecx, 0x1                                 # 00458c06
    mov edx, dword ptr [ebp - local_8]           # 00458c09
    mov word ptr [edx + field_3c], cx            # 00458c0c
    mov eax, dword ptr [ebp - local_8]           # 00458c10
    mov dword ptr [eax + field_20], 0x1          # 00458c13
    call dword ptr [0x52a23c]                    # 00458c1a
    add eax, 0x28                                # 00458c20
    mov ecx, dword ptr [ebp - local_8]           # 00458c23
    mov dword ptr [ecx + field_bc], eax          # 00458c26
L_00458c2c:
    # block 0x00458c2c: entered by je at 0x004588d8; jne at 0x004588eb; jne at 0x00458901; jne at 0x0045891b; more, 5 instruction(s), ends with ret
    pop edi                                      # 00458c2c
    pop esi                                      # 00458c2d
    {load} mov esp, ebp                          # 00458c2e
    pop ebp                                      # 00458c30
    ret                                          # 00458c31

