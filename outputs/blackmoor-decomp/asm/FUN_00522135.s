# FUN_00522135
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00522135
# extent:       0x00522135-0x0052229f (362 code bytes)
# span:         0x00522135-0x0052229f (code 362, tables 0, padding 0)
# sha256:       49c5134d0cee1a2cf38159a4570ec63fc1beff78a0bddd06acfa82f3d11d3623
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00522135
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_1c, field_58, field_70, field_bc; [edi + n] field_5, field_8; [esi + n] field_1c, field_24, field_2c, field_7c; [esp + n] stk_10, stk_14, stk_18
# callees:      calls FUN_0051d0b9, FUN_00525371, FUN_00521287, FUN_0052142d, FUN_00521de7, USER32.dll!IsWindowEnabled, USER32.dll!EnableWindow, USER32.dll!GetCapture, USER32.dll!SendMessageA, FUN_0051b097, COMCTL32.dll!PropertySheetA, FUN_0051b0e3, FUN_0051d526, FUN_0051ce72, FUN_0051d5e1, USER32.dll!GetActiveWindow and 1 more; plus 3 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 133 instruction(s), 15 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_5, 0x5  # offset +0x5
.equ field_8, 0x8  # offset +0x8
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_24, 0x24  # offset +0x24
.equ field_2c, 0x2c  # offset +0x2c
.equ field_58, 0x58  # offset +0x58
.equ field_70, 0x70  # offset +0x70
.equ field_7c, 0x7c  # offset +0x7c
.equ field_bc, 0xbc  # offset +0xbc

