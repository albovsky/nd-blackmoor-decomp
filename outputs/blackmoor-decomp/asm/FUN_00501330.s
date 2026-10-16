# FUN_00501330
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00501330
# extent:       0x00501330-0x005013f2 (194 code bytes)
# span:         0x00501330-0x00501400 (code 194, tables 0, padding 14)
# sha256:       3969d9f5b9bb6320018ef2a9e03e9ed6766d4d466b3eef9b1f0762115570f4af
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00501330
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_4, field_8; [esp + n] stk_8, stk_c, stk_14, stk_1c, stk_20, stk_24, stk_28, stk_2c
# callees:      calls FUN_0050ce04
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 69 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ stk_14, 0x14  # offset +0x14
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c

# --- external targets -----------------------------------------------
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x00501330 - 0x401000
.globl FUN_00501330
FUN_00501330:
    # block 0x00501330: entry, 12 instruction(s), calls FUN_0050ce04, ends with jl to 0x0050135d (forward)
    fld dword ptr [esp + stk_c]                  # 00501330
    fadd dword ptr [esp + stk_1c]                # 00501334
    fsub qword ptr [0x52e5e8]                    # 00501338
    fmul qword ptr [0x52e5f8]                    # 0050133e
    call FUN_0050ce04                            # 00501344
    {load} xor ecx, ecx                          # 00501349
    test eax, eax                                # 0050134b
    setle cl                                     # 0050134d
    dec ecx                                      # 00501350
    {load} and eax, ecx                          # 00501351
    cmp eax, 0x7                                 # 00501353
    jl.d8 L_0050135d                             # 00501356
    # block 0x00501358: entered by fall-through of jl at 0x00501356, 1 instruction(s), falls into the block at 0x0050135d
    mov eax, 0x7                                 # 00501358
L_0050135d:
    # block 0x0050135d: entered by jl at 0x00501356, 26 instruction(s), calls FUN_0050ce04, ends with jge to 0x005013ed (forward)
    mov edx, dword ptr [esp + stk_8]             # 0050135d
    push ebx                                     # 00501361
    push ebp                                     # 00501362
    push esi                                     # 00501363
    mov esi, dword ptr [edx + 4*eax]             # 00501364
    push edi                                     # 00501367
    fld dword ptr [esi + field_4]                # 00501368
    call FUN_0050ce04                            # 0050136b
    fld dword ptr [esi]                          # 00501370
    fsub dword ptr [0x52e584]                    # 00501372
    fimul dword ptr [esp + stk_28]               # 00501378
    mov ebx, dword ptr [esp + stk_28]            # 0050137c
    {load} mov ebp, eax                          # 00501380
    {load} mov eax, ebx                          # 00501382
    mov dword ptr [esp + stk_2c], ebp            # 00501384
    sar eax                                      # 00501388
    mov dword ptr [esp + stk_28], eax            # 0050138a
    fiadd dword ptr [esp + stk_20]               # 0050138e
    fisub dword ptr [esp + stk_28]               # 00501392
    call FUN_0050ce04                            # 00501396
    fld dword ptr [esi]                          # 0050139b
    {load} mov edi, eax                          # 0050139d
    call FUN_0050ce04                            # 0050139f
    {load} mov ecx, eax                          # 005013a4
    {load} cmp ecx, ebp                          # 005013a6
    jge.d8 L_005013ed                            # 005013a8
    # block 0x005013aa: entered by fall-through of jge at 0x005013a8, 4 instruction(s), falls into the block at 0x005013bc
    mov edx, dword ptr [esp + stk_14]            # 005013aa
    lea ebp, [4*ebx]                             # 005013ae
    lea esi, [esi + 4*ecx + field_8]             # 005013b5
    lea edx, [edx + 4*edi]                       # 005013b9
L_005013bc:
    # block 0x005013bc: entered by jl at 0x005013eb, 2 instruction(s), ends with jle to 0x005013d5 (forward)
    test edi, edi                                # 005013bc
    jle.d8 L_005013d5                            # 005013be
    # block 0x005013c0: entered by fall-through of jle at 0x005013be, 6 instruction(s), ends with jne to 0x005013d3 (forward)
    fld dword ptr [esp + stk_1c]                 # 005013c0
    fadd dword ptr [esi]                         # 005013c4
    fcom dword ptr [edx]                         # 005013c6
    fnstsw ax                                    # 005013c8
    test ah, 0x41                                # 005013ca
    jne.d8 L_005013d3                            # 005013cd
    # block 0x005013cf: entered by fall-through of jne at 0x005013cd, 2 instruction(s), ends with forward jump to 0x005013d5
    fstp dword ptr [edx]                         # 005013cf
    jmp.d8 L_005013d5                            # 005013d1
L_005013d3:
    # block 0x005013d3: entered by jne at 0x005013cd, 1 instruction(s), falls into the block at 0x005013d5
    fstp st(0)                                   # 005013d3
L_005013d5:
    # block 0x005013d5: entered by jle at 0x005013be; jmp at 0x005013d1, 5 instruction(s), ends with jge to 0x005013ed (forward)
    mov eax, dword ptr [esp + stk_24]            # 005013d5
    {load} add edi, ebx                          # 005013d9
    {load} add edx, ebp                          # 005013db
    {load} cmp edi, eax                          # 005013dd
    jge.d8 L_005013ed                            # 005013df
    # block 0x005013e1: entered by fall-through of jge at 0x005013df, 5 instruction(s), ends with jl to 0x005013bc (backward)
    mov eax, dword ptr [esp + stk_2c]            # 005013e1
    inc ecx                                      # 005013e5
    add esi, 0x4                                 # 005013e6
    {load} cmp ecx, eax                          # 005013e9
    jl.d8 L_005013bc                             # 005013eb
L_005013ed:
    # block 0x005013ed: entered by jge at 0x005013a8; jge at 0x005013df; fall-through of jl at 0x005013eb, 5 instruction(s), ends with ret
    pop edi                                      # 005013ed
    pop esi                                      # 005013ee
    pop ebp                                      # 005013ef
    pop ebx                                      # 005013f0
    ret                                          # 005013f1

# --- data items (not part of the function) -------------------------
.org 0x005013f2 - 0x401000
PAD_005013f2:  # 14 byte(s) of nop padding
    .fill 14, 1, 0x90

