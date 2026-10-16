# FUN_00525431
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525431
# extent:       0x00525431-0x0052543b (10 code bytes)
# span:         0x00525431-0x0052543b (code 10, tables 0, padding 0)
# sha256:       781413c6288bcce3e9a28104ffad57d506ab92ff75804861d109390fa84a8406
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0052540b (+0x26)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525431
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0052543b, tail jump FUN_0052544d
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0052543b, .text + (0x0052543b - 0x401000)
.set FUN_0052544d, .text + (0x0052544d - 0x401000)

.org 0x00525431 - 0x401000
.globl FUN_00525431
FUN_00525431:
    # block 0x00525431: entry, 2 instruction(s), calls FUN_0052543b, ends with forward jump to 0x0052544d
    call FUN_0052543b                            # 00525431
    jmp.d32 FUN_0052544d                         # 00525436

