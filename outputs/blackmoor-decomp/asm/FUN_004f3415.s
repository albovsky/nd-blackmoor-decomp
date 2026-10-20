# FUN_004f3415
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f3415
# extent:       0x004f3415-0x004f356e (345 code bytes)
# span:         0x004f3415-0x004f356e (code 345, tables 0, padding 0)
# sha256:       86c507a18d32d692bcab6b90517d6976628b29337830c415428cdc5ce037bd4f
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_direct_sound_close
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4f3415.c.txt, not original source) refers to the data labelled s_CDirectSound__Close_____object_i_0055da84
# name-note:    Closes DirectSound: stops all 32 channels, releases its COM objects, closes handles; logs CDirectSound::Close.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_8, field_194, field_198, field_19c, field_2ba; [ecx + n] field_194, field_19c, field_1a0, field_2ba; [edx + n] field_8, field_194, field_198
# callees:      calls FUN_004f709c, FUN_004f356e, KERNEL32.dll!CloseHandle, FUN_0044a2b7; plus 3 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 90 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_8, 0x8  # offset +0x8
.equ field_194, 0x194  # offset +0x194
.equ field_198, 0x198  # offset +0x198
.equ field_19c, 0x19c  # offset +0x19c
.equ field_1a0, 0x1a0  # offset +0x1a0
.equ field_2ba, 0x2ba  # offset +0x2ba

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004f356e, .text + (0x004f356e - 0x401000)
.set FUN_004f709c, .text + (0x004f709c - 0x401000)

.org 0x004f3415 - 0x401000
.globl FUN_004f3415
FUN_004f3415:
    # block 0x004f3415: entry, 8 instruction(s), calls FUN_004f709c, ends with jne to 0x004f3434 (forward)
    push ebp                                     # 004f3415
    {load} mov ebp, esp                          # 004f3416
    sub esp, 0x8                                 # 004f3418
    mov dword ptr [ebp - local_8], ecx           # 004f341b
    mov ecx, dword ptr [ebp - local_8]           # 004f341e
    call FUN_004f709c                            # 004f3421
    test eax, eax                                # 004f3426
    jne.d8 L_004f3434                            # 004f3428
    # block 0x004f342a: entered by fall-through of jne at 0x004f3428, 2 instruction(s), ends with forward jump to 0x004f356a
    mov eax, 0x1                                 # 004f342a
    jmp.d32 L_004f356a                           # 004f342f
L_004f3434:
    # block 0x004f3434: entered by jne at 0x004f3428, 2 instruction(s), ends with forward jump to 0x004f3446
    mov dword ptr [ebp - local_4], 0x0           # 004f3434
    jmp.d8 L_004f3446                            # 004f343b
L_004f343d:
    # block 0x004f343d: entered by jmp at 0x004f3458, 3 instruction(s), falls into the block at 0x004f3446
    mov eax, dword ptr [ebp - local_4]           # 004f343d
    add eax, 0x1                                 # 004f3440
    mov dword ptr [ebp - local_4], eax           # 004f3443
L_004f3446:
    # block 0x004f3446: entered by jmp at 0x004f343b, 2 instruction(s), ends with jge to 0x004f345a (forward)
    cmp dword ptr [ebp - local_4], 0x20          # 004f3446
    jge.d8 L_004f345a                            # 004f344a
    # block 0x004f344c: entered by fall-through of jge at 0x004f344a, 5 instruction(s), calls FUN_004f356e, ends with backward jump to 0x004f343d
    mov ecx, dword ptr [ebp - local_4]           # 004f344c
    push ecx                                     # 004f344f
    mov ecx, dword ptr [ebp - local_8]           # 004f3450
    call FUN_004f356e                            # 004f3453
    jmp.d8 L_004f343d                            # 004f3458
L_004f345a:
    # block 0x004f345a: entered by jge at 0x004f344a, 3 instruction(s), ends with je to 0x004f34f1 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004f345a
    cmp dword ptr [edx + field_194], 0x0         # 004f345d
    je.d32 L_004f34f1                            # 004f3464
    # block 0x004f346a: entered by fall-through of je at 0x004f3464, 3 instruction(s), ends with je to 0x004f349b (forward)
    mov eax, dword ptr [ebp - local_8]           # 004f346a
    cmp dword ptr [eax + field_19c], 0x0         # 004f346d
    je.d8 L_004f349b                             # 004f3474
    # block 0x004f3476: entered by fall-through of je at 0x004f3474, 9 instruction(s), calls indirect dword ptr [eax + 0x8], falls into the block at 0x004f349b
    mov ecx, dword ptr [ebp - local_8]           # 004f3476
    mov edx, dword ptr [ecx + field_19c]         # 004f3479
    mov eax, dword ptr [ebp - local_8]           # 004f347f
    mov ecx, dword ptr [eax + field_19c]         # 004f3482
    mov eax, dword ptr [ecx]                     # 004f3488
    push edx                                     # 004f348a
    call dword ptr [eax + field_8]               # 004f348b
    mov ecx, dword ptr [ebp - local_8]           # 004f348e
    mov dword ptr [ecx + field_19c], 0x0         # 004f3491
