# FUN_004f8562
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f8562
# extent:       0x004f8562-0x004f861c (186 code bytes)
# span:         0x004f8562-0x004f861c (code 186, tables 0, padding 0)
# sha256:       f7e040f6915fbfd0126f2ee100b57750280b7454fea54697b2dc1543b2048de3
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f8562
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_19c, field_3ca, field_3d2; [ecx + n] field_19c, field_278, field_3ca; [edx + n] field_30, field_19c, field_3ca
# callees:      calls FUN_0050ca3e, FUN_0044a2b7; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 52 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_30, 0x30  # offset +0x30
.equ field_19c, 0x19c  # offset +0x19c
.equ field_278, 0x278  # offset +0x278
.equ field_3ca, 0x3ca  # offset +0x3ca
.equ field_3d2, 0x3d2  # offset +0x3d2

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004f8562 - 0x401000
.globl FUN_004f8562
FUN_004f8562:
    # block 0x004f8562: entry, 9 instruction(s), ends with je to 0x004f8616 (forward)
    push ebp                                     # 004f8562
    {load} mov ebp, esp                          # 004f8563
    push ecx                                     # 004f8565
    mov dword ptr [ebp - local_4], ecx           # 004f8566
    mov eax, dword ptr [ebp - local_4]           # 004f8569
    mov dword ptr [eax + field_3ca], 0x0         # 004f856c
    mov ecx, dword ptr [ebp - local_4]           # 004f8576
    cmp dword ptr [ecx + field_19c], 0x0         # 004f8579
    je.d32 L_004f8616                            # 004f8580
    # block 0x004f8586: entered by fall-through of je at 0x004f8580, 3 instruction(s), ends with je to 0x004f8599 (forward)
    {load} xor edx, edx                          # 004f8586
    test edx, edx                                # 004f8588
    je.d8 L_004f8599                             # 004f858a
    # block 0x004f858c: entered by fall-through of je at 0x004f858a, 2 instruction(s), falls into the block at 0x004f8599
    mov eax, dword ptr [ebp - local_4]           # 004f858c
    mov dword ptr [eax + field_3d2], 0x1         # 004f858f
L_004f8599:
    # block 0x004f8599: entered by je at 0x004f858a, 16 instruction(s), calls indirect dword ptr [edx + 0x30], ends with jne to 0x004f8612 (forward)
    push 0x0                                     # 004f8599
    mov ecx, dword ptr [ebp - local_4]           # 004f859b
    mov edx, dword ptr [ecx + field_278]         # 004f859e
    push edx                                     # 004f85a4
    mov eax, dword ptr [ebp - local_4]           # 004f85a5
    mov ecx, dword ptr [eax + field_19c]         # 004f85a8
    mov edx, dword ptr [ebp - local_4]           # 004f85ae
    mov eax, dword ptr [edx + field_19c]         # 004f85b1
    mov edx, dword ptr [eax]                     # 004f85b7
    push ecx                                     # 004f85b9
    call dword ptr [edx + field_30]              # 004f85ba
    mov ecx, dword ptr [ebp - local_4]           # 004f85bd
    mov dword ptr [ecx + field_3ca], eax         # 004f85c0
    mov edx, dword ptr [ebp - local_4]           # 004f85c6
    cmp dword ptr [edx + field_3ca], 0x0         # 004f85c9
    jne.d8 L_004f8612                            # 004f85d0
    # block 0x004f85d2: entered by fall-through of jne at 0x004f85d0, 3 instruction(s), ends with je to 0x004f860b (forward)
    movsx eax, word ptr [0x63a4cd]               # 004f85d2
    test eax, eax                                # 004f85d9
    je.d8 L_004f860b                             # 004f85db
    # block 0x004f85dd: entered by fall-through of je at 0x004f85db, 11 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f860b
    mov ecx, dword ptr [ebp - local_4]           # 004f85dd
    fld dword ptr [ecx + field_278]              # 004f85e0
    sub esp, 0x8                                 # 004f85e6
    fstp qword ptr [esp]                         # 004f85e9
    push 0x55ee74                                # 004f85ec
    push 0x63888b                                # 004f85f1
    call FUN_0050ca3e                            # 004f85f6
    add esp, 0x10                                # 004f85fb
    push 0x63888b                                # 004f85fe
    call FUN_0044a2b7                            # 004f8603
    add esp, 0x4                                 # 004f8608
L_004f860b:
    # block 0x004f860b: entered by je at 0x004f85db, 2 instruction(s), ends with forward jump to 0x004f8618
    mov eax, 0x1                                 # 004f860b
    jmp.d8 L_004f8618                            # 004f8610
L_004f8612:
    # block 0x004f8612: entered by jne at 0x004f85d0, 2 instruction(s), ends with forward jump to 0x004f8618
    {load} xor eax, eax                          # 004f8612
    jmp.d8 L_004f8618                            # 004f8614
L_004f8616:
    # block 0x004f8616: entered by je at 0x004f8580, 1 instruction(s), falls into the block at 0x004f8618
    {load} xor eax, eax                          # 004f8616
L_004f8618:
    # block 0x004f8618: entered by jmp at 0x004f8610; jmp at 0x004f8614, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004f8618
    pop ebp                                      # 004f861a
    ret                                          # 004f861b

