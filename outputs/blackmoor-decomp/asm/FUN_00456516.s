# FUN_00456516
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00456516
# extent:       0x00456516-0x00456bdf (1737 code bytes)
# span:         0x00456516-0x00456bf0 (code 1737, tables 16, padding 1)
# sha256:       532f3843ff4d6fa95270adb57621c5a251e151a4854ac4dceae9639276b01563
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00456516
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       11 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c
# fields:       [eax + n] field_40, field_45, field_90, field_92; [ecx + n] field_23, field_40, field_90, field_94; [edx + n] field_4, field_8, field_c, field_21, field_40, field_45, field_90
# callees:      calls FUN_004c5377, FUN_00454f29, FUN_004c5d4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 462 instruction(s), 33 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_40, 0x40  # offset +0x40
.equ field_45, 0x45  # offset +0x45
.equ field_90, 0x90  # offset +0x90
.equ field_92, 0x92  # offset +0x92
.equ field_94, 0x94  # offset +0x94

# --- external targets -----------------------------------------------
.set FUN_00454f29, .text + (0x00454f29 - 0x401000)
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)

.org 0x00456516 - 0x401000
.globl FUN_00456516
FUN_00456516:
    # block 0x00456516: entry, 5 instruction(s), ends with je to 0x00456bdb (forward)
    push ebp                                     # 00456516
    {load} mov ebp, esp                          # 00456517
    sub esp, 0x2c                                # 00456519
    cmp dword ptr [0x624a02], 0x0                # 0045651c
    je.d32 L_00456bdb                            # 00456523
    # block 0x00456529: entered by fall-through of je at 0x00456523, 6 instruction(s), ends with jne to 0x00456551 (forward)
    movsx eax, word ptr [0x6249fa]               # 00456529
    imul eax, eax, 0x8d                          # 00456530
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00456536
    mov dword ptr [ebp - local_8], ecx           # 0045653c
    cmp dword ptr [0x624a06], 0x0                # 0045653f
    jne.d8 L_00456551                            # 00456546
    # block 0x00456548: entered by fall-through of jne at 0x00456546, 2 instruction(s), ends with je to 0x00456581 (forward)
    cmp dword ptr [0x624a0a], 0x0                # 00456548
    je.d8 L_00456581                             # 0045654f
L_00456551:
    # block 0x00456551: entered by jne at 0x00456546; fall-through of je at 0x0045654f, 10 instruction(s), calls FUN_004c5377, falls into the block at 0x00456581
    push 0x54a104                                # 00456551
    push 0x624a36                                # 00456556
    push 0x624a16                                # 0045655b
    mov edx, dword ptr [0x5cf665]                # 00456560
    push edx                                     # 00456566
    mov eax, dword ptr [0x5d15e3]                # 00456567
    push eax                                     # 0045656c
    mov ecx, 0x5cf659                            # 0045656d
    call FUN_004c5377                            # 00456572
    mov dword ptr [0x624a0a], 0x0                # 00456577
L_00456581:
    # block 0x00456581: entered by je at 0x0045654f, 2 instruction(s), ends with je to 0x004565cc (forward)
    cmp dword ptr [0x624a0e], 0x0                # 00456581
    je.d8 L_004565cc                             # 00456588
    # block 0x0045658a: entered by fall-through of je at 0x00456588, 16 instruction(s), calls FUN_00454f29, FUN_004c5377, falls into the block at 0x004565cc
    lea ecx, [ebp - local_24]                    # 0045658a
    push ecx                                     # 0045658d
    push 0x624a56                                # 0045658e
    mov ecx, 0x6249dc                            # 00456593
    call FUN_00454f29                            # 00456598
    push 0x54a138                                # 0045659d
    lea edx, [ebp - local_24]                    # 004565a2
    push edx                                     # 004565a5
    push 0x624a56                                # 004565a6
    mov eax, dword ptr [0x5cf665]                # 004565ab
    push eax                                     # 004565b0
    mov ecx, dword ptr [0x5d15e3]                # 004565b1
    push ecx                                     # 004565b7
    mov ecx, 0x5cf659                            # 004565b8
    call FUN_004c5377                            # 004565bd
    mov dword ptr [0x624a0e], 0x0                # 004565c2
L_004565cc:
    # block 0x004565cc: entered by je at 0x00456588, 3 instruction(s), ends with je to 0x004566be (forward)
    movsx edx, word ptr [0x624a6a]               # 004565cc
    cmp edx, -0x1                                # 004565d3
    je.d32 L_004566be                            # 004565d6
    # block 0x004565dc: entered by fall-through of je at 0x004565d6, 2 instruction(s), ends with forward jump to 0x004565f0
    mov word ptr [ebp - local_c], 0x0            # 004565dc
    jmp.d8 L_004565f0                            # 004565e2
