# FUN_0050e040
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050e040
# extent:       0x0050e040-0x0050e054 (20 code bytes)
# span:         0x0050e040-0x0050e054 (code 20, tables 0, padding 0)
# sha256:       a818290b31e79763744564c66b93cd49a866560931bb9dd800aa685adb3704fa
# evidence:     ev_4431af068a3f4ca776e521e2b82a00887220c1221c914635cfd4305c8866eb9e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050e040
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00513ca8, FUN_0050e05d
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050e05d, .text + (0x0050e05d - 0x401000)
.set FUN_00513ca8, .text + (0x00513ca8 - 0x401000)

.org 0x0050e040 - 0x401000
.globl FUN_0050e040
FUN_0050e040:
    # block 0x0050e040: entry, 6 instruction(s), calls FUN_00513ca8, FUN_0050e05d, ends with ret
    sub esp, 0x8                                 # 0050e040
    fst qword ptr [esp]                          # 0050e043
    call FUN_00513ca8                            # 0050e046
    call FUN_0050e05d                            # 0050e04b
    add esp, 0x8                                 # 0050e050
    ret                                          # 0050e053

