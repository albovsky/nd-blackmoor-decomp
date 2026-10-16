# FUN_00423450
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00423450
# extent:       0x00423450-0x00423467 (23 code bytes)
# span:         0x00423450-0x00423467 (code 23, tables 0, padding 0)
# sha256:       2e0b3c0353a3c82a5bef4ba20a98934703be2f57030b5a2be910bb14594f8b67
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00423450
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x00423450 - 0x401000
.globl FUN_00423450
FUN_00423450:
    # block 0x00423450: entry, 10 instruction(s), ends with ret
    push ebp                                     # 00423450
    {load} mov ebp, esp                          # 00423451
    push ecx                                     # 00423453
    mov dword ptr [ebp - local_4], ecx           # 00423454
    mov eax, dword ptr [ebp - local_4]           # 00423457
    mov dword ptr [eax], 0x52c688                # 0042345a
    mov eax, dword ptr [ebp - local_4]           # 00423460
    {load} mov esp, ebp                          # 00423463
    pop ebp                                      # 00423465
    ret                                          # 00423466

