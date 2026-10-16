# FUN_00510122
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00510122
# extent:       0x00510122-0x005102cf (429 code bytes)
# span:         0x00510122-0x005102cf (code 429, tables 0, padding 0)
# sha256:       10f65c18a66ea5ab05663e29da5c565505e6116f2efd18144b583b5202f84017
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00510122
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       4 ebp-relative slot(s): local_4, local_11, local_12, local_18
# fields:       [ecx + n] field_1, field_minus_1
# callees:      calls FUN_00512c18, FUN_005102cf, KERNEL32.dll!GetCPInfo, FUN_00510319, FUN_0051034c, FUN_00510375, FUN_00512c79
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 143 instruction(s), 18 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_11, 0x11  # offset -0x11
.equ local_12, 0x12  # offset -0x12
.equ local_18, 0x18  # offset -0x18
.equ field_1, 0x1  # offset +0x1
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_005102cf, .text + (0x005102cf - 0x401000)
.set FUN_00510319, .text + (0x00510319 - 0x401000)
.set FUN_0051034c, .text + (0x0051034c - 0x401000)
.set FUN_00510375, .text + (0x00510375 - 0x401000)
.set FUN_00512c18, .text + (0x00512c18 - 0x401000)
.set FUN_00512c79, .text + (0x00512c79 - 0x401000)

.org 0x00510122 - 0x401000
.globl FUN_00510122
FUN_00510122:
    # block 0x00510122: entry, 16 instruction(s), calls FUN_00512c18, FUN_005102cf, ends with jne to 0x00510150 (forward)
    push ebp                                     # 00510122
    {load} mov ebp, esp                          # 00510123
    sub esp, 0x18                                # 00510125
    push ebx                                     # 00510128
    push esi                                     # 00510129
    push edi                                     # 0051012a
    push 0x19                                    # 0051012b
    call FUN_00512c18                            # 0051012d
    push dword ptr [ebp + arg_8]                 # 00510132
    call FUN_005102cf                            # 00510135
    {load} mov ebx, eax                          # 0051013a
    pop ecx                                      # 0051013c
    cmp ebx, dword ptr [0x63df04]                # 0051013d
    pop ecx                                      # 00510143
    mov dword ptr [ebp + arg_8], ebx             # 00510144
    jne.d8 L_00510150                            # 00510147
L_00510149:
    # block 0x00510149: entered by jmp at 0x005102b8; fall-through of jne at 0x00510147, 2 instruction(s), ends with forward jump to 0x005102c0
    {load} xor esi, esi                          # 00510149
    jmp.d32 L_005102c0                           # 0051014b
L_00510150:
    # block 0x00510150: entered by jne at 0x00510147, 2 instruction(s), ends with je to 0x005102ae (forward)
    test ebx, ebx                                # 00510150
    je.d32 L_005102ae                            # 00510152
    # block 0x00510158: entered by fall-through of je at 0x00510152, 2 instruction(s), falls into the block at 0x0051015f
    {load} xor edx, edx                          # 00510158
    mov eax, 0x568048                            # 0051015a
L_0051015f:
    # block 0x0051015f: entered by jl at 0x0051016c, 2 instruction(s), ends with je to 0x005101d7 (forward)
    cmp dword ptr [eax], ebx                     # 0051015f
    je.d8 L_005101d7                             # 00510161
    # block 0x00510163: entered by fall-through of je at 0x00510161, 4 instruction(s), ends with jl to 0x0051015f (backward)
    add eax, 0x30                                # 00510163
    inc edx                                      # 00510166
    cmp eax, 0x568138                            # 00510167
    jl.d8 L_0051015f                             # 0051016c
    # block 0x0051016e: entered by fall-through of jl at 0x0051016c, 8 instruction(s), calls KERNEL32.dll!GetCPInfo, ends with jne to 0x005102a5 (forward)
    lea eax, [ebp - local_18]                    # 0051016e
    push eax                                     # 00510171
    push ebx                                     # 00510172
    call dword ptr [0x52a0e8]                    # 00510173
    push 0x1                                     # 00510179
    pop esi                                      # 0051017b
    {load} cmp eax, esi                          # 0051017c
    jne.d32 L_005102a5                           # 0051017e
    # block 0x00510184: entered by fall-through of jne at 0x0051017e, 10 instruction(s), ends with jbe to 0x00510292 (forward)
    push 0x40                                    # 00510184
    and dword ptr [0x63e124], 0x0                # 00510186
    pop ecx                                      # 0051018d
    {load} xor eax, eax                          # 0051018e
    mov edi, 0x63e020                            # 00510190
    cmp dword ptr [ebp - local_18], esi          # 00510195
    rep stosd dword ptr es:[edi], eax            # 00510198
    stosb byte ptr es:[edi], al                  # 0051019a
    mov dword ptr [0x63df04], ebx                # 0051019b
    jbe.d32 L_00510292                           # 005101a1
    # block 0x005101a7: entered by fall-through of jbe at 0x005101a1, 2 instruction(s), ends with je to 0x0051026d (forward)
    cmp byte ptr [ebp - local_12], 0x0           # 005101a7
    je.d32 L_0051026d                            # 005101ab
    # block 0x005101b1: entered by fall-through of je at 0x005101ab, 1 instruction(s), falls into the block at 0x005101b4
    lea ecx, [ebp - local_11]                    # 005101b1
