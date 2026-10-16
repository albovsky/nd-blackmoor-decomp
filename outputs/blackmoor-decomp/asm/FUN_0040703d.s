# FUN_0040703d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040703d
# extent:       0x0040703d-0x00407084 (71 code bytes)
# span:         0x0040703d-0x00407084 (code 71, tables 0, padding 0)
# sha256:       3c88f8579236616ff50b95c2b6f61c238548e4dfec0424c1d2f668936e96d5c8
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040703d
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

.org 0x0040703d - 0x401000
.globl FUN_0040703d
FUN_0040703d:
    # block 0x0040703d: entry, 6 instruction(s), ends with jne to 0x00407059 (forward)
    push ebp                                     # 0040703d
    {load} mov ebp, esp                          # 0040703e
    push ecx                                     # 00407040
    mov dword ptr [ebp - local_4], ecx           # 00407041
    cmp dword ptr [0x5e3586], 0x1                # 00407044
    jne.d8 L_00407059                            # 0040704b
    # block 0x0040704d: entered by fall-through of jne at 0x0040704b, 2 instruction(s), ends with forward jump to 0x00407078
    mov dword ptr [0x5e3586], 0x0                # 0040704d
    jmp.d8 L_00407078                            # 00407057
L_00407059:
    # block 0x00407059: entered by jne at 0x0040704b, 4 instruction(s), ends with jne to 0x00407078 (forward)
    mov dword ptr [0x5e3586], 0x1                # 00407059
    movsx eax, word ptr [0x5e335e]               # 00407063
    cmp eax, 0x1f                                # 0040706a
    jne.d8 L_00407078                            # 0040706d
    # block 0x0040706f: entered by fall-through of jne at 0x0040706d, 1 instruction(s), falls into the block at 0x00407078
    mov word ptr [0x5e335e], 0xffff              # 0040706f
L_00407078:
    # block 0x00407078: entered by jmp at 0x00407057; jne at 0x0040706d, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00407078
    call FUN_00404be1                            # 0040707b
    {load} mov esp, ebp                          # 00407080
    pop ebp                                      # 00407082
    ret                                          # 00407083

