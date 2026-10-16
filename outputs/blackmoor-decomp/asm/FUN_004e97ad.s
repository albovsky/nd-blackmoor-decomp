# FUN_004e97ad
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e97ad
# extent:       0x004e97ad-0x004e9a2c (639 code bytes)
# span:         0x004e97ad-0x004e9a2c (code 639, tables 0, padding 0)
# sha256:       2c8b55f948f0ad2718589666c4b4339238d88634033f532cf0d52ec2d3b1c4fe
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e97ad
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_7012, field_764c, field_7654, field_7fb2, field_7fc6, field_822e, field_8232; [ecx + n] field_695, field_784, field_7016, field_75dc, field_764c, field_7fb6, field_7fc6, field_822e; [edx + n] field_695, field_794, field_7fae, field_7fc6, field_822e
# callees:      calls FUN_004ee86f, FUN_004e2b99, FUN_004ee630, FUN_004c5377
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 157 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_695, 0x695  # offset +0x695
.equ field_784, 0x784  # offset +0x784
.equ field_794, 0x794  # offset +0x794
.equ field_7012, 0x7012  # offset +0x7012
.equ field_7016, 0x7016  # offset +0x7016
.equ field_75dc, 0x75dc  # offset +0x75dc
.equ field_764c, 0x764c  # offset +0x764c
.equ field_7654, 0x7654  # offset +0x7654
.equ field_7fae, 0x7fae  # offset +0x7fae
.equ field_7fb2, 0x7fb2  # offset +0x7fb2
.equ field_7fb6, 0x7fb6  # offset +0x7fb6
.equ field_7fc6, 0x7fc6  # offset +0x7fc6
.equ field_822e, 0x822e  # offset +0x822e
.equ field_8232, 0x8232  # offset +0x8232

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004e2b99, .text + (0x004e2b99 - 0x401000)
.set FUN_004ee630, .text + (0x004ee630 - 0x401000)
.set FUN_004ee86f, .text + (0x004ee86f - 0x401000)

.org 0x004e97ad - 0x401000
.globl FUN_004e97ad
FUN_004e97ad:
    # block 0x004e97ad: entry, 7 instruction(s), ends with je to 0x004e97d3 (forward)
    push ebp                                     # 004e97ad
    {load} mov ebp, esp                          # 004e97ae
    sub esp, 0xc                                 # 004e97b0
    mov dword ptr [ebp - local_8], ecx           # 004e97b3
    mov eax, dword ptr [ebp - local_8]           # 004e97b6
    cmp dword ptr [eax + field_764c], 0x2        # 004e97b9
    je.d8 L_004e97d3                             # 004e97c0
    # block 0x004e97c2: entered by fall-through of je at 0x004e97c0, 3 instruction(s), ends with je to 0x004e97d3 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004e97c2
    cmp dword ptr [ecx + field_764c], 0x3        # 004e97c5
    je.d8 L_004e97d3                             # 004e97cc
    # block 0x004e97ce: entered by fall-through of je at 0x004e97cc, 1 instruction(s), ends with forward jump to 0x004e9a28
    jmp.d32 L_004e9a28                           # 004e97ce
L_004e97d3:
    # block 0x004e97d3: entered by je at 0x004e97c0; je at 0x004e97cc, 5 instruction(s), calls FUN_004ee86f, ends with forward jump to 0x004e97ff
    mov ecx, dword ptr [ebp - local_8]           # 004e97d3
    call FUN_004ee86f                            # 004e97d6
    mov edx, dword ptr [ebp - local_8]           # 004e97db
    mov dword ptr [edx + field_822e], 0x0        # 004e97de
    jmp.d8 L_004e97ff                            # 004e97e8
L_004e97ea:
    # block 0x004e97ea: entered by jmp at 0x004e98b0, 5 instruction(s), falls into the block at 0x004e97ff
    mov eax, dword ptr [ebp - local_8]           # 004e97ea
    mov ecx, dword ptr [eax + field_822e]        # 004e97ed
    add ecx, 0x1                                 # 004e97f3
    mov edx, dword ptr [ebp - local_8]           # 004e97f6
    mov dword ptr [edx + field_822e], ecx        # 004e97f9
