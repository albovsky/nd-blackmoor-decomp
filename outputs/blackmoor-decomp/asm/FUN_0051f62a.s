# FUN_0051f62a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051f62a
# extent:       0x0051f62a-0x0051f636 (12 code bytes)
# span:         0x0051f62a-0x0051f636 (code 12, tables 0, padding 0)
# sha256:       52931394c002f8b4ca0cbe8724f7f31f9fd62ed8c599def9e8763d102127beca
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051f62a
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x0051f62a - 0x401000
.globl FUN_0051f62a
FUN_0051f62a:
    # block 0x0051f62a: entry, 4 instruction(s), ends with ret 0x4
    {load} mov eax, ecx                          # 0051f62a
    mov ecx, dword ptr [esp + stk_4]             # 0051f62c
    mov dword ptr [eax + field_4], ecx           # 0051f630
    ret 0x4                                      # 0051f633

