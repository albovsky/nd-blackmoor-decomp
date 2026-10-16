# FUN_0047608e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047608e
# extent:       0x0047608e-0x004763b3 (805 code bytes)
# span:         0x0047608e-0x004763b3 (code 805, tables 0, padding 0)
# sha256:       b7b2df6e8bd1bdada24cc514a1c0733c88b54d6376fed12fd44863a34b3b7781
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047608e
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_2, field_22, field_73c, field_76d, field_898, field_89a, field_89e, field_8a6, field_8b6, field_8ba, field_8be, field_8d8 and 1 more; [ecx + n] field_2, field_1c, field_22, field_2c, field_30, field_8aa, field_8ba; [edx + n] field_2, field_2c, field_30, field_8a6, field_8aa, field_8ae, field_8b2, field_8b6, field_8ca, field_8d8, field_8d9; [esi + n] field_30, field_8a6
# callees:      calls FUN_004f6334, FUN_004fb2e3, KERNEL32.dll!GetTickCount
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 191 instruction(s), 16 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ field_2, 0x2  # offset +0x2
.equ field_1c, 0x1c  # offset +0x1c
.equ field_22, 0x22  # offset +0x22
.equ field_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30
.equ field_73c, 0x73c  # offset +0x73c
.equ field_76d, 0x76d  # offset +0x76d
.equ field_898, 0x898  # offset +0x898
.equ field_89a, 0x89a  # offset +0x89a
.equ field_89e, 0x89e  # offset +0x89e
.equ field_8a6, 0x8a6  # offset +0x8a6
.equ field_8aa, 0x8aa  # offset +0x8aa
.equ field_8ae, 0x8ae  # offset +0x8ae
.equ field_8b2, 0x8b2  # offset +0x8b2
.equ field_8b6, 0x8b6  # offset +0x8b6
.equ field_8ba, 0x8ba  # offset +0x8ba
.equ field_8be, 0x8be  # offset +0x8be
.equ field_8ca, 0x8ca  # offset +0x8ca
.equ field_8d8, 0x8d8  # offset +0x8d8
.equ field_8d9, 0x8d9  # offset +0x8d9

# --- external targets -----------------------------------------------
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x0047608e - 0x401000
.globl FUN_0047608e
FUN_0047608e:
    # block 0x0047608e: entry, 14 instruction(s), ends with je to 0x004763ad (forward)
    push ebp                                     # 0047608e
    {load} mov ebp, esp                          # 0047608f
    sub esp, 0x18                                # 00476091
    push esi                                     # 00476094
    push edi                                     # 00476095
    mov dword ptr [ebp - local_18], ecx          # 00476096
    mov eax, dword ptr [ebp - local_18]          # 00476099
    movsx ecx, word ptr [eax + field_22]         # 0047609c
    imul ecx, ecx, 0x8d                          # 004760a0
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004760a6
    mov dword ptr [ebp - local_4], edx           # 004760ac
    mov eax, dword ptr [ebp - local_18]          # 004760af
    cmp dword ptr [eax + field_89a], 0x0         # 004760b2
    je.d32 L_004763ad                            # 004760b9
    # block 0x004760bf: entered by fall-through of je at 0x004760b9, 3 instruction(s), ends with jne to 0x004763ad (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004760bf
    cmp dword ptr [ecx + field_1c], 0x0          # 004760c2
    jne.d32 L_004763ad                           # 004760c6
    # block 0x004760cc: entered by fall-through of jne at 0x004760c6, 3 instruction(s), ends with jne to 0x004763ad (forward)
    mov edx, dword ptr [ebp - local_18]          # 004760cc
    cmp dword ptr [edx + field_2c], 0x0          # 004760cf
    jne.d32 L_004763ad                           # 004760d3
    # block 0x004760d9: entered by fall-through of jne at 0x004760d3, 5 instruction(s), ends with jne to 0x004763ad (forward)
    mov eax, dword ptr [ebp - local_18]          # 004760d9
    {load} xor ecx, ecx                          # 004760dc
    mov cl, byte ptr [eax + field_8d8]           # 004760de
    test ecx, ecx                                # 004760e4
    jne.d32 L_004763ad                           # 004760e6
    # block 0x004760ec: entered by fall-through of jne at 0x004760e6, 5 instruction(s), ends with jne to 0x004763ad (forward)
    mov edx, dword ptr [ebp - local_18]          # 004760ec
    {load} xor eax, eax                          # 004760ef
    mov al, byte ptr [edx + field_8d9]           # 004760f1
    test eax, eax                                # 004760f7
    jne.d32 L_004763ad                           # 004760f9
    # block 0x004760ff: entered by fall-through of jne at 0x004760f9, 5 instruction(s), ends with jne to 0x004763ad (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004760ff
    movsx edx, word ptr [ecx + field_22]         # 00476102
    imul edx, edx, 0x8d                          # 00476106
    cmp dword ptr [edx + 0x5bb632], 0x1          # 0047610c
    jne.d32 L_004763ad                           # 00476113
    # block 0x00476119: entered by fall-through of jne at 0x00476113, 2 instruction(s), ends with jne to 0x0047614e (forward)
    cmp dword ptr [0x5c39e5], 0x27d6             # 00476119
    jne.d8 L_0047614e                            # 00476123
    # block 0x00476125: entered by fall-through of jne at 0x00476123, 7 instruction(s), ends with forward jump to 0x004763ad
    mov eax, dword ptr [ebp - local_18]          # 00476125
    mov dword ptr [eax + field_89e], 0x1         # 00476128
    mov ecx, dword ptr [ebp - local_18]          # 00476132
    movsx edx, word ptr [ecx + field_22]         # 00476135
    imul edx, edx, 0x8d                          # 00476139
    mov dword ptr [edx + 0x5bb632], 0x2          # 0047613f
    jmp.d32 L_004763ad                           # 00476149
