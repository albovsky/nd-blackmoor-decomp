# FUN_0051cd70
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051cd70
# extent:       0x0051cd70-0x0051ce42 (210 code bytes)
# span:         0x0051cd70-0x0051ce42 (code 210, tables 0, padding 0)
# sha256:       8b871c342a5b6a336988c0f071df14e1a275b73e3ef47504908e604fa02e0cdb
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051cd70
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_20, local_24, local_28
# fields:       [ebx + n] field_1c
# callees:      calls FUN_0051c22e; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 76 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ arg_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0051c22e, .text + (0x0051c22e - 0x401000)

.org 0x0051cd70 - 0x401000
.globl FUN_0051cd70
FUN_0051cd70:
    # block 0x0051cd70: entry, 10 instruction(s), ends with je to 0x0051ce26 (forward)
    push ebp                                     # 0051cd70
    {load} mov ebp, esp                          # 0051cd71
    sub esp, 0x28                                # 0051cd73
    push ebx                                     # 0051cd76
    push esi                                     # 0051cd77
    mov esi, dword ptr [ebp + arg_8]             # 0051cd78
    {load} mov ebx, ecx                          # 0051cd7b
    test esi, esi                                # 0051cd7d
    mov dword ptr [ebp - local_4], 0x1           # 0051cd7f
    je.d32 L_0051ce26                            # 0051cd86
    # block 0x0051cd8c: entered by fall-through of je at 0x0051cd86, 2 instruction(s), falls into the block at 0x0051cd93
    push edi                                     # 0051cd8c
    mov edi, dword ptr [0x52a318]                # 0051cd8d
L_0051cd93:
    # block 0x0051cd93: entered by jne at 0x0051ce19, 3 instruction(s), ends with je to 0x0051ce1f (forward)
    mov cx, word ptr [esi]                       # 0051cd93
    test cx, cx                                  # 0051cd96
    je.d32 L_0051ce1f                            # 0051cd99
    # block 0x0051cd9f: entered by fall-through of je at 0x0051cd99, 10 instruction(s), ends with je to 0x0051cdd2 (forward)
    inc esi                                      # 0051cd9f
    inc esi                                      # 0051cda0
    mov ax, word ptr [esi]                       # 0051cda1
    inc esi                                      # 0051cda4
    inc esi                                      # 0051cda5
    mov edx, dword ptr [esi]                     # 0051cda6
    add esi, 0x4                                 # 0051cda8
    .insn 0x66, 0x3d, 0x1234{:u16}               # 0051cdab
    mov dword ptr [ebp + arg_8], edx             # 0051cdaf
    je.d8 L_0051cdd2                             # 0051cdb2
    # block 0x0051cdb4: entered by fall-through of je at 0x0051cdb2, 2 instruction(s), ends with jne to 0x0051cdc1 (forward)
    .insn 0x66, 0x3d, 0x0401{:u16}               # 0051cdb4
    jne.d8 L_0051cdc1                            # 0051cdb8
    # block 0x0051cdba: entered by fall-through of jne at 0x0051cdb8, 2 instruction(s), ends with forward jump to 0x0051cdf9
    mov eax, 0x180                               # 0051cdba
    jmp.d8 L_0051cdf9                            # 0051cdbf
L_0051cdc1:
    # block 0x0051cdc1: entered by jne at 0x0051cdb8, 2 instruction(s), ends with jne to 0x0051cdcc (forward)
    .insn 0x66, 0x3d, 0x0403{:u16}               # 0051cdc1
    jne.d8 L_0051cdcc                            # 0051cdc5
    # block 0x0051cdc7: entered by fall-through of jne at 0x0051cdc5, 1 instruction(s), falls into the block at 0x0051cdcc
    mov eax, 0x143                               # 0051cdc7
L_0051cdcc:
    # block 0x0051cdcc: entered by jne at 0x0051cdc5, 2 instruction(s), ends with jne to 0x0051cded (forward)
    .insn 0x66, 0x3d, 0x0401{:u16}               # 0051cdcc
    jne.d8 L_0051cded                            # 0051cdd0
