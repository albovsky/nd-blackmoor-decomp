# FUN_0044e95b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044e95b
# extent:       0x0044e95b-0x0044e9ae (83 code bytes)
# span:         0x0044e95b-0x0044e9ae (code 83, tables 0, padding 0)
# sha256:       30748eb7ef793428db6af59428950758a15de637f1dd23b51ed9038744519c57
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44e95b_offset_rect
# naming:       native port src/original_methods_fl32c.c:m44e95b_offset_rect (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Adds the origin dwords 0x583186 (x) and 0x58318a (y) to a source rectangle into a destination in the original store order; overlap orders compared; 27/27 executed.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_8, field_c; [edx + n] field_4, field_8, field_c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl32c.c:m44e95b_offset_rect (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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

.org 0x0044e95b - 0x401000
.globl FUN_0044e95b
FUN_0044e95b:
    # block 0x0044e95b: entry, 27 instruction(s), ends with ret 0x8
    push ebp                                     # 0044e95b
    {load} mov ebp, esp                          # 0044e95c
    push ecx                                     # 0044e95e
    mov dword ptr [ebp - local_4], ecx           # 0044e95f
    mov eax, dword ptr [ebp + arg_8]             # 0044e962
    mov ecx, dword ptr [eax + field_4]           # 0044e965
    add ecx, dword ptr [0x58318a]                # 0044e968
    mov edx, dword ptr [ebp + arg_c]             # 0044e96e
    mov dword ptr [edx + field_4], ecx           # 0044e971
    mov eax, dword ptr [ebp + arg_8]             # 0044e974
    mov ecx, dword ptr [eax + field_c]           # 0044e977
    add ecx, dword ptr [0x58318a]                # 0044e97a
    mov edx, dword ptr [ebp + arg_c]             # 0044e980
    mov dword ptr [edx + field_c], ecx           # 0044e983
    mov eax, dword ptr [ebp + arg_8]             # 0044e986
    mov ecx, dword ptr [eax]                     # 0044e989
    add ecx, dword ptr [0x583186]                # 0044e98b
    mov edx, dword ptr [ebp + arg_c]             # 0044e991
    mov dword ptr [edx], ecx                     # 0044e994
    mov eax, dword ptr [ebp + arg_8]             # 0044e996
    mov ecx, dword ptr [eax + field_8]           # 0044e999
    add ecx, dword ptr [0x583186]                # 0044e99c
    mov edx, dword ptr [ebp + arg_c]             # 0044e9a2
    mov dword ptr [edx + field_8], ecx           # 0044e9a5
    {load} mov esp, ebp                          # 0044e9a8
    pop ebp                                      # 0044e9aa
    ret 0x8                                      # 0044e9ab

