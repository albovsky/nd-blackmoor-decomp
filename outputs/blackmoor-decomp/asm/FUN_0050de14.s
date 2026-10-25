# FUN_0050de14
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050de14
# extent:       0x0050de14-0x0050de76 (98 code bytes)
# span:         0x0050de14-0x0050de76 (code 98, tables 0, padding 0)
# sha256:       dcff8f51f08ceba2edb5049656d4743224f2e59c1d3683319bbd31507bcc3073
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050de14
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       [esi + n] field_4
# callees:      calls FUN_005120d4, FUN_0051235b, FUN_00512126
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 48 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_005120d4, .text + (0x005120d4 - 0x401000)
.set FUN_00512126, .text + (0x00512126 - 0x401000)
.set FUN_0051235b, .text + (0x0051235b - 0x401000)

.org 0x0050de14 - 0x401000
.globl FUN_0050de14
FUN_0050de14:
    # block 0x0050de14: entry, 8 instruction(s), ends with jg to 0x0050de28 (forward)
    push ebp                                     # 0050de14
    {load} mov ebp, esp                          # 0050de15
    cmp dword ptr [ebp + arg_c], 0x0             # 0050de17
    push ebx                                     # 0050de1b
    mov ebx, dword ptr [ebp + arg_8]             # 0050de1c
    push edi                                     # 0050de1f
    {load} mov edi, ebx                          # 0050de20
    jg.d8 L_0050de28                             # 0050de22
    # block 0x0050de24: entered by fall-through of jg at 0x0050de22, 2 instruction(s), ends with forward jump to 0x0050de72
    {load} xor eax, eax                          # 0050de24
    jmp.d8 L_0050de72                            # 0050de26
L_0050de28:
    # block 0x0050de28: entered by jg at 0x0050de22, 5 instruction(s), calls FUN_005120d4, falls into the block at 0x0050de33
    push esi                                     # 0050de28
    mov esi, dword ptr [ebp + arg_10]            # 0050de29
    push esi                                     # 0050de2c
    call FUN_005120d4                            # 0050de2d
    pop ecx                                      # 0050de32
L_0050de33:
    # block 0x0050de33: entered by jmp at 0x0050de5a, 2 instruction(s), ends with je to 0x0050de65 (forward)
    dec dword ptr [ebp + arg_c]                  # 0050de33
    je.d8 L_0050de65                             # 0050de36
    # block 0x0050de38: entered by fall-through of je at 0x0050de36, 2 instruction(s), ends with js to 0x0050de47 (forward)
    dec dword ptr [esi + field_4]                # 0050de38
    js.d8 L_0050de47                             # 0050de3b
    # block 0x0050de3d: entered by fall-through of js at 0x0050de3b, 5 instruction(s), ends with forward jump to 0x0050de4e
    mov ecx, dword ptr [esi]                     # 0050de3d
    movzx eax, byte ptr [ecx]                    # 0050de3f
    inc ecx                                      # 0050de42
    mov dword ptr [esi], ecx                     # 0050de43
    jmp.d8 L_0050de4e                            # 0050de45
L_0050de47:
    # block 0x0050de47: entered by js at 0x0050de3b, 3 instruction(s), calls FUN_0051235b, falls into the block at 0x0050de4e
    push esi                                     # 0050de47
    call FUN_0051235b                            # 0050de48
    pop ecx                                      # 0050de4d
L_0050de4e:
    # block 0x0050de4e: entered by jmp at 0x0050de45, 2 instruction(s), ends with je to 0x0050de5c (forward)
    cmp eax, -0x1                                # 0050de4e
    je.d8 L_0050de5c                             # 0050de51
    # block 0x0050de53: entered by fall-through of je at 0x0050de51, 4 instruction(s), ends with je to 0x0050de65 (forward)
    mov byte ptr [edi], al                       # 0050de53
    inc edi                                      # 0050de55
    cmp al, 0xa                                  # 0050de56
    je.d8 L_0050de65                             # 0050de58
    # block 0x0050de5a: entered by fall-through of je at 0x0050de58, 1 instruction(s), ends with backward jump to 0x0050de33
    jmp.d8 L_0050de33                            # 0050de5a
L_0050de5c:
    # block 0x0050de5c: entered by je at 0x0050de51, 2 instruction(s), ends with jne to 0x0050de65 (forward)
    cmp edi, dword ptr [ebp + arg_8]             # 0050de5c
    jne.d8 L_0050de65                            # 0050de5f
    # block 0x0050de61: entered by fall-through of jne at 0x0050de5f, 2 instruction(s), ends with forward jump to 0x0050de68
    {load} xor ebx, ebx                          # 0050de61
    jmp.d8 L_0050de68                            # 0050de63
L_0050de65:
    # block 0x0050de65: entered by je at 0x0050de36; je at 0x0050de58; jne at 0x0050de5f, 1 instruction(s), falls into the block at 0x0050de68
    and byte ptr [edi], 0x0                      # 0050de65
L_0050de68:
    # block 0x0050de68: entered by jmp at 0x0050de63, 5 instruction(s), calls FUN_00512126, falls into the block at 0x0050de72
    push esi                                     # 0050de68
    call FUN_00512126                            # 0050de69
    pop ecx                                      # 0050de6e
    {load} mov eax, ebx                          # 0050de6f
    pop esi                                      # 0050de71
L_0050de72:
    # block 0x0050de72: entered by jmp at 0x0050de26, 4 instruction(s), ends with ret
    pop edi                                      # 0050de72
    pop ebx                                      # 0050de73
    pop ebp                                      # 0050de74
    ret                                          # 0050de75

