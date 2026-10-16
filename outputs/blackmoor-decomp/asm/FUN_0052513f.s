# FUN_0052513f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052513f
# extent:       0x0052513f-0x0052514f (16 code bytes)
# span:         0x0052513f-0x0052514f (code 16, tables 0, padding 0)
# sha256:       04a4e7c9f000558df2aef1bce4fafde4feaeb30be023d86e9c61160f535c314e
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052513f
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00525b0f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0052514f
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_00525b0f, .text + (0x00525b0f - 0x401000)

.org 0x0052513f - 0x401000
.globl FUN_0052513f
FUN_0052513f:
    # block 0x0052513f: entry, 4 instruction(s), calls FUN_00525b0f, ends with ret
    push 0x52496c                                # 0052513f
    mov ecx, 0x63c444                            # 00525144
    call FUN_00525b0f                            # 00525149
    ret                                          # 0052514e

