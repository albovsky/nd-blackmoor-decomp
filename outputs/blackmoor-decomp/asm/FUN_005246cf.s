# FUN_005246cf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005246cf
# extent:       0x005246cf-0x005246ee (31 code bytes)
# span:         0x005246cf-0x005246ee (code 31, tables 0, padding 0)
# sha256:       9ec260f4aaca74278849cf98d444632f06d9e9c32c8dd90f7b2e162ae05b24e9
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005246cf
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_c8; [esp + n] stk_8
# callees:      calls FUN_0051ab4b; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x005246ee
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_c8, 0xc8  # offset +0xc8

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)

.org 0x005246cf - 0x401000
.globl FUN_005246cf
FUN_005246cf:
    # block 0x005246cf: entry, 5 instruction(s), calls FUN_0051ab4b, ends with je to 0x005246ea (forward)
    push esi                                     # 005246cf
    {load} mov esi, ecx                          # 005246d0
    call FUN_0051ab4b                            # 005246d2
    cmp dword ptr [esp + stk_8], 0x1             # 005246d7
    je.d8 L_005246ea                             # 005246dc
    # block 0x005246de: entered by fall-through of je at 0x005246dc, 4 instruction(s), calls indirect dword ptr [eax + 0xc8], falls into the block at 0x005246ea
    mov eax, dword ptr [esi]                     # 005246de
    push 0x1                                     # 005246e0
    {load} mov ecx, esi                          # 005246e2
    call dword ptr [eax + field_c8]              # 005246e4
L_005246ea:
    # block 0x005246ea: entered by je at 0x005246dc, 2 instruction(s), ends with ret 0xc
    pop esi                                      # 005246ea
    ret 0xc                                      # 005246eb