L_004565e4:
    # block 0x004565e4: entered by jmp at 0x004566b0, 3 instruction(s), falls into the block at 0x004565f0
    mov ax, word ptr [ebp - local_c]             # 004565e4
    .insn 0x66, 0x05, 0x0001{:u16}               # 004565e8
    mov word ptr [ebp - local_c], ax             # 004565ec
L_004565f0:
    # block 0x004565f0: entered by jmp at 0x004565e2, 5 instruction(s), ends with jge to 0x004566b5 (forward)
    movsx ecx, word ptr [ebp - local_c]          # 004565f0
    mov edx, dword ptr [ebp - local_8]           # 004565f4
    movsx eax, word ptr [edx + field_21]         # 004565f7
    {load} cmp ecx, eax                          # 004565fb
    jge.d32 L_004566b5                           # 004565fd
    # block 0x00456603: entered by fall-through of jge at 0x004565fd, 9 instruction(s), ends with je to 0x004566b0 (forward)
    movsx ecx, word ptr [ebp - local_c]          # 00456603
    imul ecx, ecx, 0x96                          # 00456607
    mov edx, dword ptr [ebp - local_8]           # 0045660d
    lea eax, [edx + ecx + field_45]              # 00456610
    mov dword ptr [ebp - local_14], eax          # 00456614
    mov ecx, dword ptr [ebp - local_14]          # 00456617
    movsx edx, word ptr [ecx + field_94]         # 0045661a
    test edx, edx                                # 00456621
    je.d32 L_004566b0                            # 00456623
    # block 0x00456629: entered by fall-through of je at 0x00456623, 33 instruction(s), calls FUN_004c5377, falls into the block at 0x004566b0
    movsx eax, word ptr [ebp - local_c]          # 00456629
    shl eax, 0x4                                 # 0045662d
    mov ecx, dword ptr [eax + 0x624a70]          # 00456630
    sub ecx, dword ptr [0x58318a]                # 00456636
    mov dword ptr [ebp - local_20], ecx          # 0045663c
    movsx edx, word ptr [ebp - local_c]          # 0045663f
    shl edx, 0x4                                 # 00456643
    mov eax, dword ptr [edx + 0x624a78]          # 00456646
    sub eax, dword ptr [0x58318a]                # 0045664c
    mov dword ptr [ebp - local_18], eax          # 00456652
    movsx ecx, word ptr [ebp - local_c]          # 00456655
    shl ecx, 0x4                                 # 00456659
    mov edx, dword ptr [ecx + 0x624a6c]          # 0045665c
    sub edx, dword ptr [0x583186]                # 00456662
    mov dword ptr [ebp - local_24], edx          # 00456668
    movsx eax, word ptr [ebp - local_c]          # 0045666b
    shl eax, 0x4                                 # 0045666f
    mov ecx, dword ptr [eax + 0x624a74]          # 00456672
    sub ecx, dword ptr [0x583186]                # 00456678
    mov dword ptr [ebp - local_1c], ecx          # 0045667e
    push 0x54a168                                # 00456681
    movsx edx, word ptr [ebp - local_c]          # 00456686
    shl edx, 0x4                                 # 0045668a
    add edx, 0x624a6c                            # 0045668d
    push edx                                     # 00456693
    lea eax, [ebp - local_24]                    # 00456694
    push eax                                     # 00456697
    mov ecx, dword ptr [0x5cf665]                # 00456698
    push ecx                                     # 0045669e
    mov edx, dword ptr [0x5d15e3]                # 0045669f
    push edx                                     # 004566a5
    mov ecx, 0x5cf659                            # 004566a6
    call FUN_004c5377                            # 004566ab
L_004566b0:
    # block 0x004566b0: entered by je at 0x00456623, 1 instruction(s), ends with backward jump to 0x004565e4
    jmp.d32 L_004565e4                           # 004566b0
L_004566b5:
    # block 0x004566b5: entered by jge at 0x004565fd, 1 instruction(s), falls into the block at 0x004566be
    mov word ptr [0x624a6a], 0xffff              # 004566b5
L_004566be:
    # block 0x004566be: entered by je at 0x004565d6, 2 instruction(s), ends with forward jump to 0x004566d2
    mov word ptr [ebp - local_10], 0x0           # 004566be
    jmp.d8 L_004566d2                            # 004566c4
L_004566c6:
    # block 0x004566c6: entered by jmp at 0x00456b8c, 3 instruction(s), falls into the block at 0x004566d2
    mov ax, word ptr [ebp - local_10]            # 004566c6
    .insn 0x66, 0x05, 0x0001{:u16}               # 004566ca
    mov word ptr [ebp - local_10], ax            # 004566ce
L_004566d2:
    # block 0x004566d2: entered by jmp at 0x004566c4, 3 instruction(s), ends with jge to 0x00456b91 (forward)
    movsx ecx, word ptr [ebp - local_10]         # 004566d2
    cmp ecx, 0x3                                 # 004566d6
    jge.d32 L_00456b91                           # 004566d9
    # block 0x004566df: entered by fall-through of jge at 0x004566d9, 2 instruction(s), ends with forward jump to 0x004566f3
    mov word ptr [ebp - local_4], 0x0            # 004566df
    jmp.d8 L_004566f3                            # 004566e5
