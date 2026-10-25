# FUN_004a0cea
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a0cea
# extent:       0x004a0cea-0x004a0d73 (137 code bytes)
# span:         0x004a0cea-0x004a0d73 (code 137, tables 0, padding 0)
# sha256:       025c71d1da4549e45f7d5af4a3d70ab7c7575a9082a087515f91c8e014240429
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a0cea_lifted
# naming:       native port src/original_methods_fl41.c:m4a0cea_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 12 seeds; oracle: 43/43 instructions, 4/4 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1c; [ecx + n] field_1c, field_20; [edx + n] field_e30, field_e34
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4a0cea_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 43 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_e30, 0xe30  # offset +0xe30
.equ field_e34, 0xe34  # offset +0xe34

# --- external targets -----------------------------------------------

.org 0x004a0cea - 0x401000
.globl FUN_004a0cea
FUN_004a0cea:
    # block 0x004a0cea: entry, 6 instruction(s), ends with forward jump to 0x004a0d05
    push ebp                                     # 004a0cea
    {load} mov ebp, esp                          # 004a0ceb
    sub esp, 0xc                                 # 004a0ced
    mov dword ptr [ebp - local_c], ecx           # 004a0cf0
    mov dword ptr [ebp - local_4], 0x0           # 004a0cf3
    jmp.d8 L_004a0d05                            # 004a0cfa
L_004a0cfc:
    # block 0x004a0cfc: entered by jmp at 0x004a0d6d, 3 instruction(s), falls into the block at 0x004a0d05
    mov eax, dword ptr [ebp - local_4]           # 004a0cfc
    add eax, 0x1                                 # 004a0cff
    mov dword ptr [ebp - local_4], eax           # 004a0d02
L_004a0d05:
    # block 0x004a0d05: entered by jmp at 0x004a0cfa, 4 instruction(s), ends with jge to 0x004a0d6f (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004a0d05
    mov edx, dword ptr [ebp - local_4]           # 004a0d08
    cmp edx, dword ptr [ecx + field_20]          # 004a0d0b
    jge.d8 L_004a0d6f                            # 004a0d0e
    # block 0x004a0d10: entered by fall-through of jge at 0x004a0d0e, 2 instruction(s), ends with forward jump to 0x004a0d22
    mov dword ptr [ebp - local_8], 0x0           # 004a0d10
    jmp.d8 L_004a0d22                            # 004a0d17
L_004a0d19:
    # block 0x004a0d19: entered by jmp at 0x004a0d6b, 3 instruction(s), falls into the block at 0x004a0d22
    mov eax, dword ptr [ebp - local_8]           # 004a0d19
    add eax, 0x1                                 # 004a0d1c
    mov dword ptr [ebp - local_8], eax           # 004a0d1f
L_004a0d22:
    # block 0x004a0d22: entered by jmp at 0x004a0d17, 4 instruction(s), ends with jge to 0x004a0d6d (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004a0d22
    mov edx, dword ptr [ebp - local_8]           # 004a0d25
    cmp edx, dword ptr [ecx + field_1c]          # 004a0d28
    jge.d8 L_004a0d6d                            # 004a0d2b
    # block 0x004a0d2d: entered by fall-through of jge at 0x004a0d2b, 17 instruction(s), ends with backward jump to 0x004a0d19
    mov eax, dword ptr [ebp - local_c]           # 004a0d2d
    mov ecx, dword ptr [ebp - local_4]           # 004a0d30
    imul ecx, dword ptr [eax + field_1c]         # 004a0d33
    mov edx, dword ptr [ebp - local_c]           # 004a0d37
    mov eax, dword ptr [edx + field_e30]         # 004a0d3a
    lea ecx, [eax + 2*ecx]                       # 004a0d40
    mov edx, dword ptr [ebp - local_8]           # 004a0d43
    mov word ptr [ecx + 2*edx], 0xffff           # 004a0d46
    mov eax, dword ptr [ebp - local_c]           # 004a0d4c
    mov ecx, dword ptr [ebp - local_4]           # 004a0d4f
    imul ecx, dword ptr [eax + field_1c]         # 004a0d52
    mov edx, dword ptr [ebp - local_c]           # 004a0d56
    mov eax, dword ptr [edx + field_e34]         # 004a0d59
    lea ecx, [eax + 2*ecx]                       # 004a0d5f
    mov edx, dword ptr [ebp - local_8]           # 004a0d62
    mov word ptr [ecx + 2*edx], 0xffff           # 004a0d65
    jmp.d8 L_004a0d19                            # 004a0d6b
L_004a0d6d:
    # block 0x004a0d6d: entered by jge at 0x004a0d2b, 1 instruction(s), ends with backward jump to 0x004a0cfc
    jmp.d8 L_004a0cfc                            # 004a0d6d
L_004a0d6f:
    # block 0x004a0d6f: entered by jge at 0x004a0d0e, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004a0d6f
    pop ebp                                      # 004a0d71
    ret                                          # 004a0d72

