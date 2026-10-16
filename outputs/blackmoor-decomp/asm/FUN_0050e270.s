# FUN_0050e270
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050e270
# extent:       0x0050e270-0x0050e284 (20 code bytes)
# span:         0x0050e270-0x0050e284 (code 20, tables 0, padding 0)
# sha256:       02ee59d248e5338655eef82cd631886137a325e066c3e9bb75fa3913980098c5
# evidence:     ev_4431af068a3f4ca776e521e2b82a00887220c1221c914635cfd4305c8866eb9e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050e270
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00513ca8, FUN_0050e28d
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050e28d, .text + (0x0050e28d - 0x401000)
.set FUN_00513ca8, .text + (0x00513ca8 - 0x401000)

.org 0x0050e270 - 0x401000
.globl FUN_0050e270
FUN_0050e270:
    # block 0x0050e270: entry, 6 instruction(s), calls FUN_00513ca8, FUN_0050e28d, ends with ret
    sub esp, 0x8                                 # 0050e270
    fst qword ptr [esp]                          # 0050e273
    call FUN_00513ca8                            # 0050e276
    call FUN_0050e28d                            # 0050e27b
    add esp, 0x8                                 # 0050e280
    ret                                          # 0050e283

