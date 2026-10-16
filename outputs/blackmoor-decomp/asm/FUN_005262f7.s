# FUN_005262f7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005262f7
# extent:       0x005262f7-0x00526408 (273 code bytes)
# span:         0x005262f7-0x00526408 (code 273, tables 0, padding 0)
# sha256:       afe98f3d562116c88425a800d5a5865c51be1d65aee3b8cad61832328cbc64ed
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005262f7
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x10 (callee pops 16 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8, field_c, field_10, field_14, field_minus_4, field_minus_c, field_minus_10, field_minus_14, field_minus_18, field_minus_1018; [ecx + n] field_7c, field_90
# callees:      calls FUN_0050f978, FUN_0050c920, FUN_00526245, FUN_0051ea75, FUN_0051eac4, ADVAPI32.dll!RegCloseKey, FUN_0051e52f, FUN_0051e828, FUN_0051e7ba, KERNEL32.dll!GetPrivateProfileStringA; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 89 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x00526408
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_minus_14, 0x14  # offset -0x14
.equ field_minus_18, 0x18  # offset -0x18
.equ field_minus_1018, 0x1018  # offset -0x1018
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_7c, 0x7c  # offset +0x7c
.equ field_90, 0x90  # offset +0x90

# --- external targets -----------------------------------------------
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051e52f, .text + (0x0051e52f - 0x401000)
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)
.set FUN_0051e828, .text + (0x0051e828 - 0x401000)
.set FUN_0051ea75, .text + (0x0051ea75 - 0x401000)
.set FUN_0051eac4, .text + (0x0051eac4 - 0x401000)
.set FUN_00526245, .text + (0x00526245 - 0x401000)

.org 0x005262f7 - 0x401000
.globl FUN_005262f7
FUN_005262f7:
    # block 0x005262f7: entry, 9 instruction(s), calls FUN_0050f978, FUN_0050c920, ends with je to 0x005263ba (forward)
    mov eax, 0x52918c                            # 005262f7
    call FUN_0050f978                            # 005262fc
    mov eax, 0x100c                              # 00526301
    call FUN_0050c920                            # 00526306
    push edi                                     # 0052630b
    {load} xor edi, edi                          # 0052630c
    cmp dword ptr [ecx + field_7c], edi          # 0052630e
    mov dword ptr [ebp - field_minus_14], edi    # 00526311
    je.d32 L_005263ba                            # 00526314
    # block 0x0052631a: entered by fall-through of je at 0x00526314, 5 instruction(s), calls FUN_00526245, ends with jne to 0x00526331 (forward)
    push dword ptr [ebp + field_c]               # 0052631a
    call FUN_00526245                            # 0052631d
    {load} cmp eax, edi                          # 00526322
    mov dword ptr [ebp - field_minus_10], eax    # 00526324
    jne.d8 L_00526331                            # 00526327
    # block 0x00526329: entered by fall-through of jne at 0x00526327, 2 instruction(s), ends with forward jump to 0x005263ee
    push dword ptr [ebp + field_14]              # 00526329
    jmp.d32 L_005263ee                           # 0052632c
L_00526331:
    # block 0x00526331: entered by jne at 0x00526327, 18 instruction(s), calls indirect esi, ends with jne to 0x00526384 (forward)
    mov ecx, dword ptr [0x5679b0]                # 00526331
    push ebx                                     # 00526337
    push esi                                     # 00526338
    mov dword ptr [ebp + field_c], ecx           # 00526339
    lea ecx, [ebp - field_minus_18]              # 0052633c
    mov esi, dword ptr [0x52a018]                # 0052633f
    push ecx                                     # 00526345
    lea ecx, [ebp - field_minus_14]              # 00526346
    push edi                                     # 00526349
    push ecx                                     # 0052634a
    push edi                                     # 0052634b
    mov dword ptr [ebp - field_minus_4], edi     # 0052634c
    push dword ptr [ebp + field_10]              # 0052634f
    push eax                                     # 00526352
    call esi                                     # 00526353
    {load} mov ebx, eax                          # 00526355
    {load} cmp ebx, edi                          # 00526357
    jne.d8 L_00526384                            # 00526359
    # block 0x0052635b: entered by fall-through of jne at 0x00526359, 16 instruction(s), calls FUN_0051ea75, indirect esi, FUN_0051eac4, falls into the block at 0x00526384
    lea eax, [ebp - field_minus_18]              # 0052635b
    lea ecx, [ebp + field_c]                     # 0052635e
    push eax                                     # 00526361
    push dword ptr [ebp - field_minus_18]        # 00526362
    call FUN_0051ea75                            # 00526365
    push eax                                     # 0052636a
    lea eax, [ebp - field_minus_14]              # 0052636b
    push eax                                     # 0052636e
    push edi                                     # 0052636f
    push dword ptr [ebp + field_10]              # 00526370
    push dword ptr [ebp - field_minus_10]        # 00526373
    call esi                                     # 00526376
    push -0x1                                    # 00526378
    lea ecx, [ebp + field_c]                     # 0052637a
    {load} mov ebx, eax                          # 0052637d
    call FUN_0051eac4                            # 0052637f
