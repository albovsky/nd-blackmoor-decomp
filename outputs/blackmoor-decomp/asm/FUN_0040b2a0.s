# FUN_0040b2a0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040b2a0
# extent:       0x0040b2a0-0x0040b2ce (46 code bytes)
# span:         0x0040b2a0-0x0040b2d0 (code 46, tables 0, padding 2)
# sha256:       72fb6e97499baba0254c4c13f96c8952f41013ba28e013405196ae67af15b52f
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m40b2a0_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m40b2a0_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x408d49(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00408d49, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m40b2a0_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00408d49, .text + (0x00408d49 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0040b2a0 - 0x401000
.globl FUN_0040b2a0
FUN_0040b2a0:
    # block 0x0040b2a0: entry, 10 instruction(s), calls FUN_00408d49, ends with je to 0x0040b2c5 (forward)
    push ebp                                     # 0040b2a0
    {load} mov ebp, esp                          # 0040b2a1
    push ecx                                     # 0040b2a3
    mov dword ptr [ebp - local_4], ecx           # 0040b2a4
    mov ecx, dword ptr [ebp - local_4]           # 0040b2a7
    call FUN_00408d49                            # 0040b2aa
    mov eax, dword ptr [ebp + arg_8]             # 0040b2af
    and eax, 0x1                                 # 0040b2b2
    test eax, eax                                # 0040b2b5
    je.d8 L_0040b2c5                             # 0040b2b7
    # block 0x0040b2b9: entered by fall-through of je at 0x0040b2b7, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0040b2c5
    mov ecx, dword ptr [ebp - local_4]           # 0040b2b9
    push ecx                                     # 0040b2bc
    call FUN_0051dc6c                            # 0040b2bd
    add esp, 0x4                                 # 0040b2c2
L_0040b2c5:
    # block 0x0040b2c5: entered by je at 0x0040b2b7, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 0040b2c5
    {load} mov esp, ebp                          # 0040b2c8
    pop ebp                                      # 0040b2ca
    ret 0x4                                      # 0040b2cb

# --- data items (not part of the function) -------------------------
.org 0x0040b2ce - 0x401000
PAD_0040b2ce:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

