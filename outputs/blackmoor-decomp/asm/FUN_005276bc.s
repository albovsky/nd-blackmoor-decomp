# FUN_005276bc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005276bc
# extent:       0x005276bc-0x005276cb (15 code bytes)
# span:         0x005276bc-0x005276cb (code 15, tables 0, padding 0)
# sha256:       f0b214f14d0f7c455063ea90d0f51fad202b252676788e087c222dfbf33a7ecb
# evidence:     ev_450eb38fa601afc4b84de6969079191c21baf0f40898d00aa11d7f75d3380ee5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005276bc
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0045dc6e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0045dc6e, .text + (0x0045dc6e - 0x401000)

.org 0x005276bc - 0x401000
.globl FUN_005276bc
FUN_005276bc:
    # block 0x005276bc: entry, 4 instruction(s), calls FUN_0045dc6e, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 005276bc
    add ecx, 0xaf129                             # 005276bf
    call FUN_0045dc6e                            # 005276c5
    ret                                          # 005276ca

