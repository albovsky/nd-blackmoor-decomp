# FUN_00528d74
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528d74
# extent:       0x00528d74-0x00528d8b (23 code bytes)
# span:         0x00528d74-0x00528d8b (code 23, tables 0, padding 0)
# sha256:       71765c6fdfc359b23746ea3ea61b6a2be96fa0d7ee32434fecd96c66b36355e0
# evidence:     ev_911401004da6a50fe2c6da2a1636d1d967e1d217200235f8b7d699d8e6aaea05
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528d74
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8, field_minus_14
# callees:      calls tail jump FUN_0051e7ba
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_rule is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x00528d8b
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_14, 0x14  # offset -0x14
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)

.org 0x00528d74 - 0x401000
.globl FUN_00528d74
FUN_00528d74:
    # block 0x00528d74: entry, 4 instruction(s), ends with je to 0x00528d8a (forward)
    mov eax, dword ptr [ebp - field_minus_14]    # 00528d74
    and eax, 0x1                                 # 00528d77
    test eax, eax                                # 00528d7a
    je.d32 L_00528d8a                            # 00528d7c
    # block 0x00528d82: entered by fall-through of je at 0x00528d7c, 2 instruction(s), ends with backward jump to 0x0051e7ba
    mov ecx, dword ptr [ebp + field_8]           # 00528d82
    jmp.d32 FUN_0051e7ba                         # 00528d85
L_00528d8a:
    # block 0x00528d8a: entered by je at 0x00528d7c, 1 instruction(s), ends with ret
    ret                                          # 00528d8a