L_0051cdd2:
    # block 0x0051cdd2: entered by je at 0x0051cdb2; fall-through of jne at 0x0051cdd0, 8 instruction(s), ends with forward jump to 0x0051ce00
    or dword ptr [ebp - local_24], -0x1          # 0051cdd2
    lea eax, [ebp - local_28]                    # 0051cdd6
    push eax                                     # 0051cdd9
    push 0x0                                     # 0051cdda
    mov dword ptr [ebp - local_28], 0x1          # 0051cddc
    mov dword ptr [ebp - local_20], esi          # 0051cde3
    push 0x401                                   # 0051cde6
    jmp.d8 L_0051ce00                            # 0051cdeb
L_0051cded:
    # block 0x0051cded: entered by jne at 0x0051cdd0, 2 instruction(s), ends with je to 0x0051cdf9 (forward)
    .insn 0x66, 0x3d, 0x0180{:u16}               # 0051cded
    je.d8 L_0051cdf9                             # 0051cdf1
    # block 0x0051cdf3: entered by fall-through of je at 0x0051cdf1, 2 instruction(s), ends with jne to 0x0051ce12 (forward)
    .insn 0x66, 0x3d, 0x0143{:u16}               # 0051cdf3
    jne.d8 L_0051ce12                            # 0051cdf7
L_0051cdf9:
    # block 0x0051cdf9: entered by jmp at 0x0051cdbf; je at 0x0051cdf1; fall-through of jne at 0x0051cdf7, 4 instruction(s), falls into the block at 0x0051ce00
    movzx eax, ax                                # 0051cdf9
    push esi                                     # 0051cdfc
    push 0x0                                     # 0051cdfd
    push eax                                     # 0051cdff
L_0051ce00:
    # block 0x0051ce00: entered by jmp at 0x0051cdeb, 6 instruction(s), calls indirect edi, ends with jne to 0x0051ce12 (forward)
    movzx eax, cx                                # 0051ce00
    push eax                                     # 0051ce03
    push dword ptr [ebx + field_1c]              # 0051ce04
    call edi                                     # 0051ce07
    cmp eax, -0x1                                # 0051ce09
    jne.d8 L_0051ce12                            # 0051ce0c
    # block 0x0051ce0e: entered by fall-through of jne at 0x0051ce0c, 1 instruction(s), falls into the block at 0x0051ce12
    and dword ptr [ebp - local_4], 0x0           # 0051ce0e
L_0051ce12:
    # block 0x0051ce12: entered by jne at 0x0051cdf7; jne at 0x0051ce0c, 3 instruction(s), ends with jne to 0x0051cd93 (backward)
    add esi, dword ptr [ebp + arg_8]             # 0051ce12
    cmp dword ptr [ebp - local_4], 0x0           # 0051ce15
    jne.d32 L_0051cd93                           # 0051ce19
L_0051ce1f:
    # block 0x0051ce1f: entered by je at 0x0051cd99; fall-through of jne at 0x0051ce19, 3 instruction(s), ends with je to 0x0051ce39 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 0051ce1f
    pop edi                                      # 0051ce23
    je.d8 L_0051ce39                             # 0051ce24
L_0051ce26:
    # block 0x0051ce26: entered by je at 0x0051cd86; fall-through of je at 0x0051ce24, 8 instruction(s), calls FUN_0051c22e, falls into the block at 0x0051ce39
    {load} xor eax, eax                          # 0051ce26
    push eax                                     # 0051ce28
    push eax                                     # 0051ce29
    push eax                                     # 0051ce2a
    push eax                                     # 0051ce2b
    push 0x364                                   # 0051ce2c
    push dword ptr [ebx + field_1c]              # 0051ce31
    call FUN_0051c22e                            # 0051ce34
L_0051ce39:
    # block 0x0051ce39: entered by je at 0x0051ce24, 5 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 0051ce39
    pop esi                                      # 0051ce3c
    pop ebx                                      # 0051ce3d
    leave                                        # 0051ce3e
    ret 0x4                                      # 0051ce3f

