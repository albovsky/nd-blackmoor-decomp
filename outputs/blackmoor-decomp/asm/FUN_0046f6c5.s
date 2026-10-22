# FUN_0046f6c5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046f6c5
# extent:       0x0046f6c5-0x0046f77c (183 code bytes)
# span:         0x0046f6c5-0x0046f77c (code 183, tables 0, padding 0)
# sha256:       a3a5d41c9689b33b15aec217a33994b9a721deb82411b104a2f9fbd78d576d70
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m46f6c5_lifted
# naming:       native port src/original_methods_fl40.c:m46f6c5_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 3 seeds; oracle: 54/54 instructions executed, 8/8 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_1e, field_53, field_91; [ecx + n] field_21, field_f8f
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m46f6c5_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 54 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_1e, 0x1e  # offset +0x1e
.equ field_21, 0x21  # offset +0x21
.equ field_53, 0x53  # offset +0x53
.equ field_91, 0x91  # offset +0x91
.equ field_f8f, 0xf8f  # offset +0xf8f

# --- external targets -----------------------------------------------

.org 0x0046f6c5 - 0x401000
.globl FUN_0046f6c5
FUN_0046f6c5:
    # block 0x0046f6c5: entry, 12 instruction(s), ends with forward jump to 0x0046f6fd
    push ebp                                     # 0046f6c5
    {load} mov ebp, esp                          # 0046f6c6
    sub esp, 0x14                                # 0046f6c8
    mov dword ptr [ebp - local_14], ecx          # 0046f6cb
    mov dword ptr [ebp - local_4], 0x0           # 0046f6ce
    mov eax, dword ptr [ebp - local_14]          # 0046f6d5
    movsx ecx, word ptr [eax + field_1e]         # 0046f6d8
    imul ecx, ecx, 0x8d                          # 0046f6dc
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046f6e2
    mov dword ptr [ebp - local_c], edx           # 0046f6e8
    mov dword ptr [ebp - local_8], 0x0           # 0046f6eb
    jmp.d8 L_0046f6fd                            # 0046f6f2
L_0046f6f4:
    # block 0x0046f6f4: entered by jmp at 0x0046f772, 3 instruction(s), falls into the block at 0x0046f6fd
    mov eax, dword ptr [ebp - local_8]           # 0046f6f4
    add eax, 0x1                                 # 0046f6f7
    mov dword ptr [ebp - local_8], eax           # 0046f6fa
L_0046f6fd:
    # block 0x0046f6fd: entered by jmp at 0x0046f6f2, 4 instruction(s), ends with jge to 0x0046f774 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0046f6fd
    movsx edx, word ptr [ecx + field_f8f]        # 0046f700
    cmp dword ptr [ebp - local_8], edx           # 0046f707
    jge.d8 L_0046f774                            # 0046f70a
    # block 0x0046f70c: entered by fall-through of jge at 0x0046f70a, 3 instruction(s), ends with forward jump to 0x0046f725
    mov dword ptr [ebp - local_4], 0x1           # 0046f70c
    mov dword ptr [ebp - local_10], 0x0          # 0046f713
    jmp.d8 L_0046f725                            # 0046f71a
L_0046f71c:
    # block 0x0046f71c: entered by jmp at 0x0046f764, 3 instruction(s), falls into the block at 0x0046f725
    mov eax, dword ptr [ebp - local_10]          # 0046f71c
    add eax, 0x1                                 # 0046f71f
    mov dword ptr [ebp - local_10], eax          # 0046f722
L_0046f725:
    # block 0x0046f725: entered by jmp at 0x0046f71a, 4 instruction(s), ends with jge to 0x0046f766 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0046f725
    movsx edx, word ptr [ecx + field_21]         # 0046f728
    cmp dword ptr [ebp - local_10], edx          # 0046f72c
    jge.d8 L_0046f766                            # 0046f72f
    # block 0x0046f731: entered by fall-through of jge at 0x0046f72f, 13 instruction(s), ends with je to 0x0046f764 (forward)
    mov eax, dword ptr [ebp - local_14]          # 0046f731
    add eax, dword ptr [ebp - local_10]          # 0046f734
    {load} xor ecx, ecx                          # 0046f737
    mov cl, byte ptr [eax + field_53]            # 0046f739
    mov edx, dword ptr [ebp - local_8]           # 0046f73c
    imul edx, edx, 0xa8                          # 0046f73f
    mov eax, dword ptr [ebp - local_14]          # 0046f745
    mov eax, dword ptr [eax + field_91]          # 0046f748
    {load} add eax, edx                          # 0046f74e
    mov edx, dword ptr [ebp - local_10]          # 0046f750
    movsx eax, word ptr [eax + 2*edx]            # 0046f753
    {load} cmp ecx, eax                          # 0046f757
    je.d8 L_0046f764                             # 0046f759
    # block 0x0046f75b: entered by fall-through of je at 0x0046f759, 2 instruction(s), ends with forward jump to 0x0046f766
    mov dword ptr [ebp - local_4], 0x0           # 0046f75b
    jmp.d8 L_0046f766                            # 0046f762
L_0046f764:
    # block 0x0046f764: entered by je at 0x0046f759, 1 instruction(s), ends with backward jump to 0x0046f71c
    jmp.d8 L_0046f71c                            # 0046f764
L_0046f766:
    # block 0x0046f766: entered by jge at 0x0046f72f; jmp at 0x0046f762, 2 instruction(s), ends with je to 0x0046f772 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 0046f766
    je.d8 L_0046f772                             # 0046f76a
    # block 0x0046f76c: entered by fall-through of je at 0x0046f76a, 2 instruction(s), ends with forward jump to 0x0046f778
    mov ax, word ptr [ebp - local_8]             # 0046f76c
    jmp.d8 L_0046f778                            # 0046f770
L_0046f772:
    # block 0x0046f772: entered by je at 0x0046f76a, 1 instruction(s), ends with backward jump to 0x0046f6f4
    jmp.d8 L_0046f6f4                            # 0046f772
L_0046f774:
    # block 0x0046f774: entered by jge at 0x0046f70a, 1 instruction(s), falls into the block at 0x0046f778
    .insn 0x66, 0x0d, 0xffff{:u16}               # 0046f774
L_0046f778:
    # block 0x0046f778: entered by jmp at 0x0046f770, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0046f778
    pop ebp                                      # 0046f77a
    ret                                          # 0046f77b

