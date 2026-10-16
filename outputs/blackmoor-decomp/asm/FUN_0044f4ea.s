# FUN_0044f4ea
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044f4ea
# extent:       0x0044f4ea-0x0044f4fa (16 code bytes)
# span:         0x0044f4ea-0x0044f4fa (code 16, tables 0, padding 0)
# sha256:       18851bc3bb2c6ea980b60c1ceb7613fbecda388651515edf13d9a8c574e89e84
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044f4ea
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

.org 0x0044f4ea - 0x401000
.globl FUN_0044f4ea
FUN_0044f4ea:
    # block 0x0044f4ea: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0044f4ea
    {load} mov ebp, esp                          # 0044f4eb
    push ecx                                     # 0044f4ed
    mov dword ptr [ebp - local_4], ecx           # 0044f4ee
    mov eax, 0x52cca0                            # 0044f4f1
    {load} mov esp, ebp                          # 0044f4f6
    pop ebp                                      # 0044f4f8
    ret                                          # 0044f4f9

