# FUN_00513614
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513614
# extent:       0x00513614-0x00513624 (16 code bytes)
# span:         0x00513614-0x00513624 (code 16, tables 0, padding 0)
# sha256:       601c33fe84c08b11a49fdd504906deabc529b73805d5beff5832efe1e7c08719
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00513546 (+0xce)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00513614
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_90
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00513624
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_90, 0x90  # offset -0x90

# --- external targets -----------------------------------------------

.org 0x00513614 - 0x401000
.globl FUN_00513614
FUN_00513614:
    # block 0x00513614: entry, 4 instruction(s), ends with ret
    mov byte ptr [ebp - field_minus_90], 0x2     # 00513614
    fstp st(0)                                   # 0051361b
    fld tbyte ptr [0x5688ba]                     # 0051361d
    ret                                          # 00513623

