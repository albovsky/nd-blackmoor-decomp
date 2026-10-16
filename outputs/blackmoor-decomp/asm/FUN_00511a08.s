# FUN_00511a08
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00511a08
# extent:       0x00511a08-0x00511a1a (18 code bytes)
# span:         0x00511a08-0x00511a1a (code 18, tables 0, padding 0)
# sha256:       b08336dfc5d525fa7c53358317a7ddb1f06113ec5911df0feae755ab333c8275
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00511a08
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_005168ba
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_005168ba, .text + (0x005168ba - 0x401000)

.org 0x00511a08 - 0x401000
.globl FUN_00511a08
FUN_00511a08:
    # block 0x00511a08: entry, 6 instruction(s), calls FUN_005168ba, ends with ret
    push 0x30000                                 # 00511a08
    push 0x10000                                 # 00511a0d
    call FUN_005168ba                            # 00511a12
    pop ecx                                      # 00511a17
    pop ecx                                      # 00511a18
    ret                                          # 00511a19

