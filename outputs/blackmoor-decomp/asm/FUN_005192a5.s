# FUN_005192a5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005192a5
# extent:       0x005192a5-0x005193ca (293 code bytes)
# span:         0x005192a5-0x005193ca (code 293, tables 0, padding 0)
# sha256:       023b3e11ba4b7f6b34f9844db4209e171ccfaa014a1c4fcc549a0ac2ebd73ee4
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005192a5
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       2 ebp-relative slot(s): local_4, local_1004
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050c920, FUN_005121dd, FUN_0050f920, FUN_00519500, FUN_0051332e, FUN_0050ea87, FUN_0050ea7e, FUN_005176d9, KERNEL32.dll!SetEndOfFile, KERNEL32.dll!GetLastError
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 103 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_1004, 0x1004  # offset -0x1004
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)
.set FUN_0050ea7e, .text + (0x0050ea7e - 0x401000)
.set FUN_0050ea87, .text + (0x0050ea87 - 0x401000)
.set FUN_0050f920, .text + (0x0050f920 - 0x401000)
.set FUN_005121dd, .text + (0x005121dd - 0x401000)
.set FUN_0051332e, .text + (0x0051332e - 0x401000)
.set FUN_005176d9, .text + (0x005176d9 - 0x401000)
.set FUN_00519500, .text + (0x00519500 - 0x401000)

.org 0x005192a5 - 0x401000
.globl FUN_005192a5
FUN_005192a5:
    # block 0x005192a5: entry, 16 instruction(s), calls FUN_0050c920, FUN_005121dd, ends with je to 0x005193c4 (forward)
    push ebp                                     # 005192a5
    {load} mov ebp, esp                          # 005192a6
    mov eax, 0x1004                              # 005192a8
    call FUN_0050c920                            # 005192ad
    push ebx                                     # 005192b2
    push esi                                     # 005192b3
    {load} xor esi, esi                          # 005192b4
    push 0x1                                     # 005192b6
    push esi                                     # 005192b8
    push dword ptr [ebp + arg_8]                 # 005192b9
    call FUN_005121dd                            # 005192bc
    or ebx, -0x1                                 # 005192c1
    add esp, 0xc                                 # 005192c4
    {load} cmp eax, ebx                          # 005192c7
    mov dword ptr [ebp - local_4], eax           # 005192c9
    je.d32 L_005193c4                            # 005192cc
    # block 0x005192d2: entered by fall-through of je at 0x005192cc, 7 instruction(s), calls FUN_005121dd, ends with je to 0x005193c4 (forward)
    push 0x2                                     # 005192d2
    push esi                                     # 005192d4
    push dword ptr [ebp + arg_8]                 # 005192d5
    call FUN_005121dd                            # 005192d8
    add esp, 0xc                                 # 005192dd
    {load} cmp eax, ebx                          # 005192e0
    je.d32 L_005193c4                            # 005192e2
    # block 0x005192e8: entered by fall-through of je at 0x005192e2, 5 instruction(s), ends with jle to 0x00519367 (forward)
    push edi                                     # 005192e8
    mov edi, dword ptr [ebp + arg_c]             # 005192e9
    {load} sub edi, eax                          # 005192ec
    test edi, edi                                # 005192ee
    jle.d8 L_00519367                            # 005192f0
    # block 0x005192f2: entered by fall-through of jle at 0x005192f0, 11 instruction(s), calls FUN_0050f920, FUN_00519500, falls into the block at 0x00519318
    mov ebx, 0x1000                              # 005192f2
    lea eax, [ebp - local_1004]                  # 005192f7
    push ebx                                     # 005192fd
    push esi                                     # 005192fe
    push eax                                     # 005192ff
    call FUN_0050f920                            # 00519300
    push 0x8000                                  # 00519305
    push dword ptr [ebp + arg_8]                 # 0051930a
    call FUN_00519500                            # 0051930d
    add esp, 0x14                                # 00519312
    mov dword ptr [ebp + arg_c], eax             # 00519315
L_00519318:
    # block 0x00519318: entered by jmp at 0x0051933e, 3 instruction(s), ends with jge to 0x00519320 (forward)
    {load} cmp edi, ebx                          # 00519318
    {load} mov eax, ebx                          # 0051931a
    jge.d8 L_00519320                            # 0051931c
    # block 0x0051931e: entered by fall-through of jge at 0x0051931c, 1 instruction(s), falls into the block at 0x00519320
    {load} mov eax, edi                          # 0051931e
