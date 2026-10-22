# FUN_004eff03
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004eff03
# extent:       0x004eff03-0x004effcb (200 code bytes)
# span:         0x004eff03-0x004effd0 (code 200, tables 0, padding 5)
# sha256:       eb7b42525c1d74365548ec17d20837f7d9de743de4acee284e401f96a7a00bac
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004eff03
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_8, field_10, field_14, field_de; [ecx + n] field_8, field_c, field_10, field_de; [edx + n] field_10
# callees:      calls FUN_004c5377, FUN_004c5d4b
# track-n:      outputs/blackmoor-decomp/src/caption_lifecycle.c:slider_visual_valid (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 63 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_de, 0xde  # offset +0xde

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)

.org 0x004eff03 - 0x401000
.globl FUN_004eff03
FUN_004eff03:
    # block 0x004eff03: entry, 7 instruction(s), ends with jne to 0x004eff18 (forward)
    push ebp                                     # 004eff03
    {load} mov ebp, esp                          # 004eff04
    push ecx                                     # 004eff06
    mov dword ptr [ebp - local_4], ecx           # 004eff07
    mov eax, dword ptr [ebp - local_4]           # 004eff0a
    cmp dword ptr [eax + field_10], 0x4          # 004eff0d
    jne.d8 L_004eff18                            # 004eff11
    # block 0x004eff13: entered by fall-through of jne at 0x004eff11, 1 instruction(s), ends with forward jump to 0x004effc7
    jmp.d32 L_004effc7                           # 004eff13
L_004eff18:
    # block 0x004eff18: entered by jne at 0x004eff11, 17 instruction(s), calls FUN_004c5377, ends with jne to 0x004eff8d (forward)
    push 0x55cef0                                # 004eff18
    mov ecx, dword ptr [ebp - local_4]           # 004eff1d
    add ecx, 0x12e                               # 004eff20
    push ecx                                     # 004eff26
    mov edx, dword ptr [ebp - local_4]           # 004eff27
    add edx, 0x9e                                # 004eff2a
    push edx                                     # 004eff30
    mov eax, dword ptr [0x5cf665]                # 004eff31
    push eax                                     # 004eff36
    mov ecx, dword ptr [ebp - local_4]           # 004eff37
    mov edx, dword ptr [ecx + field_c]           # 004eff3a
    push edx                                     # 004eff3d
    mov ecx, 0x5cf659                            # 004eff3e
    call FUN_004c5377                            # 004eff43
    mov eax, dword ptr [ebp - local_4]           # 004eff48
    cmp dword ptr [eax + field_14], 0x1          # 004eff4b
    jne.d8 L_004eff8d                            # 004eff4f
    # block 0x004eff51: entered by fall-through of jne at 0x004eff4f, 18 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x004effc7
    push 0x55cf10                                # 004eff51
    mov ecx, dword ptr [ebp - local_4]           # 004eff56
    add ecx, 0x13e                               # 004eff59
    push ecx                                     # 004eff5f
    mov edx, dword ptr [ebp - local_4]           # 004eff60
    mov eax, dword ptr [edx + field_10]          # 004eff63
    shl eax, 0x4                                 # 004eff66
    mov ecx, dword ptr [ebp - local_4]           # 004eff69
    lea edx, [ecx + eax + field_de]              # 004eff6c
    push edx                                     # 004eff73
    mov eax, dword ptr [0x5cf665]                # 004eff74
    push eax                                     # 004eff79
    mov ecx, dword ptr [ebp - local_4]           # 004eff7a
    mov edx, dword ptr [ecx + field_8]           # 004eff7d
    push edx                                     # 004eff80
    mov ecx, 0x5cf659                            # 004eff81
    call FUN_004c5d4b                            # 004eff86
    jmp.d8 L_004effc7                            # 004eff8b
L_004eff8d:
    # block 0x004eff8d: entered by jne at 0x004eff4f, 17 instruction(s), calls FUN_004c5377, falls into the block at 0x004effc7
    push 0x55cf30                                # 004eff8d
    mov eax, dword ptr [ebp - local_4]           # 004eff92
    add eax, 0x13e                               # 004eff95
    push eax                                     # 004eff9a
    mov ecx, dword ptr [ebp - local_4]           # 004eff9b
    mov edx, dword ptr [ecx + field_10]          # 004eff9e
    shl edx, 0x4                                 # 004effa1
    mov eax, dword ptr [ebp - local_4]           # 004effa4
    lea ecx, [eax + edx + field_de]              # 004effa7
    push ecx                                     # 004effae
    mov edx, dword ptr [0x5cf665]                # 004effaf
    push edx                                     # 004effb5
    mov eax, dword ptr [ebp - local_4]           # 004effb6
    mov ecx, dword ptr [eax + field_8]           # 004effb9
    push ecx                                     # 004effbc
    mov ecx, 0x5cf659                            # 004effbd
    call FUN_004c5377                            # 004effc2
L_004effc7:
    # block 0x004effc7: entered by jmp at 0x004eff13; jmp at 0x004eff8b, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004effc7
    pop ebp                                      # 004effc9
    ret                                          # 004effca

# --- data items (not part of the function) -------------------------
.org 0x004effcb - 0x401000
PAD_004effcb:  # 5 byte(s) of int3 padding
    .fill 5, 1, 0xcc

