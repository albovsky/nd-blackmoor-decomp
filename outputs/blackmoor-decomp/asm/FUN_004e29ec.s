# FUN_004e29ec
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e29ec
# extent:       0x004e29ec-0x004e2b99 (429 code bytes)
# span:         0x004e29ec-0x004e2b99 (code 429, tables 0, padding 0)
# sha256:       10a279f3cb8b87ad1772ec375449ce18c8227752253d837237d0e8f6feb7a74a
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e29ec
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_14, field_20, field_28, field_30, field_17b, field_17f, field_187, field_18b; [ecx + n] field_14, field_18, field_1c, field_24, field_2c, field_30, field_117; [edx + n] field_20, field_24, field_28, field_17b, field_17f
# callees:      calls FUN_004c2790, KERNEL32.dll!GetTickCount, FUN_004f6334
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 118 instruction(s), 18 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30
.equ field_117, 0x117  # offset +0x117
.equ field_17b, 0x17b  # offset +0x17b
.equ field_17f, 0x17f  # offset +0x17f
.equ field_187, 0x187  # offset +0x187
.equ field_18b, 0x18b  # offset +0x18b

# --- external targets -----------------------------------------------
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)

.org 0x004e29ec - 0x401000
.globl FUN_004e29ec
FUN_004e29ec:
    # block 0x004e29ec: entry, 7 instruction(s), ends with jne to 0x004e2a03 (forward)
    push ebp                                     # 004e29ec
    {load} mov ebp, esp                          # 004e29ed
    sub esp, 0x14                                # 004e29ef
    mov dword ptr [ebp - local_c], ecx           # 004e29f2
    mov eax, dword ptr [ebp - local_c]           # 004e29f5
    cmp dword ptr [eax + field_30], 0x4          # 004e29f8
    jne.d8 L_004e2a03                            # 004e29fc
    # block 0x004e29fe: entered by fall-through of jne at 0x004e29fc, 1 instruction(s), ends with forward jump to 0x004e2b95
    jmp.d32 L_004e2b95                           # 004e29fe
L_004e2a03:
    # block 0x004e2a03: entered by jne at 0x004e29fc, 5 instruction(s), ends with je to 0x004e2a21 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004e2a03
    mov edx, dword ptr [ecx + field_14]          # 004e2a06
    mov dword ptr [ebp - local_10], edx          # 004e2a09
    cmp dword ptr [ebp - local_10], 0x0          # 004e2a0c
    je.d8 L_004e2a21                             # 004e2a10
    # block 0x004e2a12: entered by fall-through of je at 0x004e2a10, 2 instruction(s), ends with je to 0x004e2aa5 (forward)
    cmp dword ptr [ebp - local_10], 0x1          # 004e2a12
    je.d32 L_004e2aa5                            # 004e2a16
    # block 0x004e2a1c: entered by fall-through of je at 0x004e2a16, 1 instruction(s), ends with forward jump to 0x004e2b95
    jmp.d32 L_004e2b95                           # 004e2a1c
L_004e2a21:
    # block 0x004e2a21: entered by je at 0x004e2a10, 3 instruction(s), ends with je to 0x004e2a3b (forward)
    mov eax, dword ptr [ebp - local_c]           # 004e2a21
    cmp dword ptr [eax + field_187], 0x0         # 004e2a24
    je.d8 L_004e2a3b                             # 004e2a2b
    # block 0x004e2a2d: entered by fall-through of je at 0x004e2a2b, 4 instruction(s), ends with forward jump to 0x004e2a6a
    mov ecx, dword ptr [ebp - local_c]           # 004e2a2d
    mov edx, dword ptr [0x5d0377]                # 004e2a30
    mov dword ptr [ecx + field_24], edx          # 004e2a36
    jmp.d8 L_004e2a6a                            # 004e2a39
