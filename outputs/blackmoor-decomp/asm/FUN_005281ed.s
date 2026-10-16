# FUN_005281ed
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005281ed
# extent:       0x005281ed-0x005281f7 (10 code bytes)
# span:         0x005281ed-0x00528200 (code 10, tables 0, padding 9)
# sha256:       63f186e1c5de88233b1155d3f58a83650a63acc10f015b2b58e4c66fd347998e
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005281e4 (+0x9)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005281ed
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump FUN_0050c6c6
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050c6c6, .text + (0x0050c6c6 - 0x401000)

.org 0x005281ed - 0x401000
.globl FUN_005281ed
FUN_005281ed:
    # block 0x005281ed: entry, 2 instruction(s), ends with backward jump to 0x0050c6c6
    mov eax, 0x532a78                            # 005281ed
    jmp.d32 FUN_0050c6c6                         # 005281f2

# --- data items (not part of the function) -------------------------
.org 0x005281f7 - 0x401000
PAD_005281f7:  # 9 byte(s) of int3 padding
    .fill 9, 1, 0xcc

