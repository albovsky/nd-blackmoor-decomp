# FUN_004fc077
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fc077
# extent:       0x004fc077-0x004fc341 (714 code bytes)
# span:         0x004fc077-0x004fc341 (code 714, tables 0, padding 0)
# sha256:       01fbea8a5ae49d6939c9a26c3169a5b62019eda112d423fcad194ddfd6d96434
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fc077
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       18 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 6 more
# fields:       [eax + n] field_21, field_23, field_2f, field_134, field_13c, field_16a; [ecx + n] field_29, field_132, field_138, field_13c; [edx + n] field_25, field_2d, field_130, field_138
# callees:      calls FUN_004fc62d
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 170 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ arg_8, 0x8  # offset +0x8
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_25, 0x25  # offset +0x25
.equ field_29, 0x29  # offset +0x29
.equ field_2d, 0x2d  # offset +0x2d
.equ field_2f, 0x2f  # offset +0x2f
.equ field_130, 0x130  # offset +0x130
.equ field_132, 0x132  # offset +0x132
.equ field_134, 0x134  # offset +0x134
.equ field_138, 0x138  # offset +0x138
.equ field_13c, 0x13c  # offset +0x13c
.equ field_16a, 0x16a  # offset +0x16a

# --- external targets -----------------------------------------------
.set FUN_004fc62d, .text + (0x004fc62d - 0x401000)

.org 0x004fc077 - 0x401000
.globl FUN_004fc077
FUN_004fc077:
    # block 0x004fc077: entry, 66 instruction(s), ends with je to 0x004fc1a9 (forward)
    push ebp                                     # 004fc077
    {load} mov ebp, esp                          # 004fc078
    sub esp, 0x48                                # 004fc07a
    mov dword ptr [ebp - local_8], ecx           # 004fc07d
    mov eax, dword ptr [ebp + arg_8]             # 004fc080
    mov cx, word ptr [eax + field_21]            # 004fc083
    mov word ptr [ebp - local_4], cx             # 004fc087
    mov edx, dword ptr [ebp - local_4]           # 004fc08b
    and edx, 0xffff                              # 004fc08e
    imul edx, edx, 0x5bb                         # 004fc094
    mov eax, dword ptr [ebp - local_8]           # 004fc09a
    mov ecx, dword ptr [ebp + arg_8]             # 004fc09d
    mov ecx, dword ptr [ecx + field_29]          # 004fc0a0
    mov dword ptr [eax + edx + field_134], ecx   # 004fc0a3
    mov edx, dword ptr [ebp + arg_8]             # 004fc0aa
    movsx eax, word ptr [edx + field_2d]         # 004fc0ad
    mov dword ptr [ebp - local_c], eax           # 004fc0b1
    fild dword ptr [ebp - local_c]               # 004fc0b4
    fstp dword ptr [ebp - local_10]              # 004fc0b7
    fld dword ptr [ebp - local_10]               # 004fc0ba
    fdiv dword ptr [0x52cbec]                    # 004fc0bd
    mov ecx, dword ptr [ebp - local_4]           # 004fc0c3
    and ecx, 0xffff                              # 004fc0c6
    imul ecx, ecx, 0x5bb                         # 004fc0cc
    mov edx, dword ptr [ebp - local_8]           # 004fc0d2
    fstp dword ptr [edx + ecx + field_138]       # 004fc0d5
    mov eax, dword ptr [ebp + arg_8]             # 004fc0dc
    movsx ecx, word ptr [eax + field_2f]         # 004fc0df
    mov dword ptr [ebp - local_14], ecx          # 004fc0e3
    fild dword ptr [ebp - local_14]              # 004fc0e6
    fstp dword ptr [ebp - local_18]              # 004fc0e9
    fld dword ptr [ebp - local_18]               # 004fc0ec
    fdiv dword ptr [0x52cbec]                    # 004fc0ef
    mov edx, dword ptr [ebp - local_4]           # 004fc0f5
    and edx, 0xffff                              # 004fc0f8
    imul edx, edx, 0x5bb                         # 004fc0fe
    mov eax, dword ptr [ebp - local_8]           # 004fc104
    fstp dword ptr [eax + edx + field_13c]       # 004fc107
    mov ecx, dword ptr [ebp - local_4]           # 004fc10e
    and ecx, 0xffff                              # 004fc111
    imul ecx, ecx, 0x5bb                         # 004fc117
    mov edx, dword ptr [ebp - local_8]           # 004fc11d
    mov word ptr [edx + ecx + field_130], 0x1    # 004fc120
    mov eax, dword ptr [ebp - local_4]           # 004fc12a
    and eax, 0xffff                              # 004fc12d
    imul eax, eax, 0x5bb                         # 004fc132
    mov ecx, dword ptr [ebp - local_8]           # 004fc138
    mov word ptr [ecx + eax + field_132], 0x0    # 004fc13b
    mov edx, dword ptr [ebp + arg_8]             # 004fc145
    movsx eax, word ptr [edx + field_25]         # 004fc148
    {load} xor ecx, ecx                          # 004fc14c
    cmp eax, 0x2                                 # 004fc14e
    sete cl                                      # 004fc151
    mov edx, dword ptr [ebp - local_4]           # 004fc154
    and edx, 0xffff                              # 004fc157
    imul edx, edx, 0x5bb                         # 004fc15d
    mov eax, dword ptr [ebp - local_8]           # 004fc163
    mov dword ptr [eax + edx + field_16a], ecx   # 004fc166
    mov ecx, dword ptr [ebp - local_4]           # 004fc16d
    and ecx, 0xffff                              # 004fc170
    imul ecx, ecx, 0x5bb                         # 004fc176
    fld dword ptr [ecx + 0x5c3b9f]               # 004fc17c
    fcomp qword ptr [0x52c598]                   # 004fc182
    fnstsw ax                                    # 004fc188
    test ah, 0x1                                 # 004fc18a
    je.d8 L_004fc1a9                             # 004fc18d
    # block 0x004fc18f: entered by fall-through of je at 0x004fc18d, 6 instruction(s), ends with forward jump to 0x004fc1b7
    mov edx, dword ptr [ebp - local_4]           # 004fc18f
    and edx, 0xffff                              # 004fc192
    imul edx, edx, 0x5bb                         # 004fc198
    fld dword ptr [edx + 0x5c3b9f]               # 004fc19e
    fstp qword ptr [ebp - local_20]              # 004fc1a4
    jmp.d8 L_004fc1b7                            # 004fc1a7
