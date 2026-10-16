# FUN_00525c6b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525c6b
# extent:       0x00525c6b-0x00525c93 (40 code bytes)
# span:         0x00525c6b-0x00525c93 (code 40, tables 0, padding 0)
# sha256:       98ac50ba29515b17fb6973f90119ecc7d270a331ff5d0501fc8707cd6c23f194
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00525c51 (+0x1a)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525c6b
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00525751
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00525c93
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_00525751, .text + (0x00525751 - 0x401000)

.org 0x00525c6b - 0x401000
.globl FUN_00525c6b
FUN_00525c6b:
    # block 0x00525c6b: entry, 2 instruction(s), ends with je to 0x00525c7c (forward)
    cmp dword ptr [0x63c700], 0x0                # 00525c6b
    je.d8 L_00525c7c                             # 00525c72
    # block 0x00525c74: entered by fall-through of je at 0x00525c72, 2 instruction(s), ends with jne to 0x00525c92 (forward)
    dec dword ptr [0x63c700]                     # 00525c74
    jne.d8 L_00525c92                            # 00525c7a
L_00525c7c:
    # block 0x00525c7c: entered by je at 0x00525c72; fall-through of jne at 0x00525c7a, 3 instruction(s), ends with je to 0x00525c92 (forward)
    mov ecx, dword ptr [0x63c704]                # 00525c7c
    test ecx, ecx                                # 00525c82
    je.d8 L_00525c92                             # 00525c84
    # block 0x00525c86: entered by fall-through of je at 0x00525c84, 2 instruction(s), calls FUN_00525751, falls into the block at 0x00525c92
    call FUN_00525751                            # 00525c86
    and dword ptr [0x63c704], 0x0                # 00525c8b
L_00525c92:
    # block 0x00525c92: entered by jne at 0x00525c7a; je at 0x00525c84, 1 instruction(s), ends with ret
    ret                                          # 00525c92

