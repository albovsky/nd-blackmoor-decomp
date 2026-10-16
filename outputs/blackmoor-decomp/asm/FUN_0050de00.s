# FUN_0050de00
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050de00
# extent:       0x0050de00-0x0050de0a (10 code bytes)
# span:         0x0050de00-0x0050de0a (code 10, tables 0, padding 0)
# sha256:       954aa77659cf67e20e5db55597b0601427e7980dc6c4964310561b2c1c6fdc85
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050de00
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump FUN_0051397b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x0050de0a
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0051397b, .text + (0x0051397b - 0x401000)

.org 0x0050de00 - 0x401000
.globl FUN_0050de00
FUN_0050de00:
    # block 0x0050de00: entry, 2 instruction(s), ends with forward jump to 0x0051397b
    mov edx, 0x5688ea                            # 0050de00
    jmp.d32 FUN_0051397b                         # 0050de05

