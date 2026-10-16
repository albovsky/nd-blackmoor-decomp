# FUN_004ec44b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ec44b
# extent:       0x004ec44b-0x004ec4b9 (110 code bytes)
# span:         0x004ec44b-0x004ec4b9 (code 110, tables 0, padding 0)
# sha256:       9e73302d12fc9a7cd3f1f9fb86908adb23e1cde82fddf609f4edd0247fb24182
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ec44b
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_28f0; [ecx + n] field_28f2; [edx + n] field_28f0, field_28f2
# callees:      calls KERNEL32.dll!GetTickCount, FUN_004ec1fb
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 31 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_28f0, 0x28f0  # offset +0x28f0
.equ field_28f2, 0x28f2  # offset +0x28f2

# --- external targets -----------------------------------------------
.set FUN_004ec1fb, .text + (0x004ec1fb - 0x401000)

.org 0x004ec44b - 0x401000
.globl FUN_004ec44b
FUN_004ec44b:
    # block 0x004ec44b: entry, 9 instruction(s), ends with je to 0x004ec46f (forward)
    push ebp                                     # 004ec44b
    {load} mov ebp, esp                          # 004ec44c
    sub esp, 0x8                                 # 004ec44e
    mov dword ptr [ebp - local_4], ecx           # 004ec451
    mov eax, dword ptr [ebp - local_4]           # 004ec454
    movsx ecx, word ptr [eax + field_28f0]       # 004ec457
    mov dword ptr [ebp - local_8], ecx           # 004ec45e
    cmp dword ptr [ebp - local_8], 0x1           # 004ec461
    je.d8 L_004ec46f                             # 004ec465
    # block 0x004ec467: entered by fall-through of je at 0x004ec465, 2 instruction(s), ends with je to 0x004ec498 (forward)
    cmp dword ptr [ebp - local_8], 0x2           # 004ec467
    je.d8 L_004ec498                             # 004ec46b
    # block 0x004ec46d: entered by fall-through of je at 0x004ec46b, 1 instruction(s), ends with forward jump to 0x004ec4b5
    jmp.d8 L_004ec4b5                            # 004ec46d
L_004ec46f:
    # block 0x004ec46f: entered by je at 0x004ec465, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jbe to 0x004ec496 (forward)
    call dword ptr [0x52a23c]                    # 004ec46f
    mov edx, dword ptr [ebp - local_4]           # 004ec475
    cmp eax, dword ptr [edx + field_28f2]        # 004ec478
    jbe.d8 L_004ec496                            # 004ec47e
    # block 0x004ec480: entered by fall-through of jbe at 0x004ec47e, 5 instruction(s), calls FUN_004ec1fb, falls into the block at 0x004ec496
    mov eax, dword ptr [ebp - local_4]           # 004ec480
    mov word ptr [eax + field_28f0], 0x2         # 004ec483
    push 0x1                                     # 004ec48c
    mov ecx, dword ptr [ebp - local_4]           # 004ec48e
    call FUN_004ec1fb                            # 004ec491
L_004ec496:
    # block 0x004ec496: entered by jbe at 0x004ec47e, 1 instruction(s), ends with forward jump to 0x004ec4b5
    jmp.d8 L_004ec4b5                            # 004ec496
L_004ec498:
    # block 0x004ec498: entered by je at 0x004ec46b, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jbe to 0x004ec4b5 (forward)
    call dword ptr [0x52a23c]                    # 004ec498
    mov ecx, dword ptr [ebp - local_4]           # 004ec49e
    cmp eax, dword ptr [ecx + field_28f2]        # 004ec4a1
    jbe.d8 L_004ec4b5                            # 004ec4a7
    # block 0x004ec4a9: entered by fall-through of jbe at 0x004ec4a7, 2 instruction(s), falls into the block at 0x004ec4b5
    mov edx, dword ptr [ebp - local_4]           # 004ec4a9
    mov word ptr [edx + field_28f0], 0x0         # 004ec4ac
L_004ec4b5:
    # block 0x004ec4b5: entered by jmp at 0x004ec46d; jmp at 0x004ec496; jbe at 0x004ec4a7, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004ec4b5
    pop ebp                                      # 004ec4b7
    ret                                          # 004ec4b8

