# FUN_00467c0e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00467c0e
# extent:       0x00467c0e-0x00467d5f (337 code bytes)
# span:         0x00467c0e-0x00467d5f (code 337, tables 0, padding 0)
# sha256:       38a16c5851d71d9c70f920503b805773fd10101533c98254f33a38c6aa9adea9
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m467c0e_lifted
# naming:       native port src/original_methods_fl40.c:m467c0e_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 11 seeds; oracle 82/82 instructions, 12/12 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1aa, field_240, field_24a, field_264; [ecx + n] field_1aa, field_24a, field_264, field_268; [edx + n] field_1aa, field_240, field_246, field_264, field_268; [esi + n] field_1c0, field_1c4
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m467c0e_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 82 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1aa, 0x1aa  # offset +0x1aa
.equ field_1c0, 0x1c0  # offset +0x1c0
.equ field_1c4, 0x1c4  # offset +0x1c4
.equ field_240, 0x240  # offset +0x240
.equ field_246, 0x246  # offset +0x246
.equ field_24a, 0x24a  # offset +0x24a
.equ field_264, 0x264  # offset +0x264
.equ field_268, 0x268  # offset +0x268

# --- external targets -----------------------------------------------

.org 0x00467c0e - 0x401000
.globl FUN_00467c0e
FUN_00467c0e:
    # block 0x00467c0e: entry, 8 instruction(s), ends with je to 0x00467c29 (forward)
    push ebp                                     # 00467c0e
    {load} mov ebp, esp                          # 00467c0f
    push ecx                                     # 00467c11
    push esi                                     # 00467c12
    mov dword ptr [ebp - local_4], ecx           # 00467c13
    mov eax, dword ptr [ebp - local_4]           # 00467c16
    cmp dword ptr [eax + field_240], 0xb         # 00467c19
    je.d8 L_00467c29                             # 00467c20
    # block 0x00467c22: entered by fall-through of je at 0x00467c20, 2 instruction(s), ends with forward jump to 0x00467d5a
    {load} xor eax, eax                          # 00467c22
    jmp.d32 L_00467d5a                           # 00467c24
L_00467c29:
    # block 0x00467c29: entered by je at 0x00467c20, 8 instruction(s), ends with forward jump to 0x00467c77
    mov ecx, dword ptr [ebp - local_4]           # 00467c29
    mov dword ptr [ecx + field_264], 0x0         # 00467c2c
    mov edx, dword ptr [ebp - local_4]           # 00467c36
    mov eax, dword ptr [edx + field_240]         # 00467c39
    sub eax, 0x1                                 # 00467c3f
    mov ecx, dword ptr [ebp - local_4]           # 00467c42
    mov dword ptr [ecx + field_268], eax         # 00467c45
    jmp.d8 L_00467c77                            # 00467c4b
L_00467c4d:
    # block 0x00467c4d: entered by jmp at 0x00467ceb; jmp at 0x00467d4c, 10 instruction(s), falls into the block at 0x00467c77
    mov edx, dword ptr [ebp - local_4]           # 00467c4d
    mov eax, dword ptr [edx + field_264]         # 00467c50
    add eax, 0x1                                 # 00467c56
    mov ecx, dword ptr [ebp - local_4]           # 00467c59
    mov dword ptr [ecx + field_264], eax         # 00467c5c
    mov edx, dword ptr [ebp - local_4]           # 00467c62
    mov eax, dword ptr [edx + field_268]         # 00467c65
    sub eax, 0x1                                 # 00467c6b
    mov ecx, dword ptr [ebp - local_4]           # 00467c6e
    mov dword ptr [ecx + field_268], eax         # 00467c71
