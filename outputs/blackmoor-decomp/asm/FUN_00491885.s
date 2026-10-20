# FUN_00491885
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00491885
# extent:       0x00491885-0x0049192b (166 code bytes)
# span:         0x00491885-0x0049192b (code 166, tables 0, padding 0)
# sha256:       46609398881e1e043e2317d7d82de6fd9c6464b6b3340f437e853e48f3640278
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_raycast_big_buffer_allocator
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/491885.c.txt, not original source) refers to the data labelled s_CRayCast__CRayCast___constructor_0054ee6c
# name-note:    CRayCast constructor part: frees any old buffer, allocates a 0x26360-byte one and calls FUN_0049192b; failure message names the CRayCast constructor.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_50f3, field_50fc; [ecx + n] field_50f3, field_50fd; [edx + n] field_50f7
# callees:      calls FUN_0051dc6c, FUN_0051dc43, FUN_0052139c, FUN_004c97b4, FUN_0049192b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 44 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_50f3, 0x50f3  # offset +0x50f3
.equ field_50f7, 0x50f7  # offset +0x50f7
.equ field_50fc, 0x50fc  # offset +0x50fc
.equ field_50fd, 0x50fd  # offset +0x50fd

# --- external targets -----------------------------------------------
.set FUN_0049192b, .text + (0x0049192b - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x00491885 - 0x401000
.globl FUN_00491885
FUN_00491885:
    # block 0x00491885: entry, 7 instruction(s), ends with je to 0x004918bf (forward)
    push ebp                                     # 00491885
    {load} mov ebp, esp                          # 00491886
    sub esp, 0xc                                 # 00491888
    mov dword ptr [ebp - local_c], ecx           # 0049188b
    mov eax, dword ptr [ebp - local_c]           # 0049188e
    cmp dword ptr [eax + field_50f3], 0x0        # 00491891
    je.d8 L_004918bf                             # 00491898
    # block 0x0049189a: entered by fall-through of je at 0x00491898, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004918bf
    mov ecx, dword ptr [ebp - local_c]           # 0049189a
    mov edx, dword ptr [ecx + field_50f3]        # 0049189d
    mov dword ptr [ebp - local_4], edx           # 004918a3
    mov eax, dword ptr [ebp - local_4]           # 004918a6
    push eax                                     # 004918a9
    call FUN_0051dc6c                            # 004918aa
    add esp, 0x4                                 # 004918af
    mov ecx, dword ptr [ebp - local_c]           # 004918b2
    mov dword ptr [ecx + field_50f3], 0x0        # 004918b5
L_004918bf:
    # block 0x004918bf: entered by je at 0x00491898, 17 instruction(s), calls FUN_0051dc43, ends with jne to 0x0049191f (forward)
    mov edx, dword ptr [ebp - local_c]           # 004918bf
    mov dword ptr [edx + field_50f7], 0x26360    # 004918c2
    mov eax, dword ptr [ebp - local_c]           # 004918cc
    mov byte ptr [eax + field_50fc], -0x6        # 004918cf
    mov ecx, dword ptr [ebp - local_c]           # 004918d6
    mov byte ptr [ecx + field_50fd], 0x2         # 004918d9
    mov edx, dword ptr [ebp - local_c]           # 004918e0
    mov eax, dword ptr [edx + field_50f7]        # 004918e3
    push eax                                     # 004918e9
    call FUN_0051dc43                            # 004918ea
    add esp, 0x4                                 # 004918ef
    mov dword ptr [ebp - local_8], eax           # 004918f2
    mov ecx, dword ptr [ebp - local_c]           # 004918f5
    mov edx, dword ptr [ebp - local_8]           # 004918f8
    mov dword ptr [ecx + field_50f3], edx        # 004918fb
    cmp dword ptr [ebp - local_8], 0x0           # 00491901
    jne.d8 L_0049191f                            # 00491905
    # block 0x00491907: entered by fall-through of jne at 0x00491905, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x0049191f
    push 0x0                                     # 00491907
    push 0x0                                     # 00491909
    push 0x54ee6c                                # 0049190b
    call FUN_0052139c                            # 00491910
    mov ecx, 0x5cf659                            # 00491915
    call FUN_004c97b4                            # 0049191a
L_0049191f:
    # block 0x0049191f: entered by jne at 0x00491905, 5 instruction(s), calls FUN_0049192b, ends with ret
    mov ecx, dword ptr [ebp - local_c]           # 0049191f
    call FUN_0049192b                            # 00491922
    {load} mov esp, ebp                          # 00491927
    pop ebp                                      # 00491929
    ret                                          # 0049192a

