# FUN_0046e6c1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046e6c1
# extent:       0x0046e6c1-0x0046e7a6 (229 code bytes)
# span:         0x0046e6c1-0x0046e7a6 (code 229, tables 0, padding 0)
# sha256:       eac38401d3d1f42bfe5056d6dbf4f1cc575768830a65cdcf9155875306e5a44f
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m46e6c1_lifted
# naming:       native port src/original_methods_fl40.c:m46e6c1_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 1 seeds; oracle 58/58 instructions, 4/4 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1e, field_28, field_2e, field_46, field_5b, field_87; [ecx + n] field_1c, field_32, field_4e, field_67, field_8c; [edx + n] field_24, field_2c, field_4a, field_53, field_5f
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m46e6c1_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 58 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_2e, 0x2e  # offset +0x2e
.equ field_32, 0x32  # offset +0x32
.equ field_46, 0x46  # offset +0x46
.equ field_4a, 0x4a  # offset +0x4a
.equ field_4e, 0x4e  # offset +0x4e
.equ field_53, 0x53  # offset +0x53
.equ field_5b, 0x5b  # offset +0x5b
.equ field_5f, 0x5f  # offset +0x5f
.equ field_67, 0x67  # offset +0x67
.equ field_87, 0x87  # offset +0x87
.equ field_8c, 0x8c  # offset +0x8c

# --- external targets -----------------------------------------------

.org 0x0046e6c1 - 0x401000
.globl FUN_0046e6c1
FUN_0046e6c1:
    # block 0x0046e6c1: entry, 32 instruction(s), ends with forward jump to 0x0046e75b
    push ebp                                     # 0046e6c1
    {load} mov ebp, esp                          # 0046e6c2
    sub esp, 0x8                                 # 0046e6c4
    mov dword ptr [ebp - local_8], ecx           # 0046e6c7
    mov eax, dword ptr [ebp - local_8]           # 0046e6ca
    mov word ptr [eax + field_1e], 0xffff        # 0046e6cd
    mov ecx, dword ptr [ebp - local_8]           # 0046e6d3
    mov word ptr [ecx + field_1c], 0xffff        # 0046e6d6
    mov edx, dword ptr [ebp - local_8]           # 0046e6dc
    mov dword ptr [edx + field_24], 0x0          # 0046e6df
    mov eax, dword ptr [ebp - local_8]           # 0046e6e6
    mov dword ptr [eax + field_46], 0x0          # 0046e6e9
    mov ecx, dword ptr [ebp - local_8]           # 0046e6f0
    mov dword ptr [ecx + field_4e], 0x0          # 0046e6f3
    mov edx, dword ptr [ebp - local_8]           # 0046e6fa
    mov dword ptr [edx + field_4a], 0x0          # 0046e6fd
    mov eax, dword ptr [ebp - local_8]           # 0046e704
    mov dword ptr [eax + field_5b], 0x0          # 0046e707
    mov ecx, dword ptr [ebp - local_8]           # 0046e70e
    mov byte ptr [ecx + field_8c], 0x0           # 0046e711
    mov edx, dword ptr [ebp - local_8]           # 0046e718
    mov dword ptr [edx + field_5f], 0x0          # 0046e71b
    mov eax, dword ptr [ebp - local_8]           # 0046e722
    mov dword ptr [eax + field_28], 0x0          # 0046e725
    mov ecx, dword ptr [ebp - local_8]           # 0046e72c
    mov dword ptr [ecx + field_32], 0x0          # 0046e72f
    mov edx, dword ptr [ebp - local_8]           # 0046e736
    mov word ptr [edx + field_2c], 0xffff        # 0046e739
    mov eax, dword ptr [ebp - local_8]           # 0046e73f
    mov dword ptr [eax + field_2e], 0x0          # 0046e742
    mov dword ptr [ebp - local_4], 0x0           # 0046e749
    jmp.d8 L_0046e75b                            # 0046e750
L_0046e752:
    # block 0x0046e752: entered by jmp at 0x0046e779, 3 instruction(s), falls into the block at 0x0046e75b
    mov ecx, dword ptr [ebp - local_4]           # 0046e752
    add ecx, 0x1                                 # 0046e755
    mov dword ptr [ebp - local_4], ecx           # 0046e758
L_0046e75b:
    # block 0x0046e75b: entered by jmp at 0x0046e750, 2 instruction(s), ends with jge to 0x0046e77b (forward)
    cmp dword ptr [ebp - local_4], 0x8           # 0046e75b
    jge.d8 L_0046e77b                            # 0046e75f
    # block 0x0046e761: entered by fall-through of jge at 0x0046e75f, 7 instruction(s), ends with backward jump to 0x0046e752
    mov edx, dword ptr [ebp - local_8]           # 0046e761
    add edx, dword ptr [ebp - local_4]           # 0046e764
    mov byte ptr [edx + field_53], 0x0           # 0046e767
    mov eax, dword ptr [ebp - local_4]           # 0046e76b
    mov ecx, dword ptr [ebp - local_8]           # 0046e76e
    mov dword ptr [ecx + 4*eax + field_67], 0x0  # 0046e771
    jmp.d8 L_0046e752                            # 0046e779
L_0046e77b:
    # block 0x0046e77b: entered by jge at 0x0046e75f, 2 instruction(s), ends with forward jump to 0x0046e78d
    mov dword ptr [ebp - local_4], 0x0           # 0046e77b
    jmp.d8 L_0046e78d                            # 0046e782
L_0046e784:
    # block 0x0046e784: entered by jmp at 0x0046e7a0, 3 instruction(s), falls into the block at 0x0046e78d
    mov edx, dword ptr [ebp - local_4]           # 0046e784
    add edx, 0x1                                 # 0046e787
    mov dword ptr [ebp - local_4], edx           # 0046e78a
L_0046e78d:
    # block 0x0046e78d: entered by jmp at 0x0046e782, 2 instruction(s), ends with jge to 0x0046e7a2 (forward)
    cmp dword ptr [ebp - local_4], 0x5           # 0046e78d
    jge.d8 L_0046e7a2                            # 0046e791
    # block 0x0046e793: entered by fall-through of jge at 0x0046e791, 4 instruction(s), ends with backward jump to 0x0046e784
    mov eax, dword ptr [ebp - local_8]           # 0046e793
    add eax, dword ptr [ebp - local_4]           # 0046e796
    mov byte ptr [eax + field_87], 0x0           # 0046e799
    jmp.d8 L_0046e784                            # 0046e7a0
L_0046e7a2:
    # block 0x0046e7a2: entered by jge at 0x0046e791, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0046e7a2
    pop ebp                                      # 0046e7a4
    ret                                          # 0046e7a5

