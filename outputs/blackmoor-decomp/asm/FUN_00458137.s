# FUN_00458137
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00458137
# extent:       0x00458137-0x0045818a (83 code bytes)
# span:         0x00458137-0x0045818a (code 83, tables 0, padding 0)
# sha256:       30748eb7ef793428db6af59428950758a15de637f1dd23b51ed9038744519c57
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m458137_shift_rect
# naming:       native port src/original_methods_fl38c.c:m458137_shift_rect (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Copies rect src to dst: +4 and +0xc plus [0x58318a], +0 and +8 plus [0x583186] (32-bit wrap), ret 8. 27/27 instructions, no jumps.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_8, field_c; [edx + n] field_4, field_8, field_c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl38c.c:m458137_shift_rect (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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

.org 0x00458137 - 0x401000
.globl FUN_00458137
FUN_00458137:
    # block 0x00458137: entry, 27 instruction(s), ends with ret 0x8
    push ebp                                     # 00458137
    {load} mov ebp, esp                          # 00458138
    push ecx                                     # 0045813a
    mov dword ptr [ebp - local_4], ecx           # 0045813b
    mov eax, dword ptr [ebp + arg_8]             # 0045813e
    mov ecx, dword ptr [eax + field_4]           # 00458141
    add ecx, dword ptr [0x58318a]                # 00458144
    mov edx, dword ptr [ebp + arg_c]             # 0045814a
    mov dword ptr [edx + field_4], ecx           # 0045814d
    mov eax, dword ptr [ebp + arg_8]             # 00458150
    mov ecx, dword ptr [eax + field_c]           # 00458153
    add ecx, dword ptr [0x58318a]                # 00458156
    mov edx, dword ptr [ebp + arg_c]             # 0045815c
    mov dword ptr [edx + field_c], ecx           # 0045815f
    mov eax, dword ptr [ebp + arg_8]             # 00458162
    mov ecx, dword ptr [eax]                     # 00458165
    add ecx, dword ptr [0x583186]                # 00458167
    mov edx, dword ptr [ebp + arg_c]             # 0045816d
    mov dword ptr [edx], ecx                     # 00458170
    mov eax, dword ptr [ebp + arg_8]             # 00458172
    mov ecx, dword ptr [eax + field_8]           # 00458175
    add ecx, dword ptr [0x583186]                # 00458178
    mov edx, dword ptr [ebp + arg_c]             # 0045817e
    mov dword ptr [edx + field_8], ecx           # 00458181
    {load} mov esp, ebp                          # 00458184
    pop ebp                                      # 00458186
    ret 0x8                                      # 00458187

