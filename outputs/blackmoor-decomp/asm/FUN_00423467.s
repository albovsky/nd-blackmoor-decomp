# FUN_00423467
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00423467
# extent:       0x00423467-0x0042347b (20 code bytes)
# span:         0x00423467-0x0042347b (code 20, tables 0, padding 0)
# sha256:       d2e1f9c2f7bd966f2b5e3d0441e2c812263dd31c51eb6c65573d9b37174ec1c0
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00423467
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x00423467 - 0x401000
.globl FUN_00423467
FUN_00423467:
    # block 0x00423467: entry, 9 instruction(s), ends with ret
    push ebp                                     # 00423467
    {load} mov ebp, esp                          # 00423468
    push ecx                                     # 0042346a
    mov dword ptr [ebp - local_4], ecx           # 0042346b
    mov eax, dword ptr [ebp - local_4]           # 0042346e
    mov dword ptr [eax], 0x52c688                # 00423471
    {load} mov esp, ebp                          # 00423477
    pop ebp                                      # 00423479
    ret                                          # 0042347a

