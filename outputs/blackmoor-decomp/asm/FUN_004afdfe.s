# FUN_004afdfe
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004afdfe
# extent:       0x004afdfe-0x004afe09 (11 code bytes)
# span:         0x004afdfe-0x004afe09 (code 11, tables 0, padding 0)
# sha256:       012a7b6ce927f083ba98a546e3d3f750b2a1d82f350ca27efbd30a9c3c7718a5
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004afdfe
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

.org 0x004afdfe - 0x401000
.globl FUN_004afdfe
FUN_004afdfe:
    # block 0x004afdfe: entry, 7 instruction(s), ends with ret
    push ebp                                     # 004afdfe
    {load} mov ebp, esp                          # 004afdff
    push ecx                                     # 004afe01
    mov dword ptr [ebp - local_4], ecx           # 004afe02
    {load} mov esp, ebp                          # 004afe05
    pop ebp                                      # 004afe07
    ret                                          # 004afe08

