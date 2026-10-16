# FUN_0044bfb2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044bfb2
# extent:       0x0044bfb2-0x0044bfe5 (51 code bytes)
# span:         0x0044bfb2-0x0044bfe5 (code 51, tables 0, padding 0)
# sha256:       9a02e285edb153404529781afc076a620304580cbf7d18c0b7dd64364a75ba95
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044bfb2
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4; [ecx + n] field_8; [edx + n] field_4, field_8
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 21 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x0044bfb2 - 0x401000
.globl FUN_0044bfb2
FUN_0044bfb2:
    # block 0x0044bfb2: entry, 21 instruction(s), ends with ret 0x8
    push ebp                                     # 0044bfb2
    {load} mov ebp, esp                          # 0044bfb3
    push ecx                                     # 0044bfb5
    mov dword ptr [ebp - local_4], ecx           # 0044bfb6
    mov eax, dword ptr [ebp + arg_8]             # 0044bfb9
    fld dword ptr [eax]                          # 0044bfbc
    fchs                                         # 0044bfbe
    mov ecx, dword ptr [ebp + arg_c]             # 0044bfc0
    fstp dword ptr [ecx]                         # 0044bfc3
    mov edx, dword ptr [ebp + arg_8]             # 0044bfc5
    fld dword ptr [edx + field_4]                # 0044bfc8
    fchs                                         # 0044bfcb
    mov eax, dword ptr [ebp + arg_c]             # 0044bfcd
    fstp dword ptr [eax + field_4]               # 0044bfd0
    mov ecx, dword ptr [ebp + arg_c]             # 0044bfd3
    mov edx, dword ptr [ebp + arg_8]             # 0044bfd6
    mov eax, dword ptr [edx + field_8]           # 0044bfd9
    mov dword ptr [ecx + field_8], eax           # 0044bfdc
    {load} mov esp, ebp                          # 0044bfdf
    pop ebp                                      # 0044bfe1
    ret 0x8                                      # 0044bfe2

