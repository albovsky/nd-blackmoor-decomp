# FUN_0051e5ff
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e5ff
# extent:       0x0051e5ff-0x0051e611 (18 code bytes)
# span:         0x0051e5ff-0x0051e611 (code 18, tables 0, padding 0)
# sha256:       878363a215a2bc518eedbcff4638b583439ca0d4c86e15f01d653e30cd19be07
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e5ff
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050c511
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050c511, .text + (0x0050c511 - 0x401000)

.org 0x0051e5ff - 0x401000
.globl FUN_0051e5ff
FUN_0051e5ff:
    # block 0x0051e5ff: entry, 5 instruction(s), calls FUN_0050c511, ends with ret
    push 0x40                                    # 0051e5ff
    push 0x210                                   # 0051e601
    mov ecx, 0x63c378                            # 0051e606
    call FUN_0050c511                            # 0051e60b
    ret                                          # 0051e610

