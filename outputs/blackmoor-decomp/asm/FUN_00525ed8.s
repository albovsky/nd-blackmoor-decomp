# FUN_00525ed8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525ed8
# extent:       0x00525ed8-0x00525ef8 (32 code bytes)
# span:         0x00525ed8-0x00525ef8 (code 32, tables 0, padding 0)
# sha256:       0955d5e46fa388cee0a76d2d21042e5d92299a74270c88a665a811d1de8fed1c
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525ed8
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_00525ef8, FUN_0050c604
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050c604, .text + (0x0050c604 - 0x401000)
.set FUN_00525ef8, .text + (0x00525ef8 - 0x401000)

.org 0x00525ed8 - 0x401000
.globl FUN_00525ed8
FUN_00525ed8:
    # block 0x00525ed8: entry, 5 instruction(s), calls FUN_00525ef8, ends with je to 0x00525ef2 (forward)
    push esi                                     # 00525ed8
    {load} mov esi, ecx                          # 00525ed9
    call FUN_00525ef8                            # 00525edb
    test byte ptr [esp + stk_8], 0x1             # 00525ee0
    je.d8 L_00525ef2                             # 00525ee5
    # block 0x00525ee7: entered by fall-through of je at 0x00525ee5, 3 instruction(s), calls FUN_0050c604, falls into the block at 0x00525ef2
    push esi                                     # 00525ee7
    mov ecx, 0x63c7c0                            # 00525ee8
    call FUN_0050c604                            # 00525eed
L_00525ef2:
    # block 0x00525ef2: entered by je at 0x00525ee5, 3 instruction(s), ends with ret 0x4
    {load} mov eax, esi                          # 00525ef2
    pop esi                                      # 00525ef4
    ret 0x4                                      # 00525ef5

