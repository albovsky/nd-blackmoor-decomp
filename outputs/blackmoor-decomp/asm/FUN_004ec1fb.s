# FUN_004ec1fb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ec1fb
# extent:       0x004ec1fb-0x004ec44b (592 code bytes)
# span:         0x004ec1fb-0x004ec44b (code 592, tables 0, padding 0)
# sha256:       4d5fb7df1c6bdd4801d6f57f6ba36a5ebae1148410d2806b2b42456eba5695e1
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ec1fb
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       8 ebp-relative slot(s): local_4, local_8, local_1b, local_3c, local_40, local_44, local_48, local_4c
# fields:       [eax + n] field_baa, field_c0d, field_28f0; [ecx + n] field_baa, field_c0d, field_28f0, field_28f2; [edx + n] field_baa, field_c0d, field_28f0, field_28f2
# callees:      calls FUN_004fb77a, FUN_004fb2e3, KERNEL32.dll!GetTickCount, FUN_0050cd50
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 168 instruction(s), 12 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_1b, 0x1b  # offset -0x1b
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ local_4c, 0x4c  # offset -0x4c
.equ arg_8, 0x8  # offset +0x8
.equ field_baa, 0xbaa  # offset +0xbaa
.equ field_c0d, 0xc0d  # offset +0xc0d
.equ field_28f0, 0x28f0  # offset +0x28f0
.equ field_28f2, 0x28f2  # offset +0x28f2

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x004ec1fb - 0x401000
.globl FUN_004ec1fb
FUN_004ec1fb:
    # block 0x004ec1fb: entry, 17 instruction(s), ends with je to 0x004ec27d (forward)
    push ebp                                     # 004ec1fb
    {load} mov ebp, esp                          # 004ec1fc
    sub esp, 0x4c                                # 004ec1fe
    push esi                                     # 004ec201
    push edi                                     # 004ec202
    mov dword ptr [ebp - local_44], ecx          # 004ec203
    mov dword ptr [ebp - local_4], 0x0           # 004ec206
    mov eax, dword ptr [ebp - local_4]           # 004ec20d
    mov dword ptr [ebp - local_8], eax           # 004ec210
    mov esi, dword ptr [ebp - local_44]          # 004ec213
    add esi, 0x88a                               # 004ec216
    mov ecx, 0xc                                 # 004ec21c
    lea edi, [ebp - local_3c]                    # 004ec221
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004ec224
    movsb byte ptr es:[edi], byte ptr [esi]      # 004ec226
    cmp dword ptr [ebp + arg_8], 0x0             # 004ec227
    je.d8 L_004ec27d                             # 004ec22b
    # block 0x004ec22d: entered by fall-through of je at 0x004ec22b, 4 instruction(s), ends with jne to 0x004ec27d (forward)
    mov ecx, dword ptr [ebp - local_44]          # 004ec22d
    movsx edx, word ptr [ecx + field_28f0]       # 004ec230
    test edx, edx                                # 004ec237
    jne.d8 L_004ec27d                            # 004ec239
    # block 0x004ec23b: entered by fall-through of jne at 0x004ec239, 15 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, KERNEL32.dll!GetTickCount, ends with forward jump to 0x004ec443
    lea eax, [ebp - local_3c]                    # 004ec23b
    push eax                                     # 004ec23e
    mov ecx, 0x5c3a67                            # 004ec23f
    call FUN_004fb77a                            # 004ec244
    mov cx, word ptr [ebp - local_1b]            # 004ec249
    push ecx                                     # 004ec24d
    mov ecx, 0x5c3a67                            # 004ec24e
    call FUN_004fb2e3                            # 004ec253
    mov edx, dword ptr [ebp - local_44]          # 004ec258
    mov word ptr [edx + field_28f0], 0x1         # 004ec25b
    call dword ptr [0x52a23c]                    # 004ec264
    add eax, 0x190                               # 004ec26a
    mov ecx, dword ptr [ebp - local_44]          # 004ec26f
    mov dword ptr [ecx + field_28f2], eax        # 004ec272
    jmp.d32 L_004ec443                           # 004ec278