# --- external targets -----------------------------------------------
.set FUN_0051b097, .text + (0x0051b097 - 0x401000)
.set FUN_0051b0e3, .text + (0x0051b0e3 - 0x401000)
.set FUN_0051ce72, .text + (0x0051ce72 - 0x401000)
.set FUN_0051d0b9, .text + (0x0051d0b9 - 0x401000)
.set FUN_0051d526, .text + (0x0051d526 - 0x401000)
.set FUN_0051d5e1, .text + (0x0051d5e1 - 0x401000)
.set FUN_00521287, .text + (0x00521287 - 0x401000)
.set FUN_0052142d, .text + (0x0052142d - 0x401000)
.set FUN_00521de7, .text + (0x00521de7 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x00522135 - 0x401000
.globl FUN_00522135
FUN_00522135:
    # block 0x00522135: entry, 17 instruction(s), calls FUN_0051d0b9, indirect dword ptr [eax + 0xbc], FUN_00525371, ends with je to 0x00522171 (forward)
    sub esp, 0xc                                 # 00522135
    push ebp                                     # 00522138
    push esi                                     # 00522139
    {load} mov esi, ecx                          # 0052213a
    push 0x10                                    # 0052213c
    call FUN_0051d0b9                            # 0052213e
    push 0x3c000                                 # 00522143
    call FUN_0051d0b9                            # 00522148
    mov eax, dword ptr [esi]                     # 0052214d
    {load} mov ecx, esi                          # 0052214f
    call dword ptr [eax + field_bc]              # 00522151
    call FUN_00525371                            # 00522157
    mov eax, dword ptr [eax + field_4]           # 0052215c
    {load} xor ebp, ebp                          # 0052215f
    {load} cmp eax, ebp                          # 00522161
    mov dword ptr [esp + stk_10], eax            # 00522163
    je.d8 L_00522171                             # 00522167
    # block 0x00522169: entered by fall-through of je at 0x00522167, 3 instruction(s), calls FUN_00521287, falls into the block at 0x00522171
    push ebp                                     # 00522169
    {load} mov ecx, eax                          # 0052216a
    call FUN_00521287                            # 0052216c
L_00522171:
    # block 0x00522171: entered by je at 0x00522167, 3 instruction(s), ends with jne to 0x0052217c (forward)
    mov eax, dword ptr [esi + field_7c]          # 00522171
    {load} cmp eax, ebp                          # 00522174
    jne.d8 L_0052217c                            # 00522176
    # block 0x00522178: entered by fall-through of jne at 0x00522176, 2 instruction(s), ends with forward jump to 0x0052217f
    {load} xor eax, eax                          # 00522178
    jmp.d8 L_0052217f                            # 0052217a
L_0052217c:
    # block 0x0052217c: entered by jne at 0x00522176, 1 instruction(s), falls into the block at 0x0052217f
    mov eax, dword ptr [eax + field_1c]          # 0052217c
L_0052217f:
    # block 0x0052217f: entered by jmp at 0x0052217a, 14 instruction(s), calls FUN_0052142d, FUN_00521de7, ends with je to 0x005221bd (forward)
    push ebx                                     # 0052217f
    lea ecx, [esp + stk_10]                      # 00522180
    push edi                                     # 00522184
    push ecx                                     # 00522185
    push eax                                     # 00522186
    call FUN_0052142d                            # 00522187
    {load} mov ecx, esi                          # 0052218c
    {load} mov ebx, eax                          # 0052218e
    call FUN_00521de7                            # 00522190
    {load} mov edi, eax                          # 00522195
    {load} cmp ebx, ebp                          # 00522197
    mov dword ptr [esp + stk_10], ebp            # 00522199
    mov dword ptr [edi + field_8], ebx           # 0052219d
    je.d8 L_005221bd                             # 005221a0
    # block 0x005221a2: entered by fall-through of je at 0x005221a0, 4 instruction(s), calls USER32.dll!IsWindowEnabled, ends with je to 0x005221bd (forward)
    push ebx                                     # 005221a2
    call dword ptr [0x52a330]                    # 005221a3
    test eax, eax                                # 005221a9
    je.d8 L_005221bd                             # 005221ab
    # block 0x005221ad: entered by fall-through of je at 0x005221ab, 4 instruction(s), calls USER32.dll!EnableWindow, falls into the block at 0x005221bd
    push ebp                                     # 005221ad
    push ebx                                     # 005221ae
    call dword ptr [0x52a4d0]                    # 005221af
    mov dword ptr [esp + stk_10], 0x1            # 005221b5
L_005221bd:
    # block 0x005221bd: entered by je at 0x005221a0; je at 0x005221ab, 3 instruction(s), calls USER32.dll!GetCapture, ends with je to 0x005221d2 (forward)
    call dword ptr [0x52a3e0]                    # 005221bd
    {load} cmp eax, ebp                          # 005221c3
    je.d8 L_005221d2                             # 005221c5
    # block 0x005221c7: entered by fall-through of je at 0x005221c5, 5 instruction(s), calls USER32.dll!SendMessageA, falls into the block at 0x005221d2
    push ebp                                     # 005221c7
    push ebp                                     # 005221c8
    push 0x1f                                    # 005221c9
    push eax                                     # 005221cb
    call dword ptr [0x52a4c8]                    # 005221cc
L_005221d2:
    # block 0x005221d2: entered by je at 0x005221c5, 14 instruction(s), calls FUN_0051b097, COMCTL32.dll!PropertySheetA, FUN_0051b0e3, ends with je to 0x00522204 (forward)
    or dword ptr [esi + field_24], 0x10          # 005221d2
    push esi                                     # 005221d6
    mov dword ptr [esi + field_2c], ebp          # 005221d7
    call FUN_0051b097                            # 005221da
    or byte ptr [edi + field_5], 0x4             # 005221df
    or dword ptr [esi + field_24], 0x10          # 005221e3
    push edi                                     # 005221e7
    call dword ptr [0x52a02c]                    # 005221e8
    and byte ptr [edi + field_5], -0x5           # 005221ee
    {load} mov ebp, eax                          # 005221f2
    call FUN_0051b0e3                            # 005221f4
    {load} xor edi, edi                          # 005221f9
    {load} cmp ebp, edi                          # 005221fb
    je.d8 L_00522204                             # 005221fd
    # block 0x005221ff: entered by fall-through of je at 0x005221fd, 2 instruction(s), ends with jne to 0x00522208 (forward)
    cmp ebp, -0x1                                # 005221ff
    jne.d8 L_00522208                            # 00522202
L_00522204:
    # block 0x00522204: entered by je at 0x005221fd; fall-through of jne at 0x00522202, 1 instruction(s), falls into the block at 0x00522208
    and dword ptr [esi + field_24], -0x11        # 00522204
L_00522208:
    # block 0x00522208: entered by jne at 0x00522202, 6 instruction(s), calls indirect dword ptr [eax + 0x70], ends with je to 0x00522232 (forward)
    mov eax, dword ptr [esi]                     # 00522208
    mov ebp, dword ptr [esi + field_2c]          # 0052220a
    {load} mov ecx, esi                          # 0052220d
    call dword ptr [eax + field_70]              # 0052220f
    test eax, eax                                # 00522212
    je.d8 L_00522232                             # 00522214
    # block 0x00522216: entered by fall-through of je at 0x00522214, 6 instruction(s), calls FUN_0051d526, ends with je to 0x00522228 (forward)
    push 0x4                                     # 00522216
    {load} mov ecx, esi                          # 00522218
    pop ebp                                      # 0052221a
    call FUN_0051d526                            # 0052221b
    test ah, 0x1                                 # 00522220
    je.d8 L_00522228                             # 00522223
    # block 0x00522225: entered by fall-through of je at 0x00522223, 2 instruction(s), falls into the block at 0x00522228
    push 0x5                                     # 00522225
    pop ebp                                      # 00522227
L_00522228:
    # block 0x00522228: entered by je at 0x00522223, 4 instruction(s), calls FUN_0051ce72, falls into the block at 0x00522232
    push ebp                                     # 00522228
    {load} mov ecx, esi                          # 00522229
    call FUN_0051ce72                            # 0052222b
    {load} mov ebp, eax                          # 00522230
L_00522232:
    # block 0x00522232: entered by je at 0x00522214, 2 instruction(s), ends with je to 0x00522248 (forward)
    cmp dword ptr [esi + field_1c], edi          # 00522232
    je.d8 L_00522248                             # 00522235
    # block 0x00522237: entered by fall-through of je at 0x00522235, 8 instruction(s), calls FUN_0051d5e1, falls into the block at 0x00522248
    push 0x97                                    # 00522237
    push edi                                     # 0052223c
    push edi                                     # 0052223d
    push edi                                     # 0052223e
    push edi                                     # 0052223f
    push edi                                     # 00522240
    {load} mov ecx, esi                          # 00522241
    call FUN_0051d5e1                            # 00522243
L_00522248:
    # block 0x00522248: entered by je at 0x00522235, 2 instruction(s), ends with je to 0x00522257 (forward)
    cmp dword ptr [esp + stk_10], edi            # 00522248
    je.d8 L_00522257                             # 0052224c
    # block 0x0052224e: entered by fall-through of je at 0x0052224c, 3 instruction(s), calls USER32.dll!EnableWindow, falls into the block at 0x00522257
    push 0x1                                     # 0052224e
    push ebx                                     # 00522250
    call dword ptr [0x52a4d0]                    # 00522251
L_00522257:
    # block 0x00522257: entered by je at 0x0052224c, 2 instruction(s), ends with je to 0x0052226d (forward)
    {load} cmp ebx, edi                          # 00522257
    je.d8 L_0052226d                             # 00522259
    # block 0x0052225b: entered by fall-through of je at 0x00522259, 3 instruction(s), calls USER32.dll!GetActiveWindow, ends with jne to 0x0052226d (forward)
    call dword ptr [0x52a354]                    # 0052225b
    cmp eax, dword ptr [esi + field_1c]          # 00522261
    jne.d8 L_0052226d                            # 00522264
    # block 0x00522266: entered by fall-through of jne at 0x00522264, 2 instruction(s), calls USER32.dll!SetActiveWindow, falls into the block at 0x0052226d
    push ebx                                     # 00522266
    call dword ptr [0x52a304]                    # 00522267
L_0052226d:
    # block 0x0052226d: entered by je at 0x00522259; jne at 0x00522264, 6 instruction(s), calls indirect dword ptr [eax + 0x58], ends with je to 0x00522283 (forward)
    mov eax, dword ptr [esi]                     # 0052226d
    {load} mov ecx, esi                          # 0052226f
    call dword ptr [eax + field_58]              # 00522271
    mov ecx, dword ptr [esp + stk_18]            # 00522274
    {load} cmp ecx, edi                          # 00522278
    je.d8 L_00522283                             # 0052227a
    # block 0x0052227c: entered by fall-through of je at 0x0052227a, 2 instruction(s), calls FUN_00521287, falls into the block at 0x00522283
    push 0x1                                     # 0052227c
    call FUN_00521287                            # 0052227e
L_00522283:
    # block 0x00522283: entered by je at 0x0052227a, 4 instruction(s), ends with je to 0x00522297 (forward)
    cmp dword ptr [esp + stk_14], edi            # 00522283
    pop edi                                      # 00522287
    pop ebx                                      # 00522288
    je.d8 L_00522297                             # 00522289
    # block 0x0052228b: entered by fall-through of je at 0x00522289, 3 instruction(s), calls USER32.dll!EnableWindow, falls into the block at 0x00522297
    push 0x1                                     # 0052228b
    push dword ptr [esp + stk_10]                # 0052228d
    call dword ptr [0x52a4d0]                    # 00522291
L_00522297:
    # block 0x00522297: entered by je at 0x00522289, 5 instruction(s), ends with ret
    {load} mov eax, ebp                          # 00522297
    pop esi                                      # 00522299
    pop ebp                                      # 0052229a
    add esp, 0xc                                 # 0052229b
    ret                                          # 0052229e

