# FUN_00449ba5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00449ba5
# extent:       0x00449ba5-0x00449bff (90 code bytes)
# span:         0x00449ba5-0x00449bff (code 90, tables 0, padding 0)
# sha256:       15fa780209e559a030b83c911f8afc69f42e82aaee7cd249bea46cd884445e31
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m449ba5_lifted
# naming:       native port src/original_methods_fl40.c:m449ba5_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 3 seeds; oracle: 28/28 instructions executed, 4/4 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_28, field_36; [ecx + n] field_36; [edx + n] field_42
# callees:      calls KERNEL32.dll!SuspendThread, FUN_004264e8, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m449ba5_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 28 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_28, 0x28  # offset +0x28
.equ field_36, 0x36  # offset +0x36
.equ field_42, 0x42  # offset +0x42

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)

.org 0x00449ba5 - 0x401000
.globl FUN_00449ba5
FUN_00449ba5:
    # block 0x00449ba5: entry, 7 instruction(s), ends with je to 0x00449bfb (forward)
    push ebp                                     # 00449ba5
    {load} mov ebp, esp                          # 00449ba6
    sub esp, 0xc                                 # 00449ba8
    mov dword ptr [ebp - local_c], ecx           # 00449bab
    mov eax, dword ptr [ebp - local_c]           # 00449bae
    cmp dword ptr [eax + field_36], 0x0          # 00449bb1
    je.d8 L_00449bfb                             # 00449bb5
    # block 0x00449bb7: entered by fall-through of je at 0x00449bb5, 10 instruction(s), calls KERNEL32.dll!SuspendThread, ends with jne to 0x00449bf1 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00449bb7
    mov edx, dword ptr [ecx + field_36]          # 00449bba
    mov dword ptr [ebp - local_4], edx           # 00449bbd
    mov eax, dword ptr [ebp - local_4]           # 00449bc0
    mov ecx, dword ptr [eax + field_28]          # 00449bc3
    push ecx                                     # 00449bc6
    call dword ptr [0x52a27c]                    # 00449bc7
    mov dword ptr [ebp - local_8], eax           # 00449bcd
    cmp dword ptr [ebp - local_8], -0x1          # 00449bd0
    jne.d8 L_00449bf1                            # 00449bd4
    # block 0x00449bd6: entered by fall-through of jne at 0x00449bd4, 6 instruction(s), calls FUN_004264e8, FUN_004c97b4, ends with forward jump to 0x00449bfb
    push 0x5489c8                                # 00449bd6
    mov ecx, 0x583979                            # 00449bdb
    call FUN_004264e8                            # 00449be0
    mov ecx, 0x5cf659                            # 00449be5
    call FUN_004c97b4                            # 00449bea
    jmp.d8 L_00449bfb                            # 00449bef
L_00449bf1:
    # block 0x00449bf1: entered by jne at 0x00449bd4, 2 instruction(s), falls into the block at 0x00449bfb
    mov edx, dword ptr [ebp - local_c]           # 00449bf1
    mov dword ptr [edx + field_42], 0x1          # 00449bf4
L_00449bfb:
    # block 0x00449bfb: entered by je at 0x00449bb5; jmp at 0x00449bef, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00449bfb
    pop ebp                                      # 00449bfd
    ret                                          # 00449bfe

