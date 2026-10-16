# FUN_004fa127
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fa127
# extent:       0x004fa127-0x004fa2a8 (385 code bytes)
# span:         0x004fa127-0x004fa2a8 (code 385, tables 0, padding 0)
# sha256:       6f77a4ef785f6b094d806068fd614de503fe6b82c2aff60d8698d5665003217e
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fa127
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       21 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_24, local_28, local_30, local_34, local_3c and 9 more
# fields:       [eax + n] field_4, field_14, field_1c, field_24; [ecx + n] field_4, field_8, field_14, field_24, field_162, field_3ce; [edx + n] field_8, field_14, field_18, field_1c, field_20, field_28
# callees:      calls FUN_004f709c, FUN_0050ce04, FUN_0050cd50
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 120 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_4c, 0x4c  # offset -0x4c
.equ local_50, 0x50  # offset -0x50
.equ local_54, 0x54  # offset -0x54
.equ local_5c, 0x5c  # offset -0x5c
.equ local_60, 0x60  # offset -0x60
.equ local_64, 0x64  # offset -0x64
.equ local_6c, 0x6c  # offset -0x6c
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_162, 0x162  # offset +0x162
.equ field_3ce, 0x3ce  # offset +0x3ce

# --- external targets -----------------------------------------------
.set FUN_004f709c, .text + (0x004f709c - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x004fa127 - 0x401000
.globl FUN_004fa127
FUN_004fa127:
    # block 0x004fa127: entry, 17 instruction(s), calls FUN_004f709c, ends with je to 0x004fa16a (forward)
    push ebp                                     # 004fa127
    {load} mov ebp, esp                          # 004fa128
    sub esp, 0x6c                                # 004fa12a
    mov dword ptr [ebp - local_18], ecx          # 004fa12d
    mov eax, dword ptr [ebp + arg_8]             # 004fa130
    imul eax, eax, 0x5bb                         # 004fa133
    mov ecx, dword ptr [ebp - local_18]          # 004fa139
    mov edx, dword ptr [ecx + field_3ce]         # 004fa13c
    {load} add edx, eax                          # 004fa142
    mov dword ptr [ebp - local_14], edx          # 004fa144
    mov eax, dword ptr [ebp - local_14]          # 004fa147
    add eax, 0x19e                               # 004fa14a
    mov dword ptr [ebp - local_4], eax           # 004fa14f
    mov ecx, dword ptr [ebp - local_18]          # 004fa152
    call FUN_004f709c                            # 004fa155
    test eax, eax                                # 004fa15a
    je.d8 L_004fa16a                             # 004fa15c
    # block 0x004fa15e: entered by fall-through of je at 0x004fa15c, 3 instruction(s), ends with jne to 0x004fa16f (forward)
    mov ecx, dword ptr [ebp - local_14]          # 004fa15e
    cmp dword ptr [ecx + field_162], 0x0         # 004fa161
    jne.d8 L_004fa16f                            # 004fa168
L_004fa16a:
    # block 0x004fa16a: entered by je at 0x004fa15c; fall-through of jne at 0x004fa168, 1 instruction(s), ends with forward jump to 0x004fa2a2
    jmp.d32 L_004fa2a2                           # 004fa16a
L_004fa16f:
    # block 0x004fa16f: entered by jne at 0x004fa168, 35 instruction(s), calls FUN_0050ce04, ends with je to 0x004fa215 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004fa16f
    mov eax, dword ptr [ebp - local_4]           # 004fa172
    mov ecx, dword ptr [edx + field_18]          # 004fa175
    sub ecx, dword ptr [eax + field_14]          # 004fa178
    mov dword ptr [ebp - local_1c], ecx          # 004fa17b
    fild dword ptr [ebp - local_1c]              # 004fa17e
    fstp qword ptr [ebp - local_24]              # 004fa181
    fld qword ptr [ebp - local_24]               # 004fa184
    fmul qword ptr [0x52c680]                    # 004fa187
    call FUN_0050ce04                            # 004fa18d
    mov dword ptr [ebp - local_10], eax          # 004fa192
    mov edx, dword ptr [ebp - local_4]           # 004fa195
    mov eax, dword ptr [ebp - local_4]           # 004fa198
    mov ecx, dword ptr [edx + field_20]          # 004fa19b
    sub ecx, dword ptr [eax + field_1c]          # 004fa19e
    mov dword ptr [ebp - local_28], ecx          # 004fa1a1
    fild dword ptr [ebp - local_28]              # 004fa1a4
    fstp qword ptr [ebp - local_30]              # 004fa1a7
    fld qword ptr [ebp - local_30]               # 004fa1aa
    fmul qword ptr [0x52c680]                    # 004fa1ad
    call FUN_0050ce04                            # 004fa1b3
    mov dword ptr [ebp - local_c], eax           # 004fa1b8
    mov edx, dword ptr [ebp - local_4]           # 004fa1bb
    mov eax, dword ptr [ebp - local_4]           # 004fa1be
    mov ecx, dword ptr [edx + field_28]          # 004fa1c1
    sub ecx, dword ptr [eax + field_24]          # 004fa1c4
    mov dword ptr [ebp - local_34], ecx          # 004fa1c7
    fild dword ptr [ebp - local_34]              # 004fa1ca
    fstp qword ptr [ebp - local_3c]              # 004fa1cd
    fld qword ptr [ebp - local_3c]               # 004fa1d0
    fmul qword ptr [0x52c680]                    # 004fa1d3
    call FUN_0050ce04                            # 004fa1d9
    mov dword ptr [ebp - local_8], eax           # 004fa1de
    cmp dword ptr [ebp - local_10], 0x0          # 004fa1e1
    je.d8 L_004fa215                             # 004fa1e5
    # block 0x004fa1e7: entered by fall-through of je at 0x004fa1e5, 15 instruction(s), calls FUN_0050cd50, ends with forward jump to 0x004fa220
    call FUN_0050cd50                            # 004fa1e7
    cdq                                          # 004fa1ec
    idiv dword ptr [ebp - local_10]              # 004fa1ed
    mov dword ptr [ebp - local_40], edx          # 004fa1f0
    fild dword ptr [ebp - local_40]              # 004fa1f3
    fstp dword ptr [ebp - local_44]              # 004fa1f6
    fld dword ptr [ebp - local_44]               # 004fa1f9
    fdiv qword ptr [0x52c680]                    # 004fa1fc
    mov edx, dword ptr [ebp - local_4]           # 004fa202
    fild dword ptr [edx + field_14]              # 004fa205
    fstp qword ptr [ebp - local_4c]              # 004fa208
    fadd qword ptr [ebp - local_4c]              # 004fa20b
    mov eax, dword ptr [ebp + arg_c]             # 004fa20e
    fstp dword ptr [eax]                         # 004fa211
    jmp.d8 L_004fa220                            # 004fa213
L_004fa215:
    # block 0x004fa215: entered by je at 0x004fa1e5, 4 instruction(s), falls into the block at 0x004fa220
    mov ecx, dword ptr [ebp - local_4]           # 004fa215
    fild dword ptr [ecx + field_14]              # 004fa218
    mov edx, dword ptr [ebp + arg_c]             # 004fa21b
    fstp dword ptr [edx]                         # 004fa21e
L_004fa220:
    # block 0x004fa220: entered by jmp at 0x004fa213, 2 instruction(s), ends with je to 0x004fa255 (forward)
    cmp dword ptr [ebp - local_c], 0x0           # 004fa220
    je.d8 L_004fa255                             # 004fa224
    # block 0x004fa226: entered by fall-through of je at 0x004fa224, 15 instruction(s), calls FUN_0050cd50, ends with forward jump to 0x004fa261
    call FUN_0050cd50                            # 004fa226
    cdq                                          # 004fa22b
    idiv dword ptr [ebp - local_c]               # 004fa22c
    mov dword ptr [ebp - local_50], edx          # 004fa22f
    fild dword ptr [ebp - local_50]              # 004fa232
    fstp dword ptr [ebp - local_54]              # 004fa235
    fld dword ptr [ebp - local_54]               # 004fa238
    fdiv qword ptr [0x52c680]                    # 004fa23b
    mov eax, dword ptr [ebp - local_4]           # 004fa241
    fild dword ptr [eax + field_1c]              # 004fa244
    fstp qword ptr [ebp - local_5c]              # 004fa247
    fadd qword ptr [ebp - local_5c]              # 004fa24a
    mov ecx, dword ptr [ebp + arg_c]             # 004fa24d
    fstp dword ptr [ecx + field_4]               # 004fa250
    jmp.d8 L_004fa261                            # 004fa253
L_004fa255:
    # block 0x004fa255: entered by je at 0x004fa224, 4 instruction(s), falls into the block at 0x004fa261
    mov edx, dword ptr [ebp - local_4]           # 004fa255
    fild dword ptr [edx + field_1c]              # 004fa258
    mov eax, dword ptr [ebp + arg_c]             # 004fa25b
    fstp dword ptr [eax + field_4]               # 004fa25e
L_004fa261:
    # block 0x004fa261: entered by jmp at 0x004fa253, 2 instruction(s), ends with je to 0x004fa296 (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 004fa261
    je.d8 L_004fa296                             # 004fa265
    # block 0x004fa267: entered by fall-through of je at 0x004fa265, 15 instruction(s), calls FUN_0050cd50, ends with forward jump to 0x004fa2a2
    call FUN_0050cd50                            # 004fa267
    cdq                                          # 004fa26c
    idiv dword ptr [ebp - local_8]               # 004fa26d
    mov dword ptr [ebp - local_60], edx          # 004fa270
    fild dword ptr [ebp - local_60]              # 004fa273
    fstp dword ptr [ebp - local_64]              # 004fa276
    fld dword ptr [ebp - local_64]               # 004fa279
    fdiv qword ptr [0x52c680]                    # 004fa27c
    mov ecx, dword ptr [ebp - local_4]           # 004fa282
    fild dword ptr [ecx + field_24]              # 004fa285
    fstp qword ptr [ebp - local_6c]              # 004fa288
    fadd qword ptr [ebp - local_6c]              # 004fa28b
    mov edx, dword ptr [ebp + arg_c]             # 004fa28e
    fstp dword ptr [edx + field_8]               # 004fa291
    jmp.d8 L_004fa2a2                            # 004fa294
L_004fa296:
    # block 0x004fa296: entered by je at 0x004fa265, 4 instruction(s), falls into the block at 0x004fa2a2
    mov eax, dword ptr [ebp - local_4]           # 004fa296
    fild dword ptr [eax + field_24]              # 004fa299
    mov ecx, dword ptr [ebp + arg_c]             # 004fa29c
    fstp dword ptr [ecx + field_8]               # 004fa29f
L_004fa2a2:
    # block 0x004fa2a2: entered by jmp at 0x004fa16a; jmp at 0x004fa294, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004fa2a2
    pop ebp                                      # 004fa2a4
    ret 0x8                                      # 004fa2a5

