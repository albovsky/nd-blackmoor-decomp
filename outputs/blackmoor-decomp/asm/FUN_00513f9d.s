# FUN_00513f9d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513f9d
# extent:       0x00513f9d-0x00514250 (691 code bytes)
# span:         0x00513f9d-0x00514250 (code 691, tables 0, padding 0)
# sha256:       c116a95ca01985a96118356205879407795a373e0df7e3c91d4ca7137e75bb4d
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00513f9d
# arguments:    6 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_4, field_8, field_c, field_10, field_20, field_40, field_50; [ecx + n] field_4, field_8, field_c; [esi + n] field_1
# callees:      calls FUN_005146bf, FUN_005146cd, KERNEL32.dll!RaiseException
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 258 instruction(s), 29 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_40, 0x40  # offset +0x40
.equ field_50, 0x50  # offset +0x50

# --- external targets -----------------------------------------------
.set FUN_005146bf, .text + (0x005146bf - 0x401000)
.set FUN_005146cd, .text + (0x005146cd - 0x401000)

.org 0x00513f9d - 0x401000
.globl FUN_00513f9d
FUN_00513f9d:
    # block 0x00513f9d: entry, 17 instruction(s), ends with je to 0x00513fcf (forward)
    push ebp                                     # 00513f9d
    {load} mov ebp, esp                          # 00513f9e
    mov ecx, dword ptr [ebp + arg_8]             # 00513fa0
    {load} xor eax, eax                          # 00513fa3
    push ebx                                     # 00513fa5
    push esi                                     # 00513fa6
    mov dword ptr [ecx + field_4], eax           # 00513fa7
    mov ecx, dword ptr [ebp + arg_8]             # 00513faa
    push edi                                     # 00513fad
    push 0x1                                     # 00513fae
    mov dword ptr [ecx + field_8], eax           # 00513fb0
    mov ecx, dword ptr [ebp + arg_8]             # 00513fb3
    pop ebx                                      # 00513fb6
    mov dword ptr [ecx + field_c], eax           # 00513fb7
    mov cl, byte ptr [ebp + arg_10]              # 00513fba
    test cl, 0x10                                # 00513fbd
    je.d8 L_00513fcf                             # 00513fc0
    # block 0x00513fc2: entered by fall-through of je at 0x00513fc0, 3 instruction(s), falls into the block at 0x00513fcf
    mov eax, dword ptr [ebp + arg_8]             # 00513fc2
    mov dword ptr [ebp + arg_10], 0xc000008f     # 00513fc5
    or dword ptr [eax + field_4], ebx            # 00513fcc
L_00513fcf:
    # block 0x00513fcf: entered by je at 0x00513fc0, 2 instruction(s), ends with je to 0x00513fe2 (forward)
    test cl, 0x2                                 # 00513fcf
    je.d8 L_00513fe2                             # 00513fd2
    # block 0x00513fd4: entered by fall-through of je at 0x00513fd2, 3 instruction(s), falls into the block at 0x00513fe2
    mov eax, dword ptr [ebp + arg_8]             # 00513fd4
    mov dword ptr [ebp + arg_10], 0xc0000093     # 00513fd7
    or dword ptr [eax + field_4], 0x2            # 00513fde
L_00513fe2:
    # block 0x00513fe2: entered by je at 0x00513fd2, 2 instruction(s), ends with je to 0x00513ff4 (forward)
    test bl, cl                                  # 00513fe2
    je.d8 L_00513ff4                             # 00513fe4
    # block 0x00513fe6: entered by fall-through of je at 0x00513fe4, 3 instruction(s), falls into the block at 0x00513ff4
    mov eax, dword ptr [ebp + arg_8]             # 00513fe6
    mov dword ptr [ebp + arg_10], 0xc0000091     # 00513fe9
    or dword ptr [eax + field_4], 0x4            # 00513ff0
