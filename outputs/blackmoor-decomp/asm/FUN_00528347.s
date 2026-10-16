# FUN_00528347
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528347
# extent:       0x00528347-0x00528350 (9 code bytes)
# span:         0x00528347-0x00528350 (code 9, tables 0, padding 0)
# sha256:       357c16c735a3a61d567fb191e7ec83ea9cf09c5096fb41ecbe41f8087af8521e
# evidence:     ev_ae635b4fd276b6b5af385d914372d11115281daf9983e2ed88208809835d41c6
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528347
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_18
# callees:      calls FUN_0051e7ba
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_18, 0x18  # offset -0x18

# --- external targets -----------------------------------------------
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)

.org 0x00528347 - 0x401000
.globl FUN_00528347
FUN_00528347:
    # block 0x00528347: entry, 3 instruction(s), calls FUN_0051e7ba, ends with ret
    lea ecx, [ebp - field_minus_18]              # 00528347
    call FUN_0051e7ba                            # 0052834a
    ret                                          # 0052834f

