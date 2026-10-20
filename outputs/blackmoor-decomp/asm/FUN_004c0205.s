# FUN_004c0205
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c0205
# extent:       0x004c0205-0x004c04e3 (734 code bytes)
# span:         0x004c0205-0x004c04e3 (code 734, tables 0, padding 0)
# sha256:       b5926df630d4a154a54ba1cf5ba34e35832fc73bc165f13eef58ae122acd6b3f
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         movie_step
# naming:       native port src/avf_player.c:movie_step (port_acceptances, ledger class native_tests_only, reviewed 2026-10-16); the summary is the acceptance note
# summary:      States 0 and 4 match in order. Seams: 0x4c0ab1 and 0x4c08d3 are host events, surface select is the host present call, debug logs omitted, slot store 2 is p->finished.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_29, field_17a, field_182, field_1d4, field_1da, field_216, field_21a, field_21e, field_222, field_244; [ecx + n] field_24, field_17a, field_182, field_192, field_1ca, field_216, field_222, field_22a, field_240, field_244; [edx + n] field_2b, field_2d, field_192, field_1c6, field_1ca, field_1d4, field_21e, field_22a, field_240, field_244
# callees:      calls FUN_0050ca3e, FUN_0044a2b7, FUN_004c0ab1, FUN_004c08d3, FUN_004c09fe, KERNEL32.dll!GetTickCount
# track-n:      outputs/blackmoor-decomp/src/avf_player.c:movie_step (function ledger class native_tests_only; also movie_step_index; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 169 instruction(s), 18 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_24, 0x24  # offset +0x24
.equ field_29, 0x29  # offset +0x29
.equ field_2b, 0x2b  # offset +0x2b
.equ field_2d, 0x2d  # offset +0x2d
.equ field_17a, 0x17a  # offset +0x17a
.equ field_182, 0x182  # offset +0x182
.equ field_192, 0x192  # offset +0x192
.equ field_1c6, 0x1c6  # offset +0x1c6
.equ field_1ca, 0x1ca  # offset +0x1ca
.equ field_1d4, 0x1d4  # offset +0x1d4
.equ field_1da, 0x1da  # offset +0x1da
.equ field_216, 0x216  # offset +0x216
.equ field_21a, 0x21a  # offset +0x21a
.equ field_21e, 0x21e  # offset +0x21e
.equ field_222, 0x222  # offset +0x222
.equ field_22a, 0x22a  # offset +0x22a
.equ field_240, 0x240  # offset +0x240
.equ field_244, 0x244  # offset +0x244

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c08d3, .text + (0x004c08d3 - 0x401000)
.set FUN_004c09fe, .text + (0x004c09fe - 0x401000)
.set FUN_004c0ab1, .text + (0x004c0ab1 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004c0205 - 0x401000
.globl FUN_004c0205
FUN_004c0205:
    # block 0x004c0205: entry, 9 instruction(s), ends with je to 0x004c022f (forward)
    push ebp                                     # 004c0205
    {load} mov ebp, esp                          # 004c0206
    sub esp, 0x8                                 # 004c0208
    mov dword ptr [ebp - local_4], ecx           # 004c020b
    mov eax, dword ptr [ebp - local_4]           # 004c020e
    mov ecx, dword ptr [eax + field_1da]         # 004c0211
    mov dword ptr [ebp - local_8], ecx           # 004c0217
    cmp dword ptr [ebp - local_8], 0x0           # 004c021a
    je.d8 L_004c022f                             # 004c021e
    # block 0x004c0220: entered by fall-through of je at 0x004c021e, 2 instruction(s), ends with je to 0x004c0333 (forward)
    cmp dword ptr [ebp - local_8], 0x4           # 004c0220
    je.d32 L_004c0333                            # 004c0224
    # block 0x004c022a: entered by fall-through of je at 0x004c0224, 1 instruction(s), ends with forward jump to 0x004c04dd
    jmp.d32 L_004c04dd                           # 004c022a
L_004c022f:
    # block 0x004c022f: entered by je at 0x004c021e, 3 instruction(s), ends with je to 0x004c0264 (forward)
    movsx edx, word ptr [0x63a4cd]               # 004c022f
    test edx, edx                                # 004c0236
    je.d8 L_004c0264                             # 004c0238
    # block 0x004c023a: entered by fall-through of je at 0x004c0238, 10 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004c0264
    mov eax, dword ptr [ebp - local_4]           # 004c023a
    movsx ecx, word ptr [eax + field_1d4]        # 004c023d
    push ecx                                     # 004c0244
    push 0x5528a4                                # 004c0245
    push 0x63888b                                # 004c024a
    call FUN_0050ca3e                            # 004c024f
    add esp, 0xc                                 # 004c0254
    push 0x63888b                                # 004c0257
    call FUN_0044a2b7                            # 004c025c
    add esp, 0x4                                 # 004c0261
L_004c0264:
    # block 0x004c0264: entered by je at 0x004c0238, 4 instruction(s), ends with je to 0x004c032e (forward)
    mov edx, dword ptr [ebp - local_4]           # 004c0264
    movsx eax, word ptr [edx + field_1d4]        # 004c0267
    test eax, eax                                # 004c026e
    je.d32 L_004c032e                            # 004c0270
    # block 0x004c0276: entered by fall-through of je at 0x004c0270, 3 instruction(s), ends with jne to 0x004c02a1 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004c0276
    cmp dword ptr [ecx + field_17a], 0x1         # 004c0279
    jne.d8 L_004c02a1                            # 004c0280
    # block 0x004c0282: entered by fall-through of jne at 0x004c0280, 7 instruction(s), falls into the block at 0x004c02a1
    mov edx, dword ptr [ebp - local_4]           # 004c0282
    movsx eax, word ptr [edx + field_192]        # 004c0285
    mov ecx, dword ptr [ebp - local_4]           # 004c028c
    mov edx, dword ptr [ecx + field_222]         # 004c028f
    mov ecx, dword ptr [ebp - local_4]           # 004c0295
    mov eax, dword ptr [ecx + 4*eax + field_182] # 004c0298
    mov dword ptr [edx], eax                     # 004c029f
L_004c02a1:
    # block 0x004c02a1: entered by jne at 0x004c0280, 26 instruction(s), calls FUN_004c0ab1, FUN_004c08d3, FUN_004c09fe, KERNEL32.dll!GetTickCount, ends with je to 0x004c032e (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004c02a1
    mov edx, dword ptr [ebp - local_4]           # 004c02a4
    mov ax, word ptr [edx + field_1ca]           # 004c02a7
    mov word ptr [ecx + field_244], ax           # 004c02ae
    mov ecx, dword ptr [ebp - local_4]           # 004c02b5
    call FUN_004c0ab1                            # 004c02b8
    mov ecx, dword ptr [ebp - local_4]           # 004c02bd
    mov dword ptr [ecx + field_216], 0x1         # 004c02c0
    mov edx, dword ptr [ebp - local_4]           # 004c02ca
    mov dword ptr [edx + field_240], 0x2         # 004c02cd
    mov eax, dword ptr [ebp - local_4]           # 004c02d7
    mov dword ptr [eax + field_21a], 0x1         # 004c02da
    mov ecx, dword ptr [ebp - local_4]           # 004c02e4
    call FUN_004c08d3                            # 004c02e7
    mov ecx, dword ptr [ebp - local_4]           # 004c02ec
    call FUN_004c09fe                            # 004c02ef
    call dword ptr [0x52a23c]                    # 004c02f4
    mov ecx, dword ptr [ebp - local_4]           # 004c02fa
    add eax, dword ptr [ecx + field_24]          # 004c02fd
    mov edx, dword ptr [ebp - local_4]           # 004c0300
    mov dword ptr [edx + field_1c6], eax         # 004c0303
    mov eax, dword ptr [ebp - local_4]           # 004c0309
    mov dword ptr [eax + field_1da], 0x4         # 004c030c
    movsx ecx, word ptr [0x63a4cd]               # 004c0316
    test ecx, ecx                                # 004c031d
    je.d8 L_004c032e                             # 004c031f
    # block 0x004c0321: entered by fall-through of je at 0x004c031f, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c032e
    push 0x5528f0                                # 004c0321
    call FUN_0044a2b7                            # 004c0326
    add esp, 0x4                                 # 004c032b
L_004c032e:
    # block 0x004c032e: entered by je at 0x004c0270; je at 0x004c031f, 1 instruction(s), ends with forward jump to 0x004c04dd
    jmp.d32 L_004c04dd                           # 004c032e
L_004c0333:
    # block 0x004c0333: entered by je at 0x004c0224, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x004c04dd (forward)
    call dword ptr [0x52a23c]                    # 004c0333
    mov edx, dword ptr [ebp - local_4]           # 004c0339
    cmp eax, dword ptr [edx + field_1c6]         # 004c033c
    jb.d32 L_004c04dd                            # 004c0342
    # block 0x004c0348: entered by fall-through of jb at 0x004c0342, 3 instruction(s), ends with je to 0x004c038d (forward)
    mov eax, dword ptr [ebp - local_4]           # 004c0348
    cmp dword ptr [eax + field_21e], 0x0         # 004c034b
    je.d8 L_004c038d                             # 004c0352
    # block 0x004c0354: entered by fall-through of je at 0x004c0352, 8 instruction(s), calls FUN_004c0ab1, ends with je to 0x004c0388 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004c0354
    call FUN_004c0ab1                            # 004c0357
    movsx ecx, word ptr [ebp + arg_8]            # 004c035c
    imul ecx, ecx, 0x8d                          # 004c0360
    mov dword ptr [ecx + 0x5bb632], 0x2          # 004c0366
    movsx edx, word ptr [0x63a4cd]               # 004c0370
    test edx, edx                                # 004c0377
    je.d8 L_004c0388                             # 004c0379
    # block 0x004c037b: entered by fall-through of je at 0x004c0379, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c0388
    push 0x552934                                # 004c037b
    call FUN_0044a2b7                            # 004c0380
    add esp, 0x4                                 # 004c0385
L_004c0388:
    # block 0x004c0388: entered by je at 0x004c0379, 1 instruction(s), ends with forward jump to 0x004c04dd
    jmp.d32 L_004c04dd                           # 004c0388
L_004c038d:
    # block 0x004c038d: entered by je at 0x004c0352, 4 instruction(s), ends with je to 0x004c04dd (forward)
    mov eax, dword ptr [ebp - local_4]           # 004c038d
    movsx ecx, word ptr [eax + field_1d4]        # 004c0390
    test ecx, ecx                                # 004c0397
    je.d32 L_004c04dd                            # 004c0399
    # block 0x004c039f: entered by fall-through of je at 0x004c0399, 3 instruction(s), ends with jne to 0x004c04dd (forward)
    mov edx, dword ptr [ebp - local_4]           # 004c039f
    cmp dword ptr [edx + field_21e], 0x0         # 004c03a2
    jne.d32 L_004c04dd                           # 004c03a9
    # block 0x004c03af: entered by fall-through of jne at 0x004c03a9, 3 instruction(s), ends with jne to 0x004c03da (forward)
    mov eax, dword ptr [ebp - local_4]           # 004c03af
    cmp dword ptr [eax + field_17a], 0x1         # 004c03b2
    jne.d8 L_004c03da                            # 004c03b9
    # block 0x004c03bb: entered by fall-through of jne at 0x004c03b9, 7 instruction(s), falls into the block at 0x004c03da
    mov ecx, dword ptr [ebp - local_4]           # 004c03bb
    movsx edx, word ptr [ecx + field_192]        # 004c03be
    mov eax, dword ptr [ebp - local_4]           # 004c03c5
    mov ecx, dword ptr [eax + field_222]         # 004c03c8
    mov eax, dword ptr [ebp - local_4]           # 004c03ce
    mov edx, dword ptr [eax + 4*edx + field_182] # 004c03d1
    mov dword ptr [ecx], edx                     # 004c03d8
L_004c03da:
    # block 0x004c03da: entered by jne at 0x004c03b9, 19 instruction(s), calls FUN_004c0ab1, FUN_004c08d3, ends with jne to 0x004c0445 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004c03da
    mov ecx, dword ptr [ebp - local_4]           # 004c03dd
    mov dx, word ptr [ecx + field_1ca]           # 004c03e0
    mov word ptr [eax + field_244], dx           # 004c03e7
    mov ecx, dword ptr [ebp - local_4]           # 004c03ee
    call FUN_004c0ab1                            # 004c03f1
    mov eax, dword ptr [ebp - local_4]           # 004c03f6
    mov dword ptr [eax + field_216], 0x1         # 004c03f9
    mov ecx, dword ptr [ebp - local_4]           # 004c0403
    call FUN_004c08d3                            # 004c0406
    mov ecx, dword ptr [ebp - local_4]           # 004c040b
    mov dword ptr [ecx + field_240], 0x2         # 004c040e
    mov edx, dword ptr [ebp - local_4]           # 004c0418
    movsx eax, word ptr [edx + field_244]        # 004c041b
    mov ecx, dword ptr [ebp - local_4]           # 004c0422
    mov edx, dword ptr [ecx + field_22a]         # 004c0425
    movsx ecx, word ptr [edx + field_2d]         # 004c042b
    {load} cmp eax, ecx                          # 004c042f
    jne.d8 L_004c0445                            # 004c0431
    # block 0x004c0433: entered by fall-through of jne at 0x004c0431, 5 instruction(s), ends with je to 0x004c0472 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004c0433
    mov eax, dword ptr [edx + field_22a]         # 004c0436
    movsx ecx, word ptr [eax + field_29]         # 004c043c
    cmp ecx, 0x1                                 # 004c0440
    je.d8 L_004c0472                             # 004c0443
L_004c0445:
    # block 0x004c0445: entered by jne at 0x004c0431; fall-through of je at 0x004c0443, 7 instruction(s), ends with jne to 0x004c047f (forward)
    mov edx, dword ptr [ebp - local_4]           # 004c0445
    movsx eax, word ptr [edx + field_244]        # 004c0448
    mov ecx, dword ptr [ebp - local_4]           # 004c044f
    mov edx, dword ptr [ecx + field_22a]         # 004c0452
    movsx ecx, word ptr [edx + field_2b]         # 004c0458
    {load} cmp eax, ecx                          # 004c045c
    jne.d8 L_004c047f                            # 004c045e
    # block 0x004c0460: entered by fall-through of jne at 0x004c045e, 5 instruction(s), ends with jne to 0x004c047f (forward)
    mov edx, dword ptr [ebp - local_4]           # 004c0460
    mov eax, dword ptr [edx + field_22a]         # 004c0463
    movsx ecx, word ptr [eax + field_29]         # 004c0469
    cmp ecx, 0x2                                 # 004c046d
    jne.d8 L_004c047f                            # 004c0470
L_004c0472:
    # block 0x004c0472: entered by je at 0x004c0443; fall-through of jne at 0x004c0470, 2 instruction(s), falls into the block at 0x004c047f
    mov edx, dword ptr [ebp - local_4]           # 004c0472
    mov dword ptr [edx + field_21e], 0x1         # 004c0475
L_004c047f:
    # block 0x004c047f: entered by jne at 0x004c045e; jne at 0x004c0470, 8 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jne to 0x004c04dd (forward)
    call dword ptr [0x52a23c]                    # 004c047f
    mov ecx, dword ptr [ebp - local_4]           # 004c0485
    add eax, dword ptr [ecx + field_24]          # 004c0488
    mov edx, dword ptr [ebp - local_4]           # 004c048b
    mov dword ptr [edx + field_1c6], eax         # 004c048e
    mov eax, dword ptr [ebp - local_4]           # 004c0494
    cmp dword ptr [eax + field_21e], 0x0         # 004c0497
    jne.d8 L_004c04dd                            # 004c049e
    # block 0x004c04a0: entered by fall-through of jne at 0x004c049e, 5 instruction(s), calls FUN_004c09fe, ends with je to 0x004c04dd (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004c04a0
    call FUN_004c09fe                            # 004c04a3
    movsx ecx, word ptr [0x63a4cd]               # 004c04a8
    test ecx, ecx                                # 004c04af
    je.d8 L_004c04dd                             # 004c04b1
    # block 0x004c04b3: entered by fall-through of je at 0x004c04b1, 10 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004c04dd
    mov edx, dword ptr [ebp - local_4]           # 004c04b3
    movsx eax, word ptr [edx + field_1ca]        # 004c04b6
    push eax                                     # 004c04bd
    push 0x552990                                # 004c04be
    push 0x63888b                                # 004c04c3
    call FUN_0050ca3e                            # 004c04c8
    add esp, 0xc                                 # 004c04cd
    push 0x63888b                                # 004c04d0
    call FUN_0044a2b7                            # 004c04d5
    add esp, 0x4                                 # 004c04da
L_004c04dd:
    # block 0x004c04dd: entered by jmp at 0x004c022a; jmp at 0x004c032e; jb at 0x004c0342; jmp at 0x004c0388; more, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004c04dd
    pop ebp                                      # 004c04df
    ret 0x4                                      # 004c04e0