L_004fc1a9:
    # block 0x004fc1a9: entered by je at 0x004fc18d, 2 instruction(s), falls into the block at 0x004fc1b7
    mov dword ptr [ebp - local_20], 0x0          # 004fc1a9
    mov dword ptr [ebp - local_1c], 0x3ff00000   # 004fc1b0
L_004fc1b7:
    # block 0x004fc1b7: entered by jmp at 0x004fc1a7, 16 instruction(s), ends with jne to 0x004fc213 (forward)
    fld qword ptr [ebp - local_20]               # 004fc1b7
    fstp dword ptr [ebp - local_24]              # 004fc1ba
    fld dword ptr [ebp - local_24]               # 004fc1bd
    mov eax, dword ptr [ebp - local_4]           # 004fc1c0
    and eax, 0xffff                              # 004fc1c3
    imul eax, eax, 0x5bb                         # 004fc1c8
    mov ecx, dword ptr [ebp - local_8]           # 004fc1ce
    fstp dword ptr [ecx + eax + field_138]       # 004fc1d1
    mov edx, dword ptr [ebp - local_4]           # 004fc1d8
    and edx, 0xffff                              # 004fc1db
    imul edx, edx, 0x5bb                         # 004fc1e1
    fld dword ptr [edx + 0x5c3b9f]               # 004fc1e7
    fcomp qword ptr [0x52c7b0]                   # 004fc1ed
    fnstsw ax                                    # 004fc1f3
    test ah, 0x41                                # 004fc1f5
    jne.d8 L_004fc213                            # 004fc1f8
    # block 0x004fc1fa: entered by fall-through of jne at 0x004fc1f8, 6 instruction(s), ends with forward jump to 0x004fc221
    mov eax, dword ptr [ebp - local_4]           # 004fc1fa
    and eax, 0xffff                              # 004fc1fd
    imul eax, eax, 0x5bb                         # 004fc202
    fld dword ptr [eax + 0x5c3b9f]               # 004fc208
    fstp qword ptr [ebp - local_2c]              # 004fc20e
    jmp.d8 L_004fc221                            # 004fc211
L_004fc213:
    # block 0x004fc213: entered by jne at 0x004fc1f8, 2 instruction(s), falls into the block at 0x004fc221
    mov dword ptr [ebp - local_2c], 0x0          # 004fc213
    mov dword ptr [ebp - local_28], 0x0          # 004fc21a
