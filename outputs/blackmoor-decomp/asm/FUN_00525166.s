# FUN_00525166
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525166
# extent:       0x00525166-0x00525170 (10 code bytes)
# span:         0x00525166-0x00525170 (code 10, tables 0, padding 0)
# sha256:       020373079fcf29416f36f44879aac4543f121aab3d239e543411cf21ce110522
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0052515a (+0xc)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525166
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump FUN_00525263
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_00525263, .text + (0x00525263 - 0x401000)

.org 0x00525166 - 0x401000
.globl FUN_00525166
FUN_00525166:
    # block 0x00525166: entry, 2 instruction(s), ends with forward jump to 0x00525263
    mov ecx, 0x63c444                            # 00525166
    jmp.d32 FUN_00525263                         # 0052516b

