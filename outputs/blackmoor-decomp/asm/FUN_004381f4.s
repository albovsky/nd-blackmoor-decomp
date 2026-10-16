# FUN_004381f4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004381f4
# extent:       0x004381f4-0x004397f1 (5629 code bytes)
# span:         0x004381f4-0x00439822 (code 5629, tables 49, padding 0)
# sha256:       aba7032e50c39e35ea525e2e4ca8c2c41b01659c795ce014ddfa8fb67724dff4
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004381f4
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       9 ebp-relative slot(s): local_4, local_8, local_10c, local_110, local_114, local_118, local_11c, local_120, local_124
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0044a2b7, KERNEL32.dll!GetTickCount, FUN_00433bd2, FUN_004cd218, FUN_004a3947, FUN_0048e324, FUN_004a1d14, FUN_0048d119, FUN_004a64ae, FUN_004b5c48, FUN_004ab459, FUN_00465bd3, FUN_004618df, FUN_00487bcc, FUN_004afdfe, FUN_00470e71 and 94 more
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1100 instruction(s), 28 conditional branch(es) and 2 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_10c, 0x10c  # offset -0x10c
.equ local_110, 0x110  # offset -0x110
.equ local_114, 0x114  # offset -0x114
.equ local_118, 0x118  # offset -0x118
.equ local_11c, 0x11c  # offset -0x11c
.equ local_120, 0x120  # offset -0x120
.equ local_124, 0x124  # offset -0x124

