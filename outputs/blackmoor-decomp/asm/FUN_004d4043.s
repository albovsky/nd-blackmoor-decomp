# FUN_004d4043
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d4043
# extent:       0x004d4043-0x004d4074 (49 code bytes)
# span:         0x004d4043-0x004d4074 (code 49, tables 0, padding 0)
# sha256:       2957d274232c4f66aa923f532fddd631cd6eefa4343034082f561ec76e10b91d
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d4043
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004c5377
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 16 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)

.org 0x004d4043 - 0x401000
.globl FUN_004d4043
FUN_004d4043:
    # block 0x004d4043: entry, 16 instruction(s), calls FUN_004c5377, ends with ret
    push ebp                                     # 004d4043
    {load} mov ebp, esp                          # 004d4044
    push ecx                                     # 004d4046
    mov dword ptr [ebp - local_4], ecx           # 004d4047
    push 0x55a4b4                                # 004d404a
    push 0x61c497                                # 004d404f
    push 0x61c7b5                                # 004d4054
    mov eax, dword ptr [0x5cf665]                # 004d4059
    push eax                                     # 004d405e
    mov ecx, dword ptr [0x5d0377]                # 004d405f
    push ecx                                     # 004d4065
    mov ecx, 0x5cf659                            # 004d4066
    call FUN_004c5377                            # 004d406b
    {load} mov esp, ebp                          # 004d4070
    pop ebp                                      # 004d4072
    ret                                          # 004d4073

