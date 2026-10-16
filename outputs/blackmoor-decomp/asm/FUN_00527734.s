# FUN_00527734
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527734
# extent:       0x00527734-0x00527743 (15 code bytes)
# span:         0x00527734-0x00527743 (code 15, tables 0, padding 0)
# sha256:       0efa948cd3b6e4304482d40b00912d60e74904ff4378079ed481bd06bbb1e95b
# evidence:     ev_450eb38fa601afc4b84de6969079191c21baf0f40898d00aa11d7f75d3380ee5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527734
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0048bafb
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0048bafb, .text + (0x0048bafb - 0x401000)

.org 0x00527734 - 0x401000
.globl FUN_00527734
FUN_00527734:
    # block 0x00527734: entry, 4 instruction(s), calls FUN_0048bafb, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527734
    add ecx, 0xb42fe                             # 00527737
    call FUN_0048bafb                            # 0052773d
    ret                                          # 00527742

