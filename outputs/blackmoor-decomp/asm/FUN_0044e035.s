# FUN_0044e035
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044e035
# extent:       0x0044e035-0x0044e624 (1519 code bytes)
# span:         0x0044e035-0x0044e650 (code 1519, tables 36, padding 8)
# sha256:       1713719381a39e1280e18dda1994ef4a2553c8e4027e818711d62d20290e880b
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44e035_draw_panel
# naming:       native port src/original_methods_fl21b.c:m44e035_draw_panel (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m44e035_draw_panel. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 1563 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       6 ebp-relative slot(s): local_4, local_14, local_18, local_1c, local_20, local_24
# fields:       [eax + n] field_c1, field_101
# callees:      calls FUN_0044d9b5, FUN_004c5377
# track-n:      outputs/blackmoor-decomp/src/blackmoor_app.mm:create_native_scene_session (function ledger class native_oracle_verified; also native_aaa_alloc_slot, native_aaa_render, native_caption_finish_tick; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 417 instruction(s), 12 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ field_c1, 0xc1  # offset +0xc1
.equ field_101, 0x101  # offset +0x101

# --- external targets -----------------------------------------------
.set FUN_0044d9b5, .text + (0x0044d9b5 - 0x401000)
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)

.org 0x0044e035 - 0x401000
.globl FUN_0044e035
FUN_0044e035:
    # block 0x0044e035: entry, 9 instruction(s), ends with je to 0x0044e075 (forward)
    push ebp                                     # 0044e035
    {load} mov ebp, esp                          # 0044e036
    sub esp, 0x24                                # 0044e038
    movsx eax, word ptr [0x624cdd]               # 0044e03b
    imul eax, eax, 0x8d                          # 0044e042
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0044e048
    mov dword ptr [ebp - local_1c], ecx          # 0044e04e
    cmp dword ptr [0x624cec], 0x0                # 0044e051
    je.d8 L_0044e075                             # 0044e058
    # block 0x0044e05a: entered by fall-through of je at 0x0044e058, 2 instruction(s), ends with je to 0x0044e075 (forward)
    cmp dword ptr [0x624cec], 0x8                # 0044e05a
    je.d8 L_0044e075                             # 0044e061
    # block 0x0044e063: entered by fall-through of je at 0x0044e061, 2 instruction(s), ends with jne to 0x0044e095 (forward)
    cmp dword ptr [0x624cec], 0x2                # 0044e063
    jne.d8 L_0044e095                            # 0044e06a
    # block 0x0044e06c: entered by fall-through of jne at 0x0044e06a, 2 instruction(s), ends with jne to 0x0044e095 (forward)
    cmp dword ptr [0x624cf0], 0x8                # 0044e06c
    jne.d8 L_0044e095                            # 0044e073
L_0044e075:
    # block 0x0044e075: entered by je at 0x0044e058; je at 0x0044e061; fall-through of jne at 0x0044e073, 7 instruction(s), ends with forward jump to 0x0044e0b3
    mov dx, word ptr [0x624cf4]                  # 0044e075
    mov word ptr [ebp - local_18], dx            # 0044e07c
    mov ax, word ptr [0x624cf6]                  # 0044e080
    mov word ptr [ebp - local_20], ax            # 0044e086
    mov ecx, dword ptr [0x624cf8]                # 0044e08a
    mov dword ptr [ebp - local_4], ecx           # 0044e090
    jmp.d8 L_0044e0b3                            # 0044e093
L_0044e095:
    # block 0x0044e095: entered by jne at 0x0044e06a; jne at 0x0044e073, 6 instruction(s), falls into the block at 0x0044e0b3
    mov dx, word ptr [0x624cfc]                  # 0044e095
    mov word ptr [ebp - local_18], dx            # 0044e09c
    mov ax, word ptr [0x624cfe]                  # 0044e0a0
    mov word ptr [ebp - local_20], ax            # 0044e0a6
    mov ecx, dword ptr [0x624d00]                # 0044e0aa
    mov dword ptr [ebp - local_4], ecx           # 0044e0b0
