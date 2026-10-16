# FUN_00525f31
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525f31
# extent:       0x00525f31-0x00525f40 (15 code bytes)
# span:         0x00525f31-0x00525f40 (code 15, tables 0, padding 0)
# sha256:       92562d338bc0b6cc6b34433be830ce4b73669f7fcb162b5f4e2cc3a43a936206
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525f31
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050c511
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050c511, .text + (0x0050c511 - 0x401000)

.org 0x00525f31 - 0x401000
.globl FUN_00525f31
FUN_00525f31:
    # block 0x00525f31: entry, 5 instruction(s), calls FUN_0050c511, ends with ret
    push 0x40                                    # 00525f31
    push 0x8                                     # 00525f33
    mov ecx, 0x63c7c0                            # 00525f35
    call FUN_0050c511                            # 00525f3a
    ret                                          # 00525f3f