L_004f349b:
    # block 0x004f349b: entered by je at 0x004f3474, 3 instruction(s), ends with je to 0x004f34cc (forward)
    mov edx, dword ptr [ebp - local_8]           # 004f349b
    cmp dword ptr [edx + field_198], 0x0         # 004f349e
    je.d8 L_004f34cc                             # 004f34a5
    # block 0x004f34a7: entered by fall-through of je at 0x004f34a5, 9 instruction(s), calls indirect dword ptr [edx + 0x8], falls into the block at 0x004f34cc
    mov eax, dword ptr [ebp - local_8]           # 004f34a7
    mov ecx, dword ptr [eax + field_198]         # 004f34aa
    mov edx, dword ptr [ebp - local_8]           # 004f34b0
    mov eax, dword ptr [edx + field_198]         # 004f34b3
    mov edx, dword ptr [eax]                     # 004f34b9
    push ecx                                     # 004f34bb
    call dword ptr [edx + field_8]               # 004f34bc
    mov eax, dword ptr [ebp - local_8]           # 004f34bf
    mov dword ptr [eax + field_198], 0x0         # 004f34c2
L_004f34cc:
    # block 0x004f34cc: entered by je at 0x004f34a5, 9 instruction(s), calls indirect dword ptr [eax + 0x8], falls into the block at 0x004f34f1
    mov ecx, dword ptr [ebp - local_8]           # 004f34cc
    mov edx, dword ptr [ecx + field_194]         # 004f34cf
    mov eax, dword ptr [ebp - local_8]           # 004f34d5
    mov ecx, dword ptr [eax + field_194]         # 004f34d8
    mov eax, dword ptr [ecx]                     # 004f34de
    push edx                                     # 004f34e0
    call dword ptr [eax + field_8]               # 004f34e1
    mov ecx, dword ptr [ebp - local_8]           # 004f34e4
    mov dword ptr [ecx + field_194], 0x0         # 004f34e7
L_004f34f1:
    # block 0x004f34f1: entered by je at 0x004f3464, 2 instruction(s), ends with forward jump to 0x004f3503
    mov dword ptr [ebp - local_4], 0x0           # 004f34f1
    jmp.d8 L_004f3503                            # 004f34f8
L_004f34fa:
    # block 0x004f34fa: entered by jmp at 0x004f353e, 3 instruction(s), falls into the block at 0x004f3503
    mov edx, dword ptr [ebp - local_4]           # 004f34fa
    add edx, 0x1                                 # 004f34fd
    mov dword ptr [ebp - local_4], edx           # 004f3500
L_004f3503:
    # block 0x004f3503: entered by jmp at 0x004f34f8, 2 instruction(s), ends with jge to 0x004f3540 (forward)
    cmp dword ptr [ebp - local_4], 0x40          # 004f3503
    jge.d8 L_004f3540                            # 004f3507
    # block 0x004f3509: entered by fall-through of jge at 0x004f3507, 4 instruction(s), ends with je to 0x004f353e (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f3509
    mov ecx, dword ptr [ebp - local_8]           # 004f350c
    cmp dword ptr [ecx + 4*eax + field_2ba], 0x0 # 004f350f
    je.d8 L_004f353e                             # 004f3517
    # block 0x004f3519: entered by fall-through of je at 0x004f3517, 8 instruction(s), calls KERNEL32.dll!CloseHandle, falls into the block at 0x004f353e
    mov edx, dword ptr [ebp - local_4]           # 004f3519
    mov eax, dword ptr [ebp - local_8]           # 004f351c
    mov ecx, dword ptr [eax + 4*edx + field_2ba] # 004f351f
    push ecx                                     # 004f3526
    call dword ptr [0x52a2b8]                    # 004f3527
    mov edx, dword ptr [ebp - local_4]           # 004f352d
    mov eax, dword ptr [ebp - local_8]           # 004f3530
    mov dword ptr [eax + 4*edx + field_2ba], 0x0 # 004f3533
L_004f353e:
    # block 0x004f353e: entered by je at 0x004f3517, 1 instruction(s), ends with backward jump to 0x004f34fa
    jmp.d8 L_004f34fa                            # 004f353e
L_004f3540:
    # block 0x004f3540: entered by jge at 0x004f3507, 5 instruction(s), ends with je to 0x004f3565 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004f3540
    mov dword ptr [ecx + field_1a0], 0x0         # 004f3543
    movsx edx, word ptr [0x63a4cd]               # 004f354d
    test edx, edx                                # 004f3554
    je.d8 L_004f3565                             # 004f3556
    # block 0x004f3558: entered by fall-through of je at 0x004f3556, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004f3565
    push 0x55da84                                # 004f3558
    call FUN_0044a2b7                            # 004f355d
    add esp, 0x4                                 # 004f3562
L_004f3565:
    # block 0x004f3565: entered by je at 0x004f3556, 1 instruction(s), falls into the block at 0x004f356a
    mov eax, 0x1                                 # 004f3565
L_004f356a:
    # block 0x004f356a: entered by jmp at 0x004f342f, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004f356a
    pop ebp                                      # 004f356c
    ret                                          # 004f356d

