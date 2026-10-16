# FUN_00454de6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00454de6
# extent:       0x00454de6-0x00454e39 (83 code bytes)
# span:         0x00454de6-0x00454e39 (code 83, tables 0, padding 0)
# sha256:       703b1278d11871c9bf6f0c82858650272be5b715cce3188c198303d6fd15375c
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00454de6
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_20; [edx + n] field_1c, field_20
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_00454d9e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 28 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_00454d9e, .text + (0x00454d9e - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x00454de6 - 0x401000
.globl FUN_00454de6
FUN_00454de6:
    # block 0x00454de6: entry, 7 instruction(s), ends with je to 0x00454e11 (forward)
    push ebp                                     # 00454de6
    {load} mov ebp, esp                          # 00454de7
    push ecx                                     # 00454de9
    mov dword ptr [ebp - local_4], ecx           # 00454dea
    mov eax, dword ptr [ebp - local_4]           # 00454ded
    cmp dword ptr [eax + field_20], 0x0          # 00454df0
    je.d8 L_00454e11                             # 00454df4
    # block 0x00454df6: entered by fall-through of je at 0x00454df4, 7 instruction(s), calls FUN_004c2dfb, falls into the block at 0x00454e11
    mov ecx, dword ptr [ebp - local_4]           # 00454df6
    add ecx, 0x20                                # 00454df9
    push ecx                                     # 00454dfc
    mov ecx, 0x5cf659                            # 00454dfd
    call FUN_004c2dfb                            # 00454e02
    mov edx, dword ptr [ebp - local_4]           # 00454e07
    mov dword ptr [edx + field_20], 0x0          # 00454e0a
L_00454e11:
    # block 0x00454e11: entered by je at 0x00454df4, 4 instruction(s), ends with je to 0x00454e2d (forward)
    mov eax, dword ptr [ebp - local_4]           # 00454e11
    movsx ecx, word ptr [eax + field_1c]         # 00454e14
    cmp ecx, -0x1                                # 00454e18
    je.d8 L_00454e2d                             # 00454e1b
    # block 0x00454e1d: entered by fall-through of je at 0x00454e1b, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x00454e2d
    mov edx, dword ptr [ebp - local_4]           # 00454e1d
    mov ax, word ptr [edx + field_1c]            # 00454e20
    push eax                                     # 00454e24
    call FUN_004d3992                            # 00454e25
    add esp, 0x4                                 # 00454e2a
L_00454e2d:
    # block 0x00454e2d: entered by je at 0x00454e1b, 5 instruction(s), calls FUN_00454d9e, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00454e2d
    call FUN_00454d9e                            # 00454e30
    {load} mov esp, ebp                          # 00454e35
    pop ebp                                      # 00454e37
    ret                                          # 00454e38