L_004ec27d:
    # block 0x004ec27d: entered by je at 0x004ec22b; jne at 0x004ec239; jmp at 0x004ec3ed, 2 instruction(s), ends with jne to 0x004ec3f2 (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 004ec27d
    jne.d32 L_004ec3f2                           # 004ec281
    # block 0x004ec287: entered by fall-through of jne at 0x004ec281, 2 instruction(s), ends with jne to 0x004ec3f2 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 004ec287
    jne.d32 L_004ec3f2                           # 004ec28b
    # block 0x004ec291: entered by fall-through of jne at 0x004ec28b, 2 instruction(s), ends with je to 0x004ec33c (forward)
    cmp dword ptr [ebp + arg_8], 0x0             # 004ec291
    je.d32 L_004ec33c                            # 004ec295
    # block 0x004ec29b: entered by fall-through of je at 0x004ec295, 14 instruction(s), calls FUN_0050cd50, ends with je to 0x004ec2f7 (forward)
    call FUN_0050cd50                            # 004ec29b
    cdq                                          # 004ec2a0
    mov ecx, 0x3                                 # 004ec2a1
    idiv ecx                                     # 004ec2a6
    mov word ptr [ebp - local_40], dx            # 004ec2a8
    mov edi, 0x55cc98                            # 004ec2ac
    movsx edx, word ptr [ebp - local_40]         # 004ec2b1
    imul edx, edx, 0x21                          # 004ec2b5
    mov eax, dword ptr [ebp - local_44]          # 004ec2b8
    lea esi, [eax + edx + field_baa]             # 004ec2bb
    mov ecx, 0x9                                 # 004ec2c2
    {load} xor edx, edx                          # 004ec2c7
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004ec2c9
    je.d8 L_004ec2f7                             # 004ec2cb
    # block 0x004ec2cd: entered by fall-through of je at 0x004ec2cb, 9 instruction(s), ends with je to 0x004ec2f7 (forward)
    mov edi, 0x63aa08                            # 004ec2cd
    movsx eax, word ptr [ebp - local_40]         # 004ec2d2
    imul eax, eax, 0x21                          # 004ec2d6
    mov ecx, dword ptr [ebp - local_44]          # 004ec2d9
    lea esi, [ecx + eax + field_baa]             # 004ec2dc
    mov ecx, 0x1                                 # 004ec2e3
    {load} xor edx, edx                          # 004ec2e8
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004ec2ea
    je.d8 L_004ec2f7                             # 004ec2ec
    # block 0x004ec2ee: entered by fall-through of je at 0x004ec2ec, 2 instruction(s), ends with forward jump to 0x004ec2fe
    mov dword ptr [ebp - local_48], 0x1          # 004ec2ee
    jmp.d8 L_004ec2fe                            # 004ec2f5
L_004ec2f7:
    # block 0x004ec2f7: entered by je at 0x004ec2cb; je at 0x004ec2ec, 1 instruction(s), falls into the block at 0x004ec2fe
    mov dword ptr [ebp - local_48], 0x0          # 004ec2f7
L_004ec2fe:
    # block 0x004ec2fe: entered by jmp at 0x004ec2f5, 22 instruction(s), ends with forward jump to 0x004ec3d8
    mov eax, dword ptr [ebp - local_48]          # 004ec2fe
    mov dword ptr [ebp - local_8], eax           # 004ec301
    movsx ecx, word ptr [ebp - local_40]         # 004ec304
    imul ecx, ecx, 0x21                          # 004ec308
    mov edx, dword ptr [ebp - local_44]          # 004ec30b
    lea eax, [edx + ecx + field_baa]             # 004ec30e
    {load} mov edi, eax                          # 004ec315
    lea edx, [ebp - local_3c]                    # 004ec317
    or ecx, -0x1                                 # 004ec31a
    {load} xor eax, eax                          # 004ec31d
    repne scasb al, byte ptr es:[edi]            # 004ec31f
    not ecx                                      # 004ec321
    {load} sub edi, ecx                          # 004ec323
    {load} mov esi, edi                          # 004ec325
    {load} mov eax, ecx                          # 004ec327
    {load} mov edi, edx                          # 004ec329
    shr ecx, 0x2                                 # 004ec32b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004ec32e
    {load} mov ecx, eax                          # 004ec330
    and ecx, 0x3                                 # 004ec332
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004ec335
    jmp.d32 L_004ec3d8                           # 004ec337
L_004ec33c:
    # block 0x004ec33c: entered by je at 0x004ec295, 14 instruction(s), calls FUN_0050cd50, ends with je to 0x004ec398 (forward)
    call FUN_0050cd50                            # 004ec33c
    cdq                                          # 004ec341
    mov ecx, 0x3                                 # 004ec342
    idiv ecx                                     # 004ec347
    mov word ptr [ebp - local_40], dx            # 004ec349
    mov edi, 0x55cca4                            # 004ec34d
    movsx edx, word ptr [ebp - local_40]         # 004ec352
    imul edx, edx, 0x21                          # 004ec356
    mov eax, dword ptr [ebp - local_44]          # 004ec359
    lea esi, [eax + edx + field_c0d]             # 004ec35c
    mov ecx, 0x9                                 # 004ec363
    {load} xor edx, edx                          # 004ec368
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004ec36a
    je.d8 L_004ec398                             # 004ec36c
    # block 0x004ec36e: entered by fall-through of je at 0x004ec36c, 9 instruction(s), ends with je to 0x004ec398 (forward)
    mov edi, 0x63aa0c                            # 004ec36e
    movsx eax, word ptr [ebp - local_40]         # 004ec373
    imul eax, eax, 0x21                          # 004ec377
    mov ecx, dword ptr [ebp - local_44]          # 004ec37a
    lea esi, [ecx + eax + field_c0d]             # 004ec37d
    mov ecx, 0x1                                 # 004ec384
    {load} xor edx, edx                          # 004ec389
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004ec38b
    je.d8 L_004ec398                             # 004ec38d
    # block 0x004ec38f: entered by fall-through of je at 0x004ec38d, 2 instruction(s), ends with forward jump to 0x004ec39f
    mov dword ptr [ebp - local_4c], 0x1          # 004ec38f
    jmp.d8 L_004ec39f                            # 004ec396
