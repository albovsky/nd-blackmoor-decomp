# FUN_0040753b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040753b
# extent:       0x0040753b-0x00407582 (71 code bytes)
# span:         0x0040753b-0x00407582 (code 71, tables 0, padding 0)
# sha256:       ef2487eca40acb62ec002b68198cc80094fc0ae29e457b40951e84c950b536b2
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040753b
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

.org 0x0040753b - 0x401000
.globl FUN_0040753b
FUN_0040753b:
    # block 0x0040753b: entry, 6 instruction(s), ends with jne to 0x00407557 (forward)
    push ebp                                     # 0040753b
    {load} mov ebp, esp                          # 0040753c
    push ecx                                     # 0040753e
    mov dword ptr [ebp - local_4], ecx           # 0040753f
    cmp dword ptr [0x5e35ce], 0x1                # 00407542
    jne.d8 L_00407557                            # 00407549
    # block 0x0040754b: entered by fall-through of jne at 0x00407549, 2 instruction(s), ends with forward jump to 0x00407576
    mov dword ptr [0x5e35ce], 0x0                # 0040754b
    jmp.d8 L_00407576                            # 00407555
L_00407557:
    # block 0x00407557: entered by jne at 0x00407549, 4 instruction(s), ends with jne to 0x00407576 (forward)
    mov dword ptr [0x5e35ce], 0x1                # 00407557
    movsx eax, word ptr [0x5e335e]               # 00407561
    cmp eax, 0x31                                # 00407568
    jne.d8 L_00407576                            # 0040756b
    # block 0x0040756d: entered by fall-through of jne at 0x0040756b, 1 instruction(s), falls into the block at 0x00407576
    mov word ptr [0x5e335e], 0xffff              # 0040756d
L_00407576:
    # block 0x00407576: entered by jmp at 0x00407555; jne at 0x0040756b, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00407576
    call FUN_00404be1                            # 00407579
    {load} mov esp, ebp                          # 0040757e
    pop ebp                                      # 00407580
    ret                                          # 00407581

