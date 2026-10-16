# FUN_0041b2e6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041b2e6
# extent:       0x0041b2e6-0x0041b6e2 (1020 code bytes)
# span:         0x0041b2e6-0x0041b6e2 (code 1020, tables 0, padding 0)
# sha256:       e75c299a4127db01f129097ef957e716ed37720282ec834463000519e4a092c4
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0041b2e6
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       13 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_2c, local_30, local_34, local_38, local_3c, local_40 and 1 more
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0041b925, FUN_0041b992, FUN_0041bbd9
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 274 instruction(s), 18 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0041b925, .text + (0x0041b925 - 0x401000)
.set FUN_0041b992, .text + (0x0041b992 - 0x401000)
.set FUN_0041bbd9, .text + (0x0041bbd9 - 0x401000)

.org 0x0041b2e6 - 0x401000
.globl FUN_0041b2e6
FUN_0041b2e6:
    # block 0x0041b2e6: entry, 18 instruction(s), calls FUN_0041b925, ends with forward jump to 0x0041b33c
    push ebp                                     # 0041b2e6
    {load} mov ebp, esp                          # 0041b2e7
    sub esp, 0x44                                # 0041b2e9
    mov dword ptr [ebp - local_44], ecx          # 0041b2ec
    mov dword ptr [ebp - local_8], 0x0           # 0041b2ef
    mov dword ptr [ebp - local_c], 0x0           # 0041b2f6
    mov byte ptr [ebp - local_18], 0x0           # 0041b2fd
    mov ecx, dword ptr [ebp - local_44]          # 0041b301
    call FUN_0041b925                            # 0041b304
    mov byte ptr [ebp - local_2c], 0x0           # 0041b309
    mov byte ptr [ebp - local_38], 0x1           # 0041b30d
    movzx ax, byte ptr [ebp - local_38]          # 0041b311
    mov word ptr [ebp - local_40], ax            # 0041b316
    mov word ptr [ebp - local_10], 0x0           # 0041b31a
    mov word ptr [ebp - local_4], 0xfee          # 0041b320
    mov cx, word ptr [ebp - local_10]            # 0041b326
    mov word ptr [ebp - local_30], cx            # 0041b32a
    jmp.d8 L_0041b33c                            # 0041b32e
L_0041b330:
    # block 0x0041b330: entered by jmp at 0x0041b353, 3 instruction(s), falls into the block at 0x0041b33c
    mov dx, word ptr [ebp - local_30]            # 0041b330
    add dx, 0x1                                  # 0041b334
    mov word ptr [ebp - local_30], dx            # 0041b338
L_0041b33c:
    # block 0x0041b33c: entered by jmp at 0x0041b32e, 4 instruction(s), ends with jge to 0x0041b355 (forward)
    movsx eax, word ptr [ebp - local_30]         # 0041b33c
    movsx ecx, word ptr [ebp - local_4]          # 0041b340
    {load} cmp eax, ecx                          # 0041b344
    jge.d8 L_0041b355                            # 0041b346
    # block 0x0041b348: entered by fall-through of jge at 0x0041b346, 3 instruction(s), ends with backward jump to 0x0041b330
    movsx edx, word ptr [ebp - local_30]         # 0041b348
    mov byte ptr [edx + 0x56f354], 0x20          # 0041b34c
    jmp.d8 L_0041b330                            # 0041b353
L_0041b355:
    # block 0x0041b355: entered by jge at 0x0041b346, 2 instruction(s), ends with forward jump to 0x0041b369
    mov word ptr [ebp - local_3c], 0x0           # 0041b355
    jmp.d8 L_0041b369                            # 0041b35b
L_0041b35d:
    # block 0x0041b35d: entered by jmp at 0x0041b3a5, 3 instruction(s), falls into the block at 0x0041b369
    mov ax, word ptr [ebp - local_3c]            # 0041b35d
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041b361
    mov word ptr [ebp - local_3c], ax            # 0041b365
L_0041b369:
    # block 0x0041b369: entered by jmp at 0x0041b35b, 3 instruction(s), ends with jge to 0x0041b3a7 (forward)
    movsx ecx, word ptr [ebp - local_3c]         # 0041b369
    cmp ecx, 0x12                                # 0041b36d
    jge.d8 L_0041b3a7                            # 0041b370
    # block 0x0041b372: entered by fall-through of jge at 0x0041b370, 3 instruction(s), ends with jl to 0x0041b37c (forward)
    mov edx, dword ptr [ebp - local_c]           # 0041b372
    cmp edx, dword ptr [ebp + arg_c]             # 0041b375
    jl.d8 L_0041b37c                             # 0041b378
    # block 0x0041b37a: entered by fall-through of jl at 0x0041b378, 1 instruction(s), ends with forward jump to 0x0041b3a7
    jmp.d8 L_0041b3a7                            # 0041b37a
