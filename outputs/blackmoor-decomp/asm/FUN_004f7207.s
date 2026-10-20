# FUN_004f7207
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f7207
# extent:       0x004f7207-0x004f79ce (1991 code bytes)
# span:         0x004f7207-0x004f79ce (code 1991, tables 0, padding 0)
# sha256:       f8d391aa286f2c34c186a20eac22b4d439cd8b44e92a0f425c0a3a126d25ef34
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_sound_delayed_repeat_pass
# naming:       INFERRED (lower confidence, not verified): the repository text src/live_audio.c:1243 says "The 0x4f7207 delayed-repeat pass for one channel"
# name-note:    Delayed-repeat pass for one channel, restarting a channel armed by the flag-0x10 branch once its due tick has passed.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       19 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_40, local_44, local_48, local_4c and 7 more
# fields:       [eax + n] field_40, field_44, field_48, field_4c, field_54, field_58, field_60, field_64, field_68, field_6c, field_84, field_8c and 10 more; [ecx + n] field_38, field_44, field_48, field_4c, field_50, field_54, field_58, field_5c, field_64, field_68, field_7c, field_88 and 6 more; [edx + n] field_4, field_8, field_3c, field_40, field_44, field_50, field_58, field_60, field_64, field_74, field_84, field_8c and 4 more
# callees:      calls KERNEL32.dll!GetTickCount, FUN_004f6059, FUN_0050ca3e, FUN_0044a2b7, FUN_004f8f94, FUN_004f9040, FUN_004fa127, FUN_0050df94, FUN_004f61e7, FUN_004ccacf, FUN_004ccb50, FUN_004ccbd0, FUN_004ccc81
# track-n:      outputs/blackmoor-decomp/src/live_audio.c:live_audio_set_channel_flags (function ledger class candidate_port; also run_repeat_pass; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 569 instruction(s), 29 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
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
.equ local_20, 0x20  # offset -0x20
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ local_4c, 0x4c  # offset -0x4c
.equ local_50, 0x50  # offset -0x50
.equ local_54, 0x54  # offset -0x54
.equ local_58, 0x58  # offset -0x58
.equ local_5c, 0x5c  # offset -0x5c
.equ local_60, 0x60  # offset -0x60
.equ local_64, 0x64  # offset -0x64
.equ local_68, 0x68  # offset -0x68
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_38, 0x38  # offset +0x38
.equ field_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_44, 0x44  # offset +0x44
.equ field_48, 0x48  # offset +0x48
.equ field_4c, 0x4c  # offset +0x4c
.equ field_50, 0x50  # offset +0x50
.equ field_54, 0x54  # offset +0x54
.equ field_58, 0x58  # offset +0x58
.equ field_5c, 0x5c  # offset +0x5c
.equ field_60, 0x60  # offset +0x60
.equ field_64, 0x64  # offset +0x64
.equ field_68, 0x68  # offset +0x68
.equ field_6c, 0x6c  # offset +0x6c
.equ field_74, 0x74  # offset +0x74
.equ field_7c, 0x7c  # offset +0x7c
.equ field_84, 0x84  # offset +0x84
.equ field_88, 0x88  # offset +0x88
.equ field_8c, 0x8c  # offset +0x8c
.equ field_90, 0x90  # offset +0x90
.equ field_12c, 0x12c  # offset +0x12c
.equ field_130, 0x130  # offset +0x130
.equ field_162, 0x162  # offset +0x162
.equ field_16e, 0x16e  # offset +0x16e
.equ field_172, 0x172  # offset +0x172
.equ field_287, 0x287  # offset +0x287
.equ field_2a3, 0x2a3  # offset +0x2a3
.equ field_2a7, 0x2a7  # offset +0x2a7
.equ field_2ab, 0x2ab  # offset +0x2ab
.equ field_3c2, 0x3c2  # offset +0x3c2
.equ field_3ce, 0x3ce  # offset +0x3ce

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004ccacf, .text + (0x004ccacf - 0x401000)
.set FUN_004ccb50, .text + (0x004ccb50 - 0x401000)
.set FUN_004ccbd0, .text + (0x004ccbd0 - 0x401000)
.set FUN_004ccc81, .text + (0x004ccc81 - 0x401000)
.set FUN_004f6059, .text + (0x004f6059 - 0x401000)
.set FUN_004f61e7, .text + (0x004f61e7 - 0x401000)
.set FUN_004f8f94, .text + (0x004f8f94 - 0x401000)
.set FUN_004f9040, .text + (0x004f9040 - 0x401000)
.set FUN_004fa127, .text + (0x004fa127 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050df94, .text + (0x0050df94 - 0x401000)

.org 0x004f7207 - 0x401000
.globl FUN_004f7207
FUN_004f7207:
    # block 0x004f7207: entry, 12 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x004f723a
    push ebp                                     # 004f7207
    {load} mov ebp, esp                          # 004f7208
    sub esp, 0x68                                # 004f720a
    push esi                                     # 004f720d
    push edi                                     # 004f720e
    mov dword ptr [ebp - local_44], ecx          # 004f720f
    call dword ptr [0x52a23c]                    # 004f7212
    mov dword ptr [ebp - local_1c], eax          # 004f7218
    mov eax, dword ptr [ebp - local_44]          # 004f721b
    mov dword ptr [eax + field_3c2], 0x3e8       # 004f721e
    mov dword ptr [ebp - local_8], 0x0           # 004f7228
    jmp.d8 L_004f723a                            # 004f722f
L_004f7231:
    # block 0x004f7231: entered by jmp at 0x004f7297; jmp at 0x004f79c3, 3 instruction(s), falls into the block at 0x004f723a
    mov ecx, dword ptr [ebp - local_8]           # 004f7231
    add ecx, 0x1                                 # 004f7234
    mov dword ptr [ebp - local_8], ecx           # 004f7237
L_004f723a:
    # block 0x004f723a: entered by jmp at 0x004f722f, 2 instruction(s), ends with jge to 0x004f79c8 (forward)
    cmp dword ptr [ebp - local_8], 0x20          # 004f723a
    jge.d32 L_004f79c8                           # 004f723e
    # block 0x004f7244: entered by fall-through of jge at 0x004f723e, 12 instruction(s), ends with je to 0x004f7297 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004f7244
    imul edx, edx, 0x5bb                         # 004f7247
    mov eax, dword ptr [ebp - local_44]          # 004f724d
    mov ecx, dword ptr [eax + field_3ce]         # 004f7250
    {load} add ecx, edx                          # 004f7256
    mov dword ptr [ebp - local_20], ecx          # 004f7258
    mov edx, dword ptr [ebp - local_20]          # 004f725b
    add edx, 0x19e                               # 004f725e
    mov dword ptr [ebp - local_4], edx           # 004f7264
    mov eax, dword ptr [ebp - local_20]          # 004f7267
    cmp dword ptr [eax + field_162], 0x0         # 004f726a
    je.d8 L_004f7297                             # 004f7271
    # block 0x004f7273: entered by fall-through of je at 0x004f7271, 3 instruction(s), ends with jne to 0x004f7297 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 004f7273
    cmp dword ptr [ecx + field_287], 0x0         # 004f7276
    jne.d8 L_004f7297                            # 004f727d
    # block 0x004f727f: entered by fall-through of jne at 0x004f727d, 3 instruction(s), ends with jne to 0x004f7297 (forward)
    mov edx, dword ptr [ebp - local_20]          # 004f727f
    cmp dword ptr [edx + field_16e], 0x0         # 004f7282
    jne.d8 L_004f7297                            # 004f7289
    # block 0x004f728b: entered by fall-through of jne at 0x004f7289, 3 instruction(s), ends with je to 0x004f7299 (forward)
    mov eax, dword ptr [ebp - local_20]          # 004f728b
    cmp dword ptr [eax + field_172], 0x0         # 004f728e
    je.d8 L_004f7299                             # 004f7295
L_004f7297:
    # block 0x004f7297: entered by je at 0x004f7271; jne at 0x004f727d; jne at 0x004f7289; fall-through of je at 0x004f7295, 1 instruction(s), ends with backward jump to 0x004f7231
    jmp.d8 L_004f7231                            # 004f7297
L_004f7299:
    # block 0x004f7299: entered by je at 0x004f7295, 3 instruction(s), ends with je to 0x004f72fb (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f7299
    cmp dword ptr [ecx], 0x0                     # 004f729c
    je.d8 L_004f72fb                             # 004f729f
    # block 0x004f72a1: entered by fall-through of je at 0x004f729f, 4 instruction(s), ends with jbe to 0x004f72f6 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f72a1
    mov eax, dword ptr [ebp - local_1c]          # 004f72a4
    cmp eax, dword ptr [edx + field_8]           # 004f72a7
    jbe.d8 L_004f72f6                            # 004f72aa
    # block 0x004f72ac: entered by fall-through of jbe at 0x004f72aa, 9 instruction(s), calls FUN_004f6059, ends with je to 0x004f72f6 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f72ac
    mov dword ptr [ecx], 0x0                     # 004f72af
    mov edx, dword ptr [ebp - local_8]           # 004f72b5
    push edx                                     # 004f72b8
    mov ecx, dword ptr [ebp - local_44]          # 004f72b9
    call FUN_004f6059                            # 004f72bc
    movsx eax, word ptr [0x63a4cd]               # 004f72c1
    test eax, eax                                # 004f72c8
    je.d8 L_004f72f6                             # 004f72ca
    # block 0x004f72cc: entered by fall-through of je at 0x004f72ca, 12 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f72f6
    mov ecx, dword ptr [ebp - local_8]           # 004f72cc
    push ecx                                     # 004f72cf
    mov edx, dword ptr [ebp - local_4]           # 004f72d0
    mov eax, dword ptr [edx + field_4]           # 004f72d3
    push eax                                     # 004f72d6
    push 0x55e9f8                                # 004f72d7
    push 0x63888b                                # 004f72dc
    call FUN_0050ca3e                            # 004f72e1
    add esp, 0x10                                # 004f72e6
    push 0x63888b                                # 004f72e9
    call FUN_0044a2b7                            # 004f72ee
    add esp, 0x4                                 # 004f72f3
L_004f72f6:
    # block 0x004f72f6: entered by jbe at 0x004f72aa; je at 0x004f72ca, 1 instruction(s), ends with forward jump to 0x004f79c3
    jmp.d32 L_004f79c3                           # 004f72f6
L_004f72fb:
    # block 0x004f72fb: entered by je at 0x004f729f, 5 instruction(s), ends with je to 0x004f7327 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 004f72fb
    {load} xor edx, edx                          # 004f72fe
    mov dx, word ptr [ecx + field_12c]           # 004f7300
    cmp edx, 0x100                               # 004f7307
    je.d8 L_004f7327                             # 004f730d
    # block 0x004f730f: entered by fall-through of je at 0x004f730d, 5 instruction(s), ends with jne to 0x004f7733 (forward)
    mov eax, dword ptr [ebp - local_20]          # 004f730f
    {load} xor ecx, ecx                          # 004f7312
    mov cx, word ptr [eax + field_12c]           # 004f7314
    cmp ecx, 0x500                               # 004f731b
    jne.d32 L_004f7733                           # 004f7321
L_004f7327:
    # block 0x004f7327: entered by je at 0x004f730d; fall-through of jne at 0x004f7321, 4 instruction(s), ends with jbe to 0x004f772e (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f7327
    mov eax, dword ptr [ebp - local_1c]          # 004f732a
    cmp eax, dword ptr [edx + field_40]          # 004f732d
    jbe.d32 L_004f772e                           # 004f7330
    # block 0x004f7336: entered by fall-through of jbe at 0x004f7330, 15 instruction(s), ends with je to 0x004f74ab (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f7336
    mov edx, dword ptr [ebp - local_1c]          # 004f7339
    add edx, dword ptr [ecx + field_38]          # 004f733c
    mov eax, dword ptr [ebp - local_4]           # 004f733f
    mov dword ptr [eax + field_40], edx          # 004f7342
    mov ecx, dword ptr [ebp - local_4]           # 004f7345
    fld dword ptr [ecx + field_54]               # 004f7348
    fadd dword ptr [0x52cbf4]                    # 004f734b
    mov edx, dword ptr [ebp - local_4]           # 004f7351
    fild dword ptr [edx + field_3c]              # 004f7354
    fstp dword ptr [ebp - local_48]              # 004f7357
    fcomp dword ptr [ebp - local_48]             # 004f735a
    fnstsw ax                                    # 004f735d
    test ah, 0x1                                 # 004f735f
    je.d32 L_004f74ab                            # 004f7362
    # block 0x004f7368: entered by fall-through of je at 0x004f7362, 37 instruction(s), calls FUN_004f8f94, FUN_004f9040, ends with je to 0x004f74a6 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f7368
    fld dword ptr [eax + field_54]               # 004f736b
    fadd dword ptr [0x52cbf4]                    # 004f736e
    mov ecx, dword ptr [ebp - local_4]           # 004f7374
    fstp dword ptr [ecx + field_54]              # 004f7377
    mov edx, dword ptr [ebp - local_20]          # 004f737a
    mov eax, dword ptr [ebp - local_4]           # 004f737d
    fld dword ptr [edx + field_2a3]              # 004f7380
    fadd dword ptr [eax + field_44]              # 004f7386
    mov ecx, dword ptr [ebp - local_20]          # 004f7389
    fstp dword ptr [ecx + field_2a3]             # 004f738c
    mov edx, dword ptr [ebp - local_20]          # 004f7392
    mov eax, dword ptr [ebp - local_4]           # 004f7395
    fld dword ptr [edx + field_2a7]              # 004f7398
    fadd dword ptr [eax + field_48]              # 004f739e
    mov ecx, dword ptr [ebp - local_20]          # 004f73a1
    fstp dword ptr [ecx + field_2a7]             # 004f73a4
    mov edx, dword ptr [ebp - local_20]          # 004f73aa
    mov eax, dword ptr [ebp - local_4]           # 004f73ad
    fld dword ptr [edx + field_2ab]              # 004f73b0
    fadd dword ptr [eax + field_4c]              # 004f73b6
    mov ecx, dword ptr [ebp - local_20]          # 004f73b9
    fstp dword ptr [ecx + field_2ab]             # 004f73bc
    mov edx, dword ptr [ebp - local_8]           # 004f73c2
    push edx                                     # 004f73c5
    mov ecx, dword ptr [ebp - local_44]          # 004f73c6
    call FUN_004f8f94                            # 004f73c9
    mov eax, dword ptr [ebp - local_20]          # 004f73ce
    add eax, 0x2a3                               # 004f73d1
    push eax                                     # 004f73d6
    mov ecx, dword ptr [ebp - local_8]           # 004f73d7
    push ecx                                     # 004f73da
    mov ecx, dword ptr [ebp - local_44]          # 004f73db
    call FUN_004f9040                            # 004f73de
    movsx edx, word ptr [0x63a4cd]               # 004f73e3
    test edx, edx                                # 004f73ea
    je.d32 L_004f74a6                            # 004f73ec
    # block 0x004f73f2: entered by fall-through of je at 0x004f73ec, 5 instruction(s), ends with jne to 0x004f742d (forward)
    mov eax, dword ptr [ebp - local_20]          # 004f73f2
    {load} xor ecx, ecx                          # 004f73f5
    mov cx, word ptr [eax + field_12c]           # 004f73f7
    cmp ecx, 0x100                               # 004f73fe
    jne.d8 L_004f742d                            # 004f7404
    # block 0x004f7406: entered by fall-through of jne at 0x004f7404, 16 instruction(s), ends with forward jump to 0x004f7452
    mov edi, 0x55ea48                            # 004f7406
    lea edx, [ebp - local_40]                    # 004f740b
    or ecx, -0x1                                 # 004f740e
    {load} xor eax, eax                          # 004f7411
    repne scasb al, byte ptr es:[edi]            # 004f7413
    not ecx                                      # 004f7415
    {load} sub edi, ecx                          # 004f7417
    {load} mov esi, edi                          # 004f7419
    {load} mov eax, ecx                          # 004f741b
    {load} mov edi, edx                          # 004f741d
    shr ecx, 0x2                                 # 004f741f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004f7422
    {load} mov ecx, eax                          # 004f7424
    and ecx, 0x3                                 # 004f7426
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004f7429
    jmp.d8 L_004f7452                            # 004f742b
L_004f742d:
    # block 0x004f742d: entered by jne at 0x004f7404, 15 instruction(s), falls into the block at 0x004f7452
    mov edi, 0x55ea5c                            # 004f742d
    lea edx, [ebp - local_40]                    # 004f7432
    or ecx, -0x1                                 # 004f7435
    {load} xor eax, eax                          # 004f7438
    repne scasb al, byte ptr es:[edi]            # 004f743a
    not ecx                                      # 004f743c
    {load} sub edi, ecx                          # 004f743e
    {load} mov esi, edi                          # 004f7440
    {load} mov eax, ecx                          # 004f7442
    {load} mov edi, edx                          # 004f7444
    shr ecx, 0x2                                 # 004f7446
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004f7449
    {load} mov ecx, eax                          # 004f744b
    and ecx, 0x3                                 # 004f744d
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004f7450
L_004f7452:
    # block 0x004f7452: entered by jmp at 0x004f742b, 23 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f74a6
    mov ecx, dword ptr [ebp - local_20]          # 004f7452
    fld dword ptr [ecx + field_2ab]              # 004f7455
    sub esp, 0x8                                 # 004f745b
    fstp qword ptr [esp]                         # 004f745e
    mov edx, dword ptr [ebp - local_20]          # 004f7461
    fld dword ptr [edx + field_2a7]              # 004f7464
    sub esp, 0x8                                 # 004f746a
    fstp qword ptr [esp]                         # 004f746d
    mov eax, dword ptr [ebp - local_20]          # 004f7470
    fld dword ptr [eax + field_2a3]              # 004f7473
    sub esp, 0x8                                 # 004f7479
    fstp qword ptr [esp]                         # 004f747c
    mov ecx, dword ptr [ebp - local_8]           # 004f747f
    push ecx                                     # 004f7482
    lea edx, [ebp - local_40]                    # 004f7483
    push edx                                     # 004f7486
    push 0x55ea74                                # 004f7487
    push 0x63888b                                # 004f748c
    call FUN_0050ca3e                            # 004f7491
    add esp, 0x28                                # 004f7496
    push 0x63888b                                # 004f7499
    call FUN_0044a2b7                            # 004f749e
    add esp, 0x4                                 # 004f74a3
L_004f74a6:
    # block 0x004f74a6: entered by je at 0x004f73ec, 1 instruction(s), ends with forward jump to 0x004f772e
    jmp.d32 L_004f772e                           # 004f74a6
L_004f74ab:
    # block 0x004f74ab: entered by je at 0x004f7362, 3 instruction(s), ends with jne to 0x004f7722 (forward)
    mov eax, dword ptr [ebp - local_20]          # 004f74ab
    cmp dword ptr [eax + field_130], 0x0         # 004f74ae
    jne.d32 L_004f7722                           # 004f74b5
    # block 0x004f74bb: entered by fall-through of jne at 0x004f74b5, 6 instruction(s), ends with je to 0x004f74e5 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 004f74bb
    {load} xor edx, edx                          # 004f74be
    mov dx, word ptr [ecx + field_12c]           # 004f74c0
    mov dword ptr [ebp - local_4c], edx          # 004f74c7
    cmp dword ptr [ebp - local_4c], 0x100        # 004f74ca
    je.d8 L_004f74e5                             # 004f74d1
    # block 0x004f74d3: entered by fall-through of je at 0x004f74d1, 2 instruction(s), ends with je to 0x004f7572 (forward)
    cmp dword ptr [ebp - local_4c], 0x500        # 004f74d3
    je.d32 L_004f7572                            # 004f74da
    # block 0x004f74e0: entered by fall-through of je at 0x004f74da, 1 instruction(s), ends with forward jump to 0x004f76f5
    jmp.d32 L_004f76f5                           # 004f74e0
L_004f74e5:
    # block 0x004f74e5: entered by je at 0x004f74d1, 15 instruction(s), ends with je to 0x004f756d (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f74e5
    fild dword ptr [eax + field_6c]              # 004f74e8
    mov ecx, dword ptr [ebp - local_20]          # 004f74eb
    fstp dword ptr [ecx + field_2a3]             # 004f74ee
    mov edx, dword ptr [ebp - local_4]           # 004f74f4
    fild dword ptr [edx + field_74]              # 004f74f7
    mov eax, dword ptr [ebp - local_20]          # 004f74fa
    fstp dword ptr [eax + field_2a7]             # 004f74fd
    mov ecx, dword ptr [ebp - local_4]           # 004f7503
    fild dword ptr [ecx + field_7c]              # 004f7506
    mov edx, dword ptr [ebp - local_20]          # 004f7509
    fstp dword ptr [edx + field_2ab]             # 004f750c
    movsx eax, word ptr [0x63a4cd]               # 004f7512
    test eax, eax                                # 004f7519
    je.d8 L_004f756d                             # 004f751b
    # block 0x004f751d: entered by fall-through of je at 0x004f751b, 21 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f756d
    mov ecx, dword ptr [ebp - local_20]          # 004f751d
    fld dword ptr [ecx + field_2ab]              # 004f7520
    sub esp, 0x8                                 # 004f7526
    fstp qword ptr [esp]                         # 004f7529
    mov edx, dword ptr [ebp - local_20]          # 004f752c
    fld dword ptr [edx + field_2a7]              # 004f752f
    sub esp, 0x8                                 # 004f7535
    fstp qword ptr [esp]                         # 004f7538
    mov eax, dword ptr [ebp - local_20]          # 004f753b
    fld dword ptr [eax + field_2a3]              # 004f753e
    sub esp, 0x8                                 # 004f7544
    fstp qword ptr [esp]                         # 004f7547
    mov ecx, dword ptr [ebp - local_8]           # 004f754a
    push ecx                                     # 004f754d
    push 0x55ead4                                # 004f754e
    push 0x63888b                                # 004f7553
    call FUN_0050ca3e                            # 004f7558
    add esp, 0x24                                # 004f755d
    push 0x63888b                                # 004f7560
    call FUN_0044a2b7                            # 004f7565
    add esp, 0x4                                 # 004f756a
L_004f756d:
    # block 0x004f756d: entered by je at 0x004f751b, 1 instruction(s), ends with forward jump to 0x004f76f5
    jmp.d32 L_004f76f5                           # 004f756d
L_004f7572:
    # block 0x004f7572: entered by je at 0x004f74da; je at 0x004f75fb, 42 instruction(s), calls FUN_004fa127, FUN_0050df94, ends with je to 0x004f7572 (backward)
    lea edx, [ebp - local_14]                    # 004f7572
    push edx                                     # 004f7575
    mov eax, dword ptr [ebp - local_8]           # 004f7576
    push eax                                     # 004f7579
    mov ecx, dword ptr [ebp - local_44]          # 004f757a
    call FUN_004fa127                            # 004f757d
    mov ecx, dword ptr [ebp - local_20]          # 004f7582
    fld dword ptr [ecx + field_2a3]              # 004f7585
    fsub dword ptr [ebp - local_14]              # 004f758b
    mov edx, dword ptr [ebp - local_20]          # 004f758e
    fld dword ptr [edx + field_2a3]              # 004f7591
    fsub dword ptr [ebp - local_14]              # 004f7597
    fmulp st(1), st                              # 004f759a
    mov eax, dword ptr [ebp - local_20]          # 004f759c
    fld dword ptr [eax + field_2a7]              # 004f759f
    fsub dword ptr [ebp - local_10]              # 004f75a5
    mov ecx, dword ptr [ebp - local_20]          # 004f75a8
    fld dword ptr [ecx + field_2a7]              # 004f75ab
    fsub dword ptr [ebp - local_10]              # 004f75b1
    fmulp st(1), st                              # 004f75b4
    faddp st(1), st                              # 004f75b6
    mov edx, dword ptr [ebp - local_20]          # 004f75b8
    fld dword ptr [edx + field_2ab]              # 004f75bb
    fsub dword ptr [ebp - local_c]               # 004f75c1
    mov eax, dword ptr [ebp - local_20]          # 004f75c4
    fld dword ptr [eax + field_2ab]              # 004f75c7
    fsub dword ptr [ebp - local_c]               # 004f75cd
    fmulp st(1), st                              # 004f75d0
    faddp st(1), st                              # 004f75d2
    sub esp, 0x8                                 # 004f75d4
    fstp qword ptr [esp]                         # 004f75d7
    call FUN_0050df94                            # 004f75da
    add esp, 0x8                                 # 004f75df
    fstp dword ptr [ebp - local_18]              # 004f75e2
    fld dword ptr [ebp - local_18]               # 004f75e5
    mov ecx, dword ptr [ebp - local_4]           # 004f75e8
    fld dword ptr [ecx + field_5c]               # 004f75eb
    fdiv qword ptr [0x52c678]                    # 004f75ee
    fcompp                                       # 004f75f4
    fnstsw ax                                    # 004f75f6
    test ah, 0x41                                # 004f75f8
    je.d32 L_004f7572                            # 004f75fb
    # block 0x004f7601: entered by fall-through of je at 0x004f75fb, 42 instruction(s), ends with je to 0x004f76f5 (forward)
    mov edx, dword ptr [ebp - local_20]          # 004f7601
    fld dword ptr [ebp - local_14]               # 004f7604
    fsub dword ptr [edx + field_2a3]             # 004f7607
    mov eax, dword ptr [ebp - local_4]           # 004f760d
    fstp dword ptr [eax + field_60]              # 004f7610
    mov ecx, dword ptr [ebp - local_20]          # 004f7613
    fld dword ptr [ebp - local_10]               # 004f7616
    fsub dword ptr [ecx + field_2a7]             # 004f7619
    mov edx, dword ptr [ebp - local_4]           # 004f761f
    fstp dword ptr [edx + field_64]              # 004f7622
    mov eax, dword ptr [ebp - local_20]          # 004f7625
    fld dword ptr [ebp - local_c]                # 004f7628
    fsub dword ptr [eax + field_2ab]             # 004f762b
    mov ecx, dword ptr [ebp - local_4]           # 004f7631
    fstp dword ptr [ecx + field_68]              # 004f7634
    mov edx, dword ptr [ebp - local_4]           # 004f7637
    fild dword ptr [edx + field_3c]              # 004f763a
    fstp dword ptr [ebp - local_50]              # 004f763d
    mov eax, dword ptr [ebp - local_4]           # 004f7640
    fld dword ptr [eax + field_60]               # 004f7643
    fdiv dword ptr [ebp - local_50]              # 004f7646
    mov ecx, dword ptr [ebp - local_4]           # 004f7649
    fstp dword ptr [ecx + field_44]              # 004f764c
    mov edx, dword ptr [ebp - local_4]           # 004f764f
    fild dword ptr [edx + field_3c]              # 004f7652
    fstp dword ptr [ebp - local_54]              # 004f7655
    mov eax, dword ptr [ebp - local_4]           # 004f7658
    fld dword ptr [eax + field_64]               # 004f765b
    fdiv dword ptr [ebp - local_54]              # 004f765e
    mov ecx, dword ptr [ebp - local_4]           # 004f7661
    fstp dword ptr [ecx + field_48]              # 004f7664
    mov edx, dword ptr [ebp - local_4]           # 004f7667
    fild dword ptr [edx + field_3c]              # 004f766a
    fstp dword ptr [ebp - local_58]              # 004f766d
    mov eax, dword ptr [ebp - local_4]           # 004f7670
    fld dword ptr [eax + field_68]               # 004f7673
    fdiv dword ptr [ebp - local_58]              # 004f7676
    mov ecx, dword ptr [ebp - local_4]           # 004f7679
    fstp dword ptr [ecx + field_4c]              # 004f767c
    movsx edx, word ptr [0x63a4cd]               # 004f767f
    test edx, edx                                # 004f7686
    je.d8 L_004f76f5                             # 004f7688
    # block 0x004f768a: entered by fall-through of je at 0x004f7688, 33 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f76f5
    mov eax, dword ptr [ebp - local_4]           # 004f768a
    fld dword ptr [eax + field_4c]               # 004f768d
    sub esp, 0x8                                 # 004f7690
    fstp qword ptr [esp]                         # 004f7693
    mov ecx, dword ptr [ebp - local_4]           # 004f7696
    fld dword ptr [ecx + field_48]               # 004f7699
    sub esp, 0x8                                 # 004f769c
    fstp qword ptr [esp]                         # 004f769f
    mov edx, dword ptr [ebp - local_4]           # 004f76a2
    fld dword ptr [edx + field_44]               # 004f76a5
    sub esp, 0x8                                 # 004f76a8
    fstp qword ptr [esp]                         # 004f76ab
    mov eax, dword ptr [ebp - local_4]           # 004f76ae
    fld dword ptr [eax + field_68]               # 004f76b1
    sub esp, 0x8                                 # 004f76b4
    fstp qword ptr [esp]                         # 004f76b7
    mov ecx, dword ptr [ebp - local_4]           # 004f76ba
    fld dword ptr [ecx + field_64]               # 004f76bd
    sub esp, 0x8                                 # 004f76c0
    fstp qword ptr [esp]                         # 004f76c3
    mov edx, dword ptr [ebp - local_4]           # 004f76c6
    fld dword ptr [edx + field_60]               # 004f76c9
    sub esp, 0x8                                 # 004f76cc
    fstp qword ptr [esp]                         # 004f76cf
    mov eax, dword ptr [ebp - local_8]           # 004f76d2
    push eax                                     # 004f76d5
    push 0x55eb3c                                # 004f76d6
    push 0x63888b                                # 004f76db
    call FUN_0050ca3e                            # 004f76e0
    add esp, 0x3c                                # 004f76e5
    push 0x63888b                                # 004f76e8
    call FUN_0044a2b7                            # 004f76ed
    add esp, 0x4                                 # 004f76f2
L_004f76f5:
    # block 0x004f76f5: entered by jmp at 0x004f74e0; jmp at 0x004f756d; je at 0x004f7688, 14 instruction(s), calls FUN_004f8f94, FUN_004f9040, ends with forward jump to 0x004f772e
    mov ecx, dword ptr [ebp - local_4]           # 004f76f5
    mov dword ptr [ecx + field_54], 0x0          # 004f76f8
    mov edx, dword ptr [ebp - local_8]           # 004f76ff
    push edx                                     # 004f7702
    mov ecx, dword ptr [ebp - local_44]          # 004f7703
    call FUN_004f8f94                            # 004f7706
    mov eax, dword ptr [ebp - local_20]          # 004f770b
    add eax, 0x2a3                               # 004f770e
    push eax                                     # 004f7713
    mov ecx, dword ptr [ebp - local_8]           # 004f7714
    push ecx                                     # 004f7717
    mov ecx, dword ptr [ebp - local_44]          # 004f7718
    call FUN_004f9040                            # 004f771b
    jmp.d8 L_004f772e                            # 004f7720
L_004f7722:
    # block 0x004f7722: entered by jne at 0x004f74b5, 4 instruction(s), calls FUN_004f61e7, falls into the block at 0x004f772e
    mov edx, dword ptr [ebp - local_8]           # 004f7722
    push edx                                     # 004f7725
    mov ecx, dword ptr [ebp - local_44]          # 004f7726
    call FUN_004f61e7                            # 004f7729
L_004f772e:
    # block 0x004f772e: entered by jbe at 0x004f7330; jmp at 0x004f74a6; jmp at 0x004f7720, 1 instruction(s), ends with forward jump to 0x004f79c3
    jmp.d32 L_004f79c3                           # 004f772e
L_004f7733:
    # block 0x004f7733: entered by jne at 0x004f7321, 5 instruction(s), ends with jne to 0x004f79c3 (forward)
    mov eax, dword ptr [ebp - local_20]          # 004f7733
    {load} xor ecx, ecx                          # 004f7736
    mov cx, word ptr [eax + field_12c]           # 004f7738
    cmp ecx, 0x300                               # 004f773f
    jne.d32 L_004f79c3                           # 004f7745
    # block 0x004f774b: entered by fall-through of jne at 0x004f7745, 4 instruction(s), ends with jbe to 0x004f79c3 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f774b
    mov eax, dword ptr [ebp - local_1c]          # 004f774e
    cmp eax, dword ptr [edx + field_40]          # 004f7751
    jbe.d32 L_004f79c3                           # 004f7754
    # block 0x004f775a: entered by fall-through of jbe at 0x004f7754, 13 instruction(s), ends with je to 0x004f78e8 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f775a
    mov edx, dword ptr [ebp - local_1c]          # 004f775d
    add edx, dword ptr [ecx + field_38]          # 004f7760
    mov eax, dword ptr [ebp - local_4]           # 004f7763
    mov dword ptr [eax + field_40], edx          # 004f7766
    mov ecx, dword ptr [ebp - local_4]           # 004f7769
    mov edx, dword ptr [ebp - local_4]           # 004f776c
    fld dword ptr [ecx + field_58]               # 004f776f
    fadd dword ptr [edx + field_50]              # 004f7772
    fcomp qword ptr [0x52e510]                   # 004f7775
    fnstsw ax                                    # 004f777b
    test ah, 0x41                                # 004f777d
    je.d32 L_004f78e8                            # 004f7780
    # block 0x004f7786: entered by fall-through of je at 0x004f7780, 11 instruction(s), ends with je to 0x004f77b8 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f7786
    mov ecx, dword ptr [ebp - local_4]           # 004f7789
    fld dword ptr [eax + field_58]               # 004f778c
    fadd dword ptr [ecx + field_50]              # 004f778f
    mov edx, dword ptr [ebp - local_4]           # 004f7792
    fstp dword ptr [edx + field_58]              # 004f7795
    mov eax, dword ptr [ebp - local_4]           # 004f7798
    mov cl, byte ptr [eax + field_90]            # 004f779b
    mov byte ptr [ebp - local_5c], cl            # 004f77a1
    cmp byte ptr [ebp - local_5c], 0x0           # 004f77a4
    je.d8 L_004f77b8                             # 004f77a8
    # block 0x004f77aa: entered by fall-through of je at 0x004f77a8, 2 instruction(s), ends with je to 0x004f77d5 (forward)
    cmp byte ptr [ebp - local_5c], 0x1           # 004f77aa
    je.d8 L_004f77d5                             # 004f77ae
    # block 0x004f77b0: entered by fall-through of je at 0x004f77ae, 2 instruction(s), ends with je to 0x004f77f2 (forward)
    cmp byte ptr [ebp - local_5c], 0x2           # 004f77b0
    je.d8 L_004f77f2                             # 004f77b4
    # block 0x004f77b6: entered by fall-through of je at 0x004f77b4, 1 instruction(s), ends with forward jump to 0x004f780d
    jmp.d8 L_004f780d                            # 004f77b6
L_004f77b8:
    # block 0x004f77b8: entered by je at 0x004f77a8, 9 instruction(s), calls FUN_004ccacf, ends with forward jump to 0x004f780d
    mov edx, dword ptr [ebp - local_4]           # 004f77b8
    mov eax, dword ptr [edx + field_58]          # 004f77bb
    push eax                                     # 004f77be
    mov ecx, dword ptr [ebp - local_4]           # 004f77bf
    add ecx, 0x91                                # 004f77c2
    push ecx                                     # 004f77c8
    mov ecx, 0x630a7e                            # 004f77c9
    call FUN_004ccacf                            # 004f77ce
    jmp.d8 L_004f780d                            # 004f77d3
L_004f77d5:
    # block 0x004f77d5: entered by je at 0x004f77ae, 9 instruction(s), calls FUN_004ccb50, ends with forward jump to 0x004f780d
    mov edx, dword ptr [ebp - local_4]           # 004f77d5
    mov eax, dword ptr [edx + field_58]          # 004f77d8
    push eax                                     # 004f77db
    mov ecx, dword ptr [ebp - local_4]           # 004f77dc
    add ecx, 0x91                                # 004f77df
    push ecx                                     # 004f77e5
    mov ecx, 0x630a7e                            # 004f77e6
    call FUN_004ccb50                            # 004f77eb
    jmp.d8 L_004f780d                            # 004f77f0
L_004f77f2:
    # block 0x004f77f2: entered by je at 0x004f77b4, 8 instruction(s), calls FUN_004ccbd0, falls into the block at 0x004f780d
    mov edx, dword ptr [ebp - local_4]           # 004f77f2
    mov eax, dword ptr [edx + field_58]          # 004f77f5
    push eax                                     # 004f77f8
    mov ecx, dword ptr [ebp - local_4]           # 004f77f9
    add ecx, 0x91                                # 004f77fc
    push ecx                                     # 004f7802
    mov ecx, 0x630a7e                            # 004f7803
    call FUN_004ccbd0                            # 004f7808
L_004f780d:
    # block 0x004f780d: entered by jmp at 0x004f77b6; jmp at 0x004f77d3; jmp at 0x004f77f0, 37 instruction(s), calls FUN_004ccc81, FUN_004f8f94, FUN_004f9040, ends with je to 0x004f78e3 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f780d
    fild dword ptr [edx + field_8c]              # 004f7810
    fstp dword ptr [ebp - local_60]              # 004f7816
    mov eax, dword ptr [ebp - local_60]          # 004f7819
    push eax                                     # 004f781c
    mov ecx, dword ptr [ebp - local_4]           # 004f781d
    fild dword ptr [ecx + field_88]              # 004f7820
    fstp dword ptr [ebp - local_64]              # 004f7826
    mov edx, dword ptr [ebp - local_64]          # 004f7829
    push edx                                     # 004f782c
    mov eax, dword ptr [ebp - local_4]           # 004f782d
    fild dword ptr [eax + field_84]              # 004f7830
    fstp dword ptr [ebp - local_68]              # 004f7836
    mov ecx, dword ptr [ebp - local_68]          # 004f7839
    push ecx                                     # 004f783c
    mov edx, dword ptr [ebp - local_20]          # 004f783d
    add edx, 0x2a3                               # 004f7840
    push edx                                     # 004f7846
    mov eax, dword ptr [ebp - local_4]           # 004f7847
    add eax, 0x91                                # 004f784a
    push eax                                     # 004f784f
    mov ecx, 0x630a7e                            # 004f7850
    call FUN_004ccc81                            # 004f7855
    mov ecx, dword ptr [ebp - local_8]           # 004f785a
    push ecx                                     # 004f785d
    mov ecx, dword ptr [ebp - local_44]          # 004f785e
    call FUN_004f8f94                            # 004f7861
    mov edx, dword ptr [ebp - local_20]          # 004f7866
    add edx, 0x2a3                               # 004f7869
    push edx                                     # 004f786f
    mov eax, dword ptr [ebp - local_8]           # 004f7870
    push eax                                     # 004f7873
    mov ecx, dword ptr [ebp - local_44]          # 004f7874
    call FUN_004f9040                            # 004f7877
    movsx ecx, word ptr [0x63a4cd]               # 004f787c
    test ecx, ecx                                # 004f7883
    je.d8 L_004f78e3                             # 004f7885
    # block 0x004f7887: entered by fall-through of je at 0x004f7885, 25 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f78e3
    mov edx, dword ptr [ebp - local_20]          # 004f7887
    fld dword ptr [edx + field_2ab]              # 004f788a
    sub esp, 0x8                                 # 004f7890
    fstp qword ptr [esp]                         # 004f7893
    mov eax, dword ptr [ebp - local_20]          # 004f7896
    fld dword ptr [eax + field_2a7]              # 004f7899
    sub esp, 0x8                                 # 004f789f
    fstp qword ptr [esp]                         # 004f78a2
    mov ecx, dword ptr [ebp - local_20]          # 004f78a5
    fld dword ptr [ecx + field_2a3]              # 004f78a8
    sub esp, 0x8                                 # 004f78ae
    fstp qword ptr [esp]                         # 004f78b1
    mov edx, dword ptr [ebp - local_4]           # 004f78b4
    fld dword ptr [edx + field_58]               # 004f78b7
    sub esp, 0x8                                 # 004f78ba
    fstp qword ptr [esp]                         # 004f78bd
    mov eax, dword ptr [ebp - local_8]           # 004f78c0
    push eax                                     # 004f78c3
    push 0x55ebdc                                # 004f78c4
    push 0x63888b                                # 004f78c9
    call FUN_0050ca3e                            # 004f78ce
    add esp, 0x2c                                # 004f78d3
    push 0x63888b                                # 004f78d6
    call FUN_0044a2b7                            # 004f78db
    add esp, 0x4                                 # 004f78e0
L_004f78e3:
    # block 0x004f78e3: entered by je at 0x004f7885, 1 instruction(s), ends with forward jump to 0x004f79c3
    jmp.d32 L_004f79c3                           # 004f78e3
L_004f78e8:
    # block 0x004f78e8: entered by je at 0x004f7780, 3 instruction(s), ends with jne to 0x004f79b7 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 004f78e8
    cmp dword ptr [ecx + field_130], 0x0         # 004f78eb
    jne.d32 L_004f79b7                           # 004f78f2
    # block 0x004f78f8: entered by fall-through of jne at 0x004f78f2, 28 instruction(s), calls FUN_004f8f94, FUN_004f9040, ends with je to 0x004f79b5 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f78f8
    fild dword ptr [edx + field_84]              # 004f78fb
    mov eax, dword ptr [ebp - local_20]          # 004f7901
    fstp dword ptr [eax + field_2a3]             # 004f7904
    mov ecx, dword ptr [ebp - local_4]           # 004f790a
    fild dword ptr [ecx + field_88]              # 004f790d
    mov edx, dword ptr [ebp - local_20]          # 004f7913
    fstp dword ptr [edx + field_2a7]             # 004f7916
    mov eax, dword ptr [ebp - local_4]           # 004f791c
    fild dword ptr [eax + field_8c]              # 004f791f
    mov ecx, dword ptr [ebp - local_20]          # 004f7925
    fstp dword ptr [ecx + field_2ab]             # 004f7928
    mov edx, dword ptr [ebp - local_4]           # 004f792e
    mov dword ptr [edx + field_58], 0x0          # 004f7931
    mov eax, dword ptr [ebp - local_8]           # 004f7938
    push eax                                     # 004f793b
    mov ecx, dword ptr [ebp - local_44]          # 004f793c
    call FUN_004f8f94                            # 004f793f
    mov ecx, dword ptr [ebp - local_20]          # 004f7944
    add ecx, 0x2a3                               # 004f7947
    push ecx                                     # 004f794d
    mov edx, dword ptr [ebp - local_8]           # 004f794e
    push edx                                     # 004f7951
    mov ecx, dword ptr [ebp - local_44]          # 004f7952
    call FUN_004f9040                            # 004f7955
    movsx eax, word ptr [0x63a4cd]               # 004f795a
    test eax, eax                                # 004f7961
    je.d8 L_004f79b5                             # 004f7963
    # block 0x004f7965: entered by fall-through of je at 0x004f7963, 21 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f79b5
    mov ecx, dword ptr [ebp - local_20]          # 004f7965
    fld dword ptr [ecx + field_2ab]              # 004f7968
    sub esp, 0x8                                 # 004f796e
    fstp qword ptr [esp]                         # 004f7971
    mov edx, dword ptr [ebp - local_20]          # 004f7974
    fld dword ptr [edx + field_2a7]              # 004f7977
    sub esp, 0x8                                 # 004f797d
    fstp qword ptr [esp]                         # 004f7980
    mov eax, dword ptr [ebp - local_20]          # 004f7983
    fld dword ptr [eax + field_2a3]              # 004f7986
    sub esp, 0x8                                 # 004f798c
    fstp qword ptr [esp]                         # 004f798f
    mov ecx, dword ptr [ebp - local_8]           # 004f7992
    push ecx                                     # 004f7995
    push 0x55ec58                                # 004f7996
    push 0x63888b                                # 004f799b
    call FUN_0050ca3e                            # 004f79a0
    add esp, 0x24                                # 004f79a5
    push 0x63888b                                # 004f79a8
    call FUN_0044a2b7                            # 004f79ad
    add esp, 0x4                                 # 004f79b2
L_004f79b5:
    # block 0x004f79b5: entered by je at 0x004f7963, 1 instruction(s), ends with forward jump to 0x004f79c3
    jmp.d8 L_004f79c3                            # 004f79b5
L_004f79b7:
    # block 0x004f79b7: entered by jne at 0x004f78f2, 4 instruction(s), calls FUN_004f61e7, falls into the block at 0x004f79c3
    mov edx, dword ptr [ebp - local_8]           # 004f79b7
    push edx                                     # 004f79ba
    mov ecx, dword ptr [ebp - local_44]          # 004f79bb
    call FUN_004f61e7                            # 004f79be
L_004f79c3:
    # block 0x004f79c3: entered by jmp at 0x004f72f6; jmp at 0x004f772e; jne at 0x004f7745; jbe at 0x004f7754; more, 1 instruction(s), ends with backward jump to 0x004f7231
    jmp.d32 L_004f7231                           # 004f79c3
L_004f79c8:
    # block 0x004f79c8: entered by jge at 0x004f723e, 5 instruction(s), ends with ret
    pop edi                                      # 004f79c8
    pop esi                                      # 004f79c9
    {load} mov esp, ebp                          # 004f79ca
    pop ebp                                      # 004f79cc
    ret                                          # 004f79cd

