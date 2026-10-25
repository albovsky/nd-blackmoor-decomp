# FUN_004e3093
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e3093
# extent:       0x004e3093-0x004e3525 (1170 code bytes)
# span:         0x004e3093-0x004e3525 (code 1170, tables 0, padding 0)
# sha256:       503fea48b522dc0aa6b92201c5a4e211a27fa1509f0b35f35d4624898339bf12
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e3093_lifted
# naming:       native port src/original_methods_fl41.c:m4e3093_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 7 seeds; oracle: 284/284 instructions, 8/8 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       27 ebp-relative slot(s): local_4, local_36, local_4a, local_4e, local_52, local_56, local_5a, local_5e, local_62, local_66, local_6a, local_6e and 15 more
# fields:       [eax + n] field_4, field_8, field_c, field_6ce, field_ac1, field_140c, field_1ca2; [ecx + n] field_4, field_8, field_c, field_6ce, field_ac1, field_140a; [edx + n] field_4, field_8, field_c, field_6ce, field_ab1, field_ad1, field_1ca2
# callees:      calls FUN_004ee572, FUN_004ee5f2, FUN_0050ca3e, FUN_004264e8, FUN_0044a2b7, FUN_004c97b4, FUN_004edcb1, FUN_004ee6c7, FUN_004c2790, FUN_004e204a, FUN_004e2940, FUN_004c924d
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4e3093_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 284 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_36, 0x36  # offset -0x36
.equ local_4a, 0x4a  # offset -0x4a
.equ local_4e, 0x4e  # offset -0x4e
.equ local_52, 0x52  # offset -0x52
.equ local_56, 0x56  # offset -0x56
.equ local_5a, 0x5a  # offset -0x5a
.equ local_5e, 0x5e  # offset -0x5e
.equ local_62, 0x62  # offset -0x62
.equ local_66, 0x66  # offset -0x66
.equ local_6a, 0x6a  # offset -0x6a
.equ local_6e, 0x6e  # offset -0x6e
.equ local_82, 0x82  # offset -0x82
.equ local_86, 0x86  # offset -0x86
.equ local_8a, 0x8a  # offset -0x8a
.equ local_8e, 0x8e  # offset -0x8e
.equ local_92, 0x92  # offset -0x92
.equ local_96, 0x96  # offset -0x96
.equ local_9a, 0x9a  # offset -0x9a
.equ local_9e, 0x9e  # offset -0x9e
.equ local_a2, 0xa2  # offset -0xa2
.equ local_a6, 0xa6  # offset -0xa6
.equ local_aa, 0xaa  # offset -0xaa
.equ local_ae, 0xae  # offset -0xae
.equ local_f4, 0xf4  # offset -0xf4
.equ local_f8, 0xf8  # offset -0xf8
.equ local_fc, 0xfc  # offset -0xfc
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_6ce, 0x6ce  # offset +0x6ce
.equ field_ab1, 0xab1  # offset +0xab1
.equ field_ac1, 0xac1  # offset +0xac1
.equ field_ad1, 0xad1  # offset +0xad1
.equ field_140a, 0x140a  # offset +0x140a
.equ field_140c, 0x140c  # offset +0x140c
.equ field_1ca2, 0x1ca2  # offset +0x1ca2

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004c924d, .text + (0x004c924d - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004e204a, .text + (0x004e204a - 0x401000)
.set FUN_004e2940, .text + (0x004e2940 - 0x401000)
.set FUN_004edcb1, .text + (0x004edcb1 - 0x401000)
.set FUN_004ee572, .text + (0x004ee572 - 0x401000)
.set FUN_004ee5f2, .text + (0x004ee5f2 - 0x401000)
.set FUN_004ee6c7, .text + (0x004ee6c7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004e3093 - 0x401000
.globl FUN_004e3093
FUN_004e3093:
    # block 0x004e3093: entry, 10 instruction(s), calls FUN_004ee572, ends with je to 0x004e3107 (forward)
    push ebp                                     # 004e3093
    {load} mov ebp, esp                          # 004e3094
    sub esp, 0xfc                                # 004e3096
    push esi                                     # 004e309c
    push edi                                     # 004e309d
    mov dword ptr [ebp - local_fc], ecx          # 004e309e
    mov ecx, dword ptr [ebp - local_fc]          # 004e30a4
    call FUN_004ee572                            # 004e30aa
    test eax, eax                                # 004e30af
    je.d8 L_004e3107                             # 004e30b1
    # block 0x004e30b3: entered by fall-through of je at 0x004e30b1, 13 instruction(s), calls FUN_004ee5f2, FUN_0050ca3e, FUN_004264e8, ends with je to 0x004e30f8 (forward)
    mov ecx, dword ptr [ebp - local_fc]          # 004e30b3
    call FUN_004ee5f2                            # 004e30b9
    push eax                                     # 004e30be
    push 0x55c000                                # 004e30bf
    push 0x63888b                                # 004e30c4
    call FUN_0050ca3e                            # 004e30c9
    add esp, 0xc                                 # 004e30ce
    push 0x63888b                                # 004e30d1
    mov ecx, 0x583979                            # 004e30d6
    call FUN_004264e8                            # 004e30db
    movsx eax, word ptr [0x63a4cd]               # 004e30e0
    test eax, eax                                # 004e30e7
    je.d8 L_004e30f8                             # 004e30e9
    # block 0x004e30eb: entered by fall-through of je at 0x004e30e9, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004e30f8
    push 0x63888b                                # 004e30eb
    call FUN_0044a2b7                            # 004e30f0
    add esp, 0x4                                 # 004e30f5
L_004e30f8:
    # block 0x004e30f8: entered by je at 0x004e30e9, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x004e351f
    mov ecx, 0x5cf659                            # 004e30f8
    call FUN_004c97b4                            # 004e30fd
    jmp.d32 L_004e351f                           # 004e3102
L_004e3107:
    # block 0x004e3107: entered by je at 0x004e30b1, 28 instruction(s), calls FUN_004edcb1, FUN_004ee6c7, FUN_004c2790, ends with forward jump to 0x004e318d
    push 0x1                                     # 004e3107
    mov ecx, dword ptr [ebp - local_fc]          # 004e3109
    add ecx, 0x6d2                               # 004e310f
    push ecx                                     # 004e3115
    mov ecx, dword ptr [ebp - local_fc]          # 004e3116
    call FUN_004edcb1                            # 004e311c
    push 0x1                                     # 004e3121
    mov ecx, dword ptr [ebp - local_fc]          # 004e3123
    call FUN_004ee6c7                            # 004e3129
    push 0x55c04c                                # 004e312e
    push 0x6                                     # 004e3133
    mov edx, dword ptr [ebp - local_fc]          # 004e3135
    add edx, 0x9c2                               # 004e313b
    push edx                                     # 004e3141
    push 0x55c064                                # 004e3142
    mov ecx, 0x5cf659                            # 004e3147
    call FUN_004c2790                            # 004e314c
    mov ecx, dword ptr [ebp - local_fc]          # 004e3151
    mov dword ptr [ecx + field_6ce], eax         # 004e3157
    mov esi, dword ptr [ebp - local_fc]          # 004e315d
    add esi, 0x9c2                               # 004e3163
    mov ecx, 0x3b                                # 004e3169
    lea edi, [ebp - local_f4]                    # 004e316e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e3174
    movsw word ptr es:[edi], word ptr [esi]      # 004e3176
    movsb byte ptr es:[edi], byte ptr [esi]      # 004e3178
    mov word ptr [ebp - local_4], 0x0            # 004e3179
    jmp.d8 L_004e318d                            # 004e317f
L_004e3181:
    # block 0x004e3181: entered by jmp at 0x004e328d, 3 instruction(s), falls into the block at 0x004e318d
    mov dx, word ptr [ebp - local_4]             # 004e3181
    add dx, 0x1                                  # 004e3185
    mov word ptr [ebp - local_4], dx             # 004e3189
L_004e318d:
    # block 0x004e318d: entered by jmp at 0x004e317f, 3 instruction(s), ends with jge to 0x004e3292 (forward)
    movsx eax, word ptr [ebp - local_4]          # 004e318d
    cmp eax, 0xf                                 # 004e3191
    jge.d32 L_004e3292                           # 004e3194
    # block 0x004e319a: entered by fall-through of jge at 0x004e3194, 66 instruction(s), calls FUN_004e204a, ends with backward jump to 0x004e3181
    movsx ecx, word ptr [ebp - local_4]          # 004e319a
    imul ecx, ecx, 0x41                          # 004e319e
    mov edx, dword ptr [ebp - local_fc]          # 004e31a1
    lea eax, [edx + ecx + field_ab1]             # 004e31a7
    mov ecx, dword ptr [eax]                     # 004e31ae
    mov dword ptr [ebp - local_8e], ecx          # 004e31b0
    mov edx, dword ptr [eax + field_4]           # 004e31b6
    mov dword ptr [ebp - local_8a], edx          # 004e31b9
    mov ecx, dword ptr [eax + field_8]           # 004e31bf
    mov dword ptr [ebp - local_86], ecx          # 004e31c2
    mov edx, dword ptr [eax + field_c]           # 004e31c8
    mov dword ptr [ebp - local_82], edx          # 004e31cb
    movsx eax, word ptr [ebp - local_4]          # 004e31d1
    imul eax, eax, 0x41                          # 004e31d5
    mov ecx, dword ptr [ebp - local_fc]          # 004e31d8
    lea edx, [ecx + eax + field_ac1]             # 004e31de
    mov eax, dword ptr [edx]                     # 004e31e5
    mov dword ptr [ebp - local_5e], eax          # 004e31e7
    mov ecx, dword ptr [edx + field_4]           # 004e31ea
    mov dword ptr [ebp - local_5a], ecx          # 004e31ed
    mov eax, dword ptr [edx + field_8]           # 004e31f0
    mov dword ptr [ebp - local_56], eax          # 004e31f3
    mov ecx, dword ptr [edx + field_c]           # 004e31f6
    mov dword ptr [ebp - local_52], ecx          # 004e31f9
    movsx edx, word ptr [ebp - local_4]          # 004e31fc
    imul edx, edx, 0x41                          # 004e3200
    mov eax, dword ptr [ebp - local_fc]          # 004e3203
    lea ecx, [eax + edx + field_ac1]             # 004e3209
    mov edx, dword ptr [ecx]                     # 004e3210
    mov dword ptr [ebp - local_6e], edx          # 004e3212
    mov eax, dword ptr [ecx + field_4]           # 004e3215
    mov dword ptr [ebp - local_6a], eax          # 004e3218
    mov edx, dword ptr [ecx + field_8]           # 004e321b
    mov dword ptr [ebp - local_66], edx          # 004e321e
    mov eax, dword ptr [ecx + field_c]           # 004e3221
    mov dword ptr [ebp - local_62], eax          # 004e3224
    movsx ecx, word ptr [ebp - local_4]          # 004e3227
    imul ecx, ecx, 0x41                          # 004e322b
    mov edx, dword ptr [ebp - local_fc]          # 004e322e
    lea eax, [edx + ecx + field_ad1]             # 004e3234
    {load} mov edi, eax                          # 004e323b
    lea edx, [ebp - local_36]                    # 004e323d
    or ecx, -0x1                                 # 004e3240
    {load} xor eax, eax                          # 004e3243
    repne scasb al, byte ptr es:[edi]            # 004e3245
    not ecx                                      # 004e3247
    {load} sub edi, ecx                          # 004e3249
    {load} mov esi, edi                          # 004e324b
    {load} mov eax, ecx                          # 004e324d
    {load} mov edi, edx                          # 004e324f
    shr ecx, 0x2                                 # 004e3251
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e3254
    {load} mov ecx, eax                          # 004e3256
    and ecx, 0x3                                 # 004e3258
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004e325b
    mov ecx, dword ptr [ebp - local_fc]          # 004e325d
    mov edx, dword ptr [ecx + field_6ce]         # 004e3263
    push edx                                     # 004e3269
    lea eax, [ebp - local_f4]                    # 004e326a
    push eax                                     # 004e3270
    movsx ecx, word ptr [ebp - local_4]          # 004e3271
    imul ecx, ecx, 0x18f                         # 004e3275
    mov edx, dword ptr [ebp - local_fc]          # 004e327b
    lea ecx, [edx + ecx + field_1ca2]            # 004e3281
    call FUN_004e204a                            # 004e3288
    jmp.d32 L_004e3181                           # 004e328d
L_004e3292:
    # block 0x004e3292: entered by jge at 0x004e3194, 71 instruction(s), calls FUN_004e204a, ends with forward jump to 0x004e33d0
    mov esi, dword ptr [ebp - local_fc]          # 004e3292
    add esi, 0x9c2                               # 004e3298
    mov ecx, 0x3b                                # 004e329e
    lea edi, [ebp - local_f4]                    # 004e32a3
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e32a9
    movsw word ptr es:[edi], word ptr [esi]      # 004e32ab
    movsb byte ptr es:[edi], byte ptr [esi]      # 004e32ad
    mov dword ptr [ebp - local_4a], 0x1          # 004e32ae
    mov dword ptr [ebp - local_4e], 0x0          # 004e32b5
    mov eax, dword ptr [ebp - local_fc]          # 004e32bc
    add eax, 0xf74                               # 004e32c2
    mov ecx, dword ptr [eax]                     # 004e32c7
    mov dword ptr [ebp - local_ae], ecx          # 004e32c9
    mov edx, dword ptr [eax + field_4]           # 004e32cf
    mov dword ptr [ebp - local_aa], edx          # 004e32d2
    mov ecx, dword ptr [eax + field_8]           # 004e32d8
    mov dword ptr [ebp - local_a6], ecx          # 004e32db
    mov edx, dword ptr [eax + field_c]           # 004e32e1
    mov dword ptr [ebp - local_a2], edx          # 004e32e4
    mov eax, dword ptr [ebp - local_fc]          # 004e32ea
    add eax, 0xf84                               # 004e32f0
    mov ecx, dword ptr [eax]                     # 004e32f5
    mov dword ptr [ebp - local_9e], ecx          # 004e32f7
    mov edx, dword ptr [eax + field_4]           # 004e32fd
    mov dword ptr [ebp - local_9a], edx          # 004e3300
    mov ecx, dword ptr [eax + field_8]           # 004e3306
    mov dword ptr [ebp - local_96], ecx          # 004e3309
    mov edx, dword ptr [eax + field_c]           # 004e330f
    mov dword ptr [ebp - local_92], edx          # 004e3312
    mov eax, dword ptr [ebp - local_fc]          # 004e3318
    add eax, 0xf94                               # 004e331e
    mov ecx, dword ptr [eax]                     # 004e3323
    mov dword ptr [ebp - local_5e], ecx          # 004e3325
    mov edx, dword ptr [eax + field_4]           # 004e3328
    mov dword ptr [ebp - local_5a], edx          # 004e332b
    mov ecx, dword ptr [eax + field_8]           # 004e332e
    mov dword ptr [ebp - local_56], ecx          # 004e3331
    mov edx, dword ptr [eax + field_c]           # 004e3334
    mov dword ptr [ebp - local_52], edx          # 004e3337
    mov eax, dword ptr [ebp - local_fc]          # 004e333a
    add eax, 0xf94                               # 004e3340
    mov ecx, dword ptr [eax]                     # 004e3345
    mov dword ptr [ebp - local_6e], ecx          # 004e3347
    mov edx, dword ptr [eax + field_4]           # 004e334a
    mov dword ptr [ebp - local_6a], edx          # 004e334d
    mov ecx, dword ptr [eax + field_8]           # 004e3350
    mov dword ptr [ebp - local_66], ecx          # 004e3353
    mov edx, dword ptr [eax + field_c]           # 004e3356
    mov dword ptr [ebp - local_62], edx          # 004e3359
    mov eax, dword ptr [ebp - local_fc]          # 004e335c
    mov ecx, dword ptr [eax + field_6ce]         # 004e3362
    push ecx                                     # 004e3368
    lea edx, [ebp - local_f4]                    # 004e3369
    push edx                                     # 004e336f
    mov ecx, dword ptr [ebp - local_fc]          # 004e3370
    add ecx, 0x3403                              # 004e3376
    call FUN_004e204a                            # 004e337c
    mov esi, dword ptr [ebp - local_fc]          # 004e3381
    add esi, 0x9c2                               # 004e3387
    mov ecx, 0x3b                                # 004e338d
    lea edi, [ebp - local_f4]                    # 004e3392
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e3398
    movsw word ptr es:[edi], word ptr [esi]      # 004e339a
    movsb byte ptr es:[edi], byte ptr [esi]      # 004e339c
    mov dword ptr [ebp - local_4a], 0x1          # 004e339d
    mov dword ptr [ebp - local_4e], 0x0          # 004e33a4
    mov eax, dword ptr [ebp - local_fc]          # 004e33ab
    add eax, 0x111d                              # 004e33b1
    mov dword ptr [ebp - local_f8], eax          # 004e33b6
    mov word ptr [ebp - local_4], 0x10           # 004e33bc
    jmp.d8 L_004e33d0                            # 004e33c2
L_004e33c4:
    # block 0x004e33c4: entered by jmp at 0x004e34ea, 3 instruction(s), falls into the block at 0x004e33d0
    mov cx, word ptr [ebp - local_4]             # 004e33c4
    add cx, 0x1                                  # 004e33c8
    mov word ptr [ebp - local_4], cx             # 004e33cc
L_004e33d0:
    # block 0x004e33d0: entered by jmp at 0x004e33c2, 3 instruction(s), ends with jg to 0x004e34ef (forward)
    movsx edx, word ptr [ebp - local_4]          # 004e33d0
    cmp edx, 0x19                                # 004e33d4
    jg.d32 L_004e34ef                            # 004e33d7
    # block 0x004e33dd: entered by fall-through of jg at 0x004e33d7, 63 instruction(s), calls FUN_004e204a, FUN_004e2940, ends with backward jump to 0x004e33c4
    mov eax, dword ptr [ebp - local_f8]          # 004e33dd
    mov ecx, dword ptr [eax]                     # 004e33e3
    mov dword ptr [ebp - local_ae], ecx          # 004e33e5
    mov edx, dword ptr [eax + field_4]           # 004e33eb
    mov dword ptr [ebp - local_aa], edx          # 004e33ee
    mov ecx, dword ptr [eax + field_8]           # 004e33f4
    mov dword ptr [ebp - local_a6], ecx          # 004e33f7
    mov edx, dword ptr [eax + field_c]           # 004e33fd
    mov dword ptr [ebp - local_a2], edx          # 004e3400
    mov eax, dword ptr [ebp - local_f8]          # 004e3406
    add eax, 0x10                                # 004e340c
    mov dword ptr [ebp - local_f8], eax          # 004e340f
    mov ecx, dword ptr [ebp - local_f8]          # 004e3415
    mov edx, dword ptr [ecx]                     # 004e341b
    mov dword ptr [ebp - local_9e], edx          # 004e341d
    mov eax, dword ptr [ecx + field_4]           # 004e3423
    mov dword ptr [ebp - local_9a], eax          # 004e3426
    mov edx, dword ptr [ecx + field_8]           # 004e342c
    mov dword ptr [ebp - local_96], edx          # 004e342f
    mov eax, dword ptr [ecx + field_c]           # 004e3435
    mov dword ptr [ebp - local_92], eax          # 004e3438
    mov ecx, dword ptr [ebp - local_f8]          # 004e343e
    add ecx, 0x10                                # 004e3444
    mov dword ptr [ebp - local_f8], ecx          # 004e3447
    mov edx, dword ptr [ebp - local_f8]          # 004e344d
    mov eax, dword ptr [edx]                     # 004e3453
    mov dword ptr [ebp - local_5e], eax          # 004e3455
    mov ecx, dword ptr [edx + field_4]           # 004e3458
    mov dword ptr [ebp - local_5a], ecx          # 004e345b
    mov eax, dword ptr [edx + field_8]           # 004e345e
    mov dword ptr [ebp - local_56], eax          # 004e3461
    mov ecx, dword ptr [edx + field_c]           # 004e3464
    mov dword ptr [ebp - local_52], ecx          # 004e3467
    mov edx, dword ptr [ebp - local_fc]          # 004e346a
    add edx, 0xf94                               # 004e3470
    mov eax, dword ptr [edx]                     # 004e3476
    mov dword ptr [ebp - local_6e], eax          # 004e3478
    mov ecx, dword ptr [edx + field_4]           # 004e347b
    mov dword ptr [ebp - local_6a], ecx          # 004e347e
    mov eax, dword ptr [edx + field_8]           # 004e3481
    mov dword ptr [ebp - local_66], eax          # 004e3484
    mov ecx, dword ptr [edx + field_c]           # 004e3487
    mov dword ptr [ebp - local_62], ecx          # 004e348a
    mov edx, dword ptr [ebp - local_fc]          # 004e348d
    mov eax, dword ptr [edx + field_6ce]         # 004e3493
    push eax                                     # 004e3499
    lea ecx, [ebp - local_f4]                    # 004e349a
    push ecx                                     # 004e34a0
    movsx edx, word ptr [ebp - local_4]          # 004e34a1
    imul edx, edx, 0x18f                         # 004e34a5
    mov eax, dword ptr [ebp - local_fc]          # 004e34ab
    lea ecx, [eax + edx + field_1ca2]            # 004e34b1
    call FUN_004e204a                            # 004e34b8
    push 0x4                                     # 004e34bd
    movsx ecx, word ptr [ebp - local_4]          # 004e34bf
    imul ecx, ecx, 0x18f                         # 004e34c3
    mov edx, dword ptr [ebp - local_fc]          # 004e34c9
    lea ecx, [edx + ecx + field_1ca2]            # 004e34cf
    call FUN_004e2940                            # 004e34d6
    mov eax, dword ptr [ebp - local_f8]          # 004e34db
    add eax, 0x10                                # 004e34e1
    mov dword ptr [ebp - local_f8], eax          # 004e34e4
    jmp.d32 L_004e33c4                           # 004e34ea
L_004e34ef:
    # block 0x004e34ef: entered by jg at 0x004e33d7, 10 instruction(s), calls FUN_004c924d, falls into the block at 0x004e351f
    mov ecx, dword ptr [ebp - local_fc]          # 004e34ef
    mov dx, word ptr [ecx + field_140a]          # 004e34f5
    push edx                                     # 004e34fc
    mov ecx, 0x5cf659                            # 004e34fd
    call FUN_004c924d                            # 004e3502
    mov eax, dword ptr [ebp - local_fc]          # 004e3507
    mov cx, word ptr [eax + field_140c]          # 004e350d
    push ecx                                     # 004e3514
    mov ecx, 0x5cf659                            # 004e3515
    call FUN_004c924d                            # 004e351a
L_004e351f:
    # block 0x004e351f: entered by jmp at 0x004e3102, 5 instruction(s), ends with ret
    pop edi                                      # 004e351f
    pop esi                                      # 004e3520
    {load} mov esp, ebp                          # 004e3521
    pop ebp                                      # 004e3523
    ret                                          # 004e3524

