# FUN_004262ac
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004262ac
# extent:       0x004262ac-0x00426300 (84 code bytes)
# span:         0x004262ac-0x00426300 (code 84, tables 0, padding 0)
# sha256:       eaf9a97772d8fd6a3cbc8e6c54aabe6a702d38c70f88f19e0739ebbcea2d1813
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004262ac
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004fc97d, FUN_0050ca3e, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 21 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004fc97d, .text + (0x004fc97d - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004262ac - 0x401000
.globl FUN_004262ac
FUN_004262ac:
    # block 0x004262ac: entry, 10 instruction(s), calls FUN_004fc97d, ends with je to 0x004262fe (forward)
    push ebp                                     # 004262ac
    {load} mov ebp, esp                          # 004262ad
    mov ecx, 0x5c3a67                            # 004262af
    call FUN_004fc97d                            # 004262b4
    mov eax, dword ptr [0x583989]                # 004262b9
    mov dword ptr [0x583981], eax                # 004262be
    mov dword ptr [0x5d2f09], 0x1                # 004262c3
    movsx ecx, word ptr [0x63a4cd]               # 004262cd
    test ecx, ecx                                # 004262d4
    je.d8 L_004262fe                             # 004262d6
    # block 0x004262d8: entered by fall-through of je at 0x004262d6, 9 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004262fe
    mov edx, dword ptr [0x583981]                # 004262d8
    push edx                                     # 004262de
    push 0x5453e4                                # 004262df
    push 0x63888b                                # 004262e4
    call FUN_0050ca3e                            # 004262e9
    add esp, 0xc                                 # 004262ee
    push 0x63888b                                # 004262f1
    call FUN_0044a2b7                            # 004262f6
    add esp, 0x4                                 # 004262fb
L_004262fe:
    # block 0x004262fe: entered by je at 0x004262d6, 2 instruction(s), ends with ret
    pop ebp                                      # 004262fe
    ret                                          # 004262ff

