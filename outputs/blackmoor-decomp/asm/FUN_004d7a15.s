# FUN_004d7a15
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d7a15
# extent:       0x004d7a15-0x004d7ea4 (1167 code bytes)
# span:         0x004d7a15-0x004d7ea4 (code 1167, tables 0, padding 0)
# sha256:       615b793371fb9a42b79d8fac6db2d3074e57ad153235da1355201c49befe51e1
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_save_game_routine
# naming:       INFERRED (lower confidence, not verified): the repository text src/session_bindings_a65_a68_a69.h:20 says "the save routine 0x4d7a15"; src/blackmoor_app.mm:4515 says "calls the save routine 0x4d7a15"
# name-note:    The save routine called with a name and a report-failure flag, e.g. "SAVE CONTINUE".
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       7 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c
# fields:       [eax + n] field_449, field_98a8, field_98ac, field_990c; [ecx + n] field_98a8, field_98ac, field_990a, field_9910; [edx + n] field_98a8, field_98ac, field_990e
# callees:      calls FUN_0050ca3e, FUN_0050cd72, FUN_0050d0a9, FUN_0042639d, FUN_004c97b4, FUN_0050e493, FUN_0050cee4
# track-n:      outputs/blackmoor-decomp/src/blackmoor_app.mm:native_a65_save_game (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 329 instruction(s), 16 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_449, 0x449  # offset +0x449
.equ field_98a8, 0x98a8  # offset +0x98a8
.equ field_98ac, 0x98ac  # offset +0x98ac
.equ field_990a, 0x990a  # offset +0x990a
.equ field_990c, 0x990c  # offset +0x990c
.equ field_990e, 0x990e  # offset +0x990e
.equ field_9910, 0x9910  # offset +0x9910

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cd72, .text + (0x0050cd72 - 0x401000)
.set FUN_0050cee4, .text + (0x0050cee4 - 0x401000)
.set FUN_0050d0a9, .text + (0x0050d0a9 - 0x401000)
.set FUN_0050e493, .text + (0x0050e493 - 0x401000)