# --- external targets -----------------------------------------------
.set FUN_0041114f, .text + (0x0041114f - 0x401000)
.set FUN_004111a0, .text + (0x004111a0 - 0x401000)
.set FUN_00411215, .text + (0x00411215 - 0x401000)
.set FUN_004145d0, .text + (0x004145d0 - 0x401000)
.set FUN_00415011, .text + (0x00415011 - 0x401000)
.set FUN_0041608b, .text + (0x0041608b - 0x401000)
.set FUN_0041c133, .text + (0x0041c133 - 0x401000)
.set FUN_0041db40, .text + (0x0041db40 - 0x401000)
.set FUN_0041e33b, .text + (0x0041e33b - 0x401000)
.set FUN_004234b5, .text + (0x004234b5 - 0x401000)
.set FUN_00423af1, .text + (0x00423af1 - 0x401000)
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_00433bd2, .text + (0x00433bd2 - 0x401000)
.set FUN_00437743, .text + (0x00437743 - 0x401000)
.set FUN_0043d7c4, .text + (0x0043d7c4 - 0x401000)
.set FUN_00445f40, .text + (0x00445f40 - 0x401000)
.set FUN_00447c1c, .text + (0x00447c1c - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0044aff2, .text + (0x0044aff2 - 0x401000)
.set FUN_0044c9db, .text + (0x0044c9db - 0x401000)
.set FUN_0044d154, .text + (0x0044d154 - 0x401000)
.set FUN_0044e78e, .text + (0x0044e78e - 0x401000)
.set FUN_0044e80b, .text + (0x0044e80b - 0x401000)
.set FUN_0044f996, .text + (0x0044f996 - 0x401000)
.set FUN_00454d8a, .text + (0x00454d8a - 0x401000)
.set FUN_00454de6, .text + (0x00454de6 - 0x401000)
.set FUN_00456d2e, .text + (0x00456d2e - 0x401000)
.set FUN_00456dab, .text + (0x00456dab - 0x401000)
.set FUN_00457fc2, .text + (0x00457fc2 - 0x401000)
.set FUN_00458015, .text + (0x00458015 - 0x401000)
.set FUN_00459b87, .text + (0x00459b87 - 0x401000)
.set FUN_0045b42e, .text + (0x0045b42e - 0x401000)
.set FUN_0045dd4d, .text + (0x0045dd4d - 0x401000)
.set FUN_00461862, .text + (0x00461862 - 0x401000)
.set FUN_004618df, .text + (0x004618df - 0x401000)
.set FUN_0046401a, .text + (0x0046401a - 0x401000)
.set FUN_00464076, .text + (0x00464076 - 0x401000)
.set FUN_00465b3c, .text + (0x00465b3c - 0x401000)
.set FUN_00465bd3, .text + (0x00465bd3 - 0x401000)
.set FUN_00467608, .text + (0x00467608 - 0x401000)
.set FUN_00468f19, .text + (0x00468f19 - 0x401000)
.set FUN_0046b67f, .text + (0x0046b67f - 0x401000)
.set FUN_0046b73e, .text + (0x0046b73e - 0x401000)
.set FUN_0046e7a6, .text + (0x0046e7a6 - 0x401000)
.set FUN_00470ddc, .text + (0x00470ddc - 0x401000)
.set FUN_00470e71, .text + (0x00470e71 - 0x401000)
.set FUN_004730a6, .text + (0x004730a6 - 0x401000)
.set FUN_00475885, .text + (0x00475885 - 0x401000)
.set FUN_0047591f, .text + (0x0047591f - 0x401000)
.set FUN_0047823e, .text + (0x0047823e - 0x401000)
.set FUN_004782be, .text + (0x004782be - 0x401000)
.set FUN_0047b321, .text + (0x0047b321 - 0x401000)
.set FUN_0047d59b, .text + (0x0047d59b - 0x401000)
.set FUN_0047e2a5, .text + (0x0047e2a5 - 0x401000)
.set FUN_0047e3f7, .text + (0x0047e3f7 - 0x401000)
.set FUN_004821ab, .text + (0x004821ab - 0x401000)
.set FUN_00483fb5, .text + (0x00483fb5 - 0x401000)
.set FUN_00487b4f, .text + (0x00487b4f - 0x401000)
.set FUN_00487bcc, .text + (0x00487bcc - 0x401000)
.set FUN_00488e54, .text + (0x00488e54 - 0x401000)
.set FUN_0048a7e5, .text + (0x0048a7e5 - 0x401000)
.set FUN_0048bb86, .text + (0x0048bb86 - 0x401000)
.set FUN_0048d09c, .text + (0x0048d09c - 0x401000)
.set FUN_0048d119, .text + (0x0048d119 - 0x401000)
.set FUN_0048e2f5, .text + (0x0048e2f5 - 0x401000)
.set FUN_0048e324, .text + (0x0048e324 - 0x401000)
.set FUN_004a1cb1, .text + (0x004a1cb1 - 0x401000)
.set FUN_004a1d14, .text + (0x004a1d14 - 0x401000)
.set FUN_004a3884, .text + (0x004a3884 - 0x401000)
.set FUN_004a3947, .text + (0x004a3947 - 0x401000)
.set FUN_004a63dc, .text + (0x004a63dc - 0x401000)
.set FUN_004a64ae, .text + (0x004a64ae - 0x401000)
.set FUN_004a7d1d, .text + (0x004a7d1d - 0x401000)
.set FUN_004a7ddc, .text + (0x004a7ddc - 0x401000)
.set FUN_004a9f63, .text + (0x004a9f63 - 0x401000)
.set FUN_004ab3dc, .text + (0x004ab3dc - 0x401000)
.set FUN_004ab459, .text + (0x004ab459 - 0x401000)
.set FUN_004ac97d, .text + (0x004ac97d - 0x401000)
.set FUN_004afd7e, .text + (0x004afd7e - 0x401000)
.set FUN_004afdfe, .text + (0x004afdfe - 0x401000)
.set FUN_004b3d4d, .text + (0x004b3d4d - 0x401000)
.set FUN_004b5bc8, .text + (0x004b5bc8 - 0x401000)
.set FUN_004b5c48, .text + (0x004b5c48 - 0x401000)
.set FUN_004b7229, .text + (0x004b7229 - 0x401000)
.set FUN_004b72a9, .text + (0x004b72a9 - 0x401000)
.set FUN_004b7ff4, .text + (0x004b7ff4 - 0x401000)
.set FUN_004b8087, .text + (0x004b8087 - 0x401000)
.set FUN_004ba07f, .text + (0x004ba07f - 0x401000)
.set FUN_004bedfa, .text + (0x004bedfa - 0x401000)
.set FUN_004c0b8b, .text + (0x004c0b8b - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004c9428, .text + (0x004c9428 - 0x401000)
.set FUN_004c94ec, .text + (0x004c94ec - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004caf8a, .text + (0x004caf8a - 0x401000)
.set FUN_004cd218, .text + (0x004cd218 - 0x401000)
.set FUN_004cecf7, .text + (0x004cecf7 - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)
.set FUN_004dad60, .text + (0x004dad60 - 0x401000)
.set FUN_004db870, .text + (0x004db870 - 0x401000)
.set FUN_004de2d8, .text + (0x004de2d8 - 0x401000)
.set FUN_004e2e05, .text + (0x004e2e05 - 0x401000)
.set FUN_004e7e15, .text + (0x004e7e15 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cd72, .text + (0x0050cd72 - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)
.set FUN_0050d0a9, .text + (0x0050d0a9 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004381f4 - 0x401000
.globl FUN_004381f4
FUN_004381f4:
    # block 0x004381f4: entry, 8 instruction(s), ends with je to 0x00438217 (forward)
    push ebp                                     # 004381f4
    {load} mov ebp, esp                          # 004381f5
    sub esp, 0x124                               # 004381f7
    push esi                                     # 004381fd
    push edi                                     # 004381fe
    movsx eax, word ptr [0x63a4cd]               # 004381ff
    test eax, eax                                # 00438206
    je.d8 L_00438217                             # 00438208
    # block 0x0043820a: entered by fall-through of je at 0x00438208, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00438217
    push 0x546a68                                # 0043820a
    call FUN_0044a2b7                            # 0043820f
    add esp, 0x4                                 # 00438214
L_00438217:
    # block 0x00438217: entered by je at 0x00438208, 6 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x00438245
    call dword ptr [0x52a23c]                    # 00438217
    mov dword ptr [ebp - local_4], eax           # 0043821d
    mov word ptr [0x61c7cf], 0xffff              # 00438220
    mov dword ptr [0x61c7d1], 0x0                # 00438229
    mov dword ptr [ebp - local_8], 0x0           # 00438233
    jmp.d8 L_00438245                            # 0043823a
L_0043823c:
    # block 0x0043823c: entered by jmp at 0x0043825c, 3 instruction(s), falls into the block at 0x00438245
    mov ecx, dword ptr [ebp - local_8]           # 0043823c
    add ecx, 0x1                                 # 0043823f
    mov dword ptr [ebp - local_8], ecx           # 00438242
L_00438245:
    # block 0x00438245: entered by jmp at 0x0043823a, 2 instruction(s), ends with jge to 0x0043825e (forward)
    cmp dword ptr [ebp - local_8], 0x4e3         # 00438245
    jge.d8 L_0043825e                            # 0043824c
    # block 0x0043824e: entered by fall-through of jge at 0x0043824c, 3 instruction(s), ends with backward jump to 0x0043823c
    mov edx, dword ptr [ebp - local_8]           # 0043824e
    mov dword ptr [4*edx + 0x5867a1], 0x0        # 00438251
    jmp.d8 L_0043823c                            # 0043825c
L_0043825e:
    # block 0x0043825e: entered by jge at 0x0043824c, 2 instruction(s), ends with forward jump to 0x00438270
    mov dword ptr [ebp - local_8], 0x0           # 0043825e
    jmp.d8 L_00438270                            # 00438265
L_00438267:
    # block 0x00438267: entered by jmp at 0x00438286, 3 instruction(s), falls into the block at 0x00438270
    mov eax, dword ptr [ebp - local_8]           # 00438267
    add eax, 0x1                                 # 0043826a
    mov dword ptr [ebp - local_8], eax           # 0043826d
L_00438270:
    # block 0x00438270: entered by jmp at 0x00438265, 2 instruction(s), ends with jge to 0x00438288 (forward)
    cmp dword ptr [ebp - local_8], 0x2711        # 00438270
    jge.d8 L_00438288                            # 00438277
    # block 0x00438279: entered by fall-through of jge at 0x00438277, 3 instruction(s), ends with backward jump to 0x00438267
    mov ecx, dword ptr [ebp - local_8]           # 00438279
    mov word ptr [2*ecx + 0x587b2d], 0x0         # 0043827c
    jmp.d8 L_00438267                            # 00438286
L_00438288:
    # block 0x00438288: entered by jge at 0x00438277, 2 instruction(s), ends with forward jump to 0x0043829a
    mov dword ptr [ebp - local_8], 0x0           # 00438288
    jmp.d8 L_0043829a                            # 0043828f
L_00438291:
    # block 0x00438291: entered by jmp at 0x004382ae, 3 instruction(s), falls into the block at 0x0043829a
    mov edx, dword ptr [ebp - local_8]           # 00438291
    add edx, 0x1                                 # 00438294
    mov dword ptr [ebp - local_8], edx           # 00438297
L_0043829a:
    # block 0x0043829a: entered by jmp at 0x0043828f, 2 instruction(s), ends with jge to 0x004382b0 (forward)
    cmp dword ptr [ebp - local_8], 0x1e          # 0043829a
    jge.d8 L_004382b0                            # 0043829e
    # block 0x004382a0: entered by fall-through of jge at 0x0043829e, 3 instruction(s), ends with backward jump to 0x00438291
    mov eax, dword ptr [ebp - local_8]           # 004382a0
    mov dword ptr [4*eax + 0x5839b1], 0x0        # 004382a3
    jmp.d8 L_00438291                            # 004382ae
L_004382b0:
    # block 0x004382b0: entered by jge at 0x0043829e, 2 instruction(s), ends with forward jump to 0x004382c2
    mov dword ptr [ebp - local_8], 0x0           # 004382b0
    jmp.d8 L_004382c2                            # 004382b7
L_004382b9:
    # block 0x004382b9: entered by jmp at 0x004382e0, 3 instruction(s), falls into the block at 0x004382c2
    mov ecx, dword ptr [ebp - local_8]           # 004382b9
    add ecx, 0x1                                 # 004382bc
    mov dword ptr [ebp - local_8], ecx           # 004382bf
L_004382c2:
    # block 0x004382c2: entered by jmp at 0x004382b7, 2 instruction(s), ends with jge to 0x004382e2 (forward)
    cmp dword ptr [ebp - local_8], 0xa           # 004382c2
    jge.d8 L_004382e2                            # 004382c6
    # block 0x004382c8: entered by fall-through of jge at 0x004382c6, 7 instruction(s), calls FUN_00433bd2, ends with backward jump to 0x004382b9
    mov edx, dword ptr [ebp - local_8]           # 004382c8
    imul edx, edx, 0x106                         # 004382cb
    add edx, 0x585d65                            # 004382d1
    push edx                                     # 004382d7
    call FUN_00433bd2                            # 004382d8
    add esp, 0x4                                 # 004382dd
    jmp.d8 L_004382b9                            # 004382e0
L_004382e2:
    # block 0x004382e2: entered by jge at 0x004382c6, 144 instruction(s), calls FUN_004cd218, FUN_004a3947, FUN_0048e324, FUN_004a1d14, FUN_0048d119, FUN_004a64ae, FUN_004b5c48,..., ends with je to 0x00438684 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004382e2
    mov dword ptr [0x585d33], eax                # 004382e5
    mov dword ptr [0x585d37], 0x0                # 004382ea
    mov word ptr [0x585d3b], 0x0                 # 004382f4
    mov word ptr [0x585d3d], 0x0                 # 004382fd
    mov word ptr [0x585d3f], 0x0                 # 00438306
    mov dword ptr [0x585d41], 0x0                # 0043830f
    mov word ptr [0x585d45], 0x0                 # 00438319
    mov word ptr [0x585d47], 0x0                 # 00438322
    mov word ptr [0x585d49], 0x0                 # 0043832b
    mov cx, word ptr [0x5b01f8]                  # 00438334
    mov word ptr [0x585d4f], cx                  # 0043833b
    mov dx, word ptr [0x5b01f6]                  # 00438342
    mov word ptr [0x585d51], dx                  # 00438349
    movsx eax, word ptr [0x585d51]               # 00438350
    imul eax, eax, 0x3c                          # 00438357
    movsx ecx, word ptr [0x585d4f]               # 0043835a
    {load} add eax, ecx                          # 00438361
    mov dword ptr [0x585d4b], eax                # 00438363
    movsx edx, word ptr [0x5b0280]               # 00438368
    mov eax, dword ptr [ebp - local_4]           # 0043836f
    {load} add eax, edx                          # 00438372
    mov dword ptr [0x585d55], eax                # 00438374
    mov cx, word ptr [0x5b01fa]                  # 00438379
    mov word ptr [0x585d59], cx                  # 00438380
    mov dx, word ptr [0x5b01fc]                  # 00438387
    mov word ptr [0x585d5b], dx                  # 0043838e
    mov word ptr [0x585d53], 0x0                 # 00438395
    mov eax, dword ptr [ebp - local_4]           # 0043839e
    mov dword ptr [0x585d61], eax                # 004383a1
    mov ecx, dword ptr [ebp - local_4]           # 004383a6
    mov dword ptr [0x585d5d], ecx                # 004383a9
    mov word ptr [0x58c94f], 0x0                 # 004383af
    mov word ptr [0x58c957], 0xffff              # 004383b8
    movzx dx, byte ptr [0x5b6048]                # 004383c1
    mov word ptr [0x58c951], dx                  # 004383c9
    movzx ax, byte ptr [0x5b6049]                # 004383d0
    mov word ptr [0x58c953], ax                  # 004383d8
    movzx cx, byte ptr [0x5b604a]                # 004383de
    mov word ptr [0x58c955], cx                  # 004383e6
    mov ecx, 0x63821d                            # 004383ed
    call FUN_004cd218                            # 004383f2
    mov word ptr [0x591990], 0x0                 # 004383f7
    mov ecx, 0x12                                # 00438400
    or eax, -0x1                                 # 00438405
    mov edi, 0x591992                            # 00438408
    rep stosd dword ptr es:[edi], eax            # 0043840d
    mov word ptr [0x5919da], 0x0                 # 0043840f
    mov word ptr [0x5919fc], 0x0                 # 00438418
    mov ecx, 0x61c8cf                            # 00438421
    call FUN_004a3947                            # 00438426
    mov ecx, 0x624dc9                            # 0043842b
    call FUN_0048e324                            # 00438430
    mov ecx, 0x61d2dd                            # 00438435
    call FUN_004a1d14                            # 0043843a
    mov ecx, 0x61d345                            # 0043843f
    call FUN_0048d119                            # 00438444
    mov ecx, 0x61d3a1                            # 00438449
    call FUN_004a64ae                            # 0043844e
    mov ecx, 0x61d449                            # 00438453
    call FUN_004b5c48                            # 00438458
    mov ecx, 0x61d6c1                            # 0043845d
    call FUN_004ab459                            # 00438462
    mov ecx, 0x61d723                            # 00438467
    call FUN_00465bd3                            # 0043846c
    mov ecx, 0x61d779                            # 00438471
    call FUN_004618df                            # 00438476
    mov ecx, 0x61d7d8                            # 0043847b
    call FUN_00487bcc                            # 00438480
    mov ecx, 0x6204c1                            # 00438485
    call FUN_004afdfe                            # 0043848a
    mov ecx, 0x62387c                            # 0043848f
    call FUN_00470e71                            # 00438494
    mov ecx, 0x621a02                            # 00438499
    call FUN_004782be                            # 0043849e
    mov ecx, 0x622fa2                            # 004384a3
    call FUN_0047591f                            # 004384a8
    mov ecx, 0x6248ed                            # 004384ad
    call FUN_00456dab                            # 004384b2
    mov ecx, 0x624931                            # 004384b7
    call FUN_0044e80b                            # 004384bc
    mov ecx, 0x6249a0                            # 004384c1
    call FUN_004b72a9                            # 004384c6
    mov ecx, 0x619a41                            # 004384cb
    call FUN_004111a0                            # 004384d0
    mov ecx, 0x6249dc                            # 004384d5
    call FUN_00454d8a                            # 004384da
    mov ecx, 0x62387c                            # 004384df
    call FUN_00470e71                            # 004384e4
    mov ecx, 0x624b50                            # 004384e9
    call FUN_0046401a                            # 004384ee
    mov ecx, 0x625ee8                            # 004384f3
    call FUN_0047e3f7                            # 004384f8
    mov ecx, 0x627335                            # 004384fd
    call FUN_004a7ddc                            # 00438502
    mov ecx, 0x628732                            # 00438507
    call FUN_0046b73e                            # 0043850c
    mov ecx, 0x61ed7b                            # 00438511
    call FUN_00458015                            # 00438516
    mov ecx, 0x61ee6e                            # 0043851b
    call FUN_004b8087                            # 00438520
    mov ecx, 0x57975c                            # 00438525
    call FUN_004e2e05                            # 0043852a
    push 0x5bb2d3                                # 0043852f
    mov ecx, 0x5e2dbe                            # 00438534
    call FUN_00415011                            # 00438539
    push 0x5b4c3e                                # 0043853e
    mov ecx, 0x5e2dbe                            # 00438543
    call FUN_00415011                            # 00438548
    push 0x5b4eb5                                # 0043854d
    mov ecx, 0x5e2dbe                            # 00438552
    call FUN_00415011                            # 00438557
    push 0x5bb4db                                # 0043855c
    mov ecx, 0x6201f9                            # 00438561
    call FUN_004bedfa                            # 00438566
    push 0x5b4dc4                                # 0043856b
    mov ecx, 0x6201f9                            # 00438570
    call FUN_004bedfa                            # 00438575
    push 0x5b503b                                # 0043857a
    mov ecx, 0x6201f9                            # 0043857f
    call FUN_004bedfa                            # 00438584
    push 0x5bb2d3                                # 00438589
    mov ecx, 0x5e2dbe                            # 0043858e
    call FUN_0041608b                            # 00438593
    call FUN_0044c9db                            # 00438598
    mov ecx, 0x5cf659                            # 0043859d
    call FUN_004c9428                            # 004385a2
    mov ecx, 0x5cf659                            # 004385a7
    call FUN_004c94ec                            # 004385ac
    mov ecx, 0x583208                            # 004385b1
    call FUN_00437743                            # 004385b6
    mov word ptr [0x5c39ff], 0x0                 # 004385bb
    mov dword ptr [0x5c39e9], 0x0                # 004385c4
    mov dword ptr [0x5c39ed], 0x0                # 004385ce
    mov dword ptr [0x5c39f1], 0x0                # 004385d8
    mov dword ptr [0x5c39f5], 0x0                # 004385e2
    mov dword ptr [0x5c39f9], 0x0                # 004385ec
    mov dword ptr [0x5c39e5], 0xffffffff         # 004385f6
    mov dword ptr [0x5bb2f4], 0x0                # 00438600
    mov dword ptr [0x5bb505], 0x0                # 0043860a
    mov word ptr [0x5c39e3], 0x0                 # 00438614
    mov dword ptr [0x5c3a01], 0x0                # 0043861d
    cmp dword ptr [0x5bb1de], 0x0                # 00438627
    je.d8 L_00438684                             # 0043862e
    # block 0x00438630: entered by fall-through of je at 0x0043862e, 13 instruction(s), ends with forward jump to 0x0043873f
    movsx edx, word ptr [0x5b01fe]               # 00438630
    mov dword ptr [0x5bb57b], edx                # 00438637
    movsx eax, word ptr [0x5b01fe]               # 0043863d
    mov dword ptr [0x5bb57f], eax                # 00438644
    mov cx, word ptr [0x5b0200]                  # 00438649
    mov word ptr [0x5bb599], cx                  # 00438650
    mov dx, word ptr [0x5bb599]                  # 00438657
    mov word ptr [0x5bb597], dx                  # 0043865e
    mov ax, word ptr [0x5b0202]                  # 00438665
    mov word ptr [0x5bb595], ax                  # 0043866b
    mov cx, word ptr [0x5bb595]                  # 00438671
    mov word ptr [0x5bb593], cx                  # 00438678
    jmp.d32 L_0043873f                           # 0043867f
L_00438684:
    # block 0x00438684: entered by je at 0x0043862e, 2 instruction(s), ends with jne to 0x00438696 (forward)
    cmp dword ptr [0x63a4d1], 0x0                # 00438684
    jne.d8 L_00438696                            # 0043868b
    # block 0x0043868d: entered by fall-through of jne at 0x0043868b, 2 instruction(s), ends with je to 0x004386f0 (forward)
    cmp dword ptr [0x63a4d5], 0x0                # 0043868d
    je.d8 L_004386f0                             # 00438694
L_00438696:
    # block 0x00438696: entered by jne at 0x0043868b; fall-through of je at 0x00438694, 15 instruction(s), ends with forward jump to 0x0043873f
    mov edx, dword ptr [0x63a4dd]                # 00438696
    mov dword ptr [0x5bb57b], edx                # 0043869c
    mov eax, dword ptr [0x63a4dd]                # 004386a2
    mov dword ptr [0x5bb57f], eax                # 004386a7
    mov ecx, dword ptr [0x63a4dd]                # 004386ac
    mov dword ptr [0x63a4ed], ecx                # 004386b2
    mov dx, word ptr [0x5b01f2]                  # 004386b8
    mov word ptr [0x5bb599], dx                  # 004386bf
    mov ax, word ptr [0x5bb599]                  # 004386c6
    mov word ptr [0x5bb597], ax                  # 004386cc
    mov cx, word ptr [0x5b01f4]                  # 004386d2
    mov word ptr [0x5bb595], cx                  # 004386d9
    mov dx, word ptr [0x5bb595]                  # 004386e0
    mov word ptr [0x5bb593], dx                  # 004386e7
    jmp.d8 L_0043873f                            # 004386ee
L_004386f0:
    # block 0x004386f0: entered by je at 0x00438694, 12 instruction(s), falls into the block at 0x0043873f
    movsx eax, word ptr [0x5b01f0]               # 004386f0
    mov dword ptr [0x5bb57b], eax                # 004386f7
    movsx ecx, word ptr [0x5b01f0]               # 004386fc
    mov dword ptr [0x5bb57f], ecx                # 00438703
    mov dx, word ptr [0x5b01f2]                  # 00438709
    mov word ptr [0x5bb599], dx                  # 00438710
    mov ax, word ptr [0x5bb599]                  # 00438717
    mov word ptr [0x5bb597], ax                  # 0043871d
    mov cx, word ptr [0x5b01f4]                  # 00438723
    mov word ptr [0x5bb595], cx                  # 0043872a
    mov dx, word ptr [0x5bb595]                  # 00438731
    mov word ptr [0x5bb593], dx                  # 00438738
L_0043873f:
    # block 0x0043873f: entered by jmp at 0x0043867f; jmp at 0x004386ee, 2 instruction(s), ends with je to 0x004388e7 (forward)
    cmp dword ptr [0x63a4d9], 0x0                # 0043873f
    je.d32 L_004388e7                            # 00438746
    # block 0x0043874c: entered by fall-through of je at 0x00438746, 2 instruction(s), ends with jne to 0x004387a7 (forward)
    cmp dword ptr [0x63a4ed], -0x1               # 0043874c
    jne.d8 L_004387a7                            # 00438753
    # block 0x00438755: entered by fall-through of jne at 0x00438753, 10 instruction(s), calls FUN_0050ca3e, FUN_004264e8, ends with je to 0x0043878e (forward)
    push 0x546a8c                                # 00438755
    push 0x63888b                                # 0043875a
    call FUN_0050ca3e                            # 0043875f
    add esp, 0x8                                 # 00438764
    push 0x63888b                                # 00438767
    mov ecx, 0x583979                            # 0043876c
    call FUN_004264e8                            # 00438771
    movsx eax, word ptr [0x63a4cd]               # 00438776
    test eax, eax                                # 0043877d
    je.d8 L_0043878e                             # 0043877f
    # block 0x00438781: entered by fall-through of je at 0x0043877f, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0043878e
    push 0x63888b                                # 00438781
    call FUN_0044a2b7                            # 00438786
    add esp, 0x4                                 # 0043878b
L_0043878e:
    # block 0x0043878e: entered by je at 0x0043877f, 4 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x004397eb
    mov dword ptr [0x63a58a], 0x1                # 0043878e
    mov ecx, 0x5cf659                            # 00438798
    call FUN_004c97b4                            # 0043879d
    jmp.d32 L_004397eb                           # 004387a2
L_004387a7:
    # block 0x004387a7: entered by jne at 0x00438753, 16 instruction(s), calls FUN_0050cd72, FUN_0050d0a9, ends with jne to 0x00438845 (forward)
    push 0x546acc                                # 004387a7
    push 0x546ad4                                # 004387ac
    push 0x639aa2                                # 004387b1
    push 0x639a9f                                # 004387b6
    lea ecx, [ebp - local_10c]                   # 004387bb
    push ecx                                     # 004387c1
    call FUN_0050cd72                            # 004387c2
    add esp, 0x14                                # 004387c7
    push 0x546ae0                                # 004387ca
    lea edx, [ebp - local_10c]                   # 004387cf
    push edx                                     # 004387d5
    call FUN_0050d0a9                            # 004387d6
    add esp, 0x8                                 # 004387db
    mov dword ptr [0x63a4f1], eax                # 004387de
    cmp dword ptr [0x63a4f1], 0x0                # 004387e3
    jne.d8 L_00438845                            # 004387ea
    # block 0x004387ec: entered by fall-through of jne at 0x004387ea, 12 instruction(s), calls FUN_0050ca3e, FUN_004264e8, ends with je to 0x0043882c (forward)
    lea eax, [ebp - local_10c]                   # 004387ec
    push eax                                     # 004387f2
    push 0x546ae4                                # 004387f3
    push 0x63888b                                # 004387f8
    call FUN_0050ca3e                            # 004387fd
    add esp, 0xc                                 # 00438802
    push 0x63888b                                # 00438805
    mov ecx, 0x583979                            # 0043880a
    call FUN_004264e8                            # 0043880f
    movsx ecx, word ptr [0x63a4cd]               # 00438814
    test ecx, ecx                                # 0043881b
    je.d8 L_0043882c                             # 0043881d
    # block 0x0043881f: entered by fall-through of je at 0x0043881d, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0043882c
    push 0x63888b                                # 0043881f
    call FUN_0044a2b7                            # 00438824
    add esp, 0x4                                 # 00438829
L_0043882c:
    # block 0x0043882c: entered by je at 0x0043881d, 4 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x004397eb
    mov dword ptr [0x63a58a], 0x6                # 0043882c
    mov ecx, 0x5cf659                            # 00438836
    call FUN_004c97b4                            # 0043883b
    jmp.d32 L_004397eb                           # 00438840
L_00438845:
    # block 0x00438845: entered by jne at 0x004387ea, 3 instruction(s), ends with jne to 0x0043886d (forward)
    mov edx, dword ptr [0x63a4dd]                # 00438845
    cmp edx, dword ptr [0x63a4e1]                # 0043884b
    jne.d8 L_0043886d                            # 00438851
    # block 0x00438853: entered by fall-through of jne at 0x00438851, 7 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x0043889c
    mov eax, dword ptr [0x63a4dd]                # 00438853
    push eax                                     # 00438858
    push 0x546b10                                # 00438859
    push 0x63888b                                # 0043885e
    call FUN_0050ca3e                            # 00438863
    add esp, 0xc                                 # 00438868
    jmp.d8 L_0043889c                            # 0043886b
L_0043886d:
    # block 0x0043886d: entered by jne at 0x00438851, 12 instruction(s), calls FUN_0050ca3e, falls into the block at 0x0043889c
    mov ecx, dword ptr [0x63a4e1]                # 0043886d
    push ecx                                     # 00438873
    mov edx, dword ptr [0x63a4dd]                # 00438874
    push edx                                     # 0043887a
    mov eax, dword ptr [0x63a4e1]                # 0043887b
    sub eax, dword ptr [0x63a4dd]                # 00438880
    add eax, 0x1                                 # 00438886
    push eax                                     # 00438889
    push 0x546b3c                                # 0043888a
    push 0x63888b                                # 0043888f
    call FUN_0050ca3e                            # 00438894
    add esp, 0x14                                # 00438899
L_0043889c:
    # block 0x0043889c: entered by jmp at 0x0043886b, 17 instruction(s), calls FUN_0043d7c4, FUN_0050ca3e, falls into the block at 0x004388e7
    push 0x63888b                                # 0043889c
    call FUN_0043d7c4                            # 004388a1
    add esp, 0x4                                 # 004388a6
    push 0x546b70                                # 004388a9
    push 0x63888b                                # 004388ae
    call FUN_0050ca3e                            # 004388b3
    add esp, 0x8                                 # 004388b8
    push 0x63888b                                # 004388bb
    call FUN_0043d7c4                            # 004388c0
    add esp, 0x4                                 # 004388c5
    push 0x546b9c                                # 004388c8
    push 0x63888b                                # 004388cd
    call FUN_0050ca3e                            # 004388d2
    add esp, 0x8                                 # 004388d7
    push 0x63888b                                # 004388da
    call FUN_0043d7c4                            # 004388df
    add esp, 0x4                                 # 004388e4
L_004388e7:
    # block 0x004388e7: entered by je at 0x00438746, 2 instruction(s), ends with forward jump to 0x004388f9
    mov dword ptr [ebp - local_8], 0x0           # 004388e7
    jmp.d8 L_004388f9                            # 004388ee
L_004388f0:
    # block 0x004388f0: entered by jmp at 0x00438a33, 3 instruction(s), falls into the block at 0x004388f9
    mov ecx, dword ptr [ebp - local_8]           # 004388f0
    add ecx, 0x1                                 # 004388f3
    mov dword ptr [ebp - local_8], ecx           # 004388f6
L_004388f9:
    # block 0x004388f9: entered by jmp at 0x004388ee, 2 instruction(s), ends with jge to 0x00438a38 (forward)
    cmp dword ptr [ebp - local_8], 0xf0          # 004388f9
    jge.d32 L_00438a38                           # 00438900
    # block 0x00438906: entered by fall-through of jge at 0x00438900, 10 instruction(s), ends with ja to 0x0043896c (forward)
    mov edx, dword ptr [ebp - local_8]           # 00438906
    imul edx, edx, 0x8d                          # 00438909
    {load} xor eax, eax                          # 0043890f
    mov al, byte ptr [edx + 0x5bb5e3]            # 00438911
    mov dword ptr [ebp - local_114], eax         # 00438917
    mov ecx, dword ptr [ebp - local_114]         # 0043891d
    sub ecx, 0x1b                                # 00438923
    mov dword ptr [ebp - local_114], ecx         # 00438926
    cmp dword ptr [ebp - local_114], 0x24        # 0043892c
    ja.d8 L_0043896c                             # 00438933
    # block 0x00438935: entered by fall-through of ja at 0x00438933, 4 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4397f1]
    mov eax, dword ptr [ebp - local_114]         # 00438935
    {load} xor edx, edx                          # 0043893b
    mov dl, byte ptr [eax + IDXTAB_004397fd_VA]  # 0043893d
    jmp dword ptr [4*edx + SWTAB_004397f1_VA]    # 00438943
L_0043894a:
    # block 0x0043894a: entered by switch case, 5 instruction(s), calls FUN_0041db40, ends with forward jump to 0x004389b5
    mov cx, word ptr [ebp - local_8]             # 0043894a
    push ecx                                     # 0043894e
    mov ecx, 0x6177e8                            # 0043894f
    call FUN_0041db40                            # 00438954
    jmp.d8 L_004389b5                            # 00438959
L_0043895b:
    # block 0x0043895b: entered by switch case, 5 instruction(s), calls FUN_004145d0, ends with forward jump to 0x004389b5
    mov dx, word ptr [ebp - local_8]             # 0043895b
    push edx                                     # 0043895f
    mov ecx, 0x6385db                            # 00438960
    call FUN_004145d0                            # 00438965
    jmp.d8 L_004389b5                            # 0043896a
L_0043896c:
    # block 0x0043896c: entered by ja at 0x00438933; switch case, 4 instruction(s), ends with je to 0x004389b5 (forward)
    mov eax, dword ptr [ebp - local_8]           # 0043896c
    imul eax, eax, 0x8d                          # 0043896f
    cmp dword ptr [eax + 0x5bb5e5], 0x0          # 00438975
    je.d8 L_004389b5                             # 0043897c
    # block 0x0043897e: entered by fall-through of je at 0x0043897c, 11 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004389b5
    mov ecx, dword ptr [ebp - local_8]           # 0043897e
    imul ecx, ecx, 0x8d                          # 00438981
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00438987
    mov dword ptr [ebp - local_110], edx         # 0043898d
    mov eax, dword ptr [ebp - local_110]         # 00438993
    push eax                                     # 00438999
    call FUN_0051dc6c                            # 0043899a
    add esp, 0x4                                 # 0043899f
    mov ecx, dword ptr [ebp - local_8]           # 004389a2
    imul ecx, ecx, 0x8d                          # 004389a5
    mov dword ptr [ecx + 0x5bb5e5], 0x0          # 004389ab
L_004389b5:
    # block 0x004389b5: entered by jmp at 0x00438959; jmp at 0x0043896a; je at 0x0043897c, 22 instruction(s), ends with backward jump to 0x004388f0
    mov edx, dword ptr [ebp - local_8]           # 004389b5
    imul edx, edx, 0x8d                          # 004389b8
    mov byte ptr [edx + 0x5bb5e3], 0x0           # 004389be
    mov eax, dword ptr [ebp - local_8]           # 004389c5
    imul eax, eax, 0x8d                          # 004389c8
    mov byte ptr [eax + 0x5bb625], 0x0           # 004389ce
    mov ecx, dword ptr [ebp - local_8]           # 004389d5
    imul ecx, ecx, 0x8d                          # 004389d8
    mov dword ptr [ecx + 0x5bb626], 0x0          # 004389de
    mov edx, dword ptr [ebp - local_8]           # 004389e8
    imul edx, edx, 0x8d                          # 004389eb
    mov dword ptr [edx + 0x5bb632], 0x0          # 004389f1
    mov eax, dword ptr [ebp - local_8]           # 004389fb
    imul eax, eax, 0x8d                          # 004389fe
    mov word ptr [eax + 0x5bb636], 0xffff        # 00438a04
    mov ecx, dword ptr [ebp - local_8]           # 00438a0d
    imul ecx, ecx, 0x8d                          # 00438a10
    mov dword ptr [ecx + 0x5bb638], 0x1          # 00438a16
    mov edx, dword ptr [ebp - local_8]           # 00438a20
    imul edx, edx, 0x8d                          # 00438a23
    mov dword ptr [edx + 0x5bb63c], 0x0          # 00438a29
    jmp.d32 L_004388f0                           # 00438a33
L_00438a38:
    # block 0x00438a38: entered by jge at 0x00438900, 7 instruction(s), calls FUN_00423af1, ends with forward jump to 0x00438a72
    mov ecx, 0x63786d                            # 00438a38
    call FUN_00423af1                            # 00438a3d
    mov dword ptr [0x5bb214], 0x1                # 00438a42
    mov dword ptr [0x5bb210], 0x0                # 00438a4c
    mov dword ptr [0x5bb1ca], 0x0                # 00438a56
    mov dword ptr [ebp - local_8], 0x0           # 00438a60
    jmp.d8 L_00438a72                            # 00438a67
L_00438a69:
    # block 0x00438a69: entered by jmp at 0x00438a85, 3 instruction(s), falls into the block at 0x00438a72
    mov eax, dword ptr [ebp - local_8]           # 00438a69
    add eax, 0x1                                 # 00438a6c
    mov dword ptr [ebp - local_8], eax           # 00438a6f
L_00438a72:
    # block 0x00438a72: entered by jmp at 0x00438a67, 2 instruction(s), ends with jge to 0x00438a87 (forward)
    cmp dword ptr [ebp - local_8], 0x58          # 00438a72
    jge.d8 L_00438a87                            # 00438a76
    # block 0x00438a78: entered by fall-through of jge at 0x00438a76, 5 instruction(s), calls FUN_004d3992, ends with backward jump to 0x00438a69
    mov cx, word ptr [ebp - local_8]             # 00438a78
    push ecx                                     # 00438a7c
    call FUN_004d3992                            # 00438a7d
    add esp, 0x4                                 # 00438a82
    jmp.d8 L_00438a69                            # 00438a85
L_00438a87:
    # block 0x00438a87: entered by jge at 0x00438a76, 3 instruction(s), ends with je to 0x00438aa6 (forward)
    mov byte ptr [0x5b5158], 0x0                 # 00438a87
    cmp dword ptr [0x5d03cf], 0x0                # 00438a8e
    je.d8 L_00438aa6                             # 00438a95
    # block 0x00438a97: entered by fall-through of je at 0x00438a95, 3 instruction(s), calls FUN_004c2dfb, falls into the block at 0x00438aa6
    push 0x5d03cf                                # 00438a97
    mov ecx, 0x5cf659                            # 00438a9c
    call FUN_004c2dfb                            # 00438aa1
L_00438aa6:
    # block 0x00438aa6: entered by je at 0x00438a95, 3 instruction(s), ends with je to 0x00438ac5 (forward)
    mov byte ptr [0x5b51ab], 0x0                 # 00438aa6
    cmp dword ptr [0x5d03d3], 0x0                # 00438aad
    je.d8 L_00438ac5                             # 00438ab4
    # block 0x00438ab6: entered by fall-through of je at 0x00438ab4, 3 instruction(s), calls FUN_004c2dfb, falls into the block at 0x00438ac5
    push 0x5d03d3                                # 00438ab6
    mov ecx, 0x5cf659                            # 00438abb
    call FUN_004c2dfb                            # 00438ac0
L_00438ac5:
    # block 0x00438ac5: entered by je at 0x00438ab4, 3 instruction(s), ends with je to 0x00438ae4 (forward)
    mov byte ptr [0x5b51c6], 0x0                 # 00438ac5
    cmp dword ptr [0x5d03d7], 0x0                # 00438acc
    je.d8 L_00438ae4                             # 00438ad3
    # block 0x00438ad5: entered by fall-through of je at 0x00438ad3, 3 instruction(s), calls FUN_004c2dfb, falls into the block at 0x00438ae4
    push 0x5d03d7                                # 00438ad5
    mov ecx, 0x5cf659                            # 00438ada
    call FUN_004c2dfb                            # 00438adf
L_00438ae4:
    # block 0x00438ae4: entered by je at 0x00438ad3, 3 instruction(s), ends with je to 0x00438b03 (forward)
    mov byte ptr [0x5b615e], 0x0                 # 00438ae4
    cmp dword ptr [0x5d03db], 0x0                # 00438aeb
    je.d8 L_00438b03                             # 00438af2
    # block 0x00438af4: entered by fall-through of je at 0x00438af2, 3 instruction(s), calls FUN_004c2dfb, falls into the block at 0x00438b03
    push 0x5d03db                                # 00438af4
    mov ecx, 0x5cf659                            # 00438af9
    call FUN_004c2dfb                            # 00438afe
L_00438b03:
    # block 0x00438b03: entered by je at 0x00438af2, 99 instruction(s), calls FUN_00468f19, FUN_004b3d4d, FUN_00459b87, FUN_004a3884, FUN_0048a7e5, FUN_00488e54, FUN_0041114f,..., ends with je to 0x00438d02 (forward)
    mov ecx, 0x616ab2                            # 00438b03
    call FUN_00468f19                            # 00438b08
    mov ecx, 0x617066                            # 00438b0d
    call FUN_004b3d4d                            # 00438b12
    mov ecx, 0x61c7ed                            # 00438b17
    call FUN_00459b87                            # 00438b1c
    mov ecx, 0x61c8cf                            # 00438b21
    call FUN_004a3884                            # 00438b26
    mov ecx, 0x61d10f                            # 00438b2b
    call FUN_0048a7e5                            # 00438b30
    mov ecx, 0x619935                            # 00438b35
    call FUN_00488e54                            # 00438b3a
    mov ecx, 0x619a41                            # 00438b3f
    call FUN_0041114f                            # 00438b44
    mov ecx, 0x61d2dd                            # 00438b49
    call FUN_004a1cb1                            # 00438b4e
    mov ecx, 0x624dc9                            # 00438b53
    call FUN_0048e2f5                            # 00438b58
    mov ecx, 0x61d345                            # 00438b5d
    call FUN_0048d09c                            # 00438b62
    mov ecx, 0x61d3a1                            # 00438b67
    call FUN_004a63dc                            # 00438b6c
    mov ecx, 0x61d449                            # 00438b71
    call FUN_004b5bc8                            # 00438b76
    mov ecx, 0x61d6c1                            # 00438b7b
    call FUN_004ab3dc                            # 00438b80
    mov ecx, 0x61d723                            # 00438b85
    call FUN_00465b3c                            # 00438b8a
    mov ecx, 0x61d779                            # 00438b8f
    call FUN_00461862                            # 00438b94
    mov ecx, 0x61d7d8                            # 00438b99
    call FUN_00487b4f                            # 00438b9e
    mov ecx, 0x6204c1                            # 00438ba3
    call FUN_004afd7e                            # 00438ba8
    mov ecx, 0x62387c                            # 00438bad
    call FUN_00470ddc                            # 00438bb2
    mov ecx, 0x621a02                            # 00438bb7
    call FUN_0047823e                            # 00438bbc
    mov ecx, 0x61d873                            # 00438bc1
    call FUN_0044f996                            # 00438bc6
    mov ecx, 0x61e398                            # 00438bcb
    call FUN_0047b321                            # 00438bd0
    mov ecx, 0x61df56                            # 00438bd5
    call FUN_004ba07f                            # 00438bda
    mov ecx, 0x622fa2                            # 00438bdf
    call FUN_00475885                            # 00438be4
    mov ecx, 0x624686                            # 00438be9
    call FUN_0048bb86                            # 00438bee
    mov ecx, 0x6246dc                            # 00438bf3
    call FUN_0047d59b                            # 00438bf8
    mov ecx, 0x624734                            # 00438bfd
    call FUN_0045b42e                            # 00438c02
    mov ecx, 0x6248ed                            # 00438c07
    call FUN_00456d2e                            # 00438c0c
    mov ecx, 0x624931                            # 00438c11
    call FUN_0044e78e                            # 00438c16
    mov ecx, 0x6249a0                            # 00438c1b
    call FUN_004b7229                            # 00438c20
    mov ecx, 0x6249dc                            # 00438c25
    call FUN_00454de6                            # 00438c2a
    mov ecx, 0x630a34                            # 00438c2f
    call FUN_004a9f63                            # 00438c34
    mov ecx, 0x6252ad                            # 00438c39
    call FUN_00483fb5                            # 00438c3e
    mov ecx, 0x625ee8                            # 00438c43
    call FUN_0047e2a5                            # 00438c48
    mov ecx, 0x627335                            # 00438c4d
    call FUN_004a7d1d                            # 00438c52
    mov ecx, 0x61e65c                            # 00438c57
    call FUN_00467608                            # 00438c5c
    mov ecx, 0x61e95c                            # 00438c61
    call FUN_004730a6                            # 00438c66
    mov ecx, 0x61ed7b                            # 00438c6b
    call FUN_00457fc2                            # 00438c70
    mov ecx, 0x61ee6e                            # 00438c75
    call FUN_004b7ff4                            # 00438c7a
    mov ecx, 0x61f4b1                            # 00438c7f
    call FUN_0045dd4d                            # 00438c84
    mov ecx, 0x628732                            # 00438c89
    call FUN_0046b67f                            # 00438c8e
    mov ecx, 0x624b50                            # 00438c93
    call FUN_00464076                            # 00438c98
    mov ecx, 0x624c2a                            # 00438c9d
    call FUN_0046e7a6                            # 00438ca2
    mov ecx, 0x624cbf                            # 00438ca7
    call FUN_0044d154                            # 00438cac
    mov ecx, 0x624d12                            # 00438cb1
    call FUN_004821ab                            # 00438cb6
    mov ecx, 0x63847b                            # 00438cbb
    call FUN_004caf8a                            # 00438cc0
    mov ecx, 0x638603                            # 00438cc5
    call FUN_00445f40                            # 00438cca
    mov ecx, 0x6369e4                            # 00438ccf
    call FUN_004ac97d                            # 00438cd4
    mov ecx, 0x63786d                            # 00438cd9
    call FUN_004234b5                            # 00438cde
    mov byte ptr [0x5b51f6], 0x0                 # 00438ce3
    cmp dword ptr [0x5d03df], 0x0                # 00438cea
    je.d8 L_00438d02                             # 00438cf1
    # block 0x00438cf3: entered by fall-through of je at 0x00438cf1, 3 instruction(s), calls FUN_004c2dfb, falls into the block at 0x00438d02
    push 0x5d03df                                # 00438cf3
    mov ecx, 0x5cf659                            # 00438cf8
    call FUN_004c2dfb                            # 00438cfd
L_00438d02:
    # block 0x00438d02: entered by je at 0x00438cf1, 14 instruction(s), calls FUN_0044aff2, FUN_004dad60, FUN_004e7e15, FUN_004db870, ends with jne to 0x00438d7b (forward)
    mov ecx, 0x637fb1                            # 00438d02
    call FUN_0044aff2                            # 00438d07
    mov dword ptr [0x5a4c1c], 0x1                # 00438d0c
    mov dword ptr [0x5a4c20], 0x0                # 00438d16
    mov ecx, 0x5830a6                            # 00438d20
    call FUN_004dad60                            # 00438d25
    mov dword ptr [0x583985], 0xe                # 00438d2a
    mov ecx, 0x571442                            # 00438d34
    call FUN_004e7e15                            # 00438d39
    mov ecx, 0x5830ce                            # 00438d3e
    call FUN_004db870                            # 00438d43
    mov dword ptr [0x5839a9], 0x0                # 00438d48
    cmp dword ptr [0x5d0377], 0x0                # 00438d52
    jne.d8 L_00438d7b                            # 00438d59
    # block 0x00438d5b: entered by fall-through of jne at 0x00438d59, 7 instruction(s), calls FUN_004c2790, falls into the block at 0x00438d7b
    push 0x546be0                                # 00438d5b
    push 0x6                                     # 00438d60
    push 0x5b06aa                                # 00438d62
    push 0x546bec                                # 00438d67
    mov ecx, 0x5cf659                            # 00438d6c
    call FUN_004c2790                            # 00438d71
    mov dword ptr [0x5d0377], eax                # 00438d76
L_00438d7b:
    # block 0x00438d7b: entered by jne at 0x00438d59, 2 instruction(s), ends with jne to 0x00438d98 (forward)
    cmp dword ptr [0x5bb1de], 0x0                # 00438d7b
    jne.d8 L_00438d98                            # 00438d82
    # block 0x00438d84: entered by fall-through of jne at 0x00438d82, 4 instruction(s), calls FUN_0041c133, FUN_00411215, falls into the block at 0x00438d98
    mov ecx, 0x6177e8                            # 00438d84
    call FUN_0041c133                            # 00438d89
    mov ecx, 0x619a41                            # 00438d8e
    call FUN_00411215                            # 00438d93
L_00438d98:
    # block 0x00438d98: entered by jne at 0x00438d82, 15 instruction(s), calls FUN_00447c1c, FUN_004de2d8, ends with forward jump to 0x00438e13
    mov ecx, 0x6198d7                            # 00438d98
    call FUN_00447c1c                            # 00438d9d
    mov ecx, 0x61f864                            # 00438da2
    call FUN_004de2d8                            # 00438da7
    mov dword ptr [0x5b15da], 0x0                # 00438dac
    mov dword ptr [0x5b15c8], 0x0                # 00438db6
    mov word ptr [0x5b15cc], 0xffff              # 00438dc0
    mov word ptr [0x5b15ce], 0xffff              # 00438dc9
    mov word ptr [0x5b15d4], 0xffff              # 00438dd2
    mov word ptr [0x5b0a8e], 0x0                 # 00438ddb
    mov dword ptr [0x5b0a78], 0x0                # 00438de4
    mov word ptr [0x5b0a90], 0x0                 # 00438dee
    mov dword ptr [0x5b15d6], 0x0                # 00438df7
    mov dword ptr [ebp - local_8], 0x0           # 00438e01
    jmp.d8 L_00438e13                            # 00438e08
L_00438e0a:
    # block 0x00438e0a: entered by jmp at 0x00438e2f, 3 instruction(s), falls into the block at 0x00438e13
    mov edx, dword ptr [ebp - local_8]           # 00438e0a
    add edx, 0x1                                 # 00438e0d
    mov dword ptr [ebp - local_8], edx           # 00438e10
L_00438e13:
    # block 0x00438e13: entered by jmp at 0x00438e08, 2 instruction(s), ends with jge to 0x00438e31 (forward)
    cmp dword ptr [ebp - local_8], 0x3c          # 00438e13
    jge.d8 L_00438e31                            # 00438e17
    # block 0x00438e19: entered by fall-through of jge at 0x00438e17, 8 instruction(s), ends with backward jump to 0x00438e0a
    mov ecx, 0x8                                 # 00438e19
    {load} xor eax, eax                          # 00438e1e
    mov edi, dword ptr [ebp - local_8]           # 00438e20
    imul edi, edi, 0x29                          # 00438e23
    add edi, 0x5b0a9a                            # 00438e26
    rep stosd dword ptr es:[edi], eax            # 00438e2c
    stosb byte ptr es:[edi], al                  # 00438e2e
    jmp.d8 L_00438e0a                            # 00438e2f
L_00438e31:
    # block 0x00438e31: entered by jge at 0x00438e17, 2 instruction(s), ends with forward jump to 0x00438e43
    mov dword ptr [ebp - local_8], 0x0           # 00438e31
    jmp.d8 L_00438e43                            # 00438e38
L_00438e3a:
    # block 0x00438e3a: entered by jmp at 0x00438e56, 3 instruction(s), falls into the block at 0x00438e43
    mov eax, dword ptr [ebp - local_8]           # 00438e3a
    add eax, 0x1                                 # 00438e3d
    mov dword ptr [ebp - local_8], eax           # 00438e40
L_00438e43:
    # block 0x00438e43: entered by jmp at 0x00438e38, 2 instruction(s), ends with jge to 0x00438e58 (forward)
    cmp dword ptr [ebp - local_8], 0xa           # 00438e43
    jge.d8 L_00438e58                            # 00438e47
    # block 0x00438e49: entered by fall-through of jge at 0x00438e47, 4 instruction(s), ends with backward jump to 0x00438e3a
    mov ecx, dword ptr [ebp - local_8]           # 00438e49
    imul ecx, ecx, 0x29                          # 00438e4c
    mov byte ptr [ecx + 0x5b1436], 0x0           # 00438e4f
    jmp.d8 L_00438e3a                            # 00438e56
L_00438e58:
    # block 0x00438e58: entered by jge at 0x00438e47, 473 instruction(s), calls FUN_0050ce04, FUN_0041e33b, FUN_004c0b8b, FUN_004cecf7, ends with je to 0x004397eb (forward)
    mov edx, dword ptr [0x5b0a2e]                # 00438e58
    sub edx, dword ptr [0x5b0a26]                # 00438e5e
    add edx, 0x1                                 # 00438e64
    mov eax, dword ptr [0x5b0a1e]                # 00438e67
    sub eax, dword ptr [0x5b0a16]                # 00438e6c
    add eax, 0x1                                 # 00438e72
    {load} sub edx, eax                          # 00438e75
    mov word ptr [0x5b0a7c], dx                  # 00438e77
    movsx ecx, word ptr [0x5b0a7c]               # 00438e7e
    mov dword ptr [ebp - local_118], ecx         # 00438e85
    fild dword ptr [ebp - local_118]             # 00438e8b
    fstp dword ptr [ebp - local_11c]             # 00438e91
    fld dword ptr [0x5b0a78]                     # 00438e97
    fmul dword ptr [ebp - local_11c]             # 00438e9d
    call FUN_0050ce04                            # 00438ea3
    mov dword ptr [0x5b0a82], eax                # 00438ea8
    mov edx, dword ptr [0x5b0a1e]                # 00438ead
    sub edx, dword ptr [0x5b0a16]                # 00438eb3
    mov eax, dword ptr [0x5b0a82]                # 00438eb9
    {load} add eax, edx                          # 00438ebe
    mov dword ptr [0x5b0a8a], eax                # 00438ec0
    mov ecx, dword ptr [0x5b0a22]                # 00438ec5
    mov dword ptr [0x5b0a7e], ecx                # 00438ecb
    mov edx, dword ptr [0x5b0a2a]                # 00438ed1
    mov dword ptr [0x5b0a86], edx                # 00438ed7
    movsx eax, word ptr [0x5b0a6c]               # 00438edd
    mov dword ptr [ebp - local_120], eax         # 00438ee4
    fild dword ptr [ebp - local_120]             # 00438eea
    fstp dword ptr [ebp - local_124]             # 00438ef0
    fld dword ptr [ebp - local_124]              # 00438ef6
    fdiv qword ptr [0x52c680]                    # 00438efc
    fstp dword ptr [0x5b15d0]                    # 00438f02
    mov dword ptr [0x5b1602], 0x0                # 00438f08
    mov word ptr [0x5b160a], 0xffff              # 00438f12
    mov dword ptr [0x5b1606], 0x0                # 00438f1b
    mov ecx, dword ptr [0x5b0a3a]                # 00438f25
    mov dword ptr [0x5b15f2], ecx                # 00438f2b
    mov edx, dword ptr [0x5b0a3e]                # 00438f31
    mov dword ptr [0x5b15f6], edx                # 00438f37
    mov eax, dword ptr [0x5b0a42]                # 00438f3d
    mov dword ptr [0x5b15fa], eax                # 00438f42
    mov ecx, dword ptr [0x5b0a46]                # 00438f47
    mov dword ptr [0x5b15fe], ecx                # 00438f4d
    mov dword ptr [0x5d1591], 0x1                # 00438f53
    mov dword ptr [0x5d1595], 0x4d00d2           # 00438f5d
    mov edx, dword ptr [0x570c57]                # 00438f67
    mov dword ptr [0x5d1599], edx                # 00438f6d
    mov dword ptr [0x5d159d], 0x5afcf5           # 00438f73
    mov dword ptr [0x5d15a1], 0x5afcf5           # 00438f7d
    mov dword ptr [0x5d15a5], 0x0                # 00438f87
    mov dword ptr [0x5d15a9], 0x1                # 00438f91
    mov word ptr [0x5d15ad], 0x0                 # 00438f9b
    mov edi, 0x546bf4                            # 00438fa4
    mov edx, 0x5d15b3                            # 00438fa9
    or ecx, -0x1                                 # 00438fae
    {load} xor eax, eax                          # 00438fb1
    repne scasb al, byte ptr es:[edi]            # 00438fb3
    not ecx                                      # 00438fb5
    {load} sub edi, ecx                          # 00438fb7
    {load} mov esi, edi                          # 00438fb9
    {load} mov eax, ecx                          # 00438fbb
    {load} mov edi, edx                          # 00438fbd
    shr ecx, 0x2                                 # 00438fbf
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00438fc2
    {load} mov ecx, eax                          # 00438fc4
    and ecx, 0x3                                 # 00438fc6
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00438fc9
    mov dword ptr [0x5d1625], 0x14               # 00438fcb
    mov dword ptr [0x5d1629], 0x0                # 00438fd5
    mov ecx, dword ptr [0x5d0377]                # 00438fdf
    mov dword ptr [0x5d162d], ecx                # 00438fe5
    mov dword ptr [0x5d1631], 0x0                # 00438feb
    mov dword ptr [0x5d1635], 0x583102           # 00438ff5
    mov dword ptr [0x5d1639], 0x0                # 00438fff
    mov dword ptr [0x5d163d], 0x1                # 00439009
    mov word ptr [0x5d1641], 0x2                 # 00439013
    mov edi, 0x546bfc                            # 0043901c
    mov edx, 0x5d1647                            # 00439021
    or ecx, -0x1                                 # 00439026
    {load} xor eax, eax                          # 00439029
    repne scasb al, byte ptr es:[edi]            # 0043902b
    not ecx                                      # 0043902d
    {load} sub edi, ecx                          # 0043902f
    {load} mov esi, edi                          # 00439031
    {load} mov eax, ecx                          # 00439033
    {load} mov edi, edx                          # 00439035
    shr ecx, 0x2                                 # 00439037
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043903a
    {load} mov ecx, eax                          # 0043903c
    and ecx, 0x3                                 # 0043903e
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00439041
    mov dword ptr [0x5d166f], 0x2                # 00439043
    mov dword ptr [0x5d1673], 0x0                # 0043904d
    mov ecx, dword ptr [0x570c57]                # 00439057
    mov dword ptr [0x5d1677], ecx                # 0043905d
    mov dword ptr [0x5d167b], 0x5830f2           # 00439063
    mov dword ptr [0x5d167f], 0x5830f2           # 0043906d
    mov dword ptr [0x5d1683], 0x0                # 00439077
    mov dword ptr [0x5d1687], 0x1                # 00439081
    mov word ptr [0x5d168b], 0x1                 # 0043908b
    mov edi, 0x546c10                            # 00439094
    mov edx, 0x5d1691                            # 00439099
    or ecx, -0x1                                 # 0043909e
    {load} xor eax, eax                          # 004390a1
    repne scasb al, byte ptr es:[edi]            # 004390a3
    not ecx                                      # 004390a5
    {load} sub edi, ecx                          # 004390a7
    {load} mov esi, edi                          # 004390a9
    {load} mov eax, ecx                          # 004390ab
    {load} mov edi, edx                          # 004390ad
    shr ecx, 0x2                                 # 004390af
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004390b2
    {load} mov ecx, eax                          # 004390b4
    and ecx, 0x3                                 # 004390b6
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004390b9
    mov dword ptr [0x5d16b9], 0x3                # 004390bb
    mov dword ptr [0x5d16bd], 0x0                # 004390c5
    mov ecx, dword ptr [0x5d03bb]                # 004390cf
    mov dword ptr [0x5d16c1], ecx                # 004390d5
    mov dword ptr [0x5d16c5], 0x583112           # 004390db
    mov dword ptr [0x5d16c9], 0x583122           # 004390e5
    mov dword ptr [0x5d16cd], 0x0                # 004390ef
    mov dword ptr [0x5d16d1], 0x1                # 004390f9
    mov word ptr [0x5d16d5], 0x1                 # 00439103
    mov edi, 0x546c2c                            # 0043910c
    mov edx, 0x5d16db                            # 00439111
    or ecx, -0x1                                 # 00439116
    {load} xor eax, eax                          # 00439119
    repne scasb al, byte ptr es:[edi]            # 0043911b
    not ecx                                      # 0043911d
    {load} sub edi, ecx                          # 0043911f
    {load} mov esi, edi                          # 00439121
    {load} mov eax, ecx                          # 00439123
    {load} mov edi, edx                          # 00439125
    shr ecx, 0x2                                 # 00439127
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043912a
    {load} mov ecx, eax                          # 0043912c
    and ecx, 0x3                                 # 0043912e
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00439131
    mov dword ptr [0x5d174d], 0x13               # 00439133
    mov dword ptr [0x5d1751], 0x4d1898           # 0043913d
    mov dword ptr [0x5d1755], 0x0                # 00439147
    mov dword ptr [0x5d1759], 0x0                # 00439151
    mov dword ptr [0x5d175d], 0x0                # 0043915b
    mov dword ptr [0x5d1761], 0x0                # 00439165
    mov dword ptr [0x5d1765], 0x1                # 0043916f
    mov word ptr [0x5d1769], 0x2                 # 00439179
    mov edi, 0x546c44                            # 00439182
    mov edx, 0x5d176f                            # 00439187
    or ecx, -0x1                                 # 0043918c
    {load} xor eax, eax                          # 0043918f
    repne scasb al, byte ptr es:[edi]            # 00439191
    not ecx                                      # 00439193
    {load} sub edi, ecx                          # 00439195
    {load} mov esi, edi                          # 00439197
    {load} mov eax, ecx                          # 00439199
    {load} mov edi, edx                          # 0043919b
    shr ecx, 0x2                                 # 0043919d
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004391a0
    {load} mov ecx, eax                          # 004391a2
    and ecx, 0x3                                 # 004391a4
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004391a7
    mov dword ptr [0x5d1797], 0x13               # 004391a9
    mov dword ptr [0x5d179b], 0x4d0d06           # 004391b3
    mov dword ptr [0x5d179f], 0x0                # 004391bd
    mov dword ptr [0x5d17a3], 0x0                # 004391c7
    mov dword ptr [0x5d17a7], 0x0                # 004391d1
    mov dword ptr [0x5d17ab], 0x0                # 004391db
    mov dword ptr [0x5d17af], 0x1                # 004391e5
    mov word ptr [0x5d17b3], 0x2                 # 004391ef
    mov edi, 0x546c50                            # 004391f8
    mov edx, 0x5d17b9                            # 004391fd
    or ecx, -0x1                                 # 00439202
    {load} xor eax, eax                          # 00439205
    repne scasb al, byte ptr es:[edi]            # 00439207
    not ecx                                      # 00439209
    {load} sub edi, ecx                          # 0043920b
    {load} mov esi, edi                          # 0043920d
    {load} mov eax, ecx                          # 0043920f
    {load} mov edi, edx                          # 00439211
    shr ecx, 0x2                                 # 00439213
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00439216
    {load} mov ecx, eax                          # 00439218
    and ecx, 0x3                                 # 0043921a
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043921d
    mov dword ptr [0x5d17e1], 0x12               # 0043921f
    mov dword ptr [0x5d17e5], 0x0                # 00439229
    mov ecx, dword ptr [0x5d03af]                # 00439233
    mov dword ptr [0x5d17e9], ecx                # 00439239
    mov dword ptr [0x5d17ed], 0x5b0a7e           # 0043923f
    mov dword ptr [0x5d17f1], 0x5b0227           # 00439249
    mov dword ptr [0x5d17f5], 0x0                # 00439253
    mov dword ptr [0x5d17f9], 0x1                # 0043925d
    mov word ptr [0x5d17fd], 0x1                 # 00439267
    mov edi, 0x546c58                            # 00439270
    mov edx, 0x5d1803                            # 00439275
    or ecx, -0x1                                 # 0043927a
    {load} xor eax, eax                          # 0043927d
    repne scasb al, byte ptr es:[edi]            # 0043927f
    not ecx                                      # 00439281
    {load} sub edi, ecx                          # 00439283
    {load} mov esi, edi                          # 00439285
    {load} mov eax, ecx                          # 00439287
    {load} mov edi, edx                          # 00439289
    shr ecx, 0x2                                 # 0043928b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043928e
    {load} mov ecx, eax                          # 00439290
    and ecx, 0x3                                 # 00439292
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00439295
    mov dword ptr [0x5d182b], 0x11               # 00439297
    mov dword ptr [0x5d182f], 0x4d3705           # 004392a1
    mov dword ptr [0x5d1833], 0x0                # 004392ab
    mov dword ptr [0x5d1837], 0x0                # 004392b5
    mov dword ptr [0x5d183b], 0x0                # 004392bf
    mov dword ptr [0x5d183f], 0x0                # 004392c9
    mov dword ptr [0x5d1843], 0x1                # 004392d3
    mov word ptr [0x5d1847], 0x1                 # 004392dd
    mov edi, 0x546c60                            # 004392e6
    mov edx, 0x5d184d                            # 004392eb
    or ecx, -0x1                                 # 004392f0
    {load} xor eax, eax                          # 004392f3
    repne scasb al, byte ptr es:[edi]            # 004392f5
    not ecx                                      # 004392f7
    {load} sub edi, ecx                          # 004392f9
    {load} mov esi, edi                          # 004392fb
    {load} mov eax, ecx                          # 004392fd
    {load} mov edi, edx                          # 004392ff
    shr ecx, 0x2                                 # 00439301
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00439304
    {load} mov ecx, eax                          # 00439306
    and ecx, 0x3                                 # 00439308
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043930b
    mov dword ptr [0x5d1875], 0x12               # 0043930d
    mov dword ptr [0x5d1879], 0x0                # 00439317
    mov ecx, dword ptr [0x5d03b3]                # 00439321
    mov dword ptr [0x5d187d], ecx                # 00439327
    mov dword ptr [0x5d1881], 0x5b15f2           # 0043932d
    mov dword ptr [0x5d1885], 0x57055d           # 00439337
    mov dword ptr [0x5d1889], 0x0                # 00439341
    mov dword ptr [0x5d188d], 0x1                # 0043934b
    mov word ptr [0x5d1891], 0x2                 # 00439355
    mov edi, 0x546c70                            # 0043935e
    mov edx, 0x5d1803                            # 00439363
    or ecx, -0x1                                 # 00439368
    {load} xor eax, eax                          # 0043936b
    repne scasb al, byte ptr es:[edi]            # 0043936d
    not ecx                                      # 0043936f
    {load} sub edi, ecx                          # 00439371
    {load} mov esi, edi                          # 00439373
    {load} mov eax, ecx                          # 00439375
    {load} mov edi, edx                          # 00439377
    shr ecx, 0x2                                 # 00439379
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043937c
    {load} mov ecx, eax                          # 0043937e
    and ecx, 0x3                                 # 00439380
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00439383
    mov dword ptr [0x5d18bf], 0x11               # 00439385
    mov dword ptr [0x5d18c3], 0x4d3714           # 0043938f
    mov dword ptr [0x5d18c7], 0x0                # 00439399
    mov dword ptr [0x5d18cb], 0x0                # 004393a3
    mov dword ptr [0x5d18cf], 0x0                # 004393ad
    mov dword ptr [0x5d18d3], 0x0                # 004393b7
    mov dword ptr [0x5d18d7], 0x1                # 004393c1
    mov word ptr [0x5d18db], 0x1                 # 004393cb
    mov edi, 0x546c7c                            # 004393d4
    mov edx, 0x5d18e1                            # 004393d9
    or ecx, -0x1                                 # 004393de
    {load} xor eax, eax                          # 004393e1
    repne scasb al, byte ptr es:[edi]            # 004393e3
    not ecx                                      # 004393e5
    {load} sub edi, ecx                          # 004393e7
    {load} mov esi, edi                          # 004393e9
    {load} mov eax, ecx                          # 004393eb
    {load} mov edi, edx                          # 004393ed
    shr ecx, 0x2                                 # 004393ef
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004393f2
    {load} mov ecx, eax                          # 004393f4
    and ecx, 0x3                                 # 004393f6
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004393f9
    mov ecx, 0x6177e8                            # 004393fb
    call FUN_0041e33b                            # 00439400
    mov dword ptr [0x5d1953], 0xb                # 00439405
    mov dword ptr [0x5d1957], 0x4d3728           # 0043940f
    mov dword ptr [0x5d195b], 0x0                # 00439419
    mov dword ptr [0x5d195f], 0x5b4e18           # 00439423
    mov dword ptr [0x5d1963], 0x5b4e28           # 0043942d
    mov dword ptr [0x5d1967], 0x0                # 00439437
    mov dword ptr [0x5d196b], 0x1                # 00439441
    mov word ptr [0x5d196f], 0x2                 # 0043944b
    mov edi, 0x546c90                            # 00439454
    mov edx, 0x5d1975                            # 00439459
    or ecx, -0x1                                 # 0043945e
    {load} xor eax, eax                          # 00439461
    repne scasb al, byte ptr es:[edi]            # 00439463
    not ecx                                      # 00439465
    {load} sub edi, ecx                          # 00439467
    {load} mov esi, edi                          # 00439469
    {load} mov eax, ecx                          # 0043946b
    {load} mov edi, edx                          # 0043946d
    shr ecx, 0x2                                 # 0043946f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00439472
    {load} mov ecx, eax                          # 00439474
    and ecx, 0x3                                 # 00439476
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00439479
    mov dword ptr [0x5d199d], 0xb                # 0043947b
    mov dword ptr [0x5d19a1], 0x4d37af           # 00439485
    mov dword ptr [0x5d19a5], 0x0                # 0043948f
    mov dword ptr [0x5d19a9], 0x5b508f           # 00439499
    mov dword ptr [0x5d19ad], 0x5b509f           # 004394a3
    mov dword ptr [0x5d19b1], 0x0                # 004394ad
    mov dword ptr [0x5d19b5], 0x1                # 004394b7
    mov word ptr [0x5d19b9], 0x2                 # 004394c1
    mov edi, 0x546c9c                            # 004394ca
    mov edx, 0x5d19bf                            # 004394cf
    or ecx, -0x1                                 # 004394d4
    {load} xor eax, eax                          # 004394d7
    repne scasb al, byte ptr es:[edi]            # 004394d9
    not ecx                                      # 004394db
    {load} sub edi, ecx                          # 004394dd
    {load} mov esi, edi                          # 004394df
    {load} mov eax, ecx                          # 004394e1
    {load} mov edi, edx                          # 004394e3
    shr ecx, 0x2                                 # 004394e5
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004394e8
    {load} mov ecx, eax                          # 004394ea
    and ecx, 0x3                                 # 004394ec
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004394ef
    mov ecx, 0x637fcf                            # 004394f1
    call FUN_004c0b8b                            # 004394f6
    mov ecx, 0x63821d                            # 004394fb
    call FUN_004cecf7                            # 00439500
    mov dword ptr [0x5d1a7b], 0xa                # 00439505
    mov dword ptr [0x5d1a7f], 0x4d00f4           # 0043950f
    mov dword ptr [0x5d1a83], 0x0                # 00439519
    mov dword ptr [0x5d1a87], 0x0                # 00439523
    mov dword ptr [0x5d1a8b], 0x0                # 0043952d
    mov dword ptr [0x5d1a8f], 0x0                # 00439537
    mov dword ptr [0x5d1a93], 0x1                # 00439541
    mov word ptr [0x5d1a97], 0x1                 # 0043954b
    mov edi, 0x546ca8                            # 00439554
    mov edx, 0x5d1a9d                            # 00439559
    or ecx, -0x1                                 # 0043955e
    {load} xor eax, eax                          # 00439561
    repne scasb al, byte ptr es:[edi]            # 00439563
    not ecx                                      # 00439565
    {load} sub edi, ecx                          # 00439567
    {load} mov esi, edi                          # 00439569
    {load} mov eax, ecx                          # 0043956b
    {load} mov edi, edx                          # 0043956d
    shr ecx, 0x2                                 # 0043956f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00439572
    {load} mov ecx, eax                          # 00439574
    and ecx, 0x3                                 # 00439576
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00439579
    mov dword ptr [0x5d1ac5], 0xa                # 0043957b
    mov dword ptr [0x5d1ac9], 0x4d0275           # 00439585
    mov dword ptr [0x5d1acd], 0x0                # 0043958f
    mov dword ptr [0x5d1ad1], 0x0                # 00439599
    mov dword ptr [0x5d1ad5], 0x0                # 004395a3
    mov dword ptr [0x5d1ad9], 0x0                # 004395ad
    mov dword ptr [0x5d1add], 0x1                # 004395b7
    mov word ptr [0x5d1ae1], 0x1                 # 004395c1
    mov edi, 0x546cb8                            # 004395ca
    mov edx, 0x5d1ae7                            # 004395cf
    or ecx, -0x1                                 # 004395d4
    {load} xor eax, eax                          # 004395d7
    repne scasb al, byte ptr es:[edi]            # 004395d9
    not ecx                                      # 004395db
    {load} sub edi, ecx                          # 004395dd
    {load} mov esi, edi                          # 004395df
    {load} mov eax, ecx                          # 004395e1
    {load} mov edi, edx                          # 004395e3
    shr ecx, 0x2                                 # 004395e5
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004395e8
    {load} mov ecx, eax                          # 004395ea
    and ecx, 0x3                                 # 004395ec
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004395ef
    mov dword ptr [0x5d1b0f], 0xa                # 004395f1
    mov dword ptr [0x5d1b13], 0x4d040a           # 004395fb
    mov dword ptr [0x5d1b17], 0x0                # 00439605
    mov dword ptr [0x5d1b1b], 0x0                # 0043960f
    mov dword ptr [0x5d1b1f], 0x0                # 00439619
    mov dword ptr [0x5d1b23], 0x0                # 00439623
    mov dword ptr [0x5d1b27], 0x1                # 0043962d
    mov word ptr [0x5d1b2b], 0x1                 # 00439637
    mov edi, 0x546cd0                            # 00439640
    mov edx, 0x5d1b31                            # 00439645
    or ecx, -0x1                                 # 0043964a
    {load} xor eax, eax                          # 0043964d
    repne scasb al, byte ptr es:[edi]            # 0043964f
    not ecx                                      # 00439651
    {load} sub edi, ecx                          # 00439653
    {load} mov esi, edi                          # 00439655
    {load} mov eax, ecx                          # 00439657
    {load} mov edi, edx                          # 00439659
    shr ecx, 0x2                                 # 0043965b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043965e
    {load} mov ecx, eax                          # 00439660
    and ecx, 0x3                                 # 00439662
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00439665
    mov dword ptr [0x5d1ba3], 0xa                # 00439667
    mov dword ptr [0x5d1ba7], 0x4d0532           # 00439671
    mov dword ptr [0x5d1bab], 0x0                # 0043967b
    mov dword ptr [0x5d1baf], 0x0                # 00439685
    mov dword ptr [0x5d1bb3], 0x0                # 0043968f
    mov dword ptr [0x5d1bb7], 0x0                # 00439699
    mov dword ptr [0x5d1bbb], 0x1                # 004396a3
    mov word ptr [0x5d1bbf], 0x1                 # 004396ad
    mov edi, 0x546ce0                            # 004396b6
    mov edx, 0x5d1bc5                            # 004396bb
    or ecx, -0x1                                 # 004396c0
    {load} xor eax, eax                          # 004396c3
    repne scasb al, byte ptr es:[edi]            # 004396c5
    not ecx                                      # 004396c7
    {load} sub edi, ecx                          # 004396c9
    {load} mov esi, edi                          # 004396cb
    {load} mov eax, ecx                          # 004396cd
    {load} mov edi, edx                          # 004396cf
    shr ecx, 0x2                                 # 004396d1
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004396d4
    {load} mov ecx, eax                          # 004396d6
    and ecx, 0x3                                 # 004396d8
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004396db
    mov dword ptr [0x5d1bed], 0xa                # 004396dd
    mov dword ptr [0x5d1bf1], 0x4d07e7           # 004396e7
    mov dword ptr [0x5d1bf5], 0x0                # 004396f1
    mov dword ptr [0x5d1bf9], 0x0                # 004396fb
    mov dword ptr [0x5d1bfd], 0x0                # 00439705
    mov dword ptr [0x5d1c01], 0x0                # 0043970f
    mov dword ptr [0x5d1c05], 0x1                # 00439719
    mov word ptr [0x5d1c09], 0x1                 # 00439723
    mov edi, 0x546cf0                            # 0043972c
    mov edx, 0x5d1c0f                            # 00439731
    or ecx, -0x1                                 # 00439736
    {load} xor eax, eax                          # 00439739
    repne scasb al, byte ptr es:[edi]            # 0043973b
    not ecx                                      # 0043973d
    {load} sub edi, ecx                          # 0043973f
    {load} mov esi, edi                          # 00439741
    {load} mov eax, ecx                          # 00439743
    {load} mov edi, edx                          # 00439745
    shr ecx, 0x2                                 # 00439747
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043974a
    {load} mov ecx, eax                          # 0043974c
    and ecx, 0x3                                 # 0043974e
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00439751
    mov dword ptr [0x5d1b59], 0xa                # 00439753
    mov dword ptr [0x5d1b5d], 0x4d0952           # 0043975d
    mov dword ptr [0x5d1b61], 0x0                # 00439767
    mov dword ptr [0x5d1b65], 0x0                # 00439771
    mov dword ptr [0x5d1b69], 0x0                # 0043977b
    mov dword ptr [0x5d1b6d], 0x0                # 00439785
    mov dword ptr [0x5d1b71], 0x1                # 0043978f
    mov word ptr [0x5d1b75], 0x1                 # 00439799
    mov edi, 0x546d00                            # 004397a2
    mov edx, 0x5d1b7b                            # 004397a7
    or ecx, -0x1                                 # 004397ac
    {load} xor eax, eax                          # 004397af
    repne scasb al, byte ptr es:[edi]            # 004397b1
    not ecx                                      # 004397b3
    {load} sub edi, ecx                          # 004397b5
    {load} mov esi, edi                          # 004397b7
    {load} mov eax, ecx                          # 004397b9
    {load} mov edi, edx                          # 004397bb
    shr ecx, 0x2                                 # 004397bd
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004397c0
    {load} mov ecx, eax                          # 004397c2
    and ecx, 0x3                                 # 004397c4
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004397c7
    mov dword ptr [0x583999], 0x1                # 004397c9
    movsx ecx, word ptr [0x63a4cd]               # 004397d3
    test ecx, ecx                                # 004397da
    je.d8 L_004397eb                             # 004397dc
    # block 0x004397de: entered by fall-through of je at 0x004397dc, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004397eb
    push 0x546d0c                                # 004397de
    call FUN_0044a2b7                            # 004397e3
    add esp, 0x4                                 # 004397e8
L_004397eb:
    # block 0x004397eb: entered by jmp at 0x004387a2; jmp at 0x00438840; je at 0x004397dc, 5 instruction(s), ends with ret
    pop edi                                      # 004397eb
    pop esi                                      # 004397ec
    {load} mov esp, ebp                          # 004397ed
    pop ebp                                      # 004397ef
    ret                                          # 004397f0

# --- data items (not part of the function) -------------------------
.org 0x004397f1 - 0x401000
SWTAB_004397f1:  # 3 case address(es)
    .long L_0043895b - .text + 0x401000
    .long L_0043894a - .text + 0x401000
    .long L_0043896c - .text + 0x401000
.org 0x004397fd - 0x401000
IDXTAB_004397fd:  # index table of FUN_004381f4 for the switch jump at 0x00438943 (37 byte(s))
    .byte 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
    .byte 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1
    .byte 1, 1, 2, 1, 1
.set SWTAB_004397f1_VA, SWTAB_004397f1 - .text + 0x401000
.set IDXTAB_004397fd_VA, IDXTAB_004397fd - .text + 0x401000

