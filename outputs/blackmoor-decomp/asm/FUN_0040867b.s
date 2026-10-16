# FUN_0040867b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040867b
# extent:       0x0040867b-0x004086b6 (59 code bytes)
# span:         0x0040867b-0x004086b6 (code 59, tables 0, padding 0)
# sha256:       4068791472e1ec79a928f85a57fd3e503c1ebaee7f3953905081f76bfcfed691
# evidence:     ev_f077da93048f8988a96399f357fa9b0d462c71f5ee4ac3437f49adc8ae869a09
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040867b
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

.org 0x0040867b - 0x401000
.globl FUN_0040867b
FUN_0040867b:
    # block 0x0040867b: entry, 20 instruction(s), calls FUN_0051d5b2, FUN_0050cb1b, FUN_00407ca7, ends with ret
    push ebp                                     # 0040867b
    {load} mov ebp, esp                          # 0040867c
    sub esp, 0x18                                # 0040867e
    mov dword ptr [ebp - local_18], ecx          # 00408681
    push 0x13                                    # 00408684
    lea eax, [ebp - local_14]                    # 00408686
    push eax                                     # 00408689
    mov ecx, dword ptr [ebp - local_18]          # 0040868a
    add ecx, 0x64c                               # 0040868d
    call FUN_0051d5b2                            # 00408693
    lea ecx, [ebp - local_14]                    # 00408698
    push ecx                                     # 0040869b
    call FUN_0050cb1b                            # 0040869c
    add esp, 0x4                                 # 004086a1
    mov word ptr [0x5ec2bc], ax                  # 004086a4
    mov ecx, dword ptr [ebp - local_18]          # 004086aa
    call FUN_00407ca7                            # 004086ad
    {load} mov esp, ebp                          # 004086b2
    pop ebp                                      # 004086b4
    ret                                          # 004086b5

