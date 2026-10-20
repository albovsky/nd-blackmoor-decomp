# FUN_004c334f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c334f
# extent:       0x004c334f-0x004c36b2 (867 code bytes)
# span:         0x004c334f-0x004c36b2 (code 867, tables 0, padding 0)
# sha256:       d127991781bff33e16f77c2761e0258814b6a509bc390a71ada60aa7124791ff
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_bmp_screen_file_writer
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_94_runtime.h:75 says "format 0 -> 0x4c334f: 14-byte BM header, 40-byte info header, 24-bit bottom-up rows"; src/action_family_94_runtime.h:39 says "0 = 24-bit BMP (0x4c334f)"
# name-note:    Writes the screen capture as a 24-bit bottom-up BMP (14-byte BM header, 40-byte info header).
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       39 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1e, local_20, local_22, local_26, local_28, local_2c and 27 more
# fields:       [eax + n] field_1
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_004c7481, FUN_0050cd72, FUN_0050d0a9, FUN_0050e493, FUN_0050cee4, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/action_family_94_runtime.h:a94_encode (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 253 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
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
.equ local_1e, 0x1e  # offset -0x1e
.equ local_20, 0x20  # offset -0x20
.equ local_22, 0x22  # offset -0x22
.equ local_26, 0x26  # offset -0x26
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ local_4a, 0x4a  # offset -0x4a
.equ local_4c, 0x4c  # offset -0x4c
.equ local_50, 0x50  # offset -0x50
.equ local_54, 0x54  # offset -0x54
.equ local_58, 0x58  # offset -0x58
.equ local_5c, 0x5c  # offset -0x5c
.equ local_60, 0x60  # offset -0x60
.equ local_64, 0x64  # offset -0x64
.equ local_68, 0x68  # offset -0x68
.equ local_6c, 0x6c  # offset -0x6c
.equ local_70, 0x70  # offset -0x70
.equ local_74, 0x74  # offset -0x74
.equ local_78, 0x78  # offset -0x78
.equ local_7c, 0x7c  # offset -0x7c
.equ local_80, 0x80  # offset -0x80
.equ local_84, 0x84  # offset -0x84
.equ local_88, 0x88  # offset -0x88
.equ local_8c, 0x8c  # offset -0x8c
.equ local_90, 0x90  # offset -0x90
.equ local_94, 0x94  # offset -0x94
.equ field_1, 0x1  # offset +0x1
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_004c7481, .text + (0x004c7481 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cd72, .text + (0x0050cd72 - 0x401000)
.set FUN_0050cee4, .text + (0x0050cee4 - 0x401000)
.set FUN_0050d0a9, .text + (0x0050d0a9 - 0x401000)
.set FUN_0050e493, .text + (0x0050e493 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004c334f - 0x401000
.globl FUN_004c334f
FUN_004c334f:
    # block 0x004c334f: entry, 35 instruction(s), calls FUN_0051dc43, ends with jne to 0x004c33dc (forward)
    push ebp                                     # 004c334f
    {load} mov ebp, esp                          # 004c3350
    sub esp, 0x94                                # 004c3352
    push esi                                     # 004c3358
    push edi                                     # 004c3359
    mov dword ptr [ebp - local_94], ecx          # 004c335a
    mov dword ptr [ebp - local_6c], 0x0          # 004c3360
    mov eax, dword ptr [ebp + arg_c]             # 004c3367
    imul eax, eax, 0x3                           # 004c336a
    mov dword ptr [ebp - local_68], eax          # 004c336d
    mov ecx, dword ptr [ebp - local_68]          # 004c3370
    imul ecx, dword ptr [ebp + arg_10]           # 004c3373
    mov dword ptr [ebp - local_18], ecx          # 004c3377
    mov edx, dword ptr [ebp + arg_c]             # 004c337a
    shl edx                                      # 004c337d
    mov dword ptr [ebp - local_60], edx          # 004c337f
    mov eax, dword ptr [ebp - local_60]          # 004c3382
    imul eax, dword ptr [ebp + arg_10]           # 004c3385
    mov dword ptr [ebp - local_2c], eax          # 004c3389
    mov ecx, dword ptr [ebp - local_68]          # 004c338c
    add ecx, 0x3                                 # 004c338f
    and ecx, -0x4                                # 004c3392
    mov word ptr [ebp - local_74], cx            # 004c3395
    movsx edx, word ptr [ebp - local_74]         # 004c3399
    imul edx, dword ptr [ebp + arg_10]           # 004c339d
    mov dword ptr [ebp - local_10], edx          # 004c33a1
    mov eax, dword ptr [ebp - local_10]          # 004c33a4
    push eax                                     # 004c33a7
    call FUN_0051dc43                            # 004c33a8
    add esp, 0x4                                 # 004c33ad
    mov dword ptr [ebp - local_84], eax          # 004c33b0
    mov ecx, dword ptr [ebp - local_84]          # 004c33b6
    mov dword ptr [ebp - local_80], ecx          # 004c33bc
    cmp dword ptr [ebp - local_80], 0x0          # 004c33bf
    jne.d8 L_004c33dc                            # 004c33c3
    # block 0x004c33c5: entered by fall-through of jne at 0x004c33c3, 5 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x004c36a8
    push 0x5540d0                                # 004c33c5
    push 0x63888b                                # 004c33ca
    call FUN_0050ca3e                            # 004c33cf
    add esp, 0x8                                 # 004c33d4
    jmp.d32 L_004c36a8                           # 004c33d7
L_004c33dc:
    # block 0x004c33dc: entered by jne at 0x004c33c3, 9 instruction(s), calls FUN_0051dc43, ends with jne to 0x004c3402 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004c33dc
    push edx                                     # 004c33df
    call FUN_0051dc43                            # 004c33e0
    add esp, 0x4                                 # 004c33e5
    mov dword ptr [ebp - local_88], eax          # 004c33e8
    mov eax, dword ptr [ebp - local_88]          # 004c33ee
    mov dword ptr [ebp - local_78], eax          # 004c33f4
    cmp dword ptr [ebp - local_78], 0x0          # 004c33f7
    jne.d8 L_004c3402                            # 004c33fb
    # block 0x004c33fd: entered by fall-through of jne at 0x004c33fb, 1 instruction(s), ends with forward jump to 0x004c36a6
    jmp.d32 L_004c36a6                           # 004c33fd
L_004c3402:
    # block 0x004c3402: entered by jne at 0x004c33fb, 38 instruction(s), calls FUN_004c7481, ends with forward jump to 0x004c34b3
    lea ecx, [ebp - local_28]                    # 004c3402
    mov dword ptr [ebp - local_4], ecx           # 004c3405
    mov edx, dword ptr [ebp - local_4]           # 004c3408
    mov byte ptr [edx], 0x42                     # 004c340b
    mov eax, dword ptr [ebp - local_4]           # 004c340e
    mov byte ptr [eax + field_1], 0x4d           # 004c3411
    mov ecx, dword ptr [ebp - local_10]          # 004c3415
    add ecx, 0x36                                # 004c3418
    mov dword ptr [ebp - local_26], ecx          # 004c341b
    mov word ptr [ebp - local_22], 0x0           # 004c341e
    mov word ptr [ebp - local_20], 0x0           # 004c3424
    mov dword ptr [ebp - local_1e], 0x36         # 004c342a
    mov dword ptr [ebp - local_58], 0x28         # 004c3431
    mov edx, dword ptr [ebp + arg_c]             # 004c3438
    mov dword ptr [ebp - local_54], edx          # 004c343b
    mov eax, dword ptr [ebp + arg_10]            # 004c343e
    mov dword ptr [ebp - local_50], eax          # 004c3441
    mov word ptr [ebp - local_4c], 0x1           # 004c3444
    mov word ptr [ebp - local_4a], 0x18          # 004c344a
    mov dword ptr [ebp - local_48], 0x0          # 004c3450
    mov ecx, dword ptr [ebp - local_10]          # 004c3457
    mov dword ptr [ebp - local_44], ecx          # 004c345a
    mov dword ptr [ebp - local_40], 0x0          # 004c345d
    mov dword ptr [ebp - local_3c], 0x0          # 004c3464
    mov dword ptr [ebp - local_38], 0x0          # 004c346b
    mov dword ptr [ebp - local_34], 0x0          # 004c3472
    mov edx, dword ptr [ebp + arg_c]             # 004c3479
    imul edx, dword ptr [ebp + arg_10]           # 004c347c
    movsx eax, word ptr [0x639895]               # 004c3480
    imul edx, eax                                # 004c3487
    push edx                                     # 004c348a
    mov ecx, dword ptr [ebp + arg_8]             # 004c348b
    push ecx                                     # 004c348e
    mov ecx, dword ptr [ebp - local_94]          # 004c348f
    call FUN_004c7481                            # 004c3495
    mov dword ptr [ebp - local_30], 0x0          # 004c349a
    mov dword ptr [ebp - local_c], 0x0           # 004c34a1
    jmp.d8 L_004c34b3                            # 004c34a8
L_004c34aa:
    # block 0x004c34aa: entered by jmp at 0x004c3555, 3 instruction(s), falls into the block at 0x004c34b3
    mov edx, dword ptr [ebp - local_30]          # 004c34aa
    add edx, 0x2                                 # 004c34ad
    mov dword ptr [ebp - local_30], edx          # 004c34b0
L_004c34b3:
    # block 0x004c34b3: entered by jmp at 0x004c34a8, 3 instruction(s), ends with jge to 0x004c355a (forward)
    mov eax, dword ptr [ebp - local_30]          # 004c34b3
    cmp eax, dword ptr [ebp - local_2c]          # 004c34b6
    jge.d32 L_004c355a                           # 004c34b9
    # block 0x004c34bf: entered by fall-through of jge at 0x004c34b9, 49 instruction(s), ends with backward jump to 0x004c34aa
    mov ecx, dword ptr [ebp + arg_8]             # 004c34bf
    add ecx, dword ptr [ebp - local_30]          # 004c34c2
    mov dx, word ptr [ecx]                       # 004c34c5
    mov word ptr [ebp - local_64], dx            # 004c34c8
    mov eax, dword ptr [ebp - local_64]          # 004c34cc
    and eax, 0xffff                              # 004c34cf
    sar eax, 0xa                                 # 004c34d4
    and eax, 0x1f                                # 004c34d7
    mov byte ptr [ebp - local_5c], al            # 004c34da
    mov ecx, dword ptr [ebp - local_64]          # 004c34dd
    and ecx, 0xffff                              # 004c34e0
    sar ecx, 0x5                                 # 004c34e6
    and ecx, 0x1f                                # 004c34e9
    mov byte ptr [ebp - local_8], cl             # 004c34ec
    mov edx, dword ptr [ebp - local_64]          # 004c34ef
    and edx, 0xffff                              # 004c34f2
    and edx, 0x1f                                # 004c34f8
    mov byte ptr [ebp - local_70], dl            # 004c34fb
    mov al, byte ptr [ebp - local_5c]            # 004c34fe
    shl al, 0x3                                  # 004c3501
    mov byte ptr [ebp - local_5c], al            # 004c3504
    mov cl, byte ptr [ebp - local_8]             # 004c3507
    shl cl, 0x3                                  # 004c350a
    mov byte ptr [ebp - local_8], cl             # 004c350d
    mov dl, byte ptr [ebp - local_70]            # 004c3510
    shl dl, 0x3                                  # 004c3513
    mov byte ptr [ebp - local_70], dl            # 004c3516
    mov eax, dword ptr [ebp - local_78]          # 004c3519
    add eax, dword ptr [ebp - local_c]           # 004c351c
    mov cl, byte ptr [ebp - local_70]            # 004c351f
    mov byte ptr [eax], cl                       # 004c3522
    mov edx, dword ptr [ebp - local_c]           # 004c3524
    add edx, 0x1                                 # 004c3527
    mov dword ptr [ebp - local_c], edx           # 004c352a
    mov eax, dword ptr [ebp - local_78]          # 004c352d
    add eax, dword ptr [ebp - local_c]           # 004c3530
    mov cl, byte ptr [ebp - local_8]             # 004c3533
    mov byte ptr [eax], cl                       # 004c3536
    mov edx, dword ptr [ebp - local_c]           # 004c3538
    add edx, 0x1                                 # 004c353b
    mov dword ptr [ebp - local_c], edx           # 004c353e
    mov eax, dword ptr [ebp - local_78]          # 004c3541
    add eax, dword ptr [ebp - local_c]           # 004c3544
    mov cl, byte ptr [ebp - local_5c]            # 004c3547
    mov byte ptr [eax], cl                       # 004c354a
    mov edx, dword ptr [ebp - local_c]           # 004c354c
    add edx, 0x1                                 # 004c354f
    mov dword ptr [ebp - local_c], edx           # 004c3552
    jmp.d32 L_004c34aa                           # 004c3555
L_004c355a:
    # block 0x004c355a: entered by jge at 0x004c34b9, 5 instruction(s), ends with forward jump to 0x004c3582
    mov eax, dword ptr [ebp + arg_10]            # 004c355a
    sub eax, 0x1                                 # 004c355d
    mov word ptr [ebp - local_14], ax            # 004c3560
    mov dword ptr [ebp - local_30], 0x0          # 004c3564
    jmp.d8 L_004c3582                            # 004c356b
L_004c356d:
    # block 0x004c356d: entered by jmp at 0x004c35b7, 6 instruction(s), falls into the block at 0x004c3582
    mov cx, word ptr [ebp - local_14]            # 004c356d
    sub cx, 0x1                                  # 004c3571
    mov word ptr [ebp - local_14], cx            # 004c3575
    mov edx, dword ptr [ebp - local_30]          # 004c3579
    add edx, 0x1                                 # 004c357c
    mov dword ptr [ebp - local_30], edx          # 004c357f
L_004c3582:
    # block 0x004c3582: entered by jmp at 0x004c356b, 3 instruction(s), ends with jl to 0x004c35b9 (forward)
    movsx eax, word ptr [ebp - local_14]         # 004c3582
    test eax, eax                                # 004c3586
    jl.d8 L_004c35b9                             # 004c3588
    # block 0x004c358a: entered by fall-through of jl at 0x004c3588, 17 instruction(s), ends with backward jump to 0x004c356d
    mov ecx, dword ptr [ebp - local_68]          # 004c358a
    mov edx, dword ptr [ebp - local_30]          # 004c358d
    imul edx, dword ptr [ebp - local_68]         # 004c3590
    mov esi, dword ptr [ebp - local_78]          # 004c3594
    {load} add esi, edx                          # 004c3597
    movsx eax, word ptr [ebp - local_14]         # 004c3599
    movsx edx, word ptr [ebp - local_74]         # 004c359d
    imul eax, edx                                # 004c35a1
    mov edi, dword ptr [ebp - local_80]          # 004c35a4
    {load} add edi, eax                          # 004c35a7
    {load} mov eax, ecx                          # 004c35a9
    shr ecx, 0x2                                 # 004c35ab
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004c35ae
    {load} mov ecx, eax                          # 004c35b0
    and ecx, 0x3                                 # 004c35b2
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004c35b5
    jmp.d8 L_004c356d                            # 004c35b7
L_004c35b9:
    # block 0x004c35b9: entered by jl at 0x004c3588, 15 instruction(s), calls FUN_0050cd72, FUN_0050d0a9, ends with jne to 0x004c35f9 (forward)
    push 0x554114                                # 004c35b9
    mov ecx, dword ptr [ebp + arg_14]            # 004c35be
    push ecx                                     # 004c35c1
    push 0x639aa2                                # 004c35c2
    push 0x639a9f                                # 004c35c7
    push 0x63888b                                # 004c35cc
    call FUN_0050cd72                            # 004c35d1
    add esp, 0x14                                # 004c35d6
    push 0x55411c                                # 004c35d9
    push 0x63888b                                # 004c35de
    call FUN_0050d0a9                            # 004c35e3
    add esp, 0x8                                 # 004c35e8
    mov dword ptr [ebp - local_7c], eax          # 004c35eb
    cmp dword ptr [ebp - local_7c], 0x0          # 004c35ee
    jne.d8 L_004c35f9                            # 004c35f2
    # block 0x004c35f4: entered by fall-through of jne at 0x004c35f2, 1 instruction(s), ends with forward jump to 0x004c36a4
    jmp.d32 L_004c36a4                           # 004c35f4
L_004c35f9:
    # block 0x004c35f9: entered by jne at 0x004c35f2, 27 instruction(s), calls FUN_0050e493, ends with je to 0x004c3649 (forward)
    mov edx, dword ptr [ebp - local_7c]          # 004c35f9
    push edx                                     # 004c35fc
    push 0x1                                     # 004c35fd
    push 0xe                                     # 004c35ff
    lea eax, [ebp - local_28]                    # 004c3601
    push eax                                     # 004c3604
    call FUN_0050e493                            # 004c3605
    add esp, 0x10                                # 004c360a
    mov ecx, dword ptr [ebp - local_7c]          # 004c360d
    push ecx                                     # 004c3610
    push 0x1                                     # 004c3611
    push 0x28                                    # 004c3613
    lea edx, [ebp - local_58]                    # 004c3615
    push edx                                     # 004c3618
    call FUN_0050e493                            # 004c3619
    add esp, 0x10                                # 004c361e
    mov eax, dword ptr [ebp - local_7c]          # 004c3621
    push eax                                     # 004c3624
    push 0x1                                     # 004c3625
    mov ecx, dword ptr [ebp - local_10]          # 004c3627
    push ecx                                     # 004c362a
    mov edx, dword ptr [ebp - local_80]          # 004c362b
    push edx                                     # 004c362e
    call FUN_0050e493                            # 004c362f
    add esp, 0x10                                # 004c3634
    cmp dword ptr [ebp - local_7c], 0x0          # 004c3637
    je.d8 L_004c3649                             # 004c363b
    # block 0x004c363d: entered by fall-through of je at 0x004c363b, 4 instruction(s), calls FUN_0050cee4, falls into the block at 0x004c3649
    mov eax, dword ptr [ebp - local_7c]          # 004c363d
    push eax                                     # 004c3640
    call FUN_0050cee4                            # 004c3641
    add esp, 0x4                                 # 004c3646
L_004c3649:
    # block 0x004c3649: entered by je at 0x004c363b; jmp at 0x004c36a4; jmp at 0x004c36a6; jmp at 0x004c36a8, 2 instruction(s), ends with je to 0x004c366e (forward)
    cmp dword ptr [ebp - local_78], 0x0          # 004c3649
    je.d8 L_004c366e                             # 004c364d
    # block 0x004c364f: entered by fall-through of je at 0x004c364d, 7 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004c366e
    mov ecx, dword ptr [ebp - local_78]          # 004c364f
    mov dword ptr [ebp - local_8c], ecx          # 004c3652
    mov edx, dword ptr [ebp - local_8c]          # 004c3658
    push edx                                     # 004c365e
    call FUN_0051dc6c                            # 004c365f
    add esp, 0x4                                 # 004c3664
    mov dword ptr [ebp - local_78], 0x0          # 004c3667
L_004c366e:
    # block 0x004c366e: entered by je at 0x004c364d, 2 instruction(s), ends with je to 0x004c3693 (forward)
    cmp dword ptr [ebp - local_80], 0x0          # 004c366e
    je.d8 L_004c3693                             # 004c3672
    # block 0x004c3674: entered by fall-through of je at 0x004c3672, 7 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004c3693
    mov eax, dword ptr [ebp - local_80]          # 004c3674
    mov dword ptr [ebp - local_90], eax          # 004c3677
    mov ecx, dword ptr [ebp - local_90]          # 004c367d
    push ecx                                     # 004c3683
    call FUN_0051dc6c                            # 004c3684
    add esp, 0x4                                 # 004c3689
    mov dword ptr [ebp - local_80], 0x0          # 004c368c
L_004c3693:
    # block 0x004c3693: entered by je at 0x004c3672, 2 instruction(s), ends with je to 0x004c369d (forward)
    cmp dword ptr [ebp - local_6c], 0x0          # 004c3693
    je.d8 L_004c369d                             # 004c3697
    # block 0x004c3699: entered by fall-through of je at 0x004c3697, 2 instruction(s), ends with forward jump to 0x004c36aa
    {load} xor eax, eax                          # 004c3699
    jmp.d8 L_004c36aa                            # 004c369b
L_004c369d:
    # block 0x004c369d: entered by je at 0x004c3697, 2 instruction(s), ends with forward jump to 0x004c36aa
    mov eax, 0x1                                 # 004c369d
    jmp.d8 L_004c36aa                            # 004c36a2
L_004c36a4:
    # block 0x004c36a4: entered by jmp at 0x004c35f4, 1 instruction(s), ends with backward jump to 0x004c3649
    jmp.d8 L_004c3649                            # 004c36a4
L_004c36a6:
    # block 0x004c36a6: entered by jmp at 0x004c33fd, 1 instruction(s), ends with backward jump to 0x004c3649
    jmp.d8 L_004c3649                            # 004c36a6
L_004c36a8:
    # block 0x004c36a8: entered by jmp at 0x004c33d7, 1 instruction(s), ends with backward jump to 0x004c3649
    jmp.d8 L_004c3649                            # 004c36a8
L_004c36aa:
    # block 0x004c36aa: entered by jmp at 0x004c369b; jmp at 0x004c36a2, 5 instruction(s), ends with ret 0x10
    pop edi                                      # 004c36aa
    pop esi                                      # 004c36ab
    {load} mov esp, ebp                          # 004c36ac
    pop ebp                                      # 004c36ae
    ret 0x10                                     # 004c36af

