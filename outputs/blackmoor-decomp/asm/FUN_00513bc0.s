# FUN_00513bc0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513bc0
# extent:       0x00513bc0-0x00513bd7 (23 code bytes)
# span:         0x00513bc0-0x00513bd7 (code 23, tables 0, padding 0)
# sha256:       0f6bedbaacb032256ec1d8adf83f852975544b42c821b77ce77abfd6ee3580e1
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00513bc0
# arguments:    2 ebp-relative stack slot(s) referenced: arg_18, arg_1c; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       3 ebp-relative slot(s): local_c, local_10, local_20
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump LOC_00513be0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_20, 0x20  # offset -0x20
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set LOC_00513be0, .text + (0x00513be0 - 0x401000)

.org 0x00513bc0 - 0x401000
.globl FUN_00513bc0
FUN_00513bc0:
    # block 0x00513bc0: entry, 9 instruction(s), ends with forward jump to 0x00513be0
    push ebp                                     # 00513bc0
    {load} mov ebp, esp                          # 00513bc1
    add esp, -0x20                               # 00513bc3
    mov dword ptr [ebp - local_20], eax          # 00513bc6
    mov eax, dword ptr [ebp + arg_18]            # 00513bc9
    mov dword ptr [ebp - local_10], eax          # 00513bcc
    mov eax, dword ptr [ebp + arg_1c]            # 00513bcf
    mov dword ptr [ebp - local_c], eax           # 00513bd2
    jmp.d8 . + (11)  # -> LOC_00513be0           # 00513bd5

