# FUN_0050f253
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050f253
# extent:       0x0050f253-0x0050f439 (486 code bytes)
# span:         0x0050f253-0x0050f440 (code 486, tables 0, padding 7)
# sha256:       c52f4130471fa574cd837f2fcfb0771e41859a3073c653cc7f9702bce53a166e
# evidence:     ev_4431af068a3f4ca776e521e2b82a00887220c1221c914635cfd4305c8866eb9e
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050f253
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_e, arg_10; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       2 ebp-relative slot(s): local_4, local_c
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_005146dc, FUN_005145a4, FUN_00513e00, FUN_005145fe, FUN_00515a7f, FUN_0051457b, FUN_00513ef8
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 198 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ arg_e, 0xe  # offset +0xe
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_00513e00, .text + (0x00513e00 - 0x401000)
.set FUN_00513ef8, .text + (0x00513ef8 - 0x401000)
.set FUN_0051457b, .text + (0x0051457b - 0x401000)
.set FUN_005145a4, .text + (0x005145a4 - 0x401000)
.set FUN_005145fe, .text + (0x005145fe - 0x401000)
.set FUN_005146dc, .text + (0x005146dc - 0x401000)
.set FUN_00515a7f, .text + (0x00515a7f - 0x401000)

.org 0x0050f253 - 0x401000
.globl FUN_0050f253
FUN_0050f253:
    # block 0x0050f253: entry, 17 instruction(s), calls FUN_005146dc, ends with jne to 0x0050f2ed (forward)
    push ebp                                     # 0050f253
    {load} mov ebp, esp                          # 0050f254
    sub esp, 0xc                                 # 0050f256
    push esi                                     # 0050f259
    mov esi, 0xffff                              # 0050f25a
    push edi                                     # 0050f25f
    push esi                                     # 0050f260
    push 0x133f                                  # 0050f261
    call FUN_005146dc                            # 0050f266
    fld qword ptr [ebp + arg_8]                  # 0050f26b
    {load} mov edi, eax                          # 0050f26e
    mov eax, dword ptr [ebp + arg_e]             # 0050f270
    .insn 0x66, 0x25, 0x7ff0{:u16}               # 0050f273
    pop ecx                                      # 0050f277
    .insn 0x66, 0x3d, 0x7ff0{:u16}               # 0050f278
    pop ecx                                      # 0050f27c
    jne.d8 L_0050f2ed                            # 0050f27d
    # block 0x0050f27f: entered by fall-through of jne at 0x0050f27d, 8 instruction(s), calls FUN_005145a4, ends with jle to 0x0050f2bf (forward)
    push ecx                                     # 0050f27f
    push ecx                                     # 0050f280
    fstp qword ptr [esp]                         # 0050f281
    call FUN_005145a4                            # 0050f284
    pop ecx                                      # 0050f289
    test eax, eax                                # 0050f28a
    pop ecx                                      # 0050f28c
    jle.d8 L_0050f2bf                            # 0050f28d
    # block 0x0050f28f: entered by fall-through of jle at 0x0050f28d, 2 instruction(s), ends with jle to 0x0050f2f8 (forward)
    cmp eax, 0x2                                 # 0050f28f
    jle.d8 L_0050f2f8                            # 0050f292
    # block 0x0050f294: entered by fall-through of jle at 0x0050f292, 2 instruction(s), ends with jne to 0x0050f2bf (forward)
    cmp eax, 0x3                                 # 0050f294
    jne.d8 L_0050f2bf                            # 0050f297
    # block 0x0050f299: entered by fall-through of jne at 0x0050f297, 15 instruction(s), calls FUN_00513e00, ends with forward jump to 0x0050f435
    fild dword ptr [ebp + arg_10]                # 0050f299
    push edi                                     # 0050f29c
    push ecx                                     # 0050f29d
    push ecx                                     # 0050f29e
    fstp qword ptr [ebp - local_c]               # 0050f29f
    fld qword ptr [ebp - local_c]                # 0050f2a2
    fstp qword ptr [esp]                         # 0050f2a5
    fld qword ptr [ebp + arg_8]                  # 0050f2a8
    push ecx                                     # 0050f2ab
    push ecx                                     # 0050f2ac
    fstp qword ptr [esp]                         # 0050f2ad
    push 0x19                                    # 0050f2b0
    call FUN_00513e00                            # 0050f2b2
    add esp, 0x18                                # 0050f2b7
    jmp.d32 L_0050f435                           # 0050f2ba
