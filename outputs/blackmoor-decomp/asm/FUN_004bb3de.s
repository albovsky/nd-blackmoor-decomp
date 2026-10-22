# FUN_004bb3de
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bb3de
# extent:       0x004bb3de-0x004bb775 (919 code bytes)
# span:         0x004bb3de-0x004bb775 (code 919, tables 0, padding 0)
# sha256:       748fb5bab0e1a3f390d36f3932bf72f144849a19e543780bfce4de19cbe73ca1
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004bb3de
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_4, field_8, field_c, field_58, field_5c, field_64, field_70, field_8c, field_dc; [ecx + n] field_4, field_8, field_c, field_58, field_60, field_64, field_6c, field_74, field_88, field_90, field_94, field_98 and 2 more; [edx + n] field_58, field_5c, field_60, field_68, field_6c, field_70, field_74, field_8c, field_90, field_94, field_98, field_d8 and 4 more
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 253 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_58, 0x58  # offset +0x58
.equ field_5c, 0x5c  # offset +0x5c
.equ field_60, 0x60  # offset +0x60
.equ field_64, 0x64  # offset +0x64
.equ field_68, 0x68  # offset +0x68
.equ field_6c, 0x6c  # offset +0x6c
.equ field_70, 0x70  # offset +0x70
.equ field_74, 0x74  # offset +0x74
.equ field_88, 0x88  # offset +0x88
.equ field_8c, 0x8c  # offset +0x8c
.equ field_90, 0x90  # offset +0x90
.equ field_94, 0x94  # offset +0x94
.equ field_98, 0x98  # offset +0x98
.equ field_d8, 0xd8  # offset +0xd8
.equ field_dc, 0xdc  # offset +0xdc
.equ field_e0, 0xe0  # offset +0xe0
.equ field_e4, 0xe4  # offset +0xe4
.equ field_e8, 0xe8  # offset +0xe8

# --- external targets -----------------------------------------------

.org 0x004bb3de - 0x401000
.globl FUN_004bb3de
FUN_004bb3de:
    # block 0x004bb3de: entry, 6 instruction(s), ends with forward jump to 0x004bb3f9
    push ebp                                     # 004bb3de
    {load} mov ebp, esp                          # 004bb3df
    sub esp, 0x8                                 # 004bb3e1
    mov dword ptr [ebp - local_8], ecx           # 004bb3e4
    mov dword ptr [ebp - local_4], 0x0           # 004bb3e7
    jmp.d8 L_004bb3f9                            # 004bb3ee
L_004bb3f0:
    # block 0x004bb3f0: entered by jmp at 0x004bb42a; jmp at 0x004bb76a, 3 instruction(s), falls into the block at 0x004bb3f9
    mov eax, dword ptr [ebp - local_4]           # 004bb3f0
    add eax, 0x1                                 # 004bb3f3
    mov dword ptr [ebp - local_4], eax           # 004bb3f6
L_004bb3f9:
    # block 0x004bb3f9: entered by jmp at 0x004bb3ee, 2 instruction(s), ends with jge to 0x004bb76f (forward)
    cmp dword ptr [ebp - local_4], 0x4           # 004bb3f9
    jge.d32 L_004bb76f                           # 004bb3fd
    # block 0x004bb403: entered by fall-through of jge at 0x004bb3fd, 9 instruction(s), ends with jne to 0x004bb42c (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004bb403
    imul ecx, ecx, 0x14                          # 004bb406
    mov edx, dword ptr [ebp + arg_8]             # 004bb409
    mov dword ptr [edx + ecx + field_d8], 0x0    # 004bb40c
    mov eax, dword ptr [ebp - local_4]           # 004bb417
    imul eax, eax, 0x14                          # 004bb41a
    mov ecx, dword ptr [ebp + arg_8]             # 004bb41d
    cmp dword ptr [ecx + eax + field_88], 0x0    # 004bb420
    jne.d8 L_004bb42c                            # 004bb428
    # block 0x004bb42a: entered by fall-through of jne at 0x004bb428, 1 instruction(s), ends with backward jump to 0x004bb3f0
    jmp.d8 L_004bb3f0                            # 004bb42a
