# FUN_0044fc9b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044fc9b
# extent:       0x0044fc9b-0x0044ffa3 (776 code bytes)
# span:         0x0044fc9b-0x0044ffa3 (code 776, tables 0, padding 0)
# sha256:       afc773036fd730612564cd7a38100d9b6f551d42c1b987502d8ffd0ddbfe6855
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044fc9b
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       7 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c
# fields:       [eax + n] field_4, field_8, field_c, field_28, field_3c, field_44, field_94, field_c8, field_d8, field_dc, field_e0, field_e4 and 6 more; [ecx + n] field_4, field_8, field_c, field_24, field_3c, field_94, field_c8, field_d0, field_4e8, field_4ec, field_4f4, field_508 and 1 more; [edx + n] field_4, field_8, field_c, field_c0, field_c8, field_cc, field_d0, field_d4, field_4e4, field_4ec, field_50c
# callees:      calls KERNEL32.dll!GetTickCount, USER32.dll!GetAsyncKeyState, FUN_0050ce04
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 195 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_3c, 0x3c  # offset +0x3c
.equ field_44, 0x44  # offset +0x44
.equ field_94, 0x94  # offset +0x94
.equ field_c0, 0xc0  # offset +0xc0
.equ field_c8, 0xc8  # offset +0xc8
.equ field_cc, 0xcc  # offset +0xcc
.equ field_d0, 0xd0  # offset +0xd0
.equ field_d4, 0xd4  # offset +0xd4
.equ field_d8, 0xd8  # offset +0xd8
.equ field_dc, 0xdc  # offset +0xdc
.equ field_e0, 0xe0  # offset +0xe0
.equ field_e4, 0xe4  # offset +0xe4
.equ field_4e4, 0x4e4  # offset +0x4e4
.equ field_4e8, 0x4e8  # offset +0x4e8
.equ field_4ec, 0x4ec  # offset +0x4ec
.equ field_4f4, 0x4f4  # offset +0x4f4
.equ field_4f8, 0x4f8  # offset +0x4f8
.equ field_508, 0x508  # offset +0x508
.equ field_50c, 0x50c  # offset +0x50c

# --- external targets -----------------------------------------------
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x0044fc9b - 0x401000
.globl FUN_0044fc9b
FUN_0044fc9b:
    # block 0x0044fc9b: entry, 7 instruction(s), ends with jne to 0x0044fcb6 (forward)
    push ebp                                     # 0044fc9b
    {load} mov ebp, esp                          # 0044fc9c
    sub esp, 0x1c                                # 0044fc9e
    mov dword ptr [ebp - local_4], ecx           # 0044fca1
    mov eax, dword ptr [ebp - local_4]           # 0044fca4
    cmp dword ptr [eax + field_28], 0x0          # 0044fca7
    jne.d8 L_0044fcb6                            # 0044fcab
    # block 0x0044fcad: entered by fall-through of jne at 0x0044fcab, 3 instruction(s), ends with je to 0x0044fcbb (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0044fcad
    cmp dword ptr [ecx + field_24], 0x0          # 0044fcb0
    je.d8 L_0044fcbb                             # 0044fcb4
L_0044fcb6:
    # block 0x0044fcb6: entered by jne at 0x0044fcab; fall-through of je at 0x0044fcb4, 1 instruction(s), ends with forward jump to 0x0044ff9f
    jmp.d32 L_0044ff9f                           # 0044fcb6
