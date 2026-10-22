# FUN_004ba13d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ba13d
# extent:       0x004ba13d-0x004ba22e (241 code bytes)
# span:         0x004ba13d-0x004ba22e (code 241, tables 0, padding 0)
# sha256:       29c3bc24bcecc6f11a621be88d8521d5a0f32c7e69a1f067a2f01dae09482624
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ba13d_lifted
# naming:       native port src/original_methods_fl41.c:m4ba13d_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 1 seeds; oracle: 48/48 instructions, 0/0 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_38, field_48, field_1fc, field_2cc, field_2ec; [ecx + n] field_3c, field_54, field_1f4, field_2d0, field_2dc, field_2e4, field_2f0; [edx + n] field_40, field_44, field_200, field_2c4, field_2e0, field_2e8
# callees:      calls FUN_004be18b, KERNEL32.dll!GetTickCount
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4ba13d_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 48 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_38, 0x38  # offset +0x38
.equ field_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_44, 0x44  # offset +0x44
.equ field_48, 0x48  # offset +0x48
.equ field_54, 0x54  # offset +0x54
.equ field_1f4, 0x1f4  # offset +0x1f4
.equ field_1fc, 0x1fc  # offset +0x1fc
.equ field_200, 0x200  # offset +0x200
.equ field_2c4, 0x2c4  # offset +0x2c4
.equ field_2cc, 0x2cc  # offset +0x2cc
.equ field_2d0, 0x2d0  # offset +0x2d0
.equ field_2dc, 0x2dc  # offset +0x2dc
.equ field_2e0, 0x2e0  # offset +0x2e0
.equ field_2e4, 0x2e4  # offset +0x2e4
.equ field_2e8, 0x2e8  # offset +0x2e8
.equ field_2ec, 0x2ec  # offset +0x2ec
.equ field_2f0, 0x2f0  # offset +0x2f0

# --- external targets -----------------------------------------------
.set FUN_004be18b, .text + (0x004be18b - 0x401000)

.org 0x004ba13d - 0x401000
.globl FUN_004ba13d
FUN_004ba13d:
    # block 0x004ba13d: entry, 48 instruction(s), calls FUN_004be18b, KERNEL32.dll!GetTickCount, ends with ret
    push ebp                                     # 004ba13d
    {load} mov ebp, esp                          # 004ba13e
    push ecx                                     # 004ba140
    mov dword ptr [ebp - local_4], ecx           # 004ba141
    mov ecx, dword ptr [ebp - local_4]           # 004ba144
    call FUN_004be18b                            # 004ba147
    call dword ptr [0x52a23c]                    # 004ba14c
    mov ecx, dword ptr [ebp - local_4]           # 004ba152
    mov dword ptr [ecx + field_2dc], eax         # 004ba155
    call dword ptr [0x52a23c]                    # 004ba15b
    mov edx, dword ptr [ebp - local_4]           # 004ba161
    mov dword ptr [edx + field_2e0], eax         # 004ba164
    call dword ptr [0x52a23c]                    # 004ba16a
    mov ecx, dword ptr [ebp - local_4]           # 004ba170
    mov dword ptr [ecx + field_2e4], eax         # 004ba173
    mov edx, dword ptr [ebp - local_4]           # 004ba179
    mov dword ptr [edx + field_2e8], 0x0         # 004ba17c
    mov eax, dword ptr [ebp - local_4]           # 004ba186
    mov dword ptr [eax + field_2ec], 0x0         # 004ba189
    mov ecx, dword ptr [ebp - local_4]           # 004ba193
    mov dword ptr [ecx + field_2f0], 0x0         # 004ba196
    mov edx, dword ptr [ebp - local_4]           # 004ba1a0
    mov dword ptr [edx + field_2c4], 0x0         # 004ba1a3
    mov eax, dword ptr [ebp - local_4]           # 004ba1ad
    mov dword ptr [eax + field_2cc], 0x0         # 004ba1b0
    mov ecx, dword ptr [ebp - local_4]           # 004ba1ba
    mov dword ptr [ecx + field_2d0], 0x3         # 004ba1bd
    mov edx, dword ptr [ebp - local_4]           # 004ba1c7
    mov dword ptr [edx + field_44], 0x0          # 004ba1ca
    mov eax, dword ptr [ebp - local_4]           # 004ba1d1
    mov dword ptr [eax + field_38], 0x0          # 004ba1d4
    mov ecx, dword ptr [ebp - local_4]           # 004ba1db
    mov dword ptr [ecx + field_3c], 0x0          # 004ba1de
    mov edx, dword ptr [ebp - local_4]           # 004ba1e5
    mov dword ptr [edx + field_40], 0x0          # 004ba1e8
    mov eax, dword ptr [ebp - local_4]           # 004ba1ef
    mov dword ptr [eax + field_48], 0x0          # 004ba1f2
    mov ecx, dword ptr [ebp - local_4]           # 004ba1f9
    mov dword ptr [ecx + field_54], 0x0          # 004ba1fc
    mov edx, dword ptr [ebp - local_4]           # 004ba203
    mov dword ptr [edx + field_200], 0x3f800000  # 004ba206
    mov eax, dword ptr [ebp - local_4]           # 004ba210
    mov dword ptr [eax + field_1fc], 0x0         # 004ba213
    mov ecx, dword ptr [ebp - local_4]           # 004ba21d
    mov dword ptr [ecx + field_1f4], 0x0         # 004ba220
    {load} mov esp, ebp                          # 004ba22a
    pop ebp                                      # 004ba22c
    ret                                          # 004ba22d

