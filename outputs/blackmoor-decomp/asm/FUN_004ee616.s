# FUN_004ee616
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ee616
# extent:       0x004ee616-0x004ee630 (26 code bytes)
# span:         0x004ee616-0x004ee630 (code 26, tables 0, padding 0)
# sha256:       fe76f120423280b82faea35858d6abe28d22473f8ba58b8a006c1c024bf3cd58
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ee616_set_field_sx
# naming:       native port src/original_methods_fl39e.c:m4ee616_set_field_sx (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores the low word of the stack argument sign-extended (movsx) in dword [self+0x4af]; pops 4 bytes. No jumps; all 10 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [ecx + n] field_4af
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39e.c:m4ee616_set_field_sx (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_4af, 0x4af  # offset +0x4af

# --- external targets -----------------------------------------------

.org 0x004ee616 - 0x401000
.globl FUN_004ee616
FUN_004ee616:
    # block 0x004ee616: entry, 10 instruction(s), ends with ret 0x4
    push ebp                                     # 004ee616
    {load} mov ebp, esp                          # 004ee617
    push ecx                                     # 004ee619
    mov dword ptr [ebp - local_4], ecx           # 004ee61a
    movsx eax, word ptr [ebp + arg_8]            # 004ee61d
    mov ecx, dword ptr [ebp - local_4]           # 004ee621
    mov dword ptr [ecx + field_4af], eax         # 004ee624
    {load} mov esp, ebp                          # 004ee62a
    pop ebp                                      # 004ee62c
    ret 0x4                                      # 004ee62d

