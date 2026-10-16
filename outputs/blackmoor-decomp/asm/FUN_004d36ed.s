# FUN_004d36ed
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d36ed
# extent:       0x004d36ed-0x004d3705 (24 code bytes)
# span:         0x004d36ed-0x004d3705 (code 24, tables 0, padding 0)
# sha256:       9949b20e1d1c1364cc73cb7b0bc45e9da93e653d2d387c30bed3a017f13064fd
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d36ed
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_36_runtime.c:overlay36_step (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x004d36ed - 0x401000
.globl FUN_004d36ed
FUN_004d36ed:
    # block 0x004d36ed: entry, 6 instruction(s), ends with ret
    push ebp                                     # 004d36ed
    {load} mov ebp, esp                          # 004d36ee
    mov dword ptr [0x5831c8], 0x1                # 004d36f0
    mov word ptr [0x5831c6], 0x0                 # 004d36fa
    pop ebp                                      # 004d3703
    ret                                          # 004d3704

