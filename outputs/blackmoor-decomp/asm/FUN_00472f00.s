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
# name:         fn_00472f00
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00472f0a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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

