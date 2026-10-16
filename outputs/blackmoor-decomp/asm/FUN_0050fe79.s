# FUN_0050fe79
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050fe79
# extent:       0x0050fe79-0x0050fee4 (107 code bytes)
# span:         0x0050fe79-0x0050fee4 (code 107, tables 0, padding 0)
# sha256:       491f3998412d6ee454a391ac91613dd24be08c4a93dedc4d91ed8f49fe2250f1
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050fe79
# arguments:    6 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       [esi + n] field_4, field_48, field_4c
# callees:      calls FUN_0050e97e, FUN_00510dc0, KERNEL32.dll!CreateThread, KERNEL32.dll!GetLastError, FUN_0050e936, FUN_0050ea0b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 45 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ field_48, 0x48  # offset +0x48
.equ field_4c, 0x4c  # offset +0x4c

# --- external targets -----------------------------------------------
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)
.set FUN_0050e97e, .text + (0x0050e97e - 0x401000)
.set FUN_0050ea0b, .text + (0x0050ea0b - 0x401000)
.set FUN_00510dc0, .text + (0x00510dc0 - 0x401000)

.org 0x0050fe79 - 0x401000
.globl FUN_0050fe79
FUN_0050fe79:
    # block 0x0050fe79: entry, 13 instruction(s), calls FUN_0050e97e, ends with je to 0x0050fecc (forward)
    push ebp                                     # 0050fe79
    {load} mov ebp, esp                          # 0050fe7a
    push esi                                     # 0050fe7c
    push edi                                     # 0050fe7d
    push 0x74                                    # 0050fe7e
    push 0x1                                     # 0050fe80
    {load} xor edi, edi                          # 0050fe82
    call FUN_0050e97e                            # 0050fe84
    {load} mov esi, eax                          # 0050fe89
    pop ecx                                      # 0050fe8b
    test esi, esi                                # 0050fe8c
    pop ecx                                      # 0050fe8e
    je.d8 L_0050fecc                             # 0050fe8f
    # block 0x0050fe91: entered by fall-through of je at 0x0050fe8f, 17 instruction(s), calls FUN_00510dc0, KERNEL32.dll!CreateThread, ends with jne to 0x0050fee0 (forward)
    push esi                                     # 0050fe91
    call FUN_00510dc0                            # 0050fe92
    pop ecx                                      # 0050fe97
    mov eax, dword ptr [ebp + arg_10]            # 0050fe98
    push dword ptr [ebp + arg_1c]                # 0050fe9b
    or dword ptr [esi + field_4], -0x1           # 0050fe9e
    mov dword ptr [esi + field_48], eax          # 0050fea2
    mov eax, dword ptr [ebp + arg_14]            # 0050fea5
    push dword ptr [ebp + arg_18]                # 0050fea8
    mov dword ptr [esi + field_4c], eax          # 0050feab
    push esi                                     # 0050feae
    push 0x50fee4                                # 0050feaf
    push dword ptr [ebp + arg_c]                 # 0050feb4
    push dword ptr [ebp + arg_8]                 # 0050feb7
    call dword ptr [0x52a15c]                    # 0050feba
    test eax, eax                                # 0050fec0
    jne.d8 L_0050fee0                            # 0050fec2
    # block 0x0050fec4: entered by fall-through of jne at 0x0050fec2, 2 instruction(s), calls KERNEL32.dll!GetLastError, falls into the block at 0x0050fecc
    call dword ptr [0x52a2a4]                    # 0050fec4
    {load} mov edi, eax                          # 0050feca
L_0050fecc:
    # block 0x0050fecc: entered by je at 0x0050fe8f, 5 instruction(s), calls FUN_0050e936, ends with je to 0x0050fede (forward)
    push esi                                     # 0050fecc
    call FUN_0050e936                            # 0050fecd
    test edi, edi                                # 0050fed2
    pop ecx                                      # 0050fed4
    je.d8 L_0050fede                             # 0050fed5
    # block 0x0050fed7: entered by fall-through of je at 0x0050fed5, 3 instruction(s), calls FUN_0050ea0b, falls into the block at 0x0050fede
    push edi                                     # 0050fed7
    call FUN_0050ea0b                            # 0050fed8
    pop ecx                                      # 0050fedd
L_0050fede:
    # block 0x0050fede: entered by je at 0x0050fed5, 1 instruction(s), falls into the block at 0x0050fee0
    {load} xor eax, eax                          # 0050fede
L_0050fee0:
    # block 0x0050fee0: entered by jne at 0x0050fec2, 4 instruction(s), ends with ret
    pop edi                                      # 0050fee0
    pop esi                                      # 0050fee1
    pop ebp                                      # 0050fee2
    ret                                          # 0050fee3

