# FUN_0050c604
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c604
# extent:       0x0050c604-0x0050c630 (44 code bytes)
# span:         0x0050c604-0x0050c630 (code 44, tables 0, padding 0)
# sha256:       a8c638ad8a872ebfb9ab416f6e006ad0b3b6530f06caf39f465c272dec9ed075
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c604
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_c, field_10; [esp + n] stk_c
# callees:      calls KERNEL32.dll!EnterCriticalSection, KERNEL32.dll!LeaveCriticalSection
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 19 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x0050c630
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------

.org 0x0050c604 - 0x401000
.globl FUN_0050c604
FUN_0050c604:
    # block 0x0050c604: entry, 6 instruction(s), ends with je to 0x0050c62b (forward)
    push esi                                     # 0050c604
    push edi                                     # 0050c605
    mov edi, dword ptr [esp + stk_c]             # 0050c606
    {load} mov esi, ecx                          # 0050c60a
    test edi, edi                                # 0050c60c
    je.d8 L_0050c62b                             # 0050c60e
    # block 0x0050c610: entered by fall-through of je at 0x0050c60e, 10 instruction(s), calls KERNEL32.dll!EnterCriticalSection, KERNEL32.dll!LeaveCriticalSection, falls into the block at 0x0050c62b
    push ebx                                     # 0050c610
    lea ebx, [esi + field_10]                    # 0050c611
    push ebx                                     # 0050c614
    call dword ptr [0x52a0d0]                    # 0050c615
    mov eax, dword ptr [esi + field_c]           # 0050c61b
    push ebx                                     # 0050c61e
    mov dword ptr [edi], eax                     # 0050c61f
    mov dword ptr [esi + field_c], edi           # 0050c621
    call dword ptr [0x52a0c8]                    # 0050c624
    pop ebx                                      # 0050c62a
L_0050c62b:
    # block 0x0050c62b: entered by je at 0x0050c60e, 3 instruction(s), ends with ret 0x4
    pop edi                                      # 0050c62b
    pop esi                                      # 0050c62c
    ret 0x4                                      # 0050c62d

