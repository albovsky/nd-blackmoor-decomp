# FUN_00528cea
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528cea
# extent:       0x00528cea-0x00528cf4 (10 code bytes)
# span:         0x00528cea-0x00528cf4 (code 10, tables 0, padding 0)
# sha256:       7675ae58fd9d65548c22c5dd903fd1a2785b0d40b41c508177e7bc041f50cf36
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00528cdf (+0xb)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528cea
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

.org 0x00528cea - 0x401000
.globl FUN_00528cea
FUN_00528cea:
    # block 0x00528cea: entry, 2 instruction(s), ends with backward jump to 0x0050c6c6
    mov eax, 0x533cd0                            # 00528cea
    jmp.d32 FUN_0050c6c6                         # 00528cef

