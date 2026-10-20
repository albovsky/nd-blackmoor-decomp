# FUN_004841cb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004841cb
# extent:       0x004841cb-0x0048421e (83 code bytes)
# span:         0x004841cb-0x0048421e (code 83, tables 0, padding 0)
# sha256:       30748eb7ef793428db6af59428950758a15de637f1dd23b51ed9038744519c57
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         translate
# naming:       native port src/action_family_ea_runtime.c:translate (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-17); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with translate (rect plus view origin). Native: offsets in the object image; host view seam (EA_ERR_HOST on failure, no original path). Oracle aggregate.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_8, field_c; [edx + n] field_4, field_8, field_c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_ea_runtime.c:translate (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 27 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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

.org 0x004841cb - 0x401000
.globl FUN_004841cb
FUN_004841cb:
    # block 0x004841cb: entry, 27 instruction(s), ends with ret 0x8
    push ebp                                     # 004841cb
    {load} mov ebp, esp                          # 004841cc
    push ecx                                     # 004841ce
    mov dword ptr [ebp - local_4], ecx           # 004841cf
    mov eax, dword ptr [ebp + arg_8]             # 004841d2
    mov ecx, dword ptr [eax + field_4]           # 004841d5
    add ecx, dword ptr [0x58318a]                # 004841d8
    mov edx, dword ptr [ebp + arg_c]             # 004841de
    mov dword ptr [edx + field_4], ecx           # 004841e1
    mov eax, dword ptr [ebp + arg_8]             # 004841e4
    mov ecx, dword ptr [eax + field_c]           # 004841e7
    add ecx, dword ptr [0x58318a]                # 004841ea
    mov edx, dword ptr [ebp + arg_c]             # 004841f0
    mov dword ptr [edx + field_c], ecx           # 004841f3
    mov eax, dword ptr [ebp + arg_8]             # 004841f6
    mov ecx, dword ptr [eax]                     # 004841f9
    add ecx, dword ptr [0x583186]                # 004841fb
    mov edx, dword ptr [ebp + arg_c]             # 00484201
    mov dword ptr [edx], ecx                     # 00484204
    mov eax, dword ptr [ebp + arg_8]             # 00484206
    mov ecx, dword ptr [eax + field_8]           # 00484209
    add ecx, dword ptr [0x583186]                # 0048420c
    mov edx, dword ptr [ebp + arg_c]             # 00484212
    mov dword ptr [edx + field_8], ecx           # 00484215
    {load} mov esp, ebp                          # 00484218
    pop ebp                                      # 0048421a
    ret 0x8                                      # 0048421b

