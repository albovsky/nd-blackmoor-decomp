# FUN_0051b125
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051b125
# extent:       0x0051b125-0x0051b1eb (198 code bytes)
# span:         0x0051b125-0x0051b1eb (code 198, tables 0, padding 0)
# sha256:       b8b3912d3d247afa755043b2413ca9ac84c74da4429093486661096ff0572342
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051b125
# arguments:    11 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c, arg_20, arg_24, arg_28, arg_2c, arg_30; ret 0x2c (callee pops 44 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       12 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30
# fields:       [eax + n] field_8, field_5c, field_a4
# callees:      calls FUN_00525371, FUN_0051b097, USER32.dll!CreateWindowExA, FUN_0051b0e3; plus 3 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 72 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
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
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ arg_20, 0x20  # offset +0x20
.equ arg_24, 0x24  # offset +0x24
.equ arg_28, 0x28  # offset +0x28
.equ arg_2c, 0x2c  # offset +0x2c
.equ arg_30, 0x30  # offset +0x30
.equ field_5c, 0x5c  # offset +0x5c
.equ field_a4, 0xa4  # offset +0xa4

# --- external targets -----------------------------------------------
.set FUN_0051b097, .text + (0x0051b097 - 0x401000)
.set FUN_0051b0e3, .text + (0x0051b0e3 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x0051b125 - 0x401000
.globl FUN_0051b125
FUN_0051b125:
    # block 0x0051b125: entry, 37 instruction(s), calls FUN_00525371, indirect dword ptr [eax + 0x5c], ends with jne to 0x0051b198 (forward)
    push ebp                                     # 0051b125
    {load} mov ebp, esp                          # 0051b126
    sub esp, 0x30                                # 0051b128
    mov eax, dword ptr [ebp + arg_8]             # 0051b12b
    push esi                                     # 0051b12e
    mov dword ptr [ebp - local_4], eax           # 0051b12f
    mov eax, dword ptr [ebp + arg_c]             # 0051b132
    mov dword ptr [ebp - local_8], eax           # 0051b135
    mov eax, dword ptr [ebp + arg_10]            # 0051b138
    mov dword ptr [ebp - local_c], eax           # 0051b13b
    mov eax, dword ptr [ebp + arg_14]            # 0051b13e
    mov dword ptr [ebp - local_10], eax          # 0051b141
    mov eax, dword ptr [ebp + arg_18]            # 0051b144
    mov dword ptr [ebp - local_14], eax          # 0051b147
    mov eax, dword ptr [ebp + arg_1c]            # 0051b14a
    mov dword ptr [ebp - local_18], eax          # 0051b14d
    mov eax, dword ptr [ebp + arg_20]            # 0051b150
    mov dword ptr [ebp - local_1c], eax          # 0051b153
    mov eax, dword ptr [ebp + arg_24]            # 0051b156
    mov dword ptr [ebp - local_20], eax          # 0051b159
    mov eax, dword ptr [ebp + arg_28]            # 0051b15c
    mov dword ptr [ebp - local_24], eax          # 0051b15f
    mov eax, dword ptr [ebp + arg_2c]            # 0051b162
    {load} mov esi, ecx                          # 0051b165
    mov dword ptr [ebp - local_28], eax          # 0051b167
    call FUN_00525371                            # 0051b16a
    mov eax, dword ptr [eax + field_8]           # 0051b16f
    lea ecx, [ebp - local_30]                    # 0051b172
    mov dword ptr [ebp - local_2c], eax          # 0051b175
    mov eax, dword ptr [ebp + arg_30]            # 0051b178
    mov dword ptr [ebp - local_30], eax          # 0051b17b
    mov eax, dword ptr [esi]                     # 0051b17e
    push ecx                                     # 0051b180
    {load} mov ecx, esi                          # 0051b181
    call dword ptr [eax + field_5c]              # 0051b183
    test eax, eax                                # 0051b186
    jne.d8 L_0051b198                            # 0051b188
    # block 0x0051b18a: entered by fall-through of jne at 0x0051b188, 5 instruction(s), calls indirect dword ptr [eax + 0xa4], ends with forward jump to 0x0051b1e6
    mov eax, dword ptr [esi]                     # 0051b18a
    {load} mov ecx, esi                          # 0051b18c
    call dword ptr [eax + field_a4]              # 0051b18e
    {load} xor eax, eax                          # 0051b194
    jmp.d8 L_0051b1e6                            # 0051b196
L_0051b198:
    # block 0x0051b198: entered by jne at 0x0051b188, 20 instruction(s), calls FUN_0051b097, USER32.dll!CreateWindowExA, FUN_0051b0e3, ends with jne to 0x0051b1de (forward)
    push edi                                     # 0051b198
    push esi                                     # 0051b199
    call FUN_0051b097                            # 0051b19a
    push dword ptr [ebp - local_30]              # 0051b19f
    push dword ptr [ebp - local_2c]              # 0051b1a2
    push dword ptr [ebp - local_28]              # 0051b1a5
    push dword ptr [ebp - local_24]              # 0051b1a8
    push dword ptr [ebp - local_20]              # 0051b1ab
    push dword ptr [ebp - local_1c]              # 0051b1ae
    push dword ptr [ebp - local_18]              # 0051b1b1
    push dword ptr [ebp - local_14]              # 0051b1b4
    push dword ptr [ebp - local_10]              # 0051b1b7
    push dword ptr [ebp - local_c]               # 0051b1ba
    push dword ptr [ebp - local_8]               # 0051b1bd
    push dword ptr [ebp - local_4]               # 0051b1c0
    call dword ptr [0x52a418]                    # 0051b1c3
    {load} mov edi, eax                          # 0051b1c9
    call FUN_0051b0e3                            # 0051b1cb
    test eax, eax                                # 0051b1d0
    jne.d8 L_0051b1de                            # 0051b1d2
    # block 0x0051b1d4: entered by fall-through of jne at 0x0051b1d2, 3 instruction(s), calls indirect dword ptr [eax + 0xa4], falls into the block at 0x0051b1de
    mov eax, dword ptr [esi]                     # 0051b1d4
    {load} mov ecx, esi                          # 0051b1d6
    call dword ptr [eax + field_a4]              # 0051b1d8
L_0051b1de:
    # block 0x0051b1de: entered by jne at 0x0051b1d2, 4 instruction(s), falls into the block at 0x0051b1e6
    {load} xor eax, eax                          # 0051b1de
    test edi, edi                                # 0051b1e0
    setne al                                     # 0051b1e2
    pop edi                                      # 0051b1e5
L_0051b1e6:
    # block 0x0051b1e6: entered by jmp at 0x0051b196, 3 instruction(s), ends with ret 0x2c
    pop esi                                      # 0051b1e6
    leave                                        # 0051b1e7
    ret 0x2c                                     # 0051b1e8

