# FUN_004afcba
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004afcba
# extent:       0x004afcba-0x004afcca (16 code bytes)
# span:         0x004afcba-0x004afcca (code 16, tables 0, padding 0)
# sha256:       7758a81df130adceecc6471235562a067138da176f19dba35f438bb20fce272d
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004afcba
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004afcba - 0x401000
.globl FUN_004afcba
FUN_004afcba:
    # block 0x004afcba: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004afcba
    {load} mov ebp, esp                          # 004afcbb
    push ecx                                     # 004afcbd
    mov dword ptr [ebp - local_4], ecx           # 004afcbe
    mov eax, 0x52dfd8                            # 004afcc1
    {load} mov esp, ebp                          # 004afcc6
    pop ebp                                      # 004afcc8
    ret                                          # 004afcc9

