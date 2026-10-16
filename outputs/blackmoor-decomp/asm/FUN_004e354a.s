# FUN_004e354a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e354a
# extent:       0x004e354a-0x004e35e8 (158 code bytes)
# span:         0x004e354a-0x004e35e8 (code 158, tables 0, padding 0)
# sha256:       889d85606c40395a406a01a6053459e057d05dfb3f14965bcb30a70e0d9c4369
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e354a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_4530; [ecx + n] field_4530; [edx + n] field_1ca2, field_4530
# callees:      calls FUN_004e2940
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 44 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1ca2, 0x1ca2  # offset +0x1ca2
.equ field_4530, 0x4530  # offset +0x4530

# --- external targets -----------------------------------------------
.set FUN_004e2940, .text + (0x004e2940 - 0x401000)

.org 0x004e354a - 0x401000
.globl FUN_004e354a
FUN_004e354a:
    # block 0x004e354a: entry, 6 instruction(s), ends with jne to 0x004e3598 (forward)
    push ebp                                     # 004e354a
    {load} mov ebp, esp                          # 004e354b
    sub esp, 0x8                                 # 004e354d
    mov dword ptr [ebp - local_8], ecx           # 004e3550
    cmp dword ptr [0x5a1e58], 0x0                # 004e3553
    jne.d8 L_004e3598                            # 004e355a
    # block 0x004e355c: entered by fall-through of jne at 0x004e355a, 3 instruction(s), ends with je to 0x004e3598 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004e355c
    cmp dword ptr [eax + field_4530], 0xc        # 004e355f
    je.d8 L_004e3598                             # 004e3566
    # block 0x004e3568: entered by fall-through of je at 0x004e3566, 3 instruction(s), ends with je to 0x004e3598 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004e3568
    cmp dword ptr [ecx + field_4530], 0xd        # 004e356b
    je.d8 L_004e3598                             # 004e3572
    # block 0x004e3574: entered by fall-through of je at 0x004e3572, 3 instruction(s), ends with je to 0x004e3598 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004e3574
    cmp dword ptr [edx + field_4530], 0xe        # 004e3577
    je.d8 L_004e3598                             # 004e357e
    # block 0x004e3580: entered by fall-through of je at 0x004e357e, 3 instruction(s), ends with je to 0x004e3598 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004e3580
    cmp dword ptr [eax + field_4530], 0xf        # 004e3583
    je.d8 L_004e3598                             # 004e358a
    # block 0x004e358c: entered by fall-through of je at 0x004e358a, 3 instruction(s), ends with jne to 0x004e35d4 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004e358c
    cmp dword ptr [ecx + field_4530], 0x10       # 004e358f
    jne.d8 L_004e35d4                            # 004e3596
L_004e3598:
    # block 0x004e3598: entered by jne at 0x004e355a; je at 0x004e3566; je at 0x004e3572; je at 0x004e357e; more, 2 instruction(s), ends with forward jump to 0x004e35ac
    mov word ptr [ebp - local_4], 0x0            # 004e3598
    jmp.d8 L_004e35ac                            # 004e359e
L_004e35a0:
    # block 0x004e35a0: entered by jmp at 0x004e35d0, 3 instruction(s), falls into the block at 0x004e35ac
    mov dx, word ptr [ebp - local_4]             # 004e35a0
    add dx, 0x1                                  # 004e35a4
    mov word ptr [ebp - local_4], dx             # 004e35a8
L_004e35ac:
    # block 0x004e35ac: entered by jmp at 0x004e359e, 3 instruction(s), ends with jg to 0x004e35d2 (forward)
    movsx eax, word ptr [ebp - local_4]          # 004e35ac
    cmp eax, 0xf                                 # 004e35b0
    jg.d8 L_004e35d2                             # 004e35b3
    # block 0x004e35b5: entered by fall-through of jg at 0x004e35b3, 7 instruction(s), calls FUN_004e2940, ends with backward jump to 0x004e35a0
    push 0x4                                     # 004e35b5
    movsx ecx, word ptr [ebp - local_4]          # 004e35b7
    imul ecx, ecx, 0x18f                         # 004e35bb
    mov edx, dword ptr [ebp - local_8]           # 004e35c1
    lea ecx, [edx + ecx + field_1ca2]            # 004e35c4
    call FUN_004e2940                            # 004e35cb
    jmp.d8 L_004e35a0                            # 004e35d0
L_004e35d2:
    # block 0x004e35d2: entered by jg at 0x004e35b3, 1 instruction(s), ends with forward jump to 0x004e35e4
    jmp.d8 L_004e35e4                            # 004e35d2
L_004e35d4:
    # block 0x004e35d4: entered by jne at 0x004e3596, 4 instruction(s), calls FUN_004e2940, falls into the block at 0x004e35e4
    push 0x4                                     # 004e35d4
    mov ecx, dword ptr [ebp - local_8]           # 004e35d6
    add ecx, 0x3403                              # 004e35d9
    call FUN_004e2940                            # 004e35df
L_004e35e4:
    # block 0x004e35e4: entered by jmp at 0x004e35d2, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004e35e4
    pop ebp                                      # 004e35e6
    ret                                          # 004e35e7

