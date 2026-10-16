# FUN_0052094d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052094d
# extent:       0x0052094d-0x005209a3 (86 code bytes)
# span:         0x0052094d-0x005209a3 (code 86, tables 0, padding 0)
# sha256:       38a49908a009fb7bdb612e2411083b00993310245690a27b3d279f10d4d29298
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052094d
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is not read in the entry block before being written
# locals:       1 ebp-relative slot(s): local_104
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00519a42, FUN_0052658e, KERNEL32.dll!lstrlenA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 33 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_104, 0x104  # offset -0x104
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_00519a42, .text + (0x00519a42 - 0x401000)
.set FUN_0052658e, .text + (0x0052658e - 0x401000)

.org 0x0052094d - 0x401000
.globl FUN_0052094d
FUN_0052094d:
    # block 0x0052094d: entry, 9 instruction(s), ends with jne to 0x0052096e (forward)
    push ebp                                     # 0052094d
    {load} mov ebp, esp                          # 0052094e
    sub esp, 0x104                               # 00520950
    push esi                                     # 00520956
    push edi                                     # 00520957
    mov edi, dword ptr [ebp + arg_c]             # 00520958
    test edi, edi                                # 0052095b
    {load} mov esi, edi                          # 0052095d
    jne.d8 L_0052096e                            # 0052095f
    # block 0x00520961: entered by fall-through of jne at 0x0052095f, 2 instruction(s), falls into the block at 0x0052096e
    lea esi, [ebp - local_104]                   # 00520961
    mov dword ptr [ebp + arg_10], 0x104          # 00520967
L_0052096e:
    # block 0x0052096e: entered by jne at 0x0052095f, 6 instruction(s), calls FUN_00519a42, ends with je to 0x0052098d (forward)
    push dword ptr [ebp + arg_10]                # 0052096e
    push esi                                     # 00520971
    push dword ptr [ebp + arg_8]                 # 00520972
    call FUN_00519a42                            # 00520975
    test ax, ax                                  # 0052097a
    je.d8 L_0052098d                             # 0052097d
    # block 0x0052097f: entered by fall-through of je at 0x0052097d, 5 instruction(s), calls FUN_0052658e, ends with forward jump to 0x0052099d
    push dword ptr [ebp + arg_10]                # 0052097f
    push edi                                     # 00520982
    push dword ptr [ebp + arg_8]                 # 00520983
    call FUN_0052658e                            # 00520986
    jmp.d8 L_0052099d                            # 0052098b
L_0052098d:
    # block 0x0052098d: entered by je at 0x0052097d, 2 instruction(s), ends with jne to 0x0052099b (forward)
    test edi, edi                                # 0052098d
    jne.d8 L_0052099b                            # 0052098f
    # block 0x00520991: entered by fall-through of jne at 0x0052098f, 4 instruction(s), calls KERNEL32.dll!lstrlenA, ends with forward jump to 0x0052099d
    push esi                                     # 00520991
    call dword ptr [0x52a1f8]                    # 00520992
    inc eax                                      # 00520998
    jmp.d8 L_0052099d                            # 00520999
L_0052099b:
    # block 0x0052099b: entered by jne at 0x0052098f, 1 instruction(s), falls into the block at 0x0052099d
    {load} xor eax, eax                          # 0052099b
L_0052099d:
    # block 0x0052099d: entered by jmp at 0x0052098b; jmp at 0x00520999, 4 instruction(s), ends with ret 0xc
    pop edi                                      # 0052099d
    pop esi                                      # 0052099e
    leave                                        # 0052099f
    ret 0xc                                      # 005209a0

