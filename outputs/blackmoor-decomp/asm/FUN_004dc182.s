# FUN_004dc182
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004dc182
# extent:       0x004dc182-0x004dcdc3 (3137 code bytes)
# span:         0x004dc182-0x004dcdd3 (code 3137, tables 16, padding 0)
# sha256:       acb39e41c869137b1f41d9c27a8bf824b1d147f20e54a0b36f924600e496714c
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_partner_logo_animation_handler
# naming:       INFERRED (lower confidence, not verified): the repository text src/avf_player.c:118 says "0x4dc182 case 0 always plays the partner animation single-buffered."; src/avf_player.h:28 says "PARTNER_LOGO 0x4dc182 case 2 + 0x4dcdd3; worker 0x4c0c7d."
# name-note:    Handler that plays the partner logo animation (case 0 animated AVF, case 2 blit).
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       12 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30, local_34
# fields:       [eax + n] field_1c, field_24, field_2a, field_2e, field_36, field_3a, field_3d, field_3e, field_46, field_4a, field_6f, field_b1 and 17 more; [ecx + n] field_20, field_24, field_26, field_2a, field_36, field_3a, field_3e, field_42, field_46, field_4a, field_4e, field_b1 and 17 more; [edx + n] field_1c, field_32, field_36, field_3a, field_41, field_42, field_46, field_4a, field_90, field_b1, field_b3, field_b7 and 18 more
# callees:      calls FUN_0044a2b7, FUN_004dad60, FUN_004c2790, FUN_004c2a8d, FUN_004c46d1, FUN_004bede7, FUN_0041632b, FUN_0044c4c1, FUN_004c2c3a, FUN_004161d1, FUN_0051dc43, FUN_004497a0, FUN_0042639d, FUN_004c97b4, FUN_00449bff, FUN_004bef11 and 21 more
# track-n:      outputs/blackmoor-decomp/src/avf_player.c:avf_player_start (function ledger class candidate_port; also check_config, partner_step_index; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 748 instruction(s), 60 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_26, 0x26  # offset +0x26
.equ field_2a, 0x2a  # offset +0x2a
.equ field_2e, 0x2e  # offset +0x2e
.equ field_32, 0x32  # offset +0x32
.equ field_36, 0x36  # offset +0x36
.equ field_3a, 0x3a  # offset +0x3a
.equ field_3d, 0x3d  # offset +0x3d
.equ field_3e, 0x3e  # offset +0x3e
.equ field_41, 0x41  # offset +0x41
.equ field_42, 0x42  # offset +0x42
.equ field_46, 0x46  # offset +0x46
.equ field_4a, 0x4a  # offset +0x4a
.equ field_4e, 0x4e  # offset +0x4e
.equ field_6f, 0x6f  # offset +0x6f
.equ field_90, 0x90  # offset +0x90
.equ field_b1, 0xb1  # offset +0xb1
.equ field_b3, 0xb3  # offset +0xb3
.equ field_b5, 0xb5  # offset +0xb5
.equ field_b7, 0xb7  # offset +0xb7
.equ field_b9, 0xb9  # offset +0xb9
.equ field_bb, 0xbb  # offset +0xbb
.equ field_ee, 0xee  # offset +0xee
.equ field_f2, 0xf2  # offset +0xf2
.equ field_f6, 0xf6  # offset +0xf6
.equ field_fa, 0xfa  # offset +0xfa
.equ field_fe, 0xfe  # offset +0xfe
.equ field_102, 0x102  # offset +0x102
.equ field_106, 0x106  # offset +0x106
.equ field_172, 0x172  # offset +0x172
.equ field_176, 0x176  # offset +0x176
.equ field_17a, 0x17a  # offset +0x17a
.equ field_18a, 0x18a  # offset +0x18a
.equ field_18c, 0x18c  # offset +0x18c
.equ field_18e, 0x18e  # offset +0x18e
.equ field_194, 0x194  # offset +0x194
.equ field_198, 0x198  # offset +0x198
.equ field_1aa, 0x1aa  # offset +0x1aa
.equ field_1ae, 0x1ae  # offset +0x1ae
.equ field_1b2, 0x1b2  # offset +0x1b2
.equ field_1b6, 0x1b6  # offset +0x1b6
.equ field_1c2, 0x1c2  # offset +0x1c2
.equ field_1c4, 0x1c4  # offset +0x1c4
.equ field_1c6, 0x1c6  # offset +0x1c6
.equ field_1cc, 0x1cc  # offset +0x1cc

