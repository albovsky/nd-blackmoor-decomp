# FUN_00521b51
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00521b51
# extent:       0x00521b51-0x00521bcb (122 code bytes)
# span:         0x00521b51-0x00521bcb (code 122, tables 0, padding 0)
# sha256:       8e43b5f46c6fe0a432f443991469c7f99bc6346a305c6355bc6ce15090300f25
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00521b51
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_c, field_a8; [ecx + n] field_1c; [edi + n] field_68; [esi + n] field_5c, field_68, field_6c; [esp + n] stk_8
# callees:      calls USER32.dll!GetParent, FUN_0051abe4, FUN_0051f5ab
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 51 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_5c, 0x5c  # offset +0x5c
.equ field_68, 0x68  # offset +0x68
.equ field_6c, 0x6c  # offset +0x6c
.equ field_a8, 0xa8  # offset +0xa8

# --- external targets -----------------------------------------------
.set FUN_0051abe4, .text + (0x0051abe4 - 0x401000)
.set FUN_0051f5ab, .text + (0x0051f5ab - 0x401000)

.org 0x00521b51 - 0x401000
.globl FUN_00521b51
FUN_00521b51:
    # block 0x00521b51: entry, 6 instruction(s), ends with je to 0x00521bbe (forward)
    push ebx                                     # 00521b51
    mov ebx, dword ptr [esp + stk_8]             # 00521b52
    push esi                                     # 00521b56
    cmp ebx, -0x1                                # 00521b57
    push edi                                     # 00521b5a
    je.d8 L_00521bbe                             # 00521b5b
    # block 0x00521b5d: entered by fall-through of je at 0x00521b5b, 2 instruction(s), ends with je to 0x00521bbe (forward)
    test ebx, ebx                                # 00521b5d
    je.d8 L_00521bbe                             # 00521b5f
    # block 0x00521b61: entered by fall-through of je at 0x00521b5f, 13 instruction(s), calls USER32.dll!GetParent, FUN_0051abe4, FUN_0051f5ab, ends with je to 0x00521bbe (forward)
    push dword ptr [ecx + field_1c]              # 00521b61
    call dword ptr [0x52a3dc]                    # 00521b64
    push eax                                     # 00521b6a
    call FUN_0051abe4                            # 00521b6b
    {load} mov edi, eax                          # 00521b70
    push edi                                     # 00521b72
    push 0x52ee58                                # 00521b73
    call FUN_0051f5ab                            # 00521b78
    {load} mov esi, eax                          # 00521b7d
    pop ecx                                      # 00521b7f
    test esi, esi                                # 00521b80
    pop ecx                                      # 00521b82
    je.d8 L_00521bbe                             # 00521b83
    # block 0x00521b85: entered by fall-through of je at 0x00521b83, 7 instruction(s), calls FUN_0051f5ab, ends with je to 0x00521b9e (forward)
    push edi                                     # 00521b85
    push 0x52ee28                                # 00521b86
    call FUN_0051f5ab                            # 00521b8b
    pop ecx                                      # 00521b90
    test eax, eax                                # 00521b91
    pop ecx                                      # 00521b93
    je.d8 L_00521b9e                             # 00521b94
    # block 0x00521b96: entered by fall-through of je at 0x00521b94, 2 instruction(s), ends with forward jump to 0x00521ba1
    mov eax, dword ptr [eax + field_a8]          # 00521b96
    jmp.d8 L_00521ba1                            # 00521b9c
L_00521b9e:
    # block 0x00521b9e: entered by je at 0x00521b94, 1 instruction(s), falls into the block at 0x00521ba1
    mov eax, dword ptr [esi + field_5c]          # 00521b9e
L_00521ba1:
    # block 0x00521ba1: entered by jmp at 0x00521b9c, 4 instruction(s), ends with jle to 0x00521bbe (forward)
    mov ecx, dword ptr [esi + field_6c]          # 00521ba1
    {load} xor edx, edx                          # 00521ba4
    test ecx, ecx                                # 00521ba6
    jle.d8 L_00521bbe                            # 00521ba8
    # block 0x00521baa: entered by fall-through of jle at 0x00521ba8, 1 instruction(s), falls into the block at 0x00521bad
    mov esi, dword ptr [esi + field_68]          # 00521baa
L_00521bad:
    # block 0x00521bad: entered by jl at 0x00521bbc, 3 instruction(s), ends with je to 0x00521bc6 (forward)
    mov edi, dword ptr [esi]                     # 00521bad
    cmp dword ptr [edi + field_68], ebx          # 00521baf
    je.d8 L_00521bc6                             # 00521bb2
    # block 0x00521bb4: entered by fall-through of je at 0x00521bb2, 5 instruction(s), ends with jl to 0x00521bad (backward)
    add eax, dword ptr [eax]                     # 00521bb4
    inc edx                                      # 00521bb6
    add esi, 0x4                                 # 00521bb7
    {load} cmp edx, ecx                          # 00521bba
    jl.d8 L_00521bad                             # 00521bbc
L_00521bbe:
    # block 0x00521bbe: entered by je at 0x00521b5b; je at 0x00521b5f; je at 0x00521b83; jle at 0x00521ba8; more, 1 instruction(s), falls into the block at 0x00521bc0
    {load} mov eax, ebx                          # 00521bbe
L_00521bc0:
    # block 0x00521bc0: entered by jmp at 0x00521bc9, 4 instruction(s), ends with ret 0x4
    pop edi                                      # 00521bc0
    pop esi                                      # 00521bc1
    pop ebx                                      # 00521bc2
    ret 0x4                                      # 00521bc3
L_00521bc6:
    # block 0x00521bc6: entered by je at 0x00521bb2, 2 instruction(s), ends with backward jump to 0x00521bc0
    mov eax, dword ptr [eax + field_c]           # 00521bc6
    jmp.d8 L_00521bc0                            # 00521bc9

