# FUN_0050f710
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050f710
# extent:       0x0050f710-0x0050f724 (20 code bytes)
# span:         0x0050f710-0x0050f724 (code 20, tables 0, padding 0)
# sha256:       763529ef2982e4356cb24b1932d9a1af62f4ef83f498cb05585dc049dea5c9ee
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050f710
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00513ca8, FUN_0050f72d
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0050f724
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050f72d, .text + (0x0050f72d - 0x401000)
.set FUN_00513ca8, .text + (0x00513ca8 - 0x401000)

.org 0x0050f710 - 0x401000
.globl FUN_0050f710
FUN_0050f710:
    # block 0x0050f710: entry, 6 instruction(s), calls FUN_00513ca8, FUN_0050f72d, ends with ret
    sub esp, 0x8                                 # 0050f710
    fst qword ptr [esp]                          # 0050f713
    call FUN_00513ca8                            # 0050f716
    call FUN_0050f72d                            # 0050f71b
    add esp, 0x8                                 # 0050f720
    ret                                          # 0050f723

