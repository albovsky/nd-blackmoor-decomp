# FUN_0050d0bc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050d0bc
# extent:       0x0050d0bc-0x0050d1f0 (308 code bytes)
# span:         0x0050d0bc-0x0050d1f0 (code 308, tables 0, padding 0)
# sha256:       fce171988109dc8585e9190c7cd14a5e9d392385a5c3f2fcf08be21100087666
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050d0bc
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls KERNEL32.dll!InterlockedIncrement, KERNEL32.dll!InterlockedDecrement, FUN_00512c18, FUN_00512c79, FUN_005129a0, FUN_0050ea90, FUN_005128b0, FUN_0050e936
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 119 instruction(s), 16 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)
.set FUN_005128b0, .text + (0x005128b0 - 0x401000)
.set FUN_005129a0, .text + (0x005129a0 - 0x401000)
.set FUN_00512c18, .text + (0x00512c18 - 0x401000)
.set FUN_00512c79, .text + (0x00512c79 - 0x401000)

.org 0x0050d0bc - 0x401000
.globl FUN_0050d0bc
FUN_0050d0bc:
    # block 0x0050d0bc: entry, 10 instruction(s), ends with jne to 0x0050d0fa (forward)
    push ebp                                     # 0050d0bc
    {load} mov ebp, esp                          # 0050d0bd
    push ecx                                     # 0050d0bf
    push ecx                                     # 0050d0c0
    push esi                                     # 0050d0c1
    {load} xor esi, esi                          # 0050d0c2
    cmp dword ptr [0x63cb1c], esi                # 0050d0c4
    push edi                                     # 0050d0ca
    mov dword ptr [ebp - local_8], esi           # 0050d0cb
    jne.d8 L_0050d0fa                            # 0050d0ce
    # block 0x0050d0d0: entered by fall-through of jne at 0x0050d0ce, 4 instruction(s), ends with je to 0x0050d1ec (forward)
    mov eax, dword ptr [ebp + arg_8]             # 0050d0d0
    {load} mov edx, eax                          # 0050d0d3
    cmp byte ptr [eax], 0x0                      # 0050d0d5
    je.d32 L_0050d1ec                            # 0050d0d8
L_0050d0de:
    # block 0x0050d0de: entered by jne at 0x0050d0f3; fall-through of je at 0x0050d0d8, 3 instruction(s), ends with jl to 0x0050d0ef (forward)
    mov cl, byte ptr [edx]                       # 0050d0de
    cmp cl, 0x61                                 # 0050d0e0
    jl.d8 L_0050d0ef                             # 0050d0e3
    # block 0x0050d0e5: entered by fall-through of jl at 0x0050d0e3, 2 instruction(s), ends with jg to 0x0050d0ef (forward)
    cmp cl, 0x7a                                 # 0050d0e5
    jg.d8 L_0050d0ef                             # 0050d0e8
    # block 0x0050d0ea: entered by fall-through of jg at 0x0050d0e8, 2 instruction(s), falls into the block at 0x0050d0ef
    sub cl, 0x20                                 # 0050d0ea
    mov byte ptr [edx], cl                       # 0050d0ed
L_0050d0ef:
    # block 0x0050d0ef: entered by jl at 0x0050d0e3; jg at 0x0050d0e8, 3 instruction(s), ends with jne to 0x0050d0de (backward)
    inc edx                                      # 0050d0ef
    cmp byte ptr [edx], 0x0                      # 0050d0f0
    jne.d8 L_0050d0de                            # 0050d0f3
    # block 0x0050d0f5: entered by fall-through of jne at 0x0050d0f3, 1 instruction(s), ends with forward jump to 0x0050d1ec
    jmp.d32 L_0050d1ec                           # 0050d0f5
