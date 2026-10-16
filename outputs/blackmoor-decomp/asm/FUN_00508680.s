# FUN_00508680
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00508680
# extent:       0x00508680-0x005086d8 (88 code bytes)
# span:         0x00508680-0x005086e0 (code 88, tables 0, padding 8)
# sha256:       ff7cc8be393f43d9dda138489e96a43498593bb48061c39babb41a343578a8dd
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00508450 (+0x230)
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00508680
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_10, stk_14, stk_18, stk_1c
# callees:      calls FUN_00507c30
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 43 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_00507c30, .text + (0x00507c30 - 0x401000)

.org 0x00508680 - 0x401000
.globl FUN_00508680
FUN_00508680:
    # block 0x00508680: entry, 7 instruction(s), ends with jle to 0x005086d2 (forward)
    push ebx                                     # 00508680
    push esi                                     # 00508681
    mov esi, dword ptr [esp + stk_1c]            # 00508682
    {load} xor ebx, ebx                          # 00508686
    test esi, esi                                # 00508688
    push edi                                     # 0050868a
    jle.d8 L_005086d2                            # 0050868b
    # block 0x0050868d: entered by fall-through of jle at 0x0050868b, 6 instruction(s), falls into the block at 0x0050869c
    mov edi, dword ptr [esp + stk_18]            # 0050868d
    mov edx, dword ptr [esp + stk_1c]            # 00508691
    push ebp                                     # 00508695
    {load} mov ecx, edi                          # 00508696
    {load} mov eax, edi                          # 00508698
    {load} sub edx, edi                          # 0050869a
L_0050869c:
    # block 0x0050869c: entered by jne at 0x005086ae, 2 instruction(s), ends with je to 0x005086aa (forward)
    cmp dword ptr [edx + eax], 0x0               # 0050869c
    je.d8 L_005086aa                             # 005086a0
    # block 0x005086a2: entered by fall-through of je at 0x005086a0, 4 instruction(s), falls into the block at 0x005086aa
    mov ebp, dword ptr [eax]                     # 005086a2
    inc ebx                                      # 005086a4
    mov dword ptr [ecx], ebp                     # 005086a5
    add ecx, 0x4                                 # 005086a7
L_005086aa:
    # block 0x005086aa: entered by je at 0x005086a0, 3 instruction(s), ends with jne to 0x0050869c (backward)
    add eax, 0x4                                 # 005086aa
    dec esi                                      # 005086ad
    jne.d8 L_0050869c                            # 005086ae
    # block 0x005086b0: entered by fall-through of jne at 0x005086ae, 3 instruction(s), ends with je to 0x005086d2 (forward)
    test ebx, ebx                                # 005086b0
    pop ebp                                      # 005086b2
    je.d8 L_005086d2                             # 005086b3
    # block 0x005086b5: entered by fall-through of je at 0x005086b3, 13 instruction(s), calls FUN_00507c30, ends with ret
    mov eax, dword ptr [esp + stk_14]            # 005086b5
    mov ecx, dword ptr [esp + stk_10]            # 005086b9
    push 0x5033d0                                # 005086bd
    push ebx                                     # 005086c2
    push edi                                     # 005086c3
    push eax                                     # 005086c4
    push ecx                                     # 005086c5
    call FUN_00507c30                            # 005086c6
    add esp, 0x14                                # 005086cb
    pop edi                                      # 005086ce
    pop esi                                      # 005086cf
    pop ebx                                      # 005086d0
    ret                                          # 005086d1
L_005086d2:
    # block 0x005086d2: entered by jle at 0x0050868b; je at 0x005086b3, 5 instruction(s), ends with ret
    pop edi                                      # 005086d2
    pop esi                                      # 005086d3
    {load} xor eax, eax                          # 005086d4
    pop ebx                                      # 005086d6
    ret                                          # 005086d7

# --- data items (not part of the function) -------------------------
.org 0x005086d8 - 0x401000
PAD_005086d8:  # 8 byte(s) of nop padding
    .fill 8, 1, 0x90

