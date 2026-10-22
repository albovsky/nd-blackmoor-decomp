# FUN_00426b4e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00426b4e
# extent:       0x00426b4e-0x00426b5d (15 code bytes)
# span:         0x00426b4e-0x00426b5d (code 15, tables 0, padding 0)
# sha256:       b36d89ef71f565fc7267915d9dbf19fbabca249832b592bdfd74e12c221d45c0
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m426b4e_lifted
# naming:       native port src/original_methods_fl40.c:m426b4e_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 1 seeds; oracle 6/6 instructions, 0/0 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00426b5d, FUN_00426b6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m426b4e_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_00426b5d, .text + (0x00426b5d - 0x401000)
.set FUN_00426b6c, .text + (0x00426b6c - 0x401000)

.org 0x00426b4e - 0x401000
.globl FUN_00426b4e
FUN_00426b4e:
    # block 0x00426b4e: entry, 6 instruction(s), calls FUN_00426b5d, FUN_00426b6c, ends with ret
    push ebp                                     # 00426b4e
    {load} mov ebp, esp                          # 00426b4f
    call FUN_00426b5d                            # 00426b51
    call FUN_00426b6c                            # 00426b56
    pop ebp                                      # 00426b5b
    ret                                          # 00426b5c

