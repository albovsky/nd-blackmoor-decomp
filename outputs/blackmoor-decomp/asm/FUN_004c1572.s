# FUN_004c1572
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c1572
# extent:       0x004c1572-0x004c1716 (420 code bytes)
# span:         0x004c1572-0x004c1716 (code 420, tables 0, padding 0)
# sha256:       e76c13b22544cecbf5a16020c7e107a2c2ea763ca97c85853b653e778ab22811
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_main_window_creator
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4c1572.c.txt, not original source) refers to the data labelled s_Nancy_Drew__The_Curse_of_Blackmo_00552d64
# name-note:    Registers the window class, allocates a helper object, and creates the Nancy Drew Curse of Blackmoor Manor main window unless one already exists (FindWindow).
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       8 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18, local_1c, local_20, local_24
# fields:       [eax + n] field_38ac; [ecx + n] field_1c
# callees:      calls FUN_004c1451, FUN_0051dc43, FUN_0043eb3a, USER32.dll!FindWindowA, FUN_0051abe4, FUN_0051b125, USER32.dll!GetSystemMetrics, FUN_0051d699, FUN_0051d630, USER32.dll!UpdateWindow
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 112 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ field_1c, 0x1c  # offset +0x1c
.equ field_38ac, 0x38ac  # offset +0x38ac

