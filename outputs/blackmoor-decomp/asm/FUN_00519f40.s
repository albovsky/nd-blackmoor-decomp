# FUN_00519f40
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00519f40
# extent:       0x00519f40-0x0051a0ca (394 code bytes)
# span:         0x00519f40-0x0051a0ca (code 394, tables 0, padding 0)
# sha256:       6bfdad98186b34bdf54052fa04077f634bf4fe18ce693e9c3606b9bcdf984c62
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00519f40
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_d0, field_d4, field_d8; [esi + n] field_18, field_92, field_1f4
# callees:      calls FUN_00525b0f, FUN_0051d392, FUN_0051dc77, FUN_0051ac0b, FUN_0051f599, USER32.dll!SendMessageA; plus 10 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 114 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_92, 0x92  # offset +0x92
.equ field_d0, 0xd0  # offset +0xd0
.equ field_d4, 0xd4  # offset +0xd4
.equ field_d8, 0xd8  # offset +0xd8
.equ field_1f4, 0x1f4  # offset +0x1f4

# --- external targets -----------------------------------------------
.set FUN_0051ac0b, .text + (0x0051ac0b - 0x401000)
.set FUN_0051d392, .text + (0x0051d392 - 0x401000)
.set FUN_0051dc77, .text + (0x0051dc77 - 0x401000)
.set FUN_0051f599, .text + (0x0051f599 - 0x401000)
.set FUN_00525b0f, .text + (0x00525b0f - 0x401000)

.org 0x00519f40 - 0x401000
.globl FUN_00519f40
FUN_00519f40:
    # block 0x00519f40: entry, 7 instruction(s), ends with je to 0x0051a097 (forward)
    push ebp                                     # 00519f40
    {load} mov ebp, esp                          # 00519f41
    cmp dword ptr [ebp + arg_8], 0x0             # 00519f43
    push ebx                                     # 00519f47
    push esi                                     # 00519f48
    push edi                                     # 00519f49
    je.d32 L_0051a097                            # 00519f4a
    # block 0x00519f50: entered by fall-through of je at 0x00519f4a, 7 instruction(s), calls FUN_00525b0f, ends with je to 0x00519f74 (forward)
    push 0x52496c                                # 00519f50
    mov ecx, 0x63c444                            # 00519f55
    call FUN_00525b0f                            # 00519f5a
    {load} mov esi, eax                          # 00519f5f
    mov ecx, dword ptr [esi + field_18]          # 00519f61
    test ecx, ecx                                # 00519f64
    je.d8 L_00519f74                             # 00519f66
    # block 0x00519f68: entered by fall-through of je at 0x00519f66, 3 instruction(s), calls FUN_0051d392, falls into the block at 0x00519f74
    push dword ptr [ebp + arg_8]                 # 00519f68
    call FUN_0051d392                            # 00519f6b
    and dword ptr [esi + field_18], 0x0          # 00519f70
L_00519f74:
    # block 0x00519f74: entered by je at 0x00519f66, 4 instruction(s), ends with jne to 0x00519fe2 (forward)
    mov edi, dword ptr [ebp + arg_c]             # 00519f74
    mov ebx, 0x110                               # 00519f77
    {load} cmp edi, ebx                          # 00519f7c
    jne.d8 L_00519fe2                            # 00519f7e
    # block 0x00519f80: entered by fall-through of jne at 0x00519f7e, 25 instruction(s), calls indirect esi, FUN_0051dc77, ends with forward jump to 0x0051a0c3
    mov esi, dword ptr [0x52a460]                # 00519f80
    push 0x5301d0                                # 00519f86
    call esi                                     # 00519f8b
    push 0x5301b8                                # 00519f8d
    mov dword ptr [0x63ca00], eax                # 00519f92
    call esi                                     # 00519f97
    push 0x5301a4                                # 00519f99
    mov dword ptr [0x63c9fc], eax                # 00519f9e
    call esi                                     # 00519fa3
    push 0x530194                                # 00519fa5
    mov dword ptr [0x63c9f8], eax                # 00519faa
    call esi                                     # 00519faf
    push 0x530184                                # 00519fb1
    mov dword ptr [0x63c9f4], eax                # 00519fb6
    call esi                                     # 00519fbb
    push 0x530170                                # 00519fbd
    mov dword ptr [0x63c9f0], eax                # 00519fc2
    call esi                                     # 00519fc7
    push dword ptr [ebp + arg_14]                # 00519fc9
    mov dword ptr [0x63c9ec], eax                # 00519fcc
    push dword ptr [ebp + arg_10]                # 00519fd1
    push ebx                                     # 00519fd4
    push dword ptr [ebp + arg_8]                 # 00519fd5
    call FUN_0051dc77                            # 00519fd8
    jmp.d32 L_0051a0c3                           # 00519fdd
