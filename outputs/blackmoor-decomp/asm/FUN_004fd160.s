# FUN_004fd160
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fd160
# extent:       0x004fd160-0x004fd2a1 (321 code bytes)
# span:         0x004fd160-0x004fd2b0 (code 321, tables 0, padding 15)
# sha256:       65663b0f66a71cc9547bf47a56ec38fe8b42e4241d43e9cd3e8fd87033c86eff
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fd160
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_58, field_74, field_1c2; [esp + n] stk_10, stk_14, stk_20, stk_3c, stk_48, stk_4c, stk_50, stk_5c
# callees:      calls FUN_004fd2b0, FUN_0050b260, FUN_0050ba50, FUN_004fe6d0, FUN_004fe640, FUN_0050b6f0, FUN_0050ba70, FUN_004fe870, FUN_004fe700, FUN_004fe660
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 127 instruction(s), 16 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_20, 0x20  # offset +0x20
.equ stk_3c, 0x3c  # offset +0x3c
.equ stk_48, 0x48  # offset +0x48
.equ stk_4c, 0x4c  # offset +0x4c
.equ stk_50, 0x50  # offset +0x50
.equ field_58, 0x58  # offset +0x58
.equ stk_5c, 0x5c  # offset +0x5c
.equ field_74, 0x74  # offset +0x74
.equ field_1c2, 0x1c2  # offset +0x1c2

# --- external targets -----------------------------------------------
.set FUN_004fd2b0, .text + (0x004fd2b0 - 0x401000)
.set FUN_004fe640, .text + (0x004fe640 - 0x401000)
.set FUN_004fe660, .text + (0x004fe660 - 0x401000)
.set FUN_004fe6d0, .text + (0x004fe6d0 - 0x401000)
.set FUN_004fe700, .text + (0x004fe700 - 0x401000)
.set FUN_004fe870, .text + (0x004fe870 - 0x401000)
.set FUN_0050b260, .text + (0x0050b260 - 0x401000)
.set FUN_0050b6f0, .text + (0x0050b6f0 - 0x401000)
.set FUN_0050ba50, .text + (0x0050ba50 - 0x401000)
.set FUN_0050ba70, .text + (0x0050ba70 - 0x401000)

.org 0x004fd160 - 0x401000
.globl FUN_004fd160
FUN_004fd160:
    # block 0x004fd160: entry, 9 instruction(s), ends with jne to 0x004fd1b5 (forward)
    sub esp, 0x30                                # 004fd160
    push ebx                                     # 004fd163
    mov ebx, dword ptr [esp + stk_48]            # 004fd164
    push ebp                                     # 004fd168
    mov ebp, dword ptr [esp + stk_3c]            # 004fd169
    push esi                                     # 004fd16d
    push edi                                     # 004fd16e
    test ebx, ebx                                # 004fd16f
    jne.d8 L_004fd1b5                            # 004fd171
    # block 0x004fd173: entered by fall-through of jne at 0x004fd171, 9 instruction(s), calls FUN_004fd2b0, ends with jne to 0x004fd19a (forward)
    push 0x0                                     # 004fd173
    lea eax, [esp + stk_14]                      # 004fd175
    push 0x2134                                  # 004fd179
    push eax                                     # 004fd17e
    push ebp                                     # 004fd17f
    call FUN_004fd2b0                            # 004fd180
    add esp, 0x10                                # 004fd185
    cmp eax, -0x80                               # 004fd188
    jne.d8 L_004fd19a                            # 004fd18b
    # block 0x004fd18d: entered by fall-through of jne at 0x004fd18b, 2 instruction(s), ends with jne to 0x004fd19a (forward)
    cmp edx, -0x1                                # 004fd18d
    jne.d8 L_004fd19a                            # 004fd190
    # block 0x004fd192: entered by fall-through of jne at 0x004fd190, 6 instruction(s), ends with ret
    pop edi                                      # 004fd192
    pop esi                                      # 004fd193
    pop ebp                                      # 004fd194
    pop ebx                                      # 004fd195
    add esp, 0x30                                # 004fd196
    ret                                          # 004fd199
