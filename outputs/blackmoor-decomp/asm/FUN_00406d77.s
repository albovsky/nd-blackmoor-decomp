# FUN_00406d77
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00406d77
# extent:       0x00406d77-0x00406dbe (71 code bytes)
# span:         0x00406d77-0x00406dbe (code 71, tables 0, padding 0)
# sha256:       aec4db864608fac5b66a8135fb11180d4cb0832fa67ab9be0f27f19b22df37b9
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00406d77
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x00406d77 - 0x401000
.globl FUN_00406d77
FUN_00406d77:
    # block 0x00406d77: entry, 6 instruction(s), ends with jne to 0x00406d93 (forward)
    push ebp                                     # 00406d77
    {load} mov ebp, esp                          # 00406d78
    push ecx                                     # 00406d7a
    mov dword ptr [ebp - local_4], ecx           # 00406d7b
    cmp dword ptr [0x5e355e], 0x1                # 00406d7e
    jne.d8 L_00406d93                            # 00406d85
    # block 0x00406d87: entered by fall-through of jne at 0x00406d85, 2 instruction(s), ends with forward jump to 0x00406db2
    mov dword ptr [0x5e355e], 0x0                # 00406d87
    jmp.d8 L_00406db2                            # 00406d91
L_00406d93:
    # block 0x00406d93: entered by jne at 0x00406d85, 4 instruction(s), ends with jne to 0x00406db2 (forward)
    mov dword ptr [0x5e355e], 0x1                # 00406d93
    movsx eax, word ptr [0x5e335e]               # 00406d9d
    cmp eax, 0x15                                # 00406da4
    jne.d8 L_00406db2                            # 00406da7
    # block 0x00406da9: entered by fall-through of jne at 0x00406da7, 1 instruction(s), falls into the block at 0x00406db2
    mov word ptr [0x5e335e], 0xffff              # 00406da9
L_00406db2:
    # block 0x00406db2: entered by jmp at 0x00406d91; jne at 0x00406da7, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00406db2
    call FUN_00404be1                            # 00406db5
    {load} mov esp, ebp                          # 00406dba
    pop ebp                                      # 00406dbc
    ret                                          # 00406dbd

