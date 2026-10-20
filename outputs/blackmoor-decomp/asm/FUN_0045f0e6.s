# FUN_0045f0e6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045f0e6
# extent:       0x0045f0e6-0x00460ee6 (7680 code bytes)
# span:         0x0045f0e6-0x00460f16 (code 7680, tables 48, padding 0)
# sha256:       c455a9dfd57d23088ecca49be6e847a3e568c8d2c2657f3c787d2f62264707b9
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_card_puzzle_handler
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_f6_runtime.h:19 says "0x45f0e6 the handler: a phase switch on the row phase dword"
# name-note:    Handler of the raw 0xf6 card puzzle: phase switch with an inner state machine.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       12 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30
# fields:       [eax + n] field_4, field_8, field_c, field_1c, field_1e, field_24, field_25, field_27, field_4f, field_d0, field_ea, field_142 and 45 more; [ecx + n] field_4, field_8, field_c, field_1c, field_1e, field_20, field_22, field_23, field_24, field_25, field_27, field_57 and 65 more; [edx + n] field_4, field_8, field_c, field_1c, field_1e, field_24, field_29, field_6b, field_d0, field_142, field_264, field_299 and 57 more
# callees:      calls FUN_004e8d96, FUN_0045de8a, FUN_004d39f9, FUN_004c2790, KERNEL32.dll!GetTickCount, FUN_0045ea4a, FUN_0045e67d, FUN_0045e6bd, FUN_0045eb76, FUN_0045ed60, FUN_0045ef5a, FUN_0045e906, FUN_0045e9db, FUN_0045eadc, FUN_004f6334, FUN_004fb77a and 3 more
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1839 instruction(s), 102 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_22, 0x22  # offset +0x22
.equ field_23, 0x23  # offset +0x23
.equ field_24, 0x24  # offset +0x24
.equ field_25, 0x25  # offset +0x25
.equ field_27, 0x27  # offset +0x27
.equ field_29, 0x29  # offset +0x29
.equ field_4f, 0x4f  # offset +0x4f
.equ field_57, 0x57  # offset +0x57
.equ field_6b, 0x6b  # offset +0x6b
.equ field_d0, 0xd0  # offset +0xd0
.equ field_ea, 0xea  # offset +0xea
.equ field_142, 0x142  # offset +0x142
.equ field_264, 0x264  # offset +0x264
.equ field_299, 0x299  # offset +0x299
.equ field_29a, 0x29a  # offset +0x29a
.equ field_29c, 0x29c  # offset +0x29c
.equ field_29d, 0x29d  # offset +0x29d
.equ field_29e, 0x29e  # offset +0x29e
.equ field_29f, 0x29f  # offset +0x29f
.equ field_2a1, 0x2a1  # offset +0x2a1
.equ field_2a2, 0x2a2  # offset +0x2a2
.equ field_2a3, 0x2a3  # offset +0x2a3
.equ field_2a4, 0x2a4  # offset +0x2a4
.equ field_2a6, 0x2a6  # offset +0x2a6
.equ field_2a8, 0x2a8  # offset +0x2a8
.equ field_2a9, 0x2a9  # offset +0x2a9
.equ field_2aa, 0x2aa  # offset +0x2aa
.equ field_2ab, 0x2ab  # offset +0x2ab
.equ field_2ac, 0x2ac  # offset +0x2ac
.equ field_2ad, 0x2ad  # offset +0x2ad
.equ field_2cd, 0x2cd  # offset +0x2cd
.equ field_2cf, 0x2cf  # offset +0x2cf
.equ field_2d1, 0x2d1  # offset +0x2d1
.equ field_2d3, 0x2d3  # offset +0x2d3
.equ field_2d4, 0x2d4  # offset +0x2d4
.equ field_2d5, 0x2d5  # offset +0x2d5
.equ field_2d7, 0x2d7  # offset +0x2d7
.equ field_2d9, 0x2d9  # offset +0x2d9
.equ field_2e1, 0x2e1  # offset +0x2e1
.equ field_2fd, 0x2fd  # offset +0x2fd
.equ field_305, 0x305  # offset +0x305
.equ field_31d, 0x31d  # offset +0x31d
.equ field_321, 0x321  # offset +0x321
.equ field_322, 0x322  # offset +0x322
.equ field_323, 0x323  # offset +0x323
.equ field_324, 0x324  # offset +0x324
.equ field_325, 0x325  # offset +0x325
.equ field_347, 0x347  # offset +0x347
.equ field_349, 0x349  # offset +0x349
.equ field_34b, 0x34b  # offset +0x34b
.equ field_34d, 0x34d  # offset +0x34d
.equ field_34f, 0x34f  # offset +0x34f
.equ field_353, 0x353  # offset +0x353
.equ field_355, 0x355  # offset +0x355
.equ field_371, 0x371  # offset +0x371
.equ field_373, 0x373  # offset +0x373
.equ field_375, 0x375  # offset +0x375
.equ field_379, 0x379  # offset +0x379
.equ field_37d, 0x37d  # offset +0x37d
.equ field_381, 0x381  # offset +0x381
.equ field_383, 0x383  # offset +0x383
.equ field_39d, 0x39d  # offset +0x39d
.equ field_39e, 0x39e  # offset +0x39e
.equ field_3a2, 0x3a2  # offset +0x3a2
.equ field_3a6, 0x3a6  # offset +0x3a6
.equ field_3ab, 0x3ab  # offset +0x3ab
.equ field_3ac, 0x3ac  # offset +0x3ac
.equ field_3ad, 0x3ad  # offset +0x3ad
.equ field_3ae, 0x3ae  # offset +0x3ae
.equ field_47f, 0x47f  # offset +0x47f
.equ field_487, 0x487  # offset +0x487
.equ field_62b, 0x62b  # offset +0x62b
.equ field_62d, 0x62d  # offset +0x62d
.equ field_62f, 0x62f  # offset +0x62f
.equ field_637, 0x637  # offset +0x637
.equ field_63f, 0x63f  # offset +0x63f
.equ field_657, 0x657  # offset +0x657
.equ field_65f, 0x65f  # offset +0x65f
.equ field_993, 0x993  # offset +0x993
.equ field_995, 0x995  # offset +0x995
.equ field_997, 0x997  # offset +0x997
.equ field_a9b, 0xa9b  # offset +0xa9b
.equ field_a9d, 0xa9d  # offset +0xa9d
.equ field_a9f, 0xa9f  # offset +0xa9f
.equ field_c2b, 0xc2b  # offset +0xc2b
.equ field_dd8, 0xdd8  # offset +0xdd8
.equ field_e7d, 0xe7d  # offset +0xe7d
.equ field_ee0, 0xee0  # offset +0xee0
.equ field_f64, 0xf64  # offset +0xf64
.equ field_f66, 0xf66  # offset +0xf66
.equ field_f68, 0xf68  # offset +0xf68
.equ field_1304, 0x1304  # offset +0x1304
.equ field_1306, 0x1306  # offset +0x1306
.equ field_1308, 0x1308  # offset +0x1308
.equ field_130a, 0x130a  # offset +0x130a
.equ field_130c, 0x130c  # offset +0x130c
.equ field_130e, 0x130e  # offset +0x130e
.equ field_1312, 0x1312  # offset +0x1312
.equ field_1316, 0x1316  # offset +0x1316
.equ field_131a, 0x131a  # offset +0x131a
.equ field_131c, 0x131c  # offset +0x131c
.equ field_131e, 0x131e  # offset +0x131e
.equ field_1320, 0x1320  # offset +0x1320
.equ field_1322, 0x1322  # offset +0x1322
.equ field_1324, 0x1324  # offset +0x1324
.equ field_1326, 0x1326  # offset +0x1326
.equ field_1328, 0x1328  # offset +0x1328
.equ field_132c, 0x132c  # offset +0x132c
.equ field_1330, 0x1330  # offset +0x1330
.equ field_1334, 0x1334  # offset +0x1334

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_0045dd4d, .text + (0x0045dd4d - 0x401000)
.set FUN_0045de8a, .text + (0x0045de8a - 0x401000)
.set FUN_0045e67d, .text + (0x0045e67d - 0x401000)
.set FUN_0045e6bd, .text + (0x0045e6bd - 0x401000)
.set FUN_0045e906, .text + (0x0045e906 - 0x401000)
.set FUN_0045e9db, .text + (0x0045e9db - 0x401000)
.set FUN_0045ea4a, .text + (0x0045ea4a - 0x401000)
.set FUN_0045eadc, .text + (0x0045eadc - 0x401000)
.set FUN_0045eb76, .text + (0x0045eb76 - 0x401000)
.set FUN_0045ed60, .text + (0x0045ed60 - 0x401000)
.set FUN_0045ef5a, .text + (0x0045ef5a - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)

.org 0x0045f0e6 - 0x401000
.globl FUN_0045f0e6
FUN_0045f0e6:
    # block 0x0045f0e6: entry, 12 instruction(s), ends with je to 0x0045f123 (forward)
    push ebp                                     # 0045f0e6
    {load} mov ebp, esp                          # 0045f0e7
    sub esp, 0x30                                # 0045f0e9
    push esi                                     # 0045f0ec
    push edi                                     # 0045f0ed
    mov dword ptr [ebp - local_28], ecx          # 0045f0ee
    movsx eax, word ptr [ebp + arg_8]            # 0045f0f1
    imul eax, eax, 0x8d                          # 0045f0f5
    mov ecx, dword ptr [eax + 0x5bb632]          # 0045f0fb
    mov dword ptr [ebp - local_2c], ecx          # 0045f101
    cmp dword ptr [ebp - local_2c], 0x0          # 0045f104
    je.d8 L_0045f123                             # 0045f108
    # block 0x0045f10a: entered by fall-through of je at 0x0045f108, 2 instruction(s), ends with je to 0x0045f61b (forward)
    cmp dword ptr [ebp - local_2c], 0x1          # 0045f10a
    je.d32 L_0045f61b                            # 0045f10e
    # block 0x0045f114: entered by fall-through of je at 0x0045f10e, 2 instruction(s), ends with je to 0x00460be3 (forward)
    cmp dword ptr [ebp - local_2c], 0x2          # 0045f114
    je.d32 L_00460be3                            # 0045f118
    # block 0x0045f11e: entered by fall-through of je at 0x0045f118, 1 instruction(s), ends with forward jump to 0x00460ede
    jmp.d32 L_00460ede                           # 0045f11e
L_0045f123:
    # block 0x0045f123: entered by je at 0x0045f108, 34 instruction(s), calls FUN_004e8d96, ends with forward jump to 0x0045f1c1
    mov edx, dword ptr [ebp - local_28]          # 0045f123
    mov ax, word ptr [ebp + arg_8]               # 0045f126
    mov word ptr [edx + field_1e], ax            # 0045f12a
    movsx ecx, word ptr [ebp + arg_8]            # 0045f12e
    imul ecx, ecx, 0x8d                          # 0045f132
    mov edx, dword ptr [ebp - local_28]          # 0045f138
    mov eax, dword ptr [ecx + 0x5bb5e5]          # 0045f13b
    mov dword ptr [edx + field_31d], eax         # 0045f141
    mov ecx, dword ptr [ebp - local_28]          # 0045f147
    mov byte ptr [ecx + field_321], 0x1          # 0045f14a
    mov dword ptr [0x5bb1ca], 0x1                # 0045f151
    mov ecx, 0x571442                            # 0045f15b
    call FUN_004e8d96                            # 0045f160
    mov edx, dword ptr [ebp - local_28]          # 0045f165
    mov eax, dword ptr [edx + field_31d]         # 0045f168
    movsx ecx, word ptr [eax + field_25]         # 0045f16e
    mov edx, dword ptr [ebp - local_28]          # 0045f172
    mov eax, dword ptr [edx + field_31d]         # 0045f175
    movsx edx, word ptr [eax + field_27]         # 0045f17b
    imul ecx, edx                                # 0045f17f
    mov eax, dword ptr [ebp - local_28]          # 0045f182
    mov word ptr [eax + field_2a6], cx           # 0045f185
    mov ecx, 0x90                                # 0045f18c
    {load} xor eax, eax                          # 0045f191
    mov edi, dword ptr [ebp - local_28]          # 0045f193
    add edi, 0x24                                # 0045f196
    rep stosd dword ptr es:[edi], eax            # 0045f199
    mov ecx, 0xd                                 # 0045f19b
    {load} xor eax, eax                          # 0045f1a0
    mov edi, dword ptr [ebp - local_28]          # 0045f1a2
    add edi, 0x264                               # 0045f1a5
    rep stosd dword ptr es:[edi], eax            # 0045f1ab
    mov word ptr [ebp - local_8], 0x0            # 0045f1ad
    jmp.d8 L_0045f1c1                            # 0045f1b3
L_0045f1b5:
    # block 0x0045f1b5: entered by jmp at 0x0045f21a, 3 instruction(s), falls into the block at 0x0045f1c1
    mov cx, word ptr [ebp - local_8]             # 0045f1b5
    add cx, 0x1                                  # 0045f1b9
    mov word ptr [ebp - local_8], cx             # 0045f1bd
L_0045f1c1:
    # block 0x0045f1c1: entered by jmp at 0x0045f1b3, 6 instruction(s), ends with jge to 0x0045f21c (forward)
    movsx edx, word ptr [ebp - local_8]          # 0045f1c1
    mov eax, dword ptr [ebp - local_28]          # 0045f1c5
    mov ecx, dword ptr [eax + field_31d]         # 0045f1c8
    movsx eax, word ptr [ecx + field_27]         # 0045f1ce
    {load} cmp edx, eax                          # 0045f1d2
    jge.d8 L_0045f21c                            # 0045f1d4
    # block 0x0045f1d6: entered by fall-through of jge at 0x0045f1d4, 2 instruction(s), ends with forward jump to 0x0045f1ea
    mov word ptr [ebp - local_4], 0x0            # 0045f1d6
    jmp.d8 L_0045f1ea                            # 0045f1dc
L_0045f1de:
    # block 0x0045f1de: entered by jmp at 0x0045f218, 3 instruction(s), falls into the block at 0x0045f1ea
    mov cx, word ptr [ebp - local_4]             # 0045f1de
    add cx, 0x1                                  # 0045f1e2
    mov word ptr [ebp - local_4], cx             # 0045f1e6
L_0045f1ea:
    # block 0x0045f1ea: entered by jmp at 0x0045f1dc, 6 instruction(s), ends with jge to 0x0045f21a (forward)
    movsx edx, word ptr [ebp - local_4]          # 0045f1ea
    mov eax, dword ptr [ebp - local_28]          # 0045f1ee
    mov ecx, dword ptr [eax + field_31d]         # 0045f1f1
    movsx eax, word ptr [ecx + field_25]         # 0045f1f7
    {load} cmp edx, eax                          # 0045f1fb
    jge.d8 L_0045f21a                            # 0045f1fd
    # block 0x0045f1ff: entered by fall-through of jge at 0x0045f1fd, 7 instruction(s), ends with backward jump to 0x0045f1de
    movsx ecx, word ptr [ebp - local_8]          # 0045f1ff
    imul ecx, ecx, 0xd                           # 0045f203
    mov edx, dword ptr [ebp - local_28]          # 0045f206
    lea eax, [edx + ecx + field_264]             # 0045f209
    movsx ecx, word ptr [ebp - local_4]          # 0045f210
    mov byte ptr [eax + ecx], 0x1                # 0045f214
    jmp.d8 L_0045f1de                            # 0045f218
L_0045f21a:
    # block 0x0045f21a: entered by jge at 0x0045f1fd, 1 instruction(s), ends with backward jump to 0x0045f1b5
    jmp.d8 L_0045f1b5                            # 0045f21a
L_0045f21c:
    # block 0x0045f21c: entered by jge at 0x0045f1d4, 2 instruction(s), ends with forward jump to 0x0045f230
    mov word ptr [ebp - local_c], 0x0            # 0045f21c
    jmp.d8 L_0045f230                            # 0045f222
L_0045f224:
    # block 0x0045f224: entered by jmp at 0x0045f261, 3 instruction(s), falls into the block at 0x0045f230
    mov dx, word ptr [ebp - local_c]             # 0045f224
    add dx, 0x1                                  # 0045f228
    mov word ptr [ebp - local_c], dx             # 0045f22c
L_0045f230:
    # block 0x0045f230: entered by jmp at 0x0045f222, 6 instruction(s), ends with jge to 0x0045f263 (forward)
    movsx eax, word ptr [ebp - local_c]          # 0045f230
    mov ecx, dword ptr [ebp - local_28]          # 0045f234
    mov edx, dword ptr [ecx + field_31d]         # 0045f237
    movsx ecx, word ptr [edx + field_29]         # 0045f23d
    {load} cmp eax, ecx                          # 0045f241
    jge.d8 L_0045f263                            # 0045f243
    # block 0x0045f245: entered by fall-through of jge at 0x0045f243, 9 instruction(s), calls FUN_0045de8a, ends with backward jump to 0x0045f224
    push 0x0                                     # 0045f245
    mov ecx, dword ptr [ebp - local_28]          # 0045f247
    call FUN_0045de8a                            # 0045f24a
    mov word ptr [ebp - local_10], ax            # 0045f24f
    push 0x1                                     # 0045f253
    mov ecx, dword ptr [ebp - local_28]          # 0045f255
    call FUN_0045de8a                            # 0045f258
    mov word ptr [ebp - local_10], ax            # 0045f25d
    jmp.d8 L_0045f224                            # 0045f261
L_0045f263:
    # block 0x0045f263: entered by jge at 0x0045f243, 56 instruction(s), calls FUN_004d39f9, ends with jne to 0x0045f36f (forward)
    call FUN_004d39f9                            # 0045f263
    mov edx, dword ptr [ebp - local_28]          # 0045f268
    mov word ptr [edx + field_1c], ax            # 0045f26b
    mov eax, dword ptr [ebp - local_28]          # 0045f26f
    movsx ecx, word ptr [eax + field_1c]         # 0045f272
    imul ecx, ecx, 0x4a                          # 0045f276
    mov dword ptr [ecx + 0x5d1591], 0xa          # 0045f279
    mov edx, dword ptr [ebp - local_28]          # 0045f283
    movsx eax, word ptr [edx + field_1c]         # 0045f286
    imul eax, eax, 0x4a                          # 0045f28a
    mov dword ptr [eax + 0x5d1595], 0x460f26     # 0045f28d
    mov ecx, dword ptr [ebp - local_28]          # 0045f297
    movsx edx, word ptr [ecx + field_1c]         # 0045f29a
    imul edx, edx, 0x4a                          # 0045f29e
    mov dword ptr [edx + 0x5d1599], 0x0          # 0045f2a1
    mov eax, dword ptr [ebp - local_28]          # 0045f2ab
    movsx ecx, word ptr [eax + field_1c]         # 0045f2ae
    imul ecx, ecx, 0x4a                          # 0045f2b2
    mov dword ptr [ecx + 0x5d159d], 0x0          # 0045f2b5
    mov edx, dword ptr [ebp - local_28]          # 0045f2bf
    movsx eax, word ptr [edx + field_1c]         # 0045f2c2
    imul eax, eax, 0x4a                          # 0045f2c6
    mov dword ptr [eax + 0x5d15a1], 0x0          # 0045f2c9
    mov ecx, dword ptr [ebp - local_28]          # 0045f2d3
    movsx edx, word ptr [ecx + field_1c]         # 0045f2d6
    imul edx, edx, 0x4a                          # 0045f2da
    mov dword ptr [edx + 0x5d15a5], 0x1          # 0045f2dd
    mov eax, dword ptr [ebp - local_28]          # 0045f2e7
    movsx ecx, word ptr [eax + field_1c]         # 0045f2ea
    imul ecx, ecx, 0x4a                          # 0045f2ee
    mov dword ptr [ecx + 0x5d15a9], 0x1          # 0045f2f1
    mov edx, dword ptr [ebp - local_28]          # 0045f2fb
    movsx eax, word ptr [edx + field_1c]         # 0045f2fe
    imul eax, eax, 0x4a                          # 0045f302
    mov word ptr [eax + 0x5d15ad], 0x0           # 0045f305
    mov edi, 0x54af44                            # 0045f30e
    mov ecx, dword ptr [ebp - local_28]          # 0045f313
    movsx edx, word ptr [ecx + field_1c]         # 0045f316
    imul edx, edx, 0x4a                          # 0045f31a
    add edx, 0x5d15b3                            # 0045f31d
    or ecx, -0x1                                 # 0045f323
    {load} xor eax, eax                          # 0045f326
    repne scasb al, byte ptr es:[edi]            # 0045f328
    not ecx                                      # 0045f32a
    {load} sub edi, ecx                          # 0045f32c
    {load} mov esi, edi                          # 0045f32e
    {load} mov eax, ecx                          # 0045f330
    {load} mov edi, edx                          # 0045f332
    shr ecx, 0x2                                 # 0045f334
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0045f337
    {load} mov ecx, eax                          # 0045f339
    and ecx, 0x3                                 # 0045f33b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0045f33e
    mov ecx, dword ptr [ebp - local_28]          # 0045f340
    cmp dword ptr [ecx + field_20], 0x0          # 0045f343
    jne.d8 L_0045f36f                            # 0045f347
    # block 0x0045f349: entered by fall-through of jne at 0x0045f347, 10 instruction(s), calls FUN_004c2790, falls into the block at 0x0045f36f
    push 0x54af5c                                # 0045f349
    push 0x6                                     # 0045f34e
    mov edx, dword ptr [ebp - local_28]          # 0045f350
    mov eax, dword ptr [edx + field_31d]         # 0045f353
    push eax                                     # 0045f359
    push 0x54af78                                # 0045f35a
    mov ecx, 0x5cf659                            # 0045f35f
    call FUN_004c2790                            # 0045f364
    mov ecx, dword ptr [ebp - local_28]          # 0045f369
    mov dword ptr [ecx + field_20], eax          # 0045f36c