# --- external targets -----------------------------------------------
.set FUN_004161d1, .text + (0x004161d1 - 0x401000)
.set FUN_0041632b, .text + (0x0041632b - 0x401000)
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_004381f4, .text + (0x004381f4 - 0x401000)
.set FUN_0043dbd5, .text + (0x0043dbd5 - 0x401000)
.set FUN_004497a0, .text + (0x004497a0 - 0x401000)
.set FUN_00449bff, .text + (0x00449bff - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0044c4c1, .text + (0x0044c4c1 - 0x401000)
.set FUN_004bede7, .text + (0x004bede7 - 0x401000)
.set FUN_004bef11, .text + (0x004bef11 - 0x401000)
.set FUN_004bf3b8, .text + (0x004bf3b8 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004c2a8d, .text + (0x004c2a8d - 0x401000)
.set FUN_004c2c3a, .text + (0x004c2c3a - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004c46d1, .text + (0x004c46d1 - 0x401000)
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004d5c54, .text + (0x004d5c54 - 0x401000)
.set FUN_004d912a, .text + (0x004d912a - 0x401000)
.set FUN_004d940a, .text + (0x004d940a - 0x401000)
.set FUN_004dad60, .text + (0x004dad60 - 0x401000)
.set FUN_004dadff, .text + (0x004dadff - 0x401000)
.set FUN_004dc043, .text + (0x004dc043 - 0x401000)
.set FUN_004dcdd3, .text + (0x004dcdd3 - 0x401000)
.set FUN_004dd05a, .text + (0x004dd05a - 0x401000)
.set FUN_004faf98, .text + (0x004faf98 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)
.set FUN_004fbd98, .text + (0x004fbd98 - 0x401000)
.set FUN_004fc077, .text + (0x004fc077 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004dc182 - 0x401000
.globl FUN_004dc182
FUN_004dc182:
    # block 0x004dc182: entry, 16 instruction(s), ends with ja to 0x004dcdb3 (forward)
    push ebp                                     # 004dc182
    {load} mov ebp, esp                          # 004dc183
    push -0x1                                    # 004dc185
    push 0x5288c5                                # 004dc187
    mov eax, dword ptr fs:[0x0]                  # 004dc18c
    push eax                                     # 004dc192
    mov dword ptr fs:[0x0], esp                  # 004dc193
    sub esp, 0x28                                # 004dc19a
    push esi                                     # 004dc19d
    push edi                                     # 004dc19e
    mov dword ptr [ebp - local_18], ecx          # 004dc19f
    mov eax, dword ptr [ebp - local_18]          # 004dc1a2
    mov ecx, dword ptr [eax + field_1c]          # 004dc1a5
    mov dword ptr [ebp - local_1c], ecx          # 004dc1a8
    cmp dword ptr [ebp - local_1c], 0x3          # 004dc1ab
    ja.d32 L_004dcdb3                            # 004dc1af
    # block 0x004dc1b5: entered by fall-through of ja at 0x004dc1af, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4dcdc3]
    mov edx, dword ptr [ebp - local_1c]          # 004dc1b5
    jmp dword ptr [4*edx + SWTAB_004dcdc3_VA]    # 004dc1b8
L_004dc1bf:
    # block 0x004dc1bf: entered by switch case, 3 instruction(s), ends with je to 0x004dc1d7 (forward)
    movsx eax, word ptr [0x63a4cd]               # 004dc1bf
    test eax, eax                                # 004dc1c6
    je.d8 L_004dc1d7                             # 004dc1c8
    # block 0x004dc1ca: entered by fall-through of je at 0x004dc1c8, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004dc1d7
    push 0x55b094                                # 004dc1ca
    call FUN_0044a2b7                            # 004dc1cf
    add esp, 0x4                                 # 004dc1d4
L_004dc1d7:
    # block 0x004dc1d7: entered by je at 0x004dc1c8, 4 instruction(s), ends with jne to 0x004dc1f1 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004dc1d7
    movsx edx, byte ptr [ecx + field_4e]         # 004dc1da
    test edx, edx                                # 004dc1de
    jne.d8 L_004dc1f1                            # 004dc1e0
    # block 0x004dc1e2: entered by fall-through of jne at 0x004dc1e0, 3 instruction(s), ends with forward jump to 0x004dc1fe
    mov eax, dword ptr [ebp - local_18]          # 004dc1e2
    mov dword ptr [eax + field_f6], 0x0          # 004dc1e5
    jmp.d8 L_004dc1fe                            # 004dc1ef
L_004dc1f1:
    # block 0x004dc1f1: entered by jne at 0x004dc1e0, 2 instruction(s), falls into the block at 0x004dc1fe
    mov ecx, dword ptr [ebp - local_18]          # 004dc1f1
    mov dword ptr [ecx + field_f6], 0x1          # 004dc1f4
L_004dc1fe:
    # block 0x004dc1fe: entered by jmp at 0x004dc1ef, 4 instruction(s), ends with jne to 0x004dc21b (forward)
    mov edx, dword ptr [ebp - local_18]          # 004dc1fe
    movsx eax, byte ptr [edx + field_90]         # 004dc201
    test eax, eax                                # 004dc208
    jne.d8 L_004dc21b                            # 004dc20a
    # block 0x004dc20c: entered by fall-through of jne at 0x004dc20a, 3 instruction(s), ends with forward jump to 0x004dc228
    mov ecx, dword ptr [ebp - local_18]          # 004dc20c
    mov dword ptr [ecx + field_fa], 0x0          # 004dc20f
    jmp.d8 L_004dc228                            # 004dc219
L_004dc21b:
    # block 0x004dc21b: entered by jne at 0x004dc20a, 2 instruction(s), falls into the block at 0x004dc228
    mov edx, dword ptr [ebp - local_18]          # 004dc21b
    mov dword ptr [edx + field_fa], 0x1          # 004dc21e
L_004dc228:
    # block 0x004dc228: entered by jmp at 0x004dc219, 7 instruction(s), ends with jne to 0x004dc250 (forward)
    mov edi, 0x55b0e4                            # 004dc228
    mov esi, dword ptr [ebp - local_18]          # 004dc22d
    add esi, 0xbd                                # 004dc230
    mov ecx, 0x9                                 # 004dc236
    {load} xor eax, eax                          # 004dc23b
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004dc23d
    jne.d8 L_004dc250                            # 004dc23f
    # block 0x004dc241: entered by fall-through of jne at 0x004dc23f, 3 instruction(s), ends with forward jump to 0x004dc25d
    mov ecx, dword ptr [ebp - local_18]          # 004dc241
    mov dword ptr [ecx + field_102], 0x0         # 004dc244
    jmp.d8 L_004dc25d                            # 004dc24e
L_004dc250:
    # block 0x004dc250: entered by jne at 0x004dc23f, 2 instruction(s), falls into the block at 0x004dc25d
    mov edx, dword ptr [ebp - local_18]          # 004dc250
    mov dword ptr [edx + field_102], 0x1         # 004dc253
L_004dc25d:
    # block 0x004dc25d: entered by jmp at 0x004dc24e, 5 instruction(s), calls FUN_004dad60, ends with je to 0x004dc298 (forward)
    mov ecx, 0x5830a6                            # 004dc25d
    call FUN_004dad60                            # 004dc262
    mov eax, dword ptr [ebp - local_18]          # 004dc267
    cmp dword ptr [eax + field_f6], 0x0          # 004dc26a
    je.d8 L_004dc298                             # 004dc271
    # block 0x004dc273: entered by fall-through of je at 0x004dc271, 11 instruction(s), calls FUN_004c2790, ends with forward jump to 0x004dc2d5
    push 0x55b0f0                                # 004dc273
    push 0x6                                     # 004dc278
    mov ecx, dword ptr [ebp - local_18]          # 004dc27a
    add ecx, 0x4e                                # 004dc27d
    push ecx                                     # 004dc280
    push 0x55b108                                # 004dc281
    mov ecx, 0x5cf659                            # 004dc286
    call FUN_004c2790                            # 004dc28b
    mov edx, dword ptr [ebp - local_18]          # 004dc290
    mov dword ptr [edx + field_46], eax          # 004dc293
    jmp.d8 L_004dc2d5                            # 004dc296
L_004dc298:
    # block 0x004dc298: entered by je at 0x004dc271, 18 instruction(s), calls FUN_004c2a8d, FUN_004c46d1, falls into the block at 0x004dc2d5
    push 0x55b110                                # 004dc298
    push 0x6                                     # 004dc29d
    mov ax, word ptr [0x63988d]                  # 004dc29f
    push eax                                     # 004dc2a5
    mov cx, word ptr [0x63988b]                  # 004dc2a6
    push ecx                                     # 004dc2ad
    mov ecx, 0x5cf659                            # 004dc2ae
    call FUN_004c2a8d                            # 004dc2b3
    mov edx, dword ptr [ebp - local_18]          # 004dc2b8
    mov dword ptr [edx + field_46], eax          # 004dc2bb
    push 0x0                                     # 004dc2be
    push 0x0                                     # 004dc2c0
    push 0x0                                     # 004dc2c2
    mov eax, dword ptr [ebp - local_18]          # 004dc2c4
    mov ecx, dword ptr [eax + field_46]          # 004dc2c7
    push ecx                                     # 004dc2ca
    mov ecx, 0x5cf659                            # 004dc2cb
    call FUN_004c46d1                            # 004dc2d0
L_004dc2d5:
    # block 0x004dc2d5: entered by jmp at 0x004dc296, 3 instruction(s), ends with je to 0x004dc7fa (forward)
    mov edx, dword ptr [ebp - local_18]          # 004dc2d5
    cmp dword ptr [edx + field_fa], 0x0          # 004dc2d8
    je.d32 L_004dc7fa                            # 004dc2df
    # block 0x004dc2e5: entered by fall-through of je at 0x004dc2df, 43 instruction(s), calls FUN_004bede7, ends with je to 0x004dc3b4 (forward)
    mov ecx, 0x6201f9                            # 004dc2e5
    call FUN_004bede7                            # 004dc2ea
    mov eax, dword ptr [ebp - local_18]          # 004dc2ef
    mov ecx, dword ptr [eax + field_ee]          # 004dc2f2
    mov word ptr [ecx + field_18a], 0x0          # 004dc2f8
    mov dword ptr [0x6381a9], 0x0                # 004dc301
    mov dword ptr [0x6381e5], 0x0                # 004dc30b
    mov edx, dword ptr [ebp - local_18]          # 004dc315
    mov eax, dword ptr [edx + field_ee]          # 004dc318
    mov dword ptr [eax + field_172], 0x0         # 004dc31e
    mov ecx, dword ptr [ebp - local_18]          # 004dc328
    mov edx, dword ptr [ecx + field_ee]          # 004dc32b
    mov eax, dword ptr [ebp - local_18]          # 004dc331
    mov cx, word ptr [eax + field_b5]            # 004dc334
    mov word ptr [edx + field_1c4], cx           # 004dc33b
    mov edx, dword ptr [ebp - local_18]          # 004dc342
    mov eax, dword ptr [edx + field_ee]          # 004dc345
    mov word ptr [eax + field_1c6], 0x2          # 004dc34b
    mov ecx, dword ptr [ebp - local_18]          # 004dc354
    add ecx, 0x90                                # 004dc357
    {load} mov edi, ecx                          # 004dc35d
    mov edx, dword ptr [ebp - local_18]          # 004dc35f
    mov eax, dword ptr [edx + field_ee]          # 004dc362
    add eax, 0x151                               # 004dc368
    {load} mov edx, eax                          # 004dc36d
    or ecx, -0x1                                 # 004dc36f
    {load} xor eax, eax                          # 004dc372
    repne scasb al, byte ptr es:[edi]            # 004dc374
    not ecx                                      # 004dc376
    {load} sub edi, ecx                          # 004dc378
    {load} mov esi, edi                          # 004dc37a
    {load} mov eax, ecx                          # 004dc37c
    {load} mov edi, edx                          # 004dc37e
    shr ecx, 0x2                                 # 004dc380
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004dc383
    {load} mov ecx, eax                          # 004dc385
    and ecx, 0x3                                 # 004dc387
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004dc38a
    mov ecx, dword ptr [ebp - local_18]          # 004dc38c
    movsx edx, word ptr [ecx + field_b1]         # 004dc38f
    mov dword ptr [ebp - local_20], edx          # 004dc396
    cmp dword ptr [ebp - local_20], 0x1          # 004dc399
    je.d8 L_004dc3b4                             # 004dc39d
    # block 0x004dc39f: entered by fall-through of je at 0x004dc39d, 4 instruction(s), ends with forward jump to 0x004dc3c7
    mov eax, dword ptr [ebp - local_18]          # 004dc39f
    mov ecx, dword ptr [eax + field_ee]          # 004dc3a2
    mov dword ptr [ecx + field_176], 0x0         # 004dc3a8
    jmp.d8 L_004dc3c7                            # 004dc3b2
L_004dc3b4:
    # block 0x004dc3b4: entered by je at 0x004dc39d, 3 instruction(s), falls into the block at 0x004dc3c7
    mov edx, dword ptr [ebp - local_18]          # 004dc3b4
    mov eax, dword ptr [edx + field_ee]          # 004dc3b7
    mov dword ptr [eax + field_176], 0x1         # 004dc3bd
L_004dc3c7:
    # block 0x004dc3c7: entered by jmp at 0x004dc3b2, 13 instruction(s), calls FUN_0041632b, FUN_0044c4c1, ends with je to 0x004dc594 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004dc3c7
    mov edx, dword ptr [ecx + field_ee]          # 004dc3ca
    push edx                                     # 004dc3d0
    mov ecx, 0x5e2dbe                            # 004dc3d1
    call FUN_0041632b                            # 004dc3d6
    push 0x637fd7                                # 004dc3db
    call FUN_0044c4c1                            # 004dc3e0
    add esp, 0x4                                 # 004dc3e5
    mov eax, dword ptr [ebp - local_18]          # 004dc3e8
    movsx ecx, word ptr [eax + field_b1]         # 004dc3eb
    mov dword ptr [ebp - local_24], ecx          # 004dc3f2
    cmp dword ptr [ebp - local_24], 0x1          # 004dc3f5
    je.d32 L_004dc594                            # 004dc3f9
    # block 0x004dc3ff: entered by fall-through of je at 0x004dc3f9, 32 instruction(s), calls FUN_004c2c3a, FUN_004161d1, ends with jne to 0x004dc499 (forward)
    push 0x55b130                                # 004dc3ff
    push 0x1                                     # 004dc404
    push 0x8                                     # 004dc406
    mov edx, dword ptr [ebp - local_18]          # 004dc408
    mov eax, dword ptr [edx + field_ee]          # 004dc40b
    mov ecx, dword ptr [ebp - local_18]          # 004dc411
    mov edx, dword ptr [ecx + field_ee]          # 004dc414
    mov eax, dword ptr [eax + field_1b6]         # 004dc41a
    sub eax, dword ptr [edx + field_1ae]         # 004dc420
    add eax, 0x1                                 # 004dc426
    push eax                                     # 004dc429
    mov ecx, dword ptr [ebp - local_18]          # 004dc42a
    mov edx, dword ptr [ecx + field_ee]          # 004dc42d
    mov eax, dword ptr [ebp - local_18]          # 004dc433
    mov ecx, dword ptr [eax + field_ee]          # 004dc436
    mov edx, dword ptr [edx + field_1b2]         # 004dc43c
    sub edx, dword ptr [ecx + field_1aa]         # 004dc442
    add edx, 0x1                                 # 004dc448
    push edx                                     # 004dc44b
    mov ecx, 0x5cf659                            # 004dc44c
    call FUN_004c2c3a                            # 004dc451
    mov ecx, dword ptr [ebp - local_18]          # 004dc456
    mov dword ptr [ecx + field_4a], eax          # 004dc459
    mov edx, dword ptr [ebp - local_18]          # 004dc45c
    mov eax, dword ptr [edx + field_ee]          # 004dc45f
    push eax                                     # 004dc465
    mov ecx, 0x5e2dbe                            # 004dc466
    call FUN_004161d1                            # 004dc46b
    mov ecx, dword ptr [ebp - local_18]          # 004dc470
    mov edx, dword ptr [ecx + field_ee]          # 004dc473
    cmp dword ptr [edx + field_172], 0x0         # 004dc479
    jne.d8 L_004dc499                            # 004dc480
    # block 0x004dc482: entered by fall-through of jne at 0x004dc480, 6 instruction(s), falls into the block at 0x004dc499
    mov eax, dword ptr [ebp - local_18]          # 004dc482
    mov ecx, dword ptr [eax + field_ee]          # 004dc485
    mov edx, dword ptr [ebp - local_18]          # 004dc48b
    mov eax, dword ptr [edx + field_4a]          # 004dc48e
    mov ecx, dword ptr [ecx + field_17a]         # 004dc491
    mov dword ptr [eax], ecx                     # 004dc497
L_004dc499:
    # block 0x004dc499: entered by jne at 0x004dc480, 2 instruction(s), ends with jne to 0x004dc521 (forward)
    cmp dword ptr [0x6381a5], 0x0                # 004dc499
    jne.d8 L_004dc521                            # 004dc4a0
    # block 0x004dc4a2: entered by fall-through of jne at 0x004dc4a0, 7 instruction(s), calls FUN_0051dc43, ends with je to 0x004dc4dd (forward)
    push 0x46                                    # 004dc4a2
    call FUN_0051dc43                            # 004dc4a4
    add esp, 0x4                                 # 004dc4a9
    mov dword ptr [ebp - local_14], eax          # 004dc4ac
    mov dword ptr [ebp - local_4], 0x0           # 004dc4af
    cmp dword ptr [ebp - local_14], 0x0          # 004dc4b6
    je.d8 L_004dc4dd                             # 004dc4ba
    # block 0x004dc4bc: entered by fall-through of je at 0x004dc4ba, 9 instruction(s), calls FUN_004497a0, ends with forward jump to 0x004dc4e4
    push 0x4                                     # 004dc4bc
    movsx edx, word ptr [0x5b016f]               # 004dc4be
    push edx                                     # 004dc4c5
    push 0x55b150                                # 004dc4c6
    push 0x4c0c7d                                # 004dc4cb
    mov ecx, dword ptr [ebp - local_14]          # 004dc4d0
    call FUN_004497a0                            # 004dc4d3
    mov dword ptr [ebp - local_28], eax          # 004dc4d8
    jmp.d8 L_004dc4e4                            # 004dc4db
L_004dc4dd:
    # block 0x004dc4dd: entered by je at 0x004dc4ba, 1 instruction(s), falls into the block at 0x004dc4e4
    mov dword ptr [ebp - local_28], 0x0          # 004dc4dd
L_004dc4e4:
    # block 0x004dc4e4: entered by jmp at 0x004dc4db, 7 instruction(s), ends with jne to 0x004dc521 (forward)
    mov eax, dword ptr [ebp - local_28]          # 004dc4e4
    mov dword ptr [ebp - local_10], eax          # 004dc4e7
    mov dword ptr [ebp - local_4], 0xffffffff    # 004dc4ea
    mov ecx, dword ptr [ebp - local_10]          # 004dc4f1
    mov dword ptr [0x6381a5], ecx                # 004dc4f4
    cmp dword ptr [0x6381a5], 0x0                # 004dc4fa
    jne.d8 L_004dc521                            # 004dc501
    # block 0x004dc503: entered by fall-through of jne at 0x004dc501, 6 instruction(s), calls FUN_0042639d, FUN_004c97b4, falls into the block at 0x004dc521
    push 0x55b170                                # 004dc503
    push 0x55b198                                # 004dc508
    mov ecx, 0x583979                            # 004dc50d
    call FUN_0042639d                            # 004dc512
    mov ecx, 0x5cf659                            # 004dc517
    call FUN_004c97b4                            # 004dc51c
L_004dc521:
    # block 0x004dc521: entered by jne at 0x004dc4a0; jne at 0x004dc501, 4 instruction(s), ends with jne to 0x004dc552 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004dc521
    movsx eax, word ptr [edx + field_b7]         # 004dc524
    cmp eax, 0x1                                 # 004dc52b
    jne.d8 L_004dc552                            # 004dc52e
    # block 0x004dc530: entered by fall-through of jne at 0x004dc52e, 7 instruction(s), ends with forward jump to 0x004dc572
    mov ecx, dword ptr [ebp - local_18]          # 004dc530
    mov edx, dword ptr [ecx + field_ee]          # 004dc533
    mov eax, dword ptr [ebp - local_18]          # 004dc539
    mov ecx, dword ptr [eax + field_ee]          # 004dc53c
    mov dx, word ptr [edx + field_18c]           # 004dc542
    mov word ptr [ecx + field_1c2], dx           # 004dc549
    jmp.d8 L_004dc572                            # 004dc550
L_004dc552:
    # block 0x004dc552: entered by jne at 0x004dc52e, 6 instruction(s), falls into the block at 0x004dc572
    mov eax, dword ptr [ebp - local_18]          # 004dc552
    mov ecx, dword ptr [eax + field_ee]          # 004dc555
    mov edx, dword ptr [ebp - local_18]          # 004dc55b
    mov eax, dword ptr [edx + field_ee]          # 004dc55e
    mov cx, word ptr [ecx + field_18e]           # 004dc564
    mov word ptr [eax + field_1c2], cx           # 004dc56b
L_004dc572:
    # block 0x004dc572: entered by jmp at 0x004dc550, 6 instruction(s), calls FUN_00449bff, ends with forward jump to 0x004dc6f8
    mov edx, dword ptr [ebp - local_18]          # 004dc572
    mov eax, dword ptr [edx + field_ee]          # 004dc575
    mov word ptr [eax + field_1cc], 0x0          # 004dc57b
    mov ecx, dword ptr [0x6381a5]                # 004dc584
    call FUN_00449bff                            # 004dc58a
    jmp.d32 L_004dc6f8                           # 004dc58f
L_004dc594:
    # block 0x004dc594: entered by je at 0x004dc3f9, 28 instruction(s), calls FUN_004c2c3a, ends with je to 0x004dc67f (forward)
    push 0x55b1bc                                # 004dc594
    push 0x0                                     # 004dc599
    push 0x8                                     # 004dc59b
    mov ecx, dword ptr [ebp - local_18]          # 004dc59d
    mov edx, dword ptr [ecx + field_ee]          # 004dc5a0
    mov eax, dword ptr [ebp - local_18]          # 004dc5a6
    mov ecx, dword ptr [eax + field_ee]          # 004dc5a9
    mov edx, dword ptr [edx + field_1b6]         # 004dc5af
    sub edx, dword ptr [ecx + field_1ae]         # 004dc5b5
    add edx, 0x1                                 # 004dc5bb
    push edx                                     # 004dc5be
    mov eax, dword ptr [ebp - local_18]          # 004dc5bf
    mov ecx, dword ptr [eax + field_ee]          # 004dc5c2
    mov edx, dword ptr [ebp - local_18]          # 004dc5c8
    mov eax, dword ptr [edx + field_ee]          # 004dc5cb
    mov ecx, dword ptr [ecx + field_1b2]         # 004dc5d1
    sub ecx, dword ptr [eax + field_1aa]         # 004dc5d7
    add ecx, 0x1                                 # 004dc5dd
    push ecx                                     # 004dc5e0
    mov ecx, 0x5cf659                            # 004dc5e1
    call FUN_004c2c3a                            # 004dc5e6
    mov edx, dword ptr [ebp - local_18]          # 004dc5eb
    mov dword ptr [edx + field_4a], eax          # 004dc5ee
    mov eax, dword ptr [ebp - local_18]          # 004dc5f1
    movsx ecx, word ptr [eax + field_b7]         # 004dc5f4
    mov dword ptr [ebp - local_2c], ecx          # 004dc5fb
    cmp dword ptr [ebp - local_2c], 0x2          # 004dc5fe
    je.d8 L_004dc67f                             # 004dc602
    # block 0x004dc604: entered by fall-through of je at 0x004dc602, 8 instruction(s), calls FUN_004bef11, ends with je to 0x004dc67d (forward)
    push 0x0                                     # 004dc604
    mov edx, dword ptr [ebp - local_18]          # 004dc606
    mov eax, dword ptr [edx + field_106]         # 004dc609
    push eax                                     # 004dc60f
    mov ecx, 0x6201f9                            # 004dc610
    call FUN_004bef11                            # 004dc615
    test eax, eax                                # 004dc61a
    je.d8 L_004dc67d                             # 004dc61c
    # block 0x004dc61e: entered by fall-through of je at 0x004dc61c, 11 instruction(s), calls FUN_004bf3b8, FUN_0050ca3e, ends with je to 0x004dc655 (forward)
    push 0x0                                     # 004dc61e
    mov ecx, 0x6201f9                            # 004dc620
    call FUN_004bf3b8                            # 004dc625
    push eax                                     # 004dc62a
    push 0x55b1d8                                # 004dc62b
    push 0x63888b                                # 004dc630
    call FUN_0050ca3e                            # 004dc635
    add esp, 0xc                                 # 004dc63a
    movsx ecx, word ptr [0x63a4cd]               # 004dc63d
    test ecx, ecx                                # 004dc644
    je.d8 L_004dc655                             # 004dc646
    # block 0x004dc648: entered by fall-through of je at 0x004dc646, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004dc655
    push 0x63888b                                # 004dc648
    call FUN_0044a2b7                            # 004dc64d
    add esp, 0x4                                 # 004dc652
L_004dc655:
    # block 0x004dc655: entered by je at 0x004dc646, 7 instruction(s), calls FUN_004264e8, FUN_004c97b4, ends with forward jump to 0x004dcdb3
    push 0x63888b                                # 004dc655
    mov ecx, 0x583979                            # 004dc65a
    call FUN_004264e8                            # 004dc65f
    mov dword ptr [0x5bb20c], 0x1                # 004dc664
    mov ecx, 0x5cf659                            # 004dc66e
    call FUN_004c97b4                            # 004dc673
    jmp.d32 L_004dcdb3                           # 004dc678
L_004dc67d:
    # block 0x004dc67d: entered by je at 0x004dc61c, 1 instruction(s), ends with forward jump to 0x004dc6f8
    jmp.d8 L_004dc6f8                            # 004dc67d
L_004dc67f:
    # block 0x004dc67f: entered by je at 0x004dc602, 8 instruction(s), calls FUN_004bef11, ends with je to 0x004dc6f8 (forward)
    push 0x1                                     # 004dc67f
    mov edx, dword ptr [ebp - local_18]          # 004dc681
    mov eax, dword ptr [edx + field_106]         # 004dc684
    push eax                                     # 004dc68a
    mov ecx, 0x6201f9                            # 004dc68b
    call FUN_004bef11                            # 004dc690
    test eax, eax                                # 004dc695
    je.d8 L_004dc6f8                             # 004dc697
    # block 0x004dc699: entered by fall-through of je at 0x004dc697, 11 instruction(s), calls FUN_004bf3b8, FUN_0050ca3e, ends with je to 0x004dc6d0 (forward)
    push 0x0                                     # 004dc699
    mov ecx, 0x6201f9                            # 004dc69b
    call FUN_004bf3b8                            # 004dc6a0
    push eax                                     # 004dc6a5
    push 0x55b200                                # 004dc6a6
    push 0x63888b                                # 004dc6ab
    call FUN_0050ca3e                            # 004dc6b0
    add esp, 0xc                                 # 004dc6b5
    movsx ecx, word ptr [0x63a4cd]               # 004dc6b8
    test ecx, ecx                                # 004dc6bf
    je.d8 L_004dc6d0                             # 004dc6c1
    # block 0x004dc6c3: entered by fall-through of je at 0x004dc6c1, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004dc6d0
    push 0x63888b                                # 004dc6c3
    call FUN_0044a2b7                            # 004dc6c8
    add esp, 0x4                                 # 004dc6cd
L_004dc6d0:
    # block 0x004dc6d0: entered by je at 0x004dc6c1, 7 instruction(s), calls FUN_004264e8, FUN_004c97b4, ends with forward jump to 0x004dcdb3
    push 0x63888b                                # 004dc6d0
    mov ecx, 0x583979                            # 004dc6d5
    call FUN_004264e8                            # 004dc6da
    mov dword ptr [0x5bb20c], 0x1                # 004dc6df
    mov ecx, 0x5cf659                            # 004dc6e9
    call FUN_004c97b4                            # 004dc6ee
    jmp.d32 L_004dcdb3                           # 004dc6f3
L_004dc6f8:
    # block 0x004dc6f8: entered by jmp at 0x004dc58f; jmp at 0x004dc67d; je at 0x004dc697, 5 instruction(s), ends with je to 0x004dc70d (forward)
    mov edx, dword ptr [ebp - local_18]          # 004dc6f8
    movsx eax, word ptr [edx + field_b3]         # 004dc6fb
    mov dword ptr [ebp - local_30], eax          # 004dc702
    cmp dword ptr [ebp - local_30], 0x0          # 004dc705
    je.d8 L_004dc70d                             # 004dc709
    # block 0x004dc70b: entered by fall-through of je at 0x004dc709, 1 instruction(s), ends with forward jump to 0x004dc772
    jmp.d8 L_004dc772                            # 004dc70b
L_004dc70d:
    # block 0x004dc70d: entered by je at 0x004dc709, 25 instruction(s), ends with forward jump to 0x004dc7fa
    mov ecx, dword ptr [ebp - local_18]          # 004dc70d
    movsx edx, word ptr [ecx + field_bb]         # 004dc710
    mov eax, dword ptr [ebp - local_18]          # 004dc717
    mov dword ptr [eax + field_3a], edx          # 004dc71a
    mov ecx, dword ptr [ebp - local_18]          # 004dc71d
    movsx edx, word ptr [ecx + field_b9]         # 004dc720
    mov eax, dword ptr [ebp - local_18]          # 004dc727
    mov dword ptr [eax + field_36], edx          # 004dc72a
    mov ecx, dword ptr [ebp - local_18]          # 004dc72d
    mov edx, dword ptr [ecx + field_ee]          # 004dc730
    movsx eax, word ptr [edx + field_194]        # 004dc736
    mov ecx, dword ptr [ebp - local_18]          # 004dc73d
    mov edx, dword ptr [ecx + field_36]          # 004dc740
    lea eax, [edx + eax - field_minus_1]         # 004dc743
    mov ecx, dword ptr [ebp - local_18]          # 004dc747
    mov dword ptr [ecx + field_3e], eax          # 004dc74a
    mov edx, dword ptr [ebp - local_18]          # 004dc74d
    mov eax, dword ptr [edx + field_ee]          # 004dc750
    movsx ecx, word ptr [eax + field_198]        # 004dc756
    mov edx, dword ptr [ebp - local_18]          # 004dc75d
    mov eax, dword ptr [edx + field_3a]          # 004dc760
    lea ecx, [eax + ecx - field_minus_1]         # 004dc763
    mov edx, dword ptr [ebp - local_18]          # 004dc767
    mov dword ptr [edx + field_42], ecx          # 004dc76a
    jmp.d32 L_004dc7fa                           # 004dc76d
L_004dc772:
    # block 0x004dc772: entered by jmp at 0x004dc70b, 36 instruction(s), falls into the block at 0x004dc7fa
    movsx eax, word ptr [0x63988d]               # 004dc772
    mov ecx, dword ptr [ebp - local_18]          # 004dc779
    mov edx, dword ptr [ecx + field_ee]          # 004dc77c
    movsx ecx, word ptr [edx + field_198]        # 004dc782
    {load} sub eax, ecx                          # 004dc789
    cdq                                          # 004dc78b
    {load} sub eax, edx                          # 004dc78c
    sar eax                                      # 004dc78e
    mov edx, dword ptr [ebp - local_18]          # 004dc790
    mov dword ptr [edx + field_3a], eax          # 004dc793
    movsx eax, word ptr [0x63988b]               # 004dc796
    mov ecx, dword ptr [ebp - local_18]          # 004dc79d
    mov edx, dword ptr [ecx + field_ee]          # 004dc7a0
    movsx ecx, word ptr [edx + field_194]        # 004dc7a6
    {load} sub eax, ecx                          # 004dc7ad
    cdq                                          # 004dc7af
    {load} sub eax, edx                          # 004dc7b0
    sar eax                                      # 004dc7b2
    mov edx, dword ptr [ebp - local_18]          # 004dc7b4
    mov dword ptr [edx + field_36], eax          # 004dc7b7
    mov eax, dword ptr [ebp - local_18]          # 004dc7ba
    mov ecx, dword ptr [eax + field_ee]          # 004dc7bd
    movsx edx, word ptr [ecx + field_194]        # 004dc7c3
    mov eax, dword ptr [ebp - local_18]          # 004dc7ca
    mov ecx, dword ptr [eax + field_36]          # 004dc7cd
    lea edx, [ecx + edx - field_minus_1]         # 004dc7d0
    mov eax, dword ptr [ebp - local_18]          # 004dc7d4
    mov dword ptr [eax + field_3e], edx          # 004dc7d7
    mov ecx, dword ptr [ebp - local_18]          # 004dc7da
    mov edx, dword ptr [ecx + field_ee]          # 004dc7dd
    movsx eax, word ptr [edx + field_198]        # 004dc7e3
    mov ecx, dword ptr [ebp - local_18]          # 004dc7ea
    mov edx, dword ptr [ecx + field_3a]          # 004dc7ed
    lea eax, [edx + eax - field_minus_1]         # 004dc7f0
    mov ecx, dword ptr [ebp - local_18]          # 004dc7f4
    mov dword ptr [ecx + field_42], eax          # 004dc7f7
L_004dc7fa:
    # block 0x004dc7fa: entered by je at 0x004dc2df; jmp at 0x004dc76d, 28 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x004dcdb3
    mov edx, dword ptr [ebp - local_18]          # 004dc7fa
    movsx eax, word ptr [edx + field_bb]         # 004dc7fd
    mov ecx, dword ptr [ebp - local_18]          # 004dc804
    mov dword ptr [ecx + field_2a], eax          # 004dc807
    mov edx, dword ptr [ebp - local_18]          # 004dc80a
    movsx eax, word ptr [edx + field_b9]         # 004dc80d
    mov ecx, dword ptr [ebp - local_18]          # 004dc814
    mov dword ptr [ecx + field_26], eax          # 004dc817
    mov edx, dword ptr [ebp - local_18]          # 004dc81a
    mov eax, dword ptr [edx + field_46]          # 004dc81d
    mov ecx, dword ptr [ebp - local_18]          # 004dc820
    mov edx, dword ptr [ecx + field_26]          # 004dc823
    add edx, dword ptr [eax + field_3d]          # 004dc826
    mov eax, dword ptr [ebp - local_18]          # 004dc829
    mov dword ptr [eax + field_2e], edx          # 004dc82c
    mov ecx, dword ptr [ebp - local_18]          # 004dc82f
    mov edx, dword ptr [ecx + field_46]          # 004dc832
    mov eax, dword ptr [ebp - local_18]          # 004dc835
    mov ecx, dword ptr [eax + field_2a]          # 004dc838
    add ecx, dword ptr [edx + field_41]          # 004dc83b
    mov edx, dword ptr [ebp - local_18]          # 004dc83e
    mov dword ptr [edx + field_32], ecx          # 004dc841
    call dword ptr [0x52a23c]                    # 004dc844
    mov ecx, dword ptr [ebp - local_18]          # 004dc84a
    mov dword ptr [ecx + field_20], eax          # 004dc84d
    mov edx, dword ptr [ebp - local_18]          # 004dc850
    mov dword ptr [edx + field_1c], 0x1          # 004dc853
    jmp.d32 L_004dcdb3                           # 004dc85a
L_004dc85f:
    # block 0x004dc85f: entered by switch case, 3 instruction(s), ends with je to 0x004dc877 (forward)
    movsx eax, word ptr [0x63a4cd]               # 004dc85f
    test eax, eax                                # 004dc866
    je.d8 L_004dc877                             # 004dc868
    # block 0x004dc86a: entered by fall-through of je at 0x004dc868, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004dc877
    push 0x55b228                                # 004dc86a
    call FUN_0044a2b7                            # 004dc86f
    add esp, 0x4                                 # 004dc874
L_004dc877:
    # block 0x004dc877: entered by je at 0x004dc868, 10 instruction(s), calls FUN_004fbd98, FUN_004fc077, ends with je to 0x004dc917 (forward)
    mov ecx, 0x5c3a67                            # 004dc877
    call FUN_004fbd98                            # 004dc87c
    push 0x5b4631                                # 004dc881
    mov ecx, 0x5c3a67                            # 004dc886
    call FUN_004fc077                            # 004dc88b
    push 0x5b489b                                # 004dc890
    mov ecx, 0x5c3a67                            # 004dc895
    call FUN_004fc077                            # 004dc89a
    cmp dword ptr [0x5bb21a], 0x0                # 004dc89f
    je.d8 L_004dc917                             # 004dc8a6
    # block 0x004dc8a8: entered by fall-through of je at 0x004dc8a6, 3 instruction(s), ends with je to 0x004dc8cc (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004dc8a8
    cmp dword ptr [ecx + field_fa], 0x0          # 004dc8ab
    je.d8 L_004dc8cc                             # 004dc8b2
    # block 0x004dc8b4: entered by fall-through of je at 0x004dc8b2, 3 instruction(s), ends with je to 0x004dc917 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004dc8b4
    cmp dword ptr [edx + field_fa], 0x0          # 004dc8b7
    je.d8 L_004dc917                             # 004dc8be
    # block 0x004dc8c0: entered by fall-through of je at 0x004dc8be, 3 instruction(s), ends with jne to 0x004dc917 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004dc8c0
    cmp dword ptr [eax + field_102], 0x0         # 004dc8c3
    jne.d8 L_004dc917                            # 004dc8ca
L_004dc8cc:
    # block 0x004dc8cc: entered by je at 0x004dc8b2; fall-through of jne at 0x004dc8ca, 11 instruction(s), ends with jne to 0x004dc90d (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004dc8cc
    mov dx, word ptr [0x5b451f]                  # 004dc8cf
    mov word ptr [ecx + field_24], dx            # 004dc8d6
    mov eax, dword ptr [ebp - local_18]          # 004dc8da
    {load} xor ecx, ecx                          # 004dc8dd
    mov cx, word ptr [eax + field_24]            # 004dc8df
    imul ecx, ecx, 0x5bb                         # 004dc8e3
    {load} xor edx, edx                          # 004dc8e9
    mov dx, word ptr [ecx + 0x5c3b99]            # 004dc8eb
    test edx, edx                                # 004dc8f2
    jne.d8 L_004dc90d                            # 004dc8f4
    # block 0x004dc8f6: entered by fall-through of jne at 0x004dc8f4, 6 instruction(s), calls FUN_004faf98, falls into the block at 0x004dc90d
    mov eax, dword ptr [ebp - local_18]          # 004dc8f6
    mov cx, word ptr [eax + field_24]            # 004dc8f9
    push ecx                                     # 004dc8fd
    push 0x5b452d                                # 004dc8fe
    mov ecx, 0x5c3a67                            # 004dc903
    call FUN_004faf98                            # 004dc908
L_004dc90d:
    # block 0x004dc90d: entered by jne at 0x004dc8f4, 1 instruction(s), falls into the block at 0x004dc917
    mov dword ptr [0x5bb21a], 0x0                # 004dc90d
L_004dc917:
    # block 0x004dc917: entered by je at 0x004dc8a6; je at 0x004dc8be; jne at 0x004dc8ca, 3 instruction(s), ends with je to 0x004dc943 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004dc917
    cmp dword ptr [edx + field_fa], 0x0          # 004dc91a
    je.d8 L_004dc943                             # 004dc921
    # block 0x004dc923: entered by fall-through of je at 0x004dc921, 3 instruction(s), ends with je to 0x004dc943 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004dc923
    cmp dword ptr [eax + field_102], 0x0         # 004dc926
    je.d8 L_004dc943                             # 004dc92d
    # block 0x004dc92f: entered by fall-through of je at 0x004dc92d, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004dc943
    mov ecx, dword ptr [ebp - local_18]          # 004dc92f
    add ecx, 0xbd                                # 004dc932
    push ecx                                     # 004dc938
    mov ecx, 0x5c3a67                            # 004dc939
    call FUN_004fb77a                            # 004dc93e
L_004dc943:
    # block 0x004dc943: entered by je at 0x004dc921; je at 0x004dc92d, 3 instruction(s), ends with forward jump to 0x004dcdb3
    mov edx, dword ptr [ebp - local_18]          # 004dc943
    mov dword ptr [edx + field_1c], 0x2          # 004dc946
    jmp.d32 L_004dcdb3                           # 004dc94d
L_004dc952:
    # block 0x004dc952: entered by switch case, 5 instruction(s), calls FUN_004dadff, ends with je to 0x004dca42 (forward)
    mov ecx, 0x5830a6                            # 004dc952
    call FUN_004dadff                            # 004dc957
    mov eax, dword ptr [ebp - local_18]          # 004dc95c
    cmp dword ptr [eax + field_fa], 0x0          # 004dc95f
    je.d32 L_004dca42                            # 004dc966
    # block 0x004dc96c: entered by fall-through of je at 0x004dc966, 5 instruction(s), ends with je to 0x004dc981 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004dc96c
    movsx edx, word ptr [ecx + field_b1]         # 004dc96f
    mov dword ptr [ebp - local_34], edx          # 004dc976
    cmp dword ptr [ebp - local_34], 0x1          # 004dc979
    je.d8 L_004dc981                             # 004dc97d
    # block 0x004dc97f: entered by fall-through of je at 0x004dc97d, 1 instruction(s), ends with forward jump to 0x004dc98b
    jmp.d8 L_004dc98b                            # 004dc97f
L_004dc981:
    # block 0x004dc981: entered by je at 0x004dc97d, 3 instruction(s), calls FUN_004dd05a, ends with forward jump to 0x004dc993
    mov ecx, dword ptr [ebp - local_18]          # 004dc981
    call FUN_004dd05a                            # 004dc984
    jmp.d8 L_004dc993                            # 004dc989
L_004dc98b:
    # block 0x004dc98b: entered by jmp at 0x004dc97f, 2 instruction(s), calls FUN_004dcdd3, falls into the block at 0x004dc993
    mov ecx, dword ptr [ebp - local_18]          # 004dc98b
    call FUN_004dcdd3                            # 004dc98e
L_004dc993:
    # block 0x004dc993: entered by jmp at 0x004dc989, 2 instruction(s), ends with jne to 0x004dc9a8 (forward)
    cmp dword ptr [0x5d2f09], 0x0                # 004dc993
    jne.d8 L_004dc9a8                            # 004dc99a
    # block 0x004dc99c: entered by fall-through of jne at 0x004dc99a, 3 instruction(s), ends with je to 0x004dc9ed (forward)
    mov eax, dword ptr [ebp - local_18]          # 004dc99c
    cmp dword ptr [eax + field_f2], 0x0          # 004dc99f
    je.d8 L_004dc9ed                             # 004dc9a6
L_004dc9a8:
    # block 0x004dc9a8: entered by jne at 0x004dc99a; fall-through of je at 0x004dc9a6, 18 instruction(s), calls FUN_004c5377, falls into the block at 0x004dc9ed
    push 0x55b270                                # 004dc9a8
    mov ecx, dword ptr [ebp - local_18]          # 004dc9ad
    add ecx, 0x26                                # 004dc9b0
    push ecx                                     # 004dc9b3
    mov edx, dword ptr [ebp - local_18]          # 004dc9b4
    mov eax, dword ptr [edx + field_46]          # 004dc9b7
    add eax, 0x35                                # 004dc9ba
    push eax                                     # 004dc9bd
    mov ecx, dword ptr [0x5cf661]                # 004dc9be
    push ecx                                     # 004dc9c4
    mov edx, dword ptr [ebp - local_18]          # 004dc9c5
    mov eax, dword ptr [edx + field_46]          # 004dc9c8
    push eax                                     # 004dc9cb
    mov ecx, 0x5cf659                            # 004dc9cc
    call FUN_004c5377                            # 004dc9d1
    mov ecx, dword ptr [ebp - local_18]          # 004dc9d6
    mov dword ptr [ecx + field_f2], 0x0          # 004dc9d9
    mov dword ptr [0x5d2f09], 0x0                # 004dc9e3
L_004dc9ed:
    # block 0x004dc9ed: entered by je at 0x004dc9a6, 2 instruction(s), ends with je to 0x004dca40 (forward)
    cmp dword ptr [0x6381e5], 0x0                # 004dc9ed
    je.d8 L_004dca40                             # 004dc9f4
    # block 0x004dc9f6: entered by fall-through of je at 0x004dc9f4, 19 instruction(s), calls FUN_004c5377, falls into the block at 0x004dca40
    push 0x55b294                                # 004dc9f6
    mov edx, dword ptr [ebp - local_18]          # 004dc9fb
    add edx, 0x36                                # 004dc9fe
    push edx                                     # 004dca01
    mov eax, dword ptr [ebp - local_18]          # 004dca02
    mov ecx, dword ptr [eax + field_4a]          # 004dca05
    add ecx, 0x35                                # 004dca08
    push ecx                                     # 004dca0b
    mov edx, dword ptr [0x5cf661]                # 004dca0c
    push edx                                     # 004dca12
    mov eax, dword ptr [ebp - local_18]          # 004dca13
    mov ecx, dword ptr [eax + field_4a]          # 004dca16
    push ecx                                     # 004dca19
    mov ecx, 0x5cf659                            # 004dca1a
    call FUN_004c5377                            # 004dca1f
    mov dword ptr [0x6381e5], 0x0                # 004dca24
    mov edx, dword ptr [ebp - local_18]          # 004dca2e
    mov eax, dword ptr [edx + field_ee]          # 004dca31
    mov word ptr [eax + field_1cc], 0x0          # 004dca37
L_004dca40:
    # block 0x004dca40: entered by je at 0x004dc9f4, 1 instruction(s), ends with forward jump to 0x004dca9c
    jmp.d8 L_004dca9c                            # 004dca40
L_004dca42:
    # block 0x004dca42: entered by je at 0x004dc966, 2 instruction(s), ends with jne to 0x004dca57 (forward)
    cmp dword ptr [0x5d2f09], 0x0                # 004dca42
    jne.d8 L_004dca57                            # 004dca49
    # block 0x004dca4b: entered by fall-through of jne at 0x004dca49, 3 instruction(s), ends with je to 0x004dca9c (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004dca4b
    cmp dword ptr [ecx + field_f2], 0x0          # 004dca4e
    je.d8 L_004dca9c                             # 004dca55
L_004dca57:
    # block 0x004dca57: entered by jne at 0x004dca49; fall-through of je at 0x004dca55, 18 instruction(s), calls FUN_004c5377, falls into the block at 0x004dca9c
    push 0x55b2bc                                # 004dca57
    mov edx, dword ptr [ebp - local_18]          # 004dca5c
    add edx, 0x26                                # 004dca5f
    push edx                                     # 004dca62
    mov eax, dword ptr [ebp - local_18]          # 004dca63
    mov ecx, dword ptr [eax + field_46]          # 004dca66
    add ecx, 0x35                                # 004dca69
    push ecx                                     # 004dca6c
    mov edx, dword ptr [0x5cf661]                # 004dca6d
    push edx                                     # 004dca73
    mov eax, dword ptr [ebp - local_18]          # 004dca74
    mov ecx, dword ptr [eax + field_46]          # 004dca77
    push ecx                                     # 004dca7a
    mov ecx, 0x5cf659                            # 004dca7b
    call FUN_004c5377                            # 004dca80
    mov edx, dword ptr [ebp - local_18]          # 004dca85
    mov dword ptr [edx + field_f2], 0x0          # 004dca88
    mov dword ptr [0x5d2f09], 0x0                # 004dca92
L_004dca9c:
    # block 0x004dca9c: entered by jmp at 0x004dca40; je at 0x004dca55, 3 instruction(s), ends with jne to 0x004dcac8 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004dca9c
    cmp dword ptr [eax + field_fa], 0x0          # 004dca9f
    jne.d8 L_004dcac8                            # 004dcaa6
    # block 0x004dcaa8: entered by fall-through of jne at 0x004dcaa6, 5 instruction(s), calls KERNEL32.dll!GetTickCount, ends with ja to 0x004dcaff (forward)
    call dword ptr [0x52a23c]                    # 004dcaa8
    mov ecx, dword ptr [ebp - local_18]          # 004dcaae
    sub eax, dword ptr [ecx + field_20]          # 004dcab1
    cmp eax, 0xfa0                               # 004dcab4
    ja.d8 L_004dcaff                             # 004dcab9
    # block 0x004dcabb: entered by fall-through of ja at 0x004dcab9, 4 instruction(s), ends with je to 0x004dcaff (forward)
    {load} xor edx, edx                          # 004dcabb
    mov dl, byte ptr [0x58321d]                  # 004dcabd
    cmp edx, 0x1                                 # 004dcac3
    je.d8 L_004dcaff                             # 004dcac6
L_004dcac8:
    # block 0x004dcac8: entered by jne at 0x004dcaa6; fall-through of je at 0x004dcac6, 3 instruction(s), ends with je to 0x004dcbb4 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004dcac8
    cmp dword ptr [eax + field_fa], 0x0          # 004dcacb
    je.d32 L_004dcbb4                            # 004dcad2
    # block 0x004dcad8: entered by fall-through of je at 0x004dcad2, 4 instruction(s), ends with jne to 0x004dcbb4 (forward)
    {load} xor ecx, ecx                          # 004dcad8
    mov cl, byte ptr [0x58321d]                  # 004dcada
    cmp ecx, 0x1                                 # 004dcae0
    jne.d32 L_004dcbb4                           # 004dcae3
    # block 0x004dcae9: entered by fall-through of jne at 0x004dcae3, 2 instruction(s), ends with je to 0x004dcaff (forward)
    cmp dword ptr [0x6381a9], 0x4                # 004dcae9
    je.d8 L_004dcaff                             # 004dcaf0
    # block 0x004dcaf2: entered by fall-through of je at 0x004dcaf0, 2 instruction(s), ends with jne to 0x004dcbb4 (forward)
    cmp dword ptr [0x6381a9], 0x5                # 004dcaf2
    jne.d32 L_004dcbb4                           # 004dcaf9
L_004dcaff:
    # block 0x004dcaff: entered by ja at 0x004dcab9; je at 0x004dcac6; je at 0x004dcaf0; fall-through of jne at 0x004dcaf9, 5 instruction(s), calls FUN_004dad60, ends with jne to 0x004dcbaa (forward)
    mov ecx, 0x5830a6                            # 004dcaff
    call FUN_004dad60                            # 004dcb04
    mov edx, dword ptr [ebp - local_18]          # 004dcb09
    cmp dword ptr [edx + field_fa], 0x0          # 004dcb0c
    jne.d32 L_004dcbaa                           # 004dcb13
    # block 0x004dcb19: entered by fall-through of jne at 0x004dcb13, 4 instruction(s), ends with je to 0x004dcbaa (forward)
    mov eax, dword ptr [ebp - local_18]          # 004dcb19
    movsx ecx, byte ptr [eax + field_6f]         # 004dcb1c
    test ecx, ecx                                # 004dcb20
    je.d32 L_004dcbaa                            # 004dcb22
    # block 0x004dcb28: entered by fall-through of je at 0x004dcb22, 3 instruction(s), ends with jne to 0x004dcbaa (forward)
    mov edx, dword ptr [ebp - local_18]          # 004dcb28
    cmp dword ptr [edx + field_fe], 0x0          # 004dcb2b
    jne.d8 L_004dcbaa                            # 004dcb32
    # block 0x004dcb34: entered by fall-through of jne at 0x004dcb32, 3 instruction(s), ends with je to 0x004dcb4e (forward)
    mov eax, dword ptr [ebp - local_18]          # 004dcb34
    cmp dword ptr [eax + field_46], 0x0          # 004dcb37
    je.d8 L_004dcb4e                             # 004dcb3b
    # block 0x004dcb3d: entered by fall-through of je at 0x004dcb3b, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004dcb4e
    mov ecx, dword ptr [ebp - local_18]          # 004dcb3d
    add ecx, 0x46                                # 004dcb40
    push ecx                                     # 004dcb43
    mov ecx, 0x5cf659                            # 004dcb44
    call FUN_004c2dfb                            # 004dcb49
L_004dcb4e:
    # block 0x004dcb4e: entered by je at 0x004dcb3b, 21 instruction(s), calls FUN_004c2790, KERNEL32.dll!GetTickCount, ends with forward jump to 0x004dcbb4
    push 0x55b2e0                                # 004dcb4e
    push 0x6                                     # 004dcb53
    mov edx, dword ptr [ebp - local_18]          # 004dcb55
    add edx, 0x6f                                # 004dcb58
    push edx                                     # 004dcb5b
    push 0x55b2f8                                # 004dcb5c
    mov ecx, 0x5cf659                            # 004dcb61
    call FUN_004c2790                            # 004dcb66
    mov ecx, dword ptr [ebp - local_18]          # 004dcb6b
    mov dword ptr [ecx + field_46], eax          # 004dcb6e
    mov edx, dword ptr [ebp - local_18]          # 004dcb71
    mov dword ptr [edx + field_f2], 0x1          # 004dcb74
    mov byte ptr [0x58321d], 0x0                 # 004dcb7e
    mov eax, dword ptr [ebp - local_18]          # 004dcb85
    mov dword ptr [eax + field_fe], 0x1          # 004dcb88
    call dword ptr [0x52a23c]                    # 004dcb92
    mov ecx, dword ptr [ebp - local_18]          # 004dcb98
    mov dword ptr [ecx + field_20], eax          # 004dcb9b
    mov edx, dword ptr [ebp - local_18]          # 004dcb9e
    mov dword ptr [edx + field_1c], 0x2          # 004dcba1
    jmp.d8 L_004dcbb4                            # 004dcba8
L_004dcbaa:
    # block 0x004dcbaa: entered by jne at 0x004dcb13; je at 0x004dcb22; jne at 0x004dcb32, 2 instruction(s), falls into the block at 0x004dcbb4
    mov eax, dword ptr [ebp - local_18]          # 004dcbaa
    mov dword ptr [eax + field_1c], 0x3          # 004dcbad
L_004dcbb4:
    # block 0x004dcbb4: entered by je at 0x004dcad2; jne at 0x004dcae3; jne at 0x004dcaf9; jmp at 0x004dcba8, 1 instruction(s), ends with forward jump to 0x004dcdb3
    jmp.d32 L_004dcdb3                           # 004dcbb4
L_004dcbb9:
    # block 0x004dcbb9: entered by switch case, 3 instruction(s), ends with je to 0x004dcbec (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004dcbb9
    cmp dword ptr [ecx + field_fa], 0x0          # 004dcbbc
    je.d8 L_004dcbec                             # 004dcbc3
    # block 0x004dcbc5: entered by fall-through of je at 0x004dcbc3, 4 instruction(s), ends with jne to 0x004dcbec (forward)
    mov edx, dword ptr [ebp - local_18]          # 004dcbc5
    movsx eax, word ptr [edx + field_b1]         # 004dcbc8
    test eax, eax                                # 004dcbcf
    jne.d8 L_004dcbec                            # 004dcbd1
    # block 0x004dcbd3: entered by fall-through of jne at 0x004dcbd1, 5 instruction(s), ends with jne to 0x004dcbec (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004dcbd3
    mov edx, dword ptr [ecx + field_ee]          # 004dcbd6
    movsx eax, word ptr [edx + field_1cc]        # 004dcbdc
    test eax, eax                                # 004dcbe3
    jne.d8 L_004dcbec                            # 004dcbe5
    # block 0x004dcbe7: entered by fall-through of jne at 0x004dcbe5, 1 instruction(s), ends with forward jump to 0x004dcdb3
    jmp.d32 L_004dcdb3                           # 004dcbe7
L_004dcbec:
    # block 0x004dcbec: entered by je at 0x004dcbc3; jne at 0x004dcbd1; jne at 0x004dcbe5, 3 instruction(s), ends with je to 0x004dcc17 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004dcbec
    cmp dword ptr [ecx + field_fa], 0x0          # 004dcbef
    je.d8 L_004dcc17                             # 004dcbf6
    # block 0x004dcbf8: entered by fall-through of je at 0x004dcbf6, 3 instruction(s), ends with je to 0x004dcc17 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004dcbf8
    cmp dword ptr [edx + field_102], 0x0         # 004dcbfb
    je.d8 L_004dcc17                             # 004dcc02
    # block 0x004dcc04: entered by fall-through of je at 0x004dcc02, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004dcc17
    mov eax, dword ptr [ebp - local_18]          # 004dcc04
    add eax, 0xbd                                # 004dcc07
    push eax                                     # 004dcc0c
    mov ecx, 0x5c3a67                            # 004dcc0d
    call FUN_004fba69                            # 004dcc12
L_004dcc17:
    # block 0x004dcc17: entered by je at 0x004dcbf6; je at 0x004dcc02, 13 instruction(s), calls FUN_004dc043, FUN_004d5c54, USER32.dll!GetAsyncKeyState, ends with jne to 0x004dccb6 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004dcc17
    call FUN_004dc043                            # 004dcc1a
    mov dword ptr [0x583985], 0x2                # 004dcc1f
    mov dword ptr [0x5d2f09], 0x1                # 004dcc29
    mov ecx, 0x5e2e70                            # 004dcc33
    call FUN_004d5c54                            # 004dcc38
    mov dword ptr [0x5e32b9], 0x0                # 004dcc3d
    push 0x4e                                    # 004dcc47
    call dword ptr [0x52a4b4]                    # 004dcc49
    movsx ecx, ax                                # 004dcc4f
    and ecx, 0x8000                              # 004dcc52
    cmp ecx, 0x8000                              # 004dcc58
    jne.d8 L_004dccb6                            # 004dcc5e
    # block 0x004dcc60: entered by fall-through of jne at 0x004dcc5e, 6 instruction(s), calls USER32.dll!GetAsyncKeyState, ends with jne to 0x004dccb6 (forward)
    push 0x44                                    # 004dcc60
    call dword ptr [0x52a4b4]                    # 004dcc62
    movsx edx, ax                                # 004dcc68
    and edx, 0x8000                              # 004dcc6b
    cmp edx, 0x8000                              # 004dcc71
    jne.d8 L_004dccb6                            # 004dcc77
    # block 0x004dcc79: entered by fall-through of jne at 0x004dcc77, 7 instruction(s), calls FUN_0043dbd5, ends with je to 0x004dccb1 (forward)
    mov dword ptr [0x583981], 0xe                # 004dcc79
    mov dword ptr [0x583999], 0x0                # 004dcc83
    call FUN_0043dbd5                            # 004dcc8d
    mov byte ptr [0x58320c], 0x1                 # 004dcc92
    movsx eax, word ptr [0x63a4cd]               # 004dcc99
    test eax, eax                                # 004dcca0
    je.d8 L_004dccb1                             # 004dcca2
    # block 0x004dcca4: entered by fall-through of je at 0x004dcca2, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004dccb1
    push 0x55b300                                # 004dcca4
    call FUN_0044a2b7                            # 004dcca9
    add esp, 0x4                                 # 004dccae
L_004dccb1:
    # block 0x004dccb1: entered by je at 0x004dcca2, 1 instruction(s), ends with forward jump to 0x004dcdb3
    jmp.d32 L_004dcdb3                           # 004dccb1
L_004dccb6:
    # block 0x004dccb6: entered by jne at 0x004dcc5e; jne at 0x004dcc77, 6 instruction(s), calls USER32.dll!GetAsyncKeyState, ends with jne to 0x004dcd87 (forward)
    push 0x4e                                    # 004dccb6
    call dword ptr [0x52a4b4]                    # 004dccb8
    movsx ecx, ax                                # 004dccbe
    and ecx, 0x8000                              # 004dccc1
    cmp ecx, 0x8000                              # 004dccc7
    jne.d32 L_004dcd87                           # 004dcccd
    # block 0x004dccd3: entered by fall-through of jne at 0x004dcccd, 6 instruction(s), calls USER32.dll!GetAsyncKeyState, ends with jne to 0x004dcd87 (forward)
    push 0x43                                    # 004dccd3
    call dword ptr [0x52a4b4]                    # 004dccd5
    movsx edx, ax                                # 004dccdb
    and edx, 0x8000                              # 004dccde
    cmp edx, 0x8000                              # 004dcce4
    jne.d32 L_004dcd87                           # 004dccea
    # block 0x004dccf0: entered by fall-through of jne at 0x004dccea, 5 instruction(s), calls FUN_004d912a, ends with je to 0x004dcd54 (forward)
    mov ecx, 0x5e2e70                            # 004dccf0
    call FUN_004d912a                            # 004dccf5
    movsx eax, ax                                # 004dccfa
    test eax, eax                                # 004dccfd
    je.d8 L_004dcd54                             # 004dccff
    # block 0x004dcd01: entered by fall-through of je at 0x004dccff, 11 instruction(s), calls FUN_004381f4, FUN_004d940a, FUN_0043dbd5, ends with je to 0x004dcd52 (forward)
    call FUN_004381f4                            # 004dcd01
    mov dword ptr [0x5ec342], 0x1                # 004dcd06
    mov ecx, 0x5e2e70                            # 004dcd10
    call FUN_004d940a                            # 004dcd15
    mov byte ptr [0x58320c], 0x1                 # 004dcd1a
    mov dword ptr [0x583981], 0xe                # 004dcd21
    mov dword ptr [0x583999], 0x4                # 004dcd2b
    call FUN_0043dbd5                            # 004dcd35
    movsx ecx, word ptr [0x63a4cd]               # 004dcd3a
    test ecx, ecx                                # 004dcd41
    je.d8 L_004dcd52                             # 004dcd43
    # block 0x004dcd45: entered by fall-through of je at 0x004dcd43, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004dcd52
    push 0x55b368                                # 004dcd45
    call FUN_0044a2b7                            # 004dcd4a
    add esp, 0x4                                 # 004dcd4f
L_004dcd52:
    # block 0x004dcd52: entered by je at 0x004dcd43, 1 instruction(s), ends with forward jump to 0x004dcd85
    jmp.d8 L_004dcd85                            # 004dcd52
L_004dcd54:
    # block 0x004dcd54: entered by je at 0x004dccff, 6 instruction(s), calls FUN_0043dbd5, ends with je to 0x004dcd85 (forward)
    mov dword ptr [0x583981], 0xe                # 004dcd54
    mov dword ptr [0x583999], 0x0                # 004dcd5e
    call FUN_0043dbd5                            # 004dcd68
    movsx edx, word ptr [0x63a4cd]               # 004dcd6d
    test edx, edx                                # 004dcd74
    je.d8 L_004dcd85                             # 004dcd76
    # block 0x004dcd78: entered by fall-through of je at 0x004dcd76, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004dcd85
    push 0x55b3ec                                # 004dcd78
    call FUN_0044a2b7                            # 004dcd7d
    add esp, 0x4                                 # 004dcd82
L_004dcd85:
    # block 0x004dcd85: entered by jmp at 0x004dcd52; je at 0x004dcd76, 1 instruction(s), ends with forward jump to 0x004dcdb3
    jmp.d8 L_004dcdb3                            # 004dcd85
L_004dcd87:
    # block 0x004dcd87: entered by jne at 0x004dcccd; jne at 0x004dccea, 5 instruction(s), ends with je to 0x004dcdb3 (forward)
    mov dword ptr [0x583981], 0x3                # 004dcd87
    mov dword ptr [0x58398d], 0x0                # 004dcd91
    movsx eax, word ptr [0x63a4cd]               # 004dcd9b
    test eax, eax                                # 004dcda2
    je.d8 L_004dcdb3                             # 004dcda4
    # block 0x004dcda6: entered by fall-through of je at 0x004dcda4, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004dcdb3
    push 0x55b460                                # 004dcda6
    call FUN_0044a2b7                            # 004dcdab
    add esp, 0x4                                 # 004dcdb0
L_004dcdb3:
    # block 0x004dcdb3: entered by ja at 0x004dc1af; jmp at 0x004dc678; jmp at 0x004dc6f3; jmp at 0x004dc85a; more, 7 instruction(s), ends with ret
    mov ecx, dword ptr [ebp - local_c]           # 004dcdb3
    mov dword ptr fs:[0x0], ecx                  # 004dcdb6
    pop edi                                      # 004dcdbd
    pop esi                                      # 004dcdbe
    {load} mov esp, ebp                          # 004dcdbf
    pop ebp                                      # 004dcdc1
    ret                                          # 004dcdc2

# --- data items (not part of the function) -------------------------
.org 0x004dcdc3 - 0x401000
SWTAB_004dcdc3:  # 4 case address(es)
    .long L_004dc1bf - .text + 0x401000
    .long L_004dc85f - .text + 0x401000
    .long L_004dc952 - .text + 0x401000
    .long L_004dcbb9 - .text + 0x401000
.set SWTAB_004dcdc3_VA, SWTAB_004dcdc3 - .text + 0x401000

