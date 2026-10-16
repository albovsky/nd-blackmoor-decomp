# FUN_00519009
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00519009
# extent:       0x00519009-0x00519229 (544 code bytes)
# span:         0x00519009-0x00519229 (code 544, tables 0, padding 0)
# sha256:       854d91f80a4d2ff00ed080e607653dfc9a8f94cc7ba3426093aa45213d97fcd8
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00519009
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       13 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_19, local_1a, local_1c, local_1e, local_20, local_22 and 1 more
# fields:       [ebx + n] field_4, field_8, field_a; [esi + n] field_2, field_4, field_6, field_8, field_a
# callees:      calls FUN_00518bd5, FUN_00518c54, FUN_00518c82
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 177 instruction(s), 30 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_19, 0x19  # offset -0x19
.equ local_1a, 0x1a  # offset -0x1a
.equ local_1c, 0x1c  # offset -0x1c
.equ local_1e, 0x1e  # offset -0x1e
.equ local_20, 0x20  # offset -0x20
.equ local_22, 0x22  # offset -0x22
.equ local_24, 0x24  # offset -0x24
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_00518bd5, .text + (0x00518bd5 - 0x401000)
.set FUN_00518c54, .text + (0x00518c54 - 0x401000)
.set FUN_00518c82, .text + (0x00518c82 - 0x401000)

.org 0x00519009 - 0x401000
.globl FUN_00519009
FUN_00519009:
    # block 0x00519009: entry, 25 instruction(s), ends with jae to 0x00519209 (forward)
    push ebp                                     # 00519009
    {load} mov ebp, esp                          # 0051900a
    sub esp, 0x24                                # 0051900c
    push ebx                                     # 0051900f
    mov ebx, dword ptr [ebp + arg_c]             # 00519010
    push esi                                     # 00519013
    mov esi, dword ptr [ebp + arg_8]             # 00519014
    mov cx, word ptr [ebx + field_a]             # 00519017
    {load} xor eax, eax                          # 0051901b
    push edi                                     # 0051901d
    mov dword ptr [ebp - local_14], eax          # 0051901e
    mov dword ptr [ebp - local_24], eax          # 00519021
    mov dword ptr [ebp - local_20], eax          # 00519024
    mov dword ptr [ebp - local_1c], eax          # 00519027
    mov ax, word ptr [esi + field_a]             # 0051902a
    {load} mov edi, ecx                          # 0051902e
    mov edx, 0x7fff                              # 00519030
    {load} xor edi, eax                          # 00519035
    {load} and eax, edx                          # 00519037
    {load} and ecx, edx                          # 00519039
    and edi, 0x8000                              # 0051903b
    .insn 0x66, 0x3d, 0x7fff{:u16}               # 00519041
    lea edx, [ecx + eax]                         # 00519045
    mov dword ptr [ebp + arg_8], edx             # 00519048
    jae.d32 L_00519209                           # 0051904b
    # block 0x00519051: entered by fall-through of jae at 0x0051904b, 2 instruction(s), ends with jae to 0x00519209 (forward)
    .insn 0x6681/7, ecx, 32767{:s16}             # 00519051
    jae.d32 L_00519209                           # 00519056
    # block 0x0051905c: entered by fall-through of jae at 0x00519056, 2 instruction(s), ends with ja to 0x00519209 (forward)
    .insn 0x6681/7, edx, -16387{:s16}            # 0051905c
    ja.d32 L_00519209                            # 00519061
    # block 0x00519067: entered by fall-through of ja at 0x00519061, 2 instruction(s), ends with ja to 0x00519072 (forward)
    .insn 0x6681/7, edx, 16319{:s16}             # 00519067
    ja.d8 L_00519072                             # 0051906c
    # block 0x0051906e: entered by fall-through of ja at 0x0051906c, 2 instruction(s), ends with forward jump to 0x005190ac
    {load} xor eax, eax                          # 0051906e
    jmp.d8 L_005190ac                            # 00519070
L_00519072:
    # block 0x00519072: entered by ja at 0x0051906c, 3 instruction(s), ends with jne to 0x00519094 (forward)
    test ax, ax                                  # 00519072
    mov edx, 0x7fffffff                          # 00519075
    jne.d8 L_00519094                            # 0051907a
    # block 0x0051907c: entered by fall-through of jne at 0x0051907a, 3 instruction(s), ends with jne to 0x00519094 (forward)
    inc dword ptr [ebp + arg_8]                  # 0051907c
    test dword ptr [esi + field_8], edx          # 0051907f
    jne.d8 L_00519094                            # 00519082
    # block 0x00519084: entered by fall-through of jne at 0x00519082, 3 instruction(s), ends with jne to 0x00519096 (forward)
    {load} xor eax, eax                          # 00519084
    cmp dword ptr [esi + field_4], eax           # 00519086
    jne.d8 L_00519096                            # 00519089
    # block 0x0051908b: entered by fall-through of jne at 0x00519089, 2 instruction(s), ends with jne to 0x00519096 (forward)
    cmp dword ptr [esi], eax                     # 0051908b
    jne.d8 L_00519096                            # 0051908d
    # block 0x0051908f: entered by fall-through of jne at 0x0051908d, 1 instruction(s), ends with forward jump to 0x00519203
    jmp.d32 L_00519203                           # 0051908f
