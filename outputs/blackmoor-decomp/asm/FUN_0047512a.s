# FUN_0047512a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047512a
# extent:       0x0047512a-0x004752cd (419 code bytes)
# span:         0x0047512a-0x004752cd (code 419, tables 0, padding 0)
# sha256:       21c5850d068f2b36f21a2b05f2426a5de196a6754d8d5d459bb4cf76941fdc51
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047512a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_70, local_74
# fields:       [eax + n] field_76, field_34d; [ecx + n] field_76; [edi + n] field_4, field_6; [edx + n] field_76, field_2dd
# callees:      calls FUN_004fb2e3, FUN_00423259, FUN_00448d11
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl25a.c:m473206_click (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 134 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_70, 0x70  # offset -0x70
.equ local_74, 0x74  # offset -0x74
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ field_76, 0x76  # offset +0x76
.equ field_2dd, 0x2dd  # offset +0x2dd
.equ field_34d, 0x34d  # offset +0x34d

# --- external targets -----------------------------------------------
.set FUN_00423259, .text + (0x00423259 - 0x401000)
.set FUN_00448d11, .text + (0x00448d11 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x0047512a - 0x401000
.globl FUN_0047512a
FUN_0047512a:
    # block 0x0047512a: entry, 10 instruction(s), ends with jne to 0x0047514d (forward)
    push ebp                                     # 0047512a
    {load} mov ebp, esp                          # 0047512b
    sub esp, 0x74                                # 0047512d
    push esi                                     # 00475130
    push edi                                     # 00475131
    mov dword ptr [ebp - local_74], ecx          # 00475132
    mov dword ptr [ebp - local_4], 0x0           # 00475135
    mov eax, dword ptr [ebp - local_74]          # 0047513c
    cmp dword ptr [eax + field_34d], 0x0         # 0047513f
    jne.d8 L_0047514d                            # 00475146
    # block 0x00475148: entered by fall-through of jne at 0x00475146, 1 instruction(s), ends with forward jump to 0x004752c7
    jmp.d32 L_004752c7                           # 00475148
L_0047514d:
    # block 0x0047514d: entered by jne at 0x00475146, 8 instruction(s), calls FUN_004fb2e3, ends with je to 0x004752c7 (forward)
    mov ecx, dword ptr [ebp - local_74]          # 0047514d
    mov edx, dword ptr [ecx + field_76]          # 00475150
    mov ax, word ptr [edx + field_2dd]           # 00475153
    push eax                                     # 0047515a
    mov ecx, 0x5c3a67                            # 0047515b
    call FUN_004fb2e3                            # 00475160
    cmp dword ptr [0x5bb202], 0x0                # 00475165
    je.d32 L_004752c7                            # 0047516c
    # block 0x00475172: entered by fall-through of je at 0x0047516c, 10 instruction(s), ends with jbe to 0x00475232 (forward)
    mov ecx, dword ptr [ebp - local_74]          # 00475172
    mov edi, dword ptr [ecx + field_76]          # 00475175
    add edi, 0x2ed                               # 00475178
    or ecx, -0x1                                 # 0047517e
    {load} xor eax, eax                          # 00475181
    repne scasb al, byte ptr es:[edi]            # 00475183
    not ecx                                      # 00475185
    add ecx, -0x1                                # 00475187
    test ecx, ecx                                # 0047518a
    jbe.d32 L_00475232                           # 0047518c
    # block 0x00475192: entered by fall-through of jbe at 0x0047518c, 9 instruction(s), calls FUN_00423259, ends with je to 0x0047522b (forward)
    mov edx, dword ptr [ebp - local_74]          # 00475192
    mov eax, dword ptr [edx + field_76]          # 00475195
    add eax, 0x2ed                               # 00475198
    push eax                                     # 0047519d
    mov ecx, 0x619a6b                            # 0047519e
    call FUN_00423259                            # 004751a3
    mov dword ptr [ebp - local_4], eax           # 004751a8
    cmp dword ptr [ebp - local_4], 0x0           # 004751ab
    je.d8 L_0047522b                             # 004751af
    # block 0x004751b1: entered by fall-through of je at 0x004751af, 8 instruction(s), ends with ja to 0x0047522b (forward)
    mov edi, dword ptr [ebp - local_4]           # 004751b1
    or ecx, -0x1                                 # 004751b4
    {load} xor eax, eax                          # 004751b7
    repne scasb al, byte ptr es:[edi]            # 004751b9
    not ecx                                      # 004751bb
    add ecx, -0x1                                # 004751bd
    cmp ecx, 0x9c40                              # 004751c0
    ja.d8 L_0047522b                             # 004751c6
    # block 0x004751c8: entered by fall-through of ja at 0x004751c6, 33 instruction(s), calls FUN_00448d11, ends with forward jump to 0x00475232
    mov edi, dword ptr [ebp - local_4]           # 004751c8
    or ecx, -0x1                                 # 004751cb
    {load} xor eax, eax                          # 004751ce
    repne scasb al, byte ptr es:[edi]            # 004751d0
    not ecx                                      # 004751d2
    mov esi, dword ptr [ebp - local_4]           # 004751d4
    lea edi, [ebp - local_70]                    # 004751d7
    {load} mov edx, ecx                          # 004751da
    shr ecx, 0x2                                 # 004751dc
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004751df
    {load} mov ecx, edx                          # 004751e1
    and ecx, 0x3                                 # 004751e3
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004751e6
    lea edi, [ebp - local_70]                    # 004751e8
    or ecx, -0x1                                 # 004751eb
    {load} xor eax, eax                          # 004751ee
    repne scasb al, byte ptr es:[edi]            # 004751f0
    add edi, -0x1                                # 004751f2
    mov eax, dword ptr [0x54c6b8]                # 004751f5
    mov dword ptr [edi], eax                     # 004751fa
    mov cx, word ptr [0x54c6bc]                  # 004751fc
    mov word ptr [edi + field_4], cx             # 00475203
    mov dl, byte ptr [0x54c6be]                  # 00475207
    mov byte ptr [edi + field_6], dl             # 0047520d
    push 0x0                                     # 00475210
    push -0x1                                    # 00475212
    lea eax, [ebp - local_70]                    # 00475214
    push eax                                     # 00475217
    mov ecx, dword ptr [0x5d03b3]                # 00475218
    push ecx                                     # 0047521e
    mov ecx, 0x619a05                            # 0047521f
    call FUN_00448d11                            # 00475224
    jmp.d8 L_00475232                            # 00475229
L_0047522b:
    # block 0x0047522b: entered by je at 0x004751af; ja at 0x004751c6, 1 instruction(s), falls into the block at 0x00475232
    mov dword ptr [ebp - local_4], 0x0           # 0047522b
L_00475232:
    # block 0x00475232: entered by jbe at 0x0047518c; jmp at 0x00475229, 2 instruction(s), ends with jne to 0x004752c7 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 00475232
    jne.d32 L_004752c7                           # 00475236
    # block 0x0047523c: entered by fall-through of jne at 0x00475236, 10 instruction(s), ends with jbe to 0x004752c7 (forward)
    mov edx, dword ptr [ebp - local_74]          # 0047523c
    mov edi, dword ptr [edx + field_76]          # 0047523f
    add edi, 0x30e                               # 00475242
    or ecx, -0x1                                 # 00475248
    {load} xor eax, eax                          # 0047524b
    repne scasb al, byte ptr es:[edi]            # 0047524d
    not ecx                                      # 0047524f
    add ecx, -0x1                                # 00475251
    test ecx, ecx                                # 00475254
    jbe.d8 L_004752c7                            # 00475256
    # block 0x00475258: entered by fall-through of jbe at 0x00475256, 37 instruction(s), calls FUN_00448d11, falls into the block at 0x004752c7
    mov eax, dword ptr [ebp - local_74]          # 00475258
    mov ecx, dword ptr [eax + field_76]          # 0047525b
    add ecx, 0x30e                               # 0047525e
    {load} mov edi, ecx                          # 00475264
    lea edx, [ebp - local_70]                    # 00475266
    or ecx, -0x1                                 # 00475269
    {load} xor eax, eax                          # 0047526c
    repne scasb al, byte ptr es:[edi]            # 0047526e
    not ecx                                      # 00475270
    {load} sub edi, ecx                          # 00475272
    {load} mov esi, edi                          # 00475274
    {load} mov eax, ecx                          # 00475276
    {load} mov edi, edx                          # 00475278
    shr ecx, 0x2                                 # 0047527a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0047527d
    {load} mov ecx, eax                          # 0047527f
    and ecx, 0x3                                 # 00475281
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00475284
    lea edi, [ebp - local_70]                    # 00475286
    or ecx, -0x1                                 # 00475289
    {load} xor eax, eax                          # 0047528c
    repne scasb al, byte ptr es:[edi]            # 0047528e
    add edi, -0x1                                # 00475290
    mov ecx, dword ptr [0x54c6c0]                # 00475293
    mov dword ptr [edi], ecx                     # 00475299
    mov dx, word ptr [0x54c6c4]                  # 0047529b
    mov word ptr [edi + field_4], dx             # 004752a2
    mov al, byte ptr [0x54c6c6]                  # 004752a6
    mov byte ptr [edi + field_6], al             # 004752ab
    push 0x0                                     # 004752ae
    push -0x1                                    # 004752b0
    lea ecx, [ebp - local_70]                    # 004752b2
    push ecx                                     # 004752b5
    mov edx, dword ptr [0x5d03b3]                # 004752b6
    push edx                                     # 004752bc
    mov ecx, 0x619a05                            # 004752bd
    call FUN_00448d11                            # 004752c2
L_004752c7:
    # block 0x004752c7: entered by jmp at 0x00475148; je at 0x0047516c; jne at 0x00475236; jbe at 0x00475256, 5 instruction(s), ends with ret
    pop edi                                      # 004752c7
    pop esi                                      # 004752c8
    {load} mov esp, ebp                          # 004752c9
    pop ebp                                      # 004752cb
    ret                                          # 004752cc

