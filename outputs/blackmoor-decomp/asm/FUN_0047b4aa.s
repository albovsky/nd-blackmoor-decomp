# FUN_0047b4aa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047b4aa
# extent:       0x0047b4aa-0x0047b709 (607 code bytes)
# span:         0x0047b4aa-0x0047b709 (code 607, tables 0, padding 0)
# sha256:       976f6a0d3a04cea1356a2ae7b88f6276cafc011c9c54350834944bed000591df
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047b4aa
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_c, field_14, field_24, field_111, field_115, field_119, field_11d, field_27c, field_28c, field_2a1, field_2b4; [ecx + n] field_4, field_8, field_c, field_14, field_28, field_27c, field_280, field_28c, field_2a1, field_2b4; [edx + n] field_8, field_c, field_2c, field_28c, field_2a1, field_2b4, field_35b
# callees:      calls FUN_0047b709
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 159 instruction(s), 16 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ field_14, 0x14  # offset +0x14
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_111, 0x111  # offset +0x111
.equ field_115, 0x115  # offset +0x115
.equ field_119, 0x119  # offset +0x119
.equ field_11d, 0x11d  # offset +0x11d
.equ field_27c, 0x27c  # offset +0x27c
.equ field_280, 0x280  # offset +0x280
.equ field_28c, 0x28c  # offset +0x28c
.equ field_2a1, 0x2a1  # offset +0x2a1
.equ field_2b4, 0x2b4  # offset +0x2b4
.equ field_35b, 0x35b  # offset +0x35b

# --- external targets -----------------------------------------------
.set FUN_0047b709, .text + (0x0047b709 - 0x401000)

.org 0x0047b4aa - 0x401000
.globl FUN_0047b4aa
FUN_0047b4aa:
    # block 0x0047b4aa: entry, 7 instruction(s), ends with je to 0x0047b701 (forward)
    push ebp                                     # 0047b4aa
    {load} mov ebp, esp                          # 0047b4ab
    sub esp, 0x8                                 # 0047b4ad
    mov dword ptr [ebp - local_8], ecx           # 0047b4b0
    mov eax, dword ptr [ebp - local_8]           # 0047b4b3
    cmp dword ptr [eax + field_24], 0x0          # 0047b4b6
    je.d32 L_0047b701                            # 0047b4ba
    # block 0x0047b4c0: entered by fall-through of je at 0x0047b4ba, 3 instruction(s), ends with jne to 0x0047b701 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0047b4c0
    cmp dword ptr [ecx + field_28], 0x0          # 0047b4c3
    jne.d32 L_0047b701                           # 0047b4c7
    # block 0x0047b4cd: entered by fall-through of jne at 0x0047b4c7, 3 instruction(s), ends with jne to 0x0047b701 (forward)
    mov edx, dword ptr [ebp - local_8]           # 0047b4cd
    cmp dword ptr [edx + field_2c], 0x0          # 0047b4d0
    jne.d32 L_0047b701                           # 0047b4d4
    # block 0x0047b4da: entered by fall-through of jne at 0x0047b4d4, 7 instruction(s), ends with je to 0x0047b5e7 (forward)
    mov eax, dword ptr [ebp - local_8]           # 0047b4da
    mov dword ptr [eax + field_27c], 0xffffffff  # 0047b4dd
    mov ecx, dword ptr [ebp - local_8]           # 0047b4e7
    mov edx, dword ptr [ecx + field_c]           # 0047b4ea
    movsx eax, byte ptr [edx + field_35b]        # 0047b4ed
    test eax, eax                                # 0047b4f4
    je.d32 L_0047b5e7                            # 0047b4f6
    # block 0x0047b4fc: entered by fall-through of je at 0x0047b4f6, 2 instruction(s), ends with forward jump to 0x0047b50e
    mov dword ptr [ebp - local_4], 0x0           # 0047b4fc
    jmp.d8 L_0047b50e                            # 0047b503
