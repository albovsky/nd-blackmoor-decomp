# FUN_004be619
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004be619
# extent:       0x004be619-0x004be6a4 (139 code bytes)
# span:         0x004be619-0x004be6a4 (code 139, tables 0, padding 0)
# sha256:       0d30d0057d15e89a1e5cc4f242dfa1e9e9bb09e3b38398b5dcdd0f2b00e5696b
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004be619
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_004264e8, FUN_0044a2b7, FUN_004c97b4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 45 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004be619 - 0x401000
.globl FUN_004be619
FUN_004be619:
    # block 0x004be619: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x004be685 (forward)
    push ebp                                     # 004be619
    {load} mov ebp, esp                          # 004be61a
    sub esp, 0x8                                 # 004be61c
    push edi                                     # 004be61f
    mov dword ptr [ebp - local_8], ecx           # 004be620
    mov eax, dword ptr [ebp + arg_c]             # 004be623
    push eax                                     # 004be626
    call FUN_0051dc43                            # 004be627
    add esp, 0x4                                 # 004be62c
    mov dword ptr [ebp - local_4], eax           # 004be62f
    mov ecx, dword ptr [ebp + arg_8]             # 004be632
    mov edx, dword ptr [ebp - local_4]           # 004be635
    mov dword ptr [ecx], edx                     # 004be638
    cmp dword ptr [ebp - local_4], 0x0           # 004be63a
    jne.d8 L_004be685                            # 004be63e
    # block 0x004be640: entered by fall-through of jne at 0x004be63e, 10 instruction(s), calls FUN_0050ca3e, FUN_004264e8, ends with je to 0x004be679 (forward)
    push 0x552190                                # 004be640
    push 0x63888b                                # 004be645
    call FUN_0050ca3e                            # 004be64a
    add esp, 0x8                                 # 004be64f
    push 0x63888b                                # 004be652
    mov ecx, 0x583979                            # 004be657
    call FUN_004264e8                            # 004be65c
    movsx eax, word ptr [0x63a4cd]               # 004be661
    test eax, eax                                # 004be668
    je.d8 L_004be679                             # 004be66a
    # block 0x004be66c: entered by fall-through of je at 0x004be66a, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004be679
    push 0x63888b                                # 004be66c
    call FUN_0044a2b7                            # 004be671
    add esp, 0x4                                 # 004be676
L_004be679:
    # block 0x004be679: entered by je at 0x004be66a, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x004be69d
    mov ecx, 0x5cf659                            # 004be679
    call FUN_004c97b4                            # 004be67e
    jmp.d8 L_004be69d                            # 004be683
L_004be685:
    # block 0x004be685: entered by jne at 0x004be63e, 10 instruction(s), falls into the block at 0x004be69d
    mov ecx, dword ptr [ebp + arg_c]             # 004be685
    {load} xor eax, eax                          # 004be688
    mov edx, dword ptr [ebp + arg_8]             # 004be68a
    mov edi, dword ptr [edx]                     # 004be68d
    {load} mov edx, ecx                          # 004be68f
    shr ecx, 0x2                                 # 004be691
    rep stosd dword ptr es:[edi], eax            # 004be694
    {load} mov ecx, edx                          # 004be696
    and ecx, 0x3                                 # 004be698
    rep stosb byte ptr es:[edi], al              # 004be69b
L_004be69d:
    # block 0x004be69d: entered by jmp at 0x004be683, 4 instruction(s), ends with ret 0x8
    pop edi                                      # 004be69d
    {load} mov esp, ebp                          # 004be69e
    pop ebp                                      # 004be6a0
    ret 0x8                                      # 004be6a1

