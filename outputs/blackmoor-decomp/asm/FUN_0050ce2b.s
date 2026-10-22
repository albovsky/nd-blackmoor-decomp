# FUN_0050ce2b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050ce2b
# extent:       0x0050ce2b-0x0050ce57 (44 code bytes)
# span:         0x0050ce2b-0x0050ce57 (code 44, tables 0, padding 0)
# sha256:       9f4bb8d0837212444e487beb08ca14f7788bd92cb4ae80137ac6edc21b4f7440
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050ce2b
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_005120d4, FUN_0050ce57, FUN_00512126
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 17 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0050ce57, .text + (0x0050ce57 - 0x401000)
.set FUN_005120d4, .text + (0x005120d4 - 0x401000)
.set FUN_00512126, .text + (0x00512126 - 0x401000)

.org 0x0050ce2b - 0x401000
.globl FUN_0050ce2b
FUN_0050ce2b:
    # block 0x0050ce2b: entry, 17 instruction(s), calls FUN_005120d4, FUN_0050ce57, FUN_00512126, ends with ret
    push ebp                                     # 0050ce2b
    {load} mov ebp, esp                          # 0050ce2c
    push esi                                     # 0050ce2e
    push dword ptr [ebp + arg_8]                 # 0050ce2f
    call FUN_005120d4                            # 0050ce32
    push dword ptr [ebp + arg_10]                # 0050ce37
    push dword ptr [ebp + arg_c]                 # 0050ce3a
    push dword ptr [ebp + arg_8]                 # 0050ce3d
    call FUN_0050ce57                            # 0050ce40
    push dword ptr [ebp + arg_8]                 # 0050ce45
    {load} mov esi, eax                          # 0050ce48
    call FUN_00512126                            # 0050ce4a
    add esp, 0x14                                # 0050ce4f
    {load} mov eax, esi                          # 0050ce52
    pop esi                                      # 0050ce54
    pop ebp                                      # 0050ce55
    ret                                          # 0050ce56

