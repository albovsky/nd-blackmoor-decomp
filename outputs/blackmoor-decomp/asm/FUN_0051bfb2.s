# FUN_0051bfb2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051bfb2
# extent:       0x0051bfb2-0x0051bfc3 (17 code bytes)
# span:         0x0051bfb2-0x0051bfc3 (code 17, tables 0, padding 0)
# sha256:       85db77d5f8a8ff5db075511ab6fb7156f32eeab4e106d8774b135802561ba082
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051bf99 (+0x19)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051bfb2
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_18, field_28; [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_18, 0x18  # offset +0x18
.equ field_28, 0x28  # offset +0x28

# --- external targets -----------------------------------------------

.org 0x0051bfb2 - 0x401000
.globl FUN_0051bfb2
FUN_0051bfb2:
    # block 0x0051bfb2: entry, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [esp + stk_4]             # 0051bfb2
    mov dword ptr [ecx + field_18], 0x1          # 0051bfb6
    mov dword ptr [ecx + field_28], eax          # 0051bfbd
    ret 0x4                                      # 0051bfc0

