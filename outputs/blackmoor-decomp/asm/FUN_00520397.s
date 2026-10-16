# FUN_00520397
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520397
# extent:       0x00520397-0x005205d8 (577 code bytes)
# span:         0x00520397-0x005205d8 (code 577, tables 0, padding 0)
# sha256:       c0b0c25c90f4e83e491211e653d3851580d1ec055ab510f15b22699bd91547e1
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520397
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1, field_4, field_c, field_minus_8; [ebp + n] field_8, field_b, field_minus_4, field_minus_c, field_minus_10, field_minus_14, field_minus_18, field_minus_1c, field_minus_20, field_minus_2c, field_minus_12f, field_minus_130; [ebx + n] field_minus_8; [ecx + n] field_1, field_4, field_minus_8; [edi + n] field_4, field_8, field_14, field_1c; [esi + n] field_4, field_8, field_c, field_18, field_20
# callees:      calls FUN_0050f978, FUN_0051ea75, USER32.dll!GetMenuStringA, FUN_0051eac4, USER32.dll!DeleteMenu, KERNEL32.dll!GetCurrentDirectoryA, KERNEL32.dll!lstrlenA, FUN_00520291, USER32.dll!wsprintfA, FUN_0051e828, FUN_0051e95c, USER32.dll!InsertMenuA, FUN_0051e7ba, USER32.dll!GetMenuItemCount; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 194 instruction(s), 13 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_8, 0x8  # offset -0x8
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_minus_14, 0x14  # offset -0x14
.equ field_minus_18, 0x18  # offset -0x18
.equ field_minus_1c, 0x1c  # offset -0x1c
.equ field_minus_20, 0x20  # offset -0x20
.equ field_minus_2c, 0x2c  # offset -0x2c
.equ field_minus_12f, 0x12f  # offset -0x12f
.equ field_minus_130, 0x130  # offset -0x130
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_b, 0xb  # offset +0xb
.equ field_c, 0xc  # offset +0xc
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)
.set FUN_0051e828, .text + (0x0051e828 - 0x401000)
.set FUN_0051e95c, .text + (0x0051e95c - 0x401000)
.set FUN_0051ea75, .text + (0x0051ea75 - 0x401000)
.set FUN_0051eac4, .text + (0x0051eac4 - 0x401000)
.set FUN_00520291, .text + (0x00520291 - 0x401000)

.org 0x00520397 - 0x401000
.globl FUN_00520397
FUN_00520397:
    # block 0x00520397: entry, 14 instruction(s), calls FUN_0050f978, ends with jne to 0x005203f4 (forward)
    mov eax, 0x529214                            # 00520397
    call FUN_0050f978                            # 0052039c
    sub esp, 0x124                               # 005203a1
    push ebx                                     # 005203a7
    push esi                                     # 005203a8
    mov esi, dword ptr [ebp + field_8]           # 005203a9
    push edi                                     # 005203ac
    {load} mov edi, ecx                          # 005203ad
    mov ecx, dword ptr [edi + field_1c]          # 005203af
    mov eax, dword ptr [esi + field_c]           # 005203b2
    lea ebx, [edi + field_1c]                    # 005203b5
    mov dword ptr [ebp - field_minus_18], eax    # 005203b8
    cmp dword ptr [ecx - field_minus_8], 0x0     # 005203bb
    jne.d8 L_005203f4                            # 005203bf
    # block 0x005203c1: entered by fall-through of jne at 0x005203bf, 2 instruction(s), ends with je to 0x005203f4 (forward)
    test eax, eax                                # 005203c1
    je.d8 L_005203f4                             # 005203c3
    # block 0x005203c5: entered by fall-through of je at 0x005203c3, 16 instruction(s), calls FUN_0051ea75, USER32.dll!GetMenuStringA, FUN_0051eac4, falls into the block at 0x005203f4
    mov eax, dword ptr [esi + field_4]           # 005203c5
    push 0x0                                     # 005203c8
    mov dword ptr [ebp + field_8], eax           # 005203ca
    mov eax, 0x100                               # 005203cd
    push eax                                     # 005203d2
    push eax                                     # 005203d3
    {load} mov ecx, ebx                          # 005203d4
    call FUN_0051ea75                            # 005203d6
    push eax                                     # 005203db
    mov eax, dword ptr [ebp - field_minus_18]    # 005203dc
    push dword ptr [ebp + field_8]               # 005203df
    push dword ptr [eax + field_4]               # 005203e2
    call dword ptr [0x52a3cc]                    # 005203e5
    push -0x1                                    # 005203eb
    {load} mov ecx, ebx                          # 005203ed
    call FUN_0051eac4                            # 005203ef