L_004fd19a:
    # block 0x004fd19a: entered by jne at 0x004fd18b; jne at 0x004fd190, 2 instruction(s), ends with jg to 0x004fd1b1 (forward)
    test edx, edx                                # 004fd19a
    jg.d8 L_004fd1b1                             # 004fd19c
    # block 0x004fd19e: entered by fall-through of jg at 0x004fd19c, 1 instruction(s), ends with jl to 0x004fd1a4 (forward)
    jl.d8 L_004fd1a4                             # 004fd19e
    # block 0x004fd1a0: entered by fall-through of jl at 0x004fd19e, 2 instruction(s), ends with jae to 0x004fd1b1 (forward)
    test eax, eax                                # 004fd1a0
    jae.d8 L_004fd1b1                            # 004fd1a2
L_004fd1a4:
    # block 0x004fd1a4: entered by jl at 0x004fd19e; fall-through of jae at 0x004fd1a2, 7 instruction(s), ends with ret
    pop edi                                      # 004fd1a4
    pop esi                                      # 004fd1a5
    pop ebp                                      # 004fd1a6
    mov eax, 0xffffff7c                          # 004fd1a7
    pop ebx                                      # 004fd1ac
    add esp, 0x30                                # 004fd1ad
    ret                                          # 004fd1b0
L_004fd1b1:
    # block 0x004fd1b1: entered by jg at 0x004fd19c; jae at 0x004fd1a2, 1 instruction(s), falls into the block at 0x004fd1b5
    lea ebx, [esp + stk_10]                      # 004fd1b1
L_004fd1b5:
    # block 0x004fd1b5: entered by jne at 0x004fd171, 10 instruction(s), calls FUN_0050b260, FUN_0050ba50, ends with je to 0x004fd1d8 (forward)
    push ebx                                     # 004fd1b5
    lea esi, [ebp + field_74]                    # 004fd1b6
    call FUN_0050b260                            # 004fd1b9
    push eax                                     # 004fd1be
    push esi                                     # 004fd1bf
    call FUN_0050ba50                            # 004fd1c0
    mov eax, dword ptr [esp + stk_5c]            # 004fd1c5
    add esp, 0xc                                 # 004fd1c9
    test eax, eax                                # 004fd1cc
    je.d8 L_004fd1d8                             # 004fd1ce
    # block 0x004fd1d0: entered by fall-through of je at 0x004fd1ce, 2 instruction(s), falls into the block at 0x004fd1d8
    mov ecx, dword ptr [ebp + field_1c2]         # 004fd1d0
    mov dword ptr [eax], ecx                     # 004fd1d6
L_004fd1d8:
    # block 0x004fd1d8: entered by je at 0x004fd1ce, 9 instruction(s), calls FUN_004fe6d0, FUN_004fe640, falls into the block at 0x004fd1f8
    mov edx, dword ptr [esp + stk_48]            # 004fd1d8
    mov dword ptr [ebp + field_58], 0x3          # 004fd1dc
    push edx                                     # 004fd1e3
    call FUN_004fe6d0                            # 004fd1e4
    mov eax, dword ptr [esp + stk_50]            # 004fd1e9
    push eax                                     # 004fd1ed
    call FUN_004fe640                            # 004fd1ee
    add esp, 0x8                                 # 004fd1f3
    {load} xor edi, edi                          # 004fd1f6
L_004fd1f8:
    # block 0x004fd1f8: entered by jg at 0x004fd264; jae at 0x004fd268, 6 instruction(s), calls FUN_0050b6f0, ends with jge to 0x004fd297 (forward)
    push ebx                                     # 004fd1f8
    push esi                                     # 004fd1f9
    call FUN_0050b6f0                            # 004fd1fa
    add esp, 0x8                                 # 004fd1ff
    cmp edi, 0x3                                 # 004fd202
    jge.d32 L_004fd297                           # 004fd205
