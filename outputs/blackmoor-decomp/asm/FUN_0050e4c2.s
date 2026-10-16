# FUN_0050e4c2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050e4c2
# extent:       0x0050e4c2-0x0050e5cc (266 code bytes)
# span:         0x0050e4c2-0x0050e5cc (code 266, tables 0, padding 0)
# sha256:       80d954398ee6f742ff22997aba10b921f9a91c06a9a586c71b97b9ffd302f85d
# evidence:     ev_4431af068a3f4ca776e521e2b82a00887220c1221c914635cfd4305c8866eb9e
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050e4c2
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       1 ebp-relative slot(s): local_4
# fields:       [esi + n] field_4, field_c, field_10, field_18
# callees:      calls FUN_0050fa90, FUN_0050dcb0, FUN_005132c9, FUN_00510f91
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 106 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_0050dcb0, .text + (0x0050dcb0 - 0x401000)
.set FUN_0050fa90, .text + (0x0050fa90 - 0x401000)
.set FUN_00510f91, .text + (0x00510f91 - 0x401000)
.set FUN_005132c9, .text + (0x005132c9 - 0x401000)

.org 0x0050e4c2 - 0x401000
.globl FUN_0050e4c2
FUN_0050e4c2:
    # block 0x0050e4c2: entry, 14 instruction(s), ends with jne to 0x0050e4e6 (forward)
    push ebp                                     # 0050e4c2
    {load} mov ebp, esp                          # 0050e4c3
    push ecx                                     # 0050e4c5
    push ebx                                     # 0050e4c6
    push esi                                     # 0050e4c7
    push edi                                     # 0050e4c8
    mov edi, dword ptr [ebp + arg_c]             # 0050e4c9
    imul edi, dword ptr [ebp + arg_10]           # 0050e4cc
    mov eax, dword ptr [ebp + arg_8]             # 0050e4d0
    mov dword ptr [ebp - local_4], edi           # 0050e4d3
    test edi, edi                                # 0050e4d6
    mov dword ptr [ebp + arg_8], eax             # 0050e4d8
    {load} mov ebx, edi                          # 0050e4db
    jne.d8 L_0050e4e6                            # 0050e4dd
    # block 0x0050e4df: entered by fall-through of jne at 0x0050e4dd, 2 instruction(s), ends with forward jump to 0x0050e5b3
    {load} xor eax, eax                          # 0050e4df
    jmp.d32 L_0050e5b3                           # 0050e4e1
L_0050e4e6:
    # block 0x0050e4e6: entered by jne at 0x0050e4dd, 3 instruction(s), ends with je to 0x0050e4f9 (forward)
    mov esi, dword ptr [ebp + arg_14]            # 0050e4e6
    test word ptr [esi + field_c], 0x10c         # 0050e4e9
    je.d8 L_0050e4f9                             # 0050e4ef
    # block 0x0050e4f1: entered by fall-through of je at 0x0050e4ef, 3 instruction(s), ends with forward jump to 0x0050e500
    mov eax, dword ptr [esi + field_18]          # 0050e4f1
    mov dword ptr [ebp + arg_14], eax            # 0050e4f4
    jmp.d8 L_0050e500                            # 0050e4f7
L_0050e4f9:
    # block 0x0050e4f9: entered by je at 0x0050e4ef, 1 instruction(s), falls into the block at 0x0050e500
    mov dword ptr [ebp + arg_14], 0x1000         # 0050e4f9
