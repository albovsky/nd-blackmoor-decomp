# FUN_00473206
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00473206
# extent:       0x00473206-0x00473651 (1099 code bytes)
# span:         0x00473206-0x00473651 (code 1099, tables 0, padding 0)
# sha256:       e754ee96891c3c4375ac79094eafa610e3408c5a7562a2d3f126ecf93c1bf6e3
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00473206
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_c, field_e, field_76, field_104, field_106, field_335, field_339, field_341, field_345, field_347, field_371; [ecx + n] field_e, field_104, field_335, field_339, field_33d, field_341, field_347, field_371, field_4ef, field_4f3, field_4f7, field_4fb and 1 more; [edx + n] field_e, field_76, field_7a, field_335, field_339, field_345, field_347, field_375, field_minus_1
# callees:      calls FUN_004e22fd, FUN_00473651, FUN_004d5316, FUN_004eb184, FUN_0047409e, KERNEL32.dll!GetTickCount, FUN_0047512a, FUN_00473f7d
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 257 instruction(s), 20 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ field_e, 0xe  # offset +0xe
.equ field_76, 0x76  # offset +0x76
.equ field_7a, 0x7a  # offset +0x7a
.equ field_104, 0x104  # offset +0x104
.equ field_106, 0x106  # offset +0x106
.equ field_335, 0x335  # offset +0x335
.equ field_339, 0x339  # offset +0x339
.equ field_33d, 0x33d  # offset +0x33d
.equ field_341, 0x341  # offset +0x341
.equ field_345, 0x345  # offset +0x345
.equ field_347, 0x347  # offset +0x347
.equ field_371, 0x371  # offset +0x371
.equ field_375, 0x375  # offset +0x375
.equ field_4ef, 0x4ef  # offset +0x4ef
.equ field_4f3, 0x4f3  # offset +0x4f3
.equ field_4f7, 0x4f7  # offset +0x4f7
.equ field_4fb, 0x4fb  # offset +0x4fb

# --- external targets -----------------------------------------------
.set FUN_00473651, .text + (0x00473651 - 0x401000)
.set FUN_00473f7d, .text + (0x00473f7d - 0x401000)
.set FUN_0047409e, .text + (0x0047409e - 0x401000)
.set FUN_0047512a, .text + (0x0047512a - 0x401000)
.set FUN_004d5316, .text + (0x004d5316 - 0x401000)
.set FUN_004e22fd, .text + (0x004e22fd - 0x401000)
.set FUN_004eb184, .text + (0x004eb184 - 0x401000)