L_0044e0b3:
    # block 0x0044e0b3: entered by jmp at 0x0044e093, 9 instruction(s), calls FUN_0044d9b5, ends with je to 0x0044e104 (forward)
    lea edx, [ebp - local_14]                    # 0044e0b3
    push edx                                     # 0044e0b6
    mov eax, dword ptr [ebp - local_1c]          # 0044e0b7
    add eax, 0x41                                # 0044e0ba
    push eax                                     # 0044e0bd
    mov ecx, 0x624cbf                            # 0044e0be
    call FUN_0044d9b5                            # 0044e0c3
    cmp dword ptr [ebp - local_4], 0x0           # 0044e0c8
    je.d8 L_0044e104                             # 0044e0cc
    # block 0x0044e0ce: entered by fall-through of je at 0x0044e0cc, 15 instruction(s), calls FUN_004c5377, ends with forward jump to 0x0044e139
    push 0x549614                                # 0044e0ce
    lea ecx, [ebp - local_14]                    # 0044e0d3
    push ecx                                     # 0044e0d6
    mov edx, dword ptr [ebp - local_1c]          # 0044e0d7
    add edx, 0x1c1                               # 0044e0da
    push edx                                     # 0044e0e0
    mov eax, dword ptr [0x5cf665]                # 0044e0e1
    push eax                                     # 0044e0e6
    movsx ecx, word ptr [0x624cdb]               # 0044e0e7
    imul ecx, ecx, 0x4a                          # 0044e0ee
    mov edx, dword ptr [ecx + 0x5d1599]          # 0044e0f1
    push edx                                     # 0044e0f7
    mov ecx, 0x5cf659                            # 0044e0f8
    call FUN_004c5377                            # 0044e0fd
    jmp.d8 L_0044e139                            # 0044e102
L_0044e104:
    # block 0x0044e104: entered by je at 0x0044e0cc, 14 instruction(s), calls FUN_004c5377, falls into the block at 0x0044e139
    push 0x549620                                # 0044e104
    lea eax, [ebp - local_14]                    # 0044e109
    push eax                                     # 0044e10c
    mov ecx, dword ptr [ebp - local_1c]          # 0044e10d
    add ecx, 0x1d1                               # 0044e110
    push ecx                                     # 0044e116
    mov edx, dword ptr [0x5cf665]                # 0044e117
    push edx                                     # 0044e11d
    movsx eax, word ptr [0x624cdb]               # 0044e11e
    imul eax, eax, 0x4a                          # 0044e125
    mov ecx, dword ptr [eax + 0x5d1599]          # 0044e128
    push ecx                                     # 0044e12e
    mov ecx, 0x5cf659                            # 0044e12f
    call FUN_004c5377                            # 0044e134
L_0044e139:
    # block 0x0044e139: entered by jmp at 0x0044e102, 9 instruction(s), calls FUN_0044d9b5, ends with je to 0x0044e174 (forward)
    lea edx, [ebp - local_14]                    # 0044e139
    push edx                                     # 0044e13c
    mov eax, dword ptr [ebp - local_1c]          # 0044e13d
    add eax, 0xb1                                # 0044e140
    push eax                                     # 0044e145
    mov ecx, 0x624cbf                            # 0044e146
    call FUN_0044d9b5                            # 0044e14b
    cmp dword ptr [0x624cec], 0x0                # 0044e150
    je.d8 L_0044e174                             # 0044e157
    # block 0x0044e159: entered by fall-through of je at 0x0044e157, 2 instruction(s), ends with je to 0x0044e174 (forward)
    cmp dword ptr [0x624cec], 0x8                # 0044e159
    je.d8 L_0044e174                             # 0044e160
    # block 0x0044e162: entered by fall-through of je at 0x0044e160, 2 instruction(s), ends with jne to 0x0044e1aa (forward)
    cmp dword ptr [0x624cec], 0x2                # 0044e162
    jne.d8 L_0044e1aa                            # 0044e169
    # block 0x0044e16b: entered by fall-through of jne at 0x0044e169, 2 instruction(s), ends with jne to 0x0044e1aa (forward)
    cmp dword ptr [0x624cf0], 0x8                # 0044e16b
    jne.d8 L_0044e1aa                            # 0044e172
