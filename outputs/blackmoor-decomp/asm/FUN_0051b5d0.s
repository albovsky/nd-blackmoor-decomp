# FUN_0051b5d0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051b5d0
# extent:       0x0051b5d0-0x0051b5fa (42 code bytes)
# span:         0x0051b5d0-0x0051b5fa (code 42, tables 0, padding 0)
# sha256:       5a4c818fab516f4734c8873bc1365e9e9dc7d2e7af925c2afcd3a87165180ee8
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051b5d0
# arguments:    1 ebp-relative stack slot(s) referenced: arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_8
# callees:      calls FUN_0051c519, FUN_0051ab4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0051b5fa
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)
.set FUN_0051c519, .text + (0x0051c519 - 0x401000)

.org 0x0051b5d0 - 0x401000
.globl FUN_0051b5d0
FUN_0051b5d0:
    # block 0x0051b5d0: entry, 11 instruction(s), calls FUN_0051c519, ends with je to 0x0051b5ee (forward)
    push ebp                                     # 0051b5d0
    {load} mov ebp, esp                          # 0051b5d1
    lea eax, [ebp + arg_c]                       # 0051b5d3
    push esi                                     # 0051b5d6
    push eax                                     # 0051b5d7
    mov eax, dword ptr [ebp + arg_c]             # 0051b5d8
    {load} mov esi, ecx                          # 0051b5db
    push dword ptr [eax + field_8]               # 0051b5dd
    call FUN_0051c519                            # 0051b5e0
    test eax, eax                                # 0051b5e5
    je.d8 L_0051b5ee                             # 0051b5e7
    # block 0x0051b5e9: entered by fall-through of je at 0x0051b5e7, 2 instruction(s), ends with forward jump to 0x0051b5f5
    mov eax, dword ptr [ebp + arg_c]             # 0051b5e9
    jmp.d8 L_0051b5f5                            # 0051b5ec
L_0051b5ee:
    # block 0x0051b5ee: entered by je at 0x0051b5e7, 2 instruction(s), calls FUN_0051ab4b, falls into the block at 0x0051b5f5
    {load} mov ecx, esi                          # 0051b5ee
    call FUN_0051ab4b                            # 0051b5f0
L_0051b5f5:
    # block 0x0051b5f5: entered by jmp at 0x0051b5ec, 3 instruction(s), ends with ret 0x8
    pop esi                                      # 0051b5f5
    pop ebp                                      # 0051b5f6
    ret 0x8                                      # 0051b5f7

