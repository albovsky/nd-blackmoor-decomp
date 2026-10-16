# FUN_0049d1be
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0049d1be
# extent:       0x0049d1be-0x0049d55d (927 code bytes)
# span:         0x0049d1be-0x0049d55d (code 927, tables 0, padding 0)
# sha256:       738e9838ef1ffddf9b95f45aae758f892a1bc76c82ba5d5096f063bf0b30112d
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0049d1be
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_1, field_dd8, field_de4, field_df8, field_e00, field_e04, field_e08, field_e10; [ecx + n] field_1, field_de0, field_de4, field_de8, field_dfc, field_e00, field_e04, field_e14, field_minus_1; [edx + n] field_1, field_dd8, field_ddc, field_de4, field_de8, field_e00, field_minus_1
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 254 instruction(s), 12 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_1, 0x1  # offset +0x1
.equ field_dd8, 0xdd8  # offset +0xdd8
.equ field_ddc, 0xddc  # offset +0xddc
.equ field_de0, 0xde0  # offset +0xde0
.equ field_de4, 0xde4  # offset +0xde4
.equ field_de8, 0xde8  # offset +0xde8
.equ field_df8, 0xdf8  # offset +0xdf8
.equ field_dfc, 0xdfc  # offset +0xdfc
.equ field_e00, 0xe00  # offset +0xe00
.equ field_e04, 0xe04  # offset +0xe04
.equ field_e08, 0xe08  # offset +0xe08
.equ field_e10, 0xe10  # offset +0xe10
.equ field_e14, 0xe14  # offset +0xe14

# --- external targets -----------------------------------------------

.org 0x0049d1be - 0x401000
.globl FUN_0049d1be
FUN_0049d1be:
    # block 0x0049d1be: entry, 19 instruction(s), ends with forward jump to 0x0049d1fd
    push ebp                                     # 0049d1be
    {load} mov ebp, esp                          # 0049d1bf
    sub esp, 0x14                                # 0049d1c1
    push esi                                     # 0049d1c4
    push edi                                     # 0049d1c5
    mov dword ptr [ebp - local_14], ecx          # 0049d1c6
    mov eax, dword ptr [ebp - local_14]          # 0049d1c9
    mov ecx, dword ptr [eax + field_e08]         # 0049d1cc
    {load} xor eax, eax                          # 0049d1d2
    mov edx, dword ptr [ebp - local_14]          # 0049d1d4
    mov edi, dword ptr [edx + field_de4]         # 0049d1d7
    {load} mov edx, ecx                          # 0049d1dd
    shr ecx, 0x2                                 # 0049d1df
    rep stosd dword ptr es:[edi], eax            # 0049d1e2
    {load} mov ecx, edx                          # 0049d1e4
    and ecx, 0x3                                 # 0049d1e6
    rep stosb byte ptr es:[edi], al              # 0049d1e9
    mov dword ptr [ebp - local_4], 0x0           # 0049d1eb
    jmp.d8 L_0049d1fd                            # 0049d1f2
L_0049d1f4:
    # block 0x0049d1f4: entered by jmp at 0x0049d30e, 3 instruction(s), falls into the block at 0x0049d1fd
    mov eax, dword ptr [ebp - local_4]           # 0049d1f4
    add eax, 0x1                                 # 0049d1f7
    mov dword ptr [ebp - local_4], eax           # 0049d1fa
