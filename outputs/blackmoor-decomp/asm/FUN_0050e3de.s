# FUN_0050e3de
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050e3de
# extent:       0x0050e3de-0x0050e493 (181 code bytes)
# span:         0x0050e3de-0x0050e493 (code 181, tables 0, padding 0)
# sha256:       171fceb389d0edd4f5edce524d48f9837b18c012683a79d3f0c4022b82fbeb14
# evidence:     ev_4431af068a3f4ca776e521e2b82a00887220c1221c914635cfd4305c8866eb9e
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050e3de
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_e; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_005146dc, FUN_005145a4, FUN_00513e60, FUN_00513dac
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 82 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_e, 0xe  # offset +0xe

# --- external targets -----------------------------------------------
.set FUN_00513dac, .text + (0x00513dac - 0x401000)
.set FUN_00513e60, .text + (0x00513e60 - 0x401000)
.set FUN_005145a4, .text + (0x005145a4 - 0x401000)
.set FUN_005146dc, .text + (0x005146dc - 0x401000)

.org 0x0050e3de - 0x401000
.globl FUN_0050e3de
FUN_0050e3de:
    # block 0x0050e3de: entry, 17 instruction(s), calls FUN_005146dc, ends with jne to 0x0050e472 (forward)
    push ebp                                     # 0050e3de
    {load} mov ebp, esp                          # 0050e3df
    push ecx                                     # 0050e3e1
    push ecx                                     # 0050e3e2
    push esi                                     # 0050e3e3
    mov esi, 0xffff                              # 0050e3e4
    push edi                                     # 0050e3e9
    push esi                                     # 0050e3ea
    push 0x133f                                  # 0050e3eb
    call FUN_005146dc                            # 0050e3f0
    {load} mov edi, eax                          # 0050e3f5
    mov eax, dword ptr [ebp + arg_e]             # 0050e3f7
    .insn 0x66, 0x25, 0x7ff0{:u16}               # 0050e3fa
    pop ecx                                      # 0050e3fe
    .insn 0x66, 0x3d, 0x7ff0{:u16}               # 0050e3ff
    pop ecx                                      # 0050e403
    jne.d8 L_0050e472                            # 0050e404
    # block 0x0050e406: entered by fall-through of jne at 0x0050e404, 9 instruction(s), calls FUN_005145a4, ends with je to 0x0050e464 (forward)
    fld qword ptr [ebp + arg_8]                  # 0050e406
    push ecx                                     # 0050e409
    push ecx                                     # 0050e40a
    fstp qword ptr [esp]                         # 0050e40b
    call FUN_005145a4                            # 0050e40e
    pop ecx                                      # 0050e413
    dec eax                                      # 0050e414
    pop ecx                                      # 0050e415
    je.d8 L_0050e464                             # 0050e416
    # block 0x0050e418: entered by fall-through of je at 0x0050e416, 2 instruction(s), ends with je to 0x0050e454 (forward)
    dec eax                                      # 0050e418
    je.d8 L_0050e454                             # 0050e419
    # block 0x0050e41b: entered by fall-through of je at 0x0050e419, 4 instruction(s), ends with je to 0x0050e443 (forward)
    fld qword ptr [ebp + arg_8]                  # 0050e41b
    dec eax                                      # 0050e41e
    push edi                                     # 0050e41f
    je.d8 L_0050e443                             # 0050e420
    # block 0x0050e422: entered by fall-through of je at 0x0050e420, 13 instruction(s), calls FUN_00513e60, ends with forward jump to 0x0050e48f
    fadd qword ptr [0x52c598]                    # 0050e422
    push ecx                                     # 0050e428
    push ecx                                     # 0050e429
    fstp qword ptr [esp]                         # 0050e42a
    fld qword ptr [ebp + arg_8]                  # 0050e42d
    push ecx                                     # 0050e430
    push ecx                                     # 0050e431
    fstp qword ptr [esp]                         # 0050e432
    push 0x15                                    # 0050e435
    push 0x8                                     # 0050e437
    call FUN_00513e60                            # 0050e439
    add esp, 0x1c                                # 0050e43e
    jmp.d8 L_0050e48f                            # 0050e441
L_0050e443:
    # block 0x0050e443: entered by je at 0x0050e420, 7 instruction(s), calls FUN_00513dac, ends with forward jump to 0x0050e48f
    push ecx                                     # 0050e443
    push ecx                                     # 0050e444
    fstp qword ptr [esp]                         # 0050e445
    push 0x15                                    # 0050e448
    call FUN_00513dac                            # 0050e44a
    add esp, 0x10                                # 0050e44f
    jmp.d8 L_0050e48f                            # 0050e452
L_0050e454:
    # block 0x0050e454: entered by je at 0x0050e419, 8 instruction(s), calls FUN_005146dc, ends with forward jump to 0x0050e48f
    push esi                                     # 0050e454
    push edi                                     # 0050e455
    call FUN_005146dc                            # 0050e456
    fld qword ptr [ebp + arg_8]                  # 0050e45b
    pop ecx                                      # 0050e45e
    fchs                                         # 0050e45f
    pop ecx                                      # 0050e461
    jmp.d8 L_0050e48f                            # 0050e462
L_0050e464:
    # block 0x0050e464: entered by je at 0x0050e416, 7 instruction(s), calls FUN_005146dc, ends with forward jump to 0x0050e48f
    push esi                                     # 0050e464
    push edi                                     # 0050e465
    call FUN_005146dc                            # 0050e466
    fld qword ptr [ebp + arg_8]                  # 0050e46b
    pop ecx                                      # 0050e46e
    pop ecx                                      # 0050e46f
    jmp.d8 L_0050e48f                            # 0050e470
L_0050e472:
    # block 0x0050e472: entered by jne at 0x0050e404, 11 instruction(s), calls FUN_005146dc, falls into the block at 0x0050e48f
    mov eax, dword ptr [ebp + arg_c]             # 0050e472
    push esi                                     # 0050e475
    and eax, 0x7fffffff                          # 0050e476
    push edi                                     # 0050e47b
    mov dword ptr [ebp - local_4], eax           # 0050e47c
    mov eax, dword ptr [ebp + arg_8]             # 0050e47f
    mov dword ptr [ebp - local_8], eax           # 0050e482
    call FUN_005146dc                            # 0050e485
    fld qword ptr [ebp - local_8]                # 0050e48a
    pop ecx                                      # 0050e48d
    pop ecx                                      # 0050e48e
L_0050e48f:
    # block 0x0050e48f: entered by jmp at 0x0050e441; jmp at 0x0050e452; jmp at 0x0050e462; jmp at 0x0050e470, 4 instruction(s), ends with ret
    pop edi                                      # 0050e48f
    pop esi                                      # 0050e490
    leave                                        # 0050e491
    ret                                          # 0050e492

