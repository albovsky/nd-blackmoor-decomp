# FUN_0051dd50
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051dd50
# extent:       0x0051dd50-0x0051ddd5 (133 code bytes)
# span:         0x0051dd50-0x0051ddd5 (code 133, tables 0, padding 0)
# sha256:       7d58d921462e4d3d1a950d47791cd6f5a3bab6ecade033f746b54f2764438aca
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051dd50
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none: no [ebp-n] slot referenced
# fields:       [edx + n] field_c; [esi + n] field_1c
# callees:      calls FUN_0051d862, USER32.dll!GetParent, FUN_0051abe4, FUN_0051ec6f; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 59 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0051abe4, .text + (0x0051abe4 - 0x401000)
.set FUN_0051d862, .text + (0x0051d862 - 0x401000)
.set FUN_0051ec6f, .text + (0x0051ec6f - 0x401000)

.org 0x0051dd50 - 0x401000
.globl FUN_0051dd50
FUN_0051dd50:
    # block 0x0051dd50: entry, 15 instruction(s), calls FUN_0051d862, ends with jne to 0x0051ddc7 (forward)
    push ebp                                     # 0051dd50
    {load} mov ebp, esp                          # 0051dd51
    push ebx                                     # 0051dd53
    push esi                                     # 0051dd54
    mov ebx, dword ptr [ebp + arg_8]             # 0051dd55
    push edi                                     # 0051dd58
    push dword ptr [ebp + arg_14]                # 0051dd59
    mov edi, dword ptr [ebp + arg_c]             # 0051dd5c
    {load} mov esi, ecx                          # 0051dd5f
    push dword ptr [ebp + arg_10]                # 0051dd61
    push edi                                     # 0051dd64
    push ebx                                     # 0051dd65
    call FUN_0051d862                            # 0051dd66
    test eax, eax                                # 0051dd6b
    jne.d8 L_0051ddc7                            # 0051dd6d
    # block 0x0051dd6f: entered by fall-through of jne at 0x0051dd6d, 2 instruction(s), ends with je to 0x0051dd78 (forward)
    test edi, edi                                # 0051dd6f
    je.d8 L_0051dd78                             # 0051dd71
    # block 0x0051dd73: entered by fall-through of je at 0x0051dd71, 2 instruction(s), ends with jne to 0x0051ddcc (forward)
    cmp edi, -0x1                                # 0051dd73
    jne.d8 L_0051ddcc                            # 0051dd76
L_0051dd78:
    # block 0x0051dd78: entered by je at 0x0051dd71; fall-through of jne at 0x0051dd76, 2 instruction(s), ends with je to 0x0051ddcc (forward)
    test bh, -0x80                               # 0051dd78
    je.d8 L_0051ddcc                             # 0051dd7b
    # block 0x0051dd7d: entered by fall-through of je at 0x0051dd7b, 2 instruction(s), ends with jae to 0x0051ddcc (forward)
    cmp ebx, 0xf000                              # 0051dd7d
    jae.d8 L_0051ddcc                            # 0051dd83
    # block 0x0051dd85: entered by fall-through of jae at 0x0051dd83, 6 instruction(s), calls USER32.dll!GetParent, FUN_0051abe4, ends with je to 0x0051ddab (forward)
    push dword ptr [esi + field_1c]              # 0051dd85
    call dword ptr [0x52a3dc]                    # 0051dd88
    push eax                                     # 0051dd8e
    call FUN_0051abe4                            # 0051dd8f
    test eax, eax                                # 0051dd94
    je.d8 L_0051ddab                             # 0051dd96
    # block 0x0051dd98: entered by fall-through of je at 0x0051dd96, 9 instruction(s), calls indirect dword ptr [edx + 0xc], ends with jne to 0x0051ddc7 (forward)
    push dword ptr [ebp + arg_14]                # 0051dd98
    mov edx, dword ptr [eax]                     # 0051dd9b
    {load} mov ecx, eax                          # 0051dd9d
    push dword ptr [ebp + arg_10]                # 0051dd9f
    push edi                                     # 0051dda2
    push ebx                                     # 0051dda3
    call dword ptr [edx + field_c]               # 0051dda4
    test eax, eax                                # 0051dda7
    jne.d8 L_0051ddc7                            # 0051dda9
L_0051ddab:
    # block 0x0051ddab: entered by je at 0x0051dd96; fall-through of jne at 0x0051dda9, 3 instruction(s), calls FUN_0051ec6f, ends with je to 0x0051ddcc (forward)
    call FUN_0051ec6f                            # 0051ddab
    test eax, eax                                # 0051ddb0
    je.d8 L_0051ddcc                             # 0051ddb2
    # block 0x0051ddb4: entered by fall-through of je at 0x0051ddb2, 9 instruction(s), calls indirect dword ptr [edx + 0xc], ends with je to 0x0051ddcc (forward)
    push dword ptr [ebp + arg_14]                # 0051ddb4
    mov edx, dword ptr [eax]                     # 0051ddb7
    {load} mov ecx, eax                          # 0051ddb9
    push dword ptr [ebp + arg_10]                # 0051ddbb
    push edi                                     # 0051ddbe
    push ebx                                     # 0051ddbf
    call dword ptr [edx + field_c]               # 0051ddc0
    test eax, eax                                # 0051ddc3
    je.d8 L_0051ddcc                             # 0051ddc5
L_0051ddc7:
    # block 0x0051ddc7: entered by jne at 0x0051dd6d; jne at 0x0051dda9; fall-through of je at 0x0051ddc5, 3 instruction(s), ends with forward jump to 0x0051ddce
    push 0x1                                     # 0051ddc7
    pop eax                                      # 0051ddc9
    jmp.d8 L_0051ddce                            # 0051ddca
L_0051ddcc:
    # block 0x0051ddcc: entered by jne at 0x0051dd76; je at 0x0051dd7b; jae at 0x0051dd83; je at 0x0051ddb2; je at 0x0051ddc5, 1 instruction(s), falls into the block at 0x0051ddce
    {load} xor eax, eax                          # 0051ddcc
L_0051ddce:
    # block 0x0051ddce: entered by jmp at 0x0051ddca, 5 instruction(s), ends with ret 0x10
    pop edi                                      # 0051ddce
    pop esi                                      # 0051ddcf
    pop ebx                                      # 0051ddd0
    pop ebp                                      # 0051ddd1
    ret 0x10                                     # 0051ddd2

