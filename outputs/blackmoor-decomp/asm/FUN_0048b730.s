# FUN_0048b730
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048b730
# extent:       0x0048b730-0x0048b9f6 (710 code bytes)
# span:         0x0048b730-0x0048ba00 (code 710, tables 0, padding 10)
# sha256:       e15c87b9405755c89e87326077cbcee72a84b4739a65a063f65dd9e8a598abb8
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0048b730
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_21, field_24, field_c4; [ecx + n] field_24, field_c4, field_2a4; [edx + n] field_22, field_204
# callees:      calls FUN_004c5377, FUN_004c5d4b, FUN_0048ac92
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 180 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_21, 0x21  # offset +0x21
.equ field_22, 0x22  # offset +0x22
.equ field_24, 0x24  # offset +0x24
.equ field_c4, 0xc4  # offset +0xc4
.equ field_204, 0x204  # offset +0x204
.equ field_2a4, 0x2a4  # offset +0x2a4

# --- external targets -----------------------------------------------
.set FUN_0048ac92, .text + (0x0048ac92 - 0x401000)
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)

.org 0x0048b730 - 0x401000
.globl FUN_0048b730
FUN_0048b730:
    # block 0x0048b730: entry, 9 instruction(s), ends with je to 0x0048b7fb (forward)
    push ebp                                     # 0048b730
    {load} mov ebp, esp                          # 0048b731
    sub esp, 0x10                                # 0048b733
    movsx eax, word ptr [0x61d12d]               # 0048b736
    imul eax, eax, 0x8d                          # 0048b73d
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0048b743
    mov dword ptr [ebp - local_c], ecx           # 0048b749
    cmp dword ptr [0x61d2b5], 0x0                # 0048b74c
    je.d32 L_0048b7fb                            # 0048b753
    # block 0x0048b759: entered by fall-through of je at 0x0048b753, 2 instruction(s), ends with forward jump to 0x0048b76b
    mov dword ptr [ebp - local_4], 0x0           # 0048b759
    jmp.d8 L_0048b76b                            # 0048b760
L_0048b762:
    # block 0x0048b762: entered by jmp at 0x0048b7ec, 3 instruction(s), falls into the block at 0x0048b76b
    mov edx, dword ptr [ebp - local_4]           # 0048b762
    add edx, 0x1                                 # 0048b765
    mov dword ptr [ebp - local_4], edx           # 0048b768
L_0048b76b:
    # block 0x0048b76b: entered by jmp at 0x0048b760, 5 instruction(s), ends with jge to 0x0048b7f1 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0048b76b
    {load} xor ecx, ecx                          # 0048b76e
    mov cl, byte ptr [eax + field_21]            # 0048b770
    cmp dword ptr [ebp - local_4], ecx           # 0048b773
    jge.d8 L_0048b7f1                            # 0048b776
    # block 0x0048b778: entered by fall-through of jge at 0x0048b776, 33 instruction(s), calls FUN_004c5377, ends with backward jump to 0x0048b762
    push 0x54e454                                # 0048b778
    mov edx, dword ptr [ebp - local_4]           # 0048b77d
    shl edx, 0x4                                 # 0048b780
    add edx, 0x61d161                            # 0048b783
    push edx                                     # 0048b789
    mov eax, dword ptr [ebp - local_4]           # 0048b78a
    shl eax, 0x4                                 # 0048b78d
    mov ecx, dword ptr [ebp - local_c]           # 0048b790
    lea edx, [ecx + eax + field_c4]              # 0048b793
    push edx                                     # 0048b79a
    mov eax, dword ptr [0x5cf665]                # 0048b79b
    push eax                                     # 0048b7a0
    mov ecx, dword ptr [0x5d15e3]                # 0048b7a1
    push ecx                                     # 0048b7a7
    mov ecx, 0x5cf659                            # 0048b7a8
    call FUN_004c5377                            # 0048b7ad
    push 0x54e498                                # 0048b7b2
    mov edx, dword ptr [ebp - local_4]           # 0048b7b7
    shl edx, 0x4                                 # 0048b7ba
    add edx, 0x61d201                            # 0048b7bd
    push edx                                     # 0048b7c3
    mov eax, dword ptr [ebp - local_4]           # 0048b7c4
    shl eax, 0x4                                 # 0048b7c7
    mov ecx, dword ptr [ebp - local_c]           # 0048b7ca
    lea edx, [ecx + eax + field_2a4]             # 0048b7cd
    push edx                                     # 0048b7d4
    mov eax, dword ptr [0x5cf665]                # 0048b7d5
    push eax                                     # 0048b7da
    mov ecx, dword ptr [0x5d15e3]                # 0048b7db
    push ecx                                     # 0048b7e1
    mov ecx, 0x5cf659                            # 0048b7e2
    call FUN_004c5377                            # 0048b7e7
    jmp.d32 L_0048b762                           # 0048b7ec
