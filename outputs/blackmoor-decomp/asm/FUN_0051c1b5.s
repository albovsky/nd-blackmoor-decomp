# FUN_0051c1b5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051c1b5
# extent:       0x0051c1b5-0x0051c22e (121 code bytes)
# span:         0x0051c1b5-0x0051c22e (code 121, tables 0, padding 0)
# sha256:       c05c0a2ea025e60fe3b429326b6eb069df7754a79cf5911d5f71c6010d915ba4
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051c1b5
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls USER32.dll!GetDlgItem, FUN_0051c1b5, FUN_0051abe4, FUN_0051ac0b, USER32.dll!GetWindow; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 49 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0051abe4, .text + (0x0051abe4 - 0x401000)
.set FUN_0051ac0b, .text + (0x0051ac0b - 0x401000)

.org 0x0051c1b5 - 0x401000
.globl FUN_0051c1b5
FUN_0051c1b5:
L_0051c1b5:
    # block 0x0051c1b5: entry, 11 instruction(s), calls USER32.dll!GetDlgItem, ends with je to 0x0051c200 (forward)
    push ebp                                     # 0051c1b5
    {load} mov ebp, esp                          # 0051c1b6
    push esi                                     # 0051c1b8
    push edi                                     # 0051c1b9
    push dword ptr [ebp + arg_c]                 # 0051c1ba
    push dword ptr [ebp + arg_8]                 # 0051c1bd
    call dword ptr [0x52a404]                    # 0051c1c0
    mov edi, dword ptr [0x52a3d4]                # 0051c1c6
    {load} mov esi, eax                          # 0051c1cc
    test esi, esi                                # 0051c1ce
    je.d8 L_0051c200                             # 0051c1d0
    # block 0x0051c1d2: entered by fall-through of je at 0x0051c1d0, 4 instruction(s), calls indirect edi, ends with je to 0x0051c1e9 (forward)
    push esi                                     # 0051c1d2
    call edi                                     # 0051c1d3
    test eax, eax                                # 0051c1d5
    je.d8 L_0051c1e9                             # 0051c1d7
    # block 0x0051c1d9: entered by fall-through of je at 0x0051c1d7, 6 instruction(s), calls FUN_0051c1b5, ends with jne to 0x0051c228 (forward)
    push dword ptr [ebp + arg_10]                # 0051c1d9
    push dword ptr [ebp + arg_c]                 # 0051c1dc
    push esi                                     # 0051c1df
    call L_0051c1b5                              # 0051c1e0
    test eax, eax                                # 0051c1e5
    jne.d8 L_0051c228                            # 0051c1e7
L_0051c1e9:
    # block 0x0051c1e9: entered by je at 0x0051c1d7; fall-through of jne at 0x0051c1e7, 3 instruction(s), ends with jne to 0x0051c1f7 (forward)
    cmp dword ptr [ebp + arg_10], 0x0            # 0051c1e9
    push esi                                     # 0051c1ed
    jne.d8 L_0051c1f7                            # 0051c1ee
    # block 0x0051c1f0: entered by fall-through of jne at 0x0051c1ee, 2 instruction(s), calls FUN_0051abe4, ends with forward jump to 0x0051c228
    call FUN_0051abe4                            # 0051c1f0
    jmp.d8 L_0051c228                            # 0051c1f5
L_0051c1f7:
    # block 0x0051c1f7: entered by jne at 0x0051c1ee, 3 instruction(s), calls FUN_0051ac0b, ends with jne to 0x0051c228 (forward)
    call FUN_0051ac0b                            # 0051c1f7
    test eax, eax                                # 0051c1fc
    jne.d8 L_0051c228                            # 0051c1fe
L_0051c200:
    # block 0x0051c200: entered by je at 0x0051c1d0; fall-through of jne at 0x0051c1fe, 2 instruction(s), calls indirect edi, falls into the block at 0x0051c205
    push dword ptr [ebp + arg_8]                 # 0051c200
    call edi                                     # 0051c203
L_0051c205:
    # block 0x0051c205: entered by jmp at 0x0051c224, 3 instruction(s), ends with je to 0x0051c226 (forward)
    {load} mov esi, eax                          # 0051c205
    test esi, esi                                # 0051c207
    je.d8 L_0051c226                             # 0051c209
    # block 0x0051c20b: entered by fall-through of je at 0x0051c209, 6 instruction(s), calls FUN_0051c1b5, ends with jne to 0x0051c228 (forward)
    push dword ptr [ebp + arg_10]                # 0051c20b
    push dword ptr [ebp + arg_c]                 # 0051c20e
    push esi                                     # 0051c211
    call L_0051c1b5                              # 0051c212
    test eax, eax                                # 0051c217
    jne.d8 L_0051c228                            # 0051c219
    # block 0x0051c21b: entered by fall-through of jne at 0x0051c219, 4 instruction(s), calls USER32.dll!GetWindow, ends with backward jump to 0x0051c205
    push 0x2                                     # 0051c21b
    push esi                                     # 0051c21d
    call dword ptr [0x52a450]                    # 0051c21e
    jmp.d8 L_0051c205                            # 0051c224
L_0051c226:
    # block 0x0051c226: entered by je at 0x0051c209, 1 instruction(s), falls into the block at 0x0051c228
    {load} xor eax, eax                          # 0051c226
L_0051c228:
    # block 0x0051c228: entered by jne at 0x0051c1e7; jmp at 0x0051c1f5; jne at 0x0051c1fe; jne at 0x0051c219, 4 instruction(s), ends with ret 0xc
    pop edi                                      # 0051c228
    pop esi                                      # 0051c229
    pop ebp                                      # 0051c22a
    ret 0xc                                      # 0051c22b

