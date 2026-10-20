# FUN_004f52a9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f52a9
# extent:       0x004f52a9-0x004f55d5 (812 code bytes)
# span:         0x004f52a9-0x004f55d5 (code 812, tables 0, padding 0)
# sha256:       782ecd87b3573a51875acf50f43e8d372f6ca07a67404b94fb5f9eaabf3f83a2
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_sound_channel_pump
# naming:       INFERRED (lower confidence, not verified): the repository text src/live_audio.c:10 says "the pump 0x4f52a9 drains events and"; src/live_audio.h:236 says "the recovered channel pump (original 0x4f52a9)"
# name-note:    Sound pump that drains events and calls the channel update 0x4f55d5.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       7 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c
# fields:       [eax + n] field_10, field_156, field_15e, field_3c2; [ecx + n] field_4, field_8, field_c, field_10, field_166, field_5af; [edx + n] field_4, field_8, field_10, field_15e, field_162, field_3c2, field_3ce, field_5af
# callees:      calls FUN_004f709c, KERNEL32.dll!WaitForMultipleObjects, FUN_0050ca3e, FUN_0052139c, FUN_0044a2b7, FUN_004f6334, KERNEL32.dll!GetTickCount, FUN_004f8157, FUN_004f356e, FUN_004fa2a8, FUN_004f61e7, FUN_004f57e3, FUN_004f55d5, FUN_004f572b, FUN_004f7207, FUN_004f79ce and 1 more
# track-n:      outputs/blackmoor-decomp/src/blackmoor_app.mm:update (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 223 instruction(s), 21 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
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
.equ local_1c, 0x1c  # offset -0x1c
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_156, 0x156  # offset +0x156
.equ field_15e, 0x15e  # offset +0x15e
.equ field_162, 0x162  # offset +0x162
.equ field_166, 0x166  # offset +0x166
.equ field_3c2, 0x3c2  # offset +0x3c2
.equ field_3ce, 0x3ce  # offset +0x3ce
.equ field_5af, 0x5af  # offset +0x5af

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004f356e, .text + (0x004f356e - 0x401000)
.set FUN_004f55d5, .text + (0x004f55d5 - 0x401000)
.set FUN_004f572b, .text + (0x004f572b - 0x401000)
.set FUN_004f57e3, .text + (0x004f57e3 - 0x401000)
.set FUN_004f61e7, .text + (0x004f61e7 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004f709c, .text + (0x004f709c - 0x401000)
.set FUN_004f7207, .text + (0x004f7207 - 0x401000)
.set FUN_004f79ce, .text + (0x004f79ce - 0x401000)
.set FUN_004f8157, .text + (0x004f8157 - 0x401000)
.set FUN_004f842f, .text + (0x004f842f - 0x401000)
.set FUN_004fa2a8, .text + (0x004fa2a8 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004f52a9 - 0x401000
.globl FUN_004f52a9
FUN_004f52a9:
    # block 0x004f52a9: entry, 11 instruction(s), calls FUN_004f709c, ends with jne to 0x004f52d7 (forward)
    push ebp                                     # 004f52a9
    {load} mov ebp, esp                          # 004f52aa
    sub esp, 0x1c                                # 004f52ac
    mov dword ptr [ebp - local_18], ecx          # 004f52af
    mov eax, dword ptr [ebp - local_18]          # 004f52b2
    mov dword ptr [eax + field_3c2], 0x3e8       # 004f52b5
    mov dword ptr [ebp - local_4], 0x0           # 004f52bf
    mov ecx, dword ptr [ebp - local_18]          # 004f52c6
    call FUN_004f709c                            # 004f52c9
    test eax, eax                                # 004f52ce
    jne.d8 L_004f52d7                            # 004f52d0
    # block 0x004f52d2: entered by fall-through of jne at 0x004f52d0, 1 instruction(s), ends with forward jump to 0x004f55d1
    jmp.d32 L_004f55d1                           # 004f52d2
L_004f52d7:
    # block 0x004f52d7: entered by jne at 0x004f52d0; je at 0x004f55ab, 12 instruction(s), calls KERNEL32.dll!WaitForMultipleObjects, ends with je to 0x004f534b (forward)
    push 0x0                                     # 004f52d7
    push 0x0                                     # 004f52d9
    mov ecx, dword ptr [ebp - local_18]          # 004f52db
    add ecx, 0x2ba                               # 004f52de
    push ecx                                     # 004f52e4
    push 0x40                                    # 004f52e5
    call dword ptr [0x52a250]                    # 004f52e7
    mov dword ptr [ebp - local_10], eax          # 004f52ed
    mov edx, dword ptr [ebp - local_10]          # 004f52f0
    mov dword ptr [ebp - local_1c], edx          # 004f52f3
    cmp dword ptr [ebp - local_1c], 0x102        # 004f52f6
    je.d8 L_004f534b                             # 004f52fd
    # block 0x004f52ff: entered by fall-through of je at 0x004f52fd, 2 instruction(s), ends with je to 0x004f5307 (forward)
    cmp dword ptr [ebp - local_1c], -0x1         # 004f52ff
    je.d8 L_004f5307                             # 004f5303
    # block 0x004f5305: entered by fall-through of je at 0x004f5303, 1 instruction(s), ends with forward jump to 0x004f5357
    jmp.d8 L_004f5357                            # 004f5305
L_004f5307:
    # block 0x004f5307: entered by je at 0x004f5303, 3 instruction(s), ends with je to 0x004f533f (forward)
    movsx eax, word ptr [0x63a4cd]               # 004f5307
    test eax, eax                                # 004f530e
    je.d8 L_004f533f                             # 004f5310
    # block 0x004f5312: entered by fall-through of je at 0x004f5310, 11 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_0044a2b7, falls into the block at 0x004f533f
    push 0x55e424                                # 004f5312
    push 0x63888b                                # 004f5317
    call FUN_0050ca3e                            # 004f531c
    add esp, 0x8                                 # 004f5321
    push 0x0                                     # 004f5324
    push 0x0                                     # 004f5326
    push 0x63888b                                # 004f5328
    call FUN_0052139c                            # 004f532d
    push 0x63888b                                # 004f5332
    call FUN_0044a2b7                            # 004f5337
    add esp, 0x4                                 # 004f533c
L_004f533f:
    # block 0x004f533f: entered by je at 0x004f5310, 2 instruction(s), ends with forward jump to 0x004f55a7
    mov dword ptr [ebp - local_4], 0x1           # 004f533f
    jmp.d32 L_004f55a7                           # 004f5346
L_004f534b:
    # block 0x004f534b: entered by je at 0x004f52fd, 2 instruction(s), ends with forward jump to 0x004f55a7
    mov dword ptr [ebp - local_4], 0x1           # 004f534b
    jmp.d32 L_004f55a7                           # 004f5352
L_004f5357:
    # block 0x004f5357: entered by jmp at 0x004f5305, 4 instruction(s), ends with jb to 0x004f55a0 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004f5357
    mov dword ptr [ebp - local_10], ecx          # 004f535a
    cmp dword ptr [ebp - local_10], 0x0          # 004f535d
    jb.d32 L_004f55a0                            # 004f5361
    # block 0x004f5367: entered by fall-through of jb at 0x004f5361, 2 instruction(s), ends with jae to 0x004f55a0 (forward)
    cmp dword ptr [ebp - local_10], 0x40         # 004f5367
    jae.d32 L_004f55a0                           # 004f536b
    # block 0x004f5371: entered by fall-through of jae at 0x004f536b, 7 instruction(s), ends with jne to 0x004f5592 (forward)
    mov edx, dword ptr [ebp - local_10]          # 004f5371
    shr edx                                      # 004f5374
    mov dword ptr [ebp - local_c], edx           # 004f5376
    mov eax, dword ptr [ebp - local_10]          # 004f5379
    and eax, 0x1                                 # 004f537c
    test eax, eax                                # 004f537f
    jne.d32 L_004f5592                           # 004f5381
    # block 0x004f5387: entered by fall-through of jne at 0x004f5381, 9 instruction(s), ends with je to 0x004f53c2 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004f5387
    imul ecx, ecx, 0x5bb                         # 004f538a
    mov edx, dword ptr [ebp - local_18]          # 004f5390
    mov eax, dword ptr [edx + field_3ce]         # 004f5393
    {load} add eax, ecx                          # 004f5399
    mov dword ptr [ebp - local_14], eax          # 004f539b
    mov ecx, dword ptr [ebp - local_14]          # 004f539e
    cmp dword ptr [ecx + field_166], 0x0         # 004f53a1
    je.d8 L_004f53c2                             # 004f53a8
    # block 0x004f53aa: entered by fall-through of je at 0x004f53a8, 3 instruction(s), ends with je to 0x004f53c2 (forward)
    mov edx, dword ptr [ebp - local_14]          # 004f53aa
    cmp dword ptr [edx + field_162], 0x0         # 004f53ad
    je.d8 L_004f53c2                             # 004f53b4
    # block 0x004f53b6: entered by fall-through of je at 0x004f53b4, 3 instruction(s), ends with jne to 0x004f53c7 (forward)
    mov eax, dword ptr [ebp - local_14]          # 004f53b6
    cmp dword ptr [eax + field_156], 0x0         # 004f53b9
    jne.d8 L_004f53c7                            # 004f53c0
L_004f53c2:
    # block 0x004f53c2: entered by je at 0x004f53a8; je at 0x004f53b4; fall-through of jne at 0x004f53c0, 1 instruction(s), ends with forward jump to 0x004f55a7
    jmp.d32 L_004f55a7                           # 004f53c2
L_004f53c7:
    # block 0x004f53c7: entered by jne at 0x004f53c0, 6 instruction(s), calls FUN_004f6334, ends with jne to 0x004f53dc (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004f53c7
    push ecx                                     # 004f53ca
    mov ecx, dword ptr [ebp - local_18]          # 004f53cb
    call FUN_004f6334                            # 004f53ce
    test eax, eax                                # 004f53d3
    jne.d8 L_004f53dc                            # 004f53d5
    # block 0x004f53d7: entered by fall-through of jne at 0x004f53d5, 1 instruction(s), ends with forward jump to 0x004f55a7
    jmp.d32 L_004f55a7                           # 004f53d7
L_004f53dc:
    # block 0x004f53dc: entered by jne at 0x004f53d5, 3 instruction(s), ends with je to 0x004f543f (forward)
    movsx edx, word ptr [0x63a4cd]               # 004f53dc
    test edx, edx                                # 004f53e3
    je.d8 L_004f543f                             # 004f53e5
    # block 0x004f53e7: entered by fall-through of je at 0x004f53e5, 5 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jbe to 0x004f5430 (forward)
    call dword ptr [0x52a23c]                    # 004f53e7
    mov ecx, dword ptr [ebp - local_14]          # 004f53ed
    sub eax, dword ptr [ecx + field_5af]         # 004f53f0
    cmp eax, 0x7d0                               # 004f53f6
    jbe.d8 L_004f5430                            # 004f53fb
    # block 0x004f53fd: entered by fall-through of jbe at 0x004f53fb, 13 instruction(s), calls KERNEL32.dll!GetTickCount, FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f5430
    call dword ptr [0x52a23c]                    # 004f53fd
    mov edx, dword ptr [ebp - local_14]          # 004f5403
    sub eax, dword ptr [edx + field_5af]         # 004f5406
    push eax                                     # 004f540c
    mov eax, dword ptr [ebp - local_c]           # 004f540d
    push eax                                     # 004f5410
    push 0x55e48c                                # 004f5411
    push 0x63888b                                # 004f5416
    call FUN_0050ca3e                            # 004f541b
    add esp, 0x10                                # 004f5420
    push 0x63888b                                # 004f5423
    call FUN_0044a2b7                            # 004f5428
    add esp, 0x4                                 # 004f542d
L_004f5430:
    # block 0x004f5430: entered by jbe at 0x004f53fb, 3 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x004f543f
    call dword ptr [0x52a23c]                    # 004f5430
    mov ecx, dword ptr [ebp - local_14]          # 004f5436
    mov dword ptr [ecx + field_5af], eax         # 004f5439
L_004f543f:
    # block 0x004f543f: entered by je at 0x004f53e5, 12 instruction(s), calls FUN_004f8157, ends with jne to 0x004f54d0 (forward)
    mov edx, dword ptr [ebp - local_14]          # 004f543f
    add edx, 0x18a                               # 004f5442
    mov dword ptr [ebp - local_8], edx           # 004f5448
    mov eax, dword ptr [ebp - local_c]           # 004f544b
    push eax                                     # 004f544e
    mov ecx, dword ptr [ebp - local_18]          # 004f544f
    call FUN_004f8157                            # 004f5452
    mov ecx, dword ptr [ebp - local_8]           # 004f5457
    mov dword ptr [ecx + field_4], eax           # 004f545a
    mov edx, dword ptr [ebp - local_8]           # 004f545d
    cmp dword ptr [edx + field_4], -0x1          # 004f5460
    jne.d8 L_004f54d0                            # 004f5464
    # block 0x004f5466: entered by fall-through of jne at 0x004f5464, 8 instruction(s), calls FUN_004f356e, ends with je to 0x004f54cb (forward)
    mov dword ptr [ebp - local_4], 0x1           # 004f5466
    mov eax, dword ptr [ebp - local_c]           # 004f546d
    push eax                                     # 004f5470
    mov ecx, dword ptr [ebp - local_18]          # 004f5471
    call FUN_004f356e                            # 004f5474
    movsx ecx, word ptr [0x63a4cd]               # 004f5479
    test ecx, ecx                                # 004f5480
    je.d8 L_004f54cb                             # 004f5482
    # block 0x004f5484: entered by fall-through of je at 0x004f5482, 18 instruction(s), calls FUN_004fa2a8, FUN_0050ca3e, FUN_0044a2b7, FUN_0052139c, falls into the block at 0x004f54cb
    mov edx, dword ptr [ebp - local_18]          # 004f5484
    mov dword ptr [edx + field_3c2], 0x410       # 004f5487
    mov ecx, dword ptr [ebp - local_18]          # 004f5491
    call FUN_004fa2a8                            # 004f5494
    push eax                                     # 004f5499
    mov eax, dword ptr [ebp - local_c]           # 004f549a
    push eax                                     # 004f549d
    push 0x55e4ec                                # 004f549e
    push 0x63888b                                # 004f54a3
    call FUN_0050ca3e                            # 004f54a8
    add esp, 0x10                                # 004f54ad
    push 0x63888b                                # 004f54b0
    call FUN_0044a2b7                            # 004f54b5
    add esp, 0x4                                 # 004f54ba
    push 0x0                                     # 004f54bd
    push 0x0                                     # 004f54bf
    push 0x55e520                                # 004f54c1
    call FUN_0052139c                            # 004f54c6
L_004f54cb:
    # block 0x004f54cb: entered by je at 0x004f5482, 1 instruction(s), ends with forward jump to 0x004f55a7
    jmp.d32 L_004f55a7                           # 004f54cb
L_004f54d0:
    # block 0x004f54d0: entered by jne at 0x004f5464, 5 instruction(s), ends with jae to 0x004f54ed (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004f54d0
    mov edx, dword ptr [ebp - local_8]           # 004f54d3
    mov eax, dword ptr [ecx + field_4]           # 004f54d6
    cmp eax, dword ptr [edx + field_8]           # 004f54d9
    jae.d8 L_004f54ed                            # 004f54dc
    # block 0x004f54de: entered by fall-through of jae at 0x004f54dc, 5 instruction(s), falls into the block at 0x004f54ed
    mov ecx, dword ptr [ebp - local_8]           # 004f54de
    mov edx, dword ptr [ecx + field_10]          # 004f54e1
    add edx, 0x1                                 # 004f54e4
    mov eax, dword ptr [ebp - local_8]           # 004f54e7
    mov dword ptr [eax + field_10], edx          # 004f54ea
L_004f54ed:
    # block 0x004f54ed: entered by jae at 0x004f54dc, 7 instruction(s), ends with je to 0x004f557e (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004f54ed
    mov edx, dword ptr [ebp - local_8]           # 004f54f0
    mov eax, dword ptr [edx + field_4]           # 004f54f3
    mov dword ptr [ecx + field_8], eax           # 004f54f6
    mov ecx, dword ptr [ebp - local_8]           # 004f54f9
    cmp dword ptr [ecx + field_c], 0x0           # 004f54fc
    je.d8 L_004f557e                             # 004f5500
    # block 0x004f5502: entered by fall-through of je at 0x004f5500, 10 instruction(s), ends with jb to 0x004f557e (forward)
    mov edx, dword ptr [ebp - local_8]           # 004f5502
    mov eax, dword ptr [edx + field_10]          # 004f5505
    imul eax, eax, 0x56220                       # 004f5508
    mov ecx, dword ptr [ebp - local_8]           # 004f550e
    add eax, dword ptr [ecx + field_4]           # 004f5511
    mov edx, dword ptr [ebp - local_14]          # 004f5514
    mov ecx, dword ptr [edx + field_15e]         # 004f5517
    sub ecx, 0x1388                              # 004f551d
    {load} cmp eax, ecx                          # 004f5523
    jb.d8 L_004f557e                             # 004f5525
    # block 0x004f5527: entered by fall-through of jb at 0x004f5525, 3 instruction(s), ends with je to 0x004f5572 (forward)
    movsx edx, word ptr [0x63a4cd]               # 004f5527
    test edx, edx                                # 004f552e
    je.d8 L_004f5572                             # 004f5530
    # block 0x004f5532: entered by fall-through of je at 0x004f5530, 18 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f5572
    mov eax, dword ptr [ebp - local_14]          # 004f5532
    mov ecx, dword ptr [eax + field_15e]         # 004f5535
    push ecx                                     # 004f553b
    mov edx, dword ptr [ebp - local_8]           # 004f553c
    mov eax, dword ptr [edx + field_10]          # 004f553f
    imul eax, eax, 0x56220                       # 004f5542
    mov ecx, dword ptr [ebp - local_8]           # 004f5548
    add eax, dword ptr [ecx + field_4]           # 004f554b
    push eax                                     # 004f554e
    mov edx, dword ptr [ebp - local_c]           # 004f554f
    push edx                                     # 004f5552
    push 0x55e55c                                # 004f5553
    push 0x63888b                                # 004f5558
    call FUN_0050ca3e                            # 004f555d
    add esp, 0x14                                # 004f5562
    push 0x63888b                                # 004f5565
    call FUN_0044a2b7                            # 004f556a
    add esp, 0x4                                 # 004f556f
L_004f5572:
    # block 0x004f5572: entered by je at 0x004f5530, 4 instruction(s), calls FUN_004f61e7, falls into the block at 0x004f557e
    mov eax, dword ptr [ebp - local_c]           # 004f5572
    push eax                                     # 004f5575
    mov ecx, dword ptr [ebp - local_18]          # 004f5576
    call FUN_004f61e7                            # 004f5579
L_004f557e:
    # block 0x004f557e: entered by je at 0x004f5500; jb at 0x004f5525; jmp at 0x004f558e, 6 instruction(s), calls FUN_004f57e3, ends with je to 0x004f5590 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004f557e
    push ecx                                     # 004f5581
    mov ecx, dword ptr [ebp - local_18]          # 004f5582
    call FUN_004f57e3                            # 004f5585
    test eax, eax                                # 004f558a
    je.d8 L_004f5590                             # 004f558c
    # block 0x004f558e: entered by fall-through of je at 0x004f558c, 1 instruction(s), ends with backward jump to 0x004f557e
    jmp.d8 L_004f557e                            # 004f558e
L_004f5590:
    # block 0x004f5590: entered by je at 0x004f558c, 1 instruction(s), ends with forward jump to 0x004f559e
    jmp.d8 L_004f559e                            # 004f5590
L_004f5592:
    # block 0x004f5592: entered by jne at 0x004f5381, 4 instruction(s), calls FUN_004f55d5, falls into the block at 0x004f559e
    mov edx, dword ptr [ebp - local_c]           # 004f5592
    push edx                                     # 004f5595
    mov ecx, dword ptr [ebp - local_18]          # 004f5596
    call FUN_004f55d5                            # 004f5599
L_004f559e:
    # block 0x004f559e: entered by jmp at 0x004f5590, 1 instruction(s), ends with forward jump to 0x004f55a7
    jmp.d8 L_004f55a7                            # 004f559e
L_004f55a0:
    # block 0x004f55a0: entered by jb at 0x004f5361; jae at 0x004f536b, 1 instruction(s), falls into the block at 0x004f55a7
    mov dword ptr [ebp - local_4], 0x1           # 004f55a0
L_004f55a7:
    # block 0x004f55a7: entered by jmp at 0x004f5346; jmp at 0x004f5352; jmp at 0x004f53c2; jmp at 0x004f53d7; more, 2 instruction(s), ends with je to 0x004f52d7 (backward)
    cmp dword ptr [ebp - local_4], 0x0           # 004f55a7
    je.d32 L_004f52d7                            # 004f55ab
    # block 0x004f55b1: entered by fall-through of je at 0x004f55ab, 8 instruction(s), calls FUN_004f572b, FUN_004f7207, FUN_004f79ce, FUN_004f842f, falls into the block at 0x004f55d1
    mov ecx, dword ptr [ebp - local_18]          # 004f55b1
    call FUN_004f572b                            # 004f55b4
    mov ecx, dword ptr [ebp - local_18]          # 004f55b9
    call FUN_004f7207                            # 004f55bc
    mov ecx, dword ptr [ebp - local_18]          # 004f55c1
    call FUN_004f79ce                            # 004f55c4
    mov ecx, dword ptr [ebp - local_18]          # 004f55c9
    call FUN_004f842f                            # 004f55cc
L_004f55d1:
    # block 0x004f55d1: entered by jmp at 0x004f52d2, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004f55d1
    pop ebp                                      # 004f55d3
    ret                                          # 004f55d4

