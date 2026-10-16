# FUN_004d8fb6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d8fb6
# extent:       0x004d8fb6-0x004d912a (372 code bytes)
# span:         0x004d8fb6-0x004d912a (code 372, tables 0, padding 0)
# sha256:       86270d094ae5f808356f03a718b9f850f891de89733fe20e102f259f038cb632
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d8fb6
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_108, field_9804, field_9808, field_98a0; [ecx + n] field_100, field_9804, field_98a0; [edx + n] field_104, field_9808, field_3360f
# callees:      calls FUN_0050d1f0, FUN_00516530, FUN_004d7ea4, FUN_004d9910
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 112 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_100, 0x100  # offset +0x100
.equ field_104, 0x104  # offset +0x104
.equ field_108, 0x108  # offset +0x108
.equ field_9804, 0x9804  # offset +0x9804
.equ field_9808, 0x9808  # offset +0x9808
.equ field_98a0, 0x98a0  # offset +0x98a0
.equ field_3360f, 0x3360f  # offset +0x3360f

# --- external targets -----------------------------------------------
.set FUN_004d7ea4, .text + (0x004d7ea4 - 0x401000)
.set FUN_004d9910, .text + (0x004d9910 - 0x401000)
.set FUN_0050d1f0, .text + (0x0050d1f0 - 0x401000)
.set FUN_00516530, .text + (0x00516530 - 0x401000)

.org 0x004d8fb6 - 0x401000
.globl FUN_004d8fb6
FUN_004d8fb6:
    # block 0x004d8fb6: entry, 35 instruction(s), calls FUN_0050d1f0, FUN_00516530, ends with je to 0x004d9042 (forward)
    push ebp                                     # 004d8fb6
    {load} mov ebp, esp                          # 004d8fb7
    sub esp, 0x8                                 # 004d8fb9
    push esi                                     # 004d8fbc
    push edi                                     # 004d8fbd
    mov dword ptr [ebp - local_8], ecx           # 004d8fbe
    mov dword ptr [ebp - local_4], 0x0           # 004d8fc1
    mov eax, dword ptr [ebp - local_8]           # 004d8fc8
    add eax, 0x336ef                             # 004d8fcb
    push eax                                     # 004d8fd0
    mov ecx, dword ptr [ebp - local_8]           # 004d8fd1
    add ecx, 0x335ef                             # 004d8fd4
    push ecx                                     # 004d8fda
    mov edx, dword ptr [ebp - local_8]           # 004d8fdb
    add edx, 0x334ef                             # 004d8fde
    push edx                                     # 004d8fe4
    mov eax, dword ptr [ebp - local_8]           # 004d8fe5
    add eax, 0x334ec                             # 004d8fe8
    push eax                                     # 004d8fed
    mov ecx, dword ptr [ebp + arg_8]             # 004d8fee
    push ecx                                     # 004d8ff1
    call FUN_0050d1f0                            # 004d8ff2
    add esp, 0x14                                # 004d8ff7
    mov edx, dword ptr [ebp - local_8]           # 004d8ffa
    mov byte ptr [edx + field_3360f], 0x0        # 004d8ffd
    mov eax, dword ptr [ebp - local_8]           # 004d9004
    add eax, 0x29b                               # 004d9007
    push eax                                     # 004d900c
    mov ecx, dword ptr [ebp - local_8]           # 004d900d
    add ecx, 0x335ef                             # 004d9010
    push ecx                                     # 004d9016
    call FUN_00516530                            # 004d9017
    add esp, 0x8                                 # 004d901c
    test eax, eax                                # 004d901f
    je.d8 L_004d9042                             # 004d9021
    # block 0x004d9023: entered by fall-through of je at 0x004d9021, 10 instruction(s), calls FUN_00516530, ends with jne to 0x004d904a (forward)
    mov edx, dword ptr [ebp - local_8]           # 004d9023
    add edx, 0x2a5                               # 004d9026
    push edx                                     # 004d902c
    mov eax, dword ptr [ebp - local_8]           # 004d902d
    add eax, 0x335ef                             # 004d9030
    push eax                                     # 004d9035
    call FUN_00516530                            # 004d9036
    add esp, 0x8                                 # 004d903b
    test eax, eax                                # 004d903e
    jne.d8 L_004d904a                            # 004d9040
L_004d9042:
    # block 0x004d9042: entered by je at 0x004d9021; fall-through of jne at 0x004d9040, 2 instruction(s), ends with forward jump to 0x004d9122
    mov eax, dword ptr [ebp - local_4]           # 004d9042
    jmp.d32 L_004d9122                           # 004d9045
