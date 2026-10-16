# FUN_004076e5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004076e5
# extent:       0x004076e5-0x0040772c (71 code bytes)
# span:         0x004076e5-0x0040772c (code 71, tables 0, padding 0)
# sha256:       bf5dc8aafe3c584980250e8d109e85c746e4e667ba616ef327cbfc4c812bc377
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004076e5
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

.org 0x004076e5 - 0x401000
.globl FUN_004076e5
FUN_004076e5:
    # block 0x004076e5: entry, 6 instruction(s), ends with jne to 0x00407701 (forward)
    push ebp                                     # 004076e5
    {load} mov ebp, esp                          # 004076e6
    push ecx                                     # 004076e8
    mov dword ptr [ebp - local_4], ecx           # 004076e9
    cmp dword ptr [0x5e35e6], 0x1                # 004076ec
    jne.d8 L_00407701                            # 004076f3
    # block 0x004076f5: entered by fall-through of jne at 0x004076f3, 2 instruction(s), ends with forward jump to 0x00407720
    mov dword ptr [0x5e35e6], 0x0                # 004076f5
    jmp.d8 L_00407720                            # 004076ff
L_00407701:
    # block 0x00407701: entered by jne at 0x004076f3, 4 instruction(s), ends with jne to 0x00407720 (forward)
    mov dword ptr [0x5e35e6], 0x1                # 00407701
    movsx eax, word ptr [0x5e335e]               # 0040770b
    cmp eax, 0x37                                # 00407712
    jne.d8 L_00407720                            # 00407715
    # block 0x00407717: entered by fall-through of jne at 0x00407715, 1 instruction(s), falls into the block at 0x00407720
    mov word ptr [0x5e335e], 0xffff              # 00407717
L_00407720:
    # block 0x00407720: entered by jmp at 0x004076ff; jne at 0x00407715, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00407720
    call FUN_00404be1                            # 00407723
    {load} mov esp, ebp                          # 00407728
    pop ebp                                      # 0040772a
    ret                                          # 0040772b

