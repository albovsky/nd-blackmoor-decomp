# FUN_00527590
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527590
# extent:       0x00527590-0x0052759f (15 code bytes)
# span:         0x00527590-0x0052759f (code 15, tables 0, padding 0)
# sha256:       ccdf926295ec39bae5df8b228edda598e17aa291d45855d639751690775f1c2f
# evidence:     ev_450eb38fa601afc4b84de6969079191c21baf0f40898d00aa11d7f75d3380ee5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527590
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004110d7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004110d7, .text + (0x004110d7 - 0x401000)

.org 0x00527590 - 0x401000
.globl FUN_00527590
FUN_00527590:
    # block 0x00527590: entry, 4 instruction(s), calls FUN_004110d7, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527590
    add ecx, 0xa96b9                             # 00527593
    call FUN_004110d7                            # 00527599
    ret                                          # 0052759e