.org 0x004d7a15 - 0x401000
.globl FUN_004d7a15
FUN_004d7a15:
    # block 0x004d7a15: entry, 13 instruction(s), ends with je to 0x004d7a5f (forward)
    push ebp                                     # 004d7a15
    {load} mov ebp, esp                          # 004d7a16
    sub esp, 0x1c                                # 004d7a18
    push esi                                     # 004d7a1b
    push edi                                     # 004d7a1c
    mov dword ptr [ebp - local_1c], ecx          # 004d7a1d
    mov dword ptr [ebp - local_10], 0x1          # 004d7a20
    mov edi, 0x55a784                            # 004d7a27
    mov esi, dword ptr [ebp + arg_8]             # 004d7a2c
    mov ecx, 0xe                                 # 004d7a2f
    {load} xor eax, eax                          # 004d7a34
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004d7a36
    je.d8 L_004d7a5f                             # 004d7a38
    # block 0x004d7a3a: entered by fall-through of je at 0x004d7a38, 15 instruction(s), falls into the block at 0x004d7a5f
    mov edi, dword ptr [ebp + arg_8]             # 004d7a3a
    mov edx, 0x63a565                            # 004d7a3d
    or ecx, -0x1                                 # 004d7a42
    {load} xor eax, eax                          # 004d7a45
    repne scasb al, byte ptr es:[edi]            # 004d7a47
    not ecx                                      # 004d7a49
    {load} sub edi, ecx                          # 004d7a4b
    {load} mov esi, edi                          # 004d7a4d
    {load} mov eax, ecx                          # 004d7a4f
    {load} mov edi, edx                          # 004d7a51
    shr ecx, 0x2                                 # 004d7a53
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d7a56
    {load} mov ecx, eax                          # 004d7a58
    and ecx, 0x3                                 # 004d7a5a
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004d7a5d
L_004d7a5f:
    # block 0x004d7a5f: entered by je at 0x004d7a38, 12 instruction(s), ends with jne to 0x004d7aba (forward)
    mov ecx, 0xa6c4                              # 004d7a5f
    {load} xor eax, eax                          # 004d7a64
    mov edi, dword ptr [ebp - local_1c]          # 004d7a66
    add edi, 0x98b0                              # 004d7a69
    rep stosd dword ptr es:[edi], eax            # 004d7a6f
    stosw word ptr es:[edi], ax                  # 004d7a71
    mov edi, 0x55a794                            # 004d7a73
    mov esi, dword ptr [ebp + arg_8]             # 004d7a78
    mov ecx, 0xe                                 # 004d7a7b
    {load} xor edx, edx                          # 004d7a80
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004d7a82
    jne.d8 L_004d7aba                            # 004d7a84
    # block 0x004d7a86: entered by fall-through of jne at 0x004d7a84, 20 instruction(s), ends with forward jump to 0x004d7ae5
    mov eax, dword ptr [ebp - local_1c]          # 004d7a86
    add eax, 0x29b                               # 004d7a89
    {load} mov edi, eax                          # 004d7a8e
    mov ecx, dword ptr [ebp - local_1c]          # 004d7a90
    add ecx, 0x333c2                             # 004d7a93
    {load} mov edx, ecx                          # 004d7a99
    or ecx, -0x1                                 # 004d7a9b
    {load} xor eax, eax                          # 004d7a9e
    repne scasb al, byte ptr es:[edi]            # 004d7aa0
    not ecx                                      # 004d7aa2
    {load} sub edi, ecx                          # 004d7aa4
    {load} mov esi, edi                          # 004d7aa6
    {load} mov eax, ecx                          # 004d7aa8
    {load} mov edi, edx                          # 004d7aaa
    shr ecx, 0x2                                 # 004d7aac
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d7aaf
    {load} mov ecx, eax                          # 004d7ab1
    and ecx, 0x3                                 # 004d7ab3
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004d7ab6
    jmp.d8 L_004d7ae5                            # 004d7ab8
