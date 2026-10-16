# FUN_0050ea87
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050ea87
# extent:       0x0050ea87-0x0050ea90 (9 code bytes)
# span:         0x0050ea87-0x0050ea90 (code 9, tables 0, padding 0)
# sha256:       87b319d81534171ba6addad18b234892505d72b0b2ba71b3b25b22be3a17d395
# evidence:     ev_4431af068a3f4ca776e521e2b82a00887220c1221c914635cfd4305c8866eb9e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050ea87
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00510dd3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_00510dd3, .text + (0x00510dd3 - 0x401000)

.org 0x0050ea87 - 0x401000
.globl FUN_0050ea87
FUN_0050ea87:
    # block 0x0050ea87: entry, 3 instruction(s), calls FUN_00510dd3, ends with ret
    call FUN_00510dd3                            # 0050ea87
    add eax, 0xc                                 # 0050ea8c
    ret                                          # 0050ea8f