L_004ec398:
    # block 0x004ec398: entered by je at 0x004ec36c; je at 0x004ec38d, 1 instruction(s), falls into the block at 0x004ec39f
    mov dword ptr [ebp - local_4c], 0x0          # 004ec398
L_004ec39f:
    # block 0x004ec39f: entered by jmp at 0x004ec396, 21 instruction(s), falls into the block at 0x004ec3d8
    mov eax, dword ptr [ebp - local_4c]          # 004ec39f
    mov dword ptr [ebp - local_8], eax           # 004ec3a2
    movsx ecx, word ptr [ebp - local_40]         # 004ec3a5
    imul ecx, ecx, 0x21                          # 004ec3a9
    mov edx, dword ptr [ebp - local_44]          # 004ec3ac
    lea eax, [edx + ecx + field_c0d]             # 004ec3af
    {load} mov edi, eax                          # 004ec3b6
    lea edx, [ebp - local_3c]                    # 004ec3b8
    or ecx, -0x1                                 # 004ec3bb
    {load} xor eax, eax                          # 004ec3be
    repne scasb al, byte ptr es:[edi]            # 004ec3c0
    not ecx                                      # 004ec3c2
    {load} sub edi, ecx                          # 004ec3c4
    {load} mov esi, edi                          # 004ec3c6
    {load} mov eax, ecx                          # 004ec3c8
    {load} mov edi, edx                          # 004ec3ca
    shr ecx, 0x2                                 # 004ec3cc
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004ec3cf
    {load} mov ecx, eax                          # 004ec3d1
    and ecx, 0x3                                 # 004ec3d3
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004ec3d6
L_004ec3d8:
    # block 0x004ec3d8: entered by jmp at 0x004ec337, 2 instruction(s), ends with jne to 0x004ec3ed (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 004ec3d8
    jne.d8 L_004ec3ed                            # 004ec3dc
    # block 0x004ec3de: entered by fall-through of jne at 0x004ec3dc, 3 instruction(s), ends with jne to 0x004ec3ed (forward)
    movsx ecx, word ptr [ebp - local_40]         # 004ec3de
    test ecx, ecx                                # 004ec3e2
    jne.d8 L_004ec3ed                            # 004ec3e4
    # block 0x004ec3e6: entered by fall-through of jne at 0x004ec3e4, 1 instruction(s), falls into the block at 0x004ec3ed
    mov dword ptr [ebp - local_4], 0x1           # 004ec3e6
L_004ec3ed:
    # block 0x004ec3ed: entered by jne at 0x004ec3dc; jne at 0x004ec3e4, 1 instruction(s), ends with backward jump to 0x004ec27d
    jmp.d32 L_004ec27d                           # 004ec3ed
L_004ec3f2:
    # block 0x004ec3f2: entered by jne at 0x004ec281; jne at 0x004ec28b, 2 instruction(s), ends with je to 0x004ec437 (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 004ec3f2
    je.d8 L_004ec437                             # 004ec3f6
    # block 0x004ec3f8: entered by fall-through of je at 0x004ec3f6, 15 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, KERNEL32.dll!GetTickCount, ends with forward jump to 0x004ec443
    lea edx, [ebp - local_3c]                    # 004ec3f8
    push edx                                     # 004ec3fb
    mov ecx, 0x5c3a67                            # 004ec3fc
    call FUN_004fb77a                            # 004ec401
    mov ax, word ptr [ebp - local_1b]            # 004ec406
    push eax                                     # 004ec40a
    mov ecx, 0x5c3a67                            # 004ec40b
    call FUN_004fb2e3                            # 004ec410
    mov ecx, dword ptr [ebp - local_44]          # 004ec415
    mov word ptr [ecx + field_28f0], 0x2         # 004ec418
    call dword ptr [0x52a23c]                    # 004ec421
    add eax, 0x3e8                               # 004ec427
    mov edx, dword ptr [ebp - local_44]          # 004ec42c
    mov dword ptr [edx + field_28f2], eax        # 004ec42f
    jmp.d8 L_004ec443                            # 004ec435
L_004ec437:
    # block 0x004ec437: entered by je at 0x004ec3f6, 2 instruction(s), falls into the block at 0x004ec443
    mov eax, dword ptr [ebp - local_44]          # 004ec437
    mov word ptr [eax + field_28f0], 0x0         # 004ec43a
L_004ec443:
    # block 0x004ec443: entered by jmp at 0x004ec278; jmp at 0x004ec435, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004ec443
    pop esi                                      # 004ec444
    {load} mov esp, ebp                          # 004ec445
    pop ebp                                      # 004ec447
    ret 0x4                                      # 004ec448