L_0048b7f1:
    # block 0x0048b7f1: entered by jge at 0x0048b776, 1 instruction(s), falls into the block at 0x0048b7fb
    mov dword ptr [0x61d2b5], 0x0                # 0048b7f1
L_0048b7fb:
    # block 0x0048b7fb: entered by je at 0x0048b753, 5 instruction(s), ends with jne to 0x0048b87a (forward)
    mov edx, dword ptr [ebp - local_c]           # 0048b7fb
    {load} xor eax, eax                          # 0048b7fe
    mov al, byte ptr [edx + field_22]            # 0048b800
    cmp eax, 0x1                                 # 0048b803
    jne.d8 L_0048b87a                            # 0048b806
    # block 0x0048b808: entered by fall-through of jne at 0x0048b806, 2 instruction(s), ends with forward jump to 0x0048b81a
    mov dword ptr [ebp - local_4], 0x0           # 0048b808
    jmp.d8 L_0048b81a                            # 0048b80f
L_0048b811:
    # block 0x0048b811: entered by jmp at 0x0048b878, 3 instruction(s), falls into the block at 0x0048b81a
    mov ecx, dword ptr [ebp - local_4]           # 0048b811
    add ecx, 0x1                                 # 0048b814
    mov dword ptr [ebp - local_4], ecx           # 0048b817
L_0048b81a:
    # block 0x0048b81a: entered by jmp at 0x0048b80f, 3 instruction(s), ends with jge to 0x0048b87a (forward)
    movsx edx, word ptr [0x61d151]               # 0048b81a
    cmp dword ptr [ebp - local_4], edx           # 0048b821
    jge.d8 L_0048b87a                            # 0048b824
    # block 0x0048b826: entered by fall-through of jge at 0x0048b824, 22 instruction(s), calls FUN_004c5d4b, ends with backward jump to 0x0048b811
    mov eax, dword ptr [ebp - local_4]           # 0048b826
    mov cx, word ptr [2*eax + 0x61d13d]          # 0048b829
    mov word ptr [ebp - local_8], cx             # 0048b831
    push 0x54e4d8                                # 0048b835
    movsx edx, word ptr [ebp - local_8]          # 0048b83a
    shl edx, 0x4                                 # 0048b83e
    add edx, 0x61d161                            # 0048b841
    push edx                                     # 0048b847
    movsx eax, word ptr [ebp - local_8]          # 0048b848
    shl eax, 0x4                                 # 0048b84c
    mov ecx, dword ptr [ebp - local_c]           # 0048b84f
    lea edx, [ecx + eax + field_24]              # 0048b852
    push edx                                     # 0048b856
    mov eax, dword ptr [0x5cf665]                # 0048b857
    push eax                                     # 0048b85c
    movsx ecx, word ptr [0x61d12b]               # 0048b85d
    imul ecx, ecx, 0x4a                          # 0048b864
    mov edx, dword ptr [ecx + 0x5d1599]          # 0048b867
    push edx                                     # 0048b86d
    mov ecx, 0x5cf659                            # 0048b86e
    call FUN_004c5d4b                            # 0048b873
    jmp.d8 L_0048b811                            # 0048b878
