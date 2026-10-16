# FUN_0050e30f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050e30f
# extent:       0x0050e30f-0x0050e3de (207 code bytes)
# span:         0x0050e30f-0x0050e3de (code 207, tables 0, padding 0)
# sha256:       5149569416eff525e9971d50d9a6a6b6adbb6778ba30dd9d99337426059c6804
# evidence:     ev_4431af068a3f4ca776e521e2b82a00887220c1221c914635cfd4305c8866eb9e
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050e30f
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_e; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       1 ebp-relative slot(s): local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_005146dc, FUN_005145a4, FUN_00513dac, FUN_00514569, FUN_00513e60
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 94 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_e, 0xe  # offset +0xe

# --- external targets -----------------------------------------------
.set FUN_00513dac, .text + (0x00513dac - 0x401000)
.set FUN_00513e60, .text + (0x00513e60 - 0x401000)
.set FUN_00514569, .text + (0x00514569 - 0x401000)
.set FUN_005145a4, .text + (0x005145a4 - 0x401000)
.set FUN_005146dc, .text + (0x005146dc - 0x401000)

.org 0x0050e30f - 0x401000
.globl FUN_0050e30f
FUN_0050e30f:
    # block 0x0050e30f: entry, 21 instruction(s), calls FUN_005146dc, ends with jne to 0x0050e395 (forward)
    push ebp                                     # 0050e30f
    {load} mov ebp, esp                          # 0050e310
    push ecx                                     # 0050e312
    push ecx                                     # 0050e313
    push ebx                                     # 0050e314
    push esi                                     # 0050e315
    mov esi, 0xffff                              # 0050e316
    push esi                                     # 0050e31b
    push dword ptr [0x567e78]                    # 0050e31c
    call FUN_005146dc                            # 0050e322
    fld qword ptr [ebp + arg_8]                  # 0050e327
    pop ecx                                      # 0050e32a
    {load} mov ebx, eax                          # 0050e32b
    mov eax, dword ptr [ebp + arg_e]             # 0050e32d
    pop ecx                                      # 0050e330
    push ecx                                     # 0050e331
    .insn 0x66, 0x25, 0x7ff0{:u16}               # 0050e332
    push ecx                                     # 0050e336
    .insn 0x66, 0x3d, 0x7ff0{:u16}               # 0050e337
    fstp qword ptr [esp]                         # 0050e33b
    jne.d8 L_0050e395                            # 0050e33e
    # block 0x0050e340: entered by fall-through of jne at 0x0050e33e, 5 instruction(s), calls FUN_005145a4, ends with jle to 0x0050e378 (forward)
    call FUN_005145a4                            # 0050e340
    pop ecx                                      # 0050e345
    test eax, eax                                # 0050e346
    pop ecx                                      # 0050e348
    jle.d8 L_0050e378                            # 0050e349
    # block 0x0050e34b: entered by fall-through of jle at 0x0050e349, 2 instruction(s), ends with jle to 0x0050e36a (forward)
    cmp eax, 0x2                                 # 0050e34b
    jle.d8 L_0050e36a                            # 0050e34e
    # block 0x0050e350: entered by fall-through of jle at 0x0050e34e, 2 instruction(s), ends with jne to 0x0050e378 (forward)
    cmp eax, 0x3                                 # 0050e350
    jne.d8 L_0050e378                            # 0050e353
    # block 0x0050e355: entered by fall-through of jne at 0x0050e353, 9 instruction(s), calls FUN_00513dac, ends with forward jump to 0x0050e3da
    fld qword ptr [ebp + arg_8]                  # 0050e355
    push ebx                                     # 0050e358
    push ecx                                     # 0050e359
    push ecx                                     # 0050e35a
    fstp qword ptr [esp]                         # 0050e35b
    push 0xc                                     # 0050e35e
    call FUN_00513dac                            # 0050e360
    add esp, 0x10                                # 0050e365
    jmp.d8 L_0050e3da                            # 0050e368