L_00519094:
    # block 0x00519094: entered by jne at 0x0051907a; jne at 0x00519082, 1 instruction(s), falls into the block at 0x00519096
    {load} xor eax, eax                          # 00519094
L_00519096:
    # block 0x00519096: entered by jne at 0x00519089; jne at 0x0051908d, 2 instruction(s), ends with jne to 0x005190b9 (forward)
    {load} cmp cx, ax                            # 00519096
    jne.d8 L_005190b9                            # 00519099
    # block 0x0051909b: entered by fall-through of jne at 0x00519099, 3 instruction(s), ends with jne to 0x005190b9 (forward)
    inc dword ptr [ebp + arg_8]                  # 0051909b
    test dword ptr [ebx + field_8], edx          # 0051909e
    jne.d8 L_005190b9                            # 005190a1
    # block 0x005190a3: entered by fall-through of jne at 0x005190a1, 2 instruction(s), ends with jne to 0x005190b9 (forward)
    cmp dword ptr [ebx + field_4], eax           # 005190a3
    jne.d8 L_005190b9                            # 005190a6
    # block 0x005190a8: entered by fall-through of jne at 0x005190a6, 2 instruction(s), ends with jne to 0x005190b9 (forward)
    cmp dword ptr [ebx], eax                     # 005190a8
    jne.d8 L_005190b9                            # 005190aa
L_005190ac:
    # block 0x005190ac: entered by jmp at 0x00519070; fall-through of jne at 0x005190aa, 4 instruction(s), ends with forward jump to 0x00519224
    mov dword ptr [esi + field_8], eax           # 005190ac
    mov dword ptr [esi + field_4], eax           # 005190af
    mov dword ptr [esi], eax                     # 005190b2
    jmp.d32 L_00519224                           # 005190b4
L_005190b9:
    # block 0x005190b9: entered by jne at 0x00519099; jne at 0x005190a1; jne at 0x005190a6; jne at 0x005190aa, 4 instruction(s), falls into the block at 0x005190c9
    mov dword ptr [ebp - local_10], eax          # 005190b9
    lea eax, [ebp - local_20]                    # 005190bc
    mov dword ptr [ebp - local_4], eax           # 005190bf
    mov dword ptr [ebp + arg_c], 0x5             # 005190c2
L_005190c9:
    # block 0x005190c9: entered by jg at 0x0051912b, 4 instruction(s), ends with jle to 0x0051911d (forward)
    mov eax, dword ptr [ebp - local_10]          # 005190c9
    {load} add eax, eax                          # 005190cc
    cmp dword ptr [ebp + arg_c], 0x0             # 005190ce
    jle.d8 L_0051911d                            # 005190d2
    # block 0x005190d4: entered by fall-through of jle at 0x005190d2, 6 instruction(s), falls into the block at 0x005190e5
    {load} add eax, esi                          # 005190d4
    lea ecx, [ebx + field_8]                     # 005190d6
    mov dword ptr [ebp - local_8], eax           # 005190d9
    mov eax, dword ptr [ebp + arg_c]             # 005190dc
    mov dword ptr [ebp - local_c], ecx           # 005190df
    mov dword ptr [ebp - local_18], eax          # 005190e2
L_005190e5:
    # block 0x005190e5: entered by jne at 0x0051911b, 14 instruction(s), calls FUN_00518bd5, ends with je to 0x00519110 (forward)
    mov eax, dword ptr [ebp - local_8]           # 005190e5
    mov ecx, dword ptr [ebp - local_c]           # 005190e8
    movzx eax, word ptr [eax]                    # 005190eb
    movzx ecx, word ptr [ecx]                    # 005190ee
    imul eax, ecx                                # 005190f1
    mov ecx, dword ptr [ebp - local_4]           # 005190f4
    add ecx, -0x4                                # 005190f7
    push ecx                                     # 005190fa
    push eax                                     # 005190fb
    push dword ptr [ecx]                         # 005190fc
    call FUN_00518bd5                            # 005190fe
    add esp, 0xc                                 # 00519103
    test eax, eax                                # 00519106
    je.d8 L_00519110                             # 00519108
    # block 0x0051910a: entered by fall-through of je at 0x00519108, 2 instruction(s), falls into the block at 0x00519110
    mov eax, dword ptr [ebp - local_4]           # 0051910a
    inc word ptr [eax]                           # 0051910d