L_0041b37c:
    # block 0x0041b37c: entered by jl at 0x0041b378, 12 instruction(s), ends with backward jump to 0x0041b35d
    mov eax, dword ptr [ebp + arg_8]             # 0041b37c
    add eax, dword ptr [ebp - local_c]           # 0041b37f
    movsx cx, byte ptr [eax]                     # 0041b382
    mov word ptr [ebp - local_14], cx            # 0041b386
    mov edx, dword ptr [ebp - local_c]           # 0041b38a
    add edx, 0x1                                 # 0041b38d
    mov dword ptr [ebp - local_c], edx           # 0041b390
    movsx eax, word ptr [ebp - local_4]          # 0041b393
    movsx ecx, word ptr [ebp - local_3c]         # 0041b397
    mov dl, byte ptr [ebp - local_14]            # 0041b39b
    mov byte ptr [eax + ecx + 0x56f354], dl      # 0041b39e
    jmp.d8 L_0041b35d                            # 0041b3a5
L_0041b3a7:
    # block 0x0041b3a7: entered by jge at 0x0041b370; jmp at 0x0041b37a, 4 instruction(s), ends with jne to 0x0041b3c1 (forward)
    movsx eax, word ptr [ebp - local_3c]         # 0041b3a7
    mov dword ptr [0x570368], eax                # 0041b3ab
    cmp dword ptr [0x570368], 0x0                # 0041b3b0
    jne.d8 L_0041b3c1                            # 0041b3b7
    # block 0x0041b3b9: entered by fall-through of jne at 0x0041b3b7, 2 instruction(s), ends with forward jump to 0x0041b6dc
    or eax, -0x1                                 # 0041b3b9
    jmp.d32 L_0041b6dc                           # 0041b3bc
L_0041b3c1:
    # block 0x0041b3c1: entered by jne at 0x0041b3b7, 2 instruction(s), ends with forward jump to 0x0041b3d5
    mov word ptr [ebp - local_30], 0x1           # 0041b3c1
    jmp.d8 L_0041b3d5                            # 0041b3c7
L_0041b3c9:
    # block 0x0041b3c9: entered by jmp at 0x0041b3f1, 3 instruction(s), falls into the block at 0x0041b3d5
    mov cx, word ptr [ebp - local_30]            # 0041b3c9
    add cx, 0x1                                  # 0041b3cd
    mov word ptr [ebp - local_30], cx            # 0041b3d1
L_0041b3d5:
    # block 0x0041b3d5: entered by jmp at 0x0041b3c7, 3 instruction(s), ends with jg to 0x0041b3f3 (forward)
    movsx edx, word ptr [ebp - local_30]         # 0041b3d5
    cmp edx, 0x12                                # 0041b3d9
    jg.d8 L_0041b3f3                             # 0041b3dc
    # block 0x0041b3de: entered by fall-through of jg at 0x0041b3dc, 7 instruction(s), calls FUN_0041b992, ends with backward jump to 0x0041b3c9
    movsx eax, word ptr [ebp - local_4]          # 0041b3de
    movsx ecx, word ptr [ebp - local_30]         # 0041b3e2
    {load} sub eax, ecx                          # 0041b3e6
    push eax                                     # 0041b3e8
    mov ecx, dword ptr [ebp - local_44]          # 0041b3e9
    call FUN_0041b992                            # 0041b3ec
    jmp.d8 L_0041b3c9                            # 0041b3f1
L_0041b3f3:
    # block 0x0041b3f3: entered by jg at 0x0041b3dc, 4 instruction(s), calls FUN_0041b992, falls into the block at 0x0041b400
    movsx edx, word ptr [ebp - local_4]          # 0041b3f3
    push edx                                     # 0041b3f7
    mov ecx, dword ptr [ebp - local_44]          # 0041b3f8
    call FUN_0041b992                            # 0041b3fb
