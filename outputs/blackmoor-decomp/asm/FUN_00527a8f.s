# FUN_00527a8f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527a8f
# extent:       0x00527a8f-0x00527a9e (15 code bytes)
# span:         0x00527a8f-0x00527a9e (code 15, tables 0, padding 0)
# sha256:       5f9f7da29637d56beab7984e2760aa8698cc37073deea2f30ecba560ee38202f
# evidence:     ev_4a8dff9ad380397c0b868aca2777fc0b3dcad13e813ce03a000d7bb326342248
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527a8f
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004d3b6e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004d3b6e, .text + (0x004d3b6e - 0x401000)

.org 0x00527a8f - 0x401000
.globl FUN_00527a8f
FUN_00527a8f:
    # block 0x00527a8f: entry, 4 instruction(s), calls FUN_004d3b6e, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527a8f
    add ecx, 0xabfff                             # 00527a92
    call FUN_004d3b6e                            # 00527a98
    ret                                          # 00527a9d

