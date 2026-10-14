# FUN_0048945b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048945b
# extent:       0x0048945b-0x004895cc (369 code bytes)
# span:         0x0048945b-0x004895cc (code 369, tables 0, padding 0)
# sha256:       799385eaa2201dd5e8137d0e30f1e96fe0d6a0cbaf4390fe3966bf987464f79a
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# name:         <unfilled>
# arguments:    <unfilled>
# locals:       <unfilled>
# fields:       <unfilled>
# callees:      <unfilled>
# track-n:      <unfilled>
# unverified:   <unfilled>
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # [ebp - 0x4]
.equ local_8, 0x8  # [ebp - 0x8]
.equ arg_8, 0x8  # [ebp + 0x8]
.equ arg_c, 0xc  # [ebp + 0xc]

# --- external targets -----------------------------------------------

.org 0x0048945b - 0x401000
.globl FUN_0048945b
FUN_0048945b:
    # block 0x0048945b: <unfilled>
    push ebp                                     # 0048945b
    {load} mov ebp, esp                          # 0048945c
    sub esp, 0x8                                 # 0048945e
    push esi                                     # 00489461
    push edi                                     # 00489462
    mov dword ptr [ebp - local_8], ecx           # 00489463
    mov eax, dword ptr [ebp - local_8]           # 00489466
    mov ecx, dword ptr [ebp + arg_8]             # 00489469
    mov dword ptr [eax + 0x20], ecx              # 0048946c
    mov edx, dword ptr [ebp - local_8]           # 0048946f
    mov eax, dword ptr [edx + 0x20]              # 00489472
    mov word ptr [eax + 0x25], 0x2               # 00489475
    mov ecx, dword ptr [ebp - local_8]           # 0048947b
    mov edx, dword ptr [ecx + 0x20]              # 0048947e
    mov word ptr [edx + 0x3d], 0x270f            # 00489481
    mov eax, dword ptr [ebp - local_8]           # 00489487
    mov ecx, dword ptr [eax + 0x20]              # 0048948a
    mov word ptr [ecx + 0x39], 0xffff            # 0048948d
    mov edx, dword ptr [ebp - local_8]           # 00489493
    mov eax, dword ptr [edx + 0x20]              # 00489496
    mov word ptr [eax + 0x21], 0x2               # 00489499
    mov ecx, dword ptr [ebp - local_8]           # 0048949f
    mov edx, dword ptr [ecx + 0x20]              # 004894a2
    mov word ptr [edx + 0x29], 0x1               # 004894a5
    mov word ptr [ebp - local_4], 0x0            # 004894ab
    jmp.d8 L_004894bf                            # 004894b1
L_004894b3:
    # block 0x004894b3: <unfilled>
    mov ax, word ptr [ebp - local_4]             # 004894b3
    .insn 0x66, 0x05, 0x0001{:u16}               # 004894b7
    mov word ptr [ebp - local_4], ax             # 004894bb
L_004894bf:
    # block 0x004894bf: <unfilled>
    movsx ecx, word ptr [ebp - local_4]          # 004894bf
    cmp ecx, 0xa                                 # 004894c3
    jge.d8 L_004894db                            # 004894c6
    # block 0x004894c8: <unfilled>
    mov edx, dword ptr [ebp - local_8]           # 004894c8
    mov eax, dword ptr [edx + 0x20]              # 004894cb
    movsx ecx, word ptr [ebp - local_4]          # 004894ce
    mov word ptr [eax + 4*ecx + 0x51], 0xffff    # 004894d2
    jmp.d8 L_004894b3                            # 004894d9
