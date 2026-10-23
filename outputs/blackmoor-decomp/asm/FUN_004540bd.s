# FUN_004540bd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004540bd
# extent:       0x004540bd-0x004541a6 (233 code bytes)
# span:         0x004540bd-0x004541a6 (code 233, tables 0, padding 0)
# sha256:       ae866ebd4a92d9d9a3c03b8190f5a51361a95ecf313d6bf3dc1778e2275ddbcb
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4540bd_lifted
# naming:       native port src/original_methods_fl40.c:m4540bd_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 13 seeds; oracle 69/69 instructions, 18/18 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_4, field_8, field_6a7; [ecx + n] field_4, field_8, field_6a7, field_6ab; [edx + n] field_8, field_6a7
# callees:      calls FUN_004541a6
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m4540bd_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 69 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_6a7, 0x6a7  # offset +0x6a7
.equ field_6ab, 0x6ab  # offset +0x6ab

# --- external targets -----------------------------------------------
.set FUN_004541a6, .text + (0x004541a6 - 0x401000)

.org 0x004540bd - 0x401000
.globl FUN_004540bd
FUN_004540bd:
    # block 0x004540bd: entry, 7 instruction(s), ends with jne to 0x004540d7 (forward)
    push ebp                                     # 004540bd
    {load} mov ebp, esp                          # 004540be
    sub esp, 0x10                                # 004540c0
    mov dword ptr [ebp - local_10], ecx          # 004540c3
    mov eax, dword ptr [ebp - local_10]          # 004540c6
    cmp dword ptr [eax + field_6a7], 0x0         # 004540c9
    jne.d8 L_004540d7                            # 004540d0
    # block 0x004540d2: entered by fall-through of jne at 0x004540d0, 1 instruction(s), ends with forward jump to 0x004541a0
    jmp.d32 L_004541a0                           # 004540d2
L_004540d7:
    # block 0x004540d7: entered by jne at 0x004540d0, 2 instruction(s), ends with jne to 0x004540e2 (forward)
    cmp dword ptr [ebp + arg_8], 0x0             # 004540d7
    jne.d8 L_004540e2                            # 004540db
    # block 0x004540dd: entered by fall-through of jne at 0x004540db, 1 instruction(s), ends with forward jump to 0x004541a0
    jmp.d32 L_004541a0                           # 004540dd
L_004540e2:
    # block 0x004540e2: entered by jne at 0x004540db, 10 instruction(s), ends with jne to 0x0045412f (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004540e2
    mov edx, dword ptr [ecx + field_8]           # 004540e5
    mov dword ptr [ebp - local_c], edx           # 004540e8
    mov eax, dword ptr [ebp + arg_8]             # 004540eb
    mov ecx, dword ptr [eax + field_4]           # 004540ee
    mov dword ptr [ebp - local_8], ecx           # 004540f1
    mov edx, dword ptr [ebp - local_10]          # 004540f4
    mov eax, dword ptr [ebp + arg_8]             # 004540f7
    cmp eax, dword ptr [edx + field_6a7]         # 004540fa
    jne.d8 L_0045412f                            # 00454100
    # block 0x00454102: entered by fall-through of jne at 0x00454100, 2 instruction(s), ends with je to 0x00454120 (forward)
    cmp dword ptr [ebp - local_c], 0x0           # 00454102
    je.d8 L_00454120                             # 00454106
    # block 0x00454108: entered by fall-through of je at 0x00454106, 6 instruction(s), ends with forward jump to 0x0045412d
    mov ecx, dword ptr [ebp - local_10]          # 00454108
    mov edx, dword ptr [ebp - local_c]           # 0045410b
    mov dword ptr [ecx + field_6a7], edx         # 0045410e
    mov eax, dword ptr [ebp - local_c]           # 00454114
    mov dword ptr [eax + field_4], 0x0           # 00454117
    jmp.d8 L_0045412d                            # 0045411e
