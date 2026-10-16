# FUN_0050cf61
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050cf61
# extent:       0x0050cf61-0x0050cf90 (47 code bytes)
# span:         0x0050cf61-0x0050cf90 (code 47, tables 0, padding 0)
# sha256:       3a65f967babaf3e248f16a586004e6d0459defd6e2d39c5e4ef0b19afa2efa07
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050cf61
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_005120d4, FUN_0050cf90, FUN_00512126
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0050cf90, .text + (0x0050cf90 - 0x401000)
.set FUN_005120d4, .text + (0x005120d4 - 0x401000)
.set FUN_00512126, .text + (0x00512126 - 0x401000)

.org 0x0050cf61 - 0x401000
.globl FUN_0050cf61
FUN_0050cf61:
    # block 0x0050cf61: entry, 18 instruction(s), calls FUN_005120d4, FUN_0050cf90, FUN_00512126, ends with ret
    push ebp                                     # 0050cf61
    {load} mov ebp, esp                          # 0050cf62
    push esi                                     # 0050cf64
    push dword ptr [ebp + arg_14]                # 0050cf65
    call FUN_005120d4                            # 0050cf68
    push dword ptr [ebp + arg_14]                # 0050cf6d
    push dword ptr [ebp + arg_10]                # 0050cf70
    push dword ptr [ebp + arg_c]                 # 0050cf73
    push dword ptr [ebp + arg_8]                 # 0050cf76
    call FUN_0050cf90                            # 0050cf79
    push dword ptr [ebp + arg_14]                # 0050cf7e
    {load} mov esi, eax                          # 0050cf81
    call FUN_00512126                            # 0050cf83
    add esp, 0x18                                # 0050cf88
    {load} mov eax, esi                          # 0050cf8b
    pop esi                                      # 0050cf8d
    pop ebp                                      # 0050cf8e
    ret                                          # 0050cf8f