L_0044fcbb:
    # block 0x0044fcbb: entered by je at 0x0044fcb4, 21 instruction(s), calls KERNEL32.dll!GetTickCount, USER32.dll!GetAsyncKeyState, ends with je to 0x0044fe3d (forward)
    call dword ptr [0x52a23c]                    # 0044fcbb
    mov edx, dword ptr [ebp - local_4]           # 0044fcc1
    mov dword ptr [edx + field_4e4], eax         # 0044fcc4
    mov eax, dword ptr [ebp - local_4]           # 0044fcca
    mov ecx, dword ptr [ebp - local_4]           # 0044fccd
    mov edx, dword ptr [eax + field_4e4]         # 0044fcd0
    sub edx, dword ptr [ecx + field_4e8]         # 0044fcd6
    mov eax, dword ptr [ebp - local_4]           # 0044fcdc
    mov dword ptr [eax + field_4ec], edx         # 0044fcdf
    mov ecx, dword ptr [ebp - local_4]           # 0044fce5
    mov edx, dword ptr [ebp - local_4]           # 0044fce8
    mov eax, dword ptr [edx + field_4e4]         # 0044fceb
    mov dword ptr [ecx + field_4e8], eax         # 0044fcf1
    mov ecx, dword ptr [ebp - local_4]           # 0044fcf7
    mov edx, dword ptr [ecx + field_4f4]         # 0044fcfa
    push edx                                     # 0044fd00
    call dword ptr [0x52a4b4]                    # 0044fd01
    movsx eax, ax                                # 0044fd07
    and eax, 0x8000                              # 0044fd0a
    test eax, eax                                # 0044fd0f
    je.d32 L_0044fe3d                            # 0044fd11
    # block 0x0044fd17: entered by fall-through of je at 0x0044fd11, 35 instruction(s), calls FUN_0050ce04, ends with jge to 0x0044fdbc (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0044fd17
    add ecx, 0xc8                                # 0044fd1a
    mov edx, dword ptr [ebp - local_4]           # 0044fd20
    add edx, 0xd8                                # 0044fd23
    mov eax, dword ptr [ecx]                     # 0044fd29
    mov dword ptr [edx], eax                     # 0044fd2b
    mov eax, dword ptr [ecx + field_4]           # 0044fd2d
    mov dword ptr [edx + field_4], eax           # 0044fd30
    mov eax, dword ptr [ecx + field_8]           # 0044fd33
    mov dword ptr [edx + field_8], eax           # 0044fd36
    mov ecx, dword ptr [ecx + field_c]           # 0044fd39
    mov dword ptr [edx + field_c], ecx           # 0044fd3c
    mov edx, dword ptr [ebp - local_4]           # 0044fd3f
    mov eax, dword ptr [edx + field_4ec]         # 0044fd42
    mov dword ptr [ebp - local_c], eax           # 0044fd48
    mov dword ptr [ebp - local_8], 0x0           # 0044fd4b
    fild qword ptr [ebp - local_c]               # 0044fd52
    fstp dword ptr [ebp - local_10]              # 0044fd55
    mov ecx, dword ptr [ebp - local_4]           # 0044fd58
    fld dword ptr [ebp - local_10]               # 0044fd5b
    fmul dword ptr [ecx + field_508]             # 0044fd5e
    mov edx, dword ptr [ebp - local_4]           # 0044fd64
    fsubr dword ptr [edx + field_50c]            # 0044fd67
    mov eax, dword ptr [ebp - local_4]           # 0044fd6d
    fstp dword ptr [eax + field_50c]             # 0044fd70
    mov ecx, dword ptr [ebp - local_4]           # 0044fd76
    fld dword ptr [ecx + field_50c]              # 0044fd79
    call FUN_0050ce04                            # 0044fd7f
    mov edx, dword ptr [ebp - local_4]           # 0044fd84
    mov dword ptr [edx + field_c8], eax          # 0044fd87
    mov eax, dword ptr [ebp - local_4]           # 0044fd8d
    mov ecx, dword ptr [ebp - local_4]           # 0044fd90
    mov edx, dword ptr [eax + field_c8]          # 0044fd93
    cmp edx, dword ptr [ecx + field_3c]          # 0044fd99
    jge.d8 L_0044fdbc                            # 0044fd9c
    # block 0x0044fd9e: entered by fall-through of jge at 0x0044fd9c, 8 instruction(s), falls into the block at 0x0044fdbc
    mov eax, dword ptr [ebp - local_4]           # 0044fd9e
    mov ecx, dword ptr [ebp - local_4]           # 0044fda1
    mov edx, dword ptr [ecx + field_3c]          # 0044fda4
    mov dword ptr [eax + field_c8], edx          # 0044fda7
    mov eax, dword ptr [ebp - local_4]           # 0044fdad
    fild dword ptr [eax + field_3c]              # 0044fdb0
    mov ecx, dword ptr [ebp - local_4]           # 0044fdb3
    fstp dword ptr [ecx + field_50c]             # 0044fdb6