L_004d7aba:
    # block 0x004d7aba: entered by jne at 0x004d7a84, 17 instruction(s), falls into the block at 0x004d7ae5
    mov edi, dword ptr [ebp + arg_8]             # 004d7aba
    mov ecx, dword ptr [ebp - local_1c]          # 004d7abd
    add ecx, 0x333c2                             # 004d7ac0
    {load} mov edx, ecx                          # 004d7ac6
    or ecx, -0x1                                 # 004d7ac8
    {load} xor eax, eax                          # 004d7acb
    repne scasb al, byte ptr es:[edi]            # 004d7acd
    not ecx                                      # 004d7acf
    {load} sub edi, ecx                          # 004d7ad1
    {load} mov esi, edi                          # 004d7ad3
    {load} mov eax, ecx                          # 004d7ad5
    {load} mov edi, edx                          # 004d7ad7
    shr ecx, 0x2                                 # 004d7ad9
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d7adc
    {load} mov ecx, eax                          # 004d7ade
    and ecx, 0x3                                 # 004d7ae0
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004d7ae3
L_004d7ae5:
    # block 0x004d7ae5: entered by jmp at 0x004d7ab8, 33 instruction(s), calls FUN_0050ca3e, FUN_0050cd72, FUN_0050d0a9, ends with jne to 0x004d7b97 (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004d7ae5
    add ecx, 0x2af                               # 004d7ae8
    push ecx                                     # 004d7aee
    push 0x55a7a4                                # 004d7aef
    mov edx, dword ptr [ebp - local_1c]          # 004d7af4
    add edx, 0x333e3                             # 004d7af7
    push edx                                     # 004d7afd
    call FUN_0050ca3e                            # 004d7afe
    add esp, 0xc                                 # 004d7b03
    mov eax, dword ptr [ebp - local_1c]          # 004d7b06
    add eax, 0x333e3                             # 004d7b09
    push eax                                     # 004d7b0e
    mov ecx, dword ptr [ebp - local_1c]          # 004d7b0f
    add ecx, 0x333c2                             # 004d7b12
    push ecx                                     # 004d7b18
    push 0x63a3c9                                # 004d7b19
    push 0x63a9a8                                # 004d7b1e
    mov edx, dword ptr [ebp - local_1c]          # 004d7b23
    add edx, 0x333e8                             # 004d7b26
    push edx                                     # 004d7b2c
    call FUN_0050cd72                            # 004d7b2d
    add esp, 0x14                                # 004d7b32
    push 0x55a7a8                                # 004d7b35
    mov eax, dword ptr [ebp - local_1c]          # 004d7b3a
    add eax, 0x333e8                             # 004d7b3d
    push eax                                     # 004d7b42
    call FUN_0050d0a9                            # 004d7b43
    add esp, 0x8                                 # 004d7b48
    mov ecx, dword ptr [ebp - local_1c]          # 004d7b4b
    mov dword ptr [ecx + field_98ac], eax        # 004d7b4e
    mov edx, dword ptr [ebp - local_1c]          # 004d7b54
    cmp dword ptr [edx + field_98ac], 0x0        # 004d7b57
    jne.d8 L_004d7b97                            # 004d7b5e
    # block 0x004d7b60: entered by fall-through of jne at 0x004d7b5e, 2 instruction(s), ends with je to 0x004d7b88 (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 004d7b60
    je.d8 L_004d7b88                             # 004d7b64
    # block 0x004d7b66: entered by fall-through of je at 0x004d7b64, 8 instruction(s), calls FUN_0042639d, FUN_004c97b4, falls into the block at 0x004d7b88
    mov eax, dword ptr [ebp - local_1c]          # 004d7b66
    add eax, 0x333e8                             # 004d7b69
    push eax                                     # 004d7b6e
    push 0x55a7ac                                # 004d7b6f
    mov ecx, 0x583979                            # 004d7b74
    call FUN_0042639d                            # 004d7b79
    mov ecx, 0x5cf659                            # 004d7b7e
    call FUN_004c97b4                            # 004d7b83
L_004d7b88:
    # block 0x004d7b88: entered by je at 0x004d7b64, 3 instruction(s), ends with forward jump to 0x004d7e9c
    mov dword ptr [ebp - local_10], 0x0          # 004d7b88
    mov eax, dword ptr [ebp - local_10]          # 004d7b8f
    jmp.d32 L_004d7e9c                           # 004d7b92
L_004d7b97:
    # block 0x004d7b97: entered by jne at 0x004d7b5e, 4 instruction(s), ends with forward jump to 0x004d7bc1
    mov word ptr [ebp - local_4], 0xffff         # 004d7b97
    mov ecx, dword ptr [ebp - local_1c]          # 004d7b9d
    mov dword ptr [ecx + field_98a8], 0x0        # 004d7ba0
    jmp.d8 L_004d7bc1                            # 004d7baa
L_004d7bac:
    # block 0x004d7bac: entered by jmp at 0x004d7ce8, 5 instruction(s), falls into the block at 0x004d7bc1
    mov edx, dword ptr [ebp - local_1c]          # 004d7bac
    mov eax, dword ptr [edx + field_98a8]        # 004d7baf
    add eax, 0x1                                 # 004d7bb5
    mov ecx, dword ptr [ebp - local_1c]          # 004d7bb8
    mov dword ptr [ecx + field_98a8], eax        # 004d7bbb
