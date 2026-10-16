# FUN_0051f3d4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051f3d4
# extent:       0x0051f3d4-0x0051f40b (55 code bytes)
# span:         0x0051f3d4-0x0051f40b (code 55, tables 0, padding 0)
# sha256:       9b290f83b03f8d5edb5b34f7a17ff151b012b43340dd6d7360e81b60f296e448
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051f3d4
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_6c; [edi + n] field_84; [esi + n] field_1c; [esp + n] stk_10
# callees:      calls FUN_0050c193, USER32.dll!PostMessageA; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x0051f40b
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c
.equ field_6c, 0x6c  # offset +0x6c
.equ field_84, 0x84  # offset +0x84

# --- external targets -----------------------------------------------
.set FUN_0050c193, .text + (0x0050c193 - 0x401000)

.org 0x0051f3d4 - 0x401000
.globl FUN_0051f3d4
FUN_0051f3d4:
    # block 0x0051f3d4: entry, 20 instruction(s), calls FUN_0050c193, USER32.dll!PostMessageA, indirect dword ptr [eax + 0x6c], ends with ret 0x8
    push esi                                     # 0051f3d4
    push edi                                     # 0051f3d5
    {load} mov edi, ecx                          # 0051f3d6
    call FUN_0050c193                            # 0051f3d8
    {load} mov esi, eax                          # 0051f3dd
    {load} xor eax, eax                          # 0051f3df
    push eax                                     # 0051f3e1
    push eax                                     # 0051f3e2
    push 0x36a                                   # 0051f3e3
    mov dword ptr [edi + field_84], eax          # 0051f3e8
    push dword ptr [esi + field_1c]              # 0051f3ee
    call dword ptr [0x52a31c]                    # 0051f3f1
    push dword ptr [esp + stk_10]                # 0051f3f7
    mov eax, dword ptr [esi]                     # 0051f3fb
    {load} mov ecx, esi                          # 0051f3fd
    push dword ptr [esp + stk_10]                # 0051f3ff
    call dword ptr [eax + field_6c]              # 0051f403
    pop edi                                      # 0051f406
    pop esi                                      # 0051f407
    ret 0x8                                      # 0051f408

