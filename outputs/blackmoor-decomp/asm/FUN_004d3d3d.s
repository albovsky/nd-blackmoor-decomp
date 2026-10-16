# FUN_004d3d3d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d3d3d
# extent:       0x004d3d3d-0x004d3d48 (11 code bytes)
# span:         0x004d3d3d-0x004d3d48 (code 11, tables 0, padding 0)
# sha256:       012a7b6ce927f083ba98a546e3d3f750b2a1d82f350ca27efbd30a9c3c7718a5
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d3d3d
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004d3d3d - 0x401000
.globl FUN_004d3d3d
FUN_004d3d3d:
    # block 0x004d3d3d: entry, 7 instruction(s), ends with ret
    push ebp                                     # 004d3d3d
    {load} mov ebp, esp                          # 004d3d3e
    push ecx                                     # 004d3d40
    mov dword ptr [ebp - local_4], ecx           # 004d3d41
    {load} mov esp, ebp                          # 004d3d44
    pop ebp                                      # 004d3d46
    ret                                          # 004d3d47