L_004e2a3b:
    # block 0x004e2a3b: entered by je at 0x004e2a2b, 3 instruction(s), ends with jne to 0x004e2a6a (forward)
    mov eax, dword ptr [ebp - local_c]           # 004e2a3b
    cmp dword ptr [eax + field_18b], 0x0         # 004e2a3e
    jne.d8 L_004e2a6a                            # 004e2a45
    # block 0x004e2a47: entered by fall-through of jne at 0x004e2a45, 10 instruction(s), calls FUN_004c2790, falls into the block at 0x004e2a6a
    push 0x55bf88                                # 004e2a47
    push 0x6                                     # 004e2a4c
    mov ecx, dword ptr [ebp - local_c]           # 004e2a4e
    add ecx, 0x38                                # 004e2a51
    push ecx                                     # 004e2a54
    push 0x55bf94                                # 004e2a55
    mov ecx, 0x5cf659                            # 004e2a5a
    call FUN_004c2790                            # 004e2a5f
    mov edx, dword ptr [ebp - local_c]           # 004e2a64
    mov dword ptr [edx + field_24], eax          # 004e2a67
L_004e2a6a:
    # block 0x004e2a6a: entered by jmp at 0x004e2a39; jne at 0x004e2a45, 3 instruction(s), ends with jne to 0x004e2a96 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004e2a6a
    cmp dword ptr [eax + field_28], 0x0          # 004e2a6d
    jne.d8 L_004e2a96                            # 004e2a71
    # block 0x004e2a73: entered by fall-through of jne at 0x004e2a71, 10 instruction(s), calls FUN_004c2790, falls into the block at 0x004e2a96
    push 0x55bf9c                                # 004e2a73
    push 0x6                                     # 004e2a78
    mov ecx, dword ptr [ebp - local_c]           # 004e2a7a
    add ecx, 0x59                                # 004e2a7d
    push ecx                                     # 004e2a80
    push 0x55bfb0                                # 004e2a81
    mov ecx, 0x5cf659                            # 004e2a86
    call FUN_004c2790                            # 004e2a8b
    mov edx, dword ptr [ebp - local_c]           # 004e2a90
    mov dword ptr [edx + field_28], eax          # 004e2a93
L_004e2a96:
    # block 0x004e2a96: entered by jne at 0x004e2a71, 3 instruction(s), ends with forward jump to 0x004e2b95
    mov eax, dword ptr [ebp - local_c]           # 004e2a96
    mov dword ptr [eax + field_14], 0x1          # 004e2a99
    jmp.d32 L_004e2b95                           # 004e2aa0
L_004e2aa5:
    # block 0x004e2aa5: entered by je at 0x004e2a16, 5 instruction(s), ends with je to 0x004e2abf (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004e2aa5
    mov edx, dword ptr [ecx + field_18]          # 004e2aa8
    mov dword ptr [ebp - local_14], edx          # 004e2aab
    cmp dword ptr [ebp - local_14], 0x0          # 004e2aae
    je.d8 L_004e2abf                             # 004e2ab2
    # block 0x004e2ab4: entered by fall-through of je at 0x004e2ab2, 2 instruction(s), ends with je to 0x004e2b26 (forward)
    cmp dword ptr [ebp - local_14], 0x1          # 004e2ab4
    je.d8 L_004e2b26                             # 004e2ab8
    # block 0x004e2aba: entered by fall-through of je at 0x004e2ab8, 1 instruction(s), ends with forward jump to 0x004e2b95
    jmp.d32 L_004e2b95                           # 004e2aba
L_004e2abf:
    # block 0x004e2abf: entered by je at 0x004e2ab2, 3 instruction(s), ends with jne to 0x004e2b24 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004e2abf
    cmp dword ptr [eax + field_30], 0x2          # 004e2ac2
    jne.d8 L_004e2b24                            # 004e2ac6
    # block 0x004e2ac8: entered by fall-through of jne at 0x004e2ac6, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jbe to 0x004e2b24 (forward)
    call dword ptr [0x52a23c]                    # 004e2ac8
    mov ecx, dword ptr [ebp - local_c]           # 004e2ace
    cmp eax, dword ptr [ecx + field_2c]          # 004e2ad1
    jbe.d8 L_004e2b24                            # 004e2ad4
    # block 0x004e2ad6: entered by fall-through of jbe at 0x004e2ad4, 3 instruction(s), ends with je to 0x004e2b0d (forward)
    mov edx, dword ptr [ebp - local_c]           # 004e2ad6
    cmp dword ptr [edx + field_17f], 0x0         # 004e2ad9
    je.d8 L_004e2b0d                             # 004e2ae0
    # block 0x004e2ae2: entered by fall-through of je at 0x004e2ae0, 3 instruction(s), ends with je to 0x004e2b24 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004e2ae2
    cmp dword ptr [eax + field_17f], 0x0         # 004e2ae5
    je.d8 L_004e2b24                             # 004e2aec
    # block 0x004e2aee: entered by fall-through of je at 0x004e2aec, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004e2b24 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004e2aee
    movsx edx, word ptr [ecx + field_117]        # 004e2af1
    mov dword ptr [ebp - local_4], edx           # 004e2af8
    mov eax, dword ptr [ebp - local_4]           # 004e2afb
    push eax                                     # 004e2afe
    mov ecx, 0x5cf1eb                            # 004e2aff
    call FUN_004f6334                            # 004e2b04
    test eax, eax                                # 004e2b09
    jne.d8 L_004e2b24                            # 004e2b0b
