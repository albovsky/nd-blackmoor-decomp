# FUN_0050f085
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050f085
# extent:       0x0050f085-0x0050f1d9 (340 code bytes)
# span:         0x0050f085-0x0050f1d9 (code 340, tables 0, padding 0)
# sha256:       356fe0ff196d09bb788da5a1ff7eb17bedc6ccea9bce6e749175988e6483ca7f
# evidence:     ev_4431af068a3f4ca776e521e2b82a00887220c1221c914635cfd4305c8866eb9e
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050f085
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       4 ebp-relative slot(s): local_4, local_8, local_80, local_f8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050f1d9, FUN_0050f227; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 132 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_80, 0x80  # offset -0x80
.equ local_f8, 0xf8  # offset -0xf8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0050f1d9, .text + (0x0050f1d9 - 0x401000)
.set FUN_0050f227, .text + (0x0050f227 - 0x401000)

.org 0x0050f085 - 0x401000
.globl FUN_0050f085
FUN_0050f085:
    # block 0x0050f085: entry, 9 instruction(s), ends with jb to 0x0050f1d4 (forward)
    push ebp                                     # 0050f085
    {load} mov ebp, esp                          # 0050f086
    sub esp, 0xf8                                # 0050f088
    push ebx                                     # 0050f08e
    push esi                                     # 0050f08f
    mov esi, dword ptr [ebp + arg_c]             # 0050f090
    push edi                                     # 0050f093
    cmp esi, 0x2                                 # 0050f094
    jb.d32 L_0050f1d4                            # 0050f097
    # block 0x0050f09d: entered by fall-through of jb at 0x0050f097, 2 instruction(s), ends with je to 0x0050f1d4 (forward)
    cmp dword ptr [ebp + arg_10], 0x0            # 0050f09d
    je.d32 L_0050f1d4                            # 0050f0a1
    # block 0x0050f0a7: entered by fall-through of je at 0x0050f0a1, 9 instruction(s), falls into the block at 0x0050f0c4
    and dword ptr [ebp - local_4], 0x0           # 0050f0a7
    dec esi                                      # 0050f0ab
    imul esi, dword ptr [ebp + arg_10]           # 0050f0ac
    mov ebx, dword ptr [ebp + arg_8]             # 0050f0b0
    lea eax, [ebp - local_80]                    # 0050f0b3
    mov dword ptr [ebp + arg_8], eax             # 0050f0b6
    lea eax, [ebp - local_f8]                    # 0050f0b9
    {load} add esi, ebx                          # 0050f0bf
    mov dword ptr [ebp + arg_c], eax             # 0050f0c1
L_0050f0c4:
    # block 0x0050f0c4: entered by jmp at 0x0050f102; jmp at 0x0050f19f; jmp at 0x0050f1cf, 8 instruction(s), ends with ja to 0x0050f104 (forward)
    mov edi, dword ptr [ebp + arg_10]            # 0050f0c4
    {load} mov eax, esi                          # 0050f0c7
    {load} sub eax, ebx                          # 0050f0c9
    {load} xor edx, edx                          # 0050f0cb
    div edi                                      # 0050f0cd
    inc eax                                      # 0050f0cf
    cmp eax, 0x8                                 # 0050f0d0
    ja.d8 L_0050f104                             # 0050f0d3
    # block 0x0050f0d5: entered by fall-through of ja at 0x0050f0d3, 6 instruction(s), calls FUN_0050f1d9, falls into the block at 0x0050f0e3
    push dword ptr [ebp + arg_14]                # 0050f0d5
    push edi                                     # 0050f0d8
    push esi                                     # 0050f0d9
    push ebx                                     # 0050f0da
    call FUN_0050f1d9                            # 0050f0db
    add esp, 0x10                                # 0050f0e0
