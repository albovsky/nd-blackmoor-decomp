# FUN_00472f00
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00472f00
# extent:       0x00472f00-0x00472f0a (10 code bytes)
# span:         0x00472f00-0x00472f0a (code 10, tables 0, padding 0)
# sha256:       299e86fecad40485ab940fb3e801b088c0a5f34a33b49006036d6d534e301266
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m472f00_lifted
# naming:       native port src/original_methods_fl40.c:m472f00_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 1 seeds; oracle 5/5 instructions, 0/0 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00472f0a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m472f00_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_00472f0a, .text + (0x00472f0a - 0x401000)

.org 0x00472f00 - 0x401000
.globl FUN_00472f00
FUN_00472f00:
    # block 0x00472f00: entry, 5 instruction(s), calls FUN_00472f0a, ends with ret
    push ebp                                     # 00472f00
    {load} mov ebp, esp                          # 00472f01
    call FUN_00472f0a                            # 00472f03
    pop ebp                                      # 00472f08
    ret                                          # 00472f09

