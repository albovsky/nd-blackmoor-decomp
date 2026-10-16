# FUN_005255f9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005255f9
# extent:       0x005255f9-0x00525614 (27 code bytes)
# span:         0x005255f9-0x00525614 (code 27, tables 0, padding 0)
# sha256:       41e4d1273c7a260cf5f58b0db7126529832f42e81c3b313e23460436e8cbed1a
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005255ed (+0xc)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005255f9
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump FUN_0050c539
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00525614
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050c539, .text + (0x0050c539 - 0x401000)

.org 0x005255f9 - 0x401000
.globl FUN_005255f9
FUN_005255f9:
    # block 0x005255f9: entry, 2 instruction(s), ends with jne to 0x00525613 (forward)
    test byte ptr [0x63c448], 0x2                # 005255f9
    jne.d8 L_00525613                            # 00525600
    # block 0x00525602: entered by fall-through of jne at 0x00525600, 3 instruction(s), ends with backward jump to 0x0050c539
    or byte ptr [0x63c448], 0x2                  # 00525602
    mov ecx, 0x63c580                            # 00525609
    jmp.d32 FUN_0050c539                         # 0052560e
L_00525613:
    # block 0x00525613: entered by jne at 0x00525600, 1 instruction(s), ends with ret
    ret                                          # 00525613

