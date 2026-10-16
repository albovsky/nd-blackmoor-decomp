# FUN_0040a209
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040a209
# extent:       0x0040a209-0x0040a5c1 (952 code bytes)
# span:         0x0040a209-0x0040a5c1 (code 952, tables 0, padding 0)
# sha256:       beaa863858634ee991f901039a97ddf377cbf689968e5e4b405c3e25d67fe71e
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040a209
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051e3c8, FUN_0051d3d5, FUN_004090ab
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 252 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004090ab, .text + (0x004090ab - 0x401000)
.set FUN_0051d3d5, .text + (0x0051d3d5 - 0x401000)
.set FUN_0051e3c8, .text + (0x0051e3c8 - 0x401000)

.org 0x0040a209 - 0x401000
.globl FUN_0040a209
FUN_0040a209:
    # block 0x0040a209: entry, 252 instruction(s), calls FUN_0051e3c8, FUN_0051d3d5, FUN_004090ab, ends with ret
    push ebp                                     # 0040a209
    {load} mov ebp, esp                          # 0040a20a
    push ecx                                     # 0040a20c
    mov dword ptr [ebp - local_4], ecx           # 0040a20d
    mov ecx, dword ptr [ebp - local_4]           # 0040a210
    call FUN_0051e3c8                            # 0040a213
    mov eax, dword ptr [ebp - local_4]           # 0040a218
    push eax                                     # 0040a21b
    push 0x567                                   # 0040a21c
    mov ecx, dword ptr [ebp - local_4]           # 0040a221
    add ecx, 0x8c                                # 0040a224
    call FUN_0051d3d5                            # 0040a22a
    mov ecx, dword ptr [ebp - local_4]           # 0040a22f
    push ecx                                     # 0040a232
    push 0x3f0                                   # 0040a233
    mov ecx, dword ptr [ebp - local_4]           # 0040a238
    add ecx, 0xcc                                # 0040a23b
    call FUN_0051d3d5                            # 0040a241
    mov edx, dword ptr [ebp - local_4]           # 0040a246
    push edx                                     # 0040a249
    push 0x3ef                                   # 0040a24a
    mov ecx, dword ptr [ebp - local_4]           # 0040a24f
    add ecx, 0x10c                               # 0040a252
    call FUN_0051d3d5                            # 0040a258
    mov eax, dword ptr [ebp - local_4]           # 0040a25d
    push eax                                     # 0040a260
    push 0x3f1                                   # 0040a261
    mov ecx, dword ptr [ebp - local_4]           # 0040a266
    add ecx, 0x14c                               # 0040a269
    call FUN_0051d3d5                            # 0040a26f
    mov ecx, dword ptr [ebp - local_4]           # 0040a274
    push ecx                                     # 0040a277
    push 0x3f3                                   # 0040a278
    mov ecx, dword ptr [ebp - local_4]           # 0040a27d
    add ecx, 0x18c                               # 0040a280
    call FUN_0051d3d5                            # 0040a286
    mov edx, dword ptr [ebp - local_4]           # 0040a28b
    push edx                                     # 0040a28e
    push 0x3f5                                   # 0040a28f
    mov ecx, dword ptr [ebp - local_4]           # 0040a294
    add ecx, 0x1cc                               # 0040a297
    call FUN_0051d3d5                            # 0040a29d
    mov eax, dword ptr [ebp - local_4]           # 0040a2a2
    push eax                                     # 0040a2a5
    push 0x3f4                                   # 0040a2a6
    mov ecx, dword ptr [ebp - local_4]           # 0040a2ab
    add ecx, 0x20c                               # 0040a2ae
    call FUN_0051d3d5                            # 0040a2b4
    mov ecx, dword ptr [ebp - local_4]           # 0040a2b9
    push ecx                                     # 0040a2bc
    push 0x3f6                                   # 0040a2bd
    mov ecx, dword ptr [ebp - local_4]           # 0040a2c2
    add ecx, 0x24c                               # 0040a2c5
    call FUN_0051d3d5                            # 0040a2cb
    mov edx, dword ptr [ebp - local_4]           # 0040a2d0
    push edx                                     # 0040a2d3
    push 0x3ff                                   # 0040a2d4
    mov ecx, dword ptr [ebp - local_4]           # 0040a2d9
    add ecx, 0x28c                               # 0040a2dc
    call FUN_0051d3d5                            # 0040a2e2
    mov eax, dword ptr [ebp - local_4]           # 0040a2e7
    push eax                                     # 0040a2ea
    push 0x400                                   # 0040a2eb
    mov ecx, dword ptr [ebp - local_4]           # 0040a2f0
    add ecx, 0x2cc                               # 0040a2f3
    call FUN_0051d3d5                            # 0040a2f9
    mov ecx, dword ptr [ebp - local_4]           # 0040a2fe
    push ecx                                     # 0040a301
    push 0x40d                                   # 0040a302
    mov ecx, dword ptr [ebp - local_4]           # 0040a307
    add ecx, 0x30c                               # 0040a30a
    call FUN_0051d3d5                            # 0040a310
    mov edx, dword ptr [ebp - local_4]           # 0040a315
    push edx                                     # 0040a318
    push 0x40f                                   # 0040a319
    mov ecx, dword ptr [ebp - local_4]           # 0040a31e
    add ecx, 0x34c                               # 0040a321
    call FUN_0051d3d5                            # 0040a327
    mov eax, dword ptr [ebp - local_4]           # 0040a32c
    push eax                                     # 0040a32f
    push 0x40e                                   # 0040a330
    mov ecx, dword ptr [ebp - local_4]           # 0040a335
    add ecx, 0x38c                               # 0040a338
    call FUN_0051d3d5                            # 0040a33e
    mov ecx, dword ptr [ebp - local_4]           # 0040a343
    push ecx                                     # 0040a346
    push 0x410                                   # 0040a347
    mov ecx, dword ptr [ebp - local_4]           # 0040a34c
    add ecx, 0x3cc                               # 0040a34f
    call FUN_0051d3d5                            # 0040a355
    mov edx, dword ptr [ebp - local_4]           # 0040a35a
    push edx                                     # 0040a35d
    push 0x411                                   # 0040a35e
    mov ecx, dword ptr [ebp - local_4]           # 0040a363
    add ecx, 0x40c                               # 0040a366
    call FUN_0051d3d5                            # 0040a36c
    mov eax, dword ptr [ebp - local_4]           # 0040a371
    push eax                                     # 0040a374
    push 0x413                                   # 0040a375
    mov ecx, dword ptr [ebp - local_4]           # 0040a37a
    add ecx, 0x44c                               # 0040a37d
    call FUN_0051d3d5                            # 0040a383
    mov ecx, dword ptr [ebp - local_4]           # 0040a388
    push ecx                                     # 0040a38b
    push 0x412                                   # 0040a38c
    mov ecx, dword ptr [ebp - local_4]           # 0040a391
    add ecx, 0x48c                               # 0040a394
    call FUN_0051d3d5                            # 0040a39a
    mov edx, dword ptr [ebp - local_4]           # 0040a39f
    push edx                                     # 0040a3a2
    push 0x414                                   # 0040a3a3
    mov ecx, dword ptr [ebp - local_4]           # 0040a3a8
    add ecx, 0x4cc                               # 0040a3ab
    call FUN_0051d3d5                            # 0040a3b1
    mov eax, dword ptr [ebp - local_4]           # 0040a3b6
    push eax                                     # 0040a3b9
    push 0x415                                   # 0040a3ba
    mov ecx, dword ptr [ebp - local_4]           # 0040a3bf
    add ecx, 0x50c                               # 0040a3c2
    call FUN_0051d3d5                            # 0040a3c8
    mov ecx, dword ptr [ebp - local_4]           # 0040a3cd
    push ecx                                     # 0040a3d0
    push 0x416                                   # 0040a3d1
    mov ecx, dword ptr [ebp - local_4]           # 0040a3d6
    add ecx, 0x54c                               # 0040a3d9
    call FUN_0051d3d5                            # 0040a3df
    mov edx, dword ptr [ebp - local_4]           # 0040a3e4
    push edx                                     # 0040a3e7
    push 0x421                                   # 0040a3e8
    mov ecx, dword ptr [ebp - local_4]           # 0040a3ed
    add ecx, 0x58c                               # 0040a3f0
    call FUN_0051d3d5                            # 0040a3f6
    mov eax, dword ptr [ebp - local_4]           # 0040a3fb
    push eax                                     # 0040a3fe
    push 0x422                                   # 0040a3ff
    mov ecx, dword ptr [ebp - local_4]           # 0040a404
    add ecx, 0x5cc                               # 0040a407
    call FUN_0051d3d5                            # 0040a40d
    mov ecx, dword ptr [ebp - local_4]           # 0040a412
    push ecx                                     # 0040a415
    push 0x423                                   # 0040a416
    mov ecx, dword ptr [ebp - local_4]           # 0040a41b
    add ecx, 0x60c                               # 0040a41e
    call FUN_0051d3d5                            # 0040a424
    mov edx, dword ptr [ebp - local_4]           # 0040a429
    push edx                                     # 0040a42c
    push 0x424                                   # 0040a42d
    mov ecx, dword ptr [ebp - local_4]           # 0040a432
    add ecx, 0x64c                               # 0040a435
    call FUN_0051d3d5                            # 0040a43b
    mov eax, dword ptr [ebp - local_4]           # 0040a440
    push eax                                     # 0040a443
    push 0x425                                   # 0040a444
    mov ecx, dword ptr [ebp - local_4]           # 0040a449
    add ecx, 0x68c                               # 0040a44c
    call FUN_0051d3d5                            # 0040a452
    mov ecx, dword ptr [ebp - local_4]           # 0040a457
    push ecx                                     # 0040a45a
    push 0x426                                   # 0040a45b
    mov ecx, dword ptr [ebp - local_4]           # 0040a460
    add ecx, 0x6cc                               # 0040a463
    call FUN_0051d3d5                            # 0040a469
    mov edx, dword ptr [ebp - local_4]           # 0040a46e
    push edx                                     # 0040a471
    push 0x427                                   # 0040a472
    mov ecx, dword ptr [ebp - local_4]           # 0040a477
    add ecx, 0x70c                               # 0040a47a
    call FUN_0051d3d5                            # 0040a480
    mov eax, dword ptr [ebp - local_4]           # 0040a485
    push eax                                     # 0040a488
    push 0x428                                   # 0040a489
    mov ecx, dword ptr [ebp - local_4]           # 0040a48e
    add ecx, 0x74c                               # 0040a491
    call FUN_0051d3d5                            # 0040a497
    mov ecx, dword ptr [ebp - local_4]           # 0040a49c
    push ecx                                     # 0040a49f
    push 0x429                                   # 0040a4a0
    mov ecx, dword ptr [ebp - local_4]           # 0040a4a5
    add ecx, 0x78c                               # 0040a4a8
    call FUN_0051d3d5                            # 0040a4ae
    mov edx, dword ptr [ebp - local_4]           # 0040a4b3
    push edx                                     # 0040a4b6
    push 0x42a                                   # 0040a4b7
    mov ecx, dword ptr [ebp - local_4]           # 0040a4bc
    add ecx, 0x7cc                               # 0040a4bf
    call FUN_0051d3d5                            # 0040a4c5
    mov eax, dword ptr [ebp - local_4]           # 0040a4ca
    push eax                                     # 0040a4cd
    push 0x417                                   # 0040a4ce
    mov ecx, dword ptr [ebp - local_4]           # 0040a4d3
    add ecx, 0x80c                               # 0040a4d6
    call FUN_0051d3d5                            # 0040a4dc
    mov ecx, dword ptr [ebp - local_4]           # 0040a4e1
    push ecx                                     # 0040a4e4
    push 0x418                                   # 0040a4e5
    mov ecx, dword ptr [ebp - local_4]           # 0040a4ea
    add ecx, 0x84c                               # 0040a4ed
    call FUN_0051d3d5                            # 0040a4f3
    mov edx, dword ptr [ebp - local_4]           # 0040a4f8
    push edx                                     # 0040a4fb
    push 0x419                                   # 0040a4fc
    mov ecx, dword ptr [ebp - local_4]           # 0040a501
    add ecx, 0x88c                               # 0040a504
    call FUN_0051d3d5                            # 0040a50a
    mov eax, dword ptr [ebp - local_4]           # 0040a50f
    push eax                                     # 0040a512
    push 0x41a                                   # 0040a513
    mov ecx, dword ptr [ebp - local_4]           # 0040a518
    add ecx, 0x8cc                               # 0040a51b
    call FUN_0051d3d5                            # 0040a521
    mov ecx, dword ptr [ebp - local_4]           # 0040a526
    push ecx                                     # 0040a529
    push 0x41b                                   # 0040a52a
    mov ecx, dword ptr [ebp - local_4]           # 0040a52f
    add ecx, 0x90c                               # 0040a532
    call FUN_0051d3d5                            # 0040a538
    mov edx, dword ptr [ebp - local_4]           # 0040a53d
    push edx                                     # 0040a540
    push 0x41c                                   # 0040a541
    mov ecx, dword ptr [ebp - local_4]           # 0040a546
    add ecx, 0x94c                               # 0040a549
    call FUN_0051d3d5                            # 0040a54f
    mov eax, dword ptr [ebp - local_4]           # 0040a554
    push eax                                     # 0040a557
    push 0x41d                                   # 0040a558
    mov ecx, dword ptr [ebp - local_4]           # 0040a55d
    add ecx, 0x98c                               # 0040a560
    call FUN_0051d3d5                            # 0040a566
    mov ecx, dword ptr [ebp - local_4]           # 0040a56b
    push ecx                                     # 0040a56e
    push 0x41e                                   # 0040a56f
    mov ecx, dword ptr [ebp - local_4]           # 0040a574
    add ecx, 0x9cc                               # 0040a577
    call FUN_0051d3d5                            # 0040a57d
    mov edx, dword ptr [ebp - local_4]           # 0040a582
    push edx                                     # 0040a585
    push 0x41f                                   # 0040a586
    mov ecx, dword ptr [ebp - local_4]           # 0040a58b
    add ecx, 0xa0c                               # 0040a58e
    call FUN_0051d3d5                            # 0040a594
    mov eax, dword ptr [ebp - local_4]           # 0040a599
    push eax                                     # 0040a59c
    push 0x420                                   # 0040a59d
    mov ecx, dword ptr [ebp - local_4]           # 0040a5a2
    add ecx, 0xa4c                               # 0040a5a5
    call FUN_0051d3d5                            # 0040a5ab
    mov ecx, dword ptr [ebp - local_4]           # 0040a5b0
    call FUN_004090ab                            # 0040a5b3
    mov eax, 0x1                                 # 0040a5b8
    {load} mov esp, ebp                          # 0040a5bd
    pop ebp                                      # 0040a5bf
    ret                                          # 0040a5c0

