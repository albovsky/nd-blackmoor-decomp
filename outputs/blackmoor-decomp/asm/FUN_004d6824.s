# FUN_004d6824
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d6824
# extent:       0x004d6824-0x004d696d (329 code bytes)
# span:         0x004d6824-0x004d696d (code 329, tables 0, padding 0)
# sha256:       9d06c021202a269cbafe737d0346b7ff3fc51ac3dd7b28e7eab8ab3fcb0c6647
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d6824
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_954e; [ecx + n] field_1ab, field_1af, field_1b3, field_1b7, field_954e, field_956e; [edx + n] field_954e
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 79 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1ab, 0x1ab  # offset +0x1ab
.equ field_1af, 0x1af  # offset +0x1af
.equ field_1b3, 0x1b3  # offset +0x1b3
.equ field_1b7, 0x1b7  # offset +0x1b7
.equ field_954e, 0x954e  # offset +0x954e
.equ field_956e, 0x956e  # offset +0x956e

# --- external targets -----------------------------------------------

.org 0x004d6824 - 0x401000
.globl FUN_004d6824
FUN_004d6824:
    # block 0x004d6824: entry, 8 instruction(s), ends with forward jump to 0x004d6858
    push ebp                                     # 004d6824
    {load} mov ebp, esp                          # 004d6825
    sub esp, 0x8                                 # 004d6827
    mov dword ptr [ebp - local_8], ecx           # 004d682a
    mov dword ptr [ebp - local_4], 0xffffffff    # 004d682d
    mov eax, dword ptr [ebp - local_8]           # 004d6834
    mov dword ptr [eax + field_954e], 0x0        # 004d6837
    jmp.d8 L_004d6858                            # 004d6841
L_004d6843:
    # block 0x004d6843: entered by jmp at 0x004d6894; jmp at 0x004d6961, 5 instruction(s), falls into the block at 0x004d6858
    mov ecx, dword ptr [ebp - local_8]           # 004d6843
    mov edx, dword ptr [ecx + field_954e]        # 004d6846
    add edx, 0x1                                 # 004d684c
    mov eax, dword ptr [ebp - local_8]           # 004d684f
    mov dword ptr [eax + field_954e], edx        # 004d6852
L_004d6858:
    # block 0x004d6858: entered by jmp at 0x004d6841, 3 instruction(s), ends with jge to 0x004d6966 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004d6858
    cmp dword ptr [ecx + field_954e], 0x5        # 004d685b
    jge.d32 L_004d6966                           # 004d6862
    # block 0x004d6868: entered by fall-through of jge at 0x004d6862, 5 instruction(s), ends with je to 0x004d6894 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004d6868
    mov eax, dword ptr [edx + field_954e]        # 004d686b
    mov ecx, dword ptr [ebp - local_8]           # 004d6871
    cmp dword ptr [ecx + 4*eax + field_956e], 0x0 # 004d6874
    je.d8 L_004d6894                             # 004d687c
    # block 0x004d687e: entered by fall-through of je at 0x004d687c, 5 instruction(s), ends with jne to 0x004d6896 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004d687e
    mov eax, dword ptr [edx + field_954e]        # 004d6881
    mov ecx, dword ptr [ebp - local_8]           # 004d6887
    cmp dword ptr [ecx + 4*eax + field_956e], 0x4 # 004d688a
    jne.d8 L_004d6896                            # 004d6892
L_004d6894:
    # block 0x004d6894: entered by je at 0x004d687c; fall-through of jne at 0x004d6892, 1 instruction(s), ends with backward jump to 0x004d6843
    jmp.d8 L_004d6843                            # 004d6894
L_004d6896:
    # block 0x004d6896: entered by jne at 0x004d6892, 5 instruction(s), ends with je to 0x004d68c2 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004d6896
    mov eax, dword ptr [edx + field_954e]        # 004d6899
    mov ecx, dword ptr [ebp - local_8]           # 004d689f
    cmp dword ptr [ecx + 4*eax + field_956e], 0x2 # 004d68a2
    je.d8 L_004d68c2                             # 004d68aa
    # block 0x004d68ac: entered by fall-through of je at 0x004d68aa, 5 instruction(s), ends with jne to 0x004d68d9 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004d68ac
    mov eax, dword ptr [edx + field_954e]        # 004d68af
    mov ecx, dword ptr [ebp - local_8]           # 004d68b5
    cmp dword ptr [ecx + 4*eax + field_956e], 0x3 # 004d68b8
    jne.d8 L_004d68d9                            # 004d68c0
