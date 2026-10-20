# FUN_00485d52
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00485d52
# extent:       0x00485d52-0x00485f12 (448 code bytes)
# span:         0x00485d52-0x00485f12 (code 448, tables 0, padding 0)
# sha256:       aad3960dbe028697511f500ad7e2328e726a6483d6d83ae0ed0bbe257ae15e10
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         drop_sound
# naming:       native port src/action_family_ea_runtime.c:drop_sound (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with drop_sound (record +0x6d8, rand()%3 alternate loop, state 1, deadline tick+300, flag 1). Body is a parameter; negative rand returns EA_ERR_BOUNDS; oracle aggregate.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_26, field_b73; [ecx + n] field_bc9; [edx + n] field_b87, field_bac
# callees:      calls FUN_0050cd50, FUN_004fb77a, FUN_004fb2e3, KERNEL32.dll!GetTickCount
# track-n:      outputs/blackmoor-decomp/src/action_family_ea_runtime.c:drop_sound (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 131 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_26, 0x26  # offset +0x26
.equ field_b73, 0xb73  # offset +0xb73
.equ field_b87, 0xb87  # offset +0xb87
.equ field_bac, 0xbac  # offset +0xbac
.equ field_bc9, 0xbc9  # offset +0xbc9

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x00485d52 - 0x401000
.globl FUN_00485d52
FUN_00485d52:
    # block 0x00485d52: entry, 18 instruction(s), ends with jne to 0x00485d91 (forward)
    push ebp                                     # 00485d52
    {load} mov ebp, esp                          # 00485d53
    sub esp, 0x10                                # 00485d55
    push esi                                     # 00485d58
    push edi                                     # 00485d59
    mov dword ptr [ebp - local_10], ecx          # 00485d5a
    mov eax, dword ptr [ebp - local_10]          # 00485d5d
    movsx ecx, word ptr [eax + field_26]         # 00485d60
    imul ecx, ecx, 0x8d                          # 00485d64
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00485d6a
    mov dword ptr [ebp - local_8], edx           # 00485d70
    mov edi, 0x54db54                            # 00485d73
    mov esi, dword ptr [ebp - local_8]           # 00485d78
    add esi, 0x6d8                               # 00485d7b
    mov ecx, 0x9                                 # 00485d81
    {load} xor eax, eax                          # 00485d86
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00485d88
    jne.d8 L_00485d91                            # 00485d8a
    # block 0x00485d8c: entered by fall-through of jne at 0x00485d8a, 1 instruction(s), ends with forward jump to 0x00485f0c
    jmp.d32 L_00485f0c                           # 00485d8c
L_00485d91:
    # block 0x00485d91: entered by jne at 0x00485d8a, 15 instruction(s), calls FUN_0050cd50, ends with jle to 0x00485eb5 (forward)
    mov esi, dword ptr [ebp - local_8]           # 00485d91
    add esi, 0x6d8                               # 00485d94
    mov edi, dword ptr [ebp - local_10]          # 00485d9a
    add edi, 0xb52                               # 00485d9d
    mov ecx, 0xc                                 # 00485da3
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00485da8
    movsb byte ptr es:[edi], byte ptr [esi]      # 00485daa
    call FUN_0050cd50                            # 00485dab
    cdq                                          # 00485db0
    mov ecx, 0x3                                 # 00485db1
    idiv ecx                                     # 00485db6
    mov word ptr [ebp - local_c], dx             # 00485db8
    movsx edx, word ptr [ebp - local_c]          # 00485dbc
    test edx, edx                                # 00485dc0
    jle.d32 L_00485eb5                           # 00485dc2
    # block 0x00485dc8: entered by fall-through of jle at 0x00485dc2, 1 instruction(s), falls into the block at 0x00485dcf
    mov dword ptr [ebp - local_4], 0x0           # 00485dc8
L_00485dcf:
    # block 0x00485dcf: entered by jmp at 0x00485eb0, 2 instruction(s), ends with jne to 0x00485eb5 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 00485dcf
    jne.d32 L_00485eb5                           # 00485dd3
    # block 0x00485dd9: entered by fall-through of jne at 0x00485dd3, 3 instruction(s), ends with jle to 0x00485eb5 (forward)
    movsx eax, word ptr [ebp - local_c]          # 00485dd9
    test eax, eax                                # 00485ddd
    jle.d32 L_00485eb5                           # 00485ddf
    # block 0x00485de5: entered by fall-through of jle at 0x00485ddf, 3 instruction(s), ends with jne to 0x00485e42 (forward)
    movsx ecx, word ptr [ebp - local_c]          # 00485de5
    cmp ecx, 0x1                                 # 00485de9
    jne.d8 L_00485e42                            # 00485dec
    # block 0x00485dee: entered by fall-through of jne at 0x00485dec, 7 instruction(s), ends with je to 0x00485e42 (forward)
    mov edi, 0x54db60                            # 00485dee
    mov esi, dword ptr [ebp - local_8]           # 00485df3
    add esi, 0x709                               # 00485df6
    mov ecx, 0x9                                 # 00485dfc
    {load} xor edx, edx                          # 00485e01
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00485e03
    je.d8 L_00485e42                             # 00485e05
    # block 0x00485e07: entered by fall-through of je at 0x00485e05, 21 instruction(s), ends with forward jump to 0x00485eb0
    mov eax, dword ptr [ebp - local_8]           # 00485e07
    add eax, 0x709                               # 00485e0a
    {load} mov edi, eax                          # 00485e0f
    mov ecx, dword ptr [ebp - local_10]          # 00485e11
    add ecx, 0xb52                               # 00485e14
    {load} mov edx, ecx                          # 00485e1a
    or ecx, -0x1                                 # 00485e1c
    {load} xor eax, eax                          # 00485e1f
    repne scasb al, byte ptr es:[edi]            # 00485e21
    not ecx                                      # 00485e23
    {load} sub edi, ecx                          # 00485e25
    {load} mov esi, edi                          # 00485e27
    {load} mov eax, ecx                          # 00485e29
    {load} mov edi, edx                          # 00485e2b
    shr ecx, 0x2                                 # 00485e2d
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00485e30
    {load} mov ecx, eax                          # 00485e32
    and ecx, 0x3                                 # 00485e34
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00485e37
    mov dword ptr [ebp - local_4], 0x1           # 00485e39
    jmp.d8 L_00485eb0                            # 00485e40