L_0050f0e3:
    # block 0x0050f0e3: entered by jae at 0x0050f197; jae at 0x0050f1c4, 5 instruction(s), ends with jl to 0x0050f1d4 (forward)
    dec dword ptr [ebp - local_4]                # 0050f0e3
    sub dword ptr [ebp + arg_c], 0x4             # 0050f0e6
    sub dword ptr [ebp + arg_8], 0x4             # 0050f0ea
    cmp dword ptr [ebp - local_4], 0x0           # 0050f0ee
    jl.d32 L_0050f1d4                            # 0050f0f2
    # block 0x0050f0f8: entered by fall-through of jl at 0x0050f0f2, 5 instruction(s), ends with backward jump to 0x0050f0c4
    mov eax, dword ptr [ebp + arg_c]             # 0050f0f8
    mov ebx, dword ptr [eax]                     # 0050f0fb
    mov eax, dword ptr [ebp + arg_8]             # 0050f0fd
    mov esi, dword ptr [eax]                     # 0050f100
    jmp.d8 L_0050f0c4                            # 0050f102
L_0050f104:
    # block 0x0050f104: entered by ja at 0x0050f0d3, 10 instruction(s), calls FUN_0050f227, falls into the block at 0x0050f11b
    shr eax                                      # 0050f104
    imul eax, edi                                # 0050f106
    push edi                                     # 0050f109
    {load} add eax, ebx                          # 0050f10a
    push ebx                                     # 0050f10c
    push eax                                     # 0050f10d
    call FUN_0050f227                            # 0050f10e
    add esp, 0xc                                 # 0050f113
    mov dword ptr [ebp - local_8], ebx           # 0050f116
    {load} add edi, esi                          # 0050f119
L_0050f11b:
    # block 0x0050f11b: entered by jle at 0x0050f131; jmp at 0x0050f159, 5 instruction(s), ends with ja to 0x0050f133 (forward)
    mov eax, dword ptr [ebp - local_8]           # 0050f11b
    add eax, dword ptr [ebp + arg_10]            # 0050f11e
    {load} cmp eax, esi                          # 0050f121
    mov dword ptr [ebp - local_8], eax           # 0050f123
    ja.d8 L_0050f133                             # 0050f126
    # block 0x0050f128: entered by fall-through of ja at 0x0050f126, 7 instruction(s), calls indirect dword ptr [ebp + 0x14], ends with jle to 0x0050f11b (backward)
    push ebx                                     # 0050f128
    push eax                                     # 0050f129
    call dword ptr [ebp + arg_14]                # 0050f12a
    pop ecx                                      # 0050f12d
    test eax, eax                                # 0050f12e
    pop ecx                                      # 0050f130
    jle.d8 L_0050f11b                            # 0050f131
L_0050f133:
    # block 0x0050f133: entered by ja at 0x0050f126; jge at 0x0050f143; fall-through of jle at 0x0050f131, 3 instruction(s), ends with jbe to 0x0050f145 (forward)
    sub edi, dword ptr [ebp + arg_10]            # 0050f133
    {load} cmp edi, ebx                          # 0050f136
    jbe.d8 L_0050f145                            # 0050f138
    # block 0x0050f13a: entered by fall-through of jbe at 0x0050f138, 7 instruction(s), calls indirect dword ptr [ebp + 0x14], ends with jge to 0x0050f133 (backward)
    push ebx                                     # 0050f13a
    push edi                                     # 0050f13b
    call dword ptr [ebp + arg_14]                # 0050f13c
    pop ecx                                      # 0050f13f
    test eax, eax                                # 0050f140
    pop ecx                                      # 0050f142
    jge.d8 L_0050f133                            # 0050f143
L_0050f145:
    # block 0x0050f145: entered by jbe at 0x0050f138; fall-through of jge at 0x0050f143, 4 instruction(s), ends with jb to 0x0050f15b (forward)
    push dword ptr [ebp + arg_10]                # 0050f145
    cmp edi, dword ptr [ebp - local_8]           # 0050f148
    push edi                                     # 0050f14b
    jb.d8 L_0050f15b                             # 0050f14c
    # block 0x0050f14e: entered by fall-through of jb at 0x0050f14c, 4 instruction(s), calls FUN_0050f227, ends with backward jump to 0x0050f11b
    push dword ptr [ebp - local_8]               # 0050f14e
    call FUN_0050f227                            # 0050f151
    add esp, 0xc                                 # 0050f156
    jmp.d8 L_0050f11b                            # 0050f159
