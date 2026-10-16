# FUN_0050c750
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c750
# extent:       0x0050c750-0x0050c775 (37 code bytes)
# span:         0x0050c750-0x0050c775 (code 37, tables 0, padding 0)
# sha256:       a71e045854024ec5ab43776674d5baa6c655507d180c18cde6191707ba6918fb
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c750
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_8, field_c, field_10
# callees:      calls FUN_00510516
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 16 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_00510516, .text + (0x00510516 - 0x401000)

.org 0x0050c750 - 0x401000
.globl FUN_0050c750
FUN_0050c750:
    # block 0x0050c750: entry, 16 instruction(s), calls FUN_00510516, ends with ret
    push ebp                                     # 0050c750
    {load} mov ebp, esp                          # 0050c751
    cld                                          # 0050c753
    mov eax, dword ptr [ebp + arg_c]             # 0050c754
    push 0x0                                     # 0050c757
    push eax                                     # 0050c759
    push dword ptr [eax + field_10]              # 0050c75a
    push dword ptr [eax + field_8]               # 0050c75d
    push 0x0                                     # 0050c760
    push dword ptr [ebp + arg_10]                # 0050c762
    push dword ptr [eax + field_c]               # 0050c765
    push dword ptr [ebp + arg_8]                 # 0050c768
    call FUN_00510516                            # 0050c76b
    add esp, 0x20                                # 0050c770
    pop ebp                                      # 0050c773
    ret                                          # 0050c774