L_0044e174:
    # block 0x0044e174: entered by je at 0x0044e157; je at 0x0044e160; fall-through of jne at 0x0044e172, 15 instruction(s), calls FUN_004c5377, ends with forward jump to 0x0044e1df
    push 0x54962c                                # 0044e174
    lea ecx, [ebp - local_14]                    # 0044e179
    push ecx                                     # 0044e17c
    mov edx, dword ptr [ebp - local_1c]          # 0044e17d
    add edx, 0x241                               # 0044e180
    push edx                                     # 0044e186
    mov eax, dword ptr [0x5cf665]                # 0044e187
    push eax                                     # 0044e18c
    movsx ecx, word ptr [0x624cdb]               # 0044e18d
    imul ecx, ecx, 0x4a                          # 0044e194
    mov edx, dword ptr [ecx + 0x5d1599]          # 0044e197
    push edx                                     # 0044e19d
    mov ecx, 0x5cf659                            # 0044e19e
    call FUN_004c5377                            # 0044e1a3
    jmp.d8 L_0044e1df                            # 0044e1a8
L_0044e1aa:
    # block 0x0044e1aa: entered by jne at 0x0044e169; jne at 0x0044e172, 14 instruction(s), calls FUN_004c5377, falls into the block at 0x0044e1df
    push 0x549644                                # 0044e1aa
    lea eax, [ebp - local_14]                    # 0044e1af
    push eax                                     # 0044e1b2
    mov ecx, dword ptr [ebp - local_1c]          # 0044e1b3
    add ecx, 0x251                               # 0044e1b6
    push ecx                                     # 0044e1bc
    mov edx, dword ptr [0x5cf665]                # 0044e1bd
    push edx                                     # 0044e1c3
    movsx eax, word ptr [0x624cdb]               # 0044e1c4
    imul eax, eax, 0x4a                          # 0044e1cb
    mov ecx, dword ptr [eax + 0x5d1599]          # 0044e1ce
    push ecx                                     # 0044e1d4
    mov ecx, 0x5cf659                            # 0044e1d5
    call FUN_004c5377                            # 0044e1da
L_0044e1df:
    # block 0x0044e1df: entered by jmp at 0x0044e1a8, 48 instruction(s), calls FUN_0044d9b5, FUN_004c5377, ends with jne to 0x0044e488 (forward)
    lea edx, [ebp - local_14]                    # 0044e1df
    push edx                                     # 0044e1e2
    mov eax, dword ptr [ebp - local_1c]          # 0044e1e3
    add eax, 0x31                                # 0044e1e6
    push eax                                     # 0044e1e9
    mov ecx, 0x624cbf                            # 0044e1ea
    call FUN_0044d9b5                            # 0044e1ef
    push 0x549660                                # 0044e1f4
    lea ecx, [ebp - local_14]                    # 0044e1f9
    push ecx                                     # 0044e1fc
    movsx edx, word ptr [ebp - local_18]         # 0044e1fd
    shl edx, 0x4                                 # 0044e201
    mov eax, dword ptr [ebp - local_1c]          # 0044e204
    lea ecx, [eax + edx + field_101]             # 0044e207
    push ecx                                     # 0044e20e
    mov edx, dword ptr [0x5cf665]                # 0044e20f
    push edx                                     # 0044e215
    movsx eax, word ptr [0x624cdb]               # 0044e216
    imul eax, eax, 0x4a                          # 0044e21d
    mov ecx, dword ptr [eax + 0x5d1599]          # 0044e220
    push ecx                                     # 0044e226
    mov ecx, 0x5cf659                            # 0044e227
    call FUN_004c5377                            # 0044e22c
    lea edx, [ebp - local_14]                    # 0044e231
    push edx                                     # 0044e234
    mov eax, dword ptr [ebp - local_1c]          # 0044e235
    add eax, 0x21                                # 0044e238
    push eax                                     # 0044e23b
    mov ecx, 0x624cbf                            # 0044e23c
    call FUN_0044d9b5                            # 0044e241
    push 0x54967c                                # 0044e246
    lea ecx, [ebp - local_14]                    # 0044e24b
    push ecx                                     # 0044e24e
    movsx edx, word ptr [ebp - local_20]         # 0044e24f
    shl edx, 0x4                                 # 0044e253
    mov eax, dword ptr [ebp - local_1c]          # 0044e256
    lea ecx, [eax + edx + field_c1]              # 0044e259
    push ecx                                     # 0044e260
    mov edx, dword ptr [0x5cf665]                # 0044e261
    push edx                                     # 0044e267
    movsx eax, word ptr [0x624cdb]               # 0044e268
    imul eax, eax, 0x4a                          # 0044e26f
    mov ecx, dword ptr [eax + 0x5d1599]          # 0044e272
    push ecx                                     # 0044e278
    mov ecx, 0x5cf659                            # 0044e279
    call FUN_004c5377                            # 0044e27e
    cmp dword ptr [0x624cec], 0x2                # 0044e283
    jne.d32 L_0044e488                           # 0044e28a
    # block 0x0044e290: entered by fall-through of jne at 0x0044e28a, 4 instruction(s), ends with ja to 0x0044e483 (forward)
    mov edx, dword ptr [0x624cf0]                # 0044e290
    mov dword ptr [ebp - local_24], edx          # 0044e296
    cmp dword ptr [ebp - local_24], 0x8          # 0044e299
    ja.d32 L_0044e483                            # 0044e29d
    # block 0x0044e2a3: entered by fall-through of ja at 0x0044e29d, 2 instruction(s), ends with indirect jump dword ptr [4*eax + 0x44e624]
    mov eax, dword ptr [ebp - local_24]          # 0044e2a3
    jmp dword ptr [4*eax + SWTAB_0044e624_VA]    # 0044e2a6