L_0041b400:
    # block 0x0041b400: entered by jg at 0x0041b671, 4 instruction(s), ends with jle to 0x0041b41a (forward)
    movsx eax, word ptr [0x56f34e]               # 0041b400
    movsx ecx, word ptr [ebp - local_3c]         # 0041b407
    {load} cmp eax, ecx                          # 0041b40b
    jle.d8 L_0041b41a                            # 0041b40d
    # block 0x0041b40f: entered by fall-through of jle at 0x0041b40d, 2 instruction(s), falls into the block at 0x0041b41a
    mov dx, word ptr [ebp - local_3c]            # 0041b40f
    mov word ptr [0x56f34e], dx                  # 0041b413
L_0041b41a:
    # block 0x0041b41a: entered by jle at 0x0041b40d, 3 instruction(s), ends with jg to 0x0041b458 (forward)
    movsx eax, word ptr [0x56f34e]               # 0041b41a
    cmp eax, 0x2                                 # 0041b421
    jg.d8 L_0041b458                             # 0041b424
    # block 0x0041b426: entered by fall-through of jg at 0x0041b424, 12 instruction(s), ends with forward jump to 0x0041b4a1
    mov word ptr [0x56f34e], 0x1                 # 0041b426
    mov cl, byte ptr [ebp - local_2c]            # 0041b42f
    or cl, byte ptr [ebp - local_38]             # 0041b432
    mov byte ptr [ebp - local_2c], cl            # 0041b435
    movsx edx, word ptr [ebp - local_4]          # 0041b438
    movsx eax, word ptr [ebp - local_40]         # 0041b43c
    mov cl, byte ptr [edx + 0x56f354]            # 0041b440
    mov byte ptr [ebp + eax - local_2c], cl      # 0041b446
    mov dx, word ptr [ebp - local_40]            # 0041b44a
    add dx, 0x1                                  # 0041b44e
    mov word ptr [ebp - local_40], dx            # 0041b452
    jmp.d8 L_0041b4a1                            # 0041b456
L_0041b458:
    # block 0x0041b458: entered by jg at 0x0041b424, 17 instruction(s), falls into the block at 0x0041b4a1
    movsx eax, word ptr [ebp - local_40]         # 0041b458
    mov cl, byte ptr [0x56f350]                  # 0041b45c
    mov byte ptr [ebp + eax - local_2c], cl      # 0041b462
    mov dx, word ptr [ebp - local_40]            # 0041b466
    add dx, 0x1                                  # 0041b46a
    mov word ptr [ebp - local_40], dx            # 0041b46e
    movsx eax, word ptr [0x56f350]               # 0041b472
    sar eax, 0x4                                 # 0041b479
    and eax, 0xf0                                # 0041b47c
    movsx ecx, word ptr [0x56f34e]               # 0041b481
    sub ecx, 0x3                                 # 0041b488
    {load} or eax, ecx                           # 0041b48b
    movsx edx, word ptr [ebp - local_40]         # 0041b48d
    mov byte ptr [ebp + edx - local_2c], al      # 0041b491
    mov ax, word ptr [ebp - local_40]            # 0041b495
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041b499
    mov word ptr [ebp - local_40], ax            # 0041b49d
L_0041b4a1:
    # block 0x0041b4a1: entered by jmp at 0x0041b456, 7 instruction(s), ends with jne to 0x0041b51d (forward)
    mov cl, byte ptr [ebp - local_38]            # 0041b4a1
    shl cl                                       # 0041b4a4
    mov byte ptr [ebp - local_38], cl            # 0041b4a6
    mov edx, dword ptr [ebp - local_38]          # 0041b4a9
    and edx, 0xff                                # 0041b4ac
    test edx, edx                                # 0041b4b2
    jne.d8 L_0041b51d                            # 0041b4b4
    # block 0x0041b4b6: entered by fall-through of jne at 0x0041b4b4, 2 instruction(s), ends with forward jump to 0x0041b4ca
    mov word ptr [ebp - local_30], 0x0           # 0041b4b6
    jmp.d8 L_0041b4ca                            # 0041b4bc
L_0041b4be:
    # block 0x0041b4be: entered by jmp at 0x0041b4fa, 3 instruction(s), falls into the block at 0x0041b4ca
    mov ax, word ptr [ebp - local_30]            # 0041b4be
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041b4c2
    mov word ptr [ebp - local_30], ax            # 0041b4c6
