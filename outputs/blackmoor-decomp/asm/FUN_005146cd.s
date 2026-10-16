# FUN_005146cd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005146cd
# extent:       0x005146cd-0x005146dc (15 code bytes)
# span:         0x005146cd-0x005146dc (code 15, tables 0, padding 0)
# sha256:       c0a83fcece4fd3c4558b705fa545326c97ce36193c3dea69335c7882ebf36c1c
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005146cd
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

.org 0x005146cd - 0x401000
.globl FUN_005146cd
FUN_005146cd:
    # block 0x005146cd: entry, 8 instruction(s), ends with ret
    push ebp                                     # 005146cd
    {load} mov ebp, esp                          # 005146ce
    push ecx                                     # 005146d0
    fnstsw word ptr [ebp - local_2]              # 005146d1
    fnclex                                       # 005146d4
    movsx eax, word ptr [ebp - local_2]          # 005146d6
    leave                                        # 005146da
    ret                                          # 005146db

