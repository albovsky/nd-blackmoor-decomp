# FUN_005135fa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005135fa
# extent:       0x005135fa-0x00513614 (26 code bytes)
# span:         0x005135fa-0x00513614 (code 26, tables 0, padding 0)
# sha256:       bd5e9695c0d033cbcd28ff8de569bb7a8638ae0c273786a0599607d137699718
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00513546 (+0xb4)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005135fa
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_9f, field_minus_a0
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00513614
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_9f, 0x9f  # offset -0x9f
.equ field_minus_a0, 0xa0  # offset -0xa0

# --- external targets -----------------------------------------------
.set LOC_005135e3, .text + (0x005135e3 - 0x401000)

.org 0x005135fa - 0x401000
.globl FUN_005135fa
FUN_005135fa:
    # block 0x005135fa: entry, 8 instruction(s), ends with jne to 0x005135e3 (backward)
    fldln2                                       # 005135fa
    fxch st(1)                                   # 005135fc
    ftst                                         # 005135fe
    wait                                         # 00513600
    fnstsw word ptr [ebp - field_minus_a0]       # 00513601
    wait                                         # 00513607
    test byte ptr [ebp - field_minus_9f], 0x41   # 00513608
    jne.d8 . + (-44)  # -> LOC_005135e3          # 0051360f
    # block 0x00513611: entered by fall-through of jne at 0x0051360f, 2 instruction(s), ends with ret
    fyl2x                                        # 00513611
    ret                                          # 00513613

