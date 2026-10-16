# FUN_0051c22e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051c22e
# extent:       0x0051c22e-0x0051c2ab (125 code bytes)
# span:         0x0051c22e-0x0051c2ab (code 125, tables 0, padding 0)
# sha256:       3593b2bdf95f173da15c1d0961d3a4bc1e213ba39ca3481c346cfdd2d848a17a
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051c22e
# arguments:    6 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c; ret 0x18 (callee pops 24 bytes); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_1c
# callees:      calls FUN_0051ac0b, FUN_0051aa23, USER32.dll!SendMessageA, FUN_0051c22e, USER32.dll!GetWindow; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 49 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0051aa23, .text + (0x0051aa23 - 0x401000)
.set FUN_0051ac0b, .text + (0x0051ac0b - 0x401000)

.org 0x0051c22e - 0x401000
.globl FUN_0051c22e
FUN_0051c22e:
L_0051c22e:
    # block 0x0051c22e: entry, 7 instruction(s), calls indirect edi, falls into the block at 0x0051c23e
    push ebp                                     # 0051c22e
    {load} mov ebp, esp                          # 0051c22f
    push esi                                     # 0051c231
    push edi                                     # 0051c232
    push dword ptr [ebp + arg_8]                 # 0051c233
    mov edi, dword ptr [0x52a3d4]                # 0051c236
    call edi                                     # 0051c23c
L_0051c23e:
    # block 0x0051c23e: entered by jmp at 0x0051c2a3, 3 instruction(s), ends with je to 0x0051c2a5 (forward)
    {load} mov esi, eax                          # 0051c23e
    test esi, esi                                # 0051c240
    je.d8 L_0051c2a5                             # 0051c242
    # block 0x0051c244: entered by fall-through of je at 0x0051c242, 2 instruction(s), ends with je to 0x0051c268 (forward)
    cmp dword ptr [ebp + arg_1c], 0x0            # 0051c244
    je.d8 L_0051c268                             # 0051c248
    # block 0x0051c24a: entered by fall-through of je at 0x0051c248, 4 instruction(s), calls FUN_0051ac0b, ends with je to 0x0051c278 (forward)
    push esi                                     # 0051c24a
    call FUN_0051ac0b                            # 0051c24b
    test eax, eax                                # 0051c250
    je.d8 L_0051c278                             # 0051c252
    # block 0x0051c254: entered by fall-through of je at 0x0051c252, 7 instruction(s), calls FUN_0051aa23, ends with forward jump to 0x0051c278
    push dword ptr [ebp + arg_14]                # 0051c254
    push dword ptr [ebp + arg_10]                # 0051c257
    push dword ptr [ebp + arg_c]                 # 0051c25a
    push dword ptr [eax + field_1c]              # 0051c25d
    push eax                                     # 0051c260
    call FUN_0051aa23                            # 0051c261
    jmp.d8 L_0051c278                            # 0051c266
L_0051c268:
    # block 0x0051c268: entered by je at 0x0051c248, 5 instruction(s), calls USER32.dll!SendMessageA, falls into the block at 0x0051c278
    push dword ptr [ebp + arg_14]                # 0051c268
    push dword ptr [ebp + arg_10]                # 0051c26b
    push dword ptr [ebp + arg_c]                 # 0051c26e
    push esi                                     # 0051c271
    call dword ptr [0x52a4c8]                    # 0051c272
L_0051c278:
    # block 0x0051c278: entered by je at 0x0051c252; jmp at 0x0051c266, 2 instruction(s), ends with je to 0x0051c29a (forward)
    cmp dword ptr [ebp + arg_18], 0x0            # 0051c278
    je.d8 L_0051c29a                             # 0051c27c
    # block 0x0051c27e: entered by fall-through of je at 0x0051c27c, 4 instruction(s), calls indirect edi, ends with je to 0x0051c29a (forward)
    push esi                                     # 0051c27e
    call edi                                     # 0051c27f
    test eax, eax                                # 0051c281
    je.d8 L_0051c29a                             # 0051c283
    # block 0x0051c285: entered by fall-through of je at 0x0051c283, 7 instruction(s), calls FUN_0051c22e, falls into the block at 0x0051c29a
    push dword ptr [ebp + arg_1c]                # 0051c285
    push dword ptr [ebp + arg_18]                # 0051c288
    push dword ptr [ebp + arg_14]                # 0051c28b
    push dword ptr [ebp + arg_10]                # 0051c28e
    push dword ptr [ebp + arg_c]                 # 0051c291
    push esi                                     # 0051c294
    call L_0051c22e                              # 0051c295
L_0051c29a:
    # block 0x0051c29a: entered by je at 0x0051c27c; je at 0x0051c283, 4 instruction(s), calls USER32.dll!GetWindow, ends with backward jump to 0x0051c23e
    push 0x2                                     # 0051c29a
    push esi                                     # 0051c29c
    call dword ptr [0x52a450]                    # 0051c29d
    jmp.d8 L_0051c23e                            # 0051c2a3
L_0051c2a5:
    # block 0x0051c2a5: entered by je at 0x0051c242, 4 instruction(s), ends with ret 0x18
    pop edi                                      # 0051c2a5
    pop esi                                      # 0051c2a6
    pop ebp                                      # 0051c2a7
    ret 0x18                                     # 0051c2a8

