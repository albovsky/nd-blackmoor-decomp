# FUN_004d7162
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d7162
# extent:       0x004d7162-0x004d7915 (1971 code bytes)
# span:         0x004d7162-0x004d794d (code 1971, tables 56, padding 0)
# sha256:       7ba3864102959431b3ad0ad9864479750ef16826de1284b0945b6fab65984e1f
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d7162
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       9 ebp-relative slot(s): local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28
# fields:       [eax + n] field_4, field_449, field_455, field_459, field_46d, field_472, field_951a, field_9536, field_953e, field_9542, field_9556, field_955a and 6 more; [ecx + n] field_451, field_455, field_459, field_9516, field_951a, field_951e, field_953e, field_9542, field_955a, field_955e, field_9562, field_9566 and 3 more; [edx + n] field_4, field_449, field_44d, field_451, field_455, field_45d, field_472, field_951a, field_951e, field_953e, field_9542, field_955a and 10 more
# callees:      calls FUN_004daeb5, FUN_004dae88, FUN_004d6824, FUN_004d696d, FUN_004d65e9, FUN_004daef1, FUN_004fb2e3, KERNEL32.dll!GetTickCount, FUN_004d6ad1, FUN_004dad60, FUN_004d6b48, FUN_004f6334, FUN_0050ca3e, FUN_0050cd72, FUN_00449d90, FUN_004d7a15 and 4 more
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 450 instruction(s), 33 conditional branch(es) and 3 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ field_4, 0x4  # offset +0x4
.equ field_449, 0x449  # offset +0x449
.equ field_44d, 0x44d  # offset +0x44d
.equ field_451, 0x451  # offset +0x451
.equ field_455, 0x455  # offset +0x455
.equ field_459, 0x459  # offset +0x459
.equ field_45d, 0x45d  # offset +0x45d
.equ field_46d, 0x46d  # offset +0x46d
.equ field_472, 0x472  # offset +0x472
.equ field_9516, 0x9516  # offset +0x9516
.equ field_951a, 0x951a  # offset +0x951a
.equ field_951e, 0x951e  # offset +0x951e
.equ field_9536, 0x9536  # offset +0x9536
.equ field_953e, 0x953e  # offset +0x953e
.equ field_9542, 0x9542  # offset +0x9542
.equ field_9556, 0x9556  # offset +0x9556
.equ field_955a, 0x955a  # offset +0x955a
.equ field_955e, 0x955e  # offset +0x955e
.equ field_9562, 0x9562  # offset +0x9562
.equ field_9566, 0x9566  # offset +0x9566
.equ field_956a, 0x956a  # offset +0x956a
.equ field_956e, 0x956e  # offset +0x956e
.equ field_957a, 0x957a  # offset +0x957a
.equ field_9582, 0x9582  # offset +0x9582
.equ field_95a6, 0x95a6  # offset +0x95a6
.equ field_95aa, 0x95aa  # offset +0x95aa