L_004d7bc1:
    # block 0x004d7bc1: entered by jmp at 0x004d7baa, 3 instruction(s), ends with jge to 0x004d7ced (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004d7bc1
    cmp dword ptr [edx + field_98a8], 0x2        # 004d7bc4
    jge.d32 L_004d7ced                           # 004d7bcb
    # block 0x004d7bd1: entered by fall-through of jge at 0x004d7bcb, 3 instruction(s), ends with jne to 0x004d7ced (forward)
    movsx eax, word ptr [ebp - local_4]          # 004d7bd1
    cmp eax, -0x1                                # 004d7bd5
    jne.d32 L_004d7ced                           # 004d7bd8
    # block 0x004d7bde: entered by fall-through of jne at 0x004d7bd8, 2 instruction(s), ends with je to 0x004d7ce8 (forward)
    cmp dword ptr [0x61cb2f], 0x0                # 004d7bde
    je.d32 L_004d7ce8                            # 004d7be5
    # block 0x004d7beb: entered by fall-through of je at 0x004d7be5, 2 instruction(s), ends with forward jump to 0x004d7bff
    mov word ptr [ebp - local_18], 0x0           # 004d7beb
    jmp.d8 L_004d7bff                            # 004d7bf1
L_004d7bf3:
    # block 0x004d7bf3: entered by jmp at 0x004d7ce3, 3 instruction(s), falls into the block at 0x004d7bff
    mov cx, word ptr [ebp - local_18]            # 004d7bf3
    add cx, 0x1                                  # 004d7bf7
    mov word ptr [ebp - local_18], cx            # 004d7bfb
L_004d7bff:
    # block 0x004d7bff: entered by jmp at 0x004d7bf1, 3 instruction(s), ends with jge to 0x004d7ce8 (forward)
    movsx edx, word ptr [ebp - local_18]         # 004d7bff
    cmp edx, 0x5                                 # 004d7c03
    jge.d32 L_004d7ce8                           # 004d7c06
    # block 0x004d7c0c: entered by fall-through of jge at 0x004d7c06, 3 instruction(s), ends with jne to 0x004d7ce8 (forward)
    movsx eax, word ptr [ebp - local_4]          # 004d7c0c
    cmp eax, -0x1                                # 004d7c10
    jne.d32 L_004d7ce8                           # 004d7c13
    # block 0x004d7c19: entered by fall-through of jne at 0x004d7c13, 2 instruction(s), ends with forward jump to 0x004d7c2d
    mov word ptr [ebp - local_14], 0x0           # 004d7c19
    jmp.d8 L_004d7c2d                            # 004d7c1f
L_004d7c21:
    # block 0x004d7c21: entered by jmp at 0x004d7cde, 3 instruction(s), falls into the block at 0x004d7c2d
    mov cx, word ptr [ebp - local_14]            # 004d7c21
    add cx, 0x1                                  # 004d7c25
    mov word ptr [ebp - local_14], cx            # 004d7c29