L_00513ff4:
    # block 0x00513ff4: entered by je at 0x00513fe4, 2 instruction(s), ends with je to 0x00514007 (forward)
    test cl, 0x4                                 # 00513ff4
    je.d8 L_00514007                             # 00513ff7
    # block 0x00513ff9: entered by fall-through of je at 0x00513ff7, 3 instruction(s), falls into the block at 0x00514007
    mov eax, dword ptr [ebp + arg_8]             # 00513ff9
    mov dword ptr [ebp + arg_10], 0xc000008e     # 00513ffc
    or dword ptr [eax + field_4], 0x8            # 00514003
L_00514007:
    # block 0x00514007: entered by je at 0x00513ff7, 2 instruction(s), ends with je to 0x0051401a (forward)
    test cl, 0x8                                 # 00514007
    je.d8 L_0051401a                             # 0051400a
    # block 0x0051400c: entered by fall-through of je at 0x0051400a, 3 instruction(s), falls into the block at 0x0051401a
    mov eax, dword ptr [ebp + arg_8]             # 0051400c
    mov dword ptr [ebp + arg_10], 0xc0000090     # 0051400f
    or dword ptr [eax + field_4], 0x10           # 00514016
L_0051401a:
    # block 0x0051401a: entered by je at 0x0051400a, 51 instruction(s), calls FUN_005146bf, ends with je to 0x005140a3 (forward)
    mov esi, dword ptr [ebp + arg_c]             # 0051401a
    mov eax, dword ptr [ebp + arg_8]             # 0051401d
    push 0x2                                     # 00514020
    mov ecx, dword ptr [esi]                     # 00514022
    mov edx, dword ptr [eax + field_8]           # 00514024
    not ecx                                      # 00514027
    {load} and ecx, ebx                          # 00514029
    and edx, -0x11                               # 0051402b
    shl ecx, 0x4                                 # 0051402e
    {load} or ecx, edx                           # 00514031
    pop edi                                      # 00514033
    mov dword ptr [eax + field_8], ecx           # 00514034
    mov ecx, dword ptr [esi]                     # 00514037
    mov eax, dword ptr [ebp + arg_8]             # 00514039
    not ecx                                      # 0051403c
    mov edx, dword ptr [eax + field_8]           # 0051403e
    and ecx, 0x4                                 # 00514041
    shl ecx                                      # 00514044
    and edx, -0x9                                # 00514046
    {load} or ecx, edx                           # 00514049
    mov dword ptr [eax + field_8], ecx           # 0051404b
    mov ecx, dword ptr [esi]                     # 0051404e
    mov eax, dword ptr [ebp + arg_8]             # 00514050
    not ecx                                      # 00514053
    mov edx, dword ptr [eax + field_8]           # 00514055
    shr ecx                                      # 00514058
    and ecx, 0x4                                 # 0051405a
    and edx, -0x5                                # 0051405d
    {load} or ecx, edx                           # 00514060
    mov dword ptr [eax + field_8], ecx           # 00514062
    mov ecx, dword ptr [esi]                     # 00514065
    mov eax, dword ptr [ebp + arg_8]             # 00514067
    not ecx                                      # 0051406a
    mov edx, dword ptr [eax + field_8]           # 0051406c
    shr ecx, 0x3                                 # 0051406f
    {load} and ecx, edi                          # 00514072
    and edx, -0x3                                # 00514074
    {load} or ecx, edx                           # 00514077
    mov dword ptr [eax + field_8], ecx           # 00514079
    mov ecx, dword ptr [esi]                     # 0051407c
    mov eax, dword ptr [ebp + arg_8]             # 0051407e
    not ecx                                      # 00514081
    mov edx, dword ptr [eax + field_8]           # 00514083
    shr ecx, 0x5                                 # 00514086
    {load} and ecx, ebx                          # 00514089
    and edx, -0x2                                # 0051408b
    {load} or ecx, edx                           # 0051408e
    mov dword ptr [eax + field_8], ecx           # 00514090
    call FUN_005146bf                            # 00514093
    test bl, al                                  # 00514098
    je.d8 L_005140a3                             # 0051409a
    # block 0x0051409c: entered by fall-through of je at 0x0051409a, 2 instruction(s), falls into the block at 0x005140a3
    mov ecx, dword ptr [ebp + arg_8]             # 0051409c
    or dword ptr [ecx + field_c], 0x10           # 0051409f
