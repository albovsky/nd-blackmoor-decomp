# FUN_005280ea
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005280ea
# extent:       0x005280ea-0x005280f4 (10 code bytes)
# span:         0x005280ea-0x005280f4 (code 10, tables 0, padding 0)
# sha256:       72b0208b6e6b1e2d250b1a60733ffeb53573e3de1975ab702ced78d6a757616f
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005280e0 (+0xa)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005280ea
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

.org 0x005280ea - 0x401000
.globl FUN_005280ea
FUN_005280ea:
    # block 0x005280ea: entry, 2 instruction(s), ends with backward jump to 0x0050c6c6
    mov eax, 0x5328c0                            # 005280ea
    jmp.d32 FUN_0050c6c6                         # 005280ef

