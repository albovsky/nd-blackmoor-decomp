# FUN_004aaef5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004aaef5
# extent:       0x004aaef5-0x004aaf05 (16 code bytes)
# span:         0x004aaef5-0x004aaf05 (code 16, tables 0, padding 0)
# sha256:       909a70887aa2b835259c9f33759e8e80d5cd54c9636daa51e407d3f7c0f4e5f8
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004aaef5
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004aaef5 - 0x401000
.globl FUN_004aaef5
FUN_004aaef5:
    # block 0x004aaef5: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004aaef5
    {load} mov ebp, esp                          # 004aaef6
    push ecx                                     # 004aaef8
    mov dword ptr [ebp - local_4], ecx           # 004aaef9
    mov eax, 0x52de58                            # 004aaefc
    {load} mov esp, ebp                          # 004aaf01
    pop ebp                                      # 004aaf03
    ret                                          # 004aaf04

