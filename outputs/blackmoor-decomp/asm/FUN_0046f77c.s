# FUN_0046f77c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046f77c
# extent:       0x0046f77c-0x0046f8ae (306 code bytes)
# span:         0x0046f77c-0x0046f8ae (code 306, tables 0, padding 0)
# sha256:       208ae4d3eda3670f3b2d6782d35d7fcbdb2a7a50421d6c91d5df1c85584dff07
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0046f77c
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       8 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18, local_1c, local_20, local_24
# fields:       [eax + n] field_1e; [ecx + n] field_87; [edx + n] field_minus_8
# callees:      calls FUN_0051e828, FUN_0051ea21, FUN_00519bbf, FUN_0051ea75, FUN_00448d11, FUN_0051e7ba
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m46f77c_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 83 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_minus_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ field_1e, 0x1e  # offset +0x1e
.equ field_87, 0x87  # offset +0x87

# --- external targets -----------------------------------------------
.set FUN_00448d11, .text + (0x00448d11 - 0x401000)
.set FUN_00519bbf, .text + (0x00519bbf - 0x401000)
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)
.set FUN_0051e828, .text + (0x0051e828 - 0x401000)
.set FUN_0051ea21, .text + (0x0051ea21 - 0x401000)
.set FUN_0051ea75, .text + (0x0051ea75 - 0x401000)

.org 0x0046f77c - 0x401000
.globl FUN_0046f77c
FUN_0046f77c:
    # block 0x0046f77c: entry, 11 instruction(s), ends with je to 0x0046f8a0 (forward)
    push ebp                                     # 0046f77c
    {load} mov ebp, esp                          # 0046f77d
    push -0x1                                    # 0046f77f
    push 0x528252                                # 0046f781
    mov eax, dword ptr fs:[0x0]                  # 0046f786
    push eax                                     # 0046f78c
    mov dword ptr fs:[0x0], esp                  # 0046f78d
    sub esp, 0x18                                # 0046f794
    mov dword ptr [ebp - local_20], ecx          # 0046f797
    cmp dword ptr [0x5bb202], 0x0                # 0046f79a
    je.d32 L_0046f8a0                            # 0046f7a1
    # block 0x0046f7a7: entered by fall-through of je at 0x0046f7a1, 11 instruction(s), calls FUN_0051e828, ends with forward jump to 0x0046f7e3
    mov eax, dword ptr [ebp - local_20]          # 0046f7a7
    movsx ecx, word ptr [eax + field_1e]         # 0046f7aa
    imul ecx, ecx, 0x8d                          # 0046f7ae
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046f7b4
    mov dword ptr [ebp - local_18], edx          # 0046f7ba
    push 0x54c154                                # 0046f7bd
    lea ecx, [ebp - local_10]                    # 0046f7c2
    call FUN_0051e828                            # 0046f7c5
    mov dword ptr [ebp - local_4], 0x0           # 0046f7ca
    mov dword ptr [ebp - local_14], 0x0          # 0046f7d1
    jmp.d8 L_0046f7e3                            # 0046f7d8
L_0046f7da:
    # block 0x0046f7da: entered by jmp at 0x0046f861, 3 instruction(s), falls into the block at 0x0046f7e3
    mov eax, dword ptr [ebp - local_14]          # 0046f7da
    add eax, 0x1                                 # 0046f7dd
    mov dword ptr [ebp - local_14], eax          # 0046f7e0
L_0046f7e3:
    # block 0x0046f7e3: entered by jmp at 0x0046f7d8, 2 instruction(s), ends with jge to 0x0046f866 (forward)
    cmp dword ptr [ebp - local_14], 0x5          # 0046f7e3
    jge.d8 L_0046f866                            # 0046f7e7
    # block 0x0046f7e9: entered by fall-through of jge at 0x0046f7e7, 6 instruction(s), ends with je to 0x0046f80c (forward)
    mov ecx, dword ptr [ebp - local_20]          # 0046f7e9
    add ecx, dword ptr [ebp - local_14]          # 0046f7ec
    mov dl, byte ptr [ecx + field_87]            # 0046f7ef
    mov byte ptr [ebp - local_24], dl            # 0046f7f5
    cmp byte ptr [ebp - local_24], 0x0           # 0046f7f8
    je.d8 L_0046f80c                             # 0046f7fc
    # block 0x0046f7fe: entered by fall-through of je at 0x0046f7fc, 2 instruction(s), ends with je to 0x0046f822 (forward)
    cmp byte ptr [ebp - local_24], 0x1           # 0046f7fe
    je.d8 L_0046f822                             # 0046f802
    # block 0x0046f804: entered by fall-through of je at 0x0046f802, 2 instruction(s), ends with je to 0x0046f842 (forward)
    cmp byte ptr [ebp - local_24], 0x2           # 0046f804
    je.d8 L_0046f842                             # 0046f808
    # block 0x0046f80a: entered by fall-through of je at 0x0046f808, 1 instruction(s), ends with forward jump to 0x0046f861
    jmp.d8 L_0046f861                            # 0046f80a
