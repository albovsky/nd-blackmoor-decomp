# FUN_0050db77
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050db77
# extent:       0x0050db77-0x0050dc53 (220 code bytes)
# span:         0x0050db77-0x0050dc53 (code 220, tables 0, padding 0)
# sha256:       eb6a8a420eda562cf31668f5c0d3ef47abe38381f9e0df9fbcb44b1b3096bee2
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050db77
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       14 ebp-relative slot(s): local_4, local_6, local_8, local_a, local_e, local_10, local_16, local_18, local_1a, local_1e, local_20, local_24 and 2 more
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls KERNEL32.dll!GetLocalTime, KERNEL32.dll!GetSystemTime, KERNEL32.dll!GetTimeZoneInformation, FUN_00513174
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 75 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_6, 0x6  # offset -0x6
.equ local_8, 0x8  # offset -0x8
.equ local_a, 0xa  # offset -0xa
.equ local_e, 0xe  # offset -0xe
.equ local_10, 0x10  # offset -0x10
.equ local_16, 0x16  # offset -0x16
.equ local_18, 0x18  # offset -0x18
.equ local_1a, 0x1a  # offset -0x1a
.equ local_1e, 0x1e  # offset -0x1e
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_32, 0x32  # offset -0x32
.equ local_cc, 0xcc  # offset -0xcc
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00513174, .text + (0x00513174 - 0x401000)

.org 0x0050db77 - 0x401000
.globl FUN_0050db77
FUN_0050db77:
    # block 0x0050db77: entry, 12 instruction(s), calls KERNEL32.dll!GetLocalTime, KERNEL32.dll!GetSystemTime, ends with jne to 0x0050dbdc (forward)
    push ebp                                     # 0050db77
    {load} mov ebp, esp                          # 0050db78
    sub esp, 0xcc                                # 0050db7a
    lea eax, [ebp - local_10]                    # 0050db80
    push eax                                     # 0050db83
    call dword ptr [0x52a13c]                    # 0050db84
    lea eax, [ebp - local_20]                    # 0050db8a
    push eax                                     # 0050db8d
    call dword ptr [0x52a270]                    # 0050db8e
    mov ax, word ptr [ebp - local_16]            # 0050db94
    cmp ax, word ptr [0x63ca62]                  # 0050db98
    jne.d8 L_0050dbdc                            # 0050db9f
    # block 0x0050dba1: entered by fall-through of jne at 0x0050db9f, 3 instruction(s), ends with jne to 0x0050dbdc (forward)
    mov ax, word ptr [ebp - local_18]            # 0050dba1
    cmp ax, word ptr [0x63ca60]                  # 0050dba5
    jne.d8 L_0050dbdc                            # 0050dbac
    # block 0x0050dbae: entered by fall-through of jne at 0x0050dbac, 3 instruction(s), ends with jne to 0x0050dbdc (forward)
    mov ax, word ptr [ebp - local_1a]            # 0050dbae
    cmp ax, word ptr [0x63ca5e]                  # 0050dbb2
    jne.d8 L_0050dbdc                            # 0050dbb9
    # block 0x0050dbbb: entered by fall-through of jne at 0x0050dbb9, 3 instruction(s), ends with jne to 0x0050dbdc (forward)
    mov ax, word ptr [ebp - local_1e]            # 0050dbbb
    cmp ax, word ptr [0x63ca5a]                  # 0050dbbf
    jne.d8 L_0050dbdc                            # 0050dbc6
    # block 0x0050dbc8: entered by fall-through of jne at 0x0050dbc6, 3 instruction(s), ends with jne to 0x0050dbdc (forward)
    mov ax, word ptr [ebp - local_20]            # 0050dbc8
    cmp ax, word ptr [0x63ca58]                  # 0050dbcc
    jne.d8 L_0050dbdc                            # 0050dbd3
    # block 0x0050dbd5: entered by fall-through of jne at 0x0050dbd3, 2 instruction(s), ends with forward jump to 0x0050dc21
    mov eax, dword ptr [0x63ca50]                # 0050dbd5
    jmp.d8 L_0050dc21                            # 0050dbda