L_0047614e:
    # block 0x0047614e: entered by jne at 0x00476123, 2 instruction(s), ends with jne to 0x0047632c (forward)
    cmp dword ptr [0x5c39e5], 0x27d5             # 0047614e
    jne.d32 L_0047632c                           # 00476158
    # block 0x0047615e: entered by fall-through of jne at 0x00476158, 3 instruction(s), ends with je to 0x004761f1 (forward)
    mov eax, dword ptr [ebp - local_18]          # 0047615e
    cmp dword ptr [eax + field_8b6], 0x0         # 00476161
    je.d32 L_004761f1                            # 00476168
    # block 0x0047616e: entered by fall-through of je at 0x00476168, 7 instruction(s), ends with je to 0x004761bb (forward)
    mov edi, 0x54c844                            # 0047616e
    mov esi, dword ptr [ebp - local_4]           # 00476173
    add esi, 0x74c                               # 00476176
    mov ecx, 0x9                                 # 0047617c
    {load} xor edx, edx                          # 00476181
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00476183
    je.d8 L_004761bb                             # 00476185
    # block 0x00476187: entered by fall-through of je at 0x00476185, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004761bb (forward)
    mov eax, dword ptr [ebp - local_4]           # 00476187
    movsx ecx, word ptr [eax + field_76d]        # 0047618a
    mov dword ptr [ebp - local_c], ecx           # 00476191
    mov edx, dword ptr [ebp - local_c]           # 00476194
    push edx                                     # 00476197
    mov ecx, 0x5cf1eb                            # 00476198
    call FUN_004f6334                            # 0047619d
    test eax, eax                                # 004761a2
    jne.d8 L_004761bb                            # 004761a4
    # block 0x004761a6: entered by fall-through of jne at 0x004761a4, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004761bb
    mov eax, dword ptr [ebp - local_4]           # 004761a6
    mov cx, word ptr [eax + field_76d]           # 004761a9
    push ecx                                     # 004761b0
    mov ecx, 0x5c3a67                            # 004761b1
    call FUN_004fb2e3                            # 004761b6
L_004761bb:
    # block 0x004761bb: entered by je at 0x00476185; jne at 0x004761a4, 11 instruction(s), ends with forward jump to 0x00476327
    mov edx, dword ptr [ebp - local_18]          # 004761bb
    mov eax, dword ptr [ebp - local_18]          # 004761be
    mov ecx, dword ptr [eax + field_8be]         # 004761c1
    mov dword ptr [edx + field_8aa], ecx         # 004761c7
    mov edx, dword ptr [ebp - local_18]          # 004761cd
    mov eax, dword ptr [ebp - local_18]          # 004761d0
    mov ecx, dword ptr [eax + field_8ba]         # 004761d3
    mov dword ptr [edx + field_8a6], ecx         # 004761d9
    mov edx, dword ptr [ebp - local_18]          # 004761df
    mov dword ptr [edx + field_8b6], 0x0         # 004761e2
    jmp.d32 L_00476327                           # 004761ec
