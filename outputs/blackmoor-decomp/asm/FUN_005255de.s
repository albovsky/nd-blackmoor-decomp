# FUN_005255de
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005255de
# extent:       0x005255de-0x005255ed (15 code bytes)
# span:         0x005255de-0x005255ed (code 15, tables 0, padding 0)
# sha256:       2dae0c8fbf728b893ae5550c695f9c9b4aec0cf8753fbaa9c66d0cffb7dcdbc1
# evidence:     ev_d63d6a362278f40ee32ccb564ca8ec5738c7bbf1d9d11225df7a30f9c22e09d6
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005255de
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

.org 0x005255de - 0x401000
.globl FUN_005255de
FUN_005255de:
    # block 0x005255de: entry, 5 instruction(s), calls FUN_0050c511, ends with ret
    push 0x40                                    # 005255de
    push 0x8                                     # 005255e0
    mov ecx, 0x63c580                            # 005255e2
    call FUN_0050c511                            # 005255e7
    ret                                          # 005255ec