L_0044e2ad:
    # block 0x0044e2ad: entered by switch case, 22 instruction(s), calls FUN_0044d9b5, FUN_004c5377, ends with forward jump to 0x0044e483
    lea ecx, [ebp - local_14]                    # 0044e2ad
    push ecx                                     # 0044e2b0
    mov edx, dword ptr [ebp - local_1c]          # 0044e2b1
    add edx, 0x81                                # 0044e2b4
    push edx                                     # 0044e2ba
    mov ecx, 0x624cbf                            # 0044e2bb
    call FUN_0044d9b5                            # 0044e2c0
    push 0x54969c                                # 0044e2c5
    lea eax, [ebp - local_14]                    # 0044e2ca
    push eax                                     # 0044e2cd
    mov ecx, dword ptr [ebp - local_1c]          # 0044e2ce
    add ecx, 0x211                               # 0044e2d1
    push ecx                                     # 0044e2d7
    mov edx, dword ptr [0x5cf665]                # 0044e2d8
    push edx                                     # 0044e2de
    movsx eax, word ptr [0x624cdb]               # 0044e2df
    imul eax, eax, 0x4a                          # 0044e2e6
    mov ecx, dword ptr [eax + 0x5d1599]          # 0044e2e9
    push ecx                                     # 0044e2ef
    mov ecx, 0x5cf659                            # 0044e2f0
    call FUN_004c5377                            # 0044e2f5
    jmp.d32 L_0044e483                           # 0044e2fa
L_0044e2ff:
    # block 0x0044e2ff: entered by switch case, 22 instruction(s), calls FUN_0044d9b5, FUN_004c5377, ends with forward jump to 0x0044e483
    lea edx, [ebp - local_14]                    # 0044e2ff
    push edx                                     # 0044e302
    mov eax, dword ptr [ebp - local_1c]          # 0044e303
    add eax, 0x61                                # 0044e306
    push eax                                     # 0044e309
    mov ecx, 0x624cbf                            # 0044e30a
    call FUN_0044d9b5                            # 0044e30f
    push 0x5496b0                                # 0044e314
    lea ecx, [ebp - local_14]                    # 0044e319
    push ecx                                     # 0044e31c
    mov edx, dword ptr [ebp - local_1c]          # 0044e31d
    add edx, 0x1f1                               # 0044e320
    push edx                                     # 0044e326
    mov eax, dword ptr [0x5cf665]                # 0044e327
    push eax                                     # 0044e32c
    movsx ecx, word ptr [0x624cdb]               # 0044e32d
    imul ecx, ecx, 0x4a                          # 0044e334
    mov edx, dword ptr [ecx + 0x5d1599]          # 0044e337
    push edx                                     # 0044e33d
    mov ecx, 0x5cf659                            # 0044e33e
    call FUN_004c5377                            # 0044e343
    jmp.d32 L_0044e483                           # 0044e348
