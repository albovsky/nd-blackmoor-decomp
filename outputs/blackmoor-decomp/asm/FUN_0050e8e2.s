# FUN_0050e8e2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050e8e2
# extent:       0x0050e8e2-0x0050e8ed (11 code bytes)
# span:         0x0050e8e2-0x0050e8ed (code 11, tables 0, padding 0)
# sha256:       5f5163b3a04977f2aed6153fe2adc280b6e75a42c140e5920225d5bb40d228ef
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0050e7e5 (+0xfd)
# region:       crt_mfc
# frame:        none
# ending:       call-end (the code part ends in a call with no instruction after it; the call may or may not return, so it is counted only bound together with the range at 0x0050e8ed that follows it, under the owner ruling of 2026-10-16)
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050e8e2
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_18, field_minus_68
# callees:      calls FUN_0050d7f4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; the code part ends in a call with no instruction after it, whether the callee returns is not proven here, and the entry is counted only bound together with the range at 0x0050e8ed that follows it (owner ruling of 2026-10-16)
# note:         call_without_fallthrough:0x0050e8e8
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_18, 0x18  # offset -0x18
.equ field_minus_68, 0x68  # offset -0x68

# --- external targets -----------------------------------------------
.set FUN_0050d7f4, .text + (0x0050d7f4 - 0x401000)

.org 0x0050e8e2 - 0x401000
.globl FUN_0050e8e2
FUN_0050e8e2:
    # block 0x0050e8e2: entry, 3 instruction(s), calls FUN_0050d7f4, ends with call 0x50d7f4 and no instruction after it in this entry; if the call returns, execution continues in the entry at 0x0050e8ed, which is bound together with this one
    mov esp, dword ptr [ebp - field_minus_18]    # 0050e8e2
    push dword ptr [ebp - field_minus_68]        # 0050e8e5
    call FUN_0050d7f4                            # 0050e8e8

