# FUN_004cf749
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cf749
# extent:       0x004cf749-0x004cf7ac (99 code bytes)
# span:         0x004cf749-0x004cf7b0 (code 99, tables 0, padding 4)
# sha256:       786f97a67386792184f39c7fa87a23402b74d37f61f8e8a7784938e61add3eeb
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004cf749
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004c5377
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 26 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)

.org 0x004cf749 - 0x401000
.globl FUN_004cf749
FUN_004cf749:
    # block 0x004cf749: entry, 5 instruction(s), ends with jne to 0x004cf75a (forward)
    push ebp                                     # 004cf749
    {load} mov ebp, esp                          # 004cf74a
    sub esp, 0x10                                # 004cf74c
    cmp dword ptr [0x638433], 0x0                # 004cf74f
    jne.d8 L_004cf75a                            # 004cf756
    # block 0x004cf758: entered by fall-through of jne at 0x004cf756, 1 instruction(s), ends with forward jump to 0x004cf7a8
    jmp.d8 L_004cf7a8                            # 004cf758
L_004cf75a:
    # block 0x004cf75a: entered by jne at 0x004cf756, 6 instruction(s), ends with je to 0x004cf7a8 (forward)
    mov dword ptr [ebp - local_10], 0x638225     # 004cf75a
    mov dword ptr [ebp - local_4], 0x6383ff      # 004cf761
    mov dword ptr [ebp - local_c], 0x63840f      # 004cf768
    mov dword ptr [ebp - local_8], 0x583122      # 004cf76f
    cmp dword ptr [0x638423], 0x0                # 004cf776
    je.d8 L_004cf7a8                             # 004cf77d
    # block 0x004cf77f: entered by fall-through of je at 0x004cf77d, 11 instruction(s), calls FUN_004c5377, falls into the block at 0x004cf7a8
    push 0x559d94                                # 004cf77f
    mov eax, dword ptr [0x5d1a41]                # 004cf784
    push eax                                     # 004cf789
    mov ecx, dword ptr [0x5d1a3d]                # 004cf78a
    push ecx                                     # 004cf790
    mov edx, dword ptr [0x5cf665]                # 004cf791
    push edx                                     # 004cf797
    mov eax, dword ptr [0x5d1a39]                # 004cf798
    push eax                                     # 004cf79d
    mov ecx, 0x5cf659                            # 004cf79e
    call FUN_004c5377                            # 004cf7a3
L_004cf7a8:
    # block 0x004cf7a8: entered by jmp at 0x004cf758; je at 0x004cf77d, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004cf7a8
    pop ebp                                      # 004cf7aa
    ret                                          # 004cf7ab

# --- data items (not part of the function) -------------------------
.org 0x004cf7ac - 0x401000
PAD_004cf7ac:  # 4 byte(s) of int3 padding
    .fill 4, 1, 0xcc

