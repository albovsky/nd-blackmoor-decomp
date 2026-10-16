# FUN_00413187
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00413187
# extent:       0x00413187-0x0041440e (4743 code bytes)
# span:         0x00413187-0x00414490 (code 4743, tables 119, padding 11)
# sha256:       9a770b4cfe3913c426bc6375c91ffa0ff4eb56f571090acc24c099811b50b138
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00413187
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       44 ebp-relative slot(s): local_4, local_8, local_c, local_e, local_10, local_14, local_18, local_1c, local_20, local_24, local_40, local_44 and 32 more
# fields:       [eax + n] field_4, field_6, field_8, field_a, field_c, field_31, field_33, field_35, field_39, field_3d, field_41, field_292e and 3 more; [ecx + n] field_2, field_4, field_6, field_8, field_a, field_c, field_e, field_12, field_31, field_33, field_35, field_39 and 5 more; [edx + n] field_4, field_6, field_a, field_31, field_3d, field_102e, field_1032, field_1036, field_103a, field_292e, field_2930, field_2938 and 2 more
# callees:      calls FUN_0050c920, FUN_004d3836, FUN_004c2a8d, FUN_004c2dfb, FUN_0052139c, FUN_004c97b4, FUN_004c2790, FUN_004c46d1, FUN_004c924d, FUN_004c5b3a, FUN_00412db8, FUN_004c9340, FUN_0050cb1b, FUN_004c92c5
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1123 instruction(s), 49 conditional branch(es) and 2 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_minus_9, 0x9  # offset -0x9
.equ local_c, 0xc  # offset -0xc
.equ local_e, 0xe  # offset -0xe
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ local_4c, 0x4c  # offset -0x4c
.equ local_50, 0x50  # offset -0x50
.equ local_54, 0x54  # offset -0x54
.equ local_58, 0x58  # offset -0x58
.equ local_5c, 0x5c  # offset -0x5c
.equ local_9c9c, 0x9c9c  # offset -0x9c9c
.equ local_9ca0, 0x9ca0  # offset -0x9ca0
.equ local_9ca4, 0x9ca4  # offset -0x9ca4
.equ local_9ca8, 0x9ca8  # offset -0x9ca8
.equ local_9cac, 0x9cac  # offset -0x9cac
.equ local_9cb0, 0x9cb0  # offset -0x9cb0
.equ local_9cb4, 0x9cb4  # offset -0x9cb4
.equ local_9cb8, 0x9cb8  # offset -0x9cb8
.equ local_9cbc, 0x9cbc  # offset -0x9cbc
.equ local_9cc0, 0x9cc0  # offset -0x9cc0
.equ local_9cc4, 0x9cc4  # offset -0x9cc4
.equ local_9cc8, 0x9cc8  # offset -0x9cc8
.equ local_9ccc, 0x9ccc  # offset -0x9ccc
.equ local_9cd0, 0x9cd0  # offset -0x9cd0
.equ local_9cd4, 0x9cd4  # offset -0x9cd4
.equ local_9cd8, 0x9cd8  # offset -0x9cd8
.equ local_9cdc, 0x9cdc  # offset -0x9cdc
.equ local_9ce0, 0x9ce0  # offset -0x9ce0
.equ local_9ce4, 0x9ce4  # offset -0x9ce4
.equ local_9ce8, 0x9ce8  # offset -0x9ce8
.equ local_9cec, 0x9cec  # offset -0x9cec
.equ local_9cf0, 0x9cf0  # offset -0x9cf0
.equ local_9cf4, 0x9cf4  # offset -0x9cf4
.equ local_9cf8, 0x9cf8  # offset -0x9cf8
.equ local_9cfc, 0x9cfc  # offset -0x9cfc
.equ local_9d00, 0x9d00  # offset -0x9d00
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ field_e, 0xe  # offset +0xe
.equ arg_10, 0x10  # offset +0x10
.equ field_12, 0x12  # offset +0x12
.equ arg_14, 0x14  # offset +0x14
.equ field_31, 0x31  # offset +0x31
.equ field_33, 0x33  # offset +0x33
.equ field_35, 0x35  # offset +0x35
.equ field_39, 0x39  # offset +0x39
.equ field_3d, 0x3d  # offset +0x3d
.equ field_41, 0x41  # offset +0x41
.equ field_102e, 0x102e  # offset +0x102e
.equ field_1032, 0x1032  # offset +0x1032
.equ field_1036, 0x1036  # offset +0x1036
.equ field_103a, 0x103a  # offset +0x103a
.equ field_292e, 0x292e  # offset +0x292e
.equ field_2930, 0x2930  # offset +0x2930
.equ field_2938, 0x2938  # offset +0x2938
.equ field_293c, 0x293c  # offset +0x293c
.equ field_293e, 0x293e  # offset +0x293e
.equ field_2942, 0x2942  # offset +0x2942

