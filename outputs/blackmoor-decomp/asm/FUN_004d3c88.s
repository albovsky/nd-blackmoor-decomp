# FUN_004d3c88
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d3c88
# extent:       0x004d3c88-0x004d3c9a (18 code bytes)
# span:         0x004d3c88-0x004d3c9a (code 18, tables 0, padding 0)
# sha256:       06887b8e87c4b8bc0945edcb1b03d56eb4a0a4c08b1b45c80736306c97efc585
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d3c88
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004d3c88 - 0x401000
.globl FUN_004d3c88
FUN_004d3c88:
    # block 0x004d3c88: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004d3c88
    {load} mov ebp, esp                          # 004d3c89
    push ecx                                     # 004d3c8b
    mov dword ptr [ebp - local_4], ecx           # 004d3c8c
    mov byte ptr [0x61c6ad], 0x0                 # 004d3c8f
    {load} mov esp, ebp                          # 004d3c96
    pop ebp                                      # 004d3c98
    ret                                          # 004d3c99

