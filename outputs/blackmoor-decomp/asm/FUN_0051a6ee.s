# FUN_0051a6ee
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a6ee
# extent:       0x0051a6ee-0x0051a709 (27 code bytes)
# span:         0x0051a6ee-0x0051a709 (code 27, tables 0, padding 0)
# sha256:       559bcf8e0b8f252ab3002db1acf682d7f6674235c7d9661306995e5f02528feb
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051a6e2 (+0xc)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a6ee
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump FUN_0051b257
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0051a709
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0051b257, .text + (0x0051b257 - 0x401000)

.org 0x0051a6ee - 0x401000
.globl FUN_0051a6ee
FUN_0051a6ee:
    # block 0x0051a6ee: entry, 2 instruction(s), ends with jne to 0x0051a708 (forward)
    test byte ptr [0x63c314], 0x1                # 0051a6ee
    jne.d8 L_0051a708                            # 0051a6f5
    # block 0x0051a6f7: entered by fall-through of jne at 0x0051a6f5, 3 instruction(s), ends with forward jump to 0x0051b257
    or byte ptr [0x63c314], 0x1                  # 0051a6f7
    mov ecx, 0x63c318                            # 0051a6fe
    jmp.d32 FUN_0051b257                         # 0051a703
L_0051a708:
    # block 0x0051a708: entered by jne at 0x0051a6f5, 1 instruction(s), ends with ret
    ret                                          # 0051a708

