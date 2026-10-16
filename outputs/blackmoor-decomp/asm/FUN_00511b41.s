# FUN_00511b41
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00511b41
# extent:       0x00511b41-0x00511b7f (62 code bytes)
# span:         0x00511b41-0x00511b7f (code 62, tables 0, padding 0)
# sha256:       eaa4cfd7313e5d6db5db0dc2662a501dcba1c8791a88af641a4c6cc347674406
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00511b41
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_4
# callees:      calls FUN_00516d7d, FUN_00516daa
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 29 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_00516d7d, .text + (0x00516d7d - 0x401000)
.set FUN_00516daa, .text + (0x00516daa - 0x401000)

.org 0x00511b41 - 0x401000
.globl FUN_00511b41
FUN_00511b41:
    # block 0x00511b41: entry, 7 instruction(s), ends with je to 0x00511b6a (forward)
    push ebp                                     # 00511b41
    {load} mov ebp, esp                          # 00511b42
    push ecx                                     # 00511b44
    push ecx                                     # 00511b45
    cmp dword ptr [ebp + arg_8], 0x0             # 00511b46
    push dword ptr [ebp + arg_10]                # 00511b4a
    je.d8 L_00511b6a                             # 00511b4d
    # block 0x00511b4f: entered by fall-through of je at 0x00511b4d, 12 instruction(s), calls FUN_00516d7d, ends with ret
    lea eax, [ebp - local_8]                     # 00511b4f
    push eax                                     # 00511b52
    call FUN_00516d7d                            # 00511b53
    mov eax, dword ptr [ebp + arg_c]             # 00511b58
    pop ecx                                      # 00511b5b
    pop ecx                                      # 00511b5c
    mov ecx, dword ptr [ebp - local_8]           # 00511b5d
    mov dword ptr [eax], ecx                     # 00511b60
    mov ecx, dword ptr [ebp - local_4]           # 00511b62
    mov dword ptr [eax + field_4], ecx           # 00511b65
    leave                                        # 00511b68
    ret                                          # 00511b69
L_00511b6a:
    # block 0x00511b6a: entered by je at 0x00511b4d, 10 instruction(s), calls FUN_00516daa, ends with ret
    lea eax, [ebp + arg_10]                      # 00511b6a
    push eax                                     # 00511b6d
    call FUN_00516daa                            # 00511b6e
    mov eax, dword ptr [ebp + arg_c]             # 00511b73
    pop ecx                                      # 00511b76
    pop ecx                                      # 00511b77
    mov ecx, dword ptr [ebp + arg_10]            # 00511b78
    mov dword ptr [eax], ecx                     # 00511b7b
    leave                                        # 00511b7d
    ret                                          # 00511b7e

