# FUN_00406879
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00406879
# extent:       0x00406879-0x004068c0 (71 code bytes)
# span:         0x00406879-0x004068c0 (code 71, tables 0, padding 0)
# sha256:       22d31a1d8e1af6a190fb649f240988be85eb980d28537b568279b669ecc596cf
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00406879
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

.org 0x00406879 - 0x401000
.globl FUN_00406879
FUN_00406879:
    # block 0x00406879: entry, 6 instruction(s), ends with jne to 0x00406895 (forward)
    push ebp                                     # 00406879
    {load} mov ebp, esp                          # 0040687a
    push ecx                                     # 0040687c
    mov dword ptr [ebp - local_4], ecx           # 0040687d
    cmp dword ptr [0x5e3516], 0x1                # 00406880
    jne.d8 L_00406895                            # 00406887
    # block 0x00406889: entered by fall-through of jne at 0x00406887, 2 instruction(s), ends with forward jump to 0x004068b4
    mov dword ptr [0x5e3516], 0x0                # 00406889
    jmp.d8 L_004068b4                            # 00406893
L_00406895:
    # block 0x00406895: entered by jne at 0x00406887, 4 instruction(s), ends with jne to 0x004068b4 (forward)
    mov dword ptr [0x5e3516], 0x1                # 00406895
    movsx eax, word ptr [0x5e335e]               # 0040689f
    cmp eax, 0x3                                 # 004068a6
    jne.d8 L_004068b4                            # 004068a9
    # block 0x004068ab: entered by fall-through of jne at 0x004068a9, 1 instruction(s), falls into the block at 0x004068b4
    mov word ptr [0x5e335e], 0xffff              # 004068ab
L_004068b4:
    # block 0x004068b4: entered by jmp at 0x00406893; jne at 0x004068a9, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004068b4
    call FUN_00404be1                            # 004068b7
    {load} mov esp, ebp                          # 004068bc
    pop ebp                                      # 004068be
    ret                                          # 004068bf

