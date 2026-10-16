# FUN_005136c1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005136c1
# extent:       0x005136c1-0x005136ce (13 code bytes)
# span:         0x005136c1-0x005136ce (code 13, tables 0, padding 0)
# sha256:       b36911065f24d7acc331bc07316bd5e56e63014839a4dacf10bfdfc9963031eb
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00513546 (+0x17b)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005136c1
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005136ce
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set LOC_00513674, .text + (0x00513674 - 0x401000)

.org 0x005136c1 - 0x401000
.globl FUN_005136c1
FUN_005136c1:
    # block 0x005136c1: entry, 2 instruction(s), ends with jne to 0x00513674 (backward)
    {load} or cl, cl                             # 005136c1
    jne.d8 . + (-79)  # -> LOC_00513674          # 005136c3
    # block 0x005136c5: entered by fall-through of jne at 0x005136c3, 3 instruction(s), ends with ret
    fstp st(0)                                   # 005136c5
    fld tbyte ptr [0x5688b0]                     # 005136c7
    ret                                          # 005136cd

