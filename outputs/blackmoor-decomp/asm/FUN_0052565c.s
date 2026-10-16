# FUN_0052565c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052565c
# extent:       0x0052565c-0x0052566e (18 code bytes)
# span:         0x0052565c-0x0052566e (code 18, tables 0, padding 0)
# sha256:       b83a938e69b3c3e1745741bb5cf111928fd5d4bc527062cf54e8109ac14a1b22
# evidence:     ev_d63d6a362278f40ee32ccb564ca8ec5738c7bbf1d9d11225df7a30f9c22e09d6
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052565c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050c41b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050c41b, .text + (0x0050c41b - 0x401000)

.org 0x0052565c - 0x401000
.globl FUN_0052565c
FUN_0052565c:
    # block 0x0052565c: entry, 5 instruction(s), calls FUN_0050c41b, ends with ret
    push 0xf021                                  # 0052565c
    push 0x0                                     # 00525661
    mov ecx, 0x63c5d0                            # 00525663
    call FUN_0050c41b                            # 00525668
    ret                                          # 0052566d