L_004bb42c:
    # block 0x004bb42c: entered by jne at 0x004bb428, 7 instruction(s), ends with jge to 0x004bb533 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004bb42c
    imul edx, edx, 0x14                          # 004bb42f
    mov eax, dword ptr [ebp + arg_8]             # 004bb432
    mov ecx, dword ptr [ebp + arg_8]             # 004bb435
    mov edx, dword ptr [eax + edx + field_8c]    # 004bb438
    cmp edx, dword ptr [ecx + field_58]          # 004bb43f
    jge.d32 L_004bb533                           # 004bb442
    # block 0x004bb448: entered by fall-through of jge at 0x004bb442, 7 instruction(s), ends with jle to 0x004bb533 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004bb448
    imul eax, eax, 0x14                          # 004bb44b
    mov ecx, dword ptr [ebp + arg_8]             # 004bb44e
    mov edx, dword ptr [ebp + arg_8]             # 004bb451
    mov eax, dword ptr [ecx + eax + field_94]    # 004bb454
    cmp eax, dword ptr [edx + field_58]          # 004bb45b
    jle.d32 L_004bb533                           # 004bb45e
    # block 0x004bb464: entered by fall-through of jle at 0x004bb45e, 58 instruction(s), ends with forward jump to 0x004bb76a
    mov ecx, dword ptr [ebp - local_4]           # 004bb464
    imul ecx, ecx, 0x14                          # 004bb467
    mov edx, dword ptr [ebp + arg_8]             # 004bb46a
    mov dword ptr [edx + ecx + field_d8], 0x1    # 004bb46d
    mov eax, dword ptr [ebp + arg_8]             # 004bb478
    add eax, 0x68                                # 004bb47b
    mov ecx, dword ptr [ebp - local_4]           # 004bb47e
    imul ecx, ecx, 0x14                          # 004bb481
    mov edx, dword ptr [ebp + arg_8]             # 004bb484
    lea ecx, [edx + ecx + field_dc]              # 004bb487
    mov edx, dword ptr [eax]                     # 004bb48e
    mov dword ptr [ecx], edx                     # 004bb490
    mov edx, dword ptr [eax + field_4]           # 004bb492
    mov dword ptr [ecx + field_4], edx           # 004bb495
    mov edx, dword ptr [eax + field_8]           # 004bb498
    mov dword ptr [ecx + field_8], edx           # 004bb49b
    mov eax, dword ptr [eax + field_c]           # 004bb49e
    mov dword ptr [ecx + field_c], eax           # 004bb4a1
    mov ecx, dword ptr [ebp - local_4]           # 004bb4a4
    imul ecx, ecx, 0x14                          # 004bb4a7
    mov edx, dword ptr [ebp + arg_8]             # 004bb4aa
    mov eax, dword ptr [ebp + arg_8]             # 004bb4ad
    mov ecx, dword ptr [edx + ecx + field_94]    # 004bb4b0
    sub ecx, dword ptr [eax + field_58]          # 004bb4b7
    mov edx, dword ptr [ebp + arg_8]             # 004bb4ba
    mov eax, dword ptr [edx + field_68]          # 004bb4bd
    {load} add eax, ecx                          # 004bb4c0
    mov ecx, dword ptr [ebp - local_4]           # 004bb4c2
    imul ecx, ecx, 0x14                          # 004bb4c5
    mov edx, dword ptr [ebp + arg_8]             # 004bb4c8
    mov dword ptr [edx + ecx + field_e4], eax    # 004bb4cb
    mov eax, dword ptr [ebp - local_4]           # 004bb4d2
    imul eax, eax, 0x14                          # 004bb4d5
    mov ecx, dword ptr [ebp + arg_8]             # 004bb4d8
    mov edx, dword ptr [ebp + arg_8]             # 004bb4db
    mov eax, dword ptr [ecx + eax + field_90]    # 004bb4de
    sub eax, dword ptr [edx + field_5c]          # 004bb4e5
    mov ecx, dword ptr [ebp + arg_8]             # 004bb4e8
    mov edx, dword ptr [ecx + field_6c]          # 004bb4eb
    {load} add edx, eax                          # 004bb4ee
    mov eax, dword ptr [ebp - local_4]           # 004bb4f0
    imul eax, eax, 0x14                          # 004bb4f3
    mov ecx, dword ptr [ebp + arg_8]             # 004bb4f6
    mov dword ptr [ecx + eax + field_e0], edx    # 004bb4f9
    mov edx, dword ptr [ebp - local_4]           # 004bb500
    imul edx, edx, 0x14                          # 004bb503
    mov eax, dword ptr [ebp + arg_8]             # 004bb506
    mov ecx, dword ptr [ebp + arg_8]             # 004bb509
    mov eax, dword ptr [eax + field_64]          # 004bb50c
    sub eax, dword ptr [ecx + edx + field_98]    # 004bb50f
    mov ecx, dword ptr [ebp + arg_8]             # 004bb516
    mov edx, dword ptr [ecx + field_74]          # 004bb519
    {load} sub edx, eax                          # 004bb51c
    mov eax, dword ptr [ebp - local_4]           # 004bb51e
    imul eax, eax, 0x14                          # 004bb521
    mov ecx, dword ptr [ebp + arg_8]             # 004bb524
    mov dword ptr [ecx + eax + field_e8], edx    # 004bb527
    jmp.d32 L_004bb76a                           # 004bb52e
