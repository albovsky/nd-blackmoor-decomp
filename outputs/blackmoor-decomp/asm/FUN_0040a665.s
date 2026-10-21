# FUN_0040a665
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040a665
# extent:       0x0040a665-0x0040a6b7 (82 code bytes)
# span:         0x0040a665-0x0040a6b7 (code 82, tables 0, padding 0)
# sha256:       ec8082fa512d6af069c21c0fedabe7b1ca56ed465c1698083159b9e09dcea8de
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m40a665_read_tag_word
# naming:       native port src/original_methods_fl32b.c:m40a665_read_tag_word (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Twin of 0x40a613 on field self+0x10c, tag 0x53ec60 and word 0x5ec2da (own constants checked separately); returns 0x4090ab(self). Every instruction run, je taken both ways.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050cb1b, FUN_004090ab
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl32b.c:m40a665_read_tag_word (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 30 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18

# --- external targets -----------------------------------------------
.set FUN_004090ab, .text + (0x004090ab - 0x401000)
.set FUN_0050cb1b, .text + (0x0050cb1b - 0x401000)
.set FUN_0051d5b2, .text + (0x0051d5b2 - 0x401000)

.org 0x0040a665 - 0x401000
.globl FUN_0040a665
FUN_0040a665:
    # block 0x0040a665: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040a6a9 (forward)
    push ebp                                     # 0040a665
    {load} mov ebp, esp                          # 0040a666
    sub esp, 0x18                                # 0040a668
    push esi                                     # 0040a66b
    push edi                                     # 0040a66c
    mov dword ptr [ebp - local_18], ecx          # 0040a66d
    push 0x13                                    # 0040a670
    lea eax, [ebp - local_14]                    # 0040a672
    push eax                                     # 0040a675
    mov ecx, dword ptr [ebp - local_18]          # 0040a676
    add ecx, 0x10c                               # 0040a679
    call FUN_0051d5b2                            # 0040a67f
    mov edi, 0x53ec60                            # 0040a684
    lea esi, [ebp - local_14]                    # 0040a689
    mov ecx, 0x4                                 # 0040a68c
    {load} xor edx, edx                          # 0040a691
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040a693
    je.d8 L_0040a6a9                             # 0040a695
    # block 0x0040a697: entered by fall-through of je at 0x0040a695, 5 instruction(s), calls FUN_0050cb1b, falls into the block at 0x0040a6a9
    lea eax, [ebp - local_14]                    # 0040a697
    push eax                                     # 0040a69a
    call FUN_0050cb1b                            # 0040a69b
    add esp, 0x4                                 # 0040a6a0
    mov word ptr [0x5ec2da], ax                  # 0040a6a3
L_0040a6a9:
    # block 0x0040a6a9: entered by je at 0x0040a695, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040a6a9
    call FUN_004090ab                            # 0040a6ac
    pop edi                                      # 0040a6b1
    pop esi                                      # 0040a6b2
    {load} mov esp, ebp                          # 0040a6b3
    pop ebp                                      # 0040a6b5
    ret                                          # 0040a6b6

