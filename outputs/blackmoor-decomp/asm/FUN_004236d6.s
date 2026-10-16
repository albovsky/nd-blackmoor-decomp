# FUN_004236d6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004236d6
# extent:       0x004236d6-0x00423755 (127 code bytes)
# span:         0x004236d6-0x00423755 (code 127, tables 0, padding 0)
# sha256:       d3e12ee43fdc94129c88d28e0a7b257960663e21e8779a3158cf51845492361a
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004236d6
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0052139c, FUN_0044a2b7, FUN_004c97b4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 41 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004236d6 - 0x401000
.globl FUN_004236d6
FUN_004236d6:
    # block 0x004236d6: entry, 13 instruction(s), calls FUN_0051dc43, ends with jne to 0x0042370d (forward)
    push ebp                                     # 004236d6
    {load} mov ebp, esp                          # 004236d7
    sub esp, 0xc                                 # 004236d9
    push edi                                     # 004236dc
    mov dword ptr [ebp - local_c], ecx           # 004236dd
    push 0x1c                                    # 004236e0
    call FUN_0051dc43                            # 004236e2
    add esp, 0x4                                 # 004236e7
    mov dword ptr [ebp - local_8], eax           # 004236ea
    mov eax, dword ptr [ebp - local_8]           # 004236ed
    mov dword ptr [ebp - local_4], eax           # 004236f0
    cmp dword ptr [ebp - local_4], 0x0           # 004236f3
    jne.d8 L_0042370d                            # 004236f7
    # block 0x004236f9: entered by fall-through of jne at 0x004236f7, 5 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x0042374e
    push 0x5445f8                                # 004236f9
    push 0x63888b                                # 004236fe
    call FUN_0050ca3e                            # 00423703
    add esp, 0x8                                 # 00423708
    jmp.d8 L_0042374e                            # 0042370b
L_0042370d:
    # block 0x0042370d: entered by jne at 0x004236f7, 6 instruction(s), ends with forward jump to 0x00423750
    mov ecx, 0x7                                 # 0042370d
    {load} xor eax, eax                          # 00423712
    mov edi, dword ptr [ebp - local_4]           # 00423714
    rep stosd dword ptr es:[edi], eax            # 00423717
    mov eax, dword ptr [ebp - local_4]           # 00423719
    jmp.d8 L_00423750                            # 0042371c
L_0042371e:
    # block 0x0042371e: entered by jmp at 0x0042374e, 7 instruction(s), calls FUN_0052139c, ends with je to 0x00423744 (forward)
    push 0x0                                     # 0042371e
    push 0x0                                     # 00423720
    push 0x63888b                                # 00423722
    call FUN_0052139c                            # 00423727
    movsx ecx, word ptr [0x63a4cd]               # 0042372c
    test ecx, ecx                                # 00423733
    je.d8 L_00423744                             # 00423735
    # block 0x00423737: entered by fall-through of je at 0x00423735, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00423744
    push 0x63888b                                # 00423737
    call FUN_0044a2b7                            # 0042373c
    add esp, 0x4                                 # 00423741
L_00423744:
    # block 0x00423744: entered by je at 0x00423735, 2 instruction(s), calls FUN_004c97b4, falls into the block at 0x0042374e
    mov ecx, 0x5cf659                            # 00423744
    call FUN_004c97b4                            # 00423749
L_0042374e:
    # block 0x0042374e: entered by jmp at 0x0042370b, 1 instruction(s), ends with backward jump to 0x0042371e
    jmp.d8 L_0042371e                            # 0042374e
L_00423750:
    # block 0x00423750: entered by jmp at 0x0042371c, 4 instruction(s), ends with ret
    pop edi                                      # 00423750
    {load} mov esp, ebp                          # 00423751
    pop ebp                                      # 00423753
    ret                                          # 00423754