L_004bb533:
    # block 0x004bb533: entered by jge at 0x004bb442; jle at 0x004bb45e, 7 instruction(s), ends with jl to 0x004bb668 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004bb533
    imul edx, edx, 0x14                          # 004bb536
    mov eax, dword ptr [ebp + arg_8]             # 004bb539
    mov ecx, dword ptr [ebp + arg_8]             # 004bb53c
    mov edx, dword ptr [eax + edx + field_8c]    # 004bb53f
    cmp edx, dword ptr [ecx + field_58]          # 004bb546
    jl.d32 L_004bb668                            # 004bb549
    # block 0x004bb54f: entered by fall-through of jl at 0x004bb549, 7 instruction(s), ends with jg to 0x004bb668 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004bb54f
    imul eax, eax, 0x14                          # 004bb552
    mov ecx, dword ptr [ebp + arg_8]             # 004bb555
    mov edx, dword ptr [ebp + arg_8]             # 004bb558
    mov eax, dword ptr [ecx + eax + field_94]    # 004bb55b
    cmp eax, dword ptr [edx + field_60]          # 004bb562
    jg.d32 L_004bb668                            # 004bb565
    # block 0x004bb56b: entered by fall-through of jg at 0x004bb565, 71 instruction(s), ends with forward jump to 0x004bb76a
    mov ecx, dword ptr [ebp - local_4]           # 004bb56b
    imul ecx, ecx, 0x14                          # 004bb56e
    mov edx, dword ptr [ebp + arg_8]             # 004bb571
    mov dword ptr [edx + ecx + field_d8], 0x1    # 004bb574
    mov eax, dword ptr [ebp + arg_8]             # 004bb57f
    add eax, 0x68                                # 004bb582
    mov ecx, dword ptr [ebp - local_4]           # 004bb585
    imul ecx, ecx, 0x14                          # 004bb588
    mov edx, dword ptr [ebp + arg_8]             # 004bb58b
    lea ecx, [edx + ecx + field_dc]              # 004bb58e
    mov edx, dword ptr [eax]                     # 004bb595
    mov dword ptr [ecx], edx                     # 004bb597
    mov edx, dword ptr [eax + field_4]           # 004bb599
    mov dword ptr [ecx + field_4], edx           # 004bb59c
    mov edx, dword ptr [eax + field_8]           # 004bb59f
    mov dword ptr [ecx + field_8], edx           # 004bb5a2
    mov eax, dword ptr [eax + field_c]           # 004bb5a5
    mov dword ptr [ecx + field_c], eax           # 004bb5a8
    mov ecx, dword ptr [ebp - local_4]           # 004bb5ab
    imul ecx, ecx, 0x14                          # 004bb5ae
    mov edx, dword ptr [ebp + arg_8]             # 004bb5b1
    mov eax, dword ptr [ebp + arg_8]             # 004bb5b4
    mov ecx, dword ptr [edx + ecx + field_8c]    # 004bb5b7
    sub ecx, dword ptr [eax + field_58]          # 004bb5be
    mov edx, dword ptr [ebp + arg_8]             # 004bb5c1
    mov eax, dword ptr [edx + field_68]          # 004bb5c4
    {load} add eax, ecx                          # 004bb5c7
    mov ecx, dword ptr [ebp - local_4]           # 004bb5c9
    imul ecx, ecx, 0x14                          # 004bb5cc
    mov edx, dword ptr [ebp + arg_8]             # 004bb5cf
    mov dword ptr [edx + ecx + field_dc], eax    # 004bb5d2
    mov eax, dword ptr [ebp - local_4]           # 004bb5d9
    imul eax, eax, 0x14                          # 004bb5dc
    mov ecx, dword ptr [ebp + arg_8]             # 004bb5df
    mov edx, dword ptr [ebp + arg_8]             # 004bb5e2
    mov ecx, dword ptr [ecx + field_60]          # 004bb5e5
    sub ecx, dword ptr [edx + eax + field_94]    # 004bb5e8
    mov edx, dword ptr [ebp + arg_8]             # 004bb5ef
    mov eax, dword ptr [edx + field_70]          # 004bb5f2
    {load} sub eax, ecx                          # 004bb5f5
    mov ecx, dword ptr [ebp - local_4]           # 004bb5f7
    imul ecx, ecx, 0x14                          # 004bb5fa
    mov edx, dword ptr [ebp + arg_8]             # 004bb5fd
    mov dword ptr [edx + ecx + field_e4], eax    # 004bb600
    mov eax, dword ptr [ebp - local_4]           # 004bb607
    imul eax, eax, 0x14                          # 004bb60a
    mov ecx, dword ptr [ebp + arg_8]             # 004bb60d
    mov edx, dword ptr [ebp + arg_8]             # 004bb610
    mov eax, dword ptr [ecx + eax + field_90]    # 004bb613
    sub eax, dword ptr [edx + field_5c]          # 004bb61a
    mov ecx, dword ptr [ebp + arg_8]             # 004bb61d
    mov edx, dword ptr [ecx + field_6c]          # 004bb620
    {load} add edx, eax                          # 004bb623
    mov eax, dword ptr [ebp - local_4]           # 004bb625
    imul eax, eax, 0x14                          # 004bb628
    mov ecx, dword ptr [ebp + arg_8]             # 004bb62b
    mov dword ptr [ecx + eax + field_e0], edx    # 004bb62e
    mov edx, dword ptr [ebp - local_4]           # 004bb635
    imul edx, edx, 0x14                          # 004bb638
    mov eax, dword ptr [ebp + arg_8]             # 004bb63b
    mov ecx, dword ptr [ebp + arg_8]             # 004bb63e
    mov eax, dword ptr [eax + field_64]          # 004bb641
    sub eax, dword ptr [ecx + edx + field_98]    # 004bb644
    mov ecx, dword ptr [ebp + arg_8]             # 004bb64b
    mov edx, dword ptr [ecx + field_74]          # 004bb64e
    {load} sub edx, eax                          # 004bb651
    mov eax, dword ptr [ebp - local_4]           # 004bb653
    imul eax, eax, 0x14                          # 004bb656
    mov ecx, dword ptr [ebp + arg_8]             # 004bb659
    mov dword ptr [ecx + eax + field_e8], edx    # 004bb65c
    jmp.d32 L_004bb76a                           # 004bb663