# --- external targets -----------------------------------------------
.set FUN_00449d90, .text + (0x00449d90 - 0x401000)
.set FUN_004cf7e0, .text + (0x004cf7e0 - 0x401000)
.set FUN_004d65e9, .text + (0x004d65e9 - 0x401000)
.set FUN_004d6824, .text + (0x004d6824 - 0x401000)
.set FUN_004d696d, .text + (0x004d696d - 0x401000)
.set FUN_004d6ad1, .text + (0x004d6ad1 - 0x401000)
.set FUN_004d6b48, .text + (0x004d6b48 - 0x401000)
.set FUN_004d79c7, .text + (0x004d79c7 - 0x401000)
.set FUN_004d7a15, .text + (0x004d7a15 - 0x401000)
.set FUN_004d812e, .text + (0x004d812e - 0x401000)
.set FUN_004d8618, .text + (0x004d8618 - 0x401000)
.set FUN_004dad60, .text + (0x004dad60 - 0x401000)
.set FUN_004dae88, .text + (0x004dae88 - 0x401000)
.set FUN_004daeb5, .text + (0x004daeb5 - 0x401000)
.set FUN_004daef1, .text + (0x004daef1 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cd72, .text + (0x0050cd72 - 0x401000)

.org 0x004d7162 - 0x401000
.globl FUN_004d7162
FUN_004d7162:
    # block 0x004d7162: entry, 11 instruction(s), ends with ja to 0x004d7902 (forward)
    push ebp                                     # 004d7162
    {load} mov ebp, esp                          # 004d7163
    sub esp, 0x28                                # 004d7165
    push esi                                     # 004d7168
    push edi                                     # 004d7169
    mov dword ptr [ebp - local_18], ecx          # 004d716a
    mov eax, dword ptr [ebp - local_18]          # 004d716d
    mov ecx, dword ptr [eax + field_455]         # 004d7170
    mov dword ptr [ebp - local_1c], ecx          # 004d7176
    cmp dword ptr [ebp - local_1c], 0x3          # 004d7179
    ja.d32 L_004d7902                            # 004d717d
    # block 0x004d7183: entered by fall-through of ja at 0x004d717d, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4d7915]
    mov edx, dword ptr [ebp - local_1c]          # 004d7183
    jmp dword ptr [4*edx + SWTAB_004d7915_VA]    # 004d7186
L_004d718d:
    # block 0x004d718d: entered by switch case, 19 instruction(s), calls FUN_004daeb5, ends with jne to 0x004d71f2 (forward)
    lea eax, [ebp - local_8]                     # 004d718d
    push eax                                     # 004d7190
    mov ecx, 0x5830a6                            # 004d7191
    call FUN_004daeb5                            # 004d7196
    mov ecx, dword ptr [eax]                     # 004d719b
    mov edx, dword ptr [eax + field_4]           # 004d719d
    mov dword ptr [0x5830e2], ecx                # 004d71a0
    mov dword ptr [0x5830e6], edx                # 004d71a6
    mov eax, dword ptr [0x5830e2]                # 004d71ac
    mov dword ptr [0x5c3a53], eax                # 004d71b1
    mov ecx, dword ptr [0x5830e6]                # 004d71b6
    mov dword ptr [0x5c3a57], ecx                # 004d71bc
    mov edx, dword ptr [0x5830ea]                # 004d71c2
    mov dword ptr [ebp - local_10], edx          # 004d71c8
    mov eax, dword ptr [0x5830ee]                # 004d71cb
    mov dword ptr [ebp - local_c], eax           # 004d71d0
    mov ecx, dword ptr [0x5830e2]                # 004d71d3
    cmp ecx, dword ptr [ebp - local_10]          # 004d71d9
    jne.d8 L_004d71f2                            # 004d71dc
    # block 0x004d71de: entered by fall-through of jne at 0x004d71dc, 3 instruction(s), ends with jne to 0x004d71f2 (forward)
    mov edx, dword ptr [0x5830e6]                # 004d71de
    cmp edx, dword ptr [ebp - local_c]           # 004d71e4
    jne.d8 L_004d71f2                            # 004d71e7
    # block 0x004d71e9: entered by fall-through of jne at 0x004d71e7, 2 instruction(s), ends with forward jump to 0x004d71f9
    mov dword ptr [ebp - local_20], 0x0          # 004d71e9
    jmp.d8 L_004d71f9                            # 004d71f0
L_004d71f2:
    # block 0x004d71f2: entered by jne at 0x004d71dc; jne at 0x004d71e7, 1 instruction(s), falls into the block at 0x004d71f9
    mov dword ptr [ebp - local_20], 0x1          # 004d71f2
L_004d71f9:
    # block 0x004d71f9: entered by jmp at 0x004d71f0, 2 instruction(s), ends with je to 0x004d730d (forward)
    cmp dword ptr [ebp - local_20], 0x0          # 004d71f9
    je.d32 L_004d730d                            # 004d71fd
    # block 0x004d7203: entered by fall-through of je at 0x004d71fd, 13 instruction(s), ends with jle to 0x004d725c (forward)
    mov eax, dword ptr [0x583102]                # 004d7203
    mov dword ptr [0x5830f2], eax                # 004d7208
    mov ecx, dword ptr [0x583106]                # 004d720d
    mov dword ptr [0x5830f6], ecx                # 004d7213
    mov edx, dword ptr [0x58310a]                # 004d7219
    mov dword ptr [0x5830fa], edx                # 004d721f
    mov eax, dword ptr [0x58310e]                # 004d7225
    mov dword ptr [0x5830fe], eax                # 004d722a
    movsx ecx, word ptr [0x63988b]               # 004d722f
    mov edx, dword ptr [ebp - local_18]          # 004d7236
    sub ecx, dword ptr [edx + field_953e]        # 004d7239
    cmp dword ptr [0x5830e2], ecx                # 004d723f
    jle.d8 L_004d725c                            # 004d7245
    # block 0x004d7247: entered by fall-through of jle at 0x004d7245, 4 instruction(s), falls into the block at 0x004d725c
    movsx eax, word ptr [0x63988b]               # 004d7247
    mov ecx, dword ptr [ebp - local_18]          # 004d724e
    sub eax, dword ptr [ecx + field_953e]        # 004d7251
    mov dword ptr [0x5830e2], eax                # 004d7257
L_004d725c:
    # block 0x004d725c: entered by jle at 0x004d7245, 5 instruction(s), ends with jle to 0x004d728a (forward)
    movsx edx, word ptr [0x63988d]               # 004d725c
    mov eax, dword ptr [ebp - local_18]          # 004d7263
    sub edx, dword ptr [eax + field_9542]        # 004d7266
    cmp dword ptr [0x5830e6], edx                # 004d726c
    jle.d8 L_004d728a                            # 004d7272
    # block 0x004d7274: entered by fall-through of jle at 0x004d7272, 4 instruction(s), falls into the block at 0x004d728a
    movsx ecx, word ptr [0x63988d]               # 004d7274
    mov edx, dword ptr [ebp - local_18]          # 004d727b
    sub ecx, dword ptr [edx + field_9542]        # 004d727e
    mov dword ptr [0x5830e6], ecx                # 004d7284
L_004d728a:
    # block 0x004d728a: entered by jle at 0x004d7272, 26 instruction(s), calls FUN_004dae88, falls into the block at 0x004d730d
    mov eax, dword ptr [0x5830e6]                # 004d728a
    mov dword ptr [0x583106], eax                # 004d728f
    mov ecx, dword ptr [ebp - local_18]          # 004d7294
    mov edx, dword ptr [ecx + field_9542]        # 004d7297
    mov eax, dword ptr [0x583106]                # 004d729d
    lea ecx, [eax + edx - field_minus_1]         # 004d72a2
    mov dword ptr [0x58310e], ecx                # 004d72a6
    mov edx, dword ptr [0x5830e2]                # 004d72ac
    mov dword ptr [0x583102], edx                # 004d72b2
    mov eax, dword ptr [ebp - local_18]          # 004d72b8
    mov ecx, dword ptr [eax + field_953e]        # 004d72bb
    mov edx, dword ptr [0x583102]                # 004d72c1
    lea eax, [edx + ecx - field_minus_1]         # 004d72c7
    mov dword ptr [0x58310a], eax                # 004d72cb
    mov ecx, dword ptr [0x5830e6]                # 004d72d0
    push ecx                                     # 004d72d6
    mov edx, dword ptr [0x5830e2]                # 004d72d7
    push edx                                     # 004d72dd
    mov ecx, 0x5830a6                            # 004d72de
    call FUN_004dae88                            # 004d72e3
    mov eax, dword ptr [ebp - local_18]          # 004d72e8
    mov dword ptr [eax + field_9536], 0x1        # 004d72eb
    mov ecx, dword ptr [0x5830e2]                # 004d72f5
    mov dword ptr [0x5830ea], ecx                # 004d72fb
    mov edx, dword ptr [0x5830e6]                # 004d7301
    mov dword ptr [0x5830ee], edx                # 004d7307
L_004d730d:
    # block 0x004d730d: entered by je at 0x004d71fd, 7 instruction(s), calls FUN_004d6824, ends with je to 0x004d7341 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004d730d
    call FUN_004d6824                            # 004d7310
    mov ecx, dword ptr [ebp - local_18]          # 004d7315
    mov dword ptr [ecx + field_9566], eax        # 004d7318
    mov edx, dword ptr [ebp - local_18]          # 004d731e
    cmp dword ptr [edx + field_9566], -0x1       # 004d7321
    je.d8 L_004d7341                             # 004d7328
    # block 0x004d732a: entered by fall-through of je at 0x004d7328, 4 instruction(s), falls into the block at 0x004d7341
    mov eax, dword ptr [ebp - local_18]          # 004d732a
    mov ecx, dword ptr [eax + field_9566]        # 004d732d
    mov edx, dword ptr [ebp - local_18]          # 004d7333
    mov dword ptr [edx + 4*ecx + field_956e], 0x3 # 004d7336
L_004d7341:
    # block 0x004d7341: entered by je at 0x004d7328, 7 instruction(s), calls FUN_004d696d, ends with je to 0x004d73a0 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004d7341
    call FUN_004d696d                            # 004d7344
    mov ecx, dword ptr [ebp - local_18]          # 004d7349
    mov dword ptr [ecx + field_956a], eax        # 004d734c
    mov edx, dword ptr [ebp - local_18]          # 004d7352
    cmp dword ptr [edx + field_956a], -0x1       # 004d7355
    je.d8 L_004d73a0                             # 004d735c
    # block 0x004d735e: entered by fall-through of je at 0x004d735c, 16 instruction(s), calls FUN_004d65e9, falls into the block at 0x004d73a0
    mov eax, dword ptr [ebp - local_18]          # 004d735e
    mov ecx, dword ptr [eax + field_956a]        # 004d7361
    mov edx, dword ptr [ebp - local_18]          # 004d7367
    mov dword ptr [edx + 4*ecx + field_9582], 0x2 # 004d736a
    mov eax, dword ptr [ebp - local_18]          # 004d7375
    mov ecx, dword ptr [eax + field_956a]        # 004d7378
    imul ecx, ecx, 0x21                          # 004d737e
    mov edx, dword ptr [ebp - local_18]          # 004d7381
    lea eax, [edx + ecx + field_95aa]            # 004d7384
    push eax                                     # 004d738b
    push 0x2                                     # 004d738c
    mov ecx, dword ptr [ebp - local_18]          # 004d738e
    mov edx, dword ptr [ecx + field_956a]        # 004d7391
    push edx                                     # 004d7397
    mov ecx, dword ptr [ebp - local_18]          # 004d7398
    call FUN_004d65e9                            # 004d739b
L_004d73a0:
    # block 0x004d73a0: entered by je at 0x004d735c, 4 instruction(s), calls FUN_004daef1, ends with jne to 0x004d75f6 (forward)
    mov ecx, 0x5830a6                            # 004d73a0
    call FUN_004daef1                            # 004d73a5
    cmp eax, 0x2                                 # 004d73aa
    jne.d32 L_004d75f6                           # 004d73ad
    # block 0x004d73b3: entered by fall-through of jne at 0x004d73ad, 3 instruction(s), ends with je to 0x004d748c (forward)
    mov eax, dword ptr [ebp - local_18]          # 004d73b3
    cmp dword ptr [eax + field_9566], -0x1       # 004d73b6
    je.d32 L_004d748c                            # 004d73bd
    # block 0x004d73c3: entered by fall-through of je at 0x004d73bd, 9 instruction(s), ends with ja to 0x004d744b (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004d73c3
    mov edx, dword ptr [ebp - local_18]          # 004d73c6
    mov eax, dword ptr [edx + field_9566]        # 004d73c9
    mov dword ptr [ecx + field_955e], eax        # 004d73cf
    mov ecx, dword ptr [ebp - local_18]          # 004d73d5
    mov edx, dword ptr [ecx + field_955e]        # 004d73d8
    mov dword ptr [ebp - local_24], edx          # 004d73de
    cmp dword ptr [ebp - local_24], 0x4          # 004d73e1
    ja.d8 L_004d744b                             # 004d73e5
    # block 0x004d73e7: entered by fall-through of ja at 0x004d73e5, 2 instruction(s), ends with indirect jump dword ptr [4*eax + 0x4d7925]
    mov eax, dword ptr [ebp - local_24]          # 004d73e7
    jmp dword ptr [4*eax + SWTAB_004d7925_VA]    # 004d73ea
L_004d73f1:
    # block 0x004d73f1: entered by switch case, 5 instruction(s), calls FUN_004fb2e3, ends with forward jump to 0x004d744b
    push 0x14                                    # 004d73f1
    mov ecx, 0x5c3a67                            # 004d73f3
    call FUN_004fb2e3                            # 004d73f8
    mov word ptr [0x63a998], 0x14                # 004d73fd
    jmp.d8 L_004d744b                            # 004d7406
L_004d7408:
    # block 0x004d7408: entered by switch case, 5 instruction(s), calls FUN_004fb2e3, ends with forward jump to 0x004d744b
    push 0x17                                    # 004d7408
    mov ecx, 0x5c3a67                            # 004d740a
    call FUN_004fb2e3                            # 004d740f
    mov word ptr [0x63a998], 0x17                # 004d7414
    jmp.d8 L_004d744b                            # 004d741d
L_004d741f:
    # block 0x004d741f: entered by switch case, 5 instruction(s), calls FUN_004fb2e3, ends with forward jump to 0x004d744b
    push 0x14                                    # 004d741f
    mov ecx, 0x5c3a67                            # 004d7421
    call FUN_004fb2e3                            # 004d7426
    mov word ptr [0x63a998], 0x14                # 004d742b
    jmp.d8 L_004d744b                            # 004d7434
L_004d7436:
    # block 0x004d7436: entered by switch case, 4 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004d744b
    push 0x17                                    # 004d7436
    mov ecx, 0x5c3a67                            # 004d7438
    call FUN_004fb2e3                            # 004d743d
    mov word ptr [0x63a998], 0x17                # 004d7442
L_004d744b:
    # block 0x004d744b: entered by ja at 0x004d73e5; jmp at 0x004d7406; jmp at 0x004d741d; jmp at 0x004d7434, 12 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x004d75ec
    mov ecx, dword ptr [ebp - local_18]          # 004d744b
    mov edx, dword ptr [ecx + field_955e]        # 004d744e
    mov eax, dword ptr [ebp - local_18]          # 004d7454
    mov dword ptr [eax + 4*edx + field_956e], 0x2 # 004d7457
    call dword ptr [0x52a23c]                    # 004d7462
    movsx ecx, word ptr [0x5b0282]               # 004d7468
    {load} add eax, ecx                          # 004d746f
    mov edx, dword ptr [ebp - local_18]          # 004d7471
    mov dword ptr [edx + field_451], eax         # 004d7474
    mov eax, dword ptr [ebp - local_18]          # 004d747a
    mov dword ptr [eax + field_455], 0x1         # 004d747d
    jmp.d32 L_004d75ec                           # 004d7487
L_004d748c:
    # block 0x004d748c: entered by je at 0x004d73bd, 3 instruction(s), ends with je to 0x004d75ec (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004d748c
    cmp dword ptr [ecx + field_956a], -0x1       # 004d748f
    je.d32 L_004d75ec                            # 004d7496
    # block 0x004d749c: entered by fall-through of je at 0x004d7496, 9 instruction(s), ends with jl to 0x004d75a2 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004d749c
    mov eax, dword ptr [ebp - local_18]          # 004d749f
    mov ecx, dword ptr [eax + field_956a]        # 004d74a2
    mov dword ptr [edx + field_9562], ecx        # 004d74a8
    mov edx, dword ptr [ebp - local_18]          # 004d74ae
    mov dword ptr [edx + field_955e], 0xffffffff # 004d74b1
    mov eax, dword ptr [ebp - local_18]          # 004d74bb
    cmp dword ptr [eax + field_9562], 0x0        # 004d74be
    jl.d32 L_004d75a2                            # 004d74c5
    # block 0x004d74cb: entered by fall-through of jl at 0x004d74c5, 3 instruction(s), ends with jg to 0x004d75a2 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004d74cb
    cmp dword ptr [ecx + field_9562], 0x8        # 004d74ce
    jg.d32 L_004d75a2                            # 004d74d5
    # block 0x004d74db: entered by fall-through of jg at 0x004d74d5, 2 instruction(s), ends with je to 0x004d7593 (forward)
    cmp dword ptr [0x5bb1e2], 0x0                # 004d74db
    je.d32 L_004d7593                            # 004d74e2
    # block 0x004d74e8: entered by fall-through of je at 0x004d74e2, 40 instruction(s), ends with jne to 0x004d7593 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004d74e8
    mov eax, dword ptr [edx + field_9562]        # 004d74eb
    imul eax, eax, 0x21                          # 004d74f1
    mov ecx, dword ptr [ebp - local_18]          # 004d74f4
    lea edx, [ecx + eax + field_95aa]            # 004d74f7
    {load} mov edi, edx                          # 004d74fe
    mov edx, 0x63a565                            # 004d7500
    or ecx, -0x1                                 # 004d7505
    {load} xor eax, eax                          # 004d7508
    repne scasb al, byte ptr es:[edi]            # 004d750a
    not ecx                                      # 004d750c
    {load} sub edi, ecx                          # 004d750e
    {load} mov esi, edi                          # 004d7510
    {load} mov eax, ecx                          # 004d7512
    {load} mov edi, edx                          # 004d7514
    shr ecx, 0x2                                 # 004d7516
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d7519
    {load} mov ecx, eax                          # 004d751b
    and ecx, 0x3                                 # 004d751d
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004d7520
    mov edi, 0x63a565                            # 004d7522
    mov ecx, dword ptr [ebp - local_18]          # 004d7527
    add ecx, 0x96d3                              # 004d752a
    {load} mov edx, ecx                          # 004d7530
    or ecx, -0x1                                 # 004d7532
    {load} xor eax, eax                          # 004d7535
    repne scasb al, byte ptr es:[edi]            # 004d7537
    not ecx                                      # 004d7539
    {load} sub edi, ecx                          # 004d753b
    {load} mov esi, edi                          # 004d753d
    {load} mov eax, ecx                          # 004d753f
    {load} mov edi, edx                          # 004d7541
    shr ecx, 0x2                                 # 004d7543
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d7546
    {load} mov ecx, eax                          # 004d7548
    and ecx, 0x3                                 # 004d754a
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004d754d
    mov ecx, dword ptr [ebp - local_18]          # 004d754f
    cmp dword ptr [ecx + field_955a], 0x0        # 004d7552
    jne.d8 L_004d7593                            # 004d7559
    # block 0x004d755b: entered by fall-through of jne at 0x004d7559, 13 instruction(s), calls FUN_004d65e9, falls into the block at 0x004d7593
    mov edx, dword ptr [ebp - local_18]          # 004d755b
    mov dword ptr [edx + field_956e], 0x1        # 004d755e
    mov eax, dword ptr [ebp - local_18]          # 004d7568
    mov dword ptr [eax + field_95a6], 0x1        # 004d756b
    mov ecx, dword ptr [ebp - local_18]          # 004d7575
    add ecx, 0x96d3                              # 004d7578
    push ecx                                     # 004d757e
    mov edx, dword ptr [ebp - local_18]          # 004d757f
    mov eax, dword ptr [edx + field_95a6]        # 004d7582
    push eax                                     # 004d7588
    push 0x9                                     # 004d7589
    mov ecx, dword ptr [ebp - local_18]          # 004d758b
    call FUN_004d65e9                            # 004d758e
L_004d7593:
    # block 0x004d7593: entered by je at 0x004d74e2; jne at 0x004d7559, 3 instruction(s), ends with forward jump to 0x004d75af
    mov ecx, dword ptr [ebp - local_18]          # 004d7593
    mov dword ptr [ecx + field_957a], 0x1        # 004d7596
    jmp.d8 L_004d75af                            # 004d75a0
L_004d75a2:
    # block 0x004d75a2: entered by jl at 0x004d74c5; jg at 0x004d74d5, 2 instruction(s), falls into the block at 0x004d75af
    mov edx, dword ptr [ebp - local_18]          # 004d75a2
    mov dword ptr [edx + field_957a], 0x4        # 004d75a5
L_004d75af:
    # block 0x004d75af: entered by jmp at 0x004d75a0, 3 instruction(s), ends with jne to 0x004d75d2 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004d75af
    cmp dword ptr [eax + field_9562], 0x9        # 004d75b2
    jne.d8 L_004d75d2                            # 004d75b9
    # block 0x004d75bb: entered by fall-through of jne at 0x004d75b9, 5 instruction(s), calls FUN_004d6ad1, ends with forward jump to 0x004d75ec
    mov ecx, dword ptr [ebp - local_18]          # 004d75bb
    mov dword ptr [ecx + field_459], 0x1         # 004d75be
    mov ecx, dword ptr [ebp - local_18]          # 004d75c8
    call FUN_004d6ad1                            # 004d75cb
    jmp.d8 L_004d75ec                            # 004d75d0
L_004d75d2:
    # block 0x004d75d2: entered by jne at 0x004d75b9, 4 instruction(s), falls into the block at 0x004d75ec
    mov edx, dword ptr [ebp - local_18]          # 004d75d2
    mov dword ptr [edx + field_45d], 0x1         # 004d75d5
    mov eax, dword ptr [ebp - local_18]          # 004d75df
    mov dword ptr [eax + field_459], 0x0         # 004d75e2
L_004d75ec:
    # block 0x004d75ec: entered by jmp at 0x004d7487; je at 0x004d7496; jmp at 0x004d75d0, 2 instruction(s), calls FUN_004dad60, falls into the block at 0x004d75f6
    mov ecx, 0x5830a6                            # 004d75ec
    call FUN_004dad60                            # 004d75f1
L_004d75f6:
    # block 0x004d75f6: entered by jne at 0x004d73ad, 3 instruction(s), ends with je to 0x004d760c (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004d75f6
    cmp dword ptr [ecx + field_459], 0x0         # 004d75f9
    je.d8 L_004d760c                             # 004d7600
    # block 0x004d7602: entered by fall-through of je at 0x004d7600, 3 instruction(s), calls FUN_004d6b48, ends with forward jump to 0x004d7667
    mov ecx, dword ptr [ebp - local_18]          # 004d7602
    call FUN_004d6b48                            # 004d7605
    jmp.d8 L_004d7667                            # 004d760a
L_004d760c:
    # block 0x004d760c: entered by je at 0x004d7600, 3 instruction(s), ends with je to 0x004d7667 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004d760c
    cmp dword ptr [edx + field_45d], 0x0         # 004d760f
    je.d8 L_004d7667                             # 004d7616
    # block 0x004d7618: entered by fall-through of je at 0x004d7616, 4 instruction(s), ends with jne to 0x004d7667 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004d7618
    movsx ecx, byte ptr [eax + field_46d]        # 004d761b
    cmp ecx, 0xd                                 # 004d7622
    jne.d8 L_004d7667                            # 004d7625
    # block 0x004d7627: entered by fall-through of jne at 0x004d7625, 3 instruction(s), ends with je to 0x004d7667 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004d7627
    cmp dword ptr [edx + field_472], 0x0         # 004d762a
    je.d8 L_004d7667                             # 004d7631
    # block 0x004d7633: entered by fall-through of je at 0x004d7631, 8 instruction(s), falls into the block at 0x004d7667
    mov eax, dword ptr [ebp - local_18]          # 004d7633
    mov dword ptr [eax + field_455], 0x2         # 004d7636
    mov ecx, dword ptr [ebp - local_18]          # 004d7640
    mov dword ptr [ecx + field_955e], 0x3        # 004d7643
    mov edx, dword ptr [ebp - local_18]          # 004d764d
    mov dword ptr [edx + field_45d], 0x0         # 004d7650
    mov eax, dword ptr [ebp - local_18]          # 004d765a
    mov dword ptr [eax + field_472], 0x0         # 004d765d
L_004d7667:
    # block 0x004d7667: entered by jmp at 0x004d760a; je at 0x004d7616; jne at 0x004d7625; je at 0x004d7631, 1 instruction(s), ends with forward jump to 0x004d7902
    jmp.d32 L_004d7902                           # 004d7667
L_004d766c:
    # block 0x004d766c: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jbe to 0x004d76b2 (forward)
    call dword ptr [0x52a23c]                    # 004d766c
    mov ecx, dword ptr [ebp - local_18]          # 004d7672
    cmp eax, dword ptr [ecx + field_451]         # 004d7675
    jbe.d8 L_004d76b2                            # 004d767b
    # block 0x004d767d: entered by fall-through of jbe at 0x004d767b, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004d76b2 (forward)
    {load} xor edx, edx                          # 004d767d
    mov dx, word ptr [0x63a998]                  # 004d767f
    mov dword ptr [ebp - local_14], edx          # 004d7686
    mov eax, dword ptr [ebp - local_14]          # 004d7689
    push eax                                     # 004d768c
    mov ecx, 0x5cf1eb                            # 004d768d
    call FUN_004f6334                            # 004d7692
    test eax, eax                                # 004d7697
    jne.d8 L_004d76b2                            # 004d7699
    # block 0x004d769b: entered by fall-through of jne at 0x004d7699, 4 instruction(s), calls FUN_004dad60, falls into the block at 0x004d76b2
    mov ecx, dword ptr [ebp - local_18]          # 004d769b
    mov dword ptr [ecx + field_455], 0x2         # 004d769e
    mov ecx, 0x5830a6                            # 004d76a8
    call FUN_004dad60                            # 004d76ad
L_004d76b2:
    # block 0x004d76b2: entered by jbe at 0x004d767b; jne at 0x004d7699, 1 instruction(s), ends with forward jump to 0x004d7902
    jmp.d32 L_004d7902                           # 004d76b2
L_004d76b7:
    # block 0x004d76b7: entered by switch case, 5 instruction(s), ends with ja to 0x004d78e5 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004d76b7
    mov eax, dword ptr [edx + field_955e]        # 004d76ba
    mov dword ptr [ebp - local_28], eax          # 004d76c0
    cmp dword ptr [ebp - local_28], 0x4          # 004d76c3
    ja.d32 L_004d78e5                            # 004d76c7
    # block 0x004d76cd: entered by fall-through of ja at 0x004d76c7, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x4d7939]
    mov ecx, dword ptr [ebp - local_28]          # 004d76cd
    jmp dword ptr [4*ecx + SWTAB_004d7939_VA]    # 004d76d0
L_004d76d7:
    # block 0x004d76d7: entered by switch case, 29 instruction(s), calls FUN_0050ca3e, FUN_0050cd72, FUN_00449d90, ends with je to 0x004d776b (forward)
    mov edx, dword ptr [ebp - local_18]          # 004d76d7
    add edx, 0x2af                               # 004d76da
    push edx                                     # 004d76e0
    push 0x55a780                                # 004d76e1
    mov eax, dword ptr [ebp - local_18]          # 004d76e6
    add eax, 0x333e3                             # 004d76e9
    push eax                                     # 004d76ee
    call FUN_0050ca3e                            # 004d76ef
    add esp, 0xc                                 # 004d76f4
    mov ecx, dword ptr [ebp - local_18]          # 004d76f7
    add ecx, 0x333e3                             # 004d76fa
    push ecx                                     # 004d7700
    mov edx, dword ptr [ebp - local_18]          # 004d7701
    add edx, 0x96d3                              # 004d7704
    push edx                                     # 004d770a
    push 0x63a3c9                                # 004d770b
    push 0x63a9a4                                # 004d7710
    mov eax, dword ptr [ebp - local_18]          # 004d7715
    add eax, 0x333e8                             # 004d7718
    push eax                                     # 004d771d
    call FUN_0050cd72                            # 004d771e
    add esp, 0x14                                # 004d7723
    mov ecx, dword ptr [ebp - local_18]          # 004d7726
    add ecx, 0x333e8                             # 004d7729
    push ecx                                     # 004d772f
    call FUN_00449d90                            # 004d7730
    add esp, 0x4                                 # 004d7735
    test eax, eax                                # 004d7738
    je.d8 L_004d776b                             # 004d773a
    # block 0x004d773c: entered by fall-through of je at 0x004d773a, 3 instruction(s), ends with jne to 0x004d776b (forward)
    mov edx, dword ptr [ebp - local_18]          # 004d773c
    cmp dword ptr [edx + field_951a], 0x0        # 004d773f
    jne.d8 L_004d776b                            # 004d7746
    # block 0x004d7748: entered by fall-through of jne at 0x004d7746, 5 instruction(s), ends with forward jump to 0x004d77d7
    mov dword ptr [0x616783], 0x0                # 004d7748
    mov dword ptr [0x583981], 0xd                # 004d7752
    mov eax, dword ptr [ebp - local_18]          # 004d775c
    mov dword ptr [eax + field_951a], 0x1        # 004d775f
    jmp.d8 L_004d77d7                            # 004d7769
L_004d776b:
    # block 0x004d776b: entered by je at 0x004d773a; jne at 0x004d7746, 8 instruction(s), calls FUN_004d7a15, ends with je to 0x004d77b3 (forward)
    push 0x1                                     # 004d776b
    mov ecx, dword ptr [ebp - local_18]          # 004d776d
    add ecx, 0x96d3                              # 004d7770
    push ecx                                     # 004d7776
    mov ecx, dword ptr [ebp - local_18]          # 004d7777
    call FUN_004d7a15                            # 004d777a
    test eax, eax                                # 004d777f
    je.d8 L_004d77b3                             # 004d7781
    # block 0x004d7783: entered by fall-through of je at 0x004d7781, 9 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x004d77bd
    mov edx, dword ptr [ebp - local_18]          # 004d7783
    mov dword ptr [edx + field_44d], 0x1         # 004d7786
    call dword ptr [0x52a23c]                    # 004d7790
    add eax, 0x7d0                               # 004d7796
    mov ecx, dword ptr [ebp - local_18]          # 004d779b
    mov dword ptr [ecx + field_9516], eax        # 004d779e
    mov edx, dword ptr [ebp - local_18]          # 004d77a4
    mov dword ptr [edx + field_455], 0x3         # 004d77a7
    jmp.d8 L_004d77bd                            # 004d77b1
L_004d77b3:
    # block 0x004d77b3: entered by je at 0x004d7781, 2 instruction(s), falls into the block at 0x004d77bd
    mov eax, dword ptr [ebp - local_18]          # 004d77b3
    mov dword ptr [eax + field_4], 0x3           # 004d77b6
L_004d77bd:
    # block 0x004d77bd: entered by jmp at 0x004d77b1, 4 instruction(s), falls into the block at 0x004d77d7
    mov ecx, dword ptr [ebp - local_18]          # 004d77bd
    mov dword ptr [ecx + field_951a], 0x0        # 004d77c0
    mov edx, dword ptr [ebp - local_18]          # 004d77ca
    mov dword ptr [edx + field_449], 0x0         # 004d77cd
L_004d77d7:
    # block 0x004d77d7: entered by jmp at 0x004d7769, 1 instruction(s), ends with forward jump to 0x004d78e5
    jmp.d32 L_004d78e5                           # 004d77d7
L_004d77dc:
    # block 0x004d77dc: entered by switch case, 8 instruction(s), ends with jge to 0x004d780a (forward)
    mov eax, dword ptr [ebp - local_18]          # 004d77dc
    mov ecx, dword ptr [eax + field_955a]        # 004d77df
    sub ecx, 0x1                                 # 004d77e5
    mov edx, dword ptr [ebp - local_18]          # 004d77e8
    mov dword ptr [edx + field_955a], ecx        # 004d77eb
    mov eax, dword ptr [ebp - local_18]          # 004d77f1
    cmp dword ptr [eax + field_955a], 0x0        # 004d77f4
    jge.d8 L_004d780a                            # 004d77fb
    # block 0x004d77fd: entered by fall-through of jge at 0x004d77fb, 2 instruction(s), falls into the block at 0x004d780a
    mov ecx, dword ptr [ebp - local_18]          # 004d77fd
    mov dword ptr [ecx + field_955a], 0x0        # 004d7800
L_004d780a:
    # block 0x004d780a: entered by jge at 0x004d77fb, 3 instruction(s), calls FUN_004d8618, ends with forward jump to 0x004d78e5
    mov ecx, dword ptr [ebp - local_18]          # 004d780a
    call FUN_004d8618                            # 004d780d
    jmp.d32 L_004d78e5                           # 004d7812
L_004d7817:
    # block 0x004d7817: entered by switch case, 10 instruction(s), ends with jle to 0x004d7852 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004d7817
    mov eax, dword ptr [edx + field_955a]        # 004d781a
    add eax, 0x1                                 # 004d7820
    mov ecx, dword ptr [ebp - local_18]          # 004d7823
    mov dword ptr [ecx + field_955a], eax        # 004d7826
    mov edx, dword ptr [ebp - local_18]          # 004d782c
    mov eax, dword ptr [ebp - local_18]          # 004d782f
    mov ecx, dword ptr [edx + field_955a]        # 004d7832
    cmp ecx, dword ptr [eax + field_9556]        # 004d7838
    jle.d8 L_004d7852                            # 004d783e
    # block 0x004d7840: entered by fall-through of jle at 0x004d783e, 4 instruction(s), falls into the block at 0x004d7852
    mov edx, dword ptr [ebp - local_18]          # 004d7840
    mov eax, dword ptr [ebp - local_18]          # 004d7843
    mov ecx, dword ptr [eax + field_9556]        # 004d7846
    mov dword ptr [edx + field_955a], ecx        # 004d784c
L_004d7852:
    # block 0x004d7852: entered by jle at 0x004d783e, 3 instruction(s), calls FUN_004d8618, ends with forward jump to 0x004d78e5
    mov ecx, dword ptr [ebp - local_18]          # 004d7852
    call FUN_004d8618                            # 004d7855
    jmp.d32 L_004d78e5                           # 004d785a
L_004d785f:
    # block 0x004d785f: entered by switch case, 3 instruction(s), ends with jne to 0x004d789a (forward)
    mov edx, dword ptr [ebp - local_18]          # 004d785f
    cmp dword ptr [edx + field_951e], 0x0        # 004d7862
    jne.d8 L_004d789a                            # 004d7869
    # block 0x004d786b: entered by fall-through of jne at 0x004d7869, 3 instruction(s), ends with je to 0x004d789a (forward)
    mov eax, dword ptr [ebp - local_18]          # 004d786b
    cmp dword ptr [eax + field_449], 0x0         # 004d786e
    je.d8 L_004d789a                             # 004d7875
    # block 0x004d7877: entered by fall-through of je at 0x004d7875, 5 instruction(s), ends with forward jump to 0x004d78d9
    mov dword ptr [0x583981], 0xc                # 004d7877
    mov dword ptr [0x616783], 0x0                # 004d7881
    mov ecx, dword ptr [ebp - local_18]          # 004d788b
    mov dword ptr [ecx + field_951e], 0x1        # 004d788e
    jmp.d8 L_004d78d9                            # 004d7898
L_004d789a:
    # block 0x004d789a: entered by jne at 0x004d7869; je at 0x004d7875, 10 instruction(s), calls FUN_004d812e, ends with je to 0x004d78d1 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004d789a
    mov eax, dword ptr [edx + field_9562]        # 004d789d
    imul eax, eax, 0x21                          # 004d78a3
    mov ecx, dword ptr [ebp - local_18]          # 004d78a6
    lea edx, [ecx + eax + field_95aa]            # 004d78a9
    push edx                                     # 004d78b0
    mov ecx, dword ptr [ebp - local_18]          # 004d78b1
    call FUN_004d812e                            # 004d78b4
    test eax, eax                                # 004d78b9
    je.d8 L_004d78d1                             # 004d78bb
    # block 0x004d78bd: entered by fall-through of je at 0x004d78bb, 4 instruction(s), calls FUN_004d79c7, ends with forward jump to 0x004d790f
    mov ecx, dword ptr [ebp - local_18]          # 004d78bd
    call FUN_004d79c7                            # 004d78c0
    mov dword ptr [0x583985], 0x7                # 004d78c5
    jmp.d8 L_004d790f                            # 004d78cf
L_004d78d1:
    # block 0x004d78d1: entered by je at 0x004d78bb, 2 instruction(s), calls FUN_004d8618, falls into the block at 0x004d78d9
    mov ecx, dword ptr [ebp - local_18]          # 004d78d1
    call FUN_004d8618                            # 004d78d4
L_004d78d9:
    # block 0x004d78d9: entered by jmp at 0x004d7898, 1 instruction(s), ends with forward jump to 0x004d78e5
    jmp.d8 L_004d78e5                            # 004d78d9
L_004d78db:
    # block 0x004d78db: entered by switch case, 2 instruction(s), falls into the block at 0x004d78e5
    mov eax, dword ptr [ebp - local_18]          # 004d78db
    mov dword ptr [eax + field_4], 0x3           # 004d78de
L_004d78e5:
    # block 0x004d78e5: entered by ja at 0x004d76c7; jmp at 0x004d77d7; jmp at 0x004d7812; jmp at 0x004d785a; more, 1 instruction(s), ends with forward jump to 0x004d7902
    jmp.d8 L_004d7902                            # 004d78e5
L_004d78e7:
    # block 0x004d78e7: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jbe to 0x004d7902 (forward)
    call dword ptr [0x52a23c]                    # 004d78e7
    mov ecx, dword ptr [ebp - local_18]          # 004d78ed
    cmp eax, dword ptr [ecx + field_9516]        # 004d78f0
    jbe.d8 L_004d7902                            # 004d78f6
    # block 0x004d78f8: entered by fall-through of jbe at 0x004d78f6, 2 instruction(s), falls into the block at 0x004d7902
    mov edx, dword ptr [ebp - local_18]          # 004d78f8
    mov dword ptr [edx + field_4], 0x3           # 004d78fb
L_004d7902:
    # block 0x004d7902: entered by ja at 0x004d717d; jmp at 0x004d7667; jmp at 0x004d76b2; jmp at 0x004d78e5; more, 3 instruction(s), calls FUN_004cf7e0, falls into the block at 0x004d790f
    push 0x55a65c                                # 004d7902
    call FUN_004cf7e0                            # 004d7907
    add esp, 0x4                                 # 004d790c
L_004d790f:
    # block 0x004d790f: entered by jmp at 0x004d78cf, 5 instruction(s), ends with ret
    pop edi                                      # 004d790f
    pop esi                                      # 004d7910
    {load} mov esp, ebp                          # 004d7911
    pop ebp                                      # 004d7913
    ret                                          # 004d7914

# --- data items (not part of the function) -------------------------
.org 0x004d7915 - 0x401000
SWTAB_004d7915:  # 4 case address(es)
    .long L_004d718d - .text + 0x401000
    .long L_004d766c - .text + 0x401000
    .long L_004d76b7 - .text + 0x401000
    .long L_004d78e7 - .text + 0x401000
.org 0x004d7925 - 0x401000
SWTAB_004d7925:  # 5 case address(es)
    .long L_004d73f1 - .text + 0x401000
    .long L_004d7408 - .text + 0x401000
    .long L_004d7408 - .text + 0x401000
    .long L_004d741f - .text + 0x401000
    .long L_004d7436 - .text + 0x401000
.org 0x004d7939 - 0x401000
SWTAB_004d7939:  # 5 case address(es)
    .long L_004d76d7 - .text + 0x401000
    .long L_004d77dc - .text + 0x401000
    .long L_004d7817 - .text + 0x401000
    .long L_004d785f - .text + 0x401000
    .long L_004d78db - .text + 0x401000
.set SWTAB_004d7915_VA, SWTAB_004d7915 - .text + 0x401000
.set SWTAB_004d7925_VA, SWTAB_004d7925 - .text + 0x401000
.set SWTAB_004d7939_VA, SWTAB_004d7939 - .text + 0x401000