L_0047b505:
    # block 0x0047b505: entered by jmp at 0x0047b5e2, 3 instruction(s), falls into the block at 0x0047b50e
    mov ecx, dword ptr [ebp - local_4]           # 0047b505
    add ecx, 0x1                                 # 0047b508
    mov dword ptr [ebp - local_4], ecx           # 0047b50b
L_0047b50e:
    # block 0x0047b50e: entered by jmp at 0x0047b503, 2 instruction(s), ends with jge to 0x0047b5e7 (forward)
    cmp dword ptr [ebp - local_4], 0x3           # 0047b50e
    jge.d32 L_0047b5e7                           # 0047b512
    # block 0x0047b518: entered by fall-through of jge at 0x0047b512, 11 instruction(s), ends with jl to 0x0047b5e2 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0047b518
    mov eax, dword ptr [ebp - local_8]           # 0047b51c
    mov ecx, dword ptr [eax + field_c]           # 0047b51f
    mov eax, dword ptr [ebp - local_8]           # 0047b522
    mov eax, dword ptr [eax + field_28c]         # 0047b525
    imul eax, eax, 0x30                          # 0047b52b
    lea ecx, [ecx + eax + field_2a1]             # 0047b52e
    mov eax, dword ptr [ebp - local_4]           # 0047b535
    shl eax, 0x4                                 # 0047b538
    cmp edx, dword ptr [ecx + eax + field_4]     # 0047b53b
    jl.d32 L_0047b5e2                            # 0047b53f
    # block 0x0047b545: entered by fall-through of jl at 0x0047b53f, 11 instruction(s), ends with jg to 0x0047b5e2 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0047b545
    mov edx, dword ptr [ebp - local_8]           # 0047b549
    mov eax, dword ptr [edx + field_c]           # 0047b54c
    mov edx, dword ptr [ebp - local_8]           # 0047b54f
    mov edx, dword ptr [edx + field_28c]         # 0047b552
    imul edx, edx, 0x30                          # 0047b558
    lea eax, [eax + edx + field_2a1]             # 0047b55b
    mov edx, dword ptr [ebp - local_4]           # 0047b562
    shl edx, 0x4                                 # 0047b565
    cmp ecx, dword ptr [eax + edx + field_c]     # 0047b568
    jg.d8 L_0047b5e2                             # 0047b56c
    # block 0x0047b56e: entered by fall-through of jg at 0x0047b56c, 11 instruction(s), ends with jl to 0x0047b5e2 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0047b56e
    mov ecx, dword ptr [ebp - local_8]           # 0047b572
    mov edx, dword ptr [ecx + field_c]           # 0047b575
    mov ecx, dword ptr [ebp - local_8]           # 0047b578
    mov ecx, dword ptr [ecx + field_28c]         # 0047b57b
    imul ecx, ecx, 0x30                          # 0047b581
    lea edx, [edx + ecx + field_2a1]             # 0047b584
    mov ecx, dword ptr [ebp - local_4]           # 0047b58b
    shl ecx, 0x4                                 # 0047b58e
    cmp eax, dword ptr [edx + ecx]               # 0047b591
    jl.d8 L_0047b5e2                             # 0047b594
    # block 0x0047b596: entered by fall-through of jl at 0x0047b594, 11 instruction(s), ends with jg to 0x0047b5e2 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0047b596
    mov eax, dword ptr [ebp - local_8]           # 0047b59a
    mov ecx, dword ptr [eax + field_c]           # 0047b59d
    mov eax, dword ptr [ebp - local_8]           # 0047b5a0
    mov eax, dword ptr [eax + field_28c]         # 0047b5a3
    imul eax, eax, 0x30                          # 0047b5a9
    lea ecx, [ecx + eax + field_2a1]             # 0047b5ac
    mov eax, dword ptr [ebp - local_4]           # 0047b5b3
    shl eax, 0x4                                 # 0047b5b6
    cmp edx, dword ptr [ecx + eax + field_8]     # 0047b5b9
    jg.d8 L_0047b5e2                             # 0047b5bd
    # block 0x0047b5bf: entered by fall-through of jg at 0x0047b5bd, 8 instruction(s), calls FUN_0047b709, ends with forward jump to 0x0047b703
    mov ecx, dword ptr [ebp - local_8]           # 0047b5bf
    mov edx, dword ptr [ebp - local_4]           # 0047b5c2
    mov dword ptr [ecx + field_27c], edx         # 0047b5c5
    push 0x2768                                  # 0047b5cb
    mov ecx, dword ptr [ebp - local_8]           # 0047b5d0
    call FUN_0047b709                            # 0047b5d3
    mov eax, 0x1                                 # 0047b5d8
    jmp.d32 L_0047b703                           # 0047b5dd
