# FUN_005146bf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005146bf
# extent:       0x005146bf-0x005146cd (14 code bytes)
# span:         0x005146bf-0x005146cd (code 14, tables 0, padding 0)
# sha256:       ec1ff5a2a5c9e9472dafb0f5a1cb5f92b04e34be30aff6826b9fac202c50f0ba
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005146bf
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       1 ebp-relative slot(s): local_2
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_2, 0x2  # offset -0x2

# --- external targets -----------------------------------------------

.org 0x005146bf - 0x401000
.globl FUN_005146bf
FUN_005146bf:
    # block 0x005146bf: entry, 8 instruction(s), ends with ret
    push ebp                                     # 005146bf
    {load} mov ebp, esp                          # 005146c0
    push ecx                                     # 005146c2
    wait                                         # 005146c3
    fnstsw word ptr [ebp - local_2]              # 005146c4
    movsx eax, word ptr [ebp - local_2]          # 005146c7
    leave                                        # 005146cb
    ret                                          # 005146cc

