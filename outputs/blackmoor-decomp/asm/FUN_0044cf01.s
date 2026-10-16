# FUN_0044cf01
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044cf01
# extent:       0x0044cf01-0x0044d020 (287 code bytes)
# span:         0x0044cf01-0x0044d020 (code 287, tables 0, padding 0)
# sha256:       939bd1eda4b809db0d6c7746ae35843967cb23c5f040f7203d8835cbb8f9c03a
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044cf01
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0044c479, FUN_0051dc6c, FUN_00415176, FUN_0044c4ab, KERNEL32.dll!Sleep, FUN_0051ec84
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 75 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00415176, .text + (0x00415176 - 0x401000)
.set FUN_0044c479, .text + (0x0044c479 - 0x401000)
.set FUN_0044c4ab, .text + (0x0044c4ab - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)
.set FUN_0051ec84, .text + (0x0051ec84 - 0x401000)

.org 0x0044cf01 - 0x401000
.globl FUN_0044cf01
FUN_0044cf01:
    # block 0x0044cf01: entry, 5 instruction(s), falls into the block at 0x0044cf0d
    push ebp                                     # 0044cf01
    {load} mov ebp, esp                          # 0044cf02
    sub esp, 0xc                                 # 0044cf04
    mov eax, dword ptr [ebp + arg_8]             # 0044cf07
    mov dword ptr [ebp - local_4], eax           # 0044cf0a
L_0044cf0d:
    # block 0x0044cf0d: entered by jmp at 0x0044d00e, 3 instruction(s), ends with je to 0x0044d013 (forward)
    mov ecx, 0x1                                 # 0044cf0d
    test ecx, ecx                                # 0044cf12
    je.d32 L_0044d013                            # 0044cf14
    # block 0x0044cf1a: entered by fall-through of je at 0x0044cf14, 3 instruction(s), ends with je to 0x0044cf27 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0044cf1a
    cmp dword ptr [edx], 0x0                     # 0044cf1d
    je.d8 L_0044cf27                             # 0044cf20
    # block 0x0044cf22: entered by fall-through of je at 0x0044cf20, 1 instruction(s), ends with forward jump to 0x0044d013
    jmp.d32 L_0044d013                           # 0044cf22
L_0044cf27:
    # block 0x0044cf27: entered by je at 0x0044cf20, 3 instruction(s), ends with je to 0x0044cf37 (forward)
    movsx eax, word ptr [0x5b5081]               # 0044cf27
    test eax, eax                                # 0044cf2e
    je.d8 L_0044cf37                             # 0044cf30
    # block 0x0044cf32: entered by fall-through of je at 0x0044cf30, 1 instruction(s), ends with forward jump to 0x0044d01e
    jmp.d32 L_0044d01e                           # 0044cf32
L_0044cf37:
    # block 0x0044cf37: entered by je at 0x0044cf30, 6 instruction(s), calls FUN_0044c479, ends with jne to 0x0044cf51 (forward)
    push 0x5b4eb1                                # 0044cf37
    call FUN_0044c479                            # 0044cf3c
    add esp, 0x4                                 # 0044cf41
    movsx ecx, ax                                # 0044cf44
    cmp ecx, 0x2                                 # 0044cf47
    jne.d8 L_0044cf51                            # 0044cf4a
    # block 0x0044cf4c: entered by fall-through of jne at 0x0044cf4a, 1 instruction(s), ends with forward jump to 0x0044d01c
    jmp.d32 L_0044d01c                           # 0044cf4c
L_0044cf51:
    # block 0x0044cf51: entered by jne at 0x0044cf4a, 3 instruction(s), ends with jne to 0x0044cfa7 (forward)
    movsx edx, word ptr [0x5b503f]               # 0044cf51
    test edx, edx                                # 0044cf58
    jne.d8 L_0044cfa7                            # 0044cf5a
    # block 0x0044cf5c: entered by fall-through of jne at 0x0044cf5a, 2 instruction(s), ends with je to 0x0044cf83 (forward)
    cmp dword ptr [0x5b5033], 0x0                # 0044cf5c
    je.d8 L_0044cf83                             # 0044cf63
    # block 0x0044cf65: entered by fall-through of je at 0x0044cf63, 7 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0044cf83
    mov eax, dword ptr [0x5b5033]                # 0044cf65
    mov dword ptr [ebp - local_8], eax           # 0044cf6a
    mov ecx, dword ptr [ebp - local_8]           # 0044cf6d
    push ecx                                     # 0044cf70
    call FUN_0051dc6c                            # 0044cf71
    add esp, 0x4                                 # 0044cf76
    mov dword ptr [0x5b5033], 0x0                # 0044cf79
