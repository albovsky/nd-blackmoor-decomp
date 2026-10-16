# FUN_00519a4e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00519a4e
# extent:       0x00519a4e-0x00519a54 (6 code bytes)
# span:         0x00519a4e-0x00519a54 (code 6, tables 0, padding 0)
# sha256:       e128a6b97499cc0c84cd2bd3bd77f3e09f595dffccb3d17c16ecc2ac65a13ed6
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005199bd (+0x91)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00519a4e
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump WINSPOOL.DRV!DocumentPropertiesA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00519a54
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x00519a4e - 0x401000
.globl FUN_00519a4e
FUN_00519a4e:
    # block 0x00519a4e: entry, 1 instruction(s), ends with indirect jump dword ptr [0x52a4f4]
    jmp dword ptr [0x52a4f4]                     # 00519a4e

