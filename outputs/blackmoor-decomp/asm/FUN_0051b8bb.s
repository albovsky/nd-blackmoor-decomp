# FUN_0051b8bb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051b8bb
# extent:       0x0051b8bb-0x0051b99d (226 code bytes)
# span:         0x0051b8bb-0x0051b99d (code 226, tables 0, padding 0)
# sha256:       f09614dcaf5138e58fd1cea97dba93c2fcecb43bfa6c4c908db7df06880d2342
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051b8bb
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_8c, field_b0, field_f0; [ebp + n] field_8, field_c, field_minus_4, field_minus_c, field_minus_10; [esi + n] field_1c
# callees:      calls FUN_0050f978, FUN_00525371, FUN_0051d97f, FUN_0051c22e, FUN_0051c14c, USER32.dll!GetCapture, USER32.dll!WinHelpA, FUN_005213d4, FUN_0051d994; plus 5 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 82 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x0051b99d
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_8c, 0x8c  # offset +0x8c
.equ field_b0, 0xb0  # offset +0xb0
.equ field_f0, 0xf0  # offset +0xf0

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051c14c, .text + (0x0051c14c - 0x401000)
.set FUN_0051c22e, .text + (0x0051c22e - 0x401000)
.set FUN_0051d97f, .text + (0x0051d97f - 0x401000)
.set FUN_0051d994, .text + (0x0051d994 - 0x401000)
.set FUN_005213d4, .text + (0x005213d4 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x0051b8bb - 0x401000
.globl FUN_0051b8bb
FUN_0051b8bb:
    # block 0x0051b8bb: entry, 19 instruction(s), calls FUN_0050f978, FUN_00525371, FUN_0051d97f, indirect dword ptr [eax + 0xb0], ends with je to 0x0051b8ff (forward)
    mov eax, 0x528b94                            # 0051b8bb
    call FUN_0050f978                            # 0051b8c0
    push ecx                                     # 0051b8c5
    push ebx                                     # 0051b8c6
    push esi                                     # 0051b8c7
    {load} mov esi, ecx                          # 0051b8c8
    call FUN_00525371                            # 0051b8ca
    mov eax, dword ptr [eax + field_4]           # 0051b8cf
    mov dword ptr [ebp - field_minus_10], eax    # 0051b8d2
    call FUN_00525371                            # 0051b8d5
    mov ecx, dword ptr [eax + field_4]           # 0051b8da
    call FUN_0051d97f                            # 0051b8dd
    mov eax, dword ptr [esi]                     # 0051b8e2
    {load} xor ebx, ebx                          # 0051b8e4
    {load} mov ecx, esi                          # 0051b8e6
    mov dword ptr [ebp - field_minus_4], ebx     # 0051b8e8
    call dword ptr [eax + field_b0]              # 0051b8eb
    test eax, eax                                # 0051b8f1
    je.d8 L_0051b8ff                             # 0051b8f3
    # block 0x0051b8f5: entered by fall-through of je at 0x0051b8f3, 3 instruction(s), calls indirect dword ptr [eax + 0xf0], falls into the block at 0x0051b8ff
    mov eax, dword ptr [esi]                     # 0051b8f5
    {load} mov ecx, esi                          # 0051b8f7
    call dword ptr [eax + field_f0]              # 0051b8f9
L_0051b8ff:
    # block 0x0051b8ff: entered by je at 0x0051b8f3, 32 instruction(s), calls indirect edi, FUN_0051c22e, FUN_0051c14c, USER32.dll!GetCapture, ends with je to 0x0051b952 (forward)
    push edi                                     # 0051b8ff
    mov edi, dword ptr [0x52a4c8]                # 0051b900
    push ebx                                     # 0051b906
    push ebx                                     # 0051b907
    push 0x1f                                    # 0051b908
    push dword ptr [esi + field_1c]              # 0051b90a
    call edi                                     # 0051b90d
    push 0x1                                     # 0051b90f
    push 0x1                                     # 0051b911
    push ebx                                     # 0051b913
    push ebx                                     # 0051b914
    push 0x1f                                    # 0051b915
    push dword ptr [esi + field_1c]              # 0051b917
    call FUN_0051c22e                            # 0051b91a
    {load} mov ecx, esi                          # 0051b91f
    call FUN_0051c14c                            # 0051b921
    push ebx                                     # 0051b926
    {load} mov esi, eax                          # 0051b927
    push ebx                                     # 0051b929
    push 0x1f                                    # 0051b92a
    push dword ptr [esi + field_1c]              # 0051b92c
    call edi                                     # 0051b92f
    push 0x1                                     # 0051b931
    push 0x1                                     # 0051b933
    push ebx                                     # 0051b935
    push ebx                                     # 0051b936
    push 0x1f                                    # 0051b937
    push dword ptr [esi + field_1c]              # 0051b939
    call FUN_0051c22e                            # 0051b93c
    call dword ptr [0x52a3e0]                    # 0051b941
    {load} cmp eax, ebx                          # 0051b947
    je.d8 L_0051b952                             # 0051b949
    # block 0x0051b94b: entered by fall-through of je at 0x0051b949, 5 instruction(s), calls indirect edi, falls into the block at 0x0051b952
    push ebx                                     # 0051b94b
    push ebx                                     # 0051b94c
    push 0x1f                                    # 0051b94d
    push eax                                     # 0051b94f
    call edi                                     # 0051b950
L_0051b952:
    # block 0x0051b952: entered by je at 0x0051b949, 9 instruction(s), calls USER32.dll!WinHelpA, ends with jne to 0x0051b97c (forward)
    push dword ptr [ebp + field_8]               # 0051b952
    mov eax, dword ptr [ebp - field_minus_10]    # 0051b955
    push dword ptr [ebp + field_c]               # 0051b958
    push dword ptr [eax + field_8c]              # 0051b95b
    push dword ptr [esi + field_1c]              # 0051b961
    call dword ptr [0x52a3e4]                    # 0051b964
    test eax, eax                                # 0051b96a
    pop edi                                      # 0051b96c
    jne.d8 L_0051b97c                            # 0051b96d
    # block 0x0051b96f: entered by fall-through of jne at 0x0051b96d, 4 instruction(s), calls FUN_005213d4, falls into the block at 0x0051b97c
    push -0x1                                    # 0051b96f
    push ebx                                     # 0051b971
    push 0xf107                                  # 0051b972
    call FUN_005213d4                            # 0051b977
L_0051b97c:
    # block 0x0051b97c: entered by jne at 0x0051b96d, 10 instruction(s), calls FUN_00525371, FUN_0051d994, ends with ret 0x8
    or dword ptr [ebp - field_minus_4], -0x1     # 0051b97c
    call FUN_00525371                            # 0051b980
    mov ecx, dword ptr [eax + field_4]           # 0051b985
    call FUN_0051d994                            # 0051b988
    mov ecx, dword ptr [ebp - field_minus_c]     # 0051b98d
    pop esi                                      # 0051b990
    pop ebx                                      # 0051b991
    mov dword ptr fs:[0x0], ecx                  # 0051b992
    leave                                        # 0051b999
    ret 0x8                                      # 0051b99a

