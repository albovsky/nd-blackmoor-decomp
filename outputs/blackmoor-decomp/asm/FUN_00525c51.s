# FUN_00525c51
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525c51
# extent:       0x00525c51-0x00525c6b (26 code bytes)
# span:         0x00525c51-0x00525c6b (code 26, tables 0, padding 0)
# sha256:       94837170321b611ac915b28c85eaf008804ea31361412dcc250f68d93ffa1605
# evidence:     ev_d63d6a362278f40ee32ccb564ca8ec5738c7bbf1d9d11225df7a30f9c22e09d6
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525c51
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_00525ab6
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00525c6b
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00525ab6, .text + (0x00525ab6 - 0x401000)

.org 0x00525c51 - 0x401000
.globl FUN_00525c51
FUN_00525c51:
    # block 0x00525c51: entry, 3 instruction(s), ends with je to 0x00525c68 (forward)
    mov ecx, dword ptr [0x63c704]                # 00525c51
    test ecx, ecx                                # 00525c57
    je.d8 L_00525c68                             # 00525c59
    # block 0x00525c5b: entered by fall-through of je at 0x00525c59, 3 instruction(s), calls FUN_00525ab6, falls into the block at 0x00525c68
    push dword ptr [esp + stk_8]                 # 00525c5b
    push dword ptr [esp + stk_8]                 # 00525c5f
    call FUN_00525ab6                            # 00525c63
L_00525c68:
    # block 0x00525c68: entered by je at 0x00525c59, 1 instruction(s), ends with ret 0x8
    ret 0x8                                      # 00525c68

