# FUN_00425f25
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00425f25
# extent:       0x00425f25-0x00425f62 (61 code bytes)
# span:         0x00425f25-0x00425f70 (code 61, tables 0, padding 14)
# sha256:       eee09ee0cee5f987dbfe0c1d441562df9ab9b828d358a0b863531c8780cc9acd
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m425f25_lifted
# naming:       native port src/original_methods_fl40.c:m425f25_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 2 seeds; oracle: 22/22 instructions executed, 2/2 conditional-jump directions taken, callees as recording stubs.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m425f25_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 22 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x00425f25 - 0x401000
.globl FUN_00425f25
FUN_00425f25:
    # block 0x00425f25: entry, 6 instruction(s), ends with forward jump to 0x00425f40
    push ebp                                     # 00425f25
    {load} mov ebp, esp                          # 00425f26
    sub esp, 0x8                                 # 00425f28
    mov dword ptr [ebp - local_8], ecx           # 00425f2b
    mov dword ptr [ebp - local_4], 0x0           # 00425f2e
    jmp.d8 L_00425f40                            # 00425f35
L_00425f37:
    # block 0x00425f37: entered by jmp at 0x00425f51, 3 instruction(s), falls into the block at 0x00425f40
    mov eax, dword ptr [ebp - local_4]           # 00425f37
    add eax, 0x1                                 # 00425f3a
    mov dword ptr [ebp - local_4], eax           # 00425f3d
L_00425f40:
    # block 0x00425f40: entered by jmp at 0x00425f35, 3 instruction(s), ends with jge to 0x00425f53 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00425f40
    cmp ecx, dword ptr [ebp + arg_c]             # 00425f43
    jge.d8 L_00425f53                            # 00425f46
    # block 0x00425f48: entered by fall-through of jge at 0x00425f46, 4 instruction(s), ends with backward jump to 0x00425f37
    mov edx, dword ptr [ebp + arg_8]             # 00425f48
    add edx, dword ptr [ebp - local_4]           # 00425f4b
    mov byte ptr [edx], 0x9                      # 00425f4e
    jmp.d8 L_00425f37                            # 00425f51
L_00425f53:
    # block 0x00425f53: entered by jge at 0x00425f46, 6 instruction(s), ends with ret 0x8
    mov eax, dword ptr [ebp + arg_8]             # 00425f53
    add eax, dword ptr [ebp - local_4]           # 00425f56
    mov byte ptr [eax], 0x0                      # 00425f59
    {load} mov esp, ebp                          # 00425f5c
    pop ebp                                      # 00425f5e
    ret 0x8                                      # 00425f5f

# --- data items (not part of the function) -------------------------
.org 0x00425f62 - 0x401000
PAD_00425f62:  # 14 byte(s) of int3 padding
    .fill 14, 1, 0xcc

