# FUN_004c6929
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c6929
# extent:       0x004c6929-0x004c6c2a (769 code bytes)
# span:         0x004c6929-0x004c6c2a (code 769, tables 0, padding 0)
# sha256:       98cfa18028a1053964eab26e92661e919a6bb60deb799eeb13acf6c7c1b4c281
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_mask_transparent_blit
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_d9_runtime.h:199 says "0x4c6929 DFBltMaskTransPlain: copy the pixels whose mask byte is nonzero."
# name-note:    DFBltMaskTransPlain: copies the pixels whose mask byte is nonzero.
# arguments:    7 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c, arg_20; ret 0x1c (callee pops 28 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       18 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_68, local_7c, local_8c, local_90, local_94, local_98, local_9c, local_a0 and 6 more
# fields:       [eax + n] field_1, field_4, field_8, field_c, field_2f; [ecx + n] field_4, field_8, field_c, field_2f; [edx + n] field_4, field_8, field_c
# callees:      calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, FUN_004c4067, FUN_004c4202, FUN_004c952f
# track-n:      outputs/blackmoor-decomp/src/action_family_d9_runtime.h:d9_blit_mask (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 239 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_68, 0x68  # offset -0x68
.equ local_7c, 0x7c  # offset -0x7c
.equ local_8c, 0x8c  # offset -0x8c
.equ local_90, 0x90  # offset -0x90
.equ local_94, 0x94  # offset -0x94
.equ local_98, 0x98  # offset -0x98
.equ local_9c, 0x9c  # offset -0x9c
.equ local_a0, 0xa0  # offset -0xa0
.equ local_a4, 0xa4  # offset -0xa4
.equ local_1a0, 0x1a0  # offset -0x1a0
.equ local_1a4, 0x1a4  # offset -0x1a4
.equ local_1a8, 0x1a8  # offset -0x1a8
.equ local_1ac, 0x1ac  # offset -0x1ac
.equ local_1b0, 0x1b0  # offset -0x1b0
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ arg_20, 0x20  # offset +0x20
.equ field_2f, 0x2f  # offset +0x2f

