# FUN_0051a7a8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a7a8
# extent:       0x0051a7a8-0x0051a7c3 (27 code bytes)
# span:         0x0051a7a8-0x0051a7c3 (code 27, tables 0, padding 0)
# sha256:       20ae6f5c5d5c4ba6a80cb05f8f4c10130f6dd5e0b397d44922dd1006aea837af
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051a79c (+0xc)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a7a8
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump FUN_0051b257
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0051b257, .text + (0x0051b257 - 0x401000)

.org 0x0051a7a8 - 0x401000
.globl FUN_0051a7a8
FUN_0051a7a8:
    # block 0x0051a7a8: entry, 2 instruction(s), ends with jne to 0x0051a7c2 (forward)
    test byte ptr [0x63c314], 0x8                # 0051a7a8
    jne.d8 L_0051a7c2                            # 0051a7af
    # block 0x0051a7b1: entered by fall-through of jne at 0x0051a7af, 3 instruction(s), ends with forward jump to 0x0051b257
    or byte ptr [0x63c314], 0x8                  # 0051a7b1
    mov ecx, 0x63c258                            # 0051a7b8
    jmp.d32 FUN_0051b257                         # 0051a7bd
L_0051a7c2:
    # block 0x0051a7c2: entered by jne at 0x0051a7af, 1 instruction(s), ends with ret
    ret                                          # 0051a7c2

