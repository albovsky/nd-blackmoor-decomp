# FUN_00424aa8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00424aa8
# extent:       0x00424aa8-0x00425b8b (4323 code bytes)
# span:         0x00424aa8-0x00425b8b (code 4323, tables 0, padding 0)
# sha256:       e024acef55b1cbab0bbdb4197f21033cc9cd74ffa3ba7c341fbbf8a7dc1f68a8
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_dependency_tail_parser
# naming:       INFERRED (lower confidence, not verified): the repository text tasks/A-0C.1-body-boundary-and-decoder.md:16 says "the generic dependency tail parser is `FUN_00424aa8`"
# name-note:    Generic dependency tail parser used by the raw-type loader.
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       18 ebp-relative slot(s): local_4, local_8, local_c, local_40c, local_80c, local_810, local_814, local_818, local_81c, local_820, local_824, local_828 and 6 more
# fields:       [eax + n] field_2, field_4, field_6, field_8, field_c, field_10, field_12, field_14, field_16, field_18, field_1c, field_1e and 12 more; [ecx + n] field_2, field_4, field_a, field_c, field_e, field_10, field_12, field_14, field_16, field_18, field_1a, field_1c and 12 more; [edx + n] field_4, field_6, field_8, field_c, field_e, field_10, field_12, field_14, field_16, field_18, field_1a, field_1c and 12 more
# callees:      calls FUN_0050ca3e, FUN_0044a2b7, FUN_004237f7, FUN_004236d6, FUN_0052139c, FUN_004234c8, FUN_00425b8b, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/action_family_e0.h:action_family_e0_decode (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 975 instruction(s), 46 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_40c, 0x40c  # offset -0x40c
.equ local_80c, 0x80c  # offset -0x80c
.equ local_810, 0x810  # offset -0x810
.equ local_814, 0x814  # offset -0x814
.equ local_818, 0x818  # offset -0x818
.equ local_81c, 0x81c  # offset -0x81c
.equ local_820, 0x820  # offset -0x820
.equ local_824, 0x824  # offset -0x824
.equ local_828, 0x828  # offset -0x828
.equ local_82c, 0x82c  # offset -0x82c
.equ local_830, 0x830  # offset -0x830
.equ local_834, 0x834  # offset -0x834
.equ local_838, 0x838  # offset -0x838
.equ local_83c, 0x83c  # offset -0x83c
.equ local_840, 0x840  # offset -0x840
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ field_e, 0xe  # offset +0xe
.equ field_10, 0x10  # offset +0x10
.equ arg_10, 0x10  # offset +0x10
.equ field_12, 0x12  # offset +0x12
.equ arg_14, 0x14  # offset +0x14
.equ field_14, 0x14  # offset +0x14
.equ field_16, 0x16  # offset +0x16
.equ field_18, 0x18  # offset +0x18
.equ field_1a, 0x1a  # offset +0x1a
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38
.equ field_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_44, 0x44  # offset +0x44
.equ field_48, 0x48  # offset +0x48
.equ field_608, 0x608  # offset +0x608
.equ field_60c, 0x60c  # offset +0x60c
.equ field_610, 0x610  # offset +0x610