L_004761f1:
    # block 0x004761f1: entered by je at 0x00476168, 9 instruction(s), ends with je to 0x0047624b (forward)
    mov eax, dword ptr [ebp - local_18]          # 004761f1
    mov dword ptr [eax + field_8b6], 0x1         # 004761f4
    mov edi, 0x54c850                            # 004761fe
    mov esi, dword ptr [ebp - local_4]           # 00476203
    add esi, 0x74c                               # 00476206
    mov ecx, 0x9                                 # 0047620c
    {load} xor edx, edx                          # 00476211
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00476213
    je.d8 L_0047624b                             # 00476215
    # block 0x00476217: entered by fall-through of je at 0x00476215, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x0047624b (forward)
    mov eax, dword ptr [ebp - local_4]           # 00476217
    movsx ecx, word ptr [eax + field_76d]        # 0047621a
    mov dword ptr [ebp - local_10], ecx          # 00476221
    mov edx, dword ptr [ebp - local_10]          # 00476224
    push edx                                     # 00476227
    mov ecx, 0x5cf1eb                            # 00476228
    call FUN_004f6334                            # 0047622d
    test eax, eax                                # 00476232
    jne.d8 L_0047624b                            # 00476234
    # block 0x00476236: entered by fall-through of jne at 0x00476234, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x0047624b
    mov eax, dword ptr [ebp - local_4]           # 00476236
    mov cx, word ptr [eax + field_76d]           # 00476239
    push ecx                                     # 00476240
    mov ecx, 0x5c3a67                            # 00476241
    call FUN_004fb2e3                            # 00476246
L_0047624b:
    # block 0x0047624b: entered by je at 0x00476215; jne at 0x00476234, 50 instruction(s), falls into the block at 0x00476327
    mov edx, dword ptr [ebp - local_18]          # 0047624b
    mov eax, dword ptr [edx + field_8aa]         # 0047624e
    imul eax, eax, 0xc8                          # 00476254
    mov ecx, dword ptr [ebp - local_18]          # 0047625a
    lea edx, [ecx + eax + field_30]              # 0047625d
    mov eax, dword ptr [ebp - local_18]          # 00476261
    mov ecx, dword ptr [eax + field_8a6]         # 00476264
    imul ecx, ecx, 0x14                          # 0047626a
    mov dx, word ptr [edx + ecx + field_2]       # 0047626d
    mov word ptr [ebp - local_8], dx             # 00476272
    mov eax, dword ptr [ebp - local_18]          # 00476276
    mov ecx, dword ptr [eax + field_8be]         # 00476279
    imul ecx, ecx, 0xc8                          # 0047627f
    mov edx, dword ptr [ebp - local_18]          # 00476285
    lea eax, [edx + ecx + field_30]              # 00476288
    mov ecx, dword ptr [ebp - local_18]          # 0047628c
    mov edx, dword ptr [ecx + field_8ba]         # 0047628f
    imul edx, edx, 0x14                          # 00476295
    mov ecx, dword ptr [ebp - local_18]          # 00476298
    mov ecx, dword ptr [ecx + field_8aa]         # 0047629b
    imul ecx, ecx, 0xc8                          # 004762a1
    mov esi, dword ptr [ebp - local_18]          # 004762a7
    lea ecx, [esi + ecx + field_30]              # 004762aa
    mov esi, dword ptr [ebp - local_18]          # 004762ae
    mov esi, dword ptr [esi + field_8a6]         # 004762b1
    imul esi, esi, 0x14                          # 004762b7
    mov dx, word ptr [eax + edx + field_2]       # 004762ba
    mov word ptr [ecx + esi + field_2], dx       # 004762bf
    mov eax, dword ptr [ebp - local_18]          # 004762c4
    mov ecx, dword ptr [eax + field_8be]         # 004762c7
    imul ecx, ecx, 0xc8                          # 004762cd
    mov edx, dword ptr [ebp - local_18]          # 004762d3
    lea eax, [edx + ecx + field_30]              # 004762d6
    mov ecx, dword ptr [ebp - local_18]          # 004762da
    mov edx, dword ptr [ecx + field_8ba]         # 004762dd
    imul edx, edx, 0x14                          # 004762e3
    mov cx, word ptr [ebp - local_8]             # 004762e6
    mov word ptr [eax + edx + field_2], cx       # 004762ea
    mov edx, dword ptr [ebp - local_18]          # 004762ef
    mov eax, dword ptr [ebp - local_18]          # 004762f2
    mov ecx, dword ptr [eax + field_8be]         # 004762f5
    mov dword ptr [edx + field_8b2], ecx         # 004762fb
    mov edx, dword ptr [ebp - local_18]          # 00476301
    mov eax, dword ptr [ebp - local_18]          # 00476304
    mov ecx, dword ptr [eax + field_8ba]         # 00476307
    mov dword ptr [edx + field_8ae], ecx         # 0047630d
    mov edx, dword ptr [ebp - local_18]          # 00476313
    mov byte ptr [edx + field_8d8], 0x1          # 00476316
    mov eax, dword ptr [ebp - local_18]          # 0047631d
    mov byte ptr [eax + field_8d9], 0x1          # 00476320