L_0049d1fd:
    # block 0x0049d1fd: entered by jmp at 0x0049d1f2, 4 instruction(s), ends with jge to 0x0049d313 (forward)
    mov ecx, dword ptr [ebp - local_14]          # 0049d1fd
    mov edx, dword ptr [ebp - local_4]           # 0049d200
    cmp edx, dword ptr [ecx + field_e04]         # 0049d203
    jge.d32 L_0049d313                           # 0049d209
    # block 0x0049d20f: entered by fall-through of jge at 0x0049d209, 2 instruction(s), ends with je to 0x0049d226 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 0049d20f
    je.d8 L_0049d226                             # 0049d213
    # block 0x0049d215: entered by fall-through of je at 0x0049d213, 5 instruction(s), ends with jne to 0x0049d28c (forward)
    mov eax, dword ptr [ebp - local_14]          # 0049d215
    mov ecx, dword ptr [eax + field_e04]         # 0049d218
    sub ecx, 0x1                                 # 0049d21e
    cmp dword ptr [ebp - local_4], ecx           # 0049d221
    jne.d8 L_0049d28c                            # 0049d224
L_0049d226:
    # block 0x0049d226: entered by je at 0x0049d213; fall-through of jne at 0x0049d224, 2 instruction(s), ends with forward jump to 0x0049d238
    mov dword ptr [ebp - local_c], 0x0           # 0049d226
    jmp.d8 L_0049d238                            # 0049d22d
L_0049d22f:
    # block 0x0049d22f: entered by jmp at 0x0049d285, 3 instruction(s), falls into the block at 0x0049d238
    mov edx, dword ptr [ebp - local_c]           # 0049d22f
    add edx, 0x1                                 # 0049d232
    mov dword ptr [ebp - local_c], edx           # 0049d235
L_0049d238:
    # block 0x0049d238: entered by jmp at 0x0049d22d, 4 instruction(s), ends with jge to 0x0049d287 (forward)
    mov eax, dword ptr [ebp - local_14]          # 0049d238
    mov ecx, dword ptr [ebp - local_c]           # 0049d23b
    cmp ecx, dword ptr [eax + field_e00]         # 0049d23e
    jge.d8 L_0049d287                            # 0049d244
    # block 0x0049d246: entered by fall-through of jge at 0x0049d244, 18 instruction(s), ends with backward jump to 0x0049d22f
    mov edx, dword ptr [ebp - local_14]          # 0049d246
    mov eax, dword ptr [ebp - local_4]           # 0049d249
    imul eax, dword ptr [edx + field_e00]        # 0049d24c
    mov ecx, dword ptr [ebp - local_14]          # 0049d253
    mov edx, dword ptr [ecx + field_de4]         # 0049d256
    {load} add edx, eax                          # 0049d25c
    mov eax, dword ptr [ebp - local_c]           # 0049d25e
    mov cl, byte ptr [edx + eax]                 # 0049d261
    or cl, 0x1                                   # 0049d264
    mov edx, dword ptr [ebp - local_14]          # 0049d267
    mov eax, dword ptr [ebp - local_4]           # 0049d26a
    imul eax, dword ptr [edx + field_e00]        # 0049d26d
    mov edx, dword ptr [ebp - local_14]          # 0049d274
    mov edx, dword ptr [edx + field_de4]         # 0049d277
    {load} add edx, eax                          # 0049d27d
    mov eax, dword ptr [ebp - local_c]           # 0049d27f
    mov byte ptr [edx + eax], cl                 # 0049d282
    jmp.d8 L_0049d22f                            # 0049d285
L_0049d287:
    # block 0x0049d287: entered by jge at 0x0049d244, 1 instruction(s), ends with forward jump to 0x0049d30e
    jmp.d32 L_0049d30e                           # 0049d287