L_0045f36f:
    # block 0x0045f36f: entered by jne at 0x0045f347, 10 instruction(s), ends with forward jump to 0x0045f3a3
    mov edx, dword ptr [ebp - local_28]          # 0045f36f
    movsx eax, word ptr [edx + field_1c]         # 0045f372
    imul eax, eax, 0x4a                          # 0045f376
    mov ecx, dword ptr [ebp - local_28]          # 0045f379
    mov edx, dword ptr [ecx + field_20]          # 0045f37c
    mov dword ptr [eax + 0x5d1599], edx          # 0045f37f
    mov eax, dword ptr [ebp - local_28]          # 0045f385
    mov byte ptr [eax + field_322], 0x0          # 0045f388
    mov word ptr [ebp - local_c], 0x0            # 0045f38f
    jmp.d8 L_0045f3a3                            # 0045f395
L_0045f397:
    # block 0x0045f397: entered by jmp at 0x0045f3dd, 3 instruction(s), falls into the block at 0x0045f3a3
    mov cx, word ptr [ebp - local_c]             # 0045f397
    add cx, 0x1                                  # 0045f39b
    mov word ptr [ebp - local_c], cx             # 0045f39f
L_0045f3a3:
    # block 0x0045f3a3: entered by jmp at 0x0045f395, 3 instruction(s), ends with jge to 0x0045f3df (forward)
    movsx edx, word ptr [ebp - local_c]          # 0045f3a3
    cmp edx, 0xd                                 # 0045f3a7
    jge.d8 L_0045f3df                            # 0045f3aa
    # block 0x0045f3ac: entered by fall-through of jge at 0x0045f3aa, 12 instruction(s), ends with je to 0x0045f3dd (forward)
    mov eax, dword ptr [ebp - local_28]          # 0045f3ac
    mov ecx, dword ptr [eax + field_31d]         # 0045f3af
    movsx edx, word ptr [ebp - local_c]          # 0045f3b5
    imul edx, edx, 0x21                          # 0045f3b9
    lea edi, [ecx + edx + field_f68]             # 0045f3bc
    or ecx, -0x1                                 # 0045f3c3
    {load} xor eax, eax                          # 0045f3c6
    repne scasb al, byte ptr es:[edi]            # 0045f3c8
    not ecx                                      # 0045f3ca
    add ecx, -0x1                                # 0045f3cc
    test ecx, ecx                                # 0045f3cf
    je.d8 L_0045f3dd                             # 0045f3d1
    # block 0x0045f3d3: entered by fall-through of je at 0x0045f3d1, 2 instruction(s), falls into the block at 0x0045f3dd
    mov eax, dword ptr [ebp - local_28]          # 0045f3d3
    mov byte ptr [eax + field_322], 0x1          # 0045f3d6
L_0045f3dd:
    # block 0x0045f3dd: entered by je at 0x0045f3d1, 1 instruction(s), ends with backward jump to 0x0045f397
    jmp.d8 L_0045f397                            # 0045f3dd
L_0045f3df:
    # block 0x0045f3df: entered by jge at 0x0045f3aa, 4 instruction(s), ends with forward jump to 0x0045f3fd
    mov ecx, dword ptr [ebp - local_28]          # 0045f3df
    mov byte ptr [ecx + field_323], 0x0          # 0045f3e2
    mov word ptr [ebp - local_c], 0x0            # 0045f3e9
    jmp.d8 L_0045f3fd                            # 0045f3ef
L_0045f3f1:
    # block 0x0045f3f1: entered by jmp at 0x0045f437, 3 instruction(s), falls into the block at 0x0045f3fd
    mov dx, word ptr [ebp - local_c]             # 0045f3f1
    add dx, 0x1                                  # 0045f3f5
    mov word ptr [ebp - local_c], dx             # 0045f3f9
L_0045f3fd:
    # block 0x0045f3fd: entered by jmp at 0x0045f3ef, 3 instruction(s), ends with jge to 0x0045f439 (forward)
    movsx eax, word ptr [ebp - local_c]          # 0045f3fd
    cmp eax, 0xd                                 # 0045f401
    jge.d8 L_0045f439                            # 0045f404
    # block 0x0045f406: entered by fall-through of jge at 0x0045f404, 12 instruction(s), ends with je to 0x0045f437 (forward)
    mov ecx, dword ptr [ebp - local_28]          # 0045f406
    mov edx, dword ptr [ecx + field_31d]         # 0045f409
    movsx eax, word ptr [ebp - local_c]          # 0045f40f
    imul eax, eax, 0x21                          # 0045f413
    lea edi, [edx + eax + field_c2b]             # 0045f416
    or ecx, -0x1                                 # 0045f41d
    {load} xor eax, eax                          # 0045f420
    repne scasb al, byte ptr es:[edi]            # 0045f422
    not ecx                                      # 0045f424
    add ecx, -0x1                                # 0045f426
    test ecx, ecx                                # 0045f429
    je.d8 L_0045f437                             # 0045f42b
    # block 0x0045f42d: entered by fall-through of je at 0x0045f42b, 2 instruction(s), falls into the block at 0x0045f437
    mov ecx, dword ptr [ebp - local_28]          # 0045f42d
    mov byte ptr [ecx + field_323], 0x1          # 0045f430
L_0045f437:
    # block 0x0045f437: entered by je at 0x0045f42b, 1 instruction(s), ends with backward jump to 0x0045f3f1
    jmp.d8 L_0045f3f1                            # 0045f437
L_0045f439:
    # block 0x0045f439: entered by jge at 0x0045f404, 104 instruction(s), ends with forward jump to 0x00460ede
    mov edx, dword ptr [ebp - local_28]          # 0045f439
    mov eax, dword ptr [edx + field_31d]         # 0045f43c
    mov ecx, dword ptr [ebp - local_28]          # 0045f442
    mov edx, dword ptr [ecx + field_31d]         # 0045f445
    mov eax, dword ptr [eax + field_487]         # 0045f44b
    sub eax, dword ptr [edx + field_47f]         # 0045f451
    neg eax                                      # 0045f457
    {load} sbb eax, eax                          # 0045f459
    neg eax                                      # 0045f45b
    mov ecx, dword ptr [ebp - local_28]          # 0045f45d
    mov byte ptr [ecx + field_2a1], al           # 0045f460
    mov edx, dword ptr [ebp - local_28]          # 0045f466
    mov eax, dword ptr [edx + field_31d]         # 0045f469
    mov ecx, dword ptr [ebp - local_28]          # 0045f46f
    mov edx, dword ptr [ecx + field_31d]         # 0045f472
    mov eax, dword ptr [eax + field_63f]         # 0045f478
    sub eax, dword ptr [edx + field_637]         # 0045f47e
    neg eax                                      # 0045f484
    {load} sbb eax, eax                          # 0045f486
    neg eax                                      # 0045f488
    mov ecx, dword ptr [ebp - local_28]          # 0045f48a
    mov byte ptr [ecx + field_2a2], al           # 0045f48d
    mov edx, dword ptr [ebp - local_28]          # 0045f493
    mov eax, dword ptr [edx + field_31d]         # 0045f496
    movsx ecx, word ptr [eax + field_993]        # 0045f49c
    {load} xor edx, edx                          # 0045f4a3
    test ecx, ecx                                # 0045f4a5
    setg dl                                      # 0045f4a7
    mov eax, dword ptr [ebp - local_28]          # 0045f4aa
    mov byte ptr [eax + field_324], dl           # 0045f4ad
    mov ecx, dword ptr [ebp - local_28]          # 0045f4b3
    mov edx, dword ptr [ecx + field_31d]         # 0045f4b6
    movsx eax, word ptr [edx + field_a9b]        # 0045f4bc
    {load} xor ecx, ecx                          # 0045f4c3
    test eax, eax                                # 0045f4c5
    setg cl                                      # 0045f4c7
    mov edx, dword ptr [ebp - local_28]          # 0045f4ca
    mov byte ptr [edx + field_325], cl           # 0045f4cd
    mov eax, dword ptr [ebp - local_28]          # 0045f4d3
    mov ecx, dword ptr [eax + field_31d]         # 0045f4d6
    mov edx, dword ptr [ebp - local_28]          # 0045f4dc
    mov eax, dword ptr [edx + field_31d]         # 0045f4df
    mov ecx, dword ptr [ecx + field_57]          # 0045f4e5
    sub ecx, dword ptr [eax + field_4f]          # 0045f4e8
    neg ecx                                      # 0045f4eb
    {load} sbb ecx, ecx                          # 0045f4ed
    neg ecx                                      # 0045f4ef
    mov edx, dword ptr [ebp - local_28]          # 0045f4f1
    mov byte ptr [edx + field_2a3], cl           # 0045f4f4
    mov eax, dword ptr [ebp - local_28]          # 0045f4fa
    mov ecx, dword ptr [eax + field_31d]         # 0045f4fd
    mov edx, dword ptr [ebp - local_28]          # 0045f503
    mov eax, dword ptr [edx + field_31d]         # 0045f506
    mov ecx, dword ptr [ecx + field_65f]         # 0045f50c
    sub ecx, dword ptr [eax + field_657]         # 0045f512
    neg ecx                                      # 0045f518
    {load} sbb ecx, ecx                          # 0045f51a
    neg ecx                                      # 0045f51c
    mov edx, dword ptr [ebp - local_28]          # 0045f51e
    mov byte ptr [edx + field_3ae], cl           # 0045f521
    mov eax, dword ptr [ebp - local_28]          # 0045f527
    mov ecx, dword ptr [eax + field_31d]         # 0045f52a
    movzx dx, byte ptr [ecx + field_23]          # 0045f530
    mov eax, dword ptr [ebp - local_28]          # 0045f535
    mov word ptr [eax + field_2a4], dx           # 0045f538
    mov ecx, dword ptr [ebp - local_28]          # 0045f53f
    mov word ptr [ecx + field_383], 0xffff       # 0045f542
    mov edx, dword ptr [ebp - local_28]          # 0045f54b
    mov word ptr [edx + field_381], 0xffff       # 0045f54e
    mov eax, dword ptr [ebp - local_28]          # 0045f557
    mov word ptr [eax + field_347], 0x8          # 0045f55a
    mov ecx, dword ptr [ebp - local_28]          # 0045f563
    mov word ptr [ecx + field_349], 0x2          # 0045f566
    mov edx, dword ptr [ebp - local_28]          # 0045f56f
    mov word ptr [edx + field_34b], 0x1          # 0045f572
    mov eax, dword ptr [ebp - local_28]          # 0045f57b
    mov word ptr [eax + field_34d], 0x1          # 0045f57e
    mov ecx, dword ptr [ebp - local_28]          # 0045f587
    mov dword ptr [ecx + field_34f], 0x1         # 0045f58a
    mov edx, dword ptr [ebp - local_28]          # 0045f594
    mov eax, dword ptr [edx + field_31d]         # 0045f597
    mov ecx, dword ptr [ebp - local_28]          # 0045f59d
    mov dx, word ptr [eax + field_f64]           # 0045f5a0
    mov word ptr [ecx + field_353], dx           # 0045f5a7
    mov eax, dword ptr [ebp - local_28]          # 0045f5ae
    mov ecx, dword ptr [eax + field_31d]         # 0045f5b1
    mov edx, dword ptr [ebp - local_28]          # 0045f5b7
    mov ax, word ptr [ecx + field_f66]           # 0045f5ba
    mov word ptr [edx + field_355], ax           # 0045f5c1
    mov ecx, dword ptr [ebp - local_28]          # 0045f5c8
    mov word ptr [ecx + field_373], 0x8          # 0045f5cb
    mov edx, dword ptr [ebp - local_28]          # 0045f5d4
    mov byte ptr [edx + field_39d], 0x0          # 0045f5d7
    mov eax, dword ptr [ebp - local_28]          # 0045f5de
    mov byte ptr [eax + field_2a8], 0x0          # 0045f5e1
    mov ecx, dword ptr [ebp - local_28]          # 0045f5e8
    mov byte ptr [ecx + field_2a9], 0x0          # 0045f5eb
    mov edx, dword ptr [ebp - local_28]          # 0045f5f2
    mov dword ptr [edx + field_39e], 0x4         # 0045f5f5
    mov eax, dword ptr [ebp - local_28]          # 0045f5ff
    movsx ecx, word ptr [eax + field_1e]         # 0045f602
    imul ecx, ecx, 0x8d                          # 0045f606
    mov dword ptr [ecx + 0x5bb632], 0x1          # 0045f60c
    jmp.d32 L_00460ede                           # 0045f616
L_0045f61b:
    # block 0x0045f61b: entered by je at 0x0045f10e, 8 instruction(s), ends with ja to 0x00460bde (forward)
    mov edx, dword ptr [ebp - local_28]          # 0045f61b
    mov eax, dword ptr [edx + field_39e]         # 0045f61e
    mov dword ptr [ebp - local_30], eax          # 0045f624
    mov ecx, dword ptr [ebp - local_30]          # 0045f627
    sub ecx, 0x1                                 # 0045f62a
    mov dword ptr [ebp - local_30], ecx          # 0045f62d
    cmp dword ptr [ebp - local_30], 0xb          # 0045f630
    ja.d32 L_00460bde                            # 0045f634
    # block 0x0045f63a: entered by fall-through of ja at 0x0045f634, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x460ee6]
    mov edx, dword ptr [ebp - local_30]          # 0045f63a
    jmp dword ptr [4*edx + SWTAB_00460ee6_VA]    # 0045f63d
L_0045f644:
    # block 0x0045f644: entered by switch case, 4 instruction(s), ends with jne to 0x0045f680 (forward)
    mov eax, dword ptr [ebp - local_28]          # 0045f644
    movsx ecx, word ptr [eax + field_2a4]        # 0045f647
    test ecx, ecx                                # 0045f64e
    jne.d8 L_0045f680                            # 0045f650
    # block 0x0045f652: entered by fall-through of jne at 0x0045f650, 8 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x0045f680
    call dword ptr [0x52a23c]                    # 0045f652
    add eax, 0x3e8                               # 0045f658
    mov edx, dword ptr [ebp - local_28]          # 0045f65d
    mov dword ptr [edx + field_375], eax         # 0045f660
    mov eax, dword ptr [ebp - local_28]          # 0045f666
    mov dword ptr [eax + field_39e], 0xb         # 0045f669
    mov ecx, dword ptr [ebp - local_28]          # 0045f673
    mov dword ptr [ecx + field_3a6], 0x5         # 0045f676
L_0045f680:
    # block 0x0045f680: entered by jne at 0x0045f650, 1 instruction(s), ends with forward jump to 0x00460bde
    jmp.d32 L_00460bde                           # 0045f680
L_0045f685:
    # block 0x0045f685: entered by switch case, 4 instruction(s), ends with jne to 0x0045f759 (forward)
    mov edx, dword ptr [ebp - local_28]          # 0045f685
    movsx eax, word ptr [edx + field_2a4]        # 0045f688
    cmp eax, 0x1                                 # 0045f68f
    jne.d32 L_0045f759                           # 0045f692
    # block 0x0045f698: entered by fall-through of jne at 0x0045f692, 16 instruction(s), calls FUN_0045ea4a, ends with je to 0x0045f747 (forward)
    push 0x1                                     # 0045f698
    mov ecx, dword ptr [ebp - local_28]          # 0045f69a
    call FUN_0045ea4a                            # 0045f69d
    mov ecx, dword ptr [ebp - local_28]          # 0045f6a2
    mov word ptr [ecx + field_381], 0x0          # 0045f6a5
    mov edx, dword ptr [ebp - local_28]          # 0045f6ae
    movsx eax, word ptr [edx + field_381]        # 0045f6b1
    mov ecx, dword ptr [ebp - local_28]          # 0045f6b8
    mov edx, dword ptr [ebp - local_28]          # 0045f6bb
    mov dx, word ptr [edx + field_29a]           # 0045f6be
    mov word ptr [ecx + 2*eax + field_383], dx   # 0045f6c5
    mov eax, dword ptr [ebp - local_28]          # 0045f6cd
    {load} xor ecx, ecx                          # 0045f6d0
    mov cl, byte ptr [eax + field_322]           # 0045f6d2
    test ecx, ecx                                # 0045f6d8
    je.d8 L_0045f747                             # 0045f6da
    # block 0x0045f6dc: entered by fall-through of je at 0x0045f6da, 11 instruction(s), calls FUN_0045e67d, ends with je to 0x0045f747 (forward)
    mov edx, dword ptr [ebp - local_28]          # 0045f6dc
    mov eax, dword ptr [edx + field_31d]         # 0045f6df
    mov ecx, dword ptr [ebp - local_28]          # 0045f6e5
    movsx edx, word ptr [ecx + field_29a]        # 0045f6e8
    imul edx, edx, 0x21                          # 0045f6ef
    lea eax, [eax + edx + field_f68]             # 0045f6f2
    push eax                                     # 0045f6f9
    mov ecx, dword ptr [ebp - local_28]          # 0045f6fa
    call FUN_0045e67d                            # 0045f6fd
    test eax, eax                                # 0045f702
    je.d8 L_0045f747                             # 0045f704
    # block 0x0045f706: entered by fall-through of je at 0x0045f704, 16 instruction(s), calls FUN_0045e6bd, ends with forward jump to 0x0045f754
    push 0x1                                     # 0045f706
    mov ecx, dword ptr [ebp - local_28]          # 0045f708
    add ecx, 0x326                               # 0045f70b
    push ecx                                     # 0045f711
    mov edx, dword ptr [ebp - local_28]          # 0045f712
    mov eax, dword ptr [edx + field_31d]         # 0045f715
    mov ecx, dword ptr [ebp - local_28]          # 0045f71b
    movsx edx, word ptr [ecx + field_29a]        # 0045f71e
    imul edx, edx, 0x21                          # 0045f725
    lea eax, [eax + edx + field_f68]             # 0045f728
    push eax                                     # 0045f72f
    mov ecx, dword ptr [ebp - local_28]          # 0045f730
    call FUN_0045e6bd                            # 0045f733
    mov ecx, dword ptr [ebp - local_28]          # 0045f738
    mov dword ptr [ecx + field_3a2], 0x6         # 0045f73b
    jmp.d8 L_0045f754                            # 0045f745
