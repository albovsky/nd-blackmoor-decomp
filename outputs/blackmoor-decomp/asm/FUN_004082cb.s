# FUN_004082cb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004082cb
# extent:       0x004082cb-0x00408306 (59 code bytes)
# span:         0x004082cb-0x00408306 (code 59, tables 0, padding 0)
# sha256:       ef3432f1f44434da6d2c09411d1127f1829b64dde11dffafafd122eaaf6a05b4
# evidence:     ev_f077da93048f8988a96399f357fa9b0d462c71f5ee4ac3437f49adc8ae869a09
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004082cb
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

.org 0x004082cb - 0x401000
.globl FUN_004082cb
FUN_004082cb:
    # block 0x004082cb: entry, 20 instruction(s), calls FUN_0051d5b2, FUN_0050cb1b, FUN_00407ca7, ends with ret
    push ebp                                     # 004082cb
    {load} mov ebp, esp                          # 004082cc
    sub esp, 0x18                                # 004082ce
    mov dword ptr [ebp - local_18], ecx          # 004082d1
    push 0x13                                    # 004082d4
    lea eax, [ebp - local_14]                    # 004082d6
    push eax                                     # 004082d9
    mov ecx, dword ptr [ebp - local_18]          # 004082da
    add ecx, 0x24c                               # 004082dd
    call FUN_0051d5b2                            # 004082e3
    lea ecx, [ebp - local_14]                    # 004082e8
    push ecx                                     # 004082eb
    call FUN_0050cb1b                            # 004082ec
    add esp, 0x4                                 # 004082f1
    mov word ptr [0x5ec29c], ax                  # 004082f4
    mov ecx, dword ptr [ebp - local_18]          # 004082fa
    call FUN_00407ca7                            # 004082fd
    {load} mov esp, ebp                          # 00408302
    pop ebp                                      # 00408304
    ret                                          # 00408305