L_0048b87a:
    # block 0x0048b87a: entered by jne at 0x0048b806; jge at 0x0048b824, 2 instruction(s), ends with je to 0x0048b97d (forward)
    cmp dword ptr [0x61d153], 0x0                # 0048b87a
    je.d32 L_0048b97d                            # 0048b881
    # block 0x0048b887: entered by fall-through of je at 0x0048b881, 4 instruction(s), ends with jne to 0x0048b8e3 (forward)
    mov ax, word ptr [0x61d157]                  # 0048b887
    mov word ptr [ebp - local_8], ax             # 0048b88d
    cmp dword ptr [0x61d15d], 0x0                # 0048b891
    jne.d8 L_0048b8e3                            # 0048b898
    # block 0x0048b89a: entered by fall-through of jne at 0x0048b898, 19 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x0048b97d
    push 0x54e514                                # 0048b89a
    movsx ecx, word ptr [ebp - local_8]          # 0048b89f
    shl ecx, 0x4                                 # 0048b8a3
    add ecx, 0x61d161                            # 0048b8a6
    push ecx                                     # 0048b8ac
    movsx edx, word ptr [ebp - local_8]          # 0048b8ad
    shl edx, 0x4                                 # 0048b8b1
    mov eax, dword ptr [ebp - local_c]           # 0048b8b4
    lea ecx, [eax + edx + field_24]              # 0048b8b7
    push ecx                                     # 0048b8bb
    mov edx, dword ptr [0x5cf665]                # 0048b8bc
    push edx                                     # 0048b8c2
    movsx eax, word ptr [0x61d12b]               # 0048b8c3
    imul eax, eax, 0x4a                          # 0048b8ca
    mov ecx, dword ptr [eax + 0x5d1599]          # 0048b8cd
    push ecx                                     # 0048b8d3
    mov ecx, 0x5cf659                            # 0048b8d4
    call FUN_004c5d4b                            # 0048b8d9
    jmp.d32 L_0048b97d                           # 0048b8de
L_0048b8e3:
    # block 0x0048b8e3: entered by jne at 0x0048b898, 2 instruction(s), ends with jne to 0x0048b97d (forward)
    cmp dword ptr [0x61d15d], 0x1                # 0048b8e3
    jne.d32 L_0048b97d                           # 0048b8ea
    # block 0x0048b8f0: entered by fall-through of jne at 0x0048b8ea, 5 instruction(s), ends with jne to 0x0048b939 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0048b8f0
    {load} xor eax, eax                          # 0048b8f3
    mov al, byte ptr [edx + field_22]            # 0048b8f5
    cmp eax, 0x2                                 # 0048b8f8
    jne.d8 L_0048b939                            # 0048b8fb
    # block 0x0048b8fd: entered by fall-through of jne at 0x0048b8fb, 16 instruction(s), calls FUN_004c5377, falls into the block at 0x0048b939
    push 0x54e554                                # 0048b8fd
    movsx ecx, word ptr [ebp - local_8]          # 0048b902
    shl ecx, 0x4                                 # 0048b906
    add ecx, 0x61d161                            # 0048b909
    push ecx                                     # 0048b90f
    movsx edx, word ptr [ebp - local_8]          # 0048b910
    shl edx, 0x4                                 # 0048b914
    mov eax, dword ptr [ebp - local_c]           # 0048b917
    lea ecx, [eax + edx + field_c4]              # 0048b91a
    push ecx                                     # 0048b921
    mov edx, dword ptr [0x5cf665]                # 0048b922
    push edx                                     # 0048b928
    mov eax, dword ptr [0x5d15e3]                # 0048b929
    push eax                                     # 0048b92e
    mov ecx, 0x5cf659                            # 0048b92f
    call FUN_004c5377                            # 0048b934
