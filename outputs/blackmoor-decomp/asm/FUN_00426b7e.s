# FUN_00426b7e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00426b7e
# extent:       0x00426b7e-0x00426b8d (15 code bytes)
# span:         0x00426b7e-0x00426b8d (code 15, tables 0, padding 0)
# sha256:       59282f9809e147c21c29715f3a4e71e4f426afc4a79f8eca1e2e2c0f0e529839
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00426b7e
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00427420
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_00427420, .text + (0x00427420 - 0x401000)

.org 0x00426b7e - 0x401000
.globl FUN_00426b7e
FUN_00426b7e:
    # block 0x00426b7e: entry, 6 instruction(s), calls FUN_00427420, ends with ret
    push ebp                                     # 00426b7e
    {load} mov ebp, esp                          # 00426b7f
    mov ecx, 0x570388                            # 00426b81
    call FUN_00427420                            # 00426b86
    pop ebp                                      # 00426b8b
    ret                                          # 00426b8c

