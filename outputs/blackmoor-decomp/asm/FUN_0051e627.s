# FUN_0051e627
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e627
# extent:       0x0051e627-0x0051e6a9 (130 code bytes)
# span:         0x0051e627-0x0051e6a9 (code 130, tables 0, padding 0)
# sha256:       4fd2e953533efb860da40926a491ca4ef29039ec95b0491ea68a8e369c426d6f
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e627
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_8, field_c; [esi + n] field_d; [esp + n] stk_c
# callees:      calls FUN_0050c575, FUN_0051dc43
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 47 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_d, 0xd  # offset +0xd

# --- external targets -----------------------------------------------
.set FUN_0050c575, .text + (0x0050c575 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x0051e627 - 0x401000
.globl FUN_0051e627
FUN_0051e627:
    # block 0x0051e627: entry, 6 instruction(s), ends with jne to 0x0051e63c (forward)
    push ebx                                     # 0051e627
    push esi                                     # 0051e628
    mov esi, dword ptr [esp + stk_c]             # 0051e629
    {load} mov ebx, ecx                          # 0051e62d
    test esi, esi                                # 0051e62f
    jne.d8 L_0051e63c                            # 0051e631
    # block 0x0051e633: entered by fall-through of jne at 0x0051e631, 3 instruction(s), ends with forward jump to 0x0051e6a4
    mov eax, dword ptr [0x5679b0]                # 0051e633
    mov dword ptr [ebx], eax                     # 0051e638
    jmp.d8 L_0051e6a4                            # 0051e63a
L_0051e63c:
    # block 0x0051e63c: entered by jne at 0x0051e631, 5 instruction(s), ends with jg to 0x0051e653 (forward)
    push edi                                     # 0051e63c
    push 0x40                                    # 0051e63d
    pop edi                                      # 0051e63f
    {load} cmp esi, edi                          # 0051e640
    jg.d8 L_0051e653                             # 0051e642
    # block 0x0051e644: entered by fall-through of jg at 0x0051e642, 1 instruction(s), falls into the block at 0x0051e649
    mov ecx, 0x63c3f0                            # 0051e644
L_0051e649:
    # block 0x0051e649: entered by jmp at 0x0051e661; jmp at 0x0051e671; jmp at 0x0051e681, 3 instruction(s), calls FUN_0050c575, ends with forward jump to 0x0051e690
    call FUN_0050c575                            # 0051e649
    mov dword ptr [eax + field_8], edi           # 0051e64e
    jmp.d8 L_0051e690                            # 0051e651
L_0051e653:
    # block 0x0051e653: entered by jg at 0x0051e642, 3 instruction(s), ends with jg to 0x0051e663 (forward)
    mov edi, 0x80                                # 0051e653
    {load} cmp esi, edi                          # 0051e658
    jg.d8 L_0051e663                             # 0051e65a
    # block 0x0051e65c: entered by fall-through of jg at 0x0051e65a, 2 instruction(s), ends with backward jump to 0x0051e649
    mov ecx, 0x63c3c8                            # 0051e65c
    jmp.d8 L_0051e649                            # 0051e661
L_0051e663:
    # block 0x0051e663: entered by jg at 0x0051e65a, 3 instruction(s), ends with jg to 0x0051e673 (forward)
    mov edi, 0x100                               # 0051e663
    {load} cmp esi, edi                          # 0051e668
    jg.d8 L_0051e673                             # 0051e66a
    # block 0x0051e66c: entered by fall-through of jg at 0x0051e66a, 2 instruction(s), ends with backward jump to 0x0051e649
    mov ecx, 0x63c3a0                            # 0051e66c
    jmp.d8 L_0051e649                            # 0051e671
L_0051e673:
    # block 0x0051e673: entered by jg at 0x0051e66a, 3 instruction(s), ends with jg to 0x0051e683 (forward)
    mov edi, 0x200                               # 0051e673
    {load} cmp esi, edi                          # 0051e678
    jg.d8 L_0051e683                             # 0051e67a
    # block 0x0051e67c: entered by fall-through of jg at 0x0051e67a, 2 instruction(s), ends with backward jump to 0x0051e649
    mov ecx, 0x63c378                            # 0051e67c
    jmp.d8 L_0051e649                            # 0051e681
L_0051e683:
    # block 0x0051e683: entered by jg at 0x0051e67a, 5 instruction(s), calls FUN_0051dc43, falls into the block at 0x0051e690
    lea eax, [esi + field_d]                     # 0051e683
    push eax                                     # 0051e686
    call FUN_0051dc43                            # 0051e687
    pop ecx                                      # 0051e68c
    mov dword ptr [eax + field_8], esi           # 0051e68d
L_0051e690:
    # block 0x0051e690: entered by jmp at 0x0051e651, 6 instruction(s), falls into the block at 0x0051e6a4
    mov dword ptr [eax], 0x1                     # 0051e690
    and byte ptr [eax + esi + field_c], 0x0      # 0051e696
    mov dword ptr [eax + field_4], esi           # 0051e69b
    add eax, 0xc                                 # 0051e69e
    mov dword ptr [ebx], eax                     # 0051e6a1
    pop edi                                      # 0051e6a3
L_0051e6a4:
    # block 0x0051e6a4: entered by jmp at 0x0051e63a, 3 instruction(s), ends with ret 0x4
    pop esi                                      # 0051e6a4
    pop ebx                                      # 0051e6a5
    ret 0x4                                      # 0051e6a6

