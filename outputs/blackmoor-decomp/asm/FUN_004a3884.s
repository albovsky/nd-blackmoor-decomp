# FUN_004a3884
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a3884
# extent:       0x004a3884-0x004a3910 (140 code bytes)
# span:         0x004a3884-0x004a3910 (code 140, tables 0, padding 0)
# sha256:       d260d17ef300c9f0f3d76dcaddbd6ac161fda02fe2c68a70b96b994cd080665d
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a3884
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1c, field_200; [edx + n] field_1c, field_200
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_004a378a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 40 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_200, 0x200  # offset +0x200

# --- external targets -----------------------------------------------
.set FUN_004a378a, .text + (0x004a378a - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x004a3884 - 0x401000
.globl FUN_004a3884
FUN_004a3884:
    # block 0x004a3884: entry, 6 instruction(s), ends with forward jump to 0x004a38a1
    push ebp                                     # 004a3884
    {load} mov ebp, esp                          # 004a3885
    sub esp, 0x8                                 # 004a3887
    mov dword ptr [ebp - local_8], ecx           # 004a388a
    mov word ptr [ebp - local_4], 0x0            # 004a388d
    jmp.d8 L_004a38a1                            # 004a3893
L_004a3895:
    # block 0x004a3895: entered by jmp at 0x004a38e6, 3 instruction(s), falls into the block at 0x004a38a1
    mov ax, word ptr [ebp - local_4]             # 004a3895
    .insn 0x66, 0x05, 0x0001{:u16}               # 004a3899
    mov word ptr [ebp - local_4], ax             # 004a389d
L_004a38a1:
    # block 0x004a38a1: entered by jmp at 0x004a3893, 3 instruction(s), ends with jge to 0x004a38e8 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004a38a1
    cmp ecx, 0x4                                 # 004a38a5
    jge.d8 L_004a38e8                            # 004a38a8
    # block 0x004a38aa: entered by fall-through of jge at 0x004a38a8, 4 instruction(s), ends with je to 0x004a38d4 (forward)
    movsx edx, word ptr [ebp - local_4]          # 004a38aa
    mov eax, dword ptr [ebp - local_8]           # 004a38ae
    cmp dword ptr [eax + 4*edx + field_200], 0x0 # 004a38b1
    je.d8 L_004a38d4                             # 004a38b9
    # block 0x004a38bb: entered by fall-through of je at 0x004a38b9, 6 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004a38d4
    movsx ecx, word ptr [ebp - local_4]          # 004a38bb
    mov edx, dword ptr [ebp - local_8]           # 004a38bf
    lea eax, [edx + 4*ecx + field_200]           # 004a38c2
    push eax                                     # 004a38c9
    mov ecx, 0x5cf659                            # 004a38ca
    call FUN_004c2dfb                            # 004a38cf
L_004a38d4:
    # block 0x004a38d4: entered by je at 0x004a38b9, 4 instruction(s), ends with backward jump to 0x004a3895
    movsx ecx, word ptr [ebp - local_4]          # 004a38d4
    mov edx, dword ptr [ebp - local_8]           # 004a38d8
    mov dword ptr [edx + 4*ecx + field_200], 0x0 # 004a38db
    jmp.d8 L_004a3895                            # 004a38e6
L_004a38e8:
    # block 0x004a38e8: entered by jge at 0x004a38a8, 4 instruction(s), ends with je to 0x004a3904 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004a38e8
    movsx ecx, word ptr [eax + field_1c]         # 004a38eb
    cmp ecx, -0x1                                # 004a38ef
    je.d8 L_004a3904                             # 004a38f2
    # block 0x004a38f4: entered by fall-through of je at 0x004a38f2, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x004a3904
    mov edx, dword ptr [ebp - local_8]           # 004a38f4
    mov ax, word ptr [edx + field_1c]            # 004a38f7
    push eax                                     # 004a38fb
    call FUN_004d3992                            # 004a38fc
    add esp, 0x4                                 # 004a3901
L_004a3904:
    # block 0x004a3904: entered by je at 0x004a38f2, 5 instruction(s), calls FUN_004a378a, ends with ret
    mov ecx, dword ptr [ebp - local_8]           # 004a3904
    call FUN_004a378a                            # 004a3907
    {load} mov esp, ebp                          # 004a390c
    pop ebp                                      # 004a390e
    ret                                          # 004a390f

