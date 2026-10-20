# FUN_00411a22
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00411a22
# extent:       0x00411a22-0x00411b16 (244 code bytes)
# span:         0x00411a22-0x00411b16 (code 244, tables 0, padding 0)
# sha256:       c9e641c18f0fd3663697c2c7bc3f23a193c4040e79d336047f53c5534dcb53ba
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m411a22_alloc_copy
# naming:       native port src/original_methods_fl29b.c:m411a22_alloc_copy (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    Allocates 0x27 bytes, stores the result in the record table at a signed-word index, copies 0x27 bytes between two cell addresses and advances both; oracle executes every instruction and all jump directions. See tasks/fl29b-handoff.md.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [edx + n] field_23
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl29b.c:m411a22_alloc_copy (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 75 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_23, 0x23  # offset +0x23

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00411a22 - 0x401000
.globl FUN_00411a22
FUN_00411a22:
    # block 0x00411a22: entry, 13 instruction(s), ends with jl to 0x00411a49 (forward)
    push ebp                                     # 00411a22
    {load} mov ebp, esp                          # 00411a23
    sub esp, 0x10                                # 00411a25
    push esi                                     # 00411a28
    push edi                                     # 00411a29
    mov dword ptr [ebp - local_10], ecx          # 00411a2a
    mov eax, dword ptr [ebp + arg_c]             # 00411a2d
    mov ecx, dword ptr [eax]                     # 00411a30
    mov dword ptr [ebp - local_8], ecx           # 00411a32
    mov edx, dword ptr [ebp - local_8]           # 00411a35
    movsx eax, word ptr [edx + field_23]         # 00411a38
    cmp eax, 0xa                                 # 00411a3c
    jl.d8 L_00411a49                             # 00411a3f
    # block 0x00411a41: entered by fall-through of jl at 0x00411a3f, 2 instruction(s), ends with forward jump to 0x00411a4f
    mov word ptr [ebp - local_4], 0x27           # 00411a41
    jmp.d8 L_00411a4f                            # 00411a47
L_00411a49:
    # block 0x00411a49: entered by jl at 0x00411a3f, 1 instruction(s), falls into the block at 0x00411a4f
    mov word ptr [ebp - local_4], 0x27           # 00411a49
L_00411a4f:
    # block 0x00411a4f: entered by jmp at 0x00411a47, 11 instruction(s), calls FUN_0051dc43, ends with jne to 0x00411aba (forward)
    movsx ecx, word ptr [ebp - local_4]          # 00411a4f
    push ecx                                     # 00411a53
    call FUN_0051dc43                            # 00411a54
    add esp, 0x4                                 # 00411a59
    mov dword ptr [ebp - local_c], eax           # 00411a5c
    movsx edx, word ptr [0x5c39e3]               # 00411a5f
    imul edx, edx, 0x8d                          # 00411a66
    mov eax, dword ptr [ebp - local_c]           # 00411a6c
    mov dword ptr [edx + 0x5bb5e5], eax          # 00411a6f
    cmp dword ptr [ebp - local_c], 0x0           # 00411a75
    jne.d8 L_00411aba                            # 00411a79
    # block 0x00411a7b: entered by fall-through of jne at 0x00411a79, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x00411aba
    movsx ecx, word ptr [0x5c39e3]               # 00411a7b
    push ecx                                     # 00411a82
    mov edx, dword ptr [0x5bb57b]                # 00411a83
    push edx                                     # 00411a89
    push 0x541404                                # 00411a8a
    push 0x63888b                                # 00411a8f
    call FUN_0050ca3e                            # 00411a94
    add esp, 0x10                                # 00411a99
    push 0x63888b                                # 00411a9c
    push 0x541430                                # 00411aa1
    mov ecx, 0x583979                            # 00411aa6
    call FUN_0042639d                            # 00411aab
    mov ecx, 0x5cf659                            # 00411ab0
    call FUN_004c97b4                            # 00411ab5
L_00411aba:
    # block 0x00411aba: entered by jne at 0x00411a79, 26 instruction(s), ends with je to 0x00411b0e (forward)
    movsx ecx, word ptr [ebp - local_4]          # 00411aba
    mov eax, dword ptr [ebp + arg_c]             # 00411abe
    mov esi, dword ptr [eax]                     # 00411ac1
    mov edx, dword ptr [ebp + arg_8]             # 00411ac3
    mov edi, dword ptr [edx]                     # 00411ac6
    {load} mov eax, ecx                          # 00411ac8
    shr ecx, 0x2                                 # 00411aca
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00411acd
    {load} mov ecx, eax                          # 00411acf
    and ecx, 0x3                                 # 00411ad1
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00411ad4
    movsx ecx, word ptr [ebp - local_4]          # 00411ad6
    mov edx, dword ptr [ebp + arg_10]            # 00411ada
    mov eax, dword ptr [edx]                     # 00411add
    {load} add eax, ecx                          # 00411adf
    mov ecx, dword ptr [ebp + arg_10]            # 00411ae1
    mov dword ptr [ecx], eax                     # 00411ae4
    movsx edx, word ptr [ebp - local_4]          # 00411ae6
    mov eax, dword ptr [ebp + arg_c]             # 00411aea
    mov ecx, dword ptr [eax]                     # 00411aed
    {load} add ecx, edx                          # 00411aef
    mov edx, dword ptr [ebp + arg_c]             # 00411af1
    mov dword ptr [edx], ecx                     # 00411af4
    movsx eax, word ptr [0x63a4cd]               # 00411af6
    test eax, eax                                # 00411afd
    je.d8 L_00411b0e                             # 00411aff
    # block 0x00411b01: entered by fall-through of je at 0x00411aff, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00411b0e
    push 0x54144c                                # 00411b01
    call FUN_0044a2b7                            # 00411b06
    add esp, 0x4                                 # 00411b0b
L_00411b0e:
    # block 0x00411b0e: entered by je at 0x00411aff, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 00411b0e
    pop esi                                      # 00411b0f
    {load} mov esp, ebp                          # 00411b10
    pop ebp                                      # 00411b12
    ret 0xc                                      # 00411b13

