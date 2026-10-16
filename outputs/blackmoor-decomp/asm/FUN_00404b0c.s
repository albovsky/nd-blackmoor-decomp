# FUN_00404b0c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00404b0c
# extent:       0x00404b0c-0x00404b19 (13 code bytes)
# span:         0x00404b0c-0x00404b19 (code 13, tables 0, padding 0)
# sha256:       8a964d1d7ff7ce1a3c60997027339b1b12723566ff413f0bb34cb92f56441d3a
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00404b0c
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

.org 0x00404b0c - 0x401000
.globl FUN_00404b0c
FUN_00404b0c:
    # block 0x00404b0c: entry, 7 instruction(s), ends with ret 0x4
    push ebp                                     # 00404b0c
    {load} mov ebp, esp                          # 00404b0d
    push ecx                                     # 00404b0f
    mov dword ptr [ebp - local_4], ecx           # 00404b10
    {load} mov esp, ebp                          # 00404b13
    pop ebp                                      # 00404b15
    ret 0x4                                      # 00404b16

