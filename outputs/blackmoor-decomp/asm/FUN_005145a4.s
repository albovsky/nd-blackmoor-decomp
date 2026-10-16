# FUN_005145a4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005145a4
# extent:       0x005145a4-0x005145fe (90 code bytes)
# span:         0x005145a4-0x005145fe (code 90, tables 0, padding 0)
# sha256:       099782e54ee520becf9246bf30e07a85079d97aa3a8b96f62587347469fe0e6d
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005145a4
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_e; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 35 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_e, 0xe  # offset +0xe

# --- external targets -----------------------------------------------

.org 0x005145a4 - 0x401000
.globl FUN_005145a4
FUN_005145a4:
    # block 0x005145a4: entry, 5 instruction(s), ends with jne to 0x005145bb (forward)
    push ebp                                     # 005145a4
    {load} mov ebp, esp                          # 005145a5
    {load} xor edx, edx                          # 005145a7
    cmp dword ptr [ebp + arg_c], 0x7ff00000      # 005145a9
    jne.d8 L_005145bb                            # 005145b0
    # block 0x005145b2: entered by fall-through of jne at 0x005145b0, 2 instruction(s), ends with jne to 0x005145cd (forward)
    cmp dword ptr [ebp + arg_8], edx             # 005145b2
    jne.d8 L_005145cd                            # 005145b5
    # block 0x005145b7: entered by fall-through of jne at 0x005145b5, 2 instruction(s), ends with forward jump to 0x005145f7
    push 0x1                                     # 005145b7
    jmp.d8 L_005145f7                            # 005145b9
L_005145bb:
    # block 0x005145bb: entered by jne at 0x005145b0, 2 instruction(s), ends with jne to 0x005145cd (forward)
    cmp dword ptr [ebp + arg_c], 0xfff00000      # 005145bb
    jne.d8 L_005145cd                            # 005145c2
    # block 0x005145c4: entered by fall-through of jne at 0x005145c2, 2 instruction(s), ends with jne to 0x005145cd (forward)
    cmp dword ptr [ebp + arg_8], edx             # 005145c4
    jne.d8 L_005145cd                            # 005145c7
    # block 0x005145c9: entered by fall-through of jne at 0x005145c7, 2 instruction(s), ends with forward jump to 0x005145f7
    push 0x2                                     # 005145c9
    jmp.d8 L_005145f7                            # 005145cb
L_005145cd:
    # block 0x005145cd: entered by jne at 0x005145b5; jne at 0x005145c2; jne at 0x005145c7, 5 instruction(s), ends with jne to 0x005145e0 (forward)
    mov ecx, dword ptr [ebp + arg_e]             # 005145cd
    mov eax, 0x7ff8                              # 005145d0
    {load} and ecx, eax                          # 005145d5
    {load} cmp cx, ax                            # 005145d7
    jne.d8 L_005145e0                            # 005145da
    # block 0x005145dc: entered by fall-through of jne at 0x005145da, 2 instruction(s), ends with forward jump to 0x005145f7
    push 0x3                                     # 005145dc
    jmp.d8 L_005145f7                            # 005145de
L_005145e0:
    # block 0x005145e0: entered by jne at 0x005145da, 2 instruction(s), ends with jne to 0x005145fa (forward)
    .insn 0x6681/7, ecx, 32752{:s16}             # 005145e0
    jne.d8 L_005145fa                            # 005145e5
    # block 0x005145e7: entered by fall-through of jne at 0x005145e5, 2 instruction(s), ends with jne to 0x005145f5 (forward)
    test dword ptr [ebp + arg_c], 0x7ffff        # 005145e7
    jne.d8 L_005145f5                            # 005145ee
    # block 0x005145f0: entered by fall-through of jne at 0x005145ee, 2 instruction(s), ends with je to 0x005145fa (forward)
    cmp dword ptr [ebp + arg_8], edx             # 005145f0
    je.d8 L_005145fa                             # 005145f3
L_005145f5:
    # block 0x005145f5: entered by jne at 0x005145ee; fall-through of je at 0x005145f3, 1 instruction(s), falls into the block at 0x005145f7
    push 0x4                                     # 005145f5
L_005145f7:
    # block 0x005145f7: entered by jmp at 0x005145b9; jmp at 0x005145cb; jmp at 0x005145de, 3 instruction(s), ends with ret
    pop eax                                      # 005145f7
    pop ebp                                      # 005145f8
    ret                                          # 005145f9
L_005145fa:
    # block 0x005145fa: entered by jne at 0x005145e5; je at 0x005145f3, 3 instruction(s), ends with ret
    {load} xor eax, eax                          # 005145fa
    pop ebp                                      # 005145fc
    ret                                          # 005145fd