L_0050e36a:
    # block 0x0050e36a: entered by jle at 0x0050e34e, 7 instruction(s), calls FUN_005146dc, ends with forward jump to 0x0050e3da
    push esi                                     # 0050e36a
    push ebx                                     # 0050e36b
    call FUN_005146dc                            # 0050e36c
    fld qword ptr [ebp + arg_8]                  # 0050e371
    pop ecx                                      # 0050e374
    pop ecx                                      # 0050e375
    jmp.d8 L_0050e3da                            # 0050e376
L_0050e378:
    # block 0x0050e378: entered by jle at 0x0050e349; jne at 0x0050e353, 13 instruction(s), ends with forward jump to 0x0050e3d2
    fld qword ptr [ebp + arg_8]                  # 0050e378
    fadd qword ptr [0x52c598]                    # 0050e37b
    push ebx                                     # 0050e381
    push ecx                                     # 0050e382
    push ecx                                     # 0050e383
    fstp qword ptr [esp]                         # 0050e384
    fld qword ptr [ebp + arg_8]                  # 0050e387
    push ecx                                     # 0050e38a
    push ecx                                     # 0050e38b
    fstp qword ptr [esp]                         # 0050e38c
    push 0xc                                     # 0050e38f
    push 0x8                                     # 0050e391
    jmp.d8 L_0050e3d2                            # 0050e393
L_0050e395:
    # block 0x0050e395: entered by jne at 0x0050e33e, 9 instruction(s), calls FUN_00514569, ends with jne to 0x0050e3b8 (forward)
    call FUN_00514569                            # 0050e395
    fstp qword ptr [ebp - local_8]               # 0050e39a
    fld qword ptr [ebp - local_8]                # 0050e39d
    fcomp qword ptr [ebp + arg_8]                # 0050e3a0
    pop ecx                                      # 0050e3a3
    pop ecx                                      # 0050e3a4
    fnstsw ax                                    # 0050e3a5
    sahf                                         # 0050e3a7
    jne.d8 L_0050e3b8                            # 0050e3a8
L_0050e3aa:
    # block 0x0050e3aa: entered by jne at 0x0050e3bb; fall-through of jne at 0x0050e3a8, 7 instruction(s), calls FUN_005146dc, ends with forward jump to 0x0050e3da
    push esi                                     # 0050e3aa
    push ebx                                     # 0050e3ab
    call FUN_005146dc                            # 0050e3ac
    fld qword ptr [ebp - local_8]                # 0050e3b1
    pop ecx                                      # 0050e3b4
    pop ecx                                      # 0050e3b5
    jmp.d8 L_0050e3da                            # 0050e3b6
L_0050e3b8:
    # block 0x0050e3b8: entered by jne at 0x0050e3a8, 2 instruction(s), ends with jne to 0x0050e3aa (backward)
    test bl, 0x20                                # 0050e3b8
    jne.d8 L_0050e3aa                            # 0050e3bb
    # block 0x0050e3bd: entered by fall-through of jne at 0x0050e3bb, 11 instruction(s), falls into the block at 0x0050e3d2
    fld qword ptr [ebp - local_8]                # 0050e3bd
    push ebx                                     # 0050e3c0
    push ecx                                     # 0050e3c1
    push ecx                                     # 0050e3c2
    fstp qword ptr [esp]                         # 0050e3c3
    fld qword ptr [ebp + arg_8]                  # 0050e3c6
    push ecx                                     # 0050e3c9
    push ecx                                     # 0050e3ca
    fstp qword ptr [esp]                         # 0050e3cb
    push 0xc                                     # 0050e3ce
    push 0x10                                    # 0050e3d0
L_0050e3d2:
    # block 0x0050e3d2: entered by jmp at 0x0050e393, 2 instruction(s), calls FUN_00513e60, falls into the block at 0x0050e3da
    call FUN_00513e60                            # 0050e3d2
    add esp, 0x1c                                # 0050e3d7
L_0050e3da:
    # block 0x0050e3da: entered by jmp at 0x0050e368; jmp at 0x0050e376; jmp at 0x0050e3b6, 4 instruction(s), ends with ret
    pop esi                                      # 0050e3da
    pop ebx                                      # 0050e3db
    leave                                        # 0050e3dc
    ret                                          # 0050e3dd

