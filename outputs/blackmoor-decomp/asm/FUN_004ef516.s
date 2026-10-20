# FUN_004ef516
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ef516
# extent:       0x004ef516-0x004ef52a (20 code bytes)
# span:         0x004ef516-0x004ef52a (code 20, tables 0, padding 0)
# sha256:       0ffd8fa56889ccf1c9f1b3a2a3dcd8e4dbd58b03a03fa175d637d4c0563e4454
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ef516
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_162
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_162, 0x162  # offset +0x162

# --- external targets -----------------------------------------------

.org 0x004ef516 - 0x401000
.globl FUN_004ef516
FUN_004ef516:
    # block 0x004ef516: entry, 9 instruction(s), ends with ret
    push ebp                                     # 004ef516
    {load} mov ebp, esp                          # 004ef517
    push ecx                                     # 004ef519
    mov dword ptr [ebp - local_4], ecx           # 004ef51a
    mov eax, dword ptr [ebp - local_4]           # 004ef51d
    mov eax, dword ptr [eax + field_162]         # 004ef520
    {load} mov esp, ebp                          # 004ef526
    pop ebp                                      # 004ef528
    ret                                          # 004ef529

