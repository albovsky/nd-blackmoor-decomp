# FUN_0040858f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040858f
# extent:       0x0040858f-0x004085ca (59 code bytes)
# span:         0x0040858f-0x004085ca (code 59, tables 0, padding 0)
# sha256:       407a6f4a3b95c5a1be4d0098b7e1c19bd5c27aab095442e33be277f1ef5b022c
# evidence:     ev_f077da93048f8988a96399f357fa9b0d462c71f5ee4ac3437f49adc8ae869a09
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040858f
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

.org 0x0040858f - 0x401000
.globl FUN_0040858f
FUN_0040858f:
    # block 0x0040858f: entry, 20 instruction(s), calls FUN_0051d5b2, FUN_0050cb1b, FUN_00407ca7, ends with ret
    push ebp                                     # 0040858f
    {load} mov ebp, esp                          # 00408590
    sub esp, 0x18                                # 00408592
    mov dword ptr [ebp - local_18], ecx          # 00408595
    push 0x13                                    # 00408598
    lea eax, [ebp - local_14]                    # 0040859a
    push eax                                     # 0040859d
    mov ecx, dword ptr [ebp - local_18]          # 0040859e
    add ecx, 0x54c                               # 004085a1
    call FUN_0051d5b2                            # 004085a7
    lea ecx, [ebp - local_14]                    # 004085ac
    push ecx                                     # 004085af
    call FUN_0050cb1b                            # 004085b0
    add esp, 0x4                                 # 004085b5
    mov word ptr [0x5ec2b4], ax                  # 004085b8
    mov ecx, dword ptr [ebp - local_18]          # 004085be
    call FUN_00407ca7                            # 004085c1
    {load} mov esp, ebp                          # 004085c6
    pop ebp                                      # 004085c8
    ret                                          # 004085c9

