# FUN_004ef4f0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ef4f0
# extent:       0x004ef4f0-0x004ef516 (38 code bytes)
# span:         0x004ef4f0-0x004ef516 (code 38, tables 0, padding 0)
# sha256:       1d49188da76d621e5b15ae37ec850c00d5890c42287e0b50767544228232acb7
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ef4f0
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_162; [edx + n] field_19e
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_162, 0x162  # offset +0x162
.equ field_19e, 0x19e  # offset +0x19e

# --- external targets -----------------------------------------------

.org 0x004ef4f0 - 0x401000
.globl FUN_004ef4f0
FUN_004ef4f0:
    # block 0x004ef4f0: entry, 12 instruction(s), ends with ret 0x4
    push ebp                                     # 004ef4f0
    {load} mov ebp, esp                          # 004ef4f1
    push ecx                                     # 004ef4f3
    mov dword ptr [ebp - local_4], ecx           # 004ef4f4
    mov eax, dword ptr [ebp - local_4]           # 004ef4f7
    mov ecx, dword ptr [ebp + arg_8]             # 004ef4fa
    mov dword ptr [eax + field_162], ecx         # 004ef4fd
    mov edx, dword ptr [ebp - local_4]           # 004ef503
    mov dword ptr [edx + field_19e], 0x1         # 004ef506
    {load} mov esp, ebp                          # 004ef510
    pop ebp                                      # 004ef512
    ret 0x4                                      # 004ef513