L_0050f2bf:
    # block 0x0050f2bf: entered by jle at 0x0050f28d; jne at 0x0050f297, 19 instruction(s), ends with forward jump to 0x0050f40d
    fld qword ptr [ebp + arg_8]                  # 0050f2bf
    fadd qword ptr [0x52c598]                    # 0050f2c2
    push edi                                     # 0050f2c8
    push ecx                                     # 0050f2c9
    push ecx                                     # 0050f2ca
    fstp qword ptr [esp]                         # 0050f2cb
    fild dword ptr [ebp + arg_10]                # 0050f2ce
    push ecx                                     # 0050f2d1
    push ecx                                     # 0050f2d2
    fstp qword ptr [ebp - local_c]               # 0050f2d3
    fld qword ptr [ebp - local_c]                # 0050f2d6
    fstp qword ptr [esp]                         # 0050f2d9
    fld qword ptr [ebp + arg_8]                  # 0050f2dc
    push ecx                                     # 0050f2df
    push ecx                                     # 0050f2e0
    fstp qword ptr [esp]                         # 0050f2e1
    push 0x19                                    # 0050f2e4
    push 0x8                                     # 0050f2e6
    jmp.d32 L_0050f40d                           # 0050f2e8
L_0050f2ed:
    # block 0x0050f2ed: entered by jne at 0x0050f27d, 4 instruction(s), ends with jne to 0x0050f309 (forward)
    fcomp qword ptr [0x52c7b0]                   # 0050f2ed
    fnstsw ax                                    # 0050f2f3
    sahf                                         # 0050f2f5
    jne.d8 L_0050f309                            # 0050f2f6
L_0050f2f8:
    # block 0x0050f2f8: entered by jle at 0x0050f292; fall-through of jne at 0x0050f2f6, 7 instruction(s), calls FUN_005146dc, ends with forward jump to 0x0050f435
    push esi                                     # 0050f2f8
    push edi                                     # 0050f2f9
    call FUN_005146dc                            # 0050f2fa
    fld qword ptr [ebp + arg_8]                  # 0050f2ff
    pop ecx                                      # 0050f302
    pop ecx                                      # 0050f303
    jmp.d32 L_0050f435                           # 0050f304
L_0050f309:
    # block 0x0050f309: entered by jne at 0x0050f2f6, 13 instruction(s), calls FUN_005145fe, ends with jge to 0x0050f32b (forward)
    fld qword ptr [ebp + arg_8]                  # 0050f309
    lea eax, [ebp - local_4]                     # 0050f30c
    push eax                                     # 0050f30f
    push ecx                                     # 0050f310
    push ecx                                     # 0050f311
    fstp qword ptr [esp]                         # 0050f312
    call FUN_005145fe                            # 0050f315
    mov eax, dword ptr [ebp + arg_10]            # 0050f31a
    add esp, 0xc                                 # 0050f31d
    fstp qword ptr [ebp - local_c]               # 0050f320
    test eax, eax                                # 0050f323
    {load} mov ecx, eax                          # 0050f325
    jge.d8 L_0050f32b                            # 0050f327
    # block 0x0050f329: entered by fall-through of jge at 0x0050f327, 1 instruction(s), falls into the block at 0x0050f32b
    neg ecx                                      # 0050f329
L_0050f32b:
    # block 0x0050f32b: entered by jge at 0x0050f327, 2 instruction(s), ends with jg to 0x0050f338 (forward)
    cmp ecx, 0x7fffffff                          # 0050f32b
    jg.d8 L_0050f338                             # 0050f331
    # block 0x0050f333: entered by fall-through of jg at 0x0050f331, 2 instruction(s), falls into the block at 0x0050f338
    mov ecx, dword ptr [ebp - local_4]           # 0050f333
    {load} add eax, ecx                          # 0050f336
