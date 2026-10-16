# FUN_0051a82d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a82d
# extent:       0x0051a82d-0x0051a87c (79 code bytes)
# span:         0x0051a82d-0x0051a87c (code 79, tables 0, padding 0)
# sha256:       932c29eab957d6a662eb39d4b3a432b34a9455739e8b20da806547d3743dd4e2
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a82d
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; ret 0x14 (callee pops 20 bytes); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls USER32.dll!GetWindowLongA, USER32.dll!SetWindowLongA, USER32.dll!SetWindowPos
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 34 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------

.org 0x0051a82d - 0x401000
.globl FUN_0051a82d
FUN_0051a82d:
    # block 0x0051a82d: entry, 11 instruction(s), calls USER32.dll!GetWindowLongA, ends with jne to 0x0051a84e (forward)
    push ebp                                     # 0051a82d
    {load} mov ebp, esp                          # 0051a82e
    push dword ptr [ebp + arg_c]                 # 0051a830
    push dword ptr [ebp + arg_8]                 # 0051a833
    call dword ptr [0x52a454]                    # 0051a836
    mov ecx, dword ptr [ebp + arg_10]            # 0051a83c
    not ecx                                      # 0051a83f
    {load} and ecx, eax                          # 0051a841
    or ecx, dword ptr [ebp + arg_14]             # 0051a843
    {load} cmp eax, ecx                          # 0051a846
    jne.d8 L_0051a84e                            # 0051a848
    # block 0x0051a84a: entered by fall-through of jne at 0x0051a848, 2 instruction(s), ends with forward jump to 0x0051a878
    {load} xor eax, eax                          # 0051a84a
    jmp.d8 L_0051a878                            # 0051a84c
L_0051a84e:
    # block 0x0051a84e: entered by jne at 0x0051a848, 8 instruction(s), calls USER32.dll!SetWindowLongA, ends with je to 0x0051a875 (forward)
    push ecx                                     # 0051a84e
    push dword ptr [ebp + arg_c]                 # 0051a84f
    push dword ptr [ebp + arg_8]                 # 0051a852
    call dword ptr [0x52a458]                    # 0051a855
    mov eax, dword ptr [ebp + arg_18]            # 0051a85b
    {load} xor ecx, ecx                          # 0051a85e
    {load} cmp eax, ecx                          # 0051a860
    je.d8 L_0051a875                             # 0051a862
    # block 0x0051a864: entered by fall-through of je at 0x0051a862, 9 instruction(s), calls USER32.dll!SetWindowPos, falls into the block at 0x0051a875
    or al, 0x17                                  # 0051a864
    push eax                                     # 0051a866
    push ecx                                     # 0051a867
    push ecx                                     # 0051a868
    push ecx                                     # 0051a869
    push ecx                                     # 0051a86a
    push ecx                                     # 0051a86b
    push dword ptr [ebp + arg_8]                 # 0051a86c
    call dword ptr [0x52a45c]                    # 0051a86f
L_0051a875:
    # block 0x0051a875: entered by je at 0x0051a862, 2 instruction(s), falls into the block at 0x0051a878
    push 0x1                                     # 0051a875
    pop eax                                      # 0051a877
L_0051a878:
    # block 0x0051a878: entered by jmp at 0x0051a84c, 2 instruction(s), ends with ret 0x14
    pop ebp                                      # 0051a878
    ret 0x14                                     # 0051a879

