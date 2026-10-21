# FUN_004a6270
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a6270
# extent:       0x004a6270-0x004a629e (46 code bytes)
# span:         0x004a6270-0x004a62a0 (code 46, tables 0, padding 2)
# sha256:       65373145be5cbc96368b61c7e8244b9840e53884a2b74458a86e9e87167addfa
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a6270_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m4a6270_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x4a376e(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004a376e, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m4a6270_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004a376e, .text + (0x004a376e - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004a6270 - 0x401000
.globl FUN_004a6270
FUN_004a6270:
    # block 0x004a6270: entry, 10 instruction(s), calls FUN_004a376e, ends with je to 0x004a6295 (forward)
    push ebp                                     # 004a6270
    {load} mov ebp, esp                          # 004a6271
    push ecx                                     # 004a6273
    mov dword ptr [ebp - local_4], ecx           # 004a6274
    mov ecx, dword ptr [ebp - local_4]           # 004a6277
    call FUN_004a376e                            # 004a627a
    mov eax, dword ptr [ebp + arg_8]             # 004a627f
    and eax, 0x1                                 # 004a6282
    test eax, eax                                # 004a6285
    je.d8 L_004a6295                             # 004a6287
    # block 0x004a6289: entered by fall-through of je at 0x004a6287, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004a6295
    mov ecx, dword ptr [ebp - local_4]           # 004a6289
    push ecx                                     # 004a628c
    call FUN_0051dc6c                            # 004a628d
    add esp, 0x4                                 # 004a6292
L_004a6295:
    # block 0x004a6295: entered by je at 0x004a6287, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004a6295
    {load} mov esp, ebp                          # 004a6298
    pop ebp                                      # 004a629a
    ret 0x4                                      # 004a629b

# --- data items (not part of the function) -------------------------
.org 0x004a629e - 0x401000
PAD_004a629e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