L_0044fdbc:
    # block 0x0044fdbc: entered by jge at 0x0044fd9c, 12 instruction(s), ends with jne to 0x0044fe2b (forward)
    mov edx, dword ptr [ebp - local_4]           # 0044fdbc
    mov eax, dword ptr [edx + field_c8]          # 0044fdbf
    mov ecx, dword ptr [ebp - local_4]           # 0044fdc5
    mov edx, dword ptr [ecx + field_94]          # 0044fdc8
    lea eax, [eax + edx - field_minus_1]         # 0044fdce
    mov ecx, dword ptr [ebp - local_4]           # 0044fdd2
    mov dword ptr [ecx + field_d0], eax          # 0044fdd5
    mov edx, dword ptr [ebp - local_4]           # 0044fddb
    mov eax, dword ptr [ebp - local_4]           # 0044fdde
    mov ecx, dword ptr [edx + field_c8]          # 0044fde1
    cmp ecx, dword ptr [eax + field_d8]          # 0044fde7
    jne.d8 L_0044fe2b                            # 0044fded
    # block 0x0044fdef: entered by fall-through of jne at 0x0044fded, 5 instruction(s), ends with jne to 0x0044fe2b (forward)
    mov edx, dword ptr [ebp - local_4]           # 0044fdef
    mov eax, dword ptr [ebp - local_4]           # 0044fdf2
    mov ecx, dword ptr [edx + field_d0]          # 0044fdf5
    cmp ecx, dword ptr [eax + field_e0]          # 0044fdfb
    jne.d8 L_0044fe2b                            # 0044fe01
    # block 0x0044fe03: entered by fall-through of jne at 0x0044fe01, 5 instruction(s), ends with jne to 0x0044fe2b (forward)
    mov edx, dword ptr [ebp - local_4]           # 0044fe03
    mov eax, dword ptr [ebp - local_4]           # 0044fe06
    mov ecx, dword ptr [edx + field_cc]          # 0044fe09
    cmp ecx, dword ptr [eax + field_dc]          # 0044fe0f
    jne.d8 L_0044fe2b                            # 0044fe15
    # block 0x0044fe17: entered by fall-through of jne at 0x0044fe15, 5 instruction(s), ends with je to 0x0044fe38 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0044fe17
    mov eax, dword ptr [ebp - local_4]           # 0044fe1a
    mov ecx, dword ptr [edx + field_d4]          # 0044fe1d
    cmp ecx, dword ptr [eax + field_e4]          # 0044fe23
    je.d8 L_0044fe38                             # 0044fe29
L_0044fe2b:
    # block 0x0044fe2b: entered by jne at 0x0044fded; jne at 0x0044fe01; jne at 0x0044fe15; fall-through of je at 0x0044fe29, 2 instruction(s), falls into the block at 0x0044fe38
    mov edx, dword ptr [ebp - local_4]           # 0044fe2b
    mov dword ptr [edx + field_c0], 0x1          # 0044fe2e
L_0044fe38:
    # block 0x0044fe38: entered by je at 0x0044fe29, 1 instruction(s), ends with forward jump to 0x0044ff9f
    jmp.d32 L_0044ff9f                           # 0044fe38
L_0044fe3d:
    # block 0x0044fe3d: entered by je at 0x0044fd11, 8 instruction(s), calls USER32.dll!GetAsyncKeyState, ends with je to 0x0044ff9f (forward)
    mov eax, dword ptr [ebp - local_4]           # 0044fe3d
    mov ecx, dword ptr [eax + field_4f8]         # 0044fe40
    push ecx                                     # 0044fe46
    call dword ptr [0x52a4b4]                    # 0044fe47
    movsx edx, ax                                # 0044fe4d
    and edx, 0x8000                              # 0044fe50
    test edx, edx                                # 0044fe56
    je.d32 L_0044ff9f                            # 0044fe58
    # block 0x0044fe5e: entered by fall-through of je at 0x0044fe58, 42 instruction(s), calls FUN_0050ce04, ends with jle to 0x0044ff42 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0044fe5e
    add eax, 0xc8                                # 0044fe61
    mov ecx, dword ptr [ebp - local_4]           # 0044fe66
    add ecx, 0xd8                                # 0044fe69
    mov edx, dword ptr [eax]                     # 0044fe6f
    mov dword ptr [ecx], edx                     # 0044fe71
    mov edx, dword ptr [eax + field_4]           # 0044fe73
    mov dword ptr [ecx + field_4], edx           # 0044fe76
    mov edx, dword ptr [eax + field_8]           # 0044fe79
    mov dword ptr [ecx + field_8], edx           # 0044fe7c
    mov eax, dword ptr [eax + field_c]           # 0044fe7f
    mov dword ptr [ecx + field_c], eax           # 0044fe82
    mov ecx, dword ptr [ebp - local_4]           # 0044fe85
    mov edx, dword ptr [ecx + field_4ec]         # 0044fe88
    mov dword ptr [ebp - local_18], edx          # 0044fe8e
    mov dword ptr [ebp - local_14], 0x0          # 0044fe91
    fild qword ptr [ebp - local_18]              # 0044fe98
    fstp dword ptr [ebp - local_1c]              # 0044fe9b
    mov eax, dword ptr [ebp - local_4]           # 0044fe9e
    fld dword ptr [ebp - local_1c]               # 0044fea1
    fmul dword ptr [eax + field_508]             # 0044fea4
    mov ecx, dword ptr [ebp - local_4]           # 0044feaa
    fadd dword ptr [ecx + field_50c]             # 0044fead
    mov edx, dword ptr [ebp - local_4]           # 0044feb3
    fstp dword ptr [edx + field_50c]             # 0044feb6
    mov eax, dword ptr [ebp - local_4]           # 0044febc
    fld dword ptr [eax + field_50c]              # 0044febf
    call FUN_0050ce04                            # 0044fec5
    mov ecx, dword ptr [ebp - local_4]           # 0044feca
    mov dword ptr [ecx + field_c8], eax          # 0044fecd
    mov edx, dword ptr [ebp - local_4]           # 0044fed3
    mov eax, dword ptr [edx + field_c8]          # 0044fed6
    mov ecx, dword ptr [ebp - local_4]           # 0044fedc
    mov edx, dword ptr [ecx + field_94]          # 0044fedf
    lea eax, [eax + edx - field_minus_1]         # 0044fee5
    mov ecx, dword ptr [ebp - local_4]           # 0044fee9
    mov dword ptr [ecx + field_d0], eax          # 0044feec
    mov edx, dword ptr [ebp - local_4]           # 0044fef2
    mov eax, dword ptr [ebp - local_4]           # 0044fef5
    mov ecx, dword ptr [edx + field_d0]          # 0044fef8
    cmp ecx, dword ptr [eax + field_44]          # 0044fefe
    jle.d8 L_0044ff42                            # 0044ff01
    # block 0x0044ff03: entered by fall-through of jle at 0x0044ff01, 15 instruction(s), falls into the block at 0x0044ff42
    mov edx, dword ptr [ebp - local_4]           # 0044ff03
    mov eax, dword ptr [ebp - local_4]           # 0044ff06
    mov ecx, dword ptr [eax + field_44]          # 0044ff09
    mov dword ptr [edx + field_d0], ecx          # 0044ff0c
    mov edx, dword ptr [ebp - local_4]           # 0044ff12
    mov eax, dword ptr [ebp - local_4]           # 0044ff15
    mov ecx, dword ptr [edx + field_d0]          # 0044ff18
    sub ecx, dword ptr [eax + field_94]          # 0044ff1e
    add ecx, 0x1                                 # 0044ff24
    mov edx, dword ptr [ebp - local_4]           # 0044ff27
    mov dword ptr [edx + field_c8], ecx          # 0044ff2a
    mov eax, dword ptr [ebp - local_4]           # 0044ff30
    fild dword ptr [eax + field_c8]              # 0044ff33
    mov ecx, dword ptr [ebp - local_4]           # 0044ff39
    fstp dword ptr [ecx + field_50c]             # 0044ff3c
