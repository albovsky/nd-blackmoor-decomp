# FUN_005227c0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005227c0
# extent:       0x005227c0-0x005227c6 (6 code bytes)
# span:         0x005227c0-0x005227c6 (code 6, tables 0, padding 0)
# sha256:       514a68a292e78a5ee52fa7ab621a0fcee85231d3ee53505c9d69ad67058f5ef5
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005226e2 (+0xde)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005227c0
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

.org 0x005227c0 - 0x401000
.globl FUN_005227c0
FUN_005227c0:
    # block 0x005227c0: entry, 2 instruction(s), ends with ret
    mov eax, 0x52f5d8                            # 005227c0
    ret                                          # 005227c5

