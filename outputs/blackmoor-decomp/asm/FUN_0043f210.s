# FUN_0043f210
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043f210
# extent:       0x0043f210-0x0043f31a (266 code bytes)
# span:         0x0043f210-0x0043f31a (code 266, tables 0, padding 0)
# sha256:       6cc97c68404f69be5c45a8c4cb9de4126fe0a6070d2c6dac0bb590659aa64448
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0043f210
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       2 ebp-relative slot(s): local_190, local_194
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00423259, FUN_0050ca3e, FUN_0044a2b7, FUN_0052139c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 86 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_190, 0x190  # offset -0x190
.equ local_194, 0x194  # offset -0x194
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_00423259, .text + (0x00423259 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x0043f210 - 0x401000
.globl FUN_0043f210
FUN_0043f210:
    # block 0x0043f210: entry, 17 instruction(s), ends with je to 0x0043f268 (forward)
    push ebp                                     # 0043f210
    {load} mov ebp, esp                          # 0043f211
    sub esp, 0x194                               # 0043f213
    push esi                                     # 0043f219
    push edi                                     # 0043f21a
    mov ecx, 0x64                                # 0043f21b
    {load} xor eax, eax                          # 0043f220
    lea edi, [ebp - local_190]                   # 0043f222
    rep stosd dword ptr es:[edi], eax            # 0043f228
    mov edi, dword ptr [ebp + arg_c]             # 0043f22a
    or ecx, -0x1                                 # 0043f22d
    {load} xor eax, eax                          # 0043f230
    repne scasb al, byte ptr es:[edi]            # 0043f232
    not ecx                                      # 0043f234
    add ecx, -0x1                                # 0043f236
    test ecx, ecx                                # 0043f239
    je.d8 L_0043f268                             # 0043f23b
    # block 0x0043f23d: entered by fall-through of je at 0x0043f23b, 16 instruction(s), ends with forward jump to 0x0043f304
    mov edi, dword ptr [ebp + arg_c]             # 0043f23d
    lea edx, [ebp - local_190]                   # 0043f240
    or ecx, -0x1                                 # 0043f246
    {load} xor eax, eax                          # 0043f249
    repne scasb al, byte ptr es:[edi]            # 0043f24b
    not ecx                                      # 0043f24d
    {load} sub edi, ecx                          # 0043f24f
    {load} mov esi, edi                          # 0043f251
    {load} mov eax, ecx                          # 0043f253
    {load} mov edi, edx                          # 0043f255
    shr ecx, 0x2                                 # 0043f257
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043f25a
    {load} mov ecx, eax                          # 0043f25c
    and ecx, 0x3                                 # 0043f25e
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043f261
    jmp.d32 L_0043f304                           # 0043f263
L_0043f268:
    # block 0x0043f268: entered by je at 0x0043f23b, 7 instruction(s), calls FUN_00423259, ends with jne to 0x0043f2db (forward)
    mov ecx, dword ptr [ebp + arg_10]            # 0043f268
    push ecx                                     # 0043f26b
    mov ecx, 0x6187b9                            # 0043f26c
    call FUN_00423259                            # 0043f271
    mov dword ptr [ebp - local_194], eax         # 0043f276
    cmp dword ptr [ebp - local_194], 0x0         # 0043f27c
    jne.d8 L_0043f2db                            # 0043f283
    # block 0x0043f285: entered by fall-through of jne at 0x0043f283, 3 instruction(s), ends with je to 0x0043f2c1 (forward)
    movsx edx, word ptr [0x63a4cd]               # 0043f285
    test edx, edx                                # 0043f28c
    je.d8 L_0043f2c1                             # 0043f28e
    # block 0x0043f290: entered by fall-through of je at 0x0043f28e, 13 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, FUN_0052139c, falls into the block at 0x0043f2c1
    mov eax, dword ptr [ebp + arg_10]            # 0043f290
    push eax                                     # 0043f293
    push 0x547898                                # 0043f294
    push 0x63888b                                # 0043f299
    call FUN_0050ca3e                            # 0043f29e
    add esp, 0xc                                 # 0043f2a3
    push 0x63888b                                # 0043f2a6
    call FUN_0044a2b7                            # 0043f2ab
    add esp, 0x4                                 # 0043f2b0
    push 0x0                                     # 0043f2b3
    push 0x0                                     # 0043f2b5
    push 0x63888b                                # 0043f2b7
    call FUN_0052139c                            # 0043f2bc
L_0043f2c1:
    # block 0x0043f2c1: entered by je at 0x0043f28e, 8 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x0043f304
    mov ecx, dword ptr [ebp + arg_10]            # 0043f2c1
    push ecx                                     # 0043f2c4
    push 0x5478b4                                # 0043f2c5
    lea edx, [ebp - local_190]                   # 0043f2ca
    push edx                                     # 0043f2d0
    call FUN_0050ca3e                            # 0043f2d1
    add esp, 0xc                                 # 0043f2d6
    jmp.d8 L_0043f304                            # 0043f2d9
L_0043f2db:
    # block 0x0043f2db: entered by jne at 0x0043f283, 13 instruction(s), falls into the block at 0x0043f304
    mov edi, dword ptr [ebp - local_194]         # 0043f2db
    or ecx, -0x1                                 # 0043f2e1
    {load} xor eax, eax                          # 0043f2e4
    repne scasb al, byte ptr es:[edi]            # 0043f2e6
    not ecx                                      # 0043f2e8
    mov esi, dword ptr [ebp - local_194]         # 0043f2ea
    lea edi, [ebp - local_190]                   # 0043f2f0
    {load} mov eax, ecx                          # 0043f2f6
    shr ecx, 0x2                                 # 0043f2f8
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043f2fb
    {load} mov ecx, eax                          # 0043f2fd
    and ecx, 0x3                                 # 0043f2ff
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043f302
L_0043f304:
    # block 0x0043f304: entered by jmp at 0x0043f263; jmp at 0x0043f2d9, 9 instruction(s), ends with ret
    mov ecx, 0x64                                # 0043f304
    lea esi, [ebp - local_190]                   # 0043f309
    mov edi, dword ptr [ebp + arg_8]             # 0043f30f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043f312
    pop edi                                      # 0043f314
    pop esi                                      # 0043f315
    {load} mov esp, ebp                          # 0043f316
    pop ebp                                      # 0043f318
    ret                                          # 0043f319