L_00519fe2:
    # block 0x00519fe2: entered by jne at 0x00519f7e, 3 instruction(s), ends with je to 0x0051a0af (forward)
    cmp edi, dword ptr [0x63c9f0]                # 00519fe2
    mov eax, 0x111                               # 00519fe8
    je.d32 L_0051a0af                            # 00519fed
    # block 0x00519ff3: entered by fall-through of je at 0x00519fed, 2 instruction(s), ends with jne to 0x0051a003 (forward)
    {load} cmp edi, eax                          # 00519ff3
    jne.d8 L_0051a003                            # 00519ff5
    # block 0x00519ff7: entered by fall-through of jne at 0x00519ff5, 2 instruction(s), ends with je to 0x0051a0af (forward)
    .insn 0x6681/7, dword ptr [ebp + arg_10], 1038{:s16} # 00519ff7
    je.d32 L_0051a0af                            # 00519ffd
L_0051a003:
    # block 0x0051a003: entered by jne at 0x00519ff5; fall-through of je at 0x00519ffd, 2 instruction(s), ends with jb to 0x0051a097 (forward)
    cmp edi, 0xc000                              # 0051a003
    jb.d32 L_0051a097                            # 0051a009
    # block 0x0051a00f: entered by fall-through of jb at 0x0051a009, 8 instruction(s), calls FUN_0051ac0b, FUN_0051f599, ends with je to 0x0051a032 (forward)
    push dword ptr [ebp + arg_8]                 # 0051a00f
    call FUN_0051ac0b                            # 0051a012
    {load} mov esi, eax                          # 0051a017
    push 0x530200                                # 0051a019
    {load} mov ecx, esi                          # 0051a01e
    call FUN_0051f599                            # 0051a020
    test eax, eax                                # 0051a025
    je.d8 L_0051a032                             # 0051a027
    # block 0x0051a029: entered by fall-through of je at 0x0051a027, 2 instruction(s), ends with jne to 0x0051a097 (forward)
    test byte ptr [esi + field_92], 0x8          # 0051a029
    jne.d8 L_0051a097                            # 0051a030
L_0051a032:
    # block 0x0051a032: entered by je at 0x0051a027; fall-through of jne at 0x0051a030, 2 instruction(s), ends with jne to 0x0051a049 (forward)
    cmp edi, dword ptr [0x63c9fc]                # 0051a032
    jne.d8 L_0051a049                            # 0051a038
    # block 0x0051a03a: entered by fall-through of jne at 0x0051a038, 5 instruction(s), calls indirect dword ptr [eax + 0xd0], ends with forward jump to 0x0051a0c3
    mov eax, dword ptr [esi]                     # 0051a03a
    push dword ptr [ebp + arg_14]                # 0051a03c
    {load} mov ecx, esi                          # 0051a03f
    call dword ptr [eax + field_d0]              # 0051a041
    jmp.d8 L_0051a0c3                            # 0051a047
L_0051a049:
    # block 0x0051a049: entered by jne at 0x0051a038, 2 instruction(s), ends with jne to 0x0051a076 (forward)
    cmp edi, dword ptr [0x63c9f8]                # 0051a049
    jne.d8 L_0051a076                            # 0051a04f
    # block 0x0051a051: entered by fall-through of jne at 0x0051a04f, 2 instruction(s), ends with je to 0x0051a063 (forward)
    cmp dword ptr [0x63c7a4], 0x0                # 0051a051
    je.d8 L_0051a063                             # 0051a058
    # block 0x0051a05a: entered by fall-through of je at 0x0051a058, 2 instruction(s), falls into the block at 0x0051a063
    mov eax, dword ptr [ebp + arg_14]            # 0051a05a
    mov dword ptr [esi + field_1f4], eax         # 0051a05d
