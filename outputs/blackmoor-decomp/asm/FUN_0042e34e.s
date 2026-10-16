# FUN_0042e34e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042e34e
# extent:       0x0042e34e-0x0042e483 (309 code bytes)
# span:         0x0042e34e-0x0042e493 (code 309, tables 16, padding 0)
# sha256:       acd95a8a01b303d650659acfde1e4ac259399fe28212e7f87ed45ae40519526d
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0042e34e
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4c, field_52, field_56; [ecx + n] field_4c, field_4e, field_52, field_56
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 66 instruction(s), 7 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4c, 0x4c  # offset +0x4c
.equ field_4e, 0x4e  # offset +0x4e
.equ field_52, 0x52  # offset +0x52
.equ field_56, 0x56  # offset +0x56

# --- external targets -----------------------------------------------

.org 0x0042e34e - 0x401000
.globl FUN_0042e34e
FUN_0042e34e:
    # block 0x0042e34e: entry, 7 instruction(s), ends with ja to 0x0042e45d (forward)
    push ebp                                     # 0042e34e
    {load} mov ebp, esp                          # 0042e34f
    push ecx                                     # 0042e351
    mov eax, dword ptr [0x5b508b]                # 0042e352
    mov dword ptr [ebp - local_4], eax           # 0042e357
    cmp dword ptr [ebp - local_4], 0x3           # 0042e35a
    ja.d32 L_0042e45d                            # 0042e35e
    # block 0x0042e364: entered by fall-through of ja at 0x0042e35e, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x42e483]
    mov ecx, dword ptr [ebp - local_4]           # 0042e364
    jmp dword ptr [4*ecx + SWTAB_0042e483_VA]    # 0042e367
L_0042e36e:
    # block 0x0042e36e: entered by switch case, 8 instruction(s), ends with jle to 0x0042e3a5 (forward)
    mov dx, word ptr [0x5b5077]                  # 0042e36e
    add dx, 0x1                                  # 0042e375
    mov word ptr [0x5b5077], dx                  # 0042e379
    movsx eax, word ptr [0x5b5077]               # 0042e380
    mov ecx, dword ptr [0x5b5124]                # 0042e387
    movsx edx, word ptr [ecx + field_4e]         # 0042e38d
    {load} cmp eax, edx                          # 0042e391
    jle.d8 L_0042e3a5                            # 0042e393
    # block 0x0042e395: entered by fall-through of jle at 0x0042e393, 3 instruction(s), falls into the block at 0x0042e3a5
    mov eax, dword ptr [0x5b5124]                # 0042e395
    mov cx, word ptr [eax + field_4c]            # 0042e39a
    mov word ptr [0x5b5077], cx                  # 0042e39e
L_0042e3a5:
    # block 0x0042e3a5: entered by jle at 0x0042e393, 1 instruction(s), ends with forward jump to 0x0042e45d
    jmp.d32 L_0042e45d                           # 0042e3a5
L_0042e3aa:
    # block 0x0042e3aa: entered by switch case, 8 instruction(s), ends with jle to 0x0042e3e1 (forward)
    mov dx, word ptr [0x5b5077]                  # 0042e3aa
    add dx, 0x1                                  # 0042e3b1
    mov word ptr [0x5b5077], dx                  # 0042e3b5
    movsx eax, word ptr [0x5b5077]               # 0042e3bc
    mov ecx, dword ptr [0x5b5124]                # 0042e3c3
    movsx edx, word ptr [ecx + field_52]         # 0042e3c9
    {load} cmp eax, edx                          # 0042e3cd
    jle.d8 L_0042e3e1                            # 0042e3cf
    # block 0x0042e3d1: entered by fall-through of jle at 0x0042e3cf, 3 instruction(s), falls into the block at 0x0042e3e1
    mov eax, dword ptr [0x5b5124]                # 0042e3d1
    mov cx, word ptr [eax + field_52]            # 0042e3d6
    mov word ptr [0x5b5077], cx                  # 0042e3da
