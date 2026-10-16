# FUN_00416e60
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00416e60
# extent:       0x00416e60-0x00416e8e (46 code bytes)
# span:         0x00416e60-0x00416e90 (code 46, tables 0, padding 2)
# sha256:       41909e9ec567815faf789d3c8dc5c2fba2b8a19ed3d74a37007ab14fde1f1a4d
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00416e60
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00414ccf, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00414ccf, .text + (0x00414ccf - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00416e60 - 0x401000
.globl FUN_00416e60
FUN_00416e60:
    # block 0x00416e60: entry, 10 instruction(s), calls FUN_00414ccf, ends with je to 0x00416e85 (forward)
    push ebp                                     # 00416e60
    {load} mov ebp, esp                          # 00416e61
    push ecx                                     # 00416e63
    mov dword ptr [ebp - local_4], ecx           # 00416e64
    mov ecx, dword ptr [ebp - local_4]           # 00416e67
    call FUN_00414ccf                            # 00416e6a
    mov eax, dword ptr [ebp + arg_8]             # 00416e6f
    and eax, 0x1                                 # 00416e72
    test eax, eax                                # 00416e75
    je.d8 L_00416e85                             # 00416e77
    # block 0x00416e79: entered by fall-through of je at 0x00416e77, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00416e85
    mov ecx, dword ptr [ebp - local_4]           # 00416e79
    push ecx                                     # 00416e7c
    call FUN_0051dc6c                            # 00416e7d
    add esp, 0x4                                 # 00416e82
L_00416e85:
    # block 0x00416e85: entered by je at 0x00416e77, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 00416e85
    {load} mov esp, ebp                          # 00416e88
    pop ebp                                      # 00416e8a
    ret 0x4                                      # 00416e8b

# --- data items (not part of the function) -------------------------
.org 0x00416e8e - 0x401000
PAD_00416e8e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