L_004566e7:
    # block 0x004566e7: entered by jmp at 0x00456b87, 3 instruction(s), falls into the block at 0x004566f3
    mov dx, word ptr [ebp - local_4]             # 004566e7
    add dx, 0x1                                  # 004566eb
    mov word ptr [ebp - local_4], dx             # 004566ef
L_004566f3:
    # block 0x004566f3: entered by jmp at 0x004566e5, 5 instruction(s), ends with jge to 0x00456b8c (forward)
    movsx eax, word ptr [ebp - local_4]          # 004566f3
    mov ecx, dword ptr [ebp - local_8]           # 004566f7
    movsx edx, word ptr [ecx + field_23]         # 004566fa
    {load} cmp eax, edx                          # 004566fe
    jge.d32 L_00456b8c                           # 00456700
    # block 0x00456706: entered by fall-through of jge at 0x00456700, 2 instruction(s), ends with forward jump to 0x0045671a
    mov word ptr [ebp - local_c], 0x0            # 00456706
    jmp.d8 L_0045671a                            # 0045670c
L_0045670e:
    # block 0x0045670e: entered by jmp at 0x00456b82, 3 instruction(s), falls into the block at 0x0045671a
    mov ax, word ptr [ebp - local_c]             # 0045670e
    .insn 0x66, 0x05, 0x0001{:u16}               # 00456712
    mov word ptr [ebp - local_c], ax             # 00456716
L_0045671a:
    # block 0x0045671a: entered by jmp at 0x0045670c, 5 instruction(s), ends with jge to 0x00456b87 (forward)
    movsx ecx, word ptr [ebp - local_c]          # 0045671a
    mov edx, dword ptr [ebp - local_8]           # 0045671e
    movsx eax, word ptr [edx + field_21]         # 00456721
    {load} cmp ecx, eax                          # 00456725
    jge.d32 L_00456b87                           # 00456727
    # block 0x0045672d: entered by fall-through of jge at 0x00456727, 9 instruction(s), ends with je to 0x00456b82 (forward)
    {load} xor ecx, ecx                          # 0045672d
    mov dword ptr [ebp - local_24], ecx          # 0045672f
    mov dword ptr [ebp - local_20], ecx          # 00456732
    mov dword ptr [ebp - local_1c], ecx          # 00456735
    mov dword ptr [ebp - local_18], ecx          # 00456738
    movsx edx, word ptr [0x624a12]               # 0045673b
    movsx eax, word ptr [ebp - local_c]          # 00456742
    {load} cmp edx, eax                          # 00456746
    je.d32 L_00456b82                            # 00456748
    # block 0x0045674e: entered by fall-through of je at 0x00456748, 9 instruction(s), ends with jne to 0x004567d3 (forward)
    movsx ecx, word ptr [ebp - local_c]          # 0045674e
    imul ecx, ecx, 0x96                          # 00456752
    mov edx, dword ptr [ebp - local_8]           # 00456758
    lea eax, [edx + ecx + field_45]              # 0045675b
    mov dword ptr [ebp - local_14], eax          # 0045675f
    mov ecx, dword ptr [ebp - local_14]          # 00456762
    movsx edx, word ptr [ecx + field_94]         # 00456765
    test edx, edx                                # 0045676c
    jne.d8 L_004567d3                            # 0045676e
    # block 0x00456770: entered by fall-through of jne at 0x0045676e, 3 instruction(s), ends with jne to 0x004567ce (forward)
    movsx eax, word ptr [ebp - local_10]         # 00456770
    cmp eax, 0x2                                 # 00456774
    jne.d8 L_004567ce                            # 00456777
    # block 0x00456779: entered by fall-through of jne at 0x00456777, 25 instruction(s), calls FUN_00454f29, FUN_004c5d4b, falls into the block at 0x004567ce
    lea ecx, [ebp - local_24]                    # 00456779
    push ecx                                     # 0045677c
    mov edx, dword ptr [ebp - local_14]          # 0045677d
    add edx, 0x80                                # 00456780
    push edx                                     # 00456786
    mov ecx, 0x6249dc                            # 00456787
    call FUN_00454f29                            # 0045678c
    push 0x54a19c                                # 00456791
    lea eax, [ebp - local_24]                    # 00456796
    push eax                                     # 00456799
    mov ecx, dword ptr [ebp - local_14]          # 0045679a
    push ecx                                     # 0045679d
    mov edx, dword ptr [0x5cf665]                # 0045679e
    push edx                                     # 004567a4
    movsx eax, word ptr [0x6249f8]               # 004567a5
    imul eax, eax, 0x4a                          # 004567ac
    mov ecx, dword ptr [eax + 0x5d1599]          # 004567af
    push ecx                                     # 004567b5
    mov ecx, 0x5cf659                            # 004567b6
    call FUN_004c5d4b                            # 004567bb
    {load} xor edx, edx                          # 004567c0
    mov dword ptr [ebp - local_24], edx          # 004567c2
    mov dword ptr [ebp - local_20], edx          # 004567c5
    mov dword ptr [ebp - local_1c], edx          # 004567c8
    mov dword ptr [ebp - local_18], edx          # 004567cb