L_005203f4:
    # block 0x005203f4: entered by jne at 0x005203bf; je at 0x005203c3, 5 instruction(s), ends with jne to 0x0052041c (forward)
    mov eax, dword ptr [edi + field_8]           # 005203f4
    mov ecx, dword ptr [eax]                     # 005203f7
    {load} xor eax, eax                          # 005203f9
    cmp dword ptr [ecx - field_minus_8], eax     # 005203fb
    jne.d8 L_0052041c                            # 005203fe
    # block 0x00520400: entered by fall-through of jne at 0x005203fe, 3 instruction(s), ends with je to 0x0052040f (forward)
    mov ebx, dword ptr [ebx]                     # 00520400
    cmp dword ptr [ebx - field_minus_8], eax     # 00520402
    je.d8 L_0052040f                             # 00520405
    # block 0x00520407: entered by fall-through of je at 0x00520405, 4 instruction(s), calls indirect dword ptr [eax + 0xc], falls into the block at 0x0052040f
    mov eax, dword ptr [esi]                     # 00520407
    push ebx                                     # 00520409
    {load} mov ecx, esi                          # 0052040a
    call dword ptr [eax + field_c]               # 0052040c
L_0052040f:
    # block 0x0052040f: entered by je at 0x00520405, 5 instruction(s), calls indirect dword ptr [eax], ends with forward jump to 0x005205c7
    mov eax, dword ptr [esi]                     # 0052040f
    push 0x0                                     # 00520411
    {load} mov ecx, esi                          # 00520413
    call dword ptr [eax]                         # 00520415
    jmp.d32 L_005205c7                           # 00520417
L_0052041c:
    # block 0x0052041c: entered by jne at 0x005203fe, 2 instruction(s), ends with je to 0x005205c7 (forward)
    cmp dword ptr [esi + field_c], eax           # 0052041c
    je.d32 L_005205c7                            # 0052041f
    # block 0x00520425: entered by fall-through of je at 0x0052041f, 3 instruction(s), ends with jle to 0x00520446 (forward)
    {load} xor ebx, ebx                          # 00520425
    cmp dword ptr [edi + field_4], eax           # 00520427
    jle.d8 L_00520446                            # 0052042a
L_0052042c:
    # block 0x0052042c: entered by jl at 0x00520444; fall-through of jle at 0x0052042a, 10 instruction(s), calls USER32.dll!DeleteMenu, ends with jl to 0x0052042c (backward)
    mov eax, dword ptr [esi + field_4]           # 0052042c
    mov ecx, dword ptr [esi + field_c]           # 0052042f
    {load} add eax, ebx                          # 00520432
    push 0x0                                     # 00520434
    push eax                                     # 00520436
    push dword ptr [ecx + field_4]               # 00520437
    call dword ptr [0x52a3c8]                    # 0052043a
    inc ebx                                      # 00520440
    cmp ebx, dword ptr [edi + field_4]           # 00520441
    jl.d8 L_0052042c                             # 00520444
L_00520446:
    # block 0x00520446: entered by jle at 0x0052042a; fall-through of jl at 0x00520444, 19 instruction(s), calls KERNEL32.dll!GetCurrentDirectoryA, KERNEL32.dll!lstrlenA, ends with jle to 0x00520596 (forward)
    lea eax, [ebp - field_minus_130]             # 00520446
    push eax                                     # 0052044c
    push 0x104                                   # 0052044d
    call dword ptr [0x52a0f0]                    # 00520452
    lea eax, [ebp - field_minus_130]             # 00520458
    push eax                                     # 0052045e
    call dword ptr [0x52a1f8]                    # 0052045f
    mov ecx, dword ptr [0x5679b0]                # 00520465
    mov byte ptr [ebp + eax - field_minus_130], 0x5c # 0052046b
    and byte ptr [ebp + eax - field_minus_12f], 0x0 # 00520473
    inc eax                                      # 0052047b
    mov dword ptr [ebp - field_minus_18], eax    # 0052047c
    mov dword ptr [ebp - field_minus_14], ecx    # 0052047f
    {load} xor ebx, ebx                          # 00520482
    mov dword ptr [ebp - field_minus_10], ecx    # 00520484
    mov dword ptr [ebp - field_minus_4], ebx     # 00520487
    cmp dword ptr [edi + field_4], ebx           # 0052048a
    mov byte ptr [ebp - field_minus_4], 0x1      # 0052048d
    jle.d32 L_00520596                           # 00520491
    # block 0x00520497: entered by fall-through of jle at 0x00520491, 1 instruction(s), ends with forward jump to 0x0052049c
    jmp.d8 L_0052049c                            # 00520497
