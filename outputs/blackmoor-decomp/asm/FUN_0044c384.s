# FUN_0044c384
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044c384
# extent:       0x0044c384-0x0044c44c (200 code bytes)
# span:         0x0044c384-0x0044c44c (code 200, tables 0, padding 0)
# sha256:       edc601e6ad98f1c8ccbcbba181d39cd365bfb32fe3503cc6e4f84be601aadee1
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044c384
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004c2dfb, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 49 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)

.org 0x0044c384 - 0x401000
.globl FUN_0044c384
FUN_0044c384:
    # block 0x0044c384: entry, 11 instruction(s), calls FUN_004c2dfb, ends with je to 0x0044c3bd (forward)
    push ebp                                     # 0044c384
    {load} mov ebp, esp                          # 0044c385
    push 0x5d03c7                                # 0044c387
    mov ecx, 0x5cf659                            # 0044c38c
    call FUN_004c2dfb                            # 0044c391
    push 0x5d03cb                                # 0044c396
    mov ecx, 0x5cf659                            # 0044c39b
    call FUN_004c2dfb                            # 0044c3a0
    movsx eax, word ptr [0x63a4cd]               # 0044c3a5
    test eax, eax                                # 0044c3ac
    je.d8 L_0044c3bd                             # 0044c3ae
    # block 0x0044c3b0: entered by fall-through of je at 0x0044c3ae, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0044c3bd
    push 0x54922c                                # 0044c3b0
    call FUN_0044a2b7                            # 0044c3b5
    add esp, 0x4                                 # 0044c3ba
L_0044c3bd:
    # block 0x0044c3bd: entered by je at 0x0044c3ae, 6 instruction(s), calls FUN_004c2dfb, ends with je to 0x0044c3e4 (forward)
    push 0x5d03bf                                # 0044c3bd
    mov ecx, 0x5cf659                            # 0044c3c2
    call FUN_004c2dfb                            # 0044c3c7
    movsx ecx, word ptr [0x63a4cd]               # 0044c3cc
    test ecx, ecx                                # 0044c3d3
    je.d8 L_0044c3e4                             # 0044c3d5
    # block 0x0044c3d7: entered by fall-through of je at 0x0044c3d5, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0044c3e4
    push 0x54927c                                # 0044c3d7
    call FUN_0044a2b7                            # 0044c3dc
    add esp, 0x4                                 # 0044c3e1
L_0044c3e4:
    # block 0x0044c3e4: entered by je at 0x0044c3d5, 6 instruction(s), calls FUN_004c2dfb, ends with je to 0x0044c40b (forward)
    push 0x5d03c3                                # 0044c3e4
    mov ecx, 0x5cf659                            # 0044c3e9
    call FUN_004c2dfb                            # 0044c3ee
    movsx edx, word ptr [0x63a4cd]               # 0044c3f3
    test edx, edx                                # 0044c3fa
    je.d8 L_0044c40b                             # 0044c3fc
    # block 0x0044c3fe: entered by fall-through of je at 0x0044c3fc, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0044c40b
    push 0x5492cc                                # 0044c3fe
    call FUN_0044a2b7                            # 0044c403
    add esp, 0x4                                 # 0044c408
L_0044c40b:
    # block 0x0044c40b: entered by je at 0x0044c3fc, 6 instruction(s), calls FUN_004c2dfb, ends with je to 0x0044c432 (forward)
    push 0x6381f1                                # 0044c40b
    mov ecx, 0x5cf659                            # 0044c410
    call FUN_004c2dfb                            # 0044c415
    movsx eax, word ptr [0x63a4cd]               # 0044c41a
    test eax, eax                                # 0044c421
    je.d8 L_0044c432                             # 0044c423
    # block 0x0044c425: entered by fall-through of je at 0x0044c423, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0044c432
    push 0x54931c                                # 0044c425
    call FUN_0044a2b7                            # 0044c42a
    add esp, 0x4                                 # 0044c42f
L_0044c432:
    # block 0x0044c432: entered by je at 0x0044c423, 3 instruction(s), ends with je to 0x0044c44a (forward)
    movsx ecx, word ptr [0x63a4cd]               # 0044c432
    test ecx, ecx                                # 0044c439
    je.d8 L_0044c44a                             # 0044c43b
    # block 0x0044c43d: entered by fall-through of je at 0x0044c43b, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0044c44a
    push 0x549364                                # 0044c43d
    call FUN_0044a2b7                            # 0044c442
    add esp, 0x4                                 # 0044c447
L_0044c44a:
    # block 0x0044c44a: entered by je at 0x0044c43b, 2 instruction(s), ends with ret
    pop ebp                                      # 0044c44a
    ret                                          # 0044c44b

