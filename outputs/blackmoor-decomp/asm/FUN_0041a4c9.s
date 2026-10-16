# FUN_0041a4c9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041a4c9
# extent:       0x0041a4c9-0x0041aaa1 (1496 code bytes)
# span:         0x0041a4c9-0x0041aaa1 (code 1496, tables 0, padding 0)
# sha256:       188d8e1a4685f74214d536a34ec1aacc48afddbaa7abc13ef22e7888f0613954
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0041a4c9
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       14 ebp-relative slot(s): local_64, local_68, local_6c, local_70, local_74, local_88, local_8c, local_90, local_94, local_98, local_9c, local_a0 and 2 more
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050d0a9, FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, FUN_0041b925, FUN_0050d536, FUN_0041b992, FUN_0050d4f5, FUN_0041bbd9, FUN_0050cee4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 326 instruction(s), 20 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_64, 0x64  # offset -0x64
.equ local_68, 0x68  # offset -0x68
.equ local_6c, 0x6c  # offset -0x6c
.equ local_70, 0x70  # offset -0x70
.equ local_74, 0x74  # offset -0x74
.equ local_88, 0x88  # offset -0x88
.equ local_8c, 0x8c  # offset -0x8c
.equ local_90, 0x90  # offset -0x90
.equ local_94, 0x94  # offset -0x94
.equ local_98, 0x98  # offset -0x98
.equ local_9c, 0x9c  # offset -0x9c
.equ local_a0, 0xa0  # offset -0xa0
.equ local_a4, 0xa4  # offset -0xa4
.equ local_a8, 0xa8  # offset -0xa8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0041b925, .text + (0x0041b925 - 0x401000)
.set FUN_0041b992, .text + (0x0041b992 - 0x401000)
.set FUN_0041bbd9, .text + (0x0041bbd9 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cee4, .text + (0x0050cee4 - 0x401000)
.set FUN_0050d0a9, .text + (0x0050d0a9 - 0x401000)
.set FUN_0050d4f5, .text + (0x0050d4f5 - 0x401000)
.set FUN_0050d536, .text + (0x0050d536 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x0041a4c9 - 0x401000
.globl FUN_0041a4c9
FUN_0041a4c9:
    # block 0x0041a4c9: entry, 12 instruction(s), calls FUN_0050d0a9, ends with jne to 0x0041a524 (forward)
    push ebp                                     # 0041a4c9
    {load} mov ebp, esp                          # 0041a4ca
    sub esp, 0xa8                                # 0041a4cc
    mov dword ptr [ebp - local_a8], ecx          # 0041a4d2
    push 0x543150                                # 0041a4d8
    mov eax, dword ptr [ebp + arg_8]             # 0041a4dd
    push eax                                     # 0041a4e0
    call FUN_0050d0a9                            # 0041a4e1
    add esp, 0x8                                 # 0041a4e6
    mov dword ptr [ebp - local_98], eax          # 0041a4e9
    cmp dword ptr [ebp - local_98], 0x0          # 0041a4ef
    jne.d8 L_0041a524                            # 0041a4f6
    # block 0x0041a4f8: entered by fall-through of jne at 0x0041a4f6, 14 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x0041a524
    mov ecx, dword ptr [ebp + arg_8]             # 0041a4f8
    push ecx                                     # 0041a4fb
    push 0x543154                                # 0041a4fc
    lea edx, [ebp - local_64]                    # 0041a501
    push edx                                     # 0041a504
    call FUN_0050ca3e                            # 0041a505
    add esp, 0xc                                 # 0041a50a
    push 0x0                                     # 0041a50d
    push 0x0                                     # 0041a50f
    lea eax, [ebp - local_64]                    # 0041a511
    push eax                                     # 0041a514
    call FUN_0052139c                            # 0041a515
    mov ecx, 0x5cf659                            # 0041a51a
    call FUN_004c97b4                            # 0041a51f
L_0041a524:
    # block 0x0041a524: entered by jne at 0x0041a4f6, 8 instruction(s), calls FUN_0050d0a9, ends with jne to 0x0041a570 (forward)
    push 0x543164                                # 0041a524
    mov ecx, dword ptr [ebp + arg_c]             # 0041a529
    push ecx                                     # 0041a52c
    call FUN_0050d0a9                            # 0041a52d
    add esp, 0x8                                 # 0041a532
    mov dword ptr [ebp - local_8c], eax          # 0041a535
    cmp dword ptr [ebp - local_8c], 0x0          # 0041a53b
    jne.d8 L_0041a570                            # 0041a542
    # block 0x0041a544: entered by fall-through of jne at 0x0041a542, 14 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x0041a570
    mov edx, dword ptr [ebp + arg_c]             # 0041a544
    push edx                                     # 0041a547
    push 0x543168                                # 0041a548
    lea eax, [ebp - local_64]                    # 0041a54d
    push eax                                     # 0041a550
    call FUN_0050ca3e                            # 0041a551
    add esp, 0xc                                 # 0041a556
    push 0x0                                     # 0041a559
    push 0x0                                     # 0041a55b
    lea ecx, [ebp - local_64]                    # 0041a55d
    push ecx                                     # 0041a560
    call FUN_0052139c                            # 0041a561
    mov ecx, 0x5cf659                            # 0041a566
    call FUN_004c97b4                            # 0041a56b
L_0041a570:
    # block 0x0041a570: entered by jne at 0x0041a542, 12 instruction(s), calls FUN_0041b925, ends with forward jump to 0x0041a5c7
    mov byte ptr [ebp - local_74], 0x0           # 0041a570
    mov ecx, dword ptr [ebp - local_a8]          # 0041a574
    call FUN_0041b925                            # 0041a57a
    mov byte ptr [ebp - local_88], 0x0           # 0041a57f
    mov byte ptr [ebp - local_9c], 0x1           # 0041a586
    movzx dx, byte ptr [ebp - local_9c]          # 0041a58d
    mov word ptr [ebp - local_a4], dx            # 0041a595
    mov word ptr [ebp - local_6c], 0x0           # 0041a59c
    mov word ptr [ebp - local_68], 0xfee         # 0041a5a2
    mov ax, word ptr [ebp - local_6c]            # 0041a5a8
    mov word ptr [ebp - local_90], ax            # 0041a5ac
    jmp.d8 L_0041a5c7                            # 0041a5b3
L_0041a5b5:
    # block 0x0041a5b5: entered by jmp at 0x0041a5e4, 3 instruction(s), falls into the block at 0x0041a5c7
    mov cx, word ptr [ebp - local_90]            # 0041a5b5
    add cx, 0x1                                  # 0041a5bc
    mov word ptr [ebp - local_90], cx            # 0041a5c0
L_0041a5c7:
    # block 0x0041a5c7: entered by jmp at 0x0041a5b3, 4 instruction(s), ends with jge to 0x0041a5e6 (forward)
    movsx edx, word ptr [ebp - local_90]         # 0041a5c7
    movsx eax, word ptr [ebp - local_68]         # 0041a5ce
    {load} cmp edx, eax                          # 0041a5d2
    jge.d8 L_0041a5e6                            # 0041a5d4
    # block 0x0041a5d6: entered by fall-through of jge at 0x0041a5d4, 3 instruction(s), ends with backward jump to 0x0041a5b5
    movsx ecx, word ptr [ebp - local_90]         # 0041a5d6
    mov byte ptr [ecx + 0x56f354], 0x20          # 0041a5dd
    jmp.d8 L_0041a5b5                            # 0041a5e4
L_0041a5e6:
    # block 0x0041a5e6: entered by jge at 0x0041a5d4, 2 instruction(s), ends with forward jump to 0x0041a603
    mov word ptr [ebp - local_a0], 0x0           # 0041a5e6
    jmp.d8 L_0041a603                            # 0041a5ef
L_0041a5f1:
    # block 0x0041a5f1: entered by jmp at 0x0041a640, 3 instruction(s), falls into the block at 0x0041a603
    mov dx, word ptr [ebp - local_a0]            # 0041a5f1
    add dx, 0x1                                  # 0041a5f8
    mov word ptr [ebp - local_a0], dx            # 0041a5fc
L_0041a603:
    # block 0x0041a603: entered by jmp at 0x0041a5ef, 3 instruction(s), ends with jge to 0x0041a642 (forward)
    movsx eax, word ptr [ebp - local_a0]         # 0041a603
    cmp eax, 0x12                                # 0041a60a
    jge.d8 L_0041a642                            # 0041a60d
    # block 0x0041a60f: entered by fall-through of jge at 0x0041a60d, 8 instruction(s), calls FUN_0050d536, ends with je to 0x0041a642 (forward)
    mov ecx, dword ptr [ebp - local_98]          # 0041a60f
    push ecx                                     # 0041a615
    call FUN_0050d536                            # 0041a616
    add esp, 0x4                                 # 0041a61b
    mov word ptr [ebp - local_70], ax            # 0041a61e
    movsx edx, word ptr [ebp - local_70]         # 0041a622
    cmp edx, -0x1                                # 0041a626
    je.d8 L_0041a642                             # 0041a629
    # block 0x0041a62b: entered by fall-through of je at 0x0041a629, 5 instruction(s), ends with backward jump to 0x0041a5f1
    movsx eax, word ptr [ebp - local_68]         # 0041a62b
    movsx ecx, word ptr [ebp - local_a0]         # 0041a62f
    mov dl, byte ptr [ebp - local_70]            # 0041a636
    mov byte ptr [eax + ecx + 0x56f354], dl      # 0041a639
    jmp.d8 L_0041a5f1                            # 0041a640
L_0041a642:
    # block 0x0041a642: entered by jge at 0x0041a60d; je at 0x0041a629, 4 instruction(s), ends with jne to 0x0041a65c (forward)
    movsx eax, word ptr [ebp - local_a0]         # 0041a642
    mov dword ptr [0x570368], eax                # 0041a649
    cmp dword ptr [0x570368], 0x0                # 0041a64e
    jne.d8 L_0041a65c                            # 0041a655
    # block 0x0041a657: entered by fall-through of jne at 0x0041a655, 1 instruction(s), ends with forward jump to 0x0041aa9b
    jmp.d32 L_0041aa9b                           # 0041a657
L_0041a65c:
    # block 0x0041a65c: entered by jne at 0x0041a655, 2 instruction(s), ends with forward jump to 0x0041a679
    mov word ptr [ebp - local_90], 0x1           # 0041a65c
    jmp.d8 L_0041a679                            # 0041a665
L_0041a667:
    # block 0x0041a667: entered by jmp at 0x0041a69e, 3 instruction(s), falls into the block at 0x0041a679
    mov cx, word ptr [ebp - local_90]            # 0041a667
    add cx, 0x1                                  # 0041a66e
    mov word ptr [ebp - local_90], cx            # 0041a672
L_0041a679:
    # block 0x0041a679: entered by jmp at 0x0041a665, 3 instruction(s), ends with jg to 0x0041a6a0 (forward)
    movsx edx, word ptr [ebp - local_90]         # 0041a679
    cmp edx, 0x12                                # 0041a680
    jg.d8 L_0041a6a0                             # 0041a683
    # block 0x0041a685: entered by fall-through of jg at 0x0041a683, 7 instruction(s), calls FUN_0041b992, ends with backward jump to 0x0041a667
    movsx eax, word ptr [ebp - local_68]         # 0041a685
    movsx ecx, word ptr [ebp - local_90]         # 0041a689
    {load} sub eax, ecx                          # 0041a690
    push eax                                     # 0041a692
    mov ecx, dword ptr [ebp - local_a8]          # 0041a693
    call FUN_0041b992                            # 0041a699
    jmp.d8 L_0041a667                            # 0041a69e
L_0041a6a0:
    # block 0x0041a6a0: entered by jg at 0x0041a683, 4 instruction(s), calls FUN_0041b992, falls into the block at 0x0041a6b0
    movsx edx, word ptr [ebp - local_68]         # 0041a6a0
    push edx                                     # 0041a6a4
    mov ecx, dword ptr [ebp - local_a8]          # 0041a6a5
    call FUN_0041b992                            # 0041a6ab
L_0041a6b0:
    # block 0x0041a6b0: entered by jg at 0x0041a9db, 4 instruction(s), ends with jle to 0x0041a6d0 (forward)
    movsx eax, word ptr [0x56f34e]               # 0041a6b0
    movsx ecx, word ptr [ebp - local_a0]         # 0041a6b7
    {load} cmp eax, ecx                          # 0041a6be
    jle.d8 L_0041a6d0                            # 0041a6c0
    # block 0x0041a6c2: entered by fall-through of jle at 0x0041a6c0, 2 instruction(s), falls into the block at 0x0041a6d0
    mov dx, word ptr [ebp - local_a0]            # 0041a6c2
    mov word ptr [0x56f34e], dx                  # 0041a6c9
L_0041a6d0:
    # block 0x0041a6d0: entered by jle at 0x0041a6c0, 3 instruction(s), ends with jg to 0x0041a723 (forward)
    movsx eax, word ptr [0x56f34e]               # 0041a6d0
    cmp eax, 0x2                                 # 0041a6d7
    jg.d8 L_0041a723                             # 0041a6da
    # block 0x0041a6dc: entered by fall-through of jg at 0x0041a6da, 12 instruction(s), ends with forward jump to 0x0041a784
    mov word ptr [0x56f34e], 0x1                 # 0041a6dc
    mov cl, byte ptr [ebp - local_88]            # 0041a6e5
    or cl, byte ptr [ebp - local_9c]             # 0041a6eb
    mov byte ptr [ebp - local_88], cl            # 0041a6f1
    movsx edx, word ptr [ebp - local_68]         # 0041a6f7
    movsx eax, word ptr [ebp - local_a4]         # 0041a6fb
    mov cl, byte ptr [edx + 0x56f354]            # 0041a702
    mov byte ptr [ebp + eax - local_88], cl      # 0041a708
    mov dx, word ptr [ebp - local_a4]            # 0041a70f
    add dx, 0x1                                  # 0041a716
    mov word ptr [ebp - local_a4], dx            # 0041a71a
    jmp.d8 L_0041a784                            # 0041a721
L_0041a723:
    # block 0x0041a723: entered by jg at 0x0041a6da, 17 instruction(s), falls into the block at 0x0041a784
    movsx eax, word ptr [ebp - local_a4]         # 0041a723
    mov cl, byte ptr [0x56f350]                  # 0041a72a
    mov byte ptr [ebp + eax - local_88], cl      # 0041a730
    mov dx, word ptr [ebp - local_a4]            # 0041a737
    add dx, 0x1                                  # 0041a73e
    mov word ptr [ebp - local_a4], dx            # 0041a742
    movsx eax, word ptr [0x56f350]               # 0041a749
    sar eax, 0x4                                 # 0041a750
    and eax, 0xf0                                # 0041a753
    movsx ecx, word ptr [0x56f34e]               # 0041a758
    sub ecx, 0x3                                 # 0041a75f
    {load} or eax, ecx                           # 0041a762
    movsx edx, word ptr [ebp - local_a4]         # 0041a764
    mov byte ptr [ebp + edx - local_88], al      # 0041a76b
    mov ax, word ptr [ebp - local_a4]            # 0041a772
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041a779
    mov word ptr [ebp - local_a4], ax            # 0041a77d
L_0041a784:
    # block 0x0041a784: entered by jmp at 0x0041a721, 7 instruction(s), ends with jne to 0x0041a850 (forward)
    mov cl, byte ptr [ebp - local_9c]            # 0041a784
    shl cl                                       # 0041a78a
    mov byte ptr [ebp - local_9c], cl            # 0041a78c
    mov edx, dword ptr [ebp - local_9c]          # 0041a792
    and edx, 0xff                                # 0041a798
    test edx, edx                                # 0041a79e
    jne.d32 L_0041a850                           # 0041a7a0
    # block 0x0041a7a6: entered by fall-through of jne at 0x0041a7a0, 2 instruction(s), ends with forward jump to 0x0041a7c3
    mov word ptr [ebp - local_90], 0x0           # 0041a7a6
    jmp.d8 L_0041a7c3                            # 0041a7af
L_0041a7b1:
    # block 0x0041a7b1: entered by jmp at 0x0041a81c, 3 instruction(s), falls into the block at 0x0041a7c3
    mov ax, word ptr [ebp - local_90]            # 0041a7b1
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041a7b8
    mov word ptr [ebp - local_90], ax            # 0041a7bc
L_0041a7c3:
    # block 0x0041a7c3: entered by jmp at 0x0041a7af, 4 instruction(s), ends with jge to 0x0041a81e (forward)
    movsx ecx, word ptr [ebp - local_90]         # 0041a7c3
    movsx edx, word ptr [ebp - local_a4]         # 0041a7ca
    {load} cmp ecx, edx                          # 0041a7d1
    jge.d8 L_0041a81e                            # 0041a7d3
    # block 0x0041a7d5: entered by fall-through of jge at 0x0041a7d3, 17 instruction(s), calls FUN_0050d4f5, ends with backward jump to 0x0041a7b1
    movsx eax, word ptr [ebp - local_90]         # 0041a7d5
    mov cl, byte ptr [ebp + eax - local_88]      # 0041a7dc
    add cl, byte ptr [ebp - local_74]            # 0041a7e3
    movsx edx, word ptr [ebp - local_90]         # 0041a7e6
    mov byte ptr [ebp + edx - local_88], cl      # 0041a7ed
    mov al, byte ptr [ebp - local_74]            # 0041a7f4
    add al, 0x1                                  # 0041a7f7
    mov byte ptr [ebp - local_74], al            # 0041a7f9
    mov ecx, dword ptr [ebp - local_8c]          # 0041a7fc
    push ecx                                     # 0041a802
    movsx edx, word ptr [ebp - local_90]         # 0041a803
    {load} xor eax, eax                          # 0041a80a
    mov al, byte ptr [ebp + edx - local_88]      # 0041a80c
    push eax                                     # 0041a813
    call FUN_0050d4f5                            # 0041a814
    add esp, 0x8                                 # 0041a819
    jmp.d8 L_0041a7b1                            # 0041a81c
L_0041a81e:
    # block 0x0041a81e: entered by jge at 0x0041a7d3, 8 instruction(s), falls into the block at 0x0041a850
    movsx ecx, word ptr [ebp - local_a4]         # 0041a81e
    mov edx, dword ptr [0x57036c]                # 0041a825
    {load} add edx, ecx                          # 0041a82b
    mov dword ptr [0x57036c], edx                # 0041a82d
    mov byte ptr [ebp - local_88], 0x0           # 0041a833
    mov byte ptr [ebp - local_9c], 0x1           # 0041a83a
    movzx ax, byte ptr [ebp - local_9c]          # 0041a841
    mov word ptr [ebp - local_a4], ax            # 0041a849
L_0041a850:
    # block 0x0041a850: entered by jne at 0x0041a7a0, 4 instruction(s), ends with forward jump to 0x0041a87b
    mov cx, word ptr [0x56f34e]                  # 0041a850
    mov word ptr [ebp - local_94], cx            # 0041a857
    mov word ptr [ebp - local_90], 0x0           # 0041a85e
    jmp.d8 L_0041a87b                            # 0041a867
L_0041a869:
    # block 0x0041a869: entered by jmp at 0x0041a912, 3 instruction(s), falls into the block at 0x0041a87b
    mov dx, word ptr [ebp - local_90]            # 0041a869
    add dx, 0x1                                  # 0041a870
    mov word ptr [ebp - local_90], dx            # 0041a874
L_0041a87b:
    # block 0x0041a87b: entered by jmp at 0x0041a867, 4 instruction(s), ends with jge to 0x0041a917 (forward)
    movsx eax, word ptr [ebp - local_90]         # 0041a87b
    movsx ecx, word ptr [ebp - local_94]         # 0041a882
    {load} cmp eax, ecx                          # 0041a889
    jge.d32 L_0041a917                           # 0041a88b
    # block 0x0041a891: entered by fall-through of jge at 0x0041a88b, 8 instruction(s), calls FUN_0050d536, ends with je to 0x0041a917 (forward)
    mov edx, dword ptr [ebp - local_98]          # 0041a891
    push edx                                     # 0041a897
    call FUN_0050d536                            # 0041a898
    add esp, 0x4                                 # 0041a89d
    mov word ptr [ebp - local_70], ax            # 0041a8a0
    movsx eax, word ptr [ebp - local_70]         # 0041a8a4
    cmp eax, -0x1                                # 0041a8a8
    je.d8 L_0041a917                             # 0041a8ab
    # block 0x0041a8ad: entered by fall-through of je at 0x0041a8ab, 10 instruction(s), calls FUN_0041bbd9, ends with jge to 0x0041a8e0 (forward)
    movsx ecx, word ptr [ebp - local_6c]         # 0041a8ad
    push ecx                                     # 0041a8b1
    mov ecx, dword ptr [ebp - local_a8]          # 0041a8b2
    call FUN_0041bbd9                            # 0041a8b8
    movsx edx, word ptr [ebp - local_6c]         # 0041a8bd
    mov al, byte ptr [ebp - local_70]            # 0041a8c1
    mov byte ptr [edx + 0x56f354], al            # 0041a8c4
    movsx ecx, word ptr [ebp - local_6c]         # 0041a8ca
    cmp ecx, 0x11                                # 0041a8ce
    jge.d8 L_0041a8e0                            # 0041a8d1
    # block 0x0041a8d3: entered by fall-through of jge at 0x0041a8d1, 3 instruction(s), falls into the block at 0x0041a8e0
    movsx edx, word ptr [ebp - local_6c]         # 0041a8d3
    mov al, byte ptr [ebp - local_70]            # 0041a8d7
    mov byte ptr [edx + 0x570354], al            # 0041a8da
L_0041a8e0:
    # block 0x0041a8e0: entered by jge at 0x0041a8d1, 13 instruction(s), calls FUN_0041b992, ends with backward jump to 0x0041a869
    movsx ecx, word ptr [ebp - local_6c]         # 0041a8e0
    add ecx, 0x1                                 # 0041a8e4
    and ecx, 0xfff                               # 0041a8e7
    mov word ptr [ebp - local_6c], cx            # 0041a8ed
    movsx edx, word ptr [ebp - local_68]         # 0041a8f1
    add edx, 0x1                                 # 0041a8f5
    and edx, 0xfff                               # 0041a8f8
    mov word ptr [ebp - local_68], dx            # 0041a8fe
    movsx eax, word ptr [ebp - local_68]         # 0041a902
    push eax                                     # 0041a906
    mov ecx, dword ptr [ebp - local_a8]          # 0041a907
    call FUN_0041b992                            # 0041a90d
    jmp.d32 L_0041a869                           # 0041a912
L_0041a917:
    # block 0x0041a917: entered by jge at 0x0041a88b; je at 0x0041a8ab, 7 instruction(s), ends with jbe to 0x0041a94b (forward)
    movsx ecx, word ptr [ebp - local_90]         # 0041a917
    mov edx, dword ptr [0x570368]                # 0041a91e
    {load} add edx, ecx                          # 0041a924
    mov dword ptr [0x570368], edx                # 0041a926
    mov eax, dword ptr [0x570368]                # 0041a92c
    cmp eax, dword ptr [0x570370]                # 0041a931
    jbe.d8 L_0041a94b                            # 0041a937
    # block 0x0041a939: entered by fall-through of jbe at 0x0041a937, 3 instruction(s), falls into the block at 0x0041a94b
    mov ecx, dword ptr [0x570370]                # 0041a939
    add ecx, 0x400                               # 0041a93f
    mov dword ptr [0x570370], ecx                # 0041a945
L_0041a94b:
    # block 0x0041a94b: entered by jbe at 0x0041a937; jmp at 0x0041a9cd, 7 instruction(s), ends with jge to 0x0041a9d2 (forward)
    movsx edx, word ptr [ebp - local_90]         # 0041a94b
    movsx eax, word ptr [ebp - local_94]         # 0041a952
    mov cx, word ptr [ebp - local_90]            # 0041a959
    add cx, 0x1                                  # 0041a960
    mov word ptr [ebp - local_90], cx            # 0041a964
    {load} cmp edx, eax                          # 0041a96b
    jge.d8 L_0041a9d2                            # 0041a96d
    # block 0x0041a96f: entered by fall-through of jge at 0x0041a96d, 18 instruction(s), calls FUN_0041bbd9, ends with je to 0x0041a9cd (forward)
    movsx edx, word ptr [ebp - local_6c]         # 0041a96f
    push edx                                     # 0041a973
    mov ecx, dword ptr [ebp - local_a8]          # 0041a974
    call FUN_0041bbd9                            # 0041a97a
    movsx eax, word ptr [ebp - local_6c]         # 0041a97f
    add eax, 0x1                                 # 0041a983
    and eax, 0xfff                               # 0041a986
    mov word ptr [ebp - local_6c], ax            # 0041a98b
    movsx ecx, word ptr [ebp - local_68]         # 0041a98f
    add ecx, 0x1                                 # 0041a993
    and ecx, 0xfff                               # 0041a996
    mov word ptr [ebp - local_68], cx            # 0041a99c
    mov dx, word ptr [ebp - local_a0]            # 0041a9a0
    sub dx, 0x1                                  # 0041a9a7
    mov word ptr [ebp - local_a0], dx            # 0041a9ab
    movsx eax, word ptr [ebp - local_a0]         # 0041a9b2
    test eax, eax                                # 0041a9b9
    je.d8 L_0041a9cd                             # 0041a9bb
    # block 0x0041a9bd: entered by fall-through of je at 0x0041a9bb, 4 instruction(s), calls FUN_0041b992, falls into the block at 0x0041a9cd
    movsx ecx, word ptr [ebp - local_68]         # 0041a9bd
    push ecx                                     # 0041a9c1
    mov ecx, dword ptr [ebp - local_a8]          # 0041a9c2
    call FUN_0041b992                            # 0041a9c8
L_0041a9cd:
    # block 0x0041a9cd: entered by je at 0x0041a9bb, 1 instruction(s), ends with backward jump to 0x0041a94b
    jmp.d32 L_0041a94b                           # 0041a9cd
L_0041a9d2:
    # block 0x0041a9d2: entered by jge at 0x0041a96d, 3 instruction(s), ends with jg to 0x0041a6b0 (backward)
    movsx edx, word ptr [ebp - local_a0]         # 0041a9d2
    test edx, edx                                # 0041a9d9
    jg.d32 L_0041a6b0                            # 0041a9db
    # block 0x0041a9e1: entered by fall-through of jg at 0x0041a9db, 3 instruction(s), ends with jle to 0x0041aa7d (forward)
    movsx eax, word ptr [ebp - local_a4]         # 0041a9e1
    cmp eax, 0x1                                 # 0041a9e8
    jle.d32 L_0041aa7d                           # 0041a9eb
    # block 0x0041a9f1: entered by fall-through of jle at 0x0041a9eb, 2 instruction(s), ends with forward jump to 0x0041aa0e
    mov word ptr [ebp - local_90], 0x0           # 0041a9f1
    jmp.d8 L_0041aa0e                            # 0041a9fa
L_0041a9fc:
    # block 0x0041a9fc: entered by jmp at 0x0041aa68, 3 instruction(s), falls into the block at 0x0041aa0e
    mov cx, word ptr [ebp - local_90]            # 0041a9fc
    add cx, 0x1                                  # 0041aa03
    mov word ptr [ebp - local_90], cx            # 0041aa07
L_0041aa0e:
    # block 0x0041aa0e: entered by jmp at 0x0041a9fa, 4 instruction(s), ends with jge to 0x0041aa6a (forward)
    movsx edx, word ptr [ebp - local_90]         # 0041aa0e
    movsx eax, word ptr [ebp - local_a4]         # 0041aa15
    {load} cmp edx, eax                          # 0041aa1c
    jge.d8 L_0041aa6a                            # 0041aa1e
    # block 0x0041aa20: entered by fall-through of jge at 0x0041aa1e, 17 instruction(s), calls FUN_0050d4f5, ends with backward jump to 0x0041a9fc
    movsx ecx, word ptr [ebp - local_90]         # 0041aa20
    mov dl, byte ptr [ebp + ecx - local_88]      # 0041aa27
    add dl, byte ptr [ebp - local_74]            # 0041aa2e
    movsx eax, word ptr [ebp - local_90]         # 0041aa31
    mov byte ptr [ebp + eax - local_88], dl      # 0041aa38
    mov cl, byte ptr [ebp - local_74]            # 0041aa3f
    add cl, 0x1                                  # 0041aa42
    mov byte ptr [ebp - local_74], cl            # 0041aa45
    mov edx, dword ptr [ebp - local_8c]          # 0041aa48
    push edx                                     # 0041aa4e
    movsx eax, word ptr [ebp - local_90]         # 0041aa4f
    {load} xor ecx, ecx                          # 0041aa56
    mov cl, byte ptr [ebp + eax - local_88]      # 0041aa58
    push ecx                                     # 0041aa5f
    call FUN_0050d4f5                            # 0041aa60
    add esp, 0x8                                 # 0041aa65
    jmp.d8 L_0041a9fc                            # 0041aa68
L_0041aa6a:
    # block 0x0041aa6a: entered by jge at 0x0041aa1e, 4 instruction(s), falls into the block at 0x0041aa7d
    movsx edx, word ptr [ebp - local_a4]         # 0041aa6a
    mov eax, dword ptr [0x57036c]                # 0041aa71
    {load} add eax, edx                          # 0041aa76
    mov dword ptr [0x57036c], eax                # 0041aa78
L_0041aa7d:
    # block 0x0041aa7d: entered by jle at 0x0041a9eb, 8 instruction(s), calls FUN_0050cee4, falls into the block at 0x0041aa9b
    mov ecx, dword ptr [ebp - local_98]          # 0041aa7d
    push ecx                                     # 0041aa83
    call FUN_0050cee4                            # 0041aa84
    add esp, 0x4                                 # 0041aa89
    mov edx, dword ptr [ebp - local_8c]          # 0041aa8c
    push edx                                     # 0041aa92
    call FUN_0050cee4                            # 0041aa93
    add esp, 0x4                                 # 0041aa98
L_0041aa9b:
    # block 0x0041aa9b: entered by jmp at 0x0041a657, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 0041aa9b
    pop ebp                                      # 0041aa9d
    ret 0x8                                      # 0041aa9e

