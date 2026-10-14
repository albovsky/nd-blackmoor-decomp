# FUN_0041b6e2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041b6e2
# extent:       0x0041b6e2-0x0041b925 (579 code bytes)
# span:         0x0041b6e2-0x0041b925 (code 579, tables 0, padding 0)
# sha256:       8bbf62784b5ec05fb5d4fb11ea2b1170aa6f7777124604f1b9d03c0f7b87b079
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
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
.equ local_1c, 0x1c  # [ebp - 0x1c]
.equ local_20, 0x20  # [ebp - 0x20]
.equ local_24, 0x24  # [ebp - 0x24]
.equ local_28, 0x28  # [ebp - 0x28]
.equ local_2c, 0x2c  # [ebp - 0x2c]
.equ local_30, 0x30  # [ebp - 0x30]
.equ local_34, 0x34  # [ebp - 0x34]
.equ arg_8, 0x8  # [ebp + 0x8]
.equ arg_c, 0xc  # [ebp + 0xc]
.equ arg_10, 0x10  # [ebp + 0x10]
.equ arg_14, 0x14  # [ebp + 0x14]

# --- external targets -----------------------------------------------

.org 0x0041b6e2 - 0x401000
.globl FUN_0041b6e2
FUN_0041b6e2:
    # block 0x0041b6e2: <unfilled>
    push ebp                                     # 0041b6e2
    {load} mov ebp, esp                          # 0041b6e3
    sub esp, 0x34                                # 0041b6e5
    push edi                                     # 0041b6e8
    mov dword ptr [ebp - local_34], ecx          # 0041b6e9
    mov byte ptr [ebp - local_10], 0x0           # 0041b6ec
    mov dword ptr [ebp + arg_14], 0x0            # 0041b6f0
    mov dword ptr [ebp - local_1c], 0xffffffff   # 0041b6f7
    mov dword ptr [ebp - local_14], 0x56f354     # 0041b6fe
    mov dword ptr [ebp - local_2c], 0x1000       # 0041b705
    mov dword ptr [ebp - local_c], 0x12          # 0041b70c
    mov dword ptr [ebp - local_18], 0x2          # 0041b713
    mov ecx, dword ptr [ebp - local_2c]          # 0041b71a
    sub ecx, dword ptr [ebp - local_c]           # 0041b71d
    mov eax, 0x20202020                          # 0041b720
    mov edi, dword ptr [ebp - local_14]          # 0041b725
    {load} mov edx, ecx                          # 0041b728
    shr ecx, 0x2                                 # 0041b72a
    rep stosd dword ptr es:[edi], eax            # 0041b72d
    {load} mov ecx, edx                          # 0041b72f
    and ecx, 0x3                                 # 0041b731
    rep stosb byte ptr es:[edi], al              # 0041b734
    mov eax, dword ptr [ebp - local_2c]          # 0041b736
    sub eax, dword ptr [ebp - local_c]           # 0041b739
    mov dword ptr [ebp - local_8], eax           # 0041b73c
    mov dword ptr [ebp - local_4], 0x0           # 0041b73f
L_0041b746:
    # block 0x0041b746: <unfilled>
    mov ecx, dword ptr [ebp - local_4]           # 0041b746
    shr ecx                                      # 0041b749
    mov dword ptr [ebp - local_4], ecx           # 0041b74b
    mov edx, dword ptr [ebp - local_4]           # 0041b74e
    and edx, 0x100                               # 0041b751
    test edx, edx                                # 0041b757
    jne.d8 L_0041b79c                            # 0041b759
    # block 0x0041b75b: <unfilled>
    mov eax, dword ptr [ebp - local_1c]          # 0041b75b
    add eax, 0x1                                 # 0041b75e
    mov dword ptr [ebp - local_1c], eax          # 0041b761
    mov ecx, dword ptr [ebp - local_1c]          # 0041b764
    cmp ecx, dword ptr [ebp + arg_10]            # 0041b767
    jne.d8 L_0041b771                            # 0041b76a
    # block 0x0041b76c: <unfilled>
    jmp.d32 L_0041b91e                           # 0041b76c
L_0041b771:
    # block 0x0041b771: <unfilled>
    mov edx, dword ptr [ebp + arg_8]             # 0041b771
    add edx, dword ptr [ebp - local_1c]          # 0041b774
    mov al, byte ptr [edx]                       # 0041b777
    mov byte ptr [ebp - local_20], al            # 0041b779
    mov cl, byte ptr [ebp - local_20]            # 0041b77c
    sub cl, byte ptr [ebp - local_10]            # 0041b77f
    mov byte ptr [ebp - local_20], cl            # 0041b782
    mov dl, byte ptr [ebp - local_10]            # 0041b785
    add dl, 0x1                                  # 0041b788
    mov byte ptr [ebp - local_10], dl            # 0041b78b
    mov eax, dword ptr [ebp - local_20]          # 0041b78e
    and eax, 0xff                                # 0041b791
    or ah, -0x1                                  # 0041b796
    mov dword ptr [ebp - local_4], eax           # 0041b799
