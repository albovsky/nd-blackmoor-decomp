# FUN_00463f00
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00463f00
# extent:       0x00463f00-0x00463f2e (46 code bytes)
# span:         0x00463f00-0x00463f30 (code 46, tables 0, padding 2)
# sha256:       76b66fda8acc7e2119fc20d5ca0d6f26c792418966a1c9f3ec8aff3f8847a3af
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m463f00_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m463f00_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x46180b(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0046180b, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m463f00_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0046180b, .text + (0x0046180b - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00463f00 - 0x401000
.globl FUN_00463f00
FUN_00463f00:
    # block 0x00463f00: entry, 10 instruction(s), calls FUN_0046180b, ends with je to 0x00463f25 (forward)
    push ebp                                     # 00463f00
    {load} mov ebp, esp                          # 00463f01
    push ecx                                     # 00463f03
    mov dword ptr [ebp - local_4], ecx           # 00463f04
    mov ecx, dword ptr [ebp - local_4]           # 00463f07
    call FUN_0046180b                            # 00463f0a
    mov eax, dword ptr [ebp + arg_8]             # 00463f0f
    and eax, 0x1                                 # 00463f12
    test eax, eax                                # 00463f15
    je.d8 L_00463f25                             # 00463f17
    # block 0x00463f19: entered by fall-through of je at 0x00463f17, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00463f25
    mov ecx, dword ptr [ebp - local_4]           # 00463f19
    push ecx                                     # 00463f1c
    call FUN_0051dc6c                            # 00463f1d
    add esp, 0x4                                 # 00463f22
L_00463f25:
    # block 0x00463f25: entered by je at 0x00463f17, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 00463f25
    {load} mov esp, ebp                          # 00463f28
    pop ebp                                      # 00463f2a
    ret 0x4                                      # 00463f2b

# --- data items (not part of the function) -------------------------
.org 0x00463f2e - 0x401000
PAD_00463f2e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

