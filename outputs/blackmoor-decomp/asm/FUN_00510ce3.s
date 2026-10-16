# FUN_00510ce3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00510ce3
# extent:       0x00510ce3-0x00510cec (9 code bytes)
# span:         0x00510ce3-0x00510cec (code 9, tables 0, padding 0)
# sha256:       c96040d6ddc93df8c66f907b99fd2d074ec0441a548d5497b8d3166cc993ce90
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00510c8d (+0x56)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00510ce3
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00510cec
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x00510ce3 - 0x401000
.globl FUN_00510ce3
FUN_00510ce3:
    # block 0x00510ce3: entry, 4 instruction(s), ends with ret
    {load} xor eax, eax                          # 00510ce3
    cmp byte ptr [ebp + field_c], al             # 00510ce5
    setne al                                     # 00510ce8
    ret                                          # 00510ceb

