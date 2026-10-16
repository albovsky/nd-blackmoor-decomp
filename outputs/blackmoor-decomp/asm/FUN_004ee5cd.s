# FUN_004ee5cd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ee5cd
# extent:       0x004ee5cd-0x004ee5dd (16 code bytes)
# span:         0x004ee5cd-0x004ee5dd (code 16, tables 0, padding 0)
# sha256:       a77aabb5ee3354c532fbb09347549cd2a846faa4c9be42891dd10c1835fa2717
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ee5cd
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/session_exit.c:session_exit_state4 (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004ee5cd - 0x401000
.globl FUN_004ee5cd
FUN_004ee5cd:
    # block 0x004ee5cd: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004ee5cd
    {load} mov ebp, esp                          # 004ee5ce
    push ecx                                     # 004ee5d0
    mov dword ptr [ebp - local_4], ecx           # 004ee5d1
    mov eax, dword ptr [0x55cd94]                # 004ee5d4
    {load} mov esp, ebp                          # 004ee5d9
    pop ebp                                      # 004ee5db
    ret                                          # 004ee5dc

