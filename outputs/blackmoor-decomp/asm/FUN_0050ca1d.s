# FUN_0050ca1d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050ca1d
# extent:       0x0050ca1d-0x0050ca26 (9 code bytes)
# span:         0x0050ca1d-0x0050ca26 (code 9, tables 0, padding 0)
# sha256:       6bd354e4adc439f10865ad5738175ae6a9076ecba573035e46a6acb51312ad2f
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050ca1d
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump LOC_0050ca30
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set LOC_0050ca30, .text + (0x0050ca30 - 0x401000)

.org 0x0050ca1d - 0x401000
.globl FUN_0050ca1d
FUN_0050ca1d:
    # block 0x0050ca1d: entry, 4 instruction(s), ends with forward jump to 0x0050ca30
    push ebx                                     # 0050ca1d
    push ecx                                     # 0050ca1e
    mov ebx, 0x567e10                            # 0050ca1f
    jmp.d8 . + (12)  # -> LOC_0050ca30           # 0050ca24

