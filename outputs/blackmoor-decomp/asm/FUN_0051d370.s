# FUN_0051d370
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051d370
# extent:       0x0051d370-0x0051d373 (3 code bytes)
# span:         0x0051d370-0x0051d373 (code 3, tables 0, padding 0)
# sha256:       4bc724f3b1d0caf4fe369c18cba3102e6c4ea057f63fe1587e3973134a7f755e
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051d0b9 (+0x2b7)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051d370
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

.org 0x0051d370 - 0x401000
.globl FUN_0051d370
FUN_0051d370:
    # block 0x0051d370: entry, 2 instruction(s), ends with ret
    {load} xor eax, eax                          # 0051d370
    ret                                          # 0051d372

