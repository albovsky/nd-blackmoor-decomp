# FUN_004ae4d7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ae4d7
# extent:       0x004ae4d7-0x004ae683 (428 code bytes)
# span:         0x004ae4d7-0x004ae683 (code 428, tables 0, padding 0)
# sha256:       3549a8eda0f7dcbae806e4b3dca9e5ab535a23c232ba6a13392511db499e21a7
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ae4d7
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       15 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_20, local_24, local_2c, local_30, local_38, local_3c and 3 more
# fields:       [ecx + n] field_23
# callees:      calls FUN_0050ce04
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 126 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ arg_8, 0x8  # offset +0x8
.equ field_23, 0x23  # offset +0x23

# --- external targets -----------------------------------------------
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x004ae4d7 - 0x401000
.globl FUN_004ae4d7
FUN_004ae4d7:
    # block 0x004ae4d7: entry, 6 instruction(s), ends with forward jump to 0x004ae4f2
    push ebp                                     # 004ae4d7
    {load} mov ebp, esp                          # 004ae4d8
    sub esp, 0x48                                # 004ae4da
    mov dword ptr [ebp - local_18], ecx          # 004ae4dd
    mov dword ptr [ebp - local_c], 0x0           # 004ae4e0
    jmp.d8 L_004ae4f2                            # 004ae4e7
L_004ae4e9:
    # block 0x004ae4e9: entered by jmp at 0x004ae527; jmp at 0x004ae678, 3 instruction(s), falls into the block at 0x004ae4f2
    mov eax, dword ptr [ebp - local_c]           # 004ae4e9
    add eax, 0x2                                 # 004ae4ec
    mov dword ptr [ebp - local_c], eax           # 004ae4ef
L_004ae4f2:
    # block 0x004ae4f2: entered by jmp at 0x004ae4e7, 4 instruction(s), ends with jge to 0x004ae67d (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004ae4f2
    mov edx, dword ptr [ebp - local_c]           # 004ae4f5
    cmp edx, dword ptr [ecx + field_23]          # 004ae4f8
    jge.d32 L_004ae67d                           # 004ae4fb
    # block 0x004ae501: entered by fall-through of jge at 0x004ae4fb, 11 instruction(s), ends with jne to 0x004ae529 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004ae501
    mov ecx, dword ptr [eax]                     # 004ae504
    mov edx, dword ptr [ebp - local_c]           # 004ae506
    mov ax, word ptr [ecx + edx]                 # 004ae509
    mov word ptr [ebp - local_8], ax             # 004ae50d
    mov ecx, dword ptr [ebp - local_8]           # 004ae511
    and ecx, 0xffff                              # 004ae514
    {load} xor edx, edx                          # 004ae51a
    mov dx, word ptr [0x5d2f29]                  # 004ae51c
    {load} cmp ecx, edx                          # 004ae523
    jne.d8 L_004ae529                            # 004ae525
    # block 0x004ae527: entered by fall-through of jne at 0x004ae525, 1 instruction(s), ends with backward jump to 0x004ae4e9
    jmp.d8 L_004ae4e9                            # 004ae527
L_004ae529:
    # block 0x004ae529: entered by jne at 0x004ae525, 56 instruction(s), calls FUN_0050ce04, ends with jge to 0x004ae5f7 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004ae529
    and eax, 0xffff                              # 004ae52c
    {load} xor ecx, ecx                          # 004ae531
    mov cl, byte ptr [0x5d2f1b]                  # 004ae533
    sar eax, cl                                  # 004ae539
    {load} xor ecx, ecx                          # 004ae53b
    mov cl, byte ptr [0x5d2f1f]                  # 004ae53d
    {load} and eax, ecx                          # 004ae543
    mov dword ptr [ebp - local_10], eax          # 004ae545
    mov edx, dword ptr [ebp - local_8]           # 004ae548
    and edx, 0xffff                              # 004ae54b
    {load} xor ecx, ecx                          # 004ae551
    mov cl, byte ptr [0x5d2f1a]                  # 004ae553
    sar edx, cl                                  # 004ae559
    {load} xor eax, eax                          # 004ae55b
    mov al, byte ptr [0x5d2f1e]                  # 004ae55d
    {load} and edx, eax                          # 004ae562
    mov dword ptr [ebp - local_4], edx           # 004ae564
    mov edx, dword ptr [ebp - local_8]           # 004ae567
    and edx, 0xffff                              # 004ae56a
    {load} xor ecx, ecx                          # 004ae570
    mov cl, byte ptr [0x5d2f19]                  # 004ae572
    sar edx, cl                                  # 004ae578
    {load} xor eax, eax                          # 004ae57a
    mov al, byte ptr [0x5d2f1d]                  # 004ae57c
    {load} and edx, eax                          # 004ae581
    mov dword ptr [ebp - local_14], edx          # 004ae583
    fild dword ptr [ebp - local_10]              # 004ae586
    fstp qword ptr [ebp - local_20]              # 004ae589
    fild dword ptr [ebp - local_10]              # 004ae58c
    fstp dword ptr [ebp - local_24]              # 004ae58f
    fld dword ptr [ebp - local_24]               # 004ae592
    fmul qword ptr [0x52cac0]                    # 004ae595
    fadd qword ptr [ebp - local_20]              # 004ae59b
    call FUN_0050ce04                            # 004ae59e
    mov dword ptr [ebp - local_10], eax          # 004ae5a3
    fild dword ptr [ebp - local_4]               # 004ae5a6
    fstp qword ptr [ebp - local_2c]              # 004ae5a9
    fild dword ptr [ebp - local_4]               # 004ae5ac
    fstp dword ptr [ebp - local_30]              # 004ae5af
    fld dword ptr [ebp - local_30]               # 004ae5b2
    fmul qword ptr [0x52cac0]                    # 004ae5b5
    fadd qword ptr [ebp - local_2c]              # 004ae5bb
    call FUN_0050ce04                            # 004ae5be
    mov dword ptr [ebp - local_4], eax           # 004ae5c3
    fild dword ptr [ebp - local_14]              # 004ae5c6
    fstp qword ptr [ebp - local_38]              # 004ae5c9
    fild dword ptr [ebp - local_14]              # 004ae5cc
    fstp dword ptr [ebp - local_3c]              # 004ae5cf
    fld dword ptr [ebp - local_3c]               # 004ae5d2
    fmul qword ptr [0x52cac0]                    # 004ae5d5
    fadd qword ptr [ebp - local_38]              # 004ae5db
    call FUN_0050ce04                            # 004ae5de
    mov dword ptr [ebp - local_14], eax          # 004ae5e3
    cmp dword ptr [ebp - local_10], 0xff         # 004ae5e6
    jge.d8 L_004ae5f7                            # 004ae5ed
    # block 0x004ae5ef: entered by fall-through of jge at 0x004ae5ed, 3 instruction(s), ends with forward jump to 0x004ae5fe
    mov ecx, dword ptr [ebp - local_10]          # 004ae5ef
    mov dword ptr [ebp - local_40], ecx          # 004ae5f2
    jmp.d8 L_004ae5fe                            # 004ae5f5
