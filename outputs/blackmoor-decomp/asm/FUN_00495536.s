# FUN_00495536
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00495536
# extent:       0x00495536-0x00495608 (210 code bytes)
# span:         0x00495536-0x00495608 (code 210, tables 0, padding 0)
# sha256:       2096763c409a855969b691753f4b45eb4daa4d95f1bc8d09ff5d2542eb98d044
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00495536
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1, field_2; [ecx + n] field_1, field_2; [edx + n] field_1, field_2
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 76 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1, 0x1  # offset +0x1
.equ field_2, 0x2  # offset +0x2
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x00495536 - 0x401000
.globl FUN_00495536
FUN_00495536:
    # block 0x00495536: entry, 8 instruction(s), ends with je to 0x00495558 (forward)
    push ebp                                     # 00495536
    {load} mov ebp, esp                          # 00495537
    push ecx                                     # 00495539
    mov dword ptr [ebp - local_4], ecx           # 0049553a
    {load} xor eax, eax                          # 0049553d
    mov al, byte ptr [0x5d2f23]                  # 0049553f
    cmp eax, 0x5                                 # 00495544
    je.d8 L_00495558                             # 00495547
    # block 0x00495549: entered by fall-through of je at 0x00495547, 6 instruction(s), ends with forward jump to 0x00495565
    mov ecx, dword ptr [ebp + arg_8]             # 00495549
    mov dl, byte ptr [ecx]                       # 0049554c
    shr dl, 0x2                                  # 0049554e
    mov eax, dword ptr [ebp + arg_8]             # 00495551
    mov byte ptr [eax], dl                       # 00495554
    jmp.d8 L_00495565                            # 00495556
L_00495558:
    # block 0x00495558: entered by je at 0x00495547, 5 instruction(s), falls into the block at 0x00495565
    mov ecx, dword ptr [ebp + arg_8]             # 00495558
    mov dl, byte ptr [ecx]                       # 0049555b
    shr dl, 0x3                                  # 0049555d
    mov eax, dword ptr [ebp + arg_8]             # 00495560
    mov byte ptr [eax], dl                       # 00495563
L_00495565:
    # block 0x00495565: entered by jmp at 0x00495556, 4 instruction(s), ends with je to 0x00495583 (forward)
    {load} xor ecx, ecx                          # 00495565
    mov cl, byte ptr [0x5d2f22]                  # 00495567
    cmp ecx, 0x5                                 # 0049556d
    je.d8 L_00495583                             # 00495570
    # block 0x00495572: entered by fall-through of je at 0x00495570, 6 instruction(s), ends with forward jump to 0x00495592
    mov edx, dword ptr [ebp + arg_8]             # 00495572
    mov al, byte ptr [edx + field_1]             # 00495575
    shr al, 0x2                                  # 00495578
    mov ecx, dword ptr [ebp + arg_8]             # 0049557b
    mov byte ptr [ecx + field_1], al             # 0049557e
    jmp.d8 L_00495592                            # 00495581
L_00495583:
    # block 0x00495583: entered by je at 0x00495570, 5 instruction(s), falls into the block at 0x00495592
    mov edx, dword ptr [ebp + arg_8]             # 00495583
    mov al, byte ptr [edx + field_1]             # 00495586
    shr al, 0x3                                  # 00495589
    mov ecx, dword ptr [ebp + arg_8]             # 0049558c
    mov byte ptr [ecx + field_1], al             # 0049558f
L_00495592:
    # block 0x00495592: entered by jmp at 0x00495581, 4 instruction(s), ends with je to 0x004955b0 (forward)
    {load} xor edx, edx                          # 00495592
    mov dl, byte ptr [0x5d2f21]                  # 00495594
    cmp edx, 0x5                                 # 0049559a
    je.d8 L_004955b0                             # 0049559d
    # block 0x0049559f: entered by fall-through of je at 0x0049559d, 6 instruction(s), ends with forward jump to 0x004955bf
    mov eax, dword ptr [ebp + arg_8]             # 0049559f
    mov cl, byte ptr [eax + field_2]             # 004955a2
    shr cl, 0x2                                  # 004955a5
    mov edx, dword ptr [ebp + arg_8]             # 004955a8
    mov byte ptr [edx + field_2], cl             # 004955ab
    jmp.d8 L_004955bf                            # 004955ae
L_004955b0:
    # block 0x004955b0: entered by je at 0x0049559d, 5 instruction(s), falls into the block at 0x004955bf
    mov eax, dword ptr [ebp + arg_8]             # 004955b0
    mov cl, byte ptr [eax + field_2]             # 004955b3
    shr cl, 0x3                                  # 004955b6
    mov edx, dword ptr [ebp + arg_8]             # 004955b9
    mov byte ptr [edx + field_2], cl             # 004955bc
L_004955bf:
    # block 0x004955bf: entered by jmp at 0x004955ae, 27 instruction(s), ends with ret 0x8
    mov eax, dword ptr [ebp + arg_8]             # 004955bf
    {load} xor ecx, ecx                          # 004955c2
    mov cl, byte ptr [eax]                       # 004955c4
    {load} mov edx, ecx                          # 004955c6
    {load} xor ecx, ecx                          # 004955c8
    mov cl, byte ptr [0x5d2f1b]                  # 004955ca
    shl edx, cl                                  # 004955d0
    mov eax, dword ptr [ebp + arg_8]             # 004955d2
    {load} xor ecx, ecx                          # 004955d5
    mov cl, byte ptr [eax + field_1]             # 004955d7
    {load} mov eax, ecx                          # 004955da
    {load} xor ecx, ecx                          # 004955dc
    mov cl, byte ptr [0x5d2f1a]                  # 004955de
    shl eax, cl                                  # 004955e4
    {load} or edx, eax                           # 004955e6
    mov ecx, dword ptr [ebp + arg_8]             # 004955e8
    {load} xor eax, eax                          # 004955eb
    mov al, byte ptr [ecx + field_2]             # 004955ed
    {load} xor ecx, ecx                          # 004955f0
    mov cl, byte ptr [0x5d2f19]                  # 004955f2
    shl eax, cl                                  # 004955f8
    {load} or edx, eax                           # 004955fa
    mov ecx, dword ptr [ebp + arg_c]             # 004955fc
    mov word ptr [ecx], dx                       # 004955ff
    {load} mov esp, ebp                          # 00495602
    pop ebp                                      # 00495604
    ret 0x8                                      # 00495605

