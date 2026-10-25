# FUN_0045133d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045133d
# extent:       0x0045133d-0x0045150e (465 code bytes)
# span:         0x0045133d-0x0045150e (code 465, tables 0, padding 0)
# sha256:       4bc8969fa367cb39348d124627e96dea6dedda40917e938bd19dd92945b85126
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0045133d
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_4, field_e8, field_ec, field_184, field_51c; [ecx + n] field_c, field_10, field_94, field_e8, field_ec, field_118, field_16c; [edx + n] field_94, field_c8, field_e8, field_ec, field_188, field_51c
# callees:      calls FUN_0044c223, FUN_0044bf4b
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m4511d2_lifted (function ledger class candidate_port; also m45133d_lifted; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 123 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_94, 0x94  # offset +0x94
.equ field_c8, 0xc8  # offset +0xc8
.equ field_e8, 0xe8  # offset +0xe8
.equ field_ec, 0xec  # offset +0xec
.equ field_118, 0x118  # offset +0x118
.equ field_16c, 0x16c  # offset +0x16c
.equ field_184, 0x184  # offset +0x184
.equ field_188, 0x188  # offset +0x188
.equ field_51c, 0x51c  # offset +0x51c

# --- external targets -----------------------------------------------
.set FUN_0044bf4b, .text + (0x0044bf4b - 0x401000)
.set FUN_0044c223, .text + (0x0044c223 - 0x401000)

.org 0x0045133d - 0x401000
.globl FUN_0045133d
FUN_0045133d:
    # block 0x0045133d: entry, 11 instruction(s), ends with je to 0x00451382 (forward)
    push ebp                                     # 0045133d
    {load} mov ebp, esp                          # 0045133e
    sub esp, 0x10                                # 00451340
    mov dword ptr [ebp - local_c], ecx           # 00451343
    mov dword ptr [ebp - local_8], 0xffffffff    # 00451346
    mov eax, dword ptr [ebp - local_c]           # 0045134d
    fld dword ptr [eax + field_e8]               # 00451350
    fcomp qword ptr [0x52c7b0]                   # 00451356
    fnstsw ax                                    # 0045135c
    test ah, 0x1                                 # 0045135e
    je.d8 L_00451382                             # 00451361
    # block 0x00451363: entered by fall-through of je at 0x00451361, 6 instruction(s), ends with je to 0x00451382 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00451363
    fld dword ptr [ecx + field_ec]               # 00451366
    fcomp qword ptr [0x52c7b0]                   # 0045136c
    fnstsw ax                                    # 00451372
    test ah, 0x1                                 # 00451374
    je.d8 L_00451382                             # 00451377
    # block 0x00451379: entered by fall-through of je at 0x00451377, 2 instruction(s), ends with forward jump to 0x004513b5
    mov dword ptr [ebp - local_8], 0x1           # 00451379
    jmp.d8 L_004513b5                            # 00451380
L_00451382:
    # block 0x00451382: entered by je at 0x00451361; je at 0x00451377, 6 instruction(s), ends with jne to 0x004513b5 (forward)
    mov edx, dword ptr [ebp - local_c]           # 00451382
    fld dword ptr [edx + field_e8]               # 00451385
    fcomp qword ptr [0x52c7b0]                   # 0045138b
    fnstsw ax                                    # 00451391
    test ah, 0x41                                # 00451393
    jne.d8 L_004513b5                            # 00451396
    # block 0x00451398: entered by fall-through of jne at 0x00451396, 6 instruction(s), ends with je to 0x004513b5 (forward)
    mov eax, dword ptr [ebp - local_c]           # 00451398
    fld dword ptr [eax + field_ec]               # 0045139b
    fcomp qword ptr [0x52c7b0]                   # 004513a1
    fnstsw ax                                    # 004513a7
    test ah, 0x1                                 # 004513a9
    je.d8 L_004513b5                             # 004513ac
    # block 0x004513ae: entered by fall-through of je at 0x004513ac, 1 instruction(s), falls into the block at 0x004513b5
    mov dword ptr [ebp - local_8], 0x0           # 004513ae
L_004513b5:
    # block 0x004513b5: entered by jmp at 0x00451380; jne at 0x00451396; je at 0x004513ac, 9 instruction(s), ends with jge to 0x004513e2 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004513b5
    mov edx, dword ptr [ebp - local_c]           # 004513b8
    mov eax, dword ptr [ecx + field_118]         # 004513bb
    sub eax, dword ptr [edx + field_c8]          # 004513c1
    mov ecx, dword ptr [ebp - local_c]           # 004513c7
    add eax, dword ptr [ecx + field_16c]         # 004513ca
    mov dword ptr [ebp - local_4], eax           # 004513d0
    cmp dword ptr [ebp - local_4], 0x0           # 004513d3
    jge.d8 L_004513e2                            # 004513d7
    # block 0x004513d9: entered by fall-through of jge at 0x004513d7, 2 instruction(s), ends with forward jump to 0x004513ff
    mov dword ptr [ebp - local_4], 0x0           # 004513d9
    jmp.d8 L_004513ff                            # 004513e0
L_004513e2:
    # block 0x004513e2: entered by jge at 0x004513d7, 4 instruction(s), ends with jle to 0x004513ff (forward)
    mov edx, dword ptr [ebp - local_c]           # 004513e2
    mov eax, dword ptr [ebp - local_4]           # 004513e5
    cmp eax, dword ptr [edx + field_94]          # 004513e8
    jle.d8 L_004513ff                            # 004513ee
    # block 0x004513f0: entered by fall-through of jle at 0x004513ee, 4 instruction(s), falls into the block at 0x004513ff
    mov ecx, dword ptr [ebp - local_c]           # 004513f0
    mov edx, dword ptr [ecx + field_94]          # 004513f3
    sub edx, 0x1                                 # 004513f9
    mov dword ptr [ebp - local_4], edx           # 004513fc
L_004513ff:
    # block 0x004513ff: entered by jmp at 0x004513e0; jle at 0x004513ee, 19 instruction(s), calls FUN_0044c223, ends with je to 0x0045144d (forward)
    push 0x1                                     # 004513ff
    mov eax, dword ptr [ebp - local_c]           # 00451401
    mov ecx, dword ptr [eax + field_184]         # 00451404
    imul ecx, ecx, 0xc                           # 0045140a
    mov edx, dword ptr [ebp - local_c]           # 0045140d
    lea eax, [edx + ecx + field_188]             # 00451410
    push eax                                     # 00451417
    mov ecx, dword ptr [ebp - local_c]           # 00451418
    add ecx, 0xe8                                # 0045141b
    push ecx                                     # 00451421
    mov edx, dword ptr [ebp - local_c]           # 00451422
    add edx, 0xe8                                # 00451425
    push edx                                     # 0045142b
    mov ecx, 0x61f860                            # 0045142c
    call FUN_0044c223                            # 00451431
    mov eax, dword ptr [ebp - local_8]           # 00451436
    mov dword ptr [ebp - local_10], eax          # 00451439
    cmp dword ptr [ebp - local_10], 0x0          # 0045143c
    je.d8 L_0045144d                             # 00451440
    # block 0x00451442: entered by fall-through of je at 0x00451440, 2 instruction(s), ends with je to 0x004514ac (forward)
    cmp dword ptr [ebp - local_10], 0x1          # 00451442
    je.d8 L_004514ac                             # 00451446
    # block 0x00451448: entered by fall-through of je at 0x00451446, 1 instruction(s), ends with forward jump to 0x0045150a
    jmp.d32 L_0045150a                           # 00451448
L_0045144d:
    # block 0x0045144d: entered by je at 0x00451440, 24 instruction(s), calls FUN_0044bf4b, ends with forward jump to 0x0045150a
    mov ecx, dword ptr [ebp - local_4]           # 0045144d
    imul ecx, ecx, 0x18                          # 00451450
    mov edx, dword ptr [ebp - local_c]           # 00451453
    mov eax, dword ptr [edx + field_51c]         # 00451456
    mov edx, dword ptr [ebp - local_c]           # 0045145c
    fld dword ptr [edx + field_e8]               # 0045145f
    fadd dword ptr [eax + ecx]                   # 00451465
    mov eax, dword ptr [ebp - local_c]           # 00451468
    fstp dword ptr [eax + field_e8]              # 0045146b
    mov ecx, dword ptr [ebp - local_4]           # 00451471
    imul ecx, ecx, 0x18                          # 00451474
    mov edx, dword ptr [ebp - local_c]           # 00451477
    mov eax, dword ptr [edx + field_51c]         # 0045147a
    mov edx, dword ptr [ebp - local_c]           # 00451480
    fld dword ptr [edx + field_ec]               # 00451483
    fadd dword ptr [eax + ecx + field_4]         # 00451489
    mov eax, dword ptr [ebp - local_c]           # 0045148d
    fstp dword ptr [eax + field_ec]              # 00451490
    mov ecx, dword ptr [ebp - local_c]           # 00451496
    add ecx, 0xe8                                # 00451499
    push ecx                                     # 0045149f
    mov ecx, 0x61f860                            # 004514a0
    call FUN_0044bf4b                            # 004514a5
    jmp.d8 L_0045150a                            # 004514aa
L_004514ac:
    # block 0x004514ac: entered by je at 0x00451446, 23 instruction(s), calls FUN_0044bf4b, falls into the block at 0x0045150a
    mov edx, dword ptr [ebp - local_4]           # 004514ac
    imul edx, edx, 0x18                          # 004514af
    mov eax, dword ptr [ebp - local_c]           # 004514b2
    mov ecx, dword ptr [eax + field_51c]         # 004514b5
    mov eax, dword ptr [ebp - local_c]           # 004514bb
    fld dword ptr [eax + field_e8]               # 004514be
    fadd dword ptr [ecx + edx + field_c]         # 004514c4
    mov ecx, dword ptr [ebp - local_c]           # 004514c8
    fstp dword ptr [ecx + field_e8]              # 004514cb
    mov edx, dword ptr [ebp - local_4]           # 004514d1
    imul edx, edx, 0x18                          # 004514d4
    mov eax, dword ptr [ebp - local_c]           # 004514d7
    mov ecx, dword ptr [eax + field_51c]         # 004514da
    mov eax, dword ptr [ebp - local_c]           # 004514e0
    fld dword ptr [eax + field_ec]               # 004514e3
    fadd dword ptr [ecx + edx + field_10]        # 004514e9
    mov ecx, dword ptr [ebp - local_c]           # 004514ed
    fstp dword ptr [ecx + field_ec]              # 004514f0
    mov edx, dword ptr [ebp - local_c]           # 004514f6
    add edx, 0xe8                                # 004514f9
    push edx                                     # 004514ff
    mov ecx, 0x61f860                            # 00451500
    call FUN_0044bf4b                            # 00451505
L_0045150a:
    # block 0x0045150a: entered by jmp at 0x00451448; jmp at 0x004514aa, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0045150a
    pop ebp                                      # 0045150c
    ret                                          # 0045150d

