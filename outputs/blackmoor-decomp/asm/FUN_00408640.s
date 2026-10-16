# FUN_00408640
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00408640
# extent:       0x00408640-0x0040867b (59 code bytes)
# span:         0x00408640-0x0040867b (code 59, tables 0, padding 0)
# sha256:       2f36aa214d1d869290c2ed22027539984c2902a32b59f624f226af7ce08ae0b9
# evidence:     ev_f077da93048f8988a96399f357fa9b0d462c71f5ee4ac3437f49adc8ae869a09
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00408640
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

.org 0x00408640 - 0x401000
.globl FUN_00408640
FUN_00408640:
    # block 0x00408640: entry, 20 instruction(s), calls FUN_0051d5b2, FUN_0050cb1b, FUN_00407ca7, ends with ret
    push ebp                                     # 00408640
    {load} mov ebp, esp                          # 00408641
    sub esp, 0x18                                # 00408643
    mov dword ptr [ebp - local_18], ecx          # 00408646
    push 0x13                                    # 00408649
    lea eax, [ebp - local_14]                    # 0040864b
    push eax                                     # 0040864e
    mov ecx, dword ptr [ebp - local_18]          # 0040864f
    add ecx, 0x60c                               # 00408652
    call FUN_0051d5b2                            # 00408658
    lea ecx, [ebp - local_14]                    # 0040865d
    push ecx                                     # 00408660
    call FUN_0050cb1b                            # 00408661
    add esp, 0x4                                 # 00408666
    mov word ptr [0x5ec2ba], ax                  # 00408669
    mov ecx, dword ptr [ebp - local_18]          # 0040866f
    call FUN_00407ca7                            # 00408672
    {load} mov esp, ebp                          # 00408677
    pop ebp                                      # 00408679
    ret                                          # 0040867a

