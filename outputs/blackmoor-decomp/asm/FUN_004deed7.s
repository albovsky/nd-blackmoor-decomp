# FUN_004deed7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004deed7
# extent:       0x004deed7-0x004dfdc9 (3826 code bytes)
# span:         0x004deed7-0x004dfdc9 (code 3826, tables 0, padding 0)
# sha256:       8b6fc4c34f370e9b6f6bf6c5603f61a095c13ea950cfb4575b03243ddc35bb96
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004deed7
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       46 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 34 more
# fields:       [eax + n] field_4, field_49, field_51, field_14c, field_391, field_395, field_399, field_39d, field_3a1, field_3a9, field_3df, field_3e3 and 8 more; [ecx + n] field_f1, field_f5, field_38d, field_395, field_399, field_39d, field_3a1, field_3a3, field_3df, field_3e3, field_3e7, field_3eb and 4 more; [edx + n] field_e9, field_ed, field_14c, field_38d, field_391, field_399, field_39d, field_3a1, field_3a3, field_3a5, field_3a9, field_3df and 8 more; [esi + n] field_4d, field_55, field_3af, field_3b3, field_3b7, field_3bb
# callees:      calls FUN_004dfff3, FUN_004dadff, FUN_004daeb5, FUN_004dae88, FUN_0050ce04, FUN_004e22fd, FUN_004ef2d1, FUN_004dad60, FUN_004daef1, KERNEL32.dll!GetTickCount, FUN_004fb2e3, FUN_004f684a, FUN_004e29ec, FUN_004ef89b, FUN_004ef516, FUN_004c98b5 and 5 more
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 825 instruction(s), 72 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ local_4c, 0x4c  # offset -0x4c
.equ local_50, 0x50  # offset -0x50
.equ local_54, 0x54  # offset -0x54
.equ local_58, 0x58  # offset -0x58
.equ local_5c, 0x5c  # offset -0x5c
.equ local_60, 0x60  # offset -0x60
.equ local_64, 0x64  # offset -0x64
.equ local_68, 0x68  # offset -0x68
.equ local_6c, 0x6c  # offset -0x6c
.equ local_70, 0x70  # offset -0x70
.equ local_74, 0x74  # offset -0x74
.equ local_78, 0x78  # offset -0x78
.equ local_7c, 0x7c  # offset -0x7c
.equ local_80, 0x80  # offset -0x80
.equ local_84, 0x84  # offset -0x84
.equ local_88, 0x88  # offset -0x88
.equ local_8c, 0x8c  # offset -0x8c
.equ local_90, 0x90  # offset -0x90
.equ local_94, 0x94  # offset -0x94
.equ local_98, 0x98  # offset -0x98
.equ local_9c, 0x9c  # offset -0x9c
.equ local_a0, 0xa0  # offset -0xa0
.equ local_a4, 0xa4  # offset -0xa4
.equ local_a8, 0xa8  # offset -0xa8
.equ local_ac, 0xac  # offset -0xac
.equ local_b0, 0xb0  # offset -0xb0
.equ local_b4, 0xb4  # offset -0xb4
.equ local_b8, 0xb8  # offset -0xb8
.equ local_bc, 0xbc  # offset -0xbc
.equ field_4, 0x4  # offset +0x4
.equ field_49, 0x49  # offset +0x49
.equ field_4d, 0x4d  # offset +0x4d
.equ field_51, 0x51  # offset +0x51
.equ field_55, 0x55  # offset +0x55
.equ field_e9, 0xe9  # offset +0xe9
.equ field_ed, 0xed  # offset +0xed
.equ field_f1, 0xf1  # offset +0xf1
.equ field_f5, 0xf5  # offset +0xf5
.equ field_14c, 0x14c  # offset +0x14c
.equ field_38d, 0x38d  # offset +0x38d
.equ field_391, 0x391  # offset +0x391
.equ field_395, 0x395  # offset +0x395
.equ field_399, 0x399  # offset +0x399
.equ field_39d, 0x39d  # offset +0x39d
.equ field_3a1, 0x3a1  # offset +0x3a1
.equ field_3a3, 0x3a3  # offset +0x3a3
.equ field_3a5, 0x3a5  # offset +0x3a5
.equ field_3a9, 0x3a9  # offset +0x3a9
.equ field_3af, 0x3af  # offset +0x3af
.equ field_3b3, 0x3b3  # offset +0x3b3
.equ field_3b7, 0x3b7  # offset +0x3b7
.equ field_3bb, 0x3bb  # offset +0x3bb
.equ field_3df, 0x3df  # offset +0x3df
.equ field_3e3, 0x3e3  # offset +0x3e3
.equ field_3e7, 0x3e7  # offset +0x3e7
.equ field_3eb, 0x3eb  # offset +0x3eb
.equ field_72c, 0x72c  # offset +0x72c
.equ field_730, 0x730  # offset +0x730
.equ field_734, 0x734  # offset +0x734
.equ field_738, 0x738  # offset +0x738
.equ field_73c, 0x73c  # offset +0x73c
.equ field_740, 0x740  # offset +0x740