L_004d68c2:
    # block 0x004d68c2: entered by je at 0x004d68aa; fall-through of jne at 0x004d68c0, 4 instruction(s), falls into the block at 0x004d68d9
    mov edx, dword ptr [ebp - local_8]           # 004d68c2
    mov eax, dword ptr [edx + field_954e]        # 004d68c5
    mov ecx, dword ptr [ebp - local_8]           # 004d68cb
    mov dword ptr [ecx + 4*eax + field_956e], 0x1 # 004d68ce
L_004d68d9:
    # block 0x004d68d9: entered by jne at 0x004d68c0, 7 instruction(s), ends with jg to 0x004d6961 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004d68d9
    mov eax, dword ptr [edx + field_954e]        # 004d68dc
    shl eax, 0x4                                 # 004d68e2
    mov ecx, dword ptr [ebp - local_8]           # 004d68e5
    mov edx, dword ptr [0x583106]                # 004d68e8
    cmp edx, dword ptr [ecx + eax + field_1b7]   # 004d68ee
    jg.d8 L_004d6961                             # 004d68f5
    # block 0x004d68f7: entered by fall-through of jg at 0x004d68f5, 8 instruction(s), ends with jl to 0x004d6961 (forward)
    mov eax, dword ptr [0x58310e]                # 004d68f7
    sub eax, 0xc                                 # 004d68fc
    mov ecx, dword ptr [ebp - local_8]           # 004d68ff
    mov edx, dword ptr [ecx + field_954e]        # 004d6902
    shl edx, 0x4                                 # 004d6908
    mov ecx, dword ptr [ebp - local_8]           # 004d690b
    cmp eax, dword ptr [ecx + edx + field_1af]   # 004d690e
    jl.d8 L_004d6961                             # 004d6915
    # block 0x004d6917: entered by fall-through of jl at 0x004d6915, 7 instruction(s), ends with jg to 0x004d6961 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004d6917
    mov eax, dword ptr [edx + field_954e]        # 004d691a
    shl eax, 0x4                                 # 004d6920
    mov ecx, dword ptr [ebp - local_8]           # 004d6923
    mov edx, dword ptr [0x583102]                # 004d6926
    cmp edx, dword ptr [ecx + eax + field_1b3]   # 004d692c
    jg.d8 L_004d6961                             # 004d6933
    # block 0x004d6935: entered by fall-through of jg at 0x004d6933, 8 instruction(s), ends with jl to 0x004d6961 (forward)
    mov eax, dword ptr [0x58310a]                # 004d6935
    sub eax, 0xa                                 # 004d693a
    mov ecx, dword ptr [ebp - local_8]           # 004d693d
    mov edx, dword ptr [ecx + field_954e]        # 004d6940
    shl edx, 0x4                                 # 004d6946
    mov ecx, dword ptr [ebp - local_8]           # 004d6949
    cmp eax, dword ptr [ecx + edx + field_1ab]   # 004d694c
    jl.d8 L_004d6961                             # 004d6953
    # block 0x004d6955: entered by fall-through of jl at 0x004d6953, 3 instruction(s), falls into the block at 0x004d6961
    mov edx, dword ptr [ebp - local_8]           # 004d6955
    mov eax, dword ptr [edx + field_954e]        # 004d6958
    mov dword ptr [ebp - local_4], eax           # 004d695e
L_004d6961:
    # block 0x004d6961: entered by jg at 0x004d68f5; jl at 0x004d6915; jg at 0x004d6933; jl at 0x004d6953, 1 instruction(s), ends with backward jump to 0x004d6843
    jmp.d32 L_004d6843                           # 004d6961
L_004d6966:
    # block 0x004d6966: entered by jge at 0x004d6862, 4 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_4]           # 004d6966
    {load} mov esp, ebp                          # 004d6969
    pop ebp                                      # 004d696b
    ret                                          # 004d696c

