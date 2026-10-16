# FUN_0044d624
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044d624
# extent:       0x0044d624-0x0044d711 (237 code bytes)
# span:         0x0044d624-0x0044d711 (code 237, tables 0, padding 0)
# sha256:       5e2e0bcb06613a9fc6bb1fa2b89eae56bd1f6f5c0629433ba3aef70f4c64f2e4
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044d624
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1e, field_25, field_29, field_2d; [ecx + n] field_1e, field_49, field_4b, field_261, field_286; [edx + n] field_24
# callees:      calls FUN_004f6334, FUN_004fb2e3, KERNEL32.dll!GetTickCount
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 66 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_24, 0x24  # offset +0x24
.equ field_25, 0x25  # offset +0x25
.equ field_29, 0x29  # offset +0x29
.equ field_2d, 0x2d  # offset +0x2d
.equ field_49, 0x49  # offset +0x49
.equ field_4b, 0x4b  # offset +0x4b
.equ field_261, 0x261  # offset +0x261
.equ field_286, 0x286  # offset +0x286

# --- external targets -----------------------------------------------
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x0044d624 - 0x401000
.globl FUN_0044d624
FUN_0044d624:
    # block 0x0044d624: entry, 14 instruction(s), ends with je to 0x0044d70b (forward)
    push ebp                                     # 0044d624
    {load} mov ebp, esp                          # 0044d625
    sub esp, 0xc                                 # 0044d627
    push esi                                     # 0044d62a
    push edi                                     # 0044d62b
    mov dword ptr [ebp - local_c], ecx           # 0044d62c
    mov eax, dword ptr [ebp - local_c]           # 0044d62f
    movsx ecx, word ptr [eax + field_1e]         # 0044d632
    imul ecx, ecx, 0x8d                          # 0044d636
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0044d63c
    mov dword ptr [ebp - local_4], edx           # 0044d642
    mov eax, dword ptr [ebp - local_c]           # 0044d645
    cmp dword ptr [eax + field_25], 0x0          # 0044d648
    je.d32 L_0044d70b                            # 0044d64c
    # block 0x0044d652: entered by fall-through of je at 0x0044d64c, 5 instruction(s), ends with jne to 0x0044d70b (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0044d652
    {load} xor edx, edx                          # 0044d655
    mov dl, byte ptr [ecx + field_49]            # 0044d657
    test edx, edx                                # 0044d65a
    jne.d32 L_0044d70b                           # 0044d65c
    # block 0x0044d662: entered by fall-through of jne at 0x0044d65c, 3 instruction(s), ends with je to 0x0044d70b (forward)
    mov eax, dword ptr [ebp - local_c]           # 0044d662
    cmp dword ptr [eax + field_29], 0x0          # 0044d665
    je.d32 L_0044d70b                            # 0044d669
    # block 0x0044d66f: entered by fall-through of je at 0x0044d669, 5 instruction(s), ends with jne to 0x0044d70b (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0044d66f
    movsx edx, word ptr [ecx + field_1e]         # 0044d672
    imul edx, edx, 0x8d                          # 0044d676
    cmp dword ptr [edx + 0x5bb632], 0x1          # 0044d67c
    jne.d32 L_0044d70b                           # 0044d683
    # block 0x0044d689: entered by fall-through of jne at 0x0044d683, 2 instruction(s), ends with je to 0x0044d6df (forward)
    cmp dword ptr [0x5bb1ca], 0x0                # 0044d689
    je.d8 L_0044d6df                             # 0044d690
    # block 0x0044d692: entered by fall-through of je at 0x0044d690, 7 instruction(s), ends with je to 0x0044d6df (forward)
    mov edi, 0x5495b0                            # 0044d692
    mov esi, dword ptr [ebp - local_4]           # 0044d697
    add esi, 0x265                               # 0044d69a
    mov ecx, 0x9                                 # 0044d6a0
    {load} xor eax, eax                          # 0044d6a5
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0044d6a7
    je.d8 L_0044d6df                             # 0044d6a9
    # block 0x0044d6ab: entered by fall-through of je at 0x0044d6a9, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x0044d6df (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0044d6ab
    movsx edx, word ptr [ecx + field_286]        # 0044d6ae
    mov dword ptr [ebp - local_8], edx           # 0044d6b5
    mov eax, dword ptr [ebp - local_8]           # 0044d6b8
    push eax                                     # 0044d6bb
    mov ecx, 0x5cf1eb                            # 0044d6bc
    call FUN_004f6334                            # 0044d6c1
    test eax, eax                                # 0044d6c6
    jne.d8 L_0044d6df                            # 0044d6c8
    # block 0x0044d6ca: entered by fall-through of jne at 0x0044d6c8, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x0044d6df
    mov ecx, dword ptr [ebp - local_4]           # 0044d6ca
    mov dx, word ptr [ecx + field_286]           # 0044d6cd
    push edx                                     # 0044d6d4
    mov ecx, 0x5c3a67                            # 0044d6d5
    call FUN_004fb2e3                            # 0044d6da
L_0044d6df:
    # block 0x0044d6df: entered by je at 0x0044d690; je at 0x0044d6a9; jne at 0x0044d6c8, 11 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x0044d70b
    mov eax, dword ptr [ebp - local_c]           # 0044d6df
    mov dword ptr [eax + field_2d], 0x2          # 0044d6e2
    call dword ptr [0x52a23c]                    # 0044d6e9
    mov ecx, dword ptr [ebp - local_4]           # 0044d6ef
    movsx edx, word ptr [ecx + field_261]        # 0044d6f2
    imul edx, edx, 0x64                          # 0044d6f9
    {load} add eax, edx                          # 0044d6fc
    mov ecx, dword ptr [ebp - local_c]           # 0044d6fe
    mov dword ptr [ecx + field_4b], eax          # 0044d701
    mov edx, dword ptr [ebp - local_c]           # 0044d704
    mov byte ptr [edx + field_24], 0x1           # 0044d707
L_0044d70b:
    # block 0x0044d70b: entered by je at 0x0044d64c; jne at 0x0044d65c; je at 0x0044d669; jne at 0x0044d683, 5 instruction(s), ends with ret
    pop edi                                      # 0044d70b
    pop esi                                      # 0044d70c
    {load} mov esp, ebp                          # 0044d70d
    pop ebp                                      # 0044d70f
    ret                                          # 0044d710