# --- external targets -----------------------------------------------
.set FUN_00412db8, .text + (0x00412db8 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004c2a8d, .text + (0x004c2a8d - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004c46d1, .text + (0x004c46d1 - 0x401000)
.set FUN_004c5b3a, .text + (0x004c5b3a - 0x401000)
.set FUN_004c924d, .text + (0x004c924d - 0x401000)
.set FUN_004c92c5, .text + (0x004c92c5 - 0x401000)
.set FUN_004c9340, .text + (0x004c9340 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004d3836, .text + (0x004d3836 - 0x401000)
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)
.set FUN_0050cb1b, .text + (0x0050cb1b - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x00413187 - 0x401000
.globl FUN_00413187
FUN_00413187:
    # block 0x00413187: entry, 27 instruction(s), calls FUN_0050c920, ends with je to 0x0041322f (forward)
    push ebp                                     # 00413187
    {load} mov ebp, esp                          # 00413188
    mov eax, 0x9d00                              # 0041318a
    call FUN_0050c920                            # 0041318f
    push ebx                                     # 00413194
    push esi                                     # 00413195
    push edi                                     # 00413196
    mov dword ptr [ebp - local_9cf8], ecx        # 00413197
    mov dword ptr [ebp - local_4], 0x0           # 0041319d
    mov dword ptr [ebp - local_9cc8], 0x0        # 004131a4
    mov word ptr [ebp - local_9cf0], 0x0         # 004131ae
    mov eax, dword ptr [ebp + arg_8]             # 004131b7
    mov dword ptr [ebp - local_9cd0], eax        # 004131ba
    mov dword ptr [ebp - local_24], 0x0          # 004131c0
    mov dword ptr [ebp - local_54], 0x0          # 004131c7
    mov dword ptr [ebp - local_9cc0], 0x0        # 004131ce
    mov dword ptr [ebp - local_9ca0], 0x0        # 004131d8
    mov ecx, dword ptr [ebp - local_9cf8]        # 004131e2
    mov dword ptr [ecx + field_2938], 0x0        # 004131e8
    mov edx, dword ptr [ebp - local_9cf8]        # 004131f2
    mov word ptr [edx + field_293c], 0x0         # 004131f8
    mov eax, dword ptr [ebp - local_9cf8]        # 00413201
    mov dword ptr [eax + field_293e], 0x0        # 00413207
    mov ecx, dword ptr [ebp - local_9cf8]        # 00413211
    mov dword ptr [ecx + field_2942], 0x0        # 00413217
    cmp dword ptr [ebp + arg_14], 0x0            # 00413221
    je.d8 L_0041322f                             # 00413225
    # block 0x00413227: entered by fall-through of je at 0x00413225, 2 instruction(s), falls into the block at 0x0041322f
    mov edx, dword ptr [ebp + arg_14]            # 00413227
    mov word ptr [edx], 0x0                      # 0041322a
L_0041322f:
    # block 0x0041322f: entered by je at 0x00413225, 62 instruction(s), calls FUN_004d3836, ends with jge to 0x0041335c (forward)
    mov eax, dword ptr [ebp - local_9cd0]        # 0041322f
    mov cx, word ptr [eax + field_4]             # 00413235
    mov word ptr [ebp - local_9cac], cx          # 00413239
    mov edx, dword ptr [ebp - local_9cd0]        # 00413240
    mov ax, word ptr [edx + field_6]             # 00413246
    mov word ptr [ebp - local_9ca8], ax          # 0041324a
    mov ecx, dword ptr [ebp - local_9cd0]        # 00413251
    movsx edx, word ptr [ecx + field_e]          # 00413257
    add edx, 0x14                                # 0041325b
    mov word ptr [ebp - local_9ce8], dx          # 0041325e
    mov eax, dword ptr [ebp - local_9cd0]        # 00413265
    mov cx, word ptr [eax + field_c]             # 0041326b
    mov word ptr [ebp - local_9ccc], cx          # 0041326f
    mov dx, word ptr [ebp - local_9ccc]          # 00413276
    mov word ptr [ebp - local_9ce4], dx          # 0041327d
    movsx eax, word ptr [ebp - local_9cac]       # 00413284
    imul eax, eax, 0x1d0                         # 0041328b
    add eax, 0x5adb3a                            # 00413291
    push eax                                     # 00413296
    movsx ecx, word ptr [ebp - local_9cac]       # 00413297
    imul ecx, ecx, 0x7f3                         # 0041329e
    add ecx, 0x5a4c24                            # 004132a4
    push ecx                                     # 004132aa
    push 0x5416b4                                # 004132ab
    call FUN_004d3836                            # 004132b0
    add esp, 0xc                                 # 004132b5
    mov word ptr [ebp - local_44], ax            # 004132b8
    mov edx, dword ptr [ebp - local_9cd0]        # 004132bc
    movsx eax, word ptr [edx + field_a]          # 004132c2
    movsx ecx, word ptr [ebp - local_44]         # 004132c6
    lea edx, [eax + 2*ecx]                       # 004132ca
    mov word ptr [ebp - local_20], dx            # 004132cd
    mov eax, dword ptr [ebp - local_9cd0]        # 004132d1
    movsx ecx, word ptr [eax + field_8]          # 004132d7
    movsx edx, word ptr [ebp - local_44]         # 004132db
    {load} add ecx, edx                          # 004132df
    mov eax, dword ptr [ebp - local_9cf8]        # 004132e1
    mov word ptr [eax + field_292e], cx          # 004132e7
    mov ecx, dword ptr [ebp - local_9cf8]        # 004132ee
    mov dx, word ptr [ecx + field_292e]          # 004132f4
    mov word ptr [ebp - local_8], dx             # 004132fb
    mov eax, dword ptr [ebp - local_9cf8]        # 004132ff
    mov ecx, dword ptr [ebp - local_9cd0]        # 00413305
    mov dx, word ptr [ecx + field_2]             # 0041330b
    mov word ptr [eax + field_4], dx             # 0041330f
    mov edi, dword ptr [ebp + arg_c]             # 00413313
    or ecx, -0x1                                 # 00413316
    {load} xor eax, eax                          # 00413319
    repne scasb al, byte ptr es:[edi]            # 0041331b
    not ecx                                      # 0041331d
    add ecx, -0x1                                # 0041331f
    mov dword ptr [ebp - local_9ca4], ecx        # 00413322
    mov eax, dword ptr [ebp - local_9ca4]        # 00413328
    imul eax, eax, 0x90                          # 0041332e
    movsx ecx, word ptr [ebp - local_9ccc]       # 00413334
    cdq                                          # 0041333b
    idiv ecx                                     # 0041333c
    mov word ptr [ebp - local_50], ax            # 0041333e
    movsx edx, word ptr [ebp - local_9ce8]       # 00413342
    movsx eax, word ptr [ebp - local_50]         # 00413349
    {load} cmp edx, eax                          # 0041334d
    jge.d8 L_0041335c                            # 0041334f
    # block 0x00413351: entered by fall-through of jge at 0x0041334f, 2 instruction(s), falls into the block at 0x0041335c
    mov cx, word ptr [ebp - local_50]            # 00413351
    mov word ptr [ebp - local_9ce8], cx          # 00413355
L_0041335c:
    # block 0x0041335c: entered by jge at 0x0041334f, 4 instruction(s), ends with jl to 0x004134ba (forward)
    mov edx, dword ptr [ebp - local_9cf8]        # 0041335c
    movsx eax, word ptr [edx + field_4]          # 00413362
    test eax, eax                                # 00413366
    jl.d32 L_004134ba                            # 00413368
    # block 0x0041336e: entered by fall-through of jl at 0x00413368, 4 instruction(s), ends with jge to 0x004134ba (forward)
    mov ecx, dword ptr [ebp - local_9cf8]        # 0041336e
    movsx edx, word ptr [ecx + field_4]          # 00413374
    cmp edx, 0x6                                 # 00413378
    jge.d32 L_004134ba                           # 0041337b
    # block 0x00413381: entered by fall-through of jge at 0x0041337b, 4 instruction(s), ends with jne to 0x004133cc (forward)
    mov eax, dword ptr [ebp - local_9cf8]        # 00413381
    movsx ecx, word ptr [eax + field_4]          # 00413387
    cmp dword ptr [4*ecx + 0x5d0397], 0x0        # 0041338b
    jne.d8 L_004133cc                            # 00413393
    # block 0x00413395: entered by fall-through of jne at 0x00413393, 12 instruction(s), calls FUN_004c2a8d, ends with forward jump to 0x0041349e
    push 0x5416b8                                # 00413395
    push 0x6                                     # 0041339a
    mov dx, word ptr [ebp - local_9ce8]          # 0041339c
    push edx                                     # 004133a3
    mov ax, word ptr [ebp - local_9ccc]          # 004133a4
    push eax                                     # 004133ab
    mov ecx, 0x5cf659                            # 004133ac
    call FUN_004c2a8d                            # 004133b1
    mov ecx, dword ptr [ebp - local_9cf8]        # 004133b6
    movsx edx, word ptr [ecx + field_4]          # 004133bc
    mov dword ptr [4*edx + 0x5d0397], eax        # 004133c0
    jmp.d32 L_0041349e                           # 004133c7
L_004133cc:
    # block 0x004133cc: entered by jne at 0x00413393, 4 instruction(s), ends with je to 0x0041349e (forward)
    mov eax, dword ptr [ebp - local_9cf8]        # 004133cc
    movsx ecx, word ptr [eax + field_4]          # 004133d2
    cmp dword ptr [4*ecx + 0x5d0397], 0x0        # 004133d6
    je.d32 L_0041349e                            # 004133de
    # block 0x004133e4: entered by fall-through of je at 0x004133de, 12 instruction(s), ends with jg to 0x00413450 (forward)
    movsx edx, word ptr [ebp - local_9ce8]       # 004133e4
    mov eax, dword ptr [ebp - local_9cf8]        # 004133eb
    movsx ecx, word ptr [eax + field_4]          # 004133f1
    mov eax, dword ptr [4*ecx + 0x5d0397]        # 004133f5
    mov ecx, dword ptr [ebp - local_9cf8]        # 004133fc
    movsx ecx, word ptr [ecx + field_4]          # 00413402
    mov ecx, dword ptr [4*ecx + 0x5d0397]        # 00413406
    mov eax, dword ptr [eax + field_41]          # 0041340d
    sub eax, dword ptr [ecx + field_39]          # 00413410
    add eax, 0x1                                 # 00413413
    {load} cmp edx, eax                          # 00413416
    jg.d8 L_00413450                             # 00413418
    # block 0x0041341a: entered by fall-through of jg at 0x00413418, 12 instruction(s), ends with jle to 0x0041349e (forward)
    movsx ecx, word ptr [ebp - local_9ccc]       # 0041341a
    mov edx, dword ptr [ebp - local_9cf8]        # 00413421
    movsx eax, word ptr [edx + field_4]          # 00413427
    mov edx, dword ptr [4*eax + 0x5d0397]        # 0041342b
    mov eax, dword ptr [ebp - local_9cf8]        # 00413432
    movsx eax, word ptr [eax + field_4]          # 00413438
    mov eax, dword ptr [4*eax + 0x5d0397]        # 0041343c
    mov edx, dword ptr [edx + field_3d]          # 00413443
    sub edx, dword ptr [eax + field_35]          # 00413446
    add edx, 0x1                                 # 00413449
    {load} cmp ecx, edx                          # 0041344c
    jle.d8 L_0041349e                            # 0041344e
L_00413450:
    # block 0x00413450: entered by jg at 0x00413418; fall-through of jle at 0x0041344e, 17 instruction(s), calls FUN_004c2dfb, FUN_004c2a8d, falls into the block at 0x0041349e
    mov eax, dword ptr [ebp - local_9cf8]        # 00413450
    movsx ecx, word ptr [eax + field_4]          # 00413456
    lea edx, [4*ecx + 0x5d0397]                  # 0041345a
    push edx                                     # 00413461
    mov ecx, 0x5cf659                            # 00413462
    call FUN_004c2dfb                            # 00413467
    push 0x5416cc                                # 0041346c
    push 0x6                                     # 00413471
    mov ax, word ptr [ebp - local_9ce8]          # 00413473
    push eax                                     # 0041347a
    mov cx, word ptr [ebp - local_9ccc]          # 0041347b
    push ecx                                     # 00413482
    mov ecx, 0x5cf659                            # 00413483
    call FUN_004c2a8d                            # 00413488
    mov edx, dword ptr [ebp - local_9cf8]        # 0041348d
    movsx ecx, word ptr [edx + field_4]          # 00413493
    mov dword ptr [4*ecx + 0x5d0397], eax        # 00413497
L_0041349e:
    # block 0x0041349e: entered by jmp at 0x004133c7; je at 0x004133de; jle at 0x0041344e, 6 instruction(s), ends with forward jump to 0x004134d2
    mov edx, dword ptr [ebp - local_9cf8]        # 0041349e
    movsx eax, word ptr [edx + field_4]          # 004134a4
    mov ecx, dword ptr [ebp - local_9cf8]        # 004134a8
    mov edx, dword ptr [4*eax + 0x5d0397]        # 004134ae
    mov dword ptr [ecx + field_a], edx           # 004134b5
    jmp.d8 L_004134d2                            # 004134b8
L_004134ba:
    # block 0x004134ba: entered by jl at 0x00413368; jge at 0x0041337b, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x004134d2
    push 0x0                                     # 004134ba
    push 0x0                                     # 004134bc
    push 0x5416e0                                # 004134be
    call FUN_0052139c                            # 004134c3
    mov ecx, 0x5cf659                            # 004134c8
    call FUN_004c97b4                            # 004134cd
L_004134d2:
    # block 0x004134d2: entered by jmp at 0x004134b8, 4 instruction(s), ends with jle to 0x00413559 (forward)
    mov eax, dword ptr [ebp - local_9cd0]        # 004134d2
    movsx ecx, word ptr [eax + field_31]         # 004134d8
    test ecx, ecx                                # 004134dc
    jle.d8 L_00413559                            # 004134de
    # block 0x004134e0: entered by fall-through of jle at 0x004134de, 9 instruction(s), ends with je to 0x00413559 (forward)
    mov edi, dword ptr [ebp - local_9cd0]        # 004134e0
    add edi, 0x10                                # 004134e6
    or ecx, -0x1                                 # 004134e9
    {load} xor eax, eax                          # 004134ec
    repne scasb al, byte ptr es:[edi]            # 004134ee
    not ecx                                      # 004134f0
    add ecx, -0x1                                # 004134f2
    test ecx, ecx                                # 004134f5
    je.d8 L_00413559                             # 004134f7
    # block 0x004134f9: entered by fall-through of je at 0x004134f7, 3 instruction(s), ends with jne to 0x00413559 (forward)
    mov edx, dword ptr [ebp - local_9cf8]        # 004134f9
    cmp dword ptr [edx + field_6], 0x0           # 004134ff
    jne.d8 L_00413559                            # 00413503
    # block 0x00413505: entered by fall-through of jne at 0x00413503, 14 instruction(s), calls FUN_004c2790, ends with jle to 0x00413549 (forward)
    push 0x54170c                                # 00413505
    push 0x6                                     # 0041350a
    mov eax, dword ptr [ebp - local_9cd0]        # 0041350c
    add eax, 0x10                                # 00413512
    push eax                                     # 00413515
    push 0x541728                                # 00413516
    mov ecx, 0x5cf659                            # 0041351b
    call FUN_004c2790                            # 00413520
    mov ecx, dword ptr [ebp - local_9cf8]        # 00413525
    mov dword ptr [ecx + field_6], eax           # 0041352b
    mov edx, dword ptr [ebp - local_9cd0]        # 0041352e
    movsx eax, word ptr [edx + field_31]         # 00413534
    cmp eax, 0xa                                 # 00413538
    jle.d8 L_00413549                            # 0041353b
    # block 0x0041353d: entered by fall-through of jle at 0x0041353b, 2 instruction(s), falls into the block at 0x00413549
    mov ecx, dword ptr [ebp - local_9cd0]        # 0041353d
    mov word ptr [ecx + field_31], 0xa           # 00413543
L_00413549:
    # block 0x00413549: entered by jle at 0x0041353b, 2 instruction(s), falls into the block at 0x00413559
    mov edx, dword ptr [ebp - local_9cf8]        # 00413549
    mov dword ptr [edx + field_2930], 0x1        # 0041354f
L_00413559:
    # block 0x00413559: entered by jle at 0x004134de; je at 0x004134f7; jne at 0x00413503, 4 instruction(s), ends with jne to 0x00413583 (forward)
    mov eax, dword ptr [ebp - local_9cd0]        # 00413559
    movsx ecx, word ptr [eax]                    # 0041355f
    cmp ecx, 0x2                                 # 00413562
    jne.d8 L_00413583                            # 00413565
    # block 0x00413567: entered by fall-through of jne at 0x00413565, 9 instruction(s), calls FUN_004c46d1, ends with forward jump to 0x0041359d
    push 0x0                                     # 00413567
    push 0x1f                                    # 00413569
    push 0x0                                     # 0041356b
    mov edx, dword ptr [ebp - local_9cf8]        # 0041356d
    mov eax, dword ptr [edx + field_a]           # 00413573
    push eax                                     # 00413576
    mov ecx, 0x5cf659                            # 00413577
    call FUN_004c46d1                            # 0041357c
    jmp.d8 L_0041359d                            # 00413581
L_00413583:
    # block 0x00413583: entered by jne at 0x00413565, 8 instruction(s), calls FUN_004c46d1, falls into the block at 0x0041359d
    push 0x0                                     # 00413583
    push 0x0                                     # 00413585
    push 0x0                                     # 00413587
    mov ecx, dword ptr [ebp - local_9cf8]        # 00413589
    mov edx, dword ptr [ecx + field_a]           # 0041358f
    push edx                                     # 00413592
    mov ecx, 0x5cf659                            # 00413593
    call FUN_004c46d1                            # 00413598
L_0041359d:
    # block 0x0041359d: entered by jmp at 0x00413581, 25 instruction(s), calls FUN_004c924d, ends with forward jump to 0x0041360d
    mov ax, word ptr [ebp - local_9cac]          # 0041359d
    push eax                                     # 004135a4
    mov ecx, 0x5cf659                            # 004135a5
    call FUN_004c924d                            # 004135aa
    mov ecx, 0x2710                              # 004135af
    {load} xor eax, eax                          # 004135b4
    lea edi, [ebp - local_9c9c]                  # 004135b6
    rep stosd dword ptr es:[edi], eax            # 004135bc
    mov ecx, 0x6                                 # 004135be
    {load} xor eax, eax                          # 004135c3
    lea edi, [ebp - local_40]                    # 004135c5
    rep stosd dword ptr es:[edi], eax            # 004135c8
    stosb byte ptr es:[edi], al                  # 004135ca
    {load} xor ecx, ecx                          # 004135cb
    mov dword ptr [ebp - local_1c], ecx          # 004135cd
    mov dword ptr [ebp - local_18], ecx          # 004135d0
    mov dword ptr [ebp - local_14], ecx          # 004135d3
    mov word ptr [ebp - local_10], cx            # 004135d6
    mov byte ptr [ebp - local_e], cl             # 004135da
    {load} xor edx, edx                          # 004135dd
    mov word ptr [ebp - local_c], dx             # 004135df
    mov word ptr [ebp - local_48], 0x0           # 004135e3
    mov word ptr [ebp - local_9cf4], 0xffff      # 004135e9
    mov dword ptr [ebp - local_58], 0x0          # 004135f2
    jmp.d8 L_0041360d                            # 004135f9
L_004135fb:
    # block 0x004135fb: entered by jmp at 0x004141fa, 6 instruction(s), falls into the block at 0x0041360d
    mov eax, dword ptr [ebp - local_58]          # 004135fb
    add eax, 0x1                                 # 004135fe
    mov dword ptr [ebp - local_58], eax          # 00413601
    mov ecx, dword ptr [ebp + arg_c]             # 00413604
    add ecx, 0x1                                 # 00413607
    mov dword ptr [ebp + arg_c], ecx             # 0041360a
L_0041360d:
    # block 0x0041360d: entered by jmp at 0x004135f9, 3 instruction(s), ends with jge to 0x004141ff (forward)
    mov edx, dword ptr [ebp - local_58]          # 0041360d
    cmp edx, dword ptr [ebp - local_9ca4]        # 00413610
    jge.d32 L_004141ff                           # 00413616
    # block 0x0041361c: entered by fall-through of jge at 0x00413616, 3 instruction(s), ends with je to 0x004137d8 (forward)
    mov eax, dword ptr [ebp - local_9cf8]        # 0041361c
    cmp dword ptr [eax + field_2930], 0x0        # 00413622
    je.d32 L_004137d8                            # 00413629
    # block 0x0041362f: entered by fall-through of je at 0x00413629, 4 instruction(s), ends with je to 0x004137d8 (forward)
    movsx ecx, word ptr [ebp - local_48]         # 0041362f
    movsx edx, word ptr [ebp - local_9cf4]       # 00413633
    {load} cmp ecx, edx                          # 0041363a
    je.d32 L_004137d8                            # 0041363c
    # block 0x00413642: entered by fall-through of je at 0x0041363c, 2 instruction(s), ends with forward jump to 0x00413656
    mov word ptr [ebp - local_4c], 0x0           # 00413642
    jmp.d8 L_00413656                            # 00413648
L_0041364a:
    # block 0x0041364a: entered by jmp at 0x0041379a, 3 instruction(s), falls into the block at 0x00413656
    mov ax, word ptr [ebp - local_4c]            # 0041364a
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041364e
    mov word ptr [ebp - local_4c], ax            # 00413652
L_00413656:
    # block 0x00413656: entered by jmp at 0x00413648, 5 instruction(s), ends with jge to 0x0041379f (forward)
    movsx ecx, word ptr [ebp - local_4c]         # 00413656
    mov edx, dword ptr [ebp - local_9cd0]        # 0041365a
    movsx eax, word ptr [edx + field_31]         # 00413660
    {load} cmp ecx, eax                          # 00413664
    jge.d32 L_0041379f                           # 00413666
    # block 0x0041366c: entered by fall-through of jge at 0x00413666, 7 instruction(s), ends with jne to 0x0041379a (forward)
    movsx ecx, word ptr [ebp - local_48]         # 0041366c
    movsx edx, word ptr [ebp - local_4c]         # 00413670
    imul edx, edx, 0x12                          # 00413674
    mov eax, dword ptr [ebp - local_9cd0]        # 00413677
    movsx edx, word ptr [eax + edx + field_33]   # 0041367d
    {load} cmp ecx, edx                          # 00413682
    jne.d32 L_0041379a                           # 00413684
    # block 0x0041368a: entered by fall-through of jne at 0x00413684, 3 instruction(s), ends with jne to 0x004136a0 (forward)
    movsx eax, word ptr [ebp - local_48]         # 0041368a
    test eax, eax                                # 0041368e
    jne.d8 L_004136a0                            # 00413690
    # block 0x00413692: entered by fall-through of jne at 0x00413690, 3 instruction(s), falls into the block at 0x004136a0
    mov ecx, dword ptr [ebp - local_9cd0]        # 00413692
    mov dx, word ptr [ecx + field_a]             # 00413698
    mov word ptr [ebp - local_20], dx            # 0041369c
L_004136a0:
    # block 0x004136a0: entered by jne at 0x00413690, 45 instruction(s), calls FUN_004c5b3a, ends with jne to 0x0041377c (forward)
    movsx eax, word ptr [ebp - local_20]         # 004136a0
    movsx ecx, word ptr [ebp - local_44]         # 004136a4
    {load} add eax, ecx                          # 004136a8
    mov dword ptr [ebp - local_9cb8], eax        # 004136aa
    movsx edx, word ptr [ebp - local_4c]         # 004136b0
    imul edx, edx, 0x12                          # 004136b4
    mov eax, dword ptr [ebp - local_9cd0]        # 004136b7
    mov ecx, dword ptr [ebp - local_9cb8]        # 004136bd
    add ecx, dword ptr [eax + edx + field_41]    # 004136c3
    movsx edx, word ptr [ebp - local_4c]         # 004136c7
    imul edx, edx, 0x12                          # 004136cb
    mov eax, dword ptr [ebp - local_9cd0]        # 004136ce
    sub ecx, dword ptr [eax + edx + field_39]    # 004136d4
    mov dword ptr [ebp - local_9cb0], ecx        # 004136d8
    movsx ecx, word ptr [ebp - local_8]          # 004136de
    mov dword ptr [ebp - local_9cbc], ecx        # 004136e2
    movsx edx, word ptr [ebp - local_4c]         # 004136e8
    imul edx, edx, 0x12                          # 004136ec
    mov eax, dword ptr [ebp - local_9cd0]        # 004136ef
    mov ecx, dword ptr [ebp - local_9cbc]        # 004136f5
    add ecx, dword ptr [eax + edx + field_3d]    # 004136fb
    movsx edx, word ptr [ebp - local_4c]         # 004136ff
    imul edx, edx, 0x12                          # 00413703
    mov eax, dword ptr [ebp - local_9cd0]        # 00413706
    sub ecx, dword ptr [eax + edx + field_35]    # 0041370c
    mov dword ptr [ebp - local_9cb4], ecx        # 00413710
    push 0x541730                                # 00413716
    lea ecx, [ebp - local_9cbc]                  # 0041371b
    push ecx                                     # 00413721
    movsx edx, word ptr [ebp - local_4c]         # 00413722
    imul edx, edx, 0x12                          # 00413726
    mov eax, dword ptr [ebp - local_9cd0]        # 00413729
    lea ecx, [eax + edx + field_35]              # 0041372f
    push ecx                                     # 00413733
    mov edx, dword ptr [ebp - local_9cf8]        # 00413734
    mov eax, dword ptr [edx + field_a]           # 0041373a
    push eax                                     # 0041373d
    mov ecx, dword ptr [ebp - local_9cf8]        # 0041373e
    mov edx, dword ptr [ecx + field_6]           # 00413744
    push edx                                     # 00413747
    mov ecx, 0x5cf659                            # 00413748
    call FUN_004c5b3a                            # 0041374d
    movsx eax, word ptr [ebp - local_48]         # 00413752
    test eax, eax                                # 00413756
    jne.d8 L_0041377c                            # 00413758
    # block 0x0041375a: entered by fall-through of jne at 0x00413758, 9 instruction(s), ends with forward jump to 0x0041379a
    mov ecx, dword ptr [ebp - local_9cb0]        # 0041375a
    sub ecx, dword ptr [ebp - local_9cb8]        # 00413760
    movsx edx, word ptr [ebp - local_44]         # 00413766
    imul edx, edx, 0x3                           # 0041376a
    {load} add ecx, edx                          # 0041376d
    mov ax, word ptr [ebp - local_20]            # 0041376f
    {load} add ax, cx                            # 00413773
    mov word ptr [ebp - local_20], ax            # 00413776
    jmp.d8 L_0041379a                            # 0041377a
L_0041377c:
    # block 0x0041377c: entered by jne at 0x00413758, 7 instruction(s), falls into the block at 0x0041379a
    mov ecx, dword ptr [ebp - local_9cb0]        # 0041377c
    sub ecx, dword ptr [ebp - local_9cb8]        # 00413782
    movsx edx, word ptr [ebp - local_44]         # 00413788
    lea eax, [ecx + 2*edx]                       # 0041378c
    mov cx, word ptr [ebp - local_20]            # 0041378f
    {load} add cx, ax                            # 00413793
    mov word ptr [ebp - local_20], cx            # 00413796
L_0041379a:
    # block 0x0041379a: entered by jne at 0x00413684; jmp at 0x0041377a, 1 instruction(s), ends with backward jump to 0x0041364a
    jmp.d32 L_0041364a                           # 0041379a
L_0041379f:
    # block 0x0041379f: entered by jge at 0x00413666, 11 instruction(s), falls into the block at 0x004137d8
    mov dx, word ptr [ebp - local_48]            # 0041379f
    mov word ptr [ebp - local_9cf4], dx          # 004137a3
    mov eax, dword ptr [ebp - local_9cd0]        # 004137aa
    movsx ecx, word ptr [eax + field_8]          # 004137b0
    movsx edx, word ptr [ebp - local_44]         # 004137b4
    {load} add ecx, edx                          # 004137b8
    mov eax, dword ptr [ebp - local_9cf8]        # 004137ba
    mov word ptr [eax + field_292e], cx          # 004137c0
    mov ecx, dword ptr [ebp - local_9cf8]        # 004137c7
    mov dx, word ptr [ecx + field_292e]          # 004137cd
    mov word ptr [ebp - local_8], dx             # 004137d4
L_004137d8:
    # block 0x004137d8: entered by je at 0x00413629; je at 0x0041363c, 5 instruction(s), ends with je to 0x00413803 (forward)
    mov eax, dword ptr [ebp + arg_c]             # 004137d8
    mov cl, byte ptr [eax]                       # 004137db
    mov byte ptr [ebp - local_9cfc], cl          # 004137dd
    cmp byte ptr [ebp - local_9cfc], 0x0         # 004137e3
    je.d8 L_00413803                             # 004137ea
    # block 0x004137ec: entered by fall-through of je at 0x004137ea, 2 instruction(s), ends with je to 0x00413808 (forward)
    cmp byte ptr [ebp - local_9cfc], 0x3c        # 004137ec
    je.d8 L_00413808                             # 004137f3
    # block 0x004137f5: entered by fall-through of je at 0x004137f3, 2 instruction(s), ends with je to 0x00413821 (forward)
    cmp byte ptr [ebp - local_9cfc], 0x3e        # 004137f5
    je.d8 L_00413821                             # 004137fc
    # block 0x004137fe: entered by fall-through of je at 0x004137fc, 1 instruction(s), ends with forward jump to 0x0041414e
    jmp.d32 L_0041414e                           # 004137fe
L_00413803:
    # block 0x00413803: entered by je at 0x004137ea, 1 instruction(s), ends with forward jump to 0x004141be
    jmp.d32 L_004141be                           # 00413803
L_00413808:
    # block 0x00413808: entered by je at 0x004137f3, 3 instruction(s), ends with forward jump to 0x004141be
    mov dword ptr [ebp - local_9cc0], 0x1        # 00413808
    mov dword ptr [ebp - local_9ca0], 0x0        # 00413812
    jmp.d32 L_004141be                           # 0041381c
L_00413821:
    # block 0x00413821: entered by je at 0x004137fc, 8 instruction(s), ends with ja to 0x0041413f (forward)
    mov dword ptr [ebp - local_9cc0], 0x0        # 00413821
    movsx edx, byte ptr [ebp - local_5c]         # 0041382b
    mov dword ptr [ebp - local_9d00], edx        # 0041382f
    mov eax, dword ptr [ebp - local_9d00]        # 00413835
    sub eax, 0x31                                # 0041383b
    mov dword ptr [ebp - local_9d00], eax        # 0041383e
    cmp dword ptr [ebp - local_9d00], 0x46       # 00413844
    ja.d32 L_0041413f                            # 0041384b
    # block 0x00413851: entered by fall-through of ja at 0x0041384b, 4 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x41440e]
    mov edx, dword ptr [ebp - local_9d00]        # 00413851
    {load} xor ecx, ecx                          # 00413857
    mov cl, byte ptr [edx + IDXTAB_0041443e_VA]  # 00413859
    jmp dword ptr [4*ecx + SWTAB_0041440e_VA]    # 0041385f
L_00413866:
    # block 0x00413866: entered by switch case, 3 instruction(s), ends with jne to 0x004138d3 (forward)
    mov eax, dword ptr [ebp - local_9cf8]        # 00413866
    cmp dword ptr [eax + field_293e], 0x0        # 0041386c
    jne.d8 L_004138d3                            # 00413873
    # block 0x00413875: entered by fall-through of jne at 0x00413873, 26 instruction(s), calls FUN_00412db8, ends with forward jump to 0x0041392f
    mov ecx, dword ptr [ebp - local_9cf8]        # 00413875
    mov edx, dword ptr [ecx + field_a]           # 0041387b
    push edx                                     # 0041387e
    mov ax, word ptr [ebp - local_9ca8]          # 0041387f
    push eax                                     # 00413886
    lea ecx, [ebp - local_48]                    # 00413887
    push ecx                                     # 0041388a
    lea edx, [ebp - local_8]                     # 0041388b
    push edx                                     # 0041388e
    mov ax, word ptr [ebp - local_9ce4]          # 0041388f
    push eax                                     # 00413896
    mov cx, word ptr [ebp - local_9ce8]          # 00413897
    push ecx                                     # 0041389e
    lea edx, [ebp - local_20]                    # 0041389f
    push edx                                     # 004138a2
    lea eax, [ebp - local_54]                    # 004138a3
    push eax                                     # 004138a6
    mov cx, word ptr [ebp - local_9cac]          # 004138a7
    push ecx                                     # 004138ae
    lea edx, [ebp - local_9c9c]                  # 004138af
    push edx                                     # 004138b5
    mov ecx, dword ptr [ebp - local_9cf8]        # 004138b6
    call FUN_00412db8                            # 004138bc
    mov eax, dword ptr [ebp - local_9cf8]        # 004138c1
    mov dword ptr [eax + field_293e], 0x1        # 004138c7
    jmp.d8 L_0041392f                            # 004138d1
L_004138d3:
    # block 0x004138d3: entered by jne at 0x00413873, 25 instruction(s), calls FUN_00412db8, falls into the block at 0x0041392f
    mov ecx, dword ptr [ebp - local_9cf8]        # 004138d3
    mov edx, dword ptr [ecx + field_a]           # 004138d9
    push edx                                     # 004138dc
    mov ax, word ptr [ebp - local_9ca8]          # 004138dd
    push eax                                     # 004138e4
    lea ecx, [ebp - local_48]                    # 004138e5
    push ecx                                     # 004138e8
    lea edx, [ebp - local_8]                     # 004138e9
    push edx                                     # 004138ec
    mov ax, word ptr [ebp - local_9ce4]          # 004138ed
    push eax                                     # 004138f4
    mov cx, word ptr [ebp - local_9ce8]          # 004138f5
    push ecx                                     # 004138fc
    lea edx, [ebp - local_20]                    # 004138fd
    push edx                                     # 00413900
    lea eax, [ebp - local_54]                    # 00413901
    push eax                                     # 00413904
    mov cx, word ptr [ebp - local_9cac]          # 00413905
    push ecx                                     # 0041390c
    lea edx, [ebp - local_9c9c]                  # 0041390d
    push edx                                     # 00413913
    mov ecx, dword ptr [ebp - local_9cf8]        # 00413914
    call FUN_00412db8                            # 0041391a
    mov eax, dword ptr [ebp - local_9cf8]        # 0041391f
    mov dword ptr [eax + field_293e], 0x0        # 00413925
L_0041392f:
    # block 0x0041392f: entered by jmp at 0x004138d1, 1 instruction(s), ends with forward jump to 0x0041413f
    jmp.d32 L_0041413f                           # 0041392f
L_00413934:
    # block 0x00413934: entered by switch case, 3 instruction(s), ends with jne to 0x00413ae4 (forward)
    mov ecx, dword ptr [ebp - local_9cf8]        # 00413934
    cmp dword ptr [ecx + field_2938], 0x0        # 0041393a
    jne.d32 L_00413ae4                           # 00413941
    # block 0x00413947: entered by fall-through of jne at 0x00413941, 79 instruction(s), calls FUN_004c9340, FUN_00412db8, ends with forward jump to 0x00413b40
    movsx edx, word ptr [ebp - local_9cac]       # 00413947
    imul edx, edx, 0x7f3                         # 0041394e
    movsx eax, word ptr [edx + 0x5a4c77]         # 00413954
    mov dword ptr [ebp - local_9cec], eax        # 0041395b
    movsx ecx, word ptr [ebp - local_9cac]       # 00413961
    imul ecx, ecx, 0x7f3                         # 00413968
    mov edx, dword ptr [ebp - local_9cec]        # 0041396e
    shl edx, 0x4                                 # 00413974
    movsx eax, word ptr [ebp - local_9cac]       # 00413977
    imul eax, eax, 0x7f3                         # 0041397e
    movsx esi, word ptr [ebp - local_9ca8]       # 00413984
    mov ecx, dword ptr [ecx + edx + 0x5a4ceb]    # 0041398b
    add ecx, dword ptr [eax + 8*esi + 0x5a4c67]  # 00413992
    mov dword ptr [ebp - local_9cdc], ecx        # 00413999
    movsx edx, word ptr [ebp - local_9cac]       # 0041399f
    imul edx, edx, 0x7f3                         # 004139a6
    mov eax, dword ptr [ebp - local_9cec]        # 004139ac
    shl eax, 0x4                                 # 004139b2
    movsx ecx, word ptr [ebp - local_9cac]       # 004139b5
    imul ecx, ecx, 0x7f3                         # 004139bc
    movsx esi, word ptr [ebp - local_9ca8]       # 004139c2
    mov edx, dword ptr [edx + eax + 0x5a4cf3]    # 004139c9
    add edx, dword ptr [ecx + 8*esi + 0x5a4c67]  # 004139d0
    mov dword ptr [ebp - local_9cd4], edx        # 004139d7
    movsx eax, word ptr [ebp - local_9cac]       # 004139dd
    imul eax, eax, 0x7f3                         # 004139e4
    mov ecx, dword ptr [ebp - local_9cec]        # 004139ea
    shl ecx, 0x4                                 # 004139f0
    movsx edx, word ptr [ebp - local_9cac]       # 004139f3
    imul edx, edx, 0x7f3                         # 004139fa
    movsx esi, word ptr [ebp - local_9ca8]       # 00413a00
    mov eax, dword ptr [eax + ecx + 0x5a4ce7]    # 00413a07
    add eax, dword ptr [edx + 8*esi + 0x5a4c63]  # 00413a0e
    mov dword ptr [ebp - local_9ce0], eax        # 00413a15
    movsx ecx, word ptr [ebp - local_9cac]       # 00413a1b
    imul ecx, ecx, 0x7f3                         # 00413a22
    mov edx, dword ptr [ebp - local_9cec]        # 00413a28
    shl edx, 0x4                                 # 00413a2e
    movsx eax, word ptr [ebp - local_9cac]       # 00413a31
    imul eax, eax, 0x7f3                         # 00413a38
    movsx esi, word ptr [ebp - local_9ca8]       # 00413a3e
    mov ecx, dword ptr [ecx + edx + 0x5a4cef]    # 00413a45
    add ecx, dword ptr [eax + 8*esi + 0x5a4c63]  # 00413a4c
    mov dword ptr [ebp - local_9cd8], ecx        # 00413a53
    lea edx, [ebp - local_9ce0]                  # 00413a59
    push edx                                     # 00413a5f
    movsx eax, word ptr [ebp - local_9cac]       # 00413a60
    mov ecx, dword ptr [4*eax + 0x5d032f]        # 00413a67
    push ecx                                     # 00413a6e
    mov ecx, 0x5cf659                            # 00413a6f
    call FUN_004c9340                            # 00413a74
    mov edx, dword ptr [ebp - local_9cf8]        # 00413a79
    mov word ptr [edx + field_293c], ax          # 00413a7f
    mov eax, dword ptr [ebp - local_9cf8]        # 00413a86
    mov ecx, dword ptr [eax + field_a]           # 00413a8c
    push ecx                                     # 00413a8f
    mov dx, word ptr [ebp - local_9ca8]          # 00413a90
    push edx                                     # 00413a97
    lea eax, [ebp - local_48]                    # 00413a98
    push eax                                     # 00413a9b
    lea ecx, [ebp - local_8]                     # 00413a9c
    push ecx                                     # 00413a9f
    mov dx, word ptr [ebp - local_9ce4]          # 00413aa0
    push edx                                     # 00413aa7
    mov ax, word ptr [ebp - local_9ce8]          # 00413aa8
    push eax                                     # 00413aaf
    lea ecx, [ebp - local_20]                    # 00413ab0
    push ecx                                     # 00413ab3
    lea edx, [ebp - local_54]                    # 00413ab4
    push edx                                     # 00413ab7
    mov ax, word ptr [ebp - local_9cac]          # 00413ab8
    push eax                                     # 00413abf
    lea ecx, [ebp - local_9c9c]                  # 00413ac0
    push ecx                                     # 00413ac6
    mov ecx, dword ptr [ebp - local_9cf8]        # 00413ac7
    call FUN_00412db8                            # 00413acd
    mov edx, dword ptr [ebp - local_9cf8]        # 00413ad2
    mov dword ptr [edx + field_2938], 0x1        # 00413ad8
    jmp.d8 L_00413b40                            # 00413ae2
L_00413ae4:
    # block 0x00413ae4: entered by jne at 0x00413941, 25 instruction(s), calls FUN_00412db8, falls into the block at 0x00413b40
    mov eax, dword ptr [ebp - local_9cf8]        # 00413ae4
    mov ecx, dword ptr [eax + field_a]           # 00413aea
    push ecx                                     # 00413aed
    mov dx, word ptr [ebp - local_9ca8]          # 00413aee
    push edx                                     # 00413af5
    lea eax, [ebp - local_48]                    # 00413af6
    push eax                                     # 00413af9
    lea ecx, [ebp - local_8]                     # 00413afa
    push ecx                                     # 00413afd
    mov dx, word ptr [ebp - local_9ce4]          # 00413afe
    push edx                                     # 00413b05
    mov ax, word ptr [ebp - local_9ce8]          # 00413b06
    push eax                                     # 00413b0d
    lea ecx, [ebp - local_20]                    # 00413b0e
    push ecx                                     # 00413b11
    lea edx, [ebp - local_54]                    # 00413b12
    push edx                                     # 00413b15
    mov ax, word ptr [ebp - local_9cac]          # 00413b16
    push eax                                     # 00413b1d
    lea ecx, [ebp - local_9c9c]                  # 00413b1e
    push ecx                                     # 00413b24
    mov ecx, dword ptr [ebp - local_9cf8]        # 00413b25
    call FUN_00412db8                            # 00413b2b
    mov edx, dword ptr [ebp - local_9cf8]        # 00413b30
    mov dword ptr [edx + field_2938], 0x0        # 00413b36
L_00413b40:
    # block 0x00413b40: entered by jmp at 0x00413ae2, 1 instruction(s), ends with forward jump to 0x0041413f
    jmp.d32 L_0041413f                           # 00413b40
L_00413b45:
    # block 0x00413b45: entered by switch case, 12 instruction(s), calls FUN_0050cb1b, ends with jne to 0x00413b79 (forward)
    mov al, byte ptr [ebp - local_5c]            # 00413b45
    mov byte ptr [ebp - local_c], al             # 00413b48
    lea ecx, [ebp - local_c]                     # 00413b4b
    push ecx                                     # 00413b4e
    call FUN_0050cb1b                            # 00413b4f
    add esp, 0x4                                 # 00413b54
    sub eax, 0x1                                 # 00413b57
    mov word ptr [ebp - local_9cc4], ax          # 00413b5a
    movsx edx, word ptr [ebp - local_9cc4]       # 00413b61
    add edx, 0x1                                 # 00413b68
    cmp edx, 0x7                                 # 00413b6b
    jne.d8 L_00413b79                            # 00413b6e
    # block 0x00413b70: entered by fall-through of jne at 0x00413b6e, 1 instruction(s), falls into the block at 0x00413b79
    mov word ptr [ebp - local_9cc4], 0x0         # 00413b70
L_00413b79:
    # block 0x00413b79: entered by jne at 0x00413b6e, 3 instruction(s), ends with jne to 0x00413ba3 (forward)
    movsx eax, word ptr [ebp - local_48]         # 00413b79
    test eax, eax                                # 00413b7d
    jne.d8 L_00413ba3                            # 00413b7f
    # block 0x00413b81: entered by fall-through of jne at 0x00413b7f, 8 instruction(s), ends with forward jump to 0x00413bb0
    mov ecx, dword ptr [ebp - local_9cd0]        # 00413b81
    mov dx, word ptr [ecx + field_a]             # 00413b87
    mov word ptr [ebp - local_20], dx            # 00413b8b
    movsx eax, word ptr [ebp - local_20]         # 00413b8f
    movsx ecx, word ptr [ebp - local_44]         # 00413b93
    lea edx, [eax + ecx - field_minus_9]         # 00413b97
    mov dword ptr [ebp - local_9cb8], edx        # 00413b9b
    jmp.d8 L_00413bb0                            # 00413ba1
L_00413ba3:
    # block 0x00413ba3: entered by jne at 0x00413b7f, 3 instruction(s), falls into the block at 0x00413bb0
    movsx eax, word ptr [ebp - local_20]         # 00413ba3
    sub eax, 0x1                                 # 00413ba7
    mov dword ptr [ebp - local_9cb8], eax        # 00413baa
L_00413bb0:
    # block 0x00413bb0: entered by jmp at 0x00413ba1, 34 instruction(s), calls FUN_004c5b3a, ends with je to 0x00413c8d (forward)
    movsx ecx, word ptr [ebp - local_9cc4]       # 00413bb0
    shl ecx, 0x4                                 # 00413bb7
    mov edx, dword ptr [ebp - local_9cb8]        # 00413bba
    add edx, dword ptr [ecx + 0x5afc8a]          # 00413bc0
    movsx eax, word ptr [ebp - local_9cc4]       # 00413bc6
    shl eax, 0x4                                 # 00413bcd
    sub edx, dword ptr [eax + 0x5afc82]          # 00413bd0
    mov dword ptr [ebp - local_9cb0], edx        # 00413bd6
    movsx ecx, word ptr [ebp - local_8]          # 00413bdc
    mov dword ptr [ebp - local_9cbc], ecx        # 00413be0
    movsx edx, word ptr [ebp - local_9cc4]       # 00413be6
    shl edx, 0x4                                 # 00413bed
    mov eax, dword ptr [ebp - local_9cbc]        # 00413bf0
    add eax, dword ptr [edx + 0x5afc86]          # 00413bf6
    movsx ecx, word ptr [ebp - local_9cc4]       # 00413bfc
    shl ecx, 0x4                                 # 00413c03
    sub eax, dword ptr [ecx + 0x5afc7e]          # 00413c06
    mov dword ptr [ebp - local_9cb4], eax        # 00413c0c
    push 0x541744                                # 00413c12
    lea edx, [ebp - local_9cbc]                  # 00413c17
    push edx                                     # 00413c1d
    movsx eax, word ptr [ebp - local_9cc4]       # 00413c1e
    shl eax, 0x4                                 # 00413c25
    add eax, 0x5afc7e                            # 00413c28
    push eax                                     # 00413c2d
    mov ecx, dword ptr [ebp - local_9cf8]        # 00413c2e
    mov edx, dword ptr [ecx + field_a]           # 00413c34
    push edx                                     # 00413c37
    mov eax, dword ptr [0x5d0377]                # 00413c38
    push eax                                     # 00413c3d
    mov ecx, 0x5cf659                            # 00413c3e
    call FUN_004c5b3a                            # 00413c43
    cmp dword ptr [ebp + arg_10], 0x0            # 00413c48
    je.d8 L_00413c8d                             # 00413c4c
    # block 0x00413c4e: entered by fall-through of je at 0x00413c4c, 17 instruction(s), falls into the block at 0x00413c8d
    mov ecx, dword ptr [ebp + arg_10]            # 00413c4e
    mov edx, dword ptr [ebp - local_9cbc]        # 00413c51
    mov dword ptr [ecx], edx                     # 00413c57
    mov eax, dword ptr [ebp - local_9cb8]        # 00413c59
    mov dword ptr [ecx + field_4], eax           # 00413c5f
    mov edx, dword ptr [ebp - local_9cb4]        # 00413c62
    mov dword ptr [ecx + field_8], edx           # 00413c68
    mov eax, dword ptr [ebp - local_9cb0]        # 00413c6b
    mov dword ptr [ecx + field_c], eax           # 00413c71
    mov ecx, dword ptr [ebp + arg_10]            # 00413c74
    add ecx, 0x10                                # 00413c77
    mov dword ptr [ebp + arg_10], ecx            # 00413c7a
    mov edx, dword ptr [ebp + arg_14]            # 00413c7d
    mov ax, word ptr [edx]                       # 00413c80
    .insn 0x66, 0x05, 0x0001{:u16}               # 00413c83
    mov ecx, dword ptr [ebp + arg_14]            # 00413c87
    mov word ptr [ecx], ax                       # 00413c8a
L_00413c8d:
    # block 0x00413c8d: entered by je at 0x00413c4c, 36 instruction(s), calls FUN_00412db8, ends with jne to 0x00413d26 (forward)
    movsx edx, word ptr [ebp - local_9cc4]       # 00413c8d
    shl edx, 0x4                                 # 00413c94
    movsx eax, word ptr [ebp - local_9cc4]       # 00413c97
    shl eax, 0x4                                 # 00413c9e
    mov ecx, dword ptr [edx + 0x5afc86]          # 00413ca1
    sub ecx, dword ptr [eax + 0x5afc7e]          # 00413ca7
    add ecx, 0x3                                 # 00413cad
    mov dx, word ptr [ebp - local_8]             # 00413cb0
    {load} add dx, cx                            # 00413cb4
    mov word ptr [ebp - local_8], dx             # 00413cb7
    mov eax, dword ptr [ebp - local_9cf8]        # 00413cbb
    mov ecx, dword ptr [eax + field_a]           # 00413cc1
    push ecx                                     # 00413cc4
    mov dx, word ptr [ebp - local_9ca8]          # 00413cc5
    push edx                                     # 00413ccc
    lea eax, [ebp - local_48]                    # 00413ccd
    push eax                                     # 00413cd0
    lea ecx, [ebp - local_8]                     # 00413cd1
    push ecx                                     # 00413cd4
    mov dx, word ptr [ebp - local_9ce4]          # 00413cd5
    push edx                                     # 00413cdc
    mov ax, word ptr [ebp - local_9ce8]          # 00413cdd
    push eax                                     # 00413ce4
    lea ecx, [ebp - local_20]                    # 00413ce5
    push ecx                                     # 00413ce8
    lea edx, [ebp - local_54]                    # 00413ce9
    push edx                                     # 00413cec
    mov ax, word ptr [ebp - local_9cac]          # 00413ced
    push eax                                     # 00413cf4
    lea ecx, [ebp - local_9c9c]                  # 00413cf5
    push ecx                                     # 00413cfb
    mov ecx, dword ptr [ebp - local_9cf8]        # 00413cfc
    call FUN_00412db8                            # 00413d02
    movsx edx, word ptr [ebp - local_48]         # 00413d07
    test edx, edx                                # 00413d0b
    jne.d8 L_00413d26                            # 00413d0d
    # block 0x00413d0f: entered by fall-through of jne at 0x00413d0d, 5 instruction(s), falls into the block at 0x00413d26
    mov eax, dword ptr [ebp - local_9cb0]        # 00413d0f
    sub eax, dword ptr [ebp - local_9cb8]        # 00413d15
    mov cx, word ptr [ebp - local_20]            # 00413d1b
    {load} add cx, ax                            # 00413d1f
    mov word ptr [ebp - local_20], cx            # 00413d22
L_00413d26:
    # block 0x00413d26: entered by jne at 0x00413d0d, 1 instruction(s), ends with forward jump to 0x0041413f
    jmp.d32 L_0041413f                           # 00413d26
L_00413d2b:
    # block 0x00413d2b: entered by switch case, 29 instruction(s), calls FUN_00412db8, FUN_0050cb1b, ends with forward jump to 0x0041413f
    mov edx, dword ptr [ebp - local_9cf8]        # 00413d2b
    mov eax, dword ptr [edx + field_a]           # 00413d31
    push eax                                     # 00413d34
    mov cx, word ptr [ebp - local_9ca8]          # 00413d35
    push ecx                                     # 00413d3c
    lea edx, [ebp - local_48]                    # 00413d3d
    push edx                                     # 00413d40
    lea eax, [ebp - local_8]                     # 00413d41
    push eax                                     # 00413d44
    mov cx, word ptr [ebp - local_9ce4]          # 00413d45
    push ecx                                     # 00413d4c
    mov dx, word ptr [ebp - local_9ce8]          # 00413d4d
    push edx                                     # 00413d54
    lea eax, [ebp - local_20]                    # 00413d55
    push eax                                     # 00413d58
    lea ecx, [ebp - local_54]                    # 00413d59
    push ecx                                     # 00413d5c
    mov dx, word ptr [ebp - local_9cac]          # 00413d5d
    push edx                                     # 00413d64
    lea eax, [ebp - local_9c9c]                  # 00413d65
    push eax                                     # 00413d6b
    mov ecx, dword ptr [ebp - local_9cf8]        # 00413d6c
    call FUN_00412db8                            # 00413d72
    lea ecx, [ebp - local_40]                    # 00413d77
    push ecx                                     # 00413d7a
    call FUN_0050cb1b                            # 00413d7b
    add esp, 0x4                                 # 00413d80
    mov word ptr [ebp - local_9ca8], ax          # 00413d83
    jmp.d32 L_0041413f                           # 00413d8a
L_00413d8f:
    # block 0x00413d8f: entered by switch case, 14 instruction(s), calls FUN_0050cb1b, ends with jne to 0x00413deb (forward)
    mov word ptr [ebp - local_9cf0], 0x0         # 00413d8f
    lea edx, [ebp - local_40]                    # 00413d98
    push edx                                     # 00413d9b
    call FUN_0050cb1b                            # 00413d9c
    add esp, 0x4                                 # 00413da1
    mov word ptr [ebp - local_9cc4], ax          # 00413da4
    movsx eax, word ptr [ebp - local_8]          # 00413dab
    movsx ecx, word ptr [ebp - local_9cc4]       # 00413daf
    shl ecx, 0x4                                 # 00413db6
    mov edx, dword ptr [ebp - local_9cf8]        # 00413db9
    mov dword ptr [edx + ecx + field_102e], eax  # 00413dbf
    movsx eax, word ptr [ebp - local_48]         # 00413dc6
    test eax, eax                                # 00413dca
    jne.d8 L_00413deb                            # 00413dcc
    # block 0x00413dce: entered by fall-through of jne at 0x00413dcc, 5 instruction(s), ends with forward jump to 0x00413e06
    movsx ecx, word ptr [ebp - local_9cc4]       # 00413dce
    shl ecx, 0x4                                 # 00413dd5
    mov edx, dword ptr [ebp - local_9cf8]        # 00413dd8
    mov dword ptr [edx + ecx + field_1032], 0x0  # 00413dde
    jmp.d8 L_00413e06                            # 00413de9
L_00413deb:
    # block 0x00413deb: entered by jne at 0x00413dcc, 5 instruction(s), falls into the block at 0x00413e06
    movsx eax, word ptr [ebp - local_20]         # 00413deb
    movsx ecx, word ptr [ebp - local_9cc4]       # 00413def
    shl ecx, 0x4                                 # 00413df6
    mov edx, dword ptr [ebp - local_9cf8]        # 00413df9
    mov dword ptr [edx + ecx + field_1032], eax  # 00413dff
L_00413e06:
    # block 0x00413e06: entered by jmp at 0x00413de9, 6 instruction(s), ends with forward jump to 0x0041413f
    movsx eax, word ptr [ebp - local_8]          # 00413e06
    movsx ecx, word ptr [ebp - local_9cc4]       # 00413e0a
    shl ecx, 0x4                                 # 00413e11
    mov edx, dword ptr [ebp - local_9cf8]        # 00413e14
    mov dword ptr [edx + ecx + field_102e], eax  # 00413e1a
    jmp.d32 L_0041413f                           # 00413e21
L_00413e26:
    # block 0x00413e26: entered by switch case, 11 instruction(s), ends with jle to 0x00413e7f (forward)
    movsx eax, word ptr [ebp - local_20]         # 00413e26
    movsx ecx, word ptr [ebp - local_9cc4]       # 00413e2a
    shl ecx, 0x4                                 # 00413e31
    mov edx, dword ptr [ebp - local_9cf8]        # 00413e34
    mov dword ptr [edx + ecx + field_103a], eax  # 00413e3a
    movsx eax, word ptr [ebp - local_9cf0]       # 00413e41
    movsx ecx, word ptr [ebp - local_9cc4]       # 00413e48
    shl ecx, 0x4                                 # 00413e4f
    mov edx, dword ptr [ebp - local_9cf8]        # 00413e52
    cmp eax, dword ptr [edx + ecx + field_1036]  # 00413e58
    jle.d8 L_00413e7f                            # 00413e5f
    # block 0x00413e61: entered by fall-through of jle at 0x00413e5f, 5 instruction(s), falls into the block at 0x00413e7f
    movsx eax, word ptr [ebp - local_9cf0]       # 00413e61
    movsx ecx, word ptr [ebp - local_9cc4]       # 00413e68
    shl ecx, 0x4                                 # 00413e6f
    mov edx, dword ptr [ebp - local_9cf8]        # 00413e72
    mov dword ptr [edx + ecx + field_1036], eax  # 00413e78
L_00413e7f:
    # block 0x00413e7f: entered by jle at 0x00413e5f, 1 instruction(s), ends with forward jump to 0x0041413f
    jmp.d32 L_0041413f                           # 00413e7f
L_00413e84:
    # block 0x00413e84: entered by switch case, 2 instruction(s), ends with forward jump to 0x0041413f
    mov dword ptr [ebp - local_24], 0x1          # 00413e84
    jmp.d32 L_0041413f                           # 00413e8b
L_00413e90:
    # block 0x00413e90: entered by switch case, 51 instruction(s), calls FUN_00412db8, FUN_004c92c5, FUN_0050cb1b, FUN_004c924d, FUN_004d3836, ends with jne to 0x00413f79 (forward)
    mov eax, dword ptr [ebp - local_9cf8]        # 00413e90
    mov ecx, dword ptr [eax + field_a]           # 00413e96
    push ecx                                     # 00413e99
    mov dx, word ptr [ebp - local_9ca8]          # 00413e9a
    push edx                                     # 00413ea1
    lea eax, [ebp - local_48]                    # 00413ea2
    push eax                                     # 00413ea5
    lea ecx, [ebp - local_8]                     # 00413ea6
    push ecx                                     # 00413ea9
    mov dx, word ptr [ebp - local_9ce4]          # 00413eaa
    push edx                                     # 00413eb1
    mov ax, word ptr [ebp - local_9ce8]          # 00413eb2
    push eax                                     # 00413eb9
    lea ecx, [ebp - local_20]                    # 00413eba
    push ecx                                     # 00413ebd
    lea edx, [ebp - local_54]                    # 00413ebe
    push edx                                     # 00413ec1
    mov ax, word ptr [ebp - local_9cac]          # 00413ec2
    push eax                                     # 00413ec9
    lea ecx, [ebp - local_9c9c]                  # 00413eca
    push ecx                                     # 00413ed0
    mov ecx, dword ptr [ebp - local_9cf8]        # 00413ed1
    call FUN_00412db8                            # 00413ed7
    mov dx, word ptr [ebp - local_9cac]          # 00413edc
    push edx                                     # 00413ee3
    mov ecx, 0x5cf659                            # 00413ee4
    call FUN_004c92c5                            # 00413ee9
    lea eax, [ebp - local_40]                    # 00413eee
    push eax                                     # 00413ef1
    call FUN_0050cb1b                            # 00413ef2
    add esp, 0x4                                 # 00413ef7
    mov word ptr [ebp - local_9cac], ax          # 00413efa
    mov cx, word ptr [ebp - local_9cac]          # 00413f01
    push ecx                                     # 00413f08
    mov ecx, 0x5cf659                            # 00413f09
    call FUN_004c924d                            # 00413f0e
    movsx edx, word ptr [ebp - local_9cac]       # 00413f13
    imul edx, edx, 0x1d0                         # 00413f1a
    add edx, 0x5adb3a                            # 00413f20
    push edx                                     # 00413f26
    movsx eax, word ptr [ebp - local_9cac]       # 00413f27
    imul eax, eax, 0x7f3                         # 00413f2e
    add eax, 0x5a4c24                            # 00413f34
    push eax                                     # 00413f39
    push 0x541758                                # 00413f3a
    call FUN_004d3836                            # 00413f3f
    add esp, 0xc                                 # 00413f44
    mov word ptr [ebp - local_44], ax            # 00413f47
    movsx ecx, word ptr [ebp - local_48]         # 00413f4b
    test ecx, ecx                                # 00413f4f
    jne.d8 L_00413f79                            # 00413f51
    # block 0x00413f53: entered by fall-through of jne at 0x00413f51, 4 instruction(s), ends with je to 0x00413f79 (forward)
    movsx edx, word ptr [ebp - local_48]         # 00413f53
    movsx eax, word ptr [ebp - local_9cf4]       # 00413f57
    {load} cmp edx, eax                          # 00413f5e
    je.d8 L_00413f79                             # 00413f60
    # block 0x00413f62: entered by fall-through of je at 0x00413f60, 6 instruction(s), ends with forward jump to 0x00413fac
    mov ecx, dword ptr [ebp - local_9cd0]        # 00413f62
    movsx edx, word ptr [ecx + field_a]          # 00413f68
    movsx eax, word ptr [ebp - local_44]         # 00413f6c
    lea ecx, [edx + 2*eax]                       # 00413f70
    mov word ptr [ebp - local_20], cx            # 00413f73
    jmp.d8 L_00413fac                            # 00413f77
L_00413f79:
    # block 0x00413f79: entered by jne at 0x00413f51; je at 0x00413f60, 3 instruction(s), ends with jne to 0x00413fac (forward)
    movsx edx, word ptr [ebp - local_48]         # 00413f79
    test edx, edx                                # 00413f7d
    jne.d8 L_00413fac                            # 00413f7f
    # block 0x00413f81: entered by fall-through of jne at 0x00413f7f, 4 instruction(s), ends with jne to 0x00413fac (forward)
    movsx eax, word ptr [ebp - local_48]         # 00413f81
    movsx ecx, word ptr [ebp - local_9cf4]       # 00413f85
    {load} cmp eax, ecx                          # 00413f8c
    jne.d8 L_00413fac                            # 00413f8e
    # block 0x00413f90: entered by fall-through of jne at 0x00413f8e, 7 instruction(s), falls into the block at 0x00413fac
    mov edx, dword ptr [ebp - local_9cd0]        # 00413f90
    movsx eax, word ptr [edx + field_a]          # 00413f96
    movsx ecx, word ptr [ebp - local_44]         # 00413f9a
    lea edx, [eax + 2*ecx]                       # 00413f9e
    mov ax, word ptr [ebp - local_20]            # 00413fa1
    {load} add ax, dx                            # 00413fa5
    mov word ptr [ebp - local_20], ax            # 00413fa8
L_00413fac:
    # block 0x00413fac: entered by jmp at 0x00413f77; jne at 0x00413f7f; jne at 0x00413f8e, 7 instruction(s), ends with forward jump to 0x0041413f
    mov ecx, dword ptr [ebp - local_9cd0]        # 00413fac
    movsx edx, word ptr [ecx + field_8]          # 00413fb2
    movsx eax, word ptr [ebp - local_44]         # 00413fb6
    {load} add edx, eax                          # 00413fba
    mov ecx, dword ptr [ebp - local_9cf8]        # 00413fbc
    mov word ptr [ecx + field_292e], dx          # 00413fc2
    jmp.d32 L_0041413f                           # 00413fc9
L_00413fce:
    # block 0x00413fce: entered by switch case, 27 instruction(s), calls FUN_00412db8, ends with jge to 0x00414034 (forward)
    mov edx, dword ptr [ebp - local_9cf8]        # 00413fce
    mov eax, dword ptr [edx + field_a]           # 00413fd4
    push eax                                     # 00413fd7
    mov cx, word ptr [ebp - local_9ca8]          # 00413fd8
    push ecx                                     # 00413fdf
    lea edx, [ebp - local_48]                    # 00413fe0
    push edx                                     # 00413fe3
    lea eax, [ebp - local_8]                     # 00413fe4
    push eax                                     # 00413fe7
    mov cx, word ptr [ebp - local_9ce4]          # 00413fe8
    push ecx                                     # 00413fef
    mov dx, word ptr [ebp - local_9ce8]          # 00413ff0
    push edx                                     # 00413ff7
    lea eax, [ebp - local_20]                    # 00413ff8
    push eax                                     # 00413ffb
    lea ecx, [ebp - local_54]                    # 00413ffc
    push ecx                                     # 00413fff
    mov dx, word ptr [ebp - local_9cac]          # 00414000
    push edx                                     # 00414007
    lea eax, [ebp - local_9c9c]                  # 00414008
    push eax                                     # 0041400e
    mov ecx, dword ptr [ebp - local_9cf8]        # 0041400f
    call FUN_00412db8                            # 00414015
    movsx ecx, word ptr [ebp - local_9cf0]       # 0041401a
    movsx edx, word ptr [ebp - local_8]          # 00414021
    {load} cmp ecx, edx                          # 00414025
    jge.d8 L_00414034                            # 00414027
    # block 0x00414029: entered by fall-through of jge at 0x00414027, 2 instruction(s), falls into the block at 0x00414034
    mov ax, word ptr [ebp - local_8]             # 00414029
    mov word ptr [ebp - local_9cf0], ax          # 0041402d
L_00414034:
    # block 0x00414034: entered by jge at 0x00414027, 4 instruction(s), ends with jne to 0x00414054 (forward)
    mov dword ptr [ebp - local_54], 0x1          # 00414034
    movsx ecx, byte ptr [ebp - local_5c]         # 0041403b
    cmp ecx, 0x77                                # 0041403f
    jne.d8 L_00414054                            # 00414042
    # block 0x00414044: entered by fall-through of jne at 0x00414042, 2 instruction(s), falls into the block at 0x00414054
    mov edx, dword ptr [ebp - local_9cf8]        # 00414044
    mov dword ptr [edx + field_2942], 0x1        # 0041404a
L_00414054:
    # block 0x00414054: entered by jne at 0x00414042, 4 instruction(s), ends with forward jump to 0x0041413f
    mov ax, word ptr [ebp - local_48]            # 00414054
    .insn 0x66, 0x05, 0x0001{:u16}               # 00414058
    mov word ptr [ebp - local_48], ax            # 0041405c
    jmp.d32 L_0041413f                           # 00414060
L_00414065:
    # block 0x00414065: entered by switch case, 44 instruction(s), calls FUN_004d3836, FUN_00412db8, ends with forward jump to 0x0041413f
    movsx esi, word ptr [ebp - local_9ce4]       # 00414065
    movsx ecx, word ptr [ebp - local_9cac]       # 0041406c
    imul ecx, ecx, 0x1d0                         # 00414073
    add ecx, 0x5adb3a                            # 00414079
    push ecx                                     # 0041407f
    movsx edx, word ptr [ebp - local_9cac]       # 00414080
    imul edx, edx, 0x7f3                         # 00414087
    add edx, 0x5a4c24                            # 0041408d
    push edx                                     # 00414093
    lea eax, [ebp - local_9c9c]                  # 00414094
    push eax                                     # 0041409a
    call FUN_004d3836                            # 0041409b
    add esp, 0xc                                 # 004140a0
    movsx ecx, ax                                # 004140a3
    {load} sub esi, ecx                          # 004140a6
    mov word ptr [ebp - local_8], si             # 004140a8
    mov edx, dword ptr [ebp - local_9cf8]        # 004140ac
    mov eax, dword ptr [edx + field_a]           # 004140b2
    push eax                                     # 004140b5
    mov cx, word ptr [ebp - local_9ca8]          # 004140b6
    push ecx                                     # 004140bd
    lea edx, [ebp - local_48]                    # 004140be
    push edx                                     # 004140c1
    lea eax, [ebp - local_8]                     # 004140c2
    push eax                                     # 004140c5
    mov cx, word ptr [ebp - local_9ce4]          # 004140c6
    push ecx                                     # 004140cd
    mov dx, word ptr [ebp - local_9ce8]          # 004140ce
    push edx                                     # 004140d5
    lea eax, [ebp - local_20]                    # 004140d6
    push eax                                     # 004140d9
    lea ecx, [ebp - local_54]                    # 004140da
    push ecx                                     # 004140dd
    mov dx, word ptr [ebp - local_9cac]          # 004140de
    push edx                                     # 004140e5
    lea eax, [ebp - local_9c9c]                  # 004140e6
    push eax                                     # 004140ec
    mov ecx, dword ptr [ebp - local_9cf8]        # 004140ed
    call FUN_00412db8                            # 004140f3
    mov dword ptr [ebp - local_54], 0x1          # 004140f8
    mov cx, word ptr [ebp - local_48]            # 004140ff
    add cx, 0x1                                  # 00414103
    mov word ptr [ebp - local_48], cx            # 00414107
    jmp.d8 L_0041413f                            # 0041410b
L_0041410d:
    # block 0x0041410d: entered by switch case, 20 instruction(s), falls into the block at 0x0041413f
    lea edi, [ebp - local_1c]                    # 0041410d
    lea edx, [ebp - local_9c9c]                  # 00414110
    or ecx, -0x1                                 # 00414116
    {load} xor eax, eax                          # 00414119
    repne scasb al, byte ptr es:[edi]            # 0041411b
    not ecx                                      # 0041411d
    {load} sub edi, ecx                          # 0041411f
    {load} mov esi, edi                          # 00414121
    {load} mov ebx, ecx                          # 00414123
    {load} mov edi, edx                          # 00414125
    or ecx, -0x1                                 # 00414127
    {load} xor eax, eax                          # 0041412a
    repne scasb al, byte ptr es:[edi]            # 0041412c
    add edi, -0x1                                # 0041412e
    {load} mov ecx, ebx                          # 00414131
    shr ecx, 0x2                                 # 00414133
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00414136
    {load} mov ecx, ebx                          # 00414138
    and ecx, 0x3                                 # 0041413a
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0041413d
L_0041413f:
    # block 0x0041413f: entered by ja at 0x0041384b; jmp at 0x0041392f; jmp at 0x00413b40; jmp at 0x00413d26; more, 6 instruction(s), ends with forward jump to 0x004141be
    mov ecx, 0x6                                 # 0041413f
    {load} xor eax, eax                          # 00414144
    lea edi, [ebp - local_40]                    # 00414146
    rep stosd dword ptr es:[edi], eax            # 00414149
    stosb byte ptr es:[edi], al                  # 0041414b
    jmp.d8 L_004141be                            # 0041414c
L_0041414e:
    # block 0x0041414e: entered by jmp at 0x004137fe, 2 instruction(s), ends with je to 0x00414174 (forward)
    cmp dword ptr [ebp - local_9cc0], 0x0        # 0041414e
    je.d8 L_00414174                             # 00414155
    # block 0x00414157: entered by fall-through of je at 0x00414155, 2 instruction(s), ends with jne to 0x00414174 (forward)
    cmp dword ptr [ebp - local_9ca0], 0x0        # 00414157
    jne.d8 L_00414174                            # 0041415e
    # block 0x00414160: entered by fall-through of jne at 0x0041415e, 5 instruction(s), ends with forward jump to 0x004141be
    mov eax, dword ptr [ebp + arg_c]             # 00414160
    mov cl, byte ptr [eax]                       # 00414163
    mov byte ptr [ebp - local_5c], cl            # 00414165
    mov dword ptr [ebp - local_9ca0], 0x1        # 00414168
    jmp.d8 L_004141be                            # 00414172
L_00414174:
    # block 0x00414174: entered by je at 0x00414155; jne at 0x0041415e, 2 instruction(s), ends with je to 0x004141a0 (forward)
    cmp dword ptr [ebp - local_9cc0], 0x0        # 00414174
    je.d8 L_004141a0                             # 0041417b
    # block 0x0041417d: entered by fall-through of je at 0x0041417b, 2 instruction(s), ends with je to 0x004141a0 (forward)
    cmp dword ptr [ebp - local_9ca0], 0x0        # 0041417d
    je.d8 L_004141a0                             # 00414184
    # block 0x00414186: entered by fall-through of je at 0x00414184, 10 instruction(s), ends with forward jump to 0x004141be
    lea edi, [ebp - local_40]                    # 00414186
    or ecx, -0x1                                 # 00414189
    {load} xor eax, eax                          # 0041418c
    repne scasb al, byte ptr es:[edi]            # 0041418e
    not ecx                                      # 00414190
    add ecx, -0x1                                # 00414192
    mov edx, dword ptr [ebp + arg_c]             # 00414195
    mov al, byte ptr [edx]                       # 00414198
    mov byte ptr [ebp + ecx - local_40], al      # 0041419a
    jmp.d8 L_004141be                            # 0041419e
L_004141a0:
    # block 0x004141a0: entered by je at 0x0041417b; je at 0x00414184, 9 instruction(s), falls into the block at 0x004141be
    lea edi, [ebp - local_9c9c]                  # 004141a0
    or ecx, -0x1                                 # 004141a6
    {load} xor eax, eax                          # 004141a9
    repne scasb al, byte ptr es:[edi]            # 004141ab
    not ecx                                      # 004141ad
    add ecx, -0x1                                # 004141af
    mov edx, dword ptr [ebp + arg_c]             # 004141b2
    mov al, byte ptr [edx]                       # 004141b5
    mov byte ptr [ebp + ecx - local_9c9c], al    # 004141b7
L_004141be:
    # block 0x004141be: entered by jmp at 0x00413803; jmp at 0x0041381c; jmp at 0x0041414c; jmp at 0x00414172; more, 2 instruction(s), ends with je to 0x004141f2 (forward)
    cmp dword ptr [ebp - local_54], 0x0          # 004141be
    je.d8 L_004141f2                             # 004141c2
    # block 0x004141c4: entered by fall-through of je at 0x004141c2, 9 instruction(s), falls into the block at 0x004141f2
    mov ecx, dword ptr [ebp - local_9cd0]        # 004141c4
    movsx edx, word ptr [ecx + field_8]          # 004141ca
    movsx eax, word ptr [ebp - local_44]         # 004141ce
    {load} add edx, eax                          # 004141d2
    mov ecx, dword ptr [ebp - local_9cf8]        # 004141d4
    mov word ptr [ecx + field_292e], dx          # 004141da
    mov edx, dword ptr [ebp - local_9cf8]        # 004141e1
    mov ax, word ptr [edx + field_292e]          # 004141e7
    mov word ptr [ebp - local_8], ax             # 004141ee
L_004141f2:
    # block 0x004141f2: entered by je at 0x004141c2, 2 instruction(s), ends with je to 0x004141fa (forward)
    cmp dword ptr [ebp - local_24], 0x0          # 004141f2
    je.d8 L_004141fa                             # 004141f6
    # block 0x004141f8: entered by fall-through of je at 0x004141f6, 1 instruction(s), ends with forward jump to 0x004141ff
    jmp.d8 L_004141ff                            # 004141f8
L_004141fa:
    # block 0x004141fa: entered by je at 0x004141f6, 1 instruction(s), ends with backward jump to 0x004135fb
    jmp.d32 L_004135fb                           # 004141fa
L_004141ff:
    # block 0x004141ff: entered by jge at 0x00413616; jmp at 0x004141f8, 17 instruction(s), ends with jbe to 0x0041428f (forward)
    mov ecx, dword ptr [ebp - local_9cd0]        # 004141ff
    movsx edx, word ptr [ecx + field_8]          # 00414205
    movsx eax, word ptr [ebp - local_44]         # 00414209
    {load} add edx, eax                          # 0041420d
    mov ecx, dword ptr [ebp - local_9cf8]        # 0041420f
    mov word ptr [ecx + field_292e], dx          # 00414215
    mov edx, dword ptr [ebp - local_9cf8]        # 0041421c
    mov ax, word ptr [edx + field_292e]          # 00414222
    mov word ptr [ebp - local_8], ax             # 00414229
    lea edi, [ebp - local_9c9c]                  # 0041422d
    or ecx, -0x1                                 # 00414233
    {load} xor eax, eax                          # 00414236
    repne scasb al, byte ptr es:[edi]            # 00414238
    not ecx                                      # 0041423a
    add ecx, -0x1                                # 0041423c
    test ecx, ecx                                # 0041423f
    jbe.d8 L_0041428f                            # 00414241
    # block 0x00414243: entered by fall-through of jbe at 0x00414241, 23 instruction(s), calls FUN_00412db8, falls into the block at 0x0041428f
    mov ecx, dword ptr [ebp - local_9cf8]        # 00414243
    mov edx, dword ptr [ecx + field_a]           # 00414249
    push edx                                     # 0041424c
    mov ax, word ptr [ebp - local_9ca8]          # 0041424d
    push eax                                     # 00414254
    lea ecx, [ebp - local_48]                    # 00414255
    push ecx                                     # 00414258
    lea edx, [ebp - local_8]                     # 00414259
    push edx                                     # 0041425c
    mov ax, word ptr [ebp - local_9ce4]          # 0041425d
    push eax                                     # 00414264
    mov cx, word ptr [ebp - local_9ce8]          # 00414265
    push ecx                                     # 0041426c
    lea edx, [ebp - local_20]                    # 0041426d
    push edx                                     # 00414270
    lea eax, [ebp - local_54]                    # 00414271
    push eax                                     # 00414274
    mov cx, word ptr [ebp - local_9cac]          # 00414275
    push ecx                                     # 0041427c
    lea edx, [ebp - local_9c9c]                  # 0041427d
    push edx                                     # 00414283
    mov ecx, dword ptr [ebp - local_9cf8]        # 00414284
    call FUN_00412db8                            # 0041428a
L_0041428f:
    # block 0x0041428f: entered by jbe at 0x00414241, 3 instruction(s), ends with je to 0x004143bb (forward)
    mov eax, dword ptr [ebp - local_9cf8]        # 0041428f
    cmp dword ptr [eax + field_2930], 0x0        # 00414295
    je.d32 L_004143bb                            # 0041429c
    # block 0x004142a2: entered by fall-through of je at 0x0041429c, 2 instruction(s), ends with forward jump to 0x004142b6
    mov word ptr [ebp - local_4c], 0x0           # 004142a2
    jmp.d8 L_004142b6                            # 004142a8
L_004142aa:
    # block 0x004142aa: entered by jmp at 0x004143b6, 3 instruction(s), falls into the block at 0x004142b6
    mov cx, word ptr [ebp - local_4c]            # 004142aa
    add cx, 0x1                                  # 004142ae
    mov word ptr [ebp - local_4c], cx            # 004142b2
L_004142b6:
    # block 0x004142b6: entered by jmp at 0x004142a8, 5 instruction(s), ends with jge to 0x004143bb (forward)
    movsx edx, word ptr [ebp - local_4c]         # 004142b6
    mov eax, dword ptr [ebp - local_9cd0]        # 004142ba
    movsx ecx, word ptr [eax + field_31]         # 004142c0
    {load} cmp edx, ecx                          # 004142c4
    jge.d32 L_004143bb                           # 004142c6
    # block 0x004142cc: entered by fall-through of jge at 0x004142c6, 7 instruction(s), ends with jg to 0x004143b6 (forward)
    movsx edx, word ptr [ebp - local_48]         # 004142cc
    movsx eax, word ptr [ebp - local_4c]         # 004142d0
    imul eax, eax, 0x12                          # 004142d4
    mov ecx, dword ptr [ebp - local_9cd0]        # 004142d7
    movsx eax, word ptr [ecx + eax + field_33]   # 004142dd
    {load} cmp edx, eax                          # 004142e2
    jg.d32 L_004143b6                            # 004142e4
    # block 0x004142ea: entered by fall-through of jg at 0x004142e4, 48 instruction(s), calls FUN_004c5b3a, falls into the block at 0x004143b6
    movsx ecx, word ptr [ebp - local_20]         # 004142ea
    movsx edx, word ptr [ebp - local_44]         # 004142ee
    {load} add ecx, edx                          # 004142f2
    mov dword ptr [ebp - local_9cb8], ecx        # 004142f4
    movsx eax, word ptr [ebp - local_4c]         # 004142fa
    imul eax, eax, 0x12                          # 004142fe
    mov ecx, dword ptr [ebp - local_9cd0]        # 00414301
    mov edx, dword ptr [ebp - local_9cb8]        # 00414307
    add edx, dword ptr [ecx + eax + field_41]    # 0041430d
    movsx eax, word ptr [ebp - local_4c]         # 00414311
    imul eax, eax, 0x12                          # 00414315
    mov ecx, dword ptr [ebp - local_9cd0]        # 00414318
    sub edx, dword ptr [ecx + eax + field_39]    # 0041431e
    mov dword ptr [ebp - local_9cb0], edx        # 00414322
    movsx edx, word ptr [ebp - local_8]          # 00414328
    mov dword ptr [ebp - local_9cbc], edx        # 0041432c
    movsx eax, word ptr [ebp - local_4c]         # 00414332
    imul eax, eax, 0x12                          # 00414336
    mov ecx, dword ptr [ebp - local_9cd0]        # 00414339
    mov edx, dword ptr [ebp - local_9cbc]        # 0041433f
    add edx, dword ptr [ecx + eax + field_3d]    # 00414345
    movsx eax, word ptr [ebp - local_4c]         # 00414349
    imul eax, eax, 0x12                          # 0041434d
    mov ecx, dword ptr [ebp - local_9cd0]        # 00414350
    sub edx, dword ptr [ecx + eax + field_35]    # 00414356
    mov dword ptr [ebp - local_9cb4], edx        # 0041435a
    push 0x54175c                                # 00414360
    lea edx, [ebp - local_9cbc]                  # 00414365
    push edx                                     # 0041436b
    movsx eax, word ptr [ebp - local_4c]         # 0041436c
    imul eax, eax, 0x12                          # 00414370
    mov ecx, dword ptr [ebp - local_9cd0]        # 00414373
    lea edx, [ecx + eax + field_35]              # 00414379
    push edx                                     # 0041437d
    mov eax, dword ptr [ebp - local_9cf8]        # 0041437e
    mov ecx, dword ptr [eax + field_a]           # 00414384
    push ecx                                     # 00414387
    mov edx, dword ptr [ebp - local_9cf8]        # 00414388
    mov eax, dword ptr [edx + field_6]           # 0041438e
    push eax                                     # 00414391
    mov ecx, 0x5cf659                            # 00414392
    call FUN_004c5b3a                            # 00414397
    movsx ecx, word ptr [ebp - local_20]         # 0041439c
    add ecx, dword ptr [ebp - local_9cb0]        # 004143a0
    sub ecx, dword ptr [ebp - local_9cb8]        # 004143a6
    movsx edx, word ptr [ebp - local_44]         # 004143ac
    {load} add ecx, edx                          # 004143b0
    mov word ptr [ebp - local_20], cx            # 004143b2
L_004143b6:
    # block 0x004143b6: entered by jg at 0x004142e4, 1 instruction(s), ends with backward jump to 0x004142aa
    jmp.d32 L_004142aa                           # 004143b6
L_004143bb:
    # block 0x004143bb: entered by je at 0x0041429c; jge at 0x004142c6, 12 instruction(s), calls FUN_004c92c5, ends with je to 0x00414405 (forward)
    movsx eax, word ptr [ebp - local_20]         # 004143bb
    mov ecx, dword ptr [ebp - local_9cf8]        # 004143bf
    movsx edx, word ptr [ecx + field_4]          # 004143c5
    mov ecx, dword ptr [ebp - local_9cf8]        # 004143c9
    mov dword ptr [ecx + 4*edx + field_12], eax  # 004143cf
    mov dx, word ptr [ebp - local_9cac]          # 004143d3
    push edx                                     # 004143da
    mov ecx, 0x5cf659                            # 004143db
    call FUN_004c92c5                            # 004143e0
    mov eax, dword ptr [ebp - local_9cf8]        # 004143e5
    cmp dword ptr [eax + field_6], 0x0           # 004143eb
    je.d8 L_00414405                             # 004143ef
    # block 0x004143f1: entered by fall-through of je at 0x004143ef, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x00414405
    mov ecx, dword ptr [ebp - local_9cf8]        # 004143f1
    add ecx, 0x6                                 # 004143f7
    push ecx                                     # 004143fa
    mov ecx, 0x5cf659                            # 004143fb
    call FUN_004c2dfb                            # 00414400
L_00414405:
    # block 0x00414405: entered by je at 0x004143ef, 6 instruction(s), ends with ret 0x10
    pop edi                                      # 00414405
    pop esi                                      # 00414406
    pop ebx                                      # 00414407
    {load} mov esp, ebp                          # 00414408
    pop ebp                                      # 0041440a
    ret 0x10                                     # 0041440b

# --- data items (not part of the function) -------------------------
.org 0x0041440e - 0x401000
SWTAB_0041440e:  # 12 case address(es)
    .long L_00413b45 - .text + 0x401000
    .long L_00413d8f - .text + 0x401000
    .long L_00413e26 - .text + 0x401000
    .long L_00413d2b - .text + 0x401000
    .long L_00413e84 - .text + 0x401000
    .long L_00413e90 - .text + 0x401000
    .long L_00413866 - .text + 0x401000
    .long L_00413fce - .text + 0x401000
    .long L_00414065 - .text + 0x401000
    .long L_0041410d - .text + 0x401000
    .long L_00413934 - .text + 0x401000
    .long L_0041413f - .text + 0x401000
.org 0x0041443e - 0x401000
IDXTAB_0041443e:  # index table of FUN_00413187 for the switch jump at 0x0041385f (71 byte(s))
    .byte 0, 0, 0, 0, 0, 11, 0, 11, 11, 11, 11, 11, 11, 11, 11, 11
    .byte 11, 11, 11, 11, 11, 11, 11, 1, 11, 11, 11, 2, 11, 11, 11, 11
    .byte 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11
    .byte 11, 11, 3, 11, 4, 5, 11, 11, 11, 11, 11, 6, 11, 7, 11, 11
    .byte 11, 8, 11, 9, 10, 11, 7
.org 0x00414485 - 0x401000
PAD_00414485:  # 11 byte(s) of int3 padding
    .fill 11, 1, 0xcc
.set SWTAB_0041440e_VA, SWTAB_0041440e - .text + 0x401000
.set IDXTAB_0041443e_VA, IDXTAB_0041443e - .text + 0x401000

