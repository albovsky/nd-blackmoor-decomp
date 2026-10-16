# FUN_00528ee4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528ee4
# extent:       0x00528ee4-0x00528eec (8 code bytes)
# span:         0x00528ee4-0x00528eec (code 8, tables 0, padding 0)
# sha256:       27df07951e119e1e268da0e5b70ced80fb3c657be51912e25368d310d97b31c3
# evidence:     ev_911401004da6a50fe2c6da2a1636d1d967e1d217200235f8b7d699d8e6aaea05
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528ee4
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls tail jump FUN_0051b257
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_rule is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0051b257, .text + (0x0051b257 - 0x401000)

.org 0x00528ee4 - 0x401000
.globl FUN_00528ee4
FUN_00528ee4:
    # block 0x00528ee4: entry, 2 instruction(s), ends with backward jump to 0x0051b257
    mov ecx, dword ptr [ebp - field_minus_10]    # 00528ee4
    jmp.d32 FUN_0051b257                         # 00528ee7