L_0050e500:
    # block 0x0050e500: entered by jmp at 0x0050e4f7; jne at 0x0050e5aa, 3 instruction(s), ends with je to 0x0050e534 (forward)
    mov ecx, dword ptr [esi + field_c]           # 0050e500
    and ecx, 0x108                               # 0050e503
    je.d8 L_0050e534                             # 0050e509
    # block 0x0050e50b: entered by fall-through of je at 0x0050e509, 3 instruction(s), ends with je to 0x0050e534 (forward)
    mov eax, dword ptr [esi + field_4]           # 0050e50b
    test eax, eax                                # 0050e50e
    je.d8 L_0050e534                             # 0050e510
    # block 0x0050e512: entered by fall-through of je at 0x0050e510, 3 instruction(s), ends with jb to 0x0050e51a (forward)
    {load} cmp ebx, eax                          # 0050e512
    {load} mov edi, ebx                          # 0050e514
    jb.d8 L_0050e51a                             # 0050e516
    # block 0x0050e518: entered by fall-through of jb at 0x0050e516, 1 instruction(s), falls into the block at 0x0050e51a
    {load} mov edi, eax                          # 0050e518
L_0050e51a:
    # block 0x0050e51a: entered by jb at 0x0050e516, 10 instruction(s), calls FUN_0050fa90, ends with forward jump to 0x0050e57a
    push edi                                     # 0050e51a
    push dword ptr [ebp + arg_8]                 # 0050e51b
    push dword ptr [esi]                         # 0050e51e
    call FUN_0050fa90                            # 0050e520
    sub dword ptr [esi + field_4], edi           # 0050e525
    add dword ptr [esi], edi                     # 0050e528
    add esp, 0xc                                 # 0050e52a
    {load} sub ebx, edi                          # 0050e52d
    add dword ptr [ebp + arg_8], edi             # 0050e52f
    jmp.d8 L_0050e57a                            # 0050e532
L_0050e534:
    # block 0x0050e534: entered by je at 0x0050e509; je at 0x0050e510, 2 instruction(s), ends with jb to 0x0050e57f (forward)
    cmp ebx, dword ptr [ebp + arg_14]            # 0050e534
    jb.d8 L_0050e57f                             # 0050e537
    # block 0x0050e539: entered by fall-through of jb at 0x0050e537, 2 instruction(s), ends with je to 0x0050e548 (forward)
    test ecx, ecx                                # 0050e539
    je.d8 L_0050e548                             # 0050e53b
    # block 0x0050e53d: entered by fall-through of je at 0x0050e53b, 5 instruction(s), calls FUN_0050dcb0, ends with jne to 0x0050e5c1 (forward)
    push esi                                     # 0050e53d
    call FUN_0050dcb0                            # 0050e53e
    test eax, eax                                # 0050e543
    pop ecx                                      # 0050e545
    jne.d8 L_0050e5c1                            # 0050e546
L_0050e548:
    # block 0x0050e548: entered by je at 0x0050e53b; fall-through of jne at 0x0050e546, 2 instruction(s), ends with je to 0x0050e55b (forward)
    cmp dword ptr [ebp + arg_14], 0x0            # 0050e548
    je.d8 L_0050e55b                             # 0050e54c
    # block 0x0050e54e: entered by fall-through of je at 0x0050e54c, 6 instruction(s), ends with forward jump to 0x0050e55d
    {load} mov eax, ebx                          # 0050e54e
    {load} xor edx, edx                          # 0050e550
    div dword ptr [ebp + arg_14]                 # 0050e552
    {load} mov edi, ebx                          # 0050e555
    {load} sub edi, edx                          # 0050e557
    jmp.d8 L_0050e55d                            # 0050e559
L_0050e55b:
    # block 0x0050e55b: entered by je at 0x0050e54c, 1 instruction(s), falls into the block at 0x0050e55d
    {load} mov edi, ebx                          # 0050e55b
L_0050e55d:
    # block 0x0050e55d: entered by jmp at 0x0050e559, 7 instruction(s), calls FUN_005132c9, ends with je to 0x0050e5b8 (forward)
    push edi                                     # 0050e55d
    push dword ptr [ebp + arg_8]                 # 0050e55e
    push dword ptr [esi + field_10]              # 0050e561
    call FUN_005132c9                            # 0050e564
    add esp, 0xc                                 # 0050e569
    cmp eax, -0x1                                # 0050e56c
    je.d8 L_0050e5b8                             # 0050e56f
    # block 0x0050e571: entered by fall-through of je at 0x0050e56f, 4 instruction(s), ends with jb to 0x0050e5b8 (forward)
    add dword ptr [ebp + arg_8], eax             # 0050e571
    {load} sub ebx, eax                          # 0050e574
    {load} cmp eax, edi                          # 0050e576
    jb.d8 L_0050e5b8                             # 0050e578