# --- external targets -----------------------------------------------
.set FUN_0043eb3a, .text + (0x0043eb3a - 0x401000)
.set FUN_004c1451, .text + (0x004c1451 - 0x401000)
.set FUN_0051abe4, .text + (0x0051abe4 - 0x401000)
.set FUN_0051b125, .text + (0x0051b125 - 0x401000)
.set FUN_0051d630, .text + (0x0051d630 - 0x401000)
.set FUN_0051d699, .text + (0x0051d699 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004c1572 - 0x401000
.globl FUN_004c1572
FUN_004c1572:
    # block 0x004c1572: entry, 18 instruction(s), calls FUN_004c1451, FUN_0051dc43, ends with je to 0x004c15c2 (forward)
    push ebp                                     # 004c1572
    {load} mov ebp, esp                          # 004c1573
    push -0x1                                    # 004c1575
    push 0x5287fe                                # 004c1577
    mov eax, dword ptr fs:[0x0]                  # 004c157c
    push eax                                     # 004c1582
    mov dword ptr fs:[0x0], esp                  # 004c1583
    sub esp, 0x18                                # 004c158a
    mov dword ptr [ebp - local_20], ecx          # 004c158d
    mov ecx, dword ptr [ebp - local_20]          # 004c1590
    call FUN_004c1451                            # 004c1593
    push 0xbc                                    # 004c1598
    call FUN_0051dc43                            # 004c159d
    add esp, 0x4                                 # 004c15a2
    mov dword ptr [ebp - local_14], eax          # 004c15a5
    mov dword ptr [ebp - local_4], 0x0           # 004c15a8
    cmp dword ptr [ebp - local_14], 0x0          # 004c15af
    je.d8 L_004c15c2                             # 004c15b3
    # block 0x004c15b5: entered by fall-through of je at 0x004c15b3, 4 instruction(s), calls FUN_0043eb3a, ends with forward jump to 0x004c15c9
    mov ecx, dword ptr [ebp - local_14]          # 004c15b5
    call FUN_0043eb3a                            # 004c15b8
    mov dword ptr [ebp - local_24], eax          # 004c15bd
    jmp.d8 L_004c15c9                            # 004c15c0
L_004c15c2:
    # block 0x004c15c2: entered by je at 0x004c15b3, 1 instruction(s), falls into the block at 0x004c15c9
    mov dword ptr [ebp - local_24], 0x0          # 004c15c2
L_004c15c9:
    # block 0x004c15c9: entered by jmp at 0x004c15c0, 7 instruction(s), ends with jne to 0x004c15ef (forward)
    mov eax, dword ptr [ebp - local_24]          # 004c15c9
    mov dword ptr [ebp - local_10], eax          # 004c15cc
    mov dword ptr [ebp - local_4], 0xffffffff    # 004c15cf
    mov ecx, dword ptr [ebp - local_10]          # 004c15d6
    mov dword ptr [0x57044c], ecx                # 004c15d9
    cmp dword ptr [0x57044c], 0x0                # 004c15df
    jne.d8 L_004c15ef                            # 004c15e6
    # block 0x004c15e8: entered by fall-through of jne at 0x004c15e6, 2 instruction(s), ends with forward jump to 0x004c1708
    {load} xor eax, eax                          # 004c15e8
    jmp.d32 L_004c1708                           # 004c15ea
L_004c15ef:
    # block 0x004c15ef: entered by jne at 0x004c15e6, 10 instruction(s), calls USER32.dll!FindWindowA, FUN_0051abe4, ends with je to 0x004c1628 (forward)
    mov edx, dword ptr [0x57044c]                # 004c15ef
    mov dword ptr [0x5703a4], edx                # 004c15f5
    push 0x552d64                                # 004c15fb
    push 0x0                                     # 004c1600
    call dword ptr [0x52a494]                    # 004c1602
    push eax                                     # 004c1608
    call FUN_0051abe4                            # 004c1609
    mov dword ptr [ebp - local_18], eax          # 004c160e
    cmp dword ptr [ebp - local_18], 0x0          # 004c1611
    je.d8 L_004c1628                             # 004c1615
    # block 0x004c1617: entered by fall-through of je at 0x004c1615, 3 instruction(s), ends with forward jump to 0x004c1708
    mov dword ptr [0x63a561], 0x1                # 004c1617
    {load} xor eax, eax                          # 004c1621
    jmp.d32 L_004c1708                           # 004c1623
L_004c1628:
    # block 0x004c1628: entered by je at 0x004c1615, 3 instruction(s), ends with je to 0x004c1688 (forward)
    mov eax, dword ptr [ebp - local_20]          # 004c1628
    cmp dword ptr [eax + field_38ac], 0x0        # 004c162b
    je.d8 L_004c1688                             # 004c1632
    # block 0x004c1634: entered by fall-through of je at 0x004c1632, 20 instruction(s), calls FUN_0051b125, ends with jne to 0x004c1686 (forward)
    push 0x0                                     # 004c1634
    push 0x0                                     # 004c1636
    push 0x0                                     # 004c1638
    movsx ecx, word ptr [0x63988d]               # 004c163a
    push ecx                                     # 004c1641
    movsx edx, word ptr [0x63988b]               # 004c1642
    push edx                                     # 004c1649
    movsx eax, word ptr [0x639891]               # 004c164a
    push eax                                     # 004c1651
    movsx ecx, word ptr [0x63988f]               # 004c1652
    push ecx                                     # 004c1659
    push 0x90000000                              # 004c165a
    push 0x552d90                                # 004c165f
    mov edx, dword ptr [0x570448]                # 004c1664
    push edx                                     # 004c166a
    push 0x300                                   # 004c166b
    mov ecx, dword ptr [0x57044c]                # 004c1670
    call FUN_0051b125                            # 004c1676
    test eax, eax                                # 004c167b
    jne.d8 L_004c1686                            # 004c167d
    # block 0x004c167f: entered by fall-through of jne at 0x004c167d, 2 instruction(s), ends with forward jump to 0x004c1708
    {load} xor eax, eax                          # 004c167f
    jmp.d32 L_004c1708                           # 004c1681
L_004c1686:
    # block 0x004c1686: entered by jne at 0x004c167d, 1 instruction(s), ends with forward jump to 0x004c16d6
    jmp.d8 L_004c16d6                            # 004c1686
L_004c1688:
    # block 0x004c1688: entered by je at 0x004c1632, 22 instruction(s), calls USER32.dll!GetSystemMetrics, FUN_0051b125, ends with jne to 0x004c16d6 (forward)
    push 0x0                                     # 004c1688
    push 0x0                                     # 004c168a
    push 0x0                                     # 004c168c
    push 0x1                                     # 004c168e
    call dword ptr [0x52a498]                    # 004c1690
    push eax                                     # 004c1696
    push 0x0                                     # 004c1697
    call dword ptr [0x52a498]                    # 004c1699
    push eax                                     # 004c169f
    movsx eax, word ptr [0x639891]               # 004c16a0
    push eax                                     # 004c16a7
    movsx ecx, word ptr [0x63988f]               # 004c16a8
    push ecx                                     # 004c16af
    push 0x90000000                              # 004c16b0
    push 0x552dbc                                # 004c16b5
    mov edx, dword ptr [0x570448]                # 004c16ba
    push edx                                     # 004c16c0
    push 0x8                                     # 004c16c1
    mov ecx, dword ptr [0x57044c]                # 004c16c3
    call FUN_0051b125                            # 004c16c9
    test eax, eax                                # 004c16ce
    jne.d8 L_004c16d6                            # 004c16d0
    # block 0x004c16d2: entered by fall-through of jne at 0x004c16d0, 2 instruction(s), ends with forward jump to 0x004c1708
    {load} xor eax, eax                          # 004c16d2
    jmp.d8 L_004c1708                            # 004c16d4
L_004c16d6:
    # block 0x004c16d6: entered by jmp at 0x004c1686; jne at 0x004c16d0, 12 instruction(s), calls FUN_0051d699, FUN_0051d630, USER32.dll!UpdateWindow, falls into the block at 0x004c1708
    mov ecx, dword ptr [0x57044c]                # 004c16d6
    call FUN_0051d699                            # 004c16dc
    push 0x5                                     # 004c16e1
    mov ecx, dword ptr [0x57044c]                # 004c16e3
    call FUN_0051d630                            # 004c16e9
    mov eax, dword ptr [0x57044c]                # 004c16ee
    mov dword ptr [ebp - local_1c], eax          # 004c16f3
    mov ecx, dword ptr [ebp - local_1c]          # 004c16f6
    mov edx, dword ptr [ecx + field_1c]          # 004c16f9
    push edx                                     # 004c16fc
    call dword ptr [0x52a49c]                    # 004c16fd
    mov eax, 0x1                                 # 004c1703
L_004c1708:
    # block 0x004c1708: entered by jmp at 0x004c15ea; jmp at 0x004c1623; jmp at 0x004c1681; jmp at 0x004c16d4, 5 instruction(s), ends with ret
    mov ecx, dword ptr [ebp - local_c]           # 004c1708
    mov dword ptr fs:[0x0], ecx                  # 004c170b
    {load} mov esp, ebp                          # 004c1712
    pop ebp                                      # 004c1714
    ret                                          # 004c1715