L_0050f15b:
    # block 0x0050f15b: entered by jb at 0x0050f14c, 11 instruction(s), calls FUN_0050f227, ends with jl to 0x0050f1a4 (forward)
    push ebx                                     # 0050f15b
    call FUN_0050f227                            # 0050f15c
    mov eax, dword ptr [ebp - local_8]           # 0050f161
    {load} mov ecx, edi                          # 0050f164
    {load} sub ecx, ebx                          # 0050f166
    {load} mov edx, esi                          # 0050f168
    add esp, 0xc                                 # 0050f16a
    dec ecx                                      # 0050f16d
    {load} sub edx, eax                          # 0050f16e
    {load} cmp ecx, edx                          # 0050f170
    jl.d8 L_0050f1a4                             # 0050f172
    # block 0x0050f174: entered by fall-through of jl at 0x0050f172, 4 instruction(s), ends with jae to 0x0050f195 (forward)
    mov ecx, dword ptr [ebp + arg_10]            # 0050f174
    lea edx, [ebx + ecx]                         # 0050f177
    {load} cmp edx, edi                          # 0050f17a
    jae.d8 L_0050f195                            # 0050f17c
    # block 0x0050f17e: entered by fall-through of jae at 0x0050f17c, 8 instruction(s), falls into the block at 0x0050f195
    mov edx, dword ptr [ebp + arg_c]             # 0050f17e
    add dword ptr [ebp + arg_c], 0x4             # 0050f181
    {load} sub edi, ecx                          # 0050f185
    mov ecx, dword ptr [ebp + arg_8]             # 0050f187
    inc dword ptr [ebp - local_4]                # 0050f18a
    add dword ptr [ebp + arg_8], 0x4             # 0050f18d
    mov dword ptr [edx], ebx                     # 0050f191
    mov dword ptr [ecx], edi                     # 0050f193
L_0050f195:
    # block 0x0050f195: entered by jae at 0x0050f17c, 2 instruction(s), ends with jae to 0x0050f0e3 (backward)
    {load} cmp eax, esi                          # 0050f195
    jae.d32 L_0050f0e3                           # 0050f197
    # block 0x0050f19d: entered by fall-through of jae at 0x0050f197, 2 instruction(s), ends with backward jump to 0x0050f0c4
    {load} mov ebx, eax                          # 0050f19d
    jmp.d32 L_0050f0c4                           # 0050f19f
L_0050f1a4:
    # block 0x0050f1a4: entered by jl at 0x0050f172, 2 instruction(s), ends with jae to 0x0050f1bd (forward)
    {load} cmp eax, esi                          # 0050f1a4
    jae.d8 L_0050f1bd                            # 0050f1a6
    # block 0x0050f1a8: entered by fall-through of jae at 0x0050f1a6, 7 instruction(s), falls into the block at 0x0050f1bd
    mov ecx, dword ptr [ebp + arg_c]             # 0050f1a8
    inc dword ptr [ebp - local_4]                # 0050f1ab
    add dword ptr [ebp + arg_c], 0x4             # 0050f1ae
    mov dword ptr [ecx], eax                     # 0050f1b2
    mov eax, dword ptr [ebp + arg_8]             # 0050f1b4
    add dword ptr [ebp + arg_8], 0x4             # 0050f1b7
    mov dword ptr [eax], esi                     # 0050f1bb
L_0050f1bd:
    # block 0x0050f1bd: entered by jae at 0x0050f1a6, 4 instruction(s), ends with jae to 0x0050f0e3 (backward)
    mov eax, dword ptr [ebp + arg_10]            # 0050f1bd
    {load} add eax, ebx                          # 0050f1c0
    {load} cmp eax, edi                          # 0050f1c2
    jae.d32 L_0050f0e3                           # 0050f1c4
    # block 0x0050f1ca: entered by fall-through of jae at 0x0050f1c4, 3 instruction(s), ends with backward jump to 0x0050f0c4
    sub edi, dword ptr [ebp + arg_10]            # 0050f1ca
    {load} mov esi, edi                          # 0050f1cd
    jmp.d32 L_0050f0c4                           # 0050f1cf
L_0050f1d4:
    # block 0x0050f1d4: entered by jb at 0x0050f097; je at 0x0050f0a1; jl at 0x0050f0f2, 5 instruction(s), ends with ret
    pop edi                                      # 0050f1d4
    pop esi                                      # 0050f1d5
    pop ebx                                      # 0050f1d6
    leave                                        # 0050f1d7
    ret                                          # 0050f1d8

