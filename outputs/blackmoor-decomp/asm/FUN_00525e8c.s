# FUN_00525e8c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525e8c
# extent:       0x00525e8c-0x00525e9c (16 code bytes)
# span:         0x00525e8c-0x00525e9c (code 16, tables 0, padding 0)
# sha256:       7521fcec1329a840fd71b40e9332fcaf104711fba8b387f2c122c356224f640e
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00525e69 (+0x23)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525e8c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00525e69
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00525e9c
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_00525e69, .text + (0x00525e69 - 0x401000)

.org 0x00525e8c - 0x401000
.globl FUN_00525e8c
FUN_00525e8c:
    # block 0x00525e8c: entry, 1 instruction(s), ends with forward jump to 0x00525e91
    jmp.d32 L_00525e91                           # 00525e8c
L_00525e91:
    # block 0x00525e91: entered by jmp at 0x00525e8c, 3 instruction(s), calls FUN_00525e69, ends with ret
    call FUN_00525e69                            # 00525e91
    mov dword ptr [0x63c7b4], eax                # 00525e96
    ret                                          # 00525e9b