.org 0x00473206 - 0x401000
.globl FUN_00473206
FUN_00473206:
    # block 0x00473206: entry, 15 instruction(s), ends with je to 0x00473649 (forward)
    push ebp                                     # 00473206
    {load} mov ebp, esp                          # 00473207
    sub esp, 0x8                                 # 00473209
    mov dword ptr [ebp - local_8], ecx           # 0047320c
    mov eax, dword ptr [ebp - local_8]           # 0047320f
    movsx ecx, word ptr [eax + field_c]          # 00473212
    imul ecx, ecx, 0x8d                          # 00473216
    mov edx, dword ptr [ebp - local_8]           # 0047321c
    mov eax, dword ptr [ecx + 0x5bb5e5]          # 0047321f
    mov dword ptr [edx + field_76], eax          # 00473225
    mov ecx, dword ptr [ebp - local_8]           # 00473228
    mov word ptr [ecx + field_e], 0xffff         # 0047322b
    mov edx, dword ptr [ebp - local_8]           # 00473231
    cmp dword ptr [edx + field_7a], 0x0          # 00473234
    je.d32 L_00473649                            # 00473238
    # block 0x0047323e: entered by fall-through of je at 0x00473238, 67 instruction(s), calls FUN_004e22fd, ends with je to 0x00473373 (forward)
    mov eax, dword ptr [0x5b44f0]                # 0047323e
    shl eax, 0x4                                 # 00473243
    mov ecx, dword ptr [0x5b44f4]                # 00473246
    mov edx, dword ptr [0x583102]                # 0047324c
    add edx, dword ptr [eax + 8*ecx + 0x5b3e40]  # 00473252
    mov eax, dword ptr [ebp - local_8]           # 00473259
    mov dword ptr [eax + field_335], edx         # 0047325c
    mov ecx, dword ptr [0x5b44f4]                # 00473262
    shl ecx, 0x2                                 # 00473268
    mov edx, dword ptr [0x5b44f0]                # 0047326b
    movsx eax, word ptr [ecx + 8*edx + 0x5b3ae8] # 00473271
    mov ecx, dword ptr [ebp - local_8]           # 00473279
    mov edx, dword ptr [ecx + field_335]         # 0047327c
    lea eax, [edx + eax - field_minus_1]         # 00473282
    mov ecx, dword ptr [ebp - local_8]           # 00473286
    mov dword ptr [ecx + field_33d], eax         # 00473289
    mov edx, dword ptr [0x5b44f0]                # 0047328f
    shl edx, 0x4                                 # 00473295
    mov eax, dword ptr [0x5b44f4]                # 00473298
    mov ecx, dword ptr [0x583106]                # 0047329d
    add ecx, dword ptr [edx + 8*eax + 0x5b3e44]  # 004732a3
    mov edx, dword ptr [ebp - local_8]           # 004732aa
    mov dword ptr [edx + field_339], ecx         # 004732ad
    mov eax, dword ptr [0x5b44f4]                # 004732b3
    shl eax, 0x2                                 # 004732b8
    mov ecx, dword ptr [0x5b44f0]                # 004732bb
    movsx edx, word ptr [eax + 8*ecx + 0x5b3aea] # 004732c1
    mov eax, dword ptr [ebp - local_8]           # 004732c9
    mov ecx, dword ptr [eax + field_339]         # 004732cc
    lea edx, [ecx + edx - field_minus_1]         # 004732d2
    mov eax, dword ptr [ebp - local_8]           # 004732d6
    mov dword ptr [eax + field_341], edx         # 004732d9
    mov ecx, dword ptr [ebp - local_8]           # 004732df
    mov edx, dword ptr [ebp - local_8]           # 004732e2
    mov eax, dword ptr [ecx + field_33d]         # 004732e5
    sub eax, dword ptr [edx + field_335]         # 004732eb
    cdq                                          # 004732f1
    {load} sub eax, edx                          # 004732f2
    sar eax                                      # 004732f4
    mov ecx, dword ptr [ebp - local_8]           # 004732f6
    mov edx, dword ptr [ecx + field_335]         # 004732f9
    {load} add edx, eax                          # 004732ff
    mov eax, dword ptr [ebp - local_8]           # 00473301
    mov word ptr [eax + field_345], dx           # 00473304
    mov ecx, dword ptr [ebp - local_8]           # 0047330b
    mov edx, dword ptr [ebp - local_8]           # 0047330e
    mov eax, dword ptr [ecx + field_341]         # 00473311
    sub eax, dword ptr [edx + field_339]         # 00473317
    cdq                                          # 0047331d
    {load} sub eax, edx                          # 0047331e
    sar eax                                      # 00473320
    mov ecx, dword ptr [ebp - local_8]           # 00473322
    mov edx, dword ptr [ecx + field_339]         # 00473325
    {load} add edx, eax                          # 0047332b
    mov eax, dword ptr [ebp - local_8]           # 0047332d
    mov word ptr [eax + field_347], dx           # 00473330
    mov ecx, dword ptr [ebp - local_8]           # 00473337
    mov dx, word ptr [ecx + field_347]           # 0047333a
    push edx                                     # 00473341
    mov eax, dword ptr [ebp - local_8]           # 00473342
    mov cx, word ptr [eax + field_345]           # 00473345
    push ecx                                     # 0047334c
    mov ecx, dword ptr [ebp - local_8]           # 0047334d
    add ecx, 0x1a6                               # 00473350
    call FUN_004e22fd                            # 00473356
    test eax, eax                                # 0047335b
    je.d8 L_00473373                             # 0047335d
    # block 0x0047335f: entered by fall-through of je at 0x0047335d, 3 instruction(s), ends with forward jump to 0x0047364b
    mov dword ptr [0x5c39e5], 0x27a3             # 0047335f
    mov eax, 0x1                                 # 00473369
    jmp.d32 L_0047364b                           # 0047336e
