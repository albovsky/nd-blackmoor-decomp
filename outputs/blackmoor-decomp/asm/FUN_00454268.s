# FUN_00454268
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00454268
# extent:       0x00454268-0x004542b5 (77 code bytes)
# span:         0x00454268-0x004542b5 (code 77, tables 0, padding 0)
# sha256:       3a24417f9012d1bde1d018331c2f27d3700cc53f092193d8a73b0263d91ba999
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m454268_lifted
# naming:       native port src/original_methods_fl40.c:m454268_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 10 seeds; oracle 28/28 instructions, 6/6 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_6a7; [ecx + n] field_6a7; [edx + n] field_8
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m454268_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 28 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_6a7, 0x6a7  # offset +0x6a7

# --- external targets -----------------------------------------------

.org 0x00454268 - 0x401000
.globl FUN_00454268
FUN_00454268:
    # block 0x00454268: entry, 7 instruction(s), ends with jne to 0x00454281 (forward)
    push ebp                                     # 00454268
    {load} mov ebp, esp                          # 00454269
    sub esp, 0x8                                 # 0045426b
    mov dword ptr [ebp - local_8], ecx           # 0045426e
    mov eax, dword ptr [ebp - local_8]           # 00454271
    cmp dword ptr [eax + field_6a7], 0x0         # 00454274
    jne.d8 L_00454281                            # 0045427b
    # block 0x0045427d: entered by fall-through of jne at 0x0045427b, 2 instruction(s), ends with forward jump to 0x004542af
    {load} xor eax, eax                          # 0045427d
    jmp.d8 L_004542af                            # 0045427f
L_00454281:
    # block 0x00454281: entered by jne at 0x0045427b, 3 instruction(s), falls into the block at 0x0045428d
    mov ecx, dword ptr [ebp - local_8]           # 00454281
    mov edx, dword ptr [ecx + field_6a7]         # 00454284
    mov dword ptr [ebp - local_4], edx           # 0045428a
L_0045428d:
    # block 0x0045428d: entered by jmp at 0x004542ab, 2 instruction(s), ends with je to 0x004542ad (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 0045428d
    je.d8 L_004542ad                             # 00454291
    # block 0x00454293: entered by fall-through of je at 0x00454291, 4 instruction(s), ends with jne to 0x004542a2 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00454293
    mov ecx, dword ptr [eax]                     # 00454296
    cmp ecx, dword ptr [ebp + arg_8]             # 00454298
    jne.d8 L_004542a2                            # 0045429b
    # block 0x0045429d: entered by fall-through of jne at 0x0045429b, 2 instruction(s), ends with forward jump to 0x004542af
    mov eax, dword ptr [ebp - local_4]           # 0045429d
    jmp.d8 L_004542af                            # 004542a0
L_004542a2:
    # block 0x004542a2: entered by jne at 0x0045429b, 4 instruction(s), ends with backward jump to 0x0045428d
    mov edx, dword ptr [ebp - local_4]           # 004542a2
    mov eax, dword ptr [edx + field_8]           # 004542a5
    mov dword ptr [ebp - local_4], eax           # 004542a8
    jmp.d8 L_0045428d                            # 004542ab
L_004542ad:
    # block 0x004542ad: entered by je at 0x00454291, 1 instruction(s), falls into the block at 0x004542af
    {load} xor eax, eax                          # 004542ad
L_004542af:
    # block 0x004542af: entered by jmp at 0x0045427f; jmp at 0x004542a0, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004542af
    pop ebp                                      # 004542b1
    ret 0x4                                      # 004542b2

