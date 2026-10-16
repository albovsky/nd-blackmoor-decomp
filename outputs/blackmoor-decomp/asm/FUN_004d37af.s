# FUN_004d37af
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d37af
# extent:       0x004d37af-0x004d3836 (135 code bytes)
# span:         0x004d37af-0x004d3836 (code 135, tables 0, padding 0)
# sha256:       3c1e15e9acc3b3c3b0a2be514da505abb9055c3a2e04bed6c00231e20ae7546c
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d37af
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004c5377, FUN_004c5d4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 37 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)

.org 0x004d37af - 0x401000
.globl FUN_004d37af
FUN_004d37af:
    # block 0x004d37af: entry, 26 instruction(s), calls FUN_004c5377, FUN_004c5d4b, ends with je to 0x004d3834 (forward)
    push ebp                                     # 004d37af
    {load} mov ebp, esp                          # 004d37b0
    push 0x55a3c4                                # 004d37b2
    mov eax, dword ptr [0x5d19ad]                # 004d37b7
    push eax                                     # 004d37bc
    push 0x5b50cf                                # 004d37bd
    mov ecx, dword ptr [0x5cf665]                # 004d37c2
    push ecx                                     # 004d37c8
    mov edx, dword ptr [0x5d03bb]                # 004d37c9
    push edx                                     # 004d37cf
    mov ecx, 0x5cf659                            # 004d37d0
    call FUN_004c5377                            # 004d37d5
    push 0x55a3d4                                # 004d37da
    mov eax, dword ptr [0x5d19ad]                # 004d37df
    push eax                                     # 004d37e4
    mov ecx, dword ptr [0x5d19a9]                # 004d37e5
    push ecx                                     # 004d37eb
    mov edx, dword ptr [0x5cf665]                # 004d37ec
    push edx                                     # 004d37f2
    mov eax, dword ptr [0x5d19a5]                # 004d37f3
    push eax                                     # 004d37f8
    mov ecx, 0x5cf659                            # 004d37f9
    call FUN_004c5d4b                            # 004d37fe
    movsx ecx, word ptr [0x5b5104]               # 004d3803
    test ecx, ecx                                # 004d380a
    je.d8 L_004d3834                             # 004d380c
    # block 0x004d380e: entered by fall-through of je at 0x004d380c, 9 instruction(s), calls FUN_004c5d4b, falls into the block at 0x004d3834
    push 0x55a3e4                                # 004d380e
    push 0x5b50bf                                # 004d3813
    push 0x5b50af                                # 004d3818
    mov edx, dword ptr [0x5cf665]                # 004d381d
    push edx                                     # 004d3823
    mov eax, dword ptr [0x5d03cb]                # 004d3824
    push eax                                     # 004d3829
    mov ecx, 0x5cf659                            # 004d382a
    call FUN_004c5d4b                            # 004d382f
L_004d3834:
    # block 0x004d3834: entered by je at 0x004d380c, 2 instruction(s), ends with ret
    pop ebp                                      # 004d3834
    ret                                          # 004d3835