L_00473373:
    # block 0x00473373: entered by je at 0x0047335d, 5 instruction(s), ends with jl to 0x0047341f (forward)
    movsx edx, word ptr [ebp + arg_c]            # 00473373
    mov eax, dword ptr [ebp - local_8]           # 00473377
    mov ecx, dword ptr [eax + field_76]          # 0047337a
    cmp edx, dword ptr [ecx + field_4f3]         # 0047337d
    jl.d32 L_0047341f                            # 00473383
    # block 0x00473389: entered by fall-through of jl at 0x00473383, 5 instruction(s), ends with jg to 0x0047341f (forward)
    movsx edx, word ptr [ebp + arg_c]            # 00473389
    mov eax, dword ptr [ebp - local_8]           # 0047338d
    mov ecx, dword ptr [eax + field_76]          # 00473390
    cmp edx, dword ptr [ecx + field_4fb]         # 00473393
    jg.d32 L_0047341f                            # 00473399
    # block 0x0047339f: entered by fall-through of jg at 0x00473399, 5 instruction(s), ends with jl to 0x0047341f (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0047339f
    mov eax, dword ptr [ebp - local_8]           # 004733a3
    mov ecx, dword ptr [eax + field_76]          # 004733a6
    cmp edx, dword ptr [ecx + field_4ef]         # 004733a9
    jl.d8 L_0047341f                             # 004733af
    # block 0x004733b1: entered by fall-through of jl at 0x004733af, 5 instruction(s), ends with jg to 0x0047341f (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004733b1
    mov eax, dword ptr [ebp - local_8]           # 004733b5
    mov ecx, dword ptr [eax + field_76]          # 004733b8
    cmp edx, dword ptr [ecx + field_4f7]         # 004733bb
    jg.d8 L_0047341f                             # 004733c1
    # block 0x004733c3: entered by fall-through of jg at 0x004733c1, 14 instruction(s), ends with forward jump to 0x0047364b
    mov dword ptr [0x5b44f0], 0x9                # 004733c3
    mov dword ptr [0x5b44f4], 0x1                # 004733cd
    mov edx, dword ptr [0x5d0377]                # 004733d7
    mov dword ptr [0x5d162d], edx                # 004733dd
    mov eax, dword ptr [0x5b44f0]                # 004733e3
    shl eax, 0x5                                 # 004733e8
    mov ecx, dword ptr [0x5b44f4]                # 004733eb
    shl ecx, 0x4                                 # 004733f1
    lea edx, [eax + ecx + 0x5b160c]              # 004733f4
    mov dword ptr [0x5d1631], edx                # 004733fb
    mov dword ptr [0x5d1639], 0x1                # 00473401
    mov dword ptr [0x5c39e5], 0x27a1             # 0047340b
    mov eax, 0x1                                 # 00473415
    jmp.d32 L_0047364b                           # 0047341a
L_0047341f:
    # block 0x0047341f: entered by jl at 0x00473383; jg at 0x00473399; jl at 0x004733af; jg at 0x004733c1, 4 instruction(s), calls FUN_00473651, ends with forward jump to 0x00473439
    mov ecx, dword ptr [ebp - local_8]           # 0047341f
    call FUN_00473651                            # 00473422
    mov dword ptr [ebp - local_4], 0x0           # 00473427
    jmp.d8 L_00473439                            # 0047342e
L_00473430:
    # block 0x00473430: entered by jmp at 0x00473506, 3 instruction(s), falls into the block at 0x00473439
    mov eax, dword ptr [ebp - local_4]           # 00473430
    add eax, 0x1                                 # 00473433
    mov dword ptr [ebp - local_4], eax           # 00473436
