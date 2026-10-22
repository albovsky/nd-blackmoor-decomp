# FUN_0049c46c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0049c46c
# extent:       0x0049c46c-0x0049c48a (30 code bytes)
# span:         0x0049c46c-0x0049c490 (code 30, tables 0, padding 6)
# sha256:       66999a8a92e083431d98cdcf39a5855bf77b19b876daa77e6e9a46e2ecf4e195
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m49c46c_lifted
# naming:       native port src/original_methods_fl39d.c:m49c46c_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (11 recipes, original bytes run under Unicorn; golden vectors in the direct test); Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00494ccc, FUN_004c952f
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m49c46c_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_00494ccc, .text + (0x00494ccc - 0x401000)
.set FUN_004c952f, .text + (0x004c952f - 0x401000)

.org 0x0049c46c - 0x401000
.globl FUN_0049c46c
FUN_0049c46c:
    # block 0x0049c46c: entry, 9 instruction(s), calls FUN_00494ccc, FUN_004c952f, ends with ret
    push ebp                                     # 0049c46c
    {load} mov ebp, esp                          # 0049c46d
    mov ecx, 0x630a9a                            # 0049c46f
    call FUN_00494ccc                            # 0049c474
    push 0x583186                                # 0049c479
    mov ecx, 0x5cf659                            # 0049c47e
    call FUN_004c952f                            # 0049c483
    pop ebp                                      # 0049c488
    ret                                          # 0049c489

# --- data items (not part of the function) -------------------------
.org 0x0049c48a - 0x401000
PAD_0049c48a:  # 6 byte(s) of int3 padding
    .fill 6, 1, 0xcc