L_0044e34d:
    # block 0x0044e34d: entered by switch case, 22 instruction(s), calls FUN_0044d9b5, FUN_004c5377, ends with forward jump to 0x0044e483
    lea eax, [ebp - local_14]                    # 0044e34d
    push eax                                     # 0044e350
    mov ecx, dword ptr [ebp - local_1c]          # 0044e351
    add ecx, 0x51                                # 0044e354
    push ecx                                     # 0044e357
    mov ecx, 0x624cbf                            # 0044e358
    call FUN_0044d9b5                            # 0044e35d
    push 0x5496c8                                # 0044e362
    lea edx, [ebp - local_14]                    # 0044e367
    push edx                                     # 0044e36a
    mov eax, dword ptr [ebp - local_1c]          # 0044e36b
    add eax, 0x1e1                               # 0044e36e
    push eax                                     # 0044e373
    mov ecx, dword ptr [0x5cf665]                # 0044e374
    push ecx                                     # 0044e37a
    movsx edx, word ptr [0x624cdb]               # 0044e37b
    imul edx, edx, 0x4a                          # 0044e382
    mov eax, dword ptr [edx + 0x5d1599]          # 0044e385
    push eax                                     # 0044e38b
    mov ecx, 0x5cf659                            # 0044e38c
    call FUN_004c5377                            # 0044e391
    jmp.d32 L_0044e483                           # 0044e396
L_0044e39b:
    # block 0x0044e39b: entered by switch case, 22 instruction(s), calls FUN_0044d9b5, FUN_004c5377, ends with forward jump to 0x0044e483
    lea ecx, [ebp - local_14]                    # 0044e39b
    push ecx                                     # 0044e39e
    mov edx, dword ptr [ebp - local_1c]          # 0044e39f
    add edx, 0x71                                # 0044e3a2
    push edx                                     # 0044e3a5
    mov ecx, 0x624cbf                            # 0044e3a6
    call FUN_0044d9b5                            # 0044e3ab
    push 0x5496e0                                # 0044e3b0
    lea eax, [ebp - local_14]                    # 0044e3b5
    push eax                                     # 0044e3b8
    mov ecx, dword ptr [ebp - local_1c]          # 0044e3b9
    add ecx, 0x201                               # 0044e3bc
    push ecx                                     # 0044e3c2
    mov edx, dword ptr [0x5cf665]                # 0044e3c3
    push edx                                     # 0044e3c9
    movsx eax, word ptr [0x624cdb]               # 0044e3ca
    imul eax, eax, 0x4a                          # 0044e3d1
    mov ecx, dword ptr [eax + 0x5d1599]          # 0044e3d4
    push ecx                                     # 0044e3da
    mov ecx, 0x5cf659                            # 0044e3db
    call FUN_004c5377                            # 0044e3e0
    jmp.d32 L_0044e483                           # 0044e3e5
L_0044e3ea:
    # block 0x0044e3ea: entered by switch case, 22 instruction(s), calls FUN_0044d9b5, FUN_004c5377, ends with forward jump to 0x0044e483
    lea edx, [ebp - local_14]                    # 0044e3ea
    push edx                                     # 0044e3ed
    mov eax, dword ptr [ebp - local_1c]          # 0044e3ee
    add eax, 0x91                                # 0044e3f1
    push eax                                     # 0044e3f6
    mov ecx, 0x624cbf                            # 0044e3f7
    call FUN_0044d9b5                            # 0044e3fc
    push 0x5496f8                                # 0044e401
    lea ecx, [ebp - local_14]                    # 0044e406
    push ecx                                     # 0044e409
    mov edx, dword ptr [ebp - local_1c]          # 0044e40a
    add edx, 0x221                               # 0044e40d
    push edx                                     # 0044e413
    mov eax, dword ptr [0x5cf665]                # 0044e414
    push eax                                     # 0044e419
    movsx ecx, word ptr [0x624cdb]               # 0044e41a
    imul ecx, ecx, 0x4a                          # 0044e421
    mov edx, dword ptr [ecx + 0x5d1599]          # 0044e424
    push edx                                     # 0044e42a
    mov ecx, 0x5cf659                            # 0044e42b
    call FUN_004c5377                            # 0044e430
    jmp.d8 L_0044e483                            # 0044e435
L_0044e437:
    # block 0x0044e437: entered by switch case, 21 instruction(s), calls FUN_0044d9b5, FUN_004c5377, falls into the block at 0x0044e483
    lea eax, [ebp - local_14]                    # 0044e437
    push eax                                     # 0044e43a
    mov ecx, dword ptr [ebp - local_1c]          # 0044e43b
    add ecx, 0xa1                                # 0044e43e
    push ecx                                     # 0044e444
    mov ecx, 0x624cbf                            # 0044e445
    call FUN_0044d9b5                            # 0044e44a
    push 0x549714                                # 0044e44f
    lea edx, [ebp - local_14]                    # 0044e454
    push edx                                     # 0044e457
    mov eax, dword ptr [ebp - local_1c]          # 0044e458
    add eax, 0x231                               # 0044e45b
    push eax                                     # 0044e460
    mov ecx, dword ptr [0x5cf665]                # 0044e461
    push ecx                                     # 0044e467
    movsx edx, word ptr [0x624cdb]               # 0044e468
    imul edx, edx, 0x4a                          # 0044e46f
    mov eax, dword ptr [edx + 0x5d1599]          # 0044e472
    push eax                                     # 0044e478
    mov ecx, 0x5cf659                            # 0044e479
    call FUN_004c5377                            # 0044e47e
