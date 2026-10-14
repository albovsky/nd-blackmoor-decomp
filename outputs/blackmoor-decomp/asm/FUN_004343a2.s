# FUN_004343a2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004343a2
# extent:       0x004343a2-0x004344bf (285 code bytes)
# span:         0x004343a2-0x004344bf (code 285, tables 0, padding 0)
# sha256:       42bc2851f2cbbfc26f27ab7df384e93cdea9de4afed171578553f362fd12366c
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

.org 0x004343a2 - 0x401000
.globl FUN_004343a2
FUN_004343a2:
    # block 0x004343a2: <unfilled>
    push ebp                                     # 004343a2
    {load} mov ebp, esp                          # 004343a3
    sub esp, 0x24                                # 004343a5
    push esi                                     # 004343a8
    push edi                                     # 004343a9
    mov dword ptr [ebp - local_10], ecx          # 004343aa
    mov dword ptr [ebp - local_8], 0x0           # 004343ad
    jmp.d8 L_004343bf                            # 004343b4
L_004343b6:
    # block 0x004343b6: <unfilled>
    mov eax, dword ptr [ebp - local_8]           # 004343b6
    add eax, 0x1                                 # 004343b9
    mov dword ptr [ebp - local_8], eax           # 004343bc
L_004343bf:
    # block 0x004343bf: <unfilled>
    mov ecx, dword ptr [ebp - local_10]          # 004343bf
    mov edx, dword ptr [ebp - local_8]           # 004343c2
    cmp edx, dword ptr [ecx + 0x5f68]            # 004343c5
    jge.d32 L_004344b5                           # 004343cb
    # block 0x004343d1: <unfilled>
    mov eax, dword ptr [ebp - local_8]           # 004343d1
    mov ecx, dword ptr [ebp - local_10]          # 004343d4
    mov edx, dword ptr [ecx + 4*eax + 0x20e4]    # 004343d7
    mov dword ptr [ebp - local_4], edx           # 004343de
    mov eax, dword ptr [ebp - local_4]           # 004343e1
    push eax                                     # 004343e4
    mov ecx, dword ptr [ebp - local_10]          # 004343e5
    call FUN_00434814                            # 004343e8
    mov dword ptr [ebp - local_c], eax           # 004343ed
    mov ecx, dword ptr [ebp + arg_8]             # 004343f0
    mov dword ptr [ebp - local_14], ecx          # 004343f3
    mov edx, dword ptr [ebp - local_c]           # 004343f6
    mov dword ptr [ebp - local_18], edx          # 004343f9
L_004343fc:
    # block 0x004343fc: <unfilled>
    mov eax, dword ptr [ebp - local_18]          # 004343fc
    mov cl, byte ptr [eax]                       # 004343ff
    mov byte ptr [ebp - local_19], cl            # 00434401
    mov edx, dword ptr [ebp - local_14]          # 00434404
    cmp cl, byte ptr [edx]                       # 00434407
    jne.d8 L_00434439                            # 00434409
    # block 0x0043440b: <unfilled>
    cmp byte ptr [ebp - local_19], 0x0           # 0043440b
    je.d8 L_00434430                             # 0043440f
    # block 0x00434411: <unfilled>
    mov eax, dword ptr [ebp - local_18]          # 00434411
    mov cl, byte ptr [eax + 0x1]                 # 00434414
    mov byte ptr [ebp - local_1a], cl            # 00434417
    mov edx, dword ptr [ebp - local_14]          # 0043441a
    cmp cl, byte ptr [edx + 0x1]                 # 0043441d
    jne.d8 L_00434439                            # 00434420
    # block 0x00434422: <unfilled>
    add dword ptr [ebp - local_18], 0x2          # 00434422
    add dword ptr [ebp - local_14], 0x2          # 00434426
    cmp byte ptr [ebp - local_1a], 0x0           # 0043442a
    jne.d8 L_004343fc                            # 0043442e
L_00434430:
    # block 0x00434430: <unfilled>
    mov dword ptr [ebp - local_20], 0x0          # 00434430
    jmp.d8 L_00434441                            # 00434437
L_00434439:
    # block 0x00434439: <unfilled>
    {load} sbb eax, eax                          # 00434439
    sbb eax, -0x1                                # 0043443b
    mov dword ptr [ebp - local_20], eax          # 0043443e
L_00434441:
    # block 0x00434441: <unfilled>
    mov ecx, dword ptr [ebp - local_20]          # 00434441
    mov dword ptr [ebp - local_24], ecx          # 00434444
    cmp dword ptr [ebp - local_24], 0x0          # 00434447
    jne.d8 L_004344b0                            # 0043444b
    # block 0x0043444d: <unfilled>
    mov edx, dword ptr [ebp - local_4]           # 0043444d
    add edx, 0x4                                 # 00434450
    mov dword ptr [ebp - local_4], edx           # 00434453
    mov eax, dword ptr [ebp - local_4]           # 00434456
    push eax                                     # 00434459
    mov ecx, dword ptr [ebp - local_10]          # 0043445a
    call FUN_004347b8                            # 0043445d
    mov ecx, dword ptr [ebp - local_10]          # 00434462
    mov dword ptr [ecx + 0x112c], eax            # 00434465
    mov edx, dword ptr [ebp - local_4]           # 0043446b
    add edx, 0x4                                 # 0043446e
    mov dword ptr [ebp - local_4], edx           # 00434471
    mov eax, dword ptr [ebp - local_10]          # 00434474
    mov ecx, dword ptr [ebp - local_4]           # 00434477
    mov dword ptr [eax + 0x1120], ecx            # 0043447a
    mov edi, dword ptr [ebp - local_c]           # 00434480
    mov edx, dword ptr [ebp - local_10]          # 00434483
    add edx, 0x1130                              # 00434486
    or ecx, -0x1                                 # 0043448c
    {load} xor eax, eax                          # 0043448f
    repne scasb al, byte ptr es:[edi]            # 00434491
    not ecx                                      # 00434493
    {load} sub edi, ecx                          # 00434495
    {load} mov esi, edi                          # 00434497
    {load} mov eax, ecx                          # 00434499
    {load} mov edi, edx                          # 0043449b
    shr ecx, 0x2                                 # 0043449d
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004344a0
    {load} mov ecx, eax                          # 004344a2
    and ecx, 0x3                                 # 004344a4
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004344a7
    mov eax, 0x1                                 # 004344a9
    jmp.d8 L_004344b7                            # 004344ae
L_004344b0:
    # block 0x004344b0: <unfilled>
    jmp.d32 L_004343b6                           # 004344b0
L_004344b5:
    # block 0x004344b5: <unfilled>
    {load} xor eax, eax                          # 004344b5
L_004344b7:
    # block 0x004344b7: <unfilled>
    pop edi                                      # 004344b7
    pop esi                                      # 004344b8
    {load} mov esp, ebp                          # 004344b9
    pop ebp                                      # 004344bb
    ret 0x4                                      # 004344bc
