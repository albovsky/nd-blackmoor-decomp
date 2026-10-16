# FUN_00406e4c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00406e4c
# extent:       0x00406e4c-0x00406e93 (71 code bytes)
# span:         0x00406e4c-0x00406e93 (code 71, tables 0, padding 0)
# sha256:       82add8b5dac548d0c669b1f604ce7d43cd4cb0d7d3b9d779e40a93433cbc4105
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00406e4c
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

.org 0x00406e4c - 0x401000
.globl FUN_00406e4c
FUN_00406e4c:
    # block 0x00406e4c: entry, 6 instruction(s), ends with jne to 0x00406e68 (forward)
    push ebp                                     # 00406e4c
    {load} mov ebp, esp                          # 00406e4d
    push ecx                                     # 00406e4f
    mov dword ptr [ebp - local_4], ecx           # 00406e50
    cmp dword ptr [0x5e356a], 0x1                # 00406e53
    jne.d8 L_00406e68                            # 00406e5a
    # block 0x00406e5c: entered by fall-through of jne at 0x00406e5a, 2 instruction(s), ends with forward jump to 0x00406e87
    mov dword ptr [0x5e356a], 0x0                # 00406e5c
    jmp.d8 L_00406e87                            # 00406e66
L_00406e68:
    # block 0x00406e68: entered by jne at 0x00406e5a, 4 instruction(s), ends with jne to 0x00406e87 (forward)
    mov dword ptr [0x5e356a], 0x1                # 00406e68
    movsx eax, word ptr [0x5e335e]               # 00406e72
    cmp eax, 0x18                                # 00406e79
    jne.d8 L_00406e87                            # 00406e7c
    # block 0x00406e7e: entered by fall-through of jne at 0x00406e7c, 1 instruction(s), falls into the block at 0x00406e87
    mov word ptr [0x5e335e], 0xffff              # 00406e7e
L_00406e87:
    # block 0x00406e87: entered by jmp at 0x00406e66; jne at 0x00406e7c, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00406e87
    call FUN_00404be1                            # 00406e8a
    {load} mov esp, ebp                          # 00406e8f
    pop ebp                                      # 00406e91
    ret                                          # 00406e92

