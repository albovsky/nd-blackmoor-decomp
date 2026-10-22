# FUN_00401511
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00401511
# extent:       0x00401511-0x00401526 (21 code bytes)
# span:         0x00401511-0x00401526 (code 21, tables 0, padding 0)
# sha256:       e95c1ad8551a781d5a19d91b40bf79122db093527a5bca034d83b0b63d493825
# evidence:     ev_5101d3157a7cceecfaf0c751ae06a21a7013310d21b12b5f59cdca7af1ddb679
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m401511_lifted
# naming:       native port src/original_methods_fl40.c:m401511_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 1 seeds; oracle: 8/8 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m401511_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x00401511 - 0x401000
.globl FUN_00401511
FUN_00401511:
    # block 0x00401511: entry, 8 instruction(s), ends with ret
    push ebp                                     # 00401511
    {load} mov ebp, esp                          # 00401512
    push ecx                                     # 00401514
    mov dword ptr [ebp - local_4], ecx           # 00401515
    mov dword ptr [0x569138], 0xffffffff         # 00401518
    {load} mov esp, ebp                          # 00401522
    pop ebp                                      # 00401524
    ret                                          # 00401525

