# FUN_00401100
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00401100
# extent:       0x00401100-0x0040112e (46 code bytes)
# span:         0x00401100-0x00401130 (code 46, tables 0, padding 2)
# sha256:       53304095d3b3812d8725e97e7cbd9bf5a161b6396deb3242ae0719d334ddd49e
# evidence:     ev_5101d3157a7cceecfaf0c751ae06a21a7013310d21b12b5f59cdca7af1ddb679
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m401100_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m401100_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x401032(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00401032, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m401100_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00401032, .text + (0x00401032 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00401100 - 0x401000
.globl FUN_00401100
FUN_00401100:
    # block 0x00401100: entry, 10 instruction(s), calls FUN_00401032, ends with je to 0x00401125 (forward)
    push ebp                                     # 00401100
    {load} mov ebp, esp                          # 00401101
    push ecx                                     # 00401103
    mov dword ptr [ebp - local_4], ecx           # 00401104
    mov ecx, dword ptr [ebp - local_4]           # 00401107
    call FUN_00401032                            # 0040110a
    mov eax, dword ptr [ebp + arg_8]             # 0040110f
    and eax, 0x1                                 # 00401112
    test eax, eax                                # 00401115
    je.d8 L_00401125                             # 00401117
    # block 0x00401119: entered by fall-through of je at 0x00401117, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00401125
    mov ecx, dword ptr [ebp - local_4]           # 00401119
    push ecx                                     # 0040111c
    call FUN_0051dc6c                            # 0040111d
    add esp, 0x4                                 # 00401122
L_00401125:
    # block 0x00401125: entered by je at 0x00401117, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 00401125
    {load} mov esp, ebp                          # 00401128
    pop ebp                                      # 0040112a
    ret 0x4                                      # 0040112b

# --- data items (not part of the function) -------------------------
.org 0x0040112e - 0x401000
PAD_0040112e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

