# FUN_0051fb55
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051fb55
# extent:       0x0051fb55-0x0051fbcd (120 code bytes)
# span:         0x0051fb55-0x0051fbcd (code 120, tables 0, padding 0)
# sha256:       2c5ce942d4cb981d96f777c4d6b11884cb9f7a4fafabc0d18a05b6b1f0f008a3
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051fb55
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050fde2, KERNEL32.dll!lstrlenA, FUN_0051e745, FUN_0051eaec, FUN_0050fa90
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 58 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0050fa90, .text + (0x0050fa90 - 0x401000)
.set FUN_0050fde2, .text + (0x0050fde2 - 0x401000)
.set FUN_0051e745, .text + (0x0051e745 - 0x401000)
.set FUN_0051eaec, .text + (0x0051eaec - 0x401000)

.org 0x0051fb55 - 0x401000
.globl FUN_0051fb55
FUN_0051fb55:
    # block 0x0051fb55: entry, 8 instruction(s), ends with je to 0x0051fba9 (forward)
    push ebp                                     # 0051fb55
    {load} mov ebp, esp                          # 0051fb56
    push ebx                                     # 0051fb58
    push esi                                     # 0051fb59
    mov esi, dword ptr [ebp + arg_c]             # 0051fb5a
    push edi                                     # 0051fb5d
    test esi, esi                                # 0051fb5e
    je.d8 L_0051fba9                             # 0051fb60
    # block 0x0051fb62: entered by fall-through of je at 0x0051fb60, 5 instruction(s), ends with je to 0x0051fb87 (forward)
    mov ebx, dword ptr [ebp + arg_10]            # 0051fb62
    {load} mov eax, ebx                          # 0051fb65
    dec ebx                                      # 0051fb67
    test eax, eax                                # 0051fb68
    je.d8 L_0051fb87                             # 0051fb6a
    # block 0x0051fb6c: entered by fall-through of je at 0x0051fb6a, 1 instruction(s), falls into the block at 0x0051fb70
    movsx edi, byte ptr [ebp + arg_14]           # 0051fb6c
L_0051fb70:
    # block 0x0051fb70: entered by jne at 0x0051fb85, 8 instruction(s), calls FUN_0050fde2, ends with je to 0x0051fba1 (forward)
    push edi                                     # 0051fb70
    push esi                                     # 0051fb71
    call FUN_0050fde2                            # 0051fb72
    {load} mov esi, eax                          # 0051fb77
    pop ecx                                      # 0051fb79
    test esi, esi                                # 0051fb7a
    pop ecx                                      # 0051fb7c
    je.d8 L_0051fba1                             # 0051fb7d
    # block 0x0051fb7f: entered by fall-through of je at 0x0051fb7d, 5 instruction(s), ends with jne to 0x0051fb70 (backward)
    inc esi                                      # 0051fb7f
    {load} mov eax, ebx                          # 0051fb80
    dec ebx                                      # 0051fb82
    test eax, eax                                # 0051fb83
    jne.d8 L_0051fb70                            # 0051fb85
L_0051fb87:
    # block 0x0051fb87: entered by je at 0x0051fb6a; fall-through of jne at 0x0051fb85, 8 instruction(s), calls FUN_0050fde2, ends with jne to 0x0051fbad (forward)
    movsx eax, byte ptr [ebp + arg_14]           # 0051fb87
    push eax                                     # 0051fb8b
    push esi                                     # 0051fb8c
    call FUN_0050fde2                            # 0051fb8d
    pop ecx                                      # 0051fb92
    test eax, eax                                # 0051fb93
    pop ecx                                      # 0051fb95
    jne.d8 L_0051fbad                            # 0051fb96
    # block 0x0051fb98: entered by fall-through of jne at 0x0051fb96, 3 instruction(s), calls KERNEL32.dll!lstrlenA, ends with forward jump to 0x0051fbaf
    push esi                                     # 0051fb98
    call dword ptr [0x52a1f8]                    # 0051fb99
    jmp.d8 L_0051fbaf                            # 0051fb9f
L_0051fba1:
    # block 0x0051fba1: entered by je at 0x0051fb7d, 2 instruction(s), calls FUN_0051e745, falls into the block at 0x0051fba9
    mov ecx, dword ptr [ebp + arg_8]             # 0051fba1
    call FUN_0051e745                            # 0051fba4
L_0051fba9:
    # block 0x0051fba9: entered by je at 0x0051fb60, 2 instruction(s), ends with forward jump to 0x0051fbc6
    {load} xor eax, eax                          # 0051fba9
    jmp.d8 L_0051fbc6                            # 0051fbab
L_0051fbad:
    # block 0x0051fbad: entered by jne at 0x0051fb96, 1 instruction(s), falls into the block at 0x0051fbaf
    {load} sub eax, esi                          # 0051fbad
L_0051fbaf:
    # block 0x0051fbaf: entered by jmp at 0x0051fb9f, 10 instruction(s), calls FUN_0051eaec, FUN_0050fa90, falls into the block at 0x0051fbc6
    mov ecx, dword ptr [ebp + arg_8]             # 0051fbaf
    push eax                                     # 0051fbb2
    push esi                                     # 0051fbb3
    push eax                                     # 0051fbb4
    call FUN_0051eaec                            # 0051fbb5
    push eax                                     # 0051fbba
    call FUN_0050fa90                            # 0051fbbb
    add esp, 0xc                                 # 0051fbc0
    push 0x1                                     # 0051fbc3
    pop eax                                      # 0051fbc5
L_0051fbc6:
    # block 0x0051fbc6: entered by jmp at 0x0051fbab, 5 instruction(s), ends with ret 0x10
    pop edi                                      # 0051fbc6
    pop esi                                      # 0051fbc7
    pop ebx                                      # 0051fbc8
    pop ebp                                      # 0051fbc9
    ret 0x10                                     # 0051fbca

