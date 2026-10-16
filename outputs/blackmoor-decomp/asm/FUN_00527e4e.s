# FUN_00527e4e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527e4e
# extent:       0x00527e4e-0x00527e5a (12 code bytes)
# span:         0x00527e4e-0x00527e5a (code 12, tables 0, padding 0)
# sha256:       de3f96d715e8f3309cba730e71f18da729a52472f2ccc910e4623638bc48e0c1
# evidence:     ev_630eb8c9c6330d8d8954b0f0603252a92e8f72ed7f378cfbde79d9e20ec97ca4
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527e4e
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_c1fc
# callees:      calls FUN_00433e63
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_c1fc, 0xc1fc  # offset -0xc1fc

# --- external targets -----------------------------------------------
.set FUN_00433e63, .text + (0x00433e63 - 0x401000)

.org 0x00527e4e - 0x401000
.globl FUN_00527e4e
FUN_00527e4e:
    # block 0x00527e4e: entry, 3 instruction(s), calls FUN_00433e63, ends with ret
    lea ecx, [ebp - field_minus_c1fc]            # 00527e4e
    call FUN_00433e63                            # 00527e54
    ret                                          # 00527e59

