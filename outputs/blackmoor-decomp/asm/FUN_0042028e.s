# FUN_0042028e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042028e
# extent:       0x0042028e-0x004205c1 (819 code bytes)
# span:         0x0042028e-0x004205c1 (code 819, tables 0, padding 0)
# sha256:       8850c4b8591907993537b12e75eefdab6fbaa4f650641a3d1019de4de8a58aa8
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0042028e
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       7 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c
# fields:       [eax + n] field_7d9, field_7fc, field_800, field_80a, field_80e, field_ea5, field_f21; [ecx + n] field_7fe, field_802, field_810, field_ea5, field_f21; [edx + n] field_7fa, field_806, field_811, field_ea5, field_f21; [esi + n] field_7fa, field_7fc, field_7fe, field_800, field_802, field_806, field_80a, field_80e, field_810, field_811
# callees:      calls FUN_0051ea75, FUN_0050d550, FUN_0051eac4
# track-n:      outputs/blackmoor-decomp/src/action_family_3f_runtime.c:copy_name_cstr (function ledger class native_tests_only; also remove_response; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 207 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ arg_8, 0x8  # offset +0x8
.equ field_7d9, 0x7d9  # offset +0x7d9
.equ field_7fa, 0x7fa  # offset +0x7fa
.equ field_7fc, 0x7fc  # offset +0x7fc
.equ field_7fe, 0x7fe  # offset +0x7fe
.equ field_800, 0x800  # offset +0x800
.equ field_802, 0x802  # offset +0x802
.equ field_806, 0x806  # offset +0x806
.equ field_80a, 0x80a  # offset +0x80a
.equ field_80e, 0x80e  # offset +0x80e
.equ field_810, 0x810  # offset +0x810
.equ field_811, 0x811  # offset +0x811
.equ field_ea5, 0xea5  # offset +0xea5
.equ field_f21, 0xf21  # offset +0xf21

# --- external targets -----------------------------------------------
.set FUN_0050d550, .text + (0x0050d550 - 0x401000)
.set FUN_0051ea75, .text + (0x0051ea75 - 0x401000)
.set FUN_0051eac4, .text + (0x0051eac4 - 0x401000)

.org 0x0042028e - 0x401000
.globl FUN_0042028e
FUN_0042028e:
    # block 0x0042028e: entry, 8 instruction(s), ends with forward jump to 0x004202ad
    push ebp                                     # 0042028e
    {load} mov ebp, esp                          # 0042028f
    sub esp, 0x1c                                # 00420291
    push esi                                     # 00420294
    push edi                                     # 00420295
    mov dword ptr [ebp - local_1c], ecx          # 00420296
    mov word ptr [ebp - local_4], 0x0            # 00420299
    jmp.d8 L_004202ad                            # 0042029f
L_004202a1:
    # block 0x004202a1: entered by jmp at 0x004205b4, 3 instruction(s), falls into the block at 0x004202ad
    mov ax, word ptr [ebp - local_4]             # 004202a1
    .insn 0x66, 0x05, 0x0001{:u16}               # 004202a5
    mov word ptr [ebp - local_4], ax             # 004202a9
