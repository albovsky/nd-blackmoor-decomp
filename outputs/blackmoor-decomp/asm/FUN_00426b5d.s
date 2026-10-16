# FUN_00426b5d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00426b5d
# extent:       0x00426b5d-0x00426b6c (15 code bytes)
# span:         0x00426b5d-0x00426b6c (code 15, tables 0, padding 0)
# sha256:       5919f013b811c4bea2ea01ef7429548545e4a2ae5406e3d481f721346d792c36
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00426b5d
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00426520
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_00426520, .text + (0x00426520 - 0x401000)

.org 0x00426b5d - 0x401000
.globl FUN_00426b5d
FUN_00426b5d:
    # block 0x00426b5d: entry, 6 instruction(s), calls FUN_00426520, ends with ret
    push ebp                                     # 00426b5d
    {load} mov ebp, esp                          # 00426b5e
    mov ecx, 0x570388                            # 00426b60
    call FUN_00426520                            # 00426b65
    pop ebp                                      # 00426b6a
    ret                                          # 00426b6b

