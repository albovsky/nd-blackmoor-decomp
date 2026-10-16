# FUN_0051acc6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051acc6
# extent:       0x0051acc6-0x0051ade9 (291 code bytes)
# span:         0x0051acc6-0x0051ade9 (code 291, tables 0, padding 0)
# sha256:       1c0bb29702c21cb01d0478022c91a1763ddf8eb488001127e5267698a69e1abb
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051acc6
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x10 (callee pops 16 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8, field_c, field_10, field_14, field_minus_4, field_minus_c, field_minus_10, field_minus_14, field_minus_18, field_minus_1c, field_minus_30
# callees:      calls FUN_0050f978, USER32.dll!GetPropA, FUN_0051abe4, FUN_0051a8b0, USER32.dll!CallWindowProcA, FUN_0051a8d3, USER32.dll!SetWindowLongA, USER32.dll!RemovePropA, KERNEL32.dll!GlobalFindAtomA, KERNEL32.dll!GlobalDeleteAtom, FUN_0051a9ad, FUN_0051a94c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 99 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_minus_14, 0x14  # offset -0x14
.equ field_minus_18, 0x18  # offset -0x18
.equ field_minus_1c, 0x1c  # offset -0x1c
.equ field_minus_30, 0x30  # offset -0x30
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051a8b0, .text + (0x0051a8b0 - 0x401000)
.set FUN_0051a8d3, .text + (0x0051a8d3 - 0x401000)
.set FUN_0051a94c, .text + (0x0051a94c - 0x401000)
.set FUN_0051a9ad, .text + (0x0051a9ad - 0x401000)
.set FUN_0051abe4, .text + (0x0051abe4 - 0x401000)

.org 0x0051acc6 - 0x401000
.globl FUN_0051acc6
FUN_0051acc6:
    # block 0x0051acc6: entry, 20 instruction(s), calls FUN_0050f978, USER32.dll!GetPropA, ends with je to 0x0051adb0 (forward)
    mov eax, 0x528b60                            # 0051acc6
    call FUN_0050f978                            # 0051accb
    sub esp, 0x40                                # 0051acd0
    push ebx                                     # 0051acd3
    push esi                                     # 0051acd4
    push edi                                     # 0051acd5
    mov edi, dword ptr [ebp + field_8]           # 0051acd6
    mov esi, 0x52e958                            # 0051acd9
    mov dword ptr [ebp - field_minus_10], esp    # 0051acde
    push esi                                     # 0051ace1
    push edi                                     # 0051ace2
    call dword ptr [0x52a430]                    # 0051ace3
    and dword ptr [ebp - field_minus_14], 0x0    # 0051ace9
    and dword ptr [ebp - field_minus_4], 0x0     # 0051aced
    mov dword ptr [ebp - field_minus_18], eax    # 0051acf1
    mov eax, dword ptr [ebp + field_c]           # 0051acf4
    push 0x1                                     # 0051acf7
    sub eax, 0x6                                 # 0051acf9
    pop ebx                                      # 0051acfc
    je.d32 L_0051adb0                            # 0051acfd
    # block 0x0051ad03: entered by fall-through of je at 0x0051acfd, 2 instruction(s), ends with je to 0x0051ad8f (forward)
    sub eax, 0x1a                                # 0051ad03
    je.d32 L_0051ad8f                            # 0051ad06
    # block 0x0051ad0c: entered by fall-through of je at 0x0051ad06, 2 instruction(s), ends with je to 0x0051ad6b (forward)
    sub eax, 0x62                                # 0051ad0c
    je.d8 L_0051ad6b                             # 0051ad0f
    # block 0x0051ad11: entered by fall-through of je at 0x0051ad0f, 2 instruction(s), ends with jne to 0x0051adce (forward)
    sub eax, 0x8e                                # 0051ad11
    jne.d32 L_0051adce                           # 0051ad16
    # block 0x0051ad1c: entered by fall-through of jne at 0x0051ad16, 21 instruction(s), calls FUN_0051abe4, FUN_0051a8b0, USER32.dll!CallWindowProcA, FUN_0051a8d3, falls into the block at 0x0051ad57
    push edi                                     # 0051ad1c
    call FUN_0051abe4                            # 0051ad1d
    {load} mov esi, eax                          # 0051ad22
    lea eax, [ebp - field_minus_1c]              # 0051ad24
    push eax                                     # 0051ad27
    lea eax, [ebp - field_minus_30]              # 0051ad28
    push eax                                     # 0051ad2b
    push esi                                     # 0051ad2c
    call FUN_0051a8b0                            # 0051ad2d
    push dword ptr [ebp + field_14]              # 0051ad32
    push dword ptr [ebp + field_10]              # 0051ad35
    push 0x110                                   # 0051ad38
    push edi                                     # 0051ad3d
    push dword ptr [ebp - field_minus_18]        # 0051ad3e
    call dword ptr [0x52a434]                    # 0051ad41
    push dword ptr [ebp - field_minus_1c]        # 0051ad47
    mov dword ptr [ebp - field_minus_14], eax    # 0051ad4a
    lea eax, [ebp - field_minus_30]              # 0051ad4d
    push eax                                     # 0051ad50
    push esi                                     # 0051ad51
    call FUN_0051a8d3                            # 0051ad52
L_0051ad57:
    # block 0x0051ad57: entered by je at 0x0051adcc; jmp at 0x0051ade4, 8 instruction(s), ends with ret 0x10
    mov ecx, dword ptr [ebp - field_minus_c]     # 0051ad57
    mov eax, dword ptr [ebp - field_minus_14]    # 0051ad5a
    pop edi                                      # 0051ad5d
    pop esi                                      # 0051ad5e
    mov dword ptr fs:[0x0], ecx                  # 0051ad5f
    pop ebx                                      # 0051ad66
    leave                                        # 0051ad67
    ret 0x10                                     # 0051ad68
L_0051ad6b:
    # block 0x0051ad6b: entered by je at 0x0051ad0f, 12 instruction(s), calls USER32.dll!SetWindowLongA, USER32.dll!RemovePropA, KERNEL32.dll!GlobalFindAtomA, KERNEL32.dll!Glo..., ends with forward jump to 0x0051adce
    push dword ptr [ebp - field_minus_18]        # 0051ad6b
    push -0x4                                    # 0051ad6e
    push edi                                     # 0051ad70
    call dword ptr [0x52a458]                    # 0051ad71
    push esi                                     # 0051ad77
    push edi                                     # 0051ad78
    call dword ptr [0x52a438]                    # 0051ad79
    push esi                                     # 0051ad7f
    call dword ptr [0x52a238]                    # 0051ad80
    push eax                                     # 0051ad86
    call dword ptr [0x52a240]                    # 0051ad87
    jmp.d8 L_0051adce                            # 0051ad8d
L_0051ad8f:
    # block 0x0051ad8f: entered by je at 0x0051ad06, 13 instruction(s), calls FUN_0051abe4, FUN_0051a9ad, ends with forward jump to 0x0051adca
    push edi                                     # 0051ad8f
    call FUN_0051abe4                            # 0051ad90
    mov ecx, dword ptr [ebp + field_14]          # 0051ad95
    shr ecx, 0x10                                # 0051ad98
    push ecx                                     # 0051ad9b
    movsx ecx, word ptr [ebp + field_14]         # 0051ad9c
    push ecx                                     # 0051ada0
    push eax                                     # 0051ada1
    call FUN_0051a9ad                            # 0051ada2
    {load} xor ebx, ebx                          # 0051ada7
    test eax, eax                                # 0051ada9
    sete bl                                      # 0051adab
    jmp.d8 L_0051adca                            # 0051adae
L_0051adb0:
    # block 0x0051adb0: entered by je at 0x0051acfd, 9 instruction(s), calls FUN_0051abe4, FUN_0051a94c, falls into the block at 0x0051adca
    push dword ptr [ebp + field_14]              # 0051adb0
    call FUN_0051abe4                            # 0051adb3
    push edi                                     # 0051adb8
    {load} mov esi, eax                          # 0051adb9
    call FUN_0051abe4                            # 0051adbb
    push esi                                     # 0051adc0
    push dword ptr [ebp + field_10]              # 0051adc1
    push eax                                     # 0051adc4
    call FUN_0051a94c                            # 0051adc5
L_0051adca:
    # block 0x0051adca: entered by jmp at 0x0051adae, 2 instruction(s), ends with je to 0x0051ad57 (backward)
    test ebx, ebx                                # 0051adca
    je.d8 L_0051ad57                             # 0051adcc
L_0051adce:
    # block 0x0051adce: entered by jne at 0x0051ad16; jmp at 0x0051ad8d; fall-through of je at 0x0051adcc, 8 instruction(s), calls USER32.dll!CallWindowProcA, ends with backward jump to 0x0051ad57
    push dword ptr [ebp + field_14]              # 0051adce
    push dword ptr [ebp + field_10]              # 0051add1
    push dword ptr [ebp + field_c]               # 0051add4
    push edi                                     # 0051add7
    push dword ptr [ebp - field_minus_18]        # 0051add8
    call dword ptr [0x52a434]                    # 0051addb
    mov dword ptr [ebp - field_minus_14], eax    # 0051ade1
    jmp.d32 L_0051ad57                           # 0051ade4

