# FUN_0050d1f0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050d1f0
# extent:       0x0050d1f0-0x0050d337 (327 code bytes)
# span:         0x0050d1f0-0x0050d337 (code 327, tables 0, padding 0)
# sha256:       89b0abc723cf12736a25ec3c12dc6fe5a55ea965b745d8d85871f341fc858406
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050d1f0
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1; [ebx + n] field_1; [esi + n] field_2
# callees:      calls FUN_00511f30, FUN_00512c8e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 135 instruction(s), 23 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1, 0x1  # offset +0x1
.equ field_2, 0x2  # offset +0x2
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_00511f30, .text + (0x00511f30 - 0x401000)
.set FUN_00512c8e, .text + (0x00512c8e - 0x401000)

.org 0x0050d1f0 - 0x401000
.globl FUN_0050d1f0
FUN_0050d1f0:
    # block 0x0050d1f0: entry, 13 instruction(s), calls FUN_00511f30, ends with jb to 0x0050d22b (forward)
    push ebp                                     # 0050d1f0
    {load} mov ebp, esp                          # 0050d1f1
    push ecx                                     # 0050d1f3
    and dword ptr [ebp - local_4], 0x0           # 0050d1f4
    push ebx                                     # 0050d1f8
    mov ebx, dword ptr [ebp + arg_8]             # 0050d1f9
    push esi                                     # 0050d1fc
    push edi                                     # 0050d1fd
    push ebx                                     # 0050d1fe
    call FUN_00511f30                            # 0050d1ff
    cmp eax, 0x1                                 # 0050d204
    pop ecx                                      # 0050d207
    jb.d8 L_0050d22b                             # 0050d208
    # block 0x0050d20a: entered by fall-through of jb at 0x0050d208, 2 instruction(s), ends with jne to 0x0050d22b (forward)
    cmp byte ptr [ebx + field_1], 0x3a           # 0050d20a
    jne.d8 L_0050d22b                            # 0050d20e
    # block 0x0050d210: entered by fall-through of jne at 0x0050d20e, 3 instruction(s), ends with je to 0x0050d227 (forward)
    mov esi, dword ptr [ebp + arg_c]             # 0050d210
    test esi, esi                                # 0050d213
    je.d8 L_0050d227                             # 0050d215
    # block 0x0050d217: entered by fall-through of je at 0x0050d215, 6 instruction(s), calls FUN_00512c8e, falls into the block at 0x0050d227
    push 0x2                                     # 0050d217
    push ebx                                     # 0050d219
    push esi                                     # 0050d21a
    call FUN_00512c8e                            # 0050d21b
    add esp, 0xc                                 # 0050d220
    and byte ptr [esi + field_2], 0x0            # 0050d223
L_0050d227:
    # block 0x0050d227: entered by je at 0x0050d215, 3 instruction(s), ends with forward jump to 0x0050d235
    inc ebx                                      # 0050d227
    inc ebx                                      # 0050d228
    jmp.d8 L_0050d235                            # 0050d229
L_0050d22b:
    # block 0x0050d22b: entered by jb at 0x0050d208; jne at 0x0050d20e, 3 instruction(s), ends with je to 0x0050d235 (forward)
    mov eax, dword ptr [ebp + arg_c]             # 0050d22b
    test eax, eax                                # 0050d22e
    je.d8 L_0050d235                             # 0050d230
    # block 0x0050d232: entered by fall-through of je at 0x0050d230, 1 instruction(s), falls into the block at 0x0050d235
    and byte ptr [eax], 0x0                      # 0050d232
L_0050d235:
    # block 0x0050d235: entered by jmp at 0x0050d229; je at 0x0050d230, 6 instruction(s), ends with je to 0x0050d2ad (forward)
    and dword ptr [ebp + arg_c], 0x0             # 0050d235
    cmp byte ptr [ebx], 0x0                      # 0050d239
    {load} mov eax, ebx                          # 0050d23c
    mov esi, 0xff                                # 0050d23e
    mov dword ptr [ebp + arg_8], eax             # 0050d243
    je.d8 L_0050d2ad                             # 0050d246
L_0050d248:
    # block 0x0050d248: entered by jne at 0x0050d277; fall-through of je at 0x0050d246, 4 instruction(s), ends with je to 0x0050d259 (forward)
    mov cl, byte ptr [eax]                       # 0050d248
    movzx edx, cl                                # 0050d24a
    test byte ptr [edx + 0x63e021], 0x4          # 0050d24d
    je.d8 L_0050d259                             # 0050d254
    # block 0x0050d256: entered by fall-through of je at 0x0050d254, 2 instruction(s), ends with forward jump to 0x0050d273
    inc eax                                      # 0050d256
    jmp.d8 L_0050d273                            # 0050d257
