# FUN_00447c36
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00447c36
# extent:       0x00447c36-0x00447cc4 (142 code bytes)
# span:         0x00447c36-0x00447cc4 (code 142, tables 0, padding 0)
# sha256:       d2e3f7729feb5b06bffab19bd354c9e986a7157465e585e80a87c59a43361bfb
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         session_exit_effect_gate
# naming:       native port src/session_exit.c:session_exit_effect_gate (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-15); the note is the acceptance note, a statement about the native port
# name-note:    Busy and payload-type gate. Oracle gate step compares return, events and cells over the type, stage and state grid, 0 mismatches. Native propagates a controller host failure; the original always returns 1.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1c, field_2d; [ecx + n] field_2d; [edx + n] field_2d, field_49
# callees:      calls FUN_004473be
# track-n:      outputs/blackmoor-decomp/src/session_exit.c:session_exit_effect_gate (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 47 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_2d, 0x2d  # offset +0x2d
.equ field_49, 0x49  # offset +0x49

# --- external targets -----------------------------------------------
.set FUN_004473be, .text + (0x004473be - 0x401000)

.org 0x00447c36 - 0x401000
.globl FUN_00447c36
FUN_00447c36:
    # block 0x00447c36: entry, 9 instruction(s), ends with je to 0x00447cbe (forward)
    push ebp                                     # 00447c36
    {load} mov ebp, esp                          # 00447c37
    sub esp, 0x8                                 # 00447c39
    mov dword ptr [ebp - local_4], ecx           # 00447c3c
    mov eax, dword ptr [ebp - local_4]           # 00447c3f
    {load} xor ecx, ecx                          # 00447c42
    mov cl, byte ptr [eax + field_1c]            # 00447c44
    test ecx, ecx                                # 00447c47
    je.d8 L_00447cbe                             # 00447c49
    # block 0x00447c4b: entered by fall-through of je at 0x00447c49, 5 instruction(s), ends with je to 0x00447c68 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00447c4b
    mov al, byte ptr [edx + field_49]            # 00447c4e
    mov byte ptr [ebp - local_8], al             # 00447c51
    cmp byte ptr [ebp - local_8], 0x1            # 00447c54
    je.d8 L_00447c68                             # 00447c58
    # block 0x00447c5a: entered by fall-through of je at 0x00447c58, 2 instruction(s), ends with jbe to 0x00447cbe (forward)
    cmp byte ptr [ebp - local_8], 0x1            # 00447c5a
    jbe.d8 L_00447cbe                            # 00447c5e
    # block 0x00447c60: entered by fall-through of jbe at 0x00447c5e, 2 instruction(s), ends with jbe to 0x00447c82 (forward)
    cmp byte ptr [ebp - local_8], 0x3            # 00447c60
    jbe.d8 L_00447c82                            # 00447c64
    # block 0x00447c66: entered by fall-through of jbe at 0x00447c64, 1 instruction(s), ends with forward jump to 0x00447cbe
    jmp.d8 L_00447cbe                            # 00447c66
L_00447c68:
    # block 0x00447c68: entered by je at 0x00447c58, 2 instruction(s), ends with jne to 0x00447c80 (forward)
    cmp dword ptr [0x583999], 0x4                # 00447c68
    jne.d8 L_00447c80                            # 00447c6f
    # block 0x00447c71: entered by fall-through of jne at 0x00447c6f, 4 instruction(s), calls FUN_004473be, ends with forward jump to 0x00447cc0
    mov ecx, dword ptr [ebp - local_4]           # 00447c71
    call FUN_004473be                            # 00447c74
    mov eax, 0x1                                 # 00447c79
    jmp.d8 L_00447cc0                            # 00447c7e
L_00447c80:
    # block 0x00447c80: entered by jne at 0x00447c6f, 1 instruction(s), ends with forward jump to 0x00447cbe
    jmp.d8 L_00447cbe                            # 00447c80
L_00447c82:
    # block 0x00447c82: entered by jbe at 0x00447c64, 2 instruction(s), ends with jne to 0x00447c94 (forward)
    cmp dword ptr [0x583999], 0x4                # 00447c82
    jne.d8 L_00447c94                            # 00447c89
    # block 0x00447c8b: entered by fall-through of jne at 0x00447c89, 3 instruction(s), ends with je to 0x00447caf (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00447c8b
    cmp dword ptr [ecx + field_2d], 0x0          # 00447c8e
    je.d8 L_00447caf                             # 00447c92
L_00447c94:
    # block 0x00447c94: entered by jne at 0x00447c89; fall-through of je at 0x00447c92, 2 instruction(s), ends with jne to 0x00447cbe (forward)
    cmp dword ptr [0x583999], 0x3                # 00447c94
    jne.d8 L_00447cbe                            # 00447c9b
    # block 0x00447c9d: entered by fall-through of jne at 0x00447c9b, 3 instruction(s), ends with je to 0x00447caf (forward)
    mov edx, dword ptr [ebp - local_4]           # 00447c9d
    cmp dword ptr [edx + field_2d], 0x1          # 00447ca0
    je.d8 L_00447caf                             # 00447ca4
    # block 0x00447ca6: entered by fall-through of je at 0x00447ca4, 3 instruction(s), ends with jne to 0x00447cbe (forward)
    mov eax, dword ptr [ebp - local_4]           # 00447ca6
    cmp dword ptr [eax + field_2d], 0x2          # 00447ca9
    jne.d8 L_00447cbe                            # 00447cad
L_00447caf:
    # block 0x00447caf: entered by je at 0x00447c92; je at 0x00447ca4; fall-through of jne at 0x00447cad, 4 instruction(s), calls FUN_004473be, ends with forward jump to 0x00447cc0
    mov ecx, dword ptr [ebp - local_4]           # 00447caf
    call FUN_004473be                            # 00447cb2
    mov eax, 0x1                                 # 00447cb7
    jmp.d8 L_00447cc0                            # 00447cbc
L_00447cbe:
    # block 0x00447cbe: entered by je at 0x00447c49; jbe at 0x00447c5e; jmp at 0x00447c66; jmp at 0x00447c80; more, 1 instruction(s), falls into the block at 0x00447cc0
    {load} xor eax, eax                          # 00447cbe
L_00447cc0:
    # block 0x00447cc0: entered by jmp at 0x00447c7e; jmp at 0x00447cbc, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00447cc0
    pop ebp                                      # 00447cc2
    ret                                          # 00447cc3

