# FUN_004caec0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004caec0
# extent:       0x004caec0-0x004caecb (11 code bytes)
# span:         0x004caec0-0x004caed0 (code 11, tables 0, padding 5)
# sha256:       012a7b6ce927f083ba98a546e3d3f750b2a1d82f350ca27efbd30a9c3c7718a5
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004caec0
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

.org 0x004caec0 - 0x401000
.globl FUN_004caec0
FUN_004caec0:
    # block 0x004caec0: entry, 7 instruction(s), ends with ret
    push ebp                                     # 004caec0
    {load} mov ebp, esp                          # 004caec1
    push ecx                                     # 004caec3
    mov dword ptr [ebp - local_4], ecx           # 004caec4
    {load} mov esp, ebp                          # 004caec7
    pop ebp                                      # 004caec9
    ret                                          # 004caeca

# --- data items (not part of the function) -------------------------
.org 0x004caecb - 0x401000
PAD_004caecb:  # 5 byte(s) of int3 padding
    .fill 5, 1, 0xcc

