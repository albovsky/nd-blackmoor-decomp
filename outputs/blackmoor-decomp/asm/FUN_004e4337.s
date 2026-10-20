# FUN_004e4337
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e4337
# extent:       0x004e4337-0x004e4428 (241 code bytes)
# span:         0x004e4337-0x004e4428 (code 241, tables 0, padding 0)
# sha256:       cc3f8179f7ac4fe258c213ae474393b32617ca8faa06331cdaff3a1a499299a3
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e4337_load_blocks
# naming:       native port src/original_methods_fl29b.c:m4e4337_load_blocks (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    Three forward block copies (rep movsd/movsb) into self with a word-sized third length and a signed limit check; oracle executes every instruction and both jump directions (negative word is a native rejection). See tasks/fl29b-handoff.md.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [ecx + n] field_1471
# callees:      calls FUN_0050ca3e, FUN_004264e8, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl29b.c:m4e4337_load_blocks (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 73 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_1471, 0x1471  # offset +0x1471

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004e4337 - 0x401000
.globl FUN_004e4337
FUN_004e4337:
    # block 0x004e4337: entry, 55 instruction(s), ends with jle to 0x004e4420 (forward)
    push ebp                                     # 004e4337
    {load} mov ebp, esp                          # 004e4338
    sub esp, 0xc                                 # 004e433a
    push esi                                     # 004e433d
    push edi                                     # 004e433e
    mov dword ptr [ebp - local_c], ecx           # 004e433f
    mov dword ptr [ebp - local_8], 0x0           # 004e4342
    mov edi, dword ptr [ebp - local_c]           # 004e4349
    add edi, 0x6d2                               # 004e434c
    mov ecx, 0xbc                                # 004e4352
    mov esi, dword ptr [ebp + arg_8]             # 004e4357
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e435a
    mov eax, dword ptr [ebp + arg_8]             # 004e435c
    add eax, 0x2f0                               # 004e435f
    mov dword ptr [ebp + arg_8], eax             # 004e4364
    mov ecx, dword ptr [ebp - local_8]           # 004e4367
    add ecx, 0x2f0                               # 004e436a
    mov dword ptr [ebp - local_8], ecx           # 004e4370
    mov edi, dword ptr [ebp - local_c]           # 004e4373
    add edi, 0x9c2                               # 004e4376
    mov ecx, 0x2ac                               # 004e437c
    mov esi, dword ptr [ebp + arg_8]             # 004e4381
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e4384
    movsb byte ptr es:[edi], byte ptr [esi]      # 004e4386
    mov edx, dword ptr [ebp + arg_8]             # 004e4387
    add edx, 0xab1                               # 004e438a
    mov dword ptr [ebp + arg_8], edx             # 004e4390
    mov eax, dword ptr [ebp - local_8]           # 004e4393
    add eax, 0xab1                               # 004e4396
    mov dword ptr [ebp - local_8], eax           # 004e439b
    mov ecx, dword ptr [ebp - local_c]           # 004e439e
    movsx edx, word ptr [ecx + field_1471]       # 004e43a1
    imul edx, edx, 0x29                          # 004e43a8
    mov word ptr [ebp - local_4], dx             # 004e43ab
    movsx ecx, word ptr [ebp - local_4]          # 004e43af
    mov esi, dword ptr [ebp + arg_8]             # 004e43b3
    mov edi, dword ptr [ebp - local_c]           # 004e43b6
    add edi, 0x457b                              # 004e43b9
    {load} mov eax, ecx                          # 004e43bf
    shr ecx, 0x2                                 # 004e43c1
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e43c4
    {load} mov ecx, eax                          # 004e43c6
    and ecx, 0x3                                 # 004e43c8
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004e43cb
    movsx ecx, word ptr [ebp - local_4]          # 004e43cd
    mov edx, dword ptr [ebp + arg_8]             # 004e43d1
    {load} add edx, ecx                          # 004e43d4
    mov dword ptr [ebp + arg_8], edx             # 004e43d6
    movsx eax, word ptr [ebp - local_4]          # 004e43d9
    mov ecx, dword ptr [ebp - local_8]           # 004e43dd
    {load} add ecx, eax                          # 004e43e0
    mov dword ptr [ebp - local_8], ecx           # 004e43e2
    mov edx, dword ptr [ebp - local_8]           # 004e43e5
    cmp edx, dword ptr [ebp + arg_c]             # 004e43e8
    jle.d8 L_004e4420                            # 004e43eb
    # block 0x004e43ed: entered by fall-through of jle at 0x004e43eb, 13 instruction(s), calls FUN_0050ca3e, FUN_004264e8, FUN_004c97b4, falls into the block at 0x004e4420
    mov eax, dword ptr [ebp + arg_c]             # 004e43ed
    push eax                                     # 004e43f0
    mov ecx, dword ptr [ebp - local_8]           # 004e43f1
    push ecx                                     # 004e43f4
    push 0x55c0c0                                # 004e43f5
    push 0x63888b                                # 004e43fa
    call FUN_0050ca3e                            # 004e43ff
    add esp, 0x10                                # 004e4404
    push 0x63888b                                # 004e4407
    mov ecx, 0x583979                            # 004e440c
    call FUN_004264e8                            # 004e4411
    mov ecx, 0x5cf659                            # 004e4416
    call FUN_004c97b4                            # 004e441b
L_004e4420:
    # block 0x004e4420: entered by jle at 0x004e43eb, 5 instruction(s), ends with ret 0x8
    pop edi                                      # 004e4420
    pop esi                                      # 004e4421
    {load} mov esp, ebp                          # 004e4422
    pop ebp                                      # 004e4424
    ret 0x8                                      # 004e4425