L_00473439:
    # block 0x00473439: entered by jmp at 0x0047342e, 2 instruction(s), ends with jge to 0x0047350b (forward)
    cmp dword ptr [ebp - local_4], 0x4           # 00473439
    jge.d32 L_0047350b                           # 0047343d
    # block 0x00473443: entered by fall-through of jge at 0x0047343d, 3 instruction(s), ends with jne to 0x00473506 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00473443
    cmp dword ptr [4*ecx + 0x5a4b4e], 0x0        # 00473446
    jne.d32 L_00473506                           # 0047344e
    # block 0x00473454: entered by fall-through of jne at 0x0047344e, 5 instruction(s), ends with je to 0x004734d4 (forward)
    mov edx, dword ptr [ebp - local_8]           # 00473454
    mov eax, dword ptr [edx + field_76]          # 00473457
    movsx ecx, byte ptr [eax + field_106]        # 0047345a
    test ecx, ecx                                # 00473461
    je.d8 L_004734d4                             # 00473463
    # block 0x00473465: entered by fall-through of je at 0x00473463, 6 instruction(s), ends with jl to 0x004734d2 (forward)
    mov edx, dword ptr [ebp - local_8]           # 00473465
    movsx eax, word ptr [edx + field_347]        # 00473468
    mov ecx, dword ptr [ebp - local_4]           # 0047346f
    shl ecx, 0x4                                 # 00473472
    cmp eax, dword ptr [ecx + 0x5a4b62]          # 00473475
    jl.d8 L_004734d2                             # 0047347b
    # block 0x0047347d: entered by fall-through of jl at 0x0047347b, 6 instruction(s), ends with jg to 0x004734d2 (forward)
    mov edx, dword ptr [ebp - local_8]           # 0047347d
    movsx eax, word ptr [edx + field_347]        # 00473480
    mov ecx, dword ptr [ebp - local_4]           # 00473487
    shl ecx, 0x4                                 # 0047348a
    cmp eax, dword ptr [ecx + 0x5a4b6a]          # 0047348d
    jg.d8 L_004734d2                             # 00473493
    # block 0x00473495: entered by fall-through of jg at 0x00473493, 6 instruction(s), ends with jl to 0x004734d2 (forward)
    mov edx, dword ptr [ebp - local_8]           # 00473495
    movsx eax, word ptr [edx + field_345]        # 00473498
    mov ecx, dword ptr [ebp - local_4]           # 0047349f
    shl ecx, 0x4                                 # 004734a2
    cmp eax, dword ptr [ecx + 0x5a4b5e]          # 004734a5
    jl.d8 L_004734d2                             # 004734ab
    # block 0x004734ad: entered by fall-through of jl at 0x004734ab, 6 instruction(s), ends with jg to 0x004734d2 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004734ad
    movsx eax, word ptr [edx + field_345]        # 004734b0
    mov ecx, dword ptr [ebp - local_4]           # 004734b7
    shl ecx, 0x4                                 # 004734ba
    cmp eax, dword ptr [ecx + 0x5a4b66]          # 004734bd
    jg.d8 L_004734d2                             # 004734c3
    # block 0x004734c5: entered by fall-through of jg at 0x004734c3, 4 instruction(s), ends with forward jump to 0x0047350b
    mov edx, dword ptr [ebp - local_8]           # 004734c5
    mov ax, word ptr [ebp - local_4]             # 004734c8
    mov word ptr [edx + field_e], ax             # 004734cc
    jmp.d8 L_0047350b                            # 004734d0
L_004734d2:
    # block 0x004734d2: entered by jl at 0x0047347b; jg at 0x00473493; jl at 0x004734ab; jg at 0x004734c3, 1 instruction(s), ends with forward jump to 0x00473506
    jmp.d8 L_00473506                            # 004734d2
