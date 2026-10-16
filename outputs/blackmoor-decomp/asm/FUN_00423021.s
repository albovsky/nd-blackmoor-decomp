# FUN_00423021
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00423021
# extent:       0x00423021-0x00423097 (118 code bytes)
# span:         0x00423021-0x00423097 (code 118, tables 0, padding 0)
# sha256:       f9ef55eef4c25e085421e4ee49ae09bcbdfc27acc5f8bdf026b049a7228d2e59
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00423021
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [ecx + n] field_25; [edx + n] field_25
# callees:      calls FUN_0051dc6c, FUN_00423021
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 41 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_25, 0x25  # offset +0x25

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00423021 - 0x401000
.globl FUN_00423021
FUN_00423021:
L_00423021:
    # block 0x00423021: entry, 7 instruction(s), ends with je to 0x00423046 (forward)
    push ebp                                     # 00423021
    {load} mov ebp, esp                          # 00423022
    sub esp, 0x14                                # 00423024
    mov dword ptr [ebp - local_10], ecx          # 00423027
    mov eax, dword ptr [ebp - local_10]          # 0042302a
    cmp dword ptr [eax], 0x0                     # 0042302d
    je.d8 L_00423046                             # 00423030
    # block 0x00423032: entered by fall-through of je at 0x00423030, 7 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00423046
    mov ecx, dword ptr [ebp - local_10]          # 00423032
    mov edx, dword ptr [ecx]                     # 00423035
    mov dword ptr [ebp - local_4], edx           # 00423037
    mov eax, dword ptr [ebp - local_4]           # 0042303a
    push eax                                     # 0042303d
    call FUN_0051dc6c                            # 0042303e
    add esp, 0x4                                 # 00423043
L_00423046:
    # block 0x00423046: entered by je at 0x00423030, 3 instruction(s), ends with je to 0x00423093 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 00423046
    cmp dword ptr [ecx + field_25], 0x0          # 00423049
    je.d8 L_00423093                             # 0042304d
    # block 0x0042304f: entered by fall-through of je at 0x0042304d, 7 instruction(s), ends with je to 0x0042308c (forward)
    mov edx, dword ptr [ebp - local_10]          # 0042304f
    mov eax, dword ptr [edx + field_25]          # 00423052
    mov dword ptr [ebp - local_c], eax           # 00423055
    mov ecx, dword ptr [ebp - local_c]           # 00423058
    mov dword ptr [ebp - local_8], ecx           # 0042305b
    cmp dword ptr [ebp - local_8], 0x0           # 0042305e
    je.d8 L_0042308c                             # 00423062
    # block 0x00423064: entered by fall-through of je at 0x00423062, 6 instruction(s), calls FUN_00423021, ends with je to 0x00423084 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00423064
    call L_00423021                              # 00423067
    mov edx, 0x1                                 # 0042306c
    and edx, 0x1                                 # 00423071
    test edx, edx                                # 00423074
    je.d8 L_00423084                             # 00423076
    # block 0x00423078: entered by fall-through of je at 0x00423076, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00423084
    mov eax, dword ptr [ebp - local_8]           # 00423078
    push eax                                     # 0042307b
    call FUN_0051dc6c                            # 0042307c
    add esp, 0x4                                 # 00423081
L_00423084:
    # block 0x00423084: entered by je at 0x00423076, 3 instruction(s), ends with forward jump to 0x00423093
    mov ecx, dword ptr [ebp - local_8]           # 00423084
    mov dword ptr [ebp - local_14], ecx          # 00423087
    jmp.d8 L_00423093                            # 0042308a
L_0042308c:
    # block 0x0042308c: entered by je at 0x00423062, 1 instruction(s), falls into the block at 0x00423093
    mov dword ptr [ebp - local_14], 0x0          # 0042308c
L_00423093:
    # block 0x00423093: entered by je at 0x0042304d; jmp at 0x0042308a, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00423093
    pop ebp                                      # 00423095
    ret                                          # 00423096

