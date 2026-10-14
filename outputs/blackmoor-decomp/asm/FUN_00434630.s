# FUN_00434630
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00434630
# extent:       0x00434630-0x00434773 (323 code bytes)
# span:         0x00434630-0x00434773 (code 323, tables 0, padding 0)
# sha256:       1e03e4187bcd2e6a2fd1ecc8e47bbf55df28e34663f22dedd203b2195dfd7a56
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

.org 0x00434630 - 0x401000
.globl FUN_00434630
FUN_00434630:
    # block 0x00434630: <unfilled>
    push ebp                                     # 00434630
    {load} mov ebp, esp                          # 00434631
    sub esp, 0x24                                # 00434633
    push esi                                     # 00434636
    push edi                                     # 00434637
    mov dword ptr [ebp - local_10], ecx          # 00434638
    mov dword ptr [ebp - local_8], 0x0           # 0043463b
    jmp.d8 L_0043464d                            # 00434642
L_00434644:
    # block 0x00434644: <unfilled>
    mov eax, dword ptr [ebp - local_8]           # 00434644
    add eax, 0x1                                 # 00434647
    mov dword ptr [ebp - local_8], eax           # 0043464a
L_0043464d:
    # block 0x0043464d: <unfilled>
    mov ecx, dword ptr [ebp - local_10]          # 0043464d
    mov edx, dword ptr [ebp - local_8]           # 00434650
    cmp edx, dword ptr [ecx + 0x5f68]            # 00434653
    jge.d32 L_00434769                           # 00434659
    # block 0x0043465f: <unfilled>
    mov eax, dword ptr [ebp - local_8]           # 0043465f
    mov ecx, dword ptr [ebp - local_10]          # 00434662
    mov edx, dword ptr [ecx + 4*eax + 0x20e4]    # 00434665
    mov dword ptr [ebp - local_4], edx           # 0043466c
    mov eax, dword ptr [ebp - local_4]           # 0043466f
    push eax                                     # 00434672
    mov ecx, dword ptr [ebp - local_10]          # 00434673
    call FUN_00434814                            # 00434676
    mov dword ptr [ebp - local_c], eax           # 0043467b
    mov ecx, dword ptr [ebp + arg_8]             # 0043467e
    mov dword ptr [ebp - local_14], ecx          # 00434681
    mov edx, dword ptr [ebp - local_c]           # 00434684
    mov dword ptr [ebp - local_18], edx          # 00434687
L_0043468a:
    # block 0x0043468a: <unfilled>
    mov eax, dword ptr [ebp - local_18]          # 0043468a
    mov cl, byte ptr [eax]                       # 0043468d
    mov byte ptr [ebp - local_19], cl            # 0043468f
    mov edx, dword ptr [ebp - local_14]          # 00434692
    cmp cl, byte ptr [edx]                       # 00434695
    jne.d8 L_004346c7                            # 00434697
    # block 0x00434699: <unfilled>
    cmp byte ptr [ebp - local_19], 0x0           # 00434699
    je.d8 L_004346be                             # 0043469d
    # block 0x0043469f: <unfilled>
    mov eax, dword ptr [ebp - local_18]          # 0043469f
    mov cl, byte ptr [eax + 0x1]                 # 004346a2
    mov byte ptr [ebp - local_1a], cl            # 004346a5
    mov edx, dword ptr [ebp - local_14]          # 004346a8
    cmp cl, byte ptr [edx + 0x1]                 # 004346ab
    jne.d8 L_004346c7                            # 004346ae
    # block 0x004346b0: <unfilled>
    add dword ptr [ebp - local_18], 0x2          # 004346b0
    add dword ptr [ebp - local_14], 0x2          # 004346b4
    cmp byte ptr [ebp - local_1a], 0x0           # 004346b8
    jne.d8 L_0043468a                            # 004346bc
L_004346be:
    # block 0x004346be: <unfilled>
    mov dword ptr [ebp - local_20], 0x0          # 004346be
    jmp.d8 L_004346cf                            # 004346c5
L_004346c7:
    # block 0x004346c7: <unfilled>
    {load} sbb eax, eax                          # 004346c7
    sbb eax, -0x1                                # 004346c9
    mov dword ptr [ebp - local_20], eax          # 004346cc
L_004346cf:
    # block 0x004346cf: <unfilled>
    mov ecx, dword ptr [ebp - local_20]          # 004346cf
    mov dword ptr [ebp - local_24], ecx          # 004346d2
    cmp dword ptr [ebp - local_24], 0x0          # 004346d5
    jne.d32 L_00434764                           # 004346d9
    # block 0x004346df: <unfilled>
    mov edx, dword ptr [ebp - local_8]           # 004346df
    mov eax, dword ptr [ebp - local_10]          # 004346e2
    cmp dword ptr [eax + 4*edx + 0x4fc4], 0x1    # 004346e5
    je.d8 L_00434764                             # 004346ed
    # block 0x004346ef: <unfilled>
    mov ecx, dword ptr [ebp - local_8]           # 004346ef
    mov edx, dword ptr [ebp - local_10]          # 004346f2
    mov dword ptr [edx + 4*ecx + 0x4fc4], 0x1    # 004346f5
    mov eax, dword ptr [ebp - local_4]           # 00434700
    add eax, 0x4                                 # 00434703
    mov dword ptr [ebp - local_4], eax           # 00434706
    mov ecx, dword ptr [ebp - local_4]           # 00434709
    push ecx                                     # 0043470c
    mov ecx, dword ptr [ebp - local_10]          # 0043470d
    call FUN_004347b8                            # 00434710
    mov edx, dword ptr [ebp - local_10]          # 00434715
    mov dword ptr [edx + 0x112c], eax            # 00434718
    mov eax, dword ptr [ebp - local_4]           # 0043471e
    add eax, 0x4                                 # 00434721
    mov dword ptr [ebp - local_4], eax           # 00434724
    mov ecx, dword ptr [ebp - local_10]          # 00434727
    mov edx, dword ptr [ebp - local_4]           # 0043472a
    mov dword ptr [ecx + 0x1120], edx            # 0043472d
    mov edi, dword ptr [ebp - local_c]           # 00434733
    mov eax, dword ptr [ebp - local_10]          # 00434736
    add eax, 0x1130                              # 00434739
    {load} mov edx, eax                          # 0043473e
    or ecx, -0x1                                 # 00434740
    {load} xor eax, eax                          # 00434743
    repne scasb al, byte ptr es:[edi]            # 00434745
    not ecx                                      # 00434747
    {load} sub edi, ecx                          # 00434749
    {load} mov esi, edi                          # 0043474b
    {load} mov eax, ecx                          # 0043474d
    {load} mov edi, edx                          # 0043474f
    shr ecx, 0x2                                 # 00434751
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00434754
    {load} mov ecx, eax                          # 00434756
    and ecx, 0x3                                 # 00434758
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043475b
    mov eax, 0x1                                 # 0043475d
    jmp.d8 L_0043476b                            # 00434762
L_00434764:
    # block 0x00434764: <unfilled>
    jmp.d32 L_00434644                           # 00434764
L_00434769:
    # block 0x00434769: <unfilled>
    {load} xor eax, eax                          # 00434769
L_0043476b:
    # block 0x0043476b: <unfilled>
    pop edi                                      # 0043476b
    pop esi                                      # 0043476c
    {load} mov esp, ebp                          # 0043476d
    pop ebp                                      # 0043476f
    ret 0x4                                      # 00434770
