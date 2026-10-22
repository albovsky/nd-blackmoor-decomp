# FUN_0041a4b0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041a4b0
# extent:       0x0041a4b0-0x0041a4be (14 code bytes)
# span:         0x0041a4b0-0x0041a4be (code 14, tables 0, padding 0)
# sha256:       befca35709395b425403c72a706d2f3c715162ad22664d93df30e0255a4d4e8c
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m41a4b0_lifted
# naming:       native port src/original_methods_fl40.c:m41a4b0_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py) over the 32-bit address space, 1 seeds; oracle: 8/8 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m41a4b0_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0041a4b0 - 0x401000
.globl FUN_0041a4b0
FUN_0041a4b0:
    # block 0x0041a4b0: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0041a4b0
    {load} mov ebp, esp                          # 0041a4b1
    push ecx                                     # 0041a4b3
    mov dword ptr [ebp - local_4], ecx           # 0041a4b4
    mov eax, dword ptr [ebp - local_4]           # 0041a4b7
    {load} mov esp, ebp                          # 0041a4ba
    pop ebp                                      # 0041a4bc
    ret                                          # 0041a4bd

