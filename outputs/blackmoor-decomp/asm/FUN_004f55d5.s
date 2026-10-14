# FUN_004f55d5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f55d5
# extent:       0x004f55d5-0x004f572b (342 code bytes)
# span:         0x004f55d5-0x004f572b (code 342, tables 0, padding 0)
# sha256:       a23c29361019147dba61cee42d23f4b37bdc30ff70f03e579aff3b2244cad70f
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
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
.equ arg_8, 0x8  # [ebp + 0x8]

# --- external targets -----------------------------------------------
.set FUN_004f6059, .text + (0x004f6059 - 0x401000)
.set FUN_004f8f94, .text + (0x004f8f94 - 0x401000)
.set FUN_004f9040, .text + (0x004f9040 - 0x401000)
.set FUN_004f9f92, .text + (0x004f9f92 - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x004f55d5 - 0x401000
.globl FUN_004f55d5
FUN_004f55d5:
    # block 0x004f55d5: <unfilled>
    push ebp                                     # 004f55d5
    {load} mov ebp, esp                          # 004f55d6
    sub esp, 0x14                                # 004f55d8
    mov dword ptr [ebp - local_14], ecx          # 004f55db
    call dword ptr [0x52a23c]                    # 004f55de
    mov dword ptr [ebp - local_8], eax           # 004f55e4
    mov eax, dword ptr [ebp - local_14]          # 004f55e7
    mov dword ptr [eax + 0x3c2], 0x3e8           # 004f55ea
    mov ecx, dword ptr [ebp + arg_8]             # 004f55f4
    imul ecx, ecx, 0x5bb                         # 004f55f7
    mov edx, dword ptr [ebp - local_14]          # 004f55fd
    mov eax, dword ptr [edx + 0x3ce]             # 004f5600
    {load} add eax, ecx                          # 004f5606
    mov dword ptr [ebp - local_c], eax           # 004f5608
    mov ecx, dword ptr [ebp - local_c]           # 004f560b
    add ecx, 0x18a                               # 004f560e
    mov dword ptr [ebp - local_4], ecx           # 004f5614
    mov edx, dword ptr [ebp - local_c]           # 004f5617
    cmp dword ptr [edx + 0x287], 0x0             # 004f561a
    jne.d8 L_004f5647                            # 004f5621
    # block 0x004f5623: <unfilled>
    mov eax, dword ptr [ebp - local_c]           # 004f5623
    cmp dword ptr [eax + 0x16e], 0x0             # 004f5626
    jne.d8 L_004f5647                            # 004f562d
    # block 0x004f562f: <unfilled>
    mov ecx, dword ptr [ebp - local_c]           # 004f562f
    cmp dword ptr [ecx + 0x172], 0x0             # 004f5632
    jne.d8 L_004f5647                            # 004f5639
    # block 0x004f563b: <unfilled>
    mov edx, dword ptr [ebp - local_c]           # 004f563b
    cmp dword ptr [edx + 0x166], 0x0             # 004f563e
    je.d8 L_004f564c                             # 004f5645
L_004f5647:
    # block 0x004f5647: <unfilled>
    jmp.d32 L_004f5725                           # 004f5647
L_004f564c:
    # block 0x004f564c: <unfilled>
    mov eax, dword ptr [ebp - local_c]           # 004f564c
    {load} xor ecx, ecx                          # 004f564f
    mov cx, word ptr [eax + 0x12c]               # 004f5651
    and ecx, 0x20                                # 004f5658
    test ecx, ecx                                # 004f565b
    je.d8 L_004f568d                             # 004f565d
    # block 0x004f565f: <unfilled>
    mov edx, dword ptr [ebp + arg_8]             # 004f565f
    push edx                                     # 004f5662
    mov ecx, dword ptr [ebp - local_14]          # 004f5663
    call FUN_004f9f92                            # 004f5666
    mov eax, dword ptr [ebp + arg_8]             # 004f566b
    push eax                                     # 004f566e
    mov ecx, dword ptr [ebp - local_14]          # 004f566f
    call FUN_004f8f94                            # 004f5672
    mov ecx, dword ptr [ebp - local_c]           # 004f5677
    add ecx, 0x2a3                               # 004f567a
    push ecx                                     # 004f5680
    mov edx, dword ptr [ebp + arg_8]             # 004f5681
    push edx                                     # 004f5684
    mov ecx, dword ptr [ebp - local_14]          # 004f5685
    call FUN_004f9040                            # 004f5688
L_004f568d:
    # block 0x004f568d: <unfilled>
    mov eax, dword ptr [ebp - local_c]           # 004f568d
    cmp dword ptr [eax + 0x130], 0x0             # 004f5690
    jne.d32 L_004f5725                           # 004f5697
    # block 0x004f569d: <unfilled>
    mov ecx, dword ptr [ebp - local_c]           # 004f569d
    {load} xor edx, edx                          # 004f56a0
    mov dx, word ptr [ecx + 0x12c]               # 004f56a2
    and edx, 0x10                                # 004f56a9
    test edx, edx                                # 004f56ac
    je.d8 L_004f5719                             # 004f56ae
    # block 0x004f56b0: <unfilled>
    mov eax, dword ptr [ebp - local_c]           # 004f56b0
    mov dword ptr [eax + 0x19e], 0x1             # 004f56b3
    mov ecx, dword ptr [ebp - local_c]           # 004f56bd
    mov edx, dword ptr [ebp - local_c]           # 004f56c0
    mov eax, dword ptr [ecx + 0x1ae]             # 004f56c3
    sub eax, dword ptr [edx + 0x1aa]             # 004f56c9
    mov dword ptr [ebp - local_10], eax          # 004f56cf
    cmp dword ptr [ebp - local_10], 0x0          # 004f56d2
    jle.d8 L_004f56f5                            # 004f56d6
    # block 0x004f56d8: <unfilled>
    call FUN_0050cd50                            # 004f56d8
    cdq                                          # 004f56dd
    idiv dword ptr [ebp - local_10]              # 004f56de
    mov ecx, dword ptr [ebp - local_c]           # 004f56e1
    add edx, dword ptr [ecx + 0x1aa]             # 004f56e4
    mov eax, dword ptr [ebp - local_c]           # 004f56ea
    mov dword ptr [eax + 0x1a2], edx             # 004f56ed
    jmp.d8 L_004f5702                            # 004f56f3
L_004f56f5:
    # block 0x004f56f5: <unfilled>
    mov ecx, dword ptr [ebp - local_c]           # 004f56f5
    mov dword ptr [ecx + 0x1a2], 0x0             # 004f56f8
L_004f5702:
    # block 0x004f5702: <unfilled>
    mov edx, dword ptr [ebp - local_c]           # 004f5702
    mov eax, dword ptr [ebp - local_8]           # 004f5705
    add eax, dword ptr [edx + 0x1a2]             # 004f5708
    mov ecx, dword ptr [ebp - local_c]           # 004f570e
    mov dword ptr [ecx + 0x1a6], eax             # 004f5711
    jmp.d8 L_004f5725                            # 004f5717
L_004f5719:
    # block 0x004f5719: <unfilled>
    mov edx, dword ptr [ebp + arg_8]             # 004f5719
    push edx                                     # 004f571c
    mov ecx, dword ptr [ebp - local_14]          # 004f571d
    call FUN_004f6059                            # 004f5720
L_004f5725:
    # block 0x004f5725: <unfilled>
    {load} mov esp, ebp                          # 004f5725
    pop ebp                                      # 004f5727
    ret 0x4                                      # 004f5728
