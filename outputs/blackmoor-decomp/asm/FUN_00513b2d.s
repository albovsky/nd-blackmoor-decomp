# FUN_00513b2d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513b2d
# extent:       0x00513b2d-0x00513b57 (42 code bytes)
# span:         0x00513b2d-0x00513b57 (code 42, tables 0, padding 0)
# sha256:       6eb1de965f6ca85e70bda9407d84e76141979deddea5899c3fcc83ae79ee151a
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00513a57 (+0xd6)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00513b2d
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_90, field_minus_97, field_minus_9e
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00513b57
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_90, 0x90  # offset -0x90
.equ field_minus_97, 0x97  # offset -0x97
.equ field_minus_9e, 0x9e  # offset -0x9e

# --- external targets -----------------------------------------------

.org 0x00513b2d - 0x401000
.globl FUN_00513b2d
FUN_00513b2d:
    # block 0x00513b2d: entry, 5 instruction(s), ends with je to 0x00513b4d (forward)
    fxch st(1)                                   # 00513b2d
    fstp tbyte ptr [ebp - field_minus_9e]        # 00513b2f
    fld tbyte ptr [ebp - field_minus_9e]         # 00513b35
    test byte ptr [ebp - field_minus_97], 0x40   # 00513b3b
    je.d8 L_00513b4d                             # 00513b42
    # block 0x00513b44: entered by fall-through of je at 0x00513b42, 2 instruction(s), ends with forward jump to 0x00513b54
    mov byte ptr [ebp - field_minus_90], 0x7     # 00513b44
    jmp.d8 L_00513b54                            # 00513b4b
L_00513b4d:
    # block 0x00513b4d: entered by je at 0x00513b42, 1 instruction(s), falls into the block at 0x00513b54
    mov byte ptr [ebp - field_minus_90], 0x1     # 00513b4d
L_00513b54:
    # block 0x00513b54: entered by jmp at 0x00513b4b, 2 instruction(s), ends with ret
    faddp st(1), st                              # 00513b54
    ret                                          # 00513b56