L_005140a3:
    # block 0x005140a3: entered by je at 0x0051409a, 2 instruction(s), ends with je to 0x005140ae (forward)
    test al, 0x4                                 # 005140a3
    je.d8 L_005140ae                             # 005140a5
    # block 0x005140a7: entered by fall-through of je at 0x005140a5, 2 instruction(s), falls into the block at 0x005140ae
    mov ecx, dword ptr [ebp + arg_8]             # 005140a7
    or dword ptr [ecx + field_c], 0x8            # 005140aa
L_005140ae:
    # block 0x005140ae: entered by je at 0x005140a5, 2 instruction(s), ends with je to 0x005140b9 (forward)
    test al, 0x8                                 # 005140ae
    je.d8 L_005140b9                             # 005140b0
    # block 0x005140b2: entered by fall-through of je at 0x005140b0, 2 instruction(s), falls into the block at 0x005140b9
    mov ecx, dword ptr [ebp + arg_8]             # 005140b2
    or dword ptr [ecx + field_c], 0x4            # 005140b5
L_005140b9:
    # block 0x005140b9: entered by je at 0x005140b0, 2 instruction(s), ends with je to 0x005140c3 (forward)
    test al, 0x10                                # 005140b9
    je.d8 L_005140c3                             # 005140bb
    # block 0x005140bd: entered by fall-through of je at 0x005140bb, 2 instruction(s), falls into the block at 0x005140c3
    mov ecx, dword ptr [ebp + arg_8]             # 005140bd
    or dword ptr [ecx + field_c], edi            # 005140c0
L_005140c3:
    # block 0x005140c3: entered by je at 0x005140bb, 2 instruction(s), ends with je to 0x005140cd (forward)
    test al, 0x20                                # 005140c3
    je.d8 L_005140cd                             # 005140c5
    # block 0x005140c7: entered by fall-through of je at 0x005140c5, 2 instruction(s), falls into the block at 0x005140cd
    mov eax, dword ptr [ebp + arg_8]             # 005140c7
    or dword ptr [eax + field_c], ebx            # 005140ca
L_005140cd:
    # block 0x005140cd: entered by je at 0x005140c5, 4 instruction(s), ends with je to 0x0051410c (forward)
    mov eax, dword ptr [esi]                     # 005140cd
    mov ecx, 0xc00                               # 005140cf
    {load} and eax, ecx                          # 005140d4
    je.d8 L_0051410c                             # 005140d6
    # block 0x005140d8: entered by fall-through of je at 0x005140d6, 2 instruction(s), ends with je to 0x005140fe (forward)
    cmp eax, 0x400                               # 005140d8
    je.d8 L_005140fe                             # 005140dd
    # block 0x005140df: entered by fall-through of je at 0x005140dd, 2 instruction(s), ends with je to 0x005140f2 (forward)
    cmp eax, 0x800                               # 005140df
    je.d8 L_005140f2                             # 005140e4
    # block 0x005140e6: entered by fall-through of je at 0x005140e4, 2 instruction(s), ends with jne to 0x00514112 (forward)
    {load} cmp eax, ecx                          # 005140e6
    jne.d8 L_00514112                            # 005140e8
    # block 0x005140ea: entered by fall-through of jne at 0x005140e8, 3 instruction(s), ends with forward jump to 0x00514112
    mov eax, dword ptr [ebp + arg_8]             # 005140ea
    or dword ptr [eax], 0x3                      # 005140ed
    jmp.d8 L_00514112                            # 005140f0
L_005140f2:
    # block 0x005140f2: entered by je at 0x005140e4, 5 instruction(s), ends with forward jump to 0x00514108
    mov eax, dword ptr [ebp + arg_8]             # 005140f2
    mov ecx, dword ptr [eax]                     # 005140f5
    and ecx, -0x2                                # 005140f7
    {load} or ecx, edi                           # 005140fa
    jmp.d8 L_00514108                            # 005140fc
L_005140fe:
    # block 0x005140fe: entered by je at 0x005140dd, 4 instruction(s), falls into the block at 0x00514108
    mov eax, dword ptr [ebp + arg_8]             # 005140fe
    mov ecx, dword ptr [eax]                     # 00514101
    and ecx, -0x3                                # 00514103
    {load} or ecx, ebx                           # 00514106
