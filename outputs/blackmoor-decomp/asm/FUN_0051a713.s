# FUN_0051a713
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a713
# extent:       0x0051a713-0x0051a720 (13 code bytes)
# span:         0x0051a713-0x0051a720 (code 13, tables 0, padding 0)
# sha256:       444d5cd7bc222040d8d71bcb96669173936c388d6b5721505fd7bafc34174ff4
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a713
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051a801
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0051a801, .text + (0x0051a801 - 0x401000)

.org 0x0051a713 - 0x401000
.globl FUN_0051a713
FUN_0051a713:
    # block 0x0051a713: entry, 4 instruction(s), calls FUN_0051a801, ends with ret
    push 0x1                                     # 0051a713
    mov ecx, 0x63c2d8                            # 0051a715
    call FUN_0051a801                            # 0051a71a
    ret                                          # 0051a71f

