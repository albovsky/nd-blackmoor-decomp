# FUN_00524704
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524704
# extent:       0x00524704-0x005247a7 (163 code bytes)
# span:         0x00524704-0x005247a7 (code 163, tables 0, padding 0)
# sha256:       7b1a95e23be184c3cffdb814c45773c4b575843fe10389b707fecd6c15d7f701
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524704
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [edi + n] field_1c
# callees:      calls USER32.dll!GetFocus, USER32.dll!GetDesktopWindow, USER32.dll!SendMessageA, USER32.dll!GetParent; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 67 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------

.org 0x00524704 - 0x401000
.globl FUN_00524704
FUN_00524704:
    # block 0x00524704: entry, 12 instruction(s), calls indirect esi, ends with jge to 0x00524721 (forward)
    push ebp                                     # 00524704
    {load} mov ebp, esp                          # 00524705
    push ecx                                     # 00524707
    push ebx                                     # 00524708
    push esi                                     # 00524709
    mov esi, dword ptr [0x52a4b8]                # 0052470a
    push edi                                     # 00524710
    {load} mov edi, ecx                          # 00524711
    push 0x11                                    # 00524713
    call esi                                     # 00524715
    test ax, ax                                  # 00524717
    jge.d8 L_00524721                            # 0052471a
    # block 0x0052471c: entered by fall-through of jge at 0x0052471a, 3 instruction(s), ends with forward jump to 0x00524723
    push 0x8                                     # 0052471c
    pop ebx                                      # 0052471e
    jmp.d8 L_00524723                            # 0052471f
L_00524721:
    # block 0x00524721: entered by jge at 0x0052471a, 1 instruction(s), falls into the block at 0x00524723
    {load} xor ebx, ebx                          # 00524721
L_00524723:
    # block 0x00524723: entered by jmp at 0x0052471f, 4 instruction(s), calls indirect esi, ends with jge to 0x00524731 (forward)
    push 0x10                                    # 00524723
    call esi                                     # 00524725
    test ax, ax                                  # 00524727
    jge.d8 L_00524731                            # 0052472a
    # block 0x0052472c: entered by fall-through of jge at 0x0052472a, 3 instruction(s), ends with forward jump to 0x00524733
    push 0x4                                     # 0052472c
    pop eax                                      # 0052472e
    jmp.d8 L_00524733                            # 0052472f
L_00524731:
    # block 0x00524731: entered by jge at 0x0052472a, 1 instruction(s), falls into the block at 0x00524733
    {load} xor eax, eax                          # 00524731
L_00524733:
    # block 0x00524733: entered by jmp at 0x0052472f, 7 instruction(s), calls USER32.dll!GetFocus, USER32.dll!GetDesktopWindow, ends with jne to 0x0052476b (forward)
    {load} or ebx, eax                           # 00524733
    call dword ptr [0x52a308]                    # 00524735
    {load} mov esi, eax                          # 0052473b
    call dword ptr [0x52a384]                    # 0052473d
    test esi, esi                                # 00524743
    mov dword ptr [ebp - local_4], eax           # 00524745
    jne.d8 L_0052476b                            # 00524748
    # block 0x0052474a: entered by fall-through of jne at 0x00524748, 11 instruction(s), calls USER32.dll!SendMessageA, ends with forward jump to 0x0052479e
    mov eax, dword ptr [ebp + arg_8]             # 0052474a
    push dword ptr [ebp + arg_c]                 # 0052474d
    movzx ecx, bx                                # 00524750
    shl eax, 0x10                                # 00524753
    {load} or eax, ecx                           # 00524756
    push eax                                     # 00524758
    push 0x20a                                   # 00524759
    push dword ptr [edi + field_1c]              # 0052475e
    call dword ptr [0x52a4c8]                    # 00524761
    {load} mov ebx, eax                          # 00524767
    jmp.d8 L_0052479e                            # 00524769
L_0052476b:
    # block 0x0052476b: entered by jne at 0x00524748, 4 instruction(s), falls into the block at 0x00524776
    mov edi, dword ptr [ebp + arg_8]             # 0052476b
    movzx eax, bx                                # 0052476e
    shl edi, 0x10                                # 00524771
    {load} or edi, eax                           # 00524774
L_00524776:
    # block 0x00524776: entered by jne at 0x0052479c, 11 instruction(s), calls USER32.dll!SendMessageA, USER32.dll!GetParent, ends with jne to 0x0052479e (forward)
    push dword ptr [ebp + arg_c]                 # 00524776
    push edi                                     # 00524779
    push 0x20a                                   # 0052477a
    push esi                                     # 0052477f
    call dword ptr [0x52a4c8]                    # 00524780
    push esi                                     # 00524786
    {load} mov ebx, eax                          # 00524787
    call dword ptr [0x52a3dc]                    # 00524789
    test ebx, ebx                                # 0052478f
    {load} mov esi, eax                          # 00524791
    jne.d8 L_0052479e                            # 00524793
    # block 0x00524795: entered by fall-through of jne at 0x00524793, 2 instruction(s), ends with je to 0x0052479e (forward)
    test esi, esi                                # 00524795
    je.d8 L_0052479e                             # 00524797
    # block 0x00524799: entered by fall-through of je at 0x00524797, 2 instruction(s), ends with jne to 0x00524776 (backward)
    cmp esi, dword ptr [ebp - local_4]           # 00524799
    jne.d8 L_00524776                            # 0052479c
L_0052479e:
    # block 0x0052479e: entered by jmp at 0x00524769; jne at 0x00524793; je at 0x00524797; fall-through of jne at 0x0052479c, 6 instruction(s), ends with ret 0x8
    pop edi                                      # 0052479e
    {load} mov eax, ebx                          # 0052479f
    pop esi                                      # 005247a1
    pop ebx                                      # 005247a2
    leave                                        # 005247a3
    ret 0x8                                      # 005247a4

