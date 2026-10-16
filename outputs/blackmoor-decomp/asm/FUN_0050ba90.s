# FUN_0050ba90
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050ba90
# extent:       0x0050ba90-0x0050bbbe (302 code bytes)
# span:         0x0050ba90-0x0050bbc0 (code 302, tables 0, padding 2)
# sha256:       21855f13c6707aebad7566d11b3daac00969597e1f192d987f3ea3d5f43ddc61
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050ba90
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_c, field_10, field_14, field_20, field_24, field_156, field_15a; [ebp + n] field_4; [edx + n] field_4; [esi + n] field_4, field_8, field_c, field_10, field_14, field_18, field_1c; [esp + n] stk_4, stk_14, stk_18, stk_1c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 102 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ field_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ stk_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_156, 0x156  # offset +0x156
.equ field_15a, 0x15a  # offset +0x15a

# --- external targets -----------------------------------------------

.org 0x0050ba90 - 0x401000
.globl FUN_0050ba90
FUN_0050ba90:
    # block 0x0050ba90: entry, 8 instruction(s), ends with jg to 0x0050baa7 (forward)
    mov eax, dword ptr [esp + stk_4]             # 0050ba90
    push ebx                                     # 0050ba94
    push ebp                                     # 0050ba95
    push esi                                     # 0050ba96
    mov ebx, dword ptr [eax + field_24]          # 0050ba97
    mov ecx, dword ptr [eax + field_20]          # 0050ba9a
    {load} cmp ecx, ebx                          # 0050ba9d
    jg.d8 L_0050baa7                             # 0050ba9f
    # block 0x0050baa1: entered by fall-through of jg at 0x0050ba9f, 5 instruction(s), ends with ret
    pop esi                                      # 0050baa1
    pop ebp                                      # 0050baa2
    {load} xor eax, eax                          # 0050baa3
    pop ebx                                      # 0050baa5
    ret                                          # 0050baa6
L_0050baa7:
    # block 0x0050baa7: entered by jg at 0x0050ba9f, 5 instruction(s), ends with je to 0x0050bade (forward)
    mov ecx, dword ptr [eax + field_10]          # 0050baa7
    lea ebp, [ecx + 4*ebx]                       # 0050baaa
    mov ecx, dword ptr [ecx + 4*ebx]             # 0050baad
    test ch, 0x4                                 # 0050bab0
    je.d8 L_0050bade                             # 0050bab3
    # block 0x0050bab5: entered by fall-through of je at 0x0050bab3, 13 instruction(s), ends with ret
    mov edx, dword ptr [eax + field_156]         # 0050bab5
    inc ebx                                      # 0050babb
    add edx, 0x1                                 # 0050babc
    pop esi                                      # 0050babf
    mov dword ptr [eax + field_156], edx         # 0050bac0
    mov ecx, dword ptr [eax + field_15a]         # 0050bac6
    adc ecx, 0x0                                 # 0050bacc
    mov dword ptr [eax + field_24], ebx          # 0050bacf
    mov dword ptr [eax + field_15a], ecx         # 0050bad2
    pop ebp                                      # 0050bad8
    or eax, -0x1                                 # 0050bad9
    pop ebx                                      # 0050badc
    ret                                          # 0050badd
L_0050bade:
    # block 0x0050bade: entered by je at 0x0050bab3, 3 instruction(s), ends with jne to 0x0050baf7 (forward)
    mov esi, dword ptr [esp + stk_14]            # 0050bade
    test esi, esi                                # 0050bae2
    jne.d8 L_0050baf7                            # 0050bae4
    # block 0x0050bae6: entered by fall-through of jne at 0x0050bae4, 3 instruction(s), ends with jne to 0x0050baf7 (forward)
    mov edx, dword ptr [esp + stk_18]            # 0050bae6
    test edx, edx                                # 0050baea
    jne.d8 L_0050baf7                            # 0050baec
    # block 0x0050baee: entered by fall-through of jne at 0x0050baec, 5 instruction(s), ends with ret
    pop esi                                      # 0050baee
    pop ebp                                      # 0050baef
    mov eax, 0x1                                 # 0050baf0
    pop ebx                                      # 0050baf5
    ret                                          # 0050baf6
L_0050baf7:
    # block 0x0050baf7: entered by jne at 0x0050bae4; jne at 0x0050baec, 10 instruction(s), ends with jne to 0x0050bb48 (forward)
    push edi                                     # 0050baf7
    {load} mov edi, ecx                          # 0050baf8
    {load} mov edx, ecx                          # 0050bafa
    and edi, 0xff                                # 0050bafc
    and edx, 0x200                               # 0050bb02
    and ecx, 0x100                               # 0050bb08
    cmp edi, 0xff                                # 0050bb0e
    mov dword ptr [esp + stk_14], edx            # 0050bb14
    mov dword ptr [esp + stk_18], ecx            # 0050bb18
    jne.d8 L_0050bb48                            # 0050bb1c