L_0050f338:
    # block 0x0050f338: entered by jg at 0x0050f331, 2 instruction(s), ends with jle to 0x0050f37c (forward)
    cmp eax, 0xa00                               # 0050f338
    jle.d8 L_0050f37c                            # 0050f33d
    # block 0x0050f33f: entered by fall-through of jle at 0x0050f33d, 16 instruction(s), calls FUN_00515a7f, falls into the block at 0x0050f366
    fld qword ptr [ebp - local_c]                # 0050f33f
    push edi                                     # 0050f342
    push ecx                                     # 0050f343
    push ecx                                     # 0050f344
    fstp qword ptr [esp]                         # 0050f345
    fld qword ptr [0x568a18]                     # 0050f348
    push ecx                                     # 0050f34e
    push ecx                                     # 0050f34f
    fstp qword ptr [esp]                         # 0050f350
    call FUN_00515a7f                            # 0050f353
    pop ecx                                      # 0050f358
    pop ecx                                      # 0050f359
    fstp qword ptr [esp]                         # 0050f35a
    fild dword ptr [ebp + arg_10]                # 0050f35d
    fstp qword ptr [ebp - local_c]               # 0050f360
    fld qword ptr [ebp - local_c]                # 0050f363
L_0050f366:
    # block 0x0050f366: entered by jmp at 0x0050f3ae, 10 instruction(s), ends with forward jump to 0x0050f40d
    push ecx                                     # 0050f366
    push ecx                                     # 0050f367
    fstp qword ptr [esp]                         # 0050f368
    fld qword ptr [ebp + arg_8]                  # 0050f36b
    push ecx                                     # 0050f36e
    push ecx                                     # 0050f36f
    fstp qword ptr [esp]                         # 0050f370
    push 0x19                                    # 0050f373
    push 0x11                                    # 0050f375
    jmp.d32 L_0050f40d                           # 0050f377
L_0050f37c:
    # block 0x0050f37c: entered by jle at 0x0050f33d, 2 instruction(s), ends with jle to 0x0050f3b0 (forward)
    cmp eax, 0x400                               # 0050f37c
    jle.d8 L_0050f3b0                            # 0050f381
    # block 0x0050f383: entered by fall-through of jle at 0x0050f381, 18 instruction(s), calls FUN_0051457b, ends with backward jump to 0x0050f366
    fld qword ptr [ebp - local_c]                # 0050f383
    add eax, 0xfffffa00                          # 0050f386
    push eax                                     # 0050f38b
    push ecx                                     # 0050f38c
    push ecx                                     # 0050f38d
    fstp qword ptr [esp]                         # 0050f38e
    call FUN_0051457b                            # 0050f391
    fstp qword ptr [ebp - local_c]               # 0050f396
    fld qword ptr [ebp - local_c]                # 0050f399
    add esp, 0xc                                 # 0050f39c
    push edi                                     # 0050f39f
    push ecx                                     # 0050f3a0
    push ecx                                     # 0050f3a1
    fstp qword ptr [esp]                         # 0050f3a2
    fild dword ptr [ebp + arg_10]                # 0050f3a5
    fstp qword ptr [ebp - local_c]               # 0050f3a8
    fld qword ptr [ebp - local_c]                # 0050f3ab
    jmp.d8 L_0050f366                            # 0050f3ae
L_0050f3b0:
    # block 0x0050f3b0: entered by jle at 0x0050f381, 2 instruction(s), ends with jge to 0x0050f3ca (forward)
    cmp eax, 0xfffff603                          # 0050f3b0
    jge.d8 L_0050f3ca                            # 0050f3b5
    # block 0x0050f3b7: entered by fall-through of jge at 0x0050f3b5, 9 instruction(s), ends with forward jump to 0x0050f3fc
    push edi                                     # 0050f3b7
    push ecx                                     # 0050f3b8
    fldz                                         # 0050f3b9
    push ecx                                     # 0050f3bb
    fstp qword ptr [esp]                         # 0050f3bc
    fild dword ptr [ebp + arg_10]                # 0050f3bf
    fstp qword ptr [ebp - local_c]               # 0050f3c2
    fld qword ptr [ebp - local_c]                # 0050f3c5
    jmp.d8 L_0050f3fc                            # 0050f3c8
