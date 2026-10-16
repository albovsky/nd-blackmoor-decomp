# FUN_00526408
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00526408
# extent:       0x00526408-0x0052640e (6 code bytes)
# span:         0x00526408-0x0052640e (code 6, tables 0, padding 0)
# sha256:       03f8dcb0f15f4dd8b08d5087945cd61def0ec3883d01d814c0262999259c59cf
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005262f7 (+0x111)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00526408
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x00526408 - 0x401000
.globl FUN_00526408
FUN_00526408:
    # block 0x00526408: entry, 2 instruction(s), ends with ret
    mov eax, 0x530100                            # 00526408
    ret                                          # 0052640d

