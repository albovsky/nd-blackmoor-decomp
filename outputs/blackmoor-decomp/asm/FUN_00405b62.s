# FUN_00405b62
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00405b62
# extent:       0x00405b62-0x00405b72 (16 code bytes)
# span:         0x00405b62-0x00405b72 (code 16, tables 0, padding 0)
# sha256:       0596cac464420b708f1267e2bf7aacb351ca95ccc6cc776218d039c4fc3a22f9
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00405b62
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

.org 0x00405b62 - 0x401000
.globl FUN_00405b62
FUN_00405b62:
    # block 0x00405b62: entry, 8 instruction(s), ends with ret
    push ebp                                     # 00405b62
    {load} mov ebp, esp                          # 00405b63
    push ecx                                     # 00405b65
    mov dword ptr [ebp - local_4], ecx           # 00405b66
    mov eax, 0x52b370                            # 00405b69
    {load} mov esp, ebp                          # 00405b6e
    pop ebp                                      # 00405b70
    ret                                          # 00405b71

