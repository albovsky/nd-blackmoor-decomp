# FUN_00414c80
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00414c80
# extent:       0x00414c80-0x00414cae (46 code bytes)
# span:         0x00414c80-0x00414cb0 (code 46, tables 0, padding 2)
# sha256:       a8654860c1ea2260bcb7c53fd81a13536e8846bded40327520a8902de0921261
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m414c80_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m414c80_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x41458b(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0041458b, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m414c80_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0041458b, .text + (0x0041458b - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00414c80 - 0x401000
.globl FUN_00414c80
FUN_00414c80:
    # block 0x00414c80: entry, 10 instruction(s), calls FUN_0041458b, ends with je to 0x00414ca5 (forward)
    push ebp                                     # 00414c80
    {load} mov ebp, esp                          # 00414c81
    push ecx                                     # 00414c83
    mov dword ptr [ebp - local_4], ecx           # 00414c84
    mov ecx, dword ptr [ebp - local_4]           # 00414c87
    call FUN_0041458b                            # 00414c8a
    mov eax, dword ptr [ebp + arg_8]             # 00414c8f
    and eax, 0x1                                 # 00414c92
    test eax, eax                                # 00414c95
    je.d8 L_00414ca5                             # 00414c97
    # block 0x00414c99: entered by fall-through of je at 0x00414c97, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00414ca5
    mov ecx, dword ptr [ebp - local_4]           # 00414c99
    push ecx                                     # 00414c9c
    call FUN_0051dc6c                            # 00414c9d
    add esp, 0x4                                 # 00414ca2
L_00414ca5:
    # block 0x00414ca5: entered by je at 0x00414c97, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 00414ca5
    {load} mov esp, ebp                          # 00414ca8
    pop ebp                                      # 00414caa
    ret 0x4                                      # 00414cab

# --- data items (not part of the function) -------------------------
.org 0x00414cae - 0x401000
PAD_00414cae:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