L_004bb668:
    # block 0x004bb668: entered by jl at 0x004bb549; jg at 0x004bb565, 7 instruction(s), ends with jg to 0x004bb76a (forward)
    mov edx, dword ptr [ebp - local_4]           # 004bb668
    imul edx, edx, 0x14                          # 004bb66b
    mov eax, dword ptr [ebp + arg_8]             # 004bb66e
    mov ecx, dword ptr [ebp + arg_8]             # 004bb671
    mov edx, dword ptr [eax + edx + field_8c]    # 004bb674
    cmp edx, dword ptr [ecx + field_60]          # 004bb67b
    jg.d32 L_004bb76a                            # 004bb67e
    # block 0x004bb684: entered by fall-through of jg at 0x004bb67e, 7 instruction(s), ends with jl to 0x004bb76a (forward)
    mov eax, dword ptr [ebp - local_4]           # 004bb684
    imul eax, eax, 0x14                          # 004bb687
    mov ecx, dword ptr [ebp + arg_8]             # 004bb68a
    mov edx, dword ptr [ebp + arg_8]             # 004bb68d
    mov eax, dword ptr [ecx + eax + field_94]    # 004bb690
    cmp eax, dword ptr [edx + field_60]          # 004bb697
    jl.d32 L_004bb76a                            # 004bb69a
    # block 0x004bb6a0: entered by fall-through of jl at 0x004bb69a, 57 instruction(s), falls into the block at 0x004bb76a
    mov ecx, dword ptr [ebp - local_4]           # 004bb6a0
    imul ecx, ecx, 0x14                          # 004bb6a3
    mov edx, dword ptr [ebp + arg_8]             # 004bb6a6
    mov dword ptr [edx + ecx + field_d8], 0x1    # 004bb6a9
    mov eax, dword ptr [ebp + arg_8]             # 004bb6b4
    add eax, 0x68                                # 004bb6b7
    mov ecx, dword ptr [ebp - local_4]           # 004bb6ba
    imul ecx, ecx, 0x14                          # 004bb6bd
    mov edx, dword ptr [ebp + arg_8]             # 004bb6c0
    lea ecx, [edx + ecx + field_dc]              # 004bb6c3
    mov edx, dword ptr [eax]                     # 004bb6ca
    mov dword ptr [ecx], edx                     # 004bb6cc
    mov edx, dword ptr [eax + field_4]           # 004bb6ce
    mov dword ptr [ecx + field_4], edx           # 004bb6d1
    mov edx, dword ptr [eax + field_8]           # 004bb6d4
    mov dword ptr [ecx + field_8], edx           # 004bb6d7
    mov eax, dword ptr [eax + field_c]           # 004bb6da
    mov dword ptr [ecx + field_c], eax           # 004bb6dd
    mov ecx, dword ptr [ebp - local_4]           # 004bb6e0
    imul ecx, ecx, 0x14                          # 004bb6e3
    mov edx, dword ptr [ebp + arg_8]             # 004bb6e6
    mov eax, dword ptr [ebp + arg_8]             # 004bb6e9
    mov edx, dword ptr [edx + field_60]          # 004bb6ec
    sub edx, dword ptr [eax + ecx + field_8c]    # 004bb6ef
    mov eax, dword ptr [ebp + arg_8]             # 004bb6f6
    mov ecx, dword ptr [eax + field_70]          # 004bb6f9
    {load} sub ecx, edx                          # 004bb6fc
    mov edx, dword ptr [ebp - local_4]           # 004bb6fe
    imul edx, edx, 0x14                          # 004bb701
    mov eax, dword ptr [ebp + arg_8]             # 004bb704
    mov dword ptr [eax + edx + field_dc], ecx    # 004bb707
    mov ecx, dword ptr [ebp - local_4]           # 004bb70e
    imul ecx, ecx, 0x14                          # 004bb711
    mov edx, dword ptr [ebp + arg_8]             # 004bb714
    mov eax, dword ptr [ebp + arg_8]             # 004bb717
    mov ecx, dword ptr [edx + ecx + field_90]    # 004bb71a
    sub ecx, dword ptr [eax + field_5c]          # 004bb721
    mov edx, dword ptr [ebp + arg_8]             # 004bb724
    mov eax, dword ptr [edx + field_6c]          # 004bb727
    {load} add eax, ecx                          # 004bb72a
    mov ecx, dword ptr [ebp - local_4]           # 004bb72c
    imul ecx, ecx, 0x14                          # 004bb72f
    mov edx, dword ptr [ebp + arg_8]             # 004bb732
    mov dword ptr [edx + ecx + field_e0], eax    # 004bb735
    mov eax, dword ptr [ebp - local_4]           # 004bb73c
    imul eax, eax, 0x14                          # 004bb73f
    mov ecx, dword ptr [ebp + arg_8]             # 004bb742
    mov edx, dword ptr [ebp + arg_8]             # 004bb745
    mov ecx, dword ptr [ecx + field_64]          # 004bb748
    sub ecx, dword ptr [edx + eax + field_98]    # 004bb74b
    mov edx, dword ptr [ebp + arg_8]             # 004bb752
    mov eax, dword ptr [edx + field_74]          # 004bb755
    {load} sub eax, ecx                          # 004bb758
    mov ecx, dword ptr [ebp - local_4]           # 004bb75a
    imul ecx, ecx, 0x14                          # 004bb75d
    mov edx, dword ptr [ebp + arg_8]             # 004bb760
    mov dword ptr [edx + ecx + field_e8], eax    # 004bb763
L_004bb76a:
    # block 0x004bb76a: entered by jmp at 0x004bb52e; jmp at 0x004bb663; jg at 0x004bb67e; jl at 0x004bb69a, 1 instruction(s), ends with backward jump to 0x004bb3f0
    jmp.d32 L_004bb3f0                           # 004bb76a
L_004bb76f:
    # block 0x004bb76f: entered by jge at 0x004bb3fd, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004bb76f
    pop ebp                                      # 004bb771
    ret 0x4                                      # 004bb772

