# FUN_0044bebb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044bebb
# extent:       0x0044bebb-0x0044bed5 (26 code bytes)
# span:         0x0044bebb-0x0044bed5 (code 26, tables 0, padding 0)
# sha256:       3097139b3195e4d23f47428acc69e97f5d1f11a5842783922c4327a167b7c801
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044bebb
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [ecx + n] field_4, field_8
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x0044bebb - 0x401000
.globl FUN_0044bebb
FUN_0044bebb:
    # block 0x0044bebb: entry, 12 instruction(s), ends with ret 0x4
    push ebp                                     # 0044bebb
    {load} mov ebp, esp                          # 0044bebc
    push ecx                                     # 0044bebe
    mov dword ptr [ebp - local_4], ecx           # 0044bebf
    {load} xor eax, eax                          # 0044bec2
    mov ecx, dword ptr [ebp + arg_8]             # 0044bec4
    mov dword ptr [ecx], eax                     # 0044bec7
    mov dword ptr [ecx + field_4], eax           # 0044bec9
    mov dword ptr [ecx + field_8], eax           # 0044becc
    {load} mov esp, ebp                          # 0044becf
    pop ebp                                      # 0044bed1
    ret 0x4                                      # 0044bed2

