# FUN_0052778e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052778e
# extent:       0x0052778e-0x0052779d (15 code bytes)
# span:         0x0052778e-0x0052779d (code 15, tables 0, padding 0)
# sha256:       1ea051bc5b56ee01c6fe8e0bb2ef7ab497075604ceb8c0a72a47908a5ea0feb9
# evidence:     ev_450eb38fa601afc4b84de6969079191c21baf0f40898d00aa11d7f75d3380ee5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052778e
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_00454d6e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00454d6e, .text + (0x00454d6e - 0x401000)

.org 0x0052778e - 0x401000
.globl FUN_0052778e
FUN_0052778e:
    # block 0x0052778e: entry, 4 instruction(s), calls FUN_00454d6e, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 0052778e
    add ecx, 0xb4654                             # 00527791
    call FUN_00454d6e                            # 00527797
    ret                                          # 0052779c