L_00519110:
    # block 0x00519110: entered by je at 0x00519108, 4 instruction(s), ends with jne to 0x005190e5 (backward)
    add dword ptr [ebp - local_8], 0x2           # 00519110
    sub dword ptr [ebp - local_c], 0x2           # 00519114
    dec dword ptr [ebp - local_18]               # 00519118
    jne.d8 L_005190e5                            # 0051911b
L_0051911d:
    # block 0x0051911d: entered by jle at 0x005190d2; fall-through of jne at 0x0051911b, 5 instruction(s), ends with jg to 0x005190c9 (backward)
    add dword ptr [ebp - local_4], 0x2           # 0051911d
    inc dword ptr [ebp - local_10]               # 00519121
    dec dword ptr [ebp + arg_c]                  # 00519124
    cmp dword ptr [ebp + arg_c], 0x0             # 00519127
    jg.d8 L_005190c9                             # 0051912b
    # block 0x0051912d: entered by fall-through of jg at 0x0051912b, 3 instruction(s), ends with jle to 0x00519160 (forward)
    add dword ptr [ebp + arg_8], 0xc002          # 0051912d
    cmp word ptr [ebp + arg_8], 0x0              # 00519134
    jle.d8 L_00519160                            # 00519139
L_0051913b:
    # block 0x0051913b: entered by jg at 0x00519157; fall-through of jle at 0x00519139, 2 instruction(s), ends with jne to 0x00519159 (forward)
    test byte ptr [ebp - local_19], -0x80        # 0051913b
    jne.d8 L_00519159                            # 0051913f
    # block 0x00519141: entered by fall-through of jne at 0x0051913f, 7 instruction(s), calls FUN_00518c54, ends with jg to 0x0051913b (backward)
    lea eax, [ebp - local_24]                    # 00519141
    push eax                                     # 00519144
    call FUN_00518c54                            # 00519145
    add dword ptr [ebp + arg_8], 0xffff          # 0051914a
    pop ecx                                      # 00519151
    cmp word ptr [ebp + arg_8], 0x0              # 00519152
    jg.d8 L_0051913b                             # 00519157
L_00519159:
    # block 0x00519159: entered by jne at 0x0051913f; fall-through of jg at 0x00519157, 2 instruction(s), ends with jg to 0x00519199 (forward)
    cmp word ptr [ebp + arg_8], 0x0              # 00519159
    jg.d8 L_00519199                             # 0051915e
L_00519160:
    # block 0x00519160: entered by jle at 0x00519139; fall-through of jg at 0x0051915e, 3 instruction(s), ends with jge to 0x00519199 (forward)
    add dword ptr [ebp + arg_8], 0xffff          # 00519160
    cmp word ptr [ebp + arg_8], 0x0              # 00519167
    jge.d8 L_00519199                            # 0051916c
    # block 0x0051916e: entered by fall-through of jge at 0x0051916c, 4 instruction(s), falls into the block at 0x00519179
    movsx eax, word ptr [ebp + arg_8]            # 0051916e
    neg eax                                      # 00519172
    add dword ptr [ebp + arg_8], eax             # 00519174
    {load} mov ebx, eax                          # 00519177
L_00519179:
    # block 0x00519179: entered by jne at 0x0051918d, 2 instruction(s), ends with je to 0x00519182 (forward)
    test byte ptr [ebp - local_24], 0x1          # 00519179
    je.d8 L_00519182                             # 0051917d
    # block 0x0051917f: entered by fall-through of je at 0x0051917d, 1 instruction(s), falls into the block at 0x00519182
    inc dword ptr [ebp - local_14]               # 0051917f
L_00519182:
    # block 0x00519182: entered by je at 0x0051917d, 6 instruction(s), calls FUN_00518c82, ends with jne to 0x00519179 (backward)
    lea eax, [ebp - local_24]                    # 00519182
    push eax                                     # 00519185
    call FUN_00518c82                            # 00519186
    dec ebx                                      # 0051918b
    pop ecx                                      # 0051918c
    jne.d8 L_00519179                            # 0051918d
    # block 0x0051918f: entered by fall-through of jne at 0x0051918d, 2 instruction(s), ends with je to 0x00519199 (forward)
    cmp dword ptr [ebp - local_14], 0x0          # 0051918f
    je.d8 L_00519199                             # 00519193
    # block 0x00519195: entered by fall-through of je at 0x00519193, 1 instruction(s), falls into the block at 0x00519199
    or byte ptr [ebp - local_24], 0x1            # 00519195
