# FUN_004264e8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004264e8
# extent:       0x004264e8-0x00426502 (26 code bytes)
# span:         0x004264e8-0x00426510 (code 26, tables 0, padding 14)
# sha256:       5babfcbd19635b64508aa9d3732562b6db6cf3ea0d726ab826217dffdba5ae1d
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4264e8_lifted
# naming:       native port src/original_methods_fl40.c:m4264e8_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py) over the 32-bit address space, 2 seeds; oracle: 12/12 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0052139c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m4264e8_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004264e8 - 0x401000
.globl FUN_004264e8
FUN_004264e8:
    # block 0x004264e8: entry, 12 instruction(s), calls FUN_0052139c, ends with ret 0x4
    push ebp                                     # 004264e8
    {load} mov ebp, esp                          # 004264e9
    push ecx                                     # 004264eb
    mov dword ptr [ebp - local_4], ecx           # 004264ec
    push 0x0                                     # 004264ef
    push 0x0                                     # 004264f1
    mov eax, dword ptr [ebp + arg_8]             # 004264f3
    push eax                                     # 004264f6
    call FUN_0052139c                            # 004264f7
    {load} mov esp, ebp                          # 004264fc
    pop ebp                                      # 004264fe
    ret 0x4                                      # 004264ff

# --- data items (not part of the function) -------------------------
.org 0x00426502 - 0x401000
PAD_00426502:  # 14 byte(s) of int3 padding
    .fill 14, 1, 0xcc

