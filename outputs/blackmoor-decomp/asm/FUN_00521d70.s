# FUN_00521d70
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00521d70
# extent:       0x00521d70-0x00521de1 (113 code bytes)
# span:         0x00521d70-0x00521de1 (code 113, tables 0, padding 0)
# sha256:       95cd4a5b52f2f1326374b0998b771b57286d2010e054379a0c91def77fb47aa5
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00521d70
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_4; [esi + n] field_1c
# callees:      calls FUN_0051c4ec, FUN_0051e4ca, FUN_0051ca36, FUN_0051ab4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 42 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00521de1
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)
.set FUN_0051c4ec, .text + (0x0051c4ec - 0x401000)
.set FUN_0051ca36, .text + (0x0051ca36 - 0x401000)
.set FUN_0051e4ca, .text + (0x0051e4ca - 0x401000)

.org 0x00521d70 - 0x401000
.globl FUN_00521d70
FUN_00521d70:
    # block 0x00521d70: entry, 12 instruction(s), calls FUN_0051c4ec, ends with je to 0x00521d8e (forward)
    push ebp                                     # 00521d70
    {load} mov ebp, esp                          # 00521d71
    push esi                                     # 00521d73
    mov esi, dword ptr [ebp + arg_c]             # 00521d74
    push edi                                     # 00521d77
    {load} mov edi, ecx                          # 00521d78
    lea eax, [ebp + arg_c]                       # 00521d7a
    {load} mov ecx, esi                          # 00521d7d
    push eax                                     # 00521d7f
    call FUN_0051c4ec                            # 00521d80
    test eax, eax                                # 00521d85
    je.d8 L_00521d8e                             # 00521d87
    # block 0x00521d89: entered by fall-through of je at 0x00521d87, 2 instruction(s), ends with forward jump to 0x00521ddb
    mov eax, dword ptr [ebp + arg_c]             # 00521d89
    jmp.d8 L_00521ddb                            # 00521d8c
L_00521d8e:
    # block 0x00521d8e: entered by je at 0x00521d87, 2 instruction(s), ends with je to 0x00521da7 (forward)
    cmp dword ptr [0x63c7a4], 0x0                # 00521d8e
    je.d8 L_00521da7                             # 00521d95
    # block 0x00521d97: entered by fall-through of je at 0x00521d95, 6 instruction(s), calls FUN_0051e4ca, ends with forward jump to 0x00521ddb
    push dword ptr [ebp + arg_10]                # 00521d97
    {load} mov ecx, edi                          # 00521d9a
    push esi                                     # 00521d9c
    push dword ptr [ebp + arg_8]                 # 00521d9d
    call FUN_0051e4ca                            # 00521da0
    jmp.d8 L_00521ddb                            # 00521da5
L_00521da7:
    # block 0x00521da7: entered by je at 0x00521d95, 2 instruction(s), ends with je to 0x00521dae (forward)
    test esi, esi                                # 00521da7
    je.d8 L_00521dae                             # 00521da9
    # block 0x00521dab: entered by fall-through of je at 0x00521da9, 1 instruction(s), falls into the block at 0x00521dae
    mov esi, dword ptr [esi + field_1c]          # 00521dab
L_00521dae:
    # block 0x00521dae: entered by je at 0x00521da9, 9 instruction(s), calls FUN_0051ca36, ends with jne to 0x00521dd6 (forward)
    push dword ptr [0x63c77c]                    # 00521dae
    mov eax, dword ptr [ebp + arg_8]             # 00521db4
    push dword ptr [0x63c76c]                    # 00521db7
    push dword ptr [ebp + arg_10]                # 00521dbd
    push esi                                     # 00521dc0
    push dword ptr [eax + field_4]               # 00521dc1
    call FUN_0051ca36                            # 00521dc4
    test eax, eax                                # 00521dc9
    jne.d8 L_00521dd6                            # 00521dcb
    # block 0x00521dcd: entered by fall-through of jne at 0x00521dcb, 3 instruction(s), calls FUN_0051ab4b, ends with forward jump to 0x00521ddb
    {load} mov ecx, edi                          # 00521dcd
    call FUN_0051ab4b                            # 00521dcf
    jmp.d8 L_00521ddb                            # 00521dd4
L_00521dd6:
    # block 0x00521dd6: entered by jne at 0x00521dcb, 1 instruction(s), falls into the block at 0x00521ddb
    mov eax, dword ptr [0x63c76c]                # 00521dd6
L_00521ddb:
    # block 0x00521ddb: entered by jmp at 0x00521d8c; jmp at 0x00521da5; jmp at 0x00521dd4, 4 instruction(s), ends with ret 0xc
    pop edi                                      # 00521ddb
    pop esi                                      # 00521ddc
    pop ebp                                      # 00521ddd
    ret 0xc                                      # 00521dde

