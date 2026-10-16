# FUN_004e2990
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e2990
# extent:       0x004e2990-0x004e29a6 (22 code bytes)
# span:         0x004e2990-0x004e29a6 (code 22, tables 0, padding 0)
# sha256:       ebfe937ccbbfc20ae8fc6d19bade7381ab0237dc7744bc402ecdd61877cf9ac5
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e2990
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_18
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------

.org 0x004e2990 - 0x401000
.globl FUN_004e2990
FUN_004e2990:
    # block 0x004e2990: entry, 10 instruction(s), ends with ret 0x4
    push ebp                                     # 004e2990
    {load} mov ebp, esp                          # 004e2991
    push ecx                                     # 004e2993
    mov dword ptr [ebp - local_4], ecx           # 004e2994
    mov eax, dword ptr [ebp - local_4]           # 004e2997
    mov ecx, dword ptr [ebp + arg_8]             # 004e299a
    mov dword ptr [eax + field_18], ecx          # 004e299d
    {load} mov esp, ebp                          # 004e29a0
    pop ebp                                      # 004e29a2
    ret 0x4                                      # 004e29a3