L_004fc221:
    # block 0x004fc221: entered by jmp at 0x004fc211, 16 instruction(s), ends with je to 0x004fc27e (forward)
    fld qword ptr [ebp - local_2c]               # 004fc221
    fstp dword ptr [ebp - local_30]              # 004fc224
    fld dword ptr [ebp - local_30]               # 004fc227
    mov ecx, dword ptr [ebp - local_4]           # 004fc22a
    and ecx, 0xffff                              # 004fc22d
    imul ecx, ecx, 0x5bb                         # 004fc233
    mov edx, dword ptr [ebp - local_8]           # 004fc239
    fstp dword ptr [edx + ecx + field_138]       # 004fc23c
    mov eax, dword ptr [ebp - local_4]           # 004fc243
    and eax, 0xffff                              # 004fc246
    imul eax, eax, 0x5bb                         # 004fc24b
    fld dword ptr [eax + 0x5c3ba3]               # 004fc251
    fcomp qword ptr [0x52c598]                   # 004fc257
    fnstsw ax                                    # 004fc25d
    test ah, 0x1                                 # 004fc25f
    je.d8 L_004fc27e                             # 004fc262
    # block 0x004fc264: entered by fall-through of je at 0x004fc262, 6 instruction(s), ends with forward jump to 0x004fc28c
    mov ecx, dword ptr [ebp - local_4]           # 004fc264
    and ecx, 0xffff                              # 004fc267
    imul ecx, ecx, 0x5bb                         # 004fc26d
    fld dword ptr [ecx + 0x5c3ba3]               # 004fc273
    fstp qword ptr [ebp - local_38]              # 004fc279
    jmp.d8 L_004fc28c                            # 004fc27c
L_004fc27e:
    # block 0x004fc27e: entered by je at 0x004fc262, 2 instruction(s), falls into the block at 0x004fc28c
    mov dword ptr [ebp - local_38], 0x0          # 004fc27e
    mov dword ptr [ebp - local_34], 0x3ff00000   # 004fc285
L_004fc28c:
    # block 0x004fc28c: entered by jmp at 0x004fc27c, 16 instruction(s), ends with jne to 0x004fc2ea (forward)
    fld qword ptr [ebp - local_38]               # 004fc28c
    fstp dword ptr [ebp - local_3c]              # 004fc28f
    fld dword ptr [ebp - local_3c]               # 004fc292
    mov edx, dword ptr [ebp - local_4]           # 004fc295
    and edx, 0xffff                              # 004fc298
    imul edx, edx, 0x5bb                         # 004fc29e
    mov eax, dword ptr [ebp - local_8]           # 004fc2a4
    fstp dword ptr [eax + edx + field_13c]       # 004fc2a7
    mov ecx, dword ptr [ebp - local_4]           # 004fc2ae
    and ecx, 0xffff                              # 004fc2b1
    imul ecx, ecx, 0x5bb                         # 004fc2b7
    fld dword ptr [ecx + 0x5c3ba3]               # 004fc2bd
    fcomp qword ptr [0x52c7b0]                   # 004fc2c3
    fnstsw ax                                    # 004fc2c9
    test ah, 0x41                                # 004fc2cb
    jne.d8 L_004fc2ea                            # 004fc2ce
    # block 0x004fc2d0: entered by fall-through of jne at 0x004fc2ce, 6 instruction(s), ends with forward jump to 0x004fc2f8
    mov edx, dword ptr [ebp - local_4]           # 004fc2d0
    and edx, 0xffff                              # 004fc2d3
    imul edx, edx, 0x5bb                         # 004fc2d9
    fld dword ptr [edx + 0x5c3ba3]               # 004fc2df
    fstp qword ptr [ebp - local_44]              # 004fc2e5
    jmp.d8 L_004fc2f8                            # 004fc2e8
L_004fc2ea:
    # block 0x004fc2ea: entered by jne at 0x004fc2ce, 2 instruction(s), falls into the block at 0x004fc2f8
    mov dword ptr [ebp - local_44], 0x0          # 004fc2ea
    mov dword ptr [ebp - local_40], 0x0          # 004fc2f1
L_004fc2f8:
    # block 0x004fc2f8: entered by jmp at 0x004fc2e8, 24 instruction(s), calls FUN_004fc62d, ends with ret 0x4
    fld qword ptr [ebp - local_44]               # 004fc2f8
    fstp dword ptr [ebp - local_48]              # 004fc2fb
    fld dword ptr [ebp - local_48]               # 004fc2fe
    mov eax, dword ptr [ebp - local_4]           # 004fc301
    and eax, 0xffff                              # 004fc304
    imul eax, eax, 0x5bb                         # 004fc309
    mov ecx, dword ptr [ebp - local_8]           # 004fc30f
    fstp dword ptr [ecx + eax + field_13c]       # 004fc312
    push 0x1                                     # 004fc319
    mov edx, dword ptr [ebp + arg_8]             # 004fc31b
    add edx, 0x31                                # 004fc31e
    push edx                                     # 004fc321
    mov eax, dword ptr [ebp + arg_8]             # 004fc322
    movsx ecx, word ptr [eax + field_23]         # 004fc325
    push ecx                                     # 004fc329
    mov edx, dword ptr [ebp + arg_8]             # 004fc32a
    push edx                                     # 004fc32d
    mov ax, word ptr [ebp - local_4]             # 004fc32e
    push eax                                     # 004fc332
    mov ecx, dword ptr [ebp - local_8]           # 004fc333
    call FUN_004fc62d                            # 004fc336
    {load} mov esp, ebp                          # 004fc33b
    pop ebp                                      # 004fc33d
    ret 0x4                                      # 004fc33e