L_004202ad:
    # block 0x004202ad: entered by jmp at 0x0042029f, 5 instruction(s), ends with jge to 0x004205b9 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004202ad
    mov edx, dword ptr [ebp - local_1c]          # 004202b1
    movsx eax, word ptr [edx + field_f21]        # 004202b4
    {load} cmp ecx, eax                          # 004202bb
    jge.d32 L_004205b9                           # 004202bd
    # block 0x004202c3: entered by fall-through of jge at 0x004202bd, 16 instruction(s), calls FUN_0051ea75, FUN_0050d550, ends with jne to 0x0042059f (forward)
    push 0x190                                   # 004202c3
    movsx ecx, word ptr [ebp - local_4]          # 004202c8
    mov edx, dword ptr [ebp - local_1c]          # 004202cc
    lea ecx, [edx + 4*ecx + field_ea5]           # 004202cf
    call FUN_0051ea75                            # 004202d6
    mov dword ptr [ebp - local_14], eax          # 004202db
    push 0x190                                   # 004202de
    mov eax, dword ptr [ebp + arg_8]             # 004202e3
    add eax, 0x6                                 # 004202e6
    push eax                                     # 004202e9
    mov ecx, dword ptr [ebp - local_14]          # 004202ea
    push ecx                                     # 004202ed
    call FUN_0050d550                            # 004202ee
    add esp, 0xc                                 # 004202f3
    test eax, eax                                # 004202f6
    jne.d32 L_0042059f                           # 004202f8
    # block 0x004202fe: entered by fall-through of jne at 0x004202f8, 11 instruction(s), calls FUN_0051eac4, ends with forward jump to 0x00420340
    push -0x1                                    # 004202fe
    movsx edx, word ptr [ebp - local_4]          # 00420300
    mov eax, dword ptr [ebp - local_1c]          # 00420304
    lea ecx, [eax + 4*edx + field_ea5]           # 00420307
    call FUN_0051eac4                            # 0042030e
    mov cx, word ptr [ebp - local_4]             # 00420313
    mov word ptr [ebp - local_10], cx            # 00420317
    movsx edx, word ptr [ebp - local_10]         # 0042031b
    add edx, 0x1                                 # 0042031f
    mov word ptr [ebp - local_18], dx            # 00420322
    jmp.d8 L_00420340                            # 00420326
L_00420328:
    # block 0x00420328: entered by jmp at 0x00420566, 6 instruction(s), falls into the block at 0x00420340
    mov ax, word ptr [ebp - local_18]            # 00420328
    .insn 0x66, 0x05, 0x0001{:u16}               # 0042032c
    mov word ptr [ebp - local_18], ax            # 00420330
    mov cx, word ptr [ebp - local_10]            # 00420334
    add cx, 0x1                                  # 00420338
    mov word ptr [ebp - local_10], cx            # 0042033c