L_0044cf83:
    # block 0x0044cf83: entered by je at 0x0044cf63, 10 instruction(s), calls FUN_00415176, ends with forward jump to 0x0044cff0
    push 0x0                                     # 0044cf83
    push 0x0                                     # 0044cf85
    push 0x0                                     # 0044cf87
    mov dx, word ptr [0x5b5077]                  # 0044cf89
    push edx                                     # 0044cf90
    push 0x5b4eb5                                # 0044cf91
    mov ecx, 0x5e2dbe                            # 0044cf96
    call FUN_00415176                            # 0044cf9b
    mov dword ptr [0x5b5033], eax                # 0044cfa0
    jmp.d8 L_0044cff0                            # 0044cfa5
L_0044cfa7:
    # block 0x0044cfa7: entered by jne at 0x0044cf5a, 2 instruction(s), ends with je to 0x0044cfce (forward)
    cmp dword ptr [0x5b502f], 0x0                # 0044cfa7
    je.d8 L_0044cfce                             # 0044cfae
    # block 0x0044cfb0: entered by fall-through of je at 0x0044cfae, 7 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0044cfce
    mov eax, dword ptr [0x5b502f]                # 0044cfb0
    mov dword ptr [ebp - local_c], eax           # 0044cfb5
    mov ecx, dword ptr [ebp - local_c]           # 0044cfb8
    push ecx                                     # 0044cfbb
    call FUN_0051dc6c                            # 0044cfbc
    add esp, 0x4                                 # 0044cfc1
    mov dword ptr [0x5b502f], 0x0                # 0044cfc4
L_0044cfce:
    # block 0x0044cfce: entered by je at 0x0044cfae, 9 instruction(s), calls FUN_00415176, falls into the block at 0x0044cff0
    push 0x0                                     # 0044cfce
    push 0x0                                     # 0044cfd0
    push 0x0                                     # 0044cfd2
    mov dx, word ptr [0x5b5077]                  # 0044cfd4
    push edx                                     # 0044cfdb
    push 0x5b4eb5                                # 0044cfdc
    mov ecx, 0x5e2dbe                            # 0044cfe1
    call FUN_00415176                            # 0044cfe6
    mov dword ptr [0x5b502f], eax                # 0044cfeb
L_0044cff0:
    # block 0x0044cff0: entered by jmp at 0x0044cfa5, 4 instruction(s), calls FUN_0044c4ab, falls into the block at 0x0044d006
    push 0x5b4eb1                                # 0044cff0
    call FUN_0044c4ab                            # 0044cff5
    add esp, 0x4                                 # 0044cffa
    mov word ptr [0x5b5081], 0x1                 # 0044cffd
L_0044d006:
    # block 0x0044d006: entered by jmp at 0x0044d01c; jmp at 0x0044d01e, 3 instruction(s), calls KERNEL32.dll!Sleep, ends with backward jump to 0x0044cf0d
    push 0x1                                     # 0044d006
    call dword ptr [0x52a2b0]                    # 0044d008
    jmp.d32 L_0044cf0d                           # 0044d00e
L_0044d013:
    # block 0x0044d013: entered by je at 0x0044cf14; jmp at 0x0044cf22, 3 instruction(s), calls FUN_0051ec84, falls into the block at 0x0044d01c
    push 0x1                                     # 0044d013
    push 0x0                                     # 0044d015
    call FUN_0051ec84                            # 0044d017
L_0044d01c:
    # block 0x0044d01c: entered by jmp at 0x0044cf4c, 1 instruction(s), ends with backward jump to 0x0044d006
    jmp.d8 L_0044d006                            # 0044d01c
L_0044d01e:
    # block 0x0044d01e: entered by jmp at 0x0044cf32, 1 instruction(s), ends with backward jump to 0x0044d006
    jmp.d8 L_0044d006                            # 0044d01e

