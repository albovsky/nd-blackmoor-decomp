# FUN_004e9a2c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e9a2c
# extent:       0x004e9a2c-0x004e9add (177 code bytes)
# span:         0x004e9a2c-0x004e9add (code 177, tables 0, padding 0)
# sha256:       6c84e78efb1eb4070f165e80a72775451f1879f4e77a4bfcd4e44f49795bbd3b
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e9a2c_clone_record
# naming:       native port src/original_methods_fl39b.c:m4e9a2c_clone_record (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Allocates 0x72 bytes with 0x51dc43, stores the block to [p0], reports a null block (0x50ca3e, 0x42639d, 0x4c97b4), otherwise copies 0x72 bytes (rep movsd, movsw) from [p1] to [p0]. All instructions run; both jump directions taken.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39b.c:m4e9a2c_clone_record (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 57 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004e9a2c - 0x401000
.globl FUN_004e9a2c
FUN_004e9a2c:
    # block 0x004e9a2c: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x004e9a90 (forward)
    push ebp                                     # 004e9a2c
    {load} mov ebp, esp                          # 004e9a2d
    sub esp, 0x8                                 # 004e9a2f
    push esi                                     # 004e9a32
    push edi                                     # 004e9a33
    mov dword ptr [ebp - local_8], ecx           # 004e9a34
    push 0x72                                    # 004e9a37
    call FUN_0051dc43                            # 004e9a39
    add esp, 0x4                                 # 004e9a3e
    mov dword ptr [ebp - local_4], eax           # 004e9a41
    mov eax, dword ptr [ebp + arg_8]             # 004e9a44
    mov ecx, dword ptr [ebp - local_4]           # 004e9a47
    mov dword ptr [eax], ecx                     # 004e9a4a
    cmp dword ptr [ebp - local_4], 0x0           # 004e9a4c
    jne.d8 L_004e9a90                            # 004e9a50
    # block 0x004e9a52: entered by fall-through of jne at 0x004e9a50, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004e9a90
    movsx edx, word ptr [0x5c39e3]               # 004e9a52
    push edx                                     # 004e9a59
    mov eax, dword ptr [0x5bb57b]                # 004e9a5a
    push eax                                     # 004e9a5f
    push 0x55c7b0                                # 004e9a60
    push 0x63888b                                # 004e9a65
    call FUN_0050ca3e                            # 004e9a6a
    add esp, 0x10                                # 004e9a6f
    push 0x63888b                                # 004e9a72
    push 0x55c7dc                                # 004e9a77
    mov ecx, 0x583979                            # 004e9a7c
    call FUN_0042639d                            # 004e9a81
    mov ecx, 0x5cf659                            # 004e9a86
    call FUN_004c97b4                            # 004e9a8b
L_004e9a90:
    # block 0x004e9a90: entered by jne at 0x004e9a50, 20 instruction(s), ends with je to 0x004e9ad5 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 004e9a90
    mov esi, dword ptr [ecx]                     # 004e9a93
    mov edx, dword ptr [ebp + arg_8]             # 004e9a95
    mov edi, dword ptr [edx]                     # 004e9a98
    mov ecx, 0x1c                                # 004e9a9a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e9a9f
    movsw word ptr es:[edi], word ptr [esi]      # 004e9aa1
    mov eax, dword ptr [ebp + arg_10]            # 004e9aa3
    mov ecx, dword ptr [eax]                     # 004e9aa6
    add ecx, 0x72                                # 004e9aa8
    mov edx, dword ptr [ebp + arg_10]            # 004e9aab
    mov dword ptr [edx], ecx                     # 004e9aae
    mov eax, dword ptr [ebp + arg_c]             # 004e9ab0
    mov ecx, dword ptr [eax]                     # 004e9ab3
    add ecx, 0x72                                # 004e9ab5
    mov edx, dword ptr [ebp + arg_c]             # 004e9ab8
    mov dword ptr [edx], ecx                     # 004e9abb
    movsx eax, word ptr [0x63a4cd]               # 004e9abd
    test eax, eax                                # 004e9ac4
    je.d8 L_004e9ad5                             # 004e9ac6
    # block 0x004e9ac8: entered by fall-through of je at 0x004e9ac6, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004e9ad5
    push 0x55c7f8                                # 004e9ac8
    call FUN_0044a2b7                            # 004e9acd
    add esp, 0x4                                 # 004e9ad2
L_004e9ad5:
    # block 0x004e9ad5: entered by je at 0x004e9ac6, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 004e9ad5
    pop esi                                      # 004e9ad6
    {load} mov esp, ebp                          # 004e9ad7
    pop ebp                                      # 004e9ad9
    ret 0xc                                      # 004e9ada

