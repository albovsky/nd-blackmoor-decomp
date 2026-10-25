# FUN_00472f0a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00472f0a
# extent:       0x00472f0a-0x00472f21 (23 code bytes)
# span:         0x00472f0a-0x00472f21 (code 23, tables 0, padding 0)
# sha256:       a5990b2136603964433eefd8e70697f4b316e7bb884a2a42363cc8301d03df86
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00472f0a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x00472f0a - 0x401000
.globl FUN_00472f0a
FUN_00472f0a:
    # block 0x00472f0a: entry, 7 instruction(s), ends with ret
    push ebp                                     # 00472f0a
    {load} mov ebp, esp                          # 00472f0b
    fld dword ptr [0x54c598]                     # 00472f0d
    fdiv dword ptr [0x54c59c]                    # 00472f13
    fstp dword ptr [0x63a878]                    # 00472f19
    pop ebp                                      # 00472f1f
    ret                                          # 00472f20

