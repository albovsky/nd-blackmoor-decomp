# FUN_00522ed0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00522ed0
# extent:       0x00522ed0-0x00522f7a (170 code bytes)
# span:         0x00522ed0-0x00522f7a (code 170, tables 0, padding 0)
# sha256:       e1161ef5b4048afb46798f666df25b0de06fea52cb615076551c5235accd5a29
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00522ed0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edi + n] field_1c; [esi + n] field_25; [esp + n] stk_14, stk_18
# callees:      calls FUN_0051d526, FUN_0051c174, FUN_0051d657, USER32.dll!GetDesktopWindow, FUN_00522bd7; plus 4 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 65 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_25, 0x25  # offset +0x25

# --- external targets -----------------------------------------------
.set FUN_0051c174, .text + (0x0051c174 - 0x401000)
.set FUN_0051d526, .text + (0x0051d526 - 0x401000)
.set FUN_0051d657, .text + (0x0051d657 - 0x401000)
.set FUN_00522bd7, .text + (0x00522bd7 - 0x401000)

.org 0x00522ed0 - 0x401000
.globl FUN_00522ed0
FUN_00522ed0:
    # block 0x00522ed0: entry, 8 instruction(s), calls FUN_0051d526, ends with je to 0x00522ee6 (forward)
    push ebx                                     # 00522ed0
    push ebp                                     # 00522ed1
    push esi                                     # 00522ed2
    push edi                                     # 00522ed3
    {load} mov esi, ecx                          # 00522ed4
    call FUN_0051d526                            # 00522ed6
    test eax, 0x40000000                         # 00522edb
    je.d8 L_00522ee6                             # 00522ee0
    # block 0x00522ee2: entered by fall-through of je at 0x00522ee0, 2 instruction(s), ends with forward jump to 0x00522eef
    {load} mov edi, esi                          # 00522ee2
    jmp.d8 L_00522eef                            # 00522ee4
L_00522ee6:
    # block 0x00522ee6: entered by je at 0x00522ee0, 3 instruction(s), calls FUN_0051c174, falls into the block at 0x00522eef
    {load} mov ecx, esi                          # 00522ee6
    call FUN_0051c174                            # 00522ee8
    {load} mov edi, eax                          # 00522eed
L_00522eef:
    # block 0x00522eef: entered by jmp at 0x00522ee4, 3 instruction(s), ends with je to 0x00522f3c (forward)
    test byte ptr [esp + stk_14], 0xc            # 00522eef
    mov ebp, dword ptr [0x52a4c8]                # 00522ef4
    je.d8 L_00522f3c                             # 00522efa
    # block 0x00522efc: entered by fall-through of je at 0x00522efa, 6 instruction(s), calls FUN_0051d657, ends with je to 0x00522f2e (forward)
    {load} mov ecx, edi                          # 00522efc
    call FUN_0051d657                            # 00522efe
    mov ecx, dword ptr [esp + stk_14]            # 00522f03
    not ecx                                      # 00522f07
    test cl, 0x8                                 # 00522f09
    je.d8 L_00522f2e                             # 00522f0c
    # block 0x00522f0e: entered by fall-through of je at 0x00522f0c, 2 instruction(s), ends with je to 0x00522f2e (forward)
    test eax, eax                                # 00522f0e
    je.d8 L_00522f2e                             # 00522f10
    # block 0x00522f12: entered by fall-through of je at 0x00522f10, 2 instruction(s), ends with je to 0x00522f2e (forward)
    {load} cmp edi, esi                          # 00522f12
    je.d8 L_00522f2e                             # 00522f14
    # block 0x00522f16: entered by fall-through of je at 0x00522f14, 8 instruction(s), calls indirect ebp, ends with forward jump to 0x00522f3c
    or byte ptr [esi + field_25], 0x2            # 00522f16
    push 0x0                                     # 00522f1a
    push 0x1                                     # 00522f1c
    push 0x86                                    # 00522f1e
    push dword ptr [edi + field_1c]              # 00522f23
    call ebp                                     # 00522f26
    and byte ptr [esi + field_25], -0x3          # 00522f28
    jmp.d8 L_00522f3c                            # 00522f2c
L_00522f2e:
    # block 0x00522f2e: entered by je at 0x00522f0c; je at 0x00522f10; je at 0x00522f14, 5 instruction(s), calls indirect ebp, falls into the block at 0x00522f3c
    push 0x0                                     # 00522f2e
    push 0x0                                     # 00522f30
    push 0x86                                    # 00522f32
    push dword ptr [edi + field_1c]              # 00522f37
    call ebp                                     # 00522f3a
L_00522f3c:
    # block 0x00522f3c: entered by je at 0x00522efa; jmp at 0x00522f2c, 4 instruction(s), calls USER32.dll!GetDesktopWindow, falls into the block at 0x00522f4b
    push 0x5                                     # 00522f3c
    call dword ptr [0x52a384]                    # 00522f3e
    mov ebx, dword ptr [0x52a450]                # 00522f44
    push eax                                     # 00522f4a
L_00522f4b:
    # block 0x00522f4b: entered by jmp at 0x00522f71, 4 instruction(s), calls indirect ebx, ends with je to 0x00522f73 (forward)
    call ebx                                     # 00522f4b
    {load} mov esi, eax                          # 00522f4d
    test esi, esi                                # 00522f4f
    je.d8 L_00522f73                             # 00522f51
    # block 0x00522f53: entered by fall-through of je at 0x00522f51, 5 instruction(s), calls FUN_00522bd7, ends with je to 0x00522f6e (forward)
    push esi                                     # 00522f53
    push dword ptr [edi + field_1c]              # 00522f54
    call FUN_00522bd7                            # 00522f57
    test eax, eax                                # 00522f5c
    je.d8 L_00522f6e                             # 00522f5e
    # block 0x00522f60: entered by fall-through of je at 0x00522f5e, 5 instruction(s), calls indirect ebp, falls into the block at 0x00522f6e
    push 0x0                                     # 00522f60
    push dword ptr [esp + stk_18]                # 00522f62
    push 0x36d                                   # 00522f66
    push esi                                     # 00522f6b
    call ebp                                     # 00522f6c
L_00522f6e:
    # block 0x00522f6e: entered by je at 0x00522f5e, 3 instruction(s), ends with backward jump to 0x00522f4b
    push 0x2                                     # 00522f6e
    push esi                                     # 00522f70
    jmp.d8 L_00522f4b                            # 00522f71
L_00522f73:
    # block 0x00522f73: entered by je at 0x00522f51, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 00522f73
    pop esi                                      # 00522f74
    pop ebp                                      # 00522f75
    pop ebx                                      # 00522f76
    ret 0x4                                      # 00522f77

