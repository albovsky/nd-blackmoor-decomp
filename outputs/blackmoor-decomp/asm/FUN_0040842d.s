# FUN_0040842d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040842d
# extent:       0x0040842d-0x00408468 (59 code bytes)
# span:         0x0040842d-0x00408468 (code 59, tables 0, padding 0)
# sha256:       64db73e3e75a7ad1971329d90b497b77123a0c4b4b33420b0e8d3b38d6ae3346
# evidence:     ev_f077da93048f8988a96399f357fa9b0d462c71f5ee4ac3437f49adc8ae869a09
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040842d
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

.org 0x0040842d - 0x401000
.globl FUN_0040842d
FUN_0040842d:
    # block 0x0040842d: entry, 20 instruction(s), calls FUN_0051d5b2, FUN_0050cb1b, FUN_00407ca7, ends with ret
    push ebp                                     # 0040842d
    {load} mov ebp, esp                          # 0040842e
    sub esp, 0x18                                # 00408430
    mov dword ptr [ebp - local_18], ecx          # 00408433
    push 0x13                                    # 00408436
    lea eax, [ebp - local_14]                    # 00408438
    push eax                                     # 0040843b
    mov ecx, dword ptr [ebp - local_18]          # 0040843c
    add ecx, 0x3cc                               # 0040843f
    call FUN_0051d5b2                            # 00408445
    lea ecx, [ebp - local_14]                    # 0040844a
    push ecx                                     # 0040844d
    call FUN_0050cb1b                            # 0040844e
    add esp, 0x4                                 # 00408453
    mov word ptr [0x5ec2a8], ax                  # 00408456
    mov ecx, dword ptr [ebp - local_18]          # 0040845c
    call FUN_00407ca7                            # 0040845f
    {load} mov esp, ebp                          # 00408464
    pop ebp                                      # 00408466
    ret                                          # 00408467

