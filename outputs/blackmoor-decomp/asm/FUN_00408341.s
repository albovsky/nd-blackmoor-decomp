# FUN_00408341
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00408341
# extent:       0x00408341-0x0040837c (59 code bytes)
# span:         0x00408341-0x0040837c (code 59, tables 0, padding 0)
# sha256:       4f1a315f3a52311e5824bb7ca6ec3b757b4b910dd683392c8599182cc4328f3b
# evidence:     ev_f077da93048f8988a96399f357fa9b0d462c71f5ee4ac3437f49adc8ae869a09
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00408341
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

.org 0x00408341 - 0x401000
.globl FUN_00408341
FUN_00408341:
    # block 0x00408341: entry, 20 instruction(s), calls FUN_0051d5b2, FUN_0050cb1b, FUN_00407ca7, ends with ret
    push ebp                                     # 00408341
    {load} mov ebp, esp                          # 00408342
    sub esp, 0x18                                # 00408344
    mov dword ptr [ebp - local_18], ecx          # 00408347
    push 0x13                                    # 0040834a
    lea eax, [ebp - local_14]                    # 0040834c
    push eax                                     # 0040834f
    mov ecx, dword ptr [ebp - local_18]          # 00408350
    add ecx, 0x2cc                               # 00408353
    call FUN_0051d5b2                            # 00408359
    lea ecx, [ebp - local_14]                    # 0040835e
    push ecx                                     # 00408361
    call FUN_0050cb1b                            # 00408362
    add esp, 0x4                                 # 00408367
    mov word ptr [0x5ec2a0], ax                  # 0040836a
    mov ecx, dword ptr [ebp - local_18]          # 00408370
    call FUN_00407ca7                            # 00408373
    {load} mov esp, ebp                          # 00408378
    pop ebp                                      # 0040837a
    ret                                          # 0040837b

