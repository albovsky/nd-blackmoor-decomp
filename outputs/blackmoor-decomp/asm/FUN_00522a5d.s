# FUN_00522a5d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00522a5d
# extent:       0x00522a5d-0x00522ac8 (107 code bytes)
# span:         0x00522a5d-0x00522ac8 (code 107, tables 0, padding 0)
# sha256:       c3a39a69062816758ec02ea5267dbdd0f5df378abb162bb79edeecd641c63ff4
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00522a3c (+0x21)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00522a5d
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_50; [esi + n] field_1c, field_50; [esp + n] stk_20
# callees:      calls USER32.dll!PeekMessageA, USER32.dll!GetCapture, USER32.dll!ReleaseCapture, FUN_0051c174; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 44 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ field_50, 0x50  # offset +0x50

# --- external targets -----------------------------------------------
.set FUN_0051c174, .text + (0x0051c174 - 0x401000)

.org 0x00522a5d - 0x401000
.globl FUN_00522a5d
FUN_00522a5d:
    # block 0x00522a5d: entry, 7 instruction(s), ends with je to 0x00522ac2 (forward)
    sub esp, 0x1c                                # 00522a5d
    push ebp                                     # 00522a60
    push esi                                     # 00522a61
    {load} mov esi, ecx                          # 00522a62
    {load} xor ebp, ebp                          # 00522a64
    cmp dword ptr [esi + field_50], ebp          # 00522a66
    je.d8 L_00522ac2                             # 00522a69
    # block 0x00522a6b: entered by fall-through of je at 0x00522a69, 13 instruction(s), calls USER32.dll!PeekMessageA, ends with jne to 0x00522a96 (forward)
    push ebx                                     # 00522a6b
    push edi                                     # 00522a6c
    mov edi, 0x367                               # 00522a6d
    push 0x3                                     # 00522a72
    push edi                                     # 00522a74
    push edi                                     # 00522a75
    push dword ptr [esi + field_1c]              # 00522a76
    lea eax, [esp + stk_20]                      # 00522a79
    push eax                                     # 00522a7d
    call dword ptr [0x52a4c0]                    # 00522a7e
    mov ebx, dword ptr [0x52a31c]                # 00522a84
    test eax, eax                                # 00522a8a
    jne.d8 L_00522a96                            # 00522a8c
    # block 0x00522a8e: entered by fall-through of jne at 0x00522a8c, 5 instruction(s), calls indirect ebx, falls into the block at 0x00522a96
    push ebp                                     # 00522a8e
    push ebp                                     # 00522a8f
    push edi                                     # 00522a90
    push dword ptr [esi + field_1c]              # 00522a91
    call ebx                                     # 00522a94
L_00522a96:
    # block 0x00522a96: entered by jne at 0x00522a8c, 3 instruction(s), calls USER32.dll!GetCapture, ends with jne to 0x00522aa7 (forward)
    call dword ptr [0x52a3e0]                    # 00522a96
    cmp eax, dword ptr [esi + field_1c]          # 00522a9c
    jne.d8 L_00522aa7                            # 00522a9f
    # block 0x00522aa1: entered by fall-through of jne at 0x00522a9f, 1 instruction(s), calls USER32.dll!ReleaseCapture, falls into the block at 0x00522aa7
    call dword ptr [0x52a380]                    # 00522aa1
L_00522aa7:
    # block 0x00522aa7: entered by jne at 0x00522a9f, 11 instruction(s), calls FUN_0051c174, indirect ebx, falls into the block at 0x00522ac2
    {load} mov ecx, esi                          # 00522aa7
    call FUN_0051c174                            # 00522aa9
    push ebp                                     # 00522aae
    push ebp                                     # 00522aaf
    mov dword ptr [esi + field_50], ebp          # 00522ab0
    push 0x36a                                   # 00522ab3
    mov dword ptr [eax + field_50], ebp          # 00522ab8
    push dword ptr [esi + field_1c]              # 00522abb
    call ebx                                     # 00522abe
    pop edi                                      # 00522ac0
    pop ebx                                      # 00522ac1
L_00522ac2:
    # block 0x00522ac2: entered by je at 0x00522a69, 4 instruction(s), ends with ret
    pop esi                                      # 00522ac2
    pop ebp                                      # 00522ac3
    add esp, 0x1c                                # 00522ac4
    ret                                          # 00522ac7

