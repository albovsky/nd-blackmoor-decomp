# FUN_00525d3c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525d3c
# extent:       0x00525d3c-0x00525d48 (12 code bytes)
# span:         0x00525d3c-0x00525d48 (code 12, tables 0, padding 0)
# sha256:       ab8123f83a437ac5146c19de246d353c5ef1fee13892bf87e593b4200da2161a
# evidence:     ev_d63d6a362278f40ee32ccb564ca8ec5738c7bbf1d9d11225df7a30f9c22e09d6
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525d3c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050d775
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00525d48
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050d775, .text + (0x0050d775 - 0x401000)

.org 0x00525d3c - 0x401000
.globl FUN_00525d3c
FUN_00525d3c:
    # block 0x00525d3c: entry, 4 instruction(s), calls FUN_0050d775, ends with ret
    push 0x525d48                                # 00525d3c
    call FUN_0050d775                            # 00525d41
    pop ecx                                      # 00525d46
    ret                                          # 00525d47

