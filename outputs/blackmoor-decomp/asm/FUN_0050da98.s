# FUN_0050da98
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050da98
# extent:       0x0050da98-0x0050db47 (175 code bytes)
# span:         0x0050da98-0x0050db50 (code 175, tables 0, padding 9)
# sha256:       d05d92bfbb0771eac2c6d004ecffbdb1cb54cad9425ce0f203721da7e1ef19cb
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050da98
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_005130f0, FUN_00512c18, FUN_00512c79
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 71 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_00512c18, .text + (0x00512c18 - 0x401000)
.set FUN_00512c79, .text + (0x00512c79 - 0x401000)
.set FUN_005130f0, .text + (0x005130f0 - 0x401000)

.org 0x0050da98 - 0x401000
.globl FUN_0050da98
FUN_0050da98:
    # block 0x0050da98: entry, 7 instruction(s), ends with jne to 0x0050dab9 (forward)
    push ebp                                     # 0050da98
    {load} mov ebp, esp                          # 0050da99
    cmp dword ptr [0x63df1c], 0x0                # 0050da9b
    push ebx                                     # 0050daa2
    push esi                                     # 0050daa3
    push edi                                     # 0050daa4
    jne.d8 L_0050dab9                            # 0050daa5
    # block 0x0050daa7: entered by fall-through of jne at 0x0050daa5, 6 instruction(s), calls FUN_005130f0, ends with forward jump to 0x0050db42
    push dword ptr [ebp + arg_c]                 # 0050daa7
    push dword ptr [ebp + arg_8]                 # 0050daaa
    call FUN_005130f0                            # 0050daad
    pop ecx                                      # 0050dab2
    pop ecx                                      # 0050dab3
    jmp.d32 L_0050db42                           # 0050dab4
L_0050dab9:
    # block 0x0050dab9: entered by jne at 0x0050daa5, 5 instruction(s), calls FUN_00512c18, falls into the block at 0x0050dac7
    push 0x19                                    # 0050dab9
    call FUN_00512c18                            # 0050dabb
    mov esi, dword ptr [ebp + arg_c]             # 0050dac0
    mov edi, dword ptr [ebp + arg_8]             # 0050dac3
    pop ecx                                      # 0050dac6
L_0050dac7:
    # block 0x0050dac7: entered by jmp at 0x0050db22, 6 instruction(s), ends with je to 0x0050daf1 (forward)
    movzx cx, byte ptr [edi]                     # 0050dac7
    movzx eax, cl                                # 0050dacb
    inc edi                                      # 0050dace
    mov dword ptr [ebp + arg_c], ecx             # 0050dacf
    test byte ptr [eax + 0x63e021], 0x4          # 0050dad2
    je.d8 L_0050daf1                             # 0050dad9
    # block 0x0050dadb: entered by fall-through of je at 0x0050dad9, 3 instruction(s), ends with jne to 0x0050dae7 (forward)
    mov al, byte ptr [edi]                       # 0050dadb
    test al, al                                  # 0050dadd
    jne.d8 L_0050dae7                            # 0050dadf
    # block 0x0050dae1: entered by fall-through of jne at 0x0050dadf, 2 instruction(s), ends with forward jump to 0x0050daf1
    and dword ptr [ebp + arg_c], 0x0             # 0050dae1
    jmp.d8 L_0050daf1                            # 0050dae5
L_0050dae7:
    # block 0x0050dae7: entered by jne at 0x0050dadf, 5 instruction(s), falls into the block at 0x0050daf1
    {load} xor edx, edx                          # 0050dae7
    inc edi                                      # 0050dae9
    {load} mov dh, cl                            # 0050daea
    {load} mov dl, al                            # 0050daec
    mov dword ptr [ebp + arg_c], edx             # 0050daee
L_0050daf1:
    # block 0x0050daf1: entered by je at 0x0050dad9; jmp at 0x0050dae5, 5 instruction(s), ends with je to 0x0050db15 (forward)
    movzx bx, byte ptr [esi]                     # 0050daf1
    movzx eax, bl                                # 0050daf5
    inc esi                                      # 0050daf8
    test byte ptr [eax + 0x63e021], 0x4          # 0050daf9
    je.d8 L_0050db15                             # 0050db00
    # block 0x0050db02: entered by fall-through of je at 0x0050db00, 3 instruction(s), ends with jne to 0x0050db0c (forward)
    mov al, byte ptr [esi]                       # 0050db02
    test al, al                                  # 0050db04
    jne.d8 L_0050db0c                            # 0050db06
    # block 0x0050db08: entered by fall-through of jne at 0x0050db06, 2 instruction(s), ends with forward jump to 0x0050db15
    {load} xor ebx, ebx                          # 0050db08
    jmp.d8 L_0050db15                            # 0050db0a
L_0050db0c:
    # block 0x0050db0c: entered by jne at 0x0050db06, 5 instruction(s), falls into the block at 0x0050db15
    {load} xor ecx, ecx                          # 0050db0c
    inc esi                                      # 0050db0e
    {load} mov ch, bl                            # 0050db0f
    {load} mov cl, al                            # 0050db11
    {load} mov ebx, ecx                          # 0050db13
L_0050db15:
    # block 0x0050db15: entered by je at 0x0050db00; jmp at 0x0050db0a, 2 instruction(s), ends with jne to 0x0050db24 (forward)
    cmp word ptr [ebp + arg_c], bx               # 0050db15
    jne.d8 L_0050db24                            # 0050db19
    # block 0x0050db1b: entered by fall-through of jne at 0x0050db19, 2 instruction(s), ends with je to 0x0050db38 (forward)
    cmp word ptr [ebp + arg_c], 0x0              # 0050db1b
    je.d8 L_0050db38                             # 0050db20
    # block 0x0050db22: entered by fall-through of je at 0x0050db20, 1 instruction(s), ends with backward jump to 0x0050dac7
    jmp.d8 L_0050dac7                            # 0050db22
L_0050db24:
    # block 0x0050db24: entered by jne at 0x0050db19, 8 instruction(s), calls FUN_00512c79, ends with forward jump to 0x0050db42
    push 0x19                                    # 0050db24
    call FUN_00512c79                            # 0050db26
    cmp bx, word ptr [ebp + arg_c]               # 0050db2b
    pop ecx                                      # 0050db2f
    {load} sbb eax, eax                          # 0050db30
    and eax, 0x2                                 # 0050db32
    dec eax                                      # 0050db35
    jmp.d8 L_0050db42                            # 0050db36
L_0050db38:
    # block 0x0050db38: entered by je at 0x0050db20, 4 instruction(s), calls FUN_00512c79, falls into the block at 0x0050db42
    push 0x19                                    # 0050db38
    call FUN_00512c79                            # 0050db3a
    pop ecx                                      # 0050db3f
    {load} xor eax, eax                          # 0050db40
L_0050db42:
    # block 0x0050db42: entered by jmp at 0x0050dab4; jmp at 0x0050db36, 5 instruction(s), ends with ret
    pop edi                                      # 0050db42
    pop esi                                      # 0050db43
    pop ebx                                      # 0050db44
    pop ebp                                      # 0050db45
    ret                                          # 0050db46

# --- data items (not part of the function) -------------------------
.org 0x0050db47 - 0x401000
PAD_0050db47:  # 9 byte(s) of int3 padding
    .fill 9, 1, 0xcc