L_00519199:
    # block 0x00519199: entered by jg at 0x0051915e; jge at 0x0051916c; je at 0x00519193, 2 instruction(s), ends with ja to 0x005191b0 (forward)
    .insn 0x6681/7, dword ptr [ebp - local_24], -32768{:s16} # 00519199
    ja.d8 L_005191b0                             # 0051919f
    # block 0x005191a1: entered by fall-through of ja at 0x0051919f, 4 instruction(s), ends with jne to 0x005191e5 (forward)
    mov eax, dword ptr [ebp - local_24]          # 005191a1
    and eax, 0x1ffff                             # 005191a4
    cmp eax, 0x18000                             # 005191a9
    jne.d8 L_005191e5                            # 005191ae
L_005191b0:
    # block 0x005191b0: entered by ja at 0x0051919f; fall-through of jne at 0x005191ae, 2 instruction(s), ends with jne to 0x005191e2 (forward)
    cmp dword ptr [ebp - local_22], -0x1         # 005191b0
    jne.d8 L_005191e2                            # 005191b4
    # block 0x005191b6: entered by fall-through of jne at 0x005191b4, 3 instruction(s), ends with jne to 0x005191dd (forward)
    and dword ptr [ebp - local_22], 0x0          # 005191b6
    cmp dword ptr [ebp - local_1e], -0x1         # 005191ba
    jne.d8 L_005191dd                            # 005191be
    # block 0x005191c0: entered by fall-through of jne at 0x005191be, 3 instruction(s), ends with jne to 0x005191d7 (forward)
    and dword ptr [ebp - local_1e], 0x0          # 005191c0
    .insn 0x6681/7, dword ptr [ebp - local_1a], -1{:s16} # 005191c4
    jne.d8 L_005191d7                            # 005191ca
    # block 0x005191cc: entered by fall-through of jne at 0x005191ca, 3 instruction(s), ends with forward jump to 0x005191e5
    inc dword ptr [ebp + arg_8]                  # 005191cc
    mov word ptr [ebp - local_1a], 0x8000        # 005191cf
    jmp.d8 L_005191e5                            # 005191d5
L_005191d7:
    # block 0x005191d7: entered by jne at 0x005191ca, 2 instruction(s), ends with forward jump to 0x005191e5
    inc word ptr [ebp - local_1a]                # 005191d7
    jmp.d8 L_005191e5                            # 005191db
L_005191dd:
    # block 0x005191dd: entered by jne at 0x005191be, 2 instruction(s), ends with forward jump to 0x005191e5
    inc dword ptr [ebp - local_1e]               # 005191dd
    jmp.d8 L_005191e5                            # 005191e0
L_005191e2:
    # block 0x005191e2: entered by jne at 0x005191b4, 1 instruction(s), falls into the block at 0x005191e5
    inc dword ptr [ebp - local_22]               # 005191e2
L_005191e5:
    # block 0x005191e5: entered by jne at 0x005191ae; jmp at 0x005191d5; jmp at 0x005191db; jmp at 0x005191e0, 3 instruction(s), ends with jae to 0x00519209 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 005191e5
    .insn 0x66, 0x3d, 0x7fff{:u16}               # 005191e8
    jae.d8 L_00519209                            # 005191ec
    # block 0x005191ee: entered by fall-through of jae at 0x005191ec, 7 instruction(s), falls into the block at 0x00519203
    mov cx, word ptr [ebp - local_22]            # 005191ee
    {load} or eax, edi                           # 005191f2
    mov word ptr [esi], cx                       # 005191f4
    mov ecx, dword ptr [ebp - local_20]          # 005191f7
    mov dword ptr [esi + field_2], ecx           # 005191fa
    mov ecx, dword ptr [ebp - local_1c]          # 005191fd
    mov dword ptr [esi + field_6], ecx           # 00519200
L_00519203:
    # block 0x00519203: entered by jmp at 0x0051908f, 2 instruction(s), ends with forward jump to 0x00519224
    mov word ptr [esi + field_a], ax             # 00519203
    jmp.d8 L_00519224                            # 00519207
L_00519209:
    # block 0x00519209: entered by jae at 0x0051904b; jae at 0x00519056; ja at 0x00519061; jae at 0x005191ec, 7 instruction(s), falls into the block at 0x00519224
    neg di                                       # 00519209
    {load} sbb edi, edi                          # 0051920c
    and dword ptr [esi + field_4], 0x0           # 0051920e
    and edi, 0x80000000                          # 00519212
    add edi, 0x7fff8000                          # 00519218
    and dword ptr [esi], 0x0                     # 0051921e
    mov dword ptr [esi + field_8], edi           # 00519221
L_00519224:
    # block 0x00519224: entered by jmp at 0x005190b4; jmp at 0x00519207, 5 instruction(s), ends with ret
    pop edi                                      # 00519224
    pop esi                                      # 00519225
    pop ebx                                      # 00519226
    leave                                        # 00519227
    ret                                          # 00519228

