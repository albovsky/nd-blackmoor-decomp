# FUN_005135e8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005135e8
# extent:       0x005135e8-0x005135fa (18 code bytes)
# span:         0x005135e8-0x005135fa (code 18, tables 0, padding 0)
# sha256:       dab9b29ed0e404625a7221dac63e0d098525702cb56a3263933b33d707aae8f1
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00513546 (+0xa2)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005135e8
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_90
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005135fa
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_90, 0x90  # offset -0x90

# --- external targets -----------------------------------------------

.org 0x005135e8 - 0x401000
.globl FUN_005135e8
FUN_005135e8:
    # block 0x005135e8: entry, 5 instruction(s), ends with ret
    fstp st(0)                                   # 005135e8
    fstp st(0)                                   # 005135ea
    fld tbyte ptr [0x5688b0]                     # 005135ec
    mov byte ptr [ebp - field_minus_90], 0x2     # 005135f2
    ret                                          # 005135f9

