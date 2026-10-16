# FUN_004fd2b0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fd2b0
# extent:       0x004fd2b0-0x004fd36e (190 code bytes)
# span:         0x004fd2b0-0x004fd370 (code 190, tables 0, padding 2)
# sha256:       df186437da52ad831017df4ed568eecde72c2f8267733ae52af368cf0e2b20bd
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fd2b0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_8, field_c, field_18; [esp + n] stk_10, stk_18, stk_20
# callees:      calls FUN_0050b5a0, FUN_004fd370
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 90 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ stk_18, 0x18  # offset +0x18
.equ field_18, 0x18  # offset +0x18
.equ stk_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_004fd370, .text + (0x004fd370 - 0x401000)
.set FUN_0050b5a0, .text + (0x0050b5a0 - 0x401000)

.org 0x004fd2b0 - 0x401000
.globl FUN_004fd2b0
FUN_004fd2b0:
    # block 0x004fd2b0: entry, 9 instruction(s), ends with jl to 0x004fd2d4 (forward)
    push ebx                                     # 004fd2b0
    mov ebx, dword ptr [esp + stk_10]            # 004fd2b1
    push ebp                                     # 004fd2b5
    push esi                                     # 004fd2b6
    mov esi, dword ptr [esp + stk_10]            # 004fd2b7
    push edi                                     # 004fd2bb
    mov edi, dword ptr [esp + stk_20]            # 004fd2bc
    test edi, edi                                # 004fd2c0
    jl.d8 L_004fd2d4                             # 004fd2c2
    # block 0x004fd2c4: entered by fall-through of jl at 0x004fd2c2, 1 instruction(s), ends with jg to 0x004fd2ca (forward)
    jg.d8 L_004fd2ca                             # 004fd2c4
    # block 0x004fd2c6: entered by fall-through of jg at 0x004fd2c4, 2 instruction(s), ends with jbe to 0x004fd2d4 (forward)
    test ebx, ebx                                # 004fd2c6
    jbe.d8 L_004fd2d4                            # 004fd2c8
L_004fd2ca:
    # block 0x004fd2ca: entered by jg at 0x004fd2c4; fall-through of jbe at 0x004fd2c8, 4 instruction(s), falls into the block at 0x004fd2d4
    mov eax, dword ptr [esi + field_8]           # 004fd2ca
    mov ecx, dword ptr [esi + field_c]           # 004fd2cd
    {load} add ebx, eax                          # 004fd2d0
    {load} adc edi, ecx                          # 004fd2d2
L_004fd2d4:
    # block 0x004fd2d4: entered by jl at 0x004fd2c2; jbe at 0x004fd2c8, 1 instruction(s), falls into the block at 0x004fd2d8
    mov ebp, dword ptr [esp + stk_18]            # 004fd2d4
L_004fd2d8:
    # block 0x004fd2d8: entered by jmp at 0x004fd314; jmp at 0x004fd32d, 2 instruction(s), ends with jl to 0x004fd2f2 (forward)
    test edi, edi                                # 004fd2d8
    jl.d8 L_004fd2f2                             # 004fd2da
    # block 0x004fd2dc: entered by fall-through of jl at 0x004fd2da, 1 instruction(s), ends with jg to 0x004fd2e2 (forward)
    jg.d8 L_004fd2e2                             # 004fd2dc
    # block 0x004fd2de: entered by fall-through of jg at 0x004fd2dc, 2 instruction(s), ends with jbe to 0x004fd2f2 (forward)
    test ebx, ebx                                # 004fd2de
    jbe.d8 L_004fd2f2                            # 004fd2e0
L_004fd2e2:
    # block 0x004fd2e2: entered by jg at 0x004fd2dc; fall-through of jbe at 0x004fd2e0, 3 instruction(s), ends with jg to 0x004fd32f (forward)
    mov edx, dword ptr [esi + field_c]           # 004fd2e2
    {load} cmp edx, edi                          # 004fd2e5
    jg.d8 L_004fd32f                             # 004fd2e7
    # block 0x004fd2e9: entered by fall-through of jg at 0x004fd2e7, 1 instruction(s), ends with jl to 0x004fd2f2 (forward)
    jl.d8 L_004fd2f2                             # 004fd2e9
    # block 0x004fd2eb: entered by fall-through of jl at 0x004fd2e9, 3 instruction(s), ends with jae to 0x004fd32f (forward)
    mov eax, dword ptr [esi + field_8]           # 004fd2eb
    {load} cmp eax, ebx                          # 004fd2ee
    jae.d8 L_004fd32f                            # 004fd2f0
