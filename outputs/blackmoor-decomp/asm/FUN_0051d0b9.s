# FUN_0051d0b9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051d0b9
# extent:       0x0051d0b9-0x0051d370 (695 code bytes)
# span:         0x0051d0b9-0x0051d370 (code 695, tables 0, padding 0)
# sha256:       bf6338c4a43a0957e4b0ffb8197073b94ea8470047588eb4e06cef00553b375b
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051d0b9
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       9 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_18, local_1c, local_24, local_30, local_34
# fields:       [eax + n] field_8, field_18; [ecx + n] field_18
# callees:      calls FUN_00525371, FUN_0050f920, FUN_0051b720, FUN_0051d001, FUN_0051d042
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 226 instruction(s), 25 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0051d370
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_24, 0x24  # offset -0x24
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_0050f920, .text + (0x0050f920 - 0x401000)
.set FUN_0051b720, .text + (0x0051b720 - 0x401000)
.set FUN_0051d001, .text + (0x0051d001 - 0x401000)
.set FUN_0051d042, .text + (0x0051d042 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x0051d0b9 - 0x401000
.globl FUN_0051d0b9
FUN_0051d0b9:
    # block 0x0051d0b9: entry, 9 instruction(s), calls FUN_00525371, ends with jne to 0x0051d0d9 (forward)
    push ebp                                     # 0051d0b9
    {load} mov ebp, esp                          # 0051d0ba
    sub esp, 0x34                                # 0051d0bc
    call FUN_00525371                            # 0051d0bf
    mov dword ptr [ebp - local_4], eax           # 0051d0c4
    mov eax, dword ptr [eax + field_18]          # 0051d0c7
    not eax                                      # 0051d0ca
    and dword ptr [ebp + arg_8], eax             # 0051d0cc
    jne.d8 L_0051d0d9                            # 0051d0cf
    # block 0x0051d0d1: entered by fall-through of jne at 0x0051d0cf, 3 instruction(s), ends with forward jump to 0x0051d36c
    push 0x1                                     # 0051d0d1
    pop eax                                      # 0051d0d3
    jmp.d32 L_0051d36c                           # 0051d0d4
L_0051d0d9:
    # block 0x0051d0d9: entered by jne at 0x0051d0cf, 23 instruction(s), calls FUN_0050f920, FUN_00525371, ends with je to 0x0051d134 (forward)
    push ebx                                     # 0051d0d9
    push esi                                     # 0051d0da
    push edi                                     # 0051d0db
    {load} xor edi, edi                          # 0051d0dc
    push 0x28                                    # 0051d0de
    lea eax, [ebp - local_34]                    # 0051d0e0
    push edi                                     # 0051d0e3
    push eax                                     # 0051d0e4
    {load} xor esi, esi                          # 0051d0e5
    call FUN_0050f920                            # 0051d0e7
    mov eax, dword ptr [0x52a410]                # 0051d0ec
    add esp, 0xc                                 # 0051d0f1
    mov dword ptr [ebp - local_30], eax          # 0051d0f4
    call FUN_00525371                            # 0051d0f7
    mov eax, dword ptr [eax + field_8]           # 0051d0fc
    push 0x8                                     # 0051d0ff
    test byte ptr [ebp + arg_8], 0x1             # 0051d101
    mov dword ptr [ebp - local_24], eax          # 0051d105
    mov eax, dword ptr [0x63c788]                # 0051d108
    pop ebx                                      # 0051d10d
    mov dword ptr [ebp - local_1c], eax          # 0051d10e
    mov dword ptr [ebp - local_c], ebx           # 0051d111
    je.d8 L_0051d134                             # 0051d114
    # block 0x0051d116: entered by fall-through of je at 0x0051d114, 7 instruction(s), calls FUN_0051b720, ends with je to 0x0051d134 (forward)
    lea eax, [ebp - local_34]                    # 0051d116
    mov dword ptr [ebp - local_34], 0xb          # 0051d119
    push eax                                     # 0051d120
    mov dword ptr [ebp - local_10], 0x52e96c     # 0051d121
    call FUN_0051b720                            # 0051d128
    test eax, eax                                # 0051d12d
    je.d8 L_0051d134                             # 0051d12f
    # block 0x0051d131: entered by fall-through of je at 0x0051d12f, 2 instruction(s), falls into the block at 0x0051d134
    push 0x1                                     # 0051d131
    pop esi                                      # 0051d133
L_0051d134:
    # block 0x0051d134: entered by je at 0x0051d114; je at 0x0051d12f, 2 instruction(s), ends with je to 0x0051d155 (forward)
    test byte ptr [ebp + arg_8], 0x20            # 0051d134
    je.d8 L_0051d155                             # 0051d138
    # block 0x0051d13a: entered by fall-through of je at 0x0051d138, 7 instruction(s), calls FUN_0051b720, ends with je to 0x0051d155 (forward)
    or byte ptr [ebp - local_34], -0x75          # 0051d13a
    lea eax, [ebp - local_34]                    # 0051d13e
    push eax                                     # 0051d141
    mov dword ptr [ebp - local_10], 0x52e9b0     # 0051d142
    call FUN_0051b720                            # 0051d149
    test eax, eax                                # 0051d14e
    je.d8 L_0051d155                             # 0051d150
    # block 0x0051d152: entered by fall-through of je at 0x0051d150, 1 instruction(s), falls into the block at 0x0051d155
    or esi, 0x20                                 # 0051d152
L_0051d155:
    # block 0x0051d155: entered by je at 0x0051d138; je at 0x0051d150, 2 instruction(s), ends with je to 0x0051d17c (forward)
    test byte ptr [ebp + arg_8], 0x2             # 0051d155
    je.d8 L_0051d17c                             # 0051d159
    # block 0x0051d15b: entered by fall-through of je at 0x0051d159, 8 instruction(s), calls FUN_0051b720, ends with je to 0x0051d17c (forward)
    lea eax, [ebp - local_34]                    # 0051d15b
    mov dword ptr [ebp - local_34], edi          # 0051d15e
    push eax                                     # 0051d161
    mov dword ptr [ebp - local_10], 0x52e978     # 0051d162
    mov dword ptr [ebp - local_18], 0x10         # 0051d169
    call FUN_0051b720                            # 0051d170
    test eax, eax                                # 0051d175
    je.d8 L_0051d17c                             # 0051d177
    # block 0x0051d179: entered by fall-through of je at 0x0051d177, 1 instruction(s), falls into the block at 0x0051d17c
    or esi, 0x2                                  # 0051d179
L_0051d17c:
    # block 0x0051d17c: entered by je at 0x0051d159; je at 0x0051d177, 2 instruction(s), ends with je to 0x0051d1a2 (forward)
    test byte ptr [ebp + arg_8], 0x4             # 0051d17c
    je.d8 L_0051d1a2                             # 0051d180
    # block 0x0051d182: entered by fall-through of je at 0x0051d180, 9 instruction(s), calls FUN_0051d001, ends with je to 0x0051d1a2 (forward)
    push 0x7a01                                  # 0051d182
    lea eax, [ebp - local_34]                    # 0051d187
    push 0x52e98c                                # 0051d18a
    push eax                                     # 0051d18f
    mov dword ptr [ebp - local_34], ebx          # 0051d190
    mov dword ptr [ebp - local_18], edi          # 0051d193
    call FUN_0051d001                            # 0051d196
    test eax, eax                                # 0051d19b
    je.d8 L_0051d1a2                             # 0051d19d
    # block 0x0051d19f: entered by fall-through of je at 0x0051d19d, 1 instruction(s), falls into the block at 0x0051d1a2
    or esi, 0x4                                  # 0051d19f
L_0051d1a2:
    # block 0x0051d1a2: entered by je at 0x0051d180; je at 0x0051d19d, 2 instruction(s), ends with je to 0x0051d1ce (forward)
    test byte ptr [ebp + arg_8], bl              # 0051d1a2
    je.d8 L_0051d1ce                             # 0051d1a5
    # block 0x0051d1a7: entered by fall-through of je at 0x0051d1a5, 9 instruction(s), calls FUN_0051d001, ends with je to 0x0051d1ce (forward)
    push 0x7a02                                  # 0051d1a7
    lea eax, [ebp - local_34]                    # 0051d1ac
    push 0x52e99c                                # 0051d1af
    push eax                                     # 0051d1b4
    mov dword ptr [ebp - local_34], 0xb          # 0051d1b5
    mov dword ptr [ebp - local_18], 0x6          # 0051d1bc
    call FUN_0051d001                            # 0051d1c3
    test eax, eax                                # 0051d1c8
    je.d8 L_0051d1ce                             # 0051d1ca
    # block 0x0051d1cc: entered by fall-through of je at 0x0051d1ca, 1 instruction(s), falls into the block at 0x0051d1ce
    {load} or esi, ebx                           # 0051d1cc
L_0051d1ce:
    # block 0x0051d1ce: entered by je at 0x0051d1a5; je at 0x0051d1ca, 2 instruction(s), ends with je to 0x0051d1f1 (forward)
    test byte ptr [ebp + arg_8], 0x10            # 0051d1ce
    je.d8 L_0051d1f1                             # 0051d1d2
    # block 0x0051d1d4: entered by fall-through of je at 0x0051d1d2, 7 instruction(s), calls FUN_0051d042, falls into the block at 0x0051d1f1
    lea eax, [ebp - local_c]                     # 0051d1d4
    push 0x3fc0                                  # 0051d1d7
    push eax                                     # 0051d1dc
    mov dword ptr [ebp - local_8], 0xff          # 0051d1dd
    call FUN_0051d042                            # 0051d1e4
    {load} or esi, eax                           # 0051d1e9
    .insn 0x6681/4, dword ptr [ebp + arg_8], -16321{:s16} # 0051d1eb
L_0051d1f1:
    # block 0x0051d1f1: entered by je at 0x0051d1d2, 2 instruction(s), ends with je to 0x0051d20b (forward)
    test byte ptr [ebp + arg_8], 0x40            # 0051d1f1
    je.d8 L_0051d20b                             # 0051d1f5
    # block 0x0051d1f7: entered by fall-through of je at 0x0051d1f5, 6 instruction(s), calls FUN_0051d042, falls into the block at 0x0051d20b
    lea eax, [ebp - local_c]                     # 0051d1f7
    push 0x40                                    # 0051d1fa
    push eax                                     # 0051d1fc
    mov dword ptr [ebp - local_8], 0x10          # 0051d1fd
    call FUN_0051d042                            # 0051d204
    {load} or esi, eax                           # 0051d209
L_0051d20b:
    # block 0x0051d20b: entered by je at 0x0051d1f5, 2 instruction(s), ends with je to 0x0051d228 (forward)
    test byte ptr [ebp + arg_8], -0x80           # 0051d20b
    je.d8 L_0051d228                             # 0051d20f
    # block 0x0051d211: entered by fall-through of je at 0x0051d20f, 6 instruction(s), calls FUN_0051d042, falls into the block at 0x0051d228
    lea eax, [ebp - local_c]                     # 0051d211
    push 0x80                                    # 0051d214
    push eax                                     # 0051d219
    mov dword ptr [ebp - local_8], 0x2           # 0051d21a
    call FUN_0051d042                            # 0051d221
    {load} or esi, eax                           # 0051d226
L_0051d228:
    # block 0x0051d228: entered by je at 0x0051d20f, 3 instruction(s), ends with je to 0x0051d241 (forward)
    mov eax, 0x100                               # 0051d228
    test dword ptr [ebp + arg_8], eax            # 0051d22d
    je.d8 L_0051d241                             # 0051d230
    # block 0x0051d232: entered by fall-through of je at 0x0051d230, 6 instruction(s), calls FUN_0051d042, falls into the block at 0x0051d241
    push eax                                     # 0051d232
    lea eax, [ebp - local_c]                     # 0051d233
    push eax                                     # 0051d236
    mov dword ptr [ebp - local_8], ebx           # 0051d237
    call FUN_0051d042                            # 0051d23a
    {load} or esi, eax                           # 0051d23f
L_0051d241:
    # block 0x0051d241: entered by je at 0x0051d230, 3 instruction(s), ends with je to 0x0051d25e (forward)
    mov eax, 0x200                               # 0051d241
    test dword ptr [ebp + arg_8], eax            # 0051d246
    je.d8 L_0051d25e                             # 0051d249
    # block 0x0051d24b: entered by fall-through of je at 0x0051d249, 6 instruction(s), calls FUN_0051d042, falls into the block at 0x0051d25e
    push eax                                     # 0051d24b
    lea eax, [ebp - local_c]                     # 0051d24c
    push eax                                     # 0051d24f
    mov dword ptr [ebp - local_8], 0x20          # 0051d250
    call FUN_0051d042                            # 0051d257
    {load} or esi, eax                           # 0051d25c
L_0051d25e:
    # block 0x0051d25e: entered by je at 0x0051d249, 3 instruction(s), ends with je to 0x0051d27b (forward)
    mov ebx, 0x400                               # 0051d25e
    test dword ptr [ebp + arg_8], ebx            # 0051d263
    je.d8 L_0051d27b                             # 0051d266
    # block 0x0051d268: entered by fall-through of je at 0x0051d266, 6 instruction(s), calls FUN_0051d042, falls into the block at 0x0051d27b
    lea eax, [ebp - local_c]                     # 0051d268
    push ebx                                     # 0051d26b
    push eax                                     # 0051d26c
    mov dword ptr [ebp - local_8], 0x1           # 0051d26d
    call FUN_0051d042                            # 0051d274
    {load} or esi, eax                           # 0051d279
L_0051d27b:
    # block 0x0051d27b: entered by je at 0x0051d266, 3 instruction(s), ends with je to 0x0051d298 (forward)
    mov edi, 0x800                               # 0051d27b
    test dword ptr [ebp + arg_8], edi            # 0051d280
    je.d8 L_0051d298                             # 0051d283
    # block 0x0051d285: entered by fall-through of je at 0x0051d283, 6 instruction(s), calls FUN_0051d042, falls into the block at 0x0051d298
    lea eax, [ebp - local_c]                     # 0051d285
    push edi                                     # 0051d288
    push eax                                     # 0051d289
    mov dword ptr [ebp - local_8], 0x40          # 0051d28a
    call FUN_0051d042                            # 0051d291
    {load} or esi, eax                           # 0051d296
L_0051d298:
    # block 0x0051d298: entered by je at 0x0051d283, 3 instruction(s), ends with je to 0x0051d2b5 (forward)
    mov eax, 0x1000                              # 0051d298
    test dword ptr [ebp + arg_8], eax            # 0051d29d
    je.d8 L_0051d2b5                             # 0051d2a0
    # block 0x0051d2a2: entered by fall-through of je at 0x0051d2a0, 6 instruction(s), calls FUN_0051d042, falls into the block at 0x0051d2b5
    push eax                                     # 0051d2a2
    lea eax, [ebp - local_c]                     # 0051d2a3
    push eax                                     # 0051d2a6
    mov dword ptr [ebp - local_8], 0x4           # 0051d2a7
    call FUN_0051d042                            # 0051d2ae
    {load} or esi, eax                           # 0051d2b3
L_0051d2b5:
    # block 0x0051d2b5: entered by je at 0x0051d2a0, 3 instruction(s), ends with je to 0x0051d2d2 (forward)
    mov eax, 0x2000                              # 0051d2b5
    test dword ptr [ebp + arg_8], eax            # 0051d2ba
    je.d8 L_0051d2d2                             # 0051d2bd
    # block 0x0051d2bf: entered by fall-through of je at 0x0051d2bd, 6 instruction(s), calls FUN_0051d042, falls into the block at 0x0051d2d2
    push eax                                     # 0051d2bf
    lea eax, [ebp - local_c]                     # 0051d2c0
    push eax                                     # 0051d2c3
    mov dword ptr [ebp - local_8], 0x80          # 0051d2c4
    call FUN_0051d042                            # 0051d2cb
    {load} or esi, eax                           # 0051d2d0
L_0051d2d2:
    # block 0x0051d2d2: entered by je at 0x0051d2bd, 3 instruction(s), ends with je to 0x0051d2eb (forward)
    mov eax, 0x4000                              # 0051d2d2
    test dword ptr [ebp + arg_8], eax            # 0051d2d7
    je.d8 L_0051d2eb                             # 0051d2da
    # block 0x0051d2dc: entered by fall-through of je at 0x0051d2da, 6 instruction(s), calls FUN_0051d042, falls into the block at 0x0051d2eb
    push eax                                     # 0051d2dc
    lea eax, [ebp - local_c]                     # 0051d2dd
    push eax                                     # 0051d2e0
    mov dword ptr [ebp - local_8], edi           # 0051d2e1
    call FUN_0051d042                            # 0051d2e4
    {load} or esi, eax                           # 0051d2e9
L_0051d2eb:
    # block 0x0051d2eb: entered by je at 0x0051d2da, 3 instruction(s), ends with je to 0x0051d304 (forward)
    mov eax, 0x8000                              # 0051d2eb
    test dword ptr [ebp + arg_8], eax            # 0051d2f0
    je.d8 L_0051d304                             # 0051d2f3
    # block 0x0051d2f5: entered by fall-through of je at 0x0051d2f3, 6 instruction(s), calls FUN_0051d042, falls into the block at 0x0051d304
    push eax                                     # 0051d2f5
    lea eax, [ebp - local_c]                     # 0051d2f6
    push eax                                     # 0051d2f9
    mov dword ptr [ebp - local_8], ebx           # 0051d2fa
    call FUN_0051d042                            # 0051d2fd
    {load} or esi, eax                           # 0051d302
L_0051d304:
    # block 0x0051d304: entered by je at 0x0051d2f3, 3 instruction(s), ends with je to 0x0051d321 (forward)
    mov eax, 0x10000                             # 0051d304
    test dword ptr [ebp + arg_8], eax            # 0051d309
    je.d8 L_0051d321                             # 0051d30c
    # block 0x0051d30e: entered by fall-through of je at 0x0051d30c, 6 instruction(s), calls FUN_0051d042, falls into the block at 0x0051d321
    push eax                                     # 0051d30e
    lea eax, [ebp - local_c]                     # 0051d30f
    push eax                                     # 0051d312
    mov dword ptr [ebp - local_8], 0x200         # 0051d313
    call FUN_0051d042                            # 0051d31a
    {load} or esi, eax                           # 0051d31f
L_0051d321:
    # block 0x0051d321: entered by je at 0x0051d30c, 3 instruction(s), ends with je to 0x0051d33e (forward)
    mov eax, 0x20000                             # 0051d321
    test dword ptr [ebp + arg_8], eax            # 0051d326
    je.d8 L_0051d33e                             # 0051d329
    # block 0x0051d32b: entered by fall-through of je at 0x0051d329, 6 instruction(s), calls FUN_0051d042, falls into the block at 0x0051d33e
    push eax                                     # 0051d32b
    lea eax, [ebp - local_c]                     # 0051d32c
    push eax                                     # 0051d32f
    mov dword ptr [ebp - local_8], 0x100         # 0051d330
    call FUN_0051d042                            # 0051d337
    {load} or esi, eax                           # 0051d33c
L_0051d33e:
    # block 0x0051d33e: entered by je at 0x0051d329, 8 instruction(s), ends with jne to 0x0051d35c (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0051d33e
    mov edx, 0x3fc0                              # 0051d341
    or dword ptr [ecx + field_18], esi           # 0051d346
    mov eax, dword ptr [ecx + field_18]          # 0051d349
    {load} mov edi, eax                          # 0051d34c
    {load} and edi, edx                          # 0051d34e
    {load} cmp edi, edx                          # 0051d350
    jne.d8 L_0051d35c                            # 0051d352
    # block 0x0051d354: entered by fall-through of jne at 0x0051d352, 3 instruction(s), falls into the block at 0x0051d35c
    or al, 0x10                                  # 0051d354
    or esi, 0x10                                 # 0051d356
    mov dword ptr [ecx + field_18], eax          # 0051d359
L_0051d35c:
    # block 0x0051d35c: entered by jne at 0x0051d352, 9 instruction(s), falls into the block at 0x0051d36c
    {load} mov eax, esi                          # 0051d35c
    pop edi                                      # 0051d35e
    and eax, dword ptr [ebp + arg_8]             # 0051d35f
    pop esi                                      # 0051d362
    pop ebx                                      # 0051d363
    sub eax, dword ptr [ebp + arg_8]             # 0051d364
    neg eax                                      # 0051d367
    {load} sbb eax, eax                          # 0051d369
    inc eax                                      # 0051d36b
L_0051d36c:
    # block 0x0051d36c: entered by jmp at 0x0051d0d4, 2 instruction(s), ends with ret 0x4
    leave                                        # 0051d36c
    ret 0x4                                      # 0051d36d

