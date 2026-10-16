# FUN_00510a29
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00510a29
# extent:       0x00510a29-0x00510a33 (10 code bytes)
# span:         0x00510a29-0x00510a33 (code 10, tables 0, padding 0)
# sha256:       13e2fb0b67555394a5c524c91fdef09bec2a7a13dab273fc9a85796a08faba5f
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00510984 (+0xa5)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00510a29
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_14
# callees:      calls FUN_00510a9f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00510a33
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_14, 0x14  # offset -0x14

# --- external targets -----------------------------------------------
.set FUN_00510a9f, .text + (0x00510a9f - 0x401000)

.org 0x00510a29 - 0x401000
.globl FUN_00510a29
FUN_00510a29:
    # block 0x00510a29: entry, 4 instruction(s), calls FUN_00510a9f, ends with ret
    push dword ptr [ebp - field_minus_14]        # 00510a29
    call FUN_00510a9f                            # 00510a2c
    pop ecx                                      # 00510a31
    ret                                          # 00510a32