L_0041b79c:
    # block 0x0041b79c: <unfilled>
    mov ecx, dword ptr [ebp - local_4]           # 0041b79c
    and ecx, 0x1                                 # 0041b79f
    test ecx, ecx                                # 0041b7a2
    je.d8 L_0041b814                             # 0041b7a4
    # block 0x0041b7a6: <unfilled>
    mov edx, dword ptr [ebp - local_1c]          # 0041b7a6
    add edx, 0x1                                 # 0041b7a9
    mov dword ptr [ebp - local_1c], edx          # 0041b7ac
    mov eax, dword ptr [ebp - local_1c]          # 0041b7af
    cmp eax, dword ptr [ebp + arg_10]            # 0041b7b2
    jne.d8 L_0041b7bc                            # 0041b7b5
    # block 0x0041b7b7: <unfilled>
    jmp.d32 L_0041b91e                           # 0041b7b7
L_0041b7bc:
    # block 0x0041b7bc: <unfilled>
    mov ecx, dword ptr [ebp + arg_8]             # 0041b7bc
    add ecx, dword ptr [ebp - local_1c]          # 0041b7bf
    mov dl, byte ptr [ecx]                       # 0041b7c2
    mov byte ptr [ebp - local_20], dl            # 0041b7c4
    mov al, byte ptr [ebp - local_20]            # 0041b7c7
    sub al, byte ptr [ebp - local_10]            # 0041b7ca
    mov byte ptr [ebp - local_20], al            # 0041b7cd
    mov cl, byte ptr [ebp - local_10]            # 0041b7d0
    add cl, 0x1                                  # 0041b7d3
    mov byte ptr [ebp - local_10], cl            # 0041b7d6
    mov edx, dword ptr [ebp + arg_c]             # 0041b7d9
    add edx, dword ptr [ebp + arg_14]            # 0041b7dc
    mov al, byte ptr [ebp - local_20]            # 0041b7df
    mov byte ptr [edx], al                       # 0041b7e2
    mov ecx, dword ptr [ebp + arg_14]            # 0041b7e4
    add ecx, 0x1                                 # 0041b7e7
    mov dword ptr [ebp + arg_14], ecx            # 0041b7ea
    mov edx, dword ptr [ebp - local_14]          # 0041b7ed
    add edx, dword ptr [ebp - local_8]           # 0041b7f0
    mov al, byte ptr [ebp - local_20]            # 0041b7f3
    mov byte ptr [edx], al                       # 0041b7f6
    mov ecx, dword ptr [ebp - local_8]           # 0041b7f8
    add ecx, 0x1                                 # 0041b7fb
    mov dword ptr [ebp - local_8], ecx           # 0041b7fe
    mov edx, dword ptr [ebp - local_2c]          # 0041b801
    sub edx, 0x1                                 # 0041b804
    mov eax, dword ptr [ebp - local_8]           # 0041b807
    {load} and eax, edx                          # 0041b80a
    mov dword ptr [ebp - local_8], eax           # 0041b80c
    jmp.d32 L_0041b919                           # 0041b80f
L_0041b814:
    # block 0x0041b814: <unfilled>
    mov ecx, dword ptr [ebp - local_1c]          # 0041b814
    add ecx, 0x1                                 # 0041b817
    mov dword ptr [ebp - local_1c], ecx          # 0041b81a
    mov edx, dword ptr [ebp - local_1c]          # 0041b81d
    cmp edx, dword ptr [ebp + arg_10]            # 0041b820
    jne.d8 L_0041b82a                            # 0041b823
    # block 0x0041b825: <unfilled>
    jmp.d32 L_0041b91e                           # 0041b825
L_0041b82a:
    # block 0x0041b82a: <unfilled>
    mov eax, dword ptr [ebp + arg_8]             # 0041b82a
    add eax, dword ptr [ebp - local_1c]          # 0041b82d
    mov cl, byte ptr [eax]                       # 0041b830
    mov byte ptr [ebp - local_20], cl            # 0041b832
    mov dl, byte ptr [ebp - local_20]            # 0041b835
    sub dl, byte ptr [ebp - local_10]            # 0041b838
    mov byte ptr [ebp - local_20], dl            # 0041b83b
    mov al, byte ptr [ebp - local_10]            # 0041b83e
    add al, 0x1                                  # 0041b841
    mov byte ptr [ebp - local_10], al            # 0041b843
    mov ecx, dword ptr [ebp - local_20]          # 0041b846
    and ecx, 0xff                                # 0041b849
    mov dword ptr [ebp - local_24], ecx          # 0041b84f
    mov edx, dword ptr [ebp - local_1c]          # 0041b852
    add edx, 0x1                                 # 0041b855
    mov dword ptr [ebp - local_1c], edx          # 0041b858
    mov eax, dword ptr [ebp - local_1c]          # 0041b85b
    cmp eax, dword ptr [ebp + arg_10]            # 0041b85e
    jne.d8 L_0041b868                            # 0041b861
    # block 0x0041b863: <unfilled>
    jmp.d32 L_0041b91e                           # 0041b863
