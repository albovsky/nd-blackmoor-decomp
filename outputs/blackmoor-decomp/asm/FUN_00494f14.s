# FUN_00494f14
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00494f14
# extent:       0x00494f14-0x00494f1f (11 code bytes)
# span:         0x00494f14-0x00494f1f (code 11, tables 0, padding 0)
# sha256:       012a7b6ce927f083ba98a546e3d3f750b2a1d82f350ca27efbd30a9c3c7718a5
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00494f14
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

.org 0x00494f14 - 0x401000
.globl FUN_00494f14
FUN_00494f14:
    # block 0x00494f14: entry, 7 instruction(s), ends with ret
    push ebp                                     # 00494f14
    {load} mov ebp, esp                          # 00494f15
    push ecx                                     # 00494f17
    mov dword ptr [ebp - local_4], ecx           # 00494f18
    {load} mov esp, ebp                          # 00494f1b
    pop ebp                                      # 00494f1d
    ret                                          # 00494f1e