L_0045f747:
    # block 0x0045f747: entered by je at 0x0045f6da; je at 0x0045f704, 2 instruction(s), falls into the block at 0x0045f754
    mov edx, dword ptr [ebp - local_28]          # 0045f747
    mov dword ptr [edx + field_39e], 0x6         # 0045f74a
L_0045f754:
    # block 0x0045f754: entered by jmp at 0x0045f745, 1 instruction(s), ends with forward jump to 0x0045f7fb
    jmp.d32 L_0045f7fb                           # 0045f754
L_0045f759:
    # block 0x0045f759: entered by jne at 0x0045f692, 13 instruction(s), calls FUN_0045ea4a, FUN_0045eb76, ends with je to 0x0045f7ee (forward)
    push 0x0                                     # 0045f759
    mov ecx, dword ptr [ebp - local_28]          # 0045f75b
    call FUN_0045ea4a                            # 0045f75e
    mov eax, dword ptr [ebp - local_28]          # 0045f763
    add eax, 0x29a                               # 0045f766
    push eax                                     # 0045f76b
    mov ecx, dword ptr [ebp - local_28]          # 0045f76c
    call FUN_0045eb76                            # 0045f76f
    mov ecx, dword ptr [ebp - local_28]          # 0045f774
    {load} xor edx, edx                          # 0045f777
    mov dl, byte ptr [ecx + field_323]           # 0045f779
    test edx, edx                                # 0045f77f
    je.d8 L_0045f7ee                             # 0045f781
    # block 0x0045f783: entered by fall-through of je at 0x0045f781, 11 instruction(s), calls FUN_0045e67d, ends with je to 0x0045f7ee (forward)
    mov eax, dword ptr [ebp - local_28]          # 0045f783
    mov ecx, dword ptr [eax + field_31d]         # 0045f786
    mov edx, dword ptr [ebp - local_28]          # 0045f78c
    movsx eax, word ptr [edx + field_29a]        # 0045f78f
    imul eax, eax, 0x21                          # 0045f796
    lea ecx, [ecx + eax + field_c2b]             # 0045f799
    push ecx                                     # 0045f7a0
    mov ecx, dword ptr [ebp - local_28]          # 0045f7a1
    call FUN_0045e67d                            # 0045f7a4
    test eax, eax                                # 0045f7a9
    je.d8 L_0045f7ee                             # 0045f7ab
    # block 0x0045f7ad: entered by fall-through of je at 0x0045f7ab, 16 instruction(s), calls FUN_0045e6bd, ends with forward jump to 0x0045f7fb
    push 0x1                                     # 0045f7ad
    mov edx, dword ptr [ebp - local_28]          # 0045f7af
    add edx, 0x326                               # 0045f7b2
    push edx                                     # 0045f7b8
    mov eax, dword ptr [ebp - local_28]          # 0045f7b9
    mov ecx, dword ptr [eax + field_31d]         # 0045f7bc
    mov edx, dword ptr [ebp - local_28]          # 0045f7c2
    movsx eax, word ptr [edx + field_29a]        # 0045f7c5
    imul eax, eax, 0x21                          # 0045f7cc
    lea ecx, [ecx + eax + field_c2b]             # 0045f7cf
    push ecx                                     # 0045f7d6
    mov ecx, dword ptr [ebp - local_28]          # 0045f7d7
    call FUN_0045e6bd                            # 0045f7da
    mov edx, dword ptr [ebp - local_28]          # 0045f7df
    mov dword ptr [edx + field_3a2], 0x7         # 0045f7e2
    jmp.d8 L_0045f7fb                            # 0045f7ec
L_0045f7ee:
    # block 0x0045f7ee: entered by je at 0x0045f781; je at 0x0045f7ab, 2 instruction(s), falls into the block at 0x0045f7fb
    mov eax, dword ptr [ebp - local_28]          # 0045f7ee
    mov dword ptr [eax + field_39e], 0x7         # 0045f7f1
L_0045f7fb:
    # block 0x0045f7fb: entered by jmp at 0x0045f754; jmp at 0x0045f7ec, 1 instruction(s), ends with forward jump to 0x00460bde
    jmp.d32 L_00460bde                           # 0045f7fb
L_0045f800:
    # block 0x0045f800: entered by switch case, 5 instruction(s), ends with je to 0x0045f822 (forward)
    mov ecx, dword ptr [ebp - local_28]          # 0045f800
    {load} xor edx, edx                          # 0045f803
    mov dl, byte ptr [ecx + field_2ab]           # 0045f805
    test edx, edx                                # 0045f80b
    je.d8 L_0045f822                             # 0045f80d
    # block 0x0045f80f: entered by fall-through of je at 0x0045f80d, 6 instruction(s), calls FUN_0045ed60, ends with forward jump to 0x0045fbbe
    push 0x6                                     # 0045f80f
    push 0x1                                     # 0045f811
    push 0x0                                     # 0045f813
    mov ecx, dword ptr [ebp - local_28]          # 0045f815
    call FUN_0045ed60                            # 0045f818
    jmp.d32 L_0045fbbe                           # 0045f81d
L_0045f822:
    # block 0x0045f822: entered by je at 0x0045f80d, 5 instruction(s), ends with je to 0x0045f8a5 (forward)
    mov eax, dword ptr [ebp - local_28]          # 0045f822
    {load} xor ecx, ecx                          # 0045f825
    mov cl, byte ptr [eax + field_2d4]           # 0045f827
    test ecx, ecx                                # 0045f82d
    je.d8 L_0045f8a5                             # 0045f82f
    # block 0x0045f831: entered by fall-through of je at 0x0045f82f, 32 instruction(s), calls FUN_0045ef5a, FUN_0045e906, ends with forward jump to 0x0045fbbe
    mov edx, dword ptr [ebp - local_28]          # 0045f831
    mov byte ptr [edx + field_2ac], 0x1          # 0045f834
    mov eax, dword ptr [ebp - local_28]          # 0045f83b
    mov byte ptr [eax + field_2d4], 0x0          # 0045f83e
    push 0x6                                     # 0045f845
    mov ecx, dword ptr [ebp - local_28]          # 0045f847
    mov dx, word ptr [ecx + field_371]           # 0045f84a
    push edx                                     # 0045f851
    mov eax, dword ptr [ebp - local_28]          # 0045f852
    mov cx, word ptr [eax + field_29a]           # 0045f855
    push ecx                                     # 0045f85c
    push 0x1                                     # 0045f85d
    mov ecx, dword ptr [ebp - local_28]          # 0045f85f
    call FUN_0045ef5a                            # 0045f862
    mov edx, dword ptr [ebp - local_28]          # 0045f867
    mov ax, word ptr [edx + field_2a4]           # 0045f86a
    push eax                                     # 0045f871
    mov ecx, dword ptr [ebp - local_28]          # 0045f872
    movsx edx, word ptr [ecx + field_2a4]        # 0045f875
    neg edx                                      # 0045f87c
    {load} sbb edx, edx                          # 0045f87e
    inc edx                                      # 0045f880
    push edx                                     # 0045f881
    mov eax, dword ptr [ebp - local_28]          # 0045f882
    mov cx, word ptr [eax + field_371]           # 0045f885
    push ecx                                     # 0045f88c
    mov edx, dword ptr [ebp - local_28]          # 0045f88d
    mov ax, word ptr [edx + field_29a]           # 0045f890
    push eax                                     # 0045f897
    mov ecx, dword ptr [ebp - local_28]          # 0045f898
    call FUN_0045e906                            # 0045f89b
    jmp.d32 L_0045fbbe                           # 0045f8a0
L_0045f8a5:
    # block 0x0045f8a5: entered by je at 0x0045f82f, 3 instruction(s), falls into the block at 0x0045f8b8
    mov ecx, dword ptr [ebp - local_28]          # 0045f8a5
    mov word ptr [ecx + field_371], 0xffff       # 0045f8a8
    mov dword ptr [ebp - local_14], 0x0          # 0045f8b1
L_0045f8b8:
    # block 0x0045f8b8: entered by jmp at 0x0045f99e, 2 instruction(s), ends with jne to 0x0045f9a3 (forward)
    cmp dword ptr [ebp - local_14], 0x0          # 0045f8b8
    jne.d32 L_0045f9a3                           # 0045f8bc
    # block 0x0045f8c2: entered by fall-through of jne at 0x0045f8bc, 16 instruction(s), calls FUN_0045e9db, ends with je to 0x0045f997 (forward)
    mov edx, dword ptr [ebp - local_28]          # 0045f8c2
    add edx, 0x371                               # 0045f8c5
    push edx                                     # 0045f8cb
    mov eax, dword ptr [ebp - local_28]          # 0045f8cc
    movsx ecx, word ptr [eax + field_2a4]        # 0045f8cf
    neg ecx                                      # 0045f8d6
    {load} sbb ecx, ecx                          # 0045f8d8
    inc ecx                                      # 0045f8da
    push ecx                                     # 0045f8db
    mov edx, dword ptr [ebp - local_28]          # 0045f8dc
    mov ax, word ptr [edx + field_29a]           # 0045f8df
    push eax                                     # 0045f8e6
    mov ecx, dword ptr [ebp - local_28]          # 0045f8e7
    call FUN_0045e9db                            # 0045f8ea
    test eax, eax                                # 0045f8ef
    je.d32 L_0045f997                            # 0045f8f1
    # block 0x0045f8f7: entered by fall-through of je at 0x0045f8f1, 5 instruction(s), ends with jne to 0x0045f941 (forward)
    mov ecx, dword ptr [ebp - local_28]          # 0045f8f7
    {load} xor edx, edx                          # 0045f8fa
    mov dl, byte ptr [ecx + field_324]           # 0045f8fc
    test edx, edx                                # 0045f902
    jne.d8 L_0045f941                            # 0045f904
    # block 0x0045f906: entered by fall-through of jne at 0x0045f904, 18 instruction(s), calls FUN_0045e906, ends with forward jump to 0x0045f995
    mov eax, dword ptr [ebp - local_28]          # 0045f906
    mov cx, word ptr [eax + field_2a4]           # 0045f909
    push ecx                                     # 0045f910
    mov edx, dword ptr [ebp - local_28]          # 0045f911
    movsx eax, word ptr [edx + field_2a4]        # 0045f914
    neg eax                                      # 0045f91b
    {load} sbb eax, eax                          # 0045f91d
    inc eax                                      # 0045f91f
    push eax                                     # 0045f920
    mov ecx, dword ptr [ebp - local_28]          # 0045f921
    mov dx, word ptr [ecx + field_371]           # 0045f924
    push edx                                     # 0045f92b
    mov eax, dword ptr [ebp - local_28]          # 0045f92c
    mov cx, word ptr [eax + field_29a]           # 0045f92f
    push ecx                                     # 0045f936
    mov ecx, dword ptr [ebp - local_28]          # 0045f937
    call FUN_0045e906                            # 0045f93a
    jmp.d8 L_0045f995                            # 0045f93f
L_0045f941:
    # block 0x0045f941: entered by jne at 0x0045f904, 15 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x0045f995
    mov edx, dword ptr [ebp - local_28]          # 0045f941
    mov word ptr [edx + field_2cf], 0x0          # 0045f944
    mov eax, dword ptr [ebp - local_28]          # 0045f94d
    mov byte ptr [eax + field_29c], 0x1          # 0045f950
    mov ecx, dword ptr [ebp - local_28]          # 0045f957
    mov word ptr [ecx + field_29f], 0x0          # 0045f95a
    call dword ptr [0x52a23c]                    # 0045f963
    mov edx, dword ptr [ebp - local_28]          # 0045f969
    mov ecx, dword ptr [edx + field_31d]         # 0045f96c
    add eax, dword ptr [ecx + field_997]         # 0045f972
    mov edx, dword ptr [ebp - local_28]          # 0045f978
    mov dword ptr [edx + field_379], eax         # 0045f97b
    mov eax, dword ptr [ebp - local_28]          # 0045f981
    mov dword ptr [eax + field_39e], 0x1         # 0045f984
    mov dword ptr [ebp - local_14], 0x1          # 0045f98e
L_0045f995:
    # block 0x0045f995: entered by jmp at 0x0045f93f, 1 instruction(s), ends with forward jump to 0x0045f99e
    jmp.d8 L_0045f99e                            # 0045f995
L_0045f997:
    # block 0x0045f997: entered by je at 0x0045f8f1, 1 instruction(s), falls into the block at 0x0045f99e
    mov dword ptr [ebp - local_14], 0x1          # 0045f997
L_0045f99e:
    # block 0x0045f99e: entered by jmp at 0x0045f995, 1 instruction(s), ends with backward jump to 0x0045f8b8
    jmp.d32 L_0045f8b8                           # 0045f99e
L_0045f9a3:
    # block 0x0045f9a3: entered by jne at 0x0045f8bc, 4 instruction(s), ends with je to 0x0045fa6a (forward)
    mov ecx, dword ptr [ebp - local_28]          # 0045f9a3
    movsx edx, word ptr [ecx + field_371]        # 0045f9a6
    cmp edx, -0x1                                # 0045f9ad
    je.d32 L_0045fa6a                            # 0045f9b0
    # block 0x0045f9b6: entered by fall-through of je at 0x0045f9b0, 5 instruction(s), ends with jne to 0x0045fa6a (forward)
    mov eax, dword ptr [ebp - local_28]          # 0045f9b6
    {load} xor ecx, ecx                          # 0045f9b9
    mov cl, byte ptr [eax + field_29c]           # 0045f9bb
    test ecx, ecx                                # 0045f9c1
    jne.d32 L_0045fa6a                           # 0045f9c3
    # block 0x0045f9c9: entered by fall-through of jne at 0x0045f9c3, 26 instruction(s), calls FUN_0045e6bd, ends with jne to 0x0045fa40 (forward)
    push 0x3                                     # 0045f9c9
    mov edx, dword ptr [ebp - local_28]          # 0045f9cb
    add edx, 0x326                               # 0045f9ce
    push edx                                     # 0045f9d4
    mov eax, dword ptr [ebp - local_28]          # 0045f9d5
    mov ecx, dword ptr [eax + field_31d]         # 0045f9d8
    mov edx, dword ptr [ebp - local_28]          # 0045f9de
    movsx eax, word ptr [edx + field_2a4]        # 0045f9e1
    neg eax                                      # 0045f9e8
    {load} sbb eax, eax                          # 0045f9ea
    inc eax                                      # 0045f9ec
    imul eax, eax, 0x33d                         # 0045f9ed
    lea ecx, [ecx + eax + field_e7d]             # 0045f9f3
    push ecx                                     # 0045f9fa
    mov ecx, dword ptr [ebp - local_28]          # 0045f9fb
    call FUN_0045e6bd                            # 0045f9fe
    mov edx, dword ptr [ebp - local_28]          # 0045fa03
    movsx eax, word ptr [edx + field_2a4]        # 0045fa06
    imul eax, eax, 0x120                         # 0045fa0d
    mov ecx, dword ptr [ebp - local_28]          # 0045fa13
    lea edx, [ecx + eax + field_24]              # 0045fa16
    mov eax, dword ptr [ebp - local_28]          # 0045fa1a
    movsx ecx, word ptr [eax + field_29a]        # 0045fa1d
    movsx edx, word ptr [edx + 2*ecx + field_d0] # 0045fa24
    cmp edx, 0x3                                 # 0045fa2c
    jne.d8 L_0045fa40                            # 0045fa2f
    # block 0x0045fa31: entered by fall-through of jne at 0x0045fa2f, 3 instruction(s), ends with forward jump to 0x0045fa4d
    mov eax, dword ptr [ebp - local_28]          # 0045fa31
    mov dword ptr [eax + field_3a2], 0x8         # 0045fa34
    jmp.d8 L_0045fa4d                            # 0045fa3e
L_0045fa40:
    # block 0x0045fa40: entered by jne at 0x0045fa2f, 2 instruction(s), falls into the block at 0x0045fa4d
    mov ecx, dword ptr [ebp - local_28]          # 0045fa40
    mov dword ptr [ecx + field_3a2], 0x4         # 0045fa43
L_0045fa4d:
    # block 0x0045fa4d: entered by jmp at 0x0045fa3e, 9 instruction(s), calls FUN_0045eadc, ends with forward jump to 0x0045fbbe
    mov edx, dword ptr [ebp - local_28]          # 0045fa4d
    movsx eax, word ptr [edx + field_2a4]        # 0045fa50
    neg eax                                      # 0045fa57
    {load} sbb eax, eax                          # 0045fa59
    inc eax                                      # 0045fa5b
    push eax                                     # 0045fa5c
    mov ecx, dword ptr [ebp - local_28]          # 0045fa5d
    call FUN_0045eadc                            # 0045fa60
    jmp.d32 L_0045fbbe                           # 0045fa65
L_0045fa6a:
    # block 0x0045fa6a: entered by je at 0x0045f9b0; jne at 0x0045f9c3, 4 instruction(s), ends with jne to 0x0045fafd (forward)
    mov ecx, dword ptr [ebp - local_28]          # 0045fa6a
    movsx edx, word ptr [ecx + field_371]        # 0045fa6d
    cmp edx, -0x1                                # 0045fa74
    jne.d32 L_0045fafd                           # 0045fa77
    # block 0x0045fa7d: entered by fall-through of jne at 0x0045fa77, 5 instruction(s), ends with je to 0x0045fafd (forward)
    mov eax, dword ptr [ebp - local_28]          # 0045fa7d
    {load} xor ecx, ecx                          # 0045fa80
    mov cl, byte ptr [eax + field_29c]           # 0045fa82
    test ecx, ecx                                # 0045fa88
    je.d8 L_0045fafd                             # 0045fa8a
    # block 0x0045fa8c: entered by fall-through of je at 0x0045fa8a, 10 instruction(s), ends with jne to 0x0045fac9 (forward)
    mov edx, dword ptr [ebp - local_28]          # 0045fa8c
    movsx eax, word ptr [edx + field_2a4]        # 0045fa8f
    imul eax, eax, 0x120                         # 0045fa96
    mov ecx, dword ptr [ebp - local_28]          # 0045fa9c
    lea edx, [ecx + eax + field_24]              # 0045fa9f
    mov eax, dword ptr [ebp - local_28]          # 0045faa3
    movsx ecx, word ptr [eax + field_29a]        # 0045faa6
    movsx edx, word ptr [edx + 2*ecx + field_d0] # 0045faad
    cmp edx, 0x3                                 # 0045fab5
    jne.d8 L_0045fac9                            # 0045fab8
    # block 0x0045faba: entered by fall-through of jne at 0x0045fab8, 3 instruction(s), ends with forward jump to 0x0045fad6
    mov eax, dword ptr [ebp - local_28]          # 0045faba
    mov dword ptr [eax + field_39e], 0x8         # 0045fabd
    jmp.d8 L_0045fad6                            # 0045fac7
L_0045fac9:
    # block 0x0045fac9: entered by jne at 0x0045fab8, 2 instruction(s), falls into the block at 0x0045fad6
    mov ecx, dword ptr [ebp - local_28]          # 0045fac9
    mov dword ptr [ecx + field_39e], 0x4         # 0045facc
