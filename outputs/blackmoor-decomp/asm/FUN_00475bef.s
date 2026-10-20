# FUN_00475bef
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00475bef
# extent:       0x00475bef-0x00475cc4 (213 code bytes)
# span:         0x00475bef-0x00475cc4 (code 213, tables 0, padding 0)
# sha256:       52b3336e8b997c72978f5022c5c7b764723c79224d5d69e61ad80a51cf5a1223
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         cell_rect
# naming:       native port src/action_family_e4_runtime.c:cell_rect (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-17); the note is the acceptance note, a statement about the native port
# name-note:    cell_rect matches: w/h from body rect words (+0x58/+0x60, +0x5c/+0x64), x/y = index*size + view + offset + gap*index with 0x660/0x666 and 0x662/0x664, stores order left, right, top, bottom;
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_4, field_22, field_60, field_64, field_660, field_662, field_664, field_666; [ecx + n] field_4, field_58, field_5c; [edx + n] field_8, field_c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_e4_runtime.c:cell_rect (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 64 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_22, 0x22  # offset +0x22
.equ field_58, 0x58  # offset +0x58
.equ field_5c, 0x5c  # offset +0x5c
.equ field_60, 0x60  # offset +0x60
.equ field_64, 0x64  # offset +0x64
.equ field_660, 0x660  # offset +0x660
.equ field_662, 0x662  # offset +0x662
.equ field_664, 0x664  # offset +0x664
.equ field_666, 0x666  # offset +0x666

# --- external targets -----------------------------------------------

.org 0x00475bef - 0x401000
.globl FUN_00475bef
FUN_00475bef:
    # block 0x00475bef: entry, 64 instruction(s), ends with ret 0xc
    push ebp                                     # 00475bef
    {load} mov ebp, esp                          # 00475bf0
    sub esp, 0x10                                # 00475bf2
    push esi                                     # 00475bf5
    mov dword ptr [ebp - local_10], ecx          # 00475bf6
    mov eax, dword ptr [ebp - local_10]          # 00475bf9
    movsx ecx, word ptr [eax + field_22]         # 00475bfc
    imul ecx, ecx, 0x8d                          # 00475c00
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00475c06
    mov dword ptr [ebp - local_4], edx           # 00475c0c
    mov eax, dword ptr [ebp - local_4]           # 00475c0f
    mov ecx, dword ptr [ebp - local_4]           # 00475c12
    mov edx, dword ptr [eax + field_60]          # 00475c15
    sub edx, dword ptr [ecx + field_58]          # 00475c18
    mov word ptr [ebp - local_c], dx             # 00475c1b
    mov eax, dword ptr [ebp - local_4]           # 00475c1f
    mov ecx, dword ptr [ebp - local_4]           # 00475c22
    mov edx, dword ptr [eax + field_64]          # 00475c25
    sub edx, dword ptr [ecx + field_5c]          # 00475c28
    mov word ptr [ebp - local_8], dx             # 00475c2b
    mov eax, dword ptr [ebp - local_4]           # 00475c2f
    movsx ecx, word ptr [eax + field_660]        # 00475c32
    movsx edx, word ptr [ebp + arg_c]            # 00475c39
    movsx eax, word ptr [ebp - local_c]          # 00475c3d
    imul edx, eax                                # 00475c41
    add edx, dword ptr [0x583186]                # 00475c44
    mov eax, dword ptr [ebp - local_4]           # 00475c4a
    movsx eax, word ptr [eax + field_666]        # 00475c4d
    movsx esi, word ptr [ebp + arg_c]            # 00475c54
    imul eax, esi                                # 00475c58
    {load} add edx, ecx                          # 00475c5b
    {load} add eax, edx                          # 00475c5d
    mov ecx, dword ptr [ebp + arg_10]            # 00475c5f
    mov dword ptr [ecx], eax                     # 00475c62
    movsx edx, word ptr [ebp - local_c]          # 00475c64
    mov eax, dword ptr [ebp + arg_10]            # 00475c68
    mov ecx, dword ptr [eax]                     # 00475c6b
    {load} add ecx, edx                          # 00475c6d
    mov edx, dword ptr [ebp + arg_10]            # 00475c6f
    mov dword ptr [edx + field_8], ecx           # 00475c72
    mov eax, dword ptr [ebp - local_4]           # 00475c75
    movsx ecx, word ptr [eax + field_662]        # 00475c78
    movsx edx, word ptr [ebp + arg_8]            # 00475c7f
    movsx eax, word ptr [ebp - local_8]          # 00475c83
    imul edx, eax                                # 00475c87
    add edx, dword ptr [0x58318a]                # 00475c8a
    mov eax, dword ptr [ebp - local_4]           # 00475c90
    movsx eax, word ptr [eax + field_664]        # 00475c93
    movsx esi, word ptr [ebp + arg_8]            # 00475c9a
    imul eax, esi                                # 00475c9e
    {load} add edx, ecx                          # 00475ca1
    {load} add eax, edx                          # 00475ca3
    mov ecx, dword ptr [ebp + arg_10]            # 00475ca5
    mov dword ptr [ecx + field_4], eax           # 00475ca8
    movsx edx, word ptr [ebp - local_8]          # 00475cab
    mov eax, dword ptr [ebp + arg_10]            # 00475caf
    mov ecx, dword ptr [eax + field_4]           # 00475cb2
    {load} add ecx, edx                          # 00475cb5
    mov edx, dword ptr [ebp + arg_10]            # 00475cb7
    mov dword ptr [edx + field_c], ecx           # 00475cba
    pop esi                                      # 00475cbd
    {load} mov esp, ebp                          # 00475cbe
    pop ebp                                      # 00475cc0
    ret 0xc                                      # 00475cc1

