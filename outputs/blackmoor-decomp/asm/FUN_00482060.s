# FUN_00482060
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00482060
# extent:       0x00482060-0x0048208e (46 code bytes)
# span:         0x00482060-0x00482090 (code 46, tables 0, padding 2)
# sha256:       27c7912ba9fae7aa777fb21a1ab8c8690eff4a2372eda801148c8404115ee5fd
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m482060_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m482060_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x47e23e(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0047e23e, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m482060_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0047e23e, .text + (0x0047e23e - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00482060 - 0x401000
.globl FUN_00482060
FUN_00482060:
    # block 0x00482060: entry, 10 instruction(s), calls FUN_0047e23e, ends with je to 0x00482085 (forward)
    push ebp                                     # 00482060
    {load} mov ebp, esp                          # 00482061
    push ecx                                     # 00482063
    mov dword ptr [ebp - local_4], ecx           # 00482064
    mov ecx, dword ptr [ebp - local_4]           # 00482067
    call FUN_0047e23e                            # 0048206a
    mov eax, dword ptr [ebp + arg_8]             # 0048206f
    and eax, 0x1                                 # 00482072
    test eax, eax                                # 00482075
    je.d8 L_00482085                             # 00482077
    # block 0x00482079: entered by fall-through of je at 0x00482077, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00482085
    mov ecx, dword ptr [ebp - local_4]           # 00482079
    push ecx                                     # 0048207c
    call FUN_0051dc6c                            # 0048207d
    add esp, 0x4                                 # 00482082
L_00482085:
    # block 0x00482085: entered by je at 0x00482077, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 00482085
    {load} mov esp, ebp                          # 00482088
    pop ebp                                      # 0048208a
    ret 0x4                                      # 0048208b

# --- data items (not part of the function) -------------------------
.org 0x0048208e - 0x401000
PAD_0048208e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

