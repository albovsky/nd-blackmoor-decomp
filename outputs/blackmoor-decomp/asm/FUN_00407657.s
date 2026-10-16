# FUN_00407657
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00407657
# extent:       0x00407657-0x0040769e (71 code bytes)
# span:         0x00407657-0x0040769e (code 71, tables 0, padding 0)
# sha256:       935da61b59fa464e491b00aa773d143b896908cc57138cfadeff2465a8d410eb
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00407657
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

.org 0x00407657 - 0x401000
.globl FUN_00407657
FUN_00407657:
    # block 0x00407657: entry, 6 instruction(s), ends with jne to 0x00407673 (forward)
    push ebp                                     # 00407657
    {load} mov ebp, esp                          # 00407658
    push ecx                                     # 0040765a
    mov dword ptr [ebp - local_4], ecx           # 0040765b
    cmp dword ptr [0x5e35de], 0x1                # 0040765e
    jne.d8 L_00407673                            # 00407665
    # block 0x00407667: entered by fall-through of jne at 0x00407665, 2 instruction(s), ends with forward jump to 0x00407692
    mov dword ptr [0x5e35de], 0x0                # 00407667
    jmp.d8 L_00407692                            # 00407671
L_00407673:
    # block 0x00407673: entered by jne at 0x00407665, 4 instruction(s), ends with jne to 0x00407692 (forward)
    mov dword ptr [0x5e35de], 0x1                # 00407673
    movsx eax, word ptr [0x5e335e]               # 0040767d
    cmp eax, 0x35                                # 00407684
    jne.d8 L_00407692                            # 00407687
    # block 0x00407689: entered by fall-through of jne at 0x00407687, 1 instruction(s), falls into the block at 0x00407692
    mov word ptr [0x5e335e], 0xffff              # 00407689
L_00407692:
    # block 0x00407692: entered by jmp at 0x00407671; jne at 0x00407687, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00407692
    call FUN_00404be1                            # 00407695
    {load} mov esp, ebp                          # 0040769a
    pop ebp                                      # 0040769c
    ret                                          # 0040769d

