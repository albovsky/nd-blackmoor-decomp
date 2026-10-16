# FUN_0051ff07
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051ff07
# extent:       0x0051ff07-0x0051ff98 (145 code bytes)
# span:         0x0051ff07-0x0051ff98 (code 145, tables 0, padding 0)
# sha256:       abe7e30684440872934589022f15ea9104a14bac912b36615ca138b189793265
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051ff07
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_24, local_40
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls GDI32.dll!GetObjectA, USER32.dll!GetDC, GDI32.dll!GetDeviceCaps, KERNEL32.dll!MulDiv, USER32.dll!ReleaseDC, FUN_0051fded; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 58 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_24, 0x24  # offset -0x24
.equ local_40, 0x40  # offset -0x40
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051fded, .text + (0x0051fded - 0x401000)

.org 0x0051ff07 - 0x401000
.globl FUN_0051ff07
FUN_0051ff07:
    # block 0x0051ff07: entry, 15 instruction(s), calls indirect esi, ends with jne to 0x0051ff31 (forward)
    push ebp                                     # 0051ff07
    {load} mov ebp, esp                          # 0051ff08
    sub esp, 0x40                                # 0051ff0a
    push ebx                                     # 0051ff0d
    push esi                                     # 0051ff0e
    mov esi, dword ptr [0x52a0ac]                # 0051ff0f
    push edi                                     # 0051ff15
    push 0xa                                     # 0051ff16
    mov dword ptr [ebp - local_4], ecx           # 0051ff18
    pop ebx                                      # 0051ff1b
    mov edi, 0x52ff40                            # 0051ff1c
    push 0x11                                    # 0051ff21
    call esi                                     # 0051ff23
    test eax, eax                                # 0051ff25
    jne.d8 L_0051ff31                            # 0051ff27
    # block 0x0051ff29: entered by fall-through of jne at 0x0051ff27, 4 instruction(s), calls indirect esi, ends with je to 0x0051ff7b (forward)
    push 0xd                                     # 0051ff29
    call esi                                     # 0051ff2b
    test eax, eax                                # 0051ff2d
    je.d8 L_0051ff7b                             # 0051ff2f
L_0051ff31:
    # block 0x0051ff31: entered by jne at 0x0051ff27; fall-through of je at 0x0051ff2f, 7 instruction(s), calls GDI32.dll!GetObjectA, ends with je to 0x0051ff7b (forward)
    lea ecx, [ebp - local_40]                    # 0051ff31
    push ecx                                     # 0051ff34
    push 0x3c                                    # 0051ff35
    push eax                                     # 0051ff37
    call dword ptr [0x52a054]                    # 0051ff38
    test eax, eax                                # 0051ff3e
    je.d8 L_0051ff7b                             # 0051ff40
    # block 0x0051ff42: entered by fall-through of je at 0x0051ff40, 7 instruction(s), calls USER32.dll!GetDC, ends with jge to 0x0051ff5b (forward)
    push 0x0                                     # 0051ff42
    lea edi, [ebp - local_24]                    # 0051ff44
    call dword ptr [0x52a3a4]                    # 0051ff47
    {load} mov esi, eax                          # 0051ff4d
    mov eax, dword ptr [ebp - local_40]          # 0051ff4f
    test eax, eax                                # 0051ff52
    jge.d8 L_0051ff5b                            # 0051ff54
    # block 0x0051ff56: entered by fall-through of jge at 0x0051ff54, 2 instruction(s), falls into the block at 0x0051ff5b
    neg eax                                      # 0051ff56
    mov dword ptr [ebp - local_40], eax          # 0051ff58
L_0051ff5b:
    # block 0x0051ff5b: entered by jge at 0x0051ff54, 11 instruction(s), calls GDI32.dll!GetDeviceCaps, KERNEL32.dll!MulDiv, USER32.dll!ReleaseDC, falls into the block at 0x0051ff7b
    push 0x5a                                    # 0051ff5b
    push esi                                     # 0051ff5d
    call dword ptr [0x52a094]                    # 0051ff5e
    push eax                                     # 0051ff64
    push 0x48                                    # 0051ff65
    push dword ptr [ebp - local_40]              # 0051ff67
    call dword ptr [0x52a1cc]                    # 0051ff6a
    push esi                                     # 0051ff70
    push 0x0                                     # 0051ff71
    {load} mov ebx, eax                          # 0051ff73
    call dword ptr [0x52a3a8]                    # 0051ff75
L_0051ff7b:
    # block 0x0051ff7b: entered by je at 0x0051ff2f; je at 0x0051ff40, 2 instruction(s), ends with jne to 0x0051ff85 (forward)
    cmp word ptr [ebp + arg_8], 0x0              # 0051ff7b
    jne.d8 L_0051ff85                            # 0051ff80
    # block 0x0051ff82: entered by fall-through of jne at 0x0051ff80, 1 instruction(s), falls into the block at 0x0051ff85
    mov dword ptr [ebp + arg_8], ebx             # 0051ff82
L_0051ff85:
    # block 0x0051ff85: entered by jne at 0x0051ff80, 9 instruction(s), calls FUN_0051fded, ends with ret 0x4
    push dword ptr [ebp + arg_8]                 # 0051ff85
    mov ecx, dword ptr [ebp - local_4]           # 0051ff88
    push edi                                     # 0051ff8b
    call FUN_0051fded                            # 0051ff8c
    pop edi                                      # 0051ff91
    pop esi                                      # 0051ff92
    pop ebx                                      # 0051ff93
    leave                                        # 0051ff94
    ret 0x4                                      # 0051ff95

