# FUN_00407d90
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00407d90
# extent:       0x00407d90-0x00407da0 (16 code bytes)
# span:         0x00407d90-0x00407da0 (code 16, tables 0, padding 0)
# sha256:       c3fbe9accd2b9f616dfe2fe663b56c1ffdea50f8b10ffe1ff1250b30021154e2
# evidence:     ev_f077da93048f8988a96399f357fa9b0d462c71f5ee4ac3437f49adc8ae869a09
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00407d90
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

.org 0x00407d90 - 0x401000
.globl FUN_00407d90
FUN_00407d90:
    # block 0x00407d90: entry, 8 instruction(s), ends with ret
    push ebp                                     # 00407d90
    {load} mov ebp, esp                          # 00407d91
    push ecx                                     # 00407d93
    mov dword ptr [ebp - local_4], ecx           # 00407d94
    mov eax, 0x1                                 # 00407d97
    {load} mov esp, ebp                          # 00407d9c
    pop ebp                                      # 00407d9e
    ret                                          # 00407d9f