L_00454120:
    # block 0x00454120: entered by je at 0x00454106, 2 instruction(s), falls into the block at 0x0045412d
    mov ecx, dword ptr [ebp - local_10]          # 00454120
    mov dword ptr [ecx + field_6a7], 0x0         # 00454123
L_0045412d:
    # block 0x0045412d: entered by jmp at 0x0045411e, 1 instruction(s), ends with forward jump to 0x0045415f
    jmp.d8 L_0045415f                            # 0045412d
L_0045412f:
    # block 0x0045412f: entered by jne at 0x00454100, 2 instruction(s), ends with je to 0x0045414f (forward)
    cmp dword ptr [ebp - local_c], 0x0           # 0045412f
    je.d8 L_0045414f                             # 00454133
    # block 0x00454135: entered by fall-through of je at 0x00454133, 2 instruction(s), ends with je to 0x0045414f (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 00454135
    je.d8 L_0045414f                             # 00454139
    # block 0x0045413b: entered by fall-through of je at 0x00454139, 7 instruction(s), ends with forward jump to 0x0045415f
    mov edx, dword ptr [ebp - local_8]           # 0045413b
    mov eax, dword ptr [ebp - local_c]           # 0045413e
    mov dword ptr [edx + field_8], eax           # 00454141
    mov ecx, dword ptr [ebp - local_c]           # 00454144
    mov edx, dword ptr [ebp - local_8]           # 00454147
    mov dword ptr [ecx + field_4], edx           # 0045414a
    jmp.d8 L_0045415f                            # 0045414d
L_0045414f:
    # block 0x0045414f: entered by je at 0x00454133; je at 0x00454139, 2 instruction(s), ends with je to 0x0045415f (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 0045414f
    je.d8 L_0045415f                             # 00454153
    # block 0x00454155: entered by fall-through of je at 0x00454153, 2 instruction(s), falls into the block at 0x0045415f
    mov eax, dword ptr [ebp - local_8]           # 00454155
    mov dword ptr [eax + field_8], 0x0           # 00454158
L_0045415f:
    # block 0x0045415f: entered by jmp at 0x0045412d; jmp at 0x0045414d; je at 0x00454153, 3 instruction(s), ends with je to 0x00454194 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0045415f
    cmp dword ptr [ecx + field_6a7], 0x0         # 00454162
    je.d8 L_00454194                             # 00454169
    # block 0x0045416b: entered by fall-through of je at 0x00454169, 3 instruction(s), falls into the block at 0x00454177
    mov edx, dword ptr [ebp - local_10]          # 0045416b
    mov eax, dword ptr [edx + field_6a7]         # 0045416e
    mov dword ptr [ebp - local_4], eax           # 00454174
L_00454177:
    # block 0x00454177: entered by jmp at 0x00454192, 2 instruction(s), ends with je to 0x00454194 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 00454177
    je.d8 L_00454194                             # 0045417b
    # block 0x0045417d: entered by fall-through of je at 0x0045417b, 7 instruction(s), ends with backward jump to 0x00454177
    mov ecx, dword ptr [ebp - local_10]          # 0045417d
    mov edx, dword ptr [ebp - local_4]           # 00454180
    mov dword ptr [ecx + field_6ab], edx         # 00454183
    mov eax, dword ptr [ebp - local_4]           # 00454189
    mov ecx, dword ptr [eax + field_8]           # 0045418c
    mov dword ptr [ebp - local_4], ecx           # 0045418f
    jmp.d8 L_00454177                            # 00454192
L_00454194:
    # block 0x00454194: entered by je at 0x00454169; je at 0x0045417b, 4 instruction(s), calls FUN_004541a6, falls into the block at 0x004541a0
    mov edx, dword ptr [ebp + arg_8]             # 00454194
    push edx                                     # 00454197
    mov ecx, dword ptr [ebp - local_10]          # 00454198
    call FUN_004541a6                            # 0045419b
L_004541a0:
    # block 0x004541a0: entered by jmp at 0x004540d2; jmp at 0x004540dd, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004541a0
    pop ebp                                      # 004541a2
    ret 0x4                                      # 004541a3

