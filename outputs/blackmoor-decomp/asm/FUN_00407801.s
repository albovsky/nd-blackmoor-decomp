# FUN_00407801
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00407801
# extent:       0x00407801-0x00407848 (71 code bytes)
# span:         0x00407801-0x00407848 (code 71, tables 0, padding 0)
# sha256:       b7b7b25b5c9294787ab813380ce043c756c2bdfcfa29e9d4036bc570644c8509
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00407801
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

.org 0x00407801 - 0x401000
.globl FUN_00407801
FUN_00407801:
    # block 0x00407801: entry, 6 instruction(s), ends with jne to 0x0040781d (forward)
    push ebp                                     # 00407801
    {load} mov ebp, esp                          # 00407802
    push ecx                                     # 00407804
    mov dword ptr [ebp - local_4], ecx           # 00407805
    cmp dword ptr [0x5e35f6], 0x1                # 00407808
    jne.d8 L_0040781d                            # 0040780f
    # block 0x00407811: entered by fall-through of jne at 0x0040780f, 2 instruction(s), ends with forward jump to 0x0040783c
    mov dword ptr [0x5e35f6], 0x0                # 00407811
    jmp.d8 L_0040783c                            # 0040781b
L_0040781d:
    # block 0x0040781d: entered by jne at 0x0040780f, 4 instruction(s), ends with jne to 0x0040783c (forward)
    mov dword ptr [0x5e35f6], 0x1                # 0040781d
    movsx eax, word ptr [0x5e335e]               # 00407827
    cmp eax, 0x3b                                # 0040782e
    jne.d8 L_0040783c                            # 00407831
    # block 0x00407833: entered by fall-through of jne at 0x00407831, 1 instruction(s), falls into the block at 0x0040783c
    mov word ptr [0x5e335e], 0xffff              # 00407833
L_0040783c:
    # block 0x0040783c: entered by jmp at 0x0040781b; jne at 0x00407831, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 0040783c
    call FUN_00404be1                            # 0040783f
    {load} mov esp, ebp                          # 00407844
    pop ebp                                      # 00407846
    ret                                          # 00407847