L_004567ce:
    # block 0x004567ce: entered by jne at 0x00456777, 1 instruction(s), ends with forward jump to 0x00456b58
    jmp.d32 L_00456b58                           # 004567ce
L_004567d3:
    # block 0x004567d3: entered by jne at 0x0045676e, 6 instruction(s), ends with jne to 0x00456b58 (forward)
    mov eax, dword ptr [ebp - local_14]          # 004567d3
    movsx ecx, word ptr [eax + field_92]         # 004567d6
    sub ecx, 0x1                                 # 004567dd
    movsx edx, word ptr [ebp - local_4]          # 004567e0
    {load} cmp ecx, edx                          # 004567e4
    jne.d32 L_00456b58                           # 004567e6
    # block 0x004567ec: entered by fall-through of jne at 0x004567e6, 4 instruction(s), ends with je to 0x0045680e (forward)
    movsx eax, word ptr [ebp - local_10]         # 004567ec
    mov dword ptr [ebp - local_28], eax          # 004567f0
    cmp dword ptr [ebp - local_28], 0x0          # 004567f3
    je.d8 L_0045680e                             # 004567f7
    # block 0x004567f9: entered by fall-through of je at 0x004567f7, 2 instruction(s), ends with je to 0x0045687e (forward)
    cmp dword ptr [ebp - local_28], 0x1          # 004567f9
    je.d8 L_0045687e                             # 004567fd
    # block 0x004567ff: entered by fall-through of je at 0x004567fd, 2 instruction(s), ends with je to 0x00456aff (forward)
    cmp dword ptr [ebp - local_28], 0x2          # 004567ff
    je.d32 L_00456aff                            # 00456803
    # block 0x00456809: entered by fall-through of je at 0x00456803, 1 instruction(s), ends with forward jump to 0x00456b58
    jmp.d32 L_00456b58                           # 00456809
L_0045680e:
    # block 0x0045680e: entered by je at 0x004567f7, 6 instruction(s), ends with jns to 0x0045682e (forward)
    movsx ecx, word ptr [0x624a66]               # 0045680e
    mov edx, dword ptr [ebp - local_14]          # 00456815
    movsx eax, word ptr [edx + field_90]         # 00456818
    add eax, 0x2                                 # 0045681f
    and eax, 0x80000003                          # 00456822
    jns.d8 L_0045682e                            # 00456827
    # block 0x00456829: entered by fall-through of jns at 0x00456827, 3 instruction(s), falls into the block at 0x0045682e
    dec eax                                      # 00456829
    or eax, -0x4                                 # 0045682a
    inc eax                                      # 0045682d
L_0045682e:
    # block 0x0045682e: entered by jns at 0x00456827, 2 instruction(s), ends with jne to 0x00456879 (forward)
    {load} cmp ecx, eax                          # 0045682e
    jne.d8 L_00456879                            # 00456830
    # block 0x00456832: entered by fall-through of jne at 0x00456830, 21 instruction(s), calls FUN_00454f29, FUN_004c5d4b, falls into the block at 0x00456879
    lea ecx, [ebp - local_24]                    # 00456832
    push ecx                                     # 00456835
    mov edx, dword ptr [ebp - local_14]          # 00456836
    add edx, 0x60                                # 00456839
    push edx                                     # 0045683c
    mov ecx, 0x6249dc                            # 0045683d
    call FUN_00454f29                            # 00456842
    push 0x54a1cc                                # 00456847
    lea eax, [ebp - local_24]                    # 0045684c
    push eax                                     # 0045684f
    mov ecx, dword ptr [ebp - local_14]          # 00456850
    add ecx, 0x20                                # 00456853
    push ecx                                     # 00456856
    mov edx, dword ptr [0x5cf665]                # 00456857
    push edx                                     # 0045685d
    movsx eax, word ptr [0x6249f8]               # 0045685e
    imul eax, eax, 0x4a                          # 00456865
    mov ecx, dword ptr [eax + 0x5d1599]          # 00456868
    push ecx                                     # 0045686e
    mov ecx, 0x5cf659                            # 0045686f
    call FUN_004c5d4b                            # 00456874
L_00456879:
    # block 0x00456879: entered by jne at 0x00456830, 1 instruction(s), ends with forward jump to 0x00456b58
    jmp.d32 L_00456b58                           # 00456879
