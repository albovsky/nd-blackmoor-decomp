# FUN_00513cbe
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513cbe
# extent:       0x00513cbe-0x00513ccb (13 code bytes)
# span:         0x00513cbe-0x00513ccb (code 13, tables 0, padding 0)
# sha256:       b0971b5d2cb4945dc056293d2dac8d989fc1d1488b22edb4125e67fdf93c85bd
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00513cbe
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x00513cbe - 0x401000
.globl FUN_00513cbe
FUN_00513cbe:
    # block 0x00513cbe: entry, 2 instruction(s), ends with je to 0x00513cc9 (forward)
    .insn 0x6681/7, dword ptr [esp], 639{:s16}   # 00513cbe
    je.d8 L_00513cc9                             # 00513cc4
    # block 0x00513cc6: entered by fall-through of je at 0x00513cc4, 1 instruction(s), falls into the block at 0x00513cc9
    fldcw word ptr [esp]                         # 00513cc6
L_00513cc9:
    # block 0x00513cc9: entered by je at 0x00513cc4, 2 instruction(s), ends with ret
    pop edx                                      # 00513cc9
    ret                                          # 00513cca

