# FUN_0051e5c3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e5c3
# extent:       0x0051e5c3-0x0051e5cd (10 code bytes)
# span:         0x0051e5c3-0x0051e5cd (code 10, tables 0, padding 0)
# sha256:       781413c6288bcce3e9a28104ffad57d506ab92ff75804861d109390fa84a8406
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051e5ad (+0x16)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e5c3
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051e5cd, tail jump FUN_0051e5df
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0051e5cd, .text + (0x0051e5cd - 0x401000)
.set FUN_0051e5df, .text + (0x0051e5df - 0x401000)

.org 0x0051e5c3 - 0x401000
.globl FUN_0051e5c3
FUN_0051e5c3:
    # block 0x0051e5c3: entry, 2 instruction(s), calls FUN_0051e5cd, ends with forward jump to 0x0051e5df
    call FUN_0051e5cd                            # 0051e5c3
    jmp.d32 FUN_0051e5df                         # 0051e5c8

