# FUN_0051cfd1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051cfd1
# extent:       0x0051cfd1-0x0051cfd8 (7 code bytes)
# span:         0x0051cfd1-0x0051cfd8 (code 7, tables 0, padding 0)
# sha256:       619829cd4f296ce81e5275137505e34628c8e741d1c31c498d2c26ceec0f3241
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051cfd1
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_24
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x0051cfd8
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_24, 0x24  # offset +0x24

# --- external targets -----------------------------------------------

.org 0x0051cfd1 - 0x401000
.globl FUN_0051cfd1
FUN_0051cfd1:
    # block 0x0051cfd1: entry, 3 instruction(s), ends with ret
    mov eax, dword ptr [ecx + field_24]          # 0051cfd1
    and eax, 0x10                                # 0051cfd4
    ret                                          # 0051cfd7