L_004ae5f7:
    # block 0x004ae5f7: entered by jge at 0x004ae5ed, 1 instruction(s), falls into the block at 0x004ae5fe
    mov dword ptr [ebp - local_40], 0xff         # 004ae5f7
L_004ae5fe:
    # block 0x004ae5fe: entered by jmp at 0x004ae5f5, 4 instruction(s), ends with jge to 0x004ae615 (forward)
    mov edx, dword ptr [ebp - local_40]          # 004ae5fe
    mov dword ptr [ebp - local_10], edx          # 004ae601
    cmp dword ptr [ebp - local_4], 0xff          # 004ae604
    jge.d8 L_004ae615                            # 004ae60b
    # block 0x004ae60d: entered by fall-through of jge at 0x004ae60b, 3 instruction(s), ends with forward jump to 0x004ae61c
    mov eax, dword ptr [ebp - local_4]           # 004ae60d
    mov dword ptr [ebp - local_44], eax          # 004ae610
    jmp.d8 L_004ae61c                            # 004ae613
L_004ae615:
    # block 0x004ae615: entered by jge at 0x004ae60b, 1 instruction(s), falls into the block at 0x004ae61c
    mov dword ptr [ebp - local_44], 0xff         # 004ae615
L_004ae61c:
    # block 0x004ae61c: entered by jmp at 0x004ae613, 4 instruction(s), ends with jge to 0x004ae633 (forward)
    mov ecx, dword ptr [ebp - local_44]          # 004ae61c
    mov dword ptr [ebp - local_4], ecx           # 004ae61f
    cmp dword ptr [ebp - local_14], 0xff         # 004ae622
    jge.d8 L_004ae633                            # 004ae629
    # block 0x004ae62b: entered by fall-through of jge at 0x004ae629, 3 instruction(s), ends with forward jump to 0x004ae63a
    mov edx, dword ptr [ebp - local_14]          # 004ae62b
    mov dword ptr [ebp - local_48], edx          # 004ae62e
    jmp.d8 L_004ae63a                            # 004ae631
L_004ae633:
    # block 0x004ae633: entered by jge at 0x004ae629, 1 instruction(s), falls into the block at 0x004ae63a
    mov dword ptr [ebp - local_48], 0xff         # 004ae633
L_004ae63a:
    # block 0x004ae63a: entered by jmp at 0x004ae631, 22 instruction(s), ends with backward jump to 0x004ae4e9
    mov eax, dword ptr [ebp - local_48]          # 004ae63a
    mov dword ptr [ebp - local_14], eax          # 004ae63d
    {load} xor ecx, ecx                          # 004ae640
    mov cl, byte ptr [0x5d2f1b]                  # 004ae642
    mov edx, dword ptr [ebp - local_10]          # 004ae648
    shl edx, cl                                  # 004ae64b
    {load} xor eax, eax                          # 004ae64d
    mov al, byte ptr [0x5d2f1a]                  # 004ae64f
    {load} mov ecx, eax                          # 004ae654
    mov eax, dword ptr [ebp - local_4]           # 004ae656
    shl eax, cl                                  # 004ae659
    {load} or edx, eax                           # 004ae65b
    {load} xor ecx, ecx                          # 004ae65d
    mov cl, byte ptr [0x5d2f19]                  # 004ae65f
    mov eax, dword ptr [ebp - local_14]          # 004ae665
    shl eax, cl                                  # 004ae668
    {load} or edx, eax                           # 004ae66a
    mov ecx, dword ptr [ebp + arg_8]             # 004ae66c
    mov eax, dword ptr [ecx]                     # 004ae66f
    mov ecx, dword ptr [ebp - local_c]           # 004ae671
    mov word ptr [eax + ecx], dx                 # 004ae674
    jmp.d32 L_004ae4e9                           # 004ae678
L_004ae67d:
    # block 0x004ae67d: entered by jge at 0x004ae4fb, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004ae67d
    pop ebp                                      # 004ae67f
    ret 0x4                                      # 004ae680

