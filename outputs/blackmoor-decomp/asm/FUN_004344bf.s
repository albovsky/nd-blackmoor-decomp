# FUN_004344bf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004344bf
# extent:       0x004344bf-0x00434630 (369 code bytes)
# span:         0x004344bf-0x00434630 (code 369, tables 0, padding 0)
# sha256:       170621f02b872e6595467b0abfd42155f691430808b69866851fdb2464ea40d9
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
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
.equ local_10, 0x10  # [ebp - 0x10]
.equ local_14, 0x14  # [ebp - 0x14]
.equ local_18, 0x18  # [ebp - 0x18]
.equ local_19, 0x19  # [ebp - 0x19]
.equ local_1a, 0x1a  # [ebp - 0x1a]
.equ local_20, 0x20  # [ebp - 0x20]
.equ local_24, 0x24  # [ebp - 0x24]
.equ arg_8, 0x8  # [ebp + 0x8]

# --- external targets -----------------------------------------------
.set FUN_004347b8, .text + (0x004347b8 - 0x401000)
.set FUN_00434814, .text + (0x00434814 - 0x401000)

.org 0x004344bf - 0x401000
.globl FUN_004344bf
FUN_004344bf:
    # block 0x004344bf: <unfilled>
    push ebp                                     # 004344bf
    {load} mov ebp, esp                          # 004344c0
    sub esp, 0x24                                # 004344c2
    push esi                                     # 004344c5
    push edi                                     # 004344c6
    mov dword ptr [ebp - local_10], ecx          # 004344c7
    mov dword ptr [ebp - local_8], 0x0           # 004344ca
    jmp.d8 L_004344dc                            # 004344d1
L_004344d3:
    # block 0x004344d3: <unfilled>
    mov eax, dword ptr [ebp - local_8]           # 004344d3
    add eax, 0x1                                 # 004344d6
    mov dword ptr [ebp - local_8], eax           # 004344d9
L_004344dc:
    # block 0x004344dc: <unfilled>
    cmp dword ptr [ebp - local_8], 0x3e8         # 004344dc
    jge.d8 L_004344f8                            # 004344e3
    # block 0x004344e5: <unfilled>
    mov ecx, dword ptr [ebp - local_8]           # 004344e5
    mov edx, dword ptr [ebp - local_10]          # 004344e8
    mov dword ptr [edx + 4*ecx + 0x4fc4], 0x0    # 004344eb
    jmp.d8 L_004344d3                            # 004344f6
L_004344f8:
    # block 0x004344f8: <unfilled>
    mov dword ptr [ebp - local_8], 0x0           # 004344f8
    jmp.d8 L_0043450a                            # 004344ff
L_00434501:
    # block 0x00434501: <unfilled>
    mov eax, dword ptr [ebp - local_8]           # 00434501
    add eax, 0x1                                 # 00434504
    mov dword ptr [ebp - local_8], eax           # 00434507
L_0043450a:
    # block 0x0043450a: <unfilled>
    mov ecx, dword ptr [ebp - local_10]          # 0043450a
    mov edx, dword ptr [ebp - local_8]           # 0043450d
    cmp edx, dword ptr [ecx + 0x5f68]            # 00434510
    jge.d32 L_00434626                           # 00434516
    # block 0x0043451c: <unfilled>
    mov eax, dword ptr [ebp - local_8]           # 0043451c
    mov ecx, dword ptr [ebp - local_10]          # 0043451f
    mov edx, dword ptr [ecx + 4*eax + 0x20e4]    # 00434522
    mov dword ptr [ebp - local_4], edx           # 00434529
    mov eax, dword ptr [ebp - local_4]           # 0043452c
    push eax                                     # 0043452f
    mov ecx, dword ptr [ebp - local_10]          # 00434530
    call FUN_00434814                            # 00434533
    mov dword ptr [ebp - local_c], eax           # 00434538
    mov ecx, dword ptr [ebp + arg_8]             # 0043453b
    mov dword ptr [ebp - local_14], ecx          # 0043453e
    mov edx, dword ptr [ebp - local_c]           # 00434541
    mov dword ptr [ebp - local_18], edx          # 00434544
