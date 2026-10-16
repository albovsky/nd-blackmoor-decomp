# FUN_0050f9e0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050f9e0
# extent:       0x0050f9e0-0x0050fa8c (172 code bytes)
# span:         0x0050f9e0-0x0050fa90 (code 172, tables 0, padding 4)
# sha256:       7d1229e9a0b0bc4d2d1aefa645125a8758caefe3d483fb80a2a4b04f6e2e314e
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050f9e0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edi + n] field_1, field_minus_4; [esi + n] field_1, field_minus_4; [esp + n] stk_4, stk_c, stk_10
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 78 instruction(s), 19 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_1, 0x1  # offset +0x1
.equ stk_4, 0x4  # offset +0x4
.equ stk_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------

.org 0x0050f9e0 - 0x401000
.globl FUN_0050f9e0
FUN_0050f9e0:
    # block 0x0050f9e0: entry, 3 instruction(s), ends with je to 0x0050fa2c (forward)
    mov eax, dword ptr [esp + stk_c]             # 0050f9e0
    test eax, eax                                # 0050f9e4
    je.d8 L_0050fa2c                             # 0050f9e6
    # block 0x0050f9e8: entered by fall-through of je at 0x0050f9e6, 8 instruction(s), ends with je to 0x0050fa2d (forward)
    mov edx, dword ptr [esp + stk_4]             # 0050f9e8
    push esi                                     # 0050f9ec
    push edi                                     # 0050f9ed
    {load} mov esi, edx                          # 0050f9ee
    mov edi, dword ptr [esp + stk_10]            # 0050f9f0
    {load} or edx, edi                           # 0050f9f4
    and edx, 0x3                                 # 0050f9f6
    je.d8 L_0050fa2d                             # 0050f9f9
    # block 0x0050f9fb: entered by fall-through of je at 0x0050f9f9, 2 instruction(s), ends with je to 0x0050fa0d (forward)
    test eax, 0x1                                # 0050f9fb
    je.d8 L_0050fa0d                             # 0050fa00
    # block 0x0050fa02: entered by fall-through of je at 0x0050fa00, 3 instruction(s), ends with jne to 0x0050fa5a (forward)
    mov cl, byte ptr [esi]                       # 0050fa02
    cmp cl, byte ptr [edi]                       # 0050fa04
    jne.d8 L_0050fa5a                            # 0050fa06
    # block 0x0050fa08: entered by fall-through of jne at 0x0050fa06, 4 instruction(s), ends with je to 0x0050fa2a (forward)
    inc esi                                      # 0050fa08
    inc edi                                      # 0050fa09
    dec eax                                      # 0050fa0a
    je.d8 L_0050fa2a                             # 0050fa0b
L_0050fa0d:
    # block 0x0050fa0d: entered by je at 0x0050fa00; jne at 0x0050fa28; fall-through of je at 0x0050fa0b, 4 instruction(s), ends with jne to 0x0050fa5a (forward)
    mov cl, byte ptr [esi]                       # 0050fa0d
    mov dl, byte ptr [edi]                       # 0050fa0f
    {store} cmp cl, dl                           # 0050fa11
    jne.d8 L_0050fa5a                            # 0050fa13
    # block 0x0050fa15: entered by fall-through of jne at 0x0050fa13, 4 instruction(s), ends with jne to 0x0050fa5a (forward)
    mov cl, byte ptr [esi + field_1]             # 0050fa15
    mov dl, byte ptr [edi + field_1]             # 0050fa18
    {store} cmp cl, dl                           # 0050fa1b
    jne.d8 L_0050fa5a                            # 0050fa1d
    # block 0x0050fa1f: entered by fall-through of jne at 0x0050fa1d, 4 instruction(s), ends with jne to 0x0050fa0d (backward)
    add edi, 0x2                                 # 0050fa1f
    add esi, 0x2                                 # 0050fa22
    sub eax, 0x2                                 # 0050fa25
    jne.d8 L_0050fa0d                            # 0050fa28
L_0050fa2a:
    # block 0x0050fa2a: entered by je at 0x0050fa0b; je at 0x0050fa64; fall-through of jne at 0x0050fa28, 2 instruction(s), falls into the block at 0x0050fa2c
    pop edi                                      # 0050fa2a
    pop esi                                      # 0050fa2b
L_0050fa2c:
    # block 0x0050fa2c: entered by je at 0x0050f9e6, 1 instruction(s), ends with ret
    ret                                          # 0050fa2c
