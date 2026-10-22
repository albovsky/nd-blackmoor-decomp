# FUN_004d00d2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d00d2
# extent:       0x004d00d2-0x004d00f4 (34 code bytes)
# span:         0x004d00d2-0x004d00f4 (code 34, tables 0, padding 0)
# sha256:       e3928b4da2cf2d52ebe24fb53e0d1f5e8a8fbd6fde6fa2ba48f072f993eca103
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d00d2_lifted
# naming:       native port src/original_methods_fl39d.c:m4d00d2_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (11 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; no conditional jumps.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004e0742, FUN_004e119b
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4d00d2_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_004e0742, .text + (0x004e0742 - 0x401000)
.set FUN_004e119b, .text + (0x004e119b - 0x401000)

.org 0x004d00d2 - 0x401000
.globl FUN_004d00d2
FUN_004d00d2:
    # block 0x004d00d2: entry, 9 instruction(s), calls FUN_004e0742, FUN_004e119b, ends with ret
    push ebp                                     # 004d00d2
    {load} mov ebp, esp                          # 004d00d3
    mov ecx, 0x570508                            # 004d00d5
    call FUN_004e0742                            # 004d00da
    mov ecx, 0x570508                            # 004d00df
    call FUN_004e119b                            # 004d00e4
    mov word ptr [0x5bb1c4], 0x2                 # 004d00e9
    pop ebp                                      # 004d00f2
    ret                                          # 004d00f3