L_0049d28c:
    # block 0x0049d28c: entered by jne at 0x0049d224, 32 instruction(s), falls into the block at 0x0049d30e
    mov ecx, dword ptr [ebp - local_14]          # 0049d28c
    mov edx, dword ptr [ebp - local_4]           # 0049d28f
    imul edx, dword ptr [ecx + field_e00]        # 0049d292
    mov eax, dword ptr [ebp - local_14]          # 0049d299
    mov ecx, dword ptr [eax + field_de4]         # 0049d29c
    mov dl, byte ptr [ecx + edx]                 # 0049d2a2
    or dl, 0x1                                   # 0049d2a5
    mov eax, dword ptr [ebp - local_14]          # 0049d2a8
    mov ecx, dword ptr [ebp - local_4]           # 0049d2ab
    imul ecx, dword ptr [eax + field_e00]        # 0049d2ae
    mov eax, dword ptr [ebp - local_14]          # 0049d2b5
    mov eax, dword ptr [eax + field_de4]         # 0049d2b8
    mov byte ptr [eax + ecx], dl                 # 0049d2be
    mov ecx, dword ptr [ebp - local_14]          # 0049d2c1
    mov edx, dword ptr [ebp - local_4]           # 0049d2c4
    imul edx, dword ptr [ecx + field_e00]        # 0049d2c7
    mov eax, dword ptr [ebp - local_14]          # 0049d2ce
    mov ecx, dword ptr [eax + field_de4]         # 0049d2d1
    {load} add ecx, edx                          # 0049d2d7
    mov edx, dword ptr [ebp - local_14]          # 0049d2d9
    mov eax, dword ptr [edx + field_e00]         # 0049d2dc
    mov cl, byte ptr [ecx + eax - field_minus_1] # 0049d2e2
    or cl, 0x1                                   # 0049d2e6
    mov edx, dword ptr [ebp - local_14]          # 0049d2e9
    mov eax, dword ptr [edx + field_e00]         # 0049d2ec
    mov edx, dword ptr [ebp - local_14]          # 0049d2f2
    mov esi, dword ptr [ebp - local_4]           # 0049d2f5
    imul esi, dword ptr [edx + field_e00]        # 0049d2f8
    mov edx, dword ptr [ebp - local_14]          # 0049d2ff
    mov edx, dword ptr [edx + field_de4]         # 0049d302
    {load} add edx, esi                          # 0049d308
    mov byte ptr [edx + eax - field_minus_1], cl # 0049d30a
L_0049d30e:
    # block 0x0049d30e: entered by jmp at 0x0049d287, 1 instruction(s), ends with backward jump to 0x0049d1f4
    jmp.d32 L_0049d1f4                           # 0049d30e
L_0049d313:
    # block 0x0049d313: entered by jge at 0x0049d209, 3 instruction(s), ends with forward jump to 0x0049d335
    mov dword ptr [ebp - local_10], 0x0          # 0049d313
    mov dword ptr [ebp - local_4], 0x1           # 0049d31a
    jmp.d8 L_0049d335                            # 0049d321
L_0049d323:
    # block 0x0049d323: entered by jmp at 0x0049d552, 6 instruction(s), falls into the block at 0x0049d335
    mov eax, dword ptr [ebp - local_10]          # 0049d323
    add eax, 0x1                                 # 0049d326
    mov dword ptr [ebp - local_10], eax          # 0049d329
    mov ecx, dword ptr [ebp - local_4]           # 0049d32c
    add ecx, 0x2                                 # 0049d32f
    mov dword ptr [ebp - local_4], ecx           # 0049d332
L_0049d335:
    # block 0x0049d335: entered by jmp at 0x0049d321, 4 instruction(s), ends with jge to 0x0049d557 (forward)
    mov edx, dword ptr [ebp - local_14]          # 0049d335
    mov eax, dword ptr [ebp - local_10]          # 0049d338
    cmp eax, dword ptr [edx + field_ddc]         # 0049d33b
    jge.d32 L_0049d557                           # 0049d341
    # block 0x0049d347: entered by fall-through of jge at 0x0049d341, 3 instruction(s), ends with forward jump to 0x0049d369
    mov dword ptr [ebp - local_8], 0x0           # 0049d347
    mov dword ptr [ebp - local_c], 0x1           # 0049d34e
    jmp.d8 L_0049d369                            # 0049d355