L_004734d4:
    # block 0x004734d4: entered by je at 0x00473463, 11 instruction(s), calls FUN_004d5316, ends with je to 0x00473506 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004734d4
    add ecx, 0x335                               # 004734d7
    push ecx                                     # 004734dd
    mov edx, dword ptr [ebp - local_4]           # 004734de
    shl edx, 0x4                                 # 004734e1
    add edx, 0x5a4b5e                            # 004734e4
    push edx                                     # 004734ea
    mov ecx, 0x570450                            # 004734eb
    call FUN_004d5316                            # 004734f0
    test eax, eax                                # 004734f5
    je.d8 L_00473506                             # 004734f7
    # block 0x004734f9: entered by fall-through of je at 0x004734f7, 4 instruction(s), ends with forward jump to 0x0047350b
    mov eax, dword ptr [ebp - local_8]           # 004734f9
    mov cx, word ptr [ebp - local_4]             # 004734fc
    mov word ptr [eax + field_e], cx             # 00473500
    jmp.d8 L_0047350b                            # 00473504
L_00473506:
    # block 0x00473506: entered by jne at 0x0047344e; jmp at 0x004734d2; je at 0x004734f7, 1 instruction(s), ends with backward jump to 0x00473430
    jmp.d32 L_00473430                           # 00473506
L_0047350b:
    # block 0x0047350b: entered by jge at 0x0047343d; jmp at 0x004734d0; jmp at 0x00473504, 4 instruction(s), ends with je to 0x00473641 (forward)
    mov edx, dword ptr [ebp - local_8]           # 0047350b
    movsx eax, word ptr [edx + field_e]          # 0047350e
    cmp eax, -0x1                                # 00473512
    je.d32 L_00473641                            # 00473515
    # block 0x0047351b: entered by fall-through of je at 0x00473515, 6 instruction(s), ends with je to 0x0047358d (forward)
    movsx ecx, word ptr [0x583a29]               # 0047351b
    mov edx, dword ptr [ebp - local_8]           # 00473522
    mov eax, dword ptr [edx + field_76]          # 00473525
    movsx edx, word ptr [eax + field_104]        # 00473528
    {load} cmp ecx, edx                          # 0047352f
    je.d8 L_0047358d                             # 00473531
    # block 0x00473533: entered by fall-through of je at 0x00473531, 5 instruction(s), ends with je to 0x0047358d (forward)
    mov eax, dword ptr [ebp - local_8]           # 00473533
    mov ecx, dword ptr [eax + field_76]          # 00473536
    movsx edx, word ptr [ecx + field_104]        # 00473539
    cmp edx, -0x1                                # 00473540
    je.d8 L_0047358d                             # 00473543
    # block 0x00473545: entered by fall-through of je at 0x00473543, 5 instruction(s), ends with jne to 0x00473586 (forward)
    mov eax, dword ptr [ebp - local_8]           # 00473545
    movsx ecx, word ptr [eax + field_e]          # 00473548
    mov edx, dword ptr [ebp - local_8]           # 0047354c
    cmp dword ptr [edx + 4*ecx + field_375], 0x0 # 0047354f
    jne.d8 L_00473586                            # 00473557
    # block 0x00473559: entered by fall-through of jne at 0x00473557, 10 instruction(s), calls FUN_004eb184, falls into the block at 0x00473586
    mov eax, dword ptr [ebp - local_8]           # 00473559
    mov ecx, dword ptr [eax + field_76]          # 0047355c
    movsx edx, word ptr [ecx + field_104]        # 0047355f
    push edx                                     # 00473566
    mov ecx, 0x571442                            # 00473567
    call FUN_004eb184                            # 0047356c
    mov eax, dword ptr [ebp - local_8]           # 00473571
    movsx ecx, word ptr [eax + field_e]          # 00473574
    mov edx, dword ptr [ebp - local_8]           # 00473578
    mov dword ptr [edx + 4*ecx + field_375], 0x1 # 0047357b
L_00473586:
    # block 0x00473586: entered by jne at 0x00473557, 2 instruction(s), ends with forward jump to 0x0047364b
    {load} xor eax, eax                          # 00473586
    jmp.d32 L_0047364b                           # 00473588
