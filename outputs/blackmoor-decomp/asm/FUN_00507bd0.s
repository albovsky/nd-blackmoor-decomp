# FUN_00507bd0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00507bd0
# extent:       0x00507bd0-0x00507c28 (88 code bytes)
# span:         0x00507bd0-0x00507c30 (code 88, tables 0, padding 8)
# sha256:       d6035951515a53ee4fb15a22f8d351796a58aacd9b5480d397a1f998ed96e518
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00507890 (+0x340)
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00507bd0
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

.org 0x00507bd0 - 0x401000
.globl FUN_00507bd0
FUN_00507bd0:
    # block 0x00507bd0: entry, 7 instruction(s), ends with jle to 0x00507c22 (forward)
    push ebx                                     # 00507bd0
    push esi                                     # 00507bd1
    mov esi, dword ptr [esp + stk_1c]            # 00507bd2
    {load} xor ebx, ebx                          # 00507bd6
    test esi, esi                                # 00507bd8
    push edi                                     # 00507bda
    jle.d8 L_00507c22                            # 00507bdb
    # block 0x00507bdd: entered by fall-through of jle at 0x00507bdb, 6 instruction(s), falls into the block at 0x00507bec
    mov edi, dword ptr [esp + stk_18]            # 00507bdd
    mov edx, dword ptr [esp + stk_1c]            # 00507be1
    push ebp                                     # 00507be5
    {load} mov ecx, edi                          # 00507be6
    {load} mov eax, edi                          # 00507be8
    {load} sub edx, edi                          # 00507bea
L_00507bec:
    # block 0x00507bec: entered by jne at 0x00507bfe, 2 instruction(s), ends with je to 0x00507bfa (forward)
    cmp dword ptr [edx + eax], 0x0               # 00507bec
    je.d8 L_00507bfa                             # 00507bf0
    # block 0x00507bf2: entered by fall-through of je at 0x00507bf0, 4 instruction(s), falls into the block at 0x00507bfa
    mov ebp, dword ptr [eax]                     # 00507bf2
    inc ebx                                      # 00507bf4
    mov dword ptr [ecx], ebp                     # 00507bf5
    add ecx, 0x4                                 # 00507bf7
L_00507bfa:
    # block 0x00507bfa: entered by je at 0x00507bf0, 3 instruction(s), ends with jne to 0x00507bec (backward)
    add eax, 0x4                                 # 00507bfa
    dec esi                                      # 00507bfd
    jne.d8 L_00507bec                            # 00507bfe
    # block 0x00507c00: entered by fall-through of jne at 0x00507bfe, 3 instruction(s), ends with je to 0x00507c22 (forward)
    test ebx, ebx                                # 00507c00
    pop ebp                                      # 00507c02
    je.d8 L_00507c22                             # 00507c03
    # block 0x00507c05: entered by fall-through of je at 0x00507c03, 13 instruction(s), calls FUN_00507c30, ends with ret
    mov eax, dword ptr [esp + stk_14]            # 00507c05
    mov ecx, dword ptr [esp + stk_10]            # 00507c09
    push 0x5031d0                                # 00507c0d
    push ebx                                     # 00507c12
    push edi                                     # 00507c13
    push eax                                     # 00507c14
    push ecx                                     # 00507c15
    call FUN_00507c30                            # 00507c16
    add esp, 0x14                                # 00507c1b
    pop edi                                      # 00507c1e
    pop esi                                      # 00507c1f
    pop ebx                                      # 00507c20
    ret                                          # 00507c21
L_00507c22:
    # block 0x00507c22: entered by jle at 0x00507bdb; je at 0x00507c03, 5 instruction(s), ends with ret
    pop edi                                      # 00507c22
    pop esi                                      # 00507c23
    {load} xor eax, eax                          # 00507c24
    pop ebx                                      # 00507c26
    ret                                          # 00507c27

# --- data items (not part of the function) -------------------------
.org 0x00507c28 - 0x401000
PAD_00507c28:  # 8 byte(s) of nop padding
    .fill 8, 1, 0x90