L_0049d357:
    # block 0x0049d357: entered by jmp at 0x0049d54d, 6 instruction(s), falls into the block at 0x0049d369
    mov ecx, dword ptr [ebp - local_8]           # 0049d357
    add ecx, 0x1                                 # 0049d35a
    mov dword ptr [ebp - local_8], ecx           # 0049d35d
    mov edx, dword ptr [ebp - local_c]           # 0049d360
    add edx, 0x2                                 # 0049d363
    mov dword ptr [ebp - local_c], edx           # 0049d366
L_0049d369:
    # block 0x0049d369: entered by jmp at 0x0049d355, 4 instruction(s), ends with jge to 0x0049d552 (forward)
    mov eax, dword ptr [ebp - local_14]          # 0049d369
    mov ecx, dword ptr [ebp - local_8]           # 0049d36c
    cmp ecx, dword ptr [eax + field_dd8]         # 0049d36f
    jge.d32 L_0049d552                           # 0049d375
    # block 0x0049d37b: entered by fall-through of jge at 0x0049d375, 14 instruction(s), ends with jne to 0x0049d400 (forward)
    mov edx, dword ptr [ebp - local_14]          # 0049d37b
    mov eax, dword ptr [ebp - local_10]          # 0049d37e
    imul eax, dword ptr [edx + field_dd8]        # 0049d381
    mov ecx, dword ptr [ebp - local_14]          # 0049d388
    mov edx, dword ptr [ecx + field_de0]         # 0049d38b
    lea eax, [edx + 2*eax]                       # 0049d391
    mov ecx, dword ptr [ebp - local_14]          # 0049d394
    mov edx, dword ptr [ebp - local_8]           # 0049d397
    mov ax, word ptr [eax + 2*edx]               # 0049d39a
    mov word ptr [ecx + field_de8], ax           # 0049d39e
    mov ecx, dword ptr [ebp - local_14]          # 0049d3a5
    mov edx, dword ptr [ebp - local_10]          # 0049d3a8
    cmp edx, dword ptr [ecx + field_e14]         # 0049d3ab
    jne.d8 L_0049d400                            # 0049d3b1
    # block 0x0049d3b3: entered by fall-through of jne at 0x0049d3b1, 4 instruction(s), ends with jne to 0x0049d400 (forward)
    mov eax, dword ptr [ebp - local_14]          # 0049d3b3
    mov ecx, dword ptr [ebp - local_8]           # 0049d3b6
    cmp ecx, dword ptr [eax + field_e10]         # 0049d3b9
    jne.d8 L_0049d400                            # 0049d3bf
    # block 0x0049d3c1: entered by fall-through of jne at 0x0049d3bf, 17 instruction(s), falls into the block at 0x0049d400
    mov edx, dword ptr [ebp - local_14]          # 0049d3c1
    mov eax, dword ptr [ebp - local_4]           # 0049d3c4
    imul eax, dword ptr [edx + field_e00]        # 0049d3c7
    mov ecx, dword ptr [ebp - local_14]          # 0049d3ce
    mov edx, dword ptr [ecx + field_de4]         # 0049d3d1
    {load} add edx, eax                          # 0049d3d7
    mov eax, dword ptr [ebp - local_c]           # 0049d3d9
    mov cl, byte ptr [edx + eax]                 # 0049d3dc
    or cl, 0x2                                   # 0049d3df
    mov edx, dword ptr [ebp - local_14]          # 0049d3e2
    mov eax, dword ptr [ebp - local_4]           # 0049d3e5
    imul eax, dword ptr [edx + field_e00]        # 0049d3e8
    mov edx, dword ptr [ebp - local_14]          # 0049d3ef
    mov edx, dword ptr [edx + field_de4]         # 0049d3f2
    {load} add edx, eax                          # 0049d3f8
    mov eax, dword ptr [ebp - local_c]           # 0049d3fa
    mov byte ptr [edx + eax], cl                 # 0049d3fd
