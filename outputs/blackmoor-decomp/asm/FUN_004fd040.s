# FUN_004fd040
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fd040
# extent:       0x004fd040-0x004fd153 (275 code bytes)
# span:         0x004fd040-0x004fd160 (code 275, tables 0, padding 13)
# sha256:       febd5720f0c20551b6a3488635abdeae4e58450e3fe0f2faf94cbea868f30cc9
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fd040
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_8, field_c; [ebx + n] field_4, field_18, field_34, field_48, field_4c, field_58, field_5c, field_74, field_2ae; [esp + n] stk_c, stk_14, stk_18, stk_20, stk_24, stk_2c, stk_30
# callees:      calls FUN_0050b4b0, FUN_0050b500, FUN_0050b580, FUN_0050e97e, FUN_0050b2c0, FUN_004fd160, FUN_004fcef0; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 108 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ field_18, 0x18  # offset +0x18
.equ stk_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ stk_2c, 0x2c  # offset +0x2c
.equ stk_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_48, 0x48  # offset +0x48
.equ field_4c, 0x4c  # offset +0x4c
.equ field_58, 0x58  # offset +0x58
.equ field_5c, 0x5c  # offset +0x5c
.equ field_74, 0x74  # offset +0x74
.equ field_2ae, 0x2ae  # offset +0x2ae

# --- external targets -----------------------------------------------
.set FUN_004fcef0, .text + (0x004fcef0 - 0x401000)
.set FUN_004fd160, .text + (0x004fd160 - 0x401000)
.set FUN_0050b2c0, .text + (0x0050b2c0 - 0x401000)
.set FUN_0050b4b0, .text + (0x0050b4b0 - 0x401000)
.set FUN_0050b500, .text + (0x0050b500 - 0x401000)
.set FUN_0050b580, .text + (0x0050b580 - 0x401000)
.set FUN_0050e97e, .text + (0x0050e97e - 0x401000)

.org 0x004fd040 - 0x401000
.globl FUN_004fd040
FUN_004fd040:
    # block 0x004fd040: entry, 8 instruction(s), ends with je to 0x004fd062 (forward)
    push ebx                                     # 004fd040
    push ebp                                     # 004fd041
    mov ebp, dword ptr [esp + stk_c]             # 004fd042
    push esi                                     # 004fd046
    mov esi, dword ptr [esp + stk_24]            # 004fd047
    push edi                                     # 004fd04b
    test ebp, ebp                                # 004fd04c
    je.d8 L_004fd062                             # 004fd04e
    # block 0x004fd050: entered by fall-through of je at 0x004fd04e, 8 instruction(s), calls indirect esi, ends with forward jump to 0x004fd06a
    push 0x1                                     # 004fd050
    push 0x0                                     # 004fd052
    push 0x0                                     # 004fd054
    push ebp                                     # 004fd056
    call esi                                     # 004fd057
    add esp, 0x10                                # 004fd059
    mov dword ptr [esp + stk_14], eax            # 004fd05c
    jmp.d8 L_004fd06a                            # 004fd060
L_004fd062:
    # block 0x004fd062: entered by je at 0x004fd04e, 1 instruction(s), falls into the block at 0x004fd06a
    mov dword ptr [esp + stk_14], 0xffffffff     # 004fd062
L_004fd06a:
    # block 0x004fd06a: entered by jmp at 0x004fd060, 22 instruction(s), calls FUN_0050b4b0, ends with je to 0x004fd0d9 (forward)
    mov ebx, dword ptr [esp + stk_18]            # 004fd06a
    mov ecx, 0xaf                                # 004fd06e
    {load} xor eax, eax                          # 004fd073
    {load} mov edi, ebx                          # 004fd075
    rep stosd dword ptr es:[edi], eax            # 004fd077
    mov ecx, dword ptr [esp + stk_24]            # 004fd079
    mov edx, dword ptr [esp + stk_2c]            # 004fd07d
    stosw word ptr es:[edi], ax                  # 004fd081
    lea eax, [ebx + field_2ae]                   # 004fd083
    mov dword ptr [ebx], ebp                     # 004fd089
    lea ebp, [ebx + field_18]                    # 004fd08b
    mov dword ptr [eax], ecx                     # 004fd08e
    mov ecx, dword ptr [esp + stk_30]            # 004fd090
    push ebp                                     # 004fd094
    mov dword ptr [eax + field_4], esi           # 004fd095
    mov dword ptr [eax + field_8], edx           # 004fd098
    mov dword ptr [eax + field_c], ecx           # 004fd09b
    call FUN_0050b4b0                            # 004fd09e
    mov edi, dword ptr [esp + stk_20]            # 004fd0a3
    add esp, 0x4                                 # 004fd0a7
    test edi, edi                                # 004fd0aa
    je.d8 L_004fd0d9                             # 004fd0ac
    # block 0x004fd0ae: entered by fall-through of je at 0x004fd0ac, 18 instruction(s), calls FUN_0050b500, FUN_0050b580, falls into the block at 0x004fd0d9
    mov esi, dword ptr [esp + stk_20]            # 004fd0ae
    push esi                                     # 004fd0b2
    push ebp                                     # 004fd0b3
    call FUN_0050b500                            # 004fd0b4
    {load} mov ecx, esi                          # 004fd0b9
    {load} mov esi, edi                          # 004fd0bb
    {load} mov edx, ecx                          # 004fd0bd
    {load} mov edi, eax                          # 004fd0bf
    shr ecx, 0x2                                 # 004fd0c1
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004fd0c4
    {load} mov ecx, edx                          # 004fd0c6
    {load} mov eax, edx                          # 004fd0c8
    and ecx, 0x3                                 # 004fd0ca
    push eax                                     # 004fd0cd
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004fd0ce
    push ebp                                     # 004fd0d0
    call FUN_0050b580                            # 004fd0d1
    add esp, 0x10                                # 004fd0d6
