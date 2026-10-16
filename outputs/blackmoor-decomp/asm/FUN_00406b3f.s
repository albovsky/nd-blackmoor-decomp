# FUN_00406b3f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00406b3f
# extent:       0x00406b3f-0x00406b86 (71 code bytes)
# span:         0x00406b3f-0x00406b86 (code 71, tables 0, padding 0)
# sha256:       3fb7cd07a14dc56bd10c90426f581b1dd71c3c725be8efd2e9d515fa8e4b1dd3
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00406b3f
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

.org 0x00406b3f - 0x401000
.globl FUN_00406b3f
FUN_00406b3f:
    # block 0x00406b3f: entry, 6 instruction(s), ends with jne to 0x00406b5b (forward)
    push ebp                                     # 00406b3f
    {load} mov ebp, esp                          # 00406b40
    push ecx                                     # 00406b42
    mov dword ptr [ebp - local_4], ecx           # 00406b43
    cmp dword ptr [0x5e353e], 0x1                # 00406b46
    jne.d8 L_00406b5b                            # 00406b4d
    # block 0x00406b4f: entered by fall-through of jne at 0x00406b4d, 2 instruction(s), ends with forward jump to 0x00406b7a
    mov dword ptr [0x5e353e], 0x0                # 00406b4f
    jmp.d8 L_00406b7a                            # 00406b59
L_00406b5b:
    # block 0x00406b5b: entered by jne at 0x00406b4d, 4 instruction(s), ends with jne to 0x00406b7a (forward)
    mov dword ptr [0x5e353e], 0x1                # 00406b5b
    movsx eax, word ptr [0x5e335e]               # 00406b65
    cmp eax, 0xd                                 # 00406b6c
    jne.d8 L_00406b7a                            # 00406b6f
    # block 0x00406b71: entered by fall-through of jne at 0x00406b6f, 1 instruction(s), falls into the block at 0x00406b7a
    mov word ptr [0x5e335e], 0xffff              # 00406b71
L_00406b7a:
    # block 0x00406b7a: entered by jmp at 0x00406b59; jne at 0x00406b6f, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00406b7a
    call FUN_00404be1                            # 00406b7d
    {load} mov esp, ebp                          # 00406b82
    pop ebp                                      # 00406b84
    ret                                          # 00406b85