L_0050f3ca:
    # block 0x0050f3ca: entered by jge at 0x0050f3b5, 2 instruction(s), ends with jge to 0x0050f417 (forward)
    cmp eax, 0xfffffc03                          # 0050f3ca
    jge.d8 L_0050f417                            # 0050f3cf
    # block 0x0050f3d1: entered by fall-through of jge at 0x0050f3cf, 17 instruction(s), calls FUN_0051457b, falls into the block at 0x0050f3fc
    fld qword ptr [ebp - local_c]                # 0050f3d1
    add eax, 0x600                               # 0050f3d4
    push eax                                     # 0050f3d9
    push ecx                                     # 0050f3da
    push ecx                                     # 0050f3db
    fstp qword ptr [esp]                         # 0050f3dc
    call FUN_0051457b                            # 0050f3df
    fstp qword ptr [ebp - local_c]               # 0050f3e4
    fld qword ptr [ebp - local_c]                # 0050f3e7
    add esp, 0xc                                 # 0050f3ea
    push edi                                     # 0050f3ed
    push ecx                                     # 0050f3ee
    push ecx                                     # 0050f3ef
    fstp qword ptr [esp]                         # 0050f3f0
    fild dword ptr [ebp + arg_10]                # 0050f3f3
    fstp qword ptr [ebp - local_c]               # 0050f3f6
    fld qword ptr [ebp - local_c]                # 0050f3f9
L_0050f3fc:
    # block 0x0050f3fc: entered by jmp at 0x0050f3c8, 9 instruction(s), falls into the block at 0x0050f40d
    push ecx                                     # 0050f3fc
    push ecx                                     # 0050f3fd
    fstp qword ptr [esp]                         # 0050f3fe
    fld qword ptr [ebp + arg_8]                  # 0050f401
    push ecx                                     # 0050f404
    push ecx                                     # 0050f405
    fstp qword ptr [esp]                         # 0050f406
    push 0x19                                    # 0050f409
    push 0x12                                    # 0050f40b
L_0050f40d:
    # block 0x0050f40d: entered by jmp at 0x0050f2e8; jmp at 0x0050f377, 3 instruction(s), calls FUN_00513ef8, ends with forward jump to 0x0050f435
    call FUN_00513ef8                            # 0050f40d
    add esp, 0x24                                # 0050f412
    jmp.d8 L_0050f435                            # 0050f415
L_0050f417:
    # block 0x0050f417: entered by jge at 0x0050f3cf, 12 instruction(s), calls FUN_0051457b, FUN_005146dc, falls into the block at 0x0050f435
    fld qword ptr [ebp - local_c]                # 0050f417
    push eax                                     # 0050f41a
    push ecx                                     # 0050f41b
    push ecx                                     # 0050f41c
    fstp qword ptr [esp]                         # 0050f41d
    call FUN_0051457b                            # 0050f420
    fstp qword ptr [ebp - local_c]               # 0050f425
    push esi                                     # 0050f428
    push edi                                     # 0050f429
    call FUN_005146dc                            # 0050f42a
    fld qword ptr [ebp - local_c]                # 0050f42f
    add esp, 0x14                                # 0050f432
L_0050f435:
    # block 0x0050f435: entered by jmp at 0x0050f2ba; jmp at 0x0050f304; jmp at 0x0050f415, 4 instruction(s), ends with ret
    pop edi                                      # 0050f435
    pop esi                                      # 0050f436
    leave                                        # 0050f437
    ret                                          # 0050f438

# --- data items (not part of the function) -------------------------
.org 0x0050f439 - 0x401000
PAD_0050f439:  # 7 byte(s) of int3 padding
    .fill 7, 1, 0xcc

