# FUN_0050d805
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050d805
# extent:       0x0050d805-0x0050d8aa (165 code bytes)
# span:         0x0050d805-0x0050d8aa (code 165, tables 0, padding 0)
# sha256:       0e703d60e23057e295bf59c5dc83803e2a2cb6be7d977fd338ebb2d87b0fbc41
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050d805
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_minus_4; [esp + n] stk_8, stk_c, stk_14
# callees:      calls FUN_0050d8aa, KERNEL32.dll!GetCurrentProcess, KERNEL32.dll!TerminateProcess, FUN_0050d8bc, FUN_0050d8b3, KERNEL32.dll!ExitProcess; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 53 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ stk_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ stk_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0050d8aa, .text + (0x0050d8aa - 0x401000)
.set FUN_0050d8b3, .text + (0x0050d8b3 - 0x401000)
.set FUN_0050d8bc, .text + (0x0050d8bc - 0x401000)

.org 0x0050d805 - 0x401000
.globl FUN_0050d805
FUN_0050d805:
    # block 0x0050d805: entry, 6 instruction(s), calls FUN_0050d8aa, ends with jne to 0x0050d827 (forward)
    push edi                                     # 0050d805
    call FUN_0050d8aa                            # 0050d806
    push 0x1                                     # 0050d80b
    pop edi                                      # 0050d80d
    cmp dword ptr [0x63ca4c], edi                # 0050d80e
    jne.d8 L_0050d827                            # 0050d814
    # block 0x0050d816: entered by fall-through of jne at 0x0050d814, 4 instruction(s), calls KERNEL32.dll!GetCurrentProcess, KERNEL32.dll!TerminateProcess, falls into the block at 0x0050d827
    push dword ptr [esp + stk_8]                 # 0050d816
    call dword ptr [0x52a0f8]                    # 0050d81a
    push eax                                     # 0050d820
    call dword ptr [0x52a2c8]                    # 0050d821
L_0050d827:
    # block 0x0050d827: entered by jne at 0x0050d814, 6 instruction(s), ends with jne to 0x0050d87b (forward)
    cmp dword ptr [esp + stk_c], 0x0             # 0050d827
    push ebx                                     # 0050d82c
    mov ebx, dword ptr [esp + stk_14]            # 0050d82d
    mov dword ptr [0x63ca48], edi                # 0050d831
    mov byte ptr [0x63ca44], bl                  # 0050d837
    jne.d8 L_0050d87b                            # 0050d83d
    # block 0x0050d83f: entered by fall-through of jne at 0x0050d83d, 3 instruction(s), ends with je to 0x0050d86a (forward)
    mov eax, dword ptr [0x63e138]                # 0050d83f
    test eax, eax                                # 0050d844
    je.d8 L_0050d86a                             # 0050d846
    # block 0x0050d848: entered by fall-through of je at 0x0050d846, 5 instruction(s), ends with jb to 0x0050d869 (forward)
    mov ecx, dword ptr [0x63e134]                # 0050d848
    push esi                                     # 0050d84e
    lea esi, [ecx - field_minus_4]               # 0050d84f
    {load} cmp esi, eax                          # 0050d852
    jb.d8 L_0050d869                             # 0050d854
L_0050d856:
    # block 0x0050d856: entered by jae at 0x0050d867; fall-through of jb at 0x0050d854, 3 instruction(s), ends with je to 0x0050d85e (forward)
    mov eax, dword ptr [esi]                     # 0050d856
    test eax, eax                                # 0050d858
    je.d8 L_0050d85e                             # 0050d85a
    # block 0x0050d85c: entered by fall-through of je at 0x0050d85a, 1 instruction(s), calls indirect eax, falls into the block at 0x0050d85e
    call eax                                     # 0050d85c
L_0050d85e:
    # block 0x0050d85e: entered by je at 0x0050d85a, 3 instruction(s), ends with jae to 0x0050d856 (backward)
    sub esi, 0x4                                 # 0050d85e
    cmp esi, dword ptr [0x63e138]                # 0050d861
    jae.d8 L_0050d856                            # 0050d867
L_0050d869:
    # block 0x0050d869: entered by jb at 0x0050d854; fall-through of jae at 0x0050d867, 1 instruction(s), falls into the block at 0x0050d86a
    pop esi                                      # 0050d869
L_0050d86a:
    # block 0x0050d86a: entered by je at 0x0050d846, 5 instruction(s), calls FUN_0050d8bc, falls into the block at 0x0050d87b
    push 0x5370a0                                # 0050d86a
    push 0x537098                                # 0050d86f
    call FUN_0050d8bc                            # 0050d874
    pop ecx                                      # 0050d879
    pop ecx                                      # 0050d87a
L_0050d87b:
    # block 0x0050d87b: entered by jne at 0x0050d83d, 8 instruction(s), calls FUN_0050d8bc, ends with je to 0x0050d898 (forward)
    push 0x5370ac                                # 0050d87b
    push 0x5370a4                                # 0050d880
    call FUN_0050d8bc                            # 0050d885
    pop ecx                                      # 0050d88a
    pop ecx                                      # 0050d88b
    test ebx, ebx                                # 0050d88c
    pop ebx                                      # 0050d88e
    je.d8 L_0050d898                             # 0050d88f
    # block 0x0050d891: entered by fall-through of je at 0x0050d88f, 3 instruction(s), calls FUN_0050d8b3, ends with ret
    call FUN_0050d8b3                            # 0050d891
    pop edi                                      # 0050d896
    ret                                          # 0050d897
L_0050d898:
    # block 0x0050d898: entered by je at 0x0050d88f, 5 instruction(s), calls KERNEL32.dll!ExitProcess, ends with ret
    push dword ptr [esp + stk_8]                 # 0050d898
    mov dword ptr [0x63ca4c], edi                # 0050d89c
    call dword ptr [0x52a130]                    # 0050d8a2
    pop edi                                      # 0050d8a8
    ret                                          # 0050d8a9

