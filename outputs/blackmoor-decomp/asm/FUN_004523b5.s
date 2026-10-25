# FUN_004523b5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004523b5
# extent:       0x004523b5-0x004524a8 (243 code bytes)
# span:         0x004523b5-0x004524a8 (code 243, tables 0, padding 0)
# sha256:       7e7178faf6dccfb6a0723783c4113797ba51ab63427618e03739820de7d0010c
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004523b5
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       7 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c
# fields:       [eax + n] field_2a0, field_510; [ecx + n] field_40, field_ac, field_2a0, field_510; [edx + n] field_40, field_ac, field_510
# callees:      calls FUN_0050cd50
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 64 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_40, 0x40  # offset +0x40
.equ field_ac, 0xac  # offset +0xac
.equ field_2a0, 0x2a0  # offset +0x2a0
.equ field_510, 0x510  # offset +0x510

# --- external targets -----------------------------------------------
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x004523b5 - 0x401000
.globl FUN_004523b5
FUN_004523b5:
    # block 0x004523b5: entry, 6 instruction(s), falls into the block at 0x004523cc
    push ebp                                     # 004523b5
    {load} mov ebp, esp                          # 004523b6
    sub esp, 0x1c                                # 004523b8
    mov dword ptr [ebp - local_14], ecx          # 004523bb
    mov dword ptr [ebp - local_8], 0x0           # 004523be
    mov dword ptr [ebp - local_c], 0x0           # 004523c5
L_004523cc:
    # block 0x004523cc: entered by jmp at 0x0045249f, 2 instruction(s), ends with jne to 0x004524a4 (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 004523cc
    jne.d32 L_004524a4                           # 004523d0
    # block 0x004523d6: entered by fall-through of jne at 0x004523d0, 3 instruction(s), ends with forward jump to 0x004523fa
    mov eax, dword ptr [ebp - local_14]          # 004523d6
    mov dword ptr [eax + field_510], 0x0         # 004523d9
    jmp.d8 L_004523fa                            # 004523e3
L_004523e5:
    # block 0x004523e5: entered by jmp at 0x00452468, 5 instruction(s), falls into the block at 0x004523fa
    mov ecx, dword ptr [ebp - local_14]          # 004523e5
    mov edx, dword ptr [ecx + field_510]         # 004523e8
    add edx, 0x1                                 # 004523ee
    mov eax, dword ptr [ebp - local_14]          # 004523f1
    mov dword ptr [eax + field_510], edx         # 004523f4
L_004523fa:
    # block 0x004523fa: entered by jmp at 0x004523e3, 5 instruction(s), ends with jge to 0x0045246d (forward)
    mov ecx, dword ptr [ebp - local_14]          # 004523fa
    mov edx, dword ptr [ebp - local_14]          # 004523fd
    mov eax, dword ptr [ecx + field_510]         # 00452400
    cmp eax, dword ptr [edx + field_ac]          # 00452406
    jge.d8 L_0045246d                            # 0045240c
    # block 0x0045240e: entered by fall-through of jge at 0x0045240c, 7 instruction(s), calls FUN_0050cd50, ends with jne to 0x00452443 (forward)
    call FUN_0050cd50                            # 0045240e
    cdq                                          # 00452413
    mov ecx, 0x5                                 # 00452414
    idiv ecx                                     # 00452419
    mov dword ptr [ebp - local_10], edx          # 0045241b
    cmp dword ptr [ebp - local_10], 0x4          # 0045241e
    jne.d8 L_00452443                            # 00452422
    # block 0x00452424: entered by fall-through of jne at 0x00452422, 7 instruction(s), ends with forward jump to 0x00452468
    mov edx, dword ptr [ebp - local_14]          # 00452424
    mov eax, dword ptr [edx + field_510]         # 00452427
    imul eax, eax, 0x5c                          # 0045242d
    mov ecx, dword ptr [ebp - local_14]          # 00452430
    mov edx, dword ptr [ecx + field_2a0]         # 00452433
    mov dword ptr [edx + eax + field_40], 0xffffffff # 00452439
    jmp.d8 L_00452468                            # 00452441
L_00452443:
    # block 0x00452443: entered by jne at 0x00452422, 10 instruction(s), falls into the block at 0x00452468
    mov eax, dword ptr [ebp - local_c]           # 00452443
    add eax, 0x1                                 # 00452446
    mov dword ptr [ebp - local_c], eax           # 00452449
    mov ecx, dword ptr [ebp - local_14]          # 0045244c
    mov edx, dword ptr [ecx + field_510]         # 0045244f
    imul edx, edx, 0x5c                          # 00452455
    mov eax, dword ptr [ebp - local_14]          # 00452458
    mov ecx, dword ptr [eax + field_2a0]         # 0045245b
    mov eax, dword ptr [ebp - local_10]          # 00452461
    mov dword ptr [ecx + edx + field_40], eax    # 00452464
L_00452468:
    # block 0x00452468: entered by jmp at 0x00452441, 1 instruction(s), ends with backward jump to 0x004523e5
    jmp.d32 L_004523e5                           # 00452468
L_0045246d:
    # block 0x0045246d: entered by jge at 0x0045240c, 13 instruction(s), ends with jne to 0x0045249f (forward)
    fild dword ptr [ebp - local_c]               # 0045246d
    fstp dword ptr [ebp - local_18]              # 00452470
    mov ecx, dword ptr [ebp - local_14]          # 00452473
    fild dword ptr [ecx + field_ac]              # 00452476
    fstp dword ptr [ebp - local_1c]              # 0045247c
    fld dword ptr [ebp - local_18]               # 0045247f
    fdiv dword ptr [ebp - local_1c]              # 00452482
    fstp dword ptr [ebp - local_4]               # 00452485
    fld dword ptr [ebp - local_4]                # 00452488
    fcomp dword ptr [0x52cd14]                   # 0045248b
    fnstsw ax                                    # 00452491
    test ah, 0x1                                 # 00452493
    jne.d8 L_0045249f                            # 00452496
    # block 0x00452498: entered by fall-through of jne at 0x00452496, 1 instruction(s), falls into the block at 0x0045249f
    mov dword ptr [ebp - local_8], 0x1           # 00452498
L_0045249f:
    # block 0x0045249f: entered by jne at 0x00452496, 1 instruction(s), ends with backward jump to 0x004523cc
    jmp.d32 L_004523cc                           # 0045249f
L_004524a4:
    # block 0x004524a4: entered by jne at 0x004523d0, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004524a4
    pop ebp                                      # 004524a6
    ret                                          # 004524a7

