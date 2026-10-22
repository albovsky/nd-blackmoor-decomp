# FUN_0044fa8e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044fa8e
# extent:       0x0044fa8e-0x0044fb54 (198 code bytes)
# span:         0x0044fa8e-0x0044fb54 (code 198, tables 0, padding 0)
# sha256:       f589330eafe9a06f13f741bf2b74783b45b253bd9133559dbff1345e2dc50e0d
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44fa8e_lifted
# naming:       native port src/original_methods_fl40.c:m44fa8e_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 4 seeds; oracle 47/47 instructions, 4/4 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_20, field_b4, field_2a0, field_2a4; [ecx + n] field_24, field_2a0, field_4e8; [edx + n] field_1c, field_28, field_178, field_2a0
# callees:      calls FUN_004c2dfb, FUN_0051dc6c, FUN_00454065, KERNEL32.dll!GetTickCount
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m44fa8e_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 47 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_b4, 0xb4  # offset +0xb4
.equ field_178, 0x178  # offset +0x178
.equ field_2a0, 0x2a0  # offset +0x2a0
.equ field_2a4, 0x2a4  # offset +0x2a4
.equ field_4e8, 0x4e8  # offset +0x4e8

# --- external targets -----------------------------------------------
.set FUN_00454065, .text + (0x00454065 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0044fa8e - 0x401000
.globl FUN_0044fa8e
FUN_0044fa8e:
    # block 0x0044fa8e: entry, 7 instruction(s), ends with je to 0x0044fab7 (forward)
    push ebp                                     # 0044fa8e
    {load} mov ebp, esp                          # 0044fa8f
    sub esp, 0x8                                 # 0044fa91
    mov dword ptr [ebp - local_8], ecx           # 0044fa94
    mov eax, dword ptr [ebp - local_8]           # 0044fa97
    cmp dword ptr [eax + field_2a4], 0x0         # 0044fa9a
    je.d8 L_0044fab7                             # 0044faa1
    # block 0x0044faa3: entered by fall-through of je at 0x0044faa1, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x0044fab7
    mov ecx, dword ptr [ebp - local_8]           # 0044faa3
    add ecx, 0x2a4                               # 0044faa6
    push ecx                                     # 0044faac
    mov ecx, 0x5cf659                            # 0044faad
    call FUN_004c2dfb                            # 0044fab2
L_0044fab7:
    # block 0x0044fab7: entered by je at 0x0044faa1, 3 instruction(s), ends with je to 0x0044fadb (forward)
    mov edx, dword ptr [ebp - local_8]           # 0044fab7
    cmp dword ptr [edx + field_2a0], 0x0         # 0044faba
    je.d8 L_0044fadb                             # 0044fac1
    # block 0x0044fac3: entered by fall-through of je at 0x0044fac1, 7 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0044fadb
    mov eax, dword ptr [ebp - local_8]           # 0044fac3
    mov ecx, dword ptr [eax + field_2a0]         # 0044fac6
    mov dword ptr [ebp - local_4], ecx           # 0044facc
    mov edx, dword ptr [ebp - local_4]           # 0044facf
    push edx                                     # 0044fad2
    call FUN_0051dc6c                            # 0044fad3
    add esp, 0x4                                 # 0044fad8
L_0044fadb:
    # block 0x0044fadb: entered by je at 0x0044fac1, 25 instruction(s), calls FUN_00454065, KERNEL32.dll!GetTickCount, ends with ret
    mov ecx, dword ptr [ebp - local_8]           # 0044fadb
    call FUN_00454065                            # 0044fade
    mov eax, dword ptr [ebp - local_8]           # 0044fae3
    mov dword ptr [eax + field_2a4], 0x0         # 0044fae6
    mov ecx, dword ptr [ebp - local_8]           # 0044faf0
    mov dword ptr [ecx + field_2a0], 0x0         # 0044faf3
    mov edx, dword ptr [ebp - local_8]           # 0044fafd
    mov dword ptr [edx + field_1c], 0x0          # 0044fb00
    mov eax, dword ptr [ebp - local_8]           # 0044fb07
    mov dword ptr [eax + field_20], 0x0          # 0044fb0a
    mov ecx, dword ptr [ebp - local_8]           # 0044fb11
    mov dword ptr [ecx + field_24], 0x0          # 0044fb14
    mov edx, dword ptr [ebp - local_8]           # 0044fb1b
    mov dword ptr [edx + field_28], 0x0          # 0044fb1e
    mov eax, dword ptr [ebp - local_8]           # 0044fb25
    mov dword ptr [eax + field_b4], 0x0          # 0044fb28
    call dword ptr [0x52a23c]                    # 0044fb32
    mov ecx, dword ptr [ebp - local_8]           # 0044fb38
    mov dword ptr [ecx + field_4e8], eax         # 0044fb3b
    call dword ptr [0x52a23c]                    # 0044fb41
    mov edx, dword ptr [ebp - local_8]           # 0044fb47
    mov dword ptr [edx + field_178], eax         # 0044fb4a
    {load} mov esp, ebp                          # 0044fb50
    pop ebp                                      # 0044fb52
    ret                                          # 0044fb53

