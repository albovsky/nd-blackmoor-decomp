# FUN_00426510
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00426510
# extent:       0x00426510-0x00426520 (16 code bytes)
# span:         0x00426510-0x00426520 (code 16, tables 0, padding 0)
# sha256:       a3e806b20fe8983acd67328b36155b260ee46306cdab85eec6e8d2da03b9bc31
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00426510
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

.org 0x00426510 - 0x401000
.globl FUN_00426510
FUN_00426510:
    # block 0x00426510: entry, 8 instruction(s), ends with ret
    push ebp                                     # 00426510
    {load} mov ebp, esp                          # 00426511
    push ecx                                     # 00426513
    mov dword ptr [ebp - local_4], ecx           # 00426514
    mov eax, 0x52c690                            # 00426517
    {load} mov esp, ebp                          # 0042651c
    pop ebp                                      # 0042651e
    ret                                          # 0042651f

