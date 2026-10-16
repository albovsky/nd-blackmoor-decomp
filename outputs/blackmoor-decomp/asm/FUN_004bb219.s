# FUN_004bb219
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bb219
# extent:       0x004bb219-0x004bb336 (285 code bytes)
# span:         0x004bb219-0x004bb336 (code 285, tables 0, padding 0)
# sha256:       79c114ff0efdb406765e18c288d531414c34ead631e221c8b3435127cf8fc983
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004bb219
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_20, field_200, field_2c4, field_2c8, field_8e8; [ecx + n] field_48, field_200, field_208, field_2c4, field_2d8; [edx + n] field_18, field_200, field_204, field_2c4, field_2c8, field_2cc
# callees:      calls KERNEL32.dll!GetTickCount, FUN_004be410, FUN_004be48a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 68 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_18, 0x18  # offset +0x18
.equ field_20, 0x20  # offset +0x20
.equ field_48, 0x48  # offset +0x48
.equ field_200, 0x200  # offset +0x200
.equ field_204, 0x204  # offset +0x204
.equ field_208, 0x208  # offset +0x208
.equ field_2c4, 0x2c4  # offset +0x2c4
.equ field_2c8, 0x2c8  # offset +0x2c8
.equ field_2cc, 0x2cc  # offset +0x2cc
.equ field_2d8, 0x2d8  # offset +0x2d8
.equ field_8e8, 0x8e8  # offset +0x8e8

# --- external targets -----------------------------------------------
.set FUN_004be410, .text + (0x004be410 - 0x401000)
.set FUN_004be48a, .text + (0x004be48a - 0x401000)

.org 0x004bb219 - 0x401000
.globl FUN_004bb219
FUN_004bb219:
    # block 0x004bb219: entry, 10 instruction(s), calls KERNEL32.dll!GetTickCount, ends with je to 0x004bb332 (forward)
    push ebp                                     # 004bb219
    {load} mov ebp, esp                          # 004bb21a
    sub esp, 0x10                                # 004bb21c
    mov dword ptr [ebp - local_4], ecx           # 004bb21f
    call dword ptr [0x52a23c]                    # 004bb222
    mov ecx, dword ptr [ebp - local_4]           # 004bb228
    mov dword ptr [ecx + field_2d8], eax         # 004bb22b
    mov edx, dword ptr [ebp - local_4]           # 004bb231
    cmp dword ptr [edx + field_2cc], 0x0         # 004bb234
    je.d32 L_004bb332                            # 004bb23b
    # block 0x004bb241: entered by fall-through of je at 0x004bb23b, 3 instruction(s), ends with jne to 0x004bb332 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004bb241
    cmp dword ptr [eax + field_20], 0x0          # 004bb244
    jne.d32 L_004bb332                           # 004bb248
    # block 0x004bb24e: entered by fall-through of jne at 0x004bb248, 5 instruction(s), ends with jbe to 0x004bb2d2 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004bb24e
    mov edx, dword ptr [ebp - local_4]           # 004bb251
    mov eax, dword ptr [ecx + field_2d8]         # 004bb254
    cmp eax, dword ptr [edx + field_2c8]         # 004bb25a
    jbe.d8 L_004bb2d2                            # 004bb260
    # block 0x004bb262: entered by fall-through of jbe at 0x004bb260, 8 instruction(s), ends with jl to 0x004bb2ac (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004bb262
    mov edx, dword ptr [ecx + field_2c4]         # 004bb265
    add edx, 0x1                                 # 004bb26b
    mov eax, dword ptr [ebp - local_4]           # 004bb26e
    mov dword ptr [eax + field_2c4], edx         # 004bb271
    mov ecx, dword ptr [ebp - local_4]           # 004bb277
    cmp dword ptr [ecx + field_2c4], 0x9         # 004bb27a
    jl.d8 L_004bb2ac                             # 004bb281
    # block 0x004bb283: entered by fall-through of jl at 0x004bb281, 8 instruction(s), calls FUN_004be410, falls into the block at 0x004bb2ac
    mov edx, dword ptr [ebp - local_4]           # 004bb283
    mov dword ptr [edx + field_2c4], 0x8         # 004bb286
    mov eax, dword ptr [ebp - local_4]           # 004bb290
    mov dword ptr [eax + field_20], 0x3          # 004bb293
    mov ecx, dword ptr [ebp - local_4]           # 004bb29a
    mov dword ptr [ecx + field_48], 0x1          # 004bb29d
    mov ecx, dword ptr [ebp - local_4]           # 004bb2a4
    call FUN_004be410                            # 004bb2a7
L_004bb2ac:
    # block 0x004bb2ac: entered by jl at 0x004bb281, 9 instruction(s), calls FUN_004be48a, falls into the block at 0x004bb2d2
    mov edx, dword ptr [ebp - local_4]           # 004bb2ac
    mov eax, dword ptr [edx + field_18]          # 004bb2af
    mov ecx, dword ptr [ebp - local_4]           # 004bb2b2
    mov edx, dword ptr [ecx + field_2d8]         # 004bb2b5
    add edx, dword ptr [eax + field_8e8]         # 004bb2bb
    mov eax, dword ptr [ebp - local_4]           # 004bb2c1
    mov dword ptr [eax + field_2c8], edx         # 004bb2c4
    mov ecx, dword ptr [ebp - local_4]           # 004bb2ca
    call FUN_004be48a                            # 004bb2cd
L_004bb2d2:
    # block 0x004bb2d2: entered by jbe at 0x004bb260, 20 instruction(s), ends with je to 0x004bb332 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004bb2d2
    mov edx, dword ptr [ebp - local_4]           # 004bb2d5
    mov eax, dword ptr [ecx + field_2d8]         # 004bb2d8
    sub eax, dword ptr [edx + field_204]         # 004bb2de
    mov dword ptr [ebp - local_c], eax           # 004bb2e4
    mov dword ptr [ebp - local_8], 0x0           # 004bb2e7
    fild qword ptr [ebp - local_c]               # 004bb2ee
    fstp dword ptr [ebp - local_10]              # 004bb2f1
    fld dword ptr [ebp - local_10]               # 004bb2f4
    mov ecx, dword ptr [ebp - local_4]           # 004bb2f7
    fmul dword ptr [ecx + field_208]             # 004bb2fa
    fadd qword ptr [0x52c598]                    # 004bb300
    mov edx, dword ptr [ebp - local_4]           # 004bb306
    fstp dword ptr [edx + field_200]             # 004bb309
    mov eax, dword ptr [ebp - local_4]           # 004bb30f
    fld dword ptr [eax + field_200]              # 004bb312
    fcomp qword ptr [0x52c598]                   # 004bb318
    fnstsw ax                                    # 004bb31e
    test ah, 0x1                                 # 004bb320
    je.d8 L_004bb332                             # 004bb323
    # block 0x004bb325: entered by fall-through of je at 0x004bb323, 2 instruction(s), falls into the block at 0x004bb332
    mov ecx, dword ptr [ebp - local_4]           # 004bb325
    mov dword ptr [ecx + field_200], 0x3f800000  # 004bb328
L_004bb332:
    # block 0x004bb332: entered by je at 0x004bb23b; jne at 0x004bb248; je at 0x004bb323, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004bb332
    pop ebp                                      # 004bb334
    ret                                          # 004bb335

