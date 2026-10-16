# FUN_005226c4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005226c4
# extent:       0x005226c4-0x005226e2 (30 code bytes)
# span:         0x005226c4-0x005226e2 (code 30, tables 0, padding 0)
# sha256:       5b74d760070279c0e0792baedf479471d4217d67b31f9d06ee8da72466b5aea9
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00522653 (+0x71)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005226c4
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1c; [esp + n] stk_8
# callees:      calls FUN_005220e2, FUN_0051aa23
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0051aa23, .text + (0x0051aa23 - 0x401000)
.set FUN_005220e2, .text + (0x005220e2 - 0x401000)

.org 0x005226c4 - 0x401000
.globl FUN_005226c4
FUN_005226c4:
    # block 0x005226c4: entry, 8 instruction(s), calls FUN_005220e2, FUN_0051aa23, ends with ret 0x8
    call FUN_005220e2                            # 005226c4
    push dword ptr [esp + stk_8]                 # 005226c9
    push dword ptr [esp + stk_8]                 # 005226cd
    push 0x365                                   # 005226d1
    push dword ptr [eax + field_1c]              # 005226d6
    push eax                                     # 005226d9
    call FUN_0051aa23                            # 005226da
    ret 0x8                                      # 005226df

