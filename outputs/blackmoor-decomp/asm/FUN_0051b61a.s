# FUN_0051b61a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051b61a
# extent:       0x0051b61a-0x0051b645 (43 code bytes)
# span:         0x0051b61a-0x0051b645 (code 43, tables 0, padding 0)
# sha256:       12637df7ddbf8049631345def295c17c0e4588e0b85f1a3477eab48e3c44c2a0
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051b61a
# arguments:    1 ebp-relative stack slot(s) referenced: arg_c; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051c4ec, FUN_0051ab4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 19 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0051b645
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)
.set FUN_0051c4ec, .text + (0x0051c4ec - 0x401000)

.org 0x0051b61a - 0x401000
.globl FUN_0051b61a
FUN_0051b61a:
    # block 0x0051b61a: entry, 7 instruction(s), ends with je to 0x0051b639 (forward)
    push ebp                                     # 0051b61a
    {load} mov ebp, esp                          # 0051b61b
    push esi                                     # 0051b61d
    {load} mov esi, ecx                          # 0051b61e
    mov ecx, dword ptr [ebp + arg_c]             # 0051b620
    test ecx, ecx                                # 0051b623
    je.d8 L_0051b639                             # 0051b625
    # block 0x0051b627: entered by fall-through of je at 0x0051b625, 5 instruction(s), calls FUN_0051c4ec, ends with je to 0x0051b639 (forward)
    lea eax, [ebp + arg_c]                       # 0051b627
    push eax                                     # 0051b62a
    call FUN_0051c4ec                            # 0051b62b
    test eax, eax                                # 0051b630
    je.d8 L_0051b639                             # 0051b632
    # block 0x0051b634: entered by fall-through of je at 0x0051b632, 2 instruction(s), ends with forward jump to 0x0051b640
    mov eax, dword ptr [ebp + arg_c]             # 0051b634
    jmp.d8 L_0051b640                            # 0051b637
L_0051b639:
    # block 0x0051b639: entered by je at 0x0051b625; je at 0x0051b632, 2 instruction(s), calls FUN_0051ab4b, falls into the block at 0x0051b640
    {load} mov ecx, esi                          # 0051b639
    call FUN_0051ab4b                            # 0051b63b
L_0051b640:
    # block 0x0051b640: entered by jmp at 0x0051b637, 3 instruction(s), ends with ret 0xc
    pop esi                                      # 0051b640
    pop ebp                                      # 0051b641
    ret 0xc                                      # 0051b642

