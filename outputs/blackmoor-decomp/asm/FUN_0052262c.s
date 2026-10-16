# FUN_0052262c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052262c
# extent:       0x0052262c-0x00522648 (28 code bytes)
# span:         0x0052262c-0x00522648 (code 28, tables 0, padding 0)
# sha256:       72e2236b1b056feb7ac8887d941bf2555adf3906378156de35bc8d131d1f5bd3
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00522451 (+0x1db)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052262c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d55a, FUN_0051ab4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00522648
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)
.set FUN_0051d55a, .text + (0x0051d55a - 0x401000)

.org 0x0052262c - 0x401000
.globl FUN_0052262c
FUN_0052262c:
    # block 0x0052262c: entry, 10 instruction(s), calls FUN_0051d55a, FUN_0051ab4b, ends with ret 0x4
    push esi                                     # 0052262c
    push 0x0                                     # 0052262d
    push 0x0                                     # 0052262f
    {load} mov esi, ecx                          # 00522631
    push 0x400                                   # 00522633
    call FUN_0051d55a                            # 00522638
    {load} mov ecx, esi                          # 0052263d
    call FUN_0051ab4b                            # 0052263f
    pop esi                                      # 00522644
    ret 0x4                                      # 00522645