L_005101b4:
    # block 0x005101b4: entered by jne at 0x00510267, 3 instruction(s), ends with je to 0x0051026d (forward)
    mov dl, byte ptr [ecx]                       # 005101b4
    test dl, dl                                  # 005101b6
    je.d32 L_0051026d                            # 005101b8
    # block 0x005101be: entered by fall-through of je at 0x005101b8, 2 instruction(s), falls into the block at 0x005101c5
    movzx eax, byte ptr [ecx - field_minus_1]    # 005101be
    movzx edx, dl                                # 005101c2
L_005101c5:
    # block 0x005101c5: entered by jmp at 0x005101d5, 2 instruction(s), ends with ja to 0x00510261 (forward)
    {load} cmp eax, edx                          # 005101c5
    ja.d32 L_00510261                            # 005101c7
    # block 0x005101cd: entered by fall-through of ja at 0x005101c7, 3 instruction(s), ends with backward jump to 0x005101c5
    or byte ptr [eax + 0x63e021], 0x4            # 005101cd
    inc eax                                      # 005101d4
    jmp.d8 L_005101c5                            # 005101d5
L_005101d7:
    # block 0x005101d7: entered by je at 0x00510161, 10 instruction(s), falls into the block at 0x005101f4
    and dword ptr [ebp - local_4], 0x0           # 005101d7
    push 0x40                                    # 005101db
    pop ecx                                      # 005101dd
    {load} xor eax, eax                          # 005101de
    mov edi, 0x63e020                            # 005101e0
    lea esi, [edx + 2*edx]                       # 005101e5
    rep stosd dword ptr es:[edi], eax            # 005101e8
    shl esi, 0x4                                 # 005101ea
    stosb byte ptr es:[edi], al                  # 005101ed
    lea ebx, [esi + 0x568058]                    # 005101ee
L_005101f4:
    # block 0x005101f4: entered by jb at 0x00510231, 3 instruction(s), ends with je to 0x00510227 (forward)
    cmp byte ptr [ebx], 0x0                      # 005101f4
    {load} mov ecx, ebx                          # 005101f7
    je.d8 L_00510227                             # 005101f9
L_005101fb:
    # block 0x005101fb: entered by jne at 0x00510225; fall-through of je at 0x005101f9, 3 instruction(s), ends with je to 0x00510227 (forward)
    mov dl, byte ptr [ecx + field_1]             # 005101fb
    test dl, dl                                  # 005101fe
    je.d8 L_00510227                             # 00510200
    # block 0x00510202: entered by fall-through of je at 0x00510200, 4 instruction(s), ends with ja to 0x00510220 (forward)
    movzx eax, byte ptr [ecx]                    # 00510202
    movzx edi, dl                                # 00510205
    {load} cmp eax, edi                          # 00510208
    ja.d8 L_00510220                             # 0051020a
    # block 0x0051020c: entered by fall-through of ja at 0x0051020a, 2 instruction(s), falls into the block at 0x00510215
    mov edx, dword ptr [ebp - local_4]           # 0051020c
    mov dl, byte ptr [edx + 0x568040]            # 0051020f
L_00510215:
    # block 0x00510215: entered by jbe at 0x0051021e, 4 instruction(s), ends with jbe to 0x00510215 (backward)
    or byte ptr [eax + 0x63e021], dl             # 00510215
    inc eax                                      # 0051021b
    {load} cmp eax, edi                          # 0051021c
    jbe.d8 L_00510215                            # 0051021e
L_00510220:
    # block 0x00510220: entered by ja at 0x0051020a; fall-through of jbe at 0x0051021e, 4 instruction(s), ends with jne to 0x005101fb (backward)
    inc ecx                                      # 00510220
    inc ecx                                      # 00510221
    cmp byte ptr [ecx], 0x0                      # 00510222
    jne.d8 L_005101fb                            # 00510225
