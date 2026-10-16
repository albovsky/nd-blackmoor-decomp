# FUN_0052699b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052699b
# extent:       0x0052699b-0x005269a5 (10 code bytes)
# span:         0x0052699b-0x005269a5 (code 10, tables 0, padding 0)
# sha256:       632fc36e6a9c0d8d10dcefd419a9deac9c07334797949d45576c31f4fce6872d
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00526978 (+0x23)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052699b
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0052116f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0052116f, .text + (0x0052116f - 0x401000)

.org 0x0052699b - 0x401000
.globl FUN_0052699b
FUN_0052699b:
    # block 0x0052699b: entry, 4 instruction(s), calls FUN_0052116f, ends with ret
    add ecx, 0x50                                # 0052699b
    push ecx                                     # 0052699e
    call FUN_0052116f                            # 0052699f
    ret                                          # 005269a4

