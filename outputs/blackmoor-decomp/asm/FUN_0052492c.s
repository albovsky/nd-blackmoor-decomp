# FUN_0052492c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052492c
# extent:       0x0052492c-0x00524936 (10 code bytes)
# span:         0x0052492c-0x00524936 (code 10, tables 0, padding 0)
# sha256:       37b37dc8bc96665482912fe09e1968d41ae7216a511eda9065065f33de090724
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00524901 (+0x2b)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052492c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00524936, tail jump FUN_00524945
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_00524936, .text + (0x00524936 - 0x401000)
.set FUN_00524945, .text + (0x00524945 - 0x401000)

.org 0x0052492c - 0x401000
.globl FUN_0052492c
FUN_0052492c:
    # block 0x0052492c: entry, 2 instruction(s), calls FUN_00524936, ends with forward jump to 0x00524945
    call FUN_00524936                            # 0052492c
    jmp.d32 FUN_00524945                         # 00524931

