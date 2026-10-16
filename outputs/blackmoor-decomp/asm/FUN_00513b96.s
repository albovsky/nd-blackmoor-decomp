# FUN_00513b96
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513b96
# extent:       0x00513b96-0x00513bb3 (29 code bytes)
# span:         0x00513b96-0x00513bb3 (code 29, tables 0, padding 0)
# sha256:       d50ed39d2a2cf6c8ee99aad30b849d0f728d5c1906b378aea612464f1422c99e
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00513a57 (+0x13f)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00513b96
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_90
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00513bb3
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_90, 0x90  # offset -0x90

# --- external targets -----------------------------------------------

.org 0x00513b96 - 0x401000
.globl FUN_00513b96
FUN_00513b96:
    # block 0x00513b96: entry, 5 instruction(s), ends with jg to 0x00513bb0 (forward)
    fstp st(0)                                   # 00513b96
    fstp st(0)                                   # 00513b98
    fld tbyte ptr [0x568910]                     # 00513b9a
    cmp byte ptr [ebp - field_minus_90], 0x0     # 00513ba0
    jg.d8 L_00513bb0                             # 00513ba7
    # block 0x00513ba9: entered by fall-through of jg at 0x00513ba7, 1 instruction(s), falls into the block at 0x00513bb0
    mov byte ptr [ebp - field_minus_90], 0x1     # 00513ba9
L_00513bb0:
    # block 0x00513bb0: entered by jg at 0x00513ba7, 2 instruction(s), ends with ret
    {load} or cl, cl                             # 00513bb0
    ret                                          # 00513bb2