L_0050d259:
    # block 0x0050d259: entered by je at 0x0050d254, 2 instruction(s), ends with je to 0x0050d26d (forward)
    cmp cl, 0x2f                                 # 0050d259
    je.d8 L_0050d26d                             # 0050d25c
    # block 0x0050d25e: entered by fall-through of je at 0x0050d25c, 2 instruction(s), ends with je to 0x0050d26d (forward)
    cmp cl, 0x5c                                 # 0050d25e
    je.d8 L_0050d26d                             # 0050d261
    # block 0x0050d263: entered by fall-through of je at 0x0050d261, 2 instruction(s), ends with jne to 0x0050d273 (forward)
    cmp cl, 0x2e                                 # 0050d263
    jne.d8 L_0050d273                            # 0050d266
    # block 0x0050d268: entered by fall-through of jne at 0x0050d266, 2 instruction(s), ends with forward jump to 0x0050d273
    mov dword ptr [ebp - local_4], eax           # 0050d268
    jmp.d8 L_0050d273                            # 0050d26b
L_0050d26d:
    # block 0x0050d26d: entered by je at 0x0050d25c; je at 0x0050d261, 2 instruction(s), falls into the block at 0x0050d273
    lea ecx, [eax + field_1]                     # 0050d26d
    mov dword ptr [ebp + arg_c], ecx             # 0050d270
L_0050d273:
    # block 0x0050d273: entered by jmp at 0x0050d257; jne at 0x0050d266; jmp at 0x0050d26b, 3 instruction(s), ends with jne to 0x0050d248 (backward)
    inc eax                                      # 0050d273
    cmp byte ptr [eax], 0x0                      # 0050d274
    jne.d8 L_0050d248                            # 0050d277
    # block 0x0050d279: entered by fall-through of jne at 0x0050d277, 4 instruction(s), ends with je to 0x0050d2ad (forward)
    mov edi, dword ptr [ebp + arg_c]             # 0050d279
    mov dword ptr [ebp + arg_8], eax             # 0050d27c
    test edi, edi                                # 0050d27f
    je.d8 L_0050d2ad                             # 0050d281
    # block 0x0050d283: entered by fall-through of je at 0x0050d281, 2 instruction(s), ends with je to 0x0050d2a8 (forward)
    cmp dword ptr [ebp + arg_10], 0x0            # 0050d283
    je.d8 L_0050d2a8                             # 0050d287
    # block 0x0050d289: entered by fall-through of je at 0x0050d287, 3 instruction(s), ends with jb to 0x0050d291 (forward)
    {load} sub edi, ebx                          # 0050d289
    {load} cmp edi, esi                          # 0050d28b
    jb.d8 L_0050d291                             # 0050d28d
    # block 0x0050d28f: entered by fall-through of jb at 0x0050d28d, 1 instruction(s), falls into the block at 0x0050d291
    {load} mov edi, esi                          # 0050d28f
L_0050d291:
    # block 0x0050d291: entered by jb at 0x0050d28d, 8 instruction(s), calls FUN_00512c8e, falls into the block at 0x0050d2a8
    push edi                                     # 0050d291
    push ebx                                     # 0050d292
    push dword ptr [ebp + arg_10]                # 0050d293
    call FUN_00512c8e                            # 0050d296
    mov eax, dword ptr [ebp + arg_10]            # 0050d29b
    add esp, 0xc                                 # 0050d29e
    and byte ptr [edi + eax], 0x0                # 0050d2a1
    mov eax, dword ptr [ebp + arg_8]             # 0050d2a5
L_0050d2a8:
    # block 0x0050d2a8: entered by je at 0x0050d287, 2 instruction(s), ends with forward jump to 0x0050d2b7
    mov ebx, dword ptr [ebp + arg_c]             # 0050d2a8
    jmp.d8 L_0050d2b7                            # 0050d2ab
L_0050d2ad:
    # block 0x0050d2ad: entered by je at 0x0050d246; je at 0x0050d281, 3 instruction(s), ends with je to 0x0050d2b7 (forward)
    mov ecx, dword ptr [ebp + arg_10]            # 0050d2ad
    test ecx, ecx                                # 0050d2b0
    je.d8 L_0050d2b7                             # 0050d2b2
    # block 0x0050d2b4: entered by fall-through of je at 0x0050d2b2, 1 instruction(s), falls into the block at 0x0050d2b7
    and byte ptr [ecx], 0x0                      # 0050d2b4
L_0050d2b7:
    # block 0x0050d2b7: entered by jmp at 0x0050d2ab; je at 0x0050d2b2, 3 instruction(s), ends with je to 0x0050d30a (forward)
    mov edi, dword ptr [ebp - local_4]           # 0050d2b7
    test edi, edi                                # 0050d2ba
    je.d8 L_0050d30a                             # 0050d2bc
    # block 0x0050d2be: entered by fall-through of je at 0x0050d2bc, 2 instruction(s), ends with jb to 0x0050d30a (forward)
    {load} cmp edi, ebx                          # 0050d2be
    jb.d8 L_0050d30a                             # 0050d2c0
    # block 0x0050d2c2: entered by fall-through of jb at 0x0050d2c0, 2 instruction(s), ends with je to 0x0050d2e7 (forward)
    cmp dword ptr [ebp + arg_14], 0x0            # 0050d2c2
    je.d8 L_0050d2e7                             # 0050d2c6
    # block 0x0050d2c8: entered by fall-through of je at 0x0050d2c6, 3 instruction(s), ends with jb to 0x0050d2d0 (forward)
    {load} sub edi, ebx                          # 0050d2c8
    {load} cmp edi, esi                          # 0050d2ca
    jb.d8 L_0050d2d0                             # 0050d2cc
    # block 0x0050d2ce: entered by fall-through of jb at 0x0050d2cc, 1 instruction(s), falls into the block at 0x0050d2d0
    {load} mov edi, esi                          # 0050d2ce
