# FUN_005209a3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005209a3
# extent:       0x005209a3-0x00520a19 (118 code bytes)
# span:         0x005209a3-0x00520a19 (code 118, tables 0, padding 0)
# sha256:       7eb421bbcda030773cb254a5a3fcd2ea52af6b55cb70bb15735a58de876d7fea
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005209a3
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x10 (callee pops 16 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_50, field_54, field_58, field_68, field_84; [esi + n] field_1c; [esp + n] stk_1c
# callees:      calls FUN_0051ec6f, FUN_00525371, FUN_0052640e, FUN_005269a5; plus 5 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 46 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x00520a19
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_1c, 0x1c  # offset +0x1c
.equ field_1c, 0x1c  # offset +0x1c
.equ field_50, 0x50  # offset +0x50
.equ field_54, 0x54  # offset +0x54
.equ field_58, 0x58  # offset +0x58
.equ field_68, 0x68  # offset +0x68
.equ field_84, 0x84  # offset +0x84

# --- external targets -----------------------------------------------
.set FUN_0051ec6f, .text + (0x0051ec6f - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)
.set FUN_0052640e, .text + (0x0052640e - 0x401000)
.set FUN_005269a5, .text + (0x005269a5 - 0x401000)

.org 0x005209a3 - 0x401000
.globl FUN_005209a3
FUN_005209a3:
    # block 0x005209a3: entry, 15 instruction(s), calls FUN_0051ec6f, FUN_00525371, FUN_0052640e, ends with je to 0x00520a0c (forward)
    push ebx                                     # 005209a3
    push esi                                     # 005209a4
    push edi                                     # 005209a5
    or ebx, -0x1                                 # 005209a6
    call FUN_0051ec6f                            # 005209a9
    {load} mov esi, eax                          # 005209ae
    call FUN_00525371                            # 005209b0
    push dword ptr [esp + stk_1c]                # 005209b5
    mov edi, dword ptr [eax + field_4]           # 005209b9
    push dword ptr [esp + stk_1c]                # 005209bc
    push dword ptr [esp + stk_1c]                # 005209c0
    push dword ptr [esp + stk_1c]                # 005209c4
    call FUN_0052640e                            # 005209c8
    test eax, eax                                # 005209cd
    je.d8 L_00520a0c                             # 005209cf
    # block 0x005209d1: entered by fall-through of je at 0x005209cf, 2 instruction(s), ends with je to 0x005209e3 (forward)
    test edi, edi                                # 005209d1
    je.d8 L_005209e3                             # 005209d3
    # block 0x005209d5: entered by fall-through of je at 0x005209d3, 5 instruction(s), calls indirect dword ptr [eax + 0x84], ends with je to 0x00520a0c (forward)
    mov eax, dword ptr [edi]                     # 005209d5
    {load} mov ecx, edi                          # 005209d7
    call dword ptr [eax + field_84]              # 005209d9
    test eax, eax                                # 005209df
    je.d8 L_00520a0c                             # 005209e1
L_005209e3:
    # block 0x005209e3: entered by je at 0x005209d3; fall-through of je at 0x005209e1, 5 instruction(s), calls indirect dword ptr [eax + 0x50], ends with jne to 0x00520a03 (forward)
    mov eax, dword ptr [esi]                     # 005209e3
    {load} mov ecx, esi                          # 005209e5
    call dword ptr [eax + field_50]              # 005209e7
    test eax, eax                                # 005209ea
    jne.d8 L_00520a03                            # 005209ec
    # block 0x005209ee: entered by fall-through of jne at 0x005209ec, 3 instruction(s), ends with je to 0x005209fa (forward)
    mov ecx, dword ptr [esi + field_1c]          # 005209ee
    test ecx, ecx                                # 005209f1
    je.d8 L_005209fa                             # 005209f3
    # block 0x005209f5: entered by fall-through of je at 0x005209f3, 2 instruction(s), calls indirect dword ptr [eax + 0x58], falls into the block at 0x005209fa
    mov eax, dword ptr [ecx]                     # 005209f5
    call dword ptr [eax + field_58]              # 005209f7
L_005209fa:
    # block 0x005209fa: entered by je at 0x005209f3, 4 instruction(s), calls indirect dword ptr [eax + 0x68], ends with forward jump to 0x00520a0a
    mov eax, dword ptr [esi]                     # 005209fa
    {load} mov ecx, esi                          # 005209fc
    call dword ptr [eax + field_68]              # 005209fe
    jmp.d8 L_00520a0a                            # 00520a01
L_00520a03:
    # block 0x00520a03: entered by jne at 0x005209ec, 3 instruction(s), calls indirect dword ptr [eax + 0x54], falls into the block at 0x00520a0a
    mov eax, dword ptr [esi]                     # 00520a03
    {load} mov ecx, esi                          # 00520a05
    call dword ptr [eax + field_54]              # 00520a07
L_00520a0a:
    # block 0x00520a0a: entered by jmp at 0x00520a01, 1 instruction(s), falls into the block at 0x00520a0c
    {load} mov ebx, eax                          # 00520a0a
L_00520a0c:
    # block 0x00520a0c: entered by je at 0x005209cf; je at 0x005209e1, 6 instruction(s), calls FUN_005269a5, ends with ret 0x10
    call FUN_005269a5                            # 00520a0c
    pop edi                                      # 00520a11
    {load} mov eax, ebx                          # 00520a12
    pop esi                                      # 00520a14
    pop ebx                                      # 00520a15
    ret 0x10                                     # 00520a16

