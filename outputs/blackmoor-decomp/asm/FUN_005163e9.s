# FUN_005163e9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005163e9
# extent:       0x005163e9-0x00516529 (320 code bytes)
# span:         0x005163e9-0x00516530 (code 320, tables 0, padding 7)
# sha256:       aa2f39fa694f93d1646ac2f2255714673d76f1d7a16720b03fb53b01b0ce9dac
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005163e9
# arguments:    11 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c, arg_20, arg_24, arg_28, arg_2c, arg_30; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_1; [ebx + n] field_minus_1; [ecx + n] field_minus_7; [edx + n] field_minus_63db
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 101 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ field_minus_7, 0x7  # offset -0x7
.equ field_minus_63db, 0x63db  # offset -0x63db
.equ field_1, 0x1  # offset +0x1
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ arg_20, 0x20  # offset +0x20
.equ arg_24, 0x24  # offset +0x24
.equ arg_28, 0x28  # offset +0x28
.equ arg_2c, 0x2c  # offset +0x2c
.equ arg_30, 0x30  # offset +0x30

# --- external targets -----------------------------------------------

.org 0x005163e9 - 0x401000
.globl FUN_005163e9
FUN_005163e9:
    # block 0x005163e9: entry, 7 instruction(s), ends with jne to 0x00516484 (forward)
    push ebp                                     # 005163e9
    {load} mov ebp, esp                          # 005163ea
    cmp dword ptr [ebp + arg_c], 0x1             # 005163ec
    push ebx                                     # 005163f0
    mov ebx, dword ptr [ebp + arg_10]            # 005163f1
    push esi                                     # 005163f4
    jne.d32 L_00516484                           # 005163f5
    # block 0x005163fb: entered by fall-through of jne at 0x005163f5, 5 instruction(s), ends with jne to 0x00516414 (forward)
    mov eax, dword ptr [ebp + arg_14]            # 005163fb
    mov dword ptr [ebp + arg_10], ebx            # 005163fe
    and dword ptr [ebp + arg_10], 0x3            # 00516401
    {load} mov esi, eax                          # 00516405
    jne.d8 L_00516414                            # 00516407
    # block 0x00516409: entered by fall-through of jne at 0x00516407, 3 instruction(s), ends with forward jump to 0x0051641d
    shl esi, 0x2                                 # 00516409
    mov eax, dword ptr [esi + 0x568c30]          # 0051640c
    jmp.d8 L_0051641d                            # 00516412
L_00516414:
    # block 0x00516414: entered by jne at 0x00516407, 2 instruction(s), falls into the block at 0x0051641d
    shl esi, 0x2                                 # 00516414
    mov eax, dword ptr [esi + 0x568c64]          # 00516417
L_0051641d:
    # block 0x0051641d: entered by jmp at 0x00516412, 17 instruction(s), ends with jge to 0x00516457 (forward)
    {load} mov edx, ebx                          # 0051641d
    lea ecx, [eax + field_1]                     # 0051641f
    imul edx, edx, 0x16d                         # 00516422
    lea eax, [ebx - field_minus_1]               # 00516428
    push edi                                     # 0051642b
    sar eax, 0x2                                 # 0051642c
    {load} mov edi, ecx                          # 0051642f
    push 0x7                                     # 00516431
    {load} add edi, eax                          # 00516433
    lea eax, [edx + edi - field_minus_63db]      # 00516435
    pop edi                                      # 0051643c
    cdq                                          # 0051643d
    idiv edi                                     # 0051643e
    mov eax, dword ptr [ebp + arg_18]            # 00516440
    pop edi                                      # 00516443
    cmp edx, dword ptr [ebp + arg_1c]            # 00516444
    jge.d8 L_00516457                            # 00516447
    # block 0x00516449: entered by fall-through of jge at 0x00516447, 5 instruction(s), ends with forward jump to 0x00516461
    imul eax, eax, 0x7                           # 00516449
    {load} sub eax, edx                          # 0051644c
    add eax, dword ptr [ebp + arg_1c]            # 0051644e
    lea ecx, [ecx + eax - field_minus_7]         # 00516451
    jmp.d8 L_00516461                            # 00516455
L_00516457:
    # block 0x00516457: entered by jge at 0x00516447, 4 instruction(s), falls into the block at 0x00516461
    imul eax, eax, 0x7                           # 00516457
    {load} sub eax, edx                          # 0051645a
    add eax, dword ptr [ebp + arg_1c]            # 0051645c
    {load} add ecx, eax                          # 0051645f
L_00516461:
    # block 0x00516461: entered by jmp at 0x00516455, 2 instruction(s), ends with jne to 0x0051649f (forward)
    cmp dword ptr [ebp + arg_18], 0x5            # 00516461
    jne.d8 L_0051649f                            # 00516465
    # block 0x00516467: entered by fall-through of jne at 0x00516465, 2 instruction(s), ends with jne to 0x00516475 (forward)
    cmp dword ptr [ebp + arg_10], 0x0            # 00516467
    jne.d8 L_00516475                            # 0051646b
    # block 0x0051646d: entered by fall-through of jne at 0x0051646b, 2 instruction(s), ends with forward jump to 0x0051647b
    mov esi, dword ptr [esi + 0x568c34]          # 0051646d
    jmp.d8 L_0051647b                            # 00516473
L_00516475:
    # block 0x00516475: entered by jne at 0x0051646b, 1 instruction(s), falls into the block at 0x0051647b
    mov esi, dword ptr [esi + 0x568c68]          # 00516475