L_0050d0fa:
    # block 0x0050d0fa: entered by jne at 0x0050d0ce, 5 instruction(s), calls KERNEL32.dll!InterlockedIncrement, ends with je to 0x0050d126 (forward)
    mov edi, 0x63cee8                            # 0050d0fa
    push edi                                     # 0050d0ff
    call dword ptr [0x52a200]                    # 0050d100
    cmp dword ptr [0x63cee4], esi                # 0050d106
    je.d8 L_0050d126                             # 0050d10c
    # block 0x0050d10e: entered by fall-through of je at 0x0050d10c, 7 instruction(s), calls KERNEL32.dll!InterlockedDecrement, FUN_00512c18, ends with forward jump to 0x0050d129
    push edi                                     # 0050d10e
    call dword ptr [0x52a1fc]                    # 0050d10f
    push 0x13                                    # 0050d115
    call FUN_00512c18                            # 0050d117
    pop ecx                                      # 0050d11c
    mov dword ptr [ebp - local_4], 0x1           # 0050d11d
    jmp.d8 L_0050d129                            # 0050d124
L_0050d126:
    # block 0x0050d126: entered by je at 0x0050d10c, 1 instruction(s), falls into the block at 0x0050d129
    mov dword ptr [ebp - local_4], esi           # 0050d126
L_0050d129:
    # block 0x0050d129: entered by jmp at 0x0050d124, 3 instruction(s), ends with jne to 0x0050d16f (forward)
    mov eax, dword ptr [0x63cb1c]                # 0050d129
    {load} cmp eax, esi                          # 0050d12e
    jne.d8 L_0050d16f                            # 0050d130
    # block 0x0050d132: entered by fall-through of jne at 0x0050d130, 2 instruction(s), ends with je to 0x0050d141 (forward)
    cmp dword ptr [ebp - local_4], esi           # 0050d132
    je.d8 L_0050d141                             # 0050d135
    # block 0x0050d137: entered by fall-through of je at 0x0050d135, 4 instruction(s), calls FUN_00512c79, ends with forward jump to 0x0050d148
    push 0x13                                    # 0050d137
    call FUN_00512c79                            # 0050d139
    pop ecx                                      # 0050d13e
    jmp.d8 L_0050d148                            # 0050d13f
L_0050d141:
    # block 0x0050d141: entered by je at 0x0050d135, 2 instruction(s), calls KERNEL32.dll!InterlockedDecrement, falls into the block at 0x0050d148
    push edi                                     # 0050d141
    call dword ptr [0x52a1fc]                    # 0050d142
L_0050d148:
    # block 0x0050d148: entered by jmp at 0x0050d13f, 4 instruction(s), ends with je to 0x0050d1ec (forward)
    mov eax, dword ptr [ebp + arg_8]             # 0050d148
    {load} mov edx, eax                          # 0050d14b
    cmp byte ptr [eax], 0x0                      # 0050d14d
    je.d32 L_0050d1ec                            # 0050d150
L_0050d156:
    # block 0x0050d156: entered by jne at 0x0050d16b; fall-through of je at 0x0050d150, 3 instruction(s), ends with jl to 0x0050d167 (forward)
    mov cl, byte ptr [edx]                       # 0050d156
    cmp cl, 0x61                                 # 0050d158
    jl.d8 L_0050d167                             # 0050d15b
    # block 0x0050d15d: entered by fall-through of jl at 0x0050d15b, 2 instruction(s), ends with jg to 0x0050d167 (forward)
    cmp cl, 0x7a                                 # 0050d15d
    jg.d8 L_0050d167                             # 0050d160
    # block 0x0050d162: entered by fall-through of jg at 0x0050d160, 2 instruction(s), falls into the block at 0x0050d167
    sub cl, 0x20                                 # 0050d162
    mov byte ptr [edx], cl                       # 0050d165
L_0050d167:
    # block 0x0050d167: entered by jl at 0x0050d15b; jg at 0x0050d160, 3 instruction(s), ends with jne to 0x0050d156 (backward)
    inc edx                                      # 0050d167
    cmp byte ptr [edx], 0x0                      # 0050d168
    jne.d8 L_0050d156                            # 0050d16b
    # block 0x0050d16d: entered by fall-through of jne at 0x0050d16b, 1 instruction(s), ends with forward jump to 0x0050d1ec
    jmp.d8 L_0050d1ec                            # 0050d16d
