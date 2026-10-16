# FUN_0052229f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052229f
# extent:       0x0052229f-0x00522316 (119 code bytes)
# span:         0x0052229f-0x00522316 (code 119, tables 0, padding 0)
# sha256:       6552abccd0f6918d51b3ff898d54a7f0e616820526a1a3d6bc17e625ddc2cb8c
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052229f
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [esi + n] field_40, field_54, field_5c, field_68, field_6c
# callees:      calls FUN_0051dc6c, FUN_0051dc43, FUN_0050fa90, FUN_00521a86
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 49 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_40, 0x40  # offset +0x40
.equ field_54, 0x54  # offset +0x54
.equ field_5c, 0x5c  # offset +0x5c
.equ field_68, 0x68  # offset +0x68
.equ field_6c, 0x6c  # offset +0x6c

# --- external targets -----------------------------------------------
.set FUN_0050fa90, .text + (0x0050fa90 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)
.set FUN_00521a86, .text + (0x00521a86 - 0x401000)

.org 0x0052229f - 0x401000
.globl FUN_0052229f
FUN_0052229f:
    # block 0x0052229f: entry, 24 instruction(s), calls FUN_0051dc6c, FUN_0051dc43, ends with jle to 0x0052230b (forward)
    push ebp                                     # 0052229f
    {load} mov ebp, esp                          # 005222a0
    push ecx                                     # 005222a2
    push ecx                                     # 005222a3
    push ebx                                     # 005222a4
    push esi                                     # 005222a5
    {load} mov esi, ecx                          # 005222a6
    push edi                                     # 005222a8
    push dword ptr [esi + field_5c]              # 005222a9
    call FUN_0051dc6c                            # 005222ac
    {load} xor ebx, ebx                          # 005222b1
    mov dword ptr [esi + field_5c], ebx          # 005222b3
    mov eax, dword ptr [esi + field_6c]          # 005222b6
    lea eax, [eax + 4*eax]                       # 005222b9
    shl eax, 0x3                                 # 005222bc
    push eax                                     # 005222bf
    call FUN_0051dc43                            # 005222c0
    mov edi, dword ptr [esi + field_40]          # 005222c5
    pop ecx                                      # 005222c8
    mov dword ptr [esi + field_5c], eax          # 005222c9
    and edi, 0x2020                              # 005222cc
    cmp dword ptr [esi + field_6c], ebx          # 005222d2
    pop ecx                                      # 005222d5
    jle.d8 L_0052230b                            # 005222d6
    # block 0x005222d8: entered by fall-through of jle at 0x005222d6, 1 instruction(s), falls into the block at 0x005222db
    mov dword ptr [ebp - local_4], eax           # 005222d8
L_005222db:
    # block 0x005222db: entered by jl at 0x00522309, 17 instruction(s), calls FUN_0050fa90, FUN_00521a86, ends with jl to 0x005222db (backward)
    mov eax, dword ptr [esi + field_68]          # 005222db
    push 0x28                                    # 005222de
    mov eax, dword ptr [eax + 4*ebx]             # 005222e0
    mov dword ptr [ebp - local_8], eax           # 005222e3
    add eax, 0x5c                                # 005222e6
    push eax                                     # 005222e9
    push dword ptr [ebp - local_4]               # 005222ea
    call FUN_0050fa90                            # 005222ed
    mov ecx, dword ptr [ebp - local_8]           # 005222f2
    add esp, 0xc                                 # 005222f5
    push edi                                     # 005222f8
    push dword ptr [ebp - local_4]               # 005222f9
    call FUN_00521a86                            # 005222fc
    add dword ptr [ebp - local_4], 0x28          # 00522301
    inc ebx                                      # 00522305
    cmp ebx, dword ptr [esi + field_6c]          # 00522306
    jl.d8 L_005222db                             # 00522309
L_0052230b:
    # block 0x0052230b: entered by jle at 0x005222d6; fall-through of jl at 0x00522309, 7 instruction(s), ends with ret
    mov eax, dword ptr [esi + field_6c]          # 0052230b
    pop edi                                      # 0052230e
    mov dword ptr [esi + field_54], eax          # 0052230f
    pop esi                                      # 00522312
    pop ebx                                      # 00522313
    leave                                        # 00522314
    ret                                          # 00522315