L_004e2b0d:
    # block 0x004e2b0d: entered by je at 0x004e2ae0; fall-through of jne at 0x004e2b0b, 4 instruction(s), falls into the block at 0x004e2b24
    mov ecx, dword ptr [ebp - local_c]           # 004e2b0d
    mov dword ptr [ecx + field_30], 0x0          # 004e2b10
    mov edx, dword ptr [ebp - local_c]           # 004e2b17
    mov dword ptr [edx + field_17b], 0x1         # 004e2b1a
L_004e2b24:
    # block 0x004e2b24: entered by jne at 0x004e2ac6; jbe at 0x004e2ad4; je at 0x004e2aec; jne at 0x004e2b0b, 1 instruction(s), ends with forward jump to 0x004e2b95
    jmp.d8 L_004e2b95                            # 004e2b24
L_004e2b26:
    # block 0x004e2b26: entered by je at 0x004e2ab8, 3 instruction(s), ends with je to 0x004e2b95 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004e2b26
    cmp dword ptr [eax + field_20], 0x0          # 004e2b29
    je.d8 L_004e2b95                             # 004e2b2d
    # block 0x004e2b2f: entered by fall-through of je at 0x004e2b2d, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jbe to 0x004e2b95 (forward)
    call dword ptr [0x52a23c]                    # 004e2b2f
    mov ecx, dword ptr [ebp - local_c]           # 004e2b35
    cmp eax, dword ptr [ecx + field_2c]          # 004e2b38
    jbe.d8 L_004e2b95                            # 004e2b3b
    # block 0x004e2b3d: entered by fall-through of jbe at 0x004e2b3b, 3 instruction(s), ends with je to 0x004e2b74 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004e2b3d
    cmp dword ptr [edx + field_17f], 0x0         # 004e2b40
    je.d8 L_004e2b74                             # 004e2b47
    # block 0x004e2b49: entered by fall-through of je at 0x004e2b47, 3 instruction(s), ends with je to 0x004e2b95 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004e2b49
    cmp dword ptr [eax + field_17f], 0x0         # 004e2b4c
    je.d8 L_004e2b95                             # 004e2b53
    # block 0x004e2b55: entered by fall-through of je at 0x004e2b53, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004e2b95 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004e2b55
    movsx edx, word ptr [ecx + field_117]        # 004e2b58
    mov dword ptr [ebp - local_8], edx           # 004e2b5f
    mov eax, dword ptr [ebp - local_8]           # 004e2b62
    push eax                                     # 004e2b65
    mov ecx, 0x5cf1eb                            # 004e2b66
    call FUN_004f6334                            # 004e2b6b
    test eax, eax                                # 004e2b70
    jne.d8 L_004e2b95                            # 004e2b72
L_004e2b74:
    # block 0x004e2b74: entered by je at 0x004e2b47; fall-through of jne at 0x004e2b72, 6 instruction(s), falls into the block at 0x004e2b95
    mov ecx, dword ptr [ebp - local_c]           # 004e2b74
    mov dword ptr [ecx + field_1c], 0x1          # 004e2b77
    mov edx, dword ptr [ebp - local_c]           # 004e2b7e
    mov dword ptr [edx + field_20], 0x0          # 004e2b81
    mov eax, dword ptr [ebp - local_c]           # 004e2b88
    mov dword ptr [eax + field_17b], 0x1         # 004e2b8b
L_004e2b95:
    # block 0x004e2b95: entered by jmp at 0x004e29fe; jmp at 0x004e2a1c; jmp at 0x004e2aa0; jmp at 0x004e2aba; more, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004e2b95
    pop ebp                                      # 004e2b97
    ret                                          # 004e2b98