L_0041b868:
    # block 0x0041b868: <unfilled>
    mov ecx, dword ptr [ebp + arg_8]             # 0041b868
    add ecx, dword ptr [ebp - local_1c]          # 0041b86b
    mov dl, byte ptr [ecx]                       # 0041b86e
    mov byte ptr [ebp - local_20], dl            # 0041b870
    mov al, byte ptr [ebp - local_20]            # 0041b873
    sub al, byte ptr [ebp - local_10]            # 0041b876
    mov byte ptr [ebp - local_20], al            # 0041b879
    mov cl, byte ptr [ebp - local_10]            # 0041b87c
    add cl, 0x1                                  # 0041b87f
    mov byte ptr [ebp - local_10], cl            # 0041b882
    mov edx, dword ptr [ebp - local_20]          # 0041b885
    and edx, 0xff                                # 0041b888
    mov dword ptr [ebp - local_28], edx          # 0041b88e
    mov eax, dword ptr [ebp - local_28]          # 0041b891
    and eax, 0xf0                                # 0041b894
    shl eax, 0x4                                 # 0041b899
    mov ecx, dword ptr [ebp - local_24]          # 0041b89c
    {load} or ecx, eax                           # 0041b89f
    mov dword ptr [ebp - local_24], ecx          # 0041b8a1
    mov edx, dword ptr [ebp - local_28]          # 0041b8a4
    and edx, 0xf                                 # 0041b8a7
    add edx, dword ptr [ebp - local_18]          # 0041b8aa
    mov dword ptr [ebp - local_28], edx          # 0041b8ad
    mov dword ptr [ebp - local_30], 0x0          # 0041b8b0
    jmp.d8 L_0041b8c2                            # 0041b8b7
L_0041b8b9:
    # block 0x0041b8b9: <unfilled>
    mov eax, dword ptr [ebp - local_30]          # 0041b8b9
    add eax, 0x1                                 # 0041b8bc
    mov dword ptr [ebp - local_30], eax          # 0041b8bf
L_0041b8c2:
    # block 0x0041b8c2: <unfilled>
    mov ecx, dword ptr [ebp - local_30]          # 0041b8c2
    cmp ecx, dword ptr [ebp - local_28]          # 0041b8c5
    ja.d8 L_0041b919                             # 0041b8c8
    # block 0x0041b8ca: <unfilled>
    mov edx, dword ptr [ebp - local_24]          # 0041b8ca
    add edx, dword ptr [ebp - local_30]          # 0041b8cd
    mov eax, dword ptr [ebp - local_2c]          # 0041b8d0
    sub eax, 0x1                                 # 0041b8d3
    {load} and edx, eax                          # 0041b8d6
    mov ecx, dword ptr [ebp - local_14]          # 0041b8d8
    mov dl, byte ptr [ecx + edx]                 # 0041b8db
    mov byte ptr [ebp - local_20], dl            # 0041b8de
    mov eax, dword ptr [ebp + arg_c]             # 0041b8e1
    add eax, dword ptr [ebp + arg_14]            # 0041b8e4
    mov cl, byte ptr [ebp - local_20]            # 0041b8e7
    mov byte ptr [eax], cl                       # 0041b8ea
    mov edx, dword ptr [ebp + arg_14]            # 0041b8ec
    add edx, 0x1                                 # 0041b8ef
    mov dword ptr [ebp + arg_14], edx            # 0041b8f2
    mov eax, dword ptr [ebp - local_14]          # 0041b8f5
    add eax, dword ptr [ebp - local_8]           # 0041b8f8
    mov cl, byte ptr [ebp - local_20]            # 0041b8fb
    mov byte ptr [eax], cl                       # 0041b8fe
    mov edx, dword ptr [ebp - local_8]           # 0041b900
    add edx, 0x1                                 # 0041b903
    mov dword ptr [ebp - local_8], edx           # 0041b906
    mov eax, dword ptr [ebp - local_2c]          # 0041b909
    sub eax, 0x1                                 # 0041b90c
    mov ecx, dword ptr [ebp - local_8]           # 0041b90f
    {load} and ecx, eax                          # 0041b912
    mov dword ptr [ebp - local_8], ecx           # 0041b914
    jmp.d8 L_0041b8b9                            # 0041b917
L_0041b919:
    # block 0x0041b919: <unfilled>
    jmp.d32 L_0041b746                           # 0041b919
L_0041b91e:
    # block 0x0041b91e: <unfilled>
    pop edi                                      # 0041b91e
    {load} mov esp, ebp                          # 0041b91f
    pop ebp                                      # 0041b921
    ret 0x10                                     # 0041b922
