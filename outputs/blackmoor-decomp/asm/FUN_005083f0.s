# FUN_005083f0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005083f0
# extent:       0x005083f0-0x00508443 (83 code bytes)
# span:         0x005083f0-0x00508450 (code 83, tables 0, padding 13)
# sha256:       9338006f9dc926e05f99ca63bd7da8671e799b1ca312bcd44b865418d33f428e
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00508180 (+0x270)
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005083f0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_10, stk_14, stk_18, stk_1c
# callees:      calls FUN_00508450
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 42 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_00508450, .text + (0x00508450 - 0x401000)

.org 0x005083f0 - 0x401000
.globl FUN_005083f0
FUN_005083f0:
    # block 0x005083f0: entry, 7 instruction(s), ends with jle to 0x0050843d (forward)
    push ebx                                     # 005083f0
    push esi                                     # 005083f1
    mov esi, dword ptr [esp + stk_1c]            # 005083f2
    {load} xor ebx, ebx                          # 005083f6
    test esi, esi                                # 005083f8
    push edi                                     # 005083fa
    jle.d8 L_0050843d                            # 005083fb
    # block 0x005083fd: entered by fall-through of jle at 0x005083fb, 6 instruction(s), falls into the block at 0x0050840c
    mov edi, dword ptr [esp + stk_18]            # 005083fd
    mov edx, dword ptr [esp + stk_1c]            # 00508401
    push ebp                                     # 00508405
    {load} mov ecx, edi                          # 00508406
    {load} mov eax, edi                          # 00508408
    {load} sub edx, edi                          # 0050840a
L_0050840c:
    # block 0x0050840c: entered by jne at 0x0050841e, 2 instruction(s), ends with je to 0x0050841a (forward)
    cmp dword ptr [edx + eax], 0x0               # 0050840c
    je.d8 L_0050841a                             # 00508410
    # block 0x00508412: entered by fall-through of je at 0x00508410, 4 instruction(s), falls into the block at 0x0050841a
    mov ebp, dword ptr [eax]                     # 00508412
    inc ebx                                      # 00508414
    mov dword ptr [ecx], ebp                     # 00508415
    add ecx, 0x4                                 # 00508417
L_0050841a:
    # block 0x0050841a: entered by je at 0x00508410, 3 instruction(s), ends with jne to 0x0050840c (backward)
    add eax, 0x4                                 # 0050841a
    dec esi                                      # 0050841d
    jne.d8 L_0050840c                            # 0050841e
    # block 0x00508420: entered by fall-through of jne at 0x0050841e, 3 instruction(s), ends with je to 0x0050843d (forward)
    test ebx, ebx                                # 00508420
    pop ebp                                      # 00508422
    je.d8 L_0050843d                             # 00508423
    # block 0x00508425: entered by fall-through of je at 0x00508423, 12 instruction(s), calls FUN_00508450, ends with ret
    mov eax, dword ptr [esp + stk_14]            # 00508425
    mov ecx, dword ptr [esp + stk_10]            # 00508429
    push ebx                                     # 0050842d
    push edi                                     # 0050842e
    push eax                                     # 0050842f
    push ecx                                     # 00508430
    call FUN_00508450                            # 00508431
    add esp, 0x10                                # 00508436
    pop edi                                      # 00508439
    pop esi                                      # 0050843a
    pop ebx                                      # 0050843b
    ret                                          # 0050843c
L_0050843d:
    # block 0x0050843d: entered by jle at 0x005083fb; je at 0x00508423, 5 instruction(s), ends with ret
    pop edi                                      # 0050843d
    pop esi                                      # 0050843e
    {load} xor eax, eax                          # 0050843f
    pop ebx                                      # 00508441
    ret                                          # 00508442

# --- data items (not part of the function) -------------------------
.org 0x00508443 - 0x401000
PAD_00508443:  # 13 byte(s) of nop padding
    .fill 13, 1, 0x90

