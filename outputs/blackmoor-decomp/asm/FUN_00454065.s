# FUN_00454065
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00454065
# extent:       0x00454065-0x004540bd (88 code bytes)
# span:         0x00454065-0x004540bd (code 88, tables 0, padding 0)
# sha256:       32e58c8405c985f955204b3cd6dd81c784dab92afed4e94c593918f2c8231b08
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m454065_lifted
# naming:       native port src/original_methods_fl40.c:m454065_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 2 seeds; oracle: 30/30 instructions executed, 4/4 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_8, field_6a7; [ecx + n] field_6a7; [edx + n] field_4
# callees:      calls FUN_004541a6
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m454065_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 30 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_6a7, 0x6a7  # offset +0x6a7

# --- external targets -----------------------------------------------
.set FUN_004541a6, .text + (0x004541a6 - 0x401000)

.org 0x00454065 - 0x401000
.globl FUN_00454065
FUN_00454065:
    # block 0x00454065: entry, 7 instruction(s), ends with je to 0x004540a9 (forward)
    push ebp                                     # 00454065
    {load} mov ebp, esp                          # 00454066
    sub esp, 0xc                                 # 00454068
    mov dword ptr [ebp - local_c], ecx           # 0045406b
    mov eax, dword ptr [ebp - local_c]           # 0045406e
    cmp dword ptr [eax + field_6a7], 0x0         # 00454071
    je.d8 L_004540a9                             # 00454078
    # block 0x0045407a: entered by fall-through of je at 0x00454078, 3 instruction(s), falls into the block at 0x00454086
    mov ecx, dword ptr [ebp - local_c]           # 0045407a
    mov edx, dword ptr [ecx + field_6a7]         # 0045407d
    mov dword ptr [ebp - local_4], edx           # 00454083
L_00454086:
    # block 0x00454086: entered by jmp at 0x004540a7, 2 instruction(s), ends with je to 0x004540a9 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 00454086
    je.d8 L_004540a9                             # 0045408a
    # block 0x0045408c: entered by fall-through of je at 0x0045408a, 10 instruction(s), calls FUN_004541a6, ends with backward jump to 0x00454086
    mov eax, dword ptr [ebp - local_4]           # 0045408c
    mov ecx, dword ptr [eax + field_8]           # 0045408f
    mov dword ptr [ebp - local_8], ecx           # 00454092
    mov edx, dword ptr [ebp - local_4]           # 00454095
    push edx                                     # 00454098
    mov ecx, dword ptr [ebp - local_c]           # 00454099
    call FUN_004541a6                            # 0045409c
    mov eax, dword ptr [ebp - local_8]           # 004540a1
    mov dword ptr [ebp - local_4], eax           # 004540a4
    jmp.d8 L_00454086                            # 004540a7
L_004540a9:
    # block 0x004540a9: entered by je at 0x00454078; je at 0x0045408a, 8 instruction(s), ends with ret
    {load} xor ecx, ecx                          # 004540a9
    mov edx, dword ptr [ebp - local_c]           # 004540ab
    add edx, 0x6a7                               # 004540ae
    mov dword ptr [edx], ecx                     # 004540b4
    mov dword ptr [edx + field_4], ecx           # 004540b6
    {load} mov esp, ebp                          # 004540b9
    pop ebp                                      # 004540bb
    ret                                          # 004540bc