L_00514108:
    # block 0x00514108: entered by jmp at 0x005140fc, 2 instruction(s), ends with forward jump to 0x00514112
    mov dword ptr [eax], ecx                     # 00514108
    jmp.d8 L_00514112                            # 0051410a
L_0051410c:
    # block 0x0051410c: entered by je at 0x005140d6, 2 instruction(s), falls into the block at 0x00514112
    mov eax, dword ptr [ebp + arg_8]             # 0051410c
    and dword ptr [eax], -0x4                    # 0051410f
L_00514112:
    # block 0x00514112: entered by jne at 0x005140e8; jmp at 0x005140f0; jmp at 0x0051410a, 4 instruction(s), ends with je to 0x0051413d (forward)
    mov eax, dword ptr [esi]                     # 00514112
    mov ecx, 0x300                               # 00514114
    {load} and eax, ecx                          # 00514119
    je.d8 L_0051413d                             # 0051411b
    # block 0x0051411d: entered by fall-through of je at 0x0051411b, 2 instruction(s), ends with je to 0x00514130 (forward)
    cmp eax, 0x200                               # 0051411d
    je.d8 L_00514130                             # 00514122
    # block 0x00514124: entered by fall-through of je at 0x00514122, 2 instruction(s), ends with jne to 0x0051414a (forward)
    {load} cmp eax, ecx                          # 00514124
    jne.d8 L_0051414a                            # 00514126
    # block 0x00514128: entered by fall-through of jne at 0x00514126, 3 instruction(s), ends with forward jump to 0x0051414a
    mov eax, dword ptr [ebp + arg_8]             # 00514128
    and dword ptr [eax], -0x1d                   # 0051412b
    jmp.d8 L_0051414a                            # 0051412e
L_00514130:
    # block 0x00514130: entered by je at 0x00514122, 5 instruction(s), ends with forward jump to 0x00514148
    mov eax, dword ptr [ebp + arg_8]             # 00514130
    mov ecx, dword ptr [eax]                     # 00514133
    and ecx, -0x19                               # 00514135
    or ecx, 0x4                                  # 00514138
    jmp.d8 L_00514148                            # 0051413b
L_0051413d:
    # block 0x0051413d: entered by je at 0x0051411b, 4 instruction(s), falls into the block at 0x00514148
    mov eax, dword ptr [ebp + arg_8]             # 0051413d
    mov ecx, dword ptr [eax]                     # 00514140
    and ecx, -0x15                               # 00514142
    or ecx, 0x8                                  # 00514145
L_00514148:
    # block 0x00514148: entered by jmp at 0x0051413b, 1 instruction(s), falls into the block at 0x0051414a
    mov dword ptr [eax], ecx                     # 00514148
