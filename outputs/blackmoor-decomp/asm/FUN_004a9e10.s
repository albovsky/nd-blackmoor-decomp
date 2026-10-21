# FUN_004a9e10
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a9e10
# extent:       0x004a9e10-0x004a9e3e (46 code bytes)
# span:         0x004a9e10-0x004a9e40 (code 46, tables 0, padding 2)
# sha256:       c99aecae02ebf10ab3e98b831694309ad3266bbd99b0586c33f73e7debd8b375
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a9e10_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m4a9e10_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x4a7c5e(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004a7c5e, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m4a9e10_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004a7c5e, .text + (0x004a7c5e - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004a9e10 - 0x401000
.globl FUN_004a9e10
FUN_004a9e10:
    # block 0x004a9e10: entry, 10 instruction(s), calls FUN_004a7c5e, ends with je to 0x004a9e35 (forward)
    push ebp                                     # 004a9e10
    {load} mov ebp, esp                          # 004a9e11
    push ecx                                     # 004a9e13
    mov dword ptr [ebp - local_4], ecx           # 004a9e14
    mov ecx, dword ptr [ebp - local_4]           # 004a9e17
    call FUN_004a7c5e                            # 004a9e1a
    mov eax, dword ptr [ebp + arg_8]             # 004a9e1f
    and eax, 0x1                                 # 004a9e22
    test eax, eax                                # 004a9e25
    je.d8 L_004a9e35                             # 004a9e27
    # block 0x004a9e29: entered by fall-through of je at 0x004a9e27, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004a9e35
    mov ecx, dword ptr [ebp - local_4]           # 004a9e29
    push ecx                                     # 004a9e2c
    call FUN_0051dc6c                            # 004a9e2d
    add esp, 0x4                                 # 004a9e32
L_004a9e35:
    # block 0x004a9e35: entered by je at 0x004a9e27, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004a9e35
    {load} mov esp, ebp                          # 004a9e38
    pop ebp                                      # 004a9e3a
    ret 0x4                                      # 004a9e3b

# --- data items (not part of the function) -------------------------
.org 0x004a9e3e - 0x401000
PAD_004a9e3e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

