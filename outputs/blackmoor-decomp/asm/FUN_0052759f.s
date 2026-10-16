# FUN_0052759f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052759f
# extent:       0x0052759f-0x005275ae (15 code bytes)
# span:         0x0052759f-0x005275ae (code 15, tables 0, padding 0)
# sha256:       d3d9ddefa8e181ff048b8565f7c81bfe9a1dd2a62d0af8ddd133b511044ed8db
# evidence:     ev_450eb38fa601afc4b84de6969079191c21baf0f40898d00aa11d7f75d3380ee5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052759f
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
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

.org 0x0052759f - 0x401000
.globl FUN_0052759f
FUN_0052759f:
    # block 0x0052759f: entry, 4 instruction(s), calls FUN_004d3b6e, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 0052759f
    add ecx, 0xabfff                             # 005275a2
    call FUN_004d3b6e                            # 005275a8
    ret                                          # 005275ad

