# FUN_0051dc29
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051dc29
# extent:       0x0051dc29-0x0051dc31 (8 code bytes)
# span:         0x0051dc29-0x0051dc31 (code 8, tables 0, padding 0)
# sha256:       85d1ec84700c2591f452486fbe91d37dae39597847d933d8a00637089232f7f1
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051dc29
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00519cc0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_00519cc0, .text + (0x00519cc0 - 0x401000)

.org 0x0051dc29 - 0x401000
.globl FUN_0051dc29
FUN_0051dc29:
    # block 0x0051dc29: entry, 3 instruction(s), calls FUN_00519cc0, ends with ret
    call FUN_00519cc0                            # 0051dc29
    {load} xor eax, eax                          # 0051dc2e
    ret                                          # 0051dc30