L_004d7c2d:
    # block 0x004d7c2d: entered by jmp at 0x004d7c1f, 3 instruction(s), ends with jge to 0x004d7ce3 (forward)
    movsx edx, word ptr [ebp - local_14]         # 004d7c2d
    cmp edx, 0x6                                 # 004d7c31
    jge.d32 L_004d7ce3                           # 004d7c34
    # block 0x004d7c3a: entered by fall-through of jge at 0x004d7c34, 3 instruction(s), ends with jne to 0x004d7ce3 (forward)
    movsx eax, word ptr [ebp - local_4]          # 004d7c3a
    cmp eax, -0x1                                # 004d7c3e
    jne.d32 L_004d7ce3                           # 004d7c41
    # block 0x004d7c47: entered by fall-through of jne at 0x004d7c41, 10 instruction(s), ends with jne to 0x004d7cde (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004d7c47
    mov edx, dword ptr [ecx + field_98a8]        # 004d7c4a
    imul edx, edx, 0x7c                          # 004d7c50
    movsx eax, word ptr [ebp - local_18]         # 004d7c53
    imul eax, eax, 0xc                           # 004d7c57
    lea ecx, [edx + eax + 0x591a28]              # 004d7c5a
    movsx edx, word ptr [ebp - local_14]         # 004d7c61
    movsx eax, word ptr [ecx + 2*edx]            # 004d7c65
    cmp eax, -0xa                                # 004d7c69
    jne.d8 L_004d7cde                            # 004d7c6c
    # block 0x004d7c6e: entered by fall-through of jne at 0x004d7c6c, 25 instruction(s), falls into the block at 0x004d7cde
    mov cx, word ptr [ebp - local_14]            # 004d7c6e
    mov word ptr [ebp - local_8], cx             # 004d7c72
    mov dx, word ptr [ebp - local_18]            # 004d7c76
    mov word ptr [ebp - local_c], dx             # 004d7c7a
    mov eax, dword ptr [ebp - local_1c]          # 004d7c7e
    mov ecx, dword ptr [eax + field_98a8]        # 004d7c81
    imul ecx, ecx, 0x7c                          # 004d7c87
    movsx edx, word ptr [ebp - local_18]         # 004d7c8a
    imul edx, edx, 0xc                           # 004d7c8e
    lea eax, [ecx + edx + 0x591a28]              # 004d7c91
    movsx ecx, word ptr [ebp - local_14]         # 004d7c98
    mov dx, word ptr [0x61cae3]                  # 004d7c9c
    mov word ptr [eax + 2*ecx], dx               # 004d7ca3
    mov eax, dword ptr [ebp - local_1c]          # 004d7ca7
    mov ecx, dword ptr [eax + field_98a8]        # 004d7caa
    imul ecx, ecx, 0x7c                          # 004d7cb0
    movsx edx, word ptr [ebp - local_18]         # 004d7cb3
    imul edx, edx, 0xc                           # 004d7cb7
    lea eax, [ecx + edx + 0x591a64]              # 004d7cba
    movsx ecx, word ptr [ebp - local_14]         # 004d7cc1
    mov dx, word ptr [0x61cae5]                  # 004d7cc5
    mov word ptr [eax + 2*ecx], dx               # 004d7ccc
    mov eax, dword ptr [ebp - local_1c]          # 004d7cd0
    mov cx, word ptr [eax + field_98a8]          # 004d7cd3
    mov word ptr [ebp - local_4], cx             # 004d7cda
L_004d7cde:
    # block 0x004d7cde: entered by jne at 0x004d7c6c, 1 instruction(s), ends with backward jump to 0x004d7c21
    jmp.d32 L_004d7c21                           # 004d7cde
L_004d7ce3:
    # block 0x004d7ce3: entered by jge at 0x004d7c34; jne at 0x004d7c41, 1 instruction(s), ends with backward jump to 0x004d7bf3
    jmp.d32 L_004d7bf3                           # 004d7ce3
L_004d7ce8:
    # block 0x004d7ce8: entered by je at 0x004d7be5; jge at 0x004d7c06; jne at 0x004d7c13, 1 instruction(s), ends with backward jump to 0x004d7bac
    jmp.d32 L_004d7bac                           # 004d7ce8