L_00420340:
    # block 0x00420340: entered by jmp at 0x00420326, 5 instruction(s), ends with jge to 0x0042056b (forward)
    movsx edx, word ptr [ebp - local_18]         # 00420340
    mov eax, dword ptr [ebp - local_1c]          # 00420344
    movsx ecx, word ptr [eax + field_f21]        # 00420347
    {load} cmp edx, ecx                          # 0042034e
    jge.d32 L_0042056b                           # 00420350
    # block 0x00420356: entered by fall-through of jge at 0x00420350, 130 instruction(s), calls FUN_0051ea75, FUN_0051eac4, ends with backward jump to 0x00420328
    push 0x190                                   # 00420356
    movsx edx, word ptr [ebp - local_10]         # 0042035b
    mov eax, dword ptr [ebp - local_1c]          # 0042035f
    lea ecx, [eax + 4*edx + field_ea5]           # 00420362
    call FUN_0051ea75                            # 00420369
    mov dword ptr [ebp - local_c], eax           # 0042036e
    push 0x190                                   # 00420371
    movsx ecx, word ptr [ebp - local_18]         # 00420376
    mov edx, dword ptr [ebp - local_1c]          # 0042037a
    lea ecx, [edx + 4*ecx + field_ea5]           # 0042037d
    call FUN_0051ea75                            # 00420384
    mov dword ptr [ebp - local_8], eax           # 00420389
    mov ecx, 0x64                                # 0042038c
    mov esi, dword ptr [ebp - local_8]           # 00420391
    mov edi, dword ptr [ebp - local_c]           # 00420394
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00420397
    push -0x1                                    # 00420399
    movsx eax, word ptr [ebp - local_10]         # 0042039b
    mov ecx, dword ptr [ebp - local_1c]          # 0042039f
    lea ecx, [ecx + 4*eax + field_ea5]           # 004203a2
    call FUN_0051eac4                            # 004203a9
    push -0x1                                    # 004203ae
    movsx edx, word ptr [ebp - local_18]         # 004203b0
    mov eax, dword ptr [ebp - local_1c]          # 004203b4
    lea ecx, [eax + 4*edx + field_ea5]           # 004203b7
    call FUN_0051eac4                            # 004203be
    movsx ecx, word ptr [ebp - local_18]         # 004203c3
    imul ecx, ecx, 0x3a                          # 004203c7
    movsx edx, word ptr [ebp - local_10]         # 004203ca
    imul edx, edx, 0x3a                          # 004203ce
    mov eax, dword ptr [ebp - local_1c]          # 004203d1
    mov esi, dword ptr [ebp - local_1c]          # 004203d4
    mov cx, word ptr [esi + ecx + field_800]     # 004203d7
    mov word ptr [eax + edx + field_800], cx     # 004203df
    movsx edx, word ptr [ebp - local_18]         # 004203e7
    imul edx, edx, 0x3a                          # 004203eb
    movsx eax, word ptr [ebp - local_10]         # 004203ee
    imul eax, eax, 0x3a                          # 004203f2
    mov ecx, dword ptr [ebp - local_1c]          # 004203f5
    mov esi, dword ptr [ebp - local_1c]          # 004203f8
    mov dx, word ptr [esi + edx + field_7fe]     # 004203fb
    mov word ptr [ecx + eax + field_7fe], dx     # 00420403
    movsx eax, word ptr [ebp - local_18]         # 0042040b
    imul eax, eax, 0x3a                          # 0042040f
    movsx ecx, word ptr [ebp - local_10]         # 00420412
    imul ecx, ecx, 0x3a                          # 00420416
    mov edx, dword ptr [ebp - local_1c]          # 00420419
    mov esi, dword ptr [ebp - local_1c]          # 0042041c
    mov ax, word ptr [esi + eax + field_7fa]     # 0042041f
    mov word ptr [edx + ecx + field_7fa], ax     # 00420427
    movsx ecx, word ptr [ebp - local_18]         # 0042042f
    imul ecx, ecx, 0x3a                          # 00420433
    movsx edx, word ptr [ebp - local_10]         # 00420436
    imul edx, edx, 0x3a                          # 0042043a
    mov eax, dword ptr [ebp - local_1c]          # 0042043d
    mov esi, dword ptr [ebp - local_1c]          # 00420440
    mov cx, word ptr [esi + ecx + field_7fc]     # 00420443
    mov word ptr [eax + edx + field_7fc], cx     # 0042044b
    movsx edx, word ptr [ebp - local_18]         # 00420453
    imul edx, edx, 0x3a                          # 00420457
    movsx eax, word ptr [ebp - local_10]         # 0042045a
    imul eax, eax, 0x3a                          # 0042045e
    mov ecx, dword ptr [ebp - local_1c]          # 00420461
    mov esi, dword ptr [ebp - local_1c]          # 00420464
    mov edx, dword ptr [esi + edx + field_802]   # 00420467
    mov dword ptr [ecx + eax + field_802], edx   # 0042046e
    movsx eax, word ptr [ebp - local_18]         # 00420475
    imul eax, eax, 0x3a                          # 00420479
    movsx ecx, word ptr [ebp - local_10]         # 0042047c
    imul ecx, ecx, 0x3a                          # 00420480
    mov edx, dword ptr [ebp - local_1c]          # 00420483
    mov esi, dword ptr [ebp - local_1c]          # 00420486
    mov eax, dword ptr [esi + eax + field_806]   # 00420489
    mov dword ptr [edx + ecx + field_806], eax   # 00420490
    movsx ecx, word ptr [ebp - local_18]         # 00420497
    imul ecx, ecx, 0x3a                          # 0042049b
    movsx edx, word ptr [ebp - local_10]         # 0042049e
    imul edx, edx, 0x3a                          # 004204a2
    mov eax, dword ptr [ebp - local_1c]          # 004204a5
    mov esi, dword ptr [ebp - local_1c]          # 004204a8
    mov ecx, dword ptr [esi + ecx + field_80a]   # 004204ab
    mov dword ptr [eax + edx + field_80a], ecx   # 004204b2
    movsx edx, word ptr [ebp - local_18]         # 004204b9
    imul edx, edx, 0x3a                          # 004204bd
    mov eax, dword ptr [ebp - local_1c]          # 004204c0
    lea ecx, [eax + edx + field_7d9]             # 004204c3
    {load} mov edi, ecx                          # 004204ca
    movsx edx, word ptr [ebp - local_10]         # 004204cc
    imul edx, edx, 0x3a                          # 004204d0
    mov eax, dword ptr [ebp - local_1c]          # 004204d3
    lea ecx, [eax + edx + field_7d9]             # 004204d6
    {load} mov edx, ecx                          # 004204dd
    or ecx, -0x1                                 # 004204df
    {load} xor eax, eax                          # 004204e2
    repne scasb al, byte ptr es:[edi]            # 004204e4
    not ecx                                      # 004204e6
    {load} sub edi, ecx                          # 004204e8
    {load} mov esi, edi                          # 004204ea
    {load} mov eax, ecx                          # 004204ec
    {load} mov edi, edx                          # 004204ee
    shr ecx, 0x2                                 # 004204f0
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004204f3
    {load} mov ecx, eax                          # 004204f5
    and ecx, 0x3                                 # 004204f7
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004204fa
    movsx ecx, word ptr [ebp - local_18]         # 004204fc
    imul ecx, ecx, 0x3a                          # 00420500
    movsx edx, word ptr [ebp - local_10]         # 00420503
    imul edx, edx, 0x3a                          # 00420507
    mov eax, dword ptr [ebp - local_1c]          # 0042050a
    mov esi, dword ptr [ebp - local_1c]          # 0042050d
    mov cx, word ptr [esi + ecx + field_80e]     # 00420510
    mov word ptr [eax + edx + field_80e], cx     # 00420518
    movsx edx, word ptr [ebp - local_18]         # 00420520
    imul edx, edx, 0x3a                          # 00420524
    movsx eax, word ptr [ebp - local_10]         # 00420527
    imul eax, eax, 0x3a                          # 0042052b
    mov ecx, dword ptr [ebp - local_1c]          # 0042052e
    mov esi, dword ptr [ebp - local_1c]          # 00420531
    mov dl, byte ptr [esi + edx + field_810]     # 00420534
    mov byte ptr [ecx + eax + field_810], dl     # 0042053b
    movsx eax, word ptr [ebp - local_18]         # 00420542
    imul eax, eax, 0x3a                          # 00420546
    movsx ecx, word ptr [ebp - local_10]         # 00420549
    imul ecx, ecx, 0x3a                          # 0042054d
    mov edx, dword ptr [ebp - local_1c]          # 00420550
    mov esi, dword ptr [ebp - local_1c]          # 00420553
    mov ax, word ptr [esi + eax + field_811]     # 00420556
    mov word ptr [edx + ecx + field_811], ax     # 0042055e
    jmp.d32 L_00420328                           # 00420566
