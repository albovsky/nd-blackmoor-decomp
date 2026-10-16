# FUN_00511a1a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00511a1a
# extent:       0x00511a1a-0x00511a58 (62 code bytes)
# span:         0x00511a1a-0x00511a58 (code 62, tables 0, padding 0)
# sha256:       329702861d21d8421c8826f99fcd8e5e73f3279336a37b709908149d1e573f70
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00511a1a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       3 ebp-relative slot(s): local_8, local_10, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 24 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_8, 0x8  # offset -0x8
.equ local_10, 0x10  # offset -0x10
.equ local_18, 0x18  # offset -0x18

# --- external targets -----------------------------------------------

.org 0x00511a1a - 0x401000
.globl FUN_00511a1a
FUN_00511a1a:
    # block 0x00511a1a: entry, 17 instruction(s), ends with jbe to 0x00511a54 (forward)
    push ebp                                     # 00511a1a
    {load} mov ebp, esp                          # 00511a1b
    sub esp, 0x18                                # 00511a1d
    fld qword ptr [0x5304b8]                     # 00511a20
    fstp qword ptr [ebp - local_8]               # 00511a26
    fld qword ptr [0x5304b0]                     # 00511a29
    fstp qword ptr [ebp - local_10]              # 00511a2f
    fld qword ptr [ebp - local_10]               # 00511a32
    fdiv qword ptr [ebp - local_8]               # 00511a35
    fmul qword ptr [ebp - local_8]               # 00511a38
    fsubr qword ptr [ebp - local_10]             # 00511a3b
    fstp qword ptr [ebp - local_18]              # 00511a3e
    fld qword ptr [ebp - local_18]               # 00511a41
    fcomp qword ptr [0x52c598]                   # 00511a44
    fnstsw ax                                    # 00511a4a
    sahf                                         # 00511a4c
    jbe.d8 L_00511a54                            # 00511a4d
    # block 0x00511a4f: entered by fall-through of jbe at 0x00511a4d, 4 instruction(s), ends with ret
    push 0x1                                     # 00511a4f
    pop eax                                      # 00511a51
    leave                                        # 00511a52
    ret                                          # 00511a53
L_00511a54:
    # block 0x00511a54: entered by jbe at 0x00511a4d, 3 instruction(s), ends with ret
    {load} xor eax, eax                          # 00511a54
    leave                                        # 00511a56
    ret                                          # 00511a57

