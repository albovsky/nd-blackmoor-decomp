# FUN_00487a00
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00487a00
# extent:       0x00487a00-0x00487a2e (46 code bytes)
# span:         0x00487a00-0x00487a30 (code 46, tables 0, padding 2)
# sha256:       127fc5de74ba923ad33ba6be3c8f48d869774f5bf5e0f14c52264d1283349f65
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m487a00_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m487a00_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x483f4e(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00483f4e, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m487a00_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00483f4e, .text + (0x00483f4e - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00487a00 - 0x401000
.globl FUN_00487a00
FUN_00487a00:
    # block 0x00487a00: entry, 10 instruction(s), calls FUN_00483f4e, ends with je to 0x00487a25 (forward)
    push ebp                                     # 00487a00
    {load} mov ebp, esp                          # 00487a01
    push ecx                                     # 00487a03
    mov dword ptr [ebp - local_4], ecx           # 00487a04
    mov ecx, dword ptr [ebp - local_4]           # 00487a07
    call FUN_00483f4e                            # 00487a0a
    mov eax, dword ptr [ebp + arg_8]             # 00487a0f
    and eax, 0x1                                 # 00487a12
    test eax, eax                                # 00487a15
    je.d8 L_00487a25                             # 00487a17
    # block 0x00487a19: entered by fall-through of je at 0x00487a17, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00487a25
    mov ecx, dword ptr [ebp - local_4]           # 00487a19
    push ecx                                     # 00487a1c
    call FUN_0051dc6c                            # 00487a1d
    add esp, 0x4                                 # 00487a22
L_00487a25:
    # block 0x00487a25: entered by je at 0x00487a17, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 00487a25
    {load} mov esp, ebp                          # 00487a28
    pop ebp                                      # 00487a2a
    ret 0x4                                      # 00487a2b

# --- data items (not part of the function) -------------------------
.org 0x00487a2e - 0x401000
PAD_00487a2e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

