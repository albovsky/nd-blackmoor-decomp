# FUN_0044e816
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044e816
# extent:       0x0044e816-0x0044e8a2 (140 code bytes)
# span:         0x0044e816-0x0044e8a2 (code 140, tables 0, padding 0)
# sha256:       36b4696cb9fc8762a5bc6717c36e8da3d3c423a92c410f0b19629a7adf14ec6e
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44e816_lifted
# naming:       native port src/original_methods_fl40.c:m44e816_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 3 seeds; oracle: 27/27 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1e, field_236, field_23c; [ecx + n] field_23a; [edx + n] field_238, field_23e
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m44e816_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 27 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1e, 0x1e  # offset +0x1e
.equ field_236, 0x236  # offset +0x236
.equ field_238, 0x238  # offset +0x238
.equ field_23a, 0x23a  # offset +0x23a
.equ field_23c, 0x23c  # offset +0x23c
.equ field_23e, 0x23e  # offset +0x23e

# --- external targets -----------------------------------------------

.org 0x0044e816 - 0x401000
.globl FUN_0044e816
FUN_0044e816:
    # block 0x0044e816: entry, 27 instruction(s), ends with ret
    push ebp                                     # 0044e816
    {load} mov ebp, esp                          # 0044e817
    sub esp, 0x8                                 # 0044e819
    mov dword ptr [ebp - local_8], ecx           # 0044e81c
    mov eax, dword ptr [ebp - local_8]           # 0044e81f
    movsx ecx, word ptr [eax + field_1e]         # 0044e822
    imul ecx, ecx, 0x8d                          # 0044e826
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0044e82c
    mov dword ptr [ebp - local_4], edx           # 0044e832
    mov eax, dword ptr [ebp - local_4]           # 0044e835
    movsx ecx, word ptr [eax + field_236]        # 0044e838
    mov dword ptr [4*ecx + 0x585801], 0x0        # 0044e83f
    mov edx, dword ptr [ebp - local_4]           # 0044e84a
    movsx eax, word ptr [edx + field_238]        # 0044e84d
    mov dword ptr [4*eax + 0x585801], 0x0        # 0044e854
    mov ecx, dword ptr [ebp - local_4]           # 0044e85f
    movsx edx, word ptr [ecx + field_23a]        # 0044e862
    mov dword ptr [4*edx + 0x585801], 0x0        # 0044e869
    mov eax, dword ptr [ebp - local_4]           # 0044e874
    movsx ecx, word ptr [eax + field_23c]        # 0044e877
    mov dword ptr [4*ecx + 0x585801], 0x0        # 0044e87e
    mov edx, dword ptr [ebp - local_4]           # 0044e889
    movsx eax, word ptr [edx + field_23e]        # 0044e88c
    mov dword ptr [4*eax + 0x585801], 0x0        # 0044e893
    {load} mov esp, ebp                          # 0044e89e
    pop ebp                                      # 0044e8a0
    ret                                          # 0044e8a1