L_0048b939:
    # block 0x0048b939: entered by jne at 0x0048b8fb, 11 instruction(s), calls FUN_0048ac92, falls into the block at 0x0048b97d
    mov dword ptr [0x61d153], 0x0                # 0048b939
    movsx ecx, word ptr [ebp - local_8]          # 0048b943
    mov byte ptr [ecx + 0x61d133], 0x1           # 0048b947
    movsx edx, word ptr [0x61d151]               # 0048b94e
    mov ax, word ptr [ebp - local_8]             # 0048b955
    mov word ptr [2*edx + 0x61d13d], ax          # 0048b959
    mov cx, word ptr [0x61d151]                  # 0048b961
    add cx, 0x1                                  # 0048b968
    mov word ptr [0x61d151], cx                  # 0048b96c
    mov ecx, 0x61d10f                            # 0048b973
    call FUN_0048ac92                            # 0048b978
L_0048b97d:
    # block 0x0048b97d: entered by je at 0x0048b881; jmp at 0x0048b8de; jne at 0x0048b8ea, 2 instruction(s), ends with forward jump to 0x0048b98f
    mov dword ptr [ebp - local_4], 0x0           # 0048b97d
    jmp.d8 L_0048b98f                            # 0048b984
L_0048b986:
    # block 0x0048b986: entered by jmp at 0x0048b9f0, 3 instruction(s), falls into the block at 0x0048b98f
    mov edx, dword ptr [ebp - local_4]           # 0048b986
    add edx, 0x1                                 # 0048b989
    mov dword ptr [ebp - local_4], edx           # 0048b98c
L_0048b98f:
    # block 0x0048b98f: entered by jmp at 0x0048b984, 3 instruction(s), ends with jge to 0x0048b9f2 (forward)
    movsx eax, word ptr [0x61d151]               # 0048b98f
    cmp dword ptr [ebp - local_4], eax           # 0048b996
    jge.d8 L_0048b9f2                            # 0048b999
    # block 0x0048b99b: entered by fall-through of jge at 0x0048b999, 22 instruction(s), calls FUN_004c5d4b, ends with backward jump to 0x0048b986
    mov ecx, dword ptr [ebp - local_4]           # 0048b99b
    mov dx, word ptr [2*ecx + 0x61d2a1]          # 0048b99e
    mov word ptr [ebp - local_10], dx            # 0048b9a6
    push 0x54e590                                # 0048b9aa
    movsx eax, word ptr [ebp - local_10]         # 0048b9af
    shl eax, 0x4                                 # 0048b9b3
    add eax, 0x61d201                            # 0048b9b6
    push eax                                     # 0048b9bb
    movsx ecx, word ptr [ebp - local_10]         # 0048b9bc
    shl ecx, 0x4                                 # 0048b9c0
    mov edx, dword ptr [ebp - local_c]           # 0048b9c3
    lea eax, [edx + ecx + field_204]             # 0048b9c6
    push eax                                     # 0048b9cd
    mov ecx, dword ptr [0x5cf665]                # 0048b9ce
    push ecx                                     # 0048b9d4
    movsx edx, word ptr [0x61d12b]               # 0048b9d5
    imul edx, edx, 0x4a                          # 0048b9dc
    mov eax, dword ptr [edx + 0x5d1599]          # 0048b9df
    push eax                                     # 0048b9e5
    mov ecx, 0x5cf659                            # 0048b9e6
    call FUN_004c5d4b                            # 0048b9eb
    jmp.d8 L_0048b986                            # 0048b9f0
L_0048b9f2:
    # block 0x0048b9f2: entered by jge at 0x0048b999, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0048b9f2
    pop ebp                                      # 0048b9f4
    ret                                          # 0048b9f5

# --- data items (not part of the function) -------------------------
.org 0x0048b9f6 - 0x401000
PAD_0048b9f6:  # 10 byte(s) of int3 padding
    .fill 10, 1, 0xcc