L_00519320:
    # block 0x00519320: entered by jge at 0x0051931c, 8 instruction(s), calls FUN_0051332e, ends with je to 0x00519340 (forward)
    push eax                                     # 00519320
    lea eax, [ebp - local_1004]                  # 00519321
    push eax                                     # 00519327
    push dword ptr [ebp + arg_8]                 # 00519328
    call FUN_0051332e                            # 0051932b
    add esp, 0xc                                 # 00519330
    cmp eax, -0x1                                # 00519333
    je.d8 L_00519340                             # 00519336
    # block 0x00519338: entered by fall-through of je at 0x00519336, 3 instruction(s), ends with jle to 0x00519358 (forward)
    {load} sub edi, eax                          # 00519338
    test edi, edi                                # 0051933a
    jle.d8 L_00519358                            # 0051933c
    # block 0x0051933e: entered by fall-through of jle at 0x0051933c, 1 instruction(s), ends with backward jump to 0x00519318
    jmp.d8 L_00519318                            # 0051933e
L_00519340:
    # block 0x00519340: entered by je at 0x00519336, 3 instruction(s), calls FUN_0050ea87, ends with jne to 0x00519355 (forward)
    call FUN_0050ea87                            # 00519340
    cmp dword ptr [eax], 0x5                     # 00519345
    jne.d8 L_00519355                            # 00519348
    # block 0x0051934a: entered by fall-through of jne at 0x00519348, 2 instruction(s), calls FUN_0050ea7e, falls into the block at 0x00519355
    call FUN_0050ea7e                            # 0051934a
    mov dword ptr [eax], 0xd                     # 0051934f
L_00519355:
    # block 0x00519355: entered by jne at 0x00519348, 1 instruction(s), falls into the block at 0x00519358
    or esi, -0x1                                 # 00519355
L_00519358:
    # block 0x00519358: entered by jle at 0x0051933c, 6 instruction(s), calls FUN_00519500, ends with forward jump to 0x005193af
    push dword ptr [ebp + arg_c]                 # 00519358
    push dword ptr [ebp + arg_8]                 # 0051935b
    call FUN_00519500                            # 0051935e
    pop ecx                                      # 00519363
    pop ecx                                      # 00519364
    jmp.d8 L_005193af                            # 00519365
L_00519367:
    # block 0x00519367: entered by jle at 0x005192f0, 1 instruction(s), ends with jge to 0x005193af (forward)
    jge.d8 L_005193af                            # 00519367
    # block 0x00519369: entered by fall-through of jge at 0x00519367, 16 instruction(s), calls FUN_005121dd, FUN_005176d9, KERNEL32.dll!SetEndOfFile, ends with jne to 0x005193af (forward)
    push 0x0                                     # 00519369
    push dword ptr [ebp + arg_c]                 # 0051936b
    push dword ptr [ebp + arg_8]                 # 0051936e
    call FUN_005121dd                            # 00519371
    push dword ptr [ebp + arg_8]                 # 00519376
    call FUN_005176d9                            # 00519379
    add esp, 0x10                                # 0051937e
    push eax                                     # 00519381
    call dword ptr [0x52a10c]                    # 00519382
    {load} mov esi, eax                          # 00519388
    neg esi                                      # 0051938a
    {load} sbb esi, esi                          # 0051938c
    neg esi                                      # 0051938e
    dec esi                                      # 00519390
    {load} cmp esi, ebx                          # 00519391
    jne.d8 L_005193af                            # 00519393
    # block 0x00519395: entered by fall-through of jne at 0x00519393, 6 instruction(s), calls FUN_0050ea7e, KERNEL32.dll!GetLastError, FUN_0050ea87, falls into the block at 0x005193af
    call FUN_0050ea7e                            # 00519395
    mov dword ptr [eax], 0xd                     # 0051939a
    call dword ptr [0x52a2a4]                    # 005193a0
    {load} mov edi, eax                          # 005193a6
    call FUN_0050ea87                            # 005193a8
    mov dword ptr [eax], edi                     # 005193ad
L_005193af:
    # block 0x005193af: entered by jmp at 0x00519365; jge at 0x00519367; jne at 0x00519393, 8 instruction(s), calls FUN_005121dd, ends with forward jump to 0x005193c6
    push 0x0                                     # 005193af
    push dword ptr [ebp - local_4]               # 005193b1
    push dword ptr [ebp + arg_8]                 # 005193b4
    call FUN_005121dd                            # 005193b7
    add esp, 0xc                                 # 005193bc
    {load} mov eax, esi                          # 005193bf
    pop edi                                      # 005193c1
    jmp.d8 L_005193c6                            # 005193c2
L_005193c4:
    # block 0x005193c4: entered by je at 0x005192cc; je at 0x005192e2, 1 instruction(s), falls into the block at 0x005193c6
    {load} mov eax, ebx                          # 005193c4
L_005193c6:
    # block 0x005193c6: entered by jmp at 0x005193c2, 4 instruction(s), ends with ret
    pop esi                                      # 005193c6
    pop ebx                                      # 005193c7
    leave                                        # 005193c8
    ret                                          # 005193c9

