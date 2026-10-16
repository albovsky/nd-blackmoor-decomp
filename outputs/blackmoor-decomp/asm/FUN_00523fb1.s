# FUN_00523fb1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00523fb1
# extent:       0x00523fb1-0x00523fe6 (53 code bytes)
# span:         0x00523fb1-0x00523fe6 (code 53, tables 0, padding 0)
# sha256:       d80b835a09bcde4a32960c1389cf15b21ae02d18bcd279e2107e36cee6612207
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00523ef2 (+0xbf)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00523fb1
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edi + n] field_4; [esi + n] field_4, field_1c; [esp + n] stk_8
# callees:      calls FUN_00523f7d, FUN_0051d526; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x00523fe6
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0051d526, .text + (0x0051d526 - 0x401000)
.set FUN_00523f7d, .text + (0x00523f7d - 0x401000)

.org 0x00523fb1 - 0x401000
.globl FUN_00523fb1
FUN_00523fb1:
    # block 0x00523fb1: entry, 6 instruction(s), calls FUN_00523f7d, ends with je to 0x00523fdb (forward)
    push esi                                     # 00523fb1
    mov esi, dword ptr [esp + stk_8]             # 00523fb2
    push dword ptr [esi + field_4]               # 00523fb6
    call FUN_00523f7d                            # 00523fb9
    test eax, eax                                # 00523fbe
    je.d8 L_00523fdb                             # 00523fc0
    # block 0x00523fc2: entered by fall-through of je at 0x00523fc0, 11 instruction(s), calls FUN_0051d526, indirect dword ptr [edi + 0x4], ends with forward jump to 0x00523fe2
    push edi                                     # 00523fc2
    mov edi, dword ptr [esi]                     # 00523fc3
    {load} mov ecx, eax                          # 00523fc5
    call FUN_0051d526                            # 00523fc7
    shr eax, 0x1c                                # 00523fcc
    and eax, 0x1                                 # 00523fcf
    {load} mov ecx, esi                          # 00523fd2
    push eax                                     # 00523fd4
    call dword ptr [edi + field_4]               # 00523fd5
    pop edi                                      # 00523fd8
    jmp.d8 L_00523fe2                            # 00523fd9
L_00523fdb:
    # block 0x00523fdb: entered by je at 0x00523fc0, 1 instruction(s), falls into the block at 0x00523fe2
    mov dword ptr [esi + field_1c], 0x1          # 00523fdb
L_00523fe2:
    # block 0x00523fe2: entered by jmp at 0x00523fd9, 2 instruction(s), ends with ret 0x4
    pop esi                                      # 00523fe2
    ret 0x4                                      # 00523fe3