L_004d904a:
    # block 0x004d904a: entered by jne at 0x004d9040, 7 instruction(s), calls FUN_004d7ea4, ends with jne to 0x004d9068 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004d904a
    add ecx, 0x335ef                             # 004d904d
    push ecx                                     # 004d9053
    mov ecx, dword ptr [ebp - local_8]           # 004d9054
    call FUN_004d7ea4                            # 004d9057
    test eax, eax                                # 004d905c
    jne.d8 L_004d9068                            # 004d905e
    # block 0x004d9060: entered by fall-through of jne at 0x004d905e, 2 instruction(s), ends with forward jump to 0x004d9122
    mov eax, dword ptr [ebp - local_4]           # 004d9060
    jmp.d32 L_004d9122                           # 004d9063
L_004d9068:
    # block 0x004d9068: entered by jne at 0x004d905e, 27 instruction(s), calls FUN_004d9910, ends with jne to 0x004d90da (forward)
    push 0x10c                                   # 004d9068
    lea edx, [ebp - local_4]                     # 004d906d
    push edx                                     # 004d9070
    mov ecx, dword ptr [ebp - local_8]           # 004d9071
    call FUN_004d9910                            # 004d9074
    mov edi, dword ptr [ebp - local_8]           # 004d9079
    add edi, 0x335ef                             # 004d907c
    or ecx, -0x1                                 # 004d9082
    {load} xor eax, eax                          # 004d9085
    repne scasb al, byte ptr es:[edi]            # 004d9087
    not ecx                                      # 004d9089
    add ecx, -0x1                                # 004d908b
    mov esi, dword ptr [ebp - local_8]           # 004d908e
    add esi, 0x335ef                             # 004d9091
    mov edi, dword ptr [ebp - local_4]           # 004d9097
    {load} mov eax, ecx                          # 004d909a
    shr ecx, 0x2                                 # 004d909c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d909f
    {load} mov ecx, eax                          # 004d90a1
    and ecx, 0x3                                 # 004d90a3
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004d90a6
    mov ecx, dword ptr [ebp - local_4]           # 004d90a8
    mov edx, dword ptr [ebp + arg_c]             # 004d90ab
    mov dword ptr [ecx + field_100], edx         # 004d90ae
    mov eax, dword ptr [ebp - local_8]           # 004d90b4
    cmp dword ptr [eax + field_9804], 0x0        # 004d90b7
    jne.d8 L_004d90da                            # 004d90be
    # block 0x004d90c0: entered by fall-through of jne at 0x004d90be, 7 instruction(s), ends with forward jump to 0x004d910a
    mov ecx, dword ptr [ebp - local_8]           # 004d90c0
    mov edx, dword ptr [ebp - local_4]           # 004d90c3
    mov dword ptr [ecx + field_9804], edx        # 004d90c6
    mov eax, dword ptr [ebp - local_8]           # 004d90cc
    mov ecx, dword ptr [ebp - local_4]           # 004d90cf
    mov dword ptr [eax + field_9808], ecx        # 004d90d2
    jmp.d8 L_004d910a                            # 004d90d8
L_004d90da:
    # block 0x004d90da: entered by jne at 0x004d90be, 11 instruction(s), falls into the block at 0x004d910a
    mov edx, dword ptr [ebp - local_8]           # 004d90da
    mov eax, dword ptr [edx + field_9808]        # 004d90dd
    mov ecx, dword ptr [ebp - local_4]           # 004d90e3
    mov dword ptr [eax + field_108], ecx         # 004d90e6
    mov edx, dword ptr [ebp - local_4]           # 004d90ec
    mov eax, dword ptr [ebp - local_8]           # 004d90ef
    mov ecx, dword ptr [eax + field_9808]        # 004d90f2
    mov dword ptr [edx + field_104], ecx         # 004d90f8
    mov edx, dword ptr [ebp - local_8]           # 004d90fe
    mov eax, dword ptr [ebp - local_4]           # 004d9101
    mov dword ptr [edx + field_9808], eax        # 004d9104
L_004d910a:
    # block 0x004d910a: entered by jmp at 0x004d90d8, 6 instruction(s), falls into the block at 0x004d9122
    mov ecx, dword ptr [ebp - local_8]           # 004d910a
    mov edx, dword ptr [ecx + field_98a0]        # 004d910d
    add edx, 0x1                                 # 004d9113
    mov eax, dword ptr [ebp - local_8]           # 004d9116
    mov dword ptr [eax + field_98a0], edx        # 004d9119
    mov eax, dword ptr [ebp - local_4]           # 004d911f
L_004d9122:
    # block 0x004d9122: entered by jmp at 0x004d9045; jmp at 0x004d9063, 5 instruction(s), ends with ret 0x8
    pop edi                                      # 004d9122
    pop esi                                      # 004d9123
    {load} mov esp, ebp                          # 004d9124
    pop ebp                                      # 004d9126
    ret 0x8                                      # 004d9127