L_0050e57a:
    # block 0x0050e57a: entered by jmp at 0x0050e532; fall-through of jb at 0x0050e578, 2 instruction(s), ends with forward jump to 0x0050e5a8
    mov edi, dword ptr [ebp - local_4]           # 0050e57a
    jmp.d8 L_0050e5a8                            # 0050e57d
L_0050e57f:
    # block 0x0050e57f: entered by jb at 0x0050e537, 9 instruction(s), calls FUN_00510f91, ends with je to 0x0050e5c1 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 0050e57f
    push esi                                     # 0050e582
    movsx eax, byte ptr [eax]                    # 0050e583
    push eax                                     # 0050e586
    call FUN_00510f91                            # 0050e587
    pop ecx                                      # 0050e58c
    cmp eax, -0x1                                # 0050e58d
    pop ecx                                      # 0050e590
    je.d8 L_0050e5c1                             # 0050e591
    # block 0x0050e593: entered by fall-through of je at 0x0050e591, 6 instruction(s), ends with jg to 0x0050e5a8 (forward)
    inc dword ptr [ebp + arg_8]                  # 0050e593
    mov eax, dword ptr [esi + field_18]          # 0050e596
    dec ebx                                      # 0050e599
    mov dword ptr [ebp + arg_14], eax            # 0050e59a
    test eax, eax                                # 0050e59d
    jg.d8 L_0050e5a8                             # 0050e59f
    # block 0x0050e5a1: entered by fall-through of jg at 0x0050e59f, 1 instruction(s), falls into the block at 0x0050e5a8
    mov dword ptr [ebp + arg_14], 0x1            # 0050e5a1
L_0050e5a8:
    # block 0x0050e5a8: entered by jmp at 0x0050e57d; jg at 0x0050e59f, 2 instruction(s), ends with jne to 0x0050e500 (backward)
    test ebx, ebx                                # 0050e5a8
    jne.d32 L_0050e500                           # 0050e5aa
    # block 0x0050e5b0: entered by fall-through of jne at 0x0050e5aa, 1 instruction(s), falls into the block at 0x0050e5b3
    mov eax, dword ptr [ebp + arg_10]            # 0050e5b0
L_0050e5b3:
    # block 0x0050e5b3: entered by jmp at 0x0050e4e1; jmp at 0x0050e5ca, 5 instruction(s), ends with ret
    pop edi                                      # 0050e5b3
    pop esi                                      # 0050e5b4
    pop ebx                                      # 0050e5b5
    leave                                        # 0050e5b6
    ret                                          # 0050e5b7
L_0050e5b8:
    # block 0x0050e5b8: entered by je at 0x0050e56f; jb at 0x0050e578, 3 instruction(s), ends with forward jump to 0x0050e5c3
    or dword ptr [esi + field_c], 0x20           # 0050e5b8
    mov eax, dword ptr [ebp - local_4]           # 0050e5bc
    jmp.d8 L_0050e5c3                            # 0050e5bf
L_0050e5c1:
    # block 0x0050e5c1: entered by jne at 0x0050e546; je at 0x0050e591, 1 instruction(s), falls into the block at 0x0050e5c3
    {load} mov eax, edi                          # 0050e5c1
L_0050e5c3:
    # block 0x0050e5c3: entered by jmp at 0x0050e5bf, 4 instruction(s), ends with backward jump to 0x0050e5b3
    {load} sub eax, ebx                          # 0050e5c3
    {load} xor edx, edx                          # 0050e5c5
    div dword ptr [ebp + arg_c]                  # 0050e5c7
    jmp.d8 L_0050e5b3                            # 0050e5ca