L_0045fad6:
    # block 0x0045fad6: entered by jmp at 0x0045fac7, 11 instruction(s), calls FUN_0045eadc, ends with forward jump to 0x0045fbbe
    mov edx, dword ptr [ebp - local_28]          # 0045fad6
    mov byte ptr [edx + field_29c], 0x0          # 0045fad9
    mov eax, dword ptr [ebp - local_28]          # 0045fae0
    movsx ecx, word ptr [eax + field_2a4]        # 0045fae3
    neg ecx                                      # 0045faea
    {load} sbb ecx, ecx                          # 0045faec
    inc ecx                                      # 0045faee
    push ecx                                     # 0045faef
    mov ecx, dword ptr [ebp - local_28]          # 0045faf0
    call FUN_0045eadc                            # 0045faf3
    jmp.d32 L_0045fbbe                           # 0045faf8
L_0045fafd:
    # block 0x0045fafd: entered by jne at 0x0045fa77; je at 0x0045fa8a, 4 instruction(s), ends with jne to 0x0045fbbe (forward)
    mov edx, dword ptr [ebp - local_28]          # 0045fafd
    movsx eax, word ptr [edx + field_371]        # 0045fb00
    cmp eax, -0x1                                # 0045fb07
    jne.d32 L_0045fbbe                           # 0045fb0a
    # block 0x0045fb10: entered by fall-through of jne at 0x0045fb0a, 5 instruction(s), ends with je to 0x0045fb6e (forward)
    mov ecx, dword ptr [ebp - local_28]          # 0045fb10
    {load} xor edx, edx                          # 0045fb13
    mov dl, byte ptr [ecx + field_325]           # 0045fb15
    test edx, edx                                # 0045fb1b
    je.d8 L_0045fb6e                             # 0045fb1d
    # block 0x0045fb1f: entered by fall-through of je at 0x0045fb1d, 15 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x0045fbb4
    mov eax, dword ptr [ebp - local_28]          # 0045fb1f
    mov word ptr [eax + field_2cf], 0x0          # 0045fb22
    mov ecx, dword ptr [ebp - local_28]          # 0045fb2b
    mov word ptr [ecx + field_29f], 0x0          # 0045fb2e
    mov edx, dword ptr [ebp - local_28]          # 0045fb37
    mov byte ptr [edx + field_29d], 0x1          # 0045fb3a
    call dword ptr [0x52a23c]                    # 0045fb41
    mov ecx, dword ptr [ebp - local_28]          # 0045fb47
    mov edx, dword ptr [ecx + field_31d]         # 0045fb4a
    add eax, dword ptr [edx + field_a9f]         # 0045fb50
    mov ecx, dword ptr [ebp - local_28]          # 0045fb56
    mov dword ptr [ecx + field_379], eax         # 0045fb59
    mov edx, dword ptr [ebp - local_28]          # 0045fb5f
    mov dword ptr [edx + field_39e], 0x2         # 0045fb62
    jmp.d8 L_0045fbb4                            # 0045fb6c
L_0045fb6e:
    # block 0x0045fb6e: entered by je at 0x0045fb1d, 18 instruction(s), calls FUN_0045e6bd, falls into the block at 0x0045fbb4
    push 0x5                                     # 0045fb6e
    mov eax, dword ptr [ebp - local_28]          # 0045fb70
    add eax, 0x326                               # 0045fb73
    push eax                                     # 0045fb78
    mov ecx, dword ptr [ebp - local_28]          # 0045fb79
    mov edx, dword ptr [ecx + field_31d]         # 0045fb7c
    mov eax, dword ptr [ebp - local_28]          # 0045fb82
    movsx ecx, word ptr [eax + field_2a4]        # 0045fb85
    neg ecx                                      # 0045fb8c
    {load} sbb ecx, ecx                          # 0045fb8e
    inc ecx                                      # 0045fb90
    imul ecx, ecx, 0x33d                         # 0045fb91
    lea edx, [edx + ecx + field_dd8]             # 0045fb97
    push edx                                     # 0045fb9e
    mov ecx, dword ptr [ebp - local_28]          # 0045fb9f
    call FUN_0045e6bd                            # 0045fba2
    mov eax, dword ptr [ebp - local_28]          # 0045fba7
    mov dword ptr [eax + field_3a2], 0x9         # 0045fbaa
L_0045fbb4:
    # block 0x0045fbb4: entered by jmp at 0x0045fb6c, 2 instruction(s), falls into the block at 0x0045fbbe
    mov ecx, dword ptr [ebp - local_28]          # 0045fbb4
    mov byte ptr [ecx + field_3ab], 0x1          # 0045fbb7
L_0045fbbe:
    # block 0x0045fbbe: entered by jmp at 0x0045f81d; jmp at 0x0045f8a0; jmp at 0x0045fa65; jmp at 0x0045faf8; more, 1 instruction(s), ends with forward jump to 0x00460bde
    jmp.d32 L_00460bde                           # 0045fbbe
L_0045fbc3:
    # block 0x0045fbc3: entered by switch case, 5 instruction(s), ends with je to 0x0045fc6f (forward)
    mov edx, dword ptr [ebp - local_28]          # 0045fbc3
    {load} xor eax, eax                          # 0045fbc6
    mov al, byte ptr [edx + field_324]           # 0045fbc8
    test eax, eax                                # 0045fbce
    je.d32 L_0045fc6f                            # 0045fbd0
    # block 0x0045fbd6: entered by fall-through of je at 0x0045fbd0, 5 instruction(s), ends with jne to 0x0045fc6f (forward)
    mov ecx, dword ptr [ebp - local_28]          # 0045fbd6
    {load} xor edx, edx                          # 0045fbd9
    mov dl, byte ptr [ecx + field_29c]           # 0045fbdb
    test edx, edx                                # 0045fbe1
    jne.d32 L_0045fc6f                           # 0045fbe3
    # block 0x0045fbe9: entered by fall-through of jne at 0x0045fbe3, 28 instruction(s), calls KERNEL32.dll!GetTickCount, FUN_0045e9db, ends with forward jump to 0x004600d1
    mov eax, dword ptr [ebp - local_28]          # 0045fbe9
    mov word ptr [eax + field_2cf], 0x0          # 0045fbec
    mov ecx, dword ptr [ebp - local_28]          # 0045fbf5
    mov byte ptr [ecx + field_29c], 0x1          # 0045fbf8
    mov edx, dword ptr [ebp - local_28]          # 0045fbff
    mov word ptr [edx + field_29f], 0x0          # 0045fc02
    call dword ptr [0x52a23c]                    # 0045fc0b
    mov ecx, dword ptr [ebp - local_28]          # 0045fc11
    mov edx, dword ptr [ecx + field_31d]         # 0045fc14
    add eax, dword ptr [edx + field_997]         # 0045fc1a
    mov ecx, dword ptr [ebp - local_28]          # 0045fc20
    mov dword ptr [ecx + field_379], eax         # 0045fc23
    mov edx, dword ptr [ebp - local_28]          # 0045fc29
    mov dword ptr [edx + field_39e], 0x1         # 0045fc2c
    mov eax, dword ptr [ebp - local_28]          # 0045fc36
    mov word ptr [eax + field_2cd], 0x0          # 0045fc39
    mov ecx, dword ptr [ebp - local_28]          # 0045fc42
    add ecx, 0x371                               # 0045fc45
    push ecx                                     # 0045fc4b
    mov edx, dword ptr [ebp - local_28]          # 0045fc4c
    mov ax, word ptr [edx + field_2a4]           # 0045fc4f
    push eax                                     # 0045fc56
    mov ecx, dword ptr [ebp - local_28]          # 0045fc57
    mov dx, word ptr [ecx + field_29a]           # 0045fc5a
    push edx                                     # 0045fc61
    mov ecx, dword ptr [ebp - local_28]          # 0045fc62
    call FUN_0045e9db                            # 0045fc65
    jmp.d32 L_004600d1                           # 0045fc6a
L_0045fc6f:
    # block 0x0045fc6f: entered by je at 0x0045fbd0; jne at 0x0045fbe3, 5 instruction(s), ends with jne to 0x0045fc9c (forward)
    mov eax, dword ptr [ebp - local_28]          # 0045fc6f
    {load} xor ecx, ecx                          # 0045fc72
    mov cl, byte ptr [eax + field_2ab]           # 0045fc74
    test ecx, ecx                                # 0045fc7a
    jne.d8 L_0045fc9c                            # 0045fc7c
    # block 0x0045fc7e: entered by fall-through of jne at 0x0045fc7c, 4 instruction(s), ends with jne to 0x0045fce0 (forward)
    mov edx, dword ptr [ebp - local_28]          # 0045fc7e
    movsx eax, word ptr [edx + field_2cd]        # 0045fc81
    cmp eax, 0x1                                 # 0045fc88
    jne.d8 L_0045fce0                            # 0045fc8b
    # block 0x0045fc8d: entered by fall-through of jne at 0x0045fc8b, 5 instruction(s), ends with jne to 0x0045fce0 (forward)
    mov ecx, dword ptr [ebp - local_28]          # 0045fc8d
    {load} xor edx, edx                          # 0045fc90
    mov dl, byte ptr [ecx + field_3ad]           # 0045fc92
    test edx, edx                                # 0045fc98
    jne.d8 L_0045fce0                            # 0045fc9a
L_0045fc9c:
    # block 0x0045fc9c: entered by jne at 0x0045fc7c; fall-through of jne at 0x0045fc9a, 14 instruction(s), calls FUN_0045ed60, ends with jne to 0x0045fcdb (forward)
    mov eax, dword ptr [ebp - local_28]          # 0045fc9c
    mov byte ptr [eax + field_2ab], 0x0          # 0045fc9f
    push 0x7                                     # 0045fca6
    mov ecx, dword ptr [ebp - local_28]          # 0045fca8
    movsx edx, word ptr [ecx + field_2cd]        # 0045fcab
    add edx, 0x1                                 # 0045fcb2
    push edx                                     # 0045fcb5
    push 0x0                                     # 0045fcb6
    mov ecx, dword ptr [ebp - local_28]          # 0045fcb8
    call FUN_0045ed60                            # 0045fcbb
    mov eax, dword ptr [ebp - local_28]          # 0045fcc0
    movsx ecx, word ptr [eax + field_2cd]        # 0045fcc3
    cmp ecx, 0x1                                 # 0045fcca
    jne.d8 L_0045fcdb                            # 0045fccd
    # block 0x0045fccf: entered by fall-through of jne at 0x0045fccd, 2 instruction(s), falls into the block at 0x0045fcdb
    mov edx, dword ptr [ebp - local_28]          # 0045fccf
    mov word ptr [edx + field_2cd], 0x0          # 0045fcd2
L_0045fcdb:
    # block 0x0045fcdb: entered by jne at 0x0045fccd, 1 instruction(s), ends with forward jump to 0x004600d1
    jmp.d32 L_004600d1                           # 0045fcdb
L_0045fce0:
    # block 0x0045fce0: entered by jne at 0x0045fc8b; jne at 0x0045fc9a, 5 instruction(s), ends with je to 0x0045fd88 (forward)
    mov eax, dword ptr [ebp - local_28]          # 0045fce0
    {load} xor ecx, ecx                          # 0045fce3
    mov cl, byte ptr [eax + field_324]           # 0045fce5
    test ecx, ecx                                # 0045fceb
    je.d32 L_0045fd88                            # 0045fced
    # block 0x0045fcf3: entered by fall-through of je at 0x0045fced, 5 instruction(s), ends with je to 0x0045fd88 (forward)
    mov edx, dword ptr [ebp - local_28]          # 0045fcf3
    {load} xor eax, eax                          # 0045fcf6
    mov al, byte ptr [edx + field_3ad]           # 0045fcf8
    test eax, eax                                # 0045fcfe
    je.d32 L_0045fd88                            # 0045fd00
    # block 0x0045fd06: entered by fall-through of je at 0x0045fd00, 34 instruction(s), calls FUN_0045ed60, ends with forward jump to 0x004600d1
    mov ecx, dword ptr [ebp - local_28]          # 0045fd06
    mov edx, dword ptr [ecx + field_31d]         # 0045fd09
    mov eax, dword ptr [ebp - local_28]          # 0045fd0f
    movsx ecx, word ptr [eax + field_371]        # 0045fd12
    imul ecx, ecx, 0xd0                          # 0045fd19
    lea edx, [edx + ecx + field_6b]              # 0045fd1f
    mov eax, dword ptr [ebp - local_28]          # 0045fd23
    movsx ecx, word ptr [eax + field_29a]        # 0045fd26
    shl ecx, 0x4                                 # 0045fd2d
    {load} add edx, ecx                          # 0045fd30
    mov eax, dword ptr [ebp - local_28]          # 0045fd32
    movsx ecx, word ptr [eax + field_2cd]        # 0045fd35
    shl ecx, 0x4                                 # 0045fd3c
    mov eax, dword ptr [ebp - local_28]          # 0045fd3f
    lea ecx, [eax + ecx + field_2ad]             # 0045fd42
    mov eax, dword ptr [edx]                     # 0045fd49
    mov dword ptr [ecx], eax                     # 0045fd4b
    mov eax, dword ptr [edx + field_4]           # 0045fd4d
    mov dword ptr [ecx + field_4], eax           # 0045fd50
    mov eax, dword ptr [edx + field_8]           # 0045fd53
    mov dword ptr [ecx + field_8], eax           # 0045fd56
    mov edx, dword ptr [edx + field_c]           # 0045fd59
    mov dword ptr [ecx + field_c], edx           # 0045fd5c
    push 0x7                                     # 0045fd5f
    mov eax, dword ptr [ebp - local_28]          # 0045fd61
    movsx ecx, word ptr [eax + field_2cd]        # 0045fd64
    add ecx, 0x1                                 # 0045fd6b
    push ecx                                     # 0045fd6e
    push 0x1                                     # 0045fd6f
    mov ecx, dword ptr [ebp - local_28]          # 0045fd71
    call FUN_0045ed60                            # 0045fd74
    mov edx, dword ptr [ebp - local_28]          # 0045fd79
    mov byte ptr [edx + field_3ad], 0x0          # 0045fd7c
    jmp.d32 L_004600d1                           # 0045fd83
L_0045fd88:
    # block 0x0045fd88: entered by je at 0x0045fced; je at 0x0045fd00, 3 instruction(s), falls into the block at 0x0045fd9b
    mov eax, dword ptr [ebp - local_28]          # 0045fd88
    mov word ptr [eax + field_371], 0xffff       # 0045fd8b
    mov dword ptr [ebp - local_14], 0x0          # 0045fd94
L_0045fd9b:
    # block 0x0045fd9b: entered by jmp at 0x0045fe91, 2 instruction(s), ends with jne to 0x0045fe96 (forward)
    cmp dword ptr [ebp - local_14], 0x0          # 0045fd9b
    jne.d32 L_0045fe96                           # 0045fd9f
    # block 0x0045fda5: entered by fall-through of jne at 0x0045fd9f, 16 instruction(s), calls FUN_0045e9db, ends with je to 0x0045fe8a (forward)
    mov ecx, dword ptr [ebp - local_28]          # 0045fda5
    add ecx, 0x371                               # 0045fda8
    push ecx                                     # 0045fdae
    mov edx, dword ptr [ebp - local_28]          # 0045fdaf
    movsx eax, word ptr [edx + field_2a4]        # 0045fdb2
    neg eax                                      # 0045fdb9
    {load} sbb eax, eax                          # 0045fdbb
    inc eax                                      # 0045fdbd
    push eax                                     # 0045fdbe
    mov ecx, dword ptr [ebp - local_28]          # 0045fdbf
    mov dx, word ptr [ecx + field_29a]           # 0045fdc2
    push edx                                     # 0045fdc9
    mov ecx, dword ptr [ebp - local_28]          # 0045fdca
    call FUN_0045e9db                            # 0045fdcd
    test eax, eax                                # 0045fdd2
    je.d32 L_0045fe8a                            # 0045fdd4
    # block 0x0045fdda: entered by fall-through of je at 0x0045fdd4, 5 instruction(s), ends with je to 0x0045fe4f (forward)
    mov eax, dword ptr [ebp - local_28]          # 0045fdda
    {load} xor ecx, ecx                          # 0045fddd
    mov cl, byte ptr [eax + field_29c]           # 0045fddf
    test ecx, ecx                                # 0045fde5
    je.d8 L_0045fe4f                             # 0045fde7
    # block 0x0045fde9: entered by fall-through of je at 0x0045fde7, 5 instruction(s), ends with jne to 0x0045fe06 (forward)
    mov edx, dword ptr [ebp - local_28]          # 0045fde9
    {load} xor eax, eax                          # 0045fdec
    mov al, byte ptr [edx + field_3ac]           # 0045fdee
    test eax, eax                                # 0045fdf4
    jne.d8 L_0045fe06                            # 0045fdf6
    # block 0x0045fdf8: entered by fall-through of jne at 0x0045fdf6, 3 instruction(s), ends with forward jump to 0x0045fe12
    mov ecx, dword ptr [ebp - local_28]          # 0045fdf8
    mov word ptr [ecx + field_2cd], 0x0          # 0045fdfb
    jmp.d8 L_0045fe12                            # 0045fe04
L_0045fe06:
    # block 0x0045fe06: entered by jne at 0x0045fdf6, 2 instruction(s), falls into the block at 0x0045fe12
    mov edx, dword ptr [ebp - local_28]          # 0045fe06
    mov word ptr [edx + field_2cd], 0x1          # 0045fe09
L_0045fe12:
    # block 0x0045fe12: entered by jmp at 0x0045fe04, 15 instruction(s), calls FUN_0045ef5a, falls into the block at 0x0045fe4f
    push 0x7                                     # 0045fe12
    mov eax, dword ptr [ebp - local_28]          # 0045fe14
    mov cx, word ptr [eax + field_371]           # 0045fe17
    push ecx                                     # 0045fe1e
    mov edx, dword ptr [ebp - local_28]          # 0045fe1f
    mov ax, word ptr [edx + field_29a]           # 0045fe22
    push eax                                     # 0045fe29
    push 0x0                                     # 0045fe2a
    mov ecx, dword ptr [ebp - local_28]          # 0045fe2c
    call FUN_0045ef5a                            # 0045fe2f
    mov ecx, dword ptr [ebp - local_28]          # 0045fe34
    mov byte ptr [ecx + field_3ac], 0x1          # 0045fe37
    mov edx, dword ptr [ebp - local_28]          # 0045fe3e
    mov byte ptr [edx + field_3ad], 0x1          # 0045fe41
    mov dword ptr [ebp - local_14], 0x1          # 0045fe48
L_0045fe4f:
    # block 0x0045fe4f: entered by je at 0x0045fde7, 18 instruction(s), calls FUN_0045e906, ends with forward jump to 0x0045fe91
    mov eax, dword ptr [ebp - local_28]          # 0045fe4f
    mov cx, word ptr [eax + field_2a4]           # 0045fe52
    push ecx                                     # 0045fe59
    mov edx, dword ptr [ebp - local_28]          # 0045fe5a
    movsx eax, word ptr [edx + field_2a4]        # 0045fe5d
    neg eax                                      # 0045fe64
    {load} sbb eax, eax                          # 0045fe66
    inc eax                                      # 0045fe68
    push eax                                     # 0045fe69
    mov ecx, dword ptr [ebp - local_28]          # 0045fe6a
    mov dx, word ptr [ecx + field_371]           # 0045fe6d
    push edx                                     # 0045fe74
    mov eax, dword ptr [ebp - local_28]          # 0045fe75
    mov cx, word ptr [eax + field_29a]           # 0045fe78
    push ecx                                     # 0045fe7f
    mov ecx, dword ptr [ebp - local_28]          # 0045fe80
    call FUN_0045e906                            # 0045fe83
    jmp.d8 L_0045fe91                            # 0045fe88
