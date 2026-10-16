# FUN_00526195
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00526195
# extent:       0x00526195-0x005261a5 (16 code bytes)
# span:         0x00526195-0x005261a5 (code 16, tables 0, padding 0)
# sha256:       b2ad2f11b606bdbf058d33572dc095a18bacad799b11355da0ec1b0750e1660e
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00526195
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4
# callees:      calls KERNEL32.dll!GlobalFree
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x005261a5
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x00526195 - 0x401000
.globl FUN_00526195
FUN_00526195:
    # block 0x00526195: entry, 4 instruction(s), calls KERNEL32.dll!GlobalFree, ends with ret
    push dword ptr [ecx + field_4]               # 00526195
    mov dword ptr [ecx], 0x52ff4c                # 00526198
    call dword ptr [0x52a20c]                    # 0052619e
    ret                                          # 005261a4

