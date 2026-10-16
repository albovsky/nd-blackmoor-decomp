# FUN_00527918
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527918
# extent:       0x00527918-0x00527927 (15 code bytes)
# span:         0x00527918-0x00527927 (code 15, tables 0, padding 0)
# sha256:       7549df89fa7fd4a681a33c04689b402c4b42c9b419b42d977569220e3eb6c5a6
# evidence:     ev_b63e1118bba1204c7ea8b81c8fd34d19f989b1bf23170257a27495e3973a3a30
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527918
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004e048f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004e048f, .text + (0x004e048f - 0x401000)

.org 0x00527918 - 0x401000
.globl FUN_00527918
FUN_00527918:
    # block 0x00527918: entry, 4 instruction(s), calls FUN_004e048f, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527918
    add ecx, 0x180                               # 0052791b
    call FUN_004e048f                            # 00527921
    ret                                          # 00527926

