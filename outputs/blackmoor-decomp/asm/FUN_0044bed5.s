# FUN_0044bed5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044bed5
# extent:       0x0044bed5-0x0044bf14 (63 code bytes)
# span:         0x0044bed5-0x0044bf14 (code 63, tables 0, padding 0)
# sha256:       4237553dafcfe34de897cf119bbcfce44d95a85b976f083a5d51ed7f794deec3
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044bed5
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4; [ecx + n] field_8; [edx + n] field_4, field_8
# callees:      calls FUN_0050df94
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 24 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050df94, .text + (0x0050df94 - 0x401000)

.org 0x0044bed5 - 0x401000
.globl FUN_0044bed5
FUN_0044bed5:
    # block 0x0044bed5: entry, 24 instruction(s), calls FUN_0050df94, ends with ret 0x4
    push ebp                                     # 0044bed5
    {load} mov ebp, esp                          # 0044bed6
    push ecx                                     # 0044bed8
    mov dword ptr [ebp - local_4], ecx           # 0044bed9
    mov eax, dword ptr [ebp + arg_8]             # 0044bedc
    mov ecx, dword ptr [ebp + arg_8]             # 0044bedf
    fld dword ptr [eax]                          # 0044bee2
    fmul dword ptr [ecx]                         # 0044bee4
    mov edx, dword ptr [ebp + arg_8]             # 0044bee6
    mov eax, dword ptr [ebp + arg_8]             # 0044bee9
    fld dword ptr [edx + field_4]                # 0044beec
    fmul dword ptr [eax + field_4]               # 0044beef
    faddp st(1), st                              # 0044bef2
    sub esp, 0x8                                 # 0044bef4
    fstp qword ptr [esp]                         # 0044bef7
    call FUN_0050df94                            # 0044befa
    add esp, 0x8                                 # 0044beff
    mov ecx, dword ptr [ebp + arg_8]             # 0044bf02
    fstp dword ptr [ecx + field_8]               # 0044bf05
    mov edx, dword ptr [ebp + arg_8]             # 0044bf08
    fld dword ptr [edx + field_8]                # 0044bf0b
    {load} mov esp, ebp                          # 0044bf0e
    pop ebp                                      # 0044bf10
    ret 0x4                                      # 0044bf11

