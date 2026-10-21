# FUN_004756c0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004756c0
# extent:       0x004756c0-0x004756ee (46 code bytes)
# span:         0x004756c0-0x004756f0 (code 46, tables 0, padding 2)
# sha256:       08b4665abf4f5b47654210f7f20dce4e3f8e39a160a193edcde2028708f18f84
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4756c0_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m4756c0_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x472f95(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00472f95, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m4756c0_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00472f95, .text + (0x00472f95 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004756c0 - 0x401000
.globl FUN_004756c0
FUN_004756c0:
    # block 0x004756c0: entry, 10 instruction(s), calls FUN_00472f95, ends with je to 0x004756e5 (forward)
    push ebp                                     # 004756c0
    {load} mov ebp, esp                          # 004756c1
    push ecx                                     # 004756c3
    mov dword ptr [ebp - local_4], ecx           # 004756c4
    mov ecx, dword ptr [ebp - local_4]           # 004756c7
    call FUN_00472f95                            # 004756ca
    mov eax, dword ptr [ebp + arg_8]             # 004756cf
    and eax, 0x1                                 # 004756d2
    test eax, eax                                # 004756d5
    je.d8 L_004756e5                             # 004756d7
    # block 0x004756d9: entered by fall-through of je at 0x004756d7, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004756e5
    mov ecx, dword ptr [ebp - local_4]           # 004756d9
    push ecx                                     # 004756dc
    call FUN_0051dc6c                            # 004756dd
    add esp, 0x4                                 # 004756e2
L_004756e5:
    # block 0x004756e5: entered by je at 0x004756d7, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004756e5
    {load} mov esp, ebp                          # 004756e8
    pop ebp                                      # 004756ea
    ret 0x4                                      # 004756eb

# --- data items (not part of the function) -------------------------
.org 0x004756ee - 0x401000
PAD_004756ee:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