L_004fd2f2:
    # block 0x004fd2f2: entered by jl at 0x004fd2da; jbe at 0x004fd2e0; jl at 0x004fd2e9; fall-through of jae at 0x004fd2f0, 7 instruction(s), calls FUN_0050b5a0, ends with jge to 0x004fd316 (forward)
    lea ecx, [esi + field_18]                    # 004fd2f2
    push ebp                                     # 004fd2f5
    push ecx                                     # 004fd2f6
    call FUN_0050b5a0                            # 004fd2f7
    add esp, 0x8                                 # 004fd2fc
    test eax, eax                                # 004fd2ff
    jge.d8 L_004fd316                            # 004fd301
    # block 0x004fd303: entered by fall-through of jge at 0x004fd301, 8 instruction(s), ends with backward jump to 0x004fd2d8
    mov ecx, dword ptr [esi + field_8]           # 004fd303
    cdq                                          # 004fd306
    {load} sub ecx, eax                          # 004fd307
    mov dword ptr [esi + field_8], ecx           # 004fd309
    mov eax, dword ptr [esi + field_c]           # 004fd30c
    {load} sbb eax, edx                          # 004fd30f
    mov dword ptr [esi + field_c], eax           # 004fd311
    jmp.d8 L_004fd2d8                            # 004fd314
L_004fd316:
    # block 0x004fd316: entered by jge at 0x004fd301, 1 instruction(s), ends with jne to 0x004fd354 (forward)
    jne.d8 L_004fd354                            # 004fd316
    # block 0x004fd318: entered by fall-through of jne at 0x004fd316, 3 instruction(s), ends with je to 0x004fd32f (forward)
    {load} mov edx, ebx                          # 004fd318
    {load} or edx, edi                           # 004fd31a
    je.d8 L_004fd32f                             # 004fd31c
    # block 0x004fd31e: entered by fall-through of je at 0x004fd31c, 5 instruction(s), calls FUN_004fd370, ends with je to 0x004fd33a (forward)
    push esi                                     # 004fd31e
    call FUN_004fd370                            # 004fd31f
    add esp, 0x4                                 # 004fd324
    test eax, eax                                # 004fd327
    je.d8 L_004fd33a                             # 004fd329
    # block 0x004fd32b: entered by fall-through of je at 0x004fd329, 1 instruction(s), ends with jl to 0x004fd347 (forward)
    jl.d8 L_004fd347                             # 004fd32b
    # block 0x004fd32d: entered by fall-through of jl at 0x004fd32b, 1 instruction(s), ends with backward jump to 0x004fd2d8
    jmp.d8 L_004fd2d8                            # 004fd32d
L_004fd32f:
    # block 0x004fd32f: entered by jg at 0x004fd2e7; jae at 0x004fd2f0; je at 0x004fd31c, 7 instruction(s), ends with ret
    pop edi                                      # 004fd32f
    pop esi                                      # 004fd330
    or eax, -0x1                                 # 004fd331
    pop ebp                                      # 004fd334
    or edx, -0x1                                 # 004fd335
    pop ebx                                      # 004fd338
    ret                                          # 004fd339
L_004fd33a:
    # block 0x004fd33a: entered by je at 0x004fd329, 7 instruction(s), ends with ret
    pop edi                                      # 004fd33a
    pop esi                                      # 004fd33b
    pop ebp                                      # 004fd33c
    mov eax, 0xfffffffe                          # 004fd33d
    or edx, -0x1                                 # 004fd342
    pop ebx                                      # 004fd345
    ret                                          # 004fd346
L_004fd347:
    # block 0x004fd347: entered by jl at 0x004fd32b, 7 instruction(s), ends with ret
    pop edi                                      # 004fd347
    pop esi                                      # 004fd348
    pop ebp                                      # 004fd349
    mov eax, 0xffffff80                          # 004fd34a
    or edx, -0x1                                 # 004fd34f
    pop ebx                                      # 004fd352
    ret                                          # 004fd353
L_004fd354:
    # block 0x004fd354: entered by jne at 0x004fd316, 14 instruction(s), ends with ret
    mov ecx, dword ptr [esi + field_8]           # 004fd354
    mov edi, dword ptr [esi + field_c]           # 004fd357
    cdq                                          # 004fd35a
    {load} add eax, ecx                          # 004fd35b
    {load} adc edx, edi                          # 004fd35d
    mov dword ptr [esi + field_8], eax           # 004fd35f
    mov dword ptr [esi + field_c], edx           # 004fd362
    {load} mov edx, edi                          # 004fd365
    pop edi                                      # 004fd367
    pop esi                                      # 004fd368
    pop ebp                                      # 004fd369
    {load} mov eax, ecx                          # 004fd36a
    pop ebx                                      # 004fd36c
    ret                                          # 004fd36d

# --- data items (not part of the function) -------------------------
.org 0x004fd36e - 0x401000
PAD_004fd36e:  # 2 byte(s) of nop padding
    .fill 2, 1, 0x90

