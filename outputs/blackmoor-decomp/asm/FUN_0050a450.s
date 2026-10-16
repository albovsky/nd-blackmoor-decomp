# FUN_0050a450
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050a450
# extent:       0x0050a450-0x0050a4dc (140 code bytes)
# span:         0x0050a450-0x0050a4e0 (code 140, tables 0, padding 4)
# sha256:       0198c92c599b16567ebe5b8c5f5cfed2a6dc144f90708313ad6148de43e2d2ea
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050a450
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1, field_minus_1; [esp + n] stk_4, stk_c, stk_10, stk_14, stk_18, stk_1c, stk_20, stk_24
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 59 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0050a4e0
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ field_1, 0x1  # offset +0x1
.equ stk_4, 0x4  # offset +0x4
.equ stk_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24

# --- external targets -----------------------------------------------

.org 0x0050a450 - 0x401000
.globl FUN_0050a450
FUN_0050a450:
    # block 0x0050a450: entry, 22 instruction(s), ends with jge to 0x0050a489 (forward)
    mov ecx, dword ptr [esp + stk_10]            # 0050a450
    mov edx, dword ptr [esp + stk_4]             # 0050a454
    push ebx                                     # 0050a458
    mov ebx, dword ptr [esp + stk_c]             # 0050a459
    push ebp                                     # 0050a45d
    mov ebp, dword ptr [esp + stk_14]            # 0050a45e
    push esi                                     # 0050a462
    {load} sub ecx, ebp                          # 0050a463
    {load} mov esi, ebx                          # 0050a465
    {load} mov eax, ecx                          # 0050a467
    {load} sub esi, edx                          # 0050a469
    push edi                                     # 0050a46b
    cdq                                          # 0050a46c
    {load} mov edi, eax                          # 0050a46d
    {load} mov eax, ecx                          # 0050a46f
    {load} xor edi, edx                          # 0050a471
    {load} sub edi, edx                          # 0050a473
    cdq                                          # 0050a475
    idiv esi                                     # 0050a476
    test ecx, ecx                                # 0050a478
    mov dword ptr [esp + stk_18], eax            # 0050a47a
    jge.d8 L_0050a489                            # 0050a47e
    # block 0x0050a480: entered by fall-through of jge at 0x0050a47e, 3 instruction(s), ends with forward jump to 0x0050a490
    lea ecx, [eax - field_minus_1]               # 0050a480
    mov dword ptr [esp + stk_20], ecx            # 0050a483
    jmp.d8 L_0050a490                            # 0050a487
L_0050a489:
    # block 0x0050a489: entered by jge at 0x0050a47e, 2 instruction(s), falls into the block at 0x0050a490
    lea edx, [eax + field_1]                     # 0050a489
    mov dword ptr [esp + stk_20], edx            # 0050a48c
L_0050a490:
    # block 0x0050a490: entered by jmp at 0x0050a487, 12 instruction(s), ends with jge to 0x0050a4d7 (forward)
    imul eax, esi                                # 0050a490
    cdq                                          # 0050a493
    mov ecx, dword ptr [esp + stk_24]            # 0050a494
    {load} xor eax, edx                          # 0050a498
    {load} sub eax, edx                          # 0050a49a
    mov dword ptr [esp + stk_1c], 0x0            # 0050a49c
    {load} sub edi, eax                          # 0050a4a4
    mov eax, dword ptr [esp + stk_14]            # 0050a4a6
    mov dword ptr [ecx + 4*eax], ebp             # 0050a4aa
    inc eax                                      # 0050a4ad
    {load} cmp eax, ebx                          # 0050a4ae
    jge.d8 L_0050a4d7                            # 0050a4b0
    # block 0x0050a4b2: entered by fall-through of jge at 0x0050a4b0, 4 instruction(s), falls into the block at 0x0050a4bf
    mov edx, dword ptr [esp + stk_20]            # 0050a4b2
    lea ecx, [ecx + 4*eax]                       # 0050a4b6
    {load} sub ebx, eax                          # 0050a4b9
    mov eax, dword ptr [esp + stk_1c]            # 0050a4bb
L_0050a4bf:
    # block 0x0050a4bf: entered by jne at 0x0050a4d5, 3 instruction(s), ends with jl to 0x0050a4cb (forward)
    {load} add eax, edi                          # 0050a4bf
    {load} cmp eax, esi                          # 0050a4c1
    jl.d8 L_0050a4cb                             # 0050a4c3
    # block 0x0050a4c5: entered by fall-through of jl at 0x0050a4c3, 3 instruction(s), ends with forward jump to 0x0050a4cf
    {load} sub eax, esi                          # 0050a4c5
    {load} add ebp, edx                          # 0050a4c7
    jmp.d8 L_0050a4cf                            # 0050a4c9
L_0050a4cb:
    # block 0x0050a4cb: entered by jl at 0x0050a4c3, 1 instruction(s), falls into the block at 0x0050a4cf
    add ebp, dword ptr [esp + stk_18]            # 0050a4cb
L_0050a4cf:
    # block 0x0050a4cf: entered by jmp at 0x0050a4c9, 4 instruction(s), ends with jne to 0x0050a4bf (backward)
    mov dword ptr [ecx], ebp                     # 0050a4cf
    add ecx, 0x4                                 # 0050a4d1
    dec ebx                                      # 0050a4d4
    jne.d8 L_0050a4bf                            # 0050a4d5
L_0050a4d7:
    # block 0x0050a4d7: entered by jge at 0x0050a4b0; fall-through of jne at 0x0050a4d5, 5 instruction(s), ends with ret
    pop edi                                      # 0050a4d7
    pop esi                                      # 0050a4d8
    pop ebp                                      # 0050a4d9
    pop ebx                                      # 0050a4da
    ret                                          # 0050a4db

# --- data items (not part of the function) -------------------------
.org 0x0050a4dc - 0x401000
PAD_0050a4dc:  # 4 byte(s) of nop padding
    .fill 4, 1, 0x90

