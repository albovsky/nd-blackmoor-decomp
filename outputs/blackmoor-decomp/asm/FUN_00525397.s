# FUN_00525397
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525397
# extent:       0x00525397-0x005253ae (23 code bytes)
# span:         0x00525397-0x005253ae (code 23, tables 0, padding 0)
# sha256:       dec48ef68ba430133a83d1f0b2e57012af32e93e7f067cac468ea8878509a0c6
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         AfxGetModuleThreadState
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00525371, FUN_00525b0f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_00525371, .text + (0x00525371 - 0x401000)
.set FUN_00525b0f, .text + (0x00525b0f - 0x401000)

.org 0x00525397 - 0x401000
.globl FUN_00525397
FUN_00525397:
    # block 0x00525397: entry, 6 instruction(s), calls FUN_00525371, FUN_00525b0f, ends with ret
    call FUN_00525371                            # 00525397
    add eax, 0x1070                              # 0052539c
    push 0x524bd4                                # 005253a1
    {load} mov ecx, eax                          # 005253a6
    call FUN_00525b0f                            # 005253a8
    ret                                          # 005253ad

