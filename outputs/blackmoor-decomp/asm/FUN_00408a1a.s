# FUN_00408a1a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00408a1a
# extent:       0x00408a1a-0x00408a2a (16 code bytes)
# span:         0x00408a1a-0x00408a2a (code 16, tables 0, padding 0)
# sha256:       beb535bd6058a3100d2379055c8c26c5fb716b9decf3d564000c1859823a66af
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00408a1a
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

.org 0x00408a1a - 0x401000
.globl FUN_00408a1a
FUN_00408a1a:
    # block 0x00408a1a: entry, 8 instruction(s), ends with ret
    push ebp                                     # 00408a1a
    {load} mov ebp, esp                          # 00408a1b
    push ecx                                     # 00408a1d
    mov dword ptr [ebp - local_4], ecx           # 00408a1e
    mov eax, 0x52bfc8                            # 00408a21
    {load} mov esp, ebp                          # 00408a26
    pop ebp                                      # 00408a28
    ret                                          # 00408a29

