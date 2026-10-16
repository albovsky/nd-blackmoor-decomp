# FUN_00525624
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525624
# extent:       0x00525624-0x00525636 (18 code bytes)
# span:         0x00525624-0x00525636 (code 18, tables 0, padding 0)
# sha256:       ac6cab8ee30a2aa7b548765c1df873ef6cdf6c5dead5db05ea47670589e893cd
# evidence:     ev_d63d6a362278f40ee32ccb564ca8ec5738c7bbf1d9d11225df7a30f9c22e09d6
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525624
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050c3ce
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050c3ce, .text + (0x0050c3ce - 0x401000)

.org 0x00525624 - 0x401000
.globl FUN_00525624
FUN_00525624:
    # block 0x00525624: entry, 5 instruction(s), calls FUN_0050c3ce, ends with ret
    push 0xf023                                  # 00525624
    push 0x0                                     # 00525629
    mov ecx, 0x63c668                            # 0052562b
    call FUN_0050c3ce                            # 00525630
    ret                                          # 00525635

