# FUN_005244e2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005244e2
# extent:       0x005244e2-0x005244f6 (20 code bytes)
# span:         0x005244e2-0x005244f6 (code 20, tables 0, padding 0)
# sha256:       6ac8176ea33723bfeb15dc63dbe002c4b494faa186e80a5721c66f6286c4ace8
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005242c7 (+0x21b)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005244e2
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_a8, field_b8; [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_a8, 0xa8  # offset +0xa8
.equ field_b8, 0xb8  # offset +0xb8

# --- external targets -----------------------------------------------

.org 0x005244e2 - 0x401000
.globl FUN_005244e2
FUN_005244e2:
    # block 0x005244e2: entry, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [esp + stk_4]             # 005244e2
    or dword ptr [ecx + field_b8], 0x1           # 005244e6
    mov dword ptr [ecx + field_a8], eax          # 005244ed
    ret 0x4                                      # 005244f3