L_0044e483:
    # block 0x0044e483: entered by ja at 0x0044e29d; jmp at 0x0044e2fa; jmp at 0x0044e348; jmp at 0x0044e396; more, 1 instruction(s), ends with forward jump to 0x0044e619
    jmp.d32 L_0044e619                           # 0044e483
L_0044e488:
    # block 0x0044e488: entered by jne at 0x0044e28a, 2 instruction(s), ends with je to 0x0044e619 (forward)
    cmp dword ptr [0x624d04], 0x0                # 0044e488
    je.d32 L_0044e619                            # 0044e48f
    # block 0x0044e495: entered by fall-through of je at 0x0044e48f, 115 instruction(s), calls FUN_0044d9b5, FUN_004c5377, falls into the block at 0x0044e619
    lea ecx, [ebp - local_14]                    # 0044e495
    push ecx                                     # 0044e498
    mov edx, dword ptr [ebp - local_1c]          # 0044e499
    add edx, 0x81                                # 0044e49c
    push edx                                     # 0044e4a2
    mov ecx, 0x624cbf                            # 0044e4a3
    call FUN_0044d9b5                            # 0044e4a8
    push 0x549730                                # 0044e4ad
    lea eax, [ebp - local_14]                    # 0044e4b2
    push eax                                     # 0044e4b5
    mov ecx, dword ptr [ebp - local_1c]          # 0044e4b6
    add ecx, 0x81                                # 0044e4b9
    push ecx                                     # 0044e4bf
    mov edx, dword ptr [0x5cf665]                # 0044e4c0
    push edx                                     # 0044e4c6
    mov eax, dword ptr [0x5d15e3]                # 0044e4c7
    push eax                                     # 0044e4cc
    mov ecx, 0x5cf659                            # 0044e4cd
    call FUN_004c5377                            # 0044e4d2
    lea ecx, [ebp - local_14]                    # 0044e4d7
    push ecx                                     # 0044e4da
    mov edx, dword ptr [ebp - local_1c]          # 0044e4db
    add edx, 0x61                                # 0044e4de
    push edx                                     # 0044e4e1
    mov ecx, 0x624cbf                            # 0044e4e2
    call FUN_0044d9b5                            # 0044e4e7
    push 0x54973c                                # 0044e4ec
    lea eax, [ebp - local_14]                    # 0044e4f1
    push eax                                     # 0044e4f4
    mov ecx, dword ptr [ebp - local_1c]          # 0044e4f5
    add ecx, 0x61                                # 0044e4f8
    push ecx                                     # 0044e4fb
    mov edx, dword ptr [0x5cf665]                # 0044e4fc
    push edx                                     # 0044e502
    mov eax, dword ptr [0x5d15e3]                # 0044e503
    push eax                                     # 0044e508
    mov ecx, 0x5cf659                            # 0044e509
    call FUN_004c5377                            # 0044e50e
    lea ecx, [ebp - local_14]                    # 0044e513
    push ecx                                     # 0044e516
    mov edx, dword ptr [ebp - local_1c]          # 0044e517
    add edx, 0x51                                # 0044e51a
    push edx                                     # 0044e51d
    mov ecx, 0x624cbf                            # 0044e51e
    call FUN_0044d9b5                            # 0044e523
    push 0x54974c                                # 0044e528
    lea eax, [ebp - local_14]                    # 0044e52d
    push eax                                     # 0044e530
    mov ecx, dword ptr [ebp - local_1c]          # 0044e531
    add ecx, 0x51                                # 0044e534
    push ecx                                     # 0044e537
    mov edx, dword ptr [0x5cf665]                # 0044e538
    push edx                                     # 0044e53e
    mov eax, dword ptr [0x5d15e3]                # 0044e53f
    push eax                                     # 0044e544
    mov ecx, 0x5cf659                            # 0044e545
    call FUN_004c5377                            # 0044e54a
    lea ecx, [ebp - local_14]                    # 0044e54f
    push ecx                                     # 0044e552
    mov edx, dword ptr [ebp - local_1c]          # 0044e553
    add edx, 0x71                                # 0044e556
    push edx                                     # 0044e559
    mov ecx, 0x624cbf                            # 0044e55a
    call FUN_0044d9b5                            # 0044e55f
    push 0x54975c                                # 0044e564
    lea eax, [ebp - local_14]                    # 0044e569
    push eax                                     # 0044e56c
    mov ecx, dword ptr [ebp - local_1c]          # 0044e56d
    add ecx, 0x71                                # 0044e570
    push ecx                                     # 0044e573
    mov edx, dword ptr [0x5cf665]                # 0044e574
    push edx                                     # 0044e57a
    mov eax, dword ptr [0x5d15e3]                # 0044e57b
    push eax                                     # 0044e580
    mov ecx, 0x5cf659                            # 0044e581
    call FUN_004c5377                            # 0044e586
    lea ecx, [ebp - local_14]                    # 0044e58b
    push ecx                                     # 0044e58e
    mov edx, dword ptr [ebp - local_1c]          # 0044e58f
    add edx, 0x91                                # 0044e592
    push edx                                     # 0044e598
    mov ecx, 0x624cbf                            # 0044e599
    call FUN_0044d9b5                            # 0044e59e
    push 0x54976c                                # 0044e5a3
    lea eax, [ebp - local_14]                    # 0044e5a8
    push eax                                     # 0044e5ab
    mov ecx, dword ptr [ebp - local_1c]          # 0044e5ac
    add ecx, 0x91                                # 0044e5af
    push ecx                                     # 0044e5b5
    mov edx, dword ptr [0x5cf665]                # 0044e5b6
    push edx                                     # 0044e5bc
    mov eax, dword ptr [0x5d15e3]                # 0044e5bd
    push eax                                     # 0044e5c2
    mov ecx, 0x5cf659                            # 0044e5c3
    call FUN_004c5377                            # 0044e5c8
    lea ecx, [ebp - local_14]                    # 0044e5cd
    push ecx                                     # 0044e5d0
    mov edx, dword ptr [ebp - local_1c]          # 0044e5d1
    add edx, 0xa1                                # 0044e5d4
    push edx                                     # 0044e5da
    mov ecx, 0x624cbf                            # 0044e5db
    call FUN_0044d9b5                            # 0044e5e0
    push 0x549780                                # 0044e5e5
    lea eax, [ebp - local_14]                    # 0044e5ea
    push eax                                     # 0044e5ed
    mov ecx, dword ptr [ebp - local_1c]          # 0044e5ee
    add ecx, 0xa1                                # 0044e5f1
    push ecx                                     # 0044e5f7
    mov edx, dword ptr [0x5cf665]                # 0044e5f8
    push edx                                     # 0044e5fe
    mov eax, dword ptr [0x5d15e3]                # 0044e5ff
    push eax                                     # 0044e604
    mov ecx, 0x5cf659                            # 0044e605
    call FUN_004c5377                            # 0044e60a
    mov dword ptr [0x624d04], 0x0                # 0044e60f
L_0044e619:
    # block 0x0044e619: entered by jmp at 0x0044e483; je at 0x0044e48f, 4 instruction(s), ends with ret
    mov byte ptr [0x624ce3], 0x0                 # 0044e619
    {load} mov esp, ebp                          # 0044e620
    pop ebp                                      # 0044e622
    ret                                          # 0044e623

# --- data items (not part of the function) -------------------------
.org 0x0044e624 - 0x401000
SWTAB_0044e624:  # 9 case address(es)
    .long L_0044e34d - .text + 0x401000
    .long L_0044e2ff - .text + 0x401000
    .long L_0044e483 - .text + 0x401000
    .long L_0044e3ea - .text + 0x401000
    .long L_0044e437 - .text + 0x401000
    .long L_0044e483 - .text + 0x401000
    .long L_0044e39b - .text + 0x401000
    .long L_0044e483 - .text + 0x401000
    .long L_0044e2ad - .text + 0x401000
.org 0x0044e648 - 0x401000
PAD_0044e648:  # 8 byte(s) of int3 padding
    .fill 8, 1, 0xcc
.set SWTAB_0044e624_VA, SWTAB_0044e624 - .text + 0x401000

