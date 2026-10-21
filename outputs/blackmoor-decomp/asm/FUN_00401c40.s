# FUN_00401c40
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00401c40
# extent:       0x00401c40-0x00401c6e (46 code bytes)
# span:         0x00401c40-0x00401c70 (code 46, tables 0, padding 2)
# sha256:       3b928241bec9fa4c6c39994f3a735d218d99939169a6cfddf003fae99791cf28
# evidence:     ev_455a1567ac014214df64acbf5361dabf30a6cc1d06d560bab71935befaaf0a54
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m401c40_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m401c40_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x4014f5(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004014f5, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m401c40_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004014f5, .text + (0x004014f5 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00401c40 - 0x401000
.globl FUN_00401c40
FUN_00401c40:
    # block 0x00401c40: entry, 10 instruction(s), calls FUN_004014f5, ends with je to 0x00401c65 (forward)
    push ebp                                     # 00401c40
    {load} mov ebp, esp                          # 00401c41
    push ecx                                     # 00401c43
    mov dword ptr [ebp - local_4], ecx           # 00401c44
    mov ecx, dword ptr [ebp - local_4]           # 00401c47
    call FUN_004014f5                            # 00401c4a
    mov eax, dword ptr [ebp + arg_8]             # 00401c4f
    and eax, 0x1                                 # 00401c52
    test eax, eax                                # 00401c55
    je.d8 L_00401c65                             # 00401c57
    # block 0x00401c59: entered by fall-through of je at 0x00401c57, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00401c65
    mov ecx, dword ptr [ebp - local_4]           # 00401c59
    push ecx                                     # 00401c5c
    call FUN_0051dc6c                            # 00401c5d
    add esp, 0x4                                 # 00401c62
L_00401c65:
    # block 0x00401c65: entered by je at 0x00401c57, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 00401c65
    {load} mov esp, ebp                          # 00401c68
    pop ebp                                      # 00401c6a
    ret 0x4                                      # 00401c6b

# --- data items (not part of the function) -------------------------
.org 0x00401c6e - 0x401000
PAD_00401c6e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

