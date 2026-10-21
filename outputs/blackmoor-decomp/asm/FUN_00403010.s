# FUN_00403010
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00403010
# extent:       0x00403010-0x0040303e (46 code bytes)
# span:         0x00403010-0x00403040 (code 46, tables 0, padding 2)
# sha256:       a15bb4729406196534495dbb1bd48a4fbf19972f3db4e45527ebef41e0ebe914
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m403010_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m403010_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x401c70(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00401c70, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m403010_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00401c70, .text + (0x00401c70 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00403010 - 0x401000
.globl FUN_00403010
FUN_00403010:
    # block 0x00403010: entry, 10 instruction(s), calls FUN_00401c70, ends with je to 0x00403035 (forward)
    push ebp                                     # 00403010
    {load} mov ebp, esp                          # 00403011
    push ecx                                     # 00403013
    mov dword ptr [ebp - local_4], ecx           # 00403014
    mov ecx, dword ptr [ebp - local_4]           # 00403017
    call FUN_00401c70                            # 0040301a
    mov eax, dword ptr [ebp + arg_8]             # 0040301f
    and eax, 0x1                                 # 00403022
    test eax, eax                                # 00403025
    je.d8 L_00403035                             # 00403027
    # block 0x00403029: entered by fall-through of je at 0x00403027, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00403035
    mov ecx, dword ptr [ebp - local_4]           # 00403029
    push ecx                                     # 0040302c
    call FUN_0051dc6c                            # 0040302d
    add esp, 0x4                                 # 00403032
L_00403035:
    # block 0x00403035: entered by je at 0x00403027, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 00403035
    {load} mov esp, ebp                          # 00403038
    pop ebp                                      # 0040303a
    ret 0x4                                      # 0040303b

# --- data items (not part of the function) -------------------------
.org 0x0040303e - 0x401000
PAD_0040303e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