L_0042056b:
    # block 0x0042056b: entered by jge at 0x00420350, 9 instruction(s), ends with jge to 0x0042059d (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 0042056b
    mov dx, word ptr [ecx + field_f21]           # 0042056e
    sub dx, 0x1                                  # 00420575
    mov eax, dword ptr [ebp - local_1c]          # 00420579
    mov word ptr [eax + field_f21], dx           # 0042057c
    mov ecx, dword ptr [ebp - local_1c]          # 00420583
    movsx edx, word ptr [ecx + field_f21]        # 00420586
    test edx, edx                                # 0042058d
    jge.d8 L_0042059d                            # 0042058f
    # block 0x00420591: entered by fall-through of jge at 0x0042058f, 2 instruction(s), falls into the block at 0x0042059d
    mov eax, dword ptr [ebp - local_1c]          # 00420591
    mov word ptr [eax + field_f21], 0x0          # 00420594
L_0042059d:
    # block 0x0042059d: entered by jge at 0x0042058f, 1 instruction(s), ends with forward jump to 0x004205b9
    jmp.d8 L_004205b9                            # 0042059d
L_0042059f:
    # block 0x0042059f: entered by jne at 0x004202f8, 6 instruction(s), calls FUN_0051eac4, ends with backward jump to 0x004202a1
    push -0x1                                    # 0042059f
    movsx ecx, word ptr [ebp - local_4]          # 004205a1
    mov edx, dword ptr [ebp - local_1c]          # 004205a5
    lea ecx, [edx + 4*ecx + field_ea5]           # 004205a8
    call FUN_0051eac4                            # 004205af
    jmp.d32 L_004202a1                           # 004205b4
L_004205b9:
    # block 0x004205b9: entered by jge at 0x004202bd; jmp at 0x0042059d, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004205b9
    pop esi                                      # 004205ba
    {load} mov esp, ebp                          # 004205bb
    pop ebp                                      # 004205bd
    ret 0x4                                      # 004205be

