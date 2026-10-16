# FUN_005255b9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005255b9
# extent:       0x005255b9-0x005255d4 (27 code bytes)
# span:         0x005255b9-0x005255d4 (code 27, tables 0, padding 0)
# sha256:       db1fe2eebd85474e3772ecfdac574a9c3c50b62df1fa88388b872fdfe7f1fc10
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005255ad (+0xc)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005255b9
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump FUN_0050c539
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005255d4
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050c539, .text + (0x0050c539 - 0x401000)

.org 0x005255b9 - 0x401000
.globl FUN_005255b9
FUN_005255b9:
    # block 0x005255b9: entry, 2 instruction(s), ends with jne to 0x005255d3 (forward)
    test byte ptr [0x63c448], 0x1                # 005255b9
    jne.d8 L_005255d3                            # 005255c0
    # block 0x005255c2: entered by fall-through of jne at 0x005255c0, 3 instruction(s), ends with backward jump to 0x0050c539
    or byte ptr [0x63c448], 0x1                  # 005255c2
    mov ecx, 0x63c5a8                            # 005255c9
    jmp.d32 FUN_0050c539                         # 005255ce
L_005255d3:
    # block 0x005255d3: entered by jne at 0x005255c0, 1 instruction(s), ends with ret
    ret                                          # 005255d3