L_00520499:
    # block 0x00520499: entered by jl at 0x00520590, 1 instruction(s), falls into the block at 0x0052049c
    mov eax, dword ptr [ebp - field_minus_18]    # 00520499
L_0052049c:
    # block 0x0052049c: entered by jmp at 0x00520497, 11 instruction(s), calls FUN_00520291, ends with je to 0x00520596 (forward)
    push 0x1                                     # 0052049c
    push eax                                     # 0052049e
    lea eax, [ebp - field_minus_130]             # 0052049f
    {load} mov ecx, edi                          # 005204a5
    push eax                                     # 005204a7
    lea eax, [ebp - field_minus_14]              # 005204a8
    push ebx                                     # 005204ab
    push eax                                     # 005204ac
    call FUN_00520291                            # 005204ad
    test eax, eax                                # 005204b2
    je.d32 L_00520596                            # 005204b4
    # block 0x005204ba: entered by fall-through of je at 0x005204b4, 8 instruction(s), calls FUN_0051ea75, falls into the block at 0x005204d1
    mov eax, dword ptr [ebp - field_minus_14]    # 005204ba
    lea ecx, [ebp - field_minus_10]              # 005204bd
    mov dword ptr [ebp + field_8], eax           # 005204c0
    mov eax, dword ptr [eax - field_minus_8]     # 005204c3
    {load} add eax, eax                          # 005204c6
    push eax                                     # 005204c8
    call FUN_0051ea75                            # 005204c9
    mov ecx, dword ptr [ebp + field_8]           # 005204ce
L_005204d1:
    # block 0x005204d1: entered by jmp at 0x005204fd, 3 instruction(s), ends with je to 0x005204ff (forward)
    mov dl, byte ptr [ecx]                       # 005204d1
    test dl, dl                                  # 005204d3
    je.d8 L_005204ff                             # 005204d5
    # block 0x005204d7: entered by fall-through of je at 0x005204d5, 2 instruction(s), ends with jne to 0x005204df (forward)
    cmp dl, 0x26                                 # 005204d7
    jne.d8 L_005204df                            # 005204da
    # block 0x005204dc: entered by fall-through of jne at 0x005204da, 2 instruction(s), falls into the block at 0x005204df
    mov byte ptr [eax], dl                       # 005204dc
    inc eax                                      # 005204de
L_005204df:
    # block 0x005204df: entered by jne at 0x005204da, 5 instruction(s), ends with je to 0x005204f7 (forward)
    mov dl, byte ptr [ecx]                       # 005204df
    mov byte ptr [ebp + field_b], dl             # 005204e1
    movzx edx, dl                                # 005204e4
    test byte ptr [edx + 0x63e021], 0x4          # 005204e7
    je.d8 L_005204f7                             # 005204ee
    # block 0x005204f0: entered by fall-through of je at 0x005204ee, 4 instruction(s), falls into the block at 0x005204f7
    mov dl, byte ptr [ebp + field_b]             # 005204f0
    mov byte ptr [eax], dl                       # 005204f3
    inc eax                                      # 005204f5
    inc ecx                                      # 005204f6
L_005204f7:
    # block 0x005204f7: entered by je at 0x005204ee, 5 instruction(s), ends with backward jump to 0x005204d1
    mov dl, byte ptr [ecx]                       # 005204f7
    mov byte ptr [eax], dl                       # 005204f9
    inc eax                                      # 005204fb
    inc ecx                                      # 005204fc
    jmp.d8 L_005204d1                            # 005204fd
