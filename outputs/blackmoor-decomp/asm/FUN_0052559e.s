# FUN_0052559e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052559e
# extent:       0x0052559e-0x005255ad (15 code bytes)
# span:         0x0052559e-0x005255ad (code 15, tables 0, padding 0)
# sha256:       32769a65de70ab0f8459614e316d6e897b7d635c2ea9e85f38c14638e2f368a6
# evidence:     ev_d63d6a362278f40ee32ccb564ca8ec5738c7bbf1d9d11225df7a30f9c22e09d6
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052559e
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050c511
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050c511, .text + (0x0050c511 - 0x401000)

.org 0x0052559e - 0x401000
.globl FUN_0052559e
FUN_0052559e:
    # block 0x0052559e: entry, 5 instruction(s), calls FUN_0050c511, ends with ret
    push 0x40                                    # 0052559e
    push 0x10                                    # 005255a0
    mov ecx, 0x63c5a8                            # 005255a2
    call FUN_0050c511                            # 005255a7
    ret                                          # 005255ac