# --- external targets -----------------------------------------------
.set FUN_004c98b5, .text + (0x004c98b5 - 0x401000)
.set FUN_004cf7e0, .text + (0x004cf7e0 - 0x401000)
.set FUN_004dad60, .text + (0x004dad60 - 0x401000)
.set FUN_004dadff, .text + (0x004dadff - 0x401000)
.set FUN_004dae88, .text + (0x004dae88 - 0x401000)
.set FUN_004daeb5, .text + (0x004daeb5 - 0x401000)
.set FUN_004daef1, .text + (0x004daef1 - 0x401000)
.set FUN_004daf3f, .text + (0x004daf3f - 0x401000)
.set FUN_004dfff3, .text + (0x004dfff3 - 0x401000)
.set FUN_004e22fd, .text + (0x004e22fd - 0x401000)
.set FUN_004e26fc, .text + (0x004e26fc - 0x401000)
.set FUN_004e29ec, .text + (0x004e29ec - 0x401000)
.set FUN_004ef2d1, .text + (0x004ef2d1 - 0x401000)
.set FUN_004ef4f0, .text + (0x004ef4f0 - 0x401000)
.set FUN_004ef516, .text + (0x004ef516 - 0x401000)
.set FUN_004ef89b, .text + (0x004ef89b - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004f684a, .text + (0x004f684a - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x004deed7 - 0x401000
.globl FUN_004deed7
FUN_004deed7:
    # block 0x004deed7: entry, 14 instruction(s), calls FUN_004dfff3, FUN_004dadff, ends with je to 0x004def21 (forward)
    push ebp                                     # 004deed7
    {load} mov ebp, esp                          # 004deed8
    sub esp, 0xbc                                # 004deeda
    push esi                                     # 004deee0
    mov dword ptr [ebp - local_4c], ecx          # 004deee1
    mov ecx, dword ptr [ebp - local_4c]          # 004deee4
    call FUN_004dfff3                            # 004deee7
    mov ecx, 0x5830a6                            # 004deeec
    call FUN_004dadff                            # 004deef1
    mov eax, dword ptr [ebp - local_4c]          # 004deef6
    mov ecx, dword ptr [eax + field_391]         # 004deef9
    mov dword ptr [ebp - local_50], ecx          # 004deeff
    cmp dword ptr [ebp - local_50], 0x0          # 004def02
    je.d8 L_004def21                             # 004def06
    # block 0x004def08: entered by fall-through of je at 0x004def06, 2 instruction(s), ends with je to 0x004dfcf7 (forward)
    cmp dword ptr [ebp - local_50], 0x1          # 004def08
    je.d32 L_004dfcf7                            # 004def0c
    # block 0x004def12: entered by fall-through of je at 0x004def0c, 2 instruction(s), ends with je to 0x004dfd2a (forward)
    cmp dword ptr [ebp - local_50], 0x2          # 004def12
    je.d32 L_004dfd2a                            # 004def16
    # block 0x004def1c: entered by fall-through of je at 0x004def16, 1 instruction(s), ends with forward jump to 0x004dfdb7
    jmp.d32 L_004dfdb7                           # 004def1c
L_004def21:
    # block 0x004def21: entered by je at 0x004def06, 15 instruction(s), calls FUN_004daeb5, ends with jne to 0x004def6f (forward)
    lea edx, [ebp - local_40]                    # 004def21
    push edx                                     # 004def24
    mov ecx, 0x5830a6                            # 004def25
    call FUN_004daeb5                            # 004def2a
    mov ecx, dword ptr [eax]                     # 004def2f
    mov edx, dword ptr [eax + field_4]           # 004def31
    mov dword ptr [0x5830e2], ecx                # 004def34
    mov dword ptr [0x5830e6], edx                # 004def3a
    mov eax, dword ptr [0x5830ea]                # 004def40
    mov dword ptr [ebp - local_48], eax          # 004def45
    mov ecx, dword ptr [0x5830ee]                # 004def48
    mov dword ptr [ebp - local_44], ecx          # 004def4e
    mov edx, dword ptr [0x5830e2]                # 004def51
    cmp edx, dword ptr [ebp - local_48]          # 004def57
    jne.d8 L_004def6f                            # 004def5a
    # block 0x004def5c: entered by fall-through of jne at 0x004def5a, 3 instruction(s), ends with jne to 0x004def6f (forward)
    mov eax, dword ptr [0x5830e6]                # 004def5c
    cmp eax, dword ptr [ebp - local_44]          # 004def61
    jne.d8 L_004def6f                            # 004def64
    # block 0x004def66: entered by fall-through of jne at 0x004def64, 2 instruction(s), ends with forward jump to 0x004def76
    mov dword ptr [ebp - local_54], 0x0          # 004def66
    jmp.d8 L_004def76                            # 004def6d
L_004def6f:
    # block 0x004def6f: entered by jne at 0x004def5a; jne at 0x004def64, 1 instruction(s), falls into the block at 0x004def76
    mov dword ptr [ebp - local_54], 0x1          # 004def6f
L_004def76:
    # block 0x004def76: entered by jmp at 0x004def6d, 2 instruction(s), ends with je to 0x004df104 (forward)
    cmp dword ptr [ebp - local_54], 0x0          # 004def76
    je.d32 L_004df104                            # 004def7a
    # block 0x004def80: entered by fall-through of je at 0x004def7a, 2 instruction(s), ends with jne to 0x004df104 (forward)
    cmp dword ptr [0x5830de], 0x0                # 004def80
    jne.d32 L_004df104                           # 004def87
    # block 0x004def8d: entered by fall-through of jne at 0x004def87, 16 instruction(s), ends with jle to 0x004df007 (forward)
    mov ecx, dword ptr [0x583106]                # 004def8d
    mov dword ptr [0x5830f6], ecx                # 004def93
    mov edx, dword ptr [0x58310e]                # 004def99
    mov dword ptr [0x5830fe], edx                # 004def9f
    mov eax, dword ptr [0x583102]                # 004defa5
    mov dword ptr [0x5830f2], eax                # 004defaa
    mov ecx, dword ptr [0x58310a]                # 004defaf
    mov dword ptr [0x5830fa], ecx                # 004defb5
    movsx edx, word ptr [0x63988b]               # 004defbb
    mov eax, dword ptr [0x5b44f4]                # 004defc2
    shl eax, 0x2                                 # 004defc7
    mov ecx, dword ptr [0x5b44f0]                # 004defca
    movsx eax, word ptr [eax + 8*ecx + 0x5b3790] # 004defd0
    {load} sub edx, eax                          # 004defd8
    cmp dword ptr [0x5830e2], edx                # 004defda
    jle.d8 L_004df007                            # 004defe0
    # block 0x004defe2: entered by fall-through of jle at 0x004defe0, 7 instruction(s), falls into the block at 0x004df007
    movsx ecx, word ptr [0x63988b]               # 004defe2
    mov edx, dword ptr [0x5b44f4]                # 004defe9
    shl edx, 0x2                                 # 004defef
    mov eax, dword ptr [0x5b44f0]                # 004deff2
    movsx edx, word ptr [edx + 8*eax + 0x5b3790] # 004deff7
    {load} sub ecx, edx                          # 004defff
    mov dword ptr [0x5830e2], ecx                # 004df001
L_004df007:
    # block 0x004df007: entered by jle at 0x004defe0, 8 instruction(s), ends with jle to 0x004df054 (forward)
    movsx eax, word ptr [0x63988d]               # 004df007
    mov ecx, dword ptr [0x5b44f4]                # 004df00e
    shl ecx, 0x2                                 # 004df014
    mov edx, dword ptr [0x5b44f0]                # 004df017
    movsx ecx, word ptr [ecx + 8*edx + 0x5b3792] # 004df01d
    {load} sub eax, ecx                          # 004df025
    cmp dword ptr [0x5830e6], eax                # 004df027
    jle.d8 L_004df054                            # 004df02d
    # block 0x004df02f: entered by fall-through of jle at 0x004df02d, 7 instruction(s), falls into the block at 0x004df054
    movsx edx, word ptr [0x63988d]               # 004df02f
    mov eax, dword ptr [0x5b44f4]                # 004df036
    shl eax, 0x2                                 # 004df03b
    mov ecx, dword ptr [0x5b44f0]                # 004df03e
    movsx eax, word ptr [eax + 8*ecx + 0x5b3792] # 004df044
    {load} sub edx, eax                          # 004df04c
    mov dword ptr [0x5830e6], edx                # 004df04e
L_004df054:
    # block 0x004df054: entered by jle at 0x004df02d, 32 instruction(s), calls FUN_004dae88, ends with forward jump to 0x004df121
    mov ecx, dword ptr [0x5830e6]                # 004df054
    mov dword ptr [0x583106], ecx                # 004df05a
    mov edx, dword ptr [0x5b44f4]                # 004df060
    shl edx, 0x2                                 # 004df066
    mov eax, dword ptr [0x5b44f0]                # 004df069
    movsx ecx, word ptr [edx + 8*eax + 0x5b3792] # 004df06e
    mov edx, dword ptr [0x583106]                # 004df076
    lea eax, [edx + ecx - field_minus_1]         # 004df07c
    mov dword ptr [0x58310e], eax                # 004df080
    mov ecx, dword ptr [0x5830e2]                # 004df085
    mov dword ptr [0x583102], ecx                # 004df08b
    mov edx, dword ptr [0x5b44f4]                # 004df091
    shl edx, 0x2                                 # 004df097
    mov eax, dword ptr [0x5b44f0]                # 004df09a
    movsx ecx, word ptr [edx + 8*eax + 0x5b3790] # 004df09f
    mov edx, dword ptr [0x583102]                # 004df0a7
    lea eax, [edx + ecx - field_minus_1]         # 004df0ad
    mov dword ptr [0x58310a], eax                # 004df0b1
    mov ecx, dword ptr [0x5830e6]                # 004df0b6
    push ecx                                     # 004df0bc
    mov edx, dword ptr [0x5830e2]                # 004df0bd
    push edx                                     # 004df0c3
    mov ecx, 0x5830a6                            # 004df0c4
    call FUN_004dae88                            # 004df0c9
    mov dword ptr [0x63a9cc], 0x0                # 004df0ce
    mov dword ptr [0x5830de], 0x1                # 004df0d8
    mov dword ptr [0x5d28b9], 0x1                # 004df0e2
    mov eax, dword ptr [0x5830e2]                # 004df0ec
    mov dword ptr [0x5830ea], eax                # 004df0f1
    mov ecx, dword ptr [0x5830e6]                # 004df0f6
    mov dword ptr [0x5830ee], ecx                # 004df0fc
    jmp.d8 L_004df121                            # 004df102
L_004df104:
    # block 0x004df104: entered by je at 0x004def7a; jne at 0x004def87, 2 instruction(s), ends with je to 0x004df121 (forward)
    cmp dword ptr [0x5830de], 0x0                # 004df104
    je.d8 L_004df121                             # 004df10b
    # block 0x004df10d: entered by fall-through of je at 0x004df10b, 2 instruction(s), falls into the block at 0x004df121
    mov dword ptr [0x5830de], 0x0                # 004df10d
    mov dword ptr [0x5d28b9], 0x0                # 004df117
L_004df121:
    # block 0x004df121: entered by jmp at 0x004df102; je at 0x004df10b, 4 instruction(s), ends with je to 0x004df148 (forward)
    mov edx, dword ptr [ebp - local_4c]          # 004df121
    movsx eax, word ptr [edx + field_3a3]        # 004df124
    cmp eax, -0x1                                # 004df12b
    je.d8 L_004df148                             # 004df12e
    # block 0x004df130: entered by fall-through of je at 0x004df12e, 4 instruction(s), ends with forward jump to 0x004df152
    mov dword ptr [0x5d2997], 0x1                # 004df130
    mov ecx, dword ptr [ebp - local_4c]          # 004df13a
    mov word ptr [ecx + field_3a3], 0xffff       # 004df13d
    jmp.d8 L_004df152                            # 004df146
L_004df148:
    # block 0x004df148: entered by je at 0x004df12e, 1 instruction(s), falls into the block at 0x004df152
    mov dword ptr [0x5d2997], 0x0                # 004df148
L_004df152:
    # block 0x004df152: entered by jmp at 0x004df146, 43 instruction(s), calls FUN_0050ce04, ends with je to 0x004df274 (forward)
    mov dword ptr [ebp - local_24], 0x0          # 004df152
    mov dword ptr [ebp - local_4], 0x0           # 004df159
    mov dword ptr [ebp - local_18], 0x0          # 004df160
    mov edx, dword ptr [ebp - local_4c]          # 004df167
    mov dword ptr [edx + field_73c], 0x0         # 004df16a
    mov eax, dword ptr [ebp - local_4c]          # 004df174
    mov dword ptr [eax + field_740], 0x0         # 004df177
    mov ecx, dword ptr [0x5b44f0]                # 004df181
    shl ecx, 0x4                                 # 004df187
    mov edx, dword ptr [0x5b44f4]                # 004df18a
    mov eax, dword ptr [0x583106]                # 004df190
    add eax, dword ptr [ecx + 8*edx + 0x5b30d0]  # 004df195
    mov word ptr [ebp - local_8], ax             # 004df19c
    mov ecx, dword ptr [0x5b44f0]                # 004df1a0
    shl ecx, 0x4                                 # 004df1a6
    mov edx, dword ptr [0x5b44f4]                # 004df1a9
    mov eax, dword ptr [0x583102]                # 004df1af
    add eax, dword ptr [ecx + 8*edx + 0x5b30cc]  # 004df1b4
    mov word ptr [ebp - local_30], ax            # 004df1bb
    mov ecx, dword ptr [ebp - local_4c]          # 004df1bf
    mov edx, dword ptr [ebp - local_4c]          # 004df1c2
    mov eax, dword ptr [ecx + field_f1]          # 004df1c5
    sub eax, dword ptr [edx + field_e9]          # 004df1cb
    mov dword ptr [ebp - local_58], eax          # 004df1d1
    fild dword ptr [ebp - local_58]              # 004df1d4
    fstp dword ptr [ebp - local_5c]              # 004df1d7
    fld dword ptr [ebp - local_5c]               # 004df1da
    fdiv qword ptr [0x52c678]                    # 004df1dd
    call FUN_0050ce04                            # 004df1e3
    mov word ptr [ebp - local_28], ax            # 004df1e8
    mov ecx, dword ptr [ebp - local_4c]          # 004df1ec
    mov edx, dword ptr [ebp - local_4c]          # 004df1ef
    mov eax, dword ptr [ecx + field_f5]          # 004df1f2
    sub eax, dword ptr [edx + field_ed]          # 004df1f8
    mov dword ptr [ebp - local_60], eax          # 004df1fe
    fild dword ptr [ebp - local_60]              # 004df201
    fstp dword ptr [ebp - local_64]              # 004df204
    fld dword ptr [ebp - local_64]               # 004df207
    fdiv qword ptr [0x52c598]                    # 004df20a
    call FUN_0050ce04                            # 004df210
    mov word ptr [ebp - local_34], ax            # 004df215
    cmp dword ptr [0x5d02ab], 0x0                # 004df219
    je.d8 L_004df274                             # 004df220
    # block 0x004df222: entered by fall-through of je at 0x004df220, 9 instruction(s), calls FUN_004e22fd, ends with je to 0x004df24b (forward)
    mov cx, word ptr [ebp - local_8]             # 004df222
    push ecx                                     # 004df226
    mov dx, word ptr [ebp - local_30]            # 004df227
    push edx                                     # 004df22b
    mov ecx, dword ptr [ebp - local_4c]          # 004df22c
    add ecx, 0x3ef                               # 004df22f
    call FUN_004e22fd                            # 004df235
    test eax, eax                                # 004df23a
    je.d8 L_004df24b                             # 004df23c
    # block 0x004df23e: entered by fall-through of je at 0x004df23c, 2 instruction(s), falls into the block at 0x004df24b
    mov eax, dword ptr [ebp - local_4c]          # 004df23e
    mov dword ptr [eax + field_73c], 0x1         # 004df241
L_004df24b:
    # block 0x004df24b: entered by je at 0x004df23c, 9 instruction(s), calls FUN_004ef2d1, ends with je to 0x004df274 (forward)
    mov cx, word ptr [ebp - local_8]             # 004df24b
    push ecx                                     # 004df24f
    mov dx, word ptr [ebp - local_30]            # 004df250
    push edx                                     # 004df254
    mov ecx, dword ptr [ebp - local_4c]          # 004df255
    add ecx, 0x57e                               # 004df258
    call FUN_004ef2d1                            # 004df25e
    test eax, eax                                # 004df263
    je.d8 L_004df274                             # 004df265
    # block 0x004df267: entered by fall-through of je at 0x004df265, 2 instruction(s), falls into the block at 0x004df274
    mov eax, dword ptr [ebp - local_4c]          # 004df267
    mov dword ptr [eax + field_740], 0x1         # 004df26a
L_004df274:
    # block 0x004df274: entered by je at 0x004df220; je at 0x004df265, 3 instruction(s), ends with jne to 0x004dfb0a (forward)
    mov ecx, dword ptr [ebp - local_4c]          # 004df274
    cmp dword ptr [ecx + field_73c], 0x0         # 004df277
    jne.d32 L_004dfb0a                           # 004df27e
    # block 0x004df284: entered by fall-through of jne at 0x004df27e, 3 instruction(s), ends with jne to 0x004dfb0a (forward)
    mov edx, dword ptr [ebp - local_4c]          # 004df284
    cmp dword ptr [edx + field_740], 0x0         # 004df287
    jne.d32 L_004dfb0a                           # 004df28e
    # block 0x004df294: entered by fall-through of jne at 0x004df28e, 2 instruction(s), ends with forward jump to 0x004df2a8
    mov word ptr [ebp - local_14], 0x0           # 004df294
    jmp.d8 L_004df2a8                            # 004df29a
L_004df29c:
    # block 0x004df29c: entered by jmp at 0x004df475, 3 instruction(s), falls into the block at 0x004df2a8
    mov ax, word ptr [ebp - local_14]            # 004df29c
    .insn 0x66, 0x05, 0x0001{:u16}               # 004df2a0
    mov word ptr [ebp - local_14], ax            # 004df2a4
L_004df2a8:
    # block 0x004df2a8: entered by jmp at 0x004df29a, 3 instruction(s), ends with jge to 0x004df47a (forward)
    movsx ecx, word ptr [ebp - local_14]         # 004df2a8
    cmp ecx, 0x3                                 # 004df2ac
    jge.d32 L_004df47a                           # 004df2af
    # block 0x004df2b5: entered by fall-through of jge at 0x004df2af, 7 instruction(s), ends with jl to 0x004df475 (forward)
    movsx edx, word ptr [ebp - local_8]          # 004df2b5
    movsx eax, word ptr [ebp - local_14]         # 004df2b9
    shl eax, 0x4                                 # 004df2bd
    mov ecx, dword ptr [eax + 0x5832b2]          # 004df2c0
    sub ecx, 0xa                                 # 004df2c6
    {load} cmp edx, ecx                          # 004df2c9
    jl.d32 L_004df475                            # 004df2cb
    # block 0x004df2d1: entered by fall-through of jl at 0x004df2cb, 7 instruction(s), ends with jg to 0x004df475 (forward)
    movsx edx, word ptr [ebp - local_8]          # 004df2d1
    movsx eax, word ptr [ebp - local_14]         # 004df2d5
    shl eax, 0x4                                 # 004df2d9
    mov ecx, dword ptr [eax + 0x5832ba]          # 004df2dc
    add ecx, 0xf                                 # 004df2e2
    {load} cmp edx, ecx                          # 004df2e5
    jg.d32 L_004df475                            # 004df2e7
    # block 0x004df2ed: entered by fall-through of jg at 0x004df2e7, 7 instruction(s), ends with jl to 0x004df475 (forward)
    movsx edx, word ptr [ebp - local_30]         # 004df2ed
    movsx eax, word ptr [ebp - local_14]         # 004df2f1
    shl eax, 0x4                                 # 004df2f5
    mov ecx, dword ptr [eax + 0x5832ae]          # 004df2f8
    sub ecx, 0xa                                 # 004df2fe
    {load} cmp edx, ecx                          # 004df301
    jl.d32 L_004df475                            # 004df303
    # block 0x004df309: entered by fall-through of jl at 0x004df303, 7 instruction(s), ends with jg to 0x004df475 (forward)
    movsx edx, word ptr [ebp - local_30]         # 004df309
    movsx eax, word ptr [ebp - local_14]         # 004df30d
    shl eax, 0x4                                 # 004df311
    mov ecx, dword ptr [eax + 0x5832b6]          # 004df314
    add ecx, 0xf                                 # 004df31a
    {load} cmp edx, ecx                          # 004df31d
    jg.d32 L_004df475                            # 004df31f
    # block 0x004df325: entered by fall-through of jg at 0x004df31f, 4 instruction(s), ends with jne to 0x004df475 (forward)
    mov edx, dword ptr [ebp - local_4c]          # 004df325
    movsx eax, word ptr [edx + field_3a1]        # 004df328
    cmp eax, -0x1                                # 004df32f
    jne.d32 L_004df475                           # 004df332
    # block 0x004df338: entered by fall-through of jne at 0x004df332, 3 instruction(s), ends with jne to 0x004df359 (forward)
    movsx ecx, word ptr [ebp - local_14]         # 004df338
    cmp ecx, 0x2                                 # 004df33c
    jne.d8 L_004df359                            # 004df33f
    # block 0x004df341: entered by fall-through of jne at 0x004df33f, 4 instruction(s), falls into the block at 0x004df359
    mov edx, dword ptr [ebp - local_4c]          # 004df341
    mov ax, word ptr [ebp - local_14]            # 004df344
    mov word ptr [edx + field_3a3], ax           # 004df348
    mov dword ptr [0x5d2997], 0x1                # 004df34f
L_004df359:
    # block 0x004df359: entered by jne at 0x004df33f, 8 instruction(s), ends with je to 0x004df38b (forward)
    mov dword ptr [ebp - local_4], 0x1           # 004df359
    mov dword ptr [ebp - local_24], 0x0          # 004df360
    mov dword ptr [ebp - local_18], 0x0          # 004df367
    mov ecx, dword ptr [ebp - local_4c]          # 004df36e
    mov edx, dword ptr [ecx + field_395]         # 004df371
    mov dword ptr [ebp - local_68], edx          # 004df377
    cmp dword ptr [ebp - local_68], 0x0          # 004df37a
    je.d8 L_004df38b                             # 004df37e
    # block 0x004df380: entered by fall-through of je at 0x004df37e, 2 instruction(s), ends with je to 0x004df3a7 (forward)
    cmp dword ptr [ebp - local_68], 0x1          # 004df380
    je.d8 L_004df3a7                             # 004df384
    # block 0x004df386: entered by fall-through of je at 0x004df384, 1 instruction(s), ends with forward jump to 0x004df473
    jmp.d32 L_004df473                           # 004df386
L_004df38b:
    # block 0x004df38b: entered by je at 0x004df37e, 5 instruction(s), calls FUN_004dad60, ends with forward jump to 0x004df473
    mov ecx, 0x5830a6                            # 004df38b
    call FUN_004dad60                            # 004df390
    mov eax, dword ptr [ebp - local_4c]          # 004df395
    mov dword ptr [eax + field_395], 0x1         # 004df398
    jmp.d32 L_004df473                           # 004df3a2
L_004df3a7:
    # block 0x004df3a7: entered by je at 0x004df384, 4 instruction(s), calls FUN_004daef1, ends with jne to 0x004df473 (forward)
    mov ecx, 0x5830a6                            # 004df3a7
    call FUN_004daef1                            # 004df3ac
    cmp eax, 0x2                                 # 004df3b1
    jne.d32 L_004df473                           # 004df3b4
    # block 0x004df3ba: entered by fall-through of jne at 0x004df3b4, 10 instruction(s), calls FUN_004dad60, ends with je to 0x004df3f3 (forward)
    mov ecx, dword ptr [ebp - local_4c]          # 004df3ba
    mov dx, word ptr [ebp - local_14]            # 004df3bd
    mov word ptr [ecx + field_3a1], dx           # 004df3c1
    mov ecx, 0x5830a6                            # 004df3c8
    call FUN_004dad60                            # 004df3cd
    mov eax, dword ptr [ebp - local_4c]          # 004df3d2
    movsx ecx, word ptr [eax + field_3a1]        # 004df3d5
    mov dword ptr [ebp - local_6c], ecx          # 004df3dc
    cmp dword ptr [ebp - local_6c], 0x0          # 004df3df
    je.d8 L_004df3f3                             # 004df3e3
    # block 0x004df3e5: entered by fall-through of je at 0x004df3e3, 2 instruction(s), ends with je to 0x004df414 (forward)
    cmp dword ptr [ebp - local_6c], 0x1          # 004df3e5
    je.d8 L_004df414                             # 004df3e9
    # block 0x004df3eb: entered by fall-through of je at 0x004df3e9, 2 instruction(s), ends with je to 0x004df435 (forward)
    cmp dword ptr [ebp - local_6c], 0x2          # 004df3eb
    je.d8 L_004df435                             # 004df3ef
    # block 0x004df3f1: entered by fall-through of je at 0x004df3ef, 1 instruction(s), ends with forward jump to 0x004df442
    jmp.d8 L_004df442                            # 004df3f1
L_004df3f3:
    # block 0x004df3f3: entered by je at 0x004df3e3, 2 instruction(s), ends with je to 0x004df408 (forward)
    cmp dword ptr [0x5bb202], 0x0                # 004df3f3
    je.d8 L_004df408                             # 004df3fa
    # block 0x004df3fc: entered by fall-through of je at 0x004df3fa, 2 instruction(s), ends with forward jump to 0x004df412
    mov dword ptr [0x5bb202], 0x0                # 004df3fc
    jmp.d8 L_004df412                            # 004df406
L_004df408:
    # block 0x004df408: entered by je at 0x004df3fa, 1 instruction(s), falls into the block at 0x004df412
    mov dword ptr [0x5bb202], 0x1                # 004df408
L_004df412:
    # block 0x004df412: entered by jmp at 0x004df406, 1 instruction(s), ends with forward jump to 0x004df442
    jmp.d8 L_004df442                            # 004df412
L_004df414:
    # block 0x004df414: entered by je at 0x004df3e9, 2 instruction(s), ends with je to 0x004df429 (forward)
    cmp dword ptr [0x5bb206], 0x0                # 004df414
    je.d8 L_004df429                             # 004df41b
    # block 0x004df41d: entered by fall-through of je at 0x004df41b, 2 instruction(s), ends with forward jump to 0x004df433
    mov dword ptr [0x5bb206], 0x0                # 004df41d
    jmp.d8 L_004df433                            # 004df427
L_004df429:
    # block 0x004df429: entered by je at 0x004df41b, 1 instruction(s), falls into the block at 0x004df433
    mov dword ptr [0x5bb206], 0x1                # 004df429
L_004df433:
    # block 0x004df433: entered by jmp at 0x004df427, 1 instruction(s), ends with forward jump to 0x004df442
    jmp.d8 L_004df442                            # 004df433
L_004df435:
    # block 0x004df435: entered by je at 0x004df3ef, 2 instruction(s), falls into the block at 0x004df442
    mov edx, dword ptr [ebp - local_4c]          # 004df435
    mov dword ptr [edx + field_3a5], 0x1         # 004df438
L_004df442:
    # block 0x004df442: entered by jmp at 0x004df3f1; jmp at 0x004df412; jmp at 0x004df433, 10 instruction(s), calls KERNEL32.dll!GetTickCount, FUN_004fb2e3, falls into the block at 0x004df473
    call dword ptr [0x52a23c]                    # 004df442
    movsx ecx, word ptr [0x5b0282]               # 004df448
    {load} add eax, ecx                          # 004df44f
    mov edx, dword ptr [ebp - local_4c]          # 004df451
    mov dword ptr [edx + field_38d], eax         # 004df454
    push 0x17                                    # 004df45a
    mov ecx, 0x5c3a67                            # 004df45c
    call FUN_004fb2e3                            # 004df461
    mov eax, dword ptr [ebp - local_4c]          # 004df466
    mov dword ptr [eax + field_391], 0x1         # 004df469
L_004df473:
    # block 0x004df473: entered by jmp at 0x004df386; jmp at 0x004df3a2; jne at 0x004df3b4, 1 instruction(s), ends with forward jump to 0x004df47a
    jmp.d8 L_004df47a                            # 004df473
L_004df475:
    # block 0x004df475: entered by jl at 0x004df2cb; jg at 0x004df2e7; jl at 0x004df303; jg at 0x004df31f; jne at 0x004df332, 1 instruction(s), ends with backward jump to 0x004df29c
    jmp.d32 L_004df29c                           # 004df475
L_004df47a:
    # block 0x004df47a: entered by jge at 0x004df2af; jmp at 0x004df473, 2 instruction(s), ends with jne to 0x004df7ee (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 004df47a
    jne.d32 L_004df7ee                           # 004df47e
    # block 0x004df484: entered by fall-through of jne at 0x004df47e, 2 instruction(s), ends with forward jump to 0x004df498
    mov word ptr [ebp - local_10], 0x0           # 004df484
    jmp.d8 L_004df498                            # 004df48a
L_004df48c:
    # block 0x004df48c: entered by jmp at 0x004df7e9, 3 instruction(s), falls into the block at 0x004df498
    mov cx, word ptr [ebp - local_10]            # 004df48c
    add cx, 0x1                                  # 004df490
    mov word ptr [ebp - local_10], cx            # 004df494
L_004df498:
    # block 0x004df498: entered by jmp at 0x004df48a, 3 instruction(s), ends with jge to 0x004df7ee (forward)
    movsx edx, word ptr [ebp - local_10]         # 004df498
    cmp edx, 0x3                                 # 004df49c
    jge.d32 L_004df7ee                           # 004df49f
    # block 0x004df4a5: entered by fall-through of jge at 0x004df49f, 9 instruction(s), ends with jl to 0x004df7e9 (forward)
    movsx eax, word ptr [ebp - local_8]          # 004df4a5
    movsx ecx, word ptr [ebp - local_10]         # 004df4a9
    shl ecx, 0x4                                 # 004df4ad
    movsx edx, word ptr [ebp - local_34]         # 004df4b0
    mov esi, dword ptr [ebp - local_4c]          # 004df4b4
    mov ecx, dword ptr [esi + ecx + field_3b3]   # 004df4b7
    {load} sub ecx, edx                          # 004df4be
    {load} cmp eax, ecx                          # 004df4c0
    jl.d32 L_004df7e9                            # 004df4c2
    # block 0x004df4c8: entered by fall-through of jl at 0x004df4c2, 9 instruction(s), ends with jg to 0x004df7e9 (forward)
    movsx edx, word ptr [ebp - local_8]          # 004df4c8
    movsx eax, word ptr [ebp - local_10]         # 004df4cc
    shl eax, 0x4                                 # 004df4d0
    movsx ecx, word ptr [ebp - local_34]         # 004df4d3
    mov esi, dword ptr [ebp - local_4c]          # 004df4d7
    mov eax, dword ptr [esi + eax + field_3bb]   # 004df4da
    {load} add eax, ecx                          # 004df4e1
    {load} cmp edx, eax                          # 004df4e3
    jg.d32 L_004df7e9                            # 004df4e5
    # block 0x004df4eb: entered by fall-through of jg at 0x004df4e5, 9 instruction(s), ends with jl to 0x004df7e9 (forward)
    movsx ecx, word ptr [ebp - local_30]         # 004df4eb
    movsx edx, word ptr [ebp - local_10]         # 004df4ef
    shl edx, 0x4                                 # 004df4f3
    movsx eax, word ptr [ebp - local_28]         # 004df4f6
    mov esi, dword ptr [ebp - local_4c]          # 004df4fa
    mov edx, dword ptr [esi + edx + field_3af]   # 004df4fd
    {load} sub edx, eax                          # 004df504
    {load} cmp ecx, edx                          # 004df506
    jl.d32 L_004df7e9                            # 004df508
    # block 0x004df50e: entered by fall-through of jl at 0x004df508, 9 instruction(s), ends with jg to 0x004df7e9 (forward)
    movsx eax, word ptr [ebp - local_30]         # 004df50e
    movsx ecx, word ptr [ebp - local_10]         # 004df512
    shl ecx, 0x4                                 # 004df516
    movsx edx, word ptr [ebp - local_28]         # 004df519
    mov esi, dword ptr [ebp - local_4c]          # 004df51d
    mov ecx, dword ptr [esi + ecx + field_3b7]   # 004df520
    {load} add ecx, edx                          # 004df527
    {load} cmp eax, ecx                          # 004df529
    jg.d32 L_004df7e9                            # 004df52b
    # block 0x004df531: entered by fall-through of jg at 0x004df52b, 8 instruction(s), ends with je to 0x004df563 (forward)
    mov dword ptr [ebp - local_4], 0x0           # 004df531
    mov dword ptr [ebp - local_18], 0x0          # 004df538
    mov dword ptr [ebp - local_24], 0x1          # 004df53f
    mov edx, dword ptr [ebp - local_4c]          # 004df546
    mov eax, dword ptr [edx + field_399]         # 004df549
    mov dword ptr [ebp - local_70], eax          # 004df54f
    cmp dword ptr [ebp - local_70], 0x0          # 004df552
    je.d8 L_004df563                             # 004df556
    # block 0x004df558: entered by fall-through of je at 0x004df556, 2 instruction(s), ends with je to 0x004df5c0 (forward)
    cmp dword ptr [ebp - local_70], 0x1          # 004df558
    je.d8 L_004df5c0                             # 004df55c
    # block 0x004df55e: entered by fall-through of je at 0x004df55c, 1 instruction(s), ends with forward jump to 0x004df7e7
    jmp.d32 L_004df7e7                           # 004df55e
L_004df563:
    # block 0x004df563: entered by je at 0x004df556, 4 instruction(s), ends with jne to 0x004df5bb (forward)
    {load} xor ecx, ecx                          # 004df563
    mov cl, byte ptr [0x58321d]                  # 004df565
    cmp ecx, 0x1                                 # 004df56b
    jne.d8 L_004df5bb                            # 004df56e
    # block 0x004df570: entered by fall-through of jne at 0x004df56e, 16 instruction(s), falls into the block at 0x004df5bb
    movsx edx, word ptr [ebp - local_30]         # 004df570
    mov eax, dword ptr [ebp - local_4c]          # 004df574
    mov dword ptr [eax + field_3df], edx         # 004df577
    mov ecx, dword ptr [ebp - local_4c]          # 004df57d
    mov edx, dword ptr [ebp - local_4c]          # 004df580
    mov eax, dword ptr [edx + field_3df]         # 004df583
    mov dword ptr [ecx + field_3e7], eax         # 004df589
    movsx ecx, word ptr [ebp - local_8]          # 004df58f
    mov edx, dword ptr [ebp - local_4c]          # 004df593
    mov dword ptr [edx + field_3e3], ecx         # 004df596
    mov eax, dword ptr [ebp - local_4c]          # 004df59c
    mov ecx, dword ptr [ebp - local_4c]          # 004df59f
    mov edx, dword ptr [ecx + field_3e3]         # 004df5a2
    mov dword ptr [eax + field_3eb], edx         # 004df5a8
    mov eax, dword ptr [ebp - local_4c]          # 004df5ae
    mov dword ptr [eax + field_399], 0x1         # 004df5b1
L_004df5bb:
    # block 0x004df5bb: entered by jne at 0x004df56e, 1 instruction(s), ends with forward jump to 0x004df7e7
    jmp.d32 L_004df7e7                           # 004df5bb
L_004df5c0:
    # block 0x004df5c0: entered by je at 0x004df55c, 4 instruction(s), ends with jne to 0x004df7d0 (forward)
    {load} xor ecx, ecx                          # 004df5c0
    mov cl, byte ptr [0x58321d]                  # 004df5c2
    cmp ecx, 0x1                                 # 004df5c8
    jne.d32 L_004df7d0                           # 004df5cb
    # block 0x004df5d1: entered by fall-through of jne at 0x004df5cb, 11 instruction(s), ends with je to 0x004df7ce (forward)
    movsx edx, word ptr [ebp - local_30]         # 004df5d1
    mov eax, dword ptr [ebp - local_4c]          # 004df5d5
    mov dword ptr [eax + field_3e7], edx         # 004df5d8
    movsx ecx, word ptr [ebp - local_8]          # 004df5de
    mov edx, dword ptr [ebp - local_4c]          # 004df5e2
    mov dword ptr [edx + field_3eb], ecx         # 004df5e5
    mov eax, dword ptr [ebp - local_4c]          # 004df5eb
    mov ecx, dword ptr [ebp - local_4c]          # 004df5ee
    mov edx, dword ptr [eax + field_3e7]         # 004df5f1
    cmp edx, dword ptr [ecx + field_3df]         # 004df5f7
    je.d32 L_004df7ce                            # 004df5fd
    # block 0x004df603: entered by fall-through of je at 0x004df5fd, 34 instruction(s), ends with je to 0x004df69a (forward)
    mov eax, dword ptr [ebp - local_4c]          # 004df603
    mov ecx, dword ptr [ebp - local_4c]          # 004df606
    mov edx, dword ptr [eax + field_3e7]         # 004df609
    sub edx, dword ptr [ecx + field_3df]         # 004df60f
    mov word ptr [ebp - local_38], dx            # 004df615
    movsx eax, word ptr [ebp - local_38]         # 004df619
    mov dword ptr [ebp - local_74], eax          # 004df61d
    fild dword ptr [ebp - local_74]              # 004df620
    fstp dword ptr [ebp - local_78]              # 004df623
    movsx ecx, word ptr [ebp - local_10]         # 004df626
    mov edx, dword ptr [ebp - local_4c]          # 004df62a
    movsx eax, word ptr [edx + 2*ecx + field_3a9] # 004df62d
    mov dword ptr [ebp - local_7c], eax          # 004df635
    fild dword ptr [ebp - local_7c]              # 004df638
    fstp dword ptr [ebp - local_80]              # 004df63b
    fld dword ptr [ebp - local_78]               # 004df63e
    fdiv dword ptr [ebp - local_80]              # 004df641
    fstp dword ptr [ebp - local_2c]              # 004df644
    movsx ecx, word ptr [ebp - local_10]         # 004df647
    imul ecx, ecx, 0x2f                          # 004df64b
    mov edx, dword ptr [ebp - local_4c]          # 004df64e
    mov ax, word ptr [edx + ecx + field_14c]     # 004df651
    mov word ptr [ebp - local_20], ax            # 004df659
    movsx ecx, word ptr [ebp - local_10]         # 004df65d
    fld dword ptr [ebp - local_2c]               # 004df661
    fadd dword ptr [4*ecx + 0x5cf1cb]            # 004df664
    movsx edx, word ptr [ebp - local_10]         # 004df66b
    fstp dword ptr [4*edx + 0x5cf1cb]            # 004df66f
    movsx eax, word ptr [ebp - local_10]         # 004df676
    fld dword ptr [4*eax + 0x5cf1cb]             # 004df67a
    fcomp dword ptr [0x52db78]                   # 004df681
    fnstsw ax                                    # 004df687
    test ah, 0x1                                 # 004df689
    je.d8 L_004df69a                             # 004df68c
    # block 0x004df68e: entered by fall-through of je at 0x004df68c, 2 instruction(s), ends with forward jump to 0x004df6ab
    mov dword ptr [ebp - local_84], 0x0          # 004df68e
    jmp.d8 L_004df6ab                            # 004df698
L_004df69a:
    # block 0x004df69a: entered by je at 0x004df68c, 3 instruction(s), falls into the block at 0x004df6ab
    movsx ecx, word ptr [ebp - local_10]         # 004df69a
    fld dword ptr [4*ecx + 0x5cf1cb]             # 004df69e
    fstp dword ptr [ebp - local_84]              # 004df6a5
L_004df6ab:
    # block 0x004df6ab: entered by jmp at 0x004df698, 9 instruction(s), ends with jne to 0x004df6e0 (forward)
    movsx edx, word ptr [ebp - local_10]         # 004df6ab
    mov eax, dword ptr [ebp - local_84]          # 004df6af
    mov dword ptr [4*edx + 0x5cf1cb], eax        # 004df6b5
    movsx ecx, word ptr [ebp - local_10]         # 004df6bc
    fld dword ptr [4*ecx + 0x5cf1cb]             # 004df6c0
    fcomp dword ptr [0x52cbf4]                   # 004df6c7
    fnstsw ax                                    # 004df6cd
    test ah, 0x41                                # 004df6cf
    jne.d8 L_004df6e0                            # 004df6d2
    # block 0x004df6d4: entered by fall-through of jne at 0x004df6d2, 2 instruction(s), ends with forward jump to 0x004df6f1
    mov dword ptr [ebp - local_88], 0x3f800000   # 004df6d4
    jmp.d8 L_004df6f1                            # 004df6de
L_004df6e0:
    # block 0x004df6e0: entered by jne at 0x004df6d2, 3 instruction(s), falls into the block at 0x004df6f1
    movsx edx, word ptr [ebp - local_10]         # 004df6e0
    fld dword ptr [4*edx + 0x5cf1cb]             # 004df6e4
    fstp dword ptr [ebp - local_88]              # 004df6eb
L_004df6f1:
    # block 0x004df6f1: entered by jmp at 0x004df6de, 44 instruction(s), calls FUN_0050ce04, FUN_004f684a, FUN_004dfff3, falls into the block at 0x004df7ce
    movsx eax, word ptr [ebp - local_10]         # 004df6f1
    mov ecx, dword ptr [ebp - local_88]          # 004df6f5
    mov dword ptr [4*eax + 0x5cf1cb], ecx        # 004df6fb
    mov edx, dword ptr [ebp - local_20]          # 004df702
    and edx, 0xffff                              # 004df705
    imul edx, edx, 0x5bb                         # 004df70b
    movsx eax, word ptr [ebp - local_10]         # 004df711
    fld dword ptr [edx + 0x5c3b9f]               # 004df715
    fmul dword ptr [4*eax + 0x5cf1cb]            # 004df71b
    fmul dword ptr [0x52e4e0]                    # 004df722
    fadd qword ptr [0x52e4d8]                    # 004df728
    call FUN_0050ce04                            # 004df72e
    mov ecx, dword ptr [ebp - local_20]          # 004df733
    and ecx, 0xffff                              # 004df736
    imul ecx, ecx, 0x5bb                         # 004df73c
    mov dword ptr [ecx + 0x5c3ba7], eax          # 004df742
    mov edx, dword ptr [ebp - local_20]          # 004df748
    and edx, 0xffff                              # 004df74b
    imul edx, edx, 0x5bb                         # 004df751
    movsx eax, word ptr [ebp - local_10]         # 004df757
    fld dword ptr [edx + 0x5c3ba3]               # 004df75b
    fmul dword ptr [4*eax + 0x5cf1cb]            # 004df761
    fmul dword ptr [0x52e4e0]                    # 004df768
    fadd qword ptr [0x52e4d8]                    # 004df76e
    call FUN_0050ce04                            # 004df774
    mov ecx, dword ptr [ebp - local_20]          # 004df779
    and ecx, 0xffff                              # 004df77c
    imul ecx, ecx, 0x5bb                         # 004df782
    mov dword ptr [ecx + 0x5c3bab], eax          # 004df788
    mov edx, dword ptr [ebp - local_20]          # 004df78e
    and edx, 0xffff                              # 004df791
    push edx                                     # 004df797
    mov ecx, 0x5cf1eb                            # 004df798
    call FUN_004f684a                            # 004df79d
    mov ecx, dword ptr [ebp - local_4c]          # 004df7a2
    call FUN_004dfff3                            # 004df7a5
    mov eax, dword ptr [ebp - local_4c]          # 004df7aa
    mov ecx, dword ptr [ebp - local_4c]          # 004df7ad
    mov edx, dword ptr [ecx + field_3e7]         # 004df7b0
    mov dword ptr [eax + field_3df], edx         # 004df7b6
    mov eax, dword ptr [ebp - local_4c]          # 004df7bc
    mov ecx, dword ptr [ebp - local_4c]          # 004df7bf
    mov edx, dword ptr [ecx + field_3eb]         # 004df7c2
    mov dword ptr [eax + field_3e3], edx         # 004df7c8
L_004df7ce:
    # block 0x004df7ce: entered by je at 0x004df5fd, 1 instruction(s), ends with forward jump to 0x004df7e7
    jmp.d8 L_004df7e7                            # 004df7ce
L_004df7d0:
    # block 0x004df7d0: entered by jne at 0x004df5cb, 4 instruction(s), calls FUN_004dad60, falls into the block at 0x004df7e7
    mov eax, dword ptr [ebp - local_4c]          # 004df7d0
    mov dword ptr [eax + field_399], 0x0         # 004df7d3
    mov ecx, 0x5830a6                            # 004df7dd
    call FUN_004dad60                            # 004df7e2
L_004df7e7:
    # block 0x004df7e7: entered by jmp at 0x004df55e; jmp at 0x004df5bb; jmp at 0x004df7ce, 1 instruction(s), ends with forward jump to 0x004df7ee
    jmp.d8 L_004df7ee                            # 004df7e7
L_004df7e9:
    # block 0x004df7e9: entered by jl at 0x004df4c2; jg at 0x004df4e5; jl at 0x004df508; jg at 0x004df52b, 1 instruction(s), ends with backward jump to 0x004df48c
    jmp.d32 L_004df48c                           # 004df7e9
L_004df7ee:
    # block 0x004df7ee: entered by jne at 0x004df47e; jge at 0x004df49f; jmp at 0x004df7e7, 2 instruction(s), ends with jne to 0x004dfab5 (forward)
    cmp dword ptr [ebp - local_24], 0x0          # 004df7ee
    jne.d32 L_004dfab5                           # 004df7f2
    # block 0x004df7f8: entered by fall-through of jne at 0x004df7f2, 2 instruction(s), ends with forward jump to 0x004df80c
    mov word ptr [ebp - local_10], 0x0           # 004df7f8
    jmp.d8 L_004df80c                            # 004df7fe
L_004df800:
    # block 0x004df800: entered by jmp at 0x004dfab0, 3 instruction(s), falls into the block at 0x004df80c
    mov cx, word ptr [ebp - local_10]            # 004df800
    add cx, 0x1                                  # 004df804
    mov word ptr [ebp - local_10], cx            # 004df808
L_004df80c:
    # block 0x004df80c: entered by jmp at 0x004df7fe, 3 instruction(s), ends with jge to 0x004dfab5 (forward)
    movsx edx, word ptr [ebp - local_10]         # 004df80c
    cmp edx, 0x3                                 # 004df810
    jge.d32 L_004dfab5                           # 004df813
    # block 0x004df819: entered by fall-through of jge at 0x004df813, 9 instruction(s), ends with jl to 0x004dfab0 (forward)
    movsx eax, word ptr [ebp - local_8]          # 004df819
    movsx ecx, word ptr [ebp - local_10]         # 004df81d
    shl ecx, 0x4                                 # 004df821
    movsx edx, word ptr [ebp - local_34]         # 004df824
    mov esi, dword ptr [ebp - local_4c]          # 004df828
    mov ecx, dword ptr [esi + ecx + field_4d]    # 004df82b
    {load} sub ecx, edx                          # 004df82f
    {load} cmp eax, ecx                          # 004df831
    jl.d32 L_004dfab0                            # 004df833
    # block 0x004df839: entered by fall-through of jl at 0x004df833, 9 instruction(s), ends with jg to 0x004dfab0 (forward)
    movsx edx, word ptr [ebp - local_8]          # 004df839
    movsx eax, word ptr [ebp - local_10]         # 004df83d
    shl eax, 0x4                                 # 004df841
    movsx ecx, word ptr [ebp - local_34]         # 004df844
    mov esi, dword ptr [ebp - local_4c]          # 004df848
    mov eax, dword ptr [esi + eax + field_55]    # 004df84b
    {load} add eax, ecx                          # 004df84f
    {load} cmp edx, eax                          # 004df851
    jg.d32 L_004dfab0                            # 004df853
    # block 0x004df859: entered by fall-through of jg at 0x004df853, 6 instruction(s), ends with jl to 0x004dfab0 (forward)
    movsx ecx, word ptr [ebp - local_30]         # 004df859
    movsx edx, word ptr [ebp - local_10]         # 004df85d
    shl edx, 0x4                                 # 004df861
    mov eax, dword ptr [ebp - local_4c]          # 004df864
    cmp ecx, dword ptr [eax + edx + field_49]    # 004df867
    jl.d32 L_004dfab0                            # 004df86b
    # block 0x004df871: entered by fall-through of jl at 0x004df86b, 6 instruction(s), ends with jg to 0x004dfab0 (forward)
    movsx ecx, word ptr [ebp - local_30]         # 004df871
    movsx edx, word ptr [ebp - local_10]         # 004df875
    shl edx, 0x4                                 # 004df879
    mov eax, dword ptr [ebp - local_4c]          # 004df87c
    cmp ecx, dword ptr [eax + edx + field_51]    # 004df87f
    jg.d32 L_004dfab0                            # 004df883
    # block 0x004df889: entered by fall-through of jg at 0x004df883, 8 instruction(s), ends with je to 0x004df8c4 (forward)
    mov dword ptr [ebp - local_4], 0x0           # 004df889
    mov dword ptr [ebp - local_18], 0x1          # 004df890
    mov dword ptr [ebp - local_24], 0x0          # 004df897
    mov ecx, dword ptr [ebp - local_4c]          # 004df89e
    mov edx, dword ptr [ecx + field_39d]         # 004df8a1
    mov dword ptr [ebp - local_8c], edx          # 004df8a7
    cmp dword ptr [ebp - local_8c], 0x0          # 004df8ad
    je.d8 L_004df8c4                             # 004df8b4
    # block 0x004df8b6: entered by fall-through of je at 0x004df8b4, 2 instruction(s), ends with je to 0x004df8e0 (forward)
    cmp dword ptr [ebp - local_8c], 0x1          # 004df8b6
    je.d8 L_004df8e0                             # 004df8bd
    # block 0x004df8bf: entered by fall-through of je at 0x004df8bd, 1 instruction(s), ends with forward jump to 0x004dfaae
    jmp.d32 L_004dfaae                           # 004df8bf
L_004df8c4:
    # block 0x004df8c4: entered by je at 0x004df8b4, 5 instruction(s), calls FUN_004dad60, ends with forward jump to 0x004dfaae
    mov ecx, 0x5830a6                            # 004df8c4
    call FUN_004dad60                            # 004df8c9
    mov eax, dword ptr [ebp - local_4c]          # 004df8ce
    mov dword ptr [eax + field_39d], 0x1         # 004df8d1
    jmp.d32 L_004dfaae                           # 004df8db
L_004df8e0:
    # block 0x004df8e0: entered by je at 0x004df8bd, 4 instruction(s), calls FUN_004daef1, ends with jne to 0x004dfaae (forward)
    mov ecx, 0x5830a6                            # 004df8e0
    call FUN_004daef1                            # 004df8e5
    cmp eax, 0x2                                 # 004df8ea
    jne.d32 L_004dfaae                           # 004df8ed
    # block 0x004df8f3: entered by fall-through of jne at 0x004df8ed, 35 instruction(s), calls FUN_004dad60, ends with je to 0x004df9a1 (forward)
    mov ecx, 0x5830a6                            # 004df8f3
    call FUN_004dad60                            # 004df8f8
    movsx ecx, word ptr [ebp - local_30]         # 004df8fd
    movsx edx, word ptr [ebp - local_10]         # 004df901
    shl edx, 0x4                                 # 004df905
    mov eax, dword ptr [ebp - local_4c]          # 004df908
    sub ecx, dword ptr [eax + edx + field_49]    # 004df90b
    mov word ptr [ebp - local_1c], cx            # 004df90f
    movsx ecx, word ptr [ebp - local_1c]         # 004df913
    mov dword ptr [ebp - local_90], ecx          # 004df917
    fild dword ptr [ebp - local_90]              # 004df91d
    fstp dword ptr [ebp - local_94]              # 004df923
    movsx edx, word ptr [ebp - local_10]         # 004df929
    mov eax, dword ptr [ebp - local_4c]          # 004df92d
    movsx ecx, word ptr [eax + 2*edx + field_3a9] # 004df930
    mov dword ptr [ebp - local_98], ecx          # 004df938
    fild dword ptr [ebp - local_98]              # 004df93e
    fstp dword ptr [ebp - local_9c]              # 004df944
    fld dword ptr [ebp - local_94]               # 004df94a
    fdiv dword ptr [ebp - local_9c]              # 004df950
    fstp dword ptr [ebp - local_c]               # 004df956
    movsx edx, word ptr [ebp - local_10]         # 004df959
    imul edx, edx, 0x2f                          # 004df95d
    mov eax, dword ptr [ebp - local_4c]          # 004df960
    mov cx, word ptr [eax + edx + field_14c]     # 004df963
    mov word ptr [ebp - local_20], cx            # 004df96b
    movsx edx, word ptr [ebp - local_10]         # 004df96f
    mov eax, dword ptr [ebp - local_c]           # 004df973
    mov dword ptr [4*edx + 0x5cf1cb], eax        # 004df976
    movsx ecx, word ptr [ebp - local_10]         # 004df97d
    fld dword ptr [4*ecx + 0x5cf1cb]             # 004df981
    fcomp dword ptr [0x52db78]                   # 004df988
    fnstsw ax                                    # 004df98e
    test ah, 0x1                                 # 004df990
    je.d8 L_004df9a1                             # 004df993
    # block 0x004df995: entered by fall-through of je at 0x004df993, 2 instruction(s), ends with forward jump to 0x004df9b2
    mov dword ptr [ebp - local_a0], 0x0          # 004df995
    jmp.d8 L_004df9b2                            # 004df99f
L_004df9a1:
    # block 0x004df9a1: entered by je at 0x004df993, 3 instruction(s), falls into the block at 0x004df9b2
    movsx edx, word ptr [ebp - local_10]         # 004df9a1
    fld dword ptr [4*edx + 0x5cf1cb]             # 004df9a5
    fstp dword ptr [ebp - local_a0]              # 004df9ac
L_004df9b2:
    # block 0x004df9b2: entered by jmp at 0x004df99f, 9 instruction(s), ends with jne to 0x004df9e7 (forward)
    movsx eax, word ptr [ebp - local_10]         # 004df9b2
    mov ecx, dword ptr [ebp - local_a0]          # 004df9b6
    mov dword ptr [4*eax + 0x5cf1cb], ecx        # 004df9bc
    movsx edx, word ptr [ebp - local_10]         # 004df9c3
    fld dword ptr [4*edx + 0x5cf1cb]             # 004df9c7
    fcomp dword ptr [0x52cbf4]                   # 004df9ce
    fnstsw ax                                    # 004df9d4
    test ah, 0x41                                # 004df9d6
    jne.d8 L_004df9e7                            # 004df9d9
    # block 0x004df9db: entered by fall-through of jne at 0x004df9d9, 2 instruction(s), ends with forward jump to 0x004df9f8
    mov dword ptr [ebp - local_a4], 0x3f800000   # 004df9db
    jmp.d8 L_004df9f8                            # 004df9e5
L_004df9e7:
    # block 0x004df9e7: entered by jne at 0x004df9d9, 3 instruction(s), falls into the block at 0x004df9f8
    movsx eax, word ptr [ebp - local_10]         # 004df9e7
    fld dword ptr [4*eax + 0x5cf1cb]             # 004df9eb
    fstp dword ptr [ebp - local_a4]              # 004df9f2
L_004df9f8:
    # block 0x004df9f8: entered by jmp at 0x004df9e5, 36 instruction(s), calls FUN_0050ce04, FUN_004f684a, FUN_004dfff3, falls into the block at 0x004dfaae
    movsx ecx, word ptr [ebp - local_10]         # 004df9f8
    mov edx, dword ptr [ebp - local_a4]          # 004df9fc
    mov dword ptr [4*ecx + 0x5cf1cb], edx        # 004dfa02
    mov eax, dword ptr [ebp - local_20]          # 004dfa09
    and eax, 0xffff                              # 004dfa0c
    imul eax, eax, 0x5bb                         # 004dfa11
    movsx ecx, word ptr [ebp - local_10]         # 004dfa17
    fld dword ptr [eax + 0x5c3b9f]               # 004dfa1b
    fmul dword ptr [4*ecx + 0x5cf1cb]            # 004dfa21
    fmul dword ptr [0x52e4e0]                    # 004dfa28
    fadd qword ptr [0x52e4d8]                    # 004dfa2e
    call FUN_0050ce04                            # 004dfa34
    mov edx, dword ptr [ebp - local_20]          # 004dfa39
    and edx, 0xffff                              # 004dfa3c
    imul edx, edx, 0x5bb                         # 004dfa42
    mov dword ptr [edx + 0x5c3ba7], eax          # 004dfa48
    mov eax, dword ptr [ebp - local_20]          # 004dfa4e
    and eax, 0xffff                              # 004dfa51
    imul eax, eax, 0x5bb                         # 004dfa56
    movsx ecx, word ptr [ebp - local_10]         # 004dfa5c
    fld dword ptr [eax + 0x5c3ba3]               # 004dfa60
    fmul dword ptr [4*ecx + 0x5cf1cb]            # 004dfa66
    fmul dword ptr [0x52e4e0]                    # 004dfa6d
    fadd qword ptr [0x52e4d8]                    # 004dfa73
    call FUN_0050ce04                            # 004dfa79
    mov edx, dword ptr [ebp - local_20]          # 004dfa7e
    and edx, 0xffff                              # 004dfa81
    imul edx, edx, 0x5bb                         # 004dfa87
    mov dword ptr [edx + 0x5c3bab], eax          # 004dfa8d
    mov eax, dword ptr [ebp - local_20]          # 004dfa93
    and eax, 0xffff                              # 004dfa96
    push eax                                     # 004dfa9b
    mov ecx, 0x5cf1eb                            # 004dfa9c
    call FUN_004f684a                            # 004dfaa1
    mov ecx, dword ptr [ebp - local_4c]          # 004dfaa6
    call FUN_004dfff3                            # 004dfaa9
L_004dfaae:
    # block 0x004dfaae: entered by jmp at 0x004df8bf; jmp at 0x004df8db; jne at 0x004df8ed, 1 instruction(s), ends with forward jump to 0x004dfab5
    jmp.d8 L_004dfab5                            # 004dfaae
L_004dfab0:
    # block 0x004dfab0: entered by jl at 0x004df833; jg at 0x004df853; jl at 0x004df86b; jg at 0x004df883, 1 instruction(s), ends with backward jump to 0x004df800
    jmp.d32 L_004df800                           # 004dfab0
L_004dfab5:
    # block 0x004dfab5: entered by jne at 0x004df7f2; jge at 0x004df813; jmp at 0x004dfaae, 2 instruction(s), ends with jne to 0x004dfac8 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 004dfab5
    jne.d8 L_004dfac8                            # 004dfab9
    # block 0x004dfabb: entered by fall-through of jne at 0x004dfab9, 2 instruction(s), falls into the block at 0x004dfac8
    mov ecx, dword ptr [ebp - local_4c]          # 004dfabb
    mov dword ptr [ecx + field_395], 0x0         # 004dfabe
L_004dfac8:
    # block 0x004dfac8: entered by jne at 0x004dfab9, 2 instruction(s), ends with jne to 0x004dfadb (forward)
    cmp dword ptr [ebp - local_24], 0x0          # 004dfac8
    jne.d8 L_004dfadb                            # 004dfacc
    # block 0x004dface: entered by fall-through of jne at 0x004dfacc, 2 instruction(s), falls into the block at 0x004dfadb
    mov edx, dword ptr [ebp - local_4c]          # 004dface
    mov dword ptr [edx + field_399], 0x0         # 004dfad1
L_004dfadb:
    # block 0x004dfadb: entered by jne at 0x004dfacc, 2 instruction(s), ends with jne to 0x004dfaee (forward)
    cmp dword ptr [ebp - local_18], 0x0          # 004dfadb
    jne.d8 L_004dfaee                            # 004dfadf
    # block 0x004dfae1: entered by fall-through of jne at 0x004dfadf, 2 instruction(s), falls into the block at 0x004dfaee
    mov eax, dword ptr [ebp - local_4c]          # 004dfae1
    mov dword ptr [eax + field_39d], 0x0         # 004dfae4
L_004dfaee:
    # block 0x004dfaee: entered by jne at 0x004dfadf, 2 instruction(s), ends with jne to 0x004dfb0a (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 004dfaee
    jne.d8 L_004dfb0a                            # 004dfaf2
    # block 0x004dfaf4: entered by fall-through of jne at 0x004dfaf2, 2 instruction(s), ends with jne to 0x004dfb0a (forward)
    cmp dword ptr [ebp - local_24], 0x0          # 004dfaf4
    jne.d8 L_004dfb0a                            # 004dfaf8
    # block 0x004dfafa: entered by fall-through of jne at 0x004dfaf8, 2 instruction(s), ends with jne to 0x004dfb0a (forward)
    cmp dword ptr [ebp - local_18], 0x0          # 004dfafa
    jne.d8 L_004dfb0a                            # 004dfafe
    # block 0x004dfb00: entered by fall-through of jne at 0x004dfafe, 2 instruction(s), calls FUN_004dad60, falls into the block at 0x004dfb0a
    mov ecx, 0x5830a6                            # 004dfb00
    call FUN_004dad60                            # 004dfb05
L_004dfb0a:
    # block 0x004dfb0a: entered by jne at 0x004df27e; jne at 0x004df28e; jne at 0x004dfaf2; jne at 0x004dfaf8; more, 2 instruction(s), ends with je to 0x004dfcf2 (forward)
    cmp dword ptr [0x5d02ab], 0x0                # 004dfb0a
    je.d32 L_004dfcf2                            # 004dfb11
    # block 0x004dfb17: entered by fall-through of je at 0x004dfb11, 16 instruction(s), calls FUN_004e29ec, FUN_004ef89b, FUN_004ef516, ends with je to 0x004dfc73 (forward)
    mov ecx, dword ptr [ebp - local_4c]          # 004dfb17
    add ecx, 0x3ef                               # 004dfb1a
    call FUN_004e29ec                            # 004dfb20
    mov ecx, dword ptr [ebp - local_4c]          # 004dfb25
    add ecx, 0x57e                               # 004dfb28
    call FUN_004ef89b                            # 004dfb2e
    mov ecx, dword ptr [ebp - local_4c]          # 004dfb33
    add ecx, 0x57e                               # 004dfb36
    call FUN_004ef516                            # 004dfb3c
    mov ecx, dword ptr [ebp - local_4c]          # 004dfb41
    mov dword ptr [ecx + field_730], eax         # 004dfb44
    mov edx, dword ptr [ebp - local_4c]          # 004dfb4a
    mov eax, dword ptr [ebp - local_4c]          # 004dfb4d
    mov ecx, dword ptr [edx + field_730]         # 004dfb50
    cmp ecx, dword ptr [eax + field_734]         # 004dfb56
    je.d32 L_004dfc73                            # 004dfb5c
    # block 0x004dfb62: entered by fall-through of je at 0x004dfb5c, 3 instruction(s), ends with jne to 0x004dfb7d (forward)
    mov edx, dword ptr [ebp - local_4c]          # 004dfb62
    cmp dword ptr [edx + field_730], 0x32        # 004dfb65
    jne.d8 L_004dfb7d                            # 004dfb6c
    # block 0x004dfb6e: entered by fall-through of jne at 0x004dfb6c, 3 instruction(s), ends with forward jump to 0x004dfc2d
    mov eax, dword ptr [0x5d02b7]                # 004dfb6e
    mov dword ptr [0x5d02bb], eax                # 004dfb73
    jmp.d32 L_004dfc2d                           # 004dfb78
L_004dfb7d:
    # block 0x004dfb7d: entered by jne at 0x004dfb6c, 14 instruction(s), ends with je to 0x004dfbf6 (forward)
    mov ecx, dword ptr [ebp - local_4c]          # 004dfb7d
    fild dword ptr [ecx + field_730]             # 004dfb80
    fstp dword ptr [ebp - local_a8]              # 004dfb86
    fld dword ptr [ebp - local_a8]               # 004dfb8c
    fsub dword ptr [0x52e4d4]                    # 004dfb92
    fdiv dword ptr [0x52e4d4]                    # 004dfb98
    mov edx, dword ptr [ebp - local_4c]          # 004dfb9e
    fstp dword ptr [edx + field_738]             # 004dfba1
    mov eax, dword ptr [ebp - local_4c]          # 004dfba7
    fld dword ptr [eax + field_738]              # 004dfbaa
    fcomp dword ptr [0x52db78]                   # 004dfbb0
    fnstsw ax                                    # 004dfbb6
    test ah, 0x1                                 # 004dfbb8
    je.d8 L_004dfbf6                             # 004dfbbb
    # block 0x004dfbbd: entered by fall-through of je at 0x004dfbbb, 11 instruction(s), calls FUN_0050ce04, ends with forward jump to 0x004dfc2d
    fild dword ptr [0x5d02c3]                    # 004dfbbd
    fstp dword ptr [ebp - local_ac]              # 004dfbc3
    mov ecx, dword ptr [ebp - local_4c]          # 004dfbc9
    fld dword ptr [ebp - local_ac]               # 004dfbcc
    fmul dword ptr [ecx + field_738]             # 004dfbd2
    fild dword ptr [0x5d02b7]                    # 004dfbd8
    fstp dword ptr [ebp - local_b0]              # 004dfbde
    fadd dword ptr [ebp - local_b0]              # 004dfbe4
    call FUN_0050ce04                            # 004dfbea
    mov dword ptr [0x5d02bb], eax                # 004dfbef
    jmp.d8 L_004dfc2d                            # 004dfbf4
L_004dfbf6:
    # block 0x004dfbf6: entered by je at 0x004dfbbb, 10 instruction(s), calls FUN_0050ce04, falls into the block at 0x004dfc2d
    fild dword ptr [0x5d02c7]                    # 004dfbf6
    fstp dword ptr [ebp - local_b4]              # 004dfbfc
    mov edx, dword ptr [ebp - local_4c]          # 004dfc02
    fld dword ptr [ebp - local_b4]               # 004dfc05
    fmul dword ptr [edx + field_738]             # 004dfc0b
    fild dword ptr [0x5d02b7]                    # 004dfc11
    fstp dword ptr [ebp - local_b8]              # 004dfc17
    fadd dword ptr [ebp - local_b8]              # 004dfc1d
    call FUN_0050ce04                            # 004dfc23
    mov dword ptr [0x5d02bb], eax                # 004dfc28
L_004dfc2d:
    # block 0x004dfc2d: entered by jmp at 0x004dfb78; jmp at 0x004dfbf4, 16 instruction(s), calls FUN_004c98b5, FUN_004ef4f0, falls into the block at 0x004dfc73
    mov ecx, 0x5cf659                            # 004dfc2d
    call FUN_004c98b5                            # 004dfc32
    mov eax, dword ptr [ebp - local_4c]          # 004dfc37
    mov ecx, dword ptr [ebp - local_4c]          # 004dfc3a
    mov edx, dword ptr [ecx + field_730]         # 004dfc3d
    mov dword ptr [eax + field_72c], edx         # 004dfc43
    mov eax, dword ptr [ebp - local_4c]          # 004dfc49
    mov ecx, dword ptr [eax + field_72c]         # 004dfc4c
    push ecx                                     # 004dfc52
    mov ecx, dword ptr [ebp - local_4c]          # 004dfc53
    add ecx, 0x57e                               # 004dfc56
    call FUN_004ef4f0                            # 004dfc5c
    mov edx, dword ptr [ebp - local_4c]          # 004dfc61
    mov eax, dword ptr [ebp - local_4c]          # 004dfc64
    mov ecx, dword ptr [eax + field_730]         # 004dfc67
    mov dword ptr [edx + field_734], ecx         # 004dfc6d
L_004dfc73:
    # block 0x004dfc73: entered by je at 0x004dfb5c, 4 instruction(s), calls FUN_004daf3f, ends with je to 0x004dfcf2 (forward)
    mov ecx, 0x5830a6                            # 004dfc73
    call FUN_004daf3f                            # 004dfc78
    test eax, eax                                # 004dfc7d
    je.d8 L_004dfcf2                             # 004dfc7f
    # block 0x004dfc81: entered by fall-through of je at 0x004dfc7f, 5 instruction(s), calls FUN_004e26fc, ends with je to 0x004dfcf2 (forward)
    mov ecx, dword ptr [ebp - local_4c]          # 004dfc81
    add ecx, 0x3ef                               # 004dfc84
    call FUN_004e26fc                            # 004dfc8a
    test eax, eax                                # 004dfc8f
    je.d8 L_004dfcf2                             # 004dfc91
    # block 0x004dfc93: entered by fall-through of je at 0x004dfc91, 20 instruction(s), calls FUN_004c98b5, FUN_004ef4f0, falls into the block at 0x004dfcf2
    mov edx, dword ptr [0x5d02b7]                # 004dfc93
    mov dword ptr [0x5d02bb], edx                # 004dfc99
    mov ecx, 0x5cf659                            # 004dfc9f
    call FUN_004c98b5                            # 004dfca4
    mov eax, dword ptr [ebp - local_4c]          # 004dfca9
    mov dword ptr [eax + field_72c], 0x32        # 004dfcac
    mov ecx, dword ptr [ebp - local_4c]          # 004dfcb6
    mov edx, dword ptr [ecx + field_72c]         # 004dfcb9
    push edx                                     # 004dfcbf
    mov ecx, dword ptr [ebp - local_4c]          # 004dfcc0
    add ecx, 0x57e                               # 004dfcc3
    call FUN_004ef4f0                            # 004dfcc9
    mov eax, dword ptr [ebp - local_4c]          # 004dfcce
    mov ecx, dword ptr [ebp - local_4c]          # 004dfcd1
    mov edx, dword ptr [ecx + field_72c]         # 004dfcd4
    mov dword ptr [eax + field_734], edx         # 004dfcda
    mov eax, dword ptr [ebp - local_4c]          # 004dfce0
    mov ecx, dword ptr [ebp - local_4c]          # 004dfce3
    mov edx, dword ptr [ecx + field_72c]         # 004dfce6
    mov dword ptr [eax + field_730], edx         # 004dfcec
L_004dfcf2:
    # block 0x004dfcf2: entered by je at 0x004dfb11; je at 0x004dfc7f; je at 0x004dfc91, 1 instruction(s), ends with forward jump to 0x004dfdb7
    jmp.d32 L_004dfdb7                           # 004dfcf2
L_004dfcf7:
    # block 0x004dfcf7: entered by je at 0x004def0c, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jbe to 0x004dfd25 (forward)
    call dword ptr [0x52a23c]                    # 004dfcf7
    mov ecx, dword ptr [ebp - local_4c]          # 004dfcfd
    cmp eax, dword ptr [ecx + field_38d]         # 004dfd00
    jbe.d8 L_004dfd25                            # 004dfd06
    # block 0x004dfd08: entered by fall-through of jbe at 0x004dfd06, 5 instruction(s), calls FUN_004f6334, ends with jne to 0x004dfd25 (forward)
    push 0x17                                    # 004dfd08
    mov ecx, 0x5cf1eb                            # 004dfd0a
    call FUN_004f6334                            # 004dfd0f
    test eax, eax                                # 004dfd14
    jne.d8 L_004dfd25                            # 004dfd16
    # block 0x004dfd18: entered by fall-through of jne at 0x004dfd16, 2 instruction(s), falls into the block at 0x004dfd25
    mov edx, dword ptr [ebp - local_4c]          # 004dfd18
    mov dword ptr [edx + field_391], 0x2         # 004dfd1b
L_004dfd25:
    # block 0x004dfd25: entered by jbe at 0x004dfd06; jne at 0x004dfd16, 1 instruction(s), ends with forward jump to 0x004dfdb7
    jmp.d32 L_004dfdb7                           # 004dfd25
L_004dfd2a:
    # block 0x004dfd2a: entered by je at 0x004def16, 7 instruction(s), calls FUN_004dad60, ends with jl to 0x004dfdb7 (forward)
    mov ecx, 0x5830a6                            # 004dfd2a
    call FUN_004dad60                            # 004dfd2f
    mov eax, dword ptr [ebp - local_4c]          # 004dfd34
    movsx ecx, word ptr [eax + field_3a1]        # 004dfd37
    mov dword ptr [ebp - local_bc], ecx          # 004dfd3e
    cmp dword ptr [ebp - local_bc], 0x0          # 004dfd44
    jl.d8 L_004dfdb7                             # 004dfd4b
    # block 0x004dfd4d: entered by fall-through of jl at 0x004dfd4b, 2 instruction(s), ends with jle to 0x004dfd6d (forward)
    cmp dword ptr [ebp - local_bc], 0x1          # 004dfd4d
    jle.d8 L_004dfd6d                            # 004dfd54
    # block 0x004dfd56: entered by fall-through of jle at 0x004dfd54, 2 instruction(s), ends with je to 0x004dfd61 (forward)
    cmp dword ptr [ebp - local_bc], 0x2          # 004dfd56
    je.d8 L_004dfd61                             # 004dfd5d
    # block 0x004dfd5f: entered by fall-through of je at 0x004dfd5d, 1 instruction(s), ends with forward jump to 0x004dfdb7
    jmp.d8 L_004dfdb7                            # 004dfd5f
L_004dfd61:
    # block 0x004dfd61: entered by je at 0x004dfd5d, 2 instruction(s), ends with forward jump to 0x004dfdc4
    mov dword ptr [0x583995], 0x2                # 004dfd61
    jmp.d8 L_004dfdc4                            # 004dfd6b
L_004dfd6d:
    # block 0x004dfd6d: entered by jle at 0x004dfd54, 12 instruction(s), calls FUN_004dad60, falls into the block at 0x004dfdb7
    mov ecx, 0x5830a6                            # 004dfd6d
    call FUN_004dad60                            # 004dfd72
    mov edx, dword ptr [ebp - local_4c]          # 004dfd77
    mov dword ptr [edx + field_391], 0x0         # 004dfd7a
    mov eax, dword ptr [ebp - local_4c]          # 004dfd84
    mov dword ptr [eax + field_395], 0x0         # 004dfd87
    mov ecx, dword ptr [ebp - local_4c]          # 004dfd91
    mov dword ptr [ecx + field_399], 0x0         # 004dfd94
    mov edx, dword ptr [ebp - local_4c]          # 004dfd9e
    mov dword ptr [edx + field_39d], 0x0         # 004dfda1
    mov eax, dword ptr [ebp - local_4c]          # 004dfdab
    mov word ptr [eax + field_3a1], 0xffff       # 004dfdae
L_004dfdb7:
    # block 0x004dfdb7: entered by jmp at 0x004def1c; jmp at 0x004dfcf2; jmp at 0x004dfd25; jl at 0x004dfd4b; more, 3 instruction(s), calls FUN_004cf7e0, falls into the block at 0x004dfdc4
    push 0x55b8f0                                # 004dfdb7
    call FUN_004cf7e0                            # 004dfdbc
    add esp, 0x4                                 # 004dfdc1
L_004dfdc4:
    # block 0x004dfdc4: entered by jmp at 0x004dfd6b, 4 instruction(s), ends with ret
    pop esi                                      # 004dfdc4
    {load} mov esp, ebp                          # 004dfdc5
    pop ebp                                      # 004dfdc7
    ret                                          # 004dfdc8

