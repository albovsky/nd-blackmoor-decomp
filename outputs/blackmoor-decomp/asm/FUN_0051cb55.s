# FUN_0051cb55
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051cb55
# extent:       0x0051cb55-0x0051cb6b (22 code bytes)
# span:         0x0051cb55-0x0051cb6b (code 22, tables 0, padding 0)
# sha256:       11c306b3204f5965223f007d31e74b7a68e15e8ea3cd72f590ab67130e48c05b
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051cb55
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_8; [esp + n] stk_4, stk_8
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x0051cb55 - 0x401000
.globl FUN_0051cb55
FUN_0051cb55:
    # block 0x0051cb55: entry, 7 instruction(s), ends with ret 0x8
    {load} mov eax, ecx                          # 0051cb55
    mov ecx, dword ptr [esp + stk_8]             # 0051cb57
    and dword ptr [eax + field_8], 0x0           # 0051cb5b
    mov dword ptr [eax], ecx                     # 0051cb5f
    mov ecx, dword ptr [esp + stk_4]             # 0051cb61
    mov dword ptr [eax + field_4], ecx           # 0051cb65
    ret 0x8                                      # 0051cb68