L_0045fe8a:
    # block 0x0045fe8a: entered by je at 0x0045fdd4, 1 instruction(s), falls into the block at 0x0045fe91
    mov dword ptr [ebp - local_14], 0x1          # 0045fe8a
L_0045fe91:
    # block 0x0045fe91: entered by jmp at 0x0045fe88, 1 instruction(s), ends with backward jump to 0x0045fd9b
    jmp.d32 L_0045fd9b                           # 0045fe91
L_0045fe96:
    # block 0x0045fe96: entered by jne at 0x0045fd9f, 4 instruction(s), ends with je to 0x0045ff5c (forward)
    mov edx, dword ptr [ebp - local_28]          # 0045fe96
    movsx eax, word ptr [edx + field_371]        # 0045fe99
    cmp eax, -0x1                                # 0045fea0
    je.d32 L_0045ff5c                            # 0045fea3
    # block 0x0045fea9: entered by fall-through of je at 0x0045fea3, 5 instruction(s), ends with jne to 0x0045ff5c (forward)
    mov ecx, dword ptr [ebp - local_28]          # 0045fea9
    {load} xor edx, edx                          # 0045feac
    mov dl, byte ptr [ecx + field_29c]           # 0045feae
    test edx, edx                                # 0045feb4
    jne.d32 L_0045ff5c                           # 0045feb6
    # block 0x0045febc: entered by fall-through of jne at 0x0045feb6, 26 instruction(s), calls FUN_0045e6bd, ends with jne to 0x0045ff32 (forward)
    push 0x3                                     # 0045febc
    mov eax, dword ptr [ebp - local_28]          # 0045febe
    add eax, 0x326                               # 0045fec1
    push eax                                     # 0045fec6
    mov ecx, dword ptr [ebp - local_28]          # 0045fec7
    mov edx, dword ptr [ecx + field_31d]         # 0045feca
    mov eax, dword ptr [ebp - local_28]          # 0045fed0
    movsx ecx, word ptr [eax + field_2a4]        # 0045fed3
    neg ecx                                      # 0045feda
    {load} sbb ecx, ecx                          # 0045fedc
    inc ecx                                      # 0045fede
    imul ecx, ecx, 0x33d                         # 0045fedf
    lea edx, [edx + ecx + field_e7d]             # 0045fee5
    push edx                                     # 0045feec
    mov ecx, dword ptr [ebp - local_28]          # 0045feed
    call FUN_0045e6bd                            # 0045fef0
    mov eax, dword ptr [ebp - local_28]          # 0045fef5
    movsx ecx, word ptr [eax + field_2a4]        # 0045fef8
    imul ecx, ecx, 0x120                         # 0045feff
    mov edx, dword ptr [ebp - local_28]          # 0045ff05
    lea eax, [edx + ecx + field_24]              # 0045ff08
    mov ecx, dword ptr [ebp - local_28]          # 0045ff0c
    movsx edx, word ptr [ecx + field_29a]        # 0045ff0f
    movsx eax, word ptr [eax + 2*edx + field_d0] # 0045ff16
    cmp eax, 0x3                                 # 0045ff1e
    jne.d8 L_0045ff32                            # 0045ff21
    # block 0x0045ff23: entered by fall-through of jne at 0x0045ff21, 3 instruction(s), ends with forward jump to 0x0045ff3f
    mov ecx, dword ptr [ebp - local_28]          # 0045ff23
    mov dword ptr [ecx + field_3a2], 0x8         # 0045ff26
    jmp.d8 L_0045ff3f                            # 0045ff30
L_0045ff32:
    # block 0x0045ff32: entered by jne at 0x0045ff21, 2 instruction(s), falls into the block at 0x0045ff3f
    mov edx, dword ptr [ebp - local_28]          # 0045ff32
    mov dword ptr [edx + field_3a2], 0x4         # 0045ff35
L_0045ff3f:
    # block 0x0045ff3f: entered by jmp at 0x0045ff30, 9 instruction(s), calls FUN_0045eadc, ends with forward jump to 0x004600d1
    mov eax, dword ptr [ebp - local_28]          # 0045ff3f
    movsx ecx, word ptr [eax + field_2a4]        # 0045ff42
    neg ecx                                      # 0045ff49
    {load} sbb ecx, ecx                          # 0045ff4b
    inc ecx                                      # 0045ff4d
    push ecx                                     # 0045ff4e
    mov ecx, dword ptr [ebp - local_28]          # 0045ff4f
    call FUN_0045eadc                            # 0045ff52
    jmp.d32 L_004600d1                           # 0045ff57
L_0045ff5c:
    # block 0x0045ff5c: entered by je at 0x0045fea3; jne at 0x0045feb6, 4 instruction(s), ends with jne to 0x0046001a (forward)
    mov edx, dword ptr [ebp - local_28]          # 0045ff5c
    movsx eax, word ptr [edx + field_371]        # 0045ff5f
    cmp eax, -0x1                                # 0045ff66
    jne.d32 L_0046001a                           # 0045ff69
    # block 0x0045ff6f: entered by fall-through of jne at 0x0045ff69, 5 instruction(s), ends with je to 0x0046001a (forward)
    mov ecx, dword ptr [ebp - local_28]          # 0045ff6f
    {load} xor edx, edx                          # 0045ff72
    mov dl, byte ptr [ecx + field_29c]           # 0045ff74
    test edx, edx                                # 0045ff7a
    je.d32 L_0046001a                            # 0045ff7c
    # block 0x0045ff82: entered by fall-through of je at 0x0045ff7c, 5 instruction(s), ends with je to 0x0046001a (forward)
    mov eax, dword ptr [ebp - local_28]          # 0045ff82
    {load} xor ecx, ecx                          # 0045ff85
    mov cl, byte ptr [eax + field_3ac]           # 0045ff87
    test ecx, ecx                                # 0045ff8d
    je.d32 L_0046001a                            # 0045ff8f
    # block 0x0045ff95: entered by fall-through of je at 0x0045ff8f, 10 instruction(s), ends with jne to 0x0045ffd2 (forward)
    mov edx, dword ptr [ebp - local_28]          # 0045ff95
    movsx eax, word ptr [edx + field_2a4]        # 0045ff98
    imul eax, eax, 0x120                         # 0045ff9f
    mov ecx, dword ptr [ebp - local_28]          # 0045ffa5
    lea edx, [ecx + eax + field_24]              # 0045ffa8
    mov eax, dword ptr [ebp - local_28]          # 0045ffac
    movsx ecx, word ptr [eax + field_29a]        # 0045ffaf
    movsx edx, word ptr [edx + 2*ecx + field_d0] # 0045ffb6
    cmp edx, 0x3                                 # 0045ffbe
    jne.d8 L_0045ffd2                            # 0045ffc1
    # block 0x0045ffc3: entered by fall-through of jne at 0x0045ffc1, 3 instruction(s), ends with forward jump to 0x0045ffdf
    mov eax, dword ptr [ebp - local_28]          # 0045ffc3
    mov dword ptr [eax + field_39e], 0x8         # 0045ffc6
    jmp.d8 L_0045ffdf                            # 0045ffd0
L_0045ffd2:
    # block 0x0045ffd2: entered by jne at 0x0045ffc1, 2 instruction(s), falls into the block at 0x0045ffdf
    mov ecx, dword ptr [ebp - local_28]          # 0045ffd2
    mov dword ptr [ecx + field_39e], 0x4         # 0045ffd5
L_0045ffdf:
    # block 0x0045ffdf: entered by jmp at 0x0045ffd0, 15 instruction(s), calls FUN_0045eadc, ends with forward jump to 0x004600d1
    mov edx, dword ptr [ebp - local_28]          # 0045ffdf
    mov byte ptr [edx + field_29c], 0x0          # 0045ffe2
    mov eax, dword ptr [ebp - local_28]          # 0045ffe9
    mov byte ptr [eax + field_3ac], 0x0          # 0045ffec
    mov ecx, dword ptr [ebp - local_28]          # 0045fff3
    mov byte ptr [ecx + field_2ac], 0x1          # 0045fff6
    mov edx, dword ptr [ebp - local_28]          # 0045fffd
    movsx eax, word ptr [edx + field_2a4]        # 00460000
    neg eax                                      # 00460007
    {load} sbb eax, eax                          # 00460009
    inc eax                                      # 0046000b
    push eax                                     # 0046000c
    mov ecx, dword ptr [ebp - local_28]          # 0046000d
    call FUN_0045eadc                            # 00460010
    jmp.d32 L_004600d1                           # 00460015
L_0046001a:
    # block 0x0046001a: entered by jne at 0x0045ff69; je at 0x0045ff7c; je at 0x0045ff8f, 4 instruction(s), ends with jne to 0x004600d1 (forward)
    mov ecx, dword ptr [ebp - local_28]          # 0046001a
    movsx edx, word ptr [ecx + field_371]        # 0046001d
    cmp edx, -0x1                                # 00460024
    jne.d32 L_004600d1                           # 00460027
    # block 0x0046002d: entered by fall-through of jne at 0x00460027, 5 instruction(s), ends with jne to 0x00460085 (forward)
    mov eax, dword ptr [ebp - local_28]          # 0046002d
    {load} xor ecx, ecx                          # 00460030
    mov cl, byte ptr [eax + field_29c]           # 00460032
    test ecx, ecx                                # 00460038
    jne.d8 L_00460085                            # 0046003a
    # block 0x0046003c: entered by fall-through of jne at 0x0046003a, 19 instruction(s), calls FUN_0045e6bd, ends with forward jump to 0x004600c7
    push 0x5                                     # 0046003c
    mov edx, dword ptr [ebp - local_28]          # 0046003e
    add edx, 0x326                               # 00460041
    push edx                                     # 00460047
    mov eax, dword ptr [ebp - local_28]          # 00460048
    mov ecx, dword ptr [eax + field_31d]         # 0046004b
    mov edx, dword ptr [ebp - local_28]          # 00460051
    movsx eax, word ptr [edx + field_2a4]        # 00460054
    neg eax                                      # 0046005b
    {load} sbb eax, eax                          # 0046005d
    inc eax                                      # 0046005f
    imul eax, eax, 0x33d                         # 00460060
    lea ecx, [ecx + eax + field_dd8]             # 00460066
    push ecx                                     # 0046006d
    mov ecx, dword ptr [ebp - local_28]          # 0046006e
    call FUN_0045e6bd                            # 00460071
    mov edx, dword ptr [ebp - local_28]          # 00460076
    mov dword ptr [edx + field_3a2], 0x9         # 00460079
    jmp.d8 L_004600c7                            # 00460083
L_00460085:
    # block 0x00460085: entered by jne at 0x0046003a, 12 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x004600c7
    call dword ptr [0x52a23c]                    # 00460085
    add eax, 0x12c                               # 0046008b
    mov ecx, dword ptr [ebp - local_28]          # 00460090
    mov dword ptr [ecx + field_375], eax         # 00460093
    mov edx, dword ptr [ebp - local_28]          # 00460099
    mov dword ptr [edx + field_39e], 0xb         # 0046009c
    mov eax, dword ptr [ebp - local_28]          # 004600a6
    mov dword ptr [eax + field_3a6], 0x9         # 004600a9
    mov ecx, dword ptr [ebp - local_28]          # 004600b3
    mov byte ptr [ecx + field_29c], 0x0          # 004600b6
    mov edx, dword ptr [ebp - local_28]          # 004600bd
    mov byte ptr [edx + field_3ac], 0x0          # 004600c0
L_004600c7:
    # block 0x004600c7: entered by jmp at 0x00460083, 2 instruction(s), falls into the block at 0x004600d1
    mov eax, dword ptr [ebp - local_28]          # 004600c7
    mov byte ptr [eax + field_3ab], 0x1          # 004600ca
L_004600d1:
    # block 0x004600d1: entered by jmp at 0x0045fc6a; jmp at 0x0045fcdb; jmp at 0x0045fd83; jmp at 0x0045ff57; more, 1 instruction(s), ends with forward jump to 0x00460bde
    jmp.d32 L_00460bde                           # 004600d1
L_004600d6:
    # block 0x004600d6: entered by switch case, 8 instruction(s), calls FUN_0045e67d, ends with je to 0x00460171 (forward)
    mov ecx, dword ptr [ebp - local_28]          # 004600d6
    mov edx, dword ptr [ecx + field_31d]         # 004600d9
    add edx, 0xbc4                               # 004600df
    push edx                                     # 004600e5
    mov ecx, dword ptr [ebp - local_28]          # 004600e6
    call FUN_0045e67d                            # 004600e9
    test eax, eax                                # 004600ee
    je.d8 L_00460171                             # 004600f0
    # block 0x004600f2: entered by fall-through of je at 0x004600f0, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x00460171 (forward)
    mov eax, dword ptr [ebp - local_28]          # 004600f2
    movsx ecx, word ptr [eax + field_373]        # 004600f5
    mov dword ptr [ebp - local_18], ecx          # 004600fc
    mov edx, dword ptr [ebp - local_18]          # 004600ff
    push edx                                     # 00460102
    mov ecx, 0x5cf1eb                            # 00460103
    call FUN_004f6334                            # 00460108
    test eax, eax                                # 0046010d
    jne.d8 L_00460171                            # 0046010f
    # block 0x00460111: entered by fall-through of jne at 0x0046010f, 29 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, falls into the block at 0x00460171
    mov eax, dword ptr [ebp - local_28]          # 00460111
    mov ecx, dword ptr [eax + field_31d]         # 00460114
    add ecx, 0xbc4                               # 0046011a
    {load} mov edi, ecx                          # 00460120
    mov edx, dword ptr [ebp - local_28]          # 00460122
    add edx, 0x326                               # 00460125
    or ecx, -0x1                                 # 0046012b
    {load} xor eax, eax                          # 0046012e
    repne scasb al, byte ptr es:[edi]            # 00460130
    not ecx                                      # 00460132
    {load} sub edi, ecx                          # 00460134
    {load} mov esi, edi                          # 00460136
    {load} mov eax, ecx                          # 00460138
    {load} mov edi, edx                          # 0046013a
    shr ecx, 0x2                                 # 0046013c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0046013f
    {load} mov ecx, eax                          # 00460141
    and ecx, 0x3                                 # 00460143
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00460146
    mov ecx, dword ptr [ebp - local_28]          # 00460148
    add ecx, 0x326                               # 0046014b
    push ecx                                     # 00460151
    mov ecx, 0x5c3a67                            # 00460152
    call FUN_004fb77a                            # 00460157
    mov edx, dword ptr [ebp - local_28]          # 0046015c
    mov ax, word ptr [edx + field_347]           # 0046015f
    push eax                                     # 00460166
    mov ecx, 0x5c3a67                            # 00460167
    call FUN_004fb2e3                            # 0046016c
L_00460171:
    # block 0x00460171: entered by je at 0x004600f0; jne at 0x0046010f, 11 instruction(s), ends with jl to 0x00460234 (forward)
    mov ecx, dword ptr [ebp - local_28]          # 00460171
    movsx edx, word ptr [ecx + field_2cf]        # 00460174
    mov eax, dword ptr [ebp - local_28]          # 0046017b
    mov ecx, dword ptr [eax + field_31d]         # 0046017e
    movsx eax, word ptr [ecx + field_993]        # 00460184
    mov ecx, dword ptr [ebp - local_28]          # 0046018b
    mov ecx, dword ptr [ecx + field_31d]         # 0046018e
    movsx ecx, word ptr [ecx + field_995]        # 00460194
    imul eax, ecx                                # 0046019b
    {load} cmp edx, eax                          # 0046019e
    jl.d32 L_00460234                            # 004601a0
    # block 0x004601a6: entered by fall-through of jl at 0x004601a0, 28 instruction(s), ends with jne to 0x00460224 (forward)
    mov edx, dword ptr [ebp - local_28]          # 004601a6
    mov byte ptr [edx + field_29e], 0x1          # 004601a9
    mov eax, dword ptr [ebp - local_28]          # 004601b0
    mov word ptr [eax + field_2cf], 0xffff       # 004601b3
    mov ecx, dword ptr [ebp - local_28]          # 004601bc
    mov edx, dword ptr [ecx + field_31d]         # 004601bf
    mov eax, dword ptr [ebp - local_28]          # 004601c5
    movsx ecx, word ptr [eax + field_371]        # 004601c8
    imul ecx, ecx, 0xd0                          # 004601cf
    lea edx, [edx + ecx + field_6b]              # 004601d5
    mov eax, dword ptr [ebp - local_28]          # 004601d9
    movsx ecx, word ptr [eax + field_29a]        # 004601dc
    shl ecx, 0x4                                 # 004601e3
    {load} add edx, ecx                          # 004601e6
    mov eax, dword ptr [ebp - local_28]          # 004601e8
    add eax, 0x2ad                               # 004601eb
    mov ecx, dword ptr [edx]                     # 004601f0
    mov dword ptr [eax], ecx                     # 004601f2
    mov ecx, dword ptr [edx + field_4]           # 004601f4
    mov dword ptr [eax + field_4], ecx           # 004601f7
    mov ecx, dword ptr [edx + field_8]           # 004601fa
    mov dword ptr [eax + field_8], ecx           # 004601fd
    mov edx, dword ptr [edx + field_c]           # 00460200
    mov dword ptr [eax + field_c], edx           # 00460203
    mov eax, dword ptr [ebp - local_28]          # 00460206
    movsx ecx, word ptr [eax + field_2a4]        # 00460209
    test ecx, ecx                                # 00460210
    jne.d8 L_00460224                            # 00460212
    # block 0x00460214: entered by fall-through of jne at 0x00460212, 6 instruction(s), calls FUN_0045ed60, ends with forward jump to 0x00460232
    push 0x7                                     # 00460214
    push 0x1                                     # 00460216
    push 0x1                                     # 00460218
    mov ecx, dword ptr [ebp - local_28]          # 0046021a
    call FUN_0045ed60                            # 0046021d
    jmp.d8 L_00460232                            # 00460222
L_00460224:
    # block 0x00460224: entered by jne at 0x00460212, 5 instruction(s), calls FUN_0045ed60, falls into the block at 0x00460232
    push 0x6                                     # 00460224
    push 0x1                                     # 00460226
    push 0x1                                     # 00460228
    mov ecx, dword ptr [ebp - local_28]          # 0046022a
    call FUN_0045ed60                            # 0046022d
L_00460232:
    # block 0x00460232: entered by jmp at 0x00460222, 1 instruction(s), ends with forward jump to 0x004602a2
    jmp.d8 L_004602a2                            # 00460232
L_00460234:
    # block 0x00460234: entered by jl at 0x004601a0, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x004602a2 (forward)
    call dword ptr [0x52a23c]                    # 00460234
    mov edx, dword ptr [ebp - local_28]          # 0046023a
    cmp eax, dword ptr [edx + field_379]         # 0046023d
    jb.d8 L_004602a2                             # 00460243
    # block 0x00460245: entered by fall-through of jb at 0x00460243, 20 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x004602a2
    mov eax, dword ptr [ebp - local_28]          # 00460245
    mov cx, word ptr [eax + field_2cf]           # 00460248
    add cx, 0x1                                  # 0046024f
    mov edx, dword ptr [ebp - local_28]          # 00460253
    mov word ptr [edx + field_2cf], cx           # 00460256
    mov eax, dword ptr [ebp - local_28]          # 0046025d
    movsx eax, word ptr [eax + field_2cf]        # 00460260
    mov ecx, dword ptr [ebp - local_28]          # 00460267
    mov edx, dword ptr [ecx + field_31d]         # 0046026a
    movsx ecx, word ptr [edx + field_993]        # 00460270
    cdq                                          # 00460277
    idiv ecx                                     # 00460278
    mov eax, dword ptr [ebp - local_28]          # 0046027a
    mov word ptr [eax + field_29f], dx           # 0046027d
    call dword ptr [0x52a23c]                    # 00460284
    mov ecx, dword ptr [ebp - local_28]          # 0046028a
    mov edx, dword ptr [ecx + field_31d]         # 0046028d
    add eax, dword ptr [edx + field_997]         # 00460293
    mov ecx, dword ptr [ebp - local_28]          # 00460299
    mov dword ptr [ecx + field_379], eax         # 0046029c
