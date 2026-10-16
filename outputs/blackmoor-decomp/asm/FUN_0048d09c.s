# FUN_0048d09c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048d09c
# extent:       0x0048d09c-0x0048d0e5 (73 code bytes)
# span:         0x0048d09c-0x0048d0e5 (code 73, tables 0, padding 0)
# sha256:       b9ed04abda5e20560959328a01564f6f1d8992a22e59ba1e4760e20c3f482631
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0048d09c
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_20; [ecx + n] field_1c; [edx + n] field_1c
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_0048d067
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
.set FUN_0048d067, .text + (0x0048d067 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x0048d09c - 0x401000
.globl FUN_0048d09c
FUN_0048d09c:
    # block 0x0048d09c: entry, 7 instruction(s), ends with je to 0x0048d0bd (forward)
    push ebp                                     # 0048d09c
    {load} mov ebp, esp                          # 0048d09d
    push ecx                                     # 0048d09f
    mov dword ptr [ebp - local_4], ecx           # 0048d0a0
    mov eax, dword ptr [ebp - local_4]           # 0048d0a3
    cmp dword ptr [eax + field_20], 0x0          # 0048d0a6
    je.d8 L_0048d0bd                             # 0048d0aa
    # block 0x0048d0ac: entered by fall-through of je at 0x0048d0aa, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x0048d0bd
    mov ecx, dword ptr [ebp - local_4]           # 0048d0ac
    add ecx, 0x20                                # 0048d0af
    push ecx                                     # 0048d0b2
    mov ecx, 0x5cf659                            # 0048d0b3
    call FUN_004c2dfb                            # 0048d0b8
L_0048d0bd:
    # block 0x0048d0bd: entered by je at 0x0048d0aa, 4 instruction(s), ends with je to 0x0048d0d9 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0048d0bd
    movsx eax, word ptr [edx + field_1c]         # 0048d0c0
    cmp eax, -0x1                                # 0048d0c4
    je.d8 L_0048d0d9                             # 0048d0c7
    # block 0x0048d0c9: entered by fall-through of je at 0x0048d0c7, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x0048d0d9
    mov ecx, dword ptr [ebp - local_4]           # 0048d0c9
    mov dx, word ptr [ecx + field_1c]            # 0048d0cc
    push edx                                     # 0048d0d0
    call FUN_004d3992                            # 0048d0d1
    add esp, 0x4                                 # 0048d0d6
L_0048d0d9:
    # block 0x0048d0d9: entered by je at 0x0048d0c7, 5 instruction(s), calls FUN_0048d067, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 0048d0d9
    call FUN_0048d067                            # 0048d0dc
    {load} mov esp, ebp                          # 0048d0e1
    pop ebp                                      # 0048d0e3
    ret                                          # 0048d0e4

