# FUN_00528e64
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528e64
# extent:       0x00528e64-0x00528e6e (10 code bytes)
# span:         0x00528e64-0x00528e6e (code 10, tables 0, padding 0)
# sha256:       aefd7ab666a3490cf2e39ff8c9199690348b3d9302ec1f374c6db4c0639120a7
# evidence:     ev_911401004da6a50fe2c6da2a1636d1d967e1d217200235f8b7d699d8e6aaea05
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528e64
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_rule is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x00528e6e
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00528e64 - 0x401000
.globl FUN_00528e64
FUN_00528e64:
    # block 0x00528e64: entry, 4 instruction(s), calls FUN_0051dc6c, ends with ret
    push dword ptr [ebp - field_minus_10]        # 00528e64
    call FUN_0051dc6c                            # 00528e67
    pop ecx                                      # 00528e6c
    ret                                          # 00528e6d

