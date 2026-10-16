# FUN_00519492
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00519492
# extent:       0x00519492-0x00519500 (110 code bytes)
# span:         0x00519492-0x00519500 (code 110, tables 0, padding 0)
# sha256:       372c0e26483ab71e89c5ef4105c8544b6b17ccf90461750f06882de577566f90
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00519492
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_4; [esp + n] stk_10, stk_14
# callees:      calls FUN_0050ea90, FUN_005197de; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 58 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)
.set FUN_005197de, .text + (0x005197de - 0x401000)

.org 0x00519492 - 0x401000
.globl FUN_00519492
FUN_00519492:
    # block 0x00519492: entry, 10 instruction(s), ends with je to 0x005194f3 (forward)
    push ecx                                     # 00519492
    push ebx                                     # 00519493
    push ebp                                     # 00519494
    push esi                                     # 00519495
    mov esi, dword ptr [0x63ca34]                # 00519496
    push edi                                     # 0051949c
    {load} xor edi, edi                          # 0051949d
    mov eax, dword ptr [esi]                     # 0051949f
    {load} cmp eax, edi                          # 005194a1
    je.d8 L_005194f3                             # 005194a3
    # block 0x005194a5: entered by fall-through of je at 0x005194a3, 1 instruction(s), falls into the block at 0x005194ab
    mov ebx, dword ptr [0x52a1f4]                # 005194a5
L_005194ab:
    # block 0x005194ab: entered by jne at 0x005194f1, 12 instruction(s), calls indirect ebx, ends with je to 0x005194fb (forward)
    push edi                                     # 005194ab
    push edi                                     # 005194ac
    push edi                                     # 005194ad
    push edi                                     # 005194ae
    push -0x1                                    # 005194af
    push eax                                     # 005194b1
    push edi                                     # 005194b2
    push 0x1                                     # 005194b3
    call ebx                                     # 005194b5
    {load} mov ebp, eax                          # 005194b7
    {load} cmp ebp, edi                          # 005194b9
    je.d8 L_005194fb                             # 005194bb
    # block 0x005194bd: entered by fall-through of je at 0x005194bb, 6 instruction(s), calls FUN_0050ea90, ends with je to 0x005194fb (forward)
    push ebp                                     # 005194bd
    call FUN_0050ea90                            # 005194be
    {load} cmp eax, edi                          # 005194c3
    pop ecx                                      # 005194c5
    mov dword ptr [esp + stk_10], eax            # 005194c6
    je.d8 L_005194fb                             # 005194ca
    # block 0x005194cc: entered by fall-through of je at 0x005194ca, 11 instruction(s), calls indirect ebx, ends with je to 0x005194fb (forward)
    push edi                                     # 005194cc
    push edi                                     # 005194cd
    push ebp                                     # 005194ce
    push eax                                     # 005194cf
    push -0x1                                    # 005194d0
    push dword ptr [esi]                         # 005194d2
    push edi                                     # 005194d4
    push 0x1                                     # 005194d5
    call ebx                                     # 005194d7
    test eax, eax                                # 005194d9
    je.d8 L_005194fb                             # 005194db
    # block 0x005194dd: entered by fall-through of je at 0x005194db, 9 instruction(s), calls FUN_005197de, ends with jne to 0x005194ab (backward)
    push edi                                     # 005194dd
    push dword ptr [esp + stk_14]                # 005194de
    call FUN_005197de                            # 005194e2
    mov eax, dword ptr [esi + field_4]           # 005194e7
    add esi, 0x4                                 # 005194ea
    pop ecx                                      # 005194ed
    {load} cmp eax, edi                          # 005194ee
    pop ecx                                      # 005194f0
    jne.d8 L_005194ab                            # 005194f1
L_005194f3:
    # block 0x005194f3: entered by je at 0x005194a3; fall-through of jne at 0x005194f1, 1 instruction(s), falls into the block at 0x005194f5
    {load} xor eax, eax                          # 005194f3
L_005194f5:
    # block 0x005194f5: entered by jmp at 0x005194fe, 6 instruction(s), ends with ret
    pop edi                                      # 005194f5
    pop esi                                      # 005194f6
    pop ebp                                      # 005194f7
    pop ebx                                      # 005194f8
    pop ecx                                      # 005194f9
    ret                                          # 005194fa
L_005194fb:
    # block 0x005194fb: entered by je at 0x005194bb; je at 0x005194ca; je at 0x005194db, 2 instruction(s), ends with backward jump to 0x005194f5
    or eax, -0x1                                 # 005194fb
    jmp.d8 L_005194f5                            # 005194fe