# --- external targets -----------------------------------------------
.set FUN_004234c8, .text + (0x004234c8 - 0x401000)
.set FUN_004236d6, .text + (0x004236d6 - 0x401000)
.set FUN_004237f7, .text + (0x004237f7 - 0x401000)
.set FUN_00425b8b, .text + (0x00425b8b - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x00424aa8 - 0x401000
.globl FUN_00424aa8
FUN_00424aa8:
    # block 0x00424aa8: entry, 59 instruction(s), ends with je to 0x00424c03 (forward)
    push ebp                                     # 00424aa8
    {load} mov ebp, esp                          # 00424aa9
    sub esp, 0x840                               # 00424aab
    push edi                                     # 00424ab1
    mov dword ptr [ebp - local_840], ecx         # 00424ab2
    mov eax, dword ptr [ebp + arg_14]            # 00424ab8
    mov dword ptr [ebp - local_c], eax           # 00424abb
    mov ecx, dword ptr [ebp + arg_8]             # 00424abe
    add ecx, 0x36                                # 00424ac1
    mov dword ptr [ebp - local_820], ecx         # 00424ac4
    mov edx, dword ptr [ebp - local_820]         # 00424aca
    mov dword ptr [edx + field_1c], 0x0          # 00424ad0
    mov eax, dword ptr [ebp - local_820]         # 00424ad7
    mov dword ptr [eax + field_20], 0x0          # 00424add
    mov ecx, dword ptr [ebp - local_820]         # 00424ae4
    mov dword ptr [ecx + field_24], 0x0          # 00424aea
    mov edx, dword ptr [ebp - local_820]         # 00424af1
    mov dword ptr [edx + field_28], 0x1          # 00424af7
    mov eax, dword ptr [ebp - local_820]         # 00424afe
    mov dword ptr [eax + field_2c], 0x0          # 00424b04
    mov ecx, dword ptr [ebp - local_820]         # 00424b0b
    mov dword ptr [ecx + field_30], 0x0          # 00424b11
    mov edx, dword ptr [ebp - local_820]         # 00424b18
    mov dword ptr [edx + field_34], 0x0          # 00424b1e
    mov eax, dword ptr [ebp - local_820]         # 00424b25
    mov dword ptr [eax + field_38], 0x0          # 00424b2b
    mov ecx, dword ptr [ebp - local_820]         # 00424b32
    mov dword ptr [ebp - local_838], ecx         # 00424b38
    mov edx, dword ptr [ebp - local_838]         # 00424b3e
    mov dword ptr [edx], 0x0                     # 00424b44
    mov eax, dword ptr [ebp - local_838]         # 00424b4a
    mov ecx, dword ptr [ebp - local_840]         # 00424b50
    mov edx, dword ptr [ecx + field_60c]         # 00424b56
    mov dword ptr [eax + field_8], edx           # 00424b5c
    mov eax, dword ptr [ebp - local_840]         # 00424b5f
    mov ecx, dword ptr [eax + field_60c]         # 00424b65
    add ecx, 0x1                                 # 00424b6b
    mov edx, dword ptr [ebp - local_840]         # 00424b6e
    mov dword ptr [edx + field_60c], ecx         # 00424b74
    mov eax, dword ptr [ebp - local_838]         # 00424b7a
    mov dword ptr [eax + field_c], 0x0           # 00424b80
    mov ecx, dword ptr [ebp - local_838]         # 00424b87
    mov dword ptr [ecx + field_10], 0x0          # 00424b8d
    mov edx, dword ptr [ebp - local_838]         # 00424b94
    mov eax, dword ptr [ebp - local_820]         # 00424b9a
    mov dword ptr [edx + field_14], eax          # 00424ba0
    mov ecx, dword ptr [ebp - local_838]         # 00424ba3
    mov dword ptr [ecx + field_18], 0x0          # 00424ba9
    mov ecx, 0x100                               # 00424bb0
    or eax, -0x1                                 # 00424bb5
    lea edi, [ebp - local_80c]                   # 00424bb8
    rep stosd dword ptr es:[edi], eax            # 00424bbe
    mov ecx, 0x100                               # 00424bc0
    or eax, -0x1                                 # 00424bc5
    lea edi, [ebp - local_40c]                   # 00424bc8
    rep stosd dword ptr es:[edi], eax            # 00424bce
    mov edx, dword ptr [ebp - local_838]         # 00424bd0
    cmp dword ptr [edx + field_4], 0x0           # 00424bd6
    je.d8 L_00424c03                             # 00424bda
    # block 0x00424bdc: entered by fall-through of je at 0x00424bda, 11 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x00425b82
    mov eax, dword ptr [ebp + arg_8]             # 00424bdc
    {load} xor ecx, ecx                          # 00424bdf
    mov cl, byte ptr [eax + field_30]            # 00424be1
    push ecx                                     # 00424be4
    mov edx, dword ptr [0x5bb57b]                # 00424be5
    push edx                                     # 00424beb
    push 0x544ab0                                # 00424bec
    push 0x63888b                                # 00424bf1
    call FUN_0050ca3e                            # 00424bf6
    add esp, 0x10                                # 00424bfb
    jmp.d32 L_00425b82                           # 00424bfe
L_00424c03:
    # block 0x00424c03: entered by je at 0x00424bda, 4 instruction(s), ends with jne to 0x00424c36 (forward)
    mov eax, dword ptr [ebp + arg_10]            # 00424c03
    sub eax, dword ptr [ebp + arg_c]             # 00424c06
    test eax, eax                                # 00424c09
    jne.d8 L_00424c36                            # 00424c0b
    # block 0x00424c0d: entered by fall-through of jne at 0x00424c0b, 5 instruction(s), ends with je to 0x00424c31 (forward)
    mov ecx, dword ptr [ebp - local_838]         # 00424c0d
    mov dword ptr [ecx], 0x1                     # 00424c13
    movsx edx, word ptr [0x63a4cd]               # 00424c19
    test edx, edx                                # 00424c20
    je.d8 L_00424c31                             # 00424c22
    # block 0x00424c24: entered by fall-through of je at 0x00424c22, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00424c31
    push 0x544b14                                # 00424c24
    call FUN_0044a2b7                            # 00424c29
    add esp, 0x4                                 # 00424c2e
L_00424c31:
    # block 0x00424c31: entered by je at 0x00424c22, 1 instruction(s), ends with forward jump to 0x00425b84
    jmp.d32 L_00425b84                           # 00424c31
L_00424c36:
    # block 0x00424c36: entered by jne at 0x00424c0b, 12 instruction(s), ends with je to 0x00424c94 (forward)
    mov eax, dword ptr [ebp + arg_10]            # 00424c36
    sub eax, dword ptr [ebp + arg_c]             # 00424c39
    shr eax, 0x4                                 # 00424c3c
    mov ecx, dword ptr [ebp - local_820]         # 00424c3f
    mov dword ptr [ecx + field_34], eax          # 00424c45
    mov eax, dword ptr [ebp + arg_10]            # 00424c48
    sub eax, dword ptr [ebp + arg_c]             # 00424c4b
    {load} xor edx, edx                          # 00424c4e
    mov ecx, 0x10                                # 00424c50
    div ecx                                      # 00424c55
    test edx, edx                                # 00424c57
    je.d8 L_00424c94                             # 00424c59
    # block 0x00424c5b: entered by fall-through of je at 0x00424c59, 18 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x00425b80
    mov edx, dword ptr [ebp + arg_c]             # 00424c5b
    push edx                                     # 00424c5e
    mov eax, dword ptr [ebp + arg_10]            # 00424c5f
    push eax                                     # 00424c62
    mov ecx, dword ptr [ebp - local_820]         # 00424c63
    mov edx, dword ptr [ecx + field_34]          # 00424c69
    push edx                                     # 00424c6c
    mov eax, dword ptr [ebp + arg_8]             # 00424c6d
    {load} xor ecx, ecx                          # 00424c70
    mov cl, byte ptr [eax + field_30]            # 00424c72
    push ecx                                     # 00424c75
    mov edx, dword ptr [0x5bb57b]                # 00424c76
    push edx                                     # 00424c7c
    push 0x544b30                                # 00424c7d
    push 0x63888b                                # 00424c82
    call FUN_0050ca3e                            # 00424c87
    add esp, 0x1c                                # 00424c8c
    jmp.d32 L_00425b80                           # 00424c8f
L_00424c94:
    # block 0x00424c94: entered by je at 0x00424c59, 5 instruction(s), ends with forward jump to 0x00424cbf
    mov dword ptr [ebp - local_4], 0x0           # 00424c94
    mov eax, dword ptr [ebp - local_4]           # 00424c9b
    mov dword ptr [ebp - local_834], eax         # 00424c9e
    mov dword ptr [ebp - local_81c], 0x0         # 00424ca4
    jmp.d8 L_00424cbf                            # 00424cae
L_00424cb0:
    # block 0x00424cb0: entered by jmp at 0x00424e58, 3 instruction(s), falls into the block at 0x00424cbf
    mov ecx, dword ptr [ebp - local_81c]         # 00424cb0
    add ecx, 0x1                                 # 00424cb6
    mov dword ptr [ebp - local_81c], ecx         # 00424cb9
L_00424cbf:
    # block 0x00424cbf: entered by jmp at 0x00424cae, 4 instruction(s), ends with jge to 0x00424e5d (forward)
    mov edx, dword ptr [ebp - local_820]         # 00424cbf
    mov eax, dword ptr [ebp - local_81c]         # 00424cc5
    cmp eax, dword ptr [edx + field_34]          # 00424ccb
    jge.d32 L_00424e5d                           # 00424cce
    # block 0x00424cd4: entered by fall-through of jge at 0x00424cce, 9 instruction(s), ends with jne to 0x00424dc7 (forward)
    mov ecx, dword ptr [ebp - local_81c]         # 00424cd4
    shl ecx, 0x4                                 # 00424cda
    mov edx, dword ptr [ebp - local_c]           # 00424cdd
    {load} add edx, ecx                          # 00424ce0
    mov dword ptr [ebp - local_828], edx         # 00424ce2
    mov eax, dword ptr [ebp - local_828]         # 00424ce8
    movsx ecx, word ptr [eax]                    # 00424cee
    cmp ecx, 0x12                                # 00424cf1
    jne.d32 L_00424dc7                           # 00424cf4
    # block 0x00424cfa: entered by fall-through of jne at 0x00424cf4, 8 instruction(s), ends with jge to 0x00424d65 (forward)
    mov edx, dword ptr [ebp - local_834]         # 00424cfa
    add edx, 0x1                                 # 00424d00
    mov dword ptr [ebp - local_834], edx         # 00424d03
    mov eax, dword ptr [ebp - local_81c]         # 00424d09
    add eax, 0x1                                 # 00424d0f
    mov ecx, dword ptr [ebp - local_820]         # 00424d12
    cmp eax, dword ptr [ecx + field_34]          # 00424d18
    jge.d8 L_00424d65                            # 00424d1b
    # block 0x00424d1d: entered by fall-through of jge at 0x00424d1b, 7 instruction(s), ends with jne to 0x00424d65 (forward)
    mov edx, dword ptr [ebp - local_81c]         # 00424d1d
    add edx, 0x1                                 # 00424d23
    shl edx, 0x4                                 # 00424d26
    mov eax, dword ptr [ebp - local_c]           # 00424d29
    movsx ecx, word ptr [eax + edx]              # 00424d2c
    cmp ecx, 0x13                                # 00424d30
    jne.d8 L_00424d65                            # 00424d33
    # block 0x00424d35: entered by fall-through of jne at 0x00424d33, 14 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x00425b7e
    mov edx, dword ptr [ebp - local_820]         # 00424d35
    mov eax, dword ptr [edx + field_34]          # 00424d3b
    push eax                                     # 00424d3e
    mov ecx, dword ptr [ebp + arg_8]             # 00424d3f
    {load} xor edx, edx                          # 00424d42
    mov dl, byte ptr [ecx + field_30]            # 00424d44
    push edx                                     # 00424d47
    mov eax, dword ptr [0x5bb57b]                # 00424d48
    push eax                                     # 00424d4d
    push 0x544bd4                                # 00424d4e
    push 0x63888b                                # 00424d53
    call FUN_0050ca3e                            # 00424d58
    add esp, 0x14                                # 00424d5d
    jmp.d32 L_00425b7e                           # 00424d60
L_00424d65:
    # block 0x00424d65: entered by jge at 0x00424d1b; jne at 0x00424d33, 5 instruction(s), ends with jge to 0x00424dc2 (forward)
    mov ecx, dword ptr [ebp - local_81c]         # 00424d65
    add ecx, 0x2                                 # 00424d6b
    mov edx, dword ptr [ebp - local_820]         # 00424d6e
    cmp ecx, dword ptr [edx + field_34]          # 00424d74
    jge.d8 L_00424dc2                            # 00424d77
    # block 0x00424d79: entered by fall-through of jge at 0x00424d77, 7 instruction(s), ends with jne to 0x00424dc2 (forward)
    mov eax, dword ptr [ebp - local_81c]         # 00424d79
    add eax, 0x2                                 # 00424d7f
    shl eax, 0x4                                 # 00424d82
    mov ecx, dword ptr [ebp - local_c]           # 00424d85
    movsx edx, word ptr [ecx + eax]              # 00424d88
    cmp edx, 0x13                                # 00424d8c
    jne.d8 L_00424dc2                            # 00424d8f
    # block 0x00424d91: entered by fall-through of jne at 0x00424d8f, 14 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x00425b7c
    mov eax, dword ptr [ebp - local_820]         # 00424d91
    mov ecx, dword ptr [eax + field_34]          # 00424d97
    push ecx                                     # 00424d9a
    mov edx, dword ptr [ebp + arg_8]             # 00424d9b
    {load} xor eax, eax                          # 00424d9e
    mov al, byte ptr [edx + field_30]            # 00424da0
    push eax                                     # 00424da3
    mov ecx, dword ptr [0x5bb57b]                # 00424da4
    push ecx                                     # 00424daa
    push 0x544c54                                # 00424dab
    push 0x63888b                                # 00424db0
    call FUN_0050ca3e                            # 00424db5
    add esp, 0x14                                # 00424dba
    jmp.d32 L_00425b7c                           # 00424dbd
L_00424dc2:
    # block 0x00424dc2: entered by jge at 0x00424d77; jne at 0x00424d8f, 1 instruction(s), ends with forward jump to 0x00424e58
    jmp.d32 L_00424e58                           # 00424dc2
L_00424dc7:
    # block 0x00424dc7: entered by jne at 0x00424cf4, 4 instruction(s), ends with jne to 0x00424de0 (forward)
    mov edx, dword ptr [ebp - local_828]         # 00424dc7
    movsx eax, word ptr [edx]                    # 00424dcd
    cmp eax, 0x13                                # 00424dd0
    jne.d8 L_00424de0                            # 00424dd3
    # block 0x00424dd5: entered by fall-through of jne at 0x00424dd3, 4 instruction(s), ends with forward jump to 0x00424e58
    mov ecx, dword ptr [ebp - local_4]           # 00424dd5
    add ecx, 0x1                                 # 00424dd8
    mov dword ptr [ebp - local_4], ecx           # 00424ddb
    jmp.d8 L_00424e58                            # 00424dde
L_00424de0:
    # block 0x00424de0: entered by jne at 0x00424dd3, 4 instruction(s), ends with jne to 0x00424e58 (forward)
    mov edx, dword ptr [ebp - local_828]         # 00424de0
    movsx eax, word ptr [edx]                    # 00424de6
    cmp eax, 0xb                                 # 00424de9
    jne.d8 L_00424e58                            # 00424dec
    # block 0x00424dee: entered by fall-through of jne at 0x00424dec, 5 instruction(s), ends with jge to 0x00424e58 (forward)
    mov ecx, dword ptr [ebp - local_81c]         # 00424dee
    add ecx, 0x1                                 # 00424df4
    mov edx, dword ptr [ebp - local_820]         # 00424df7
    cmp ecx, dword ptr [edx + field_34]          # 00424dfd
    jge.d8 L_00424e58                            # 00424e00
    # block 0x00424e02: entered by fall-through of jge at 0x00424e00, 7 instruction(s), ends with jne to 0x00424e58 (forward)
    mov eax, dword ptr [ebp - local_81c]         # 00424e02
    add eax, 0x1                                 # 00424e08
    shl eax, 0x4                                 # 00424e0b
    mov ecx, dword ptr [ebp - local_c]           # 00424e0e
    movsx edx, word ptr [ecx + eax]              # 00424e11
    cmp edx, 0xb                                 # 00424e15
    jne.d8 L_00424e58                            # 00424e18
    # block 0x00424e1a: entered by fall-through of jne at 0x00424e18, 4 instruction(s), ends with jne to 0x00424e58 (forward)
    mov eax, dword ptr [ebp - local_828]         # 00424e1a
    movsx ecx, word ptr [eax + field_6]          # 00424e20
    test ecx, ecx                                # 00424e24
    jne.d8 L_00424e58                            # 00424e26
    # block 0x00424e28: entered by fall-through of jne at 0x00424e26, 14 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x00425b7a
    mov edx, dword ptr [ebp - local_820]         # 00424e28
    mov eax, dword ptr [edx + field_34]          # 00424e2e
    push eax                                     # 00424e31
    mov ecx, dword ptr [ebp + arg_8]             # 00424e32
    {load} xor edx, edx                          # 00424e35
    mov dl, byte ptr [ecx + field_30]            # 00424e37
    push edx                                     # 00424e3a
    mov eax, dword ptr [0x5bb57b]                # 00424e3b
    push eax                                     # 00424e40
    push 0x544cf0                                # 00424e41
    push 0x63888b                                # 00424e46
    call FUN_0050ca3e                            # 00424e4b
    add esp, 0x14                                # 00424e50
    jmp.d32 L_00425b7a                           # 00424e53
L_00424e58:
    # block 0x00424e58: entered by jmp at 0x00424dc2; jmp at 0x00424dde; jne at 0x00424dec; jge at 0x00424e00; more, 1 instruction(s), ends with backward jump to 0x00424cb0
    jmp.d32 L_00424cb0                           # 00424e58
L_00424e5d:
    # block 0x00424e5d: entered by jge at 0x00424cce, 3 instruction(s), ends with je to 0x00424e98 (forward)
    mov ecx, dword ptr [ebp - local_834]         # 00424e5d
    cmp ecx, dword ptr [ebp - local_4]           # 00424e63
    je.d8 L_00424e98                             # 00424e66
    # block 0x00424e68: entered by fall-through of je at 0x00424e66, 14 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x00425b78
    mov edx, dword ptr [ebp - local_820]         # 00424e68
    mov eax, dword ptr [edx + field_34]          # 00424e6e
    push eax                                     # 00424e71
    mov ecx, dword ptr [ebp + arg_8]             # 00424e72
    {load} xor edx, edx                          # 00424e75
    mov dl, byte ptr [ecx + field_30]            # 00424e77
    push edx                                     # 00424e7a
    mov eax, dword ptr [0x5bb57b]                # 00424e7b
    push eax                                     # 00424e80
    push 0x544d94                                # 00424e81
    push 0x63888b                                # 00424e86
    call FUN_0050ca3e                            # 00424e8b
    add esp, 0x14                                # 00424e90
    jmp.d32 L_00425b78                           # 00424e93
L_00424e98:
    # block 0x00424e98: entered by je at 0x00424e66, 3 instruction(s), ends with je to 0x00424ecc (forward)
    movsx ecx, word ptr [0x63a4cd]               # 00424e98
    test ecx, ecx                                # 00424e9f
    je.d8 L_00424ecc                             # 00424ea1
    # block 0x00424ea3: entered by fall-through of je at 0x00424ea1, 10 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00424ecc
    mov edx, dword ptr [ebp - local_820]         # 00424ea3
    mov eax, dword ptr [edx + field_34]          # 00424ea9
    push eax                                     # 00424eac
    push 0x544e30                                # 00424ead
    push 0x63888b                                # 00424eb2
    call FUN_0050ca3e                            # 00424eb7
    add esp, 0xc                                 # 00424ebc
    push 0x63888b                                # 00424ebf
    call FUN_0044a2b7                            # 00424ec4
    add esp, 0x4                                 # 00424ec9
L_00424ecc:
    # block 0x00424ecc: entered by je at 0x00424ea1, 6 instruction(s), ends with forward jump to 0x00424f04
    mov ecx, dword ptr [ebp - local_838]         # 00424ecc
    mov dword ptr [ebp - local_818], ecx         # 00424ed2
    mov dword ptr [ebp - local_83c], 0x0         # 00424ed8
    mov dword ptr [ebp - local_8], 0x0           # 00424ee2
    mov dword ptr [ebp - local_81c], 0x0         # 00424ee9
    jmp.d8 L_00424f04                            # 00424ef3
L_00424ef5:
    # block 0x00424ef5: entered by jmp at 0x00425a78, 3 instruction(s), falls into the block at 0x00424f04
    mov edx, dword ptr [ebp - local_81c]         # 00424ef5
    add edx, 0x1                                 # 00424efb
    mov dword ptr [ebp - local_81c], edx         # 00424efe
L_00424f04:
    # block 0x00424f04: entered by jmp at 0x00424ef3, 4 instruction(s), ends with jge to 0x00425a7d (forward)
    mov eax, dword ptr [ebp - local_820]         # 00424f04
    mov ecx, dword ptr [ebp - local_81c]         # 00424f0a
    cmp ecx, dword ptr [eax + field_34]          # 00424f10
    jge.d32 L_00425a7d                           # 00424f13
    # block 0x00424f19: entered by fall-through of jge at 0x00424f13, 9 instruction(s), ends with jne to 0x0042533b (forward)
    mov edx, dword ptr [ebp - local_81c]         # 00424f19
    shl edx, 0x4                                 # 00424f1f
    mov eax, dword ptr [ebp - local_c]           # 00424f22
    {load} add eax, edx                          # 00424f25
    mov dword ptr [ebp - local_828], eax         # 00424f27
    mov ecx, dword ptr [ebp - local_828]         # 00424f2d
    movsx edx, word ptr [ecx]                    # 00424f33
    cmp edx, 0x12                                # 00424f36
    jne.d32 L_0042533b                           # 00424f39
    # block 0x00424f3f: entered by fall-through of jne at 0x00424f39, 14 instruction(s), calls FUN_004237f7, FUN_004236d6, ends with jne to 0x0042503e (forward)
    mov ecx, dword ptr [ebp - local_840]         # 00424f3f
    call FUN_004237f7                            # 00424f45
    mov dword ptr [ebp - local_814], eax         # 00424f4a
    mov ecx, dword ptr [ebp - local_840]         # 00424f50
    call FUN_004236d6                            # 00424f56
    mov dword ptr [ebp - local_824], eax         # 00424f5b
    mov eax, dword ptr [ebp - local_818]         # 00424f61
    mov ecx, dword ptr [eax + field_18]          # 00424f67
    add ecx, 0x1                                 # 00424f6a
    mov edx, dword ptr [ebp - local_818]         # 00424f6d
    mov dword ptr [edx + field_18], ecx          # 00424f73
    mov eax, dword ptr [ebp - local_818]         # 00424f76
    cmp dword ptr [eax + field_4], 0x0           # 00424f7c
    jne.d32 L_0042503e                           # 00424f80
    # block 0x00424f86: entered by fall-through of jne at 0x00424f80, 33 instruction(s), ends with forward jump to 0x0042513a
    mov ecx, dword ptr [ebp - local_818]         # 00424f86
    mov edx, dword ptr [ebp - local_814]         # 00424f8c
    mov dword ptr [ecx + field_4], edx           # 00424f92
    mov eax, dword ptr [ebp - local_814]         # 00424f95
    mov dword ptr [eax + field_34], 0x0          # 00424f9b
    mov ecx, dword ptr [ebp - local_814]         # 00424fa2
    mov dword ptr [ecx + field_38], 0x0          # 00424fa8
    mov edx, dword ptr [ebp - local_814]         # 00424faf
    mov dword ptr [edx + field_3c], 0x0          # 00424fb5
    mov eax, dword ptr [ebp - local_814]         # 00424fbc
    mov dword ptr [eax + field_40], 0x0          # 00424fc2
    mov ecx, dword ptr [ebp - local_814]         # 00424fc9
    mov edx, dword ptr [ebp - local_824]         # 00424fcf
    mov dword ptr [ecx + field_44], edx          # 00424fd5
    mov eax, dword ptr [ebp - local_814]         # 00424fd8
    mov ecx, dword ptr [ebp - local_818]         # 00424fde
    mov dword ptr [eax + field_48], ecx          # 00424fe4
    mov edx, dword ptr [ebp - local_824]         # 00424fe7
    mov dword ptr [edx + field_4], 0x0           # 00424fed
    mov eax, dword ptr [ebp - local_824]         # 00424ff4
    mov ecx, dword ptr [ebp - local_814]         # 00424ffa
    mov dword ptr [eax + field_c], ecx           # 00425000
    mov edx, dword ptr [ebp - local_824]         # 00425003
    mov eax, dword ptr [ebp - local_818]         # 00425009
    mov dword ptr [edx + field_10], eax          # 0042500f
    mov ecx, dword ptr [ebp - local_824]         # 00425012
    mov edx, dword ptr [ebp - local_820]         # 00425018
    mov dword ptr [ecx + field_14], edx          # 0042501e
    mov eax, dword ptr [ebp - local_814]         # 00425021
    mov dword ptr [ebp - local_83c], eax         # 00425027
    mov ecx, dword ptr [ebp - local_824]         # 0042502d
    mov dword ptr [ebp - local_818], ecx         # 00425033
    jmp.d32 L_0042513a                           # 00425039
L_0042503e:
    # block 0x0042503e: entered by jne at 0x00424f80, 2 instruction(s), ends with je to 0x00425102 (forward)
    cmp dword ptr [ebp - local_83c], 0x0         # 0042503e
    je.d32 L_00425102                            # 00425045
    # block 0x0042504b: entered by fall-through of je at 0x00425045, 34 instruction(s), ends with forward jump to 0x0042513a
    mov edx, dword ptr [ebp - local_83c]         # 0042504b
    mov eax, dword ptr [ebp - local_814]         # 00425051
    mov dword ptr [edx + field_38], eax          # 00425057
    mov ecx, dword ptr [ebp - local_814]         # 0042505a
    mov edx, dword ptr [ebp - local_83c]         # 00425060
    mov dword ptr [ecx + field_34], edx          # 00425066
    mov eax, dword ptr [ebp - local_814]         # 00425069
    mov dword ptr [eax + field_38], 0x0          # 0042506f
    mov ecx, dword ptr [ebp - local_814]         # 00425076
    mov dword ptr [ecx + field_3c], 0x0          # 0042507c
    mov edx, dword ptr [ebp - local_814]         # 00425083
    mov dword ptr [edx + field_40], 0x0          # 00425089
    mov eax, dword ptr [ebp - local_814]         # 00425090
    mov ecx, dword ptr [ebp - local_818]         # 00425096
    mov dword ptr [eax + field_48], ecx          # 0042509c
    mov edx, dword ptr [ebp - local_814]         # 0042509f
    mov eax, dword ptr [ebp - local_824]         # 004250a5
    mov dword ptr [edx + field_44], eax          # 004250ab
    mov ecx, dword ptr [ebp - local_824]         # 004250ae
    mov dword ptr [ecx + field_4], 0x0           # 004250b4
    mov edx, dword ptr [ebp - local_824]         # 004250bb
    mov eax, dword ptr [ebp - local_814]         # 004250c1
    mov dword ptr [edx + field_c], eax           # 004250c7
    mov ecx, dword ptr [ebp - local_824]         # 004250ca
    mov edx, dword ptr [ebp - local_818]         # 004250d0
    mov dword ptr [ecx + field_10], edx          # 004250d6
    mov eax, dword ptr [ebp - local_824]         # 004250d9
    mov ecx, dword ptr [ebp - local_820]         # 004250df
    mov dword ptr [eax + field_14], ecx          # 004250e5
    mov edx, dword ptr [ebp - local_814]         # 004250e8
    mov dword ptr [ebp - local_83c], edx         # 004250ee
    mov eax, dword ptr [ebp - local_824]         # 004250f4
    mov dword ptr [ebp - local_818], eax         # 004250fa
    jmp.d8 L_0042513a                            # 00425100
L_00425102:
    # block 0x00425102: entered by je at 0x00425045, 16 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x00425b76
    mov ecx, dword ptr [ebp - local_820]         # 00425102
    mov edx, dword ptr [ecx + field_34]          # 00425108
    push edx                                     # 0042510b
    mov eax, dword ptr [ebp + arg_8]             # 0042510c
    {load} xor ecx, ecx                          # 0042510f
    mov cl, byte ptr [eax + field_30]            # 00425111
    push ecx                                     # 00425114
    mov edx, dword ptr [0x5bb57b]                # 00425115
    push edx                                     # 0042511b
    mov eax, dword ptr [ebp - local_81c]         # 0042511c
    push eax                                     # 00425122
    push 0x544e54                                # 00425123
    push 0x63888b                                # 00425128
    call FUN_0050ca3e                            # 0042512d
    add esp, 0x18                                # 00425132
    jmp.d32 L_00425b76                           # 00425135
L_0042513a:
    # block 0x0042513a: entered by jmp at 0x00425039; jmp at 0x00425100, 56 instruction(s), ends with jne to 0x00425282 (forward)
    mov ecx, dword ptr [ebp - local_814]         # 0042513a
    mov dword ptr [ecx], 0x1                     # 00425140
    mov edx, dword ptr [ebp - local_814]         # 00425146
    mov dword ptr [edx + field_4], 0x0           # 0042514c
    mov eax, dword ptr [ebp - local_814]         # 00425153
    mov ecx, dword ptr [ebp - local_840]         # 00425159
    mov edx, dword ptr [ecx + field_608]         # 0042515f
    mov dword ptr [eax + field_c], edx           # 00425165
    mov eax, dword ptr [ebp - local_840]         # 00425168
    mov ecx, dword ptr [eax + field_608]         # 0042516e
    add ecx, 0x1                                 # 00425174
    mov edx, dword ptr [ebp - local_840]         # 00425177
    mov dword ptr [edx + field_608], ecx         # 0042517d
    mov eax, dword ptr [ebp - local_814]         # 00425183
    mov ecx, dword ptr [ebp - local_828]         # 00425189
    mov dx, word ptr [ecx]                       # 0042518f
    mov word ptr [eax + field_10], dx            # 00425192
    mov eax, dword ptr [ebp - local_814]         # 00425196
    mov ecx, dword ptr [ebp - local_828]         # 0042519c
    mov dx, word ptr [ecx + field_2]             # 004251a2
    mov word ptr [eax + field_12], dx            # 004251a6
    mov eax, dword ptr [ebp - local_814]         # 004251aa
    mov ecx, dword ptr [ebp - local_828]         # 004251b0
    mov dx, word ptr [ecx + field_4]             # 004251b6
    mov word ptr [eax + field_14], dx            # 004251ba
    mov eax, dword ptr [ebp - local_814]         # 004251be
    mov dword ptr [eax + field_20], 0x0          # 004251c4
    mov ecx, dword ptr [ebp - local_814]         # 004251cb
    mov dword ptr [ecx + field_24], 0x0          # 004251d1
    mov edx, dword ptr [ebp - local_814]         # 004251d8
    mov dword ptr [edx + field_28], 0x0          # 004251de
    mov eax, dword ptr [ebp - local_814]         # 004251e5
    mov word ptr [eax + field_18], 0x0           # 004251eb
    mov ecx, dword ptr [ebp - local_814]         # 004251f1
    mov word ptr [ecx + field_1a], 0x0           # 004251f7
    mov edx, dword ptr [ebp - local_814]         # 004251fd
    mov word ptr [edx + field_1c], 0x0           # 00425203
    mov eax, dword ptr [ebp - local_814]         # 00425209
    mov word ptr [eax + field_1e], 0x0           # 0042520f
    mov ecx, dword ptr [ebp - local_824]         # 00425215
    mov dword ptr [ecx], 0x0                     # 0042521b
    mov edx, dword ptr [ebp - local_824]         # 00425221
    mov dword ptr [edx + field_18], 0x0          # 00425227
    mov eax, dword ptr [ebp - local_824]         # 0042522e
    mov ecx, dword ptr [ebp - local_840]         # 00425234
    mov edx, dword ptr [ecx + field_60c]         # 0042523a
    mov dword ptr [eax + field_8], edx           # 00425240
    mov eax, dword ptr [ebp - local_840]         # 00425243
    mov ecx, dword ptr [eax + field_60c]         # 00425249
    add ecx, 0x1                                 # 0042524f
    mov edx, dword ptr [ebp - local_840]         # 00425252
    mov dword ptr [edx + field_60c], ecx         # 00425258
    mov eax, dword ptr [ebp - local_828]         # 0042525e
    movsx ecx, word ptr [eax + field_6]          # 00425264
    cmp ecx, 0x1                                 # 00425268
    jne.d8 L_00425282                            # 0042526b
    # block 0x0042526d: entered by fall-through of jne at 0x0042526b, 4 instruction(s), ends with forward jump to 0x00425295
    mov edx, dword ptr [ebp - local_814]         # 0042526d
    mov eax, dword ptr [edx + field_c]           # 00425273
    mov word ptr [ebp + 2*eax - local_80c], 0x1  # 00425276
    jmp.d8 L_00425295                            # 00425280
L_00425282:
    # block 0x00425282: entered by jne at 0x0042526b, 3 instruction(s), falls into the block at 0x00425295
    mov ecx, dword ptr [ebp - local_814]         # 00425282
    mov edx, dword ptr [ecx + field_c]           # 00425288
    mov word ptr [ebp + 2*edx - local_80c], 0x0  # 0042528b
L_00425295:
    # block 0x00425295: entered by jmp at 0x00425280, 3 instruction(s), ends with je to 0x004252dc (forward)
    movsx eax, word ptr [0x63a4cd]               # 00425295
    test eax, eax                                # 0042529c
    je.d8 L_004252dc                             # 0042529e
    # block 0x004252a0: entered by fall-through of je at 0x0042529e, 3 instruction(s), ends with jl to 0x004252dc (forward)
    mov ecx, dword ptr [ebp - local_814]         # 004252a0
    cmp dword ptr [ecx + field_c], 0x200         # 004252a6
    jl.d8 L_004252dc                             # 004252ad
    # block 0x004252af: entered by fall-through of jl at 0x004252ad, 11 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, FUN_0052139c, falls into the block at 0x004252dc
    push 0x544ee0                                # 004252af
    push 0x63888b                                # 004252b4
    call FUN_0050ca3e                            # 004252b9
    add esp, 0x8                                 # 004252be
    push 0x63888b                                # 004252c1
    call FUN_0044a2b7                            # 004252c6
    add esp, 0x4                                 # 004252cb
    push 0x0                                     # 004252ce
    push 0x0                                     # 004252d0
    push 0x63888b                                # 004252d2
    call FUN_0052139c                            # 004252d7
L_004252dc:
    # block 0x004252dc: entered by je at 0x0042529e; jl at 0x004252ad, 8 instruction(s), ends with je to 0x00425336 (forward)
    mov edx, dword ptr [ebp - local_820]         # 004252dc
    mov eax, dword ptr [edx + field_28]          # 004252e2
    add eax, 0x1                                 # 004252e5
    mov ecx, dword ptr [ebp - local_820]         # 004252e8
    mov dword ptr [ecx + field_28], eax          # 004252ee
    movsx edx, word ptr [0x63a4cd]               # 004252f1
    test edx, edx                                # 004252f8
    je.d8 L_00425336                             # 004252fa
    # block 0x004252fc: entered by fall-through of je at 0x004252fa, 15 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00425336
    mov eax, dword ptr [ebp - local_81c]         # 004252fc
    push eax                                     # 00425302
    mov ecx, dword ptr [ebp - local_83c]         # 00425303
    mov edx, dword ptr [ecx + field_c]           # 00425309
    push edx                                     # 0042530c
    mov eax, dword ptr [ebp - local_818]         # 0042530d
    mov ecx, dword ptr [eax + field_8]           # 00425313
    push ecx                                     # 00425316
    push 0x544f28                                # 00425317
    push 0x63888b                                # 0042531c
    call FUN_0050ca3e                            # 00425321
    add esp, 0x14                                # 00425326
    push 0x63888b                                # 00425329
    call FUN_0044a2b7                            # 0042532e
    add esp, 0x4                                 # 00425333
L_00425336:
    # block 0x00425336: entered by je at 0x004252fa, 1 instruction(s), ends with forward jump to 0x00425a78
    jmp.d32 L_00425a78                           # 00425336
L_0042533b:
    # block 0x0042533b: entered by jne at 0x00424f39, 4 instruction(s), ends with jne to 0x004254c6 (forward)
    mov edx, dword ptr [ebp - local_828]         # 0042533b
    movsx eax, word ptr [edx]                    # 00425341
    cmp eax, 0x13                                # 00425344
    jne.d32 L_004254c6                           # 00425347
    # block 0x0042534d: entered by fall-through of jne at 0x00425347, 3 instruction(s), ends with je to 0x00425395 (forward)
    movsx ecx, word ptr [0x63a4cd]               # 0042534d
    test ecx, ecx                                # 00425354
    je.d8 L_00425395                             # 00425356
    # block 0x00425358: entered by fall-through of je at 0x00425356, 16 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00425395
    mov edx, dword ptr [ebp - local_81c]         # 00425358
    push edx                                     # 0042535e
    mov eax, dword ptr [ebp - local_818]         # 0042535f
    mov ecx, dword ptr [eax + field_c]           # 00425365
    mov edx, dword ptr [ecx + field_c]           # 00425368
    push edx                                     # 0042536b
    mov eax, dword ptr [ebp - local_818]         # 0042536c
    mov ecx, dword ptr [eax + field_8]           # 00425372
    push ecx                                     # 00425375
    push 0x544f6c                                # 00425376
    push 0x63888b                                # 0042537b
    call FUN_0050ca3e                            # 00425380
    add esp, 0x14                                # 00425385
    push 0x63888b                                # 00425388
    call FUN_0044a2b7                            # 0042538d
    add esp, 0x4                                 # 00425392
L_00425395:
    # block 0x00425395: entered by je at 0x00425356, 14 instruction(s), ends with jne to 0x004253ef (forward)
    mov edx, dword ptr [ebp - local_818]         # 00425395
    mov eax, dword ptr [edx + field_10]          # 0042539b
    mov dword ptr [ebp - local_82c], eax         # 0042539e
    mov ecx, dword ptr [ebp - local_818]         # 004253a4
    mov edx, dword ptr [ecx + field_c]           # 004253aa
    mov dword ptr [ebp - local_810], edx         # 004253ad
    mov eax, dword ptr [ebp - local_82c]         # 004253b3
    mov dword ptr [ebp - local_818], eax         # 004253b9
    mov ecx, dword ptr [ebp - local_810]         # 004253bf
    mov dword ptr [ebp - local_83c], ecx         # 004253c5
    mov edx, dword ptr [ebp - local_828]         # 004253cb
    movsx eax, word ptr [edx + field_6]          # 004253d1
    cmp eax, 0x1                                 # 004253d5
    jne.d8 L_004253ef                            # 004253d8
    # block 0x004253da: entered by fall-through of jne at 0x004253d8, 4 instruction(s), ends with forward jump to 0x00425402
    mov ecx, dword ptr [ebp - local_83c]         # 004253da
    mov edx, dword ptr [ecx + field_c]           # 004253e0
    mov word ptr [ebp + 2*edx - local_40c], 0x1  # 004253e3
    jmp.d8 L_00425402                            # 004253ed
L_004253ef:
    # block 0x004253ef: entered by jne at 0x004253d8, 3 instruction(s), falls into the block at 0x00425402
    mov eax, dword ptr [ebp - local_83c]         # 004253ef
    mov ecx, dword ptr [eax + field_c]           # 004253f5
    mov word ptr [ebp + 2*ecx - local_40c], 0x0  # 004253f8
L_00425402:
    # block 0x00425402: entered by jmp at 0x004253ed, 3 instruction(s), ends with je to 0x00425449 (forward)
    movsx edx, word ptr [0x63a4cd]               # 00425402
    test edx, edx                                # 00425409
    je.d8 L_00425449                             # 0042540b
    # block 0x0042540d: entered by fall-through of je at 0x0042540b, 3 instruction(s), ends with jl to 0x00425449 (forward)
    mov eax, dword ptr [ebp - local_814]         # 0042540d
    cmp dword ptr [eax + field_c], 0x200         # 00425413
    jl.d8 L_00425449                             # 0042541a
    # block 0x0042541c: entered by fall-through of jl at 0x0042541a, 11 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, FUN_0052139c, falls into the block at 0x00425449
    push 0x544fb0                                # 0042541c
    push 0x63888b                                # 00425421
    call FUN_0050ca3e                            # 00425426
    add esp, 0x8                                 # 0042542b
    push 0x63888b                                # 0042542e
    call FUN_0044a2b7                            # 00425433
    add esp, 0x4                                 # 00425438
    push 0x0                                     # 0042543b
    push 0x0                                     # 0042543d
    push 0x63888b                                # 0042543f
    call FUN_0052139c                            # 00425444
L_00425449:
    # block 0x00425449: entered by je at 0x0042540b; jl at 0x0042541a, 8 instruction(s), ends with je to 0x004254a6 (forward)
    mov ecx, dword ptr [ebp - local_83c]         # 00425449
    mov edx, dword ptr [ecx + field_c]           # 0042544f
    movsx eax, word ptr [ebp + 2*edx - local_80c] # 00425452
    mov ecx, dword ptr [ebp - local_83c]         # 0042545a
    mov edx, dword ptr [ecx + field_c]           # 00425460
    movsx ecx, word ptr [ebp + 2*edx - local_40c] # 00425463
    {load} cmp eax, ecx                          # 0042546b
    je.d8 L_004254a6                             # 0042546d
    # block 0x0042546f: entered by fall-through of je at 0x0042546d, 16 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x00425b74
    mov edx, dword ptr [ebp - local_820]         # 0042546f
    mov eax, dword ptr [edx + field_34]          # 00425475
    push eax                                     # 00425478
    mov ecx, dword ptr [ebp + arg_8]             # 00425479
    {load} xor edx, edx                          # 0042547c
    mov dl, byte ptr [ecx + field_30]            # 0042547e
    push edx                                     # 00425481
    mov eax, dword ptr [0x5bb57b]                # 00425482
    push eax                                     # 00425487
    mov ecx, dword ptr [ebp - local_81c]         # 00425488
    push ecx                                     # 0042548e
    push 0x544ff4                                # 0042548f
    push 0x63888b                                # 00425494
    call FUN_0050ca3e                            # 00425499
    add esp, 0x18                                # 0042549e
    jmp.d32 L_00425b74                           # 004254a1
L_004254a6:
    # block 0x004254a6: entered by je at 0x0042546d, 6 instruction(s), ends with forward jump to 0x00425a78
    mov edx, dword ptr [ebp - local_83c]         # 004254a6
    mov eax, dword ptr [edx + field_c]           # 004254ac
    mov ecx, dword ptr [ebp - local_83c]         # 004254af
    mov dx, word ptr [ebp + 2*eax - local_80c]   # 004254b5
    mov word ptr [ecx + field_16], dx            # 004254bd
    jmp.d32 L_00425a78                           # 004254c1
L_004254c6:
    # block 0x004254c6: entered by jne at 0x00425347, 6 instruction(s), calls FUN_004237f7, ends with jne to 0x00425539 (forward)
    mov ecx, dword ptr [ebp - local_840]         # 004254c6
    call FUN_004237f7                            # 004254cc
    mov dword ptr [ebp - local_814], eax         # 004254d1
    mov eax, dword ptr [ebp - local_818]         # 004254d7
    cmp dword ptr [eax + field_4], 0x0           # 004254dd
    jne.d8 L_00425539                            # 004254e1
    # block 0x004254e3: entered by fall-through of jne at 0x004254e1, 15 instruction(s), ends with forward jump to 0x004255cf
    mov ecx, dword ptr [ebp - local_818]         # 004254e3
    mov edx, dword ptr [ebp - local_814]         # 004254e9
    mov dword ptr [ecx + field_4], edx           # 004254ef
    mov eax, dword ptr [ebp - local_814]         # 004254f2
    mov dword ptr [eax + field_34], 0x0          # 004254f8
    mov ecx, dword ptr [ebp - local_814]         # 004254ff
    mov dword ptr [ecx + field_38], 0x0          # 00425505
    mov edx, dword ptr [ebp - local_814]         # 0042550c
    mov dword ptr [edx + field_44], 0x0          # 00425512
    mov eax, dword ptr [ebp - local_814]         # 00425519
    mov ecx, dword ptr [ebp - local_818]         # 0042551f
    mov dword ptr [eax + field_48], ecx          # 00425525
    mov edx, dword ptr [ebp - local_814]         # 00425528
    mov dword ptr [ebp - local_83c], edx         # 0042552e
    jmp.d32 L_004255cf                           # 00425534
L_00425539:
    # block 0x00425539: entered by jne at 0x004254e1, 2 instruction(s), ends with je to 0x00425597 (forward)
    cmp dword ptr [ebp - local_83c], 0x0         # 00425539
    je.d8 L_00425597                             # 00425540
    # block 0x00425542: entered by fall-through of je at 0x00425540, 16 instruction(s), ends with forward jump to 0x004255cf
    mov eax, dword ptr [ebp - local_83c]         # 00425542
    mov ecx, dword ptr [ebp - local_814]         # 00425548
    mov dword ptr [eax + field_38], ecx          # 0042554e
    mov edx, dword ptr [ebp - local_814]         # 00425551
    mov eax, dword ptr [ebp - local_83c]         # 00425557
    mov dword ptr [edx + field_34], eax          # 0042555d
    mov ecx, dword ptr [ebp - local_814]         # 00425560
    mov dword ptr [ecx + field_38], 0x0          # 00425566
    mov edx, dword ptr [ebp - local_814]         # 0042556d
    mov eax, dword ptr [ebp - local_818]         # 00425573
    mov dword ptr [edx + field_48], eax          # 00425579
    mov ecx, dword ptr [ebp - local_814]         # 0042557c
    mov dword ptr [ecx + field_44], 0x0          # 00425582
    mov edx, dword ptr [ebp - local_814]         # 00425589
    mov dword ptr [ebp - local_83c], edx         # 0042558f
    jmp.d8 L_004255cf                            # 00425595
L_00425597:
    # block 0x00425597: entered by je at 0x00425540, 16 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x00425b72
    mov eax, dword ptr [ebp - local_820]         # 00425597
    mov ecx, dword ptr [eax + field_34]          # 0042559d
    push ecx                                     # 004255a0
    mov edx, dword ptr [ebp + arg_8]             # 004255a1
    {load} xor eax, eax                          # 004255a4
    mov al, byte ptr [edx + field_30]            # 004255a6
    push eax                                     # 004255a9
    mov ecx, dword ptr [0x5bb57b]                # 004255aa
    push ecx                                     # 004255b0
    mov edx, dword ptr [ebp - local_81c]         # 004255b1
    push edx                                     # 004255b7
    push 0x54508c                                # 004255b8
    push 0x63888b                                # 004255bd
    call FUN_0050ca3e                            # 004255c2
    add esp, 0x18                                # 004255c7
    jmp.d32 L_00425b72                           # 004255ca
L_004255cf:
    # block 0x004255cf: entered by jmp at 0x00425534; jmp at 0x00425595, 41 instruction(s), ends with jne to 0x004256af (forward)
    mov eax, dword ptr [ebp - local_814]         # 004255cf
    mov dword ptr [eax], 0x2                     # 004255d5
    mov ecx, dword ptr [ebp - local_814]         # 004255db
    mov dword ptr [ecx + field_4], 0x0           # 004255e1
    mov edx, dword ptr [ebp - local_814]         # 004255e8
    mov eax, dword ptr [ebp - local_828]         # 004255ee
    mov cx, word ptr [eax]                       # 004255f4
    mov word ptr [edx + field_10], cx            # 004255f7
    mov edx, dword ptr [ebp - local_814]         # 004255fb
    mov eax, dword ptr [ebp - local_828]         # 00425601
    mov cx, word ptr [eax + field_2]             # 00425607
    mov word ptr [edx + field_12], cx            # 0042560b
    mov edx, dword ptr [ebp - local_814]         # 0042560f
    mov eax, dword ptr [ebp - local_828]         # 00425615
    mov cx, word ptr [eax + field_4]             # 0042561b
    mov word ptr [edx + field_14], cx            # 0042561f
    mov edx, dword ptr [ebp - local_814]         # 00425623
    mov dword ptr [edx + field_20], 0x0          # 00425629
    mov eax, dword ptr [ebp - local_814]         # 00425630
    mov dword ptr [eax + field_24], 0x0          # 00425636
    mov ecx, dword ptr [ebp - local_814]         # 0042563d
    mov dword ptr [ecx + field_28], 0x0          # 00425643
    mov edx, dword ptr [ebp - local_814]         # 0042564a
    mov eax, dword ptr [ebp - local_840]         # 00425650
    mov ecx, dword ptr [eax + field_608]         # 00425656
    mov dword ptr [edx + field_c], ecx           # 0042565c
    mov edx, dword ptr [ebp - local_840]         # 0042565f
    mov eax, dword ptr [edx + field_608]         # 00425665
    add eax, 0x1                                 # 0042566b
    mov ecx, dword ptr [ebp - local_840]         # 0042566e
    mov dword ptr [ecx + field_608], eax         # 00425674
    mov edx, dword ptr [ebp - local_828]         # 0042567a
    mov eax, dword ptr [ebp - local_814]         # 00425680
    mov ecx, dword ptr [edx + field_8]           # 00425686
    mov dword ptr [eax + field_18], ecx          # 00425689
    mov edx, dword ptr [edx + field_c]           # 0042568c
    mov dword ptr [eax + field_1c], edx          # 0042568f
    mov eax, dword ptr [ebp - local_828]         # 00425692
    movsx ecx, word ptr [eax + field_6]          # 00425698
    cmp ecx, 0x1                                 # 0042569c
    jne.d8 L_004256af                            # 0042569f
    # block 0x004256a1: entered by fall-through of jne at 0x0042569f, 3 instruction(s), ends with forward jump to 0x004256bb
    mov edx, dword ptr [ebp - local_814]         # 004256a1
    mov word ptr [edx + field_16], 0x1           # 004256a7
    jmp.d8 L_004256bb                            # 004256ad
L_004256af:
    # block 0x004256af: entered by jne at 0x0042569f, 2 instruction(s), falls into the block at 0x004256bb
    mov eax, dword ptr [ebp - local_814]         # 004256af
    mov word ptr [eax + field_16], 0x0           # 004256b5
L_004256bb:
    # block 0x004256bb: entered by jmp at 0x004256ad, 4 instruction(s), ends with jne to 0x00425746 (forward)
    mov ecx, dword ptr [ebp - local_814]         # 004256bb
    movsx edx, word ptr [ecx + field_10]         # 004256c1
    cmp edx, 0x6                                 # 004256c5
    jne.d8 L_00425746                            # 004256c8
    # block 0x004256ca: entered by fall-through of jne at 0x004256c8, 4 instruction(s), ends with jne to 0x0042571f (forward)
    mov eax, dword ptr [ebp - local_814]         # 004256ca
    movsx ecx, word ptr [eax + field_14]         # 004256d0
    cmp ecx, 0x3                                 # 004256d4
    jne.d8 L_0042571f                            # 004256d7
    # block 0x004256d9: entered by fall-through of jne at 0x004256d7, 17 instruction(s), ends with forward jump to 0x00425741
    mov edx, dword ptr [ebp - local_828]         # 004256d9
    movsx eax, word ptr [edx + field_8]          # 004256df
    imul eax, eax, 0x3c                          # 004256e3
    mov ecx, dword ptr [ebp - local_828]         # 004256e6
    movsx edx, word ptr [ecx + field_a]          # 004256ec
    {load} add eax, edx                          # 004256f0
    mov ecx, dword ptr [ebp - local_814]         # 004256f2
    mov dword ptr [ecx + field_24], eax          # 004256f8
    mov edx, dword ptr [ebp - local_828]         # 004256fb
    movsx eax, word ptr [edx + field_c]          # 00425701
    imul eax, eax, 0x3c                          # 00425705
    mov ecx, dword ptr [ebp - local_828]         # 00425708
    movsx edx, word ptr [ecx + field_e]          # 0042570e
    {load} add eax, edx                          # 00425712
    mov ecx, dword ptr [ebp - local_814]         # 00425714
    mov dword ptr [ecx + field_28], eax          # 0042571a
    jmp.d8 L_00425741                            # 0042571d
L_0042571f:
    # block 0x0042571f: entered by jne at 0x004256d7, 8 instruction(s), falls into the block at 0x00425741
    mov edx, dword ptr [ebp - local_828]         # 0042571f
    movsx eax, word ptr [edx + field_8]          # 00425725
    imul eax, eax, 0x3c                          # 00425729
    mov ecx, dword ptr [ebp - local_828]         # 0042572c
    movsx edx, word ptr [ecx + field_a]          # 00425732
    {load} add eax, edx                          # 00425736
    mov ecx, dword ptr [ebp - local_814]         # 00425738
    mov dword ptr [ecx + field_20], eax          # 0042573e
L_00425741:
    # block 0x00425741: entered by jmp at 0x0042571d, 1 instruction(s), ends with forward jump to 0x0042582e
    jmp.d32 L_0042582e                           # 00425741
L_00425746:
    # block 0x00425746: entered by jne at 0x004256c8, 4 instruction(s), ends with jl to 0x004257d6 (forward)
    mov edx, dword ptr [ebp - local_828]         # 00425746
    movsx eax, word ptr [edx + field_c]          # 0042574c
    cmp eax, 0x1388                              # 00425750
    jl.d8 L_004257d6                             # 00425755
    # block 0x00425757: entered by fall-through of jl at 0x00425755, 4 instruction(s), ends with je to 0x00425775 (forward)
    mov ecx, dword ptr [ebp - local_814]         # 00425757
    movsx edx, word ptr [ecx + field_10]         # 0042575d
    cmp edx, 0xe                                 # 00425761
    je.d8 L_00425775                             # 00425764
    # block 0x00425766: entered by fall-through of je at 0x00425764, 4 instruction(s), ends with jne to 0x004257d6 (forward)
    mov eax, dword ptr [ebp - local_814]         # 00425766
    movsx ecx, word ptr [eax + field_10]         # 0042576c
    cmp ecx, 0xd                                 # 00425770
    jne.d8 L_004257d6                            # 00425773
L_00425775:
    # block 0x00425775: entered by je at 0x00425764; fall-through of jne at 0x00425773, 20 instruction(s), ends with forward jump to 0x0042582e
    mov edx, dword ptr [ebp - local_828]         # 00425775
    movsx eax, word ptr [edx + field_c]          # 0042577b
    mov cx, word ptr [2*eax + 0x5adb81]          # 0042577f
    mov word ptr [ebp - local_830], cx           # 00425787
    mov edx, dword ptr [ebp - local_828]         # 0042578e
    movsx eax, word ptr [edx + field_8]          # 00425794
    imul eax, eax, 0x36ee80                      # 00425798
    mov ecx, dword ptr [ebp - local_828]         # 0042579e
    movsx edx, word ptr [ecx + field_a]          # 004257a4
    imul edx, edx, 0xea60                        # 004257a8
    {load} add eax, edx                          # 004257ae
    movsx ecx, word ptr [ebp - local_830]        # 004257b0
    imul ecx, ecx, 0x3e8                         # 004257b7
    {load} add eax, ecx                          # 004257bd
    mov edx, dword ptr [ebp - local_828]         # 004257bf
    movsx ecx, word ptr [edx + field_e]          # 004257c5
    {load} add eax, ecx                          # 004257c9
    mov edx, dword ptr [ebp - local_814]         # 004257cb
    mov dword ptr [edx + field_20], eax          # 004257d1
    jmp.d8 L_0042582e                            # 004257d4
L_004257d6:
    # block 0x004257d6: entered by jl at 0x00425755; jne at 0x00425773, 4 instruction(s), ends with je to 0x0042582e (forward)
    mov eax, dword ptr [ebp - local_814]         # 004257d6
    movsx ecx, word ptr [eax + field_10]         # 004257dc
    cmp ecx, 0x9                                 # 004257e0
    je.d8 L_0042582e                             # 004257e3
    # block 0x004257e5: entered by fall-through of je at 0x004257e3, 16 instruction(s), falls into the block at 0x0042582e
    mov edx, dword ptr [ebp - local_828]         # 004257e5
    movsx eax, word ptr [edx + field_8]          # 004257eb
    imul eax, eax, 0x36ee80                      # 004257ef
    mov ecx, dword ptr [ebp - local_828]         # 004257f5
    movsx edx, word ptr [ecx + field_a]          # 004257fb
    imul edx, edx, 0xea60                        # 004257ff
    {load} add eax, edx                          # 00425805
    mov ecx, dword ptr [ebp - local_828]         # 00425807
    movsx edx, word ptr [ecx + field_c]          # 0042580d
    imul edx, edx, 0x3e8                         # 00425811
    {load} add eax, edx                          # 00425817
    mov ecx, dword ptr [ebp - local_828]         # 00425819
    movsx edx, word ptr [ecx + field_e]          # 0042581f
    {load} add eax, edx                          # 00425823
    mov ecx, dword ptr [ebp - local_814]         # 00425825
    mov dword ptr [ecx + field_20], eax          # 0042582b
L_0042582e:
    # block 0x0042582e: entered by jmp at 0x00425741; jmp at 0x004257d4; je at 0x004257e3, 4 instruction(s), ends with jne to 0x004258bc (forward)
    mov edx, dword ptr [ebp - local_814]         # 0042582e
    movsx eax, word ptr [edx + field_10]         # 00425834
    cmp eax, 0xb                                 # 00425838
    jne.d8 L_004258bc                            # 0042583b
    # block 0x0042583d: entered by fall-through of jne at 0x0042583b, 7 instruction(s), ends with jne to 0x0042588c (forward)
    mov ecx, dword ptr [ebp - local_820]         # 0042583d
    mov edx, dword ptr [ecx + field_30]          # 00425843
    add edx, 0x1                                 # 00425846
    mov eax, dword ptr [ebp - local_820]         # 00425849
    mov dword ptr [eax + field_30], edx          # 0042584f
    cmp dword ptr [ebp - local_8], 0x0           # 00425852
    jne.d8 L_0042588c                            # 00425856
    # block 0x00425858: entered by fall-through of jne at 0x00425856, 10 instruction(s), ends with forward jump to 0x004258ba
    mov ecx, dword ptr [ebp - local_814]         # 00425858
    mov dword ptr [ecx + field_3c], 0x0          # 0042585e
    mov edx, dword ptr [ebp - local_814]         # 00425865
    mov dword ptr [edx + field_40], 0x0          # 0042586b
    mov eax, dword ptr [ebp - local_814]         # 00425872
    mov dword ptr [ebp - local_8], eax           # 00425878
    mov ecx, dword ptr [ebp - local_820]         # 0042587b
    mov edx, dword ptr [ebp - local_814]         # 00425881
    mov dword ptr [ecx + field_1c], edx          # 00425887
    jmp.d8 L_004258ba                            # 0042588a
L_0042588c:
    # block 0x0042588c: entered by jne at 0x00425856, 10 instruction(s), falls into the block at 0x004258ba
    mov eax, dword ptr [ebp - local_8]           # 0042588c
    mov ecx, dword ptr [ebp - local_814]         # 0042588f
    mov dword ptr [eax + field_40], ecx          # 00425895
    mov edx, dword ptr [ebp - local_814]         # 00425898
    mov eax, dword ptr [ebp - local_8]           # 0042589e
    mov dword ptr [edx + field_3c], eax          # 004258a1
    mov ecx, dword ptr [ebp - local_814]         # 004258a4
    mov dword ptr [ecx + field_40], 0x0          # 004258aa
    mov edx, dword ptr [ebp - local_814]         # 004258b1
    mov dword ptr [ebp - local_8], edx           # 004258b7
L_004258ba:
    # block 0x004258ba: entered by jmp at 0x0042588a, 1 instruction(s), ends with forward jump to 0x004258eb
    jmp.d8 L_004258eb                            # 004258ba
L_004258bc:
    # block 0x004258bc: entered by jne at 0x0042583b, 9 instruction(s), falls into the block at 0x004258eb
    mov eax, dword ptr [ebp - local_820]         # 004258bc
    mov ecx, dword ptr [eax + field_2c]          # 004258c2
    add ecx, 0x1                                 # 004258c5
    mov edx, dword ptr [ebp - local_820]         # 004258c8
    mov dword ptr [edx + field_2c], ecx          # 004258ce
    mov eax, dword ptr [ebp - local_814]         # 004258d1
    mov dword ptr [eax + field_3c], 0x0          # 004258d7
    mov ecx, dword ptr [ebp - local_814]         # 004258de
    mov dword ptr [ecx + field_40], 0x0          # 004258e4
L_004258eb:
    # block 0x004258eb: entered by jmp at 0x004258ba, 8 instruction(s), ends with je to 0x00425a78 (forward)
    mov edx, dword ptr [ebp - local_818]         # 004258eb
    mov eax, dword ptr [edx + field_18]          # 004258f1
    add eax, 0x1                                 # 004258f4
    mov ecx, dword ptr [ebp - local_818]         # 004258f7
    mov dword ptr [ecx + field_18], eax          # 004258fd
    movsx edx, word ptr [0x63a4cd]               # 00425900
    test edx, edx                                # 00425907
    je.d32 L_00425a78                            # 00425909
    # block 0x0042590f: entered by fall-through of je at 0x00425909, 39 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, ends with jg to 0x004259d2 (forward)
    mov eax, dword ptr [ebp - local_81c]         # 0042590f
    push eax                                     # 00425915
    mov ecx, dword ptr [ebp - local_814]         # 00425916
    mov edx, dword ptr [ecx + field_c]           # 0042591c
    push edx                                     # 0042591f
    mov eax, dword ptr [ebp - local_818]         # 00425920
    mov ecx, dword ptr [eax + field_8]           # 00425926
    push ecx                                     # 00425929
    push 0x545118                                # 0042592a
    push 0x63888b                                # 0042592f
    call FUN_0050ca3e                            # 00425934
    add esp, 0x14                                # 00425939
    push 0x63888b                                # 0042593c
    call FUN_0044a2b7                            # 00425941
    add esp, 0x4                                 # 00425946
    mov edx, dword ptr [ebp - local_814]         # 00425949
    movsx eax, word ptr [edx + field_10]         # 0042594f
    push eax                                     # 00425953
    push 0x545154                                # 00425954
    push 0x63888b                                # 00425959
    call FUN_0050ca3e                            # 0042595e
    add esp, 0xc                                 # 00425963
    push 0x63888b                                # 00425966
    call FUN_0044a2b7                            # 0042596b
    add esp, 0x4                                 # 00425970
    mov ecx, dword ptr [ebp - local_814]         # 00425973
    movsx edx, word ptr [ecx + field_12]         # 00425979
    push edx                                     # 0042597d
    push 0x545168                                # 0042597e
    push 0x63888b                                # 00425983
    call FUN_0050ca3e                            # 00425988
    add esp, 0xc                                 # 0042598d
    push 0x63888b                                # 00425990
    call FUN_0044a2b7                            # 00425995
    add esp, 0x4                                 # 0042599a
    mov eax, dword ptr [ebp - local_814]         # 0042599d
    movsx ecx, word ptr [eax + field_14]         # 004259a3
    cmp ecx, 0x7                                 # 004259a7
    jg.d8 L_004259d2                             # 004259aa
    # block 0x004259ac: entered by fall-through of jg at 0x004259aa, 9 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x004259ef
    mov edx, dword ptr [ebp - local_814]         # 004259ac
    movsx eax, word ptr [edx + field_14]         # 004259b2
    mov ecx, dword ptr [4*eax + 0x544400]        # 004259b6
    push ecx                                     # 004259bd
    push 0x54517c                                # 004259be
    push 0x63888b                                # 004259c3
    call FUN_0050ca3e                            # 004259c8
    add esp, 0xc                                 # 004259cd
    jmp.d8 L_004259ef                            # 004259d0
L_004259d2:
    # block 0x004259d2: entered by jg at 0x004259aa, 7 instruction(s), calls FUN_0050ca3e, falls into the block at 0x004259ef
    mov edx, dword ptr [ebp - local_814]         # 004259d2
    movsx eax, word ptr [edx + field_14]         # 004259d8
    push eax                                     # 004259dc
    push 0x545190                                # 004259dd
    push 0x63888b                                # 004259e2
    call FUN_0050ca3e                            # 004259e7
    add esp, 0xc                                 # 004259ec
L_004259ef:
    # block 0x004259ef: entered by jmp at 0x004259d0, 33 instruction(s), calls FUN_0044a2b7, FUN_0050ca3e, falls into the block at 0x00425a78
    push 0x63888b                                # 004259ef
    call FUN_0044a2b7                            # 004259f4
    add esp, 0x4                                 # 004259f9
    mov ecx, dword ptr [ebp - local_814]         # 004259fc
    movsx edx, word ptr [ecx + field_16]         # 00425a02
    mov eax, dword ptr [4*edx + 0x5443e0]        # 00425a06
    push eax                                     # 00425a0d
    push 0x5451a4                                # 00425a0e
    push 0x63888b                                # 00425a13
    call FUN_0050ca3e                            # 00425a18
    add esp, 0xc                                 # 00425a1d
    push 0x63888b                                # 00425a20
    call FUN_0044a2b7                            # 00425a25
    add esp, 0x4                                 # 00425a2a
    mov ecx, dword ptr [ebp - local_814]         # 00425a2d
    movsx edx, word ptr [ecx + field_1e]         # 00425a33
    push edx                                     # 00425a37
    mov eax, dword ptr [ebp - local_814]         # 00425a38
    movsx ecx, word ptr [eax + field_1c]         # 00425a3e
    push ecx                                     # 00425a42
    mov edx, dword ptr [ebp - local_814]         # 00425a43
    movsx eax, word ptr [edx + field_1a]         # 00425a49
    push eax                                     # 00425a4d
    mov ecx, dword ptr [ebp - local_814]         # 00425a4e
    movsx edx, word ptr [ecx + field_18]         # 00425a54
    push edx                                     # 00425a58
    push 0x5451b8                                # 00425a59
    push 0x63888b                                # 00425a5e
    call FUN_0050ca3e                            # 00425a63
    add esp, 0x18                                # 00425a68
    push 0x63888b                                # 00425a6b
    call FUN_0044a2b7                            # 00425a70
    add esp, 0x4                                 # 00425a75
L_00425a78:
    # block 0x00425a78: entered by jmp at 0x00425336; jmp at 0x004254c1; je at 0x00425909, 1 instruction(s), ends with backward jump to 0x00424ef5
    jmp.d32 L_00424ef5                           # 00425a78
L_00425a7d:
    # block 0x00425a7d: entered by jge at 0x00424f13, 3 instruction(s), ends with je to 0x00425b3e (forward)
    movsx eax, word ptr [0x63a4cd]               # 00425a7d
    test eax, eax                                # 00425a84
    je.d32 L_00425b3e                            # 00425a86
    # block 0x00425a8c: entered by fall-through of je at 0x00425a86, 41 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, FUN_004234c8, FUN_00425b8b, falls into the block at 0x00425b3e
    mov ecx, dword ptr [ebp - local_820]         # 00425a8c
    mov edx, dword ptr [ecx + field_30]          # 00425a92
    push edx                                     # 00425a95
    mov eax, dword ptr [ebp - local_820]         # 00425a96
    mov ecx, dword ptr [eax + field_2c]          # 00425a9c
    push ecx                                     # 00425a9f
    mov edx, dword ptr [ebp - local_820]         # 00425aa0
    mov eax, dword ptr [edx + field_28]          # 00425aa6
    push eax                                     # 00425aa9
    push 0x5451d4                                # 00425aaa
    push 0x63888b                                # 00425aaf
    call FUN_0050ca3e                            # 00425ab4
    add esp, 0x14                                # 00425ab9
    push 0x63888b                                # 00425abc
    call FUN_0044a2b7                            # 00425ac1
    add esp, 0x4                                 # 00425ac6
    mov ecx, dword ptr [ebp - local_820]         # 00425ac9
    mov edx, dword ptr [ecx + field_34]          # 00425acf
    push edx                                     # 00425ad2
    push 0x545218                                # 00425ad3
    push 0x63888b                                # 00425ad8
    call FUN_0050ca3e                            # 00425add
    add esp, 0xc                                 # 00425ae2
    push 0x63888b                                # 00425ae5
    call FUN_0044a2b7                            # 00425aea
    add esp, 0x4                                 # 00425aef
    mov ecx, dword ptr [ebp - local_840]         # 00425af2
    call FUN_004234c8                            # 00425af8
    mov eax, dword ptr [ebp - local_840]         # 00425afd
    mov dword ptr [eax + field_610], 0x0         # 00425b03
    mov ecx, dword ptr [ebp - local_838]         # 00425b0d
    push ecx                                     # 00425b13
    mov ecx, dword ptr [ebp - local_840]         # 00425b14
    call FUN_00425b8b                            # 00425b1a
    push 0x545240                                # 00425b1f
    push 0x63888b                                # 00425b24
    call FUN_0050ca3e                            # 00425b29
    add esp, 0x8                                 # 00425b2e
    push 0x63888b                                # 00425b31
    call FUN_0044a2b7                            # 00425b36
    add esp, 0x4                                 # 00425b3b
L_00425b3e:
    # block 0x00425b3e: entered by je at 0x00425a86, 1 instruction(s), ends with forward jump to 0x00425b84
    jmp.d8 L_00425b84                            # 00425b3e
L_00425b40:
    # block 0x00425b40: entered by jmp at 0x00425b72; jmp at 0x00425b74; jmp at 0x00425b76; jmp at 0x00425b78; more, 7 instruction(s), calls FUN_0052139c, ends with je to 0x00425b66 (forward)
    push 0x0                                     # 00425b40
    push 0x0                                     # 00425b42
    push 0x63888b                                # 00425b44
    call FUN_0052139c                            # 00425b49
    movsx edx, word ptr [0x63a4cd]               # 00425b4e
    test edx, edx                                # 00425b55
    je.d8 L_00425b66                             # 00425b57
    # block 0x00425b59: entered by fall-through of je at 0x00425b57, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00425b66
    push 0x63888b                                # 00425b59
    call FUN_0044a2b7                            # 00425b5e
    add esp, 0x4                                 # 00425b63
L_00425b66:
    # block 0x00425b66: entered by je at 0x00425b57, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x00425b84
    mov ecx, 0x5cf659                            # 00425b66
    call FUN_004c97b4                            # 00425b6b
    jmp.d8 L_00425b84                            # 00425b70
L_00425b72:
    # block 0x00425b72: entered by jmp at 0x004255ca, 1 instruction(s), ends with backward jump to 0x00425b40
    jmp.d8 L_00425b40                            # 00425b72
L_00425b74:
    # block 0x00425b74: entered by jmp at 0x004254a1, 1 instruction(s), ends with backward jump to 0x00425b40
    jmp.d8 L_00425b40                            # 00425b74
L_00425b76:
    # block 0x00425b76: entered by jmp at 0x00425135, 1 instruction(s), ends with backward jump to 0x00425b40
    jmp.d8 L_00425b40                            # 00425b76
L_00425b78:
    # block 0x00425b78: entered by jmp at 0x00424e93, 1 instruction(s), ends with backward jump to 0x00425b40
    jmp.d8 L_00425b40                            # 00425b78
L_00425b7a:
    # block 0x00425b7a: entered by jmp at 0x00424e53, 1 instruction(s), ends with backward jump to 0x00425b40
    jmp.d8 L_00425b40                            # 00425b7a
L_00425b7c:
    # block 0x00425b7c: entered by jmp at 0x00424dbd, 1 instruction(s), ends with backward jump to 0x00425b40
    jmp.d8 L_00425b40                            # 00425b7c
L_00425b7e:
    # block 0x00425b7e: entered by jmp at 0x00424d60, 1 instruction(s), ends with backward jump to 0x00425b40
    jmp.d8 L_00425b40                            # 00425b7e
L_00425b80:
    # block 0x00425b80: entered by jmp at 0x00424c8f, 1 instruction(s), ends with backward jump to 0x00425b40
    jmp.d8 L_00425b40                            # 00425b80
L_00425b82:
    # block 0x00425b82: entered by jmp at 0x00424bfe, 1 instruction(s), ends with backward jump to 0x00425b40
    jmp.d8 L_00425b40                            # 00425b82
L_00425b84:
    # block 0x00425b84: entered by jmp at 0x00424c31; jmp at 0x00425b3e; jmp at 0x00425b70, 4 instruction(s), ends with ret 0x10
    pop edi                                      # 00425b84
    {load} mov esp, ebp                          # 00425b85
    pop ebp                                      # 00425b87
    ret 0x10                                     # 00425b88