L_004d7ced:
    # block 0x004d7ced: entered by jge at 0x004d7bcb; jne at 0x004d7bd8, 87 instruction(s), calls FUN_0050e493, ends with je to 0x004d7e3f (forward)
    mov edi, 0x5b0113                            # 004d7ced
    mov edx, dword ptr [ebp - local_1c]          # 004d7cf2
    add edx, 0x98b0                              # 004d7cf5
    or ecx, -0x1                                 # 004d7cfb
    {load} xor eax, eax                          # 004d7cfe
    repne scasb al, byte ptr es:[edi]            # 004d7d00
    not ecx                                      # 004d7d02
    {load} sub edi, ecx                          # 004d7d04
    {load} mov esi, edi                          # 004d7d06
    {load} mov eax, ecx                          # 004d7d08
    {load} mov edi, edx                          # 004d7d0a
    shr ecx, 0x2                                 # 004d7d0c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d7d0f
    {load} mov ecx, eax                          # 004d7d11
    and ecx, 0x3                                 # 004d7d13
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004d7d16
    mov edi, 0x5b0131                            # 004d7d18
    mov ecx, dword ptr [ebp - local_1c]          # 004d7d1d
    add ecx, 0x98ce                              # 004d7d20
    {load} mov edx, ecx                          # 004d7d26
    or ecx, -0x1                                 # 004d7d28
    {load} xor eax, eax                          # 004d7d2b
    repne scasb al, byte ptr es:[edi]            # 004d7d2d
    not ecx                                      # 004d7d2f
    {load} sub edi, ecx                          # 004d7d31
    {load} mov esi, edi                          # 004d7d33
    {load} mov eax, ecx                          # 004d7d35
    {load} mov edi, edx                          # 004d7d37
    shr ecx, 0x2                                 # 004d7d39
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d7d3c
    {load} mov ecx, eax                          # 004d7d3e
    and ecx, 0x3                                 # 004d7d40
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004d7d43
    mov edi, 0x5b014f                            # 004d7d45
    mov ecx, dword ptr [ebp - local_1c]          # 004d7d4a
    add ecx, 0x98ec                              # 004d7d4d
    {load} mov edx, ecx                          # 004d7d53
    or ecx, -0x1                                 # 004d7d55
    {load} xor eax, eax                          # 004d7d58
    repne scasb al, byte ptr es:[edi]            # 004d7d5a
    not ecx                                      # 004d7d5c
    {load} sub edi, ecx                          # 004d7d5e
    {load} mov esi, edi                          # 004d7d60
    {load} mov eax, ecx                          # 004d7d62
    {load} mov edi, edx                          # 004d7d64
    shr ecx, 0x2                                 # 004d7d66
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d7d69
    {load} mov ecx, eax                          # 004d7d6b
    and ecx, 0x3                                 # 004d7d6d
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004d7d70
    mov ecx, dword ptr [ebp - local_1c]          # 004d7d72
    mov dx, word ptr [0x5bb21e]                  # 004d7d75
    mov word ptr [ecx + field_990a], dx          # 004d7d7c
    mov eax, dword ptr [ebp - local_1c]          # 004d7d83
    mov cx, word ptr [0x5bb220]                  # 004d7d86
    mov word ptr [eax + field_990c], cx          # 004d7d8d
    mov edx, dword ptr [ebp - local_1c]          # 004d7d94
    mov ax, word ptr [0x5bb222]                  # 004d7d97
    mov word ptr [edx + field_990e], ax          # 004d7d9d
    mov ecx, dword ptr [ebp - local_1c]          # 004d7da4
    mov dx, word ptr [0x5bb224]                  # 004d7da7
    mov word ptr [ecx + field_9910], dx          # 004d7dae
    mov ecx, 0x84a4                              # 004d7db5
    mov esi, 0x58397d                            # 004d7dba
    mov edi, dword ptr [ebp - local_1c]          # 004d7dbf
    add edi, 0x9912                              # 004d7dc2
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d7dc8
    movsw word ptr es:[edi], word ptr [esi]      # 004d7dca
    movsb byte ptr es:[edi], byte ptr [esi]      # 004d7dcc
    mov ecx, 0x2207                              # 004d7dcd
    mov esi, 0x5bb22e                            # 004d7dd2
    mov edi, dword ptr [ebp - local_1c]          # 004d7dd7
    add edi, 0x2aba5                             # 004d7dda
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d7de0
    movsb byte ptr es:[edi], byte ptr [esi]      # 004d7de2
    mov eax, dword ptr [ebp - local_1c]          # 004d7de3
    mov ecx, dword ptr [eax + field_98ac]        # 004d7de6
    push ecx                                     # 004d7dec
    push 0x1                                     # 004d7ded
    push 0x29b12                                 # 004d7def
    mov edx, dword ptr [ebp - local_1c]          # 004d7df4
    add edx, 0x98b0                              # 004d7df7
    push edx                                     # 004d7dfd
    call FUN_0050e493                            # 004d7dfe
    add esp, 0x10                                # 004d7e03
    cmp eax, 0x1                                 # 004d7e06
    je.d8 L_004d7e3f                             # 004d7e09
    # block 0x004d7e0b: entered by fall-through of je at 0x004d7e09, 2 instruction(s), ends with je to 0x004d7e33 (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 004d7e0b
    je.d8 L_004d7e33                             # 004d7e0f
    # block 0x004d7e11: entered by fall-through of je at 0x004d7e0f, 8 instruction(s), calls FUN_0042639d, FUN_004c97b4, falls into the block at 0x004d7e33
    mov eax, dword ptr [ebp - local_1c]          # 004d7e11
    add eax, 0x333e8                             # 004d7e14
    push eax                                     # 004d7e19
    push 0x55a7e0                                # 004d7e1a
    mov ecx, 0x583979                            # 004d7e1f
    call FUN_0042639d                            # 004d7e24
    mov ecx, 0x5cf659                            # 004d7e29
    call FUN_004c97b4                            # 004d7e2e
