# FUN_004afa0e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004afa0e
# extent:       0x004afa0e-0x004afa1e (16 code bytes)
# span:         0x004afa0e-0x004afa1e (code 16, tables 0, padding 0)
# sha256:       18b29bf28675a2cf0c21d14dad751abf06d391922bbff3773b4f01bd63c25ed7
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004afa0e
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

.org 0x004afa0e - 0x401000
.globl FUN_004afa0e
FUN_004afa0e:
    # block 0x004afa0e: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004afa0e
    {load} mov ebp, esp                          # 004afa0f
    push ecx                                     # 004afa11
    mov dword ptr [ebp - local_4], ecx           # 004afa12
    mov eax, 0x52df68                            # 004afa15
    {load} mov esp, ebp                          # 004afa1a
    pop ebp                                      # 004afa1c
    ret                                          # 004afa1d

