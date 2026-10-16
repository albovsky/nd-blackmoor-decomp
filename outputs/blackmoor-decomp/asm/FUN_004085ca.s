# FUN_004085ca
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004085ca
# extent:       0x004085ca-0x00408605 (59 code bytes)
# span:         0x004085ca-0x00408605 (code 59, tables 0, padding 0)
# sha256:       80836d93e16c824af379f6446a87c11c110398633d548e8f62578625a1a36a44
# evidence:     ev_f077da93048f8988a96399f357fa9b0d462c71f5ee4ac3437f49adc8ae869a09
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004085ca
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

.org 0x004085ca - 0x401000
.globl FUN_004085ca
FUN_004085ca:
    # block 0x004085ca: entry, 20 instruction(s), calls FUN_0051d5b2, FUN_0050cb1b, FUN_00407ca7, ends with ret
    push ebp                                     # 004085ca
    {load} mov ebp, esp                          # 004085cb
    sub esp, 0x18                                # 004085cd
    mov dword ptr [ebp - local_18], ecx          # 004085d0
    push 0x13                                    # 004085d3
    lea eax, [ebp - local_14]                    # 004085d5
    push eax                                     # 004085d8
    mov ecx, dword ptr [ebp - local_18]          # 004085d9
    add ecx, 0x58c                               # 004085dc
    call FUN_0051d5b2                            # 004085e2
    lea ecx, [ebp - local_14]                    # 004085e7
    push ecx                                     # 004085ea
    call FUN_0050cb1b                            # 004085eb
    add esp, 0x4                                 # 004085f0
    mov word ptr [0x5ec2b6], ax                  # 004085f3
    mov ecx, dword ptr [ebp - local_18]          # 004085f9
    call FUN_00407ca7                            # 004085fc
    {load} mov esp, ebp                          # 00408601
    pop ebp                                      # 00408603
    ret                                          # 00408604

