# FUN_0050c0e9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c0e9
# extent:       0x0050c0e9-0x0050c17c (147 code bytes)
# span:         0x0050c0e9-0x0050c17c (code 147, tables 0, padding 0)
# sha256:       256b56b71acaceb7c21a24fbb8868d9699de96c805c64684c4719780ee1e8ae6
# evidence:     ev_6b87ed72115c87fed1179d88fa97974f93d6f22889e386bb49899d21464413f2
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c0e9
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_10
# fields:       [ebx + n] field_4, field_8, field_c, field_10, field_14, field_24
# callees:      calls FUN_0050bf50, USER32.dll!SystemParametersInfoA, KERNEL32.dll!lstrcpyA; plus 3 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 61 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_24, 0x24  # offset +0x24

# --- external targets -----------------------------------------------
.set FUN_0050bf50, .text + (0x0050bf50 - 0x401000)

.org 0x0050c0e9 - 0x401000
.globl FUN_0050c0e9
FUN_0050c0e9:
    # block 0x0050c0e9: entry, 8 instruction(s), calls FUN_0050bf50, ends with je to 0x0050c108 (forward)
    push ebp                                     # 0050c0e9
    {load} mov ebp, esp                          # 0050c0ea
    sub esp, 0x10                                # 0050c0ec
    push ebx                                     # 0050c0ef
    push esi                                     # 0050c0f0
    call FUN_0050bf50                            # 0050c0f1
    test eax, eax                                # 0050c0f6
    je.d8 L_0050c108                             # 0050c0f8
    # block 0x0050c0fa: entered by fall-through of je at 0x0050c0f8, 4 instruction(s), calls indirect dword ptr [0x63c368], ends with forward jump to 0x0050c176
    push dword ptr [ebp + arg_c]                 # 0050c0fa
    push dword ptr [ebp + arg_8]                 # 0050c0fd
    call dword ptr [0x63c368]                    # 0050c100
    jmp.d8 L_0050c176                            # 0050c106
L_0050c108:
    # block 0x0050c108: entered by je at 0x0050c0f8, 2 instruction(s), ends with jne to 0x0050c174 (forward)
    cmp dword ptr [ebp + arg_8], 0x12340042      # 0050c108
    jne.d8 L_0050c174                            # 0050c10f
    # block 0x0050c111: entered by fall-through of jne at 0x0050c10f, 4 instruction(s), ends with je to 0x0050c174 (forward)
    mov ebx, dword ptr [ebp + arg_c]             # 0050c111
    {load} xor esi, esi                          # 0050c114
    {load} cmp ebx, esi                          # 0050c116
    je.d8 L_0050c174                             # 0050c118
    # block 0x0050c11a: entered by fall-through of je at 0x0050c118, 2 instruction(s), ends with jb to 0x0050c174 (forward)
    cmp dword ptr [ebx], 0x28                    # 0050c11a
    jb.d8 L_0050c174                             # 0050c11d
    # block 0x0050c11f: entered by fall-through of jb at 0x0050c11d, 8 instruction(s), calls USER32.dll!SystemParametersInfoA, ends with je to 0x0050c174 (forward)
    lea eax, [ebp - local_10]                    # 0050c11f
    push esi                                     # 0050c122
    push eax                                     # 0050c123
    push esi                                     # 0050c124
    push 0x30                                    # 0050c125
    call dword ptr [0x52a4bc]                    # 0050c127
    test eax, eax                                # 0050c12d
    je.d8 L_0050c174                             # 0050c12f
    # block 0x0050c131: entered by fall-through of je at 0x0050c12f, 22 instruction(s), calls indirect esi, ends with jb to 0x0050c170 (forward)
    push edi                                     # 0050c131
    mov dword ptr [ebx + field_4], esi           # 0050c132
    mov dword ptr [ebx + field_8], esi           # 0050c135
    push esi                                     # 0050c138
    mov esi, dword ptr [0x52a498]                # 0050c139
    call esi                                     # 0050c13f
    push 0x1                                     # 0050c141
    mov dword ptr [ebx + field_c], eax           # 0050c143
    call esi                                     # 0050c146
    lea edi, [ebx + field_14]                    # 0050c148
    lea esi, [ebp - local_10]                    # 0050c14b
    movsd dword ptr es:[edi], dword ptr [esi]    # 0050c14e
    movsd dword ptr es:[edi], dword ptr [esi]    # 0050c14f
    movsd dword ptr es:[edi], dword ptr [esi]    # 0050c150
    cmp dword ptr [ebx], 0x48                    # 0050c151
    push 0x1                                     # 0050c154
    movsd dword ptr es:[edi], dword ptr [esi]    # 0050c156
    pop esi                                      # 0050c157
    mov dword ptr [ebx + field_10], eax          # 0050c158
    mov dword ptr [ebx + field_24], esi          # 0050c15b
    pop edi                                      # 0050c15e
    jb.d8 L_0050c170                             # 0050c15f
    # block 0x0050c161: entered by fall-through of jb at 0x0050c15f, 4 instruction(s), calls KERNEL32.dll!lstrcpyA, falls into the block at 0x0050c170
    add ebx, 0x28                                # 0050c161
    push 0x52ea3c                                # 0050c164
    push ebx                                     # 0050c169
    call dword ptr [0x52a244]                    # 0050c16a
L_0050c170:
    # block 0x0050c170: entered by jb at 0x0050c15f, 2 instruction(s), ends with forward jump to 0x0050c176
    {load} mov eax, esi                          # 0050c170
    jmp.d8 L_0050c176                            # 0050c172
L_0050c174:
    # block 0x0050c174: entered by jne at 0x0050c10f; je at 0x0050c118; jb at 0x0050c11d; je at 0x0050c12f, 1 instruction(s), falls into the block at 0x0050c176
    {load} xor eax, eax                          # 0050c174
L_0050c176:
    # block 0x0050c176: entered by jmp at 0x0050c106; jmp at 0x0050c172, 4 instruction(s), ends with ret 0x8
    pop esi                                      # 0050c176
    pop ebx                                      # 0050c177
    leave                                        # 0050c178
    ret 0x8                                      # 0050c179

