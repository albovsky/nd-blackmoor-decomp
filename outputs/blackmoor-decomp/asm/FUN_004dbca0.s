# FUN_004dbca0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004dbca0
# extent:       0x004dbca0-0x004dbcce (46 code bytes)
# span:         0x004dbca0-0x004dbcd0 (code 46, tables 0, padding 2)
# sha256:       0ca48b78c77c791c199cc7abf2d38336417bbe647f8ab86f208f4066089c5624
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4dbca0_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m4dbca0_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x4db27f(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004db27f, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m4dbca0_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004db27f, .text + (0x004db27f - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004dbca0 - 0x401000
.globl FUN_004dbca0
FUN_004dbca0:
    # block 0x004dbca0: entry, 10 instruction(s), calls FUN_004db27f, ends with je to 0x004dbcc5 (forward)
    push ebp                                     # 004dbca0
    {load} mov ebp, esp                          # 004dbca1
    push ecx                                     # 004dbca3
    mov dword ptr [ebp - local_4], ecx           # 004dbca4
    mov ecx, dword ptr [ebp - local_4]           # 004dbca7
    call FUN_004db27f                            # 004dbcaa
    mov eax, dword ptr [ebp + arg_8]             # 004dbcaf
    and eax, 0x1                                 # 004dbcb2
    test eax, eax                                # 004dbcb5
    je.d8 L_004dbcc5                             # 004dbcb7
    # block 0x004dbcb9: entered by fall-through of je at 0x004dbcb7, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004dbcc5
    mov ecx, dword ptr [ebp - local_4]           # 004dbcb9
    push ecx                                     # 004dbcbc
    call FUN_0051dc6c                            # 004dbcbd
    add esp, 0x4                                 # 004dbcc2
L_004dbcc5:
    # block 0x004dbcc5: entered by je at 0x004dbcb7, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004dbcc5
    {load} mov esp, ebp                          # 004dbcc8
    pop ebp                                      # 004dbcca
    ret 0x4                                      # 004dbccb

# --- data items (not part of the function) -------------------------
.org 0x004dbcce - 0x401000
PAD_004dbcce:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

