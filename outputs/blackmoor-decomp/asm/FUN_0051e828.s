# FUN_0051e828
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e828
# extent:       0x0051e828-0x0051e87a (82 code bytes)
# span:         0x0051e828-0x0051e87a (code 82, tables 0, padding 0)
# sha256:       44be1fba760325ea237ce81233c9aec65fe95bed7fcb586dbcbf1159d7fc88ff
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e828
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_0051faaa, KERNEL32.dll!lstrlenA, FUN_0051e627, FUN_0050fa90
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 35 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050fa90, .text + (0x0050fa90 - 0x401000)
.set FUN_0051e627, .text + (0x0051e627 - 0x401000)
.set FUN_0051faaa, .text + (0x0051faaa - 0x401000)

.org 0x0051e828 - 0x401000
.globl FUN_0051e828
FUN_0051e828:
    # block 0x0051e828: entry, 9 instruction(s), ends with je to 0x0051e872 (forward)
    mov eax, dword ptr [0x5679b0]                # 0051e828
    push ebx                                     # 0051e82d
    mov ebx, dword ptr [esp + stk_8]             # 0051e82e
    push esi                                     # 0051e832
    {load} mov esi, ecx                          # 0051e833
    push edi                                     # 0051e835
    test ebx, ebx                                # 0051e836
    mov dword ptr [esi], eax                     # 0051e838
    je.d8 L_0051e872                             # 0051e83a
    # block 0x0051e83c: entered by fall-through of je at 0x0051e83a, 4 instruction(s), ends with jne to 0x0051e851 (forward)
    {load} mov eax, ebx                          # 0051e83c
    shr eax, 0x10                                # 0051e83e
    test ax, ax                                  # 0051e841
    jne.d8 L_0051e851                            # 0051e844
    # block 0x0051e846: entered by fall-through of jne at 0x0051e844, 4 instruction(s), calls FUN_0051faaa, ends with forward jump to 0x0051e872
    movzx eax, bx                                # 0051e846
    push eax                                     # 0051e849
    call FUN_0051faaa                            # 0051e84a
    jmp.d8 L_0051e872                            # 0051e84f
L_0051e851:
    # block 0x0051e851: entered by jne at 0x0051e844, 5 instruction(s), calls KERNEL32.dll!lstrlenA, ends with je to 0x0051e872 (forward)
    push ebx                                     # 0051e851
    call dword ptr [0x52a1f8]                    # 0051e852
    {load} mov edi, eax                          # 0051e858
    test edi, edi                                # 0051e85a
    je.d8 L_0051e872                             # 0051e85c
    # block 0x0051e85e: entered by fall-through of je at 0x0051e85c, 8 instruction(s), calls FUN_0051e627, FUN_0050fa90, falls into the block at 0x0051e872
    push edi                                     # 0051e85e
    {load} mov ecx, esi                          # 0051e85f
    call FUN_0051e627                            # 0051e861
    push edi                                     # 0051e866
    push ebx                                     # 0051e867
    push dword ptr [esi]                         # 0051e868
    call FUN_0050fa90                            # 0051e86a
    add esp, 0xc                                 # 0051e86f
L_0051e872:
    # block 0x0051e872: entered by je at 0x0051e83a; jmp at 0x0051e84f; je at 0x0051e85c, 5 instruction(s), ends with ret 0x4
    {load} mov eax, esi                          # 0051e872
    pop edi                                      # 0051e874
    pop esi                                      # 0051e875
    pop ebx                                      # 0051e876
    ret 0x4                                      # 0051e877