L_00434547:
    # block 0x00434547: <unfilled>
    mov eax, dword ptr [ebp - local_18]          # 00434547
    mov cl, byte ptr [eax]                       # 0043454a
    mov byte ptr [ebp - local_19], cl            # 0043454c
    mov edx, dword ptr [ebp - local_14]          # 0043454f
    cmp cl, byte ptr [edx]                       # 00434552
    jne.d8 L_00434584                            # 00434554
    # block 0x00434556: <unfilled>
    cmp byte ptr [ebp - local_19], 0x0           # 00434556
    je.d8 L_0043457b                             # 0043455a
    # block 0x0043455c: <unfilled>
    mov eax, dword ptr [ebp - local_18]          # 0043455c
    mov cl, byte ptr [eax + 0x1]                 # 0043455f
    mov byte ptr [ebp - local_1a], cl            # 00434562
    mov edx, dword ptr [ebp - local_14]          # 00434565
    cmp cl, byte ptr [edx + 0x1]                 # 00434568
    jne.d8 L_00434584                            # 0043456b
    # block 0x0043456d: <unfilled>
    add dword ptr [ebp - local_18], 0x2          # 0043456d
    add dword ptr [ebp - local_14], 0x2          # 00434571
    cmp byte ptr [ebp - local_1a], 0x0           # 00434575
    jne.d8 L_00434547                            # 00434579
L_0043457b:
    # block 0x0043457b: <unfilled>
    mov dword ptr [ebp - local_20], 0x0          # 0043457b
    jmp.d8 L_0043458c                            # 00434582
L_00434584:
    # block 0x00434584: <unfilled>
    {load} sbb eax, eax                          # 00434584
    sbb eax, -0x1                                # 00434586
    mov dword ptr [ebp - local_20], eax          # 00434589
L_0043458c:
    # block 0x0043458c: <unfilled>
    mov ecx, dword ptr [ebp - local_20]          # 0043458c
    mov dword ptr [ebp - local_24], ecx          # 0043458f
    cmp dword ptr [ebp - local_24], 0x0          # 00434592
    jne.d32 L_00434621                           # 00434596
    # block 0x0043459c: <unfilled>
    mov edx, dword ptr [ebp - local_8]           # 0043459c
    mov eax, dword ptr [ebp - local_10]          # 0043459f
    cmp dword ptr [eax + 4*edx + 0x4fc4], 0x1    # 004345a2
    je.d8 L_00434621                             # 004345aa
    # block 0x004345ac: <unfilled>
    mov ecx, dword ptr [ebp - local_8]           # 004345ac
    mov edx, dword ptr [ebp - local_10]          # 004345af
    mov dword ptr [edx + 4*ecx + 0x4fc4], 0x1    # 004345b2
    mov eax, dword ptr [ebp - local_4]           # 004345bd
    add eax, 0x4                                 # 004345c0
    mov dword ptr [ebp - local_4], eax           # 004345c3
    mov ecx, dword ptr [ebp - local_4]           # 004345c6
    push ecx                                     # 004345c9
    mov ecx, dword ptr [ebp - local_10]          # 004345ca
    call FUN_004347b8                            # 004345cd
    mov edx, dword ptr [ebp - local_10]          # 004345d2
    mov dword ptr [edx + 0x112c], eax            # 004345d5
    mov eax, dword ptr [ebp - local_4]           # 004345db
    add eax, 0x4                                 # 004345de
    mov dword ptr [ebp - local_4], eax           # 004345e1
    mov ecx, dword ptr [ebp - local_10]          # 004345e4
    mov edx, dword ptr [ebp - local_4]           # 004345e7
    mov dword ptr [ecx + 0x1120], edx            # 004345ea
    mov edi, dword ptr [ebp - local_c]           # 004345f0
    mov eax, dword ptr [ebp - local_10]          # 004345f3
    add eax, 0x1130                              # 004345f6
    {load} mov edx, eax                          # 004345fb
    or ecx, -0x1                                 # 004345fd
    {load} xor eax, eax                          # 00434600
    repne scasb al, byte ptr es:[edi]            # 00434602
    not ecx                                      # 00434604
    {load} sub edi, ecx                          # 00434606
    {load} mov esi, edi                          # 00434608
    {load} mov eax, ecx                          # 0043460a
    {load} mov edi, edx                          # 0043460c
    shr ecx, 0x2                                 # 0043460e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00434611
    {load} mov ecx, eax                          # 00434613
    and ecx, 0x3                                 # 00434615
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00434618
    mov eax, 0x1                                 # 0043461a
    jmp.d8 L_00434628                            # 0043461f
L_00434621:
    # block 0x00434621: <unfilled>
    jmp.d32 L_00434501                           # 00434621
L_00434626:
    # block 0x00434626: <unfilled>
    {load} xor eax, eax                          # 00434626
L_00434628:
    # block 0x00434628: <unfilled>
    pop edi                                      # 00434628
    pop esi                                      # 00434629
    {load} mov esp, ebp                          # 0043462a
    pop ebp                                      # 0043462c
    ret 0x4                                      # 0043462d
