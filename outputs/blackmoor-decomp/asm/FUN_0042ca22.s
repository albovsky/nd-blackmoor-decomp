# FUN_0042ca22
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042ca22
# extent:       0x0042ca22-0x0042caa8 (134 code bytes)
# span:         0x0042ca22-0x0042caa8 (code 134, tables 0, padding 0)
# sha256:       3dead420bd958c11ea07b07b40a28799798ec3908cd78ce7af62259b78ea33f8
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m42ca22_apply_event_flags
# naming:       native port src/original_methods_fl17.c:m42ca22_apply_event_flags (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m42ca22_apply_event_flags. Direct test plus a differential test against the original bytes (Unicorn), every original instruction reached. Oracle window runs all 134 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_4, field_6d; [ecx + n] field_2; [edx + n] field_2
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl17.c:m42ca22_apply_event_flags (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 42 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ field_6d, 0x6d  # offset +0x6d

# --- external targets -----------------------------------------------

.org 0x0042ca22 - 0x401000
.globl FUN_0042ca22
FUN_0042ca22:
    # block 0x0042ca22: entry, 5 instruction(s), ends with je to 0x0042ca3e (forward)
    push ebp                                     # 0042ca22
    {load} mov ebp, esp                          # 0042ca23
    sub esp, 0x8                                 # 0042ca25
    cmp dword ptr [0x5b4ea5], 0x0                # 0042ca28
    je.d8 L_0042ca3e                             # 0042ca2f
    # block 0x0042ca31: entered by fall-through of je at 0x0042ca2f, 4 instruction(s), ends with jne to 0x0042ca40 (forward)
    mov eax, dword ptr [0x5b4ead]                # 0042ca31
    movsx ecx, word ptr [eax + field_6d]         # 0042ca36
    test ecx, ecx                                # 0042ca3a
    jne.d8 L_0042ca40                            # 0042ca3c
L_0042ca3e:
    # block 0x0042ca3e: entered by je at 0x0042ca2f; fall-through of jne at 0x0042ca3c, 1 instruction(s), ends with forward jump to 0x0042caa4
    jmp.d8 L_0042caa4                            # 0042ca3e
L_0042ca40:
    # block 0x0042ca40: entered by jne at 0x0042ca3c, 2 instruction(s), ends with forward jump to 0x0042ca52
    mov dword ptr [ebp - local_4], 0x0           # 0042ca40
    jmp.d8 L_0042ca52                            # 0042ca47
L_0042ca49:
    # block 0x0042ca49: entered by jmp at 0x0042caa2, 3 instruction(s), falls into the block at 0x0042ca52
    mov edx, dword ptr [ebp - local_4]           # 0042ca49
    add edx, 0x1                                 # 0042ca4c
    mov dword ptr [ebp - local_4], edx           # 0042ca4f
L_0042ca52:
    # block 0x0042ca52: entered by jmp at 0x0042ca47, 4 instruction(s), ends with jge to 0x0042caa4 (forward)
    mov eax, dword ptr [0x5b4ead]                # 0042ca52
    movsx ecx, word ptr [eax + field_6d]         # 0042ca57
    cmp dword ptr [ebp - local_4], ecx           # 0042ca5b
    jge.d8 L_0042caa4                            # 0042ca5e
    # block 0x0042ca60: entered by fall-through of jge at 0x0042ca5e, 9 instruction(s), ends with je to 0x0042caa2 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0042ca60
    imul edx, edx, 0x6                           # 0042ca63
    mov eax, dword ptr [0x5b4ea5]                # 0042ca66
    {load} add eax, edx                          # 0042ca6b
    mov dword ptr [ebp - local_8], eax           # 0042ca6d
    mov ecx, dword ptr [ebp - local_8]           # 0042ca70
    movsx edx, word ptr [ecx + field_2]          # 0042ca73
    cmp edx, -0x1                                # 0042ca77
    je.d8 L_0042caa2                             # 0042ca7a
    # block 0x0042ca7c: entered by fall-through of je at 0x0042ca7a, 5 instruction(s), ends with jne to 0x0042caa2 (forward)
    mov eax, dword ptr [ebp - local_8]           # 0042ca7c
    movsx ecx, word ptr [eax]                    # 0042ca7f
    movsx edx, word ptr [0x5b4e00]               # 0042ca82
    {load} cmp ecx, edx                          # 0042ca89
    jne.d8 L_0042caa2                            # 0042ca8b
    # block 0x0042ca8d: entered by fall-through of jne at 0x0042ca8b, 5 instruction(s), falls into the block at 0x0042caa2
    mov eax, dword ptr [ebp - local_8]           # 0042ca8d
    movsx ecx, word ptr [eax + field_4]          # 0042ca90
    mov edx, dword ptr [ebp - local_8]           # 0042ca94
    movsx eax, word ptr [edx + field_2]          # 0042ca97
    mov dword ptr [4*eax + 0x585801], ecx        # 0042ca9b
L_0042caa2:
    # block 0x0042caa2: entered by je at 0x0042ca7a; jne at 0x0042ca8b, 1 instruction(s), ends with backward jump to 0x0042ca49
    jmp.d8 L_0042ca49                            # 0042caa2
L_0042caa4:
    # block 0x0042caa4: entered by jmp at 0x0042ca3e; jge at 0x0042ca5e, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0042caa4
    pop ebp                                      # 0042caa6
    ret                                          # 0042caa7

