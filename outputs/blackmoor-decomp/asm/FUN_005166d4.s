# FUN_005166d4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005166d4
# extent:       0x005166d4-0x0051672d (89 code bytes)
# span:         0x005166d4-0x0051672d (code 89, tables 0, padding 0)
# sha256:       596f6d1a0d9994c7a7b88ec0fcce2bcf553210e0814743118482d545ea7c9908
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005166d4
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls KERNEL32.dll!InterlockedIncrement, FUN_00512c18, FUN_0051672d, FUN_00512c79; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 39 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_00512c18, .text + (0x00512c18 - 0x401000)
.set FUN_00512c79, .text + (0x00512c79 - 0x401000)
.set FUN_0051672d, .text + (0x0051672d - 0x401000)

.org 0x005166d4 - 0x401000
.globl FUN_005166d4
FUN_005166d4:
    # block 0x005166d4: entry, 12 instruction(s), calls KERNEL32.dll!InterlockedIncrement, ends with je to 0x00516704 (forward)
    push ebp                                     # 005166d4
    {load} mov ebp, esp                          # 005166d5
    push ebx                                     # 005166d7
    push esi                                     # 005166d8
    mov esi, 0x63cee8                            # 005166d9
    push edi                                     # 005166de
    push esi                                     # 005166df
    call dword ptr [0x52a200]                    # 005166e0
    mov edi, dword ptr [0x52a1fc]                # 005166e6
    {load} xor ebx, ebx                          # 005166ec
    cmp dword ptr [0x63cee4], ebx                # 005166ee
    je.d8 L_00516704                             # 005166f4
    # block 0x005166f6: entered by fall-through of je at 0x005166f4, 7 instruction(s), calls indirect edi, FUN_00512c18, falls into the block at 0x00516704
    push esi                                     # 005166f6
    call edi                                     # 005166f7
    push 0x13                                    # 005166f9
    call FUN_00512c18                            # 005166fb
    pop ecx                                      # 00516700
    push 0x1                                     # 00516701
    pop ebx                                      # 00516703
L_00516704:
    # block 0x00516704: entered by je at 0x005166f4, 8 instruction(s), calls FUN_0051672d, ends with je to 0x00516722 (forward)
    push dword ptr [ebp + arg_c]                 # 00516704
    push dword ptr [ebp + arg_8]                 # 00516707
    call FUN_0051672d                            # 0051670a
    pop ecx                                      # 0051670f
    mov dword ptr [ebp + arg_c], eax             # 00516710
    test ebx, ebx                                # 00516713
    pop ecx                                      # 00516715
    je.d8 L_00516722                             # 00516716
    # block 0x00516718: entered by fall-through of je at 0x00516716, 4 instruction(s), calls FUN_00512c79, ends with forward jump to 0x00516725
    push 0x13                                    # 00516718
    call FUN_00512c79                            # 0051671a
    pop ecx                                      # 0051671f
    jmp.d8 L_00516725                            # 00516720
L_00516722:
    # block 0x00516722: entered by je at 0x00516716, 2 instruction(s), calls indirect edi, falls into the block at 0x00516725
    push esi                                     # 00516722
    call edi                                     # 00516723
L_00516725:
    # block 0x00516725: entered by jmp at 0x00516720, 6 instruction(s), ends with ret
    mov eax, dword ptr [ebp + arg_c]             # 00516725
    pop edi                                      # 00516728
    pop esi                                      # 00516729
    pop ebx                                      # 0051672a
    pop ebp                                      # 0051672b
    ret                                          # 0051672c

