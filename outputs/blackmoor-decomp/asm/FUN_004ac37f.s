# FUN_004ac37f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ac37f
# extent:       0x004ac37f-0x004ac3d2 (83 code bytes)
# span:         0x004ac37f-0x004ac3d2 (code 83, tables 0, padding 0)
# sha256:       30748eb7ef793428db6af59428950758a15de637f1dd23b51ed9038744519c57
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ac37f
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_8, field_c; [edx + n] field_4, field_8, field_c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 27 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x004ac37f - 0x401000
.globl FUN_004ac37f
FUN_004ac37f:
    # block 0x004ac37f: entry, 27 instruction(s), ends with ret 0x8
    push ebp                                     # 004ac37f
    {load} mov ebp, esp                          # 004ac380
    push ecx                                     # 004ac382
    mov dword ptr [ebp - local_4], ecx           # 004ac383
    mov eax, dword ptr [ebp + arg_8]             # 004ac386
    mov ecx, dword ptr [eax + field_4]           # 004ac389
    add ecx, dword ptr [0x58318a]                # 004ac38c
    mov edx, dword ptr [ebp + arg_c]             # 004ac392
    mov dword ptr [edx + field_4], ecx           # 004ac395
    mov eax, dword ptr [ebp + arg_8]             # 004ac398
    mov ecx, dword ptr [eax + field_c]           # 004ac39b
    add ecx, dword ptr [0x58318a]                # 004ac39e
    mov edx, dword ptr [ebp + arg_c]             # 004ac3a4
    mov dword ptr [edx + field_c], ecx           # 004ac3a7
    mov eax, dword ptr [ebp + arg_8]             # 004ac3aa
    mov ecx, dword ptr [eax]                     # 004ac3ad
    add ecx, dword ptr [0x583186]                # 004ac3af
    mov edx, dword ptr [ebp + arg_c]             # 004ac3b5
    mov dword ptr [edx], ecx                     # 004ac3b8
    mov eax, dword ptr [ebp + arg_8]             # 004ac3ba
    mov ecx, dword ptr [eax + field_8]           # 004ac3bd
    add ecx, dword ptr [0x583186]                # 004ac3c0
    mov edx, dword ptr [ebp + arg_c]             # 004ac3c6
    mov dword ptr [edx + field_8], ecx           # 004ac3c9
    {load} mov esp, ebp                          # 004ac3cc
    pop ebp                                      # 004ac3ce
    ret 0x8                                      # 004ac3cf