L_0049d400:
    # block 0x0049d400: entered by jne at 0x0049d3b1; jne at 0x0049d3bf, 4 instruction(s), ends with jne to 0x0049d45b (forward)
    mov ecx, dword ptr [ebp - local_14]          # 0049d400
    mov edx, dword ptr [ebp - local_10]          # 0049d403
    cmp edx, dword ptr [ecx + field_dfc]         # 0049d406
    jne.d8 L_0049d45b                            # 0049d40c
    # block 0x0049d40e: entered by fall-through of jne at 0x0049d40c, 4 instruction(s), ends with jne to 0x0049d45b (forward)
    mov eax, dword ptr [ebp - local_14]          # 0049d40e
    mov ecx, dword ptr [ebp - local_8]           # 0049d411
    cmp ecx, dword ptr [eax + field_df8]         # 0049d414
    jne.d8 L_0049d45b                            # 0049d41a
    # block 0x0049d41c: entered by fall-through of jne at 0x0049d41a, 17 instruction(s), falls into the block at 0x0049d45b
    mov edx, dword ptr [ebp - local_14]          # 0049d41c
    mov eax, dword ptr [ebp - local_4]           # 0049d41f
    imul eax, dword ptr [edx + field_e00]        # 0049d422
    mov ecx, dword ptr [ebp - local_14]          # 0049d429
    mov edx, dword ptr [ecx + field_de4]         # 0049d42c
    {load} add edx, eax                          # 0049d432
    mov eax, dword ptr [ebp - local_c]           # 0049d434
    mov cl, byte ptr [edx + eax]                 # 0049d437
    or cl, 0x4                                   # 0049d43a
    mov edx, dword ptr [ebp - local_14]          # 0049d43d
    mov eax, dword ptr [ebp - local_4]           # 0049d440
    imul eax, dword ptr [edx + field_e00]        # 0049d443
    mov edx, dword ptr [ebp - local_14]          # 0049d44a
    mov edx, dword ptr [edx + field_de4]         # 0049d44d
    {load} add edx, eax                          # 0049d453
    mov eax, dword ptr [ebp - local_c]           # 0049d455
    mov byte ptr [edx + eax], cl                 # 0049d458
L_0049d45b:
    # block 0x0049d45b: entered by jne at 0x0049d40c; jne at 0x0049d41a, 6 instruction(s), ends with je to 0x0049d4af (forward)
    mov ecx, dword ptr [ebp - local_14]          # 0049d45b
    {load} xor edx, edx                          # 0049d45e
    mov dx, word ptr [ecx + field_de8]           # 0049d460
    and edx, 0x4                                 # 0049d467
    test edx, edx                                # 0049d46a
    je.d8 L_0049d4af                             # 0049d46c
    # block 0x0049d46e: entered by fall-through of je at 0x0049d46c, 17 instruction(s), falls into the block at 0x0049d4af
    mov eax, dword ptr [ebp - local_14]          # 0049d46e
    mov ecx, dword ptr [ebp - local_4]           # 0049d471
    imul ecx, dword ptr [eax + field_e00]        # 0049d474
    mov edx, dword ptr [ebp - local_14]          # 0049d47b
    mov eax, dword ptr [edx + field_de4]         # 0049d47e
    {load} add eax, ecx                          # 0049d484
    mov ecx, dword ptr [ebp - local_c]           # 0049d486
    mov dl, byte ptr [eax + ecx + field_1]       # 0049d489
    or dl, 0x1                                   # 0049d48d
    mov eax, dword ptr [ebp - local_14]          # 0049d490
    mov ecx, dword ptr [ebp - local_4]           # 0049d493
    imul ecx, dword ptr [eax + field_e00]        # 0049d496
    mov eax, dword ptr [ebp - local_14]          # 0049d49d
    mov eax, dword ptr [eax + field_de4]         # 0049d4a0
    {load} add eax, ecx                          # 0049d4a6
    mov ecx, dword ptr [ebp - local_c]           # 0049d4a8
    mov byte ptr [eax + ecx + field_1], dl       # 0049d4ab