L_0041b4ca:
    # block 0x0041b4ca: entered by jmp at 0x0041b4bc, 4 instruction(s), ends with jge to 0x0041b4fc (forward)
    movsx ecx, word ptr [ebp - local_30]         # 0041b4ca
    movsx edx, word ptr [ebp - local_40]         # 0041b4ce
    {load} cmp ecx, edx                          # 0041b4d2
    jge.d8 L_0041b4fc                            # 0041b4d4
    # block 0x0041b4d6: entered by fall-through of jge at 0x0041b4d4, 12 instruction(s), ends with backward jump to 0x0041b4be
    movsx eax, word ptr [ebp - local_30]         # 0041b4d6
    mov cl, byte ptr [ebp + eax - local_2c]      # 0041b4da
    add cl, byte ptr [ebp - local_18]            # 0041b4de
    movsx edx, word ptr [ebp - local_30]         # 0041b4e1
    mov byte ptr [ebp + edx - local_2c], cl      # 0041b4e5
    mov al, byte ptr [ebp - local_18]            # 0041b4e9
    add al, 0x1                                  # 0041b4ec
    mov byte ptr [ebp - local_18], al            # 0041b4ee
    mov ecx, dword ptr [ebp - local_8]           # 0041b4f1
    add ecx, 0x1                                 # 0041b4f4
    mov dword ptr [ebp - local_8], ecx           # 0041b4f7
    jmp.d8 L_0041b4be                            # 0041b4fa
L_0041b4fc:
    # block 0x0041b4fc: entered by jge at 0x0041b4d4, 8 instruction(s), falls into the block at 0x0041b51d
    movsx edx, word ptr [ebp - local_40]         # 0041b4fc
    mov eax, dword ptr [0x57036c]                # 0041b500
    {load} add eax, edx                          # 0041b505
    mov dword ptr [0x57036c], eax                # 0041b507
    mov byte ptr [ebp - local_2c], 0x0           # 0041b50c
    mov byte ptr [ebp - local_38], 0x1           # 0041b510
    movzx cx, byte ptr [ebp - local_38]          # 0041b514
    mov word ptr [ebp - local_40], cx            # 0041b519
L_0041b51d:
    # block 0x0041b51d: entered by jne at 0x0041b4b4, 4 instruction(s), ends with forward jump to 0x0041b53c
    mov dx, word ptr [0x56f34e]                  # 0041b51d
    mov word ptr [ebp - local_34], dx            # 0041b524
    mov word ptr [ebp - local_30], 0x0           # 0041b528
    jmp.d8 L_0041b53c                            # 0041b52e
L_0041b530:
    # block 0x0041b530: entered by jmp at 0x0041b5cc, 3 instruction(s), falls into the block at 0x0041b53c
    mov ax, word ptr [ebp - local_30]            # 0041b530
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041b534
    mov word ptr [ebp - local_30], ax            # 0041b538
L_0041b53c:
    # block 0x0041b53c: entered by jmp at 0x0041b52e, 4 instruction(s), ends with jge to 0x0041b5d1 (forward)
    movsx ecx, word ptr [ebp - local_30]         # 0041b53c
    movsx edx, word ptr [ebp - local_34]         # 0041b540
    {load} cmp ecx, edx                          # 0041b544
    jge.d32 L_0041b5d1                           # 0041b546
    # block 0x0041b54c: entered by fall-through of jge at 0x0041b546, 3 instruction(s), ends with jl to 0x0041b556 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0041b54c
    cmp eax, dword ptr [ebp + arg_c]             # 0041b54f
    jl.d8 L_0041b556                             # 0041b552
    # block 0x0041b554: entered by fall-through of jl at 0x0041b552, 1 instruction(s), ends with forward jump to 0x0041b5d1
    jmp.d8 L_0041b5d1                            # 0041b554
L_0041b556:
    # block 0x0041b556: entered by jl at 0x0041b552, 17 instruction(s), calls FUN_0041bbd9, ends with jge to 0x0041b59d (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 0041b556
    add ecx, dword ptr [ebp - local_c]           # 0041b559
    movsx dx, byte ptr [ecx]                     # 0041b55c
    mov word ptr [ebp - local_14], dx            # 0041b560
    mov eax, dword ptr [ebp - local_c]           # 0041b564
    add eax, 0x1                                 # 0041b567
    mov dword ptr [ebp - local_c], eax           # 0041b56a
    movsx ecx, word ptr [ebp - local_10]         # 0041b56d
    push ecx                                     # 0041b571
    mov ecx, dword ptr [ebp - local_44]          # 0041b572
    call FUN_0041bbd9                            # 0041b575
    movsx edx, word ptr [ebp - local_10]         # 0041b57a
    mov al, byte ptr [ebp - local_14]            # 0041b57e
    mov byte ptr [edx + 0x56f354], al            # 0041b581
    movsx ecx, word ptr [ebp - local_10]         # 0041b587
    cmp ecx, 0x11                                # 0041b58b
    jge.d8 L_0041b59d                            # 0041b58e
    # block 0x0041b590: entered by fall-through of jge at 0x0041b58e, 3 instruction(s), falls into the block at 0x0041b59d
    movsx edx, word ptr [ebp - local_10]         # 0041b590
    mov al, byte ptr [ebp - local_14]            # 0041b594
    mov byte ptr [edx + 0x570354], al            # 0041b597
