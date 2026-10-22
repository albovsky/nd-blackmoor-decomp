# FUN_004e9b87
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e9b87
# extent:       0x004e9b87-0x004e9c2f (168 code bytes)
# span:         0x004e9b87-0x004e9c2f (code 168, tables 0, padding 0)
# sha256:       18dda3886dc204864d676dd68d00dd891ccc7d8662784e19da4cb015845cb137
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e9b87_clone_record
# naming:       native port src/original_methods_fl39b.c:m4e9b87_clone_record (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Allocates 0x4 bytes with 0x51dc43, stores the block to [p0], reports a null block (0x50ca3e, 0x42639d, 0x4c97b4), otherwise copies 0x4 bytes (one dword move) from [p1] to [p0]. All instructions run; both jump directions taken.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39b.c:m4e9b87_clone_record (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 52 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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

.org 0x004e9b87 - 0x401000
.globl FUN_004e9b87
FUN_004e9b87:
    # block 0x004e9b87: entry, 13 instruction(s), calls FUN_0051dc43, ends with jne to 0x004e9be9 (forward)
    push ebp                                     # 004e9b87
    {load} mov ebp, esp                          # 004e9b88
    sub esp, 0x8                                 # 004e9b8a
    mov dword ptr [ebp - local_8], ecx           # 004e9b8d
    push 0x4                                     # 004e9b90
    call FUN_0051dc43                            # 004e9b92
    add esp, 0x4                                 # 004e9b97
    mov dword ptr [ebp - local_4], eax           # 004e9b9a
    mov eax, dword ptr [ebp + arg_8]             # 004e9b9d
    mov ecx, dword ptr [ebp - local_4]           # 004e9ba0
    mov dword ptr [eax], ecx                     # 004e9ba3
    cmp dword ptr [ebp - local_4], 0x0           # 004e9ba5
    jne.d8 L_004e9be9                            # 004e9ba9
    # block 0x004e9bab: entered by fall-through of jne at 0x004e9ba9, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004e9be9
    movsx edx, word ptr [0x5c39e3]               # 004e9bab
    push edx                                     # 004e9bb2
    mov eax, dword ptr [0x5bb57b]                # 004e9bb3
    push eax                                     # 004e9bb8
    push 0x55c8b8                                # 004e9bb9
    push 0x63888b                                # 004e9bbe
    call FUN_0050ca3e                            # 004e9bc3
    add esp, 0x10                                # 004e9bc8
    push 0x63888b                                # 004e9bcb
    push 0x55c8e4                                # 004e9bd0
    mov ecx, 0x583979                            # 004e9bd5
    call FUN_0042639d                            # 004e9bda
    mov ecx, 0x5cf659                            # 004e9bdf
    call FUN_004c97b4                            # 004e9be4
L_004e9be9:
    # block 0x004e9be9: entered by jne at 0x004e9ba9, 19 instruction(s), ends with je to 0x004e9c29 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 004e9be9
    mov edx, dword ptr [ecx]                     # 004e9bec
    mov eax, dword ptr [ebp + arg_8]             # 004e9bee
    mov ecx, dword ptr [eax]                     # 004e9bf1
    mov edx, dword ptr [edx]                     # 004e9bf3
    mov dword ptr [ecx], edx                     # 004e9bf5
    mov eax, dword ptr [ebp + arg_10]            # 004e9bf7
    mov ecx, dword ptr [eax]                     # 004e9bfa
    add ecx, 0x4                                 # 004e9bfc
    mov edx, dword ptr [ebp + arg_10]            # 004e9bff
    mov dword ptr [edx], ecx                     # 004e9c02
    mov eax, dword ptr [ebp + arg_c]             # 004e9c04
    mov ecx, dword ptr [eax]                     # 004e9c07
    add ecx, 0x4                                 # 004e9c09
    mov edx, dword ptr [ebp + arg_c]             # 004e9c0c
    mov dword ptr [edx], ecx                     # 004e9c0f
    movsx eax, word ptr [0x63a4cd]               # 004e9c11
    test eax, eax                                # 004e9c18
    je.d8 L_004e9c29                             # 004e9c1a
    # block 0x004e9c1c: entered by fall-through of je at 0x004e9c1a, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004e9c29
    push 0x55c900                                # 004e9c1c
    call FUN_0044a2b7                            # 004e9c21
    add esp, 0x4                                 # 004e9c26
L_004e9c29:
    # block 0x004e9c29: entered by je at 0x004e9c1a, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 004e9c29
    pop ebp                                      # 004e9c2b
    ret 0xc                                      # 004e9c2c

