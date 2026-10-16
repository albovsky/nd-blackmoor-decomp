# FUN_00521bcb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00521bcb
# extent:       0x00521bcb-0x00521bed (34 code bytes)
# span:         0x00521bcb-0x00521bed (code 34, tables 0, padding 0)
# sha256:       9a2b6a9d3b193189062d0bcec55db5e9f4defaa005995a6ff111a75bee50fd12
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00521bcb
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_1c; [esp + n] stk_4
# callees:      calls USER32.dll!GetParent, USER32.dll!GetDlgItem, USER32.dll!IsWindowEnabled
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------

.org 0x00521bcb - 0x401000
.globl FUN_00521bcb
FUN_00521bcb:
    # block 0x00521bcb: entry, 7 instruction(s), calls USER32.dll!GetParent, USER32.dll!GetDlgItem, ends with je to 0x00521bea (forward)
    push dword ptr [esp + stk_4]                 # 00521bcb
    push dword ptr [ecx + field_1c]              # 00521bcf
    call dword ptr [0x52a3dc]                    # 00521bd2
    push eax                                     # 00521bd8
    call dword ptr [0x52a404]                    # 00521bd9
    test eax, eax                                # 00521bdf
    je.d8 L_00521bea                             # 00521be1
    # block 0x00521be3: entered by fall-through of je at 0x00521be1, 2 instruction(s), calls USER32.dll!IsWindowEnabled, falls into the block at 0x00521bea
    push eax                                     # 00521be3
    call dword ptr [0x52a330]                    # 00521be4
L_00521bea:
    # block 0x00521bea: entered by je at 0x00521be1, 1 instruction(s), ends with ret 0x4
    ret 0x4                                      # 00521bea