L_0044ff42:
    # block 0x0044ff42: entered by jle at 0x0044ff01, 5 instruction(s), ends with jne to 0x0044ff92 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0044ff42
    mov eax, dword ptr [ebp - local_4]           # 0044ff45
    mov ecx, dword ptr [edx + field_c8]          # 0044ff48
    cmp ecx, dword ptr [eax + field_d8]          # 0044ff4e
    jne.d8 L_0044ff92                            # 0044ff54
    # block 0x0044ff56: entered by fall-through of jne at 0x0044ff54, 5 instruction(s), ends with jne to 0x0044ff92 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0044ff56
    mov eax, dword ptr [ebp - local_4]           # 0044ff59
    mov ecx, dword ptr [edx + field_d0]          # 0044ff5c
    cmp ecx, dword ptr [eax + field_e0]          # 0044ff62
    jne.d8 L_0044ff92                            # 0044ff68
    # block 0x0044ff6a: entered by fall-through of jne at 0x0044ff68, 5 instruction(s), ends with jne to 0x0044ff92 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0044ff6a
    mov eax, dword ptr [ebp - local_4]           # 0044ff6d
    mov ecx, dword ptr [edx + field_cc]          # 0044ff70
    cmp ecx, dword ptr [eax + field_dc]          # 0044ff76
    jne.d8 L_0044ff92                            # 0044ff7c
    # block 0x0044ff7e: entered by fall-through of jne at 0x0044ff7c, 5 instruction(s), ends with je to 0x0044ff9f (forward)
    mov edx, dword ptr [ebp - local_4]           # 0044ff7e
    mov eax, dword ptr [ebp - local_4]           # 0044ff81
    mov ecx, dword ptr [edx + field_d4]          # 0044ff84
    cmp ecx, dword ptr [eax + field_e4]          # 0044ff8a
    je.d8 L_0044ff9f                             # 0044ff90
L_0044ff92:
    # block 0x0044ff92: entered by jne at 0x0044ff54; jne at 0x0044ff68; jne at 0x0044ff7c; fall-through of je at 0x0044ff90, 2 instruction(s), falls into the block at 0x0044ff9f
    mov edx, dword ptr [ebp - local_4]           # 0044ff92
    mov dword ptr [edx + field_c0], 0x1          # 0044ff95
L_0044ff9f:
    # block 0x0044ff9f: entered by jmp at 0x0044fcb6; jmp at 0x0044fe38; je at 0x0044fe58; je at 0x0044ff90, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0044ff9f
    pop ebp                                      # 0044ffa1
    ret                                          # 0044ffa2

