# FUN_004ee517
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ee517
# extent:       0x004ee517-0x004ee572 (91 code bytes)
# span:         0x004ee517-0x004ee572 (code 91, tables 0, padding 0)
# sha256:       bdf99bfc4e34cf7469fbe14a958b49b90014e583ea42cf12d614bb64f7c583c4
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ee517
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4af, field_685; [ecx + n] field_4af; [edx + n] field_15f
# callees:      calls FUN_004e26fc
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 28 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_15f, 0x15f  # offset +0x15f
.equ field_4af, 0x4af  # offset +0x4af
.equ field_685, 0x685  # offset +0x685

# --- external targets -----------------------------------------------
.set FUN_004e26fc, .text + (0x004e26fc - 0x401000)

.org 0x004ee517 - 0x401000
.globl FUN_004ee517
FUN_004ee517:
    # block 0x004ee517: entry, 7 instruction(s), ends with je to 0x004ee53a (forward)
    push ebp                                     # 004ee517
    {load} mov ebp, esp                          # 004ee518
    push ecx                                     # 004ee51a
    mov dword ptr [ebp - local_4], ecx           # 004ee51b
    mov eax, dword ptr [ebp - local_4]           # 004ee51e
    cmp dword ptr [eax + field_4af], 0x2         # 004ee521
    je.d8 L_004ee53a                             # 004ee528
    # block 0x004ee52a: entered by fall-through of je at 0x004ee528, 3 instruction(s), ends with je to 0x004ee53a (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ee52a
    cmp dword ptr [ecx + field_4af], 0x3         # 004ee52d
    je.d8 L_004ee53a                             # 004ee534
    # block 0x004ee536: entered by fall-through of je at 0x004ee534, 2 instruction(s), ends with forward jump to 0x004ee56e
    {load} xor eax, eax                          # 004ee536
    jmp.d8 L_004ee56e                            # 004ee538
L_004ee53a:
    # block 0x004ee53a: entered by je at 0x004ee528; je at 0x004ee534, 3 instruction(s), ends with je to 0x004ee56c (forward)
    mov edx, dword ptr [ebp - local_4]           # 004ee53a
    cmp dword ptr [edx + field_15f], 0x0         # 004ee53d
    je.d8 L_004ee56c                             # 004ee544
    # block 0x004ee546: entered by fall-through of je at 0x004ee544, 5 instruction(s), calls FUN_004e26fc, ends with je to 0x004ee56c (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ee546
    add ecx, 0x31c                               # 004ee549
    call FUN_004e26fc                            # 004ee54f
    test eax, eax                                # 004ee554
    je.d8 L_004ee56c                             # 004ee556
    # block 0x004ee558: entered by fall-through of je at 0x004ee556, 4 instruction(s), ends with forward jump to 0x004ee56e
    mov eax, dword ptr [ebp - local_4]           # 004ee558
    mov dword ptr [eax + field_685], 0x1         # 004ee55b
    mov eax, 0x1                                 # 004ee565
    jmp.d8 L_004ee56e                            # 004ee56a
L_004ee56c:
    # block 0x004ee56c: entered by je at 0x004ee544; je at 0x004ee556, 1 instruction(s), falls into the block at 0x004ee56e
    {load} xor eax, eax                          # 004ee56c
L_004ee56e:
    # block 0x004ee56e: entered by jmp at 0x004ee538; jmp at 0x004ee56a, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004ee56e
    pop ebp                                      # 004ee570
    ret                                          # 004ee571

