# FUN_004dc043
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004dc043
# extent:       0x004dc043-0x004dc13f (252 code bytes)
# span:         0x004dc043-0x004dc13f (code 252, tables 0, padding 0)
# sha256:       8c3628c9cd770abdc55a89aa8711344e7d2c0ffafb03a5b8070880d54b2d1686
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004dc043
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_ee, field_fa
# callees:      calls FUN_0044c479, FUN_00449a94, FUN_0044c4ab, FUN_00415011, FUN_004c2dfb, FUN_0041632b, FUN_004bedfa, FUN_004dbfbf; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 64 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_ee, 0xee  # offset +0xee
.equ field_fa, 0xfa  # offset +0xfa

# --- external targets -----------------------------------------------
.set FUN_00415011, .text + (0x00415011 - 0x401000)
.set FUN_0041632b, .text + (0x0041632b - 0x401000)
.set FUN_00449a94, .text + (0x00449a94 - 0x401000)
.set FUN_0044c479, .text + (0x0044c479 - 0x401000)
.set FUN_0044c4ab, .text + (0x0044c4ab - 0x401000)
.set FUN_004bedfa, .text + (0x004bedfa - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004dbfbf, .text + (0x004dbfbf - 0x401000)

.org 0x004dc043 - 0x401000
.globl FUN_004dc043
FUN_004dc043:
    # block 0x004dc043: entry, 7 instruction(s), ends with je to 0x004dc122 (forward)
    push ebp                                     # 004dc043
    {load} mov ebp, esp                          # 004dc044
    sub esp, 0x10                                # 004dc046
    mov dword ptr [ebp - local_c], ecx           # 004dc049
    mov eax, dword ptr [ebp - local_c]           # 004dc04c
    cmp dword ptr [eax + field_fa], 0x0          # 004dc04f
    je.d32 L_004dc122                            # 004dc056
    # block 0x004dc05c: entered by fall-through of je at 0x004dc056, 2 instruction(s), ends with je to 0x004dc0d5 (forward)
    cmp dword ptr [0x6381a5], 0x0                # 004dc05c
    je.d8 L_004dc0d5                             # 004dc063
    # block 0x004dc065: entered by fall-through of je at 0x004dc063, 12 instruction(s), calls FUN_0044c479, FUN_00449a94, ends with je to 0x004dc0ad (forward)
    push 0x637fd3                                # 004dc065
    call FUN_0044c479                            # 004dc06a
    add esp, 0x4                                 # 004dc06f
    mov dword ptr [0x637fd3], 0x2                # 004dc072
    mov ecx, dword ptr [0x6381a5]                # 004dc07c
    call FUN_00449a94                            # 004dc082
    mov ecx, dword ptr [0x6381a5]                # 004dc087
    mov dword ptr [ebp - local_8], ecx           # 004dc08d
    mov edx, dword ptr [ebp - local_8]           # 004dc090
    mov dword ptr [ebp - local_4], edx           # 004dc093
    cmp dword ptr [ebp - local_4], 0x0           # 004dc096
    je.d8 L_004dc0ad                             # 004dc09a
    # block 0x004dc09c: entered by fall-through of je at 0x004dc09a, 7 instruction(s), calls indirect dword ptr [edx], ends with forward jump to 0x004dc0b4
    push 0x1                                     # 004dc09c
    mov eax, dword ptr [ebp - local_4]           # 004dc09e
    mov edx, dword ptr [eax]                     # 004dc0a1
    mov ecx, dword ptr [ebp - local_4]           # 004dc0a3
    call dword ptr [edx]                         # 004dc0a6
    mov dword ptr [ebp - local_10], eax          # 004dc0a8
    jmp.d8 L_004dc0b4                            # 004dc0ab
L_004dc0ad:
    # block 0x004dc0ad: entered by je at 0x004dc09a, 1 instruction(s), falls into the block at 0x004dc0b4
    mov dword ptr [ebp - local_10], 0x0          # 004dc0ad
L_004dc0b4:
    # block 0x004dc0b4: entered by jmp at 0x004dc0ab, 5 instruction(s), calls FUN_0044c4ab, falls into the block at 0x004dc0d5
    mov dword ptr [0x6381a5], 0x0                # 004dc0b4
    push 0x637fd3                                # 004dc0be
    call FUN_0044c4ab                            # 004dc0c3
    add esp, 0x4                                 # 004dc0c8
    mov dword ptr [0x637fd3], 0x0                # 004dc0cb
L_004dc0d5:
    # block 0x004dc0d5: entered by je at 0x004dc063, 20 instruction(s), calls FUN_00415011, FUN_004c2dfb, FUN_0041632b, FUN_004bedfa, falls into the block at 0x004dc122
    mov eax, dword ptr [ebp - local_c]           # 004dc0d5
    mov ecx, dword ptr [eax + field_ee]          # 004dc0d8
    push ecx                                     # 004dc0de
    mov ecx, 0x5e2dbe                            # 004dc0df
    call FUN_00415011                            # 004dc0e4
    mov edx, dword ptr [ebp - local_c]           # 004dc0e9
    add edx, 0x4a                                # 004dc0ec
    push edx                                     # 004dc0ef
    mov ecx, 0x5cf659                            # 004dc0f0
    call FUN_004c2dfb                            # 004dc0f5
    mov eax, dword ptr [ebp - local_c]           # 004dc0fa
    mov ecx, dword ptr [eax + field_ee]          # 004dc0fd
    push ecx                                     # 004dc103
    mov ecx, 0x5e2dbe                            # 004dc104
    call FUN_0041632b                            # 004dc109
    mov edx, dword ptr [ebp - local_c]           # 004dc10e
    add edx, 0x106                               # 004dc111
    push edx                                     # 004dc117
    mov ecx, 0x6201f9                            # 004dc118
    call FUN_004bedfa                            # 004dc11d
L_004dc122:
    # block 0x004dc122: entered by je at 0x004dc056, 10 instruction(s), calls FUN_004c2dfb, FUN_004dbfbf, ends with ret
    mov eax, dword ptr [ebp - local_c]           # 004dc122
    add eax, 0x46                                # 004dc125
    push eax                                     # 004dc128
    mov ecx, 0x5cf659                            # 004dc129
    call FUN_004c2dfb                            # 004dc12e
    mov ecx, dword ptr [ebp - local_c]           # 004dc133
    call FUN_004dbfbf                            # 004dc136
    {load} mov esp, ebp                          # 004dc13b
    pop ebp                                      # 004dc13d
    ret                                          # 004dc13e