L_0041b59d:
    # block 0x0041b59d: entered by jge at 0x0041b58e, 13 instruction(s), calls FUN_0041b992, ends with backward jump to 0x0041b530
    movsx ecx, word ptr [ebp - local_10]         # 0041b59d
    add ecx, 0x1                                 # 0041b5a1
    and ecx, 0xfff                               # 0041b5a4
    mov word ptr [ebp - local_10], cx            # 0041b5aa
    movsx edx, word ptr [ebp - local_4]          # 0041b5ae
    add edx, 0x1                                 # 0041b5b2
    and edx, 0xfff                               # 0041b5b5
    mov word ptr [ebp - local_4], dx             # 0041b5bb
    movsx eax, word ptr [ebp - local_4]          # 0041b5bf
    push eax                                     # 0041b5c3
    mov ecx, dword ptr [ebp - local_44]          # 0041b5c4
    call FUN_0041b992                            # 0041b5c7
    jmp.d32 L_0041b530                           # 0041b5cc
L_0041b5d1:
    # block 0x0041b5d1: entered by jge at 0x0041b546; jmp at 0x0041b554, 7 instruction(s), ends with jbe to 0x0041b602 (forward)
    movsx ecx, word ptr [ebp - local_30]         # 0041b5d1
    mov edx, dword ptr [0x570368]                # 0041b5d5
    {load} add edx, ecx                          # 0041b5db
    mov dword ptr [0x570368], edx                # 0041b5dd
    mov eax, dword ptr [0x570368]                # 0041b5e3
    cmp eax, dword ptr [0x570370]                # 0041b5e8
    jbe.d8 L_0041b602                            # 0041b5ee
    # block 0x0041b5f0: entered by fall-through of jbe at 0x0041b5ee, 3 instruction(s), falls into the block at 0x0041b602
    mov ecx, dword ptr [0x570370]                # 0041b5f0
    add ecx, 0x400                               # 0041b5f6
    mov dword ptr [0x570370], ecx                # 0041b5fc
L_0041b602:
    # block 0x0041b602: entered by jbe at 0x0041b5ee; jmp at 0x0041b669, 7 instruction(s), ends with jge to 0x0041b66b (forward)
    movsx edx, word ptr [ebp - local_30]         # 0041b602
    movsx eax, word ptr [ebp - local_34]         # 0041b606
    mov cx, word ptr [ebp - local_30]            # 0041b60a
    add cx, 0x1                                  # 0041b60e
    mov word ptr [ebp - local_30], cx            # 0041b612
    {load} cmp edx, eax                          # 0041b616
    jge.d8 L_0041b66b                            # 0041b618
    # block 0x0041b61a: entered by fall-through of jge at 0x0041b618, 18 instruction(s), calls FUN_0041bbd9, ends with je to 0x0041b669 (forward)
    movsx edx, word ptr [ebp - local_10]         # 0041b61a
    push edx                                     # 0041b61e
    mov ecx, dword ptr [ebp - local_44]          # 0041b61f
    call FUN_0041bbd9                            # 0041b622
    movsx eax, word ptr [ebp - local_10]         # 0041b627
    add eax, 0x1                                 # 0041b62b
    and eax, 0xfff                               # 0041b62e
    mov word ptr [ebp - local_10], ax            # 0041b633
    movsx ecx, word ptr [ebp - local_4]          # 0041b637
    add ecx, 0x1                                 # 0041b63b
    and ecx, 0xfff                               # 0041b63e
    mov word ptr [ebp - local_4], cx             # 0041b644
    mov dx, word ptr [ebp - local_3c]            # 0041b648
    sub dx, 0x1                                  # 0041b64c
    mov word ptr [ebp - local_3c], dx            # 0041b650
    movsx eax, word ptr [ebp - local_3c]         # 0041b654
    test eax, eax                                # 0041b658
    je.d8 L_0041b669                             # 0041b65a
    # block 0x0041b65c: entered by fall-through of je at 0x0041b65a, 4 instruction(s), calls FUN_0041b992, falls into the block at 0x0041b669
    movsx ecx, word ptr [ebp - local_4]          # 0041b65c
    push ecx                                     # 0041b660
    mov ecx, dword ptr [ebp - local_44]          # 0041b661
    call FUN_0041b992                            # 0041b664
