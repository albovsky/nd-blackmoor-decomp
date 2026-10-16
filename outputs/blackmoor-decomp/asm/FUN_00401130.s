# FUN_00401130
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00401130
# extent:       0x00401130-0x0040113d (13 code bytes)
# span:         0x00401130-0x00401140 (code 13, tables 0, padding 3)
# sha256:       8a964d1d7ff7ce1a3c60997027339b1b12723566ff413f0bb34cb92f56441d3a
# evidence:     ev_5101d3157a7cceecfaf0c751ae06a21a7013310d21b12b5f59cdca7af1ddb679
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00401130
# arguments:    no [ebp+n] stack argument slot referenced; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
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

.org 0x00401130 - 0x401000
.globl FUN_00401130
FUN_00401130:
    # block 0x00401130: entry, 7 instruction(s), ends with ret 0x4
    push ebp                                     # 00401130
    {load} mov ebp, esp                          # 00401131
    push ecx                                     # 00401133
    mov dword ptr [ebp - local_4], ecx           # 00401134
    {load} mov esp, ebp                          # 00401137
    pop ebp                                      # 00401139
    ret 0x4                                      # 0040113a

# --- data items (not part of the function) -------------------------
.org 0x0040113d - 0x401000
PAD_0040113d:  # 3 byte(s) of int3 padding
    .fill 3, 1, 0xcc

