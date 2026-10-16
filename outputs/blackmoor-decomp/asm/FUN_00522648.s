# FUN_00522648
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00522648
# extent:       0x00522648-0x00522653 (11 code bytes)
# span:         0x00522648-0x00522653 (code 11, tables 0, padding 0)
# sha256:       95c42a7b82d422064e0781caa92ab3933cac688107c88a1a0c92d16c039b0859
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00522451 (+0x1f7)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00522648
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_c0
# callees:      none direct; 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_c0, 0xc0  # offset +0xc0

# --- external targets -----------------------------------------------

.org 0x00522648 - 0x401000
.globl FUN_00522648
FUN_00522648:
    # block 0x00522648: entry, 3 instruction(s), calls indirect dword ptr [eax + 0xc0], ends with ret 0x8
    mov eax, dword ptr [ecx]                     # 00522648
    call dword ptr [eax + field_c0]              # 0052264a
    ret 0x8                                      # 00522650