L_0045687e:
    # block 0x0045687e: entered by je at 0x004567fd, 4 instruction(s), ends with ja to 0x00456afd (forward)
    movsx edx, word ptr [0x624a66]               # 0045687e
    mov dword ptr [ebp - local_2c], edx          # 00456885
    cmp dword ptr [ebp - local_2c], 0x3          # 00456888
    ja.d32 L_00456afd                            # 0045688c
    # block 0x00456892: entered by fall-through of ja at 0x0045688c, 2 instruction(s), ends with indirect jump dword ptr [4*eax + 0x456bdf]
    mov eax, dword ptr [ebp - local_2c]          # 00456892
    jmp dword ptr [4*eax + SWTAB_00456bdf_VA]    # 00456895
L_0045689c:
    # block 0x0045689c: entered by switch case, 4 instruction(s), ends with je to 0x004568ba (forward)
    mov ecx, dword ptr [ebp - local_14]          # 0045689c
    movsx edx, word ptr [ecx + field_90]         # 0045689f
    cmp edx, 0x1                                 # 004568a6
    je.d8 L_004568ba                             # 004568a9
    # block 0x004568ab: entered by fall-through of je at 0x004568a9, 4 instruction(s), ends with jne to 0x0045691b (forward)
    mov eax, dword ptr [ebp - local_14]          # 004568ab
    movsx ecx, word ptr [eax + field_90]         # 004568ae
    cmp ecx, 0x3                                 # 004568b5
    jne.d8 L_0045691b                            # 004568b8
L_004568ba:
    # block 0x004568ba: entered by je at 0x004568a9; fall-through of jne at 0x004568b8, 27 instruction(s), calls FUN_00454f29, FUN_004c5d4b, falls into the block at 0x0045691b
    lea edx, [ebp - local_24]                    # 004568ba
    push edx                                     # 004568bd
    mov eax, dword ptr [ebp - local_14]          # 004568be
    movsx ecx, word ptr [eax + field_90]         # 004568c1
    shl ecx, 0x4                                 # 004568c8
    mov edx, dword ptr [ebp - local_14]          # 004568cb
    lea eax, [edx + ecx + field_40]              # 004568ce
    push eax                                     # 004568d2
    mov ecx, 0x6249dc                            # 004568d3
    call FUN_00454f29                            # 004568d8
    push 0x54a1f4                                # 004568dd
    lea ecx, [ebp - local_24]                    # 004568e2
    push ecx                                     # 004568e5
    mov edx, dword ptr [ebp - local_14]          # 004568e6
    movsx eax, word ptr [edx + field_90]         # 004568e9
    shl eax, 0x4                                 # 004568f0
    mov ecx, dword ptr [ebp - local_14]          # 004568f3
    {load} add ecx, eax                          # 004568f6
    push ecx                                     # 004568f8
    mov edx, dword ptr [0x5cf665]                # 004568f9
    push edx                                     # 004568ff
    movsx eax, word ptr [0x6249f8]               # 00456900
    imul eax, eax, 0x4a                          # 00456907
    mov ecx, dword ptr [eax + 0x5d1599]          # 0045690a
    push ecx                                     # 00456910
    mov ecx, 0x5cf659                            # 00456911
    call FUN_004c5d4b                            # 00456916
L_0045691b:
    # block 0x0045691b: entered by jne at 0x004568b8, 1 instruction(s), ends with forward jump to 0x00456afd
    jmp.d32 L_00456afd                           # 0045691b
L_00456920:
    # block 0x00456920: entered by switch case, 4 instruction(s), ends with jne to 0x00456977 (forward)
    mov edx, dword ptr [ebp - local_14]          # 00456920
    movsx eax, word ptr [edx + field_90]         # 00456923
    test eax, eax                                # 0045692a
    jne.d8 L_00456977                            # 0045692c
    # block 0x0045692e: entered by fall-through of jne at 0x0045692c, 22 instruction(s), calls FUN_00454f29, FUN_004c5d4b, ends with forward jump to 0x004569cd
    lea ecx, [ebp - local_24]                    # 0045692e
    push ecx                                     # 00456931
    mov edx, dword ptr [ebp - local_14]          # 00456932
    add edx, 0x70                                # 00456935
    push edx                                     # 00456938
    mov ecx, 0x6249dc                            # 00456939
    call FUN_00454f29                            # 0045693e
    push 0x54a220                                # 00456943
    lea eax, [ebp - local_24]                    # 00456948
    push eax                                     # 0045694b
    mov ecx, dword ptr [ebp - local_14]          # 0045694c
    add ecx, 0x30                                # 0045694f
    push ecx                                     # 00456952
    mov edx, dword ptr [0x5cf665]                # 00456953
    push edx                                     # 00456959
    movsx eax, word ptr [0x6249f8]               # 0045695a
    imul eax, eax, 0x4a                          # 00456961
    mov ecx, dword ptr [eax + 0x5d1599]          # 00456964
    push ecx                                     # 0045696a
    mov ecx, 0x5cf659                            # 0045696b
    call FUN_004c5d4b                            # 00456970
    jmp.d8 L_004569cd                            # 00456975
