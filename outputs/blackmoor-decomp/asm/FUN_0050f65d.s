# FUN_0050f65d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050f65d
# extent:       0x0050f65d-0x0050f70d (176 code bytes)
# span:         0x0050f65d-0x0050f710 (code 176, tables 0, padding 3)
# sha256:       f32ca915dbe638e31f51802d5f83778d3c718d597e159196a3802a7572442eca
# evidence:     ev_4431af068a3f4ca776e521e2b82a00887220c1221c914635cfd4305c8866eb9e
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050f65d
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_e, arg_10; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_005146dc, FUN_005145a4, FUN_00513dac, FUN_00513e60, FUN_005145fe
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 73 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_e, 0xe  # offset +0xe
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_00513dac, .text + (0x00513dac - 0x401000)
.set FUN_00513e60, .text + (0x00513e60 - 0x401000)
.set FUN_005145a4, .text + (0x005145a4 - 0x401000)
.set FUN_005145fe, .text + (0x005145fe - 0x401000)
.set FUN_005146dc, .text + (0x005146dc - 0x401000)

.org 0x0050f65d - 0x401000
.globl FUN_0050f65d
FUN_0050f65d:
    # block 0x0050f65d: entry, 15 instruction(s), calls FUN_005146dc, ends with jne to 0x0050f6e9 (forward)
    push ebp                                     # 0050f65d
    {load} mov ebp, esp                          # 0050f65e
    push esi                                     # 0050f660
    mov esi, 0xffff                              # 0050f661
    push edi                                     # 0050f666
    push esi                                     # 0050f667
    push 0x133f                                  # 0050f668
    call FUN_005146dc                            # 0050f66d
    {load} mov edi, eax                          # 0050f672
    mov eax, dword ptr [ebp + arg_e]             # 0050f674
    .insn 0x66, 0x25, 0x7ff0{:u16}               # 0050f677
    pop ecx                                      # 0050f67b
    .insn 0x66, 0x3d, 0x7ff0{:u16}               # 0050f67c
    pop ecx                                      # 0050f680
    jne.d8 L_0050f6e9                            # 0050f681
    # block 0x0050f683: entered by fall-through of jne at 0x0050f681, 11 instruction(s), calls FUN_005145a4, ends with jle to 0x0050f6c4 (forward)
    mov eax, dword ptr [ebp + arg_10]            # 0050f683
    push ecx                                     # 0050f686
    fld qword ptr [ebp + arg_8]                  # 0050f687
    or dword ptr [eax], -0x1                     # 0050f68a
    push ecx                                     # 0050f68d
    fstp qword ptr [esp]                         # 0050f68e
    call FUN_005145a4                            # 0050f691
    pop ecx                                      # 0050f696
    test eax, eax                                # 0050f697
    pop ecx                                      # 0050f699
    jle.d8 L_0050f6c4                            # 0050f69a
    # block 0x0050f69c: entered by fall-through of jle at 0x0050f69a, 2 instruction(s), ends with jle to 0x0050f6bb (forward)
    cmp eax, 0x2                                 # 0050f69c
    jle.d8 L_0050f6bb                            # 0050f69f
    # block 0x0050f6a1: entered by fall-through of jle at 0x0050f69f, 2 instruction(s), ends with jne to 0x0050f6c4 (forward)
    cmp eax, 0x3                                 # 0050f6a1
    jne.d8 L_0050f6c4                            # 0050f6a4
    # block 0x0050f6a6: entered by fall-through of jne at 0x0050f6a4, 9 instruction(s), calls FUN_00513dac, ends with forward jump to 0x0050f709
    fld qword ptr [ebp + arg_8]                  # 0050f6a6
    push edi                                     # 0050f6a9
    push ecx                                     # 0050f6aa
    push ecx                                     # 0050f6ab
    fstp qword ptr [esp]                         # 0050f6ac
    push 0x17                                    # 0050f6af
    call FUN_00513dac                            # 0050f6b1
    add esp, 0x10                                # 0050f6b6
    jmp.d8 L_0050f709                            # 0050f6b9
L_0050f6bb:
    # block 0x0050f6bb: entered by jle at 0x0050f69f, 3 instruction(s), ends with forward jump to 0x0050f6ce
    fld qword ptr [0x568a20]                     # 0050f6bb
    push edi                                     # 0050f6c1
    jmp.d8 L_0050f6ce                            # 0050f6c2
L_0050f6c4:
    # block 0x0050f6c4: entered by jle at 0x0050f69a; jne at 0x0050f6a4, 3 instruction(s), falls into the block at 0x0050f6ce
    fld qword ptr [ebp + arg_8]                  # 0050f6c4
    fadd qword ptr [0x52c598]                    # 0050f6c7
    push edi                                     # 0050f6cd
L_0050f6ce:
    # block 0x0050f6ce: entered by jmp at 0x0050f6c2, 12 instruction(s), calls FUN_00513e60, ends with forward jump to 0x0050f709
    push ecx                                     # 0050f6ce
    push ecx                                     # 0050f6cf
    fstp qword ptr [esp]                         # 0050f6d0
    fld qword ptr [ebp + arg_8]                  # 0050f6d3
    push ecx                                     # 0050f6d6
    push ecx                                     # 0050f6d7
    fstp qword ptr [esp]                         # 0050f6d8
    push 0x17                                    # 0050f6db
    push 0x8                                     # 0050f6dd
    call FUN_00513e60                            # 0050f6df
    add esp, 0x1c                                # 0050f6e4
    jmp.d8 L_0050f709                            # 0050f6e7
L_0050f6e9:
    # block 0x0050f6e9: entered by jne at 0x0050f681, 12 instruction(s), calls FUN_005145fe, FUN_005146dc, falls into the block at 0x0050f709
    push dword ptr [ebp + arg_10]                # 0050f6e9
    fld qword ptr [ebp + arg_8]                  # 0050f6ec
    push ecx                                     # 0050f6ef
    push ecx                                     # 0050f6f0
    fstp qword ptr [esp]                         # 0050f6f1
    call FUN_005145fe                            # 0050f6f4
    fstp qword ptr [ebp + arg_8]                 # 0050f6f9
    push esi                                     # 0050f6fc
    push edi                                     # 0050f6fd
    call FUN_005146dc                            # 0050f6fe
    fld qword ptr [ebp + arg_8]                  # 0050f703
    add esp, 0x14                                # 0050f706
L_0050f709:
    # block 0x0050f709: entered by jmp at 0x0050f6b9; jmp at 0x0050f6e7, 4 instruction(s), ends with ret
    pop edi                                      # 0050f709
    pop esi                                      # 0050f70a
    pop ebp                                      # 0050f70b
    ret                                          # 0050f70c

# --- data items (not part of the function) -------------------------
.org 0x0050f70d - 0x401000
PAD_0050f70d:  # 3 byte(s) of int3 padding
    .fill 3, 1, 0xcc