L_00526384:
    # block 0x00526384: entered by jne at 0x00526359, 6 instruction(s), calls ADVAPI32.dll!RegCloseKey, ends with jne to 0x005263a1 (forward)
    push dword ptr [ebp - field_minus_10]        # 00526384
    call dword ptr [0x52a000]                    # 00526387
    pop esi                                      # 0052638d
    {load} cmp ebx, edi                          # 0052638e
    pop ebx                                      # 00526390
    jne.d8 L_005263a1                            # 00526391
    # block 0x00526393: entered by fall-through of jne at 0x00526391, 5 instruction(s), calls FUN_0051e52f, ends with forward jump to 0x005263ac
    mov ecx, dword ptr [ebp + field_8]           # 00526393
    lea eax, [ebp + field_c]                     # 00526396
    push eax                                     # 00526399
    call FUN_0051e52f                            # 0052639a
    jmp.d8 L_005263ac                            # 0052639f
L_005263a1:
    # block 0x005263a1: entered by jne at 0x00526391, 3 instruction(s), calls FUN_0051e828, falls into the block at 0x005263ac
    push dword ptr [ebp + field_14]              # 005263a1
    mov ecx, dword ptr [ebp + field_8]           # 005263a4
    call FUN_0051e828                            # 005263a7
L_005263ac:
    # block 0x005263ac: entered by jmp at 0x0052639f, 4 instruction(s), calls FUN_0051e7ba, ends with forward jump to 0x005263f6
    or dword ptr [ebp - field_minus_4], -0x1     # 005263ac
    lea ecx, [ebp + field_c]                     # 005263b0
    call FUN_0051e7ba                            # 005263b3
    jmp.d8 L_005263f6                            # 005263b8
L_005263ba:
    # block 0x005263ba: entered by je at 0x00526314, 2 instruction(s), ends with jne to 0x005263c6 (forward)
    cmp dword ptr [ebp + field_14], edi          # 005263ba
    jne.d8 L_005263c6                            # 005263bd
    # block 0x005263bf: entered by fall-through of jne at 0x005263bd, 1 instruction(s), falls into the block at 0x005263c6
    mov dword ptr [ebp + field_14], 0x63c418     # 005263bf
L_005263c6:
    # block 0x005263c6: entered by jne at 0x005263bd, 10 instruction(s), calls KERNEL32.dll!GetPrivateProfileStringA, falls into the block at 0x005263ee
    push dword ptr [ecx + field_90]              # 005263c6
    lea eax, [ebp - field_minus_1018]            # 005263cc
    push 0x1000                                  # 005263d2
    push eax                                     # 005263d7
    push dword ptr [ebp + field_14]              # 005263d8
    push dword ptr [ebp + field_10]              # 005263db
    push dword ptr [ebp + field_c]               # 005263de
    call dword ptr [0x52a298]                    # 005263e1
    lea eax, [ebp - field_minus_1018]            # 005263e7
    push eax                                     # 005263ed
L_005263ee:
    # block 0x005263ee: entered by jmp at 0x0052632c, 2 instruction(s), calls FUN_0051e828, falls into the block at 0x005263f6
    mov ecx, dword ptr [ebp + field_8]           # 005263ee
    call FUN_0051e828                            # 005263f1
L_005263f6:
    # block 0x005263f6: entered by jmp at 0x005263b8, 6 instruction(s), ends with ret 0x10
    mov ecx, dword ptr [ebp - field_minus_c]     # 005263f6
    mov eax, dword ptr [ebp + field_8]           # 005263f9
    pop edi                                      # 005263fc
    mov dword ptr fs:[0x0], ecx                  # 005263fd
    leave                                        # 00526404
    ret 0x10                                     # 00526405

