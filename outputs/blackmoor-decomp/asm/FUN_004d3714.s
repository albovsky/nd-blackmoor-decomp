# FUN_004d3714
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d3714
# extent:       0x004d3714-0x004d3723 (15 code bytes)
# span:         0x004d3714-0x004d3723 (code 15, tables 0, padding 0)
# sha256:       a203d6164df6bce20fc3bebd99491ad912031a3af737862fb0e6840975b4b2ce
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_taskbar_restore_layer_callback
# naming:       INFERRED (lower confidence, not verified): the repository text src/caption_lifecycle.c:1201 says "layer 11 (0x4d3714 ->"
# name-note:    Layer 11 render callback that forwards to the task bar restore 0x4e1157.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004e1157
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_004e1157, .text + (0x004e1157 - 0x401000)

.org 0x004d3714 - 0x401000
.globl FUN_004d3714
FUN_004d3714:
    # block 0x004d3714: entry, 6 instruction(s), calls FUN_004e1157, ends with ret
    push ebp                                     # 004d3714
    {load} mov ebp, esp                          # 004d3715
    mov ecx, 0x570508                            # 004d3717
    call FUN_004e1157                            # 004d371c
    pop ebp                                      # 004d3721
    ret                                          # 004d3722