L_0050d2d0:
    # block 0x0050d2d0: entered by jb at 0x0050d2cc, 8 instruction(s), calls FUN_00512c8e, falls into the block at 0x0050d2e7
    push edi                                     # 0050d2d0
    push ebx                                     # 0050d2d1
    push dword ptr [ebp + arg_14]                # 0050d2d2
    call FUN_00512c8e                            # 0050d2d5
    mov eax, dword ptr [ebp + arg_14]            # 0050d2da
    add esp, 0xc                                 # 0050d2dd
    and byte ptr [edi + eax], 0x0                # 0050d2e0
    mov eax, dword ptr [ebp + arg_8]             # 0050d2e4
L_0050d2e7:
    # block 0x0050d2e7: entered by je at 0x0050d2c6, 3 instruction(s), ends with je to 0x0050d332 (forward)
    mov edi, dword ptr [ebp + arg_18]            # 0050d2e7
    test edi, edi                                # 0050d2ea
    je.d8 L_0050d332                             # 0050d2ec
    # block 0x0050d2ee: entered by fall-through of je at 0x0050d2ec, 3 instruction(s), ends with jae to 0x0050d2f7 (forward)
    sub eax, dword ptr [ebp - local_4]           # 0050d2ee
    {load} cmp eax, esi                          # 0050d2f1
    jae.d8 L_0050d2f7                            # 0050d2f3
    # block 0x0050d2f5: entered by fall-through of jae at 0x0050d2f3, 1 instruction(s), falls into the block at 0x0050d2f7
    {load} mov esi, eax                          # 0050d2f5
L_0050d2f7:
    # block 0x0050d2f7: entered by jae at 0x0050d2f3, 7 instruction(s), calls FUN_00512c8e, ends with forward jump to 0x0050d332
    push esi                                     # 0050d2f7
    push dword ptr [ebp - local_4]               # 0050d2f8
    push edi                                     # 0050d2fb
    call FUN_00512c8e                            # 0050d2fc
    add esp, 0xc                                 # 0050d301
    and byte ptr [esi + edi], 0x0                # 0050d304
    jmp.d8 L_0050d332                            # 0050d308
L_0050d30a:
    # block 0x0050d30a: entered by je at 0x0050d2bc; jb at 0x0050d2c0, 3 instruction(s), ends with je to 0x0050d328 (forward)
    mov edi, dword ptr [ebp + arg_14]            # 0050d30a
    test edi, edi                                # 0050d30d
    je.d8 L_0050d328                             # 0050d30f
    # block 0x0050d311: entered by fall-through of je at 0x0050d30f, 3 instruction(s), ends with jae to 0x0050d319 (forward)
    {load} sub eax, ebx                          # 0050d311
    {load} cmp eax, esi                          # 0050d313
    jae.d8 L_0050d319                            # 0050d315
    # block 0x0050d317: entered by fall-through of jae at 0x0050d315, 1 instruction(s), falls into the block at 0x0050d319
    {load} mov esi, eax                          # 0050d317
L_0050d319:
    # block 0x0050d319: entered by jae at 0x0050d315, 6 instruction(s), calls FUN_00512c8e, falls into the block at 0x0050d328
    push esi                                     # 0050d319
    push ebx                                     # 0050d31a
    push edi                                     # 0050d31b
    call FUN_00512c8e                            # 0050d31c
    add esp, 0xc                                 # 0050d321
    and byte ptr [esi + edi], 0x0                # 0050d324
L_0050d328:
    # block 0x0050d328: entered by je at 0x0050d30f, 3 instruction(s), ends with je to 0x0050d332 (forward)
    mov eax, dword ptr [ebp + arg_18]            # 0050d328
    test eax, eax                                # 0050d32b
    je.d8 L_0050d332                             # 0050d32d
    # block 0x0050d32f: entered by fall-through of je at 0x0050d32d, 1 instruction(s), falls into the block at 0x0050d332
    and byte ptr [eax], 0x0                      # 0050d32f
L_0050d332:
    # block 0x0050d332: entered by je at 0x0050d2ec; jmp at 0x0050d308; je at 0x0050d32d, 5 instruction(s), ends with ret
    pop edi                                      # 0050d332
    pop esi                                      # 0050d333
    pop ebx                                      # 0050d334
    leave                                        # 0050d335
    ret                                          # 0050d336

