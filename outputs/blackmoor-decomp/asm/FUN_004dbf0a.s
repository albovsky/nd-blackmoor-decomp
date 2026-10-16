# FUN_004dbf0a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004dbf0a
# extent:       0x004dbf0a-0x004dbf1a (16 code bytes)
# span:         0x004dbf0a-0x004dbf1a (code 16, tables 0, padding 0)
# sha256:       281df9bcdff514e39c4a0e65158af7b1770e0bb1af967c5517470566373ed947
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004dbf0a
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

.org 0x004dbf0a - 0x401000
.globl FUN_004dbf0a
FUN_004dbf0a:
    # block 0x004dbf0a: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004dbf0a
    {load} mov ebp, esp                          # 004dbf0b
    push ecx                                     # 004dbf0d
    mov dword ptr [ebp - local_4], ecx           # 004dbf0e
    mov eax, 0x52e460                            # 004dbf11
    {load} mov esp, ebp                          # 004dbf16
    pop ebp                                      # 004dbf18
    ret                                          # 004dbf19