L_004602a2:
    # block 0x004602a2: entered by jmp at 0x00460232; jb at 0x00460243, 1 instruction(s), ends with forward jump to 0x00460bde
    jmp.d32 L_00460bde                           # 004602a2
L_004602a7:
    # block 0x004602a7: entered by switch case, 8 instruction(s), calls FUN_0045e67d, ends with je to 0x00460346 (forward)
    mov edx, dword ptr [ebp - local_28]          # 004602a7
    mov eax, dword ptr [edx + field_31d]         # 004602aa
    add eax, 0xbe5                               # 004602b0
    push eax                                     # 004602b5
    mov ecx, dword ptr [ebp - local_28]          # 004602b6
    call FUN_0045e67d                            # 004602b9
    test eax, eax                                # 004602be
    je.d32 L_00460346                            # 004602c0
    # block 0x004602c6: entered by fall-through of je at 0x004602c0, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x00460346 (forward)
    mov ecx, dword ptr [ebp - local_28]          # 004602c6
    movsx edx, word ptr [ecx + field_373]        # 004602c9
    mov dword ptr [ebp - local_1c], edx          # 004602d0
    mov eax, dword ptr [ebp - local_1c]          # 004602d3
    push eax                                     # 004602d6
    mov ecx, 0x5cf1eb                            # 004602d7
    call FUN_004f6334                            # 004602dc
    test eax, eax                                # 004602e1
    jne.d8 L_00460346                            # 004602e3
    # block 0x004602e5: entered by fall-through of jne at 0x004602e3, 30 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, falls into the block at 0x00460346
    mov ecx, dword ptr [ebp - local_28]          # 004602e5
    mov edx, dword ptr [ecx + field_31d]         # 004602e8
    add edx, 0xbe5                               # 004602ee
    {load} mov edi, edx                          # 004602f4
    mov eax, dword ptr [ebp - local_28]          # 004602f6
    add eax, 0x326                               # 004602f9
    {load} mov edx, eax                          # 004602fe
    or ecx, -0x1                                 # 00460300
    {load} xor eax, eax                          # 00460303
    repne scasb al, byte ptr es:[edi]            # 00460305
    not ecx                                      # 00460307
    {load} sub edi, ecx                          # 00460309
    {load} mov esi, edi                          # 0046030b
    {load} mov eax, ecx                          # 0046030d
    {load} mov edi, edx                          # 0046030f
    shr ecx, 0x2                                 # 00460311
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00460314
    {load} mov ecx, eax                          # 00460316
    and ecx, 0x3                                 # 00460318
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0046031b
    mov ecx, dword ptr [ebp - local_28]          # 0046031d
    add ecx, 0x326                               # 00460320
    push ecx                                     # 00460326
    mov ecx, 0x5c3a67                            # 00460327
    call FUN_004fb77a                            # 0046032c
    mov edx, dword ptr [ebp - local_28]          # 00460331
    mov ax, word ptr [edx + field_347]           # 00460334
    push eax                                     # 0046033b
    mov ecx, 0x5c3a67                            # 0046033c
    call FUN_004fb2e3                            # 00460341
L_00460346:
    # block 0x00460346: entered by je at 0x004602c0; jne at 0x004602e3, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x004604d2 (forward)
    call dword ptr [0x52a23c]                    # 00460346
    mov ecx, dword ptr [ebp - local_28]          # 0046034c
    cmp eax, dword ptr [ecx + field_379]         # 0046034f
    jb.d32 L_004604d2                            # 00460355
    # block 0x0046035b: entered by fall-through of jb at 0x00460355, 5 instruction(s), ends with je to 0x00460384 (forward)
    mov edx, dword ptr [ebp - local_28]          # 0046035b
    {load} xor eax, eax                          # 0046035e
    mov al, byte ptr [edx + field_2d3]           # 00460360
    test eax, eax                                # 00460366
    je.d8 L_00460384                             # 00460368
    # block 0x0046036a: entered by fall-through of je at 0x00460368, 6 instruction(s), ends with forward jump to 0x0046039c
    mov ecx, dword ptr [ebp - local_28]          # 0046036a
    mov dx, word ptr [ecx + field_2d5]           # 0046036d
    add dx, 0x1                                  # 00460374
    mov eax, dword ptr [ebp - local_28]          # 00460378
    mov word ptr [eax + field_2d5], dx           # 0046037b
    jmp.d8 L_0046039c                            # 00460382
L_00460384:
    # block 0x00460384: entered by je at 0x00460368, 5 instruction(s), falls into the block at 0x0046039c
    mov ecx, dword ptr [ebp - local_28]          # 00460384
    mov dx, word ptr [ecx + field_2d5]           # 00460387
    sub dx, 0x1                                  # 0046038e
    mov eax, dword ptr [ebp - local_28]          # 00460392
    mov word ptr [eax + field_2d5], dx           # 00460395
L_0046039c:
    # block 0x0046039c: entered by jmp at 0x00460382, 5 instruction(s), ends with je to 0x00460434 (forward)
    mov ecx, dword ptr [ebp - local_28]          # 0046039c
    {load} xor edx, edx                          # 0046039f
    mov dl, byte ptr [ecx + field_2d3]           # 004603a1
    test edx, edx                                # 004603a7
    je.d32 L_00460434                            # 004603a9
    # block 0x004603af: entered by fall-through of je at 0x004603a9, 29 instruction(s), ends with forward jump to 0x004604b4
    mov eax, dword ptr [ebp - local_28]          # 004603af
    movsx ecx, word ptr [eax + field_2d7]        # 004603b2
    shl ecx, 0x4                                 # 004603b9
    mov edx, dword ptr [ebp - local_28]          # 004603bc
    mov eax, dword ptr [edx + field_31d]         # 004603bf
    movsx edx, word ptr [eax + field_62d]        # 004603c5
    mov eax, dword ptr [ebp - local_28]          # 004603cc
    mov ecx, dword ptr [eax + ecx + field_2fd]   # 004603cf
    {load} add ecx, edx                          # 004603d6
    mov edx, dword ptr [ebp - local_28]          # 004603d8
    movsx eax, word ptr [edx + field_2d7]        # 004603db
    shl eax, 0x4                                 # 004603e2
    mov edx, dword ptr [ebp - local_28]          # 004603e5
    mov dword ptr [edx + eax + field_2fd], ecx   # 004603e8
    mov eax, dword ptr [ebp - local_28]          # 004603ef
    movsx ecx, word ptr [eax + field_2d7]        # 004603f2
    shl ecx, 0x4                                 # 004603f9
    mov edx, dword ptr [ebp - local_28]          # 004603fc
    mov eax, dword ptr [edx + field_31d]         # 004603ff
    movsx edx, word ptr [eax + field_62d]        # 00460405
    mov eax, dword ptr [ebp - local_28]          # 0046040c
    mov ecx, dword ptr [eax + ecx + field_305]   # 0046040f
    {load} add ecx, edx                          # 00460416
    mov edx, dword ptr [ebp - local_28]          # 00460418
    movsx eax, word ptr [edx + field_2d7]        # 0046041b
    shl eax, 0x4                                 # 00460422
    mov edx, dword ptr [ebp - local_28]          # 00460425
    mov dword ptr [edx + eax + field_305], ecx   # 00460428
    jmp.d32 L_004604b4                           # 0046042f
L_00460434:
    # block 0x00460434: entered by je at 0x004603a9, 28 instruction(s), falls into the block at 0x004604b4
    mov eax, dword ptr [ebp - local_28]          # 00460434
    movsx ecx, word ptr [eax + field_2d7]        # 00460437
    shl ecx, 0x4                                 # 0046043e
    mov edx, dword ptr [ebp - local_28]          # 00460441
    mov eax, dword ptr [edx + field_31d]         # 00460444
    movsx edx, word ptr [eax + field_62d]        # 0046044a
    mov eax, dword ptr [ebp - local_28]          # 00460451
    mov ecx, dword ptr [eax + ecx + field_2fd]   # 00460454
    {load} sub ecx, edx                          # 0046045b
    mov edx, dword ptr [ebp - local_28]          # 0046045d
    movsx eax, word ptr [edx + field_2d7]        # 00460460
    shl eax, 0x4                                 # 00460467
    mov edx, dword ptr [ebp - local_28]          # 0046046a
    mov dword ptr [edx + eax + field_2fd], ecx   # 0046046d
    mov eax, dword ptr [ebp - local_28]          # 00460474
    movsx ecx, word ptr [eax + field_2d7]        # 00460477
    shl ecx, 0x4                                 # 0046047e
    mov edx, dword ptr [ebp - local_28]          # 00460481
    mov eax, dword ptr [edx + field_31d]         # 00460484
    movsx edx, word ptr [eax + field_62d]        # 0046048a
    mov eax, dword ptr [ebp - local_28]          # 00460491
    mov ecx, dword ptr [eax + ecx + field_305]   # 00460494
    {load} sub ecx, edx                          # 0046049b
    mov edx, dword ptr [ebp - local_28]          # 0046049d
    movsx eax, word ptr [edx + field_2d7]        # 004604a0
    shl eax, 0x4                                 # 004604a7
    mov edx, dword ptr [ebp - local_28]          # 004604aa
    mov dword ptr [edx + eax + field_305], ecx   # 004604ad
L_004604b4:
    # block 0x004604b4: entered by jmp at 0x0046042f, 6 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x004604d2
    call dword ptr [0x52a23c]                    # 004604b4
    mov ecx, dword ptr [ebp - local_28]          # 004604ba
    mov edx, dword ptr [ecx + field_31d]         # 004604bd
    add eax, dword ptr [edx + field_62f]         # 004604c3
    mov ecx, dword ptr [ebp - local_28]          # 004604c9
    mov dword ptr [ecx + field_379], eax         # 004604cc
L_004604d2:
    # block 0x004604d2: entered by jb at 0x00460355, 5 instruction(s), ends with je to 0x004604ff (forward)
    mov edx, dword ptr [ebp - local_28]          # 004604d2
    {load} xor eax, eax                          # 004604d5
    mov al, byte ptr [edx + field_2d3]           # 004604d7
    test eax, eax                                # 004604dd
    je.d8 L_004604ff                             # 004604df
    # block 0x004604e1: entered by fall-through of je at 0x004604df, 7 instruction(s), ends with jge to 0x00460524 (forward)
    mov ecx, dword ptr [ebp - local_28]          # 004604e1
    movsx edx, word ptr [ecx + field_2d5]        # 004604e4
    mov eax, dword ptr [ebp - local_28]          # 004604eb
    mov ecx, dword ptr [eax + field_31d]         # 004604ee
    movsx eax, word ptr [ecx + field_62b]        # 004604f4
    {load} cmp edx, eax                          # 004604fb
    jge.d8 L_00460524                            # 004604fd
L_004604ff:
    # block 0x004604ff: entered by je at 0x004604df; fall-through of jge at 0x004604fd, 5 instruction(s), ends with jne to 0x004605b6 (forward)
    mov ecx, dword ptr [ebp - local_28]          # 004604ff
    {load} xor edx, edx                          # 00460502
    mov dl, byte ptr [ecx + field_2d3]           # 00460504
    test edx, edx                                # 0046050a
    jne.d32 L_004605b6                           # 0046050c
    # block 0x00460512: entered by fall-through of jne at 0x0046050c, 4 instruction(s), ends with jge to 0x004605b6 (forward)
    mov eax, dword ptr [ebp - local_28]          # 00460512
    movsx ecx, word ptr [eax + field_2d5]        # 00460515
    test ecx, ecx                                # 0046051c
    jge.d32 L_004605b6                           # 0046051e
L_00460524:
    # block 0x00460524: entered by jge at 0x004604fd; fall-through of jge at 0x0046051e, 18 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jne to 0x004605b6 (forward)
    call dword ptr [0x52a23c]                    # 00460524
    add eax, 0x1f4                               # 0046052a
    mov edx, dword ptr [ebp - local_28]          # 0046052f
    mov dword ptr [edx + field_375], eax         # 00460532
    mov eax, dword ptr [ebp - local_28]          # 00460538
    mov dword ptr [eax + field_39e], 0xb         # 0046053b
    mov ecx, dword ptr [ebp - local_28]          # 00460545
    mov edx, dword ptr [ebp - local_28]          # 00460548
    mov eax, dword ptr [edx + field_2d9]         # 0046054b
    mov dword ptr [ecx + field_3a6], eax         # 00460551
    mov ecx, dword ptr [ebp - local_28]          # 00460557
    mov word ptr [ecx + field_2d5], 0xffff       # 0046055a
    mov edx, dword ptr [ebp - local_28]          # 00460563
    mov eax, dword ptr [edx + field_31d]         # 00460566
    mov ecx, dword ptr [ebp - local_28]          # 0046056c
    mov edx, dword ptr [ecx + field_2e1]         # 0046056f
    cmp edx, dword ptr [eax + field_637]         # 00460575
    jne.d8 L_004605b6                            # 0046057b
    # block 0x0046057d: entered by fall-through of jne at 0x0046057b, 9 instruction(s), ends with je to 0x004605ac (forward)
    mov eax, dword ptr [ebp - local_28]          # 0046057d
    mov ecx, dword ptr [ebp - local_28]          # 00460580
    mov dx, word ptr [ecx + field_2d7]           # 00460583
    mov word ptr [eax + field_2cd], dx           # 0046058a
    mov eax, dword ptr [ebp - local_28]          # 00460591
    {load} xor ecx, ecx                          # 00460594
    mov cl, byte ptr [eax + field_2d3]           # 00460596
    test ecx, ecx                                # 0046059c
    je.d8 L_004605ac                             # 0046059e
    # block 0x004605a0: entered by fall-through of je at 0x0046059e, 3 instruction(s), ends with forward jump to 0x004605b6
    mov edx, dword ptr [ebp - local_28]          # 004605a0
    mov byte ptr [edx + field_2ab], 0x1          # 004605a3
    jmp.d8 L_004605b6                            # 004605aa
L_004605ac:
    # block 0x004605ac: entered by je at 0x0046059e, 2 instruction(s), falls into the block at 0x004605b6
    mov eax, dword ptr [ebp - local_28]          # 004605ac
    mov byte ptr [eax + field_29e], 0x1          # 004605af
L_004605b6:
    # block 0x004605b6: entered by jne at 0x0046050c; jge at 0x0046051e; jne at 0x0046057b; jmp at 0x004605aa, 1 instruction(s), ends with forward jump to 0x00460bde
    jmp.d32 L_00460bde                           # 004605b6
L_004605bb:
    # block 0x004605bb: entered by switch case, 8 instruction(s), calls FUN_0045e67d, ends with je to 0x00460656 (forward)
    mov ecx, dword ptr [ebp - local_28]          # 004605bb
    mov edx, dword ptr [ecx + field_31d]         # 004605be
    add edx, 0xbc4                               # 004605c4
    push edx                                     # 004605ca
    mov ecx, dword ptr [ebp - local_28]          # 004605cb
    call FUN_0045e67d                            # 004605ce
    test eax, eax                                # 004605d3
    je.d8 L_00460656                             # 004605d5
    # block 0x004605d7: entered by fall-through of je at 0x004605d5, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x00460656 (forward)
    mov eax, dword ptr [ebp - local_28]          # 004605d7
    movsx ecx, word ptr [eax + field_373]        # 004605da
    mov dword ptr [ebp - local_20], ecx          # 004605e1
    mov edx, dword ptr [ebp - local_20]          # 004605e4
    push edx                                     # 004605e7
    mov ecx, 0x5cf1eb                            # 004605e8
    call FUN_004f6334                            # 004605ed
    test eax, eax                                # 004605f2
    jne.d8 L_00460656                            # 004605f4
    # block 0x004605f6: entered by fall-through of jne at 0x004605f4, 29 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, falls into the block at 0x00460656
    mov eax, dword ptr [ebp - local_28]          # 004605f6
    mov ecx, dword ptr [eax + field_31d]         # 004605f9
    add ecx, 0xbc4                               # 004605ff
    {load} mov edi, ecx                          # 00460605
    mov edx, dword ptr [ebp - local_28]          # 00460607
    add edx, 0x326                               # 0046060a
    or ecx, -0x1                                 # 00460610
    {load} xor eax, eax                          # 00460613
    repne scasb al, byte ptr es:[edi]            # 00460615
    not ecx                                      # 00460617
    {load} sub edi, ecx                          # 00460619
    {load} mov esi, edi                          # 0046061b
    {load} mov eax, ecx                          # 0046061d
    {load} mov edi, edx                          # 0046061f
    shr ecx, 0x2                                 # 00460621
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00460624
    {load} mov ecx, eax                          # 00460626
    and ecx, 0x3                                 # 00460628
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0046062b
    mov ecx, dword ptr [ebp - local_28]          # 0046062d
    add ecx, 0x326                               # 00460630
    push ecx                                     # 00460636
    mov ecx, 0x5c3a67                            # 00460637
    call FUN_004fb77a                            # 0046063c
    mov edx, dword ptr [ebp - local_28]          # 00460641
    mov ax, word ptr [edx + field_347]           # 00460644
    push eax                                     # 0046064b
    mov ecx, 0x5c3a67                            # 0046064c
    call FUN_004fb2e3                            # 00460651
L_00460656:
    # block 0x00460656: entered by je at 0x004605d5; jne at 0x004605f4, 11 instruction(s), ends with jl to 0x004606d7 (forward)
    mov ecx, dword ptr [ebp - local_28]          # 00460656
    movsx edx, word ptr [ecx + field_2cf]        # 00460659
    mov eax, dword ptr [ebp - local_28]          # 00460660
    mov ecx, dword ptr [eax + field_31d]         # 00460663
    movsx eax, word ptr [ecx + field_a9b]        # 00460669
    mov ecx, dword ptr [ebp - local_28]          # 00460670
    mov ecx, dword ptr [ecx + field_31d]         # 00460673
    movsx ecx, word ptr [ecx + field_a9d]        # 00460679
    imul eax, ecx                                # 00460680
    {load} cmp edx, eax                          # 00460683
    jl.d8 L_004606d7                             # 00460685
    # block 0x00460687: entered by fall-through of jl at 0x00460685, 15 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x00460745
    mov edx, dword ptr [ebp - local_28]          # 00460687
    mov byte ptr [edx + field_29d], 0x0          # 0046068a
    mov eax, dword ptr [ebp - local_28]          # 00460691
    mov word ptr [eax + field_2cf], 0xffff       # 00460694
    mov ecx, dword ptr [ebp - local_28]          # 0046069d
    mov byte ptr [ecx + field_29e], 0x1          # 004606a0
    call dword ptr [0x52a23c]                    # 004606a7
    add eax, 0x12c                               # 004606ad
    mov edx, dword ptr [ebp - local_28]          # 004606b2
    mov dword ptr [edx + field_375], eax         # 004606b5
    mov eax, dword ptr [ebp - local_28]          # 004606bb
    mov dword ptr [eax + field_39e], 0xb         # 004606be
    mov ecx, dword ptr [ebp - local_28]          # 004606c8
    mov dword ptr [ecx + field_3a6], 0x9         # 004606cb
    jmp.d8 L_00460745                            # 004606d5
