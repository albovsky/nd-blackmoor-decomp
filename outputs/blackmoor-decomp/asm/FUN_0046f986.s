# FUN_0046f986
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046f986
# extent:       0x0046f986-0x00470993 (4109 code bytes)
# span:         0x0046f986-0x004709bb (code 4109, tables 40, padding 0)
# sha256:       828180ff64d8627c87eb28348d59e3d8ed47fad98a795874c7350ce26a48856a
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0046f986
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       28 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30, local_34 and 16 more
# fields:       [eax + n] field_1, field_1c, field_1e, field_2c, field_32, field_36, field_4a, field_4e, field_53, field_5b, field_5f, field_67 and 14 more; [ecx + n] field_1, field_1c, field_20, field_21, field_23, field_28, field_2c, field_36, field_4e, field_52, field_53, field_54 and 16 more; [edx + n] field_1c, field_1e, field_21, field_2c, field_2e, field_36, field_46, field_4a, field_53, field_5b, field_5f, field_67 and 14 more
# callees:      calls FUN_004e8d96, FUN_004d39f9, FUN_004c2790, FUN_004fb77a, KERNEL32.dll!GetTickCount, FUN_004709bb, FUN_004709de, FUN_0046f8ae, FUN_0051e745, FUN_0046f77c, FUN_0046f4b0, FUN_0046ee20, FUN_0051ea48, FUN_0051e8a7, FUN_0051ea21, FUN_0051ea75 and 7 more
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1076 instruction(s), 77 conditional branch(es) and 2 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_minus_8, 0x8  # offset -0x8
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
.equ local_4c, 0x4c  # offset -0x4c
.equ local_4d, 0x4d  # offset -0x4d
.equ local_4e, 0x4e  # offset -0x4e
.equ local_54, 0x54  # offset -0x54
.equ local_58, 0x58  # offset -0x58
.equ local_5c, 0x5c  # offset -0x5c
.equ local_60, 0x60  # offset -0x60
.equ local_61, 0x61  # offset -0x61
.equ local_62, 0x62  # offset -0x62
.equ local_68, 0x68  # offset -0x68
.equ local_6c, 0x6c  # offset -0x6c
.equ field_1, 0x1  # offset +0x1
.equ arg_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_2e, 0x2e  # offset +0x2e
.equ field_32, 0x32  # offset +0x32
.equ field_36, 0x36  # offset +0x36
.equ field_46, 0x46  # offset +0x46
.equ field_4a, 0x4a  # offset +0x4a
.equ field_4e, 0x4e  # offset +0x4e
.equ field_52, 0x52  # offset +0x52
.equ field_53, 0x53  # offset +0x53
.equ field_54, 0x54  # offset +0x54
.equ field_5b, 0x5b  # offset +0x5b
.equ field_5f, 0x5f  # offset +0x5f
.equ field_67, 0x67  # offset +0x67
.equ field_87, 0x87  # offset +0x87
.equ field_8c, 0x8c  # offset +0x8c
.equ field_8d, 0x8d  # offset +0x8d
.equ field_173, 0x173  # offset +0x173
.equ field_196, 0x196  # offset +0x196
.equ field_198, 0x198  # offset +0x198
.equ field_63d, 0x63d  # offset +0x63d
.equ field_e73, 0xe73  # offset +0xe73
.equ field_e75, 0xe75  # offset +0xe75
.equ field_e77, 0xe77  # offset +0xe77
.equ field_e79, 0xe79  # offset +0xe79
.equ field_e7b, 0xe7b  # offset +0xe7b
.equ field_e7f, 0xe7f  # offset +0xe7f
.equ field_e83, 0xe83  # offset +0xe83
.equ field_e87, 0xe87  # offset +0xe87
.equ field_e89, 0xe89  # offset +0xe89
.equ field_e8b, 0xe8b  # offset +0xe8b
.equ field_f43, 0xf43  # offset +0xf43
.equ field_f45, 0xf45  # offset +0xf45
.equ field_f47, 0xf47  # offset +0xf47
.equ field_f49, 0xf49  # offset +0xf49
.equ field_f4b, 0xf4b  # offset +0xf4b
.equ field_f4f, 0xf4f  # offset +0xf4f
.equ field_f53, 0xf53  # offset +0xf53
.equ field_f57, 0xf57  # offset +0xf57
.equ field_f59, 0xf59  # offset +0xf59
.equ field_f5b, 0xf5b  # offset +0xf5b

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_00448d11, .text + (0x00448d11 - 0x401000)
.set FUN_0046e7a6, .text + (0x0046e7a6 - 0x401000)
.set FUN_0046ee20, .text + (0x0046ee20 - 0x401000)
.set FUN_0046f4b0, .text + (0x0046f4b0 - 0x401000)
.set FUN_0046f77c, .text + (0x0046f77c - 0x401000)
.set FUN_0046f8ae, .text + (0x0046f8ae - 0x401000)
.set FUN_004709bb, .text + (0x004709bb - 0x401000)
.set FUN_004709de, .text + (0x004709de - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)
.set FUN_0051e745, .text + (0x0051e745 - 0x401000)
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)
.set FUN_0051e8a7, .text + (0x0051e8a7 - 0x401000)
.set FUN_0051ea21, .text + (0x0051ea21 - 0x401000)
.set FUN_0051ea48, .text + (0x0051ea48 - 0x401000)
.set FUN_0051ea75, .text + (0x0051ea75 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x0046f986 - 0x401000
.globl FUN_0046f986
FUN_0046f986:
    # block 0x0046f986: entry, 24 instruction(s), ends with ja to 0x00470972 (forward)
    push ebp                                     # 0046f986
    {load} mov ebp, esp                          # 0046f987
    push -0x1                                    # 0046f989
    push 0x528265                                # 0046f98b
    mov eax, dword ptr fs:[0x0]                  # 0046f990
    push eax                                     # 0046f996
    mov dword ptr fs:[0x0], esp                  # 0046f997
    sub esp, 0x60                                # 0046f99e
    push esi                                     # 0046f9a1
    push edi                                     # 0046f9a2
    mov dword ptr [ebp - local_3c], ecx          # 0046f9a3
    mov eax, dword ptr [0x5679b0]                # 0046f9a6
    mov dword ptr [ebp - local_1c], eax          # 0046f9ab
    mov dword ptr [ebp - local_4], 0x0           # 0046f9ae
    movsx ecx, word ptr [ebp + arg_8]            # 0046f9b5
    imul ecx, ecx, 0x8d                          # 0046f9b9
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046f9bf
    mov dword ptr [ebp - local_24], edx          # 0046f9c5
    movsx eax, word ptr [ebp + arg_8]            # 0046f9c8
    imul eax, eax, 0x8d                          # 0046f9cc
    mov ecx, dword ptr [eax + 0x5bb632]          # 0046f9d2
    mov dword ptr [ebp - local_40], ecx          # 0046f9d8
    cmp dword ptr [ebp - local_40], 0x3          # 0046f9db
    ja.d32 L_00470972                            # 0046f9df
    # block 0x0046f9e5: entered by fall-through of ja at 0x0046f9df, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x470993]
    mov edx, dword ptr [ebp - local_40]          # 0046f9e5
    jmp dword ptr [4*edx + SWTAB_00470993_VA]    # 0046f9e8
L_0046f9ef:
    # block 0x0046f9ef: entered by switch case, 65 instruction(s), calls FUN_004e8d96, FUN_004d39f9, ends with jne to 0x0046fb20 (forward)
    mov eax, dword ptr [ebp - local_3c]          # 0046f9ef
    mov cx, word ptr [ebp + arg_8]               # 0046f9f2
    mov word ptr [eax + field_1e], cx            # 0046f9f6
    mov edx, dword ptr [ebp - local_3c]          # 0046f9fa
    mov dword ptr [edx + field_46], 0x1          # 0046f9fd
    mov dword ptr [0x5bb1ca], 0x1                # 0046fa04
    mov ecx, 0x571442                            # 0046fa0e
    call FUN_004e8d96                            # 0046fa13
    call FUN_004d39f9                            # 0046fa18
    mov ecx, dword ptr [ebp - local_3c]          # 0046fa1d
    mov word ptr [ecx + field_1c], ax            # 0046fa20
    mov edx, dword ptr [ebp - local_3c]          # 0046fa24
    movsx eax, word ptr [edx + field_1c]         # 0046fa27
    imul eax, eax, 0x4a                          # 0046fa2b
    mov dword ptr [eax + 0x5d1591], 0xa          # 0046fa2e
    mov ecx, dword ptr [ebp - local_3c]          # 0046fa38
    movsx edx, word ptr [ecx + field_1c]         # 0046fa3b
    imul edx, edx, 0x4a                          # 0046fa3f
    mov dword ptr [edx + 0x5d1595], 0x470a73     # 0046fa42
    mov eax, dword ptr [ebp - local_3c]          # 0046fa4c
    movsx ecx, word ptr [eax + field_1c]         # 0046fa4f
    imul ecx, ecx, 0x4a                          # 0046fa53
    mov dword ptr [ecx + 0x5d1599], 0x0          # 0046fa56
    mov edx, dword ptr [ebp - local_3c]          # 0046fa60
    movsx eax, word ptr [edx + field_1c]         # 0046fa63
    imul eax, eax, 0x4a                          # 0046fa67
    mov dword ptr [eax + 0x5d159d], 0x0          # 0046fa6a
    mov ecx, dword ptr [ebp - local_3c]          # 0046fa74
    movsx edx, word ptr [ecx + field_1c]         # 0046fa77
    imul edx, edx, 0x4a                          # 0046fa7b
    mov dword ptr [edx + 0x5d15a1], 0x0          # 0046fa7e
    mov eax, dword ptr [ebp - local_3c]          # 0046fa88
    movsx ecx, word ptr [eax + field_1c]         # 0046fa8b
    imul ecx, ecx, 0x4a                          # 0046fa8f
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 0046fa92
    mov edx, dword ptr [ebp - local_3c]          # 0046fa9c
    movsx eax, word ptr [edx + field_1c]         # 0046fa9f
    imul eax, eax, 0x4a                          # 0046faa3
    mov dword ptr [eax + 0x5d15a9], 0x1          # 0046faa6
    mov ecx, dword ptr [ebp - local_3c]          # 0046fab0
    movsx edx, word ptr [ecx + field_1c]         # 0046fab3
    imul edx, edx, 0x4a                          # 0046fab7
    mov word ptr [edx + 0x5d15ad], 0x0           # 0046faba
    mov edi, 0x54c18c                            # 0046fac3
    mov eax, dword ptr [ebp - local_3c]          # 0046fac8
    movsx ecx, word ptr [eax + field_1c]         # 0046facb
    imul ecx, ecx, 0x4a                          # 0046facf
    add ecx, 0x5d15b3                            # 0046fad2
    {load} mov edx, ecx                          # 0046fad8
    or ecx, -0x1                                 # 0046fada
    {load} xor eax, eax                          # 0046fadd
    repne scasb al, byte ptr es:[edi]            # 0046fadf
    not ecx                                      # 0046fae1
    {load} sub edi, ecx                          # 0046fae3
    {load} mov esi, edi                          # 0046fae5
    {load} mov eax, ecx                          # 0046fae7
    {load} mov edi, edx                          # 0046fae9
    shr ecx, 0x2                                 # 0046faeb
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0046faee
    {load} mov ecx, eax                          # 0046faf0
    and ecx, 0x3                                 # 0046faf2
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0046faf5
    mov ecx, dword ptr [ebp - local_3c]          # 0046faf7
    cmp dword ptr [ecx + field_20], 0x0          # 0046fafa
    jne.d8 L_0046fb20                            # 0046fafe
    # block 0x0046fb00: entered by fall-through of jne at 0x0046fafe, 9 instruction(s), calls FUN_004c2790, falls into the block at 0x0046fb20
    push 0x54c1a0                                # 0046fb00
    push 0x6                                     # 0046fb05
    mov edx, dword ptr [ebp - local_24]          # 0046fb07
    push edx                                     # 0046fb0a
    push 0x54c1b4                                # 0046fb0b
    mov ecx, 0x5cf659                            # 0046fb10
    call FUN_004c2790                            # 0046fb15
    mov ecx, dword ptr [ebp - local_3c]          # 0046fb1a
    mov dword ptr [ecx + field_20], eax          # 0046fb1d
L_0046fb20:
    # block 0x0046fb20: entered by jne at 0x0046fafe, 13 instruction(s), ends with je to 0x0046fb63 (forward)
    mov edx, dword ptr [ebp - local_3c]          # 0046fb20
    movsx eax, word ptr [edx + field_1c]         # 0046fb23
    imul eax, eax, 0x4a                          # 0046fb27
    mov ecx, dword ptr [ebp - local_3c]          # 0046fb2a
    mov edx, dword ptr [ecx + field_20]          # 0046fb2d
    mov dword ptr [eax + 0x5d1599], edx          # 0046fb30
    mov edi, 0x54c1bc                            # 0046fb36
    mov esi, dword ptr [ebp - local_24]          # 0046fb3b
    add esi, 0x61c                               # 0046fb3e
    mov ecx, 0x9                                 # 0046fb44
    {load} xor eax, eax                          # 0046fb49
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0046fb4b
    je.d8 L_0046fb63                             # 0046fb4d
    # block 0x0046fb4f: entered by fall-through of je at 0x0046fb4d, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x0046fb63
    mov ecx, dword ptr [ebp - local_24]          # 0046fb4f
    add ecx, 0x61c                               # 0046fb52
    push ecx                                     # 0046fb58
    mov ecx, 0x5c3a67                            # 0046fb59
    call FUN_004fb77a                            # 0046fb5e
L_0046fb63:
    # block 0x0046fb63: entered by je at 0x0046fb4d, 7 instruction(s), ends with je to 0x0046fb8f (forward)
    mov edi, 0x54c1c8                            # 0046fb63
    mov esi, dword ptr [ebp - local_24]          # 0046fb68
    add esi, 0x6b1                               # 0046fb6b
    mov ecx, 0x9                                 # 0046fb71
    {load} xor edx, edx                          # 0046fb76
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0046fb78
    je.d8 L_0046fb8f                             # 0046fb7a
    # block 0x0046fb7c: entered by fall-through of je at 0x0046fb7a, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x0046fb8f
    mov eax, dword ptr [ebp - local_24]          # 0046fb7c
    add eax, 0x6b1                               # 0046fb7f
    push eax                                     # 0046fb84
    mov ecx, 0x5c3a67                            # 0046fb85
    call FUN_004fb77a                            # 0046fb8a
L_0046fb8f:
    # block 0x0046fb8f: entered by je at 0x0046fb7a, 7 instruction(s), ends with je to 0x0046fbbb (forward)
    mov edi, 0x54c1d4                            # 0046fb8f
    mov esi, dword ptr [ebp - local_24]          # 0046fb94
    add esi, 0x746                               # 0046fb97
    mov ecx, 0x9                                 # 0046fb9d
    {load} xor edx, edx                          # 0046fba2
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0046fba4
    je.d8 L_0046fbbb                             # 0046fba6
    # block 0x0046fba8: entered by fall-through of je at 0x0046fba6, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x0046fbbb
    mov eax, dword ptr [ebp - local_24]          # 0046fba8
    add eax, 0x746                               # 0046fbab
    push eax                                     # 0046fbb0
    mov ecx, 0x5c3a67                            # 0046fbb1
    call FUN_004fb77a                            # 0046fbb6
L_0046fbbb:
    # block 0x0046fbbb: entered by je at 0x0046fba6, 7 instruction(s), ends with je to 0x0046fbe7 (forward)
    mov edi, 0x54c1e0                            # 0046fbbb
    mov esi, dword ptr [ebp - local_24]          # 0046fbc0
    add esi, 0x7db                               # 0046fbc3
    mov ecx, 0x9                                 # 0046fbc9
    {load} xor edx, edx                          # 0046fbce
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0046fbd0
    je.d8 L_0046fbe7                             # 0046fbd2
    # block 0x0046fbd4: entered by fall-through of je at 0x0046fbd2, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x0046fbe7
    mov eax, dword ptr [ebp - local_24]          # 0046fbd4
    add eax, 0x7db                               # 0046fbd7
    push eax                                     # 0046fbdc
    mov ecx, 0x5c3a67                            # 0046fbdd
    call FUN_004fb77a                            # 0046fbe2
L_0046fbe7:
    # block 0x0046fbe7: entered by je at 0x0046fbd2, 7 instruction(s), ends with je to 0x0046fc13 (forward)
    mov edi, 0x54c1ec                            # 0046fbe7
    mov esi, dword ptr [ebp - local_24]          # 0046fbec
    add esi, 0x870                               # 0046fbef
    mov ecx, 0x9                                 # 0046fbf5
    {load} xor edx, edx                          # 0046fbfa
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0046fbfc
    je.d8 L_0046fc13                             # 0046fbfe
    # block 0x0046fc00: entered by fall-through of je at 0x0046fbfe, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x0046fc13
    mov eax, dword ptr [ebp - local_24]          # 0046fc00
    add eax, 0x870                               # 0046fc03
    push eax                                     # 0046fc08
    mov ecx, 0x5c3a67                            # 0046fc09
    call FUN_004fb77a                            # 0046fc0e
L_0046fc13:
    # block 0x0046fc13: entered by je at 0x0046fbfe, 7 instruction(s), ends with je to 0x0046fc3f (forward)
    mov edi, 0x54c1f8                            # 0046fc13
    mov esi, dword ptr [ebp - local_24]          # 0046fc18
    add esi, 0x905                               # 0046fc1b
    mov ecx, 0x9                                 # 0046fc21
    {load} xor edx, edx                          # 0046fc26
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0046fc28
    je.d8 L_0046fc3f                             # 0046fc2a
    # block 0x0046fc2c: entered by fall-through of je at 0x0046fc2a, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x0046fc3f
    mov eax, dword ptr [ebp - local_24]          # 0046fc2c
    add eax, 0x905                               # 0046fc2f
    push eax                                     # 0046fc34
    mov ecx, 0x5c3a67                            # 0046fc35
    call FUN_004fb77a                            # 0046fc3a
L_0046fc3f:
    # block 0x0046fc3f: entered by je at 0x0046fc2a, 7 instruction(s), ends with je to 0x0046fc6b (forward)
    mov edi, 0x54c204                            # 0046fc3f
    mov esi, dword ptr [ebp - local_24]          # 0046fc44
    add esi, 0xac4                               # 0046fc47
    mov ecx, 0x9                                 # 0046fc4d
    {load} xor edx, edx                          # 0046fc52
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0046fc54
    je.d8 L_0046fc6b                             # 0046fc56
    # block 0x0046fc58: entered by fall-through of je at 0x0046fc56, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x0046fc6b
    mov eax, dword ptr [ebp - local_24]          # 0046fc58
    add eax, 0xac4                               # 0046fc5b
    push eax                                     # 0046fc60
    mov ecx, 0x5c3a67                            # 0046fc61
    call FUN_004fb77a                            # 0046fc66
L_0046fc6b:
    # block 0x0046fc6b: entered by je at 0x0046fc56, 7 instruction(s), ends with je to 0x0046fc97 (forward)
    mov edi, 0x54c210                            # 0046fc6b
    mov esi, dword ptr [ebp - local_24]          # 0046fc70
    add esi, 0x99a                               # 0046fc73
    mov ecx, 0x9                                 # 0046fc79
    {load} xor edx, edx                          # 0046fc7e
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0046fc80
    je.d8 L_0046fc97                             # 0046fc82
    # block 0x0046fc84: entered by fall-through of je at 0x0046fc82, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x0046fc97
    mov eax, dword ptr [ebp - local_24]          # 0046fc84
    add eax, 0x99a                               # 0046fc87
    push eax                                     # 0046fc8c
    mov ecx, 0x5c3a67                            # 0046fc8d
    call FUN_004fb77a                            # 0046fc92
L_0046fc97:
    # block 0x0046fc97: entered by je at 0x0046fc82, 7 instruction(s), ends with je to 0x0046fcc3 (forward)
    mov edi, 0x54c21c                            # 0046fc97
    mov esi, dword ptr [ebp - local_24]          # 0046fc9c
    add esi, 0xa2f                               # 0046fc9f
    mov ecx, 0x9                                 # 0046fca5
    {load} xor edx, edx                          # 0046fcaa
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0046fcac
    je.d8 L_0046fcc3                             # 0046fcae
    # block 0x0046fcb0: entered by fall-through of je at 0x0046fcae, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x0046fcc3
    mov eax, dword ptr [ebp - local_24]          # 0046fcb0
    add eax, 0xa2f                               # 0046fcb3
    push eax                                     # 0046fcb8
    mov ecx, 0x5c3a67                            # 0046fcb9
    call FUN_004fb77a                            # 0046fcbe
L_0046fcc3:
    # block 0x0046fcc3: entered by je at 0x0046fcae, 7 instruction(s), ends with je to 0x0046fcef (forward)
    mov edi, 0x54c228                            # 0046fcc3
    mov esi, dword ptr [ebp - local_24]          # 0046fcc8
    add esi, 0xbee                               # 0046fccb
    mov ecx, 0x9                                 # 0046fcd1
    {load} xor edx, edx                          # 0046fcd6
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0046fcd8
    je.d8 L_0046fcef                             # 0046fcda
    # block 0x0046fcdc: entered by fall-through of je at 0x0046fcda, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x0046fcef
    mov eax, dword ptr [ebp - local_24]          # 0046fcdc
    add eax, 0xbee                               # 0046fcdf
    push eax                                     # 0046fce4
    mov ecx, 0x5c3a67                            # 0046fce5
    call FUN_004fb77a                            # 0046fcea
L_0046fcef:
    # block 0x0046fcef: entered by je at 0x0046fcda, 2 instruction(s), ends with forward jump to 0x0046fd01
    mov dword ptr [ebp - local_18], 0x0          # 0046fcef
    jmp.d8 L_0046fd01                            # 0046fcf6
L_0046fcf8:
    # block 0x0046fcf8: entered by jmp at 0x0046fd27, 3 instruction(s), falls into the block at 0x0046fd01
    mov ecx, dword ptr [ebp - local_18]          # 0046fcf8
    add ecx, 0x1                                 # 0046fcfb
    mov dword ptr [ebp - local_18], ecx          # 0046fcfe
L_0046fd01:
    # block 0x0046fd01: entered by jmp at 0x0046fcf6, 2 instruction(s), ends with jge to 0x0046fd29 (forward)
    cmp dword ptr [ebp - local_18], 0x8          # 0046fd01
    jge.d8 L_0046fd29                            # 0046fd05
    # block 0x0046fd07: entered by fall-through of jge at 0x0046fd05, 10 instruction(s), ends with backward jump to 0x0046fcf8
    mov edx, dword ptr [ebp - local_3c]          # 0046fd07
    add edx, dword ptr [ebp - local_18]          # 0046fd0a
    mov eax, dword ptr [ebp - local_18]          # 0046fd0d
    mov ecx, dword ptr [ebp - local_24]          # 0046fd10
    mov al, byte ptr [ecx + 2*eax + field_23]    # 0046fd13
    mov byte ptr [edx + field_53], al            # 0046fd17
    mov ecx, dword ptr [ebp - local_18]          # 0046fd1a
    mov edx, dword ptr [ebp - local_3c]          # 0046fd1d
    mov word ptr [edx + 2*ecx + field_36], 0x1   # 0046fd20
    jmp.d8 L_0046fcf8                            # 0046fd27
L_0046fd29:
    # block 0x0046fd29: entered by jge at 0x0046fd05, 6 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x0046fd4e
    mov eax, dword ptr [ebp - local_3c]          # 0046fd29
    mov dword ptr [eax + field_5f], 0x1          # 0046fd2c
    call dword ptr [0x52a23c]                    # 0046fd33
    mov dword ptr [ebp - local_14], eax          # 0046fd39
    mov dword ptr [ebp - local_10], 0x0          # 0046fd3c
    jmp.d8 L_0046fd4e                            # 0046fd43
L_0046fd45:
    # block 0x0046fd45: entered by jmp at 0x0046fd92, 3 instruction(s), falls into the block at 0x0046fd4e
    mov ecx, dword ptr [ebp - local_10]          # 0046fd45
    add ecx, 0x1                                 # 0046fd48
    mov dword ptr [ebp - local_10], ecx          # 0046fd4b
L_0046fd4e:
    # block 0x0046fd4e: entered by jmp at 0x0046fd43, 4 instruction(s), ends with jge to 0x0046fd94 (forward)
    mov edx, dword ptr [ebp - local_24]          # 0046fd4e
    movsx eax, word ptr [edx + field_21]         # 0046fd51
    cmp dword ptr [ebp - local_10], eax          # 0046fd55
    jge.d8 L_0046fd94                            # 0046fd58
    # block 0x0046fd5a: entered by fall-through of jge at 0x0046fd58, 20 instruction(s), calls FUN_004709bb, FUN_004709de, ends with backward jump to 0x0046fd45
    mov ecx, dword ptr [ebp - local_3c]          # 0046fd5a
    add ecx, dword ptr [ebp - local_10]          # 0046fd5d
    {load} xor edx, edx                          # 0046fd60
    mov dl, byte ptr [ecx + field_53]            # 0046fd62
    push edx                                     # 0046fd65
    mov ecx, dword ptr [ebp - local_3c]          # 0046fd66
    call FUN_004709bb                            # 0046fd69
    push eax                                     # 0046fd6e
    mov eax, dword ptr [ebp - local_10]          # 0046fd6f
    mov ecx, dword ptr [ebp - local_3c]          # 0046fd72
    movsx edx, word ptr [ecx + 2*eax + field_36] # 0046fd75
    push edx                                     # 0046fd7a
    mov ecx, dword ptr [ebp - local_3c]          # 0046fd7b
    call FUN_004709de                            # 0046fd7e
    mov ecx, dword ptr [ebp - local_14]          # 0046fd83
    {load} add ecx, eax                          # 0046fd86
    mov edx, dword ptr [ebp - local_10]          # 0046fd88
    mov eax, dword ptr [ebp - local_3c]          # 0046fd8b
    mov dword ptr [eax + 4*edx + field_67], ecx  # 0046fd8e
    jmp.d8 L_0046fd45                            # 0046fd92
L_0046fd94:
    # block 0x0046fd94: entered by jge at 0x0046fd58, 10 instruction(s), calls FUN_0046f8ae, ends with forward jump to 0x00470972
    mov ecx, dword ptr [ebp - local_24]          # 0046fd94
    add ecx, 0x33                                # 0046fd97
    push ecx                                     # 0046fd9a
    mov ecx, dword ptr [ebp - local_3c]          # 0046fd9b
    call FUN_0046f8ae                            # 0046fd9e
    mov edx, dword ptr [ebp - local_3c]          # 0046fda3
    movsx eax, word ptr [edx + field_1e]         # 0046fda6
    imul eax, eax, 0x8d                          # 0046fdaa
    mov dword ptr [eax + 0x5bb632], 0x1          # 0046fdb0
    jmp.d32 L_00470972                           # 0046fdba
L_0046fdbf:
    # block 0x0046fdbf: entered by switch case, 3 instruction(s), ends with je to 0x00470465 (forward)
    mov ecx, dword ptr [ebp - local_3c]          # 0046fdbf
    cmp dword ptr [ecx + field_28], 0x0          # 0046fdc2
    je.d32 L_00470465                            # 0046fdc6
    # block 0x0046fdcc: entered by fall-through of je at 0x0046fdc6, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jbe to 0x00470465 (forward)
    call dword ptr [0x52a23c]                    # 0046fdcc
    mov edx, dword ptr [ebp - local_3c]          # 0046fdd2
    cmp eax, dword ptr [edx + field_2e]          # 0046fdd5
    jbe.d32 L_00470465                           # 0046fdd8
    # block 0x0046fdde: entered by fall-through of jbe at 0x0046fdd8, 10 instruction(s), ends with ja to 0x0047035b (forward)
    mov eax, dword ptr [ebp - local_3c]          # 0046fdde
    mov dword ptr [eax + field_32], 0x0          # 0046fde1
    mov ecx, dword ptr [ebp - local_3c]          # 0046fde8
    movsx edx, word ptr [ecx + field_2c]         # 0046fdeb
    mov dword ptr [ebp - local_44], edx          # 0046fdef
    mov eax, dword ptr [ebp - local_44]          # 0046fdf2
    sub eax, 0xa                                 # 0046fdf5
    mov dword ptr [ebp - local_44], eax          # 0046fdf8
    cmp dword ptr [ebp - local_44], 0x5          # 0046fdfb
    ja.d32 L_0047035b                            # 0046fdff
    # block 0x0046fe05: entered by fall-through of ja at 0x0046fdff, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x4709a3]
    mov ecx, dword ptr [ebp - local_44]          # 0046fe05
    jmp dword ptr [4*ecx + SWTAB_004709a3_VA]    # 0046fe08
L_0046fe0f:
    # block 0x0046fe0f: entered by switch case, 2 instruction(s), ends with forward jump to 0x0046fe21
    mov dword ptr [ebp - local_18], 0x0          # 0046fe0f
    jmp.d8 L_0046fe21                            # 0046fe16
L_0046fe18:
    # block 0x0046fe18: entered by jmp at 0x0046fe34, 3 instruction(s), falls into the block at 0x0046fe21
    mov edx, dword ptr [ebp - local_18]          # 0046fe18
    add edx, 0x1                                 # 0046fe1b
    mov dword ptr [ebp - local_18], edx          # 0046fe1e
L_0046fe21:
    # block 0x0046fe21: entered by jmp at 0x0046fe16, 2 instruction(s), ends with jge to 0x0046fe36 (forward)
    cmp dword ptr [ebp - local_18], 0x5          # 0046fe21
    jge.d8 L_0046fe36                            # 0046fe25
    # block 0x0046fe27: entered by fall-through of jge at 0x0046fe25, 4 instruction(s), ends with backward jump to 0x0046fe18
    mov eax, dword ptr [ebp - local_3c]          # 0046fe27
    add eax, dword ptr [ebp - local_18]          # 0046fe2a
    mov byte ptr [eax + field_87], 0x0           # 0046fe2d
    jmp.d8 L_0046fe18                            # 0046fe34
L_0046fe36:
    # block 0x0046fe36: entered by jge at 0x0046fe25, 10 instruction(s), calls FUN_0051e745, FUN_0046f77c, FUN_0046f4b0, ends with forward jump to 0x00470465
    mov ecx, dword ptr [ebp - local_3c]          # 0046fe36
    mov byte ptr [ecx + field_8c], 0x0           # 0046fe39
    mov ecx, dword ptr [ebp - local_3c]          # 0046fe40
    add ecx, 0x8d                                # 0046fe43
    call FUN_0051e745                            # 0046fe49
    mov ecx, dword ptr [ebp - local_3c]          # 0046fe4e
    call FUN_0046f77c                            # 0046fe51
    mov ecx, dword ptr [ebp - local_3c]          # 0046fe56
    call FUN_0046f4b0                            # 0046fe59
    jmp.d32 L_00470465                           # 0046fe5e
L_0046fe63:
    # block 0x0046fe63: entered by switch case, 15 instruction(s), ends with jge to 0x0046fea7 (forward)
    mov edx, dword ptr [ebp - local_3c]          # 0046fe63
    {load} xor eax, eax                          # 0046fe66
    mov al, byte ptr [edx + field_8c]            # 0046fe68
    mov ecx, dword ptr [ebp - local_3c]          # 0046fe6e
    mov byte ptr [ecx + eax + field_87], 0x1     # 0046fe71
    mov edx, dword ptr [ebp - local_3c]          # 0046fe79
    mov al, byte ptr [edx + field_8c]            # 0046fe7c
    add al, 0x1                                  # 0046fe82
    mov ecx, dword ptr [ebp - local_3c]          # 0046fe84
    mov byte ptr [ecx + field_8c], al            # 0046fe87
    mov edx, dword ptr [ebp - local_3c]          # 0046fe8d
    {load} xor eax, eax                          # 0046fe90
    mov al, byte ptr [edx + field_8c]            # 0046fe92
    cmp eax, 0x5                                 # 0046fe98
    jge.d8 L_0046fea7                            # 0046fe9b
    # block 0x0046fe9d: entered by fall-through of jge at 0x0046fe9b, 3 instruction(s), calls FUN_0046f77c, ends with forward jump to 0x0046feea
    mov ecx, dword ptr [ebp - local_3c]          # 0046fe9d
    call FUN_0046f77c                            # 0046fea0
    jmp.d8 L_0046feea                            # 0046fea5
L_0046fea7:
    # block 0x0046fea7: entered by jge at 0x0046fe9b, 7 instruction(s), calls FUN_0046f8ae, ends with forward jump to 0x0046fecb
    mov ecx, dword ptr [ebp - local_24]          # 0046fea7
    add ecx, 0xa60                               # 0046feaa
    push ecx                                     # 0046feb0
    mov ecx, dword ptr [ebp - local_3c]          # 0046feb1
    call FUN_0046f8ae                            # 0046feb4
    mov dword ptr [ebp - local_18], 0x0          # 0046feb9
    jmp.d8 L_0046fecb                            # 0046fec0
L_0046fec2:
    # block 0x0046fec2: entered by jmp at 0x0046fede, 3 instruction(s), falls into the block at 0x0046fecb
    mov edx, dword ptr [ebp - local_18]          # 0046fec2
    add edx, 0x1                                 # 0046fec5
    mov dword ptr [ebp - local_18], edx          # 0046fec8
L_0046fecb:
    # block 0x0046fecb: entered by jmp at 0x0046fec0, 2 instruction(s), ends with jge to 0x0046fee0 (forward)
    cmp dword ptr [ebp - local_18], 0x5          # 0046fecb
    jge.d8 L_0046fee0                            # 0046fecf
    # block 0x0046fed1: entered by fall-through of jge at 0x0046fecf, 4 instruction(s), ends with backward jump to 0x0046fec2
    mov eax, dword ptr [ebp - local_3c]          # 0046fed1
    add eax, dword ptr [ebp - local_18]          # 0046fed4
    mov byte ptr [eax + field_87], 0x0           # 0046fed7
    jmp.d8 L_0046fec2                            # 0046fede
L_0046fee0:
    # block 0x0046fee0: entered by jge at 0x0046fecf, 2 instruction(s), falls into the block at 0x0046feea
    mov ecx, dword ptr [ebp - local_3c]          # 0046fee0
    mov byte ptr [ecx + field_8c], 0x0           # 0046fee3
L_0046feea:
    # block 0x0046feea: entered by jmp at 0x0046fea5, 1 instruction(s), ends with forward jump to 0x00470465
    jmp.d32 L_00470465                           # 0046feea
L_0046feef:
    # block 0x0046feef: entered by switch case, 15 instruction(s), ends with jge to 0x0046ff33 (forward)
    mov edx, dword ptr [ebp - local_3c]          # 0046feef
    {load} xor eax, eax                          # 0046fef2
    mov al, byte ptr [edx + field_8c]            # 0046fef4
    mov ecx, dword ptr [ebp - local_3c]          # 0046fefa
    mov byte ptr [ecx + eax + field_87], 0x2     # 0046fefd
    mov edx, dword ptr [ebp - local_3c]          # 0046ff05
    mov al, byte ptr [edx + field_8c]            # 0046ff08
    add al, 0x1                                  # 0046ff0e
    mov ecx, dword ptr [ebp - local_3c]          # 0046ff10
    mov byte ptr [ecx + field_8c], al            # 0046ff13
    mov edx, dword ptr [ebp - local_3c]          # 0046ff19
    {load} xor eax, eax                          # 0046ff1c
    mov al, byte ptr [edx + field_8c]            # 0046ff1e
    cmp eax, 0x5                                 # 0046ff24
    jge.d8 L_0046ff33                            # 0046ff27
    # block 0x0046ff29: entered by fall-through of jge at 0x0046ff27, 3 instruction(s), calls FUN_0046f77c, ends with forward jump to 0x0046ff76
    mov ecx, dword ptr [ebp - local_3c]          # 0046ff29
    call FUN_0046f77c                            # 0046ff2c
    jmp.d8 L_0046ff76                            # 0046ff31
L_0046ff33:
    # block 0x0046ff33: entered by jge at 0x0046ff27, 7 instruction(s), calls FUN_0046f8ae, ends with forward jump to 0x0046ff57
    mov ecx, dword ptr [ebp - local_24]          # 0046ff33
    add ecx, 0xa60                               # 0046ff36
    push ecx                                     # 0046ff3c
    mov ecx, dword ptr [ebp - local_3c]          # 0046ff3d
    call FUN_0046f8ae                            # 0046ff40
    mov dword ptr [ebp - local_18], 0x0          # 0046ff45
    jmp.d8 L_0046ff57                            # 0046ff4c
L_0046ff4e:
    # block 0x0046ff4e: entered by jmp at 0x0046ff6a, 3 instruction(s), falls into the block at 0x0046ff57
    mov edx, dword ptr [ebp - local_18]          # 0046ff4e
    add edx, 0x1                                 # 0046ff51
    mov dword ptr [ebp - local_18], edx          # 0046ff54
L_0046ff57:
    # block 0x0046ff57: entered by jmp at 0x0046ff4c, 2 instruction(s), ends with jge to 0x0046ff6c (forward)
    cmp dword ptr [ebp - local_18], 0x5          # 0046ff57
    jge.d8 L_0046ff6c                            # 0046ff5b
    # block 0x0046ff5d: entered by fall-through of jge at 0x0046ff5b, 4 instruction(s), ends with backward jump to 0x0046ff4e
    mov eax, dword ptr [ebp - local_3c]          # 0046ff5d
    add eax, dword ptr [ebp - local_18]          # 0046ff60
    mov byte ptr [eax + field_87], 0x0           # 0046ff63
    jmp.d8 L_0046ff4e                            # 0046ff6a
L_0046ff6c:
    # block 0x0046ff6c: entered by jge at 0x0046ff5b, 2 instruction(s), falls into the block at 0x0046ff76
    mov ecx, dword ptr [ebp - local_3c]          # 0046ff6c
    mov byte ptr [ecx + field_8c], 0x0           # 0046ff6f
L_0046ff76:
    # block 0x0046ff76: entered by jmp at 0x0046ff31, 1 instruction(s), ends with forward jump to 0x00470465
    jmp.d32 L_00470465                           # 0046ff76
L_0046ff7b:
    # block 0x0046ff7b: entered by switch case, 6 instruction(s), calls FUN_0046ee20, ends with je to 0x00470237 (forward)
    mov ecx, dword ptr [ebp - local_3c]          # 0046ff7b
    call FUN_0046ee20                            # 0046ff7e
    mov byte ptr [ebp - local_28], al            # 0046ff83
    movsx edx, byte ptr [ebp - local_28]         # 0046ff86
    test edx, edx                                # 0046ff8a
    je.d32 L_00470237                            # 0046ff8c
    # block 0x0046ff92: entered by fall-through of je at 0x0046ff8c, 7 instruction(s), calls FUN_0051ea48, ends with forward jump to 0x0046ffb6
    mov al, byte ptr [ebp - local_28]            # 0046ff92
    push eax                                     # 0046ff95
    mov ecx, dword ptr [ebp - local_3c]          # 0046ff96
    add ecx, 0x8d                                # 0046ff99
    call FUN_0051ea48                            # 0046ff9f
    mov dword ptr [ebp - local_18], 0x0          # 0046ffa4
    jmp.d8 L_0046ffb6                            # 0046ffab
L_0046ffad:
    # block 0x0046ffad: entered by jmp at 0x0046ffc9, 3 instruction(s), falls into the block at 0x0046ffb6
    mov ecx, dword ptr [ebp - local_18]          # 0046ffad
    add ecx, 0x1                                 # 0046ffb0
    mov dword ptr [ebp - local_18], ecx          # 0046ffb3
L_0046ffb6:
    # block 0x0046ffb6: entered by jmp at 0x0046ffab, 2 instruction(s), ends with jge to 0x0046ffcb (forward)
    cmp dword ptr [ebp - local_18], 0x5          # 0046ffb6
    jge.d8 L_0046ffcb                            # 0046ffba
    # block 0x0046ffbc: entered by fall-through of jge at 0x0046ffba, 4 instruction(s), ends with backward jump to 0x0046ffad
    mov edx, dword ptr [ebp - local_3c]          # 0046ffbc
    add edx, dword ptr [ebp - local_18]          # 0046ffbf
    mov byte ptr [edx + field_87], 0x0           # 0046ffc2
    jmp.d8 L_0046ffad                            # 0046ffc9
L_0046ffcb:
    # block 0x0046ffcb: entered by jge at 0x0046ffba, 4 instruction(s), ends with je to 0x00470031 (forward)
    mov eax, dword ptr [ebp - local_3c]          # 0046ffcb
    mov byte ptr [eax + field_8c], 0x0           # 0046ffce
    cmp dword ptr [0x5bb202], 0x0                # 0046ffd5
    je.d8 L_00470031                             # 0046ffdc
    # block 0x0046ffde: entered by fall-through of je at 0x0046ffdc, 23 instruction(s), calls FUN_0051e8a7, FUN_0051ea21, FUN_0051ea75, FUN_00448d11, FUN_0051e745, falls into the block at 0x00470031
    mov ecx, dword ptr [ebp - local_3c]          # 0046ffde
    add ecx, 0x8d                                # 0046ffe1
    push ecx                                     # 0046ffe7
    lea ecx, [ebp - local_1c]                    # 0046ffe8
    call FUN_0051e8a7                            # 0046ffeb
    push 0x54c234                                # 0046fff0
    lea ecx, [ebp - local_1c]                    # 0046fff5
    call FUN_0051ea21                            # 0046fff8
    push 0x0                                     # 0046fffd
    push -0x1                                    # 0046ffff
    mov edx, dword ptr [ebp - local_24]          # 00470001
    movsx eax, word ptr [edx + field_173]        # 00470004
    add eax, 0xa                                 # 0047000b
    push eax                                     # 0047000e
    lea ecx, [ebp - local_1c]                    # 0047000f
    call FUN_0051ea75                            # 00470012
    push eax                                     # 00470017
    mov ecx, dword ptr [0x5d03b3]                # 00470018
    push ecx                                     # 0047001e
    mov ecx, 0x619a05                            # 0047001f
    call FUN_00448d11                            # 00470024
    lea ecx, [ebp - local_1c]                    # 00470029
    call FUN_0051e745                            # 0047002c
L_00470031:
    # block 0x00470031: entered by je at 0x0046ffdc, 6 instruction(s), ends with jl to 0x00470066 (forward)
    mov edx, dword ptr [ebp - local_3c]          # 00470031
    mov eax, dword ptr [edx + field_8d]          # 00470034
    mov ecx, dword ptr [eax - field_minus_8]     # 0047003a
    mov dword ptr [ebp - local_2c], ecx          # 0047003d
    cmp dword ptr [ebp - local_2c], 0xa          # 00470040
    jl.d8 L_00470066                             # 00470044
    # block 0x00470046: entered by fall-through of jl at 0x00470044, 8 instruction(s), calls FUN_0051e745, FUN_0046f8ae, falls into the block at 0x00470066
    mov ecx, dword ptr [ebp - local_3c]          # 00470046
    add ecx, 0x8d                                # 00470049
    call FUN_0051e745                            # 0047004f
    mov edx, dword ptr [ebp - local_24]          # 00470054
    add edx, 0xc1f                               # 00470057
    push edx                                     # 0047005d
    mov ecx, dword ptr [ebp - local_3c]          # 0047005e
    call FUN_0046f8ae                            # 00470061
L_00470066:
    # block 0x00470066: entered by jl at 0x00470044, 3 instruction(s), ends with je to 0x004700ac (forward)
    mov eax, dword ptr [ebp - local_3c]          # 00470066
    cmp dword ptr [eax + field_5b], 0x0          # 00470069
    je.d8 L_004700ac                             # 0047006d
    # block 0x0047006f: entered by fall-through of je at 0x0047006d, 8 instruction(s), ends with jl to 0x004700ac (forward)
    mov ecx, dword ptr [ebp - local_3c]          # 0047006f
    mov edx, dword ptr [ecx + field_8d]          # 00470072
    mov eax, dword ptr [edx - field_minus_8]     # 00470078
    mov dword ptr [ebp - local_30], eax          # 0047007b
    mov ecx, dword ptr [ebp - local_24]          # 0047007e
    movsx edx, word ptr [ecx + field_173]        # 00470081
    cmp dword ptr [ebp - local_30], edx          # 00470088
    jl.d8 L_004700ac                             # 0047008b
    # block 0x0047008d: entered by fall-through of jl at 0x0047008b, 8 instruction(s), calls FUN_0051e745, FUN_0046f8ae, falls into the block at 0x004700ac
    mov ecx, dword ptr [ebp - local_3c]          # 0047008d
    add ecx, 0x8d                                # 00470090
    call FUN_0051e745                            # 00470096
    mov eax, dword ptr [ebp - local_24]          # 0047009b
    add eax, 0xaf5                               # 0047009e
    push eax                                     # 004700a3
    mov ecx, dword ptr [ebp - local_3c]          # 004700a4
    call FUN_0046f8ae                            # 004700a7
L_004700ac:
    # block 0x004700ac: entered by je at 0x0047006d; jl at 0x0047008b, 3 instruction(s), ends with je to 0x0047018f (forward)
    mov ecx, dword ptr [ebp - local_3c]          # 004700ac
    cmp dword ptr [ecx + field_5b], 0x0          # 004700af
    je.d32 L_0047018f                            # 004700b3
    # block 0x004700b9: entered by fall-through of je at 0x004700b3, 3 instruction(s), ends with jne to 0x0047018f (forward)
    mov edx, dword ptr [ebp - local_3c]          # 004700b9
    cmp dword ptr [edx + field_4a], 0x0          # 004700bc
    jne.d32 L_0047018f                           # 004700c0
    # block 0x004700c6: entered by fall-through of jne at 0x004700c0, 8 instruction(s), falls into the block at 0x004700e4
    mov eax, dword ptr [ebp - local_3c]          # 004700c6
    mov ecx, dword ptr [eax + field_8d]          # 004700c9
    mov dword ptr [ebp - local_34], ecx          # 004700cf
    mov edx, dword ptr [ebp - local_24]          # 004700d2
    add edx, 0x175                               # 004700d5
    mov dword ptr [ebp - local_48], edx          # 004700db
    mov eax, dword ptr [ebp - local_34]          # 004700de
    mov dword ptr [ebp - local_4c], eax          # 004700e1
L_004700e4:
    # block 0x004700e4: entered by jne at 0x00470116, 6 instruction(s), ends with jne to 0x00470121 (forward)
    mov ecx, dword ptr [ebp - local_4c]          # 004700e4
    mov dl, byte ptr [ecx]                       # 004700e7
    mov byte ptr [ebp - local_4d], dl            # 004700e9
    mov eax, dword ptr [ebp - local_48]          # 004700ec
    cmp dl, byte ptr [eax]                       # 004700ef
    jne.d8 L_00470121                            # 004700f1
    # block 0x004700f3: entered by fall-through of jne at 0x004700f1, 2 instruction(s), ends with je to 0x00470118 (forward)
    cmp byte ptr [ebp - local_4d], 0x0           # 004700f3
    je.d8 L_00470118                             # 004700f7
    # block 0x004700f9: entered by fall-through of je at 0x004700f7, 6 instruction(s), ends with jne to 0x00470121 (forward)
    mov ecx, dword ptr [ebp - local_4c]          # 004700f9
    mov dl, byte ptr [ecx + field_1]             # 004700fc
    mov byte ptr [ebp - local_4e], dl            # 004700ff
    mov eax, dword ptr [ebp - local_48]          # 00470102
    cmp dl, byte ptr [eax + field_1]             # 00470105
    jne.d8 L_00470121                            # 00470108
    # block 0x0047010a: entered by fall-through of jne at 0x00470108, 4 instruction(s), ends with jne to 0x004700e4 (backward)
    add dword ptr [ebp - local_4c], 0x2          # 0047010a
    add dword ptr [ebp - local_48], 0x2          # 0047010e
    cmp byte ptr [ebp - local_4e], 0x0           # 00470112
    jne.d8 L_004700e4                            # 00470116
L_00470118:
    # block 0x00470118: entered by je at 0x004700f7; fall-through of jne at 0x00470116, 2 instruction(s), ends with forward jump to 0x00470129
    mov dword ptr [ebp - local_54], 0x0          # 00470118
    jmp.d8 L_00470129                            # 0047011f
L_00470121:
    # block 0x00470121: entered by jne at 0x004700f1; jne at 0x00470108, 3 instruction(s), falls into the block at 0x00470129
    {load} sbb ecx, ecx                          # 00470121
    sbb ecx, -0x1                                # 00470123
    mov dword ptr [ebp - local_54], ecx          # 00470126
L_00470129:
    # block 0x00470129: entered by jmp at 0x0047011f, 4 instruction(s), ends with jne to 0x0047018a (forward)
    mov edx, dword ptr [ebp - local_54]          # 00470129
    mov dword ptr [ebp - local_58], edx          # 0047012c
    cmp dword ptr [ebp - local_58], 0x0          # 0047012f
    jne.d8 L_0047018a                            # 00470133
    # block 0x00470135: entered by fall-through of jne at 0x00470133, 9 instruction(s), calls FUN_0051e745, ends with je to 0x00470178 (forward)
    mov eax, dword ptr [ebp - local_3c]          # 00470135
    mov dword ptr [eax + field_4a], 0x1          # 00470138
    mov ecx, dword ptr [ebp - local_3c]          # 0047013f
    add ecx, 0x8d                                # 00470142
    call FUN_0051e745                            # 00470148
    mov ecx, dword ptr [ebp - local_24]          # 0047014d
    movsx edx, word ptr [ecx + field_196]        # 00470150
    cmp edx, -0x1                                # 00470157
    je.d8 L_00470178                             # 0047015a
    # block 0x0047015c: entered by fall-through of je at 0x0047015a, 6 instruction(s), falls into the block at 0x00470178
    mov eax, dword ptr [ebp - local_24]          # 0047015c
    {load} xor ecx, ecx                          # 0047015f
    mov cl, byte ptr [eax + field_198]           # 00470161
    mov edx, dword ptr [ebp - local_24]          # 00470167
    movsx eax, word ptr [edx + field_196]        # 0047016a
    mov dword ptr [4*eax + 0x585801], ecx        # 00470171
L_00470178:
    # block 0x00470178: entered by je at 0x0047015a, 5 instruction(s), calls FUN_0046f8ae, falls into the block at 0x0047018a
    mov ecx, dword ptr [ebp - local_24]          # 00470178
    add ecx, 0xb8a                               # 0047017b
    push ecx                                     # 00470181
    mov ecx, dword ptr [ebp - local_3c]          # 00470182
    call FUN_0046f8ae                            # 00470185
L_0047018a:
    # block 0x0047018a: entered by jne at 0x00470133, 1 instruction(s), ends with forward jump to 0x00470235
    jmp.d32 L_00470235                           # 0047018a
L_0047018f:
    # block 0x0047018f: entered by je at 0x004700b3; jne at 0x004700c0, 3 instruction(s), ends with je to 0x00470235 (forward)
    mov edx, dword ptr [ebp - local_3c]          # 0047018f
    cmp dword ptr [edx + field_5b], 0x0          # 00470192
    je.d32 L_00470235                            # 00470196
    # block 0x0047019c: entered by fall-through of je at 0x00470196, 8 instruction(s), falls into the block at 0x004701ba
    mov eax, dword ptr [ebp - local_3c]          # 0047019c
    mov ecx, dword ptr [eax + field_8d]          # 0047019f
    mov dword ptr [ebp - local_38], ecx          # 004701a5
    mov edx, dword ptr [ebp - local_24]          # 004701a8
    add edx, 0x199                               # 004701ab
    mov dword ptr [ebp - local_5c], edx          # 004701b1
    mov eax, dword ptr [ebp - local_38]          # 004701b4
    mov dword ptr [ebp - local_60], eax          # 004701b7
L_004701ba:
    # block 0x004701ba: entered by jne at 0x004701ec, 6 instruction(s), ends with jne to 0x004701f7 (forward)
    mov ecx, dword ptr [ebp - local_60]          # 004701ba
    mov dl, byte ptr [ecx]                       # 004701bd
    mov byte ptr [ebp - local_61], dl            # 004701bf
    mov eax, dword ptr [ebp - local_5c]          # 004701c2
    cmp dl, byte ptr [eax]                       # 004701c5
    jne.d8 L_004701f7                            # 004701c7
    # block 0x004701c9: entered by fall-through of jne at 0x004701c7, 2 instruction(s), ends with je to 0x004701ee (forward)
    cmp byte ptr [ebp - local_61], 0x0           # 004701c9
    je.d8 L_004701ee                             # 004701cd
    # block 0x004701cf: entered by fall-through of je at 0x004701cd, 6 instruction(s), ends with jne to 0x004701f7 (forward)
    mov ecx, dword ptr [ebp - local_60]          # 004701cf
    mov dl, byte ptr [ecx + field_1]             # 004701d2
    mov byte ptr [ebp - local_62], dl            # 004701d5
    mov eax, dword ptr [ebp - local_5c]          # 004701d8
    cmp dl, byte ptr [eax + field_1]             # 004701db
    jne.d8 L_004701f7                            # 004701de
    # block 0x004701e0: entered by fall-through of jne at 0x004701de, 4 instruction(s), ends with jne to 0x004701ba (backward)
    add dword ptr [ebp - local_60], 0x2          # 004701e0
    add dword ptr [ebp - local_5c], 0x2          # 004701e4
    cmp byte ptr [ebp - local_62], 0x0           # 004701e8
    jne.d8 L_004701ba                            # 004701ec
L_004701ee:
    # block 0x004701ee: entered by je at 0x004701cd; fall-through of jne at 0x004701ec, 2 instruction(s), ends with forward jump to 0x004701ff
    mov dword ptr [ebp - local_68], 0x0          # 004701ee
    jmp.d8 L_004701ff                            # 004701f5
L_004701f7:
    # block 0x004701f7: entered by jne at 0x004701c7; jne at 0x004701de, 3 instruction(s), falls into the block at 0x004701ff
    {load} sbb ecx, ecx                          # 004701f7
    sbb ecx, -0x1                                # 004701f9
    mov dword ptr [ebp - local_68], ecx          # 004701fc
L_004701ff:
    # block 0x004701ff: entered by jmp at 0x004701f5, 4 instruction(s), ends with jne to 0x00470235 (forward)
    mov edx, dword ptr [ebp - local_68]          # 004701ff
    mov dword ptr [ebp - local_6c], edx          # 00470202
    cmp dword ptr [ebp - local_6c], 0x0          # 00470205
    jne.d8 L_00470235                            # 00470209
    # block 0x0047020b: entered by fall-through of jne at 0x00470209, 10 instruction(s), calls FUN_0051e745, FUN_0046f8ae, falls into the block at 0x00470235
    mov eax, dword ptr [ebp - local_3c]          # 0047020b
    mov dword ptr [eax + field_4e], 0x1          # 0047020e
    mov ecx, dword ptr [ebp - local_3c]          # 00470215
    add ecx, 0x8d                                # 00470218
    call FUN_0051e745                            # 0047021e
    mov ecx, dword ptr [ebp - local_24]          # 00470223
    add ecx, 0xe8e                               # 00470226
    push ecx                                     # 0047022c
    mov ecx, dword ptr [ebp - local_3c]          # 0047022d
    call FUN_0046f8ae                            # 00470230
L_00470235:
    # block 0x00470235: entered by jmp at 0x0047018a; je at 0x00470196; jne at 0x00470209, 1 instruction(s), ends with forward jump to 0x0047027a
    jmp.d8 L_0047027a                            # 00470235
L_00470237:
    # block 0x00470237: entered by je at 0x0046ff8c, 7 instruction(s), calls FUN_0046f8ae, ends with forward jump to 0x0047025b
    mov edx, dword ptr [ebp - local_24]          # 00470237
    add edx, 0xa60                               # 0047023a
    push edx                                     # 00470240
    mov ecx, dword ptr [ebp - local_3c]          # 00470241
    call FUN_0046f8ae                            # 00470244
    mov dword ptr [ebp - local_18], 0x0          # 00470249
    jmp.d8 L_0047025b                            # 00470250
L_00470252:
    # block 0x00470252: entered by jmp at 0x0047026e, 3 instruction(s), falls into the block at 0x0047025b
    mov eax, dword ptr [ebp - local_18]          # 00470252
    add eax, 0x1                                 # 00470255
    mov dword ptr [ebp - local_18], eax          # 00470258
L_0047025b:
    # block 0x0047025b: entered by jmp at 0x00470250, 2 instruction(s), ends with jge to 0x00470270 (forward)
    cmp dword ptr [ebp - local_18], 0x5          # 0047025b
    jge.d8 L_00470270                            # 0047025f
    # block 0x00470261: entered by fall-through of jge at 0x0047025f, 4 instruction(s), ends with backward jump to 0x00470252
    mov ecx, dword ptr [ebp - local_3c]          # 00470261
    add ecx, dword ptr [ebp - local_18]          # 00470264
    mov byte ptr [ecx + field_87], 0x0           # 00470267
    jmp.d8 L_00470252                            # 0047026e
L_00470270:
    # block 0x00470270: entered by jge at 0x0047025f, 2 instruction(s), falls into the block at 0x0047027a
    mov edx, dword ptr [ebp - local_3c]          # 00470270
    mov byte ptr [edx + field_8c], 0x0           # 00470273
L_0047027a:
    # block 0x0047027a: entered by jmp at 0x00470235, 1 instruction(s), ends with forward jump to 0x00470465
    jmp.d32 L_00470465                           # 0047027a
L_0047027f:
    # block 0x0047027f: entered by switch case, 2 instruction(s), ends with forward jump to 0x00470291
    mov dword ptr [ebp - local_18], 0x0          # 0047027f
    jmp.d8 L_00470291                            # 00470286
L_00470288:
    # block 0x00470288: entered by jmp at 0x004702a4, 3 instruction(s), falls into the block at 0x00470291
    mov eax, dword ptr [ebp - local_18]          # 00470288
    add eax, 0x1                                 # 0047028b
    mov dword ptr [ebp - local_18], eax          # 0047028e
L_00470291:
    # block 0x00470291: entered by jmp at 0x00470286, 2 instruction(s), ends with jge to 0x004702a6 (forward)
    cmp dword ptr [ebp - local_18], 0x5          # 00470291
    jge.d8 L_004702a6                            # 00470295
    # block 0x00470297: entered by fall-through of jge at 0x00470295, 4 instruction(s), ends with backward jump to 0x00470288
    mov ecx, dword ptr [ebp - local_3c]          # 00470297
    add ecx, dword ptr [ebp - local_18]          # 0047029a
    mov byte ptr [ecx + field_87], 0x0           # 0047029d
    jmp.d8 L_00470288                            # 004702a4
L_004702a6:
    # block 0x004702a6: entered by jge at 0x00470295, 4 instruction(s), ends with je to 0x0047030a (forward)
    mov edx, dword ptr [ebp - local_3c]          # 004702a6
    mov byte ptr [edx + field_8c], 0x0           # 004702a9
    cmp dword ptr [0x5bb202], 0x0                # 004702b0
    je.d8 L_0047030a                             # 004702b7
    # block 0x004702b9: entered by fall-through of je at 0x004702b7, 23 instruction(s), calls FUN_0051e8a7, FUN_0051ea21, FUN_0051ea75, FUN_00448d11, FUN_0051e745, falls into the block at 0x0047030a
    mov eax, dword ptr [ebp - local_3c]          # 004702b9
    add eax, 0x8d                                # 004702bc
    push eax                                     # 004702c1
    lea ecx, [ebp - local_1c]                    # 004702c2
    call FUN_0051e8a7                            # 004702c5
    push 0x54c23c                                # 004702ca
    lea ecx, [ebp - local_1c]                    # 004702cf
    call FUN_0051ea21                            # 004702d2
    push 0x0                                     # 004702d7
    push -0x1                                    # 004702d9
    mov ecx, dword ptr [ebp - local_24]          # 004702db
    movsx edx, word ptr [ecx + field_173]        # 004702de
    add edx, 0xa                                 # 004702e5
    push edx                                     # 004702e8
    lea ecx, [ebp - local_1c]                    # 004702e9
    call FUN_0051ea75                            # 004702ec
    push eax                                     # 004702f1
    mov eax, dword ptr [0x5d03b3]                # 004702f2
    push eax                                     # 004702f7
    mov ecx, 0x619a05                            # 004702f8
    call FUN_00448d11                            # 004702fd
    lea ecx, [ebp - local_1c]                    # 00470302
    call FUN_0051e745                            # 00470305
L_0047030a:
    # block 0x0047030a: entered by je at 0x004702b7, 1 instruction(s), ends with forward jump to 0x00470465
    jmp.d32 L_00470465                           # 0047030a
L_0047030f:
    # block 0x0047030f: entered by switch case, 2 instruction(s), ends with forward jump to 0x00470321
    mov dword ptr [ebp - local_18], 0x0          # 0047030f
    jmp.d8 L_00470321                            # 00470316
L_00470318:
    # block 0x00470318: entered by jmp at 0x00470334, 3 instruction(s), falls into the block at 0x00470321
    mov ecx, dword ptr [ebp - local_18]          # 00470318
    add ecx, 0x1                                 # 0047031b
    mov dword ptr [ebp - local_18], ecx          # 0047031e
L_00470321:
    # block 0x00470321: entered by jmp at 0x00470316, 2 instruction(s), ends with jge to 0x00470336 (forward)
    cmp dword ptr [ebp - local_18], 0x5          # 00470321
    jge.d8 L_00470336                            # 00470325
    # block 0x00470327: entered by fall-through of jge at 0x00470325, 4 instruction(s), ends with backward jump to 0x00470318
    mov edx, dword ptr [ebp - local_3c]          # 00470327
    add edx, dword ptr [ebp - local_18]          # 0047032a
    mov byte ptr [edx + field_87], 0x0           # 0047032d
    jmp.d8 L_00470318                            # 00470334
L_00470336:
    # block 0x00470336: entered by jge at 0x00470325, 8 instruction(s), calls FUN_0051e745, FUN_0046f77c, ends with forward jump to 0x00470465
    mov eax, dword ptr [ebp - local_3c]          # 00470336
    mov byte ptr [eax + field_8c], 0x0           # 00470339
    mov ecx, dword ptr [ebp - local_3c]          # 00470340
    add ecx, 0x8d                                # 00470343
    call FUN_0051e745                            # 00470349
    mov ecx, dword ptr [ebp - local_3c]          # 0047034e
    call FUN_0046f77c                            # 00470351
    jmp.d32 L_00470465                           # 00470356
L_0047035b:
    # block 0x0047035b: entered by ja at 0x0046fdff, 4 instruction(s), ends with jg to 0x00470372 (forward)
    mov ecx, dword ptr [ebp - local_3c]          # 0047035b
    movsx edx, word ptr [ecx + field_2c]         # 0047035e
    cmp edx, 0xa                                 # 00470362
    jg.d8 L_00470372                             # 00470365
    # block 0x00470367: entered by fall-through of jg at 0x00470365, 4 instruction(s), ends with jge to 0x00470390 (forward)
    mov eax, dword ptr [ebp - local_3c]          # 00470367
    movsx ecx, word ptr [eax + field_2c]         # 0047036a
    test ecx, ecx                                # 0047036e
    jge.d8 L_00470390                            # 00470370
L_00470372:
    # block 0x00470372: entered by jg at 0x00470365; fall-through of jge at 0x00470370, 3 instruction(s), ends with je to 0x0047038b (forward)
    movsx edx, word ptr [0x63a4cd]               # 00470372
    test edx, edx                                # 00470379
    je.d8 L_0047038b                             # 0047037b
    # block 0x0047037d: entered by fall-through of je at 0x0047037b, 4 instruction(s), calls FUN_0052139c, falls into the block at 0x0047038b
    push 0x0                                     # 0047037d
    push 0x0                                     # 0047037f
    push 0x54c244                                # 00470381
    call FUN_0052139c                            # 00470386
L_0047038b:
    # block 0x0047038b: entered by je at 0x0047037b, 1 instruction(s), ends with forward jump to 0x00470465
    jmp.d32 L_00470465                           # 0047038b
L_00470390:
    # block 0x00470390: entered by jge at 0x00470370, 2 instruction(s), ends with forward jump to 0x004703a2
    mov dword ptr [ebp - local_18], 0x0          # 00470390
    jmp.d8 L_004703a2                            # 00470397
L_00470399:
    # block 0x00470399: entered by jmp at 0x004703c3, 3 instruction(s), falls into the block at 0x004703a2
    mov eax, dword ptr [ebp - local_18]          # 00470399
    add eax, 0x1                                 # 0047039c
    mov dword ptr [ebp - local_18], eax          # 0047039f
L_004703a2:
    # block 0x004703a2: entered by jmp at 0x00470397, 5 instruction(s), ends with jge to 0x004703c5 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 004703a2
    movsx edx, word ptr [ecx + field_21]         # 004703a5
    sub edx, 0x1                                 # 004703a9
    cmp dword ptr [ebp - local_18], edx          # 004703ac
    jge.d8 L_004703c5                            # 004703af
    # block 0x004703b1: entered by fall-through of jge at 0x004703af, 7 instruction(s), ends with backward jump to 0x00470399
    mov eax, dword ptr [ebp - local_3c]          # 004703b1
    add eax, dword ptr [ebp - local_18]          # 004703b4
    mov ecx, dword ptr [ebp - local_3c]          # 004703b7
    add ecx, dword ptr [ebp - local_18]          # 004703ba
    mov dl, byte ptr [ecx + field_54]            # 004703bd
    mov byte ptr [eax + field_53], dl            # 004703c0
    jmp.d8 L_00470399                            # 004703c3
L_004703c5:
    # block 0x004703c5: entered by jge at 0x004703af, 4 instruction(s), ends with jne to 0x004703e2 (forward)
    mov eax, dword ptr [ebp - local_3c]          # 004703c5
    movsx ecx, word ptr [eax + field_2c]         # 004703c8
    cmp ecx, 0x9                                 # 004703cc
    jne.d8 L_004703e2                            # 004703cf
    # block 0x004703d1: entered by fall-through of jne at 0x004703cf, 5 instruction(s), ends with forward jump to 0x004703fa
    mov edx, dword ptr [ebp - local_24]          # 004703d1
    movsx eax, word ptr [edx + field_21]         # 004703d4
    mov ecx, dword ptr [ebp - local_3c]          # 004703d8
    mov byte ptr [ecx + eax + field_52], 0x0     # 004703db
    jmp.d8 L_004703fa                            # 004703e0
L_004703e2:
    # block 0x004703e2: entered by jne at 0x004703cf, 7 instruction(s), falls into the block at 0x004703fa
    mov edx, dword ptr [ebp - local_3c]          # 004703e2
    movsx eax, word ptr [edx + field_2c]         # 004703e5
    add eax, 0x1                                 # 004703e9
    mov ecx, dword ptr [ebp - local_24]          # 004703ec
    movsx edx, word ptr [ecx + field_21]         # 004703ef
    mov ecx, dword ptr [ebp - local_3c]          # 004703f3
    mov byte ptr [ecx + edx + field_52], al      # 004703f6
L_004703fa:
    # block 0x004703fa: entered by jmp at 0x004703e0, 6 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x0047041f
    mov edx, dword ptr [ebp - local_3c]          # 004703fa
    mov dword ptr [edx + field_5f], 0x1          # 004703fd
    call dword ptr [0x52a23c]                    # 00470404
    mov dword ptr [ebp - local_14], eax          # 0047040a
    mov dword ptr [ebp - local_10], 0x0          # 0047040d
    jmp.d8 L_0047041f                            # 00470414
L_00470416:
    # block 0x00470416: entered by jmp at 0x00470463, 3 instruction(s), falls into the block at 0x0047041f
    mov eax, dword ptr [ebp - local_10]          # 00470416
    add eax, 0x1                                 # 00470419
    mov dword ptr [ebp - local_10], eax          # 0047041c
L_0047041f:
    # block 0x0047041f: entered by jmp at 0x00470414, 4 instruction(s), ends with jge to 0x00470465 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 0047041f
    movsx edx, word ptr [ecx + field_21]         # 00470422
    cmp dword ptr [ebp - local_10], edx          # 00470426
    jge.d8 L_00470465                            # 00470429
    # block 0x0047042b: entered by fall-through of jge at 0x00470429, 20 instruction(s), calls FUN_004709bb, FUN_004709de, ends with backward jump to 0x00470416
    mov eax, dword ptr [ebp - local_3c]          # 0047042b
    add eax, dword ptr [ebp - local_10]          # 0047042e
    {load} xor ecx, ecx                          # 00470431
    mov cl, byte ptr [eax + field_53]            # 00470433
    push ecx                                     # 00470436
    mov ecx, dword ptr [ebp - local_3c]          # 00470437
    call FUN_004709bb                            # 0047043a
    push eax                                     # 0047043f
    mov edx, dword ptr [ebp - local_10]          # 00470440
    mov eax, dword ptr [ebp - local_3c]          # 00470443
    movsx ecx, word ptr [eax + 2*edx + field_36] # 00470446
    push ecx                                     # 0047044b
    mov ecx, dword ptr [ebp - local_3c]          # 0047044c
    call FUN_004709de                            # 0047044f
    mov edx, dword ptr [ebp - local_14]          # 00470454
    {load} add edx, eax                          # 00470457
    mov eax, dword ptr [ebp - local_10]          # 00470459
    mov ecx, dword ptr [ebp - local_3c]          # 0047045c
    mov dword ptr [ecx + 4*eax + field_67], edx  # 0047045f
    jmp.d8 L_00470416                            # 00470463
L_00470465:
    # block 0x00470465: entered by je at 0x0046fdc6; jbe at 0x0046fdd8; jmp at 0x0046fe5e; jmp at 0x0046feea; more, 3 instruction(s), ends with je to 0x004705a5 (forward)
    mov edx, dword ptr [ebp - local_3c]          # 00470465
    cmp dword ptr [edx + field_5f], 0x0          # 00470468
    je.d32 L_004705a5                            # 0047046c
    # block 0x00470472: entered by fall-through of je at 0x0047046c, 5 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x00470494
    call dword ptr [0x52a23c]                    # 00470472
    mov dword ptr [ebp - local_14], eax          # 00470478
    mov dword ptr [ebp - local_20], 0x1          # 0047047b
    mov dword ptr [ebp - local_18], 0x0          # 00470482
    jmp.d8 L_00470494                            # 00470489
L_0047048b:
    # block 0x0047048b: entered by jmp at 0x00470569, 3 instruction(s), falls into the block at 0x00470494
    mov eax, dword ptr [ebp - local_18]          # 0047048b
    add eax, 0x1                                 # 0047048e
    mov dword ptr [ebp - local_18], eax          # 00470491
L_00470494:
    # block 0x00470494: entered by jmp at 0x00470489, 4 instruction(s), ends with jge to 0x0047056e (forward)
    mov ecx, dword ptr [ebp - local_24]          # 00470494
    movsx edx, word ptr [ecx + field_21]         # 00470497
    cmp dword ptr [ebp - local_18], edx          # 0047049b
    jge.d32 L_0047056e                           # 0047049e
    # block 0x004704a4: entered by fall-through of jge at 0x0047049e, 12 instruction(s), calls FUN_004709bb, ends with je to 0x00470569 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004704a4
    mov ecx, dword ptr [ebp - local_3c]          # 004704a7
    movsx esi, word ptr [ecx + 2*eax + field_36] # 004704aa
    mov edx, dword ptr [ebp - local_3c]          # 004704af
    add edx, dword ptr [ebp - local_18]          # 004704b2
    {load} xor eax, eax                          # 004704b5
    mov al, byte ptr [edx + field_53]            # 004704b7
    push eax                                     # 004704ba
    mov ecx, dword ptr [ebp - local_3c]          # 004704bb
    call FUN_004709bb                            # 004704be
    {load} cmp esi, eax                          # 004704c3
    je.d32 L_00470569                            # 004704c5
    # block 0x004704cb: entered by fall-through of je at 0x004704c5, 6 instruction(s), ends with jle to 0x00470569 (forward)
    mov dword ptr [ebp - local_20], 0x0          # 004704cb
    mov ecx, dword ptr [ebp - local_18]          # 004704d2
    mov edx, dword ptr [ebp - local_3c]          # 004704d5
    mov eax, dword ptr [ebp - local_14]          # 004704d8
    cmp eax, dword ptr [edx + 4*ecx + field_67]  # 004704db
    jle.d32 L_00470569                           # 004704df
    # block 0x004704e5: entered by fall-through of jle at 0x004704df, 36 instruction(s), calls FUN_004709bb, FUN_004709de, FUN_004fb2e3, ends with jne to 0x00470569 (forward)
    mov ecx, dword ptr [ebp - local_3c]          # 004704e5
    add ecx, dword ptr [ebp - local_18]          # 004704e8
    {load} xor edx, edx                          # 004704eb
    mov dl, byte ptr [ecx + field_53]            # 004704ed
    push edx                                     # 004704f0
    mov ecx, dword ptr [ebp - local_3c]          # 004704f1
    call FUN_004709bb                            # 004704f4
    push eax                                     # 004704f9
    mov eax, dword ptr [ebp - local_18]          # 004704fa
    mov ecx, dword ptr [ebp - local_3c]          # 004704fd
    movsx edx, word ptr [ecx + 2*eax + field_36] # 00470500
    push edx                                     # 00470505
    mov ecx, dword ptr [ebp - local_3c]          # 00470506
    call FUN_004709de                            # 00470509
    mov ecx, dword ptr [ebp - local_14]          # 0047050e
    {load} add ecx, eax                          # 00470511
    mov edx, dword ptr [ebp - local_18]          # 00470513
    mov eax, dword ptr [ebp - local_3c]          # 00470516
    mov dword ptr [eax + 4*edx + field_67], ecx  # 00470519
    mov ecx, dword ptr [ebp - local_18]          # 0047051d
    mov edx, dword ptr [ebp - local_3c]          # 00470520
    mov ax, word ptr [edx + 2*ecx + field_36]    # 00470523
    .insn 0x66, 0x05, 0x0001{:u16}               # 00470528
    mov ecx, dword ptr [ebp - local_18]          # 0047052c
    mov edx, dword ptr [ebp - local_3c]          # 0047052f
    mov word ptr [edx + 2*ecx + field_36], ax    # 00470532
    mov eax, dword ptr [ebp - local_24]          # 00470537
    mov cx, word ptr [eax + field_63d]           # 0047053a
    push ecx                                     # 00470541
    mov ecx, 0x5c3a67                            # 00470542
    call FUN_004fb2e3                            # 00470547
    mov edx, dword ptr [ebp - local_18]          # 0047054c
    mov eax, dword ptr [ebp - local_3c]          # 0047054f
    movsx ecx, word ptr [eax + 2*edx + field_36] # 00470552
    cmp ecx, 0x1d                                # 00470557
    jne.d8 L_00470569                            # 0047055a
    # block 0x0047055c: entered by fall-through of jne at 0x0047055a, 3 instruction(s), falls into the block at 0x00470569
    mov edx, dword ptr [ebp - local_18]          # 0047055c
    mov eax, dword ptr [ebp - local_3c]          # 0047055f
    mov word ptr [eax + 2*edx + field_36], 0x0   # 00470562
L_00470569:
    # block 0x00470569: entered by je at 0x004704c5; jle at 0x004704df; jne at 0x0047055a, 1 instruction(s), ends with backward jump to 0x0047048b
    jmp.d32 L_0047048b                           # 00470569
L_0047056e:
    # block 0x0047056e: entered by jge at 0x0047049e, 2 instruction(s), ends with je to 0x004705a5 (forward)
    cmp dword ptr [ebp - local_20], 0x0          # 0047056e
    je.d8 L_004705a5                             # 00470572
    # block 0x00470574: entered by fall-through of je at 0x00470572, 6 instruction(s), ends with jne to 0x004705a5 (forward)
    mov ecx, dword ptr [ebp - local_3c]          # 00470574
    mov dword ptr [ecx + field_5f], 0x0          # 00470577
    movsx edx, word ptr [ebp + arg_8]            # 0047057e
    imul edx, edx, 0x8d                          # 00470582
    cmp dword ptr [edx + 0x5bb632], 0x2          # 00470588
    jne.d8 L_004705a5                            # 0047058f
    # block 0x00470591: entered by fall-through of jne at 0x0047058f, 3 instruction(s), falls into the block at 0x004705a5
    movsx eax, word ptr [ebp + arg_8]            # 00470591
    imul eax, eax, 0x8d                          # 00470595
    mov dword ptr [eax + 0x5bb632], 0x3          # 0047059b
L_004705a5:
    # block 0x004705a5: entered by je at 0x0047046c; je at 0x00470572; jne at 0x0047058f, 1 instruction(s), ends with forward jump to 0x00470972
    jmp.d32 L_00470972                           # 004705a5
L_004705aa:
    # block 0x004705aa: entered by switch case, 7 instruction(s), ends with je to 0x004705d6 (forward)
    mov edi, 0x54c28c                            # 004705aa
    mov esi, dword ptr [ebp - local_24]          # 004705af
    add esi, 0x61c                               # 004705b2
    mov ecx, 0x9                                 # 004705b8
    {load} xor edx, edx                          # 004705bd
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004705bf
    je.d8 L_004705d6                             # 004705c1
    # block 0x004705c3: entered by fall-through of je at 0x004705c1, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004705d6
    mov eax, dword ptr [ebp - local_24]          # 004705c3
    add eax, 0x61c                               # 004705c6
    push eax                                     # 004705cb
    mov ecx, 0x5c3a67                            # 004705cc
    call FUN_004fb77a                            # 004705d1
L_004705d6:
    # block 0x004705d6: entered by je at 0x004705c1, 7 instruction(s), ends with je to 0x00470602 (forward)
    mov edi, 0x54c298                            # 004705d6
    mov esi, dword ptr [ebp - local_24]          # 004705db
    add esi, 0x6b1                               # 004705de
    mov ecx, 0x9                                 # 004705e4
    {load} xor edx, edx                          # 004705e9
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004705eb
    je.d8 L_00470602                             # 004705ed
    # block 0x004705ef: entered by fall-through of je at 0x004705ed, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x00470602
    mov eax, dword ptr [ebp - local_24]          # 004705ef
    add eax, 0x6b1                               # 004705f2
    push eax                                     # 004705f7
    mov ecx, 0x5c3a67                            # 004705f8
    call FUN_004fba69                            # 004705fd
L_00470602:
    # block 0x00470602: entered by je at 0x004705ed, 7 instruction(s), ends with je to 0x0047062e (forward)
    mov edi, 0x54c2a4                            # 00470602
    mov esi, dword ptr [ebp - local_24]          # 00470607
    add esi, 0x746                               # 0047060a
    mov ecx, 0x9                                 # 00470610
    {load} xor edx, edx                          # 00470615
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00470617
    je.d8 L_0047062e                             # 00470619
    # block 0x0047061b: entered by fall-through of je at 0x00470619, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x0047062e
    mov eax, dword ptr [ebp - local_24]          # 0047061b
    add eax, 0x746                               # 0047061e
    push eax                                     # 00470623
    mov ecx, 0x5c3a67                            # 00470624
    call FUN_004fba69                            # 00470629
L_0047062e:
    # block 0x0047062e: entered by je at 0x00470619, 7 instruction(s), ends with je to 0x0047065a (forward)
    mov edi, 0x54c2b0                            # 0047062e
    mov esi, dword ptr [ebp - local_24]          # 00470633
    add esi, 0x7db                               # 00470636
    mov ecx, 0x9                                 # 0047063c
    {load} xor edx, edx                          # 00470641
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00470643
    je.d8 L_0047065a                             # 00470645
    # block 0x00470647: entered by fall-through of je at 0x00470645, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x0047065a
    mov eax, dword ptr [ebp - local_24]          # 00470647
    add eax, 0x7db                               # 0047064a
    push eax                                     # 0047064f
    mov ecx, 0x5c3a67                            # 00470650
    call FUN_004fba69                            # 00470655
L_0047065a:
    # block 0x0047065a: entered by je at 0x00470645, 7 instruction(s), ends with je to 0x00470686 (forward)
    mov edi, 0x54c2bc                            # 0047065a
    mov esi, dword ptr [ebp - local_24]          # 0047065f
    add esi, 0x870                               # 00470662
    mov ecx, 0x9                                 # 00470668
    {load} xor edx, edx                          # 0047066d
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0047066f
    je.d8 L_00470686                             # 00470671
    # block 0x00470673: entered by fall-through of je at 0x00470671, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x00470686
    mov eax, dword ptr [ebp - local_24]          # 00470673
    add eax, 0x870                               # 00470676
    push eax                                     # 0047067b
    mov ecx, 0x5c3a67                            # 0047067c
    call FUN_004fba69                            # 00470681
L_00470686:
    # block 0x00470686: entered by je at 0x00470671, 7 instruction(s), ends with je to 0x004706b2 (forward)
    mov edi, 0x54c2c8                            # 00470686
    mov esi, dword ptr [ebp - local_24]          # 0047068b
    add esi, 0x905                               # 0047068e
    mov ecx, 0x9                                 # 00470694
    {load} xor edx, edx                          # 00470699
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0047069b
    je.d8 L_004706b2                             # 0047069d
    # block 0x0047069f: entered by fall-through of je at 0x0047069d, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004706b2
    mov eax, dword ptr [ebp - local_24]          # 0047069f
    add eax, 0x905                               # 004706a2
    push eax                                     # 004706a7
    mov ecx, 0x5c3a67                            # 004706a8
    call FUN_004fba69                            # 004706ad
L_004706b2:
    # block 0x004706b2: entered by je at 0x0047069d, 7 instruction(s), ends with je to 0x004706de (forward)
    mov edi, 0x54c2d4                            # 004706b2
    mov esi, dword ptr [ebp - local_24]          # 004706b7
    add esi, 0x99a                               # 004706ba
    mov ecx, 0x9                                 # 004706c0
    {load} xor edx, edx                          # 004706c5
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004706c7
    je.d8 L_004706de                             # 004706c9
    # block 0x004706cb: entered by fall-through of je at 0x004706c9, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004706de
    mov eax, dword ptr [ebp - local_24]          # 004706cb
    add eax, 0x99a                               # 004706ce
    push eax                                     # 004706d3
    mov ecx, 0x5c3a67                            # 004706d4
    call FUN_004fba69                            # 004706d9
L_004706de:
    # block 0x004706de: entered by je at 0x004706c9, 7 instruction(s), ends with je to 0x0047070a (forward)
    mov edi, 0x54c2e0                            # 004706de
    mov esi, dword ptr [ebp - local_24]          # 004706e3
    add esi, 0xa2f                               # 004706e6
    mov ecx, 0x9                                 # 004706ec
    {load} xor edx, edx                          # 004706f1
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004706f3
    je.d8 L_0047070a                             # 004706f5
    # block 0x004706f7: entered by fall-through of je at 0x004706f5, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x0047070a
    mov eax, dword ptr [ebp - local_24]          # 004706f7
    add eax, 0xa2f                               # 004706fa
    push eax                                     # 004706ff
    mov ecx, 0x5c3a67                            # 00470700
    call FUN_004fba69                            # 00470705
L_0047070a:
    # block 0x0047070a: entered by je at 0x004706f5, 7 instruction(s), ends with je to 0x00470736 (forward)
    mov edi, 0x54c2ec                            # 0047070a
    mov esi, dword ptr [ebp - local_24]          # 0047070f
    add esi, 0xac4                               # 00470712
    mov ecx, 0x9                                 # 00470718
    {load} xor edx, edx                          # 0047071d
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0047071f
    je.d8 L_00470736                             # 00470721
    # block 0x00470723: entered by fall-through of je at 0x00470721, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x00470736
    mov eax, dword ptr [ebp - local_24]          # 00470723
    add eax, 0xac4                               # 00470726
    push eax                                     # 0047072b
    mov ecx, 0x5c3a67                            # 0047072c
    call FUN_004fba69                            # 00470731
L_00470736:
    # block 0x00470736: entered by je at 0x00470721, 7 instruction(s), ends with je to 0x00470762 (forward)
    mov edi, 0x54c2f8                            # 00470736
    mov esi, dword ptr [ebp - local_24]          # 0047073b
    add esi, 0xb59                               # 0047073e
    mov ecx, 0x9                                 # 00470744
    {load} xor edx, edx                          # 00470749
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0047074b
    je.d8 L_00470762                             # 0047074d
    # block 0x0047074f: entered by fall-through of je at 0x0047074d, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x00470762
    mov eax, dword ptr [ebp - local_24]          # 0047074f
    add eax, 0xb59                               # 00470752
    push eax                                     # 00470757
    mov ecx, 0x5c3a67                            # 00470758
    call FUN_004fba69                            # 0047075d
L_00470762:
    # block 0x00470762: entered by je at 0x0047074d, 7 instruction(s), ends with je to 0x0047078e (forward)
    mov edi, 0x54c304                            # 00470762
    mov esi, dword ptr [ebp - local_24]          # 00470767
    add esi, 0xbee                               # 0047076a
    mov ecx, 0x9                                 # 00470770
    {load} xor edx, edx                          # 00470775
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00470777
    je.d8 L_0047078e                             # 00470779
    # block 0x0047077b: entered by fall-through of je at 0x00470779, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x0047078e
    mov eax, dword ptr [ebp - local_24]          # 0047077b
    add eax, 0xbee                               # 0047077e
    push eax                                     # 00470783
    mov ecx, 0x5c3a67                            # 00470784
    call FUN_004fba69                            # 00470789
L_0047078e:
    # block 0x0047078e: entered by je at 0x00470779, 3 instruction(s), ends with je to 0x0047087d (forward)
    mov ecx, dword ptr [ebp - local_3c]          # 0047078e
    cmp dword ptr [ecx + field_4e], 0x0          # 00470791
    je.d32 L_0047087d                            # 00470795
    # block 0x0047079b: entered by fall-through of je at 0x00470795, 4 instruction(s), ends with je to 0x0047084d (forward)
    mov edx, dword ptr [ebp - local_24]          # 0047079b
    movsx eax, word ptr [edx + field_e73]        # 0047079e
    cmp eax, 0x270f                              # 004707a5
    je.d32 L_0047084d                            # 004707aa
    # block 0x004707b0: entered by fall-through of je at 0x004707aa, 25 instruction(s), ends with jne to 0x00470839 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 004707b0
    movsx edx, word ptr [ecx + field_e73]        # 004707b3
    mov dword ptr [0x5bb57b], edx                # 004707ba
    mov eax, dword ptr [ebp - local_24]          # 004707c0
    mov cx, word ptr [eax + field_e75]           # 004707c3
    mov word ptr [0x5bb599], cx                  # 004707ca
    mov edx, dword ptr [ebp - local_24]          # 004707d1
    mov ax, word ptr [edx + field_e77]           # 004707d4
    mov word ptr [0x5bb595], ax                  # 004707db
    mov ecx, dword ptr [ebp - local_24]          # 004707e1
    mov dx, word ptr [ecx + field_e79]           # 004707e4
    mov word ptr [0x5c39ff], dx                  # 004707eb
    mov eax, dword ptr [ebp - local_24]          # 004707f2
    mov ecx, dword ptr [eax + field_e7b]         # 004707f5
    mov dword ptr [0x5bb59b], ecx                # 004707fb
    mov edx, dword ptr [ebp - local_24]          # 00470801
    mov eax, dword ptr [edx + field_e7f]         # 00470804
    mov dword ptr [0x5bb59f], eax                # 0047080a
    mov ecx, dword ptr [ebp - local_24]          # 0047080f
    mov edx, dword ptr [ecx + field_e83]         # 00470812
    mov dword ptr [0x5bb5a3], edx                # 00470818
    mov eax, dword ptr [ebp - local_24]          # 0047081e
    movsx ecx, word ptr [eax + field_e87]        # 00470821
    cmp ecx, 0x1                                 # 00470828
    jne.d8 L_00470839                            # 0047082b
    # block 0x0047082d: entered by fall-through of jne at 0x0047082b, 2 instruction(s), ends with forward jump to 0x00470843
    mov dword ptr [0x5bb1ca], 0x0                # 0047082d
    jmp.d8 L_00470843                            # 00470837
L_00470839:
    # block 0x00470839: entered by jne at 0x0047082b, 1 instruction(s), falls into the block at 0x00470843
    mov dword ptr [0x5bb1ca], 0x1                # 00470839
L_00470843:
    # block 0x00470843: entered by jmp at 0x00470837, 1 instruction(s), falls into the block at 0x0047084d
    mov dword ptr [0x583999], 0x4                # 00470843
L_0047084d:
    # block 0x0047084d: entered by je at 0x004707aa, 4 instruction(s), ends with je to 0x00470878 (forward)
    mov edx, dword ptr [ebp - local_24]          # 0047084d
    movsx eax, word ptr [edx + field_e89]        # 00470850
    cmp eax, -0x1                                # 00470857
    je.d8 L_00470878                             # 0047085a
    # block 0x0047085c: entered by fall-through of je at 0x0047085a, 6 instruction(s), falls into the block at 0x00470878
    mov ecx, dword ptr [ebp - local_24]          # 0047085c
    {load} xor edx, edx                          # 0047085f
    mov dl, byte ptr [ecx + field_e8b]           # 00470861
    mov eax, dword ptr [ebp - local_24]          # 00470867
    movsx ecx, word ptr [eax + field_e89]        # 0047086a
    mov dword ptr [4*ecx + 0x585801], edx        # 00470871
L_00470878:
    # block 0x00470878: entered by je at 0x0047085a, 1 instruction(s), ends with forward jump to 0x0047095a
    jmp.d32 L_0047095a                           # 00470878
L_0047087d:
    # block 0x0047087d: entered by je at 0x00470795, 4 instruction(s), ends with je to 0x0047092f (forward)
    mov edx, dword ptr [ebp - local_24]          # 0047087d
    movsx eax, word ptr [edx + field_f43]        # 00470880
    cmp eax, 0x270f                              # 00470887
    je.d32 L_0047092f                            # 0047088c
    # block 0x00470892: entered by fall-through of je at 0x0047088c, 25 instruction(s), ends with jne to 0x0047091b (forward)
    mov ecx, dword ptr [ebp - local_24]          # 00470892
    movsx edx, word ptr [ecx + field_f43]        # 00470895
    mov dword ptr [0x5bb57b], edx                # 0047089c
    mov eax, dword ptr [ebp - local_24]          # 004708a2
    mov cx, word ptr [eax + field_f45]           # 004708a5
    mov word ptr [0x5bb599], cx                  # 004708ac
    mov edx, dword ptr [ebp - local_24]          # 004708b3
    mov ax, word ptr [edx + field_f47]           # 004708b6
    mov word ptr [0x5bb595], ax                  # 004708bd
    mov ecx, dword ptr [ebp - local_24]          # 004708c3
    mov dx, word ptr [ecx + field_f49]           # 004708c6
    mov word ptr [0x5c39ff], dx                  # 004708cd
    mov eax, dword ptr [ebp - local_24]          # 004708d4
    mov ecx, dword ptr [eax + field_f4b]         # 004708d7
    mov dword ptr [0x5bb59b], ecx                # 004708dd
    mov edx, dword ptr [ebp - local_24]          # 004708e3
    mov eax, dword ptr [edx + field_f4f]         # 004708e6
    mov dword ptr [0x5bb59f], eax                # 004708ec
    mov ecx, dword ptr [ebp - local_24]          # 004708f1
    mov edx, dword ptr [ecx + field_f53]         # 004708f4
    mov dword ptr [0x5bb5a3], edx                # 004708fa
    mov eax, dword ptr [ebp - local_24]          # 00470900
    movsx ecx, word ptr [eax + field_f57]        # 00470903
    cmp ecx, 0x1                                 # 0047090a
    jne.d8 L_0047091b                            # 0047090d
    # block 0x0047090f: entered by fall-through of jne at 0x0047090d, 2 instruction(s), ends with forward jump to 0x00470925
    mov dword ptr [0x5bb1ca], 0x0                # 0047090f
    jmp.d8 L_00470925                            # 00470919
L_0047091b:
    # block 0x0047091b: entered by jne at 0x0047090d, 1 instruction(s), falls into the block at 0x00470925
    mov dword ptr [0x5bb1ca], 0x1                # 0047091b
L_00470925:
    # block 0x00470925: entered by jmp at 0x00470919, 1 instruction(s), falls into the block at 0x0047092f
    mov dword ptr [0x583999], 0x4                # 00470925
L_0047092f:
    # block 0x0047092f: entered by je at 0x0047088c, 4 instruction(s), ends with je to 0x0047095a (forward)
    mov edx, dword ptr [ebp - local_24]          # 0047092f
    movsx eax, word ptr [edx + field_f59]        # 00470932
    cmp eax, -0x1                                # 00470939
    je.d8 L_0047095a                             # 0047093c
    # block 0x0047093e: entered by fall-through of je at 0x0047093c, 6 instruction(s), falls into the block at 0x0047095a
    mov ecx, dword ptr [ebp - local_24]          # 0047093e
    {load} xor edx, edx                          # 00470941
    mov dl, byte ptr [ecx + field_f5b]           # 00470943
    mov eax, dword ptr [ebp - local_24]          # 00470949
    movsx ecx, word ptr [eax + field_f59]        # 0047094c
    mov dword ptr [4*ecx + 0x585801], edx        # 00470953
L_0047095a:
    # block 0x0047095a: entered by jmp at 0x00470878; je at 0x0047093c, 7 instruction(s), calls FUN_0042ba3a, FUN_0046e7a6, falls into the block at 0x00470972
    mov edx, dword ptr [ebp - local_3c]          # 0047095a
    mov ax, word ptr [edx + field_1e]            # 0047095d
    push eax                                     # 00470961
    call FUN_0042ba3a                            # 00470962
    add esp, 0x4                                 # 00470967
    mov ecx, dword ptr [ebp - local_3c]          # 0047096a
    call FUN_0046e7a6                            # 0047096d
L_00470972:
    # block 0x00470972: entered by ja at 0x0046f9df; jmp at 0x0046fdba; jmp at 0x004705a5, 10 instruction(s), calls FUN_0051e7ba, ends with ret 0x4
    mov dword ptr [ebp - local_4], 0xffffffff    # 00470972
    lea ecx, [ebp - local_1c]                    # 00470979
    call FUN_0051e7ba                            # 0047097c
    mov ecx, dword ptr [ebp - local_c]           # 00470981
    mov dword ptr fs:[0x0], ecx                  # 00470984
    pop edi                                      # 0047098b
    pop esi                                      # 0047098c
    {load} mov esp, ebp                          # 0047098d
    pop ebp                                      # 0047098f
    ret 0x4                                      # 00470990

# --- data items (not part of the function) -------------------------
.org 0x00470993 - 0x401000
SWTAB_00470993:  # 4 case address(es)
    .long L_0046f9ef - .text + 0x401000
    .long L_0046fdbf - .text + 0x401000
    .long L_00470465 - .text + 0x401000
    .long L_004705aa - .text + 0x401000
.org 0x004709a3 - 0x401000
SWTAB_004709a3:  # 6 case address(es)
    .long L_0046fe0f - .text + 0x401000
    .long L_0046fe63 - .text + 0x401000
    .long L_0046feef - .text + 0x401000
    .long L_0046ff7b - .text + 0x401000
    .long L_0047027f - .text + 0x401000
    .long L_0047030f - .text + 0x401000
.set SWTAB_00470993_VA, SWTAB_00470993 - .text + 0x401000
.set SWTAB_004709a3_VA, SWTAB_004709a3 - .text + 0x401000