L_004e97ff:
    # block 0x004e97ff: entered by jmp at 0x004e97e8, 3 instruction(s), ends with jge to 0x004e98b5 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004e97ff
    cmp dword ptr [eax + field_822e], 0x6        # 004e9802
    jge.d32 L_004e98b5                           # 004e9809
    # block 0x004e980f: entered by fall-through of jge at 0x004e9809, 6 instruction(s), ends with je to 0x004e98b0 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004e980f
    mov edx, dword ptr [ecx + field_822e]        # 004e9812
    imul edx, edx, 0xf7                          # 004e9818
    mov eax, dword ptr [ebp - local_8]           # 004e981e
    cmp dword ptr [eax + edx + field_7012], 0x0  # 004e9821
    je.d32 L_004e98b0                            # 004e9829
    # block 0x004e982f: entered by fall-through of je at 0x004e9829, 14 instruction(s), calls FUN_004e2b99, ends with jne to 0x004e98b0 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004e982f
    mov edx, dword ptr [ecx + field_822e]        # 004e9832
    imul edx, edx, 0x18f                         # 004e9838
    mov eax, dword ptr [ebp - local_8]           # 004e983e
    lea ecx, [eax + edx + field_7654]            # 004e9841
    call FUN_004e2b99                            # 004e9848
    mov ecx, dword ptr [ebp - local_8]           # 004e984d
    mov edx, dword ptr [ecx + field_822e]        # 004e9850
    imul edx, edx, 0xf7                          # 004e9856
    mov eax, dword ptr [ebp - local_8]           # 004e985c
    mov ecx, dword ptr [ebp - local_8]           # 004e985f
    mov eax, dword ptr [eax + field_8232]        # 004e9862
    cmp eax, dword ptr [ecx + edx + field_7016]  # 004e9868
    jne.d8 L_004e98b0                            # 004e986f
    # block 0x004e9871: entered by fall-through of jne at 0x004e986f, 17 instruction(s), calls FUN_004ee630, FUN_004c5377, falls into the block at 0x004e98b0
    push 0x55c6d8                                # 004e9871
    mov ecx, dword ptr [ebp - local_8]           # 004e9876
    add ecx, 0x763c                              # 004e9879
    push ecx                                     # 004e987f
    mov edx, dword ptr [ebp - local_8]           # 004e9880
    mov eax, dword ptr [edx + field_822e]        # 004e9883
    shl eax, 0x4                                 # 004e9889
    mov ecx, dword ptr [ebp - local_8]           # 004e988c
    lea edx, [ecx + eax + field_75dc]            # 004e988f
    push edx                                     # 004e9896
    mov eax, dword ptr [0x5cf665]                # 004e9897
    push eax                                     # 004e989c
    mov ecx, dword ptr [ebp - local_8]           # 004e989d
    call FUN_004ee630                            # 004e98a0
    push eax                                     # 004e98a5
    mov ecx, 0x5cf659                            # 004e98a6
    call FUN_004c5377                            # 004e98ab
L_004e98b0:
    # block 0x004e98b0: entered by je at 0x004e9829; jne at 0x004e986f, 1 instruction(s), ends with backward jump to 0x004e97ea
    jmp.d32 L_004e97ea                           # 004e98b0
L_004e98b5:
    # block 0x004e98b5: entered by jge at 0x004e9809, 3 instruction(s), ends with forward jump to 0x004e98d9
    mov ecx, dword ptr [ebp - local_8]           # 004e98b5
    mov dword ptr [ecx + field_822e], 0x0        # 004e98b8
    jmp.d8 L_004e98d9                            # 004e98c2
L_004e98c4:
    # block 0x004e98c4: entered by jmp at 0x004e9a23, 5 instruction(s), falls into the block at 0x004e98d9
    mov edx, dword ptr [ebp - local_8]           # 004e98c4
    mov eax, dword ptr [edx + field_822e]        # 004e98c7
    add eax, 0x1                                 # 004e98cd
    mov ecx, dword ptr [ebp - local_8]           # 004e98d0
    mov dword ptr [ecx + field_822e], eax        # 004e98d3
L_004e98d9:
    # block 0x004e98d9: entered by jmp at 0x004e98c2, 3 instruction(s), ends with jge to 0x004e9a28 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004e98d9
    cmp dword ptr [edx + field_822e], 0x10       # 004e98dc
    jge.d32 L_004e9a28                           # 004e98e3
    # block 0x004e98e9: entered by fall-through of jge at 0x004e98e3, 6 instruction(s), ends with je to 0x004e99d7 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004e98e9
    mov ecx, dword ptr [eax + field_822e]        # 004e98ec
    imul ecx, ecx, 0x28                          # 004e98f2
    mov edx, dword ptr [ebp - local_8]           # 004e98f5
    cmp dword ptr [edx + ecx + field_7fae], -0x1 # 004e98f8
    je.d32 L_004e99d7                            # 004e9900
    # block 0x004e9906: entered by fall-through of je at 0x004e9900, 14 instruction(s), ends with je to 0x004e998a (forward)
    mov eax, dword ptr [ebp - local_8]           # 004e9906
    mov ecx, dword ptr [eax + field_822e]        # 004e9909
    imul ecx, ecx, 0x28                          # 004e990f
    mov edx, dword ptr [ebp - local_8]           # 004e9912
    mov eax, dword ptr [edx + ecx + field_7fae]  # 004e9915
    mov dword ptr [ebp - local_4], eax           # 004e991c
    mov ecx, dword ptr [ebp - local_8]           # 004e991f
    mov edx, dword ptr [ecx + field_822e]        # 004e9922
    imul edx, edx, 0x28                          # 004e9928
    mov eax, dword ptr [ebp - local_8]           # 004e992b
    mov ecx, dword ptr [eax + edx + field_7fb2]  # 004e992e
    mov dword ptr [ebp - local_c], ecx           # 004e9935
    cmp dword ptr [ebp - local_c], 0x1           # 004e9938
    je.d8 L_004e998a                             # 004e993c
    # block 0x004e993e: entered by fall-through of je at 0x004e993c, 20 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004e99d5
    push 0x55c6ec                                # 004e993e
    mov edx, dword ptr [ebp - local_8]           # 004e9943
    mov eax, dword ptr [edx + field_822e]        # 004e9946
    imul eax, eax, 0x28                          # 004e994c
    mov ecx, dword ptr [ebp - local_8]           # 004e994f
    lea edx, [ecx + eax + field_7fc6]            # 004e9952
    push edx                                     # 004e9959
    mov eax, dword ptr [ebp - local_4]           # 004e995a
    imul eax, eax, 0x16d                         # 004e995d
    mov ecx, dword ptr [ebp - local_8]           # 004e9963
    lea edx, [ecx + eax + field_784]             # 004e9966
    push edx                                     # 004e996d
    mov eax, dword ptr [0x5cf665]                # 004e996e
    push eax                                     # 004e9973
    mov ecx, dword ptr [ebp - local_8]           # 004e9974
    mov edx, dword ptr [ecx + field_695]         # 004e9977
    push edx                                     # 004e997d
    mov ecx, 0x5cf659                            # 004e997e
    call FUN_004c5377                            # 004e9983
    jmp.d8 L_004e99d5                            # 004e9988
