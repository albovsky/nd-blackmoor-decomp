# FUN_0051e7e4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e7e4
# extent:       0x0051e7e4-0x0051e828 (68 code bytes)
# span:         0x0051e7e4-0x0051e828 (code 68, tables 0, padding 0)
# sha256:       54bdd15e3743294c2543f09b49ff7b25510e3b5114fc58061b3fc0ca28e7529c
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e7e4
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051e627, FUN_0050fa90
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 31 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0050fa90, .text + (0x0050fa90 - 0x401000)
.set FUN_0051e627, .text + (0x0051e627 - 0x401000)

.org 0x0051e7e4 - 0x401000
.globl FUN_0051e7e4
FUN_0051e7e4:
    # block 0x0051e7e4: entry, 10 instruction(s), ends with jne to 0x0051e804 (forward)
    push ebp                                     # 0051e7e4
    {load} mov ebp, esp                          # 0051e7e5
    mov eax, dword ptr [ebp + arg_14]            # 0051e7e7
    push ebx                                     # 0051e7ea
    mov ebx, dword ptr [ebp + arg_c]             # 0051e7eb
    push edi                                     # 0051e7ee
    {load} add eax, ebx                          # 0051e7ef
    {load} mov edi, ecx                          # 0051e7f1
    test eax, eax                                # 0051e7f3
    jne.d8 L_0051e804                            # 0051e7f5
    # block 0x0051e7f7: entered by fall-through of jne at 0x0051e7f5, 4 instruction(s), ends with forward jump to 0x0051e822
    mov eax, dword ptr [ebp + arg_8]             # 0051e7f7
    mov ecx, dword ptr [0x5679b0]                # 0051e7fa
    mov dword ptr [eax], ecx                     # 0051e800
    jmp.d8 L_0051e822                            # 0051e802
L_0051e804:
    # block 0x0051e804: entered by jne at 0x0051e7f5, 13 instruction(s), calls FUN_0051e627, FUN_0050fa90, falls into the block at 0x0051e822
    push esi                                     # 0051e804
    mov esi, dword ptr [ebp + arg_8]             # 0051e805
    push eax                                     # 0051e808
    {load} mov ecx, esi                          # 0051e809
    call FUN_0051e627                            # 0051e80b
    mov eax, dword ptr [edi]                     # 0051e810
    push ebx                                     # 0051e812
    add eax, dword ptr [ebp + arg_10]            # 0051e813
    push eax                                     # 0051e816
    push dword ptr [esi]                         # 0051e817
    call FUN_0050fa90                            # 0051e819
    add esp, 0xc                                 # 0051e81e
    pop esi                                      # 0051e821
L_0051e822:
    # block 0x0051e822: entered by jmp at 0x0051e802, 4 instruction(s), ends with ret 0x10
    pop edi                                      # 0051e822
    pop ebx                                      # 0051e823
    pop ebp                                      # 0051e824
    ret 0x10                                     # 0051e825

