# FUN_004ef4df
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ef4df
# extent:       0x004ef4df-0x004ef4f0 (17 code bytes)
# span:         0x004ef4df-0x004ef4f0 (code 17, tables 0, padding 0)
# sha256:       d500a64daa2531474397cfd9958b6e1b88fc9b0b86d04aa2ea4015b50431bc91
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ef4df
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_10
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------

.org 0x004ef4df - 0x401000
.globl FUN_004ef4df
FUN_004ef4df:
    # block 0x004ef4df: entry, 9 instruction(s), ends with ret
    push ebp                                     # 004ef4df
    {load} mov ebp, esp                          # 004ef4e0
    push ecx                                     # 004ef4e2
    mov dword ptr [ebp - local_4], ecx           # 004ef4e3
    mov eax, dword ptr [ebp - local_4]           # 004ef4e6
    mov eax, dword ptr [eax + field_10]          # 004ef4e9
    {load} mov esp, ebp                          # 004ef4ec
    pop ebp                                      # 004ef4ee
    ret                                          # 004ef4ef