L_0051a063:
    # block 0x0051a063: entered by je at 0x0051a058, 5 instruction(s), calls indirect dword ptr [eax + 0xd4], ends with forward jump to 0x0051a0c3
    mov eax, dword ptr [esi]                     # 0051a063
    {load} mov ecx, esi                          # 0051a065
    call dword ptr [eax + field_d4]              # 0051a067
    and dword ptr [esi + field_1f4], 0x0         # 0051a06d
    jmp.d8 L_0051a0c3                            # 0051a074
L_0051a076:
    # block 0x0051a076: entered by jne at 0x0051a04f, 2 instruction(s), ends with jne to 0x0051a09b (forward)
    cmp edi, dword ptr [0x63ca00]                # 0051a076
    jne.d8 L_0051a09b                            # 0051a07c
    # block 0x0051a07e: entered by fall-through of jne at 0x0051a07c, 9 instruction(s), calls indirect dword ptr [eax + 0xd8], falls into the block at 0x0051a097
    mov ecx, dword ptr [ebp + arg_14]            # 0051a07e
    mov eax, dword ptr [esi]                     # 0051a081
    shr ecx, 0x10                                # 0051a083
    push ecx                                     # 0051a086
    movzx ecx, word ptr [ebp + arg_14]           # 0051a087
    push ecx                                     # 0051a08b
    {load} mov ecx, esi                          # 0051a08c
    push dword ptr [ebp + arg_10]                # 0051a08e
    call dword ptr [eax + field_d8]              # 0051a091
L_0051a097:
    # block 0x0051a097: entered by je at 0x00519f4a; jb at 0x0051a009; jne at 0x0051a030; jne at 0x0051a0a1, 2 instruction(s), ends with forward jump to 0x0051a0c3
    {load} xor eax, eax                          # 0051a097
    jmp.d8 L_0051a0c3                            # 0051a099
L_0051a09b:
    # block 0x0051a09b: entered by jne at 0x0051a07c, 2 instruction(s), ends with jne to 0x0051a097 (backward)
    cmp edi, dword ptr [0x63c9f4]                # 0051a09b
    jne.d8 L_0051a097                            # 0051a0a1
    # block 0x0051a0a3: entered by fall-through of jne at 0x0051a0a1, 4 instruction(s), calls indirect dword ptr [eax + 0xd0], ends with forward jump to 0x0051a0c3
    mov eax, dword ptr [esi]                     # 0051a0a3
    {load} mov ecx, esi                          # 0051a0a5
    call dword ptr [eax + field_d0]              # 0051a0a7
    jmp.d8 L_0051a0c3                            # 0051a0ad
L_0051a0af:
    # block 0x0051a0af: entered by je at 0x00519fed; je at 0x00519ffd, 7 instruction(s), calls USER32.dll!SendMessageA, falls into the block at 0x0051a0c3
    push 0x0                                     # 0051a0af
    push 0xe146                                  # 0051a0b1
    push eax                                     # 0051a0b6
    push dword ptr [ebp + arg_8]                 # 0051a0b7
    call dword ptr [0x52a4c8]                    # 0051a0ba
    push 0x1                                     # 0051a0c0
    pop eax                                      # 0051a0c2
L_0051a0c3:
    # block 0x0051a0c3: entered by jmp at 0x00519fdd; jmp at 0x0051a047; jmp at 0x0051a074; jmp at 0x0051a099; more, 5 instruction(s), ends with ret 0x10
    pop edi                                      # 0051a0c3
    pop esi                                      # 0051a0c4
    pop ebx                                      # 0051a0c5
    pop ebp                                      # 0051a0c6
    ret 0x10                                     # 0051a0c7

