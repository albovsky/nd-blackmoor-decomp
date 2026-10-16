# FUN_0051a76a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a76a
# extent:       0x0051a76a-0x0051a785 (27 code bytes)
# span:         0x0051a76a-0x0051a785 (code 27, tables 0, padding 0)
# sha256:       7894b6afe49fcea7949d5d613a8d5d7a2d0e923aa32a89642cb298d6bc2f068f
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051a75e (+0xc)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a76a
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump FUN_0051b257
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0051a785
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0051b257, .text + (0x0051b257 - 0x401000)

.org 0x0051a76a - 0x401000
.globl FUN_0051a76a
FUN_0051a76a:
    # block 0x0051a76a: entry, 2 instruction(s), ends with jne to 0x0051a784 (forward)
    test byte ptr [0x63c314], 0x4                # 0051a76a
    jne.d8 L_0051a784                            # 0051a771
    # block 0x0051a773: entered by fall-through of jne at 0x0051a771, 3 instruction(s), ends with forward jump to 0x0051b257
    or byte ptr [0x63c314], 0x4                  # 0051a773
    mov ecx, 0x63c298                            # 0051a77a
    jmp.d32 FUN_0051b257                         # 0051a77f
L_0051a784:
    # block 0x0051a784: entered by jne at 0x0051a771, 1 instruction(s), ends with ret
    ret                                          # 0051a784

