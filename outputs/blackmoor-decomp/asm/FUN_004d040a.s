# FUN_004d040a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d040a
# extent:       0x004d040a-0x004d0532 (296 code bytes)
# span:         0x004d040a-0x004d0532 (code 296, tables 0, padding 0)
# sha256:       99b0c82813ace9ad39efa3a87683555b0cab00d4cfc0b16bc9ddb56ec5321481
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d040a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_e5, field_e9; [ecx + n] field_ed; [edx + n] field_21, field_e1
# callees:      calls FUN_004c5377
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 67 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_21, 0x21  # offset +0x21
.equ field_e1, 0xe1  # offset +0xe1
.equ field_e5, 0xe5  # offset +0xe5
.equ field_e9, 0xe9  # offset +0xe9
.equ field_ed, 0xed  # offset +0xed

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)

.org 0x004d040a - 0x401000
.globl FUN_004d040a
FUN_004d040a:
    # block 0x004d040a: entry, 5 instruction(s), ends with forward jump to 0x004d0424
    push ebp                                     # 004d040a
    {load} mov ebp, esp                          # 004d040b
    sub esp, 0x14                                # 004d040d
    mov word ptr [ebp - local_4], 0x0            # 004d0410
    jmp.d8 L_004d0424                            # 004d0416
L_004d0418:
    # block 0x004d0418: entered by jmp at 0x004d0529, 3 instruction(s), falls into the block at 0x004d0424
    mov ax, word ptr [ebp - local_4]             # 004d0418
    .insn 0x66, 0x05, 0x0001{:u16}               # 004d041c
    mov word ptr [ebp - local_4], ax             # 004d0420
L_004d0424:
    # block 0x004d0424: entered by jmp at 0x004d0416, 3 instruction(s), ends with jge to 0x004d052e (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004d0424
    cmp ecx, 0x3                                 # 004d0428
    jge.d32 L_004d052e                           # 004d042b
    # block 0x004d0431: entered by fall-through of jge at 0x004d042b, 53 instruction(s), calls FUN_004c5377, ends with backward jump to 0x004d0418
    movsx edx, word ptr [0x5b51c7]               # 004d0431
    imul edx, edx, 0x8d                          # 004d0438
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004d043e
    movsx ecx, word ptr [ebp - local_4]          # 004d0444
    shl ecx, 0x4                                 # 004d0448
    mov edx, dword ptr [eax + ecx + field_e5]    # 004d044b
    add edx, dword ptr [0x58318a]                # 004d0452
    mov dword ptr [ebp - local_10], edx          # 004d0458
    movsx eax, word ptr [0x5b51c7]               # 004d045b
    imul eax, eax, 0x8d                          # 004d0462
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004d0468
    movsx edx, word ptr [ebp - local_4]          # 004d046e
    shl edx, 0x4                                 # 004d0472
    mov eax, dword ptr [ecx + edx + field_ed]    # 004d0475
    add eax, dword ptr [0x58318a]                # 004d047c
    mov dword ptr [ebp - local_8], eax           # 004d0482
    movsx ecx, word ptr [0x5b51c7]               # 004d0485
    imul ecx, ecx, 0x8d                          # 004d048c
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004d0492
    movsx eax, word ptr [ebp - local_4]          # 004d0498
    shl eax, 0x4                                 # 004d049c
    mov ecx, dword ptr [edx + eax + field_e1]    # 004d049f
    add ecx, dword ptr [0x583186]                # 004d04a6
    mov dword ptr [ebp - local_14], ecx          # 004d04ac
    movsx edx, word ptr [0x5b51c7]               # 004d04af
    imul edx, edx, 0x8d                          # 004d04b6
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004d04bc
    movsx ecx, word ptr [ebp - local_4]          # 004d04c2
    shl ecx, 0x4                                 # 004d04c6
    mov edx, dword ptr [eax + ecx + field_e9]    # 004d04c9
    add edx, dword ptr [0x583186]                # 004d04d0
    mov dword ptr [ebp - local_c], edx           # 004d04d6
    push 0x559fa4                                # 004d04d9
    lea eax, [ebp - local_14]                    # 004d04de
    push eax                                     # 004d04e1
    movsx ecx, word ptr [0x5b51c7]               # 004d04e2
    imul ecx, ecx, 0x8d                          # 004d04e9
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004d04ef
    movsx eax, word ptr [ebp - local_4]          # 004d04f5
    shl eax, 0x6                                 # 004d04f9
    lea ecx, [edx + eax + field_21]              # 004d04fc
    movsx edx, word ptr [ebp - local_4]          # 004d0500
    mov eax, dword ptr [4*edx + 0x5b51ba]        # 004d0504
    shl eax, 0x4                                 # 004d050b
    {load} add ecx, eax                          # 004d050e
    push ecx                                     # 004d0510
    mov ecx, dword ptr [0x5cf665]                # 004d0511
    push ecx                                     # 004d0517
    mov edx, dword ptr [0x5d1b17]                # 004d0518
    push edx                                     # 004d051e
    mov ecx, 0x5cf659                            # 004d051f
    call FUN_004c5377                            # 004d0524
    jmp.d32 L_004d0418                           # 004d0529
L_004d052e:
    # block 0x004d052e: entered by jge at 0x004d042b, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004d052e
    pop ebp                                      # 004d0530
    ret                                          # 004d0531