L_00485e42:
    # block 0x00485e42: entered by jne at 0x00485dec; je at 0x00485e05, 3 instruction(s), ends with jne to 0x00485e9f (forward)
    movsx ecx, word ptr [ebp - local_c]          # 00485e42
    cmp ecx, 0x2                                 # 00485e46
    jne.d8 L_00485e9f                            # 00485e49
    # block 0x00485e4b: entered by fall-through of jne at 0x00485e49, 7 instruction(s), ends with je to 0x00485e9f (forward)
    mov edi, 0x54db6c                            # 00485e4b
    mov esi, dword ptr [ebp - local_8]           # 00485e50
    add esi, 0x72a                               # 00485e53
    mov ecx, 0x9                                 # 00485e59
    {load} xor edx, edx                          # 00485e5e
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00485e60
    je.d8 L_00485e9f                             # 00485e62
    # block 0x00485e64: entered by fall-through of je at 0x00485e62, 21 instruction(s), ends with forward jump to 0x00485eb0
    mov eax, dword ptr [ebp - local_8]           # 00485e64
    add eax, 0x72a                               # 00485e67
    {load} mov edi, eax                          # 00485e6c
    mov ecx, dword ptr [ebp - local_10]          # 00485e6e
    add ecx, 0xb52                               # 00485e71
    {load} mov edx, ecx                          # 00485e77
    or ecx, -0x1                                 # 00485e79
    {load} xor eax, eax                          # 00485e7c
    repne scasb al, byte ptr es:[edi]            # 00485e7e
    not ecx                                      # 00485e80
    {load} sub edi, ecx                          # 00485e82
    {load} mov esi, edi                          # 00485e84
    {load} mov eax, ecx                          # 00485e86
    {load} mov edi, edx                          # 00485e88
    shr ecx, 0x2                                 # 00485e8a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00485e8d
    {load} mov ecx, eax                          # 00485e8f
    and ecx, 0x3                                 # 00485e91
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00485e94
    mov dword ptr [ebp - local_4], 0x1           # 00485e96
    jmp.d8 L_00485eb0                            # 00485e9d
L_00485e9f:
    # block 0x00485e9f: entered by jne at 0x00485e49; je at 0x00485e62, 5 instruction(s), calls FUN_0050cd50, falls into the block at 0x00485eb0
    call FUN_0050cd50                            # 00485e9f
    cdq                                          # 00485ea4
    mov ecx, 0x3                                 # 00485ea5
    idiv ecx                                     # 00485eaa
    mov word ptr [ebp - local_c], dx             # 00485eac
L_00485eb0:
    # block 0x00485eb0: entered by jmp at 0x00485e40; jmp at 0x00485e9d, 1 instruction(s), ends with backward jump to 0x00485dcf
    jmp.d32 L_00485dcf                           # 00485eb0
L_00485eb5:
    # block 0x00485eb5: entered by jle at 0x00485dc2; jne at 0x00485dd3; jle at 0x00485ddf, 18 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, KERNEL32.dll!GetTickCount, falls into the block at 0x00485f0c
    mov edx, dword ptr [ebp - local_10]          # 00485eb5
    add edx, 0xb52                               # 00485eb8
    push edx                                     # 00485ebe
    mov ecx, 0x5c3a67                            # 00485ebf
    call FUN_004fb77a                            # 00485ec4
    mov eax, dword ptr [ebp - local_10]          # 00485ec9
    mov cx, word ptr [eax + field_b73]           # 00485ecc
    push ecx                                     # 00485ed3
    mov ecx, 0x5c3a67                            # 00485ed4
    call FUN_004fb2e3                            # 00485ed9
    mov edx, dword ptr [ebp - local_10]          # 00485ede
    mov dword ptr [edx + field_bac], 0x1         # 00485ee1
    call dword ptr [0x52a23c]                    # 00485eeb
    add eax, 0x12c                               # 00485ef1
    mov ecx, dword ptr [ebp - local_10]          # 00485ef6
    mov dword ptr [ecx + field_bc9], eax         # 00485ef9
    mov edx, dword ptr [ebp - local_10]          # 00485eff
    mov dword ptr [edx + field_b87], 0x1         # 00485f02
L_00485f0c:
    # block 0x00485f0c: entered by jmp at 0x00485d8c, 5 instruction(s), ends with ret
    pop edi                                      # 00485f0c
    pop esi                                      # 00485f0d
    {load} mov esp, ebp                          # 00485f0e
    pop ebp                                      # 00485f10
    ret                                          # 00485f11

