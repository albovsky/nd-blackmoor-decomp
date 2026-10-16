# FUN_00406af8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00406af8
# extent:       0x00406af8-0x00406b3f (71 code bytes)
# span:         0x00406af8-0x00406b3f (code 71, tables 0, padding 0)
# sha256:       45f4193694350f353c81befc9240f6969a3a2d98324895c51284497e24a16338
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00406af8
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

.org 0x00406af8 - 0x401000
.globl FUN_00406af8
FUN_00406af8:
    # block 0x00406af8: entry, 6 instruction(s), ends with jne to 0x00406b14 (forward)
    push ebp                                     # 00406af8
    {load} mov ebp, esp                          # 00406af9
    push ecx                                     # 00406afb
    mov dword ptr [ebp - local_4], ecx           # 00406afc
    cmp dword ptr [0x5e353a], 0x1                # 00406aff
    jne.d8 L_00406b14                            # 00406b06
    # block 0x00406b08: entered by fall-through of jne at 0x00406b06, 2 instruction(s), ends with forward jump to 0x00406b33
    mov dword ptr [0x5e353a], 0x0                # 00406b08
    jmp.d8 L_00406b33                            # 00406b12
L_00406b14:
    # block 0x00406b14: entered by jne at 0x00406b06, 4 instruction(s), ends with jne to 0x00406b33 (forward)
    mov dword ptr [0x5e353a], 0x1                # 00406b14
    movsx eax, word ptr [0x5e335e]               # 00406b1e
    cmp eax, 0xc                                 # 00406b25
    jne.d8 L_00406b33                            # 00406b28
    # block 0x00406b2a: entered by fall-through of jne at 0x00406b28, 1 instruction(s), falls into the block at 0x00406b33
    mov word ptr [0x5e335e], 0xffff              # 00406b2a
L_00406b33:
    # block 0x00406b33: entered by jmp at 0x00406b12; jne at 0x00406b28, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00406b33
    call FUN_00404be1                            # 00406b36
    {load} mov esp, ebp                          # 00406b3b
    pop ebp                                      # 00406b3d
    ret                                          # 00406b3e