L_004606d7:
    # block 0x004606d7: entered by jl at 0x00460685, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x00460745 (forward)
    call dword ptr [0x52a23c]                    # 004606d7
    mov edx, dword ptr [ebp - local_28]          # 004606dd
    cmp eax, dword ptr [edx + field_379]         # 004606e0
    jb.d8 L_00460745                             # 004606e6
    # block 0x004606e8: entered by fall-through of jb at 0x004606e6, 20 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x00460745
    mov eax, dword ptr [ebp - local_28]          # 004606e8
    mov cx, word ptr [eax + field_2cf]           # 004606eb
    add cx, 0x1                                  # 004606f2
    mov edx, dword ptr [ebp - local_28]          # 004606f6
    mov word ptr [edx + field_2cf], cx           # 004606f9
    mov eax, dword ptr [ebp - local_28]          # 00460700
    movsx eax, word ptr [eax + field_2cf]        # 00460703
    mov ecx, dword ptr [ebp - local_28]          # 0046070a
    mov edx, dword ptr [ecx + field_31d]         # 0046070d
    movsx ecx, word ptr [edx + field_a9b]        # 00460713
    cdq                                          # 0046071a
    idiv ecx                                     # 0046071b
    mov eax, dword ptr [ebp - local_28]          # 0046071d
    mov word ptr [eax + field_29f], dx           # 00460720
    call dword ptr [0x52a23c]                    # 00460727
    mov ecx, dword ptr [ebp - local_28]          # 0046072d
    mov edx, dword ptr [ecx + field_31d]         # 00460730
    add eax, dword ptr [edx + field_a9f]         # 00460736
    mov ecx, dword ptr [ebp - local_28]          # 0046073c
    mov dword ptr [ecx + field_379], eax         # 0046073f
L_00460745:
    # block 0x00460745: entered by jmp at 0x004606d5; jb at 0x004606e6, 1 instruction(s), ends with forward jump to 0x00460bde
    jmp.d32 L_00460bde                           # 00460745
L_0046074a:
    # block 0x0046074a: entered by switch case, 33 instruction(s), calls FUN_0045e6bd, FUN_0045ea4a, ends with forward jump to 0x004607ed
    push 0x2                                     # 0046074a
    mov edx, dword ptr [ebp - local_28]          # 0046074c
    add edx, 0x326                               # 0046074f
    push edx                                     # 00460755
    mov eax, dword ptr [ebp - local_28]          # 00460756
    mov ecx, dword ptr [eax + field_31d]         # 00460759
    mov edx, dword ptr [ebp - local_28]          # 0046075f
    movsx eax, word ptr [edx + field_2a4]        # 00460762
    imul eax, eax, 0x33d                         # 00460769
    lea ecx, [ecx + eax + field_ee0]             # 0046076f
    push ecx                                     # 00460776
    mov ecx, dword ptr [ebp - local_28]          # 00460777
    call FUN_0045e6bd                            # 0046077a
    mov edx, dword ptr [ebp - local_28]          # 0046077f
    movsx eax, word ptr [edx + field_2a4]        # 00460782
    imul eax, eax, 0x120                         # 00460789
    mov ecx, dword ptr [ebp - local_28]          # 0046078f
    mov dx, word ptr [ecx + eax + field_142]     # 00460792
    add dx, 0x1                                  # 0046079a
    mov eax, dword ptr [ebp - local_28]          # 0046079e
    movsx ecx, word ptr [eax + field_2a4]        # 004607a1
    imul ecx, ecx, 0x120                         # 004607a8
    mov eax, dword ptr [ebp - local_28]          # 004607ae
    mov word ptr [eax + ecx + field_142], dx     # 004607b1
    mov ecx, dword ptr [ebp - local_28]          # 004607b9
    mov dword ptr [ecx + field_3a2], 0x4         # 004607bc
    mov edx, dword ptr [ebp - local_28]          # 004607c6
    mov ax, word ptr [edx + field_2a4]           # 004607c9
    push eax                                     # 004607d0
    mov ecx, dword ptr [ebp - local_28]          # 004607d1
    call FUN_0045ea4a                            # 004607d4
    mov word ptr [ebp - local_4], 0x0            # 004607d9
    jmp.d8 L_004607ed                            # 004607df
L_004607e1:
    # block 0x004607e1: entered by jmp at 0x00460850, 3 instruction(s), falls into the block at 0x004607ed
    mov cx, word ptr [ebp - local_4]             # 004607e1
    add cx, 0x1                                  # 004607e5
    mov word ptr [ebp - local_4], cx             # 004607e9
L_004607ed:
    # block 0x004607ed: entered by jmp at 0x004607df, 6 instruction(s), ends with jge to 0x00460852 (forward)
    movsx edx, word ptr [ebp - local_4]          # 004607ed
    mov eax, dword ptr [ebp - local_28]          # 004607f1
    mov ecx, dword ptr [eax + field_31d]         # 004607f4
    movsx eax, word ptr [ecx + field_25]         # 004607fa
    {load} cmp edx, eax                          # 004607fe
    jge.d8 L_00460852                            # 00460800
    # block 0x00460802: entered by fall-through of jge at 0x00460800, 9 instruction(s), ends with jne to 0x00460850 (forward)
    mov ecx, dword ptr [ebp - local_28]          # 00460802
    movsx edx, word ptr [ecx + field_2a4]        # 00460805
    imul edx, edx, 0x120                         # 0046080c
    mov eax, dword ptr [ebp - local_28]          # 00460812
    lea ecx, [eax + edx + field_24]              # 00460815
    movsx edx, word ptr [ebp - local_4]          # 00460819
    movsx eax, word ptr [ecx + 2*edx + field_d0] # 0046081d
    cmp eax, 0x3                                 # 00460825
    jne.d8 L_00460850                            # 00460828
    # block 0x0046082a: entered by fall-through of jne at 0x00460828, 7 instruction(s), falls into the block at 0x00460850
    mov ecx, dword ptr [ebp - local_28]          # 0046082a
    movsx edx, word ptr [ecx + field_2a4]        # 0046082d
    imul edx, edx, 0x120                         # 00460834
    mov eax, dword ptr [ebp - local_28]          # 0046083a
    lea ecx, [eax + edx + field_24]              # 0046083d
    movsx edx, word ptr [ebp - local_4]          # 00460841
    mov dword ptr [ecx + 4*edx + field_ea], 0x1  # 00460845
L_00460850:
    # block 0x00460850: entered by jne at 0x00460828, 1 instruction(s), ends with backward jump to 0x004607e1
    jmp.d8 L_004607e1                            # 00460850
L_00460852:
    # block 0x00460852: entered by jge at 0x00460800, 1 instruction(s), ends with forward jump to 0x00460bde
    jmp.d32 L_00460bde                           # 00460852
L_00460857:
    # block 0x00460857: entered by switch case, 5 instruction(s), ends with je to 0x004608a6 (forward)
    mov eax, dword ptr [ebp - local_28]          # 00460857
    {load} xor ecx, ecx                          # 0046085a
    mov cl, byte ptr [eax + field_3ab]           # 0046085c
    test ecx, ecx                                # 00460862
    je.d8 L_004608a6                             # 00460864
    # block 0x00460866: entered by fall-through of je at 0x00460864, 15 instruction(s), calls FUN_0045e6bd, ends with forward jump to 0x00460a6d
    push 0x1                                     # 00460866
    mov edx, dword ptr [ebp - local_28]          # 00460868
    add edx, 0x326                               # 0046086b
    push edx                                     # 00460871
    mov eax, dword ptr [ebp - local_28]          # 00460872
    mov ecx, dword ptr [eax + field_31d]         # 00460875
    add ecx, 0xc06                               # 0046087b
    push ecx                                     # 00460881
    mov ecx, dword ptr [ebp - local_28]          # 00460882
    call FUN_0045e6bd                            # 00460885
    mov edx, dword ptr [ebp - local_28]          # 0046088a
    mov dword ptr [edx + field_3a2], 0x9         # 0046088d
    mov eax, dword ptr [ebp - local_28]          # 00460897
    mov byte ptr [eax + field_3ab], 0x0          # 0046089a
    jmp.d32 L_00460a6d                           # 004608a1
L_004608a6:
    # block 0x004608a6: entered by je at 0x00460864, 9 instruction(s), calls FUN_0045de8a, ends with je to 0x00460a6d (forward)
    mov ecx, dword ptr [ebp - local_28]          # 004608a6
    mov dx, word ptr [ecx + field_2a4]           # 004608a9
    push edx                                     # 004608b0
    mov ecx, dword ptr [ebp - local_28]          # 004608b1
    call FUN_0045de8a                            # 004608b4
    mov word ptr [ebp - local_10], ax            # 004608b9
    movsx eax, word ptr [ebp - local_10]         # 004608bd
    cmp eax, -0x1                                # 004608c1
    je.d32 L_00460a6d                            # 004608c4
    # block 0x004608ca: entered by fall-through of je at 0x004608c4, 9 instruction(s), ends with jne to 0x00460a00 (forward)
    mov ecx, dword ptr [ebp - local_28]          # 004608ca
    movsx edx, word ptr [ecx + field_2a4]        # 004608cd
    imul edx, edx, 0x120                         # 004608d4
    mov eax, dword ptr [ebp - local_28]          # 004608da
    lea ecx, [eax + edx + field_24]              # 004608dd
    movsx edx, word ptr [ebp - local_10]         # 004608e1
    movsx eax, word ptr [ecx + 2*edx + field_d0] # 004608e5
    cmp eax, 0x3                                 # 004608ed
    jne.d32 L_00460a00                           # 004608f0
    # block 0x004608f6: entered by fall-through of jne at 0x004608f0, 33 instruction(s), calls FUN_0045e6bd, FUN_0045ea4a, ends with forward jump to 0x00460999
    push 0x2                                     # 004608f6
    mov ecx, dword ptr [ebp - local_28]          # 004608f8
    add ecx, 0x326                               # 004608fb
    push ecx                                     # 00460901
    mov edx, dword ptr [ebp - local_28]          # 00460902
    mov eax, dword ptr [edx + field_31d]         # 00460905
    mov ecx, dword ptr [ebp - local_28]          # 0046090b
    movsx edx, word ptr [ecx + field_2a4]        # 0046090e
    imul edx, edx, 0x33d                         # 00460915
    lea eax, [eax + edx + field_ee0]             # 0046091b
    push eax                                     # 00460922
    mov ecx, dword ptr [ebp - local_28]          # 00460923
    call FUN_0045e6bd                            # 00460926
    mov ecx, dword ptr [ebp - local_28]          # 0046092b
    movsx edx, word ptr [ecx + field_2a4]        # 0046092e
    imul edx, edx, 0x120                         # 00460935
    mov eax, dword ptr [ebp - local_28]          # 0046093b
    mov cx, word ptr [eax + edx + field_142]     # 0046093e
    add cx, 0x1                                  # 00460946
    mov edx, dword ptr [ebp - local_28]          # 0046094a
    movsx eax, word ptr [edx + field_2a4]        # 0046094d
    imul eax, eax, 0x120                         # 00460954
    mov edx, dword ptr [ebp - local_28]          # 0046095a
    mov word ptr [edx + eax + field_142], cx     # 0046095d
    mov eax, dword ptr [ebp - local_28]          # 00460965
    mov dword ptr [eax + field_3a2], 0x4         # 00460968
    mov ecx, dword ptr [ebp - local_28]          # 00460972
    mov dx, word ptr [ecx + field_2a4]           # 00460975
    push edx                                     # 0046097c
    mov ecx, dword ptr [ebp - local_28]          # 0046097d
    call FUN_0045ea4a                            # 00460980
    mov word ptr [ebp - local_4], 0x0            # 00460985
    jmp.d8 L_00460999                            # 0046098b
L_0046098d:
    # block 0x0046098d: entered by jmp at 0x004609fc, 3 instruction(s), falls into the block at 0x00460999
    mov ax, word ptr [ebp - local_4]             # 0046098d
    .insn 0x66, 0x05, 0x0001{:u16}               # 00460991
    mov word ptr [ebp - local_4], ax             # 00460995
L_00460999:
    # block 0x00460999: entered by jmp at 0x0046098b, 6 instruction(s), ends with jge to 0x004609fe (forward)
    movsx ecx, word ptr [ebp - local_4]          # 00460999
    mov edx, dword ptr [ebp - local_28]          # 0046099d
    mov eax, dword ptr [edx + field_31d]         # 004609a0
    movsx edx, word ptr [eax + field_25]         # 004609a6
    {load} cmp ecx, edx                          # 004609aa
    jge.d8 L_004609fe                            # 004609ac
    # block 0x004609ae: entered by fall-through of jge at 0x004609ac, 9 instruction(s), ends with jne to 0x004609fc (forward)
    mov eax, dword ptr [ebp - local_28]          # 004609ae
    movsx ecx, word ptr [eax + field_2a4]        # 004609b1
    imul ecx, ecx, 0x120                         # 004609b8
    mov edx, dword ptr [ebp - local_28]          # 004609be
    lea eax, [edx + ecx + field_24]              # 004609c1
    movsx ecx, word ptr [ebp - local_4]          # 004609c5
    movsx edx, word ptr [eax + 2*ecx + field_d0] # 004609c9
    cmp edx, 0x3                                 # 004609d1
    jne.d8 L_004609fc                            # 004609d4
    # block 0x004609d6: entered by fall-through of jne at 0x004609d4, 7 instruction(s), falls into the block at 0x004609fc
    mov eax, dword ptr [ebp - local_28]          # 004609d6
    movsx ecx, word ptr [eax + field_2a4]        # 004609d9
    imul ecx, ecx, 0x120                         # 004609e0
    mov edx, dword ptr [ebp - local_28]          # 004609e6
    lea eax, [edx + ecx + field_24]              # 004609e9
    movsx ecx, word ptr [ebp - local_4]          # 004609ed
    mov dword ptr [eax + 4*ecx + field_ea], 0x1  # 004609f1
L_004609fc:
    # block 0x004609fc: entered by jne at 0x004609d4, 1 instruction(s), ends with backward jump to 0x0046098d
    jmp.d8 L_0046098d                            # 004609fc
L_004609fe:
    # block 0x004609fe: entered by jge at 0x004609ac, 1 instruction(s), ends with forward jump to 0x00460a0d
    jmp.d8 L_00460a0d                            # 004609fe
L_00460a00:
    # block 0x00460a00: entered by jne at 0x004608f0, 2 instruction(s), falls into the block at 0x00460a0d
    mov edx, dword ptr [ebp - local_28]          # 00460a00
    mov dword ptr [edx + field_39e], 0x4         # 00460a03
L_00460a0d:
    # block 0x00460a0d: entered by jmp at 0x004609fe, 6 instruction(s), ends with je to 0x00460a3c (forward)
    mov eax, dword ptr [ebp - local_28]          # 00460a0d
    mov ecx, dword ptr [eax + field_31d]         # 00460a10
    {load} xor edx, edx                          # 00460a16
    mov dl, byte ptr [ecx + field_22]            # 00460a18
    test edx, edx                                # 00460a1b
    je.d8 L_00460a3c                             # 00460a1d
    # block 0x00460a1f: entered by fall-through of je at 0x00460a1d, 7 instruction(s), ends with je to 0x00460a6d (forward)
    movsx eax, word ptr [ebp - local_10]         # 00460a1f
    mov ecx, dword ptr [ebp - local_28]          # 00460a23
    movsx edx, word ptr [ecx + field_381]        # 00460a26
    mov ecx, dword ptr [ebp - local_28]          # 00460a2d
    movsx edx, word ptr [ecx + 2*edx + field_383] # 00460a30
    {load} cmp eax, edx                          # 00460a38
    je.d8 L_00460a6d                             # 00460a3a
L_00460a3c:
    # block 0x00460a3c: entered by je at 0x00460a1d; fall-through of je at 0x00460a3a, 11 instruction(s), falls into the block at 0x00460a6d
    mov eax, dword ptr [ebp - local_28]          # 00460a3c
    movsx ecx, word ptr [eax + field_2a4]        # 00460a3f
    neg ecx                                      # 00460a46
    {load} sbb ecx, ecx                          # 00460a48
    inc ecx                                      # 00460a4a
    mov edx, dword ptr [ebp - local_28]          # 00460a4b
    mov word ptr [edx + field_2a4], cx           # 00460a4e
    mov eax, dword ptr [ebp - local_28]          # 00460a55
    mov word ptr [eax + field_383], 0xffff       # 00460a58
    mov ecx, dword ptr [ebp - local_28]          # 00460a61
    mov word ptr [ecx + field_381], 0xffff       # 00460a64
L_00460a6d:
    # block 0x00460a6d: entered by jmp at 0x004608a1; je at 0x004608c4; je at 0x00460a3a, 1 instruction(s), ends with forward jump to 0x00460bde
    jmp.d32 L_00460bde                           # 00460a6d
L_00460a72:
    # block 0x00460a72: entered by switch case, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x00460b37 (forward)
    mov edx, dword ptr [ebp - local_28]          # 00460a72
    movsx eax, word ptr [edx + field_373]        # 00460a75
    mov dword ptr [ebp - local_24], eax          # 00460a7c
    mov ecx, dword ptr [ebp - local_24]          # 00460a7f
    push ecx                                     # 00460a82
    mov ecx, 0x5cf1eb                            # 00460a83
    call FUN_004f6334                            # 00460a88
    test eax, eax                                # 00460a8d
    jne.d32 L_00460b37                           # 00460a8f
    # block 0x00460a95: entered by fall-through of jne at 0x00460a8f, 5 instruction(s), ends with je to 0x00460aae (forward)
    mov edx, dword ptr [ebp - local_28]          # 00460a95
    {load} xor eax, eax                          # 00460a98
    mov al, byte ptr [edx + field_299]           # 00460a9a
    test eax, eax                                # 00460aa0
    je.d8 L_00460aae                             # 00460aa2
    # block 0x00460aa4: entered by fall-through of je at 0x00460aa2, 2 instruction(s), falls into the block at 0x00460aae
    mov ecx, dword ptr [ebp - local_28]          # 00460aa4
    mov byte ptr [ecx + field_299], 0x0          # 00460aa7
L_00460aae:
    # block 0x00460aae: entered by je at 0x00460aa2, 3 instruction(s), ends with jne to 0x00460b25 (forward)
    mov edx, dword ptr [ebp - local_28]          # 00460aae
    cmp dword ptr [edx + field_3a2], 0xc         # 00460ab1
    jne.d8 L_00460b25                            # 00460ab8
    # block 0x00460aba: entered by fall-through of jne at 0x00460ab8, 20 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x00460b37
    mov eax, dword ptr [ebp - local_28]          # 00460aba
    mov dword ptr [eax + field_37d], 0x64        # 00460abd
    mov ecx, dword ptr [ebp - local_28]          # 00460ac7
    mov word ptr [ecx + field_2d1], 0x0          # 00460aca
    call dword ptr [0x52a23c]                    # 00460ad3
    mov edx, dword ptr [ebp - local_28]          # 00460ad9
    add eax, dword ptr [edx + field_37d]         # 00460adc
    mov ecx, dword ptr [ebp - local_28]          # 00460ae2
    mov dword ptr [ecx + field_379], eax         # 00460ae5
    call dword ptr [0x52a23c]                    # 00460aeb
    add eax, 0x7d0                               # 00460af1
    mov edx, dword ptr [ebp - local_28]          # 00460af6
    mov dword ptr [edx + field_375], eax         # 00460af9
    mov eax, dword ptr [ebp - local_28]          # 00460aff
    mov dword ptr [eax + field_39e], 0xb         # 00460b02
    mov ecx, dword ptr [ebp - local_28]          # 00460b0c
    mov dword ptr [ecx + field_3a6], 0xc         # 00460b0f
    mov edx, dword ptr [ebp - local_28]          # 00460b19
    mov byte ptr [edx + field_2aa], 0x1          # 00460b1c
    jmp.d8 L_00460b37                            # 00460b23
