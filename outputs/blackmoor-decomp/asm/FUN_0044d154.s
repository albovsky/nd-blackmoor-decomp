# FUN_0044d154
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044d154
# extent:       0x0044d154-0x0044d19d (73 code bytes)
# span:         0x0044d154-0x0044d19d (code 73, tables 0, padding 0)
# sha256:       a5e0960dfa0fd46999dac01f36b7dca12e590c248e74c73303658d66fcce6d1e
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044d154
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_20; [ecx + n] field_1c; [edx + n] field_1c
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_0044d107
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 26 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_0044d107, .text + (0x0044d107 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x0044d154 - 0x401000
.globl FUN_0044d154
FUN_0044d154:
    # block 0x0044d154: entry, 7 instruction(s), ends with je to 0x0044d175 (forward)
    push ebp                                     # 0044d154
    {load} mov ebp, esp                          # 0044d155
    push ecx                                     # 0044d157
    mov dword ptr [ebp - local_4], ecx           # 0044d158
    mov eax, dword ptr [ebp - local_4]           # 0044d15b
    cmp dword ptr [eax + field_20], 0x0          # 0044d15e
    je.d8 L_0044d175                             # 0044d162
    # block 0x0044d164: entered by fall-through of je at 0x0044d162, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x0044d175
    mov ecx, dword ptr [ebp - local_4]           # 0044d164
    add ecx, 0x20                                # 0044d167
    push ecx                                     # 0044d16a
    mov ecx, 0x5cf659                            # 0044d16b
    call FUN_004c2dfb                            # 0044d170
L_0044d175:
    # block 0x0044d175: entered by je at 0x0044d162, 4 instruction(s), ends with je to 0x0044d191 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0044d175
    movsx eax, word ptr [edx + field_1c]         # 0044d178
    cmp eax, -0x1                                # 0044d17c
    je.d8 L_0044d191                             # 0044d17f
    # block 0x0044d181: entered by fall-through of je at 0x0044d17f, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x0044d191
    mov ecx, dword ptr [ebp - local_4]           # 0044d181
    mov dx, word ptr [ecx + field_1c]            # 0044d184
    push edx                                     # 0044d188
    call FUN_004d3992                            # 0044d189
    add esp, 0x4                                 # 0044d18e
L_0044d191:
    # block 0x0044d191: entered by je at 0x0044d17f, 5 instruction(s), calls FUN_0044d107, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 0044d191
    call FUN_0044d107                            # 0044d194
    {load} mov esp, ebp                          # 0044d199
    pop ebp                                      # 0044d19b
    ret                                          # 0044d19c