# --- external targets -----------------------------------------------
.set FUN_004c4067, .text + (0x004c4067 - 0x401000)
.set FUN_004c4202, .text + (0x004c4202 - 0x401000)
.set FUN_004c952f, .text + (0x004c952f - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004c6929 - 0x401000
.globl FUN_004c6929
FUN_004c6929:
    # block 0x004c6929: entry, 8 instruction(s), ends with je to 0x004c6a92 (forward)
    push ebp                                     # 004c6929
    {load} mov ebp, esp                          # 004c692a
    sub esp, 0x1b0                               # 004c692c
    push esi                                     # 004c6932
    mov dword ptr [ebp - local_1b0], ecx         # 004c6933
    movsx eax, word ptr [0x63a4cd]               # 004c6939
    test eax, eax                                # 004c6940
    je.d32 L_004c6a92                            # 004c6942
    # block 0x004c6948: entered by fall-through of je at 0x004c6942, 23 instruction(s), ends with jne to 0x004c69aa (forward)
    mov ecx, dword ptr [ebp + arg_14]            # 004c6948
    mov edx, dword ptr [ebp + arg_14]            # 004c694b
    mov eax, dword ptr [ecx + field_8]           # 004c694e
    sub eax, dword ptr [edx]                     # 004c6951
    mov dword ptr [ebp - local_1ac], eax         # 004c6953
    mov ecx, dword ptr [ebp + arg_14]            # 004c6959
    mov edx, dword ptr [ebp + arg_14]            # 004c695c
    mov eax, dword ptr [ecx + field_c]           # 004c695f
    sub eax, dword ptr [edx + field_4]           # 004c6962
    mov dword ptr [ebp - local_1a8], eax         # 004c6965
    mov ecx, dword ptr [ebp + arg_18]            # 004c696b
    mov edx, dword ptr [ebp + arg_18]            # 004c696e
    mov eax, dword ptr [ecx + field_8]           # 004c6971
    sub eax, dword ptr [edx]                     # 004c6974
    mov dword ptr [ebp - local_a4], eax          # 004c6976
    mov ecx, dword ptr [ebp + arg_18]            # 004c697c
    mov edx, dword ptr [ebp + arg_18]            # 004c697f
    mov eax, dword ptr [ecx + field_c]           # 004c6982
    sub eax, dword ptr [edx + field_4]           # 004c6985
    mov dword ptr [ebp - local_1a4], eax         # 004c6988
    mov ecx, dword ptr [ebp - local_1ac]         # 004c698e
    cmp ecx, dword ptr [ebp - local_a4]          # 004c6994
    jne.d8 L_004c69aa                            # 004c699a
    # block 0x004c699c: entered by fall-through of jne at 0x004c699a, 3 instruction(s), ends with je to 0x004c6a18 (forward)
    mov edx, dword ptr [ebp - local_1a8]         # 004c699c
    cmp edx, dword ptr [ebp - local_1a4]         # 004c69a2
    je.d8 L_004c6a18                             # 004c69a8
L_004c69aa:
    # block 0x004c69aa: entered by jne at 0x004c699a; fall-through of je at 0x004c69a8, 39 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, ends with forward jump to 0x004c6c23
    mov eax, dword ptr [ebp + arg_18]            # 004c69aa
    mov ecx, dword ptr [eax + field_c]           # 004c69ad
    push ecx                                     # 004c69b0
    mov edx, dword ptr [ebp + arg_18]            # 004c69b1
    mov eax, dword ptr [edx + field_8]           # 004c69b4
    push eax                                     # 004c69b7
    mov ecx, dword ptr [ebp + arg_18]            # 004c69b8
    mov edx, dword ptr [ecx + field_4]           # 004c69bb
    push edx                                     # 004c69be
    mov eax, dword ptr [ebp + arg_18]            # 004c69bf
    mov ecx, dword ptr [eax]                     # 004c69c2
    push ecx                                     # 004c69c4
    mov edx, dword ptr [ebp + arg_14]            # 004c69c5
    mov eax, dword ptr [edx + field_c]           # 004c69c8
    push eax                                     # 004c69cb
    mov ecx, dword ptr [ebp + arg_14]            # 004c69cc
    mov edx, dword ptr [ecx + field_8]           # 004c69cf
    push edx                                     # 004c69d2
    mov eax, dword ptr [ebp + arg_14]            # 004c69d3
    mov ecx, dword ptr [eax + field_4]           # 004c69d6
    push ecx                                     # 004c69d9
    mov edx, dword ptr [ebp + arg_14]            # 004c69da
    mov eax, dword ptr [edx]                     # 004c69dd
    push eax                                     # 004c69df
    mov ecx, dword ptr [ebp + arg_20]            # 004c69e0
    push ecx                                     # 004c69e3
    push 0x555054                                # 004c69e4
    lea edx, [ebp - local_1a0]                   # 004c69e9
    push edx                                     # 004c69ef
    call FUN_0050ca3e                            # 004c69f0
    add esp, 0x2c                                # 004c69f5
    push 0x0                                     # 004c69f8
    push 0x0                                     # 004c69fa
    lea eax, [ebp - local_1a0]                   # 004c69fc
    push eax                                     # 004c6a02
    call FUN_0052139c                            # 004c6a03
    mov ecx, dword ptr [ebp - local_1b0]         # 004c6a08
    call FUN_004c97b4                            # 004c6a0e
    jmp.d32 L_004c6c23                           # 004c6a13
L_004c6a18:
    # block 0x004c6a18: entered by je at 0x004c69a8, 2 instruction(s), ends with je to 0x004c6a24 (forward)
    cmp dword ptr [ebp + arg_8], 0x0             # 004c6a18
    je.d8 L_004c6a24                             # 004c6a1c
    # block 0x004c6a1e: entered by fall-through of je at 0x004c6a1c, 2 instruction(s), ends with jne to 0x004c6a92 (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 004c6a1e
    jne.d8 L_004c6a92                            # 004c6a22
L_004c6a24:
    # block 0x004c6a24: entered by je at 0x004c6a1c; fall-through of jne at 0x004c6a22, 39 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, ends with forward jump to 0x004c6c23
    mov ecx, dword ptr [ebp + arg_18]            # 004c6a24
    mov edx, dword ptr [ecx + field_c]           # 004c6a27
    push edx                                     # 004c6a2a
    mov eax, dword ptr [ebp + arg_18]            # 004c6a2b
    mov ecx, dword ptr [eax + field_8]           # 004c6a2e
    push ecx                                     # 004c6a31
    mov edx, dword ptr [ebp + arg_18]            # 004c6a32
    mov eax, dword ptr [edx + field_4]           # 004c6a35
    push eax                                     # 004c6a38
    mov ecx, dword ptr [ebp + arg_18]            # 004c6a39
    mov edx, dword ptr [ecx]                     # 004c6a3c
    push edx                                     # 004c6a3e
    mov eax, dword ptr [ebp + arg_14]            # 004c6a3f
    mov ecx, dword ptr [eax + field_c]           # 004c6a42
    push ecx                                     # 004c6a45
    mov edx, dword ptr [ebp + arg_14]            # 004c6a46
    mov eax, dword ptr [edx + field_8]           # 004c6a49
    push eax                                     # 004c6a4c
    mov ecx, dword ptr [ebp + arg_14]            # 004c6a4d
    mov edx, dword ptr [ecx + field_4]           # 004c6a50
    push edx                                     # 004c6a53
    mov eax, dword ptr [ebp + arg_14]            # 004c6a54
    mov ecx, dword ptr [eax]                     # 004c6a57
    push ecx                                     # 004c6a59
    mov edx, dword ptr [ebp + arg_20]            # 004c6a5a
    push edx                                     # 004c6a5d
    push 0x5550e8                                # 004c6a5e
    lea eax, [ebp - local_1a0]                   # 004c6a63
    push eax                                     # 004c6a69
    call FUN_0050ca3e                            # 004c6a6a
    add esp, 0x2c                                # 004c6a6f
    push 0x0                                     # 004c6a72
    push 0x0                                     # 004c6a74
    lea ecx, [ebp - local_1a0]                   # 004c6a76
    push ecx                                     # 004c6a7c
    call FUN_0052139c                            # 004c6a7d
    mov ecx, dword ptr [ebp - local_1b0]         # 004c6a82
    call FUN_004c97b4                            # 004c6a88
    jmp.d32 L_004c6c23                           # 004c6a8d
L_004c6a92:
    # block 0x004c6a92: entered by je at 0x004c6942; jne at 0x004c6a22, 63 instruction(s), calls FUN_004c4067, ends with forward jump to 0x004c6b66
    push 0x20                                    # 004c6a92
    mov edx, dword ptr [ebp + arg_20]            # 004c6a94
    push edx                                     # 004c6a97
    lea eax, [ebp - local_8c]                    # 004c6a98
    push eax                                     # 004c6a9e
    mov ecx, dword ptr [ebp + arg_18]            # 004c6a9f
    push ecx                                     # 004c6aa2
    mov edx, dword ptr [ebp + arg_c]             # 004c6aa3
    push edx                                     # 004c6aa6
    mov ecx, dword ptr [ebp - local_1b0]         # 004c6aa7
    call FUN_004c4067                            # 004c6aad
    mov eax, dword ptr [ebp + arg_8]             # 004c6ab2
    movsx eax, word ptr [eax + field_2f]         # 004c6ab5
    cdq                                          # 004c6ab9
    {load} sub eax, edx                          # 004c6aba
    sar eax                                      # 004c6abc
    mov dword ptr [ebp - local_94], eax          # 004c6abe
    mov eax, dword ptr [ebp - local_7c]          # 004c6ac4
    cdq                                          # 004c6ac7
    {load} sub eax, edx                          # 004c6ac8
    sar eax                                      # 004c6aca
    mov dword ptr [ebp - local_9c], eax          # 004c6acc
    mov ecx, dword ptr [ebp + arg_8]             # 004c6ad2
    movsx edx, word ptr [ecx + field_2f]         # 004c6ad5
    mov eax, dword ptr [ebp + arg_14]            # 004c6ad9
    mov ecx, dword ptr [eax + field_4]           # 004c6adc
    imul ecx, edx                                # 004c6adf
    mov edx, dword ptr [ebp + arg_8]             # 004c6ae2
    mov eax, dword ptr [edx]                     # 004c6ae5
    {load} add eax, ecx                          # 004c6ae7
    movsx ecx, word ptr [0x639895]               # 004c6ae9
    mov edx, dword ptr [ebp + arg_14]            # 004c6af0
    mov edx, dword ptr [edx]                     # 004c6af3
    imul edx, ecx                                # 004c6af5
    {load} add eax, edx                          # 004c6af8
    mov dword ptr [ebp - local_4], eax           # 004c6afa
    mov eax, dword ptr [ebp + arg_1c]            # 004c6afd
    mov ecx, dword ptr [eax + field_8]           # 004c6b00
    add ecx, 0x1                                 # 004c6b03
    mov edx, dword ptr [ebp + arg_1c]            # 004c6b06
    mov eax, dword ptr [edx + field_4]           # 004c6b09
    imul eax, ecx                                # 004c6b0c
    mov ecx, dword ptr [ebp + arg_10]            # 004c6b0f
    {load} add ecx, eax                          # 004c6b12
    mov edx, dword ptr [ebp + arg_1c]            # 004c6b14
    add ecx, dword ptr [edx]                     # 004c6b17
    mov dword ptr [ebp - local_a0], ecx          # 004c6b19
    mov eax, dword ptr [ebp + arg_14]            # 004c6b1f
    mov ecx, dword ptr [ebp + arg_14]            # 004c6b22
    mov edx, dword ptr [eax + field_c]           # 004c6b25
    sub edx, dword ptr [ecx + field_4]           # 004c6b28
    add edx, 0x1                                 # 004c6b2b
    mov dword ptr [ebp - local_90], edx          # 004c6b2e
    mov eax, dword ptr [ebp + arg_14]            # 004c6b34
    mov ecx, dword ptr [ebp + arg_14]            # 004c6b37
    mov edx, dword ptr [eax + field_8]           # 004c6b3a
    sub edx, dword ptr [ecx]                     # 004c6b3d
    add edx, 0x1                                 # 004c6b3f
    mov dword ptr [ebp - local_c], edx           # 004c6b42
    mov eax, dword ptr [ebp - local_68]          # 004c6b45
    mov dword ptr [ebp - local_8], eax           # 004c6b48
    mov dword ptr [ebp - local_98], 0x0          # 004c6b4b
    jmp.d8 L_004c6b66                            # 004c6b55
L_004c6b57:
    # block 0x004c6b57: entered by jmp at 0x004c6be9, 3 instruction(s), falls into the block at 0x004c6b66
    mov ecx, dword ptr [ebp - local_98]          # 004c6b57
    add ecx, 0x1                                 # 004c6b5d
    mov dword ptr [ebp - local_98], ecx          # 004c6b60
L_004c6b66:
    # block 0x004c6b66: entered by jmp at 0x004c6b55, 3 instruction(s), ends with jge to 0x004c6bee (forward)
    mov edx, dword ptr [ebp - local_98]          # 004c6b66
    cmp edx, dword ptr [ebp - local_90]          # 004c6b6c
    jge.d8 L_004c6bee                            # 004c6b72
    # block 0x004c6b74: entered by fall-through of jge at 0x004c6b72, 2 instruction(s), ends with forward jump to 0x004c6b86
    mov dword ptr [ebp - local_10], 0x0          # 004c6b74
    jmp.d8 L_004c6b86                            # 004c6b7b
L_004c6b7d:
    # block 0x004c6b7d: entered by jmp at 0x004c6bb3, 3 instruction(s), falls into the block at 0x004c6b86
    mov eax, dword ptr [ebp - local_10]          # 004c6b7d
    add eax, 0x1                                 # 004c6b80
    mov dword ptr [ebp - local_10], eax          # 004c6b83
L_004c6b86:
    # block 0x004c6b86: entered by jmp at 0x004c6b7b, 3 instruction(s), ends with jge to 0x004c6bb5 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004c6b86
    cmp ecx, dword ptr [ebp - local_c]           # 004c6b89
    jge.d8 L_004c6bb5                            # 004c6b8c
    # block 0x004c6b8e: entered by fall-through of jge at 0x004c6b8c, 6 instruction(s), ends with je to 0x004c6bb3 (forward)
    mov edx, dword ptr [ebp - local_a0]          # 004c6b8e
    add edx, dword ptr [ebp - local_10]          # 004c6b94
    {load} xor eax, eax                          # 004c6b97
    mov al, byte ptr [edx]                       # 004c6b99
    test eax, eax                                # 004c6b9b
    je.d8 L_004c6bb3                             # 004c6b9d
    # block 0x004c6b9f: entered by fall-through of je at 0x004c6b9d, 6 instruction(s), falls into the block at 0x004c6bb3
    mov ecx, dword ptr [ebp - local_10]          # 004c6b9f
    mov edx, dword ptr [ebp - local_8]           # 004c6ba2
    mov eax, dword ptr [ebp - local_10]          # 004c6ba5
    mov esi, dword ptr [ebp - local_4]           # 004c6ba8
    mov ax, word ptr [esi + 2*eax]               # 004c6bab
    mov word ptr [edx + 2*ecx], ax               # 004c6baf
L_004c6bb3:
    # block 0x004c6bb3: entered by je at 0x004c6b9d, 1 instruction(s), ends with backward jump to 0x004c6b7d
    jmp.d8 L_004c6b7d                            # 004c6bb3
L_004c6bb5:
    # block 0x004c6bb5: entered by jge at 0x004c6b8c, 14 instruction(s), ends with backward jump to 0x004c6b57
    mov ecx, dword ptr [ebp - local_94]          # 004c6bb5
    mov edx, dword ptr [ebp - local_4]           # 004c6bbb
    lea eax, [edx + 2*ecx]                       # 004c6bbe
    mov dword ptr [ebp - local_4], eax           # 004c6bc1
    mov ecx, dword ptr [ebp - local_9c]          # 004c6bc4
    mov edx, dword ptr [ebp - local_8]           # 004c6bca
    lea eax, [edx + 2*ecx]                       # 004c6bcd
    mov dword ptr [ebp - local_8], eax           # 004c6bd0
    mov ecx, dword ptr [ebp + arg_1c]            # 004c6bd3
    mov edx, dword ptr [ecx + field_8]           # 004c6bd6
    mov eax, dword ptr [ebp - local_a0]          # 004c6bd9
    lea ecx, [eax + edx + field_1]               # 004c6bdf
    mov dword ptr [ebp - local_a0], ecx          # 004c6be3
    jmp.d32 L_004c6b57                           # 004c6be9
L_004c6bee:
    # block 0x004c6bee: entered by jge at 0x004c6b72, 11 instruction(s), calls FUN_004c4202, ends with jne to 0x004c6c23 (forward)
    push 0x555164                                # 004c6bee
    mov edx, dword ptr [ebp + arg_18]            # 004c6bf3
    push edx                                     # 004c6bf6
    mov eax, dword ptr [ebp + arg_c]             # 004c6bf7
    push eax                                     # 004c6bfa
    mov ecx, dword ptr [ebp - local_1b0]         # 004c6bfb
    call FUN_004c4202                            # 004c6c01
    mov ecx, dword ptr [ebp - local_1b0]         # 004c6c06
    mov edx, dword ptr [ebp + arg_c]             # 004c6c0c
    cmp edx, dword ptr [ecx + field_c]           # 004c6c0f
    jne.d8 L_004c6c23                            # 004c6c12
    # block 0x004c6c14: entered by fall-through of jne at 0x004c6c12, 4 instruction(s), calls FUN_004c952f, falls into the block at 0x004c6c23
    mov eax, dword ptr [ebp + arg_18]            # 004c6c14
    push eax                                     # 004c6c17
    mov ecx, dword ptr [ebp - local_1b0]         # 004c6c18
    call FUN_004c952f                            # 004c6c1e
L_004c6c23:
    # block 0x004c6c23: entered by jmp at 0x004c6a13; jmp at 0x004c6a8d; jne at 0x004c6c12, 4 instruction(s), ends with ret 0x1c
    pop esi                                      # 004c6c23
    {load} mov esp, ebp                          # 004c6c24
    pop ebp                                      # 004c6c26
    ret 0x1c                                     # 004c6c27

