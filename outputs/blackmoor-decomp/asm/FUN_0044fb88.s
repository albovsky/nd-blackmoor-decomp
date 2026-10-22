# FUN_0044fb88
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044fb88
# extent:       0x0044fb88-0x0044fbe3 (91 code bytes)
# span:         0x0044fb88-0x0044fbe3 (code 91, tables 0, padding 0)
# sha256:       800580dc9ec0b54d5729da3570d9e3fabd584ac60f5fa6921d59f1bb79a5b5b1
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44fb88_lifted
# naming:       native port src/original_methods_fl40.c:m44fb88_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 6 seeds; oracle: 31/31 instructions executed, 10/10 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_14, field_48; [ecx + n] field_40, field_44; [edx + n] field_3c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m44fb88_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 31 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_14, 0x14  # offset +0x14
.equ field_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_44, 0x44  # offset +0x44
.equ field_48, 0x48  # offset +0x48

# --- external targets -----------------------------------------------

.org 0x0044fb88 - 0x401000
.globl FUN_0044fb88
FUN_0044fb88:
    # block 0x0044fb88: entry, 7 instruction(s), ends with jne to 0x0044fb9f (forward)
    push ebp                                     # 0044fb88
    {load} mov ebp, esp                          # 0044fb89
    push ecx                                     # 0044fb8b
    mov dword ptr [ebp - local_4], ecx           # 0044fb8c
    mov eax, dword ptr [ebp - local_4]           # 0044fb8f
    cmp dword ptr [eax + field_14], 0x0          # 0044fb92
    jne.d8 L_0044fb9f                            # 0044fb96
    # block 0x0044fb98: entered by fall-through of jne at 0x0044fb96, 2 instruction(s), ends with forward jump to 0x0044fbdf
    mov eax, 0x1                                 # 0044fb98
    jmp.d8 L_0044fbdf                            # 0044fb9d
L_0044fb9f:
    # block 0x0044fb9f: entered by jne at 0x0044fb96, 4 instruction(s), ends with jl to 0x0044fbda (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0044fb9f
    mov edx, dword ptr [0x583106]                # 0044fba2
    cmp edx, dword ptr [ecx + field_40]          # 0044fba8
    jl.d8 L_0044fbda                             # 0044fbab
    # block 0x0044fbad: entered by fall-through of jl at 0x0044fbab, 4 instruction(s), ends with jg to 0x0044fbda (forward)
    mov eax, dword ptr [ebp - local_4]           # 0044fbad
    mov ecx, dword ptr [0x58310e]                # 0044fbb0
    cmp ecx, dword ptr [eax + field_48]          # 0044fbb6
    jg.d8 L_0044fbda                             # 0044fbb9
    # block 0x0044fbbb: entered by fall-through of jg at 0x0044fbb9, 4 instruction(s), ends with jl to 0x0044fbda (forward)
    mov edx, dword ptr [ebp - local_4]           # 0044fbbb
    mov eax, dword ptr [0x583102]                # 0044fbbe
    cmp eax, dword ptr [edx + field_3c]          # 0044fbc3
    jl.d8 L_0044fbda                             # 0044fbc6
    # block 0x0044fbc8: entered by fall-through of jl at 0x0044fbc6, 4 instruction(s), ends with jg to 0x0044fbda (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0044fbc8
    mov edx, dword ptr [0x58310a]                # 0044fbcb
    cmp edx, dword ptr [ecx + field_44]          # 0044fbd1
    jg.d8 L_0044fbda                             # 0044fbd4
    # block 0x0044fbd6: entered by fall-through of jg at 0x0044fbd4, 2 instruction(s), ends with forward jump to 0x0044fbdf
    {load} xor eax, eax                          # 0044fbd6
    jmp.d8 L_0044fbdf                            # 0044fbd8
L_0044fbda:
    # block 0x0044fbda: entered by jl at 0x0044fbab; jg at 0x0044fbb9; jl at 0x0044fbc6; jg at 0x0044fbd4, 1 instruction(s), falls into the block at 0x0044fbdf
    mov eax, 0x1                                 # 0044fbda
L_0044fbdf:
    # block 0x0044fbdf: entered by jmp at 0x0044fb9d; jmp at 0x0044fbd8, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0044fbdf
    pop ebp                                      # 0044fbe1
    ret                                          # 0044fbe2

