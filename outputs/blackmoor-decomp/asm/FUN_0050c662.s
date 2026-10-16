# FUN_0050c662
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c662
# extent:       0x0050c662-0x0050c669 (7 code bytes)
# span:         0x0050c662-0x0050c669 (code 7, tables 0, padding 0)
# sha256:       78901b609495f17b16fc3ddca954f4f55f35f527a920188c8a4d58a20c517fb6
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0050c635 (+0x2d)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c662
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x0050c662 - 0x401000
.globl FUN_0050c662
FUN_0050c662:
    # block 0x0050c662: entry, 5 instruction(s), ends with ret 0x8
    pop edi                                      # 0050c662
    pop esi                                      # 0050c663
    pop ebx                                      # 0050c664
    leave                                        # 0050c665
    ret 0x8                                      # 0050c666

