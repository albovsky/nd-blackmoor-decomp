# FUN_0051a94c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a94c
# extent:       0x0051a94c-0x0051a9ad (97 code bytes)
# span:         0x0051a94c-0x0051a9ad (code 97, tables 0, padding 0)
# sha256:       790f7707de5feb899c13c3d7c08bbc685251f64b50e4c2751253e91e395c69cb
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a94c
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is not read in the entry block before being written
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [ebx + n] field_1c; [edi + n] field_1c; [esi + n] field_1c
# callees:      calls FUN_0051d526, FUN_0051c14c, USER32.dll!SendMessageA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 39 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0051c14c, .text + (0x0051c14c - 0x401000)
.set FUN_0051d526, .text + (0x0051d526 - 0x401000)

.org 0x0051a94c - 0x401000
.globl FUN_0051a94c
FUN_0051a94c:
    # block 0x0051a94c: entry, 12 instruction(s), calls FUN_0051d526, ends with jne to 0x0051a9a6 (forward)
    push ebp                                     # 0051a94c
    {load} mov ebp, esp                          # 0051a94d
    push ecx                                     # 0051a94f
    push ecx                                     # 0051a950
    push ebx                                     # 0051a951
    push esi                                     # 0051a952
    mov esi, dword ptr [ebp + arg_8]             # 0051a953
    push edi                                     # 0051a956
    {load} mov ecx, esi                          # 0051a957
    call FUN_0051d526                            # 0051a959
    test eax, 0x40000000                         # 0051a95e
    jne.d8 L_0051a9a6                            # 0051a963
    # block 0x0051a965: entered by fall-through of jne at 0x0051a963, 8 instruction(s), calls FUN_0051c14c, ends with je to 0x0051a9a6 (forward)
    {load} mov ecx, esi                          # 0051a965
    call FUN_0051c14c                            # 0051a967
    mov edi, dword ptr [ebp + arg_10]            # 0051a96c
    {load} mov ebx, eax                          # 0051a96f
    {load} mov ecx, edi                          # 0051a971
    call FUN_0051c14c                            # 0051a973
    {load} cmp ebx, eax                          # 0051a978
    je.d8 L_0051a9a6                             # 0051a97a
    # block 0x0051a97c: entered by fall-through of je at 0x0051a97a, 4 instruction(s), ends with jne to 0x0051a98b (forward)
    mov eax, dword ptr [esi + field_1c]          # 0051a97c
    test edi, edi                                # 0051a97f
    mov dword ptr [ebp - local_8], eax           # 0051a981
    jne.d8 L_0051a98b                            # 0051a984
    # block 0x0051a986: entered by fall-through of jne at 0x0051a984, 2 instruction(s), ends with forward jump to 0x0051a991
    and dword ptr [ebp - local_4], edi           # 0051a986
    jmp.d8 L_0051a991                            # 0051a989
L_0051a98b:
    # block 0x0051a98b: entered by jne at 0x0051a984, 2 instruction(s), falls into the block at 0x0051a991
    mov eax, dword ptr [edi + field_1c]          # 0051a98b
    mov dword ptr [ebp - local_4], eax           # 0051a98e
L_0051a991:
    # block 0x0051a991: entered by jmp at 0x0051a989, 6 instruction(s), calls USER32.dll!SendMessageA, falls into the block at 0x0051a9a6
    lea eax, [ebp - local_8]                     # 0051a991
    push eax                                     # 0051a994
    push dword ptr [ebp + arg_c]                 # 0051a995
    push 0x36e                                   # 0051a998
    push dword ptr [ebx + field_1c]              # 0051a99d
    call dword ptr [0x52a4c8]                    # 0051a9a0
L_0051a9a6:
    # block 0x0051a9a6: entered by jne at 0x0051a963; je at 0x0051a97a, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 0051a9a6
    pop esi                                      # 0051a9a7
    pop ebx                                      # 0051a9a8
    leave                                        # 0051a9a9
    ret 0xc                                      # 0051a9aa

