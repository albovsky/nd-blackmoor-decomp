# FUN_00524157
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524157
# extent:       0x00524157-0x00524186 (47 code bytes)
# span:         0x00524157-0x00524186 (code 47, tables 0, padding 0)
# sha256:       176fcefb873ddcc67af2a4ee3b040896ffddba0a47d1b85312385347ac1ceca8
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524157
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_1c; [esi + n] field_50; [esp + n] stk_8
# callees:      calls FUN_0050c193; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 17 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_50, 0x50  # offset +0x50

# --- external targets -----------------------------------------------
.set FUN_0050c193, .text + (0x0050c193 - 0x401000)

.org 0x00524157 - 0x401000
.globl FUN_00524157
FUN_00524157:
    # block 0x00524157: entry, 5 instruction(s), calls FUN_0050c193, ends with jne to 0x00524177 (forward)
    push esi                                     # 00524157
    {load} mov esi, ecx                          # 00524158
    call FUN_0050c193                            # 0052415a
    {load} cmp eax, esi                          # 0052415f
    jne.d8 L_00524177                            # 00524161
    # block 0x00524163: entered by fall-through of jne at 0x00524161, 8 instruction(s), calls indirect dword ptr [eax + 0x4], ends with forward jump to 0x00524182
    mov ecx, dword ptr [esp + stk_8]             # 00524163
    {load} xor edx, edx                          # 00524167
    cmp dword ptr [esi + field_50], edx          # 00524169
    mov eax, dword ptr [ecx]                     # 0052416c
    setne dl                                     # 0052416e
    push edx                                     # 00524171
    call dword ptr [eax + field_4]               # 00524172
    jmp.d8 L_00524182                            # 00524175
L_00524177:
    # block 0x00524177: entered by jne at 0x00524161, 2 instruction(s), falls into the block at 0x00524182
    mov eax, dword ptr [esp + stk_8]             # 00524177
    mov dword ptr [eax + field_1c], 0x1          # 0052417b
L_00524182:
    # block 0x00524182: entered by jmp at 0x00524175, 2 instruction(s), ends with ret 0x4
    pop esi                                      # 00524182
    ret 0x4                                      # 00524183

