# FUN_0050b380
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050b380
# extent:       0x0050b380-0x0050b421 (161 code bytes)
# span:         0x0050b380-0x0050b430 (code 161, tables 0, padding 15)
# sha256:       2e02f1a5df25a09d9227a306908c378fae0e5b3c5eddd238328ede4f605ff546
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050b380
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4, field_8, field_c, field_19; [edx + n] field_16; [esi + n] field_16, field_17, field_18, field_19; [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 68 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_16, 0x16  # offset +0x16
.equ field_17, 0x17  # offset +0x17
.equ field_18, 0x18  # offset +0x18
.equ field_19, 0x19  # offset +0x19

# --- external targets -----------------------------------------------

.org 0x0050b380 - 0x401000
.globl FUN_0050b380
FUN_0050b380:
    # block 0x0050b380: entry, 4 instruction(s), ends with je to 0x0050b420 (forward)
    mov ecx, dword ptr [esp + stk_4]             # 0050b380
    {load} xor edx, edx                          # 0050b384
    {load} cmp ecx, edx                          # 0050b386
    je.d32 L_0050b420                            # 0050b388
    # block 0x0050b38e: entered by fall-through of je at 0x0050b388, 17 instruction(s), ends with jle to 0x0050b3d2 (forward)
    push ebx                                     # 0050b38e
    push ebp                                     # 0050b38f
    push esi                                     # 0050b390
    mov esi, dword ptr [ecx]                     # 0050b391
    push edi                                     # 0050b393
    {load} xor eax, eax                          # 0050b394
    mov byte ptr [esi + field_16], dl            # 0050b396
    mov esi, dword ptr [ecx]                     # 0050b399
    mov byte ptr [esi + field_17], dl            # 0050b39b
    mov esi, dword ptr [ecx]                     # 0050b39e
    mov byte ptr [esi + field_18], dl            # 0050b3a0
    mov esi, dword ptr [ecx]                     # 0050b3a3
    mov byte ptr [esi + field_19], dl            # 0050b3a5
    mov edi, dword ptr [ecx + field_4]           # 0050b3a8
    {load} xor esi, esi                          # 0050b3ab
    {load} cmp edi, edx                          # 0050b3ad
    jle.d8 L_0050b3d2                            # 0050b3af
    # block 0x0050b3b1: entered by fall-through of jle at 0x0050b3af, 1 instruction(s), falls into the block at 0x0050b3b3
    mov ebp, dword ptr [ecx]                     # 0050b3b1
L_0050b3b3:
    # block 0x0050b3b3: entered by jl at 0x0050b3ce, 11 instruction(s), ends with jl to 0x0050b3b3 (backward)
    {load} xor edx, edx                          # 0050b3b3
    {load} mov ebx, eax                          # 0050b3b5
    mov dl, byte ptr [esi + ebp]                 # 0050b3b7
    shr ebx, 0x18                                # 0050b3ba
    {load} xor edx, ebx                          # 0050b3bd
    shl eax, 0x8                                 # 0050b3bf
    mov edx, dword ptr [4*edx + 0x567374]        # 0050b3c2
    {load} xor eax, edx                          # 0050b3c9
    inc esi                                      # 0050b3cb
    {load} cmp esi, edi                          # 0050b3cc
    jl.d8 L_0050b3b3                             # 0050b3ce
    # block 0x0050b3d0: entered by fall-through of jl at 0x0050b3ce, 1 instruction(s), falls into the block at 0x0050b3d2
    {load} xor edx, edx                          # 0050b3d0
L_0050b3d2:
    # block 0x0050b3d2: entered by jle at 0x0050b3af, 4 instruction(s), ends with jle to 0x0050b3fb (forward)
    mov edi, dword ptr [ecx + field_c]           # 0050b3d2
    {load} xor esi, esi                          # 0050b3d5
    {load} cmp edi, edx                          # 0050b3d7
    jle.d8 L_0050b3fb                            # 0050b3d9
    # block 0x0050b3db: entered by fall-through of jle at 0x0050b3d9, 1 instruction(s), falls into the block at 0x0050b3de
    mov ebp, dword ptr [ecx + field_8]           # 0050b3db
L_0050b3de:
    # block 0x0050b3de: entered by jl at 0x0050b3f9, 11 instruction(s), ends with jl to 0x0050b3de (backward)
    {load} xor edx, edx                          # 0050b3de
    {load} mov ebx, eax                          # 0050b3e0
    mov dl, byte ptr [esi + ebp]                 # 0050b3e2
    shr ebx, 0x18                                # 0050b3e5
    {load} xor edx, ebx                          # 0050b3e8
    shl eax, 0x8                                 # 0050b3ea
    mov edx, dword ptr [4*edx + 0x567374]        # 0050b3ed
    {load} xor eax, edx                          # 0050b3f4
    inc esi                                      # 0050b3f6
    {load} cmp esi, edi                          # 0050b3f7
    jl.d8 L_0050b3de                             # 0050b3f9
L_0050b3fb:
    # block 0x0050b3fb: entered by jle at 0x0050b3d9; fall-through of jl at 0x0050b3f9, 17 instruction(s), falls into the block at 0x0050b420
    mov edx, dword ptr [ecx]                     # 0050b3fb
    pop edi                                      # 0050b3fd
    mov byte ptr [edx + field_16], al            # 0050b3fe
    mov esi, dword ptr [ecx]                     # 0050b401
    {load} mov edx, eax                          # 0050b403
    shr edx, 0x8                                 # 0050b405
    mov byte ptr [esi + field_17], dl            # 0050b408
    mov esi, dword ptr [ecx]                     # 0050b40b
    {load} mov edx, eax                          # 0050b40d
    shr edx, 0x10                                # 0050b40f
    mov byte ptr [esi + field_18], dl            # 0050b412
    mov ecx, dword ptr [ecx]                     # 0050b415
    shr eax, 0x18                                # 0050b417
    pop esi                                      # 0050b41a
    pop ebp                                      # 0050b41b
    mov byte ptr [ecx + field_19], al            # 0050b41c
    pop ebx                                      # 0050b41f
L_0050b420:
    # block 0x0050b420: entered by je at 0x0050b388, 1 instruction(s), ends with ret
    ret                                          # 0050b420

# --- data items (not part of the function) -------------------------
.org 0x0050b421 - 0x401000
PAD_0050b421:  # 15 byte(s) of nop padding
    .fill 15, 1, 0x90