L_00476327:
    # block 0x00476327: entered by jmp at 0x004761ec, 1 instruction(s), ends with forward jump to 0x004763ad
    jmp.d32 L_004763ad                           # 00476327
L_0047632c:
    # block 0x0047632c: entered by jne at 0x00476158, 2 instruction(s), ends with jne to 0x004763ad (forward)
    cmp dword ptr [0x5c39e5], 0x27d7             # 0047632c
    jne.d8 L_004763ad                            # 00476336
    # block 0x00476338: entered by fall-through of jne at 0x00476336, 7 instruction(s), ends with je to 0x00476385 (forward)
    mov edi, 0x54c85c                            # 00476338
    mov esi, dword ptr [ebp - local_4]           # 0047633d
    add esi, 0x71b                               # 00476340
    mov ecx, 0x9                                 # 00476346
    {load} xor edx, edx                          # 0047634b
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0047634d
    je.d8 L_00476385                             # 0047634f
    # block 0x00476351: entered by fall-through of je at 0x0047634f, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x00476385 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00476351
    movsx ecx, word ptr [eax + field_73c]        # 00476354
    mov dword ptr [ebp - local_14], ecx          # 0047635b
    mov edx, dword ptr [ebp - local_14]          # 0047635e
    push edx                                     # 00476361
    mov ecx, 0x5cf1eb                            # 00476362
    call FUN_004f6334                            # 00476367
    test eax, eax                                # 0047636c
    jne.d8 L_00476385                            # 0047636e
    # block 0x00476370: entered by fall-through of jne at 0x0047636e, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x00476385
    mov eax, dword ptr [ebp - local_4]           # 00476370
    mov cx, word ptr [eax + field_73c]           # 00476373
    push ecx                                     # 0047637a
    mov ecx, 0x5c3a67                            # 0047637b
    call FUN_004fb2e3                            # 00476380
L_00476385:
    # block 0x00476385: entered by je at 0x0047634f; jne at 0x0047636e, 8 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x004763ad
    call dword ptr [0x52a23c]                    # 00476385
    add eax, 0xfa                                # 0047638b
    mov edx, dword ptr [ebp - local_18]          # 00476390
    mov dword ptr [edx + field_8ca], eax         # 00476393
    mov eax, dword ptr [ebp - local_18]          # 00476399
    mov byte ptr [eax + field_898], 0x1          # 0047639c
    mov ecx, dword ptr [ebp - local_18]          # 004763a3
    mov dword ptr [ecx + field_2c], 0x3          # 004763a6
L_004763ad:
    # block 0x004763ad: entered by je at 0x004760b9; jne at 0x004760c6; jne at 0x004760d3; jne at 0x004760e6; more, 5 instruction(s), ends with ret
    pop edi                                      # 004763ad
    pop esi                                      # 004763ae
    {load} mov esp, ebp                          # 004763af
    pop ebp                                      # 004763b1
    ret                                          # 004763b2

