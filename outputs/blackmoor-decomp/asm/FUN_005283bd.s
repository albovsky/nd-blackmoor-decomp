# FUN_005283bd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005283bd
# extent:       0x005283bd-0x005283c7 (10 code bytes)
# span:         0x005283bd-0x005283d0 (code 10, tables 0, padding 9)
# sha256:       a9301eb57482e183f15dcbc758f0e40cc84ca82d5b2858298c528735cc665289
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005283b4 (+0x9)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005283bd
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump FUN_0050c6c6
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050c6c6, .text + (0x0050c6c6 - 0x401000)

.org 0x005283bd - 0x401000
.globl FUN_005283bd
FUN_005283bd:
    # block 0x005283bd: entry, 2 instruction(s), ends with backward jump to 0x0050c6c6
    mov eax, 0x532d80                            # 005283bd
    jmp.d32 FUN_0050c6c6                         # 005283c2

# --- data items (not part of the function) -------------------------
.org 0x005283c7 - 0x401000
PAD_005283c7:  # 9 byte(s) of int3 padding
    .fill 9, 1, 0xcc

