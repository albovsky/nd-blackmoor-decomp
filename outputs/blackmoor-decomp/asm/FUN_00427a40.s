# FUN_00427a40
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00427a40
# extent:       0x00427a40-0x00427a45 (5 code bytes)
# span:         0x00427a40-0x00427a50 (code 5, tables 0, padding 11)
# sha256:       7178bc05f1e5707e6c3dae3e068488f3df05d53b0e5eb728edd1abc56533f087
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00427a40
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x00427a40 - 0x401000
.globl FUN_00427a40
FUN_00427a40:
    # block 0x00427a40: entry, 4 instruction(s), ends with ret
    push ebp                                     # 00427a40
    {load} mov ebp, esp                          # 00427a41
    pop ebp                                      # 00427a43
    ret                                          # 00427a44

# --- data items (not part of the function) -------------------------
.org 0x00427a45 - 0x401000
PAD_00427a45:  # 11 byte(s) of int3 padding
    .fill 11, 1, 0xcc

