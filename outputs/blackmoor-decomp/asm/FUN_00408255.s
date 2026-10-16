# FUN_00408255
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00408255
# extent:       0x00408255-0x00408290 (59 code bytes)
# span:         0x00408255-0x00408290 (code 59, tables 0, padding 0)
# sha256:       6949b0f6a581db486fc8077fdb0bf7a5130afce0c5905da27edce9f5dd7b539e
# evidence:     ev_f077da93048f8988a96399f357fa9b0d462c71f5ee4ac3437f49adc8ae869a09
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00408255
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

.org 0x00408255 - 0x401000
.globl FUN_00408255
FUN_00408255:
    # block 0x00408255: entry, 20 instruction(s), calls FUN_0051d5b2, FUN_0050cb1b, FUN_00407ca7, ends with ret
    push ebp                                     # 00408255
    {load} mov ebp, esp                          # 00408256
    sub esp, 0x18                                # 00408258
    mov dword ptr [ebp - local_18], ecx          # 0040825b
    push 0x13                                    # 0040825e
    lea eax, [ebp - local_14]                    # 00408260
    push eax                                     # 00408263
    mov ecx, dword ptr [ebp - local_18]          # 00408264
    add ecx, 0x1cc                               # 00408267
    call FUN_0051d5b2                            # 0040826d
    lea ecx, [ebp - local_14]                    # 00408272
    push ecx                                     # 00408275
    call FUN_0050cb1b                            # 00408276
    add esp, 0x4                                 # 0040827b
    mov word ptr [0x5ec298], ax                  # 0040827e
    mov ecx, dword ptr [ebp - local_18]          # 00408284
    call FUN_00407ca7                            # 00408287
    {load} mov esp, ebp                          # 0040828c
    pop ebp                                      # 0040828e
    ret                                          # 0040828f