L_0047b5e2:
    # block 0x0047b5e2: entered by jl at 0x0047b53f; jg at 0x0047b56c; jl at 0x0047b594; jg at 0x0047b5bd, 1 instruction(s), ends with backward jump to 0x0047b505
    jmp.d32 L_0047b505                           # 0047b5e2
L_0047b5e7:
    # block 0x0047b5e7: entered by je at 0x0047b4f6; jge at 0x0047b512, 2 instruction(s), ends with forward jump to 0x0047b5f9
    mov dword ptr [ebp - local_4], 0x0           # 0047b5e7
    jmp.d8 L_0047b5f9                            # 0047b5ee
L_0047b5f0:
    # block 0x0047b5f0: entered by jmp at 0x0047b6fc, 3 instruction(s), falls into the block at 0x0047b5f9
    mov eax, dword ptr [ebp - local_4]           # 0047b5f0
    add eax, 0x1                                 # 0047b5f3
    mov dword ptr [ebp - local_4], eax           # 0047b5f6
L_0047b5f9:
    # block 0x0047b5f9: entered by jmp at 0x0047b5ee, 4 instruction(s), ends with jge to 0x0047b701 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0047b5f9
    mov edx, dword ptr [ebp - local_4]           # 0047b5fc
    cmp edx, dword ptr [ecx + field_280]         # 0047b5ff
    jge.d32 L_0047b701                           # 0047b605
    # block 0x0047b60b: entered by fall-through of jge at 0x0047b605, 16 instruction(s), ends with jl to 0x0047b6fc (forward)
    mov eax, dword ptr [ebp - local_8]           # 0047b60b
    mov ecx, dword ptr [ebp - local_8]           # 0047b60e
    mov edx, dword ptr [eax + field_28c]         # 0047b611
    imul edx, dword ptr [ecx + field_280]        # 0047b617
    add edx, dword ptr [ebp - local_4]           # 0047b61e
    mov eax, dword ptr [ebp - local_8]           # 0047b621
    mov dword ptr [eax + field_2b4], edx         # 0047b624
    movsx ecx, word ptr [ebp + arg_c]            # 0047b62a
    mov edx, dword ptr [ebp - local_8]           # 0047b62e
    mov eax, dword ptr [edx + field_c]           # 0047b631
    mov edx, dword ptr [ebp - local_4]           # 0047b634
    shl edx, 0x4                                 # 0047b637
    mov eax, dword ptr [eax + edx + field_115]   # 0047b63a
    add eax, 0x3                                 # 0047b641
    {load} cmp ecx, eax                          # 0047b644
    jl.d32 L_0047b6fc                            # 0047b646
    # block 0x0047b64c: entered by fall-through of jl at 0x0047b646, 9 instruction(s), ends with jg to 0x0047b6fc (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0047b64c
    mov edx, dword ptr [ebp - local_8]           # 0047b650
    mov eax, dword ptr [edx + field_c]           # 0047b653
    mov edx, dword ptr [ebp - local_4]           # 0047b656
    shl edx, 0x4                                 # 0047b659
    mov eax, dword ptr [eax + edx + field_11d]   # 0047b65c
    sub eax, 0x3                                 # 0047b663
    {load} cmp ecx, eax                          # 0047b666
    jg.d32 L_0047b6fc                            # 0047b668
    # block 0x0047b66e: entered by fall-through of jg at 0x0047b668, 9 instruction(s), ends with jl to 0x0047b6fc (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0047b66e
    mov edx, dword ptr [ebp - local_8]           # 0047b672
    mov eax, dword ptr [edx + field_c]           # 0047b675
    mov edx, dword ptr [ebp - local_4]           # 0047b678
    shl edx, 0x4                                 # 0047b67b
    mov eax, dword ptr [eax + edx + field_111]   # 0047b67e
    add eax, 0x3                                 # 0047b685
    {load} cmp ecx, eax                          # 0047b688
    jl.d8 L_0047b6fc                             # 0047b68a
    # block 0x0047b68c: entered by fall-through of jl at 0x0047b68a, 9 instruction(s), ends with jg to 0x0047b6fc (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0047b68c
    mov edx, dword ptr [ebp - local_8]           # 0047b690
    mov eax, dword ptr [edx + field_c]           # 0047b693
    mov edx, dword ptr [ebp - local_4]           # 0047b696
    shl edx, 0x4                                 # 0047b699
    mov eax, dword ptr [eax + edx + field_119]   # 0047b69c
    sub eax, 0x3                                 # 0047b6a3
    {load} cmp ecx, eax                          # 0047b6a6
    jg.d8 L_0047b6fc                             # 0047b6a8
    # block 0x0047b6aa: entered by fall-through of jg at 0x0047b6a8, 7 instruction(s), ends with jne to 0x0047b6fc (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0047b6aa
    mov edx, dword ptr [ecx + field_2b4]         # 0047b6ad
    imul edx, edx, 0xc                           # 0047b6b3
    mov eax, dword ptr [ebp - local_8]           # 0047b6b6
    mov ecx, dword ptr [eax + field_14]          # 0047b6b9
    cmp dword ptr [ecx + edx + field_4], 0x0     # 0047b6bc
    jne.d8 L_0047b6fc                            # 0047b6c1
    # block 0x0047b6c3: entered by fall-through of jne at 0x0047b6c1, 7 instruction(s), ends with jne to 0x0047b6fc (forward)
    mov edx, dword ptr [ebp - local_8]           # 0047b6c3
    mov eax, dword ptr [edx + field_2b4]         # 0047b6c6
    imul eax, eax, 0xc                           # 0047b6cc
    mov ecx, dword ptr [ebp - local_8]           # 0047b6cf
    mov edx, dword ptr [ecx + field_14]          # 0047b6d2
    cmp dword ptr [edx + eax + field_8], 0x0     # 0047b6d5
    jne.d8 L_0047b6fc                            # 0047b6da
    # block 0x0047b6dc: entered by fall-through of jne at 0x0047b6da, 8 instruction(s), calls FUN_0047b709, ends with forward jump to 0x0047b703
    mov eax, dword ptr [ebp - local_8]           # 0047b6dc
    mov ecx, dword ptr [ebp - local_4]           # 0047b6df
    mov dword ptr [eax + field_27c], ecx         # 0047b6e2
    push 0x2769                                  # 0047b6e8
    mov ecx, dword ptr [ebp - local_8]           # 0047b6ed
    call FUN_0047b709                            # 0047b6f0
    mov eax, 0x1                                 # 0047b6f5
    jmp.d8 L_0047b703                            # 0047b6fa
L_0047b6fc:
    # block 0x0047b6fc: entered by jl at 0x0047b646; jg at 0x0047b668; jl at 0x0047b68a; jg at 0x0047b6a8; more, 1 instruction(s), ends with backward jump to 0x0047b5f0
    jmp.d32 L_0047b5f0                           # 0047b6fc
L_0047b701:
    # block 0x0047b701: entered by je at 0x0047b4ba; jne at 0x0047b4c7; jne at 0x0047b4d4; jge at 0x0047b605, 1 instruction(s), falls into the block at 0x0047b703
    {load} xor eax, eax                          # 0047b701
L_0047b703:
    # block 0x0047b703: entered by jmp at 0x0047b5dd; jmp at 0x0047b6fa, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 0047b703
    pop ebp                                      # 0047b705
    ret 0x8                                      # 0047b706

