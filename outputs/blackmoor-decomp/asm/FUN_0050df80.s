# FUN_0050df80
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050df80
# extent:       0x0050df80-0x0050df94 (20 code bytes)
# span:         0x0050df80-0x0050df94 (code 20, tables 0, padding 0)
# sha256:       59bcf8f8397fca2e1cb229e6ac1fee4ea21370b75a8e76b0a3d731ad46f87b22
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050df80
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00513ca8, FUN_0050df9d
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050df9d, .text + (0x0050df9d - 0x401000)
.set FUN_00513ca8, .text + (0x00513ca8 - 0x401000)

.org 0x0050df80 - 0x401000
.globl FUN_0050df80
FUN_0050df80:
    # block 0x0050df80: entry, 6 instruction(s), calls FUN_00513ca8, FUN_0050df9d, ends with ret
    sub esp, 0x8                                 # 0050df80
    fst qword ptr [esp]                          # 0050df83
    call FUN_00513ca8                            # 0050df86
    call FUN_0050df9d                            # 0050df8b
    add esp, 0x8                                 # 0050df90
    ret                                          # 0050df93

