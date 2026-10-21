# FUN_004d5230
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d5230
# extent:       0x004d5230-0x004d525e (46 code bytes)
# span:         0x004d5230-0x004d5260 (code 46, tables 0, padding 2)
# sha256:       807f2fa34e547d08cfe0c8c01a548c3ce68518e7ea9bea37402d10a08e49338b
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d5230_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m4d5230_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x44af20(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0044af20, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m4d5230_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0044af20, .text + (0x0044af20 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004d5230 - 0x401000
.globl FUN_004d5230
FUN_004d5230:
    # block 0x004d5230: entry, 10 instruction(s), calls FUN_0044af20, ends with je to 0x004d5255 (forward)
    push ebp                                     # 004d5230
    {load} mov ebp, esp                          # 004d5231
    push ecx                                     # 004d5233
    mov dword ptr [ebp - local_4], ecx           # 004d5234
    mov ecx, dword ptr [ebp - local_4]           # 004d5237
    call FUN_0044af20                            # 004d523a
    mov eax, dword ptr [ebp + arg_8]             # 004d523f
    and eax, 0x1                                 # 004d5242
    test eax, eax                                # 004d5245
    je.d8 L_004d5255                             # 004d5247
    # block 0x004d5249: entered by fall-through of je at 0x004d5247, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004d5255
    mov ecx, dword ptr [ebp - local_4]           # 004d5249
    push ecx                                     # 004d524c
    call FUN_0051dc6c                            # 004d524d
    add esp, 0x4                                 # 004d5252
L_004d5255:
    # block 0x004d5255: entered by je at 0x004d5247, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004d5255
    {load} mov esp, ebp                          # 004d5258
    pop ebp                                      # 004d525a
    ret 0x4                                      # 004d525b

# --- data items (not part of the function) -------------------------
.org 0x004d525e - 0x401000
PAD_004d525e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

