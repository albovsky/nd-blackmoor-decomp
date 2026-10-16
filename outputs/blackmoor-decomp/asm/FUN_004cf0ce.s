# FUN_004cf0ce
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cf0ce
# extent:       0x004cf0ce-0x004cf1e4 (278 code bytes)
# span:         0x004cf0ce-0x004cf1e4 (code 278, tables 0, padding 0)
# sha256:       42d02963e7e2830193850153918c34944c9fd457de189c2cbc03e9421af04fbd
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004cf0ce
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       8 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20
# fields:       [eax + n] field_2d, field_2f, field_31; [ecx + n] field_21, field_2f, field_31, field_226; [edx + n] field_21, field_2d
# callees:      calls FUN_004cf0a9
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 91 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ arg_8, 0x8  # offset +0x8
.equ field_21, 0x21  # offset +0x21
.equ field_2d, 0x2d  # offset +0x2d
.equ field_2f, 0x2f  # offset +0x2f
.equ field_31, 0x31  # offset +0x31
.equ field_226, 0x226  # offset +0x226

# --- external targets -----------------------------------------------
.set FUN_004cf0a9, .text + (0x004cf0a9 - 0x401000)

.org 0x004cf0ce - 0x401000
.globl FUN_004cf0ce
FUN_004cf0ce:
    # block 0x004cf0ce: entry, 15 instruction(s), ends with forward jump to 0x004cf107
    push ebp                                     # 004cf0ce
    {load} mov ebp, esp                          # 004cf0cf
    sub esp, 0x20                                # 004cf0d1
    mov dword ptr [ebp - local_20], ecx          # 004cf0d4
    mov eax, dword ptr [ebp + arg_8]             # 004cf0d7
    imul eax, eax, 0x35                          # 004cf0da
    mov ecx, dword ptr [ebp - local_20]          # 004cf0dd
    mov edx, dword ptr [ecx + field_226]         # 004cf0e0
    {load} add edx, eax                          # 004cf0e6
    mov dword ptr [ebp - local_10], edx          # 004cf0e8
    mov eax, dword ptr [ebp - local_10]          # 004cf0eb
    movsx ecx, word ptr [eax + field_2d]         # 004cf0ee
    mov dword ptr [ebp - local_1c], ecx          # 004cf0f2
    mov dword ptr [ebp - local_14], 0x0          # 004cf0f5
    jmp.d8 L_004cf107                            # 004cf0fc
L_004cf0fe:
    # block 0x004cf0fe: entered by jmp at 0x004cf12c, 3 instruction(s), falls into the block at 0x004cf107
    mov edx, dword ptr [ebp - local_14]          # 004cf0fe
    add edx, 0x1                                 # 004cf101
    mov dword ptr [ebp - local_14], edx          # 004cf104
L_004cf107:
    # block 0x004cf107: entered by jmp at 0x004cf0fc, 4 instruction(s), ends with jge to 0x004cf12e (forward)
    mov eax, dword ptr [ebp - local_10]          # 004cf107
    movsx ecx, word ptr [eax + field_2f]         # 004cf10a
    cmp dword ptr [ebp - local_14], ecx          # 004cf10e
    jge.d8 L_004cf12e                            # 004cf111
    # block 0x004cf113: entered by fall-through of jge at 0x004cf111, 9 instruction(s), ends with backward jump to 0x004cf0fe
    mov edx, dword ptr [ebp - local_14]          # 004cf113
    imul edx, edx, 0x23                          # 004cf116
    mov eax, dword ptr [ebp - local_10]          # 004cf119
    mov ecx, dword ptr [eax + field_31]          # 004cf11c
    movsx edx, word ptr [ecx + edx + field_21]   # 004cf11f
    mov eax, dword ptr [ebp - local_1c]          # 004cf124
    {load} add eax, edx                          # 004cf127
    mov dword ptr [ebp - local_1c], eax          # 004cf129
    jmp.d8 L_004cf0fe                            # 004cf12c
L_004cf12e:
    # block 0x004cf12e: entered by jge at 0x004cf111, 12 instruction(s), calls FUN_004cf0a9, ends with jle to 0x004cf17b (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004cf12e
    push ecx                                     # 004cf131
    mov ecx, dword ptr [ebp - local_20]          # 004cf132
    call FUN_004cf0a9                            # 004cf135
    mov dword ptr [ebp - local_4], eax           # 004cf13a
    mov dword ptr [ebp - local_c], 0x0           # 004cf13d
    mov edx, dword ptr [ebp - local_c]           # 004cf144
    mov dword ptr [ebp - local_8], edx           # 004cf147
    mov eax, dword ptr [ebp - local_10]          # 004cf14a
    movsx ecx, word ptr [eax + field_2d]         # 004cf14d
    test ecx, ecx                                # 004cf151
    jle.d8 L_004cf17b                            # 004cf153
    # block 0x004cf155: entered by fall-through of jle at 0x004cf153, 7 instruction(s), ends with jl to 0x004cf17b (forward)
    mov dword ptr [ebp - local_8], 0x0           # 004cf155
    mov edx, dword ptr [ebp - local_10]          # 004cf15c
    movsx eax, word ptr [edx + field_2d]         # 004cf15f
    mov dword ptr [ebp - local_c], eax           # 004cf163
    mov ecx, dword ptr [ebp - local_4]           # 004cf166
    cmp ecx, dword ptr [ebp - local_8]           # 004cf169
    jl.d8 L_004cf17b                             # 004cf16c
    # block 0x004cf16e: entered by fall-through of jl at 0x004cf16c, 3 instruction(s), ends with jge to 0x004cf17b (forward)
    mov edx, dword ptr [ebp - local_4]           # 004cf16e
    cmp edx, dword ptr [ebp - local_c]           # 004cf171
    jge.d8 L_004cf17b                            # 004cf174
    # block 0x004cf176: entered by fall-through of jge at 0x004cf174, 2 instruction(s), ends with forward jump to 0x004cf1de
    or eax, -0x1                                 # 004cf176
    jmp.d8 L_004cf1de                            # 004cf179