L_0042e3e1:
    # block 0x0042e3e1: entered by jle at 0x0042e3cf, 1 instruction(s), ends with forward jump to 0x0042e45d
    jmp.d8 L_0042e45d                            # 0042e3e1
L_0042e3e3:
    # block 0x0042e3e3: entered by switch case, 8 instruction(s), ends with jge to 0x0042e424 (forward)
    mov dx, word ptr [0x5b5077]                  # 0042e3e3
    sub dx, 0x1                                  # 0042e3ea
    mov word ptr [0x5b5077], dx                  # 0042e3ee
    movsx eax, word ptr [0x5b5077]               # 0042e3f5
    mov ecx, dword ptr [0x5b5124]                # 0042e3fc
    movsx edx, word ptr [ecx + field_4c]         # 0042e402
    {load} cmp eax, edx                          # 0042e406
    jge.d8 L_0042e424                            # 0042e408
    # block 0x0042e40a: entered by fall-through of jge at 0x0042e408, 4 instruction(s), falls into the block at 0x0042e424
    mov eax, dword ptr [0x5b5124]                # 0042e40a
    mov cx, word ptr [eax + field_4c]            # 0042e40f
    mov word ptr [0x5b5077], cx                  # 0042e413
    mov dword ptr [0x5b508b], 0x0                # 0042e41a
L_0042e424:
    # block 0x0042e424: entered by jge at 0x0042e408, 1 instruction(s), ends with forward jump to 0x0042e45d
    jmp.d8 L_0042e45d                            # 0042e424
L_0042e426:
    # block 0x0042e426: entered by switch case, 8 instruction(s), ends with jle to 0x0042e45d (forward)
    mov dx, word ptr [0x5b5077]                  # 0042e426
    add dx, 0x1                                  # 0042e42d
    mov word ptr [0x5b5077], dx                  # 0042e431
    movsx eax, word ptr [0x5b5077]               # 0042e438
    mov ecx, dword ptr [0x5b5124]                # 0042e43f
    movsx edx, word ptr [ecx + field_56]         # 0042e445
    {load} cmp eax, edx                          # 0042e449
    jle.d8 L_0042e45d                            # 0042e44b
    # block 0x0042e44d: entered by fall-through of jle at 0x0042e44b, 3 instruction(s), falls into the block at 0x0042e45d
    mov eax, dword ptr [0x5b5124]                # 0042e44d
    mov cx, word ptr [eax + field_56]            # 0042e452
    mov word ptr [0x5b5077], cx                  # 0042e456
L_0042e45d:
    # block 0x0042e45d: entered by ja at 0x0042e35e; jmp at 0x0042e3a5; jmp at 0x0042e3e1; jmp at 0x0042e424; more, 2 instruction(s), ends with jne to 0x0042e47f (forward)
    cmp dword ptr [0x5b508b], 0x1                # 0042e45d
    jne.d8 L_0042e47f                            # 0042e464
    # block 0x0042e466: entered by fall-through of jne at 0x0042e464, 3 instruction(s), ends with je to 0x0042e47f (forward)
    movsx edx, word ptr [0x5b5100]               # 0042e466
    cmp dword ptr [0x5c39e5], edx                # 0042e46d
    je.d8 L_0042e47f                             # 0042e473
    # block 0x0042e475: entered by fall-through of je at 0x0042e473, 1 instruction(s), falls into the block at 0x0042e47f
    mov dword ptr [0x5b508b], 0x2                # 0042e475
L_0042e47f:
    # block 0x0042e47f: entered by jne at 0x0042e464; je at 0x0042e473, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0042e47f
    pop ebp                                      # 0042e481
    ret                                          # 0042e482

# --- data items (not part of the function) -------------------------
.org 0x0042e483 - 0x401000
SWTAB_0042e483:  # 4 case address(es)
    .long L_0042e36e - .text + 0x401000
    .long L_0042e3aa - .text + 0x401000
    .long L_0042e3e3 - .text + 0x401000
    .long L_0042e426 - .text + 0x401000
.set SWTAB_0042e483_VA, SWTAB_0042e483 - .text + 0x401000

