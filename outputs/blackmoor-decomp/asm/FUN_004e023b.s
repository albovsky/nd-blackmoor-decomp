# FUN_004e023b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e023b
# extent:       0x004e023b-0x004e0377 (316 code bytes)
# span:         0x004e023b-0x004e0377 (code 316, tables 0, padding 0)
# sha256:       dd5da8ed93a4c6aa918a6bb452527c2eb15993d9e16ff866a4f9dcfc311705a0
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e023b
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004c5d4b, FUN_004c5377
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 83 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)

.org 0x004e023b - 0x401000
.globl FUN_004e023b
FUN_004e023b:
    # block 0x004e023b: entry, 5 instruction(s), ends with je to 0x004e0270 (forward)
    push ebp                                     # 004e023b
    {load} mov ebp, esp                          # 004e023c
    push ecx                                     # 004e023e
    cmp dword ptr [0x5bb202], 0x0                # 004e023f
    je.d8 L_004e0270                             # 004e0246
    # block 0x004e0248: entered by fall-through of je at 0x004e0246, 10 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x004e0296
    push 0x55baac                                # 004e0248
    push 0x5832ae                                # 004e024d
    push 0x5832de                                # 004e0252
    mov eax, dword ptr [0x5cf665]                # 004e0257
    push eax                                     # 004e025c
    mov ecx, dword ptr [0x5d2819]                # 004e025d
    push ecx                                     # 004e0263
    mov ecx, 0x5cf659                            # 004e0264
    call FUN_004c5d4b                            # 004e0269
    jmp.d8 L_004e0296                            # 004e026e
L_004e0270:
    # block 0x004e0270: entered by je at 0x004e0246, 9 instruction(s), calls FUN_004c5377, falls into the block at 0x004e0296
    push 0x55babc                                # 004e0270
    push 0x5832ae                                # 004e0275
    push 0x5832ae                                # 004e027a
    mov edx, dword ptr [0x5cf665]                # 004e027f
    push edx                                     # 004e0285
    mov eax, dword ptr [0x5d2819]                # 004e0286
    push eax                                     # 004e028b
    mov ecx, 0x5cf659                            # 004e028c
    call FUN_004c5377                            # 004e0291
L_004e0296:
    # block 0x004e0296: entered by jmp at 0x004e026e, 2 instruction(s), ends with je to 0x004e02c8 (forward)
    cmp dword ptr [0x5bb206], 0x0                # 004e0296
    je.d8 L_004e02c8                             # 004e029d
    # block 0x004e029f: entered by fall-through of je at 0x004e029d, 10 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x004e02ee
    push 0x55bacc                                # 004e029f
    push 0x5832be                                # 004e02a4
    push 0x5832ee                                # 004e02a9
    mov ecx, dword ptr [0x5cf665]                # 004e02ae
    push ecx                                     # 004e02b4
    mov edx, dword ptr [0x5d2819]                # 004e02b5
    push edx                                     # 004e02bb
    mov ecx, 0x5cf659                            # 004e02bc
    call FUN_004c5d4b                            # 004e02c1
    jmp.d8 L_004e02ee                            # 004e02c6
L_004e02c8:
    # block 0x004e02c8: entered by je at 0x004e029d, 9 instruction(s), calls FUN_004c5377, falls into the block at 0x004e02ee
    push 0x55badc                                # 004e02c8
    push 0x5832be                                # 004e02cd
    push 0x5832be                                # 004e02d2
    mov eax, dword ptr [0x5cf665]                # 004e02d7
    push eax                                     # 004e02dc
    mov ecx, dword ptr [0x5d2819]                # 004e02dd
    push ecx                                     # 004e02e3
    mov ecx, 0x5cf659                            # 004e02e4
    call FUN_004c5377                            # 004e02e9
L_004e02ee:
    # block 0x004e02ee: entered by jmp at 0x004e02c6, 2 instruction(s), ends with je to 0x004e031d (forward)
    cmp dword ptr [0x5835da], 0x0                # 004e02ee
    je.d8 L_004e031d                             # 004e02f5
    # block 0x004e02f7: entered by fall-through of je at 0x004e02f5, 9 instruction(s), calls FUN_004c5377, falls into the block at 0x004e031d
    push 0x55baec                                # 004e02f7
    push 0x5832ce                                # 004e02fc
    push 0x5832fe                                # 004e0301
    mov edx, dword ptr [0x5cf665]                # 004e0306
    push edx                                     # 004e030c
    mov eax, dword ptr [0x5d2819]                # 004e030d
    push eax                                     # 004e0312
    mov ecx, 0x5cf659                            # 004e0313
    call FUN_004c5377                            # 004e0318
L_004e031d:
    # block 0x004e031d: entered by je at 0x004e02f5, 2 instruction(s), ends with forward jump to 0x004e0331
    mov word ptr [ebp - local_4], 0x0            # 004e031d
    jmp.d8 L_004e0331                            # 004e0323
L_004e0325:
    # block 0x004e0325: entered by jmp at 0x004e0371, 3 instruction(s), falls into the block at 0x004e0331
    mov cx, word ptr [ebp - local_4]             # 004e0325
    add cx, 0x1                                  # 004e0329
    mov word ptr [ebp - local_4], cx             # 004e032d
L_004e0331:
    # block 0x004e0331: entered by jmp at 0x004e0323, 3 instruction(s), ends with jge to 0x004e0373 (forward)
    movsx edx, word ptr [ebp - local_4]          # 004e0331
    cmp edx, 0x3                                 # 004e0335
    jge.d8 L_004e0373                            # 004e0338
    # block 0x004e033a: entered by fall-through of jge at 0x004e0338, 16 instruction(s), calls FUN_004c5d4b, ends with backward jump to 0x004e0325
    push 0x55bafc                                # 004e033a
    movsx eax, word ptr [ebp - local_4]          # 004e033f
    shl eax, 0x4                                 # 004e0343
    add eax, 0x5835e4                            # 004e0346
    push eax                                     # 004e034b
    movsx ecx, word ptr [ebp - local_4]          # 004e034c
    shl ecx, 0x4                                 # 004e0350
    add ecx, 0x58331e                            # 004e0353
    push ecx                                     # 004e0359
    mov edx, dword ptr [0x5cf665]                # 004e035a
    push edx                                     # 004e0360
    mov eax, dword ptr [0x5d2819]                # 004e0361
    push eax                                     # 004e0366
    mov ecx, 0x5cf659                            # 004e0367
    call FUN_004c5d4b                            # 004e036c
    jmp.d8 L_004e0325                            # 004e0371
L_004e0373:
    # block 0x004e0373: entered by jge at 0x004e0338, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004e0373
    pop ebp                                      # 004e0375
    ret                                          # 004e0376