L_0050dbdc:
    # block 0x0050dbdc: entered by jne at 0x0050db9f; jne at 0x0050dbac; jne at 0x0050dbb9; jne at 0x0050dbc6; more, 5 instruction(s), calls KERNEL32.dll!GetTimeZoneInformation, ends with je to 0x0050dc09 (forward)
    lea eax, [ebp - local_cc]                    # 0050dbdc
    push eax                                     # 0050dbe2
    call dword ptr [0x52a138]                    # 0050dbe3
    cmp eax, -0x1                                # 0050dbe9
    je.d8 L_0050dc09                             # 0050dbec
    # block 0x0050dbee: entered by fall-through of je at 0x0050dbec, 2 instruction(s), ends with jne to 0x0050dc05 (forward)
    cmp eax, 0x2                                 # 0050dbee
    jne.d8 L_0050dc05                            # 0050dbf1
    # block 0x0050dbf3: entered by fall-through of jne at 0x0050dbf1, 2 instruction(s), ends with je to 0x0050dc05 (forward)
    cmp word ptr [ebp - local_32], 0x0           # 0050dbf3
    je.d8 L_0050dc05                             # 0050dbf8
    # block 0x0050dbfa: entered by fall-through of je at 0x0050dbf8, 2 instruction(s), ends with je to 0x0050dc05 (forward)
    cmp dword ptr [ebp - local_24], 0x0          # 0050dbfa
    je.d8 L_0050dc05                             # 0050dbfe
    # block 0x0050dc00: entered by fall-through of je at 0x0050dbfe, 3 instruction(s), ends with forward jump to 0x0050dc0c
    push 0x1                                     # 0050dc00
    pop eax                                      # 0050dc02
    jmp.d8 L_0050dc0c                            # 0050dc03
L_0050dc05:
    # block 0x0050dc05: entered by jne at 0x0050dbf1; je at 0x0050dbf8; je at 0x0050dbfe, 2 instruction(s), ends with forward jump to 0x0050dc0c
    {load} xor eax, eax                          # 0050dc05
    jmp.d8 L_0050dc0c                            # 0050dc07
L_0050dc09:
    # block 0x0050dc09: entered by je at 0x0050dbec, 1 instruction(s), falls into the block at 0x0050dc0c
    or eax, -0x1                                 # 0050dc09
L_0050dc0c:
    # block 0x0050dc0c: entered by jmp at 0x0050dc03; jmp at 0x0050dc07, 11 instruction(s), falls into the block at 0x0050dc21
    push esi                                     # 0050dc0c
    push edi                                     # 0050dc0d
    lea esi, [ebp - local_20]                    # 0050dc0e
    mov edi, 0x63ca58                            # 0050dc11
    movsd dword ptr es:[edi], dword ptr [esi]    # 0050dc16
    movsd dword ptr es:[edi], dword ptr [esi]    # 0050dc17
    movsd dword ptr es:[edi], dword ptr [esi]    # 0050dc18
    movsd dword ptr es:[edi], dword ptr [esi]    # 0050dc19
    pop edi                                      # 0050dc1a
    mov dword ptr [0x63ca50], eax                # 0050dc1b
    pop esi                                      # 0050dc20
L_0050dc21:
    # block 0x0050dc21: entered by jmp at 0x0050dbda, 18 instruction(s), calls FUN_00513174, ends with je to 0x0050dc51 (forward)
    push eax                                     # 0050dc21
    movzx eax, word ptr [ebp - local_4]          # 0050dc22
    push eax                                     # 0050dc26
    movzx eax, word ptr [ebp - local_6]          # 0050dc27
    push eax                                     # 0050dc2b
    movzx eax, word ptr [ebp - local_8]          # 0050dc2c
    push eax                                     # 0050dc30
    movzx eax, word ptr [ebp - local_a]          # 0050dc31
    push eax                                     # 0050dc35
    movzx eax, word ptr [ebp - local_e]          # 0050dc36
    push eax                                     # 0050dc3a
    movzx eax, word ptr [ebp - local_10]         # 0050dc3b
    push eax                                     # 0050dc3f
    call FUN_00513174                            # 0050dc40
    mov ecx, dword ptr [ebp + arg_8]             # 0050dc45
    add esp, 0x1c                                # 0050dc48
    test ecx, ecx                                # 0050dc4b
    je.d8 L_0050dc51                             # 0050dc4d
    # block 0x0050dc4f: entered by fall-through of je at 0x0050dc4d, 1 instruction(s), falls into the block at 0x0050dc51
    mov dword ptr [ecx], eax                     # 0050dc4f
L_0050dc51:
    # block 0x0050dc51: entered by je at 0x0050dc4d, 2 instruction(s), ends with ret
    leave                                        # 0050dc51
    ret                                          # 0050dc52

