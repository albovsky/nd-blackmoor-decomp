# FUN_0051a643
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a643
# extent:       0x0051a643-0x0051a6b5 (114 code bytes)
# span:         0x0051a643-0x0051a6b5 (code 114, tables 0, padding 0)
# sha256:       f7b7bf1d0f548e80fd18cc50522fa54a2407249041fde37f5e9de7eac7dd40eb
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a643
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0xc (callee pops 12 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4, field_8; [esi + n] field_4, field_8; [esp + n] stk_4, stk_c, stk_10, stk_14
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 51 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0051a6b5
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------

.org 0x0051a643 - 0x401000
.globl FUN_0051a643
FUN_0051a643:
    # block 0x0051a643: entry, 6 instruction(s), ends with jne to 0x0051a66a (forward)
    mov eax, dword ptr [esp + stk_4]             # 0051a643
    push esi                                     # 0051a647
    push edi                                     # 0051a648
    mov esi, dword ptr [eax]                     # 0051a649
    cmp esi, -0x1                                # 0051a64b
    jne.d8 L_0051a66a                            # 0051a64e
    # block 0x0051a650: entered by fall-through of jne at 0x0051a64e, 4 instruction(s), ends with jbe to 0x0051a66a (forward)
    mov edx, dword ptr [ecx + field_8]           # 0051a650
    {load} xor edi, edi                          # 0051a653
    test edx, edx                                # 0051a655
    jbe.d8 L_0051a66a                            # 0051a657
    # block 0x0051a659: entered by fall-through of jbe at 0x0051a657, 1 instruction(s), falls into the block at 0x0051a65c
    mov eax, dword ptr [ecx + field_4]           # 0051a659
L_0051a65c:
    # block 0x0051a65c: entered by jb at 0x0051a668, 3 instruction(s), ends with jne to 0x0051a66a (forward)
    mov esi, dword ptr [eax]                     # 0051a65c
    test esi, esi                                # 0051a65e
    jne.d8 L_0051a66a                            # 0051a660
    # block 0x0051a662: entered by fall-through of jne at 0x0051a660, 4 instruction(s), ends with jb to 0x0051a65c (backward)
    inc edi                                      # 0051a662
    add eax, 0x4                                 # 0051a663
    {load} cmp edi, edx                          # 0051a666
    jb.d8 L_0051a65c                             # 0051a668
L_0051a66a:
    # block 0x0051a66a: entered by jne at 0x0051a64e; jbe at 0x0051a657; jne at 0x0051a660; fall-through of jb at 0x0051a668, 3 instruction(s), ends with jne to 0x0051a698 (forward)
    mov edi, dword ptr [esi]                     # 0051a66a
    test edi, edi                                # 0051a66c
    jne.d8 L_0051a698                            # 0051a66e
    # block 0x0051a670: entered by fall-through of jne at 0x0051a66e, 9 instruction(s), ends with jae to 0x0051a697 (forward)
    mov eax, dword ptr [esi + field_4]           # 0051a670
    push ebx                                     # 0051a673
    mov ebx, dword ptr [ecx + field_8]           # 0051a674
    {load} xor edx, edx                          # 0051a677
    shr eax, 0x4                                 # 0051a679
    div ebx                                      # 0051a67c
    inc edx                                      # 0051a67e
    {load} cmp edx, ebx                          # 0051a67f
    jae.d8 L_0051a697                            # 0051a681
    # block 0x0051a683: entered by fall-through of jae at 0x0051a681, 2 instruction(s), falls into the block at 0x0051a689
    mov eax, dword ptr [ecx + field_4]           # 0051a683
    lea eax, [eax + 4*edx]                       # 0051a686
L_0051a689:
    # block 0x0051a689: entered by jb at 0x0051a695, 3 instruction(s), ends with jne to 0x0051a697 (forward)
    mov edi, dword ptr [eax]                     # 0051a689
    test edi, edi                                # 0051a68b
    jne.d8 L_0051a697                            # 0051a68d
    # block 0x0051a68f: entered by fall-through of jne at 0x0051a68d, 4 instruction(s), ends with jb to 0x0051a689 (backward)
    inc edx                                      # 0051a68f
    add eax, 0x4                                 # 0051a690
    {load} cmp edx, ebx                          # 0051a693
    jb.d8 L_0051a689                             # 0051a695
L_0051a697:
    # block 0x0051a697: entered by jae at 0x0051a681; jne at 0x0051a68d; fall-through of jb at 0x0051a695, 1 instruction(s), falls into the block at 0x0051a698
    pop ebx                                      # 0051a697
L_0051a698:
    # block 0x0051a698: entered by jne at 0x0051a66e, 11 instruction(s), ends with ret 0xc
    mov eax, dword ptr [esp + stk_c]             # 0051a698
    mov ecx, dword ptr [esp + stk_10]            # 0051a69c
    mov dword ptr [eax], edi                     # 0051a6a0
    mov eax, dword ptr [esi + field_4]           # 0051a6a2
    mov dword ptr [ecx], eax                     # 0051a6a5
    mov ecx, dword ptr [esp + stk_14]            # 0051a6a7
    mov eax, dword ptr [esi + field_8]           # 0051a6ab
    pop edi                                      # 0051a6ae
    mov dword ptr [ecx], eax                     # 0051a6af
    pop esi                                      # 0051a6b1
    ret 0xc                                      # 0051a6b2

