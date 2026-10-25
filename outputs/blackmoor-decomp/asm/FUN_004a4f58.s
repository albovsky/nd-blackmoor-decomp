# FUN_004a4f58
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a4f58
# extent:       0x004a4f58-0x004a5eda (3970 code bytes)
# span:         0x004a4f58-0x004a5eda (code 3970, tables 0, padding 0)
# sha256:       7a9fa8b7e2a2420855bacd3c866cb9f70684d48d80457a1f838fb70dd41b98ed
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a4f58
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       8 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20
# fields:       [eax + n] field_4, field_8, field_c, field_1c, field_20, field_21, field_22, field_23, field_27, field_2b, field_2d, field_200 and 23 more; [ecx + n] field_4, field_8, field_1c, field_1e, field_20, field_21, field_22, field_23, field_2b, field_2d, field_200, field_203 and 19 more; [edx + n] field_4, field_c, field_1c, field_1e, field_20, field_21, field_23, field_2b, field_2d, field_2f, field_200, field_203 and 32 more
# callees:      calls FUN_004e8d96, FUN_004c2790, FUN_004c2a8d, FUN_004c6c2a, FUN_004c6e4d, FUN_004d39f9, FUN_004fb77a, FUN_004a39c4, FUN_004fb2e3, FUN_004f6334, FUN_004fba69, FUN_004a3947, FUN_0042ba3a, FUN_004a3884
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 998 instruction(s), 49 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_21, 0x21  # offset +0x21
.equ field_22, 0x22  # offset +0x22
.equ field_23, 0x23  # offset +0x23
.equ field_27, 0x27  # offset +0x27
.equ field_2b, 0x2b  # offset +0x2b
.equ field_2d, 0x2d  # offset +0x2d
.equ field_2f, 0x2f  # offset +0x2f
.equ field_200, 0x200  # offset +0x200
.equ field_203, 0x203  # offset +0x203
.equ field_204, 0x204  # offset +0x204
.equ field_208, 0x208  # offset +0x208
.equ field_20c, 0x20c  # offset +0x20c
.equ field_264, 0x264  # offset +0x264
.equ field_26e, 0x26e  # offset +0x26e
.equ field_27a, 0x27a  # offset +0x27a
.equ field_27b, 0x27b  # offset +0x27b
.equ field_27f, 0x27f  # offset +0x27f
.equ field_290, 0x290  # offset +0x290
.equ field_3e3, 0x3e3  # offset +0x3e3
.equ field_3e7, 0x3e7  # offset +0x3e7
.equ field_3eb, 0x3eb  # offset +0x3eb
.equ field_3ef, 0x3ef  # offset +0x3ef
.equ field_3f3, 0x3f3  # offset +0x3f3
.equ field_3f7, 0x3f7  # offset +0x3f7
.equ field_3fb, 0x3fb  # offset +0x3fb
.equ field_3ff, 0x3ff  # offset +0x3ff
.equ field_403, 0x403  # offset +0x403
.equ field_407, 0x407  # offset +0x407
.equ field_40b, 0x40b  # offset +0x40b
.equ field_40f, 0x40f  # offset +0x40f
.equ field_413, 0x413  # offset +0x413
.equ field_470, 0x470  # offset +0x470
.equ field_5a8, 0x5a8  # offset +0x5a8
.equ field_5a9, 0x5a9  # offset +0x5a9
.equ field_5ad, 0x5ad  # offset +0x5ad
.equ field_5b1, 0x5b1  # offset +0x5b1
.equ field_5b5, 0x5b5  # offset +0x5b5
.equ field_64c, 0x64c  # offset +0x64c
.equ field_64e, 0x64e  # offset +0x64e
.equ field_650, 0x650  # offset +0x650
.equ field_652, 0x652  # offset +0x652
.equ field_654, 0x654  # offset +0x654
.equ field_658, 0x658  # offset +0x658
.equ field_65c, 0x65c  # offset +0x65c
.equ field_660, 0x660  # offset +0x660
.equ field_662, 0x662  # offset +0x662
.equ field_664, 0x664  # offset +0x664
.equ field_686, 0x686  # offset +0x686
.equ field_696, 0x696  # offset +0x696
.equ field_698, 0x698  # offset +0x698
.equ field_69a, 0x69a  # offset +0x69a
.equ field_69c, 0x69c  # offset +0x69c
.equ field_69e, 0x69e  # offset +0x69e
.equ field_6a2, 0x6a2  # offset +0x6a2
.equ field_6a6, 0x6a6  # offset +0x6a6
.equ field_6aa, 0x6aa  # offset +0x6aa
.equ field_6ac, 0x6ac  # offset +0x6ac
.equ field_6ae, 0x6ae  # offset +0x6ae
.equ field_830, 0x830  # offset +0x830
.equ field_832, 0x832  # offset +0x832
.equ field_834, 0x834  # offset +0x834
.equ field_836, 0x836  # offset +0x836

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_004a3884, .text + (0x004a3884 - 0x401000)
.set FUN_004a3947, .text + (0x004a3947 - 0x401000)
.set FUN_004a39c4, .text + (0x004a39c4 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004c2a8d, .text + (0x004c2a8d - 0x401000)
.set FUN_004c6c2a, .text + (0x004c6c2a - 0x401000)
.set FUN_004c6e4d, .text + (0x004c6e4d - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)

.org 0x004a4f58 - 0x401000
.globl FUN_004a4f58
FUN_004a4f58:
    # block 0x004a4f58: entry, 16 instruction(s), ends with je to 0x004a4fa8 (forward)
    push ebp                                     # 004a4f58
    {load} mov ebp, esp                          # 004a4f59
    sub esp, 0x20                                # 004a4f5b
    push esi                                     # 004a4f5e
    push edi                                     # 004a4f5f
    mov dword ptr [ebp - local_18], ecx          # 004a4f60
    movsx eax, word ptr [ebp + arg_8]            # 004a4f63
    imul eax, eax, 0x8d                          # 004a4f67
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004a4f6d
    mov dword ptr [ebp - local_4], ecx           # 004a4f73
    movsx edx, word ptr [ebp + arg_8]            # 004a4f76
    imul edx, edx, 0x8d                          # 004a4f7a
    mov eax, dword ptr [edx + 0x5bb632]          # 004a4f80
    mov dword ptr [ebp - local_1c], eax          # 004a4f86
    cmp dword ptr [ebp - local_1c], 0x0          # 004a4f89
    je.d8 L_004a4fa8                             # 004a4f8d
    # block 0x004a4f8f: entered by fall-through of je at 0x004a4f8d, 2 instruction(s), ends with je to 0x004a5b6a (forward)
    cmp dword ptr [ebp - local_1c], 0x1          # 004a4f8f
    je.d32 L_004a5b6a                            # 004a4f93
    # block 0x004a4f99: entered by fall-through of je at 0x004a4f93, 2 instruction(s), ends with je to 0x004a5c3e (forward)
    cmp dword ptr [ebp - local_1c], 0x2          # 004a4f99
    je.d32 L_004a5c3e                            # 004a4f9d
    # block 0x004a4fa3: entered by fall-through of je at 0x004a4f9d, 1 instruction(s), ends with forward jump to 0x004a5ed2
    jmp.d32 L_004a5ed2                           # 004a4fa3
L_004a4fa8:
    # block 0x004a4fa8: entered by je at 0x004a4f8d, 12 instruction(s), calls FUN_004e8d96, ends with forward jump to 0x004a4ff2
    mov ecx, dword ptr [ebp - local_18]          # 004a4fa8
    mov dx, word ptr [ebp + arg_8]               # 004a4fab
    mov word ptr [ecx + field_1e], dx            # 004a4faf
    mov eax, dword ptr [ebp - local_18]          # 004a4fb3
    mov dword ptr [eax + field_26e], 0x1         # 004a4fb6
    mov dword ptr [0x5bb1ca], 0x1                # 004a4fc0
    mov ecx, 0x571442                            # 004a4fca
    call FUN_004e8d96                            # 004a4fcf
    mov ecx, dword ptr [ebp - local_18]          # 004a4fd4
    mov word ptr [ecx + field_264], 0xffff       # 004a4fd7
    mov dword ptr [ebp - local_8], 0x0           # 004a4fe0
    jmp.d8 L_004a4ff2                            # 004a4fe7
L_004a4fe9:
    # block 0x004a4fe9: entered by jmp at 0x004a516f, 3 instruction(s), falls into the block at 0x004a4ff2
    mov edx, dword ptr [ebp - local_8]           # 004a4fe9
    add edx, 0x1                                 # 004a4fec
    mov dword ptr [ebp - local_8], edx           # 004a4fef
L_004a4ff2:
    # block 0x004a4ff2: entered by jmp at 0x004a4fe7, 2 instruction(s), ends with jge to 0x004a5174 (forward)
    cmp dword ptr [ebp - local_8], 0x2           # 004a4ff2
    jge.d32 L_004a5174                           # 004a4ff6
    # block 0x004a4ffc: entered by fall-through of jge at 0x004a4ff6, 5 instruction(s), ends with jne to 0x004a5082 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004a4ffc
    imul eax, eax, 0x7c                          # 004a4fff
    movsx ecx, word ptr [eax + 0x591a24]         # 004a5002
    test ecx, ecx                                # 004a5009
    jne.d8 L_004a5082                            # 004a500b
    # block 0x004a500d: entered by fall-through of jne at 0x004a500b, 26 instruction(s), ends with forward jump to 0x004a516f
    mov esi, dword ptr [ebp - local_4]           # 004a500d
    add esi, 0x415                               # 004a5010
    mov edi, dword ptr [ebp - local_8]           # 004a5016
    imul edi, edi, 0x7c                          # 004a5019
    add edi, 0x591a28                            # 004a501c
    mov ecx, 0xf                                 # 004a5022
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004a5027
    mov esi, dword ptr [ebp - local_4]           # 004a5029
    add esi, 0x451                               # 004a502c
    mov edi, dword ptr [ebp - local_8]           # 004a5032
    imul edi, edi, 0x7c                          # 004a5035
    add edi, 0x591a64                            # 004a5038
    mov ecx, 0xf                                 # 004a503e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004a5043
    mov edx, dword ptr [ebp - local_8]           # 004a5045
    imul edx, edx, 0x7c                          # 004a5048
    mov word ptr [edx + 0x591a24], 0x1           # 004a504b
    mov eax, dword ptr [ebp - local_8]           # 004a5054
    imul eax, eax, 0x7c                          # 004a5057
    mov cx, word ptr [0x5bb57b]                  # 004a505a
    mov word ptr [eax + 0x591a26], cx            # 004a5061
    mov edx, dword ptr [ebp - local_18]          # 004a5068
    mov ax, word ptr [ebp - local_8]             # 004a506b
    mov word ptr [edx + field_264], ax           # 004a506f
    mov dword ptr [ebp - local_8], 0x2           # 004a5076
    jmp.d32 L_004a516f                           # 004a507d
L_004a5082:
    # block 0x004a5082: entered by jne at 0x004a500b, 5 instruction(s), ends with jne to 0x004a516f (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004a5082
    imul ecx, ecx, 0x7c                          # 004a5085
    movsx edx, word ptr [ecx + 0x591a26]         # 004a5088
    cmp dword ptr [0x5bb57b], edx                # 004a508f
    jne.d32 L_004a516f                           # 004a5095
    # block 0x004a509b: entered by fall-through of jne at 0x004a5095, 5 instruction(s), ends with forward jump to 0x004a50bb
    mov eax, dword ptr [ebp - local_18]          # 004a509b
    mov cx, word ptr [ebp - local_8]             # 004a509e
    mov word ptr [eax + field_264], cx           # 004a50a2
    mov dword ptr [ebp - local_10], 0x0          # 004a50a9
    jmp.d8 L_004a50bb                            # 004a50b0
L_004a50b2:
    # block 0x004a50b2: entered by jmp at 0x004a5163, 3 instruction(s), falls into the block at 0x004a50bb
    mov edx, dword ptr [ebp - local_10]          # 004a50b2
    add edx, 0x1                                 # 004a50b5
    mov dword ptr [ebp - local_10], edx          # 004a50b8
L_004a50bb:
    # block 0x004a50bb: entered by jmp at 0x004a50b0, 4 instruction(s), ends with jge to 0x004a5168 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a50bb
    movsx ecx, byte ptr [eax + field_22]         # 004a50be
    cmp dword ptr [ebp - local_10], ecx          # 004a50c2
    jge.d32 L_004a5168                           # 004a50c5
    # block 0x004a50cb: entered by fall-through of jge at 0x004a50c5, 4 instruction(s), ends with je to 0x004a5168 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004a50cb
    movsx eax, word ptr [edx + field_264]        # 004a50ce
    cmp eax, -0x1                                # 004a50d5
    je.d32 L_004a5168                            # 004a50d8
    # block 0x004a50de: entered by fall-through of je at 0x004a50d8, 2 instruction(s), ends with forward jump to 0x004a50f0
    mov dword ptr [ebp - local_c], 0x0           # 004a50de
    jmp.d8 L_004a50f0                            # 004a50e5
L_004a50e7:
    # block 0x004a50e7: entered by jmp at 0x004a5161, 3 instruction(s), falls into the block at 0x004a50f0
    mov ecx, dword ptr [ebp - local_c]           # 004a50e7
    add ecx, 0x1                                 # 004a50ea
    mov dword ptr [ebp - local_c], ecx           # 004a50ed
L_004a50f0:
    # block 0x004a50f0: entered by jmp at 0x004a50e5, 4 instruction(s), ends with jge to 0x004a5163 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004a50f0
    movsx eax, byte ptr [edx + field_21]         # 004a50f3
    cmp dword ptr [ebp - local_c], eax           # 004a50f7
    jge.d8 L_004a5163                            # 004a50fa
    # block 0x004a50fc: entered by fall-through of jge at 0x004a50fa, 4 instruction(s), ends with je to 0x004a5163 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004a50fc
    movsx edx, word ptr [ecx + field_264]        # 004a50ff
    cmp edx, -0x1                                # 004a5106
    je.d8 L_004a5163                             # 004a5109
    # block 0x004a510b: entered by fall-through of je at 0x004a5109, 10 instruction(s), ends with jl to 0x004a5155 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004a510b
    movsx ecx, word ptr [eax + field_264]        # 004a510e
    imul ecx, ecx, 0x7c                          # 004a5115
    mov edx, dword ptr [ebp - local_10]          # 004a5118
    imul edx, edx, 0xc                           # 004a511b
    lea eax, [ecx + edx + 0x591a28]              # 004a511e
    mov ecx, dword ptr [ebp - local_c]           # 004a5125
    movsx edx, word ptr [eax + 2*ecx]            # 004a5128
    test edx, edx                                # 004a512c
    jl.d8 L_004a5155                             # 004a512e
    # block 0x004a5130: entered by fall-through of jl at 0x004a512e, 10 instruction(s), ends with jge to 0x004a5161 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004a5130
    movsx ecx, word ptr [eax + field_264]        # 004a5133
    imul ecx, ecx, 0x7c                          # 004a513a
    mov edx, dword ptr [ebp - local_10]          # 004a513d
    imul edx, edx, 0xc                           # 004a5140
    lea eax, [ecx + edx + 0x591a64]              # 004a5143
    mov ecx, dword ptr [ebp - local_c]           # 004a514a
    movsx edx, word ptr [eax + 2*ecx]            # 004a514d
    test edx, edx                                # 004a5151
    jge.d8 L_004a5161                            # 004a5153
L_004a5155:
    # block 0x004a5155: entered by jl at 0x004a512e; fall-through of jge at 0x004a5153, 2 instruction(s), falls into the block at 0x004a5161
    mov eax, dword ptr [ebp - local_18]          # 004a5155
    mov word ptr [eax + field_264], 0xffff       # 004a5158
L_004a5161:
    # block 0x004a5161: entered by jge at 0x004a5153, 1 instruction(s), ends with backward jump to 0x004a50e7
    jmp.d8 L_004a50e7                            # 004a5161
L_004a5163:
    # block 0x004a5163: entered by jge at 0x004a50fa; je at 0x004a5109, 1 instruction(s), ends with backward jump to 0x004a50b2
    jmp.d32 L_004a50b2                           # 004a5163
L_004a5168:
    # block 0x004a5168: entered by jge at 0x004a50c5; je at 0x004a50d8, 1 instruction(s), falls into the block at 0x004a516f
    mov dword ptr [ebp - local_8], 0x2           # 004a5168
L_004a516f:
    # block 0x004a516f: entered by jmp at 0x004a507d; jne at 0x004a5095, 1 instruction(s), ends with backward jump to 0x004a4fe9
    jmp.d32 L_004a4fe9                           # 004a516f
L_004a5174:
    # block 0x004a5174: entered by jge at 0x004a4ff6, 4 instruction(s), ends with jne to 0x004a51d0 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004a5174
    movsx edx, word ptr [ecx + field_264]        # 004a5177
    cmp edx, -0x1                                # 004a517e
    jne.d8 L_004a51d0                            # 004a5181
    # block 0x004a5183: entered by fall-through of jne at 0x004a5181, 15 instruction(s), falls into the block at 0x004a51d0
    mov eax, dword ptr [ebp - local_18]          # 004a5183
    mov word ptr [eax + field_264], 0x1          # 004a5186
    mov esi, dword ptr [ebp - local_4]           # 004a518f
    add esi, 0x415                               # 004a5192
    mov ecx, 0xf                                 # 004a5198
    mov edi, 0x591aa4                            # 004a519d
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004a51a2
    mov esi, dword ptr [ebp - local_4]           # 004a51a4
    add esi, 0x451                               # 004a51a7
    mov ecx, 0xf                                 # 004a51ad
    mov edi, 0x591ae0                            # 004a51b2
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004a51b7
    mov word ptr [0x591aa0], 0x1                 # 004a51b9
    mov cx, word ptr [0x5bb57b]                  # 004a51c2
    mov word ptr [0x591aa2], cx                  # 004a51c9
L_004a51d0:
    # block 0x004a51d0: entered by jne at 0x004a5181, 2 instruction(s), ends with forward jump to 0x004a51e2
    mov dword ptr [ebp - local_10], 0x0          # 004a51d0
    jmp.d8 L_004a51e2                            # 004a51d7
L_004a51d9:
    # block 0x004a51d9: entered by jmp at 0x004a55c6, 3 instruction(s), falls into the block at 0x004a51e2
    mov edx, dword ptr [ebp - local_10]          # 004a51d9
    add edx, 0x1                                 # 004a51dc
    mov dword ptr [ebp - local_10], edx          # 004a51df
L_004a51e2:
    # block 0x004a51e2: entered by jmp at 0x004a51d7, 4 instruction(s), ends with jge to 0x004a55cb (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a51e2
    movsx ecx, byte ptr [eax + field_22]         # 004a51e5
    cmp dword ptr [ebp - local_10], ecx          # 004a51e9
    jge.d32 L_004a55cb                           # 004a51ec
    # block 0x004a51f2: entered by fall-through of jge at 0x004a51ec, 2 instruction(s), ends with forward jump to 0x004a5204
    mov dword ptr [ebp - local_c], 0x0           # 004a51f2
    jmp.d8 L_004a5204                            # 004a51f9
L_004a51fb:
    # block 0x004a51fb: entered by jmp at 0x004a55c1, 3 instruction(s), falls into the block at 0x004a5204
    mov edx, dword ptr [ebp - local_c]           # 004a51fb
    add edx, 0x1                                 # 004a51fe
    mov dword ptr [ebp - local_c], edx           # 004a5201
L_004a5204:
    # block 0x004a5204: entered by jmp at 0x004a51f9, 4 instruction(s), ends with jge to 0x004a55c6 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a5204
    movsx ecx, byte ptr [eax + field_21]         # 004a5207
    cmp dword ptr [ebp - local_c], ecx           # 004a520b
    jge.d32 L_004a55c6                           # 004a520e
    # block 0x004a5214: entered by fall-through of jge at 0x004a520e, 253 instruction(s), ends with backward jump to 0x004a51fb
    mov edx, dword ptr [ebp - local_10]          # 004a5214
    imul edx, edx, 0x60                          # 004a5217
    mov eax, dword ptr [ebp - local_4]           # 004a521a
    lea ecx, [eax + edx + field_203]             # 004a521d
    mov edx, dword ptr [ebp - local_c]           # 004a5224
    shl edx, 0x4                                 # 004a5227
    mov eax, dword ptr [ecx + edx + field_4]     # 004a522a
    add eax, dword ptr [0x58318a]                # 004a522e
    mov ecx, dword ptr [ebp - local_10]          # 004a5234
    imul ecx, ecx, 0x60                          # 004a5237
    mov edx, dword ptr [ebp - local_18]          # 004a523a
    lea ecx, [edx + ecx + field_20]              # 004a523d
    mov edx, dword ptr [ebp - local_c]           # 004a5241
    shl edx, 0x4                                 # 004a5244
    mov dword ptr [ecx + edx + field_4], eax     # 004a5247
    mov eax, dword ptr [ebp - local_10]          # 004a524b
    imul eax, eax, 0x60                          # 004a524e
    mov ecx, dword ptr [ebp - local_4]           # 004a5251
    lea edx, [ecx + eax + field_203]             # 004a5254
    mov eax, dword ptr [ebp - local_c]           # 004a525b
    shl eax, 0x4                                 # 004a525e
    mov ecx, dword ptr [edx + eax + field_c]     # 004a5261
    add ecx, dword ptr [0x58318a]                # 004a5265
    mov edx, dword ptr [ebp - local_10]          # 004a526b
    imul edx, edx, 0x60                          # 004a526e
    mov eax, dword ptr [ebp - local_18]          # 004a5271
    lea edx, [eax + edx + field_20]              # 004a5274
    mov eax, dword ptr [ebp - local_c]           # 004a5278
    shl eax, 0x4                                 # 004a527b
    mov dword ptr [edx + eax + field_c], ecx     # 004a527e
    mov ecx, dword ptr [ebp - local_10]          # 004a5282
    imul ecx, ecx, 0x60                          # 004a5285
    mov edx, dword ptr [ebp - local_4]           # 004a5288
    lea eax, [edx + ecx + field_203]             # 004a528b
    mov ecx, dword ptr [ebp - local_c]           # 004a5292
    shl ecx, 0x4                                 # 004a5295
    mov edx, dword ptr [eax + ecx]               # 004a5298
    add edx, dword ptr [0x583186]                # 004a529b
    mov eax, dword ptr [ebp - local_10]          # 004a52a1
    imul eax, eax, 0x60                          # 004a52a4
    mov ecx, dword ptr [ebp - local_18]          # 004a52a7
    lea eax, [ecx + eax + field_20]              # 004a52aa
    mov ecx, dword ptr [ebp - local_c]           # 004a52ae
    shl ecx, 0x4                                 # 004a52b1
    mov dword ptr [eax + ecx], edx               # 004a52b4
    mov edx, dword ptr [ebp - local_10]          # 004a52b7
    imul edx, edx, 0x60                          # 004a52ba
    mov eax, dword ptr [ebp - local_4]           # 004a52bd
    lea ecx, [eax + edx + field_203]             # 004a52c0
    mov edx, dword ptr [ebp - local_c]           # 004a52c7
    shl edx, 0x4                                 # 004a52ca
    mov eax, dword ptr [ecx + edx + field_8]     # 004a52cd
    add eax, dword ptr [0x583186]                # 004a52d1
    mov ecx, dword ptr [ebp - local_10]          # 004a52d7
    imul ecx, ecx, 0x60                          # 004a52da
    mov edx, dword ptr [ebp - local_18]          # 004a52dd
    lea ecx, [edx + ecx + field_20]              # 004a52e0
    mov edx, dword ptr [ebp - local_c]           # 004a52e4
    shl edx, 0x4                                 # 004a52e7
    mov dword ptr [ecx + edx + field_8], eax     # 004a52ea
    mov eax, dword ptr [ebp - local_10]          # 004a52ee
    imul eax, eax, 0x60                          # 004a52f1
    mov ecx, dword ptr [ebp - local_4]           # 004a52f4
    lea edx, [ecx + eax + field_203]             # 004a52f7
    mov eax, dword ptr [ebp - local_c]           # 004a52fe
    shl eax, 0x4                                 # 004a5301
    mov ecx, dword ptr [edx + eax + field_4]     # 004a5304
    mov edx, dword ptr [ebp - local_4]           # 004a5308
    add ecx, dword ptr [edx + field_3e7]         # 004a530b
    mov eax, dword ptr [ebp - local_10]          # 004a5311
    imul eax, eax, 0x60                          # 004a5314
    mov edx, dword ptr [ebp - local_18]          # 004a5317
    lea eax, [edx + eax + field_290]             # 004a531a
    mov edx, dword ptr [ebp - local_c]           # 004a5321
    shl edx, 0x4                                 # 004a5324
    mov dword ptr [eax + edx + field_4], ecx     # 004a5327
    mov eax, dword ptr [ebp - local_10]          # 004a532b
    imul eax, eax, 0x60                          # 004a532e
    mov ecx, dword ptr [ebp - local_4]           # 004a5331
    lea edx, [ecx + eax + field_203]             # 004a5334
    mov eax, dword ptr [ebp - local_c]           # 004a533b
    shl eax, 0x4                                 # 004a533e
    mov ecx, dword ptr [edx + eax + field_4]     # 004a5341
    mov edx, dword ptr [ebp - local_4]           # 004a5345
    add ecx, dword ptr [edx + field_3ef]         # 004a5348
    mov eax, dword ptr [ebp - local_10]          # 004a534e
    imul eax, eax, 0x60                          # 004a5351
    mov edx, dword ptr [ebp - local_18]          # 004a5354
    lea eax, [edx + eax + field_290]             # 004a5357
    mov edx, dword ptr [ebp - local_c]           # 004a535e
    shl edx, 0x4                                 # 004a5361
    mov dword ptr [eax + edx + field_c], ecx     # 004a5364
    mov eax, dword ptr [ebp - local_10]          # 004a5368
    imul eax, eax, 0x60                          # 004a536b
    mov ecx, dword ptr [ebp - local_4]           # 004a536e
    lea edx, [ecx + eax + field_203]             # 004a5371
    mov eax, dword ptr [ebp - local_c]           # 004a5378
    shl eax, 0x4                                 # 004a537b
    mov ecx, dword ptr [edx + eax]               # 004a537e
    mov edx, dword ptr [ebp - local_4]           # 004a5381
    add ecx, dword ptr [edx + field_3e3]         # 004a5384
    mov eax, dword ptr [ebp - local_10]          # 004a538a
    imul eax, eax, 0x60                          # 004a538d
    mov edx, dword ptr [ebp - local_18]          # 004a5390
    lea eax, [edx + eax + field_290]             # 004a5393
    mov edx, dword ptr [ebp - local_c]           # 004a539a
    shl edx, 0x4                                 # 004a539d
    mov dword ptr [eax + edx], ecx               # 004a53a0
    mov eax, dword ptr [ebp - local_10]          # 004a53a3
    imul eax, eax, 0x60                          # 004a53a6
    mov ecx, dword ptr [ebp - local_4]           # 004a53a9
    lea edx, [ecx + eax + field_203]             # 004a53ac
    mov eax, dword ptr [ebp - local_c]           # 004a53b3
    shl eax, 0x4                                 # 004a53b6
    mov ecx, dword ptr [edx + eax]               # 004a53b9
    mov edx, dword ptr [ebp - local_4]           # 004a53bc
    add ecx, dword ptr [edx + field_3eb]         # 004a53bf
    mov eax, dword ptr [ebp - local_10]          # 004a53c5
    imul eax, eax, 0x60                          # 004a53c8
    mov edx, dword ptr [ebp - local_18]          # 004a53cb
    lea eax, [edx + eax + field_290]             # 004a53ce
    mov edx, dword ptr [ebp - local_c]           # 004a53d5
    shl edx, 0x4                                 # 004a53d8
    mov dword ptr [eax + edx + field_8], ecx     # 004a53db
    mov eax, dword ptr [ebp - local_10]          # 004a53df
    imul eax, eax, 0x60                          # 004a53e2
    mov ecx, dword ptr [ebp - local_4]           # 004a53e5
    lea edx, [ecx + eax + field_203]             # 004a53e8
    mov eax, dword ptr [ebp - local_c]           # 004a53ef
    shl eax, 0x4                                 # 004a53f2
    mov ecx, dword ptr [edx + eax + field_4]     # 004a53f5
    mov edx, dword ptr [ebp - local_4]           # 004a53f9
    add ecx, dword ptr [edx + field_3f7]         # 004a53fc
    mov eax, dword ptr [ebp - local_10]          # 004a5402
    imul eax, eax, 0x60                          # 004a5405
    mov edx, dword ptr [ebp - local_18]          # 004a5408
    lea eax, [edx + eax + field_470]             # 004a540b
    mov edx, dword ptr [ebp - local_c]           # 004a5412
    shl edx, 0x4                                 # 004a5415
    mov dword ptr [eax + edx + field_4], ecx     # 004a5418
    mov eax, dword ptr [ebp - local_10]          # 004a541c
    imul eax, eax, 0x60                          # 004a541f
    mov ecx, dword ptr [ebp - local_4]           # 004a5422
    lea edx, [ecx + eax + field_203]             # 004a5425
    mov eax, dword ptr [ebp - local_c]           # 004a542c
    shl eax, 0x4                                 # 004a542f
    mov ecx, dword ptr [edx + eax + field_4]     # 004a5432
    mov edx, dword ptr [ebp - local_4]           # 004a5436
    add ecx, dword ptr [edx + field_3ff]         # 004a5439
    mov eax, dword ptr [ebp - local_10]          # 004a543f
    imul eax, eax, 0x60                          # 004a5442
    mov edx, dword ptr [ebp - local_18]          # 004a5445
    lea eax, [edx + eax + field_470]             # 004a5448
    mov edx, dword ptr [ebp - local_c]           # 004a544f
    shl edx, 0x4                                 # 004a5452
    mov dword ptr [eax + edx + field_c], ecx     # 004a5455
    mov eax, dword ptr [ebp - local_10]          # 004a5459
    imul eax, eax, 0x60                          # 004a545c
    mov ecx, dword ptr [ebp - local_4]           # 004a545f
    lea edx, [ecx + eax + field_203]             # 004a5462
    mov eax, dword ptr [ebp - local_c]           # 004a5469
    shl eax, 0x4                                 # 004a546c
    mov ecx, dword ptr [edx + eax]               # 004a546f
    mov edx, dword ptr [ebp - local_4]           # 004a5472
    add ecx, dword ptr [edx + field_3f3]         # 004a5475
    mov eax, dword ptr [ebp - local_10]          # 004a547b
    imul eax, eax, 0x60                          # 004a547e
    mov edx, dword ptr [ebp - local_18]          # 004a5481
    lea eax, [edx + eax + field_470]             # 004a5484
    mov edx, dword ptr [ebp - local_c]           # 004a548b
    shl edx, 0x4                                 # 004a548e
    mov dword ptr [eax + edx], ecx               # 004a5491
    mov eax, dword ptr [ebp - local_10]          # 004a5494
    imul eax, eax, 0x60                          # 004a5497
    mov ecx, dword ptr [ebp - local_4]           # 004a549a
    lea edx, [ecx + eax + field_203]             # 004a549d
    mov eax, dword ptr [ebp - local_c]           # 004a54a4
    shl eax, 0x4                                 # 004a54a7
    mov ecx, dword ptr [edx + eax]               # 004a54aa
    mov edx, dword ptr [ebp - local_4]           # 004a54ad
    add ecx, dword ptr [edx + field_3fb]         # 004a54b0
    mov eax, dword ptr [ebp - local_10]          # 004a54b6
    imul eax, eax, 0x60                          # 004a54b9
    mov edx, dword ptr [ebp - local_18]          # 004a54bc
    lea eax, [edx + eax + field_470]             # 004a54bf
    mov edx, dword ptr [ebp - local_c]           # 004a54c6
    shl edx, 0x4                                 # 004a54c9
    mov dword ptr [eax + edx + field_8], ecx     # 004a54cc
    mov eax, dword ptr [ebp - local_10]          # 004a54d0
    imul eax, eax, 0x60                          # 004a54d3
    mov ecx, dword ptr [ebp - local_4]           # 004a54d6
    lea edx, [ecx + eax + field_203]             # 004a54d9
    mov eax, dword ptr [ebp - local_c]           # 004a54e0
    shl eax, 0x4                                 # 004a54e3
    mov ecx, dword ptr [edx + eax + field_4]     # 004a54e6
    mov edx, dword ptr [ebp - local_4]           # 004a54ea
    add ecx, dword ptr [edx + field_407]         # 004a54ed
    mov eax, dword ptr [ebp - local_10]          # 004a54f3
    imul eax, eax, 0x60                          # 004a54f6
    mov edx, dword ptr [ebp - local_18]          # 004a54f9
    lea eax, [edx + eax + field_650]             # 004a54fc
    mov edx, dword ptr [ebp - local_c]           # 004a5503
    shl edx, 0x4                                 # 004a5506
    mov dword ptr [eax + edx + field_4], ecx     # 004a5509
    mov eax, dword ptr [ebp - local_10]          # 004a550d
    imul eax, eax, 0x60                          # 004a5510
    mov ecx, dword ptr [ebp - local_4]           # 004a5513
    lea edx, [ecx + eax + field_203]             # 004a5516
    mov eax, dword ptr [ebp - local_c]           # 004a551d
    shl eax, 0x4                                 # 004a5520
    mov ecx, dword ptr [edx + eax + field_4]     # 004a5523
    mov edx, dword ptr [ebp - local_4]           # 004a5527
    add ecx, dword ptr [edx + field_40f]         # 004a552a
    mov eax, dword ptr [ebp - local_10]          # 004a5530
    imul eax, eax, 0x60                          # 004a5533
    mov edx, dword ptr [ebp - local_18]          # 004a5536
    lea eax, [edx + eax + field_650]             # 004a5539
    mov edx, dword ptr [ebp - local_c]           # 004a5540
    shl edx, 0x4                                 # 004a5543
    mov dword ptr [eax + edx + field_c], ecx     # 004a5546
    mov eax, dword ptr [ebp - local_10]          # 004a554a
    imul eax, eax, 0x60                          # 004a554d
    mov ecx, dword ptr [ebp - local_4]           # 004a5550
    lea edx, [ecx + eax + field_203]             # 004a5553
    mov eax, dword ptr [ebp - local_c]           # 004a555a
    shl eax, 0x4                                 # 004a555d
    mov ecx, dword ptr [edx + eax]               # 004a5560
    mov edx, dword ptr [ebp - local_4]           # 004a5563
    add ecx, dword ptr [edx + field_403]         # 004a5566
    mov eax, dword ptr [ebp - local_10]          # 004a556c
    imul eax, eax, 0x60                          # 004a556f
    mov edx, dword ptr [ebp - local_18]          # 004a5572
    lea eax, [edx + eax + field_650]             # 004a5575
    mov edx, dword ptr [ebp - local_c]           # 004a557c
    shl edx, 0x4                                 # 004a557f
    mov dword ptr [eax + edx], ecx               # 004a5582
    mov eax, dword ptr [ebp - local_10]          # 004a5585
    imul eax, eax, 0x60                          # 004a5588
    mov ecx, dword ptr [ebp - local_4]           # 004a558b
    lea edx, [ecx + eax + field_203]             # 004a558e
    mov eax, dword ptr [ebp - local_c]           # 004a5595
    shl eax, 0x4                                 # 004a5598
    mov ecx, dword ptr [edx + eax]               # 004a559b
    mov edx, dword ptr [ebp - local_4]           # 004a559e
    add ecx, dword ptr [edx + field_40b]         # 004a55a1
    mov eax, dword ptr [ebp - local_10]          # 004a55a7
    imul eax, eax, 0x60                          # 004a55aa
    mov edx, dword ptr [ebp - local_18]          # 004a55ad
    lea eax, [edx + eax + field_650]             # 004a55b0
    mov edx, dword ptr [ebp - local_c]           # 004a55b7
    shl edx, 0x4                                 # 004a55ba
    mov dword ptr [eax + edx + field_8], ecx     # 004a55bd
    jmp.d32 L_004a51fb                           # 004a55c1
L_004a55c6:
    # block 0x004a55c6: entered by jge at 0x004a520e, 1 instruction(s), ends with backward jump to 0x004a51d9
    jmp.d32 L_004a51d9                           # 004a55c6
L_004a55cb:
    # block 0x004a55cb: entered by jge at 0x004a51ec, 5 instruction(s), ends with je to 0x004a5640 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a55cb
    {load} xor ecx, ecx                          # 004a55ce
    mov cl, byte ptr [eax + field_5a8]           # 004a55d0
    test ecx, ecx                                # 004a55d6
    je.d8 L_004a5640                             # 004a55d8
    # block 0x004a55da: entered by fall-through of je at 0x004a55d8, 23 instruction(s), ends with forward jump to 0x004a5698
    mov edx, dword ptr [ebp - local_4]           # 004a55da
    mov eax, dword ptr [ebp - local_4]           # 004a55dd
    mov ecx, dword ptr [edx + field_5b1]         # 004a55e0
    sub ecx, dword ptr [eax + field_5a9]         # 004a55e6
    mov edx, dword ptr [ebp - local_18]          # 004a55ec
    mov word ptr [edx + field_830], cx           # 004a55ef
    mov eax, dword ptr [ebp - local_4]           # 004a55f6
    mov ecx, dword ptr [ebp - local_4]           # 004a55f9
    mov edx, dword ptr [eax + field_5b5]         # 004a55fc
    sub edx, dword ptr [ecx + field_5ad]         # 004a5602
    mov eax, dword ptr [ebp - local_18]          # 004a5608
    mov word ptr [eax + field_832], dx           # 004a560b
    mov ecx, dword ptr [ebp - local_18]          # 004a5612
    movsx edx, word ptr [ecx + field_830]        # 004a5615
    sar edx                                      # 004a561c
    mov eax, dword ptr [ebp - local_18]          # 004a561e
    mov word ptr [eax + field_834], dx           # 004a5621
    mov ecx, dword ptr [ebp - local_18]          # 004a5628
    movsx edx, word ptr [ecx + field_832]        # 004a562b
    sar edx                                      # 004a5632
    mov eax, dword ptr [ebp - local_18]          # 004a5634
    mov word ptr [eax + field_836], dx           # 004a5637
    jmp.d8 L_004a5698                            # 004a563e
L_004a5640:
    # block 0x004a5640: entered by je at 0x004a55d8, 22 instruction(s), falls into the block at 0x004a5698
    mov ecx, dword ptr [ebp - local_4]           # 004a5640
    mov edx, dword ptr [ebp - local_4]           # 004a5643
    mov eax, dword ptr [ecx + field_2b]          # 004a5646
    sub eax, dword ptr [edx + field_23]          # 004a5649
    mov ecx, dword ptr [ebp - local_18]          # 004a564c
    mov word ptr [ecx + field_830], ax           # 004a564f
    mov edx, dword ptr [ebp - local_4]           # 004a5656
    mov eax, dword ptr [ebp - local_4]           # 004a5659
    mov ecx, dword ptr [edx + field_2f]          # 004a565c
    sub ecx, dword ptr [eax + field_27]          # 004a565f
    mov edx, dword ptr [ebp - local_18]          # 004a5662
    mov word ptr [edx + field_832], cx           # 004a5665
    mov eax, dword ptr [ebp - local_18]          # 004a566c
    movsx ecx, word ptr [eax + field_830]        # 004a566f
    sar ecx                                      # 004a5676
    mov edx, dword ptr [ebp - local_18]          # 004a5678
    mov word ptr [edx + field_834], cx           # 004a567b
    mov eax, dword ptr [ebp - local_18]          # 004a5682
    movsx ecx, word ptr [eax + field_832]        # 004a5685
    sar ecx                                      # 004a568c
    mov edx, dword ptr [ebp - local_18]          # 004a568e
    mov word ptr [edx + field_836], cx           # 004a5691
L_004a5698:
    # block 0x004a5698: entered by jmp at 0x004a563e, 2 instruction(s), ends with forward jump to 0x004a56aa
    mov dword ptr [ebp - local_8], 0x0           # 004a5698
    jmp.d8 L_004a56aa                            # 004a569f
L_004a56a1:
    # block 0x004a56a1: entered by jmp at 0x004a56c1, 3 instruction(s), falls into the block at 0x004a56aa
    mov eax, dword ptr [ebp - local_8]           # 004a56a1
    add eax, 0x1                                 # 004a56a4
    mov dword ptr [ebp - local_8], eax           # 004a56a7
L_004a56aa:
    # block 0x004a56aa: entered by jmp at 0x004a569f, 2 instruction(s), ends with jge to 0x004a56c3 (forward)
    cmp dword ptr [ebp - local_8], 0x4           # 004a56aa
    jge.d8 L_004a56c3                            # 004a56ae
    # block 0x004a56b0: entered by fall-through of jge at 0x004a56ae, 4 instruction(s), ends with backward jump to 0x004a56a1
    mov ecx, dword ptr [ebp - local_8]           # 004a56b0
    mov edx, dword ptr [ebp - local_18]          # 004a56b3
    mov dword ptr [edx + 4*ecx + field_200], 0x0 # 004a56b6
    jmp.d8 L_004a56a1                            # 004a56c1
L_004a56c3:
    # block 0x004a56c3: entered by jge at 0x004a56ae, 3 instruction(s), ends with jne to 0x004a56f2 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004a56c3
    cmp dword ptr [eax + field_200], 0x0         # 004a56c6
    jne.d8 L_004a56f2                            # 004a56cd
    # block 0x004a56cf: entered by fall-through of jne at 0x004a56cd, 9 instruction(s), calls FUN_004c2790, falls into the block at 0x004a56f2
    push 0x550594                                # 004a56cf
    push 0x6                                     # 004a56d4
    mov ecx, dword ptr [ebp - local_4]           # 004a56d6
    push ecx                                     # 004a56d9
    push 0x5505bc                                # 004a56da
    mov ecx, 0x5cf659                            # 004a56df
    call FUN_004c2790                            # 004a56e4
    mov edx, dword ptr [ebp - local_18]          # 004a56e9
    mov dword ptr [edx + field_200], eax         # 004a56ec
L_004a56f2:
    # block 0x004a56f2: entered by jne at 0x004a56cd, 4 instruction(s), ends with jne to 0x004a57dd (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a56f2
    movsx ecx, word ptr [eax + field_413]        # 004a56f5
    cmp ecx, 0x1                                 # 004a56fc
    jne.d32 L_004a57dd                           # 004a56ff
    # block 0x004a5705: entered by fall-through of jne at 0x004a56ff, 3 instruction(s), ends with jne to 0x004a57dd (forward)
    mov edx, dword ptr [ebp - local_18]          # 004a5705
    cmp dword ptr [edx + field_204], 0x0         # 004a5708
    jne.d32 L_004a57dd                           # 004a570f
    # block 0x004a5715: entered by fall-through of jne at 0x004a570f, 16 instruction(s), calls FUN_004c2a8d, ends with forward jump to 0x004a575d
    push 0x5505c4                                # 004a5715
    push 0x6                                     # 004a571a
    mov eax, dword ptr [ebp - local_18]          # 004a571c
    mov ecx, dword ptr [eax + field_200]         # 004a571f
    mov dx, word ptr [ecx + field_2d]            # 004a5725
    push edx                                     # 004a5729
    mov eax, dword ptr [ebp - local_18]          # 004a572a
    mov ecx, dword ptr [eax + field_200]         # 004a572d
    mov dx, word ptr [ecx + field_2b]            # 004a5733
    push edx                                     # 004a5737
    mov ecx, 0x5cf659                            # 004a5738
    call FUN_004c2a8d                            # 004a573d
    mov ecx, dword ptr [ebp - local_18]          # 004a5742
    mov dword ptr [ecx + field_204], eax         # 004a5745
    mov dword ptr [ebp - local_10], 0x0          # 004a574b
    jmp.d8 L_004a575d                            # 004a5752
L_004a5754:
    # block 0x004a5754: entered by jmp at 0x004a57d8, 3 instruction(s), falls into the block at 0x004a575d
    mov edx, dword ptr [ebp - local_10]          # 004a5754
    add edx, 0x1                                 # 004a5757
    mov dword ptr [ebp - local_10], edx          # 004a575a
L_004a575d:
    # block 0x004a575d: entered by jmp at 0x004a5752, 4 instruction(s), ends with jge to 0x004a57dd (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a575d
    movsx ecx, byte ptr [eax + field_22]         # 004a5760
    cmp dword ptr [ebp - local_10], ecx          # 004a5764
    jge.d8 L_004a57dd                            # 004a5767
    # block 0x004a5769: entered by fall-through of jge at 0x004a5767, 2 instruction(s), ends with forward jump to 0x004a577b
    mov dword ptr [ebp - local_c], 0x0           # 004a5769
    jmp.d8 L_004a577b                            # 004a5770
L_004a5772:
    # block 0x004a5772: entered by jmp at 0x004a57d6, 3 instruction(s), falls into the block at 0x004a577b
    mov edx, dword ptr [ebp - local_c]           # 004a5772
    add edx, 0x1                                 # 004a5775
    mov dword ptr [ebp - local_c], edx           # 004a5778
L_004a577b:
    # block 0x004a577b: entered by jmp at 0x004a5770, 4 instruction(s), ends with jge to 0x004a57d8 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a577b
    movsx ecx, byte ptr [eax + field_21]         # 004a577e
    cmp dword ptr [ebp - local_c], ecx           # 004a5782
    jge.d8 L_004a57d8                            # 004a5785
    # block 0x004a5787: entered by fall-through of jge at 0x004a5785, 26 instruction(s), calls FUN_004c6c2a, ends with backward jump to 0x004a5772
    push 0x5505ec                                # 004a5787
    mov edx, dword ptr [ebp - local_10]          # 004a578c
    imul edx, edx, 0x60                          # 004a578f
    mov eax, dword ptr [ebp - local_4]           # 004a5792
    lea ecx, [eax + edx + field_23]              # 004a5795
    mov edx, dword ptr [ebp - local_c]           # 004a5799
    shl edx, 0x4                                 # 004a579c
    {load} add ecx, edx                          # 004a579f
    push ecx                                     # 004a57a1
    mov eax, dword ptr [ebp - local_10]          # 004a57a2
    imul eax, eax, 0x60                          # 004a57a5
    mov ecx, dword ptr [ebp - local_4]           # 004a57a8
    lea edx, [ecx + eax + field_23]              # 004a57ab
    mov eax, dword ptr [ebp - local_c]           # 004a57af
    shl eax, 0x4                                 # 004a57b2
    {load} add edx, eax                          # 004a57b5
    push edx                                     # 004a57b7
    mov ecx, dword ptr [ebp - local_18]          # 004a57b8
    mov edx, dword ptr [ecx + field_204]         # 004a57bb
    push edx                                     # 004a57c1
    mov eax, dword ptr [ebp - local_18]          # 004a57c2
    mov ecx, dword ptr [eax + field_200]         # 004a57c5
    push ecx                                     # 004a57cb
    mov ecx, 0x5cf659                            # 004a57cc
    call FUN_004c6c2a                            # 004a57d1
    jmp.d8 L_004a5772                            # 004a57d6
L_004a57d8:
    # block 0x004a57d8: entered by jge at 0x004a5785, 1 instruction(s), ends with backward jump to 0x004a5754
    jmp.d32 L_004a5754                           # 004a57d8
L_004a57dd:
    # block 0x004a57dd: entered by jne at 0x004a56ff; jne at 0x004a570f; jge at 0x004a5767, 4 instruction(s), ends with je to 0x004a57ff (forward)
    mov edx, dword ptr [ebp - local_4]           # 004a57dd
    movsx eax, word ptr [edx + field_413]        # 004a57e0
    cmp eax, 0x2                                 # 004a57e7
    je.d8 L_004a57ff                             # 004a57ea
    # block 0x004a57ec: entered by fall-through of je at 0x004a57ea, 4 instruction(s), ends with jne to 0x004a58d7 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004a57ec
    movsx edx, word ptr [ecx + field_413]        # 004a57ef
    cmp edx, 0x1                                 # 004a57f6
    jne.d32 L_004a58d7                           # 004a57f9
L_004a57ff:
    # block 0x004a57ff: entered by je at 0x004a57ea; fall-through of jne at 0x004a57f9, 3 instruction(s), ends with jne to 0x004a58d7 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004a57ff
    cmp dword ptr [eax + field_208], 0x0         # 004a5802
    jne.d32 L_004a58d7                           # 004a5809
    # block 0x004a580f: entered by fall-through of jne at 0x004a5809, 16 instruction(s), calls FUN_004c2a8d, ends with forward jump to 0x004a5857
    push 0x550620                                # 004a580f
    push 0x6                                     # 004a5814
    mov ecx, dword ptr [ebp - local_18]          # 004a5816
    mov edx, dword ptr [ecx + field_200]         # 004a5819
    mov ax, word ptr [edx + field_2d]            # 004a581f
    push eax                                     # 004a5823
    mov ecx, dword ptr [ebp - local_18]          # 004a5824
    mov edx, dword ptr [ecx + field_200]         # 004a5827
    mov ax, word ptr [edx + field_2b]            # 004a582d
    push eax                                     # 004a5831
    mov ecx, 0x5cf659                            # 004a5832
    call FUN_004c2a8d                            # 004a5837
    mov ecx, dword ptr [ebp - local_18]          # 004a583c
    mov dword ptr [ecx + field_208], eax         # 004a583f
    mov dword ptr [ebp - local_10], 0x0          # 004a5845
    jmp.d8 L_004a5857                            # 004a584c
L_004a584e:
    # block 0x004a584e: entered by jmp at 0x004a58d2, 3 instruction(s), falls into the block at 0x004a5857
    mov edx, dword ptr [ebp - local_10]          # 004a584e
    add edx, 0x1                                 # 004a5851
    mov dword ptr [ebp - local_10], edx          # 004a5854
L_004a5857:
    # block 0x004a5857: entered by jmp at 0x004a584c, 4 instruction(s), ends with jge to 0x004a58d7 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a5857
    movsx ecx, byte ptr [eax + field_22]         # 004a585a
    cmp dword ptr [ebp - local_10], ecx          # 004a585e
    jge.d8 L_004a58d7                            # 004a5861
    # block 0x004a5863: entered by fall-through of jge at 0x004a5861, 2 instruction(s), ends with forward jump to 0x004a5875
    mov dword ptr [ebp - local_c], 0x0           # 004a5863
    jmp.d8 L_004a5875                            # 004a586a
L_004a586c:
    # block 0x004a586c: entered by jmp at 0x004a58d0, 3 instruction(s), falls into the block at 0x004a5875
    mov edx, dword ptr [ebp - local_c]           # 004a586c
    add edx, 0x1                                 # 004a586f
    mov dword ptr [ebp - local_c], edx           # 004a5872
L_004a5875:
    # block 0x004a5875: entered by jmp at 0x004a586a, 4 instruction(s), ends with jge to 0x004a58d2 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a5875
    movsx ecx, byte ptr [eax + field_21]         # 004a5878
    cmp dword ptr [ebp - local_c], ecx           # 004a587c
    jge.d8 L_004a58d2                            # 004a587f
    # block 0x004a5881: entered by fall-through of jge at 0x004a587f, 26 instruction(s), calls FUN_004c6e4d, ends with backward jump to 0x004a586c
    push 0x550648                                # 004a5881
    mov edx, dword ptr [ebp - local_10]          # 004a5886
    imul edx, edx, 0x60                          # 004a5889
    mov eax, dword ptr [ebp - local_4]           # 004a588c
    lea ecx, [eax + edx + field_23]              # 004a588f
    mov edx, dword ptr [ebp - local_c]           # 004a5893
    shl edx, 0x4                                 # 004a5896
    {load} add ecx, edx                          # 004a5899
    push ecx                                     # 004a589b
    mov eax, dword ptr [ebp - local_10]          # 004a589c
    imul eax, eax, 0x60                          # 004a589f
    mov ecx, dword ptr [ebp - local_4]           # 004a58a2
    lea edx, [ecx + eax + field_23]              # 004a58a5
    mov eax, dword ptr [ebp - local_c]           # 004a58a9
    shl eax, 0x4                                 # 004a58ac
    {load} add edx, eax                          # 004a58af
    push edx                                     # 004a58b1
    mov ecx, dword ptr [ebp - local_18]          # 004a58b2
    mov edx, dword ptr [ecx + field_208]         # 004a58b5
    push edx                                     # 004a58bb
    mov eax, dword ptr [ebp - local_18]          # 004a58bc
    mov ecx, dword ptr [eax + field_200]         # 004a58bf
    push ecx                                     # 004a58c5
    mov ecx, 0x5cf659                            # 004a58c6
    call FUN_004c6e4d                            # 004a58cb
    jmp.d8 L_004a586c                            # 004a58d0
L_004a58d2:
    # block 0x004a58d2: entered by jge at 0x004a587f, 1 instruction(s), ends with backward jump to 0x004a584e
    jmp.d32 L_004a584e                           # 004a58d2
L_004a58d7:
    # block 0x004a58d7: entered by jne at 0x004a57f9; jne at 0x004a5809; jge at 0x004a5861, 4 instruction(s), ends with jne to 0x004a59c2 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004a58d7
    movsx eax, word ptr [edx + field_413]        # 004a58da
    cmp eax, 0x1                                 # 004a58e1
    jne.d32 L_004a59c2                           # 004a58e4
    # block 0x004a58ea: entered by fall-through of jne at 0x004a58e4, 3 instruction(s), ends with jne to 0x004a59c2 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004a58ea
    cmp dword ptr [ecx + field_20c], 0x0         # 004a58ed
    jne.d32 L_004a59c2                           # 004a58f4
    # block 0x004a58fa: entered by fall-through of jne at 0x004a58f4, 16 instruction(s), calls FUN_004c2a8d, ends with forward jump to 0x004a5942
    push 0x550680                                # 004a58fa
    push 0x6                                     # 004a58ff
    mov edx, dword ptr [ebp - local_18]          # 004a5901
    mov eax, dword ptr [edx + field_200]         # 004a5904
    mov cx, word ptr [eax + field_2d]            # 004a590a
    push ecx                                     # 004a590e
    mov edx, dword ptr [ebp - local_18]          # 004a590f
    mov eax, dword ptr [edx + field_200]         # 004a5912
    mov cx, word ptr [eax + field_2b]            # 004a5918
    push ecx                                     # 004a591c
    mov ecx, 0x5cf659                            # 004a591d
    call FUN_004c2a8d                            # 004a5922
    mov edx, dword ptr [ebp - local_18]          # 004a5927
    mov dword ptr [edx + field_20c], eax         # 004a592a
    mov dword ptr [ebp - local_10], 0x0          # 004a5930
    jmp.d8 L_004a5942                            # 004a5937
L_004a5939:
    # block 0x004a5939: entered by jmp at 0x004a59bd, 3 instruction(s), falls into the block at 0x004a5942
    mov eax, dword ptr [ebp - local_10]          # 004a5939
    add eax, 0x1                                 # 004a593c
    mov dword ptr [ebp - local_10], eax          # 004a593f
L_004a5942:
    # block 0x004a5942: entered by jmp at 0x004a5937, 4 instruction(s), ends with jge to 0x004a59c2 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004a5942
    movsx edx, byte ptr [ecx + field_22]         # 004a5945
    cmp dword ptr [ebp - local_10], edx          # 004a5949
    jge.d8 L_004a59c2                            # 004a594c
    # block 0x004a594e: entered by fall-through of jge at 0x004a594c, 2 instruction(s), ends with forward jump to 0x004a5960
    mov dword ptr [ebp - local_c], 0x0           # 004a594e
    jmp.d8 L_004a5960                            # 004a5955
L_004a5957:
    # block 0x004a5957: entered by jmp at 0x004a59bb, 3 instruction(s), falls into the block at 0x004a5960
    mov eax, dword ptr [ebp - local_c]           # 004a5957
    add eax, 0x1                                 # 004a595a
    mov dword ptr [ebp - local_c], eax           # 004a595d
L_004a5960:
    # block 0x004a5960: entered by jmp at 0x004a5955, 4 instruction(s), ends with jge to 0x004a59bd (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004a5960
    movsx edx, byte ptr [ecx + field_21]         # 004a5963
    cmp dword ptr [ebp - local_c], edx           # 004a5967
    jge.d8 L_004a59bd                            # 004a596a
    # block 0x004a596c: entered by fall-through of jge at 0x004a596a, 26 instruction(s), calls FUN_004c6c2a, ends with backward jump to 0x004a5957
    push 0x5506a8                                # 004a596c
    mov eax, dword ptr [ebp - local_10]          # 004a5971
    imul eax, eax, 0x60                          # 004a5974
    mov ecx, dword ptr [ebp - local_4]           # 004a5977
    lea edx, [ecx + eax + field_23]              # 004a597a
    mov eax, dword ptr [ebp - local_c]           # 004a597e
    shl eax, 0x4                                 # 004a5981
    {load} add edx, eax                          # 004a5984
    push edx                                     # 004a5986
    mov ecx, dword ptr [ebp - local_10]          # 004a5987
    imul ecx, ecx, 0x60                          # 004a598a
    mov edx, dword ptr [ebp - local_4]           # 004a598d
    lea eax, [edx + ecx + field_23]              # 004a5990
    mov ecx, dword ptr [ebp - local_c]           # 004a5994
    shl ecx, 0x4                                 # 004a5997
    {load} add eax, ecx                          # 004a599a
    push eax                                     # 004a599c
    mov edx, dword ptr [ebp - local_18]          # 004a599d
    mov eax, dword ptr [edx + field_20c]         # 004a59a0
    push eax                                     # 004a59a6
    mov ecx, dword ptr [ebp - local_18]          # 004a59a7
    mov edx, dword ptr [ecx + field_208]         # 004a59aa
    push edx                                     # 004a59b0
    mov ecx, 0x5cf659                            # 004a59b1
    call FUN_004c6c2a                            # 004a59b6
    jmp.d8 L_004a5957                            # 004a59bb
L_004a59bd:
    # block 0x004a59bd: entered by jge at 0x004a596a, 1 instruction(s), ends with backward jump to 0x004a5939
    jmp.d32 L_004a5939                           # 004a59bd
L_004a59c2:
    # block 0x004a59c2: entered by jne at 0x004a58e4; jne at 0x004a58f4; jge at 0x004a594c, 61 instruction(s), calls FUN_004d39f9, ends with je to 0x004a5acd (forward)
    call FUN_004d39f9                            # 004a59c2
    mov ecx, dword ptr [ebp - local_18]          # 004a59c7
    mov word ptr [ecx + field_1c], ax            # 004a59ca
    mov edx, dword ptr [ebp - local_18]          # 004a59ce
    movsx eax, word ptr [edx + field_1c]         # 004a59d1
    imul eax, eax, 0x4a                          # 004a59d5
    mov dword ptr [eax + 0x5d1591], 0xa          # 004a59d8
    mov ecx, dword ptr [ebp - local_18]          # 004a59e2
    movsx edx, word ptr [ecx + field_1c]         # 004a59e5
    imul edx, edx, 0x4a                          # 004a59e9
    mov dword ptr [edx + 0x5d1595], 0x4a5eea     # 004a59ec
    mov eax, dword ptr [ebp - local_18]          # 004a59f6
    movsx ecx, word ptr [eax + field_1c]         # 004a59f9
    imul ecx, ecx, 0x4a                          # 004a59fd
    mov dword ptr [ecx + 0x5d1599], 0x0          # 004a5a00
    mov edx, dword ptr [ebp - local_18]          # 004a5a0a
    movsx eax, word ptr [edx + field_1c]         # 004a5a0d
    imul eax, eax, 0x4a                          # 004a5a11
    mov dword ptr [eax + 0x5d159d], 0x0          # 004a5a14
    mov ecx, dword ptr [ebp - local_18]          # 004a5a1e
    movsx edx, word ptr [ecx + field_1c]         # 004a5a21
    imul edx, edx, 0x4a                          # 004a5a25
    mov dword ptr [edx + 0x5d15a1], 0x0          # 004a5a28
    mov eax, dword ptr [ebp - local_18]          # 004a5a32
    movsx ecx, word ptr [eax + field_1c]         # 004a5a35
    imul ecx, ecx, 0x4a                          # 004a5a39
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 004a5a3c
    mov edx, dword ptr [ebp - local_18]          # 004a5a46
    movsx eax, word ptr [edx + field_1c]         # 004a5a49
    imul eax, eax, 0x4a                          # 004a5a4d
    mov dword ptr [eax + 0x5d15a9], 0x1          # 004a5a50
    mov ecx, dword ptr [ebp - local_18]          # 004a5a5a
    movsx edx, word ptr [ecx + field_1c]         # 004a5a5d
    imul edx, edx, 0x4a                          # 004a5a61
    mov word ptr [edx + 0x5d15ad], 0x0           # 004a5a64
    mov edi, 0x5506e0                            # 004a5a6d
    mov eax, dword ptr [ebp - local_18]          # 004a5a72
    movsx ecx, word ptr [eax + field_1c]         # 004a5a75
    imul ecx, ecx, 0x4a                          # 004a5a79
    add ecx, 0x5d15b3                            # 004a5a7c
    {load} mov edx, ecx                          # 004a5a82
    or ecx, -0x1                                 # 004a5a84
    {load} xor eax, eax                          # 004a5a87
    repne scasb al, byte ptr es:[edi]            # 004a5a89
    not ecx                                      # 004a5a8b
    {load} sub edi, ecx                          # 004a5a8d
    {load} mov esi, edi                          # 004a5a8f
    {load} mov eax, ecx                          # 004a5a91
    {load} mov edi, edx                          # 004a5a93
    shr ecx, 0x2                                 # 004a5a95
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004a5a98
    {load} mov ecx, eax                          # 004a5a9a
    and ecx, 0x3                                 # 004a5a9c
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004a5a9f
    mov edi, 0x5506fc                            # 004a5aa1
    mov esi, dword ptr [ebp - local_4]           # 004a5aa6
    add esi, 0x5b9                               # 004a5aa9
    mov ecx, 0x9                                 # 004a5aaf
    {load} xor edx, edx                          # 004a5ab4
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a5ab6
    je.d8 L_004a5acd                             # 004a5ab8
    # block 0x004a5aba: entered by fall-through of je at 0x004a5ab8, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004a5acd
    mov eax, dword ptr [ebp - local_4]           # 004a5aba
    add eax, 0x5b9                               # 004a5abd
    push eax                                     # 004a5ac2
    mov ecx, 0x5c3a67                            # 004a5ac3
    call FUN_004fb77a                            # 004a5ac8
L_004a5acd:
    # block 0x004a5acd: entered by je at 0x004a5ab8, 7 instruction(s), ends with je to 0x004a5af9 (forward)
    mov edi, 0x550708                            # 004a5acd
    mov esi, dword ptr [ebp - local_4]           # 004a5ad2
    add esi, 0x5ea                               # 004a5ad5
    mov ecx, 0x9                                 # 004a5adb
    {load} xor edx, edx                          # 004a5ae0
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a5ae2
    je.d8 L_004a5af9                             # 004a5ae4
    # block 0x004a5ae6: entered by fall-through of je at 0x004a5ae4, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004a5af9
    mov eax, dword ptr [ebp - local_4]           # 004a5ae6
    add eax, 0x5ea                               # 004a5ae9
    push eax                                     # 004a5aee
    mov ecx, 0x5c3a67                            # 004a5aef
    call FUN_004fb77a                            # 004a5af4
L_004a5af9:
    # block 0x004a5af9: entered by je at 0x004a5ae4, 7 instruction(s), ends with je to 0x004a5b25 (forward)
    mov edi, 0x550714                            # 004a5af9
    mov esi, dword ptr [ebp - local_4]           # 004a5afe
    add esi, 0x61b                               # 004a5b01
    mov ecx, 0x9                                 # 004a5b07
    {load} xor edx, edx                          # 004a5b0c
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a5b0e
    je.d8 L_004a5b25                             # 004a5b10
    # block 0x004a5b12: entered by fall-through of je at 0x004a5b10, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004a5b25
    mov eax, dword ptr [ebp - local_4]           # 004a5b12
    add eax, 0x61b                               # 004a5b15
    push eax                                     # 004a5b1a
    mov ecx, 0x5c3a67                            # 004a5b1b
    call FUN_004fb77a                            # 004a5b20
L_004a5b25:
    # block 0x004a5b25: entered by je at 0x004a5b10, 13 instruction(s), calls FUN_004a39c4, ends with forward jump to 0x004a5ed2
    mov ecx, dword ptr [ebp - local_18]          # 004a5b25
    call FUN_004a39c4                            # 004a5b28
    mov ecx, dword ptr [ebp - local_18]          # 004a5b2d
    mov byte ptr [ecx + field_27f], 0x0          # 004a5b30
    mov edx, dword ptr [ebp - local_18]          # 004a5b37
    mov byte ptr [edx + field_27a], 0x0          # 004a5b3a
    mov eax, dword ptr [ebp - local_18]          # 004a5b41
    mov dword ptr [eax + field_27b], 0x0         # 004a5b44
    mov ecx, dword ptr [ebp - local_18]          # 004a5b4e
    movsx edx, word ptr [ecx + field_1e]         # 004a5b51
    imul edx, edx, 0x8d                          # 004a5b55
    mov dword ptr [edx + 0x5bb632], 0x1          # 004a5b5b
    jmp.d32 L_004a5ed2                           # 004a5b65
L_004a5b6a:
    # block 0x004a5b6a: entered by je at 0x004a4f93, 5 instruction(s), ends with je to 0x004a5bf0 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004a5b6a
    mov ecx, dword ptr [eax + field_27b]         # 004a5b6d
    mov dword ptr [ebp - local_20], ecx          # 004a5b73
    cmp dword ptr [ebp - local_20], 0x1          # 004a5b76
    je.d8 L_004a5bf0                             # 004a5b7a
    # block 0x004a5b7c: entered by fall-through of je at 0x004a5b7a, 2 instruction(s), ends with je to 0x004a5b87 (forward)
    cmp dword ptr [ebp - local_20], 0x2          # 004a5b7c
    je.d8 L_004a5b87                             # 004a5b80
    # block 0x004a5b82: entered by fall-through of je at 0x004a5b80, 1 instruction(s), ends with forward jump to 0x004a5c39
    jmp.d32 L_004a5c39                           # 004a5b82
L_004a5b87:
    # block 0x004a5b87: entered by je at 0x004a5b80, 7 instruction(s), ends with je to 0x004a5bd7 (forward)
    mov edi, 0x550720                            # 004a5b87
    mov esi, dword ptr [ebp - local_4]           # 004a5b8c
    add esi, 0x665                               # 004a5b8f
    mov ecx, 0x9                                 # 004a5b95
    {load} xor edx, edx                          # 004a5b9a
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a5b9c
    je.d8 L_004a5bd7                             # 004a5b9e
    # block 0x004a5ba0: entered by fall-through of je at 0x004a5b9e, 13 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x004a5bee
    mov eax, dword ptr [ebp - local_4]           # 004a5ba0
    add eax, 0x665                               # 004a5ba3
    push eax                                     # 004a5ba8
    mov ecx, 0x5c3a67                            # 004a5ba9
    call FUN_004fb77a                            # 004a5bae
    mov ecx, dword ptr [ebp - local_4]           # 004a5bb3
    mov dx, word ptr [ecx + field_686]           # 004a5bb6
    push edx                                     # 004a5bbd
    mov ecx, 0x5c3a67                            # 004a5bbe
    call FUN_004fb2e3                            # 004a5bc3
    mov eax, dword ptr [ebp - local_18]          # 004a5bc8
    mov dword ptr [eax + field_27b], 0x1         # 004a5bcb
    jmp.d8 L_004a5bee                            # 004a5bd5
L_004a5bd7:
    # block 0x004a5bd7: entered by je at 0x004a5b9e, 4 instruction(s), falls into the block at 0x004a5bee
    mov ecx, dword ptr [ebp - local_18]          # 004a5bd7
    movsx edx, word ptr [ecx + field_1e]         # 004a5bda
    imul edx, edx, 0x8d                          # 004a5bde
    mov dword ptr [edx + 0x5bb632], 0x2          # 004a5be4
L_004a5bee:
    # block 0x004a5bee: entered by jmp at 0x004a5bd5, 1 instruction(s), ends with forward jump to 0x004a5c39
    jmp.d8 L_004a5c39                            # 004a5bee
L_004a5bf0:
    # block 0x004a5bf0: entered by je at 0x004a5b7a, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004a5c39 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a5bf0
    movsx ecx, word ptr [eax + field_686]        # 004a5bf3
    mov dword ptr [ebp - local_14], ecx          # 004a5bfa
    mov edx, dword ptr [ebp - local_14]          # 004a5bfd
    push edx                                     # 004a5c00
    mov ecx, 0x5cf1eb                            # 004a5c01
    call FUN_004f6334                            # 004a5c06
    test eax, eax                                # 004a5c0b
    jne.d8 L_004a5c39                            # 004a5c0d
    # block 0x004a5c0f: entered by fall-through of jne at 0x004a5c0d, 9 instruction(s), calls FUN_004fba69, falls into the block at 0x004a5c39
    mov eax, dword ptr [ebp - local_4]           # 004a5c0f
    add eax, 0x665                               # 004a5c12
    push eax                                     # 004a5c17
    mov ecx, 0x5c3a67                            # 004a5c18
    call FUN_004fba69                            # 004a5c1d
    mov ecx, dword ptr [ebp - local_18]          # 004a5c22
    movsx edx, word ptr [ecx + field_1e]         # 004a5c25
    imul edx, edx, 0x8d                          # 004a5c29
    mov dword ptr [edx + 0x5bb632], 0x2          # 004a5c2f
L_004a5c39:
    # block 0x004a5c39: entered by jmp at 0x004a5b82; jmp at 0x004a5bee; jne at 0x004a5c0d, 1 instruction(s), ends with forward jump to 0x004a5ed2
    jmp.d32 L_004a5ed2                           # 004a5c39
L_004a5c3e:
    # block 0x004a5c3e: entered by je at 0x004a4f9d, 8 instruction(s), ends with je to 0x004a5c75 (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 004a5c3e
    mov edi, 0x55072c                            # 004a5c48
    mov esi, dword ptr [ebp - local_4]           # 004a5c4d
    add esi, 0x5b9                               # 004a5c50
    mov ecx, 0x9                                 # 004a5c56
    {load} xor eax, eax                          # 004a5c5b
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a5c5d
    je.d8 L_004a5c75                             # 004a5c5f
    # block 0x004a5c61: entered by fall-through of je at 0x004a5c5f, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004a5c75
    mov ecx, dword ptr [ebp - local_4]           # 004a5c61
    add ecx, 0x5b9                               # 004a5c64
    push ecx                                     # 004a5c6a
    mov ecx, 0x5c3a67                            # 004a5c6b
    call FUN_004fba69                            # 004a5c70
L_004a5c75:
    # block 0x004a5c75: entered by je at 0x004a5c5f, 7 instruction(s), ends with je to 0x004a5ca1 (forward)
    mov edi, 0x550738                            # 004a5c75
    mov esi, dword ptr [ebp - local_4]           # 004a5c7a
    add esi, 0x5ea                               # 004a5c7d
    mov ecx, 0x9                                 # 004a5c83
    {load} xor edx, edx                          # 004a5c88
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a5c8a
    je.d8 L_004a5ca1                             # 004a5c8c
    # block 0x004a5c8e: entered by fall-through of je at 0x004a5c8c, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004a5ca1
    mov eax, dword ptr [ebp - local_4]           # 004a5c8e
    add eax, 0x5ea                               # 004a5c91
    push eax                                     # 004a5c96
    mov ecx, 0x5c3a67                            # 004a5c97
    call FUN_004fba69                            # 004a5c9c
L_004a5ca1:
    # block 0x004a5ca1: entered by je at 0x004a5c8c, 7 instruction(s), ends with je to 0x004a5ccd (forward)
    mov edi, 0x550744                            # 004a5ca1
    mov esi, dword ptr [ebp - local_4]           # 004a5ca6
    add esi, 0x61b                               # 004a5ca9
    mov ecx, 0x9                                 # 004a5caf
    {load} xor edx, edx                          # 004a5cb4
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a5cb6
    je.d8 L_004a5ccd                             # 004a5cb8
    # block 0x004a5cba: entered by fall-through of je at 0x004a5cb8, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004a5ccd
    mov eax, dword ptr [ebp - local_4]           # 004a5cba
    add eax, 0x61b                               # 004a5cbd
    push eax                                     # 004a5cc2
    mov ecx, 0x5c3a67                            # 004a5cc3
    call FUN_004fba69                            # 004a5cc8
L_004a5ccd:
    # block 0x004a5ccd: entered by je at 0x004a5cb8, 5 instruction(s), ends with je to 0x004a5dc2 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004a5ccd
    {load} xor edx, edx                          # 004a5cd0
    mov dl, byte ptr [ecx + field_27a]           # 004a5cd2
    test edx, edx                                # 004a5cd8
    je.d32 L_004a5dc2                            # 004a5cda
    # block 0x004a5ce0: entered by fall-through of je at 0x004a5cda, 4 instruction(s), ends with je to 0x004a5d92 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a5ce0
    movsx ecx, word ptr [eax + field_696]        # 004a5ce3
    cmp ecx, 0x270f                              # 004a5cea
    je.d32 L_004a5d92                            # 004a5cf0
    # block 0x004a5cf6: entered by fall-through of je at 0x004a5cf0, 25 instruction(s), ends with jne to 0x004a5d7e (forward)
    mov edx, dword ptr [ebp - local_4]           # 004a5cf6
    movsx eax, word ptr [edx + field_696]        # 004a5cf9
    mov dword ptr [0x5bb57b], eax                # 004a5d00
    mov ecx, dword ptr [ebp - local_4]           # 004a5d05
    mov dx, word ptr [ecx + field_698]           # 004a5d08
    mov word ptr [0x5bb599], dx                  # 004a5d0f
    mov eax, dword ptr [ebp - local_4]           # 004a5d16
    mov cx, word ptr [eax + field_69a]           # 004a5d19
    mov word ptr [0x5bb595], cx                  # 004a5d20
    mov edx, dword ptr [ebp - local_4]           # 004a5d27
    mov ax, word ptr [edx + field_69c]           # 004a5d2a
    mov word ptr [0x5c39ff], ax                  # 004a5d31
    mov ecx, dword ptr [ebp - local_4]           # 004a5d37
    mov edx, dword ptr [ecx + field_69e]         # 004a5d3a
    mov dword ptr [0x5bb59b], edx                # 004a5d40
    mov eax, dword ptr [ebp - local_4]           # 004a5d46
    mov ecx, dword ptr [eax + field_6a2]         # 004a5d49
    mov dword ptr [0x5bb59f], ecx                # 004a5d4f
    mov edx, dword ptr [ebp - local_4]           # 004a5d55
    mov eax, dword ptr [edx + field_6a6]         # 004a5d58
    mov dword ptr [0x5bb5a3], eax                # 004a5d5e
    mov ecx, dword ptr [ebp - local_4]           # 004a5d63
    movsx edx, word ptr [ecx + field_6aa]        # 004a5d66
    cmp edx, 0x1                                 # 004a5d6d
    jne.d8 L_004a5d7e                            # 004a5d70
    # block 0x004a5d72: entered by fall-through of jne at 0x004a5d70, 2 instruction(s), ends with forward jump to 0x004a5d88
    mov dword ptr [0x5bb1ca], 0x0                # 004a5d72
    jmp.d8 L_004a5d88                            # 004a5d7c
L_004a5d7e:
    # block 0x004a5d7e: entered by jne at 0x004a5d70, 1 instruction(s), falls into the block at 0x004a5d88
    mov dword ptr [0x5bb1ca], 0x1                # 004a5d7e
L_004a5d88:
    # block 0x004a5d88: entered by jmp at 0x004a5d7c, 1 instruction(s), falls into the block at 0x004a5d92
    mov dword ptr [0x583999], 0x4                # 004a5d88
L_004a5d92:
    # block 0x004a5d92: entered by je at 0x004a5cf0, 4 instruction(s), ends with je to 0x004a5dbd (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a5d92
    movsx ecx, word ptr [eax + field_6ac]        # 004a5d95
    cmp ecx, -0x1                                # 004a5d9c
    je.d8 L_004a5dbd                             # 004a5d9f
    # block 0x004a5da1: entered by fall-through of je at 0x004a5d9f, 6 instruction(s), falls into the block at 0x004a5dbd
    mov edx, dword ptr [ebp - local_4]           # 004a5da1
    {load} xor eax, eax                          # 004a5da4
    mov al, byte ptr [edx + field_6ae]           # 004a5da6
    mov ecx, dword ptr [ebp - local_4]           # 004a5dac
    movsx edx, word ptr [ecx + field_6ac]        # 004a5daf
    mov dword ptr [4*edx + 0x585801], eax        # 004a5db6
L_004a5dbd:
    # block 0x004a5dbd: entered by je at 0x004a5d9f, 1 instruction(s), ends with forward jump to 0x004a5eba
    jmp.d32 L_004a5eba                           # 004a5dbd
L_004a5dc2:
    # block 0x004a5dc2: entered by je at 0x004a5cda, 5 instruction(s), ends with je to 0x004a5eba (forward)
    mov eax, dword ptr [ebp - local_18]          # 004a5dc2
    {load} xor ecx, ecx                          # 004a5dc5
    mov cl, byte ptr [eax + field_27f]           # 004a5dc7
    test ecx, ecx                                # 004a5dcd
    je.d32 L_004a5eba                            # 004a5dcf
    # block 0x004a5dd5: entered by fall-through of je at 0x004a5dcf, 6 instruction(s), calls FUN_004a3947, ends with je to 0x004a5e8f (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004a5dd5
    call FUN_004a3947                            # 004a5dd8
    mov edx, dword ptr [ebp - local_4]           # 004a5ddd
    movsx eax, word ptr [edx + field_64c]        # 004a5de0
    cmp eax, 0x270f                              # 004a5de7
    je.d32 L_004a5e8f                            # 004a5dec
    # block 0x004a5df2: entered by fall-through of je at 0x004a5dec, 25 instruction(s), ends with jne to 0x004a5e7b (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004a5df2
    movsx edx, word ptr [ecx + field_64c]        # 004a5df5
    mov dword ptr [0x5bb57b], edx                # 004a5dfc
    mov eax, dword ptr [ebp - local_4]           # 004a5e02
    mov cx, word ptr [eax + field_64e]           # 004a5e05
    mov word ptr [0x5bb599], cx                  # 004a5e0c
    mov edx, dword ptr [ebp - local_4]           # 004a5e13
    mov ax, word ptr [edx + field_650]           # 004a5e16
    mov word ptr [0x5bb595], ax                  # 004a5e1d
    mov ecx, dword ptr [ebp - local_4]           # 004a5e23
    mov dx, word ptr [ecx + field_652]           # 004a5e26
    mov word ptr [0x5c39ff], dx                  # 004a5e2d
    mov eax, dword ptr [ebp - local_4]           # 004a5e34
    mov ecx, dword ptr [eax + field_654]         # 004a5e37
    mov dword ptr [0x5bb59b], ecx                # 004a5e3d
    mov edx, dword ptr [ebp - local_4]           # 004a5e43
    mov eax, dword ptr [edx + field_658]         # 004a5e46
    mov dword ptr [0x5bb59f], eax                # 004a5e4c
    mov ecx, dword ptr [ebp - local_4]           # 004a5e51
    mov edx, dword ptr [ecx + field_65c]         # 004a5e54
    mov dword ptr [0x5bb5a3], edx                # 004a5e5a
    mov eax, dword ptr [ebp - local_4]           # 004a5e60
    movsx ecx, word ptr [eax + field_660]        # 004a5e63
    cmp ecx, 0x1                                 # 004a5e6a
    jne.d8 L_004a5e7b                            # 004a5e6d
    # block 0x004a5e6f: entered by fall-through of jne at 0x004a5e6d, 2 instruction(s), ends with forward jump to 0x004a5e85
    mov dword ptr [0x5bb1ca], 0x0                # 004a5e6f
    jmp.d8 L_004a5e85                            # 004a5e79
L_004a5e7b:
    # block 0x004a5e7b: entered by jne at 0x004a5e6d, 1 instruction(s), falls into the block at 0x004a5e85
    mov dword ptr [0x5bb1ca], 0x1                # 004a5e7b
L_004a5e85:
    # block 0x004a5e85: entered by jmp at 0x004a5e79, 1 instruction(s), falls into the block at 0x004a5e8f
    mov dword ptr [0x583999], 0x4                # 004a5e85
L_004a5e8f:
    # block 0x004a5e8f: entered by je at 0x004a5dec, 4 instruction(s), ends with je to 0x004a5eba (forward)
    mov edx, dword ptr [ebp - local_4]           # 004a5e8f
    movsx eax, word ptr [edx + field_662]        # 004a5e92
    cmp eax, -0x1                                # 004a5e99
    je.d8 L_004a5eba                             # 004a5e9c
    # block 0x004a5e9e: entered by fall-through of je at 0x004a5e9c, 6 instruction(s), falls into the block at 0x004a5eba
    mov ecx, dword ptr [ebp - local_4]           # 004a5e9e
    {load} xor edx, edx                          # 004a5ea1
    mov dl, byte ptr [ecx + field_664]           # 004a5ea3
    mov eax, dword ptr [ebp - local_4]           # 004a5ea9
    movsx ecx, word ptr [eax + field_662]        # 004a5eac
    mov dword ptr [4*ecx + 0x585801], edx        # 004a5eb3
L_004a5eba:
    # block 0x004a5eba: entered by jmp at 0x004a5dbd; je at 0x004a5dcf; je at 0x004a5e9c, 7 instruction(s), calls FUN_0042ba3a, FUN_004a3884, falls into the block at 0x004a5ed2
    mov edx, dword ptr [ebp - local_18]          # 004a5eba
    mov ax, word ptr [edx + field_1e]            # 004a5ebd
    push eax                                     # 004a5ec1
    call FUN_0042ba3a                            # 004a5ec2
    add esp, 0x4                                 # 004a5ec7
    mov ecx, dword ptr [ebp - local_18]          # 004a5eca
    call FUN_004a3884                            # 004a5ecd
L_004a5ed2:
    # block 0x004a5ed2: entered by jmp at 0x004a4fa3; jmp at 0x004a5b65; jmp at 0x004a5c39, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004a5ed2
    pop esi                                      # 004a5ed3
    {load} mov esp, ebp                          # 004a5ed4
    pop ebp                                      # 004a5ed6
    ret 0x4                                      # 004a5ed7

