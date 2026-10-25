# FUN_00455b2e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00455b2e
# extent:       0x00455b2e-0x00455c4f (289 code bytes)
# span:         0x00455b2e-0x00455c4f (code 289, tables 0, padding 0)
# sha256:       76af1a964e76587cf26e18f2217a23c969d4d353fb05e4395ec65c72ccdbaf6b
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m455b2e_lifted
# naming:       native port src/original_methods_fl40.c:m455b2e_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 9 seeds; oracle 78/78 instructions, 8/8 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1e, field_172, field_803; [ecx + n] field_155, field_172, field_7e2, field_8a6; [edx + n] field_172, field_7e2
# callees:      calls FUN_0050cd50, FUN_004fb77a, FUN_004fb2e3, FUN_00448d11
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m455b2e_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 78 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1e, 0x1e  # offset +0x1e
.equ field_155, 0x155  # offset +0x155
.equ field_172, 0x172  # offset +0x172
.equ field_7e2, 0x7e2  # offset +0x7e2
.equ field_803, 0x803  # offset +0x803
.equ field_8a6, 0x8a6  # offset +0x8a6

# --- external targets -----------------------------------------------
.set FUN_00448d11, .text + (0x00448d11 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x00455b2e - 0x401000
.globl FUN_00455b2e
FUN_00455b2e:
    # block 0x00455b2e: entry, 14 instruction(s), calls FUN_0050cd50, ends with jns to 0x00455b60 (forward)
    push ebp                                     # 00455b2e
    {load} mov ebp, esp                          # 00455b2f
    sub esp, 0x8                                 # 00455b31
    push esi                                     # 00455b34
    push edi                                     # 00455b35
    mov dword ptr [ebp - local_8], ecx           # 00455b36
    mov eax, dword ptr [ebp - local_8]           # 00455b39
    movsx ecx, word ptr [eax + field_1e]         # 00455b3c
    imul ecx, ecx, 0x8d                          # 00455b40
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00455b46
    mov dword ptr [ebp - local_4], edx           # 00455b4c
    call FUN_0050cd50                            # 00455b4f
    and eax, 0x80000003                          # 00455b54
    jns.d8 L_00455b60                            # 00455b59
    # block 0x00455b5b: entered by fall-through of jns at 0x00455b59, 3 instruction(s), falls into the block at 0x00455b60
    dec eax                                      # 00455b5b
    or eax, -0x4                                 # 00455b5c
    inc eax                                      # 00455b5f
L_00455b60:
    # block 0x00455b60: entered by jns at 0x00455b59, 12 instruction(s), ends with je to 0x00455c49 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00455b60
    mov word ptr [ecx + field_172], ax           # 00455b63
    mov edi, 0x54a05c                            # 00455b6a
    mov edx, dword ptr [ebp - local_8]           # 00455b6f
    movsx eax, word ptr [edx + field_172]        # 00455b72
    imul eax, eax, 0x31                          # 00455b79
    mov ecx, dword ptr [ebp - local_4]           # 00455b7c
    lea esi, [ecx + eax + field_7e2]             # 00455b7f
    mov ecx, 0x9                                 # 00455b86
    {load} xor edx, edx                          # 00455b8b
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00455b8d
    je.d32 L_00455c49                            # 00455b8f
    # block 0x00455b95: entered by fall-through of je at 0x00455b8f, 18 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with je to 0x00455c3c (forward)
    mov eax, dword ptr [ebp - local_8]           # 00455b95
    movsx ecx, word ptr [eax + field_172]        # 00455b98
    imul ecx, ecx, 0x31                          # 00455b9f
    mov edx, dword ptr [ebp - local_4]           # 00455ba2
    lea eax, [edx + ecx + field_7e2]             # 00455ba5
    push eax                                     # 00455bac
    mov ecx, 0x5c3a67                            # 00455bad
    call FUN_004fb77a                            # 00455bb2
    mov ecx, dword ptr [ebp - local_8]           # 00455bb7
    movsx edx, word ptr [ecx + field_172]        # 00455bba
    imul edx, edx, 0x31                          # 00455bc1
    mov eax, dword ptr [ebp - local_4]           # 00455bc4
    mov cx, word ptr [eax + edx + field_803]     # 00455bc7
    push ecx                                     # 00455bcf
    mov ecx, 0x5c3a67                            # 00455bd0
    call FUN_004fb2e3                            # 00455bd5
    cmp dword ptr [0x5bb202], 0x0                # 00455bda
    je.d8 L_00455c3c                             # 00455be1
    # block 0x00455be3: entered by fall-through of je at 0x00455be1, 12 instruction(s), ends with jbe to 0x00455c3c (forward)
    mov edx, dword ptr [ebp - local_8]           # 00455be3
    movsx eax, word ptr [edx + field_172]        # 00455be6
    imul eax, eax, 0xc8                          # 00455bed
    mov ecx, dword ptr [ebp - local_4]           # 00455bf3
    lea edi, [ecx + eax + field_8a6]             # 00455bf6
    or ecx, -0x1                                 # 00455bfd
    {load} xor eax, eax                          # 00455c00
    repne scasb al, byte ptr es:[edi]            # 00455c02
    not ecx                                      # 00455c04
    add ecx, -0x1                                # 00455c06
    test ecx, ecx                                # 00455c09
    jbe.d8 L_00455c3c                            # 00455c0b
    # block 0x00455c0d: entered by fall-through of jbe at 0x00455c0b, 12 instruction(s), calls FUN_00448d11, falls into the block at 0x00455c3c
    push 0x0                                     # 00455c0d
    push -0x1                                    # 00455c0f
    mov edx, dword ptr [ebp - local_8]           # 00455c11
    movsx eax, word ptr [edx + field_172]        # 00455c14
    imul eax, eax, 0xc8                          # 00455c1b
    mov ecx, dword ptr [ebp - local_4]           # 00455c21
    lea edx, [ecx + eax + field_8a6]             # 00455c24
    push edx                                     # 00455c2b
    mov eax, dword ptr [0x5d03b3]                # 00455c2c
    push eax                                     # 00455c31
    mov ecx, 0x619a05                            # 00455c32
    call FUN_00448d11                            # 00455c37
L_00455c3c:
    # block 0x00455c3c: entered by je at 0x00455be1; jbe at 0x00455c0b, 2 instruction(s), falls into the block at 0x00455c49
    mov ecx, dword ptr [ebp - local_8]           # 00455c3c
    mov dword ptr [ecx + field_155], 0x2         # 00455c3f
L_00455c49:
    # block 0x00455c49: entered by je at 0x00455b8f, 5 instruction(s), ends with ret
    pop edi                                      # 00455c49
    pop esi                                      # 00455c4a
    {load} mov esp, ebp                          # 00455c4b
    pop ebp                                      # 00455c4d
    ret                                          # 00455c4e

