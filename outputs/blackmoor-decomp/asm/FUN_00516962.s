# FUN_00516962
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00516962
# extent:       0x00516962-0x005169eb (137 code bytes)
# span:         0x00516962-0x005169eb (code 137, tables 0, padding 0)
# sha256:       f7b93698cb00bf421cb8e5906d7d4e6948e8b0cecf3b662de09ec85edb65dc49
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00516962
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 53 instruction(s), 13 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x00516962 - 0x401000
.globl FUN_00516962
FUN_00516962:
    # block 0x00516962: entry, 6 instruction(s), ends with je to 0x00516972 (forward)
    push ebx                                     # 00516962
    mov ebx, dword ptr [esp + stk_8]             # 00516963
    {load} xor eax, eax                          # 00516967
    push esi                                     # 00516969
    test bl, 0x10                                # 0051696a
    je.d8 L_00516972                             # 0051696d
    # block 0x0051696f: entered by fall-through of je at 0x0051696d, 2 instruction(s), falls into the block at 0x00516972
    push 0x1                                     # 0051696f
    pop eax                                      # 00516971
L_00516972:
    # block 0x00516972: entered by je at 0x0051696d, 2 instruction(s), ends with je to 0x00516979 (forward)
    test bl, 0x8                                 # 00516972
    je.d8 L_00516979                             # 00516975
    # block 0x00516977: entered by fall-through of je at 0x00516975, 1 instruction(s), falls into the block at 0x00516979
    or al, 0x4                                   # 00516977
L_00516979:
    # block 0x00516979: entered by je at 0x00516975, 2 instruction(s), ends with je to 0x00516980 (forward)
    test bl, 0x4                                 # 00516979
    je.d8 L_00516980                             # 0051697c
    # block 0x0051697e: entered by fall-through of je at 0x0051697c, 1 instruction(s), falls into the block at 0x00516980
    or al, 0x8                                   # 0051697e
L_00516980:
    # block 0x00516980: entered by je at 0x0051697c, 2 instruction(s), ends with je to 0x00516987 (forward)
    test bl, 0x2                                 # 00516980
    je.d8 L_00516987                             # 00516983
    # block 0x00516985: entered by fall-through of je at 0x00516983, 1 instruction(s), falls into the block at 0x00516987
    or al, 0x10                                  # 00516985
L_00516987:
    # block 0x00516987: entered by je at 0x00516983, 2 instruction(s), ends with je to 0x0051698e (forward)
    test bl, 0x1                                 # 00516987
    je.d8 L_0051698e                             # 0051698a
    # block 0x0051698c: entered by fall-through of je at 0x0051698a, 1 instruction(s), falls into the block at 0x0051698e
    or al, 0x20                                  # 0051698c
L_0051698e:
    # block 0x0051698e: entered by je at 0x0051698a, 2 instruction(s), ends with je to 0x00516998 (forward)
    test ebx, 0x80000                            # 0051698e
    je.d8 L_00516998                             # 00516994
    # block 0x00516996: entered by fall-through of je at 0x00516994, 1 instruction(s), falls into the block at 0x00516998
    or al, 0x2                                   # 00516996
L_00516998:
    # block 0x00516998: entered by je at 0x00516994, 5 instruction(s), ends with je to 0x005169c5 (forward)
    {load} mov ecx, ebx                          # 00516998
    mov edx, 0x300                               # 0051699a
    {load} and ecx, edx                          # 0051699f
    mov esi, 0x200                               # 005169a1
    je.d8 L_005169c5                             # 005169a6
    # block 0x005169a8: entered by fall-through of je at 0x005169a6, 2 instruction(s), ends with je to 0x005169c2 (forward)
    cmp ecx, 0x100                               # 005169a8
    je.d8 L_005169c2                             # 005169ae
    # block 0x005169b0: entered by fall-through of je at 0x005169ae, 2 instruction(s), ends with je to 0x005169bd (forward)
    {load} cmp ecx, esi                          # 005169b0
    je.d8 L_005169bd                             # 005169b2
    # block 0x005169b4: entered by fall-through of je at 0x005169b2, 2 instruction(s), ends with jne to 0x005169c5 (forward)
    {load} cmp ecx, edx                          # 005169b4
    jne.d8 L_005169c5                            # 005169b6
    # block 0x005169b8: entered by fall-through of jne at 0x005169b6, 2 instruction(s), ends with forward jump to 0x005169c5
    or ah, 0xc                                   # 005169b8
    jmp.d8 L_005169c5                            # 005169bb
L_005169bd:
    # block 0x005169bd: entered by je at 0x005169b2, 2 instruction(s), ends with forward jump to 0x005169c5
    or ah, 0x8                                   # 005169bd
    jmp.d8 L_005169c5                            # 005169c0
L_005169c2:
    # block 0x005169c2: entered by je at 0x005169ae, 1 instruction(s), falls into the block at 0x005169c5
    or ah, 0x4                                   # 005169c2
L_005169c5:
    # block 0x005169c5: entered by je at 0x005169a6; jne at 0x005169b6; jmp at 0x005169bb; jmp at 0x005169c0, 3 instruction(s), ends with je to 0x005169db (forward)
    {load} mov ecx, ebx                          # 005169c5
    and ecx, 0x30000                             # 005169c7
    je.d8 L_005169db                             # 005169cd
    # block 0x005169cf: entered by fall-through of je at 0x005169cd, 2 instruction(s), ends with jne to 0x005169dd (forward)
    cmp ecx, 0x10000                             # 005169cf
    jne.d8 L_005169dd                            # 005169d5
    # block 0x005169d7: entered by fall-through of jne at 0x005169d5, 2 instruction(s), ends with forward jump to 0x005169dd
    {load} or eax, esi                           # 005169d7
    jmp.d8 L_005169dd                            # 005169d9
L_005169db:
    # block 0x005169db: entered by je at 0x005169cd, 1 instruction(s), falls into the block at 0x005169dd
    {load} or eax, edx                           # 005169db
L_005169dd:
    # block 0x005169dd: entered by jne at 0x005169d5; jmp at 0x005169d9, 4 instruction(s), ends with je to 0x005169ea (forward)
    pop esi                                      # 005169dd
    test ebx, 0x40000                            # 005169de
    pop ebx                                      # 005169e4
    je.d8 L_005169ea                             # 005169e5
    # block 0x005169e7: entered by fall-through of je at 0x005169e5, 1 instruction(s), falls into the block at 0x005169ea
    or ah, 0x10                                  # 005169e7
L_005169ea:
    # block 0x005169ea: entered by je at 0x005169e5, 1 instruction(s), ends with ret
    ret                                          # 005169ea