L_00456977:
    # block 0x00456977: entered by jne at 0x0045692c, 4 instruction(s), ends with jne to 0x004569cd (forward)
    mov edx, dword ptr [ebp - local_14]          # 00456977
    movsx eax, word ptr [edx + field_90]         # 0045697a
    cmp eax, 0x2                                 # 00456981
    jne.d8 L_004569cd                            # 00456984
    # block 0x00456986: entered by fall-through of jne at 0x00456984, 21 instruction(s), calls FUN_00454f29, FUN_004c5d4b, falls into the block at 0x004569cd
    lea ecx, [ebp - local_24]                    # 00456986
    push ecx                                     # 00456989
    mov edx, dword ptr [ebp - local_14]          # 0045698a
    add edx, 0x50                                # 0045698d
    push edx                                     # 00456990
    mov ecx, 0x6249dc                            # 00456991
    call FUN_00454f29                            # 00456996
    push 0x54a24c                                # 0045699b
    lea eax, [ebp - local_24]                    # 004569a0
    push eax                                     # 004569a3
    mov ecx, dword ptr [ebp - local_14]          # 004569a4
    add ecx, 0x10                                # 004569a7
    push ecx                                     # 004569aa
    mov edx, dword ptr [0x5cf665]                # 004569ab
    push edx                                     # 004569b1
    movsx eax, word ptr [0x6249f8]               # 004569b2
    imul eax, eax, 0x4a                          # 004569b9
    mov ecx, dword ptr [eax + 0x5d1599]          # 004569bc
    push ecx                                     # 004569c2
    mov ecx, 0x5cf659                            # 004569c3
    call FUN_004c5d4b                            # 004569c8
L_004569cd:
    # block 0x004569cd: entered by jmp at 0x00456975; jne at 0x00456984, 1 instruction(s), ends with forward jump to 0x00456afd
    jmp.d32 L_00456afd                           # 004569cd
L_004569d2:
    # block 0x004569d2: entered by switch case, 4 instruction(s), ends with je to 0x004569f4 (forward)
    mov edx, dword ptr [ebp - local_14]          # 004569d2
    movsx eax, word ptr [edx + field_90]         # 004569d5
    cmp eax, 0x1                                 # 004569dc
    je.d8 L_004569f4                             # 004569df
    # block 0x004569e1: entered by fall-through of je at 0x004569df, 4 instruction(s), ends with jne to 0x00456a74 (forward)
    mov ecx, dword ptr [ebp - local_14]          # 004569e1
    movsx edx, word ptr [ecx + field_90]         # 004569e4
    cmp edx, 0x3                                 # 004569eb
    jne.d32 L_00456a74                           # 004569ee
L_004569f4:
    # block 0x004569f4: entered by je at 0x004569df; fall-through of jne at 0x004569ee, 7 instruction(s), ends with jns to 0x00456a12 (forward)
    lea eax, [ebp - local_24]                    # 004569f4
    push eax                                     # 004569f7
    mov ecx, dword ptr [ebp - local_14]          # 004569f8
    movsx edx, word ptr [ecx + field_90]         # 004569fb
    add edx, 0x2                                 # 00456a02
    and edx, 0x80000003                          # 00456a05
    jns.d8 L_00456a12                            # 00456a0b
    # block 0x00456a0d: entered by fall-through of jns at 0x00456a0b, 3 instruction(s), falls into the block at 0x00456a12
    dec edx                                      # 00456a0d
    or edx, -0x4                                 # 00456a0e
    inc edx                                      # 00456a11
L_00456a12:
    # block 0x00456a12: entered by jns at 0x00456a0b, 14 instruction(s), calls FUN_00454f29, ends with jns to 0x00456a4a (forward)
    shl edx, 0x4                                 # 00456a12
    mov eax, dword ptr [ebp - local_14]          # 00456a15
    lea ecx, [eax + edx + field_40]              # 00456a18
    push ecx                                     # 00456a1c
    mov ecx, 0x6249dc                            # 00456a1d
    call FUN_00454f29                            # 00456a22
    push 0x54a278                                # 00456a27
    lea edx, [ebp - local_24]                    # 00456a2c
    push edx                                     # 00456a2f
    mov eax, dword ptr [ebp - local_14]          # 00456a30
    movsx ecx, word ptr [eax + field_90]         # 00456a33
    add ecx, 0x2                                 # 00456a3a
    and ecx, 0x80000003                          # 00456a3d
    jns.d8 L_00456a4a                            # 00456a43
    # block 0x00456a45: entered by fall-through of jns at 0x00456a43, 3 instruction(s), falls into the block at 0x00456a4a
    dec ecx                                      # 00456a45
    or ecx, -0x4                                 # 00456a46
    inc ecx                                      # 00456a49
