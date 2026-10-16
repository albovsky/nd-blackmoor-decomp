# FUN_0051e591
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e591
# extent:       0x0051e591-0x0051e59b (10 code bytes)
# span:         0x0051e591-0x0051e59b (code 10, tables 0, padding 0)
# sha256:       781413c6288bcce3e9a28104ffad57d506ab92ff75804861d109390fa84a8406
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051e57b (+0x16)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e591
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051e59b, tail jump FUN_0051e5ad
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0051e59b, .text + (0x0051e59b - 0x401000)
.set FUN_0051e5ad, .text + (0x0051e5ad - 0x401000)

.org 0x0051e591 - 0x401000
.globl FUN_0051e591
FUN_0051e591:
    # block 0x0051e591: entry, 2 instruction(s), calls FUN_0051e59b, ends with forward jump to 0x0051e5ad
    call FUN_0051e59b                            # 0051e591
    jmp.d32 FUN_0051e5ad                         # 0051e596

