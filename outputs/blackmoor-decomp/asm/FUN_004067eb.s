# FUN_004067eb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004067eb
# extent:       0x004067eb-0x00406832 (71 code bytes)
# span:         0x004067eb-0x00406832 (code 71, tables 0, padding 0)
# sha256:       c4834236247b443370b247ba307fc6cb0946695f838663c9c4479e7bcb872677
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004067eb
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

.org 0x004067eb - 0x401000
.globl FUN_004067eb
FUN_004067eb:
    # block 0x004067eb: entry, 6 instruction(s), ends with jne to 0x00406807 (forward)
    push ebp                                     # 004067eb
    {load} mov ebp, esp                          # 004067ec
    push ecx                                     # 004067ee
    mov dword ptr [ebp - local_4], ecx           # 004067ef
    cmp dword ptr [0x5e350e], 0x1                # 004067f2
    jne.d8 L_00406807                            # 004067f9
    # block 0x004067fb: entered by fall-through of jne at 0x004067f9, 2 instruction(s), ends with forward jump to 0x00406826
    mov dword ptr [0x5e350e], 0x0                # 004067fb
    jmp.d8 L_00406826                            # 00406805
L_00406807:
    # block 0x00406807: entered by jne at 0x004067f9, 4 instruction(s), ends with jne to 0x00406826 (forward)
    mov dword ptr [0x5e350e], 0x1                # 00406807
    movsx eax, word ptr [0x5e335e]               # 00406811
    cmp eax, 0x1                                 # 00406818
    jne.d8 L_00406826                            # 0040681b
    # block 0x0040681d: entered by fall-through of jne at 0x0040681b, 1 instruction(s), falls into the block at 0x00406826
    mov word ptr [0x5e335e], 0xffff              # 0040681d
L_00406826:
    # block 0x00406826: entered by jmp at 0x00406805; jne at 0x0040681b, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00406826
    call FUN_00404be1                            # 00406829
    {load} mov esp, ebp                          # 0040682e
    pop ebp                                      # 00406830
    ret                                          # 00406831

