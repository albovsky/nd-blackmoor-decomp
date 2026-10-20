# FUN_004fca60
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fca60
# extent:       0x004fca60-0x004fcb5c (252 code bytes)
# span:         0x004fca60-0x004fcb5c (code 252, tables 0, padding 0)
# sha256:       372547ba566f69952091001f1df3930506bf6bfd712b16180a16e8b6f6f67255
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4fca60_set_channel_scalars
# naming:       native port src/original_methods_fl19b.c:m4fca60_set_channel_scalars (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m4fca60_set_channel_scalars. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 252 bytes.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [ecx + n] field_138, field_13c; [edx + n] field_10c, field_138, field_13c, field_140, field_144; [esi + n] field_b764
# callees:      calls FUN_0050ce04, FUN_004f684a
# track-n:      outputs/blackmoor-decomp/src/blackmoor_app.mm:native_a95_set_channel_scalars (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 57 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_10c, 0x10c  # offset +0x10c
.equ field_138, 0x138  # offset +0x138
.equ field_13c, 0x13c  # offset +0x13c
.equ field_140, 0x140  # offset +0x140
.equ field_144, 0x144  # offset +0x144
.equ field_b764, 0xb764  # offset +0xb764

# --- external targets -----------------------------------------------
.set FUN_004f684a, .text + (0x004f684a - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x004fca60 - 0x401000
.globl FUN_004fca60
FUN_004fca60:
    # block 0x004fca60: entry, 57 instruction(s), calls FUN_0050ce04, FUN_004f684a, ends with ret 0xc
    push ebp                                     # 004fca60
    {load} mov ebp, esp                          # 004fca61
    push ecx                                     # 004fca63
    push esi                                     # 004fca64
    mov dword ptr [ebp - local_4], ecx           # 004fca65
    movsx eax, word ptr [ebp + arg_8]            # 004fca68
    imul eax, eax, 0x5bb                         # 004fca6c
    mov ecx, dword ptr [ebp - local_4]           # 004fca72
    mov edx, dword ptr [ebp + arg_c]             # 004fca75
    mov dword ptr [ecx + eax + field_138], edx   # 004fca78
    movsx eax, word ptr [ebp + arg_8]            # 004fca7f
    imul eax, eax, 0x5bb                         # 004fca83
    mov ecx, dword ptr [ebp - local_4]           # 004fca89
    mov edx, dword ptr [ebp + arg_10]            # 004fca8c
    mov dword ptr [ecx + eax + field_13c], edx   # 004fca8f
    movsx eax, word ptr [ebp + arg_8]            # 004fca96
    imul eax, eax, 0x5bb                         # 004fca9a
    movsx ecx, word ptr [ebp + arg_8]            # 004fcaa0
    imul ecx, ecx, 0x5bb                         # 004fcaa4
    mov edx, dword ptr [ebp - local_4]           # 004fcaaa
    movsx ecx, word ptr [edx + ecx + field_10c]  # 004fcaad
    mov edx, dword ptr [ebp - local_4]           # 004fcab5
    mov esi, dword ptr [ebp - local_4]           # 004fcab8
    fld dword ptr [edx + eax + field_138]        # 004fcabb
    fmul dword ptr [esi + 4*ecx + field_b764]    # 004fcac2
    fmul dword ptr [0x52e4e0]                    # 004fcac9
    fadd qword ptr [0x52e4d8]                    # 004fcacf
    call FUN_0050ce04                            # 004fcad5
    movsx ecx, word ptr [ebp + arg_8]            # 004fcada
    imul ecx, ecx, 0x5bb                         # 004fcade
    mov edx, dword ptr [ebp - local_4]           # 004fcae4
    mov dword ptr [edx + ecx + field_140], eax   # 004fcae7
    movsx eax, word ptr [ebp + arg_8]            # 004fcaee
    imul eax, eax, 0x5bb                         # 004fcaf2
    movsx ecx, word ptr [ebp + arg_8]            # 004fcaf8
    imul ecx, ecx, 0x5bb                         # 004fcafc
    mov edx, dword ptr [ebp - local_4]           # 004fcb02
    movsx ecx, word ptr [edx + ecx + field_10c]  # 004fcb05
    mov edx, dword ptr [ebp - local_4]           # 004fcb0d
    mov esi, dword ptr [ebp - local_4]           # 004fcb10
    fld dword ptr [edx + eax + field_13c]        # 004fcb13
    fmul dword ptr [esi + 4*ecx + field_b764]    # 004fcb1a
    fmul dword ptr [0x52e4e0]                    # 004fcb21
    fadd qword ptr [0x52e4d8]                    # 004fcb27
    call FUN_0050ce04                            # 004fcb2d
    movsx ecx, word ptr [ebp + arg_8]            # 004fcb32
    imul ecx, ecx, 0x5bb                         # 004fcb36
    mov edx, dword ptr [ebp - local_4]           # 004fcb3c
    mov dword ptr [edx + ecx + field_144], eax   # 004fcb3f
    movsx eax, word ptr [ebp + arg_8]            # 004fcb46
    push eax                                     # 004fcb4a
    mov ecx, 0x5cf1eb                            # 004fcb4b
    call FUN_004f684a                            # 004fcb50
    pop esi                                      # 004fcb55
    {load} mov esp, ebp                          # 004fcb56
    pop ebp                                      # 004fcb58
    ret 0xc                                      # 004fcb59

