# FUN_004c0ab1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c0ab1
# extent:       0x004c0ab1-0x004c0b8b (218 code bytes)
# span:         0x004c0ab1-0x004c0b8b (code 218, tables 0, padding 0)
# sha256:       a40e159b3a7d57f79b18f5220ea846df81e256c52d86cc7d2ed27bc53329919e
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         triggers
# naming:       native port src/action_family_35_runtime.c:triggers (port_acceptances, ledger class native_tests_only, reviewed 2026-10-15); the note is the acceptance note, a statement about the native port
# name-note:    Static triggers matches branch for branch. The Bink oracle (action_family_35_bink) compares event table and order, 0 mismatches, but the debug-log arm never runs, so tests-only. Frame is a parameter.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_2, field_22e, field_230, field_244; [ecx + n] field_2, field_22a, field_22e, field_244; [edx + n] field_2, field_4
# callees:      calls FUN_0050ca3e, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/action_family_35_runtime.c:triggers (function ledger class native_tests_only; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 62 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ field_22a, 0x22a  # offset +0x22a
.equ field_22e, 0x22e  # offset +0x22e
.equ field_230, 0x230  # offset +0x230
.equ field_244, 0x244  # offset +0x244

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004c0ab1 - 0x401000
.globl FUN_004c0ab1
FUN_004c0ab1:
    # block 0x004c0ab1: entry, 9 instruction(s), ends with forward jump to 0x004c0ad8
    push ebp                                     # 004c0ab1
    {load} mov ebp, esp                          # 004c0ab2
    sub esp, 0xc                                 # 004c0ab4
    mov dword ptr [ebp - local_c], ecx           # 004c0ab7
    mov eax, dword ptr [ebp - local_c]           # 004c0aba
    mov ecx, dword ptr [eax + field_230]         # 004c0abd
    mov dword ptr [ebp - local_8], ecx           # 004c0ac3
    mov dword ptr [ebp - local_4], 0x0           # 004c0ac6
    jmp.d8 L_004c0ad8                            # 004c0acd
L_004c0acf:
    # block 0x004c0acf: entered by jmp at 0x004c0b82, 3 instruction(s), falls into the block at 0x004c0ad8
    mov edx, dword ptr [ebp - local_4]           # 004c0acf
    add edx, 0x1                                 # 004c0ad2
    mov dword ptr [ebp - local_4], edx           # 004c0ad5
L_004c0ad8:
    # block 0x004c0ad8: entered by jmp at 0x004c0acd, 4 instruction(s), ends with jge to 0x004c0b87 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004c0ad8
    movsx ecx, word ptr [eax + field_22e]        # 004c0adb
    cmp dword ptr [ebp - local_4], ecx           # 004c0ae2
    jge.d32 L_004c0b87                           # 004c0ae5
    # block 0x004c0aeb: entered by fall-through of jge at 0x004c0ae5, 6 instruction(s), ends with jne to 0x004c0b67 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004c0aeb
    movsx eax, word ptr [edx]                    # 004c0aee
    mov ecx, dword ptr [ebp - local_c]           # 004c0af1
    movsx edx, word ptr [ecx + field_244]        # 004c0af4
    {load} cmp eax, edx                          # 004c0afb
    jne.d8 L_004c0b67                            # 004c0afd
    # block 0x004c0aff: entered by fall-through of jne at 0x004c0afd, 4 instruction(s), ends with je to 0x004c0b67 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004c0aff
    movsx ecx, word ptr [eax + field_2]          # 004c0b02
    cmp ecx, -0x1                                # 004c0b06
    je.d8 L_004c0b67                             # 004c0b09
    # block 0x004c0b0b: entered by fall-through of je at 0x004c0b09, 8 instruction(s), ends with je to 0x004c0b67 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004c0b0b
    movsx eax, word ptr [edx + field_4]          # 004c0b0e
    mov ecx, dword ptr [ebp - local_8]           # 004c0b12
    movsx edx, word ptr [ecx + field_2]          # 004c0b15
    mov dword ptr [4*edx + 0x585801], eax        # 004c0b19
    movsx eax, word ptr [0x63a4cd]               # 004c0b20
    test eax, eax                                # 004c0b27
    je.d8 L_004c0b67                             # 004c0b29
    # block 0x004c0b2b: entered by fall-through of je at 0x004c0b29, 16 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004c0b67
    mov ecx, dword ptr [ebp - local_c]           # 004c0b2b
    mov edx, dword ptr [ecx + field_22a]         # 004c0b2e
    push edx                                     # 004c0b34
    mov eax, dword ptr [ebp - local_c]           # 004c0b35
    movsx ecx, word ptr [eax + field_244]        # 004c0b38
    push ecx                                     # 004c0b3f
    mov edx, dword ptr [ebp - local_8]           # 004c0b40
    movsx eax, word ptr [edx + field_2]          # 004c0b43
    push eax                                     # 004c0b47
    push 0x552b20                                # 004c0b48
    push 0x63888b                                # 004c0b4d
    call FUN_0050ca3e                            # 004c0b52
    add esp, 0x14                                # 004c0b57
    push 0x63888b                                # 004c0b5a
    call FUN_0044a2b7                            # 004c0b5f
    add esp, 0x4                                 # 004c0b64
L_004c0b67:
    # block 0x004c0b67: entered by jne at 0x004c0afd; je at 0x004c0b09; je at 0x004c0b29, 5 instruction(s), ends with jge to 0x004c0b82 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004c0b67
    movsx edx, word ptr [ecx + field_22e]        # 004c0b6a
    sub edx, 0x1                                 # 004c0b71
    cmp dword ptr [ebp - local_4], edx           # 004c0b74
    jge.d8 L_004c0b82                            # 004c0b77
    # block 0x004c0b79: entered by fall-through of jge at 0x004c0b77, 3 instruction(s), falls into the block at 0x004c0b82
    mov eax, dword ptr [ebp - local_8]           # 004c0b79
    add eax, 0x6                                 # 004c0b7c
    mov dword ptr [ebp - local_8], eax           # 004c0b7f
L_004c0b82:
    # block 0x004c0b82: entered by jge at 0x004c0b77, 1 instruction(s), ends with backward jump to 0x004c0acf
    jmp.d32 L_004c0acf                           # 004c0b82
L_004c0b87:
    # block 0x004c0b87: entered by jge at 0x004c0ae5, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004c0b87
    pop ebp                                      # 004c0b89
    ret                                          # 004c0b8a