L_00456a4a:
    # block 0x00456a4a: entered by jns at 0x00456a43, 12 instruction(s), calls FUN_004c5d4b, falls into the block at 0x00456a74
    shl ecx, 0x4                                 # 00456a4a
    mov edx, dword ptr [ebp - local_14]          # 00456a4d
    {load} add edx, ecx                          # 00456a50
    push edx                                     # 00456a52
    mov eax, dword ptr [0x5cf665]                # 00456a53
    push eax                                     # 00456a58
    movsx ecx, word ptr [0x6249f8]               # 00456a59
    imul ecx, ecx, 0x4a                          # 00456a60
    mov edx, dword ptr [ecx + 0x5d1599]          # 00456a63
    push edx                                     # 00456a69
    mov ecx, 0x5cf659                            # 00456a6a
    call FUN_004c5d4b                            # 00456a6f
L_00456a74:
    # block 0x00456a74: entered by jne at 0x004569ee, 1 instruction(s), ends with forward jump to 0x00456afd
    jmp.d32 L_00456afd                           # 00456a74
L_00456a79:
    # block 0x00456a79: entered by switch case, 4 instruction(s), ends with je to 0x00456a96 (forward)
    mov eax, dword ptr [ebp - local_14]          # 00456a79
    movsx ecx, word ptr [eax + field_90]         # 00456a7c
    test ecx, ecx                                # 00456a83
    je.d8 L_00456a96                             # 00456a85
    # block 0x00456a87: entered by fall-through of je at 0x00456a85, 4 instruction(s), ends with jne to 0x00456afd (forward)
    mov edx, dword ptr [ebp - local_14]          # 00456a87
    movsx eax, word ptr [edx + field_90]         # 00456a8a
    cmp eax, 0x2                                 # 00456a91
    jne.d8 L_00456afd                            # 00456a94
L_00456a96:
    # block 0x00456a96: entered by je at 0x00456a85; fall-through of jne at 0x00456a94, 29 instruction(s), calls FUN_00454f29, FUN_004c5d4b, falls into the block at 0x00456afd
    lea ecx, [ebp - local_24]                    # 00456a96
    push ecx                                     # 00456a99
    mov edx, dword ptr [ebp - local_14]          # 00456a9a
    movsx eax, word ptr [edx + field_90]         # 00456a9d
    add eax, 0x1                                 # 00456aa4
    shl eax, 0x4                                 # 00456aa7
    mov ecx, dword ptr [ebp - local_14]          # 00456aaa
    lea edx, [ecx + eax + field_40]              # 00456aad
    push edx                                     # 00456ab1
    mov ecx, 0x6249dc                            # 00456ab2
    call FUN_00454f29                            # 00456ab7
    push 0x54a2a4                                # 00456abc
    lea eax, [ebp - local_24]                    # 00456ac1
    push eax                                     # 00456ac4
    mov ecx, dword ptr [ebp - local_14]          # 00456ac5
    movsx edx, word ptr [ecx + field_90]         # 00456ac8
    add edx, 0x1                                 # 00456acf
    shl edx, 0x4                                 # 00456ad2
    mov eax, dword ptr [ebp - local_14]          # 00456ad5
    {load} add eax, edx                          # 00456ad8
    push eax                                     # 00456ada
    mov ecx, dword ptr [0x5cf665]                # 00456adb
    push ecx                                     # 00456ae1
    movsx edx, word ptr [0x6249f8]               # 00456ae2
    imul edx, edx, 0x4a                          # 00456ae9
    mov eax, dword ptr [edx + 0x5d1599]          # 00456aec
    push eax                                     # 00456af2
    mov ecx, 0x5cf659                            # 00456af3
    call FUN_004c5d4b                            # 00456af8
L_00456afd:
    # block 0x00456afd: entered by ja at 0x0045688c; jmp at 0x0045691b; jmp at 0x004569cd; jmp at 0x00456a74; more, 1 instruction(s), ends with forward jump to 0x00456b58
    jmp.d8 L_00456b58                            # 00456afd
