# FUN_00454e39
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00454e39
# extent:       0x00454e39-0x00454e70 (55 code bytes)
# span:         0x00454e39-0x00454e70 (code 55, tables 0, padding 0)
# sha256:       d42262c3741a4ca1d919639be0e66668acbc045b2c0bc52a8722542ffffb1ee9
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00454e39
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_150; [ecx + n] field_1c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_150, 0x150  # offset +0x150

# --- external targets -----------------------------------------------

.org 0x00454e39 - 0x401000
.globl FUN_00454e39
FUN_00454e39:
    # block 0x00454e39: entry, 7 instruction(s), ends with je to 0x00454e6c (forward)
    push ebp                                     # 00454e39
    {load} mov ebp, esp                          # 00454e3a
    push ecx                                     # 00454e3c
    mov dword ptr [ebp - local_4], ecx           # 00454e3d
    mov eax, dword ptr [ebp - local_4]           # 00454e40
    cmp dword ptr [eax + field_150], 0x0         # 00454e43
    je.d8 L_00454e6c                             # 00454e4a
    # block 0x00454e4c: entered by fall-through of je at 0x00454e4a, 4 instruction(s), ends with je to 0x00454e6c (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00454e4c
    movsx edx, word ptr [ecx + field_1c]         # 00454e4f
    cmp edx, -0x1                                # 00454e53
    je.d8 L_00454e6c                             # 00454e56
    # block 0x00454e58: entered by fall-through of je at 0x00454e56, 4 instruction(s), falls into the block at 0x00454e6c
    mov eax, dword ptr [ebp - local_4]           # 00454e58
    movsx ecx, word ptr [eax + field_1c]         # 00454e5b
    imul ecx, ecx, 0x4a                          # 00454e5f
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 00454e62
L_00454e6c:
    # block 0x00454e6c: entered by je at 0x00454e4a; je at 0x00454e56, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00454e6c
    pop ebp                                      # 00454e6e
    ret                                          # 00454e6f

