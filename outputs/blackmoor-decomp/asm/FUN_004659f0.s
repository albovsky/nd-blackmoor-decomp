# FUN_004659f0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004659f0
# extent:       0x004659f0-0x00465a1e (46 code bytes)
# span:         0x004659f0-0x00465a20 (code 46, tables 0, padding 2)
# sha256:       51adf0f40df297c8b48f96c8ce7720c476ced9bcf71093f602160b7142ab5ad6
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4659f0_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m4659f0_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x463ffe(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00463ffe, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m4659f0_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00463ffe, .text + (0x00463ffe - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004659f0 - 0x401000
.globl FUN_004659f0
FUN_004659f0:
    # block 0x004659f0: entry, 10 instruction(s), calls FUN_00463ffe, ends with je to 0x00465a15 (forward)
    push ebp                                     # 004659f0
    {load} mov ebp, esp                          # 004659f1
    push ecx                                     # 004659f3
    mov dword ptr [ebp - local_4], ecx           # 004659f4
    mov ecx, dword ptr [ebp - local_4]           # 004659f7
    call FUN_00463ffe                            # 004659fa
    mov eax, dword ptr [ebp + arg_8]             # 004659ff
    and eax, 0x1                                 # 00465a02
    test eax, eax                                # 00465a05
    je.d8 L_00465a15                             # 00465a07
    # block 0x00465a09: entered by fall-through of je at 0x00465a07, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00465a15
    mov ecx, dword ptr [ebp - local_4]           # 00465a09
    push ecx                                     # 00465a0c
    call FUN_0051dc6c                            # 00465a0d
    add esp, 0x4                                 # 00465a12
L_00465a15:
    # block 0x00465a15: entered by je at 0x00465a07, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 00465a15
    {load} mov esp, ebp                          # 00465a18
    pop ebp                                      # 00465a1a
    ret 0x4                                      # 00465a1b

# --- data items (not part of the function) -------------------------
.org 0x00465a1e - 0x401000
PAD_00465a1e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

