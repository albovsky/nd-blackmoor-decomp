# FUN_0040888e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040888e
# extent:       0x0040888e-0x004088c9 (59 code bytes)
# span:         0x0040888e-0x004088c9 (code 59, tables 0, padding 0)
# sha256:       f814376ffc11b94aab447ff12aeef644ecadd0b6a4de78ab9e47f2b384db749c
# evidence:     ev_f077da93048f8988a96399f357fa9b0d462c71f5ee4ac3437f49adc8ae869a09
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040888e
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050cb1b, FUN_00407ca7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18

# --- external targets -----------------------------------------------
.set FUN_00407ca7, .text + (0x00407ca7 - 0x401000)
.set FUN_0050cb1b, .text + (0x0050cb1b - 0x401000)
.set FUN_0051d5b2, .text + (0x0051d5b2 - 0x401000)

.org 0x0040888e - 0x401000
.globl FUN_0040888e
FUN_0040888e:
    # block 0x0040888e: entry, 20 instruction(s), calls FUN_0051d5b2, FUN_0050cb1b, FUN_00407ca7, ends with ret
    push ebp                                     # 0040888e
    {load} mov ebp, esp                          # 0040888f
    sub esp, 0x18                                # 00408891
    mov dword ptr [ebp - local_18], ecx          # 00408894
    push 0x13                                    # 00408897
    lea eax, [ebp - local_14]                    # 00408899
    push eax                                     # 0040889c
    mov ecx, dword ptr [ebp - local_18]          # 0040889d
    add ecx, 0x88c                               # 004088a0
    call FUN_0051d5b2                            # 004088a6
    lea ecx, [ebp - local_14]                    # 004088ab
    push ecx                                     # 004088ae
    call FUN_0050cb1b                            # 004088af
    add esp, 0x4                                 # 004088b4
    mov word ptr [0x5ec2ce], ax                  # 004088b7
    mov ecx, dword ptr [ebp - local_18]          # 004088bd
    call FUN_00407ca7                            # 004088c0
    {load} mov esp, ebp                          # 004088c5
    pop ebp                                      # 004088c7
    ret                                          # 004088c8

