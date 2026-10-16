# FUN_00408519
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00408519
# extent:       0x00408519-0x00408554 (59 code bytes)
# span:         0x00408519-0x00408554 (code 59, tables 0, padding 0)
# sha256:       f73dd4f552fec863845028dcaf4c55b994eebe296d371a67dc7899e11577bdc3
# evidence:     ev_f077da93048f8988a96399f357fa9b0d462c71f5ee4ac3437f49adc8ae869a09
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00408519
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

.org 0x00408519 - 0x401000
.globl FUN_00408519
FUN_00408519:
    # block 0x00408519: entry, 20 instruction(s), calls FUN_0051d5b2, FUN_0050cb1b, FUN_00407ca7, ends with ret
    push ebp                                     # 00408519
    {load} mov ebp, esp                          # 0040851a
    sub esp, 0x18                                # 0040851c
    mov dword ptr [ebp - local_18], ecx          # 0040851f
    push 0x13                                    # 00408522
    lea eax, [ebp - local_14]                    # 00408524
    push eax                                     # 00408527
    mov ecx, dword ptr [ebp - local_18]          # 00408528
    add ecx, 0x4cc                               # 0040852b
    call FUN_0051d5b2                            # 00408531
    lea ecx, [ebp - local_14]                    # 00408536
    push ecx                                     # 00408539
    call FUN_0050cb1b                            # 0040853a
    add esp, 0x4                                 # 0040853f
    mov word ptr [0x5ec2b0], ax                  # 00408542
    mov ecx, dword ptr [ebp - local_18]          # 00408548
    call FUN_00407ca7                            # 0040854b
    {load} mov esp, ebp                          # 00408550
    pop ebp                                      # 00408552
    ret                                          # 00408553

