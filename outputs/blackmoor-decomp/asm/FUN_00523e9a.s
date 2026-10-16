# FUN_00523e9a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00523e9a
# extent:       0x00523e9a-0x00523eaa (16 code bytes)
# span:         0x00523e9a-0x00523eaa (code 16, tables 0, padding 0)
# sha256:       69f56614dbab4a4aea6c5ad672fcec9529d51d9ef364862e28778efb2ae0b21e
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00523dcf (+0xcb)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00523e9a
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_1c
# callees:      calls FUN_0051c1b5
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0051c1b5, .text + (0x0051c1b5 - 0x401000)

.org 0x00523e9a - 0x401000
.globl FUN_00523e9a
FUN_00523e9a:
    # block 0x00523e9a: entry, 5 instruction(s), calls FUN_0051c1b5, ends with ret
    push 0x1                                     # 00523e9a
    push 0xe801                                  # 00523e9c
    push dword ptr [ecx + field_1c]              # 00523ea1
    call FUN_0051c1b5                            # 00523ea4
    ret                                          # 00523ea9

