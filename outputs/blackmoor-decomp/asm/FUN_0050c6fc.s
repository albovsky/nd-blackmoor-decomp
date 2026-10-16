# FUN_0050c6fc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c6fc
# extent:       0x0050c6fc-0x0050c750 (84 code bytes)
# span:         0x0050c6fc-0x0050c750 (code 84, tables 0, padding 0)
# sha256:       3fa0fb1d2009c52b327745bab516b835363588f06883218a752271a829c33fa2
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c6fc
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00510d20
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 26 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_00510d20, .text + (0x00510d20 - 0x401000)

.org 0x0050c6fc - 0x401000
.globl FUN_0050c6fc
FUN_0050c6fc:
    # block 0x0050c6fc: entry, 26 instruction(s), calls FUN_00510d20, ends with ret
    push ebp                                     # 0050c6fc
    {load} mov ebp, esp                          # 0050c6fd
    sub esp, 0x14                                # 0050c6ff
    mov eax, dword ptr [ebp + arg_c]             # 0050c702
    and dword ptr [ebp - local_14], 0x0          # 0050c705
    mov ecx, dword ptr [ebp + arg_8]             # 0050c709
    mov dword ptr [ebp - local_c], eax           # 0050c70c
    mov eax, dword ptr [ebp + arg_14]            # 0050c70f
    mov dword ptr [ebp - local_10], 0x50c750     # 0050c712
    inc eax                                      # 0050c719
    mov dword ptr [ebp - local_8], ecx           # 0050c71a
    mov dword ptr [ebp - local_4], eax           # 0050c71d
    mov eax, dword ptr fs:[0x0]                  # 0050c720
    mov dword ptr [ebp - local_14], eax          # 0050c726
    {disp32} lea eax, [ebp - local_14]           # 0050c729
    mov dword ptr fs:[0x0], eax                  # 0050c72f
    push dword ptr [ebp + arg_18]                # 0050c735
    push ecx                                     # 0050c738
    push dword ptr [ebp + arg_10]                # 0050c739
    call FUN_00510d20                            # 0050c73c
    {load} mov ecx, eax                          # 0050c741
    mov eax, dword ptr [ebp - local_14]          # 0050c743
    mov dword ptr fs:[0x0], eax                  # 0050c746
    {load} mov eax, ecx                          # 0050c74c
    leave                                        # 0050c74e
    ret                                          # 0050c74f