L_005204ff:
    # block 0x005204ff: entered by je at 0x005204d5, 50 instruction(s), calls FUN_0051eac4, USER32.dll!wsprintfA, FUN_0051e828, FUN_0051e95c, USER32.dll!InsertMenuA, FUN_0051e..., ends with jl to 0x00520499 (backward)
    and byte ptr [eax], 0x0                      # 005204ff
    push -0x1                                    # 00520502
    lea ecx, [ebp - field_minus_10]              # 00520504
    call FUN_0051eac4                            # 00520507
    mov eax, dword ptr [edi + field_14]          # 0052050c
    push 0xa                                     # 0052050f
    {load} xor edx, edx                          # 00520511
    pop ecx                                      # 00520513
    lea eax, [eax + ebx + field_1]               # 00520514
    div ecx                                      # 00520518
    lea eax, [ebp - field_minus_2c]              # 0052051a
    push edx                                     # 0052051d
    push 0x5300f4                                # 0052051e
    push eax                                     # 00520523
    call dword ptr [0x52a3e8]                    # 00520524
    add esp, 0xc                                 # 0052052a
    lea eax, [ebp - field_minus_2c]              # 0052052d
    lea ecx, [ebp - field_minus_20]              # 00520530
    push eax                                     # 00520533
    call FUN_0051e828                            # 00520534
    lea ecx, [ebp - field_minus_10]              # 00520539
    mov byte ptr [ebp - field_minus_4], 0x2      # 0052053c
    push ecx                                     # 00520540
    push eax                                     # 00520541
    lea eax, [ebp - field_minus_1c]              # 00520542
    push eax                                     # 00520545
    call FUN_0051e95c                            # 00520546
    mov eax, dword ptr [eax]                     # 0052054b
    mov ecx, dword ptr [esi + field_8]           # 0052054d
    mov dword ptr [ebp + field_8], eax           # 00520550
    mov eax, dword ptr [esi + field_4]           # 00520553
    push dword ptr [ebp + field_8]               # 00520556
    lea edx, [ecx + field_1]                     # 00520559
    mov dword ptr [esi + field_8], edx           # 0052055c
    lea edx, [eax + field_1]                     # 0052055f
    push eax                                     # 00520562
    mov eax, dword ptr [esi + field_c]           # 00520563
    push 0x400                                   # 00520566
    push ecx                                     # 0052056b
    mov dword ptr [esi + field_4], edx           # 0052056c
    push dword ptr [eax + field_4]               # 0052056f
    call dword ptr [0x52a3c4]                    # 00520572
    lea ecx, [ebp - field_minus_1c]              # 00520578
    call FUN_0051e7ba                            # 0052057b
    lea ecx, [ebp - field_minus_20]              # 00520580
    mov byte ptr [ebp - field_minus_4], 0x1      # 00520583
    call FUN_0051e7ba                            # 00520587
    inc ebx                                      # 0052058c
    cmp ebx, dword ptr [edi + field_4]           # 0052058d
    jl.d32 L_00520499                            # 00520590
L_00520596:
    # block 0x00520596: entered by jle at 0x00520491; je at 0x005204b4; fall-through of jl at 0x00520590, 12 instruction(s), calls USER32.dll!GetMenuItemCount, FUN_0051e7ba, falls into the block at 0x005205c7
    mov eax, dword ptr [esi + field_c]           # 00520596
    dec dword ptr [esi + field_8]                # 00520599
    push dword ptr [eax + field_4]               # 0052059c
    call dword ptr [0x52a3f8]                    # 0052059f
    and byte ptr [ebp - field_minus_4], 0x0      # 005205a5
    lea ecx, [ebp - field_minus_10]              # 005205a9
    mov dword ptr [esi + field_20], eax          # 005205ac
    mov dword ptr [esi + field_18], 0x1          # 005205af
    call FUN_0051e7ba                            # 005205b6
    or dword ptr [ebp - field_minus_4], -0x1     # 005205bb
    lea ecx, [ebp - field_minus_14]              # 005205bf
    call FUN_0051e7ba                            # 005205c2
L_005205c7:
    # block 0x005205c7: entered by jmp at 0x00520417; je at 0x0052041f, 7 instruction(s), ends with ret 0x4
    mov ecx, dword ptr [ebp - field_minus_c]     # 005205c7
    pop edi                                      # 005205ca
    pop esi                                      # 005205cb
    pop ebx                                      # 005205cc
    mov dword ptr fs:[0x0], ecx                  # 005205cd
    leave                                        # 005205d4
    ret 0x4                                      # 005205d5

