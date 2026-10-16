# FUN_00513174
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513174
# extent:       0x00513174-0x00513236 (194 code bytes)
# span:         0x00513174-0x00513236 (code 194, tables 0, padding 0)
# sha256:       1c3a7157fbac8510ef5d1424d7d7a8b386e387047b5642c87e83bdf1af0458e7
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00513174
# arguments:    7 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c, arg_20; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       5 ebp-relative slot(s): local_8, local_10, local_14, local_1c, local_24
# fields:       [ebx + n] field_minus_1
# callees:      calls FUN_00515f67, FUN_0051621c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 65 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_8, 0x8  # offset -0x8
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_1c, 0x1c  # offset -0x1c
.equ local_24, 0x24  # offset -0x24
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ arg_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_00515f67, .text + (0x00515f67 - 0x401000)
.set FUN_0051621c, .text + (0x0051621c - 0x401000)

.org 0x00513174 - 0x401000
.globl FUN_00513174
FUN_00513174:
    # block 0x00513174: entry, 8 instruction(s), ends with jl to 0x00513230 (forward)
    push ebp                                     # 00513174
    {load} mov ebp, esp                          # 00513175
    sub esp, 0x24                                # 00513177
    push ebx                                     # 0051317a
    mov ebx, dword ptr [ebp + arg_8]             # 0051317b
    sub ebx, 0x76c                               # 0051317e
    cmp ebx, 0x46                                # 00513184
    jl.d32 L_00513230                            # 00513187
    # block 0x0051318d: entered by fall-through of jl at 0x00513187, 2 instruction(s), ends with jg to 0x00513230 (forward)
    cmp ebx, 0x8a                                # 0051318d
    jg.d32 L_00513230                            # 00513193
    # block 0x00513199: entered by fall-through of jg at 0x00513193, 7 instruction(s), ends with jne to 0x005131b3 (forward)
    push esi                                     # 00513199
    push edi                                     # 0051319a
    mov edi, dword ptr [ebp + arg_c]             # 0051319b
    mov esi, dword ptr [4*edi + 0x568c64]        # 0051319e
    add esi, dword ptr [ebp + arg_10]            # 005131a5
    test bl, 0x3                                 # 005131a8
    jne.d8 L_005131b3                            # 005131ab
    # block 0x005131ad: entered by fall-through of jne at 0x005131ab, 2 instruction(s), ends with jle to 0x005131b3 (forward)
    cmp edi, 0x2                                 # 005131ad
    jle.d8 L_005131b3                            # 005131b0
    # block 0x005131b2: entered by fall-through of jle at 0x005131b0, 1 instruction(s), falls into the block at 0x005131b3
    inc esi                                      # 005131b2
L_005131b3:
    # block 0x005131b3: entered by jne at 0x005131ab; jle at 0x005131b0, 27 instruction(s), calls FUN_00515f67, ends with je to 0x00513226 (forward)
    call FUN_00515f67                            # 005131b3
    {load} mov eax, ebx                          # 005131b8
    lea ecx, [ebx - field_minus_1]               # 005131ba
    imul eax, eax, 0x16d                         # 005131bd
    sar ecx, 0x2                                 # 005131c3
    {load} mov edx, esi                          # 005131c6
    mov dword ptr [ebp - local_8], esi           # 005131c8
    {load} add edx, ecx                          # 005131cb
    mov dword ptr [ebp - local_10], ebx          # 005131cd
    {load} add eax, edx                          # 005131d0
    mov edx, dword ptr [ebp + arg_1c]            # 005131d2
    lea ecx, [eax + 2*eax]                       # 005131d5
    mov eax, dword ptr [ebp + arg_14]            # 005131d8
    mov dword ptr [ebp - local_1c], eax          # 005131db
    lea ecx, [eax + 8*ecx]                       # 005131de
    imul ecx, ecx, 0x3c                          # 005131e1
    add ecx, dword ptr [ebp + arg_18]            # 005131e4
    imul ecx, ecx, 0x3c                          # 005131e7
    add ecx, dword ptr [0x568b80]                # 005131ea
    dec edi                                      # 005131f0
    cmp dword ptr [ebp + arg_20], 0x1            # 005131f1
    mov dword ptr [ebp - local_14], edi          # 005131f5
    pop edi                                      # 005131f8
    pop esi                                      # 005131f9
    lea ecx, [ecx + edx + 0x7c558180]            # 005131fa
    mov dword ptr [ebp + arg_8], ecx             # 00513201
    je.d8 L_00513226                             # 00513204
    # block 0x00513206: entered by fall-through of je at 0x00513204, 2 instruction(s), ends with jne to 0x0051322c (forward)
    cmp dword ptr [ebp + arg_20], -0x1           # 00513206
    jne.d8 L_0051322c                            # 0051320a
    # block 0x0051320c: entered by fall-through of jne at 0x0051320a, 2 instruction(s), ends with je to 0x0051322c (forward)
    cmp dword ptr [0x568b84], 0x0                # 0051320c
    je.d8 L_0051322c                             # 00513213
    # block 0x00513215: entered by fall-through of je at 0x00513213, 7 instruction(s), calls FUN_0051621c, ends with je to 0x0051322c (forward)
    lea eax, [ebp - local_24]                    # 00513215
    push eax                                     # 00513218
    call FUN_0051621c                            # 00513219
    pop ecx                                      # 0051321e
    mov ecx, dword ptr [ebp + arg_8]             # 0051321f
    test eax, eax                                # 00513222
    je.d8 L_0051322c                             # 00513224
L_00513226:
    # block 0x00513226: entered by je at 0x00513204; fall-through of je at 0x00513224, 1 instruction(s), falls into the block at 0x0051322c
    add ecx, dword ptr [0x568b88]                # 00513226
L_0051322c:
    # block 0x0051322c: entered by jne at 0x0051320a; je at 0x00513213; je at 0x00513224, 2 instruction(s), ends with forward jump to 0x00513233
    {load} mov eax, ecx                          # 0051322c
    jmp.d8 L_00513233                            # 0051322e
L_00513230:
    # block 0x00513230: entered by jl at 0x00513187; jg at 0x00513193, 1 instruction(s), falls into the block at 0x00513233
    or eax, -0x1                                 # 00513230
L_00513233:
    # block 0x00513233: entered by jmp at 0x0051322e, 3 instruction(s), ends with ret
    pop ebx                                      # 00513233
    leave                                        # 00513234
    ret                                          # 00513235

