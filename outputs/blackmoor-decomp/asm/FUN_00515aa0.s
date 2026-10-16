# FUN_00515aa0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00515aa0
# extent:       0x00515aa0-0x00515b32 (146 code bytes)
# span:         0x00515aa0-0x00515b32 (code 146, tables 0, padding 0)
# sha256:       4948874620de45d11396fe2039f0648d107dec018375e843b7e752e663e40eba
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00515aa0
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_e; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_005145a4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 65 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_e, 0xe  # offset +0xe

# --- external targets -----------------------------------------------
.set FUN_005145a4, .text + (0x005145a4 - 0x401000)

.org 0x00515aa0 - 0x401000
.globl FUN_00515aa0
FUN_00515aa0:
    # block 0x00515aa0: entry, 8 instruction(s), ends with jne to 0x00515ae0 (forward)
    push ebp                                     # 00515aa0
    {load} mov ebp, esp                          # 00515aa1
    mov eax, dword ptr [ebp + arg_e]             # 00515aa3
    mov ecx, 0x7ff0                              # 00515aa6
    {load} mov edx, eax                          # 00515aab
    {load} and edx, ecx                          # 00515aad
    {load} cmp dx, cx                            # 00515aaf
    jne.d8 L_00515ae0                            # 00515ab2
    # block 0x00515ab4: entered by fall-through of jne at 0x00515ab2, 9 instruction(s), calls FUN_005145a4, ends with je to 0x00515ad9 (forward)
    fld qword ptr [ebp + arg_8]                  # 00515ab4
    push ecx                                     # 00515ab7
    push ecx                                     # 00515ab8
    fstp qword ptr [esp]                         # 00515ab9
    call FUN_005145a4                            # 00515abc
    pop ecx                                      # 00515ac1
    dec eax                                      # 00515ac2
    pop ecx                                      # 00515ac3
    je.d8 L_00515ad9                             # 00515ac4
    # block 0x00515ac6: entered by fall-through of je at 0x00515ac4, 2 instruction(s), ends with je to 0x00515ad5 (forward)
    dec eax                                      # 00515ac6
    je.d8 L_00515ad5                             # 00515ac7
    # block 0x00515ac9: entered by fall-through of je at 0x00515ac7, 2 instruction(s), ends with je to 0x00515ad1 (forward)
    dec eax                                      # 00515ac9
    je.d8 L_00515ad1                             # 00515aca
    # block 0x00515acc: entered by fall-through of je at 0x00515aca, 1 instruction(s), falls into the block at 0x00515ace
    push 0x1                                     # 00515acc
L_00515ace:
    # block 0x00515ace: entered by jmp at 0x00515ad3; jmp at 0x00515ad7, 3 instruction(s), ends with ret
    pop eax                                      # 00515ace
    pop ebp                                      # 00515acf
    ret                                          # 00515ad0
L_00515ad1:
    # block 0x00515ad1: entered by je at 0x00515aca, 2 instruction(s), ends with backward jump to 0x00515ace
    push 0x2                                     # 00515ad1
    jmp.d8 L_00515ace                            # 00515ad3
L_00515ad5:
    # block 0x00515ad5: entered by je at 0x00515ac7, 2 instruction(s), ends with backward jump to 0x00515ace
    push 0x4                                     # 00515ad5
    jmp.d8 L_00515ace                            # 00515ad7
L_00515ad9:
    # block 0x00515ad9: entered by je at 0x00515ac4, 3 instruction(s), ends with ret
    mov eax, 0x200                               # 00515ad9
    pop ebp                                      # 00515ade
    ret                                          # 00515adf
L_00515ae0:
    # block 0x00515ae0: entered by jne at 0x00515ab2, 4 instruction(s), ends with jne to 0x00515b0a (forward)
    and eax, 0x8000                              # 00515ae0
    test dx, dx                                  # 00515ae5
    {load} mov ecx, eax                          # 00515ae8
    jne.d8 L_00515b0a                            # 00515aea
    # block 0x00515aec: entered by fall-through of jne at 0x00515aea, 2 instruction(s), ends with jne to 0x00515afb (forward)
    test dword ptr [ebp + arg_c], 0xfffff        # 00515aec
    jne.d8 L_00515afb                            # 00515af3
    # block 0x00515af5: entered by fall-through of jne at 0x00515af3, 2 instruction(s), ends with je to 0x00515b0a (forward)
    cmp dword ptr [ebp + arg_8], 0x0             # 00515af5
    je.d8 L_00515b0a                             # 00515af9
L_00515afb:
    # block 0x00515afb: entered by jne at 0x00515af3; fall-through of je at 0x00515af9, 7 instruction(s), ends with ret
    {load} mov eax, ecx                          # 00515afb
    neg eax                                      # 00515afd
    {load} sbb eax, eax                          # 00515aff
    and al, -0x70                                # 00515b01
    add eax, 0x80                                # 00515b03
    pop ebp                                      # 00515b08
    ret                                          # 00515b09
L_00515b0a:
    # block 0x00515b0a: entered by jne at 0x00515aea; je at 0x00515af9, 6 instruction(s), ends with jne to 0x00515b25 (forward)
    fld qword ptr [ebp + arg_8]                  # 00515b0a
    fcomp qword ptr [0x52c7b0]                   # 00515b0d
    fnstsw ax                                    # 00515b13
    sahf                                         # 00515b15
    {load} mov eax, ecx                          # 00515b16
    jne.d8 L_00515b25                            # 00515b18
    # block 0x00515b1a: entered by fall-through of jne at 0x00515b18, 6 instruction(s), ends with ret
    neg eax                                      # 00515b1a
    {load} sbb eax, eax                          # 00515b1c
    and al, -0x20                                # 00515b1e
    add eax, 0x40                                # 00515b20
    pop ebp                                      # 00515b23
    ret                                          # 00515b24
L_00515b25:
    # block 0x00515b25: entered by jne at 0x00515b18, 6 instruction(s), ends with ret
    neg eax                                      # 00515b25
    {load} sbb eax, eax                          # 00515b27
    and al, 0x8                                  # 00515b29
    add eax, 0x100                               # 00515b2b
    pop ebp                                      # 00515b30
    ret                                          # 00515b31

