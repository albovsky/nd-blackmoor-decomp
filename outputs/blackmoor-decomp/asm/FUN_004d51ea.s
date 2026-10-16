# FUN_004d51ea
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d51ea
# extent:       0x004d51ea-0x004d51f7 (13 code bytes)
# span:         0x004d51ea-0x004d51f7 (code 13, tables 0, padding 0)
# sha256:       8a964d1d7ff7ce1a3c60997027339b1b12723566ff413f0bb34cb92f56441d3a
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d51ea
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

.org 0x004d51ea - 0x401000
.globl FUN_004d51ea
FUN_004d51ea:
    # block 0x004d51ea: entry, 7 instruction(s), ends with ret 0x4
    push ebp                                     # 004d51ea
    {load} mov ebp, esp                          # 004d51eb
    push ecx                                     # 004d51ed
    mov dword ptr [ebp - local_4], ecx           # 004d51ee
    {load} mov esp, ebp                          # 004d51f1
    pop ebp                                      # 004d51f3
    ret 0x4                                      # 004d51f4

