# FUN_0050c309
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c309
# extent:       0x0050c309-0x0050c32e (37 code bytes)
# span:         0x0050c309-0x0050c32e (code 37, tables 0, padding 0)
# sha256:       c59fece9509875b52beb16d8e200dffafe645e7ff8f8307e432e877d493fe879
# evidence:     ev_6b87ed72115c87fed1179d88fa97974f93d6f22889e386bb49899d21464413f2
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c309
# arguments:    7 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c, arg_20; ret 0x1c (callee pops 28 bytes); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       [ecx + n] field_4
# callees:      calls GDI32.dll!ExtTextOutA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ arg_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------

.org 0x0050c309 - 0x401000
.globl FUN_0050c309
FUN_0050c309:
    # block 0x0050c309: entry, 13 instruction(s), calls GDI32.dll!ExtTextOutA, ends with ret 0x1c
    push ebp                                     # 0050c309
    {load} mov ebp, esp                          # 0050c30a
    push dword ptr [ebp + arg_20]                # 0050c30c
    push dword ptr [ebp + arg_1c]                # 0050c30f
    push dword ptr [ebp + arg_18]                # 0050c312
    push dword ptr [ebp + arg_14]                # 0050c315
    push dword ptr [ebp + arg_10]                # 0050c318
    push dword ptr [ebp + arg_c]                 # 0050c31b
    push dword ptr [ebp + arg_8]                 # 0050c31e
    push dword ptr [ecx + field_4]               # 0050c321
    call dword ptr [0x52a0a4]                    # 0050c324
    pop ebp                                      # 0050c32a
    ret 0x1c                                     # 0050c32b

