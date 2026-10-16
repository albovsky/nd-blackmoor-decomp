# FUN_00513b02
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513b02
# extent:       0x00513b02-0x00513b2d (43 code bytes)
# span:         0x00513b02-0x00513b2d (code 43, tables 0, padding 0)
# sha256:       67fbfbcaeb9948ae7b72f3f1031069a5d03c801cffd2794ed7400239f5deb653
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00513a57 (+0xab)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00513b02
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_90, field_minus_97, field_minus_9e
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00513b2d
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_90, 0x90  # offset -0x90
.equ field_minus_97, 0x97  # offset -0x97
.equ field_minus_9e, 0x9e  # offset -0x9e

# --- external targets -----------------------------------------------

.org 0x00513b02 - 0x401000
.globl FUN_00513b02
FUN_00513b02:
    # block 0x00513b02: entry, 4 instruction(s), ends with je to 0x00513b1f (forward)
    fstp tbyte ptr [ebp - field_minus_9e]        # 00513b02
    fld tbyte ptr [ebp - field_minus_9e]         # 00513b08
    test byte ptr [ebp - field_minus_97], 0x40   # 00513b0e
    je.d8 L_00513b1f                             # 00513b15
    # block 0x00513b17: entered by fall-through of je at 0x00513b15, 2 instruction(s), ends with ret
    mov byte ptr [ebp - field_minus_90], 0x7     # 00513b17
    ret                                          # 00513b1e
L_00513b1f:
    # block 0x00513b1f: entered by je at 0x00513b15, 3 instruction(s), ends with ret
    mov byte ptr [ebp - field_minus_90], 0x1     # 00513b1f
    fadd qword ptr [0x568924]                    # 00513b26
    ret                                          # 00513b2c