L_004d7e33:
    # block 0x004d7e33: entered by je at 0x004d7e0f, 3 instruction(s), ends with forward jump to 0x004d7e9c
    mov dword ptr [ebp - local_10], 0x0          # 004d7e33
    mov eax, dword ptr [ebp - local_10]          # 004d7e3a
    jmp.d8 L_004d7e9c                            # 004d7e3d
L_004d7e3f:
    # block 0x004d7e3f: entered by je at 0x004d7e09, 8 instruction(s), calls FUN_0050cee4, ends with je to 0x004d7e79 (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004d7e3f
    mov edx, dword ptr [ecx + field_98ac]        # 004d7e42
    push edx                                     # 004d7e48
    call FUN_0050cee4                            # 004d7e49
    add esp, 0x4                                 # 004d7e4e
    movsx eax, word ptr [ebp - local_4]          # 004d7e51
    cmp eax, -0x1                                # 004d7e55
    je.d8 L_004d7e79                             # 004d7e58
    # block 0x004d7e5a: entered by fall-through of je at 0x004d7e58, 7 instruction(s), falls into the block at 0x004d7e79
    movsx ecx, word ptr [ebp - local_4]          # 004d7e5a
    imul ecx, ecx, 0x7c                          # 004d7e5e
    movsx edx, word ptr [ebp - local_c]          # 004d7e61
    imul edx, edx, 0xc                           # 004d7e65
    lea eax, [ecx + edx + 0x591a28]              # 004d7e68
    movsx ecx, word ptr [ebp - local_8]          # 004d7e6f
    mov word ptr [eax + 2*ecx], 0xfff6           # 004d7e73
L_004d7e79:
    # block 0x004d7e79: entered by je at 0x004d7e58, 6 instruction(s), ends with je to 0x004d7e99 (forward)
    mov edi, 0x55a810                            # 004d7e79
    mov esi, dword ptr [ebp + arg_8]             # 004d7e7e
    mov ecx, 0xe                                 # 004d7e81
    {load} xor edx, edx                          # 004d7e86
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004d7e88
    je.d8 L_004d7e99                             # 004d7e8a
    # block 0x004d7e8c: entered by fall-through of je at 0x004d7e8a, 2 instruction(s), falls into the block at 0x004d7e99
    mov eax, dword ptr [ebp - local_1c]          # 004d7e8c
    mov dword ptr [eax + field_449], 0x0         # 004d7e8f
L_004d7e99:
    # block 0x004d7e99: entered by je at 0x004d7e8a, 1 instruction(s), falls into the block at 0x004d7e9c
    mov eax, dword ptr [ebp - local_10]          # 004d7e99
L_004d7e9c:
    # block 0x004d7e9c: entered by jmp at 0x004d7b92; jmp at 0x004d7e3d, 5 instruction(s), ends with ret 0x8
    pop edi                                      # 004d7e9c
    pop esi                                      # 004d7e9d
    {load} mov esp, ebp                          # 004d7e9e
    pop ebp                                      # 004d7ea0
    ret 0x8                                      # 004d7ea1