L_00456aff:
    # block 0x00456aff: entered by je at 0x00456803, 5 instruction(s), ends with jne to 0x00456b58 (forward)
    movsx ecx, word ptr [0x624a66]               # 00456aff
    mov edx, dword ptr [ebp - local_14]          # 00456b06
    movsx eax, word ptr [edx + field_90]         # 00456b09
    {load} cmp ecx, eax                          # 00456b10
    jne.d8 L_00456b58                            # 00456b12
    # block 0x00456b14: entered by fall-through of jne at 0x00456b12, 20 instruction(s), calls FUN_00454f29, FUN_004c5d4b, falls into the block at 0x00456b58
    lea ecx, [ebp - local_24]                    # 00456b14
    push ecx                                     # 00456b17
    mov edx, dword ptr [ebp - local_14]          # 00456b18
    add edx, 0x40                                # 00456b1b
    push edx                                     # 00456b1e
    mov ecx, 0x6249dc                            # 00456b1f
    call FUN_00454f29                            # 00456b24
    push 0x54a2d0                                # 00456b29
    lea eax, [ebp - local_24]                    # 00456b2e
    push eax                                     # 00456b31
    mov ecx, dword ptr [ebp - local_14]          # 00456b32
    push ecx                                     # 00456b35
    mov edx, dword ptr [0x5cf665]                # 00456b36
    push edx                                     # 00456b3c
    movsx eax, word ptr [0x6249f8]               # 00456b3d
    imul eax, eax, 0x4a                          # 00456b44
    mov ecx, dword ptr [eax + 0x5d1599]          # 00456b47
    push ecx                                     # 00456b4d
    mov ecx, 0x5cf659                            # 00456b4e
    call FUN_004c5d4b                            # 00456b53
L_00456b58:
    # block 0x00456b58: entered by jmp at 0x004567ce; jne at 0x004567e6; jmp at 0x00456809; jmp at 0x00456879; more, 2 instruction(s), ends with jle to 0x00456b82 (forward)
    cmp dword ptr [ebp - local_20], 0x0          # 00456b58
    jle.d8 L_00456b82                            # 00456b5c
    # block 0x00456b5e: entered by fall-through of jle at 0x00456b5c, 11 instruction(s), falls into the block at 0x00456b82
    movsx edx, word ptr [ebp - local_c]          # 00456b5e
    shl edx, 0x4                                 # 00456b62
    add edx, 0x624a6c                            # 00456b65
    mov eax, dword ptr [ebp - local_24]          # 00456b6b
    mov dword ptr [edx], eax                     # 00456b6e
    mov ecx, dword ptr [ebp - local_20]          # 00456b70
    mov dword ptr [edx + field_4], ecx           # 00456b73
    mov eax, dword ptr [ebp - local_1c]          # 00456b76
    mov dword ptr [edx + field_8], eax           # 00456b79
    mov ecx, dword ptr [ebp - local_18]          # 00456b7c
    mov dword ptr [edx + field_c], ecx           # 00456b7f
L_00456b82:
    # block 0x00456b82: entered by je at 0x00456748; jle at 0x00456b5c, 1 instruction(s), ends with backward jump to 0x0045670e
    jmp.d32 L_0045670e                           # 00456b82
L_00456b87:
    # block 0x00456b87: entered by jge at 0x00456727, 1 instruction(s), ends with backward jump to 0x004566e7
    jmp.d32 L_004566e7                           # 00456b87
L_00456b8c:
    # block 0x00456b8c: entered by jge at 0x00456700, 1 instruction(s), ends with backward jump to 0x004566c6
    jmp.d32 L_004566c6                           # 00456b8c
L_00456b91:
    # block 0x00456b91: entered by jge at 0x004566d9, 2 instruction(s), ends with je to 0x00456bdb (forward)
    cmp dword ptr [0x624a06], 0x0                # 00456b91
    je.d8 L_00456bdb                             # 00456b98
    # block 0x00456b9a: entered by fall-through of je at 0x00456b98, 15 instruction(s), calls FUN_004c5d4b, falls into the block at 0x00456bdb
    push 0x54a2f8                                # 00456b9a
    push 0x624a46                                # 00456b9f
    movsx edx, word ptr [0x624a12]               # 00456ba4
    imul edx, edx, 0x96                          # 00456bab
    mov eax, dword ptr [ebp - local_8]           # 00456bb1
    lea ecx, [eax + edx + field_45]              # 00456bb4
    push ecx                                     # 00456bb8
    mov edx, dword ptr [0x5cf665]                # 00456bb9
    push edx                                     # 00456bbf
    movsx eax, word ptr [0x6249f8]               # 00456bc0
    imul eax, eax, 0x4a                          # 00456bc7
    mov ecx, dword ptr [eax + 0x5d1599]          # 00456bca
    push ecx                                     # 00456bd0
    mov ecx, 0x5cf659                            # 00456bd1
    call FUN_004c5d4b                            # 00456bd6
L_00456bdb:
    # block 0x00456bdb: entered by je at 0x00456523; je at 0x00456b98, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00456bdb
    pop ebp                                      # 00456bdd
    ret                                          # 00456bde

# --- data items (not part of the function) -------------------------
.org 0x00456bdf - 0x401000
SWTAB_00456bdf:  # 4 case address(es)
    .long L_0045689c - .text + 0x401000
    .long L_00456920 - .text + 0x401000
    .long L_004569d2 - .text + 0x401000
    .long L_00456a79 - .text + 0x401000
.org 0x00456bef - 0x401000
PAD_00456bef:  # 1 byte(s) of int3 padding
    .fill 1, 1, 0xcc
.set SWTAB_00456bdf_VA, SWTAB_00456bdf - .text + 0x401000

