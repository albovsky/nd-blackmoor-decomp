# FUN_00513020
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513020
# extent:       0x00513020-0x00513025 (5 code bytes)
# span:         0x00513020-0x00513030 (code 5, tables 0, padding 11)
# sha256:       129f1135daa1b60c707996d1ed0561b8f4731388ee1f4732c0a27db4c5e3a907
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00512f53 (+0xcd)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00513020
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edx + n] field_minus_1
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1

# --- external targets -----------------------------------------------

.org 0x00513020 - 0x401000
.globl FUN_00513020
FUN_00513020:
    # block 0x00513020: entry, 3 instruction(s), ends with ret
    lea eax, [edx - field_minus_1]               # 00513020
    pop ebx                                      # 00513023
    ret                                          # 00513024

# --- data items (not part of the function) -------------------------
.org 0x00513025 - 0x401000
PAD_00513025:  # 11 byte(s) of alignment instructions
    {disp32} lea esp, [esp]
    {disp8} lea esp, [esp]