L_0046f80c:
    # block 0x0046f80c: entered by je at 0x0046f7fc, 5 instruction(s), calls FUN_0051ea21, ends with forward jump to 0x0046f861
    push 0x54c15c                                # 0046f80c
    lea ecx, [ebp - local_10]                    # 0046f811
    call FUN_0051ea21                            # 0046f814
    mov dword ptr [ebp - local_14], 0x5          # 0046f819
    jmp.d8 L_0046f861                            # 0046f820
L_0046f822:
    # block 0x0046f822: entered by je at 0x0046f802, 9 instruction(s), calls FUN_0051ea21, FUN_00519bbf, ends with forward jump to 0x0046f861
    mov eax, dword ptr [ebp - local_18]          # 0046f822
    add eax, 0x777                               # 0046f825
    push eax                                     # 0046f82a
    lea ecx, [ebp - local_10]                    # 0046f82b
    call FUN_0051ea21                            # 0046f82e
    push 0x54c164                                # 0046f833
    lea ecx, [ebp - local_10]                    # 0046f838
    call FUN_00519bbf                            # 0046f83b
    jmp.d8 L_0046f861                            # 0046f840
L_0046f842:
    # block 0x0046f842: entered by je at 0x0046f808, 8 instruction(s), calls FUN_0051ea21, FUN_00519bbf, falls into the block at 0x0046f861
    mov ecx, dword ptr [ebp - local_18]          # 0046f842
    add ecx, 0x80c                               # 0046f845
    push ecx                                     # 0046f84b
    lea ecx, [ebp - local_10]                    # 0046f84c
    call FUN_0051ea21                            # 0046f84f
    push 0x54c16c                                # 0046f854
    lea ecx, [ebp - local_10]                    # 0046f859
    call FUN_00519bbf                            # 0046f85c
L_0046f861:
    # block 0x0046f861: entered by jmp at 0x0046f80a; jmp at 0x0046f820; jmp at 0x0046f840, 1 instruction(s), ends with backward jump to 0x0046f7da
    jmp.d32 L_0046f7da                           # 0046f861
L_0046f866:
    # block 0x0046f866: entered by jge at 0x0046f7e7, 17 instruction(s), calls FUN_0051ea75, FUN_00448d11, FUN_0051e7ba, falls into the block at 0x0046f8a0
    mov edx, dword ptr [ebp - local_10]          # 0046f866
    mov eax, dword ptr [edx - field_minus_8]     # 0046f869
    mov dword ptr [ebp - local_1c], eax          # 0046f86c
    push 0x0                                     # 0046f86f
    push -0x1                                    # 0046f871
    mov ecx, dword ptr [ebp - local_1c]          # 0046f873
    push ecx                                     # 0046f876
    lea ecx, [ebp - local_10]                    # 0046f877
    call FUN_0051ea75                            # 0046f87a
    push eax                                     # 0046f87f
    mov edx, dword ptr [0x5d03b3]                # 0046f880
    push edx                                     # 0046f886
    mov ecx, 0x619a05                            # 0046f887
    call FUN_00448d11                            # 0046f88c
    mov dword ptr [ebp - local_4], 0xffffffff    # 0046f891
    lea ecx, [ebp - local_10]                    # 0046f898
    call FUN_0051e7ba                            # 0046f89b
L_0046f8a0:
    # block 0x0046f8a0: entered by je at 0x0046f7a1, 5 instruction(s), ends with ret
    mov ecx, dword ptr [ebp - local_c]           # 0046f8a0
    mov dword ptr fs:[0x0], ecx                  # 0046f8a3
    {load} mov esp, ebp                          # 0046f8aa
    pop ebp                                      # 0046f8ac
    ret                                          # 0046f8ad

