# FUN_0046b58a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046b58a
# extent:       0x0046b58a-0x0046b67f (245 code bytes)
# span:         0x0046b58a-0x0046b67f (code 245, tables 0, padding 0)
# sha256:       66df3b1d3f0e894eae45c9cca5a1d213714f4656a01bd6b74fa4d7c725b69d32
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m46b58a_lifted
# naming:       native port src/original_methods_fl40.c:m46b58a_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 2 seeds; oracle 51/51 instructions, 2/2 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1e, field_48a4, field_4a24, field_4a34, field_4a52, field_4a59; [ecx + n] field_1c, field_48a0, field_4a28, field_4a2c, field_4a38, field_4a50; [edx + n] field_4a30, field_4a48, field_4a4c, field_4a54
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m46b58a_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 51 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_48a0, 0x48a0  # offset +0x48a0
.equ field_48a4, 0x48a4  # offset +0x48a4
.equ field_4a24, 0x4a24  # offset +0x4a24
.equ field_4a28, 0x4a28  # offset +0x4a28
.equ field_4a2c, 0x4a2c  # offset +0x4a2c
.equ field_4a30, 0x4a30  # offset +0x4a30
.equ field_4a34, 0x4a34  # offset +0x4a34
.equ field_4a38, 0x4a38  # offset +0x4a38
.equ field_4a48, 0x4a48  # offset +0x4a48
.equ field_4a4c, 0x4a4c  # offset +0x4a4c
.equ field_4a50, 0x4a50  # offset +0x4a50
.equ field_4a52, 0x4a52  # offset +0x4a52
.equ field_4a54, 0x4a54  # offset +0x4a54
.equ field_4a59, 0x4a59  # offset +0x4a59

# --- external targets -----------------------------------------------

.org 0x0046b58a - 0x401000
.globl FUN_0046b58a
FUN_0046b58a:
    # block 0x0046b58a: entry, 34 instruction(s), ends with forward jump to 0x0046b64b
    push ebp                                     # 0046b58a
    {load} mov ebp, esp                          # 0046b58b
    sub esp, 0x8                                 # 0046b58d
    mov dword ptr [ebp - local_8], ecx           # 0046b590
    mov eax, dword ptr [ebp - local_8]           # 0046b593
    mov word ptr [eax + field_1e], 0xffff        # 0046b596
    mov ecx, dword ptr [ebp - local_8]           # 0046b59c
    mov word ptr [ecx + field_1c], 0xffff        # 0046b59f
    mov edx, dword ptr [ebp - local_8]           # 0046b5a5
    mov dword ptr [edx + field_4a48], 0x0        # 0046b5a8
    mov eax, dword ptr [ebp - local_8]           # 0046b5b2
    mov word ptr [eax + field_4a52], 0xffff      # 0046b5b5
    mov ecx, dword ptr [ebp - local_8]           # 0046b5be
    mov word ptr [ecx + field_4a50], 0xffff      # 0046b5c1
    mov edx, dword ptr [ebp - local_8]           # 0046b5ca
    mov byte ptr [edx + field_4a54], 0x0         # 0046b5cd
    mov eax, dword ptr [ebp - local_8]           # 0046b5d4
    mov byte ptr [eax + field_4a59], 0x0         # 0046b5d7
    mov ecx, dword ptr [ebp - local_8]           # 0046b5de
    mov dword ptr [ecx + field_4a2c], 0x0        # 0046b5e1
    mov edx, dword ptr [ebp - local_8]           # 0046b5eb
    mov dword ptr [edx + field_4a4c], 0x0        # 0046b5ee
    mov eax, dword ptr [ebp - local_8]           # 0046b5f8
    mov dword ptr [eax + field_4a24], 0x0        # 0046b5fb
    mov ecx, dword ptr [ebp - local_8]           # 0046b605
    mov dword ptr [ecx + field_4a28], 0x0        # 0046b608
    mov edx, dword ptr [ebp - local_8]           # 0046b612
    mov dword ptr [edx + field_4a30], 0x0        # 0046b615
    mov eax, dword ptr [ebp - local_8]           # 0046b61f
    mov dword ptr [eax + field_4a34], 0x0        # 0046b622
    mov ecx, dword ptr [ebp - local_8]           # 0046b62c
    mov dword ptr [ecx + field_4a38], 0x0        # 0046b62f
    mov dword ptr [ebp - local_4], 0x0           # 0046b639
    jmp.d8 L_0046b64b                            # 0046b640
L_0046b642:
    # block 0x0046b642: entered by jmp at 0x0046b679, 3 instruction(s), falls into the block at 0x0046b64b
    mov edx, dword ptr [ebp - local_4]           # 0046b642
    add edx, 0x1                                 # 0046b645
    mov dword ptr [ebp - local_4], edx           # 0046b648
L_0046b64b:
    # block 0x0046b64b: entered by jmp at 0x0046b640, 2 instruction(s), ends with jge to 0x0046b67b (forward)
    cmp dword ptr [ebp - local_4], 0x14          # 0046b64b
    jge.d8 L_0046b67b                            # 0046b64f
    # block 0x0046b651: entered by fall-through of jge at 0x0046b64f, 9 instruction(s), ends with backward jump to 0x0046b642
    mov eax, dword ptr [ebp - local_4]           # 0046b651
    shl eax, 0x4                                 # 0046b654
    mov ecx, dword ptr [ebp - local_8]           # 0046b657
    mov dword ptr [ecx + eax + field_48a0], 0x0  # 0046b65a
    mov edx, dword ptr [ebp - local_4]           # 0046b665
    shl edx, 0x4                                 # 0046b668
    mov eax, dword ptr [ebp - local_8]           # 0046b66b
    mov dword ptr [eax + edx + field_48a4], 0x0  # 0046b66e
    jmp.d8 L_0046b642                            # 0046b679
L_0046b67b:
    # block 0x0046b67b: entered by jge at 0x0046b64f, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0046b67b
    pop ebp                                      # 0046b67d
    ret                                          # 0046b67e

