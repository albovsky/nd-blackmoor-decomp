# FUN_004e1d34
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e1d34
# extent:       0x004e1d34-0x004e1db3 (127 code bytes)
# span:         0x004e1d34-0x004e1db3 (code 127, tables 0, padding 0)
# sha256:       7bb9d53606a405dd79d685d1ba7212d5adb6e8aa2b903c2964553680f55515c9
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e1d34
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_17f, field_187; [ecx + n] field_28, field_18b; [edx + n] field_24
# callees:      calls FUN_004c2dfb, FUN_004fba69, FUN_004e1c9f
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl18.c:m4e7bf3_close_slots (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 39 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_17f, 0x17f  # offset +0x17f
.equ field_187, 0x187  # offset +0x187
.equ field_18b, 0x18b  # offset +0x18b

# --- external targets -----------------------------------------------
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004e1c9f, .text + (0x004e1c9f - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)

.org 0x004e1d34 - 0x401000
.globl FUN_004e1d34
FUN_004e1d34:
    # block 0x004e1d34: entry, 7 instruction(s), ends with jne to 0x004e1d6d (forward)
    push ebp                                     # 004e1d34
    {load} mov ebp, esp                          # 004e1d35
    push ecx                                     # 004e1d37
    mov dword ptr [ebp - local_4], ecx           # 004e1d38
    mov eax, dword ptr [ebp - local_4]           # 004e1d3b
    cmp dword ptr [eax + field_187], 0x0         # 004e1d3e
    jne.d8 L_004e1d6d                            # 004e1d45
    # block 0x004e1d47: entered by fall-through of jne at 0x004e1d45, 3 instruction(s), ends with jne to 0x004e1d6d (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e1d47
    cmp dword ptr [ecx + field_18b], 0x0         # 004e1d4a
    jne.d8 L_004e1d6d                            # 004e1d51
    # block 0x004e1d53: entered by fall-through of jne at 0x004e1d51, 3 instruction(s), ends with je to 0x004e1d6d (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e1d53
    cmp dword ptr [edx + field_24], 0x0          # 004e1d56
    je.d8 L_004e1d6d                             # 004e1d5a
    # block 0x004e1d5c: entered by fall-through of je at 0x004e1d5a, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004e1d6d
    mov eax, dword ptr [ebp - local_4]           # 004e1d5c
    add eax, 0x24                                # 004e1d5f
    push eax                                     # 004e1d62
    mov ecx, 0x5cf659                            # 004e1d63
    call FUN_004c2dfb                            # 004e1d68
L_004e1d6d:
    # block 0x004e1d6d: entered by jne at 0x004e1d45; jne at 0x004e1d51; je at 0x004e1d5a, 3 instruction(s), ends with je to 0x004e1d87 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e1d6d
    cmp dword ptr [ecx + field_28], 0x0          # 004e1d70
    je.d8 L_004e1d87                             # 004e1d74
    # block 0x004e1d76: entered by fall-through of je at 0x004e1d74, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004e1d87
    mov edx, dword ptr [ebp - local_4]           # 004e1d76
    add edx, 0x28                                # 004e1d79
    push edx                                     # 004e1d7c
    mov ecx, 0x5cf659                            # 004e1d7d
    call FUN_004c2dfb                            # 004e1d82
L_004e1d87:
    # block 0x004e1d87: entered by je at 0x004e1d74, 3 instruction(s), ends with je to 0x004e1da7 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e1d87
    cmp dword ptr [eax + field_17f], 0x0         # 004e1d8a
    je.d8 L_004e1da7                             # 004e1d91
    # block 0x004e1d93: entered by fall-through of je at 0x004e1d91, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004e1da7
    mov ecx, dword ptr [ebp - local_4]           # 004e1d93
    add ecx, 0xf6                                # 004e1d96
    push ecx                                     # 004e1d9c
    mov ecx, 0x5c3a67                            # 004e1d9d
    call FUN_004fba69                            # 004e1da2
L_004e1da7:
    # block 0x004e1da7: entered by je at 0x004e1d91, 5 instruction(s), calls FUN_004e1c9f, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004e1da7
    call FUN_004e1c9f                            # 004e1daa
    {load} mov esp, ebp                          # 004e1daf
    pop ebp                                      # 004e1db1
    ret                                          # 004e1db2

