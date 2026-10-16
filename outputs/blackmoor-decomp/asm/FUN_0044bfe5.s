# FUN_0044bfe5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044bfe5
# extent:       0x0044bfe5-0x0044c00a (37 code bytes)
# span:         0x0044bfe5-0x0044c00a (code 37, tables 0, padding 0)
# sha256:       18c1959ced508162dd17e1a97cb430d5aa8b9afcd276641e1a4e37f59ce7b99b
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044bfe5
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4; [edx + n] field_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 16 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x0044bfe5 - 0x401000
.globl FUN_0044bfe5
FUN_0044bfe5:
    # block 0x0044bfe5: entry, 16 instruction(s), ends with ret 0x8
    push ebp                                     # 0044bfe5
    {load} mov ebp, esp                          # 0044bfe6
    push ecx                                     # 0044bfe8
    mov dword ptr [ebp - local_4], ecx           # 0044bfe9
    mov eax, dword ptr [ebp + arg_8]             # 0044bfec
    mov ecx, dword ptr [ebp + arg_c]             # 0044bfef
    fld dword ptr [eax]                          # 0044bff2
    fmul dword ptr [ecx]                         # 0044bff4
    mov edx, dword ptr [ebp + arg_8]             # 0044bff6
    mov eax, dword ptr [ebp + arg_c]             # 0044bff9
    fld dword ptr [edx + field_4]                # 0044bffc
    fmul dword ptr [eax + field_4]               # 0044bfff
    faddp st(1), st                              # 0044c002
    {load} mov esp, ebp                          # 0044c004
    pop ebp                                      # 0044c006
    ret 0x8                                      # 0044c007

