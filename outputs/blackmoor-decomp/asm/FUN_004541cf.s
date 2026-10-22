# FUN_004541cf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004541cf
# extent:       0x004541cf-0x00454268 (153 code bytes)
# span:         0x004541cf-0x00454268 (code 153, tables 0, padding 0)
# sha256:       b24db1e8b099823f34d9de4f4b919c916110ad1bb51ff357e1bae0b8a2615161
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4541cf_lifted
# naming:       native port src/original_methods_fl40.c:m4541cf_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py) over the 32-bit address space, 5 seeds; oracle: 47/47 instructions executed, 4/4 conditional-jump directions taken, callees as recording stubs.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_4, field_6ab; [ecx + n] field_8, field_6a7, field_6ab; [edx + n] field_6a7
# callees:      calls FUN_00454268, FUN_004547bc
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m4541cf_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 47 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_6a7, 0x6a7  # offset +0x6a7
.equ field_6ab, 0x6ab  # offset +0x6ab

# --- external targets -----------------------------------------------
.set FUN_00454268, .text + (0x00454268 - 0x401000)
.set FUN_004547bc, .text + (0x004547bc - 0x401000)

.org 0x004541cf - 0x401000
.globl FUN_004541cf
FUN_004541cf:
    # block 0x004541cf: entry, 11 instruction(s), calls FUN_00454268, ends with je to 0x004541f2 (forward)
    push ebp                                     # 004541cf
    {load} mov ebp, esp                          # 004541d0
    sub esp, 0x8                                 # 004541d2
    mov dword ptr [ebp - local_8], ecx           # 004541d5
    mov eax, dword ptr [ebp + arg_8]             # 004541d8
    push eax                                     # 004541db
    mov ecx, dword ptr [ebp - local_8]           # 004541dc
    call FUN_00454268                            # 004541df
    mov dword ptr [ebp - local_4], eax           # 004541e4
    cmp dword ptr [ebp - local_4], 0x0           # 004541e7
    je.d8 L_004541f2                             # 004541eb
    # block 0x004541ed: entered by fall-through of je at 0x004541eb, 2 instruction(s), ends with forward jump to 0x00454262
    mov eax, dword ptr [ebp - local_4]           # 004541ed
    jmp.d8 L_00454262                            # 004541f0
L_004541f2:
    # block 0x004541f2: entered by je at 0x004541eb, 12 instruction(s), calls FUN_004547bc, ends with jne to 0x00454235 (forward)
    mov dword ptr [ebp - local_4], 0x0           # 004541f2
    push 0xc                                     # 004541f9
    lea ecx, [ebp - local_4]                     # 004541fb
    push ecx                                     # 004541fe
    mov ecx, dword ptr [ebp - local_8]           # 004541ff
    call FUN_004547bc                            # 00454202
    mov edx, dword ptr [ebp - local_4]           # 00454207
    mov eax, dword ptr [ebp + arg_8]             # 0045420a
    mov dword ptr [edx], eax                     # 0045420d
    mov ecx, dword ptr [ebp - local_8]           # 0045420f
    cmp dword ptr [ecx + field_6a7], 0x0         # 00454212
    jne.d8 L_00454235                            # 00454219
    # block 0x0045421b: entered by fall-through of jne at 0x00454219, 7 instruction(s), ends with forward jump to 0x0045425f
    mov edx, dword ptr [ebp - local_8]           # 0045421b
    mov eax, dword ptr [ebp - local_4]           # 0045421e
    mov dword ptr [edx + field_6a7], eax         # 00454221
    mov ecx, dword ptr [ebp - local_8]           # 00454227
    mov edx, dword ptr [ebp - local_4]           # 0045422a
    mov dword ptr [ecx + field_6ab], edx         # 0045422d
    jmp.d8 L_0045425f                            # 00454233
L_00454235:
    # block 0x00454235: entered by jne at 0x00454219, 11 instruction(s), falls into the block at 0x0045425f
    mov eax, dword ptr [ebp - local_8]           # 00454235
    mov ecx, dword ptr [eax + field_6ab]         # 00454238
    mov edx, dword ptr [ebp - local_4]           # 0045423e
    mov dword ptr [ecx + field_8], edx           # 00454241
    mov eax, dword ptr [ebp - local_4]           # 00454244
    mov ecx, dword ptr [ebp - local_8]           # 00454247
    mov edx, dword ptr [ecx + field_6ab]         # 0045424a
    mov dword ptr [eax + field_4], edx           # 00454250
    mov eax, dword ptr [ebp - local_8]           # 00454253
    mov ecx, dword ptr [ebp - local_4]           # 00454256
    mov dword ptr [eax + field_6ab], ecx         # 00454259
L_0045425f:
    # block 0x0045425f: entered by jmp at 0x00454233, 1 instruction(s), falls into the block at 0x00454262
    mov eax, dword ptr [ebp - local_4]           # 0045425f
L_00454262:
    # block 0x00454262: entered by jmp at 0x004541f0, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 00454262
    pop ebp                                      # 00454264
    ret 0x4                                      # 00454265

