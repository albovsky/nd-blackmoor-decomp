# FUN_005226e2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005226e2
# extent:       0x005226e2-0x00522753 (113 code bytes)
# span:         0x005226e2-0x00522753 (code 113, tables 0, padding 0)
# sha256:       e7e78452c7b46f0e0172c3d6c3591b81b800b4be6f48c1957f18dbaae6b9513e
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005226e2
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_4; [esi + n] field_1c
# callees:      calls FUN_0051c4ec, FUN_0051c9ac, FUN_0051ca36, FUN_0051ab4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 42 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00522753
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)
.set FUN_0051c4ec, .text + (0x0051c4ec - 0x401000)
.set FUN_0051c9ac, .text + (0x0051c9ac - 0x401000)
.set FUN_0051ca36, .text + (0x0051ca36 - 0x401000)

.org 0x005226e2 - 0x401000
.globl FUN_005226e2
FUN_005226e2:
    # block 0x005226e2: entry, 12 instruction(s), calls FUN_0051c4ec, ends with je to 0x00522700 (forward)
    push ebp                                     # 005226e2
    {load} mov ebp, esp                          # 005226e3
    push esi                                     # 005226e5
    mov esi, dword ptr [ebp + arg_c]             # 005226e6
    push edi                                     # 005226e9
    {load} mov edi, ecx                          # 005226ea
    lea eax, [ebp + arg_c]                       # 005226ec
    {load} mov ecx, esi                          # 005226ef
    push eax                                     # 005226f1
    call FUN_0051c4ec                            # 005226f2
    test eax, eax                                # 005226f7
    je.d8 L_00522700                             # 005226f9
    # block 0x005226fb: entered by fall-through of je at 0x005226f9, 2 instruction(s), ends with forward jump to 0x0052274d
    mov eax, dword ptr [ebp + arg_c]             # 005226fb
    jmp.d8 L_0052274d                            # 005226fe
L_00522700:
    # block 0x00522700: entered by je at 0x005226f9, 2 instruction(s), ends with je to 0x00522719 (forward)
    cmp dword ptr [0x63c7a4], 0x0                # 00522700
    je.d8 L_00522719                             # 00522707
    # block 0x00522709: entered by fall-through of je at 0x00522707, 6 instruction(s), calls FUN_0051c9ac, ends with forward jump to 0x0052274d
    push dword ptr [ebp + arg_10]                # 00522709
    {load} mov ecx, edi                          # 0052270c
    push esi                                     # 0052270e
    push dword ptr [ebp + arg_8]                 # 0052270f
    call FUN_0051c9ac                            # 00522712
    jmp.d8 L_0052274d                            # 00522717
L_00522719:
    # block 0x00522719: entered by je at 0x00522707, 2 instruction(s), ends with je to 0x00522720 (forward)
    test esi, esi                                # 00522719
    je.d8 L_00522720                             # 0052271b
    # block 0x0052271d: entered by fall-through of je at 0x0052271b, 1 instruction(s), falls into the block at 0x00522720
    mov esi, dword ptr [esi + field_1c]          # 0052271d
L_00522720:
    # block 0x00522720: entered by je at 0x0052271b, 9 instruction(s), calls FUN_0051ca36, ends with jne to 0x00522748 (forward)
    push dword ptr [0x63c77c]                    # 00522720
    mov eax, dword ptr [ebp + arg_8]             # 00522726
    push dword ptr [0x63c76c]                    # 00522729
    push dword ptr [ebp + arg_10]                # 0052272f
    push esi                                     # 00522732
    push dword ptr [eax + field_4]               # 00522733
    call FUN_0051ca36                            # 00522736
    test eax, eax                                # 0052273b
    jne.d8 L_00522748                            # 0052273d
    # block 0x0052273f: entered by fall-through of jne at 0x0052273d, 3 instruction(s), calls FUN_0051ab4b, ends with forward jump to 0x0052274d
    {load} mov ecx, edi                          # 0052273f
    call FUN_0051ab4b                            # 00522741
    jmp.d8 L_0052274d                            # 00522746
L_00522748:
    # block 0x00522748: entered by jne at 0x0052273d, 1 instruction(s), falls into the block at 0x0052274d
    mov eax, dword ptr [0x63c76c]                # 00522748
L_0052274d:
    # block 0x0052274d: entered by jmp at 0x005226fe; jmp at 0x00522717; jmp at 0x00522746, 4 instruction(s), ends with ret 0xc
    pop edi                                      # 0052274d
    pop esi                                      # 0052274e
    pop ebp                                      # 0052274f
    ret 0xc                                      # 00522750

