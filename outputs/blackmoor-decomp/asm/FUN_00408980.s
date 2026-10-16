# FUN_00408980
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00408980
# extent:       0x00408980-0x004089ae (46 code bytes)
# span:         0x00408980-0x004089b0 (code 46, tables 0, padding 2)
# sha256:       c06b15a38a9b8fc0f759772c5b34ee9cc1c6357361f210955db203b432166b71
# evidence:     ev_f077da93048f8988a96399f357fa9b0d462c71f5ee4ac3437f49adc8ae869a09
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00408980
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00407c29, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00407c29, .text + (0x00407c29 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00408980 - 0x401000
.globl FUN_00408980
FUN_00408980:
    # block 0x00408980: entry, 10 instruction(s), calls FUN_00407c29, ends with je to 0x004089a5 (forward)
    push ebp                                     # 00408980
    {load} mov ebp, esp                          # 00408981
    push ecx                                     # 00408983
    mov dword ptr [ebp - local_4], ecx           # 00408984
    mov ecx, dword ptr [ebp - local_4]           # 00408987
    call FUN_00407c29                            # 0040898a
    mov eax, dword ptr [ebp + arg_8]             # 0040898f
    and eax, 0x1                                 # 00408992
    test eax, eax                                # 00408995
    je.d8 L_004089a5                             # 00408997
    # block 0x00408999: entered by fall-through of je at 0x00408997, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004089a5
    mov ecx, dword ptr [ebp - local_4]           # 00408999
    push ecx                                     # 0040899c
    call FUN_0051dc6c                            # 0040899d
    add esp, 0x4                                 # 004089a2
L_004089a5:
    # block 0x004089a5: entered by je at 0x00408997, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004089a5
    {load} mov esp, ebp                          # 004089a8
    pop ebp                                      # 004089aa
    ret 0x4                                      # 004089ab

# --- data items (not part of the function) -------------------------
.org 0x004089ae - 0x401000
PAD_004089ae:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

