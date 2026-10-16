# FUN_004ef4c9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ef4c9
# extent:       0x004ef4c9-0x004ef4df (22 code bytes)
# span:         0x004ef4c9-0x004ef4df (code 22, tables 0, padding 0)
# sha256:       e7c806708bab2ad8df826d25bf5a7db32c74e0439276e644978409f12ada7d4d
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ef4c9
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_10
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------

.org 0x004ef4c9 - 0x401000
.globl FUN_004ef4c9
FUN_004ef4c9:
    # block 0x004ef4c9: entry, 10 instruction(s), ends with ret 0x4
    push ebp                                     # 004ef4c9
    {load} mov ebp, esp                          # 004ef4ca
    push ecx                                     # 004ef4cc
    mov dword ptr [ebp - local_4], ecx           # 004ef4cd
    mov eax, dword ptr [ebp - local_4]           # 004ef4d0
    mov ecx, dword ptr [ebp + arg_8]             # 004ef4d3
    mov dword ptr [eax + field_10], ecx          # 004ef4d6
    {load} mov esp, ebp                          # 004ef4d9
    pop ebp                                      # 004ef4db
    ret 0x4                                      # 004ef4dc

