# FUN_0051b4ac
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051b4ac
# extent:       0x0051b4ac-0x0051b4cb (31 code bytes)
# span:         0x0051b4ac-0x0051b4cb (code 31, tables 0, padding 0)
# sha256:       ce11f841e55f5b9bf29d50e003aeb1841bad333e2a3617e59ec1f94e82a494e3
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051b4ac
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1034; [esp + n] stk_c
# callees:      calls FUN_00525371; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x0051b4cb
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc
.equ field_1034, 0x1034  # offset +0x1034

# --- external targets -----------------------------------------------
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x0051b4ac - 0x401000
.globl FUN_0051b4ac
FUN_0051b4ac:
    # block 0x0051b4ac: entry, 6 instruction(s), calls FUN_00525371, ends with je to 0x0051b4c5 (forward)
    push esi                                     # 0051b4ac
    {load} mov esi, ecx                          # 0051b4ad
    call FUN_00525371                            # 0051b4af
    mov eax, dword ptr [eax + field_1034]        # 0051b4b4
    test eax, eax                                # 0051b4ba
    je.d8 L_0051b4c5                             # 0051b4bc
    # block 0x0051b4be: entered by fall-through of je at 0x0051b4bc, 3 instruction(s), calls indirect eax, falls into the block at 0x0051b4c5
    push esi                                     # 0051b4be
    push dword ptr [esp + stk_c]                 # 0051b4bf
    call eax                                     # 0051b4c3
L_0051b4c5:
    # block 0x0051b4c5: entered by je at 0x0051b4bc, 3 instruction(s), ends with ret 0x4
    {load} xor eax, eax                          # 0051b4c5
    pop esi                                      # 0051b4c7
    ret 0x4                                      # 0051b4c8

