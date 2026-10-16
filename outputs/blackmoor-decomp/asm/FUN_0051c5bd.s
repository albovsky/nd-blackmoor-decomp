# FUN_0051c5bd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051c5bd
# extent:       0x0051c5bd-0x0051c618 (91 code bytes)
# span:         0x0051c5bd-0x0051c618 (code 91, tables 0, padding 0)
# sha256:       b76ec872f11db4fb0aaaf81de6080a8fd2fed6ac8e6be09437c1a0a77581d16b
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051c5bd
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none: no [ebp-n] slot referenced
# fields:       [ecx + n] field_1c, field_38; [esi + n] field_2000
# callees:      calls USER32.dll!SendMessageA, FUN_0051c618
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 33 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_1c, 0x1c  # offset +0x1c
.equ field_38, 0x38  # offset +0x38
.equ field_2000, 0x2000  # offset +0x2000

# --- external targets -----------------------------------------------
.set FUN_0051c618, .text + (0x0051c618 - 0x401000)

.org 0x0051c5bd - 0x401000
.globl FUN_0051c5bd
FUN_0051c5bd:
    # block 0x0051c5bd: entry, 5 instruction(s), ends with je to 0x0051c602 (forward)
    push ebp                                     # 0051c5bd
    {load} mov ebp, esp                          # 0051c5be
    cmp dword ptr [ecx + field_38], 0x0          # 0051c5c0
    push esi                                     # 0051c5c4
    je.d8 L_0051c602                             # 0051c5c5
    # block 0x0051c5c7: entered by fall-through of je at 0x0051c5c5, 9 instruction(s), calls USER32.dll!SendMessageA, ends with jb to 0x0051c5f4 (forward)
    push dword ptr [ebp + arg_10]                # 0051c5c7
    mov esi, dword ptr [ebp + arg_8]             # 0051c5ca
    push dword ptr [ebp + arg_c]                 # 0051c5cd
    lea eax, [esi + field_2000]                  # 0051c5d0
    push eax                                     # 0051c5d6
    push dword ptr [ecx + field_1c]              # 0051c5d7
    call dword ptr [0x52a4c8]                    # 0051c5da
    cmp esi, 0x132                               # 0051c5e0
    jb.d8 L_0051c5f4                             # 0051c5e6
    # block 0x0051c5e8: entered by fall-through of jb at 0x0051c5e6, 2 instruction(s), ends with ja to 0x0051c5f4 (forward)
    cmp esi, 0x138                               # 0051c5e8
    ja.d8 L_0051c5f4                             # 0051c5ee
    # block 0x0051c5f0: entered by fall-through of ja at 0x0051c5ee, 2 instruction(s), ends with je to 0x0051c613 (forward)
    test eax, eax                                # 0051c5f0
    je.d8 L_0051c613                             # 0051c5f2
L_0051c5f4:
    # block 0x0051c5f4: entered by jb at 0x0051c5e6; ja at 0x0051c5ee; fall-through of je at 0x0051c5f2, 3 instruction(s), ends with je to 0x0051c5fd (forward)
    mov ecx, dword ptr [ebp + arg_14]            # 0051c5f4
    test ecx, ecx                                # 0051c5f7
    je.d8 L_0051c5fd                             # 0051c5f9
    # block 0x0051c5fb: entered by fall-through of je at 0x0051c5f9, 1 instruction(s), falls into the block at 0x0051c5fd
    mov dword ptr [ecx], eax                     # 0051c5fb
L_0051c5fd:
    # block 0x0051c5fd: entered by je at 0x0051c5f9, 3 instruction(s), ends with forward jump to 0x0051c613
    push 0x1                                     # 0051c5fd
    pop eax                                      # 0051c5ff
    jmp.d8 L_0051c613                            # 0051c600
L_0051c602:
    # block 0x0051c602: entered by je at 0x0051c5c5, 5 instruction(s), calls FUN_0051c618, falls into the block at 0x0051c613
    push dword ptr [ebp + arg_14]                # 0051c602
    push dword ptr [ebp + arg_10]                # 0051c605
    push dword ptr [ebp + arg_c]                 # 0051c608
    push dword ptr [ebp + arg_8]                 # 0051c60b
    call FUN_0051c618                            # 0051c60e
L_0051c613:
    # block 0x0051c613: entered by je at 0x0051c5f2; jmp at 0x0051c600, 3 instruction(s), ends with ret 0x10
    pop esi                                      # 0051c613
    pop ebp                                      # 0051c614
    ret 0x10                                     # 0051c615

