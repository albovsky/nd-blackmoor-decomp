# FUN_00523ab8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00523ab8
# extent:       0x00523ab8-0x00523ad6 (30 code bytes)
# span:         0x00523ab8-0x00523ad6 (code 30, tables 0, padding 0)
# sha256:       ca07ca6abca900d5d3aa6bf4dc56a5bba4ff149240d8dfa2359a23b901c25a9e
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00523ab8
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_78; [esi + n] field_68; [esp + n] stk_8
# callees:      calls FUN_0051ab4b; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_68, 0x68  # offset +0x68
.equ field_78, 0x78  # offset +0x78

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)

.org 0x00523ab8 - 0x401000
.globl FUN_00523ab8
FUN_00523ab8:
    # block 0x00523ab8: entry, 5 instruction(s), ends with je to 0x00523acb (forward)
    push esi                                     # 00523ab8
    {load} mov esi, ecx                          # 00523ab9
    mov ecx, dword ptr [esi + field_68]          # 00523abb
    test ecx, ecx                                # 00523abe
    je.d8 L_00523acb                             # 00523ac0
    # block 0x00523ac2: entered by fall-through of je at 0x00523ac0, 3 instruction(s), calls indirect dword ptr [eax + 0x78], falls into the block at 0x00523acb
    mov eax, dword ptr [ecx]                     # 00523ac2
    push dword ptr [esp + stk_8]                 # 00523ac4
    call dword ptr [eax + field_78]              # 00523ac8
L_00523acb:
    # block 0x00523acb: entered by je at 0x00523ac0, 4 instruction(s), calls FUN_0051ab4b, ends with ret 0x4
    {load} mov ecx, esi                          # 00523acb
    call FUN_0051ab4b                            # 00523acd
    pop esi                                      # 00523ad2
    ret 0x4                                      # 00523ad3

