# FUN_00523d68
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00523d68
# extent:       0x00523d68-0x00523dac (68 code bytes)
# span:         0x00523d68-0x00523dac (code 68, tables 0, padding 0)
# sha256:       04940383fcc28ab2cf57eec827fe915c8f66292285c345f8347abf1a7917ecb9
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00523c57 (+0x111)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00523d68
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8, stk_c, stk_10
# callees:      calls FUN_0051ea75, FUN_0051fb2e, FUN_0050fde2, FUN_0051eac4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 24 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00523dac
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0050fde2, .text + (0x0050fde2 - 0x401000)
.set FUN_0051ea75, .text + (0x0051ea75 - 0x401000)
.set FUN_0051eac4, .text + (0x0051eac4 - 0x401000)
.set FUN_0051fb2e, .text + (0x0051fb2e - 0x401000)

.org 0x00523d68 - 0x401000
.globl FUN_00523d68
FUN_00523d68:
    # block 0x00523d68: entry, 11 instruction(s), calls FUN_0051ea75, FUN_0051fb2e, ends with je to 0x00523d9d (forward)
    mov ecx, dword ptr [esp + stk_8]             # 00523d68
    push esi                                     # 00523d6c
    push 0xff                                    # 00523d6d
    call FUN_0051ea75                            # 00523d72
    {load} mov esi, eax                          # 00523d77
    push 0x100                                   # 00523d79
    push esi                                     # 00523d7e
    push dword ptr [esp + stk_10]                # 00523d7f
    call FUN_0051fb2e                            # 00523d83
    test eax, eax                                # 00523d88
    je.d8 L_00523d9d                             # 00523d8a
    # block 0x00523d8c: entered by fall-through of je at 0x00523d8a, 7 instruction(s), calls FUN_0050fde2, ends with je to 0x00523d9d (forward)
    push 0xa                                     # 00523d8c
    push esi                                     # 00523d8e
    call FUN_0050fde2                            # 00523d8f
    pop ecx                                      # 00523d94
    test eax, eax                                # 00523d95
    pop ecx                                      # 00523d97
    je.d8 L_00523d9d                             # 00523d98
    # block 0x00523d9a: entered by fall-through of je at 0x00523d98, 1 instruction(s), falls into the block at 0x00523d9d
    and byte ptr [eax], 0x0                      # 00523d9a
L_00523d9d:
    # block 0x00523d9d: entered by je at 0x00523d8a; je at 0x00523d98, 5 instruction(s), calls FUN_0051eac4, ends with ret 0x8
    mov ecx, dword ptr [esp + stk_c]             # 00523d9d
    push -0x1                                    # 00523da1
    call FUN_0051eac4                            # 00523da3
    pop esi                                      # 00523da8
    ret 0x8                                      # 00523da9

