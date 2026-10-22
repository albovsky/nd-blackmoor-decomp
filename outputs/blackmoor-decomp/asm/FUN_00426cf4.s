# FUN_00426cf4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00426cf4
# extent:       0x00426cf4-0x00426d0f (27 code bytes)
# span:         0x00426cf4-0x00426d0f (code 27, tables 0, padding 0)
# sha256:       caea76ecb744bd4de352a331045de9377f8f2e4da2a6003bce504eda469ed13b
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m426cf4_lifted
# naming:       native port src/original_methods_fl40.c:m426cf4_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py) over the 32-bit address space, 2 seeds; oracle: 12/12 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051f0e2
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m426cf4_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051f0e2, .text + (0x0051f0e2 - 0x401000)

.org 0x00426cf4 - 0x401000
.globl FUN_00426cf4
FUN_00426cf4:
    # block 0x00426cf4: entry, 12 instruction(s), calls FUN_0051f0e2, ends with ret 0x4
    push ebp                                     # 00426cf4
    {load} mov ebp, esp                          # 00426cf5
    push ecx                                     # 00426cf7
    mov dword ptr [ebp - local_4], ecx           # 00426cf8
    mov eax, dword ptr [ebp + arg_8]             # 00426cfb
    push eax                                     # 00426cfe
    mov ecx, dword ptr [ebp - local_4]           # 00426cff
    call FUN_0051f0e2                            # 00426d02
    {load} xor eax, eax                          # 00426d07
    {load} mov esp, ebp                          # 00426d09
    pop ebp                                      # 00426d0b
    ret 0x4                                      # 00426d0c

