# FUN_0050c6c6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c6c6
# extent:       0x0050c6c6-0x0050c6fc (54 code bytes)
# span:         0x0050c6c6-0x0050c6fc (code 54, tables 0, padding 0)
# sha256:       61a6d1086c6a6cc4d003780bdedbd3a5f039d7a7c6773b8767c169128c6f9510
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c6c6
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00510516
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 27 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_00510516, .text + (0x00510516 - 0x401000)

.org 0x0050c6c6 - 0x401000
.globl FUN_0050c6c6
FUN_0050c6c6:
    # block 0x0050c6c6: entry, 27 instruction(s), calls FUN_00510516, ends with ret
    push ebp                                     # 0050c6c6
    {load} mov ebp, esp                          # 0050c6c7
    sub esp, 0x4                                 # 0050c6c9
    push ebx                                     # 0050c6cc
    push esi                                     # 0050c6cd
    push edi                                     # 0050c6ce
    cld                                          # 0050c6cf
    mov dword ptr [ebp - local_4], eax           # 0050c6d0
    {load} xor eax, eax                          # 0050c6d3
    push eax                                     # 0050c6d5
    push eax                                     # 0050c6d6
    push eax                                     # 0050c6d7
    push dword ptr [ebp - local_4]               # 0050c6d8
    push dword ptr [ebp + arg_14]                # 0050c6db
    push dword ptr [ebp + arg_10]                # 0050c6de
    push dword ptr [ebp + arg_c]                 # 0050c6e1
    push dword ptr [ebp + arg_8]                 # 0050c6e4
    call FUN_00510516                            # 0050c6e7
    add esp, 0x20                                # 0050c6ec
    mov dword ptr [ebp + arg_14], eax            # 0050c6ef
    pop edi                                      # 0050c6f2
    pop esi                                      # 0050c6f3
    pop ebx                                      # 0050c6f4
    mov eax, dword ptr [ebp + arg_14]            # 0050c6f5
    {load} mov esp, ebp                          # 0050c6f8
    pop ebp                                      # 0050c6fa
    ret                                          # 0050c6fb