L_004e998a:
    # block 0x004e998a: entered by je at 0x004e993c, 19 instruction(s), calls FUN_004c5377, falls into the block at 0x004e99d5
    push 0x55c730                                # 004e998a
    mov eax, dword ptr [ebp - local_8]           # 004e998f
    mov ecx, dword ptr [eax + field_822e]        # 004e9992
    imul ecx, ecx, 0x28                          # 004e9998
    mov edx, dword ptr [ebp - local_8]           # 004e999b
    lea eax, [edx + ecx + field_7fc6]            # 004e999e
    push eax                                     # 004e99a5
    mov ecx, dword ptr [ebp - local_4]           # 004e99a6
    imul ecx, ecx, 0x16d                         # 004e99a9
    mov edx, dword ptr [ebp - local_8]           # 004e99af
    lea eax, [edx + ecx + field_794]             # 004e99b2
    push eax                                     # 004e99b9
    mov ecx, dword ptr [0x5cf665]                # 004e99ba
    push ecx                                     # 004e99c0
    mov edx, dword ptr [ebp - local_8]           # 004e99c1
    mov eax, dword ptr [edx + field_695]         # 004e99c4
    push eax                                     # 004e99ca
    mov ecx, 0x5cf659                            # 004e99cb
    call FUN_004c5377                            # 004e99d0
L_004e99d5:
    # block 0x004e99d5: entered by jmp at 0x004e9988, 1 instruction(s), ends with forward jump to 0x004e9a23
    jmp.d8 L_004e9a23                            # 004e99d5
L_004e99d7:
    # block 0x004e99d7: entered by je at 0x004e9900, 20 instruction(s), calls FUN_004ee630, FUN_004c5377, falls into the block at 0x004e9a23
    push 0x55c770                                # 004e99d7
    mov ecx, dword ptr [ebp - local_8]           # 004e99dc
    mov edx, dword ptr [ecx + field_822e]        # 004e99df
    imul edx, edx, 0x28                          # 004e99e5
    mov eax, dword ptr [ebp - local_8]           # 004e99e8
    lea ecx, [eax + edx + field_7fc6]            # 004e99eb
    push ecx                                     # 004e99f2
    mov edx, dword ptr [ebp - local_8]           # 004e99f3
    mov eax, dword ptr [edx + field_822e]        # 004e99f6
    imul eax, eax, 0x28                          # 004e99fc
    mov ecx, dword ptr [ebp - local_8]           # 004e99ff
    lea edx, [ecx + eax + field_7fb6]            # 004e9a02
    push edx                                     # 004e9a09
    mov eax, dword ptr [0x5cf665]                # 004e9a0a
    push eax                                     # 004e9a0f
    mov ecx, dword ptr [ebp - local_8]           # 004e9a10
    call FUN_004ee630                            # 004e9a13
    push eax                                     # 004e9a18
    mov ecx, 0x5cf659                            # 004e9a19
    call FUN_004c5377                            # 004e9a1e
L_004e9a23:
    # block 0x004e9a23: entered by jmp at 0x004e99d5, 1 instruction(s), ends with backward jump to 0x004e98c4
    jmp.d32 L_004e98c4                           # 004e9a23
L_004e9a28:
    # block 0x004e9a28: entered by jmp at 0x004e97ce; jge at 0x004e98e3, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004e9a28
    pop ebp                                      # 004e9a2a
    ret                                          # 004e9a2b