L_00467c77:
    # block 0x00467c77: entered by jmp at 0x00467c4b, 5 instruction(s), ends with jge to 0x00467d55 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00467c77
    mov eax, dword ptr [ebp - local_4]           # 00467c7a
    mov ecx, dword ptr [edx + field_264]         # 00467c7d
    cmp ecx, dword ptr [eax + field_240]         # 00467c83
    jge.d32 L_00467d55                           # 00467c89
    # block 0x00467c8f: entered by fall-through of jge at 0x00467c89, 10 instruction(s), ends with jne to 0x00467cf0 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00467c8f
    mov eax, dword ptr [edx + field_264]         # 00467c92
    mov ecx, dword ptr [ebp - local_4]           # 00467c98
    mov edx, dword ptr [ecx + field_1aa]         # 00467c9b
    mov ecx, dword ptr [ebp - local_4]           # 00467ca1
    mov ecx, dword ptr [ecx + field_264]         # 00467ca4
    mov esi, dword ptr [ebp - local_4]           # 00467caa
    mov eax, dword ptr [esi + 8*eax + field_1c0] # 00467cad
    cmp eax, dword ptr [edx + 8*ecx + field_246] # 00467cb4
    jne.d8 L_00467cf0                            # 00467cbb
    # block 0x00467cbd: entered by fall-through of jne at 0x00467cbb, 10 instruction(s), ends with jne to 0x00467cf0 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00467cbd
    mov edx, dword ptr [ecx + field_264]         # 00467cc0
    mov eax, dword ptr [ebp - local_4]           # 00467cc6
    mov ecx, dword ptr [eax + field_1aa]         # 00467cc9
    mov eax, dword ptr [ebp - local_4]           # 00467ccf
    mov eax, dword ptr [eax + field_264]         # 00467cd2
    mov esi, dword ptr [ebp - local_4]           # 00467cd8
    mov edx, dword ptr [esi + 8*edx + field_1c4] # 00467cdb
    cmp edx, dword ptr [ecx + 8*eax + field_24a] # 00467ce2
    jne.d8 L_00467cf0                            # 00467ce9
    # block 0x00467ceb: entered by fall-through of jne at 0x00467ce9, 1 instruction(s), ends with backward jump to 0x00467c4d
    jmp.d32 L_00467c4d                           # 00467ceb
L_00467cf0:
    # block 0x00467cf0: entered by jne at 0x00467cbb; jne at 0x00467ce9, 10 instruction(s), ends with jne to 0x00467d51 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00467cf0
    mov ecx, dword ptr [eax + field_264]         # 00467cf3
    mov edx, dword ptr [ebp - local_4]           # 00467cf9
    mov eax, dword ptr [edx + field_1aa]         # 00467cfc
    mov edx, dword ptr [ebp - local_4]           # 00467d02
    mov edx, dword ptr [edx + field_268]         # 00467d05
    mov esi, dword ptr [ebp - local_4]           # 00467d0b
    mov ecx, dword ptr [esi + 8*ecx + field_1c0] # 00467d0e
    cmp ecx, dword ptr [eax + 8*edx + field_24a] # 00467d15
    jne.d8 L_00467d51                            # 00467d1c
    # block 0x00467d1e: entered by fall-through of jne at 0x00467d1c, 10 instruction(s), ends with jne to 0x00467d51 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00467d1e
    mov eax, dword ptr [edx + field_264]         # 00467d21
    mov ecx, dword ptr [ebp - local_4]           # 00467d27
    mov edx, dword ptr [ecx + field_1aa]         # 00467d2a
    mov ecx, dword ptr [ebp - local_4]           # 00467d30
    mov ecx, dword ptr [ecx + field_268]         # 00467d33
    mov esi, dword ptr [ebp - local_4]           # 00467d39
    mov eax, dword ptr [esi + 8*eax + field_1c4] # 00467d3c
    cmp eax, dword ptr [edx + 8*ecx + field_246] # 00467d43
    jne.d8 L_00467d51                            # 00467d4a
    # block 0x00467d4c: entered by fall-through of jne at 0x00467d4a, 1 instruction(s), ends with backward jump to 0x00467c4d
    jmp.d32 L_00467c4d                           # 00467d4c
L_00467d51:
    # block 0x00467d51: entered by jne at 0x00467d1c; jne at 0x00467d4a, 2 instruction(s), ends with forward jump to 0x00467d5a
    {load} xor eax, eax                          # 00467d51
    jmp.d8 L_00467d5a                            # 00467d53
L_00467d55:
    # block 0x00467d55: entered by jge at 0x00467c89, 1 instruction(s), falls into the block at 0x00467d5a
    mov eax, 0x1                                 # 00467d55
L_00467d5a:
    # block 0x00467d5a: entered by jmp at 0x00467c24; jmp at 0x00467d53, 4 instruction(s), ends with ret
    pop esi                                      # 00467d5a
    {load} mov esp, ebp                          # 00467d5b
    pop ebp                                      # 00467d5d
    ret                                          # 00467d5e