L_0047358d:
    # block 0x0047358d: entered by je at 0x00473531; je at 0x00473543, 4 instruction(s), calls FUN_0047409e, ends with jne to 0x0047363a (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0047358d
    call FUN_0047409e                            # 00473590
    cmp dword ptr [0x5a4bce], -0x1               # 00473595
    jne.d32 L_0047363a                           # 0047359c
    # block 0x004735a2: entered by fall-through of jne at 0x0047359c, 28 instruction(s), calls KERNEL32.dll!GetTickCount, ends with je to 0x0047363a (forward)
    mov eax, dword ptr [ebp - local_8]           # 004735a2
    movsx ecx, word ptr [eax + field_e]          # 004735a5
    shl ecx, 0x4                                 # 004735a9
    mov edx, dword ptr [0x583102]                # 004735ac
    sub edx, dword ptr [ecx + 0x5a4b5e]          # 004735b2
    mov eax, dword ptr [ebp - local_8]           # 004735b8
    movsx ecx, word ptr [eax + field_e]          # 004735bb
    mov dword ptr [8*ecx + 0x5a4b9e], edx        # 004735bf
    mov edx, dword ptr [ebp - local_8]           # 004735c6
    movsx eax, word ptr [edx + field_e]          # 004735c9
    shl eax, 0x4                                 # 004735cd
    mov ecx, dword ptr [0x583106]                # 004735d0
    sub ecx, dword ptr [eax + 0x5a4b62]          # 004735d6
    mov edx, dword ptr [ebp - local_8]           # 004735dc
    movsx eax, word ptr [edx + field_e]          # 004735df
    mov dword ptr [8*eax + 0x5a4ba2], ecx        # 004735e3
    mov ecx, dword ptr [ebp - local_8]           # 004735ea
    movsx edx, word ptr [ecx + field_e]          # 004735ed
    mov dword ptr [0x5a4bce], edx                # 004735f1
    mov eax, dword ptr [ebp - local_8]           # 004735f7
    movsx ecx, word ptr [eax + field_e]          # 004735fa
    mov dword ptr [4*ecx + 0x5a4bbe], 0x1        # 004735fe
    call dword ptr [0x52a23c]                    # 00473609
    mov edx, dword ptr [ebp - local_4]           # 0047360f
    mov dword ptr [4*edx + 0x63a864], eax        # 00473612
    mov eax, dword ptr [ebp - local_8]           # 00473619
    cmp dword ptr [eax + field_371], 0x0         # 0047361c
    je.d8 L_0047363a                             # 00473623
    # block 0x00473625: entered by fall-through of je at 0x00473623, 4 instruction(s), calls FUN_0047512a, falls into the block at 0x0047363a
    mov ecx, dword ptr [ebp - local_8]           # 00473625
    mov dword ptr [ecx + field_371], 0x0         # 00473628
    mov ecx, dword ptr [ebp - local_8]           # 00473632
    call FUN_0047512a                            # 00473635
L_0047363a:
    # block 0x0047363a: entered by jne at 0x0047359c; je at 0x00473623, 2 instruction(s), ends with forward jump to 0x0047364b
    mov eax, 0x1                                 # 0047363a
    jmp.d8 L_0047364b                            # 0047363f
L_00473641:
    # block 0x00473641: entered by je at 0x00473515, 2 instruction(s), calls FUN_00473f7d, falls into the block at 0x00473649
    mov ecx, dword ptr [ebp - local_8]           # 00473641
    call FUN_00473f7d                            # 00473644
L_00473649:
    # block 0x00473649: entered by je at 0x00473238, 1 instruction(s), falls into the block at 0x0047364b
    {load} xor eax, eax                          # 00473649
L_0047364b:
    # block 0x0047364b: entered by jmp at 0x0047336e; jmp at 0x0047341a; jmp at 0x00473588; jmp at 0x0047363f, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 0047364b
    pop ebp                                      # 0047364d
    ret 0x8                                      # 0047364e