L_0041b669:
    # block 0x0041b669: entered by je at 0x0041b65a, 1 instruction(s), ends with backward jump to 0x0041b602
    jmp.d8 L_0041b602                            # 0041b669
L_0041b66b:
    # block 0x0041b66b: entered by jge at 0x0041b618, 3 instruction(s), ends with jg to 0x0041b400 (backward)
    movsx edx, word ptr [ebp - local_3c]         # 0041b66b
    test edx, edx                                # 0041b66f
    jg.d32 L_0041b400                            # 0041b671
    # block 0x0041b677: entered by fall-through of jg at 0x0041b671, 3 instruction(s), ends with jle to 0x0041b6d9 (forward)
    movsx eax, word ptr [ebp - local_40]         # 0041b677
    cmp eax, 0x1                                 # 0041b67b
    jle.d8 L_0041b6d9                            # 0041b67e
    # block 0x0041b680: entered by fall-through of jle at 0x0041b67e, 2 instruction(s), ends with forward jump to 0x0041b694
    mov word ptr [ebp - local_30], 0x0           # 0041b680
    jmp.d8 L_0041b694                            # 0041b686
L_0041b688:
    # block 0x0041b688: entered by jmp at 0x0041b6c5, 3 instruction(s), falls into the block at 0x0041b694
    mov cx, word ptr [ebp - local_30]            # 0041b688
    add cx, 0x1                                  # 0041b68c
    mov word ptr [ebp - local_30], cx            # 0041b690
L_0041b694:
    # block 0x0041b694: entered by jmp at 0x0041b686, 4 instruction(s), ends with jge to 0x0041b6c7 (forward)
    movsx edx, word ptr [ebp - local_30]         # 0041b694
    movsx eax, word ptr [ebp - local_40]         # 0041b698
    {load} cmp edx, eax                          # 0041b69c
    jge.d8 L_0041b6c7                            # 0041b69e
    # block 0x0041b6a0: entered by fall-through of jge at 0x0041b69e, 12 instruction(s), ends with backward jump to 0x0041b688
    movsx ecx, word ptr [ebp - local_30]         # 0041b6a0
    mov dl, byte ptr [ebp + ecx - local_2c]      # 0041b6a4
    add dl, byte ptr [ebp - local_18]            # 0041b6a8
    movsx eax, word ptr [ebp - local_30]         # 0041b6ab
    mov byte ptr [ebp + eax - local_2c], dl      # 0041b6af
    mov cl, byte ptr [ebp - local_18]            # 0041b6b3
    add cl, 0x1                                  # 0041b6b6
    mov byte ptr [ebp - local_18], cl            # 0041b6b9
    mov edx, dword ptr [ebp - local_8]           # 0041b6bc
    add edx, 0x1                                 # 0041b6bf
    mov dword ptr [ebp - local_8], edx           # 0041b6c2
    jmp.d8 L_0041b688                            # 0041b6c5
L_0041b6c7:
    # block 0x0041b6c7: entered by jge at 0x0041b69e, 4 instruction(s), falls into the block at 0x0041b6d9
    movsx eax, word ptr [ebp - local_40]         # 0041b6c7
    mov ecx, dword ptr [0x57036c]                # 0041b6cb
    {load} add ecx, eax                          # 0041b6d1
    mov dword ptr [0x57036c], ecx                # 0041b6d3
L_0041b6d9:
    # block 0x0041b6d9: entered by jle at 0x0041b67e, 1 instruction(s), falls into the block at 0x0041b6dc
    mov eax, dword ptr [ebp - local_8]           # 0041b6d9
L_0041b6dc:
    # block 0x0041b6dc: entered by jmp at 0x0041b3bc, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 0041b6dc
    pop ebp                                      # 0041b6de
    ret 0x8                                      # 0041b6df