L_004fd20b:
    # block 0x004fd20b: entered by jmp at 0x004fd248; fall-through of jge at 0x004fd205, 8 instruction(s), calls FUN_0050ba70, ends with je to 0x004fd24a (forward)
    lea ecx, [esp + stk_20]                      # 004fd20b
    lea esi, [ebp + field_74]                    # 004fd20f
    push ecx                                     # 004fd212
    push esi                                     # 004fd213
    call FUN_0050ba70                            # 004fd214
    add esp, 0x8                                 # 004fd219
    test eax, eax                                # 004fd21c
    je.d8 L_004fd24a                             # 004fd21e
    # block 0x004fd220: entered by fall-through of je at 0x004fd21e, 2 instruction(s), ends with je to 0x004fd26a (forward)
    cmp eax, -0x1                                # 004fd220
    je.d8 L_004fd26a                             # 004fd223
    # block 0x004fd225: entered by fall-through of je at 0x004fd223, 11 instruction(s), calls FUN_004fe870, ends with jne to 0x004fd26f (forward)
    mov eax, dword ptr [esp + stk_4c]            # 004fd225
    mov ecx, dword ptr [esp + stk_48]            # 004fd229
    lea edx, [esp + stk_20]                      # 004fd22d
    push edx                                     # 004fd231
    push eax                                     # 004fd232
    push ecx                                     # 004fd233
    call FUN_004fe870                            # 004fd234
    {load} mov esi, eax                          # 004fd239
    add esp, 0xc                                 # 004fd23b
    test esi, esi                                # 004fd23e
    jne.d8 L_004fd26f                            # 004fd240
    # block 0x004fd242: entered by fall-through of jne at 0x004fd240, 3 instruction(s), ends with jge to 0x004fd297 (forward)
    inc edi                                      # 004fd242
    cmp edi, 0x3                                 # 004fd243
    jge.d8 L_004fd297                            # 004fd246
    # block 0x004fd248: entered by fall-through of jge at 0x004fd246, 1 instruction(s), ends with backward jump to 0x004fd20b
    jmp.d8 L_004fd20b                            # 004fd248
L_004fd24a:
    # block 0x004fd24a: entered by je at 0x004fd21e, 2 instruction(s), ends with jge to 0x004fd297 (forward)
    cmp edi, 0x3                                 # 004fd24a
    jge.d8 L_004fd297                            # 004fd24d
    # block 0x004fd24f: entered by fall-through of jge at 0x004fd24d, 8 instruction(s), calls FUN_004fd2b0, ends with jl to 0x004fd26a (forward)
    push 0x0                                     # 004fd24f
    push 0x2134                                  # 004fd251
    push ebx                                     # 004fd256
    push ebp                                     # 004fd257
    call FUN_004fd2b0                            # 004fd258
    add esp, 0x10                                # 004fd25d
    test edx, edx                                # 004fd260
    jl.d8 L_004fd26a                             # 004fd262
    # block 0x004fd264: entered by fall-through of jl at 0x004fd262, 1 instruction(s), ends with jg to 0x004fd1f8 (backward)
    jg.d8 L_004fd1f8                             # 004fd264
    # block 0x004fd266: entered by fall-through of jg at 0x004fd264, 2 instruction(s), ends with jae to 0x004fd1f8 (backward)
    test eax, eax                                # 004fd266
    jae.d8 L_004fd1f8                            # 004fd268
L_004fd26a:
    # block 0x004fd26a: entered by je at 0x004fd223; jl at 0x004fd262; fall-through of jae at 0x004fd268, 1 instruction(s), falls into the block at 0x004fd26f
    mov esi, 0xffffff7b                          # 004fd26a
L_004fd26f:
    # block 0x004fd26f: entered by jne at 0x004fd240, 15 instruction(s), calls FUN_004fe700, FUN_004fe660, ends with ret
    mov edx, dword ptr [esp + stk_48]            # 004fd26f
    push edx                                     # 004fd273
    call FUN_004fe700                            # 004fd274
    mov eax, dword ptr [esp + stk_50]            # 004fd279
    push eax                                     # 004fd27d
    call FUN_004fe660                            # 004fd27e
    add esp, 0x8                                 # 004fd283
    {load} mov eax, esi                          # 004fd286
    mov dword ptr [ebp + field_58], 0x2          # 004fd288
    pop edi                                      # 004fd28f
    pop esi                                      # 004fd290
    pop ebp                                      # 004fd291
    pop ebx                                      # 004fd292
    add esp, 0x30                                # 004fd293
    ret                                          # 004fd296
L_004fd297:
    # block 0x004fd297: entered by jge at 0x004fd205; jge at 0x004fd246; jge at 0x004fd24d, 7 instruction(s), ends with ret
    pop edi                                      # 004fd297
    pop esi                                      # 004fd298
    pop ebp                                      # 004fd299
    {load} xor eax, eax                          # 004fd29a
    pop ebx                                      # 004fd29c
    add esp, 0x30                                # 004fd29d
    ret                                          # 004fd2a0

# --- data items (not part of the function) -------------------------
.org 0x004fd2a1 - 0x401000
PAD_004fd2a1:  # 15 byte(s) of nop padding
    .fill 15, 1, 0x90

