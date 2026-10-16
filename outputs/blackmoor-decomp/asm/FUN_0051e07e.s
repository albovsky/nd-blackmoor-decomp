# FUN_0051e07e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e07e
# extent:       0x0051e07e-0x0051e08b (13 code bytes)
# span:         0x0051e07e-0x0051e08b (code 13, tables 0, padding 0)
# sha256:       2fbfe62c828090f47cf1bd616b1ac93bbbaa4d2ba9e86ca9f4993431b4e9df3e
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051dff7 (+0x87)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e07e
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_58; [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_58, 0x58  # offset +0x58

# --- external targets -----------------------------------------------

.org 0x0051e07e - 0x401000
.globl FUN_0051e07e
FUN_0051e07e:
    # block 0x0051e07e: entry, 5 instruction(s), ends with ret 0x4
    mov eax, dword ptr [esp + stk_4]             # 0051e07e
    push 0x1                                     # 0051e082
    mov dword ptr [ecx + field_58], eax          # 0051e084
    pop eax                                      # 0051e087
    ret 0x4                                      # 0051e088