L_0051414a:
    # block 0x0051414a: entered by jne at 0x00514126; jmp at 0x0051412e, 40 instruction(s), calls FUN_005146cd, KERNEL32.dll!RaiseException, ends with je to 0x005141c4 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 0051414a
    mov ecx, dword ptr [ebp + arg_14]            # 0051414d
    and ecx, 0xfff                               # 00514150
    mov edx, dword ptr [eax]                     # 00514156
    shl ecx, 0x5                                 # 00514158
    and edx, 0xfffe001f                          # 0051415b
    {load} or ecx, edx                           # 00514161
    mov dword ptr [eax], ecx                     # 00514163
    mov eax, dword ptr [ebp + arg_8]             # 00514165
    or dword ptr [eax + field_20], ebx           # 00514168
    mov eax, dword ptr [ebp + arg_8]             # 0051416b
    mov ecx, dword ptr [eax + field_20]          # 0051416e
    and ecx, -0x1d                               # 00514171
    {load} or ecx, edi                           # 00514174
    mov dword ptr [eax + field_20], ecx          # 00514176
    mov eax, dword ptr [ebp + arg_18]            # 00514179
    fld qword ptr [eax]                          # 0051417c
    mov eax, dword ptr [ebp + arg_8]             # 0051417e
    fstp qword ptr [eax + field_10]              # 00514181
    mov eax, dword ptr [ebp + arg_8]             # 00514184
    or dword ptr [eax + field_50], ebx           # 00514187
    mov eax, dword ptr [ebp + arg_8]             # 0051418a
    mov ecx, dword ptr [eax + field_50]          # 0051418d
    and ecx, -0x1d                               # 00514190
    {load} or ecx, edi                           # 00514193
    mov edi, dword ptr [ebp + arg_1c]            # 00514195
    mov dword ptr [eax + field_50], ecx          # 00514198
    mov eax, dword ptr [ebp + arg_8]             # 0051419b
    fld qword ptr [edi]                          # 0051419e
    fstp qword ptr [eax + field_40]              # 005141a0
    call FUN_005146cd                            # 005141a3
    lea eax, [ebp + arg_8]                       # 005141a8
    push eax                                     # 005141ab
    push ebx                                     # 005141ac
    push 0x0                                     # 005141ad
    push dword ptr [ebp + arg_10]                # 005141af
    call dword ptr [0x52a158]                    # 005141b2
    mov eax, dword ptr [ebp + arg_8]             # 005141b8
    test byte ptr [eax + field_8], 0x10          # 005141bb
    je.d8 L_005141c4                             # 005141bf
    # block 0x005141c1: entered by fall-through of je at 0x005141bf, 1 instruction(s), falls into the block at 0x005141c4
    and dword ptr [esi], -0x2                    # 005141c1
L_005141c4:
    # block 0x005141c4: entered by je at 0x005141bf, 2 instruction(s), ends with je to 0x005141cd (forward)
    test byte ptr [eax + field_8], 0x8           # 005141c4
    je.d8 L_005141cd                             # 005141c8
    # block 0x005141ca: entered by fall-through of je at 0x005141c8, 1 instruction(s), falls into the block at 0x005141cd
    and dword ptr [esi], -0x5                    # 005141ca
L_005141cd:
    # block 0x005141cd: entered by je at 0x005141c8, 2 instruction(s), ends with je to 0x005141d6 (forward)
    test byte ptr [eax + field_8], 0x4           # 005141cd
    je.d8 L_005141d6                             # 005141d1
    # block 0x005141d3: entered by fall-through of je at 0x005141d1, 1 instruction(s), falls into the block at 0x005141d6
    and dword ptr [esi], -0x9                    # 005141d3
L_005141d6:
    # block 0x005141d6: entered by je at 0x005141d1, 2 instruction(s), ends with je to 0x005141df (forward)
    test byte ptr [eax + field_8], 0x2           # 005141d6
    je.d8 L_005141df                             # 005141da
    # block 0x005141dc: entered by fall-through of je at 0x005141da, 1 instruction(s), falls into the block at 0x005141df
    and dword ptr [esi], -0x11                   # 005141dc
L_005141df:
    # block 0x005141df: entered by je at 0x005141da, 2 instruction(s), ends with je to 0x005141e7 (forward)
    test byte ptr [eax + field_8], bl            # 005141df
    je.d8 L_005141e7                             # 005141e2
    # block 0x005141e4: entered by fall-through of je at 0x005141e2, 1 instruction(s), falls into the block at 0x005141e7
    and dword ptr [esi], -0x21                   # 005141e4
L_005141e7:
    # block 0x005141e7: entered by je at 0x005141e2, 5 instruction(s), ends with je to 0x0051421b (forward)
    mov ecx, dword ptr [eax]                     # 005141e7
    mov edx, 0xfffff3ff                          # 005141e9
    and ecx, 0x3                                 # 005141ee
    sub ecx, 0x0                                 # 005141f1
    je.d8 L_0051421b                             # 005141f4
    # block 0x005141f6: entered by fall-through of je at 0x005141f4, 2 instruction(s), ends with je to 0x0051420f (forward)
    dec ecx                                      # 005141f6
    je.d8 L_0051420f                             # 005141f7
    # block 0x005141f9: entered by fall-through of je at 0x005141f7, 2 instruction(s), ends with je to 0x00514205 (forward)
    dec ecx                                      # 005141f9
    je.d8 L_00514205                             # 005141fa
    # block 0x005141fc: entered by fall-through of je at 0x005141fa, 2 instruction(s), ends with jne to 0x0051421d (forward)
    dec ecx                                      # 005141fc
    jne.d8 L_0051421d                            # 005141fd
    # block 0x005141ff: entered by fall-through of jne at 0x005141fd, 2 instruction(s), ends with forward jump to 0x0051421d
    or byte ptr [esi + field_1], 0xc             # 005141ff
    jmp.d8 L_0051421d                            # 00514203
