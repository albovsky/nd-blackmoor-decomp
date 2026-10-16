# FUN_004b371c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b371c
# extent:       0x004b371c-0x004b372c (16 code bytes)
# span:         0x004b371c-0x004b372c (code 16, tables 0, padding 0)
# sha256:       b478cef8b432d0627c3232d8382fcc30a5be7d760766d3723476b1c15b6efba6
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b371c
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

.org 0x004b371c - 0x401000
.globl FUN_004b371c
FUN_004b371c:
    # block 0x004b371c: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004b371c
    {load} mov ebp, esp                          # 004b371d
    push ecx                                     # 004b371f
    mov dword ptr [ebp - local_4], ecx           # 004b3720
    mov eax, 0x52dff0                            # 004b3723
    {load} mov esp, ebp                          # 004b3728
    pop ebp                                      # 004b372a
    ret                                          # 004b372b

