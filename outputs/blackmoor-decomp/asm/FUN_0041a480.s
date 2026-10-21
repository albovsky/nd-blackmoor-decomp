# FUN_0041a480
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041a480
# extent:       0x0041a480-0x0041a4ae (46 code bytes)
# span:         0x0041a480-0x0041a4b0 (code 46, tables 0, padding 2)
# sha256:       96c8bb21caf34dc5bf59ac633f84e031f53519a049d1aac5beb50cdb58a972fe
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m41a480_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m41a480_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x416f2d(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00416f2d, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m41a480_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00416f2d, .text + (0x00416f2d - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0041a480 - 0x401000
.globl FUN_0041a480
FUN_0041a480:
    # block 0x0041a480: entry, 10 instruction(s), calls FUN_00416f2d, ends with je to 0x0041a4a5 (forward)
    push ebp                                     # 0041a480
    {load} mov ebp, esp                          # 0041a481
    push ecx                                     # 0041a483
    mov dword ptr [ebp - local_4], ecx           # 0041a484
    mov ecx, dword ptr [ebp - local_4]           # 0041a487
    call FUN_00416f2d                            # 0041a48a
    mov eax, dword ptr [ebp + arg_8]             # 0041a48f
    and eax, 0x1                                 # 0041a492
    test eax, eax                                # 0041a495
    je.d8 L_0041a4a5                             # 0041a497
    # block 0x0041a499: entered by fall-through of je at 0x0041a497, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0041a4a5
    mov ecx, dword ptr [ebp - local_4]           # 0041a499
    push ecx                                     # 0041a49c
    call FUN_0051dc6c                            # 0041a49d
    add esp, 0x4                                 # 0041a4a2
L_0041a4a5:
    # block 0x0041a4a5: entered by je at 0x0041a497, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 0041a4a5
    {load} mov esp, ebp                          # 0041a4a8
    pop ebp                                      # 0041a4aa
    ret 0x4                                      # 0041a4ab

# --- data items (not part of the function) -------------------------
.org 0x0041a4ae - 0x401000
PAD_0041a4ae:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

