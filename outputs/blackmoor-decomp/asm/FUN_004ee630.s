# FUN_004ee630
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ee630
# extent:       0x004ee630-0x004ee644 (20 code bytes)
# span:         0x004ee630-0x004ee644 (code 20, tables 0, padding 0)
# sha256:       a04d5cb06b6b17c27f65cd8b016835b40269afaa4b2cd7caaa379e5f98f61ef0
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ee630
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4ab
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4ab, 0x4ab  # offset +0x4ab

# --- external targets -----------------------------------------------

.org 0x004ee630 - 0x401000
.globl FUN_004ee630
FUN_004ee630:
    # block 0x004ee630: entry, 9 instruction(s), ends with ret
    push ebp                                     # 004ee630
    {load} mov ebp, esp                          # 004ee631
    push ecx                                     # 004ee633
    mov dword ptr [ebp - local_4], ecx           # 004ee634
    mov eax, dword ptr [ebp - local_4]           # 004ee637
    mov eax, dword ptr [eax + field_4ab]         # 004ee63a
    {load} mov esp, ebp                          # 004ee640
    pop ebp                                      # 004ee642
    ret                                          # 004ee643

