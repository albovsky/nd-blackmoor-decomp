# FUN_00523e94
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00523e94
# extent:       0x00523e94-0x00523e9a (6 code bytes)
# span:         0x00523e94-0x00523e9a (code 6, tables 0, padding 0)
# sha256:       1acaa9bcea6d484829441d7d276652e9fabfb081bbd11ac3a110bf3dc28f1baa
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00523dcf (+0xc5)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00523e94
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00523e9a
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4c, 0x4c  # offset +0x4c

# --- external targets -----------------------------------------------

.org 0x00523e94 - 0x401000
.globl FUN_00523e94
FUN_00523e94:
    # block 0x00523e94: entry, 2 instruction(s), ends with ret 0x8
    lea eax, [ecx + field_4c]                    # 00523e94
    ret 0x8                                      # 00523e97