L_00514205:
    # block 0x00514205: entered by je at 0x005141fa, 4 instruction(s), ends with forward jump to 0x00514217
    mov ecx, dword ptr [esi]                     # 00514205
    and ch, -0x5                                 # 00514207
    or ch, 0x8                                   # 0051420a
    jmp.d8 L_00514217                            # 0051420d
L_0051420f:
    # block 0x0051420f: entered by je at 0x005141f7, 3 instruction(s), falls into the block at 0x00514217
    mov ecx, dword ptr [esi]                     # 0051420f
    and ch, -0x9                                 # 00514211
    or ch, 0x4                                   # 00514214
L_00514217:
    # block 0x00514217: entered by jmp at 0x0051420d, 2 instruction(s), ends with forward jump to 0x0051421d
    mov dword ptr [esi], ecx                     # 00514217
    jmp.d8 L_0051421d                            # 00514219
L_0051421b:
    # block 0x0051421b: entered by je at 0x005141f4, 1 instruction(s), falls into the block at 0x0051421d
    and dword ptr [esi], edx                     # 0051421b
L_0051421d:
    # block 0x0051421d: entered by jne at 0x005141fd; jmp at 0x00514203; jmp at 0x00514219, 5 instruction(s), ends with je to 0x0051423d (forward)
    mov ecx, dword ptr [eax]                     # 0051421d
    shr ecx, 0x2                                 # 0051421f
    and ecx, 0x7                                 # 00514222
    sub ecx, 0x0                                 # 00514225
    je.d8 L_0051423d                             # 00514228
    # block 0x0051422a: entered by fall-through of je at 0x00514228, 2 instruction(s), ends with je to 0x00514234 (forward)
    dec ecx                                      # 0051422a
    je.d8 L_00514234                             # 0051422b
    # block 0x0051422d: entered by fall-through of je at 0x0051422b, 2 instruction(s), ends with jne to 0x00514246 (forward)
    dec ecx                                      # 0051422d
    jne.d8 L_00514246                            # 0051422e
    # block 0x00514230: entered by fall-through of jne at 0x0051422e, 2 instruction(s), ends with forward jump to 0x00514246
    and dword ptr [esi], edx                     # 00514230
    jmp.d8 L_00514246                            # 00514232
L_00514234:
    # block 0x00514234: entered by je at 0x0051422b, 4 instruction(s), ends with forward jump to 0x00514244
    mov ecx, dword ptr [esi]                     # 00514234
    {load} and ecx, edx                          # 00514236
    or ch, 0x2                                   # 00514238
    jmp.d8 L_00514244                            # 0051423b
L_0051423d:
    # block 0x0051423d: entered by je at 0x00514228, 3 instruction(s), falls into the block at 0x00514244
    mov ecx, dword ptr [esi]                     # 0051423d
    {load} and ecx, edx                          # 0051423f
    or ch, 0x3                                   # 00514241
L_00514244:
    # block 0x00514244: entered by jmp at 0x0051423b, 1 instruction(s), falls into the block at 0x00514246
    mov dword ptr [esi], ecx                     # 00514244
L_00514246:
    # block 0x00514246: entered by jne at 0x0051422e; jmp at 0x00514232, 7 instruction(s), ends with ret
    fld qword ptr [eax + field_40]               # 00514246
    fstp qword ptr [edi]                         # 00514249
    pop edi                                      # 0051424b
    pop esi                                      # 0051424c
    pop ebx                                      # 0051424d
    pop ebp                                      # 0051424e
    ret                                          # 0051424f

