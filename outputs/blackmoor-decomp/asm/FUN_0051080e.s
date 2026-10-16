# FUN_0051080e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051080e
# extent:       0x0051080e-0x0051086b (93 code bytes)
# span:         0x0051080e-0x0051086b (code 93, tables 0, padding 0)
# sha256:       32226ad6eaae61e18a253b3a2f19966312b1ac65b2219e321477763191d6422a
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051080e
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_8; [edi + n] field_4; [esi + n] field_4; [esp + n] stk_c, stk_10, stk_14
# callees:      calls FUN_005130f0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 42 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_005130f0, .text + (0x005130f0 - 0x401000)

.org 0x0051080e - 0x401000
.globl FUN_0051080e
FUN_0051080e:
    # block 0x0051080e: entry, 6 instruction(s), ends with je to 0x00510865 (forward)
    push esi                                     # 0051080e
    push edi                                     # 0051080f
    mov edi, dword ptr [esp + stk_c]             # 00510810
    mov eax, dword ptr [edi + field_4]           # 00510814
    test eax, eax                                # 00510817
    je.d8 L_00510865                             # 00510819
    # block 0x0051081b: entered by fall-through of je at 0x00510819, 3 instruction(s), ends with je to 0x00510865 (forward)
    cmp byte ptr [eax + field_8], 0x0            # 0051081b
    lea edx, [eax + field_8]                     # 0051081f
    je.d8 L_00510865                             # 00510822
    # block 0x00510824: entered by fall-through of je at 0x00510822, 4 instruction(s), ends with je to 0x0051083f (forward)
    mov esi, dword ptr [esp + stk_10]            # 00510824
    mov ecx, dword ptr [esi + field_4]           # 00510828
    {load} cmp eax, ecx                          # 0051082b
    je.d8 L_0051083f                             # 0051082d
    # block 0x0051082f: entered by fall-through of je at 0x0051082d, 8 instruction(s), calls FUN_005130f0, ends with jne to 0x00510861 (forward)
    add ecx, 0x8                                 # 0051082f
    push ecx                                     # 00510832
    push edx                                     # 00510833
    call FUN_005130f0                            # 00510834
    pop ecx                                      # 00510839
    test eax, eax                                # 0051083a
    pop ecx                                      # 0051083c
    jne.d8 L_00510861                            # 0051083d
L_0051083f:
    # block 0x0051083f: entered by je at 0x0051082d; fall-through of jne at 0x0051083d, 2 instruction(s), ends with je to 0x00510849 (forward)
    test byte ptr [esi], 0x2                     # 0051083f
    je.d8 L_00510849                             # 00510842
    # block 0x00510844: entered by fall-through of je at 0x00510842, 2 instruction(s), ends with je to 0x00510861 (forward)
    test byte ptr [edi], 0x8                     # 00510844
    je.d8 L_00510861                             # 00510847
L_00510849:
    # block 0x00510849: entered by je at 0x00510842; fall-through of je at 0x00510847, 4 instruction(s), ends with je to 0x00510858 (forward)
    mov eax, dword ptr [esp + stk_14]            # 00510849
    mov eax, dword ptr [eax]                     # 0051084d
    test al, 0x1                                 # 0051084f
    je.d8 L_00510858                             # 00510851
    # block 0x00510853: entered by fall-through of je at 0x00510851, 2 instruction(s), ends with je to 0x00510861 (forward)
    test byte ptr [edi], 0x1                     # 00510853
    je.d8 L_00510861                             # 00510856
L_00510858:
    # block 0x00510858: entered by je at 0x00510851; fall-through of je at 0x00510856, 2 instruction(s), ends with je to 0x00510865 (forward)
    test al, 0x2                                 # 00510858
    je.d8 L_00510865                             # 0051085a
    # block 0x0051085c: entered by fall-through of je at 0x0051085a, 2 instruction(s), ends with jne to 0x00510865 (forward)
    test byte ptr [edi], 0x2                     # 0051085c
    jne.d8 L_00510865                            # 0051085f
L_00510861:
    # block 0x00510861: entered by jne at 0x0051083d; je at 0x00510847; je at 0x00510856; fall-through of jne at 0x0051085f, 2 instruction(s), ends with forward jump to 0x00510868
    {load} xor eax, eax                          # 00510861
    jmp.d8 L_00510868                            # 00510863
L_00510865:
    # block 0x00510865: entered by je at 0x00510819; je at 0x00510822; je at 0x0051085a; jne at 0x0051085f, 2 instruction(s), falls into the block at 0x00510868
    push 0x1                                     # 00510865
    pop eax                                      # 00510867
L_00510868:
    # block 0x00510868: entered by jmp at 0x00510863, 3 instruction(s), ends with ret
    pop edi                                      # 00510868
    pop esi                                      # 00510869
    ret                                          # 0051086a

