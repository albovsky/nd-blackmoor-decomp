# FUN_00514569
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00514569
# extent:       0x00514569-0x0051457b (18 code bytes)
# span:         0x00514569-0x0051457b (code 18, tables 0, padding 0)
# sha256:       a3cfd45fc82da22697161c8c1622c9c03d9cb2b967d72d4efec02688c38b8dfd
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00514569
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       1 ebp-relative slot(s): local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x00514569 - 0x401000
.globl FUN_00514569
FUN_00514569:
    # block 0x00514569: entry, 10 instruction(s), ends with ret
    push ebp                                     # 00514569
    {load} mov ebp, esp                          # 0051456a
    push ecx                                     # 0051456c
    push ecx                                     # 0051456d
    fld qword ptr [ebp + arg_8]                  # 0051456e
    frndint                                      # 00514571
    fstp qword ptr [ebp - local_8]               # 00514573
    fld qword ptr [ebp - local_8]                # 00514576
    leave                                        # 00514579
    ret                                          # 0051457a