L_004894db:
    # block 0x004894db: <unfilled>
    mov edi, 0x54e058                            # 004894db
    mov edx, dword ptr [ebp - local_8]           # 004894e0
    mov eax, dword ptr [edx + 0x20]              # 004894e3
    add eax, 0x79                                # 004894e6
    {load} mov edx, eax                          # 004894e9
    or ecx, -0x1                                 # 004894eb
    {load} xor eax, eax                          # 004894ee
    repne scasb al, byte ptr es:[edi]            # 004894f0
    not ecx                                      # 004894f2
    {load} sub edi, ecx                          # 004894f4
    {load} mov esi, edi                          # 004894f6
    {load} mov eax, ecx                          # 004894f8
    {load} mov edi, edx                          # 004894fa
    shr ecx, 0x2                                 # 004894fc
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004894ff
    {load} mov ecx, eax                          # 00489501
    and ecx, 0x3                                 # 00489503
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00489506
    mov ecx, dword ptr [ebp - local_8]           # 00489508
    mov edx, dword ptr [ecx + 0x20]              # 0048950b
    mov word ptr [edx + 0x43], 0x1               # 0048950e
    mov eax, dword ptr [ebp - local_8]           # 00489514
    mov ecx, dword ptr [eax + 0x20]              # 00489517
    mov dword ptr [ecx + 0x4d], 0x1              # 0048951a
    mov edx, dword ptr [ebp - local_8]           # 00489521
    mov eax, dword ptr [edx + 0x20]              # 00489524
    mov word ptr [eax + 0x2b], 0x1               # 00489527
    mov ecx, dword ptr [ebp - local_8]           # 0048952d
    mov edx, dword ptr [ecx + 0x20]              # 00489530
    mov word ptr [edx + 0xaa], 0x1               # 00489533
    mov eax, dword ptr [ebp + arg_8]             # 0048953c
    mov word ptr [eax + 0x6ec], 0x0              # 0048953f
    mov ecx, dword ptr [ebp + arg_8]             # 00489548
    mov word ptr [ecx + 0x6ee], 0x0              # 0048954b
    mov edx, dword ptr [ebp + arg_8]             # 00489554
    mov word ptr [edx + 0x6f0], 0x2              # 00489557
    mov eax, dword ptr [ebp + arg_8]             # 00489560
    add eax, 0x702                               # 00489563
    mov ecx, dword ptr [ebp + arg_c]             # 00489568
    mov edx, dword ptr [ecx]                     # 0048956b
    mov dword ptr [eax], edx                     # 0048956d
    mov edx, dword ptr [ecx + 0x4]               # 0048956f
    mov dword ptr [eax + 0x4], edx               # 00489572
    mov edx, dword ptr [ecx + 0x8]               # 00489575
    mov dword ptr [eax + 0x8], edx               # 00489578
    mov ecx, dword ptr [ecx + 0xc]               # 0048957b
    mov dword ptr [eax + 0xc], ecx               # 0048957e
    mov edx, dword ptr [ebp + arg_8]             # 00489581
    mov dword ptr [edx + 0x6f6], 0x0             # 00489584
    mov eax, dword ptr [ebp + arg_8]             # 0048958e
    mov dword ptr [eax + 0x6f2], 0x0             # 00489591
    mov ecx, dword ptr [ebp + arg_c]             # 0048959b
    mov edx, dword ptr [ebp + arg_c]             # 0048959e
    mov eax, dword ptr [ecx + 0xc]               # 004895a1
    sub eax, dword ptr [edx + 0x4]               # 004895a4
    mov ecx, dword ptr [ebp + arg_8]             # 004895a7
    mov dword ptr [ecx + 0x6fe], eax             # 004895aa
    mov edx, dword ptr [ebp + arg_c]             # 004895b0
    mov eax, dword ptr [ebp + arg_c]             # 004895b3
    mov ecx, dword ptr [edx + 0x8]               # 004895b6
    sub ecx, dword ptr [eax]                     # 004895b9
    mov edx, dword ptr [ebp + arg_8]             # 004895bb
    mov dword ptr [edx + 0x6fa], ecx             # 004895be
    pop edi                                      # 004895c4
    pop esi                                      # 004895c5
    {load} mov esp, ebp                          # 004895c6
    pop ebp                                      # 004895c8
    ret 0x8                                      # 004895c9
