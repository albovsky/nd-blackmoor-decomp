# FUN_004088c9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004088c9
# extent:       0x004088c9-0x00408904 (59 code bytes)
# span:         0x004088c9-0x00408904 (code 59, tables 0, padding 0)
# sha256:       7fabf3aabfe666d923b7ba8259f7362c3e23fb453c492b44f1ecee37e1d292f4
# evidence:     ev_f077da93048f8988a96399f357fa9b0d462c71f5ee4ac3437f49adc8ae869a09
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004088c9
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

.org 0x004088c9 - 0x401000
.globl FUN_004088c9
FUN_004088c9:
    # block 0x004088c9: entry, 20 instruction(s), calls FUN_0051d5b2, FUN_0050cb1b, FUN_00407ca7, ends with ret
    push ebp                                     # 004088c9
    {load} mov ebp, esp                          # 004088ca
    sub esp, 0x18                                # 004088cc
    mov dword ptr [ebp - local_18], ecx          # 004088cf
    push 0x13                                    # 004088d2
    lea eax, [ebp - local_14]                    # 004088d4
    push eax                                     # 004088d7
    mov ecx, dword ptr [ebp - local_18]          # 004088d8
    add ecx, 0x8cc                               # 004088db
    call FUN_0051d5b2                            # 004088e1
    lea ecx, [ebp - local_14]                    # 004088e6
    push ecx                                     # 004088e9
    call FUN_0050cb1b                            # 004088ea
    add esp, 0x4                                 # 004088ef
    mov word ptr [0x5ec2d0], ax                  # 004088f2
    mov ecx, dword ptr [ebp - local_18]          # 004088f8
    call FUN_00407ca7                            # 004088fb
    {load} mov esp, ebp                          # 00408900
    pop ebp                                      # 00408902
    ret                                          # 00408903

