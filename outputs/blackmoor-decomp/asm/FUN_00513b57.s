# FUN_00513b57
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513b57
# extent:       0x00513b57-0x00513b96 (63 code bytes)
# span:         0x00513b57-0x00513b96 (code 63, tables 0, padding 0)
# sha256:       4bb2a6e8f917353df919b2a51118ec3bb396418a7017ee4d72c9b6ef86528dae
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00513a57 (+0x100)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00513b57
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_90, field_minus_97, field_minus_9e
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 14 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00513b96
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_90, 0x90  # offset -0x90
.equ field_minus_97, 0x97  # offset -0x97
.equ field_minus_9e, 0x9e  # offset -0x9e

# --- external targets -----------------------------------------------

.org 0x00513b57 - 0x401000
.globl FUN_00513b57
FUN_00513b57:
    # block 0x00513b57: entry, 4 instruction(s), ends with je to 0x00513b8c (forward)
    fstp tbyte ptr [ebp - field_minus_9e]        # 00513b57
    fld tbyte ptr [ebp - field_minus_9e]         # 00513b5d
    test byte ptr [ebp - field_minus_97], 0x40   # 00513b63
    je.d8 L_00513b8c                             # 00513b6a
    # block 0x00513b6c: entered by fall-through of je at 0x00513b6a, 5 instruction(s), ends with je to 0x00513b8c (forward)
    fxch st(1)                                   # 00513b6c
    fstp tbyte ptr [ebp - field_minus_9e]        # 00513b6e
    fld tbyte ptr [ebp - field_minus_9e]         # 00513b74
    test byte ptr [ebp - field_minus_97], 0x40   # 00513b7a
    je.d8 L_00513b8c                             # 00513b81
    # block 0x00513b83: entered by fall-through of je at 0x00513b81, 2 instruction(s), ends with forward jump to 0x00513b93
    mov byte ptr [ebp - field_minus_90], 0x7     # 00513b83
    jmp.d8 L_00513b93                            # 00513b8a
L_00513b8c:
    # block 0x00513b8c: entered by je at 0x00513b6a; je at 0x00513b81, 1 instruction(s), falls into the block at 0x00513b93
    mov byte ptr [ebp - field_minus_90], 0x1     # 00513b8c
L_00513b93:
    # block 0x00513b93: entered by jmp at 0x00513b8a, 2 instruction(s), ends with ret
    faddp st(1), st                              # 00513b93
    ret                                          # 00513b95