L_00460b25:
    # block 0x00460b25: entered by jne at 0x00460ab8, 4 instruction(s), falls into the block at 0x00460b37
    mov eax, dword ptr [ebp - local_28]          # 00460b25
    mov ecx, dword ptr [ebp - local_28]          # 00460b28
    mov edx, dword ptr [ecx + field_3a2]         # 00460b2b
    mov dword ptr [eax + field_39e], edx         # 00460b31
L_00460b37:
    # block 0x00460b37: entered by jne at 0x00460a8f; jmp at 0x00460b23, 1 instruction(s), ends with forward jump to 0x00460bde
    jmp.d32 L_00460bde                           # 00460b37
L_00460b3c:
    # block 0x00460b3c: entered by switch case, 5 instruction(s), ends with je to 0x00460b98 (forward)
    mov eax, dword ptr [ebp - local_28]          # 00460b3c
    {load} xor ecx, ecx                          # 00460b3f
    mov cl, byte ptr [eax + field_2aa]           # 00460b41
    test ecx, ecx                                # 00460b47
    je.d8 L_00460b98                             # 00460b49
    # block 0x00460b4b: entered by fall-through of je at 0x00460b49, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x00460b98 (forward)
    call dword ptr [0x52a23c]                    # 00460b4b
    mov edx, dword ptr [ebp - local_28]          # 00460b51
    cmp eax, dword ptr [edx + field_379]         # 00460b54
    jb.d8 L_00460b98                             # 00460b5a
    # block 0x00460b5c: entered by fall-through of jb at 0x00460b5a, 5 instruction(s), ends with jns to 0x00460b76 (forward)
    mov eax, dword ptr [ebp - local_28]          # 00460b5c
    movsx ecx, word ptr [eax + field_2d1]        # 00460b5f
    add ecx, 0x1                                 # 00460b66
    and ecx, 0x80000001                          # 00460b69
    jns.d8 L_00460b76                            # 00460b6f
    # block 0x00460b71: entered by fall-through of jns at 0x00460b6f, 3 instruction(s), falls into the block at 0x00460b76
    dec ecx                                      # 00460b71
    or ecx, -0x2                                 # 00460b72
    inc ecx                                      # 00460b75
L_00460b76:
    # block 0x00460b76: entered by jns at 0x00460b6f, 7 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x00460b98
    mov edx, dword ptr [ebp - local_28]          # 00460b76
    mov word ptr [edx + field_2d1], cx           # 00460b79
    call dword ptr [0x52a23c]                    # 00460b80
    mov ecx, dword ptr [ebp - local_28]          # 00460b86
    add eax, dword ptr [ecx + field_37d]         # 00460b89
    mov edx, dword ptr [ebp - local_28]          # 00460b8f
    mov dword ptr [edx + field_379], eax         # 00460b92
L_00460b98:
    # block 0x00460b98: entered by je at 0x00460b49; jb at 0x00460b5a, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x00460bbb (forward)
    call dword ptr [0x52a23c]                    # 00460b98
    mov ecx, dword ptr [ebp - local_28]          # 00460b9e
    cmp eax, dword ptr [ecx + field_375]         # 00460ba1
    jb.d8 L_00460bbb                             # 00460ba7
    # block 0x00460ba9: entered by fall-through of jb at 0x00460ba7, 4 instruction(s), falls into the block at 0x00460bbb
    mov edx, dword ptr [ebp - local_28]          # 00460ba9
    mov eax, dword ptr [ebp - local_28]          # 00460bac
    mov ecx, dword ptr [eax + field_3a6]         # 00460baf
    mov dword ptr [edx + field_39e], ecx         # 00460bb5
L_00460bbb:
    # block 0x00460bbb: entered by jb at 0x00460ba7, 1 instruction(s), ends with forward jump to 0x00460bde
    jmp.d8 L_00460bde                            # 00460bbb
L_00460bbd:
    # block 0x00460bbd: entered by switch case, 6 instruction(s), falls into the block at 0x00460bde
    mov edx, dword ptr [ebp - local_28]          # 00460bbd
    movsx eax, word ptr [edx + field_1e]         # 00460bc0
    imul eax, eax, 0x8d                          # 00460bc4
    mov dword ptr [eax + 0x5bb632], 0x2          # 00460bca
    mov ecx, dword ptr [ebp - local_28]          # 00460bd4
    mov byte ptr [ecx + field_2aa], 0x1          # 00460bd7
L_00460bde:
    # block 0x00460bde: entered by ja at 0x0045f634; jmp at 0x0045f680; jmp at 0x0045f7fb; jmp at 0x0045fbbe; more, 1 instruction(s), ends with forward jump to 0x00460ede
    jmp.d32 L_00460ede                           # 00460bde
L_00460be3:
    # block 0x00460be3: entered by je at 0x0045f118, 6 instruction(s), ends with je to 0x00460ce8 (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 00460be3
    mov edx, dword ptr [ebp - local_28]          # 00460bed
    {load} xor eax, eax                          # 00460bf0
    mov al, byte ptr [edx + field_39d]           # 00460bf2
    test eax, eax                                # 00460bf8
    je.d32 L_00460ce8                            # 00460bfa
    # block 0x00460c00: entered by fall-through of je at 0x00460bfa, 5 instruction(s), ends with je to 0x00460ce3 (forward)
    mov ecx, dword ptr [ebp - local_28]          # 00460c00
    mov edx, dword ptr [ecx + field_31d]         # 00460c03
    movsx eax, word ptr [edx + field_1320]       # 00460c09
    cmp eax, 0x270f                              # 00460c10
    je.d32 L_00460ce3                            # 00460c15
    # block 0x00460c1b: entered by fall-through of je at 0x00460c15, 33 instruction(s), ends with jne to 0x00460ccf (forward)
    mov ecx, dword ptr [ebp - local_28]          # 00460c1b
    mov edx, dword ptr [ecx + field_31d]         # 00460c1e
    movsx eax, word ptr [edx + field_1320]       # 00460c24
    mov dword ptr [0x5bb57b], eax                # 00460c2b
    mov ecx, dword ptr [ebp - local_28]          # 00460c30
    mov edx, dword ptr [ecx + field_31d]         # 00460c33
    mov ax, word ptr [edx + field_1322]          # 00460c39
    mov word ptr [0x5bb599], ax                  # 00460c40
    mov ecx, dword ptr [ebp - local_28]          # 00460c46
    mov edx, dword ptr [ecx + field_31d]         # 00460c49
    mov ax, word ptr [edx + field_1324]          # 00460c4f
    mov word ptr [0x5bb595], ax                  # 00460c56
    mov ecx, dword ptr [ebp - local_28]          # 00460c5c
    mov edx, dword ptr [ecx + field_31d]         # 00460c5f
    mov ax, word ptr [edx + field_1326]          # 00460c65
    mov word ptr [0x5c39ff], ax                  # 00460c6c
    mov ecx, dword ptr [ebp - local_28]          # 00460c72
    mov edx, dword ptr [ecx + field_31d]         # 00460c75
    mov eax, dword ptr [edx + field_1328]        # 00460c7b
    mov dword ptr [0x5bb59b], eax                # 00460c81
    mov ecx, dword ptr [ebp - local_28]          # 00460c86
    mov edx, dword ptr [ecx + field_31d]         # 00460c89
    mov eax, dword ptr [edx + field_132c]        # 00460c8f
    mov dword ptr [0x5bb59f], eax                # 00460c95
    mov ecx, dword ptr [ebp - local_28]          # 00460c9a
    mov edx, dword ptr [ecx + field_31d]         # 00460c9d
    mov eax, dword ptr [edx + field_1330]        # 00460ca3
    mov dword ptr [0x5bb5a3], eax                # 00460ca9
    mov ecx, dword ptr [ebp - local_28]          # 00460cae
    mov edx, dword ptr [ecx + field_31d]         # 00460cb1
    movsx eax, word ptr [edx + field_1334]       # 00460cb7
    cmp eax, 0x1                                 # 00460cbe
    jne.d8 L_00460ccf                            # 00460cc1
    # block 0x00460cc3: entered by fall-through of jne at 0x00460cc1, 2 instruction(s), ends with forward jump to 0x00460cd9
    mov dword ptr [0x5bb1ca], 0x0                # 00460cc3
    jmp.d8 L_00460cd9                            # 00460ccd
L_00460ccf:
    # block 0x00460ccf: entered by jne at 0x00460cc1, 1 instruction(s), falls into the block at 0x00460cd9
    mov dword ptr [0x5bb1ca], 0x1                # 00460ccf
L_00460cd9:
    # block 0x00460cd9: entered by jmp at 0x00460ccd, 1 instruction(s), falls into the block at 0x00460ce3
    mov dword ptr [0x583999], 0x4                # 00460cd9
L_00460ce3:
    # block 0x00460ce3: entered by je at 0x00460c15, 1 instruction(s), ends with forward jump to 0x00460ec6
    jmp.d32 L_00460ec6                           # 00460ce3
L_00460ce8:
    # block 0x00460ce8: entered by je at 0x00460bfa, 5 instruction(s), ends with je to 0x00460ec6 (forward)
    mov ecx, dword ptr [ebp - local_28]          # 00460ce8
    {load} xor edx, edx                          # 00460ceb
    mov dl, byte ptr [ecx + field_2aa]           # 00460ced
    test edx, edx                                # 00460cf3
    je.d32 L_00460ec6                            # 00460cf5
    # block 0x00460cfb: entered by fall-through of je at 0x00460cf5, 5 instruction(s), ends with jne to 0x00460d22 (forward)
    mov eax, dword ptr [ebp - local_28]          # 00460cfb
    {load} xor ecx, ecx                          # 00460cfe
    mov cl, byte ptr [eax + field_2a9]           # 00460d00
    test ecx, ecx                                # 00460d06
    jne.d8 L_00460d22                            # 00460d08
    # block 0x00460d0a: entered by fall-through of jne at 0x00460d08, 5 instruction(s), ends with jne to 0x00460d50 (forward)
    mov edx, dword ptr [ebp - local_28]          # 00460d0a
    mov eax, dword ptr [edx + field_31d]         # 00460d0d
    movsx ecx, word ptr [eax + field_1304]       # 00460d13
    cmp ecx, 0x270f                              # 00460d1a
    jne.d8 L_00460d50                            # 00460d20
L_00460d22:
    # block 0x00460d22: entered by jne at 0x00460d08; fall-through of jne at 0x00460d20, 5 instruction(s), ends with je to 0x00460e46 (forward)
    mov edx, dword ptr [ebp - local_28]          # 00460d22
    {load} xor eax, eax                          # 00460d25
    mov al, byte ptr [edx + field_2a9]           # 00460d27
    test eax, eax                                # 00460d2d
    je.d32 L_00460e46                            # 00460d2f
    # block 0x00460d35: entered by fall-through of je at 0x00460d2f, 5 instruction(s), ends with je to 0x00460e46 (forward)
    mov ecx, dword ptr [ebp - local_28]          # 00460d35
    mov edx, dword ptr [ecx + field_31d]         # 00460d38
    movsx eax, word ptr [edx + field_1306]       # 00460d3e
    cmp eax, 0x270f                              # 00460d45
    je.d32 L_00460e46                            # 00460d4a
L_00460d50:
    # block 0x00460d50: entered by jne at 0x00460d20; fall-through of je at 0x00460d4a, 5 instruction(s), ends with je to 0x00460d77 (forward)
    mov ecx, dword ptr [ebp - local_28]          # 00460d50
    {load} xor edx, edx                          # 00460d53
    mov dl, byte ptr [ecx + field_2a9]           # 00460d55
    test edx, edx                                # 00460d5b
    je.d8 L_00460d77                             # 00460d5d
    # block 0x00460d5f: entered by fall-through of je at 0x00460d5d, 5 instruction(s), ends with forward jump to 0x00460d8d
    mov eax, dword ptr [ebp - local_28]          # 00460d5f
    mov ecx, dword ptr [eax + field_31d]         # 00460d62
    movsx edx, word ptr [ecx + field_1306]       # 00460d68
    mov dword ptr [0x5bb57b], edx                # 00460d6f
    jmp.d8 L_00460d8d                            # 00460d75
L_00460d77:
    # block 0x00460d77: entered by je at 0x00460d5d, 4 instruction(s), falls into the block at 0x00460d8d
    mov eax, dword ptr [ebp - local_28]          # 00460d77
    mov ecx, dword ptr [eax + field_31d]         # 00460d7a
    movsx edx, word ptr [ecx + field_1304]       # 00460d80
    mov dword ptr [0x5bb57b], edx                # 00460d87
L_00460d8d:
    # block 0x00460d8d: entered by jmp at 0x00460d75, 29 instruction(s), ends with jne to 0x00460e32 (forward)
    mov eax, dword ptr [ebp - local_28]          # 00460d8d
    mov ecx, dword ptr [eax + field_31d]         # 00460d90
    mov dx, word ptr [ecx + field_1308]          # 00460d96
    mov word ptr [0x5bb599], dx                  # 00460d9d
    mov eax, dword ptr [ebp - local_28]          # 00460da4
    mov ecx, dword ptr [eax + field_31d]         # 00460da7
    mov dx, word ptr [ecx + field_130a]          # 00460dad
    mov word ptr [0x5bb595], dx                  # 00460db4
    mov eax, dword ptr [ebp - local_28]          # 00460dbb
    mov ecx, dword ptr [eax + field_31d]         # 00460dbe
    mov dx, word ptr [ecx + field_130c]          # 00460dc4
    mov word ptr [0x5c39ff], dx                  # 00460dcb
    mov eax, dword ptr [ebp - local_28]          # 00460dd2
    mov ecx, dword ptr [eax + field_31d]         # 00460dd5
    mov edx, dword ptr [ecx + field_130e]        # 00460ddb
    mov dword ptr [0x5bb59b], edx                # 00460de1
    mov eax, dword ptr [ebp - local_28]          # 00460de7
    mov ecx, dword ptr [eax + field_31d]         # 00460dea
    mov edx, dword ptr [ecx + field_1312]        # 00460df0
    mov dword ptr [0x5bb59f], edx                # 00460df6
    mov eax, dword ptr [ebp - local_28]          # 00460dfc
    mov ecx, dword ptr [eax + field_31d]         # 00460dff
    mov edx, dword ptr [ecx + field_1316]        # 00460e05
    mov dword ptr [0x5bb5a3], edx                # 00460e0b
    mov eax, dword ptr [ebp - local_28]          # 00460e11
    mov ecx, dword ptr [eax + field_31d]         # 00460e14
    movsx edx, word ptr [ecx + field_131a]       # 00460e1a
    cmp edx, 0x1                                 # 00460e21
    jne.d8 L_00460e32                            # 00460e24
    # block 0x00460e26: entered by fall-through of jne at 0x00460e24, 2 instruction(s), ends with forward jump to 0x00460e3c
    mov dword ptr [0x5bb1ca], 0x0                # 00460e26
    jmp.d8 L_00460e3c                            # 00460e30
L_00460e32:
    # block 0x00460e32: entered by jne at 0x00460e24, 1 instruction(s), falls into the block at 0x00460e3c
    mov dword ptr [0x5bb1ca], 0x1                # 00460e32
L_00460e3c:
    # block 0x00460e3c: entered by jmp at 0x00460e30, 1 instruction(s), falls into the block at 0x00460e46
    mov dword ptr [0x583999], 0x4                # 00460e3c
L_00460e46:
    # block 0x00460e46: entered by je at 0x00460d2f; je at 0x00460d4a, 5 instruction(s), ends with je to 0x00460e87 (forward)
    mov eax, dword ptr [ebp - local_28]          # 00460e46
    {load} xor ecx, ecx                          # 00460e49
    mov cl, byte ptr [eax + field_2a8]           # 00460e4b
    test ecx, ecx                                # 00460e51
    je.d8 L_00460e87                             # 00460e53
    # block 0x00460e55: entered by fall-through of je at 0x00460e53, 5 instruction(s), ends with je to 0x00460e87 (forward)
    mov edx, dword ptr [ebp - local_28]          # 00460e55
    mov eax, dword ptr [edx + field_31d]         # 00460e58
    movsx ecx, word ptr [eax + field_131c]       # 00460e5e
    cmp ecx, -0x1                                # 00460e65
    je.d8 L_00460e87                             # 00460e68
    # block 0x00460e6a: entered by fall-through of je at 0x00460e68, 5 instruction(s), ends with forward jump to 0x00460ec6
    mov edx, dword ptr [ebp - local_28]          # 00460e6a
    mov eax, dword ptr [edx + field_31d]         # 00460e6d
    movsx ecx, word ptr [eax + field_131c]       # 00460e73
    mov dword ptr [4*ecx + 0x585801], 0x1        # 00460e7a
    jmp.d8 L_00460ec6                            # 00460e85
L_00460e87:
    # block 0x00460e87: entered by je at 0x00460e53; je at 0x00460e68, 5 instruction(s), ends with je to 0x00460ec6 (forward)
    mov edx, dword ptr [ebp - local_28]          # 00460e87
    {load} xor eax, eax                          # 00460e8a
    mov al, byte ptr [edx + field_2a9]           # 00460e8c
    test eax, eax                                # 00460e92
    je.d8 L_00460ec6                             # 00460e94
    # block 0x00460e96: entered by fall-through of je at 0x00460e94, 5 instruction(s), ends with je to 0x00460ec6 (forward)
    mov ecx, dword ptr [ebp - local_28]          # 00460e96
    mov edx, dword ptr [ecx + field_31d]         # 00460e99
    movsx eax, word ptr [edx + field_131e]       # 00460e9f
    cmp eax, -0x1                                # 00460ea6
    je.d8 L_00460ec6                             # 00460ea9
    # block 0x00460eab: entered by fall-through of je at 0x00460ea9, 4 instruction(s), falls into the block at 0x00460ec6
    mov ecx, dword ptr [ebp - local_28]          # 00460eab
    mov edx, dword ptr [ecx + field_31d]         # 00460eae
    movsx eax, word ptr [edx + field_131e]       # 00460eb4
    mov dword ptr [4*eax + 0x585801], 0x1        # 00460ebb
L_00460ec6:
    # block 0x00460ec6: entered by jmp at 0x00460ce3; je at 0x00460cf5; jmp at 0x00460e85; je at 0x00460e94; je at 0x00460ea9, 7 instruction(s), calls FUN_0042ba3a, FUN_0045dd4d, falls into the block at 0x00460ede
    mov ecx, dword ptr [ebp - local_28]          # 00460ec6
    mov dx, word ptr [ecx + field_1e]            # 00460ec9
    push edx                                     # 00460ecd
    call FUN_0042ba3a                            # 00460ece
    add esp, 0x4                                 # 00460ed3
    mov ecx, dword ptr [ebp - local_28]          # 00460ed6
    call FUN_0045dd4d                            # 00460ed9
L_00460ede:
    # block 0x00460ede: entered by jmp at 0x0045f11e; jmp at 0x0045f616; jmp at 0x00460bde, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 00460ede
    pop esi                                      # 00460edf
    {load} mov esp, ebp                          # 00460ee0
    pop ebp                                      # 00460ee2
    ret 0x4                                      # 00460ee3

# --- data items (not part of the function) -------------------------
.org 0x00460ee6 - 0x401000
SWTAB_00460ee6:  # 12 case address(es)
    .long L_004600d6 - .text + 0x401000
    .long L_004605bb - .text + 0x401000
    .long L_004602a7 - .text + 0x401000
    .long L_0045f644 - .text + 0x401000
    .long L_0045f685 - .text + 0x401000
    .long L_0045f800 - .text + 0x401000
    .long L_0045fbc3 - .text + 0x401000
    .long L_0046074a - .text + 0x401000
    .long L_00460857 - .text + 0x401000
    .long L_00460a72 - .text + 0x401000
    .long L_00460b3c - .text + 0x401000
    .long L_00460bbd - .text + 0x401000
.set SWTAB_00460ee6_VA, SWTAB_00460ee6 - .text + 0x401000

