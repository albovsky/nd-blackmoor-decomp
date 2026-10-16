# FUN_0050cba8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050cba8
# extent:       0x0050cba8-0x0050cc10 (104 code bytes)
# span:         0x0050cba8-0x0050cc10 (code 104, tables 0, padding 0)
# sha256:       1d7e64925499e845c503a9f6fae7b19e7522dfe84dff516b21b6c04d2e7f1362
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050cba8
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       3 ebp-relative slot(s): local_4, local_10, local_1c
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050cc10; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 34 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_10, 0x10  # offset -0x10
.equ local_1c, 0x1c  # offset -0x1c
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0050cc10, .text + (0x0050cc10 - 0x401000)

.org 0x0050cba8 - 0x401000
.globl FUN_0050cba8
FUN_0050cba8:
    # block 0x0050cba8: entry, 18 instruction(s), falls into the block at 0x0050cbdf
    push ebp                                     # 0050cba8
    {load} mov ebp, esp                          # 0050cba9
    push -0x1                                    # 0050cbab
    push 0x530238                                # 0050cbad
    push 0x511930                                # 0050cbb2
    mov eax, dword ptr fs:[0x0]                  # 0050cbb7
    push eax                                     # 0050cbbd
    mov dword ptr fs:[0x0], esp                  # 0050cbbe
    sub esp, 0xc                                 # 0050cbc5
    push ebx                                     # 0050cbc8
    push esi                                     # 0050cbc9
    push edi                                     # 0050cbca
    and dword ptr [ebp - local_1c], 0x0          # 0050cbcb
    mov esi, dword ptr [ebp + arg_c]             # 0050cbcf
    {load} mov eax, esi                          # 0050cbd2
    imul eax, dword ptr [ebp + arg_10]           # 0050cbd4
    add dword ptr [ebp + arg_8], eax             # 0050cbd8
    and dword ptr [ebp - local_4], 0x0           # 0050cbdb
L_0050cbdf:
    # block 0x0050cbdf: entered by jmp at 0x0050cbed, 2 instruction(s), ends with js to 0x0050cbef (forward)
    dec dword ptr [ebp + arg_10]                 # 0050cbdf
    js.d8 L_0050cbef                             # 0050cbe2
    # block 0x0050cbe4: entered by fall-through of js at 0x0050cbe2, 4 instruction(s), calls indirect dword ptr [ebp + 0x14], ends with backward jump to 0x0050cbdf
    sub dword ptr [ebp + arg_8], esi             # 0050cbe4
    mov ecx, dword ptr [ebp + arg_8]             # 0050cbe7
    call dword ptr [ebp + arg_14]                # 0050cbea
    jmp.d8 L_0050cbdf                            # 0050cbed
L_0050cbef:
    # block 0x0050cbef: entered by js at 0x0050cbe2, 10 instruction(s), calls FUN_0050cc10, ends with ret 0x10
    mov dword ptr [ebp - local_1c], 0x1          # 0050cbef
    or dword ptr [ebp - local_4], -0x1           # 0050cbf6
    call FUN_0050cc10                            # 0050cbfa
    mov ecx, dword ptr [ebp - local_10]          # 0050cbff
    mov dword ptr fs:[0x0], ecx                  # 0050cc02
    pop edi                                      # 0050cc09
    pop esi                                      # 0050cc0a
    pop ebx                                      # 0050cc0b
    leave                                        # 0050cc0c
    ret 0x10                                     # 0050cc0d

