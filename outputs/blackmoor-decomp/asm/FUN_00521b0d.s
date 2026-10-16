# FUN_00521b0d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00521b0d
# extent:       0x00521b0d-0x00521b19 (12 code bytes)
# span:         0x00521b0d-0x00521b19 (code 12, tables 0, padding 0)
# sha256:       6773f759d99432b4cb6c82441da62f0ba049139f63dfb597105dae4d524322cd
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00521a86 (+0x87)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00521b0d
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_c4
# callees:      none direct; 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x00521b19
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_c4, 0xc4  # offset +0xc4

# --- external targets -----------------------------------------------

.org 0x00521b0d - 0x401000
.globl FUN_00521b0d
FUN_00521b0d:
    # block 0x00521b0d: entry, 5 instruction(s), calls indirect dword ptr [eax + 0xc4], ends with ret
    mov eax, dword ptr [ecx]                     # 00521b0d
    call dword ptr [eax + field_c4]              # 00521b0f
    push 0x1                                     # 00521b15
    pop eax                                      # 00521b17
    ret                                          # 00521b18