L_0050fa2d:
    # block 0x0050fa2d: entered by je at 0x0050f9f9, 4 instruction(s), ends with je to 0x0050fa62 (forward)
    {load} mov ecx, eax                          # 0050fa2d
    and eax, 0x3                                 # 0050fa2f
    shr ecx, 0x2                                 # 0050fa32
    je.d8 L_0050fa62                             # 0050fa35
    # block 0x0050fa37: entered by fall-through of je at 0x0050fa35, 2 instruction(s), ends with je to 0x0050fa62 (forward)
    rep cmpsd dword ptr [esi], dword ptr es:[edi] # 0050fa37
    je.d8 L_0050fa62                             # 0050fa39
    # block 0x0050fa3b: entered by fall-through of je at 0x0050fa39, 4 instruction(s), ends with jne to 0x0050fa55 (forward)
    mov ecx, dword ptr [esi - field_minus_4]     # 0050fa3b
    mov edx, dword ptr [edi - field_minus_4]     # 0050fa3e
    {store} cmp cl, dl                           # 0050fa41
    jne.d8 L_0050fa55                            # 0050fa43
    # block 0x0050fa45: entered by fall-through of jne at 0x0050fa43, 2 instruction(s), ends with jne to 0x0050fa55 (forward)
    {store} cmp ch, dh                           # 0050fa45
    jne.d8 L_0050fa55                            # 0050fa47
    # block 0x0050fa49: entered by fall-through of jne at 0x0050fa47, 4 instruction(s), ends with jne to 0x0050fa55 (forward)
    shr ecx, 0x10                                # 0050fa49
    shr edx, 0x10                                # 0050fa4c
    {store} cmp cl, dl                           # 0050fa4f
    jne.d8 L_0050fa55                            # 0050fa51
    # block 0x0050fa53: entered by fall-through of jne at 0x0050fa51, 1 instruction(s), falls into the block at 0x0050fa55
    {store} cmp ch, dh                           # 0050fa53
L_0050fa55:
    # block 0x0050fa55: entered by jne at 0x0050fa43; jne at 0x0050fa47; jne at 0x0050fa51; jne at 0x0050fa6c; more, 1 instruction(s), falls into the block at 0x0050fa5a
    mov eax, 0x0                                 # 0050fa55
L_0050fa5a:
    # block 0x0050fa5a: entered by jne at 0x0050fa06; jne at 0x0050fa13; jne at 0x0050fa1d, 5 instruction(s), ends with ret
    {load} sbb eax, eax                          # 0050fa5a
    pop edi                                      # 0050fa5c
    sbb eax, -0x1                                # 0050fa5d
    pop esi                                      # 0050fa60
    ret                                          # 0050fa61
L_0050fa62:
    # block 0x0050fa62: entered by je at 0x0050fa35; je at 0x0050fa39, 2 instruction(s), ends with je to 0x0050fa2a (backward)
    test eax, eax                                # 0050fa62
    je.d8 L_0050fa2a                             # 0050fa64
    # block 0x0050fa66: entered by fall-through of je at 0x0050fa64, 4 instruction(s), ends with jne to 0x0050fa55 (backward)
    mov edx, dword ptr [esi]                     # 0050fa66
    mov ecx, dword ptr [edi]                     # 0050fa68
    {store} cmp dl, cl                           # 0050fa6a
    jne.d8 L_0050fa55                            # 0050fa6c
    # block 0x0050fa6e: entered by fall-through of jne at 0x0050fa6c, 2 instruction(s), ends with je to 0x0050fa89 (forward)
    dec eax                                      # 0050fa6e
    je.d8 L_0050fa89                             # 0050fa6f
    # block 0x0050fa71: entered by fall-through of je at 0x0050fa6f, 2 instruction(s), ends with jne to 0x0050fa55 (backward)
    {store} cmp dh, ch                           # 0050fa71
    jne.d8 L_0050fa55                            # 0050fa73
    # block 0x0050fa75: entered by fall-through of jne at 0x0050fa73, 2 instruction(s), ends with je to 0x0050fa89 (forward)
    dec eax                                      # 0050fa75
    je.d8 L_0050fa89                             # 0050fa76
    # block 0x0050fa78: entered by fall-through of je at 0x0050fa76, 4 instruction(s), ends with jne to 0x0050fa55 (backward)
    and ecx, 0xff0000                            # 0050fa78
    and edx, 0xff0000                            # 0050fa7e
    {load} cmp edx, ecx                          # 0050fa84
    jne.d8 L_0050fa55                            # 0050fa86
    # block 0x0050fa88: entered by fall-through of jne at 0x0050fa86, 1 instruction(s), falls into the block at 0x0050fa89
    dec eax                                      # 0050fa88
L_0050fa89:
    # block 0x0050fa89: entered by je at 0x0050fa6f; je at 0x0050fa76, 3 instruction(s), ends with ret
    pop edi                                      # 0050fa89
    pop esi                                      # 0050fa8a
    ret                                          # 0050fa8b

# --- data items (not part of the function) -------------------------
.org 0x0050fa8c - 0x401000
PAD_0050fa8c:  # 4 byte(s) of int3 padding
    .fill 4, 1, 0xcc