L_004cf17b:
    # block 0x004cf17b: entered by jle at 0x004cf153; jl at 0x004cf16c; jge at 0x004cf174, 2 instruction(s), ends with forward jump to 0x004cf18d
    mov dword ptr [ebp - local_14], 0x0          # 004cf17b
    jmp.d8 L_004cf18d                            # 004cf182
L_004cf184:
    # block 0x004cf184: entered by jmp at 0x004cf1b3; jmp at 0x004cf1d9, 3 instruction(s), falls into the block at 0x004cf18d
    mov eax, dword ptr [ebp - local_14]          # 004cf184
    add eax, 0x1                                 # 004cf187
    mov dword ptr [ebp - local_14], eax          # 004cf18a
L_004cf18d:
    # block 0x004cf18d: entered by jmp at 0x004cf182, 4 instruction(s), ends with jge to 0x004cf1db (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004cf18d
    movsx edx, word ptr [ecx + field_2f]         # 004cf190
    cmp dword ptr [ebp - local_14], edx          # 004cf194
    jge.d8 L_004cf1db                            # 004cf197
    # block 0x004cf199: entered by fall-through of jge at 0x004cf197, 8 instruction(s), ends with jg to 0x004cf1b5 (forward)
    mov eax, dword ptr [ebp - local_14]          # 004cf199
    imul eax, eax, 0x23                          # 004cf19c
    mov ecx, dword ptr [ebp - local_10]          # 004cf19f
    mov edx, dword ptr [ecx + field_31]          # 004cf1a2
    movsx eax, word ptr [edx + eax + field_21]   # 004cf1a5
    mov dword ptr [ebp - local_18], eax          # 004cf1aa
    cmp dword ptr [ebp - local_18], 0x0          # 004cf1ad
    jg.d8 L_004cf1b5                             # 004cf1b1
    # block 0x004cf1b3: entered by fall-through of jg at 0x004cf1b1, 1 instruction(s), ends with backward jump to 0x004cf184
    jmp.d8 L_004cf184                            # 004cf1b3
L_004cf1b5:
    # block 0x004cf1b5: entered by jg at 0x004cf1b1, 8 instruction(s), ends with jl to 0x004cf1d9 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004cf1b5
    mov dword ptr [ebp - local_8], ecx           # 004cf1b8
    mov edx, dword ptr [ebp - local_c]           # 004cf1bb
    add edx, dword ptr [ebp - local_18]          # 004cf1be
    mov dword ptr [ebp - local_c], edx           # 004cf1c1
    mov eax, dword ptr [ebp - local_4]           # 004cf1c4
    cmp eax, dword ptr [ebp - local_8]           # 004cf1c7
    jl.d8 L_004cf1d9                             # 004cf1ca
    # block 0x004cf1cc: entered by fall-through of jl at 0x004cf1ca, 3 instruction(s), ends with jge to 0x004cf1d9 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004cf1cc
    cmp ecx, dword ptr [ebp - local_c]           # 004cf1cf
    jge.d8 L_004cf1d9                            # 004cf1d2
    # block 0x004cf1d4: entered by fall-through of jge at 0x004cf1d2, 2 instruction(s), ends with forward jump to 0x004cf1de
    mov eax, dword ptr [ebp - local_14]          # 004cf1d4
    jmp.d8 L_004cf1de                            # 004cf1d7
L_004cf1d9:
    # block 0x004cf1d9: entered by jl at 0x004cf1ca; jge at 0x004cf1d2, 1 instruction(s), ends with backward jump to 0x004cf184
    jmp.d8 L_004cf184                            # 004cf1d9
L_004cf1db:
    # block 0x004cf1db: entered by jge at 0x004cf197, 1 instruction(s), falls into the block at 0x004cf1de
    or eax, -0x1                                 # 004cf1db
L_004cf1de:
    # block 0x004cf1de: entered by jmp at 0x004cf179; jmp at 0x004cf1d7, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004cf1de
    pop ebp                                      # 004cf1e0
    ret 0x4                                      # 004cf1e1