L_0051647b:
    # block 0x0051647b: entered by jmp at 0x00516473, 2 instruction(s), ends with jle to 0x0051649f (forward)
    {load} cmp ecx, esi                          # 0051647b
    jle.d8 L_0051649f                            # 0051647d
    # block 0x0051647f: entered by fall-through of jle at 0x0051647d, 2 instruction(s), ends with forward jump to 0x0051649f
    sub ecx, 0x7                                 # 0051647f
    jmp.d8 L_0051649f                            # 00516482
L_00516484:
    # block 0x00516484: entered by jne at 0x005163f5, 3 instruction(s), ends with jne to 0x00516495 (forward)
    mov eax, dword ptr [ebp + arg_14]            # 00516484
    test bl, 0x3                                 # 00516487
    jne.d8 L_00516495                            # 0051648a
    # block 0x0051648c: entered by fall-through of jne at 0x0051648a, 2 instruction(s), ends with forward jump to 0x0051649c
    mov ecx, dword ptr [4*eax + 0x568c30]        # 0051648c
    jmp.d8 L_0051649c                            # 00516493
L_00516495:
    # block 0x00516495: entered by jne at 0x0051648a, 1 instruction(s), falls into the block at 0x0051649c
    mov ecx, dword ptr [4*eax + 0x568c64]        # 00516495
L_0051649c:
    # block 0x0051649c: entered by jmp at 0x00516493, 1 instruction(s), falls into the block at 0x0051649f
    add ecx, dword ptr [ebp + arg_20]            # 0051649c
L_0051649f:
    # block 0x0051649f: entered by jne at 0x00516465; jle at 0x0051647d; jmp at 0x00516482, 2 instruction(s), ends with jne to 0x005164d0 (forward)
    cmp dword ptr [ebp + arg_8], 0x1             # 0051649f
    jne.d8 L_005164d0                            # 005164a3
    # block 0x005164a5: entered by fall-through of jne at 0x005164a3, 11 instruction(s), ends with forward jump to 0x00516525
    mov eax, dword ptr [ebp + arg_24]            # 005164a5
    mov dword ptr [0x568c1c], ecx                # 005164a8
    imul eax, eax, 0x3c                          # 005164ae
    add eax, dword ptr [ebp + arg_28]            # 005164b1
    mov dword ptr [0x568c18], ebx                # 005164b4
    imul eax, eax, 0x3c                          # 005164ba
    add eax, dword ptr [ebp + arg_2c]            # 005164bd
    imul eax, eax, 0x3e8                         # 005164c0
    add eax, dword ptr [ebp + arg_30]            # 005164c6
    mov dword ptr [0x568c20], eax                # 005164c9
    jmp.d8 L_00516525                            # 005164ce
L_005164d0:
    # block 0x005164d0: entered by jne at 0x005164a3, 11 instruction(s), ends with jns to 0x00516508 (forward)
    mov eax, dword ptr [ebp + arg_24]            # 005164d0
    mov dword ptr [0x568c2c], ecx                # 005164d3
    imul eax, eax, 0x3c                          # 005164d9
    add eax, dword ptr [ebp + arg_28]            # 005164dc
    imul eax, eax, 0x3c                          # 005164df
    add eax, dword ptr [0x568b88]                # 005164e2
    add eax, dword ptr [ebp + arg_2c]            # 005164e8
    imul eax, eax, 0x3e8                         # 005164eb
    add eax, dword ptr [ebp + arg_30]            # 005164f1
    mov dword ptr [0x568c30], eax                # 005164f4
    jns.d8 L_00516508                            # 005164f9
    # block 0x005164fb: entered by fall-through of jns at 0x005164f9, 4 instruction(s), ends with forward jump to 0x00516519
    add eax, 0x5265c00                           # 005164fb
    dec ecx                                      # 00516500
    mov dword ptr [0x568c30], eax                # 00516501
    jmp.d8 L_00516519                            # 00516506
L_00516508:
    # block 0x00516508: entered by jns at 0x005164f9, 3 instruction(s), ends with jl to 0x0051651f (forward)
    mov edx, 0x5265c00                           # 00516508
    {load} cmp eax, edx                          # 0051650d
    jl.d8 L_0051651f                             # 0051650f
    # block 0x00516511: entered by fall-through of jl at 0x0051650f, 3 instruction(s), falls into the block at 0x00516519
    {load} sub eax, edx                          # 00516511
    inc ecx                                      # 00516513
    mov dword ptr [0x568c30], eax                # 00516514
L_00516519:
    # block 0x00516519: entered by jmp at 0x00516506, 1 instruction(s), falls into the block at 0x0051651f
    mov dword ptr [0x568c2c], ecx                # 00516519
L_0051651f:
    # block 0x0051651f: entered by jl at 0x0051650f, 1 instruction(s), falls into the block at 0x00516525
    mov dword ptr [0x568c28], ebx                # 0051651f
L_00516525:
    # block 0x00516525: entered by jmp at 0x005164ce, 4 instruction(s), ends with ret
    pop esi                                      # 00516525
    pop ebx                                      # 00516526
    pop ebp                                      # 00516527
    ret                                          # 00516528

# --- data items (not part of the function) -------------------------
.org 0x00516529 - 0x401000
PAD_00516529:  # 7 byte(s) of int3 padding
    .fill 7, 1, 0xcc