L_0049d4af:
    # block 0x0049d4af: entered by je at 0x0049d46c, 6 instruction(s), ends with je to 0x0049d507 (forward)
    mov edx, dword ptr [ebp - local_14]          # 0049d4af
    {load} xor eax, eax                          # 0049d4b2
    mov ax, word ptr [edx + field_de8]           # 0049d4b4
    and eax, 0x1                                 # 0049d4bb
    test eax, eax                                # 0049d4be
    je.d8 L_0049d507                             # 0049d4c0
    # block 0x0049d4c2: entered by fall-through of je at 0x0049d4c0, 19 instruction(s), falls into the block at 0x0049d507
    mov ecx, dword ptr [ebp - local_4]           # 0049d4c2
    add ecx, 0x1                                 # 0049d4c5
    mov edx, dword ptr [ebp - local_14]          # 0049d4c8
    imul ecx, dword ptr [edx + field_e00]        # 0049d4cb
    mov eax, dword ptr [ebp - local_14]          # 0049d4d2
    mov edx, dword ptr [eax + field_de4]         # 0049d4d5
    {load} add edx, ecx                          # 0049d4db
    mov eax, dword ptr [ebp - local_c]           # 0049d4dd
    mov cl, byte ptr [edx + eax]                 # 0049d4e0
    or cl, 0x1                                   # 0049d4e3
    mov edx, dword ptr [ebp - local_4]           # 0049d4e6
    add edx, 0x1                                 # 0049d4e9
    mov eax, dword ptr [ebp - local_14]          # 0049d4ec
    imul edx, dword ptr [eax + field_e00]        # 0049d4ef
    mov eax, dword ptr [ebp - local_14]          # 0049d4f6
    mov eax, dword ptr [eax + field_de4]         # 0049d4f9
    {load} add eax, edx                          # 0049d4ff
    mov edx, dword ptr [ebp - local_c]           # 0049d501
    mov byte ptr [eax + edx], cl                 # 0049d504
L_0049d507:
    # block 0x0049d507: entered by je at 0x0049d4c0, 20 instruction(s), ends with backward jump to 0x0049d357
    mov eax, dword ptr [ebp - local_4]           # 0049d507
    add eax, 0x1                                 # 0049d50a
    mov ecx, dword ptr [ebp - local_14]          # 0049d50d
    imul eax, dword ptr [ecx + field_e00]        # 0049d510
    mov edx, dword ptr [ebp - local_14]          # 0049d517
    mov ecx, dword ptr [edx + field_de4]         # 0049d51a
    {load} add ecx, eax                          # 0049d520
    mov edx, dword ptr [ebp - local_c]           # 0049d522
    mov al, byte ptr [ecx + edx + field_1]       # 0049d525
    or al, 0x1                                   # 0049d529
    mov ecx, dword ptr [ebp - local_4]           # 0049d52b
    add ecx, 0x1                                 # 0049d52e
    mov edx, dword ptr [ebp - local_14]          # 0049d531
    imul ecx, dword ptr [edx + field_e00]        # 0049d534
    mov edx, dword ptr [ebp - local_14]          # 0049d53b
    mov edx, dword ptr [edx + field_de4]         # 0049d53e
    {load} add edx, ecx                          # 0049d544
    mov ecx, dword ptr [ebp - local_c]           # 0049d546
    mov byte ptr [edx + ecx + field_1], al       # 0049d549
    jmp.d32 L_0049d357                           # 0049d54d
L_0049d552:
    # block 0x0049d552: entered by jge at 0x0049d375, 1 instruction(s), ends with backward jump to 0x0049d323
    jmp.d32 L_0049d323                           # 0049d552
L_0049d557:
    # block 0x0049d557: entered by jge at 0x0049d341, 5 instruction(s), ends with ret
    pop edi                                      # 0049d557
    pop esi                                      # 0049d558
    {load} mov esp, ebp                          # 0049d559
    pop ebp                                      # 0049d55b
    ret                                          # 0049d55c

