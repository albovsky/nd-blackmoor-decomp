# FUN_00524880
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524880
# extent:       0x00524880-0x00524889 (9 code bytes)
# span:         0x00524880-0x00524889 (code 9, tables 0, padding 0)
# sha256:       f573db2794cbc131fba82ddbda6aaf71d3199edc1a586e9712682869f6925dfd
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524880
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_30
# callees:      calls FUN_00525371
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00524889
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_30, 0x30  # offset +0x30

# --- external targets -----------------------------------------------
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x00524880 - 0x401000
.globl FUN_00524880
FUN_00524880:
    # block 0x00524880: entry, 3 instruction(s), calls FUN_00525371, ends with ret
    call FUN_00525371                            # 00524880
    mov eax, dword ptr [eax + field_30]          # 00524885
    ret                                          # 00524888

