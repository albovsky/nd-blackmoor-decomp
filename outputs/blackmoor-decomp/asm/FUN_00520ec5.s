# FUN_00520ec5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520ec5
# extent:       0x00520ec5-0x00520ed5 (16 code bytes)
# span:         0x00520ec5-0x00520ed5 (code 16, tables 0, padding 0)
# sha256:       0663fcafbe7128bc30c46f2622cddb4618017e0f09eef1ecd9f575de2f247746
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00520e6d (+0x58)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520ec5
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4; [esp + n] stk_4
# callees:      calls GDI32.dll!GetClipBox
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x00520ec5 - 0x401000
.globl FUN_00520ec5
FUN_00520ec5:
    # block 0x00520ec5: entry, 4 instruction(s), calls GDI32.dll!GetClipBox, ends with ret 0x4
    push dword ptr [esp + stk_4]                 # 00520ec5
    push dword ptr [ecx + field_4]               # 00520ec9
    call dword ptr [0x52a058]                    # 00520ecc
    ret 0x4                                      # 00520ed2

