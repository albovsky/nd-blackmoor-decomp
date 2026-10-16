# FUN_0040821a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040821a
# extent:       0x0040821a-0x00408255 (59 code bytes)
# span:         0x0040821a-0x00408255 (code 59, tables 0, padding 0)
# sha256:       c5c66781a0adfbea52b5ab80ab9394937df09b17d88a48b365f90d7436ab58c0
# evidence:     ev_f077da93048f8988a96399f357fa9b0d462c71f5ee4ac3437f49adc8ae869a09
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040821a
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

.org 0x0040821a - 0x401000
.globl FUN_0040821a
FUN_0040821a:
    # block 0x0040821a: entry, 20 instruction(s), calls FUN_0051d5b2, FUN_0050cb1b, FUN_00407ca7, ends with ret
    push ebp                                     # 0040821a
    {load} mov ebp, esp                          # 0040821b
    sub esp, 0x18                                # 0040821d
    mov dword ptr [ebp - local_18], ecx          # 00408220
    push 0x13                                    # 00408223
    lea eax, [ebp - local_14]                    # 00408225
    push eax                                     # 00408228
    mov ecx, dword ptr [ebp - local_18]          # 00408229
    add ecx, 0x18c                               # 0040822c
    call FUN_0051d5b2                            # 00408232
    lea ecx, [ebp - local_14]                    # 00408237
    push ecx                                     # 0040823a
    call FUN_0050cb1b                            # 0040823b
    add esp, 0x4                                 # 00408240
    mov word ptr [0x5ec296], ax                  # 00408243
    mov ecx, dword ptr [ebp - local_18]          # 00408249
    call FUN_00407ca7                            # 0040824c
    {load} mov esp, ebp                          # 00408251
    pop ebp                                      # 00408253
    ret                                          # 00408254

