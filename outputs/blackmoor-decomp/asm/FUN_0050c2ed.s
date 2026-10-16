# FUN_0050c2ed
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c2ed
# extent:       0x0050c2ed-0x0050c309 (28 code bytes)
# span:         0x0050c2ed-0x0050c309 (code 28, tables 0, padding 0)
# sha256:       8fe78c72d976a0805c551c361e71c81f86244e8b7b0d80b4cdd179751e3e3356
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0050c2a0 (+0x4d)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c2ed
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x10 (callee pops 16 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4; [esp + n] stk_10
# callees:      calls GDI32.dll!TextOutA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------

.org 0x0050c2ed - 0x401000
.globl FUN_0050c2ed
FUN_0050c2ed:
    # block 0x0050c2ed: entry, 7 instruction(s), calls GDI32.dll!TextOutA, ends with ret 0x10
    push dword ptr [esp + stk_10]                # 0050c2ed
    push dword ptr [esp + stk_10]                # 0050c2f1
    push dword ptr [esp + stk_10]                # 0050c2f5
    push dword ptr [esp + stk_10]                # 0050c2f9
    push dword ptr [ecx + field_4]               # 0050c2fd
    call dword ptr [0x52a0a0]                    # 0050c300
    ret 0x10                                     # 0050c306