L_004fd0d9:
    # block 0x004fd0d9: entered by je at 0x004fd0ac, 4 instruction(s), ends with je to 0x004fd0ea (forward)
    mov eax, dword ptr [esp + stk_14]            # 004fd0d9
    mov esi, 0x1                                 # 004fd0dd
    cmp eax, -0x1                                # 004fd0e2
    je.d8 L_004fd0ea                             # 004fd0e5
    # block 0x004fd0e7: entered by fall-through of je at 0x004fd0e5, 1 instruction(s), falls into the block at 0x004fd0ea
    mov dword ptr [ebx + field_4], esi           # 004fd0e7
L_004fd0ea:
    # block 0x004fd0ea: entered by je at 0x004fd0e5, 27 instruction(s), calls FUN_0050e97e, FUN_0050b2c0, FUN_004fd160, ends with jge to 0x004fd144 (forward)
    push 0x20                                    # 004fd0ea
    push esi                                     # 004fd0ec
    mov dword ptr [ebx + field_34], esi          # 004fd0ed
    call FUN_0050e97e                            # 004fd0f0
    mov ecx, dword ptr [ebx + field_34]          # 004fd0f5
    push 0x10                                    # 004fd0f8
    push ecx                                     # 004fd0fa
    mov dword ptr [ebx + field_48], eax          # 004fd0fb
    call FUN_0050e97e                            # 004fd0fe
    lea edx, [ebx + field_74]                    # 004fd103
    push -0x1                                    # 004fd106
    push edx                                     # 004fd108
    mov dword ptr [ebx + field_4c], eax          # 004fd109
    call FUN_0050b2c0                            # 004fd10c
    mov ecx, dword ptr [ebx + field_4c]          # 004fd111
    mov edx, dword ptr [ebx + field_48]          # 004fd114
    lea eax, [ebx + field_5c]                    # 004fd117
    push 0x0                                     # 004fd11a
    push eax                                     # 004fd11c
    push ecx                                     # 004fd11d
    push edx                                     # 004fd11e
    push ebx                                     # 004fd11f
    call FUN_004fd160                            # 004fd120
    {load} mov edi, eax                          # 004fd125
    add esp, 0x2c                                # 004fd127
    test edi, edi                                # 004fd12a
    jge.d8 L_004fd144                            # 004fd12c
    # block 0x004fd12e: entered by fall-through of jge at 0x004fd12c, 10 instruction(s), calls FUN_004fcef0, ends with ret
    push ebx                                     # 004fd12e
    mov dword ptr [ebx], 0x0                     # 004fd12f
    call FUN_004fcef0                            # 004fd135
    add esp, 0x4                                 # 004fd13a
    {load} mov eax, edi                          # 004fd13d
    pop edi                                      # 004fd13f
    pop esi                                      # 004fd140
    pop ebp                                      # 004fd141
    pop ebx                                      # 004fd142
    ret                                          # 004fd143
L_004fd144:
    # block 0x004fd144: entered by jge at 0x004fd12c, 2 instruction(s), ends with jge to 0x004fd14c (forward)
    cmp dword ptr [ebx + field_58], esi          # 004fd144
    jge.d8 L_004fd14c                            # 004fd147
    # block 0x004fd149: entered by fall-through of jge at 0x004fd147, 1 instruction(s), falls into the block at 0x004fd14c
    mov dword ptr [ebx + field_58], esi          # 004fd149
L_004fd14c:
    # block 0x004fd14c: entered by jge at 0x004fd147, 6 instruction(s), ends with ret
    {load} mov eax, edi                          # 004fd14c
    pop edi                                      # 004fd14e
    pop esi                                      # 004fd14f
    pop ebp                                      # 004fd150
    pop ebx                                      # 004fd151
    ret                                          # 004fd152

# --- data items (not part of the function) -------------------------
.org 0x004fd153 - 0x401000
PAD_004fd153:  # 13 byte(s) of nop padding
    .fill 13, 1, 0x90