L_00510227:
    # block 0x00510227: entered by je at 0x005101f9; je at 0x00510200; fall-through of jne at 0x00510225, 4 instruction(s), ends with jb to 0x005101f4 (backward)
    inc dword ptr [ebp - local_4]                # 00510227
    add ebx, 0x8                                 # 0051022a
    cmp dword ptr [ebp - local_4], 0x4           # 0051022d
    jb.d8 L_005101f4                             # 00510231
    # block 0x00510233: entered by fall-through of jb at 0x00510231, 13 instruction(s), calls FUN_00510319, ends with forward jump to 0x005102b3
    mov eax, dword ptr [ebp + arg_8]             # 00510233
    mov dword ptr [0x63df1c], 0x1                # 00510236
    push eax                                     # 00510240
    mov dword ptr [0x63df04], eax                # 00510241
    call FUN_00510319                            # 00510246
    lea esi, [esi + 0x56804c]                    # 0051024b
    mov edi, 0x63df10                            # 00510251
    movsd dword ptr es:[edi], dword ptr [esi]    # 00510256
    movsd dword ptr es:[edi], dword ptr [esi]    # 00510257
    pop ecx                                      # 00510258
    mov dword ptr [0x63e124], eax                # 00510259
    movsd dword ptr es:[edi], dword ptr [esi]    # 0051025e
    jmp.d8 L_005102b3                            # 0051025f
L_00510261:
    # block 0x00510261: entered by ja at 0x005101c7, 4 instruction(s), ends with jne to 0x005101b4 (backward)
    inc ecx                                      # 00510261
    inc ecx                                      # 00510262
    cmp byte ptr [ecx - field_minus_1], 0x0      # 00510263
    jne.d32 L_005101b4                           # 00510267
L_0051026d:
    # block 0x0051026d: entered by je at 0x005101ab; je at 0x005101b8; fall-through of jne at 0x00510267, 1 instruction(s), falls into the block at 0x0051026f
    {load} mov eax, esi                          # 0051026d
L_0051026f:
    # block 0x0051026f: entered by jb at 0x0051027c, 4 instruction(s), ends with jb to 0x0051026f (backward)
    or byte ptr [eax + 0x63e021], 0x8            # 0051026f
    inc eax                                      # 00510276
    cmp eax, 0xff                                # 00510277
    jb.d8 L_0051026f                             # 0051027c
    # block 0x0051027e: entered by fall-through of jb at 0x0051027c, 6 instruction(s), calls FUN_00510319, ends with forward jump to 0x00510299
    push ebx                                     # 0051027e
    call FUN_00510319                            # 0051027f
    pop ecx                                      # 00510284
    mov dword ptr [0x63e124], eax                # 00510285
    mov dword ptr [0x63df1c], esi                # 0051028a
    jmp.d8 L_00510299                            # 00510290
L_00510292:
    # block 0x00510292: entered by jbe at 0x005101a1, 1 instruction(s), falls into the block at 0x00510299
    and dword ptr [0x63df1c], 0x0                # 00510292
L_00510299:
    # block 0x00510299: entered by jmp at 0x00510290, 6 instruction(s), ends with forward jump to 0x005102b3
    {load} xor eax, eax                          # 00510299
    mov edi, 0x63df10                            # 0051029b
    stosd dword ptr es:[edi], eax                # 005102a0
    stosd dword ptr es:[edi], eax                # 005102a1
    stosd dword ptr es:[edi], eax                # 005102a2
    jmp.d8 L_005102b3                            # 005102a3
L_005102a5:
    # block 0x005102a5: entered by jne at 0x0051017e, 2 instruction(s), ends with je to 0x005102bd (forward)
    cmp dword ptr [0x63ca74], 0x0                # 005102a5
    je.d8 L_005102bd                             # 005102ac
L_005102ae:
    # block 0x005102ae: entered by je at 0x00510152; fall-through of je at 0x005102ac, 1 instruction(s), calls FUN_0051034c, falls into the block at 0x005102b3
    call FUN_0051034c                            # 005102ae
L_005102b3:
    # block 0x005102b3: entered by jmp at 0x0051025f; jmp at 0x005102a3, 2 instruction(s), calls FUN_00510375, ends with backward jump to 0x00510149
    call FUN_00510375                            # 005102b3
    jmp.d32 L_00510149                           # 005102b8
L_005102bd:
    # block 0x005102bd: entered by je at 0x005102ac, 1 instruction(s), falls into the block at 0x005102c0
    or esi, -0x1                                 # 005102bd
L_005102c0:
    # block 0x005102c0: entered by jmp at 0x0051014b, 9 instruction(s), calls FUN_00512c79, ends with ret
    push 0x19                                    # 005102c0
    call FUN_00512c79                            # 005102c2
    pop ecx                                      # 005102c7
    {load} mov eax, esi                          # 005102c8
    pop edi                                      # 005102ca
    pop esi                                      # 005102cb
    pop ebx                                      # 005102cc
    leave                                        # 005102cd
    ret                                          # 005102ce

