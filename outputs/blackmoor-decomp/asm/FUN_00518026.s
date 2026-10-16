# FUN_00518026
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00518026
# extent:       0x00518026-0x00518039 (19 code bytes)
# span:         0x00518026-0x00518039 (code 19, tables 0, padding 0)
# sha256:       4d7b6db9e1753f93166703fd9e44b5a232a5c63ffaacf49e509c38fa1e2e58af
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051779c (+0x88a)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00518026
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_c
# callees:      calls FUN_00517a70
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00518039
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_00517a70, .text + (0x00517a70 - 0x401000)

.org 0x00518026 - 0x401000
.globl FUN_00518026
FUN_00518026:
    # block 0x00518026: entry, 6 instruction(s), calls FUN_00517a70, ends with ret
    sub esp, 0x2c                                # 00518026
    fstp tbyte ptr [esp]                         # 00518029
    fstp tbyte ptr [esp + stk_c]                 # 0051802c
    call FUN_00517a70                            # 00518030
    add esp, 0x2c                                # 00518035
    ret                                          # 00518038