L_0050d16f:
    # block 0x0050d16f: entered by jne at 0x0050d130, 15 instruction(s), calls FUN_005129a0, ends with je to 0x0050d1c8 (forward)
    push ebx                                     # 0050d16f
    push 0x1                                     # 0050d170
    push esi                                     # 0050d172
    push esi                                     # 0050d173
    push esi                                     # 0050d174
    push -0x1                                    # 0050d175
    push dword ptr [ebp + arg_8]                 # 0050d177
    mov esi, 0x200                               # 0050d17a
    push esi                                     # 0050d17f
    push eax                                     # 0050d180
    call FUN_005129a0                            # 0050d181
    {load} mov ebx, eax                          # 0050d186
    add esp, 0x20                                # 0050d188
    test ebx, ebx                                # 0050d18b
    je.d8 L_0050d1c8                             # 0050d18d
    # block 0x0050d18f: entered by fall-through of je at 0x0050d18d, 6 instruction(s), calls FUN_0050ea90, ends with je to 0x0050d1c8 (forward)
    push ebx                                     # 0050d18f
    call FUN_0050ea90                            # 0050d190
    test eax, eax                                # 0050d195
    pop ecx                                      # 0050d197
    mov dword ptr [ebp - local_8], eax           # 0050d198
    je.d8 L_0050d1c8                             # 0050d19b
    # block 0x0050d19d: entered by fall-through of je at 0x0050d19b, 12 instruction(s), calls FUN_005129a0, ends with je to 0x0050d1c8 (forward)
    push 0x1                                     # 0050d19d
    push 0x0                                     # 0050d19f
    push ebx                                     # 0050d1a1
    push eax                                     # 0050d1a2
    push -0x1                                    # 0050d1a3
    push dword ptr [ebp + arg_8]                 # 0050d1a5
    push esi                                     # 0050d1a8
    push dword ptr [0x63cb1c]                    # 0050d1a9
    call FUN_005129a0                            # 0050d1af
    add esp, 0x20                                # 0050d1b4
    test eax, eax                                # 0050d1b7
    je.d8 L_0050d1c8                             # 0050d1b9
    # block 0x0050d1bb: entered by fall-through of je at 0x0050d1b9, 5 instruction(s), calls FUN_005128b0, falls into the block at 0x0050d1c8
    push dword ptr [ebp - local_8]               # 0050d1bb
    push dword ptr [ebp + arg_8]                 # 0050d1be
    call FUN_005128b0                            # 0050d1c1
    pop ecx                                      # 0050d1c6
    pop ecx                                      # 0050d1c7
L_0050d1c8:
    # block 0x0050d1c8: entered by je at 0x0050d18d; je at 0x0050d19b; je at 0x0050d1b9, 3 instruction(s), ends with je to 0x0050d1d9 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 0050d1c8
    pop ebx                                      # 0050d1cc
    je.d8 L_0050d1d9                             # 0050d1cd
    # block 0x0050d1cf: entered by fall-through of je at 0x0050d1cd, 4 instruction(s), calls FUN_00512c79, ends with forward jump to 0x0050d1e0
    push 0x13                                    # 0050d1cf
    call FUN_00512c79                            # 0050d1d1
    pop ecx                                      # 0050d1d6
    jmp.d8 L_0050d1e0                            # 0050d1d7
L_0050d1d9:
    # block 0x0050d1d9: entered by je at 0x0050d1cd, 2 instruction(s), calls KERNEL32.dll!InterlockedDecrement, falls into the block at 0x0050d1e0
    push edi                                     # 0050d1d9
    call dword ptr [0x52a1fc]                    # 0050d1da
L_0050d1e0:
    # block 0x0050d1e0: entered by jmp at 0x0050d1d7, 4 instruction(s), calls FUN_0050e936, falls into the block at 0x0050d1ec
    push dword ptr [ebp - local_8]               # 0050d1e0
    call FUN_0050e936                            # 0050d1e3
    mov eax, dword ptr [ebp + arg_8]             # 0050d1e8
    pop ecx                                      # 0050d1eb
L_0050d1ec:
    # block 0x0050d1ec: entered by je at 0x0050d0d8; jmp at 0x0050d0f5; je at 0x0050d150; jmp at 0x0050d16d, 4 instruction(s), ends with ret
    pop edi                                      # 0050d1ec
    pop esi                                      # 0050d1ed
    leave                                        # 0050d1ee
    ret                                          # 0050d1ef

