# FUN_00406ce9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00406ce9
# extent:       0x00406ce9-0x00406d30 (71 code bytes)
# span:         0x00406ce9-0x00406d30 (code 71, tables 0, padding 0)
# sha256:       0cb31517ab08a08a7a81eef7851cb960e4bd075ea867b17961c2ad92ea50fd43
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00406ce9
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

.org 0x00406ce9 - 0x401000
.globl FUN_00406ce9
FUN_00406ce9:
    # block 0x00406ce9: entry, 6 instruction(s), ends with jne to 0x00406d05 (forward)
    push ebp                                     # 00406ce9
    {load} mov ebp, esp                          # 00406cea
    push ecx                                     # 00406cec
    mov dword ptr [ebp - local_4], ecx           # 00406ced
    cmp dword ptr [0x5e3556], 0x1                # 00406cf0
    jne.d8 L_00406d05                            # 00406cf7
    # block 0x00406cf9: entered by fall-through of jne at 0x00406cf7, 2 instruction(s), ends with forward jump to 0x00406d24
    mov dword ptr [0x5e3556], 0x0                # 00406cf9
    jmp.d8 L_00406d24                            # 00406d03
L_00406d05:
    # block 0x00406d05: entered by jne at 0x00406cf7, 4 instruction(s), ends with jne to 0x00406d24 (forward)
    mov dword ptr [0x5e3556], 0x1                # 00406d05
    movsx eax, word ptr [0x5e335e]               # 00406d0f
    cmp eax, 0x13                                # 00406d16
    jne.d8 L_00406d24                            # 00406d19
    # block 0x00406d1b: entered by fall-through of jne at 0x00406d19, 1 instruction(s), falls into the block at 0x00406d24
    mov word ptr [0x5e335e], 0xffff              # 00406d1b
L_00406d24:
    # block 0x00406d24: entered by jmp at 0x00406d03; jne at 0x00406d19, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00406d24
    call FUN_00404be1                            # 00406d27
    {load} mov esp, ebp                          # 00406d2c
    pop ebp                                      # 00406d2e
    ret                                          # 00406d2f