L_0050bb1e:
    # block 0x0050bb1e: entered by je at 0x0050bb42; fall-through of jne at 0x0050bb1c, 7 instruction(s), ends with je to 0x0050bb3a (forward)
    mov edx, dword ptr [ebp + field_4]           # 0050bb1e
    add ebp, 0x4                                 # 0050bb21
    {load} mov ecx, edx                          # 0050bb24
    inc ebx                                      # 0050bb26
    and ecx, 0xff                                # 0050bb27
    test dh, 0x2                                 # 0050bb2d
    je.d8 L_0050bb3a                             # 0050bb30
    # block 0x0050bb32: entered by fall-through of je at 0x0050bb30, 1 instruction(s), falls into the block at 0x0050bb3a
    mov dword ptr [esp + stk_14], 0x200          # 0050bb32
L_0050bb3a:
    # block 0x0050bb3a: entered by je at 0x0050bb30, 3 instruction(s), ends with je to 0x0050bb1e (backward)
    {load} add edi, ecx                          # 0050bb3a
    cmp ecx, 0xff                                # 0050bb3c
    je.d8 L_0050bb1e                             # 0050bb42
    # block 0x0050bb44: entered by fall-through of je at 0x0050bb42, 1 instruction(s), falls into the block at 0x0050bb48
    mov edx, dword ptr [esp + stk_14]            # 0050bb44
L_0050bb48:
    # block 0x0050bb48: entered by jne at 0x0050bb1c, 2 instruction(s), ends with je to 0x0050bb82 (forward)
    test esi, esi                                # 0050bb48
    je.d8 L_0050bb82                             # 0050bb4a
    # block 0x0050bb4c: entered by fall-through of je at 0x0050bb4a, 16 instruction(s), falls into the block at 0x0050bb82
    mov dword ptr [esi + field_c], edx           # 0050bb4c
    mov edx, dword ptr [esp + stk_18]            # 0050bb4f
    mov dword ptr [esi + field_8], edx           # 0050bb53
    mov ecx, dword ptr [eax + field_c]           # 0050bb56
    add ecx, dword ptr [eax]                     # 0050bb59
    mov dword ptr [esi], ecx                     # 0050bb5b
    mov edx, dword ptr [eax + field_156]         # 0050bb5d
    mov dword ptr [esi + field_18], edx          # 0050bb63
    mov ecx, dword ptr [eax + field_15a]         # 0050bb66
    mov dword ptr [esi + field_1c], ecx          # 0050bb6c
    mov edx, dword ptr [eax + field_14]          # 0050bb6f
    mov ecx, dword ptr [edx + 8*ebx]             # 0050bb72
    mov dword ptr [esi + field_10], ecx          # 0050bb75
    mov edx, dword ptr [edx + 8*ebx + field_4]   # 0050bb78
    mov dword ptr [esi + field_4], edi           # 0050bb7c
    mov dword ptr [esi + field_14], edx          # 0050bb7f
L_0050bb82:
    # block 0x0050bb82: entered by je at 0x0050bb4a, 3 instruction(s), ends with je to 0x0050bbb4 (forward)
    mov ecx, dword ptr [esp + stk_1c]            # 0050bb82
    test ecx, ecx                                # 0050bb86
    je.d8 L_0050bbb4                             # 0050bb88
    # block 0x0050bb8a: entered by fall-through of je at 0x0050bb88, 11 instruction(s), falls into the block at 0x0050bbb4
    mov esi, dword ptr [eax + field_c]           # 0050bb8a
    mov edx, dword ptr [eax + field_156]         # 0050bb8d
    {load} add esi, edi                          # 0050bb93
    inc ebx                                      # 0050bb95
    add edx, 0x1                                 # 0050bb96
    mov dword ptr [eax + field_c], esi           # 0050bb99
    mov dword ptr [eax + field_156], edx         # 0050bb9c
    mov ecx, dword ptr [eax + field_15a]         # 0050bba2
    adc ecx, 0x0                                 # 0050bba8
    mov dword ptr [eax + field_24], ebx          # 0050bbab
    mov dword ptr [eax + field_15a], ecx         # 0050bbae
L_0050bbb4:
    # block 0x0050bbb4: entered by je at 0x0050bb88, 6 instruction(s), ends with ret
    pop edi                                      # 0050bbb4
    pop esi                                      # 0050bbb5
    pop ebp                                      # 0050bbb6
    mov eax, 0x1                                 # 0050bbb7
    pop ebx                                      # 0050bbbc
    ret                                          # 0050bbbd

# --- data items (not part of the function) -------------------------
.org 0x0050bbbe - 0x401000
PAD_0050bbbe:  # 2 byte(s) of nop padding
    .fill 2, 1, 0x90

