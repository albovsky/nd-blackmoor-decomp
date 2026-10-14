# FUN_004895cc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004895cc
# extent:       0x004895cc-0x00489722 (342 code bytes)
# span:         0x004895cc-0x00489722 (code 342, tables 0, padding 0)
# sha256:       717d0de9f08e537cf3833bc5664716f6df3452ed642f638453e4e7567a990410
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
.equ local_c, 0xc  # [ebp - 0xc]
.equ arg_8, 0x8  # [ebp + 0x8]
.equ arg_c, 0xc  # [ebp + 0xc]
.equ arg_10, 0x10  # [ebp + 0x10]

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0048945b, .text + (0x0048945b - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004895cc - 0x401000
.globl FUN_004895cc
FUN_004895cc:
    # block 0x004895cc: <unfilled>
    push ebp                                     # 004895cc
    {load} mov ebp, esp                          # 004895cd
    sub esp, 0xc                                 # 004895cf
    push esi                                     # 004895d2
    push edi                                     # 004895d3
    mov dword ptr [ebp - local_c], ecx           # 004895d4
    push 0xaba                                   # 004895d7
    call FUN_0051dc43                            # 004895dc
    add esp, 0x4                                 # 004895e1
    mov dword ptr [ebp - local_8], eax           # 004895e4
    mov eax, dword ptr [ebp + arg_8]             # 004895e7
    mov ecx, dword ptr [ebp - local_8]           # 004895ea
    mov dword ptr [eax], ecx                     # 004895ed
    cmp dword ptr [ebp - local_8], 0x0           # 004895ef
    jne.d8 L_00489633                            # 004895f3
    # block 0x004895f5: <unfilled>
    movsx edx, word ptr [0x5c39e3]               # 004895f5
    push edx                                     # 004895fc
    mov eax, dword ptr [0x5bb57b]                # 004895fd
    push eax                                     # 00489602
    push 0x54e064                                # 00489603
    push 0x63888b                                # 00489608
    call FUN_0050ca3e                            # 0048960d
    add esp, 0x10                                # 00489612
    push 0x63888b                                # 00489615
    push 0x54e090                                # 0048961a
    mov ecx, 0x583979                            # 0048961f
    call FUN_0042639d                            # 00489624
    mov ecx, 0x5cf659                            # 00489629
    call FUN_004c97b4                            # 0048962e
L_00489633:
    # block 0x00489633: <unfilled>
    mov ecx, 0x2ae                               # 00489633
    {load} xor eax, eax                          # 00489638
    mov edx, dword ptr [ebp + arg_8]             # 0048963a
    mov edi, dword ptr [edx]                     # 0048963d
    rep stosd dword ptr es:[edi], eax            # 0048963f
    stosw word ptr es:[edi], ax                  # 00489641
    mov eax, dword ptr [ebp - local_c]           # 00489643
    mov ecx, dword ptr [ebp + arg_8]             # 00489646
    mov edx, dword ptr [ecx]                     # 00489649
    mov dword ptr [eax + 0x1c], edx              # 0048964b
    mov eax, dword ptr [ebp - local_c]           # 0048964e
    mov ecx, dword ptr [ebp - local_c]           # 00489651
    mov edx, dword ptr [ecx + 0x1c]              # 00489654
    mov dword ptr [eax + 0x20], edx              # 00489657
    mov eax, dword ptr [ebp + arg_c]             # 0048965a
    mov ecx, dword ptr [eax]                     # 0048965d
    mov dword ptr [ebp - local_4], ecx           # 0048965f
    mov edx, dword ptr [ebp - local_4]           # 00489662
    add edx, 0x25                                # 00489665
    push edx                                     # 00489668
    mov eax, dword ptr [ebp - local_c]           # 00489669
    mov ecx, dword ptr [eax + 0x1c]              # 0048966c
    push ecx                                     # 0048966f
    mov ecx, dword ptr [ebp - local_c]           # 00489670
    call FUN_0048945b                            # 00489673
    mov edi, dword ptr [ebp - local_4]           # 00489678
    mov edx, dword ptr [ebp - local_c]           # 0048967b
    mov edx, dword ptr [edx + 0x20]              # 0048967e
    or ecx, -0x1                                 # 00489681
    {load} xor eax, eax                          # 00489684
    repne scasb al, byte ptr es:[edi]            # 00489686
    not ecx                                      # 00489688
    {load} sub edi, ecx                          # 0048968a
    {load} mov esi, edi                          # 0048968c
    {load} mov eax, ecx                          # 0048968e
    {load} mov edi, edx                          # 00489690
    shr ecx, 0x2                                 # 00489692
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00489695
    {load} mov ecx, eax                          # 00489697
    and ecx, 0x3                                 # 00489699
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0048969c
    mov ecx, dword ptr [ebp - local_c]           # 0048969e
    mov edx, dword ptr [ecx + 0x20]              # 004896a1
    mov eax, dword ptr [ebp - local_4]           # 004896a4
    mov cx, word ptr [eax + 0x21]                # 004896a7
    mov word ptr [edx + 0x23], cx                # 004896ab
    mov edx, dword ptr [ebp - local_c]           # 004896af
    mov eax, dword ptr [edx + 0x20]              # 004896b2
    mov ecx, dword ptr [ebp - local_4]           # 004896b5
    mov dx, word ptr [ecx + 0x23]                # 004896b8
    mov word ptr [eax + 0x27], dx                # 004896bc
    mov eax, dword ptr [ebp - local_4]           # 004896c0
    add eax, 0x35                                # 004896c3
    mov ecx, dword ptr [ebp - local_c]           # 004896c6
    mov edx, dword ptr [ecx + 0x1c]              # 004896c9
    add edx, 0xac                                # 004896cc
    mov ecx, dword ptr [eax]                     # 004896d2
    mov dword ptr [edx], ecx                     # 004896d4
    mov ecx, dword ptr [eax + 0x4]               # 004896d6
    mov dword ptr [edx + 0x4], ecx               # 004896d9
    mov ecx, dword ptr [eax + 0x8]               # 004896dc
    mov dword ptr [edx + 0x8], ecx               # 004896df
    mov eax, dword ptr [eax + 0xc]               # 004896e2
    mov dword ptr [edx + 0xc], eax               # 004896e5
    mov ecx, dword ptr [ebp + arg_c]             # 004896e8
    mov edx, dword ptr [ecx]                     # 004896eb
    add edx, 0x45                                # 004896ed
    mov eax, dword ptr [ebp + arg_c]             # 004896f0
    mov dword ptr [eax], edx                     # 004896f3
    mov ecx, dword ptr [ebp + arg_10]            # 004896f5
    mov edx, dword ptr [ecx]                     # 004896f8
    add edx, 0x45                                # 004896fa
    mov eax, dword ptr [ebp + arg_10]            # 004896fd
    mov dword ptr [eax], edx                     # 00489700
    movsx ecx, word ptr [0x63a4cd]               # 00489702
    test ecx, ecx                                # 00489709
    je.d8 L_0048971a                             # 0048970b
    # block 0x0048970d: <unfilled>
    push 0x54e0ac                                # 0048970d
    call FUN_0044a2b7                            # 00489712
    add esp, 0x4                                 # 00489717
L_0048971a:
    # block 0x0048971a: <unfilled>
    pop edi                                      # 0048971a
    pop esi                                      # 0048971b
    {load} mov esp, ebp                          # 0048971c
    pop ebp                                      # 0048971e
    ret 0xc                                      # 0048971f
