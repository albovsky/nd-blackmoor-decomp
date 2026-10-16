# FUN_0052768f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052768f
# extent:       0x0052768f-0x0052769e (15 code bytes)
# span:         0x0052768f-0x0052769e (code 15, tables 0, padding 0)
# sha256:       574837877710353fe123b6aac754e8d5431c88da0cf3064eea47ab4592734982
# evidence:     ev_450eb38fa601afc4b84de6969079191c21baf0f40898d00aa11d7f75d3380ee5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052768f
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_00472f95
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00472f95, .text + (0x00472f95 - 0x401000)

.org 0x0052768f - 0x401000
.globl FUN_0052768f
FUN_0052768f:
    # block 0x0052768f: entry, 4 instruction(s), calls FUN_00472f95, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 0052768f
    add ecx, 0xae5d4                             # 00527692
    call FUN_00472f95                            # 00527698
    ret                                          # 0052769d

