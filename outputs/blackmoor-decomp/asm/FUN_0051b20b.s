# FUN_0051b20b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051b20b
# extent:       0x0051b20b-0x0051b257 (76 code bytes)
# span:         0x0051b20b-0x0051b257 (code 76, tables 0, padding 0)
# sha256:       0f69ecb4c8866302b503998039bdf05a4888e368df6c5b87b76aa9e10191fa11
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051b20b
# arguments:    7 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c, arg_20; ret 0x1c (callee pops 28 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_4, field_8, field_c, field_1c
# callees:      calls FUN_0051b125
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 35 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ arg_1c, 0x1c  # offset +0x1c
.equ arg_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_0051b125, .text + (0x0051b125 - 0x401000)

.org 0x0051b20b - 0x401000
.globl FUN_0051b20b
FUN_0051b20b:
    # block 0x0051b20b: entry, 7 instruction(s), ends with jne to 0x0051b21b (forward)
    push ebp                                     # 0051b20b
    {load} mov ebp, esp                          # 0051b20c
    mov eax, dword ptr [ebp + arg_18]            # 0051b20e
    push esi                                     # 0051b211
    test eax, eax                                # 0051b212
    push edi                                     # 0051b214
    jne.d8 L_0051b21b                            # 0051b215
    # block 0x0051b217: entered by fall-through of jne at 0x0051b215, 2 instruction(s), ends with forward jump to 0x0051b21e
    {load} xor edi, edi                          # 0051b217
    jmp.d8 L_0051b21e                            # 0051b219
L_0051b21b:
    # block 0x0051b21b: entered by jne at 0x0051b215, 1 instruction(s), falls into the block at 0x0051b21e
    mov edi, dword ptr [eax + field_1c]          # 0051b21b
L_0051b21e:
    # block 0x0051b21e: entered by jmp at 0x0051b219, 25 instruction(s), calls FUN_0051b125, ends with ret 0x1c
    push dword ptr [ebp + arg_20]                # 0051b21e
    mov eax, dword ptr [ebp + arg_14]            # 0051b221
    push dword ptr [ebp + arg_1c]                # 0051b224
    mov edx, dword ptr [eax + field_4]           # 0051b227
    mov esi, dword ptr [eax]                     # 0051b22a
    push edi                                     # 0051b22c
    mov edi, dword ptr [eax + field_c]           # 0051b22d
    mov eax, dword ptr [eax + field_8]           # 0051b230
    {load} sub edi, edx                          # 0051b233
    {load} sub eax, esi                          # 0051b235
    push edi                                     # 0051b237
    push eax                                     # 0051b238
    mov eax, dword ptr [ebp + arg_10]            # 0051b239
    push edx                                     # 0051b23c
    or eax, 0x40000000                           # 0051b23d
    push esi                                     # 0051b242
    push eax                                     # 0051b243
    push dword ptr [ebp + arg_c]                 # 0051b244
    push dword ptr [ebp + arg_8]                 # 0051b247
    push 0x0                                     # 0051b24a
    call FUN_0051b125                            # 0051b24c
    pop edi                                      # 0051b251
    pop esi                                      # 0051b252
    pop ebp                                      # 0051b253
    ret 0x1c                                     # 0051b254

