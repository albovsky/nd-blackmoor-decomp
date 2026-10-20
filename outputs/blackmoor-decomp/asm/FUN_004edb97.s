# FUN_004edb97
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004edb97
# extent:       0x004edb97-0x004edcb1 (282 code bytes)
# span:         0x004edb97-0x004edcb1 (code 282, tables 0, padding 0)
# sha256:       0f9dd052b1bed5f56fff0501bbd7af2165f92d1d845367b6e593144eedfb542a
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004edb97
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_15f, field_675, field_679, field_67d, field_681; [ecx + n] field_252, field_675, field_679, field_67d, field_681; [edx + n] field_4ab
# callees:      calls FUN_004e1d34, FUN_004eead0, FUN_004c2dfb, FUN_004fba69, FUN_004edae5
# track-n:      outputs/blackmoor-decomp/src/caption_lifecycle.c:popup_init (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 69 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_15f, 0x15f  # offset +0x15f
.equ field_252, 0x252  # offset +0x252
.equ field_4ab, 0x4ab  # offset +0x4ab
.equ field_675, 0x675  # offset +0x675
.equ field_679, 0x679  # offset +0x679
.equ field_67d, 0x67d  # offset +0x67d
.equ field_681, 0x681  # offset +0x681

# --- external targets -----------------------------------------------
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004e1d34, .text + (0x004e1d34 - 0x401000)
.set FUN_004edae5, .text + (0x004edae5 - 0x401000)
.set FUN_004eead0, .text + (0x004eead0 - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)

.org 0x004edb97 - 0x401000
.globl FUN_004edb97
FUN_004edb97:
    # block 0x004edb97: entry, 7 instruction(s), ends with je to 0x004edbb8 (forward)
    push ebp                                     # 004edb97
    {load} mov ebp, esp                          # 004edb98
    push ecx                                     # 004edb9a
    mov dword ptr [ebp - local_4], ecx           # 004edb9b
    mov eax, dword ptr [ebp - local_4]           # 004edb9e
    cmp dword ptr [eax + field_15f], 0x0         # 004edba1
    je.d8 L_004edbb8                             # 004edba8
    # block 0x004edbaa: entered by fall-through of je at 0x004edba8, 3 instruction(s), calls FUN_004e1d34, falls into the block at 0x004edbb8
    mov ecx, dword ptr [ebp - local_4]           # 004edbaa
    add ecx, 0x31c                               # 004edbad
    call FUN_004e1d34                            # 004edbb3
L_004edbb8:
    # block 0x004edbb8: entered by je at 0x004edba8, 3 instruction(s), ends with je to 0x004edbd2 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004edbb8
    cmp dword ptr [ecx + field_252], 0x0         # 004edbbb
    je.d8 L_004edbd2                             # 004edbc2
    # block 0x004edbc4: entered by fall-through of je at 0x004edbc2, 3 instruction(s), calls FUN_004eead0, falls into the block at 0x004edbd2
    mov ecx, dword ptr [ebp - local_4]           # 004edbc4
    add ecx, 0x4b7                               # 004edbc7
    call FUN_004eead0                            # 004edbcd
L_004edbd2:
    # block 0x004edbd2: entered by je at 0x004edbc2, 3 instruction(s), ends with je to 0x004edbf1 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004edbd2
    cmp dword ptr [edx + field_4ab], 0x0         # 004edbd5
    je.d8 L_004edbf1                             # 004edbdc
    # block 0x004edbde: entered by fall-through of je at 0x004edbdc, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004edbf1
    mov eax, dword ptr [ebp - local_4]           # 004edbde
    add eax, 0x4ab                               # 004edbe1
    push eax                                     # 004edbe6
    mov ecx, 0x5cf659                            # 004edbe7
    call FUN_004c2dfb                            # 004edbec
L_004edbf1:
    # block 0x004edbf1: entered by je at 0x004edbdc, 3 instruction(s), ends with je to 0x004edc1e (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004edbf1
    cmp dword ptr [ecx + field_675], 0x0         # 004edbf4
    je.d8 L_004edc1e                             # 004edbfb
    # block 0x004edbfd: entered by fall-through of je at 0x004edbfb, 7 instruction(s), calls FUN_004fba69, falls into the block at 0x004edc1e
    mov edx, dword ptr [ebp - local_4]           # 004edbfd
    add edx, 0x9b                                # 004edc00
    push edx                                     # 004edc06
    mov ecx, 0x5c3a67                            # 004edc07
    call FUN_004fba69                            # 004edc0c
    mov eax, dword ptr [ebp - local_4]           # 004edc11
    mov dword ptr [eax + field_675], 0x0         # 004edc14
L_004edc1e:
    # block 0x004edc1e: entered by je at 0x004edbfb, 3 instruction(s), ends with je to 0x004edc4b (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004edc1e
    cmp dword ptr [ecx + field_679], 0x0         # 004edc21
    je.d8 L_004edc4b                             # 004edc28
    # block 0x004edc2a: entered by fall-through of je at 0x004edc28, 7 instruction(s), calls FUN_004fba69, falls into the block at 0x004edc4b
    mov edx, dword ptr [ebp - local_4]           # 004edc2a
    add edx, 0xcc                                # 004edc2d
    push edx                                     # 004edc33
    mov ecx, 0x5c3a67                            # 004edc34
    call FUN_004fba69                            # 004edc39
    mov eax, dword ptr [ebp - local_4]           # 004edc3e
    mov dword ptr [eax + field_679], 0x0         # 004edc41
L_004edc4b:
    # block 0x004edc4b: entered by je at 0x004edc28, 3 instruction(s), ends with je to 0x004edc78 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004edc4b
    cmp dword ptr [ecx + field_67d], 0x0         # 004edc4e
    je.d8 L_004edc78                             # 004edc55
    # block 0x004edc57: entered by fall-through of je at 0x004edc55, 7 instruction(s), calls FUN_004fba69, falls into the block at 0x004edc78
    mov edx, dword ptr [ebp - local_4]           # 004edc57
    add edx, 0xfd                                # 004edc5a
    push edx                                     # 004edc60
    mov ecx, 0x5c3a67                            # 004edc61
    call FUN_004fba69                            # 004edc66
    mov eax, dword ptr [ebp - local_4]           # 004edc6b
    mov dword ptr [eax + field_67d], 0x0         # 004edc6e
L_004edc78:
    # block 0x004edc78: entered by je at 0x004edc55, 3 instruction(s), ends with je to 0x004edca5 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004edc78
    cmp dword ptr [ecx + field_681], 0x0         # 004edc7b
    je.d8 L_004edca5                             # 004edc82
    # block 0x004edc84: entered by fall-through of je at 0x004edc82, 7 instruction(s), calls FUN_004fba69, falls into the block at 0x004edca5
    mov edx, dword ptr [ebp - local_4]           # 004edc84
    add edx, 0x12e                               # 004edc87
    push edx                                     # 004edc8d
    mov ecx, 0x5c3a67                            # 004edc8e
    call FUN_004fba69                            # 004edc93
    mov eax, dword ptr [ebp - local_4]           # 004edc98
    mov dword ptr [eax + field_681], 0x0         # 004edc9b
L_004edca5:
    # block 0x004edca5: entered by je at 0x004edc82, 5 instruction(s), calls FUN_004edae5, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004edca5
    call FUN_004edae5                            # 004edca8
    {load} mov esp, ebp                          # 004edcad
    pop ebp                                      # 004edcaf
    ret                                          # 004edcb0

