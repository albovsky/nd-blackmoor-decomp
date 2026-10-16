# FUN_0044ecaf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044ecaf
# extent:       0x0044ecaf-0x0044edfb (332 code bytes)
# span:         0x0044ecaf-0x0044edfb (code 332, tables 0, padding 0)
# sha256:       28d3ce2c2cbd7b2c5e30140694f57c09e2cd0b3425cac2eac3be7107c34bb458
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044ecaf
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1e, field_26, field_30; [edx + n] field_26, field_27
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 77 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_26, 0x26  # offset +0x26
.equ field_27, 0x27  # offset +0x27
.equ field_30, 0x30  # offset +0x30

# --- external targets -----------------------------------------------

.org 0x0044ecaf - 0x401000
.globl FUN_0044ecaf
FUN_0044ecaf:
    # block 0x0044ecaf: entry, 12 instruction(s), ends with jne to 0x0044ed30 (forward)
    push ebp                                     # 0044ecaf
    {load} mov ebp, esp                          # 0044ecb0
    sub esp, 0x8                                 # 0044ecb2
    mov dword ptr [ebp - local_8], ecx           # 0044ecb5
    mov eax, dword ptr [ebp - local_8]           # 0044ecb8
    movsx ecx, word ptr [eax + field_1e]         # 0044ecbb
    imul ecx, ecx, 0x8d                          # 0044ecbf
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0044ecc5
    mov dword ptr [ebp - local_4], edx           # 0044eccb
    movsx eax, word ptr [ebp + arg_8]            # 0044ecce
    cmp eax, 0x2787                              # 0044ecd2
    jne.d8 L_0044ed30                            # 0044ecd7
    # block 0x0044ecd9: entered by fall-through of jne at 0x0044ecd7, 14 instruction(s), ends with forward jump to 0x0044edf5
    mov ecx, dword ptr [0x5d0377]                # 0044ecd9
    mov dword ptr [0x5d162d], ecx                # 0044ecdf
    mov dword ptr [0x5b44f0], 0x9                # 0044ece5
    mov dword ptr [0x5b44f4], 0x1                # 0044ecef
    mov edx, dword ptr [0x5b44f0]                # 0044ecf9
    shl edx, 0x5                                 # 0044ecff
    mov eax, dword ptr [0x5b44f4]                # 0044ed02
    shl eax, 0x4                                 # 0044ed07
    lea ecx, [edx + eax + 0x5b160c]              # 0044ed0a
    mov dword ptr [0x5d1631], ecx                # 0044ed11
    mov dword ptr [0x5d1639], 0x1                # 0044ed17
    movsx edx, word ptr [ebp + arg_8]            # 0044ed21
    mov dword ptr [0x5c39e5], edx                # 0044ed25
    jmp.d32 L_0044edf5                           # 0044ed2b
L_0044ed30:
    # block 0x0044ed30: entered by jne at 0x0044ecd7, 3 instruction(s), ends with je to 0x0044ed98 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0044ed30
    cmp eax, 0x2785                              # 0044ed34
    je.d8 L_0044ed98                             # 0044ed39
    # block 0x0044ed3b: entered by fall-through of je at 0x0044ed39, 3 instruction(s), ends with jne to 0x0044ed50 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0044ed3b
    cmp ecx, 0x2786                              # 0044ed3f
    jne.d8 L_0044ed50                            # 0044ed45
    # block 0x0044ed47: entered by fall-through of jne at 0x0044ed45, 3 instruction(s), ends with je to 0x0044ed98 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0044ed47
    cmp edx, 0x2                                 # 0044ed4b
    je.d8 L_0044ed98                             # 0044ed4e
L_0044ed50:
    # block 0x0044ed50: entered by jne at 0x0044ed45; fall-through of je at 0x0044ed4e, 3 instruction(s), ends with jne to 0x0044ed6e (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0044ed50
    cmp eax, 0x2786                              # 0044ed54
    jne.d8 L_0044ed6e                            # 0044ed59
    # block 0x0044ed5b: entered by fall-through of jne at 0x0044ed59, 3 instruction(s), ends with jne to 0x0044ed6e (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0044ed5b
    test ecx, ecx                                # 0044ed5f
    jne.d8 L_0044ed6e                            # 0044ed61
    # block 0x0044ed63: entered by fall-through of jne at 0x0044ed61, 4 instruction(s), ends with jg to 0x0044ed98 (forward)
    mov edx, dword ptr [ebp - local_8]           # 0044ed63
    movsx eax, word ptr [edx + field_26]         # 0044ed66
    test eax, eax                                # 0044ed6a
    jg.d8 L_0044ed98                             # 0044ed6c
L_0044ed6e:
    # block 0x0044ed6e: entered by jne at 0x0044ed59; jne at 0x0044ed61; fall-through of jg at 0x0044ed6c, 3 instruction(s), ends with jne to 0x0044edf5 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0044ed6e
    cmp ecx, 0x2786                              # 0044ed72
    jne.d8 L_0044edf5                            # 0044ed78
    # block 0x0044ed7a: entered by fall-through of jne at 0x0044ed78, 3 instruction(s), ends with jne to 0x0044edf5 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0044ed7a
    cmp edx, 0x1                                 # 0044ed7e
    jne.d8 L_0044edf5                            # 0044ed81
    # block 0x0044ed83: entered by fall-through of jne at 0x0044ed81, 7 instruction(s), ends with jge to 0x0044edf5 (forward)
    mov eax, dword ptr [ebp - local_8]           # 0044ed83
    movsx ecx, word ptr [eax + field_26]         # 0044ed86
    mov edx, dword ptr [ebp - local_4]           # 0044ed8a
    movsx eax, word ptr [edx + field_27]         # 0044ed8d
    sub eax, 0x1                                 # 0044ed91
    {load} cmp ecx, eax                          # 0044ed94
    jge.d8 L_0044edf5                            # 0044ed96
L_0044ed98:
    # block 0x0044ed98: entered by je at 0x0044ed39; je at 0x0044ed4e; jg at 0x0044ed6c; fall-through of jge at 0x0044ed96, 16 instruction(s), falls into the block at 0x0044edf5
    mov dword ptr [0x5b44f0], 0x16               # 0044ed98
    mov dword ptr [0x5b44f4], 0x1                # 0044eda2
    mov ecx, dword ptr [0x5d0377]                # 0044edac
    mov dword ptr [0x5d162d], ecx                # 0044edb2
    mov edx, dword ptr [0x5b44f0]                # 0044edb8
    shl edx, 0x5                                 # 0044edbe
    mov eax, dword ptr [0x5b44f4]                # 0044edc1
    shl eax, 0x4                                 # 0044edc6
    lea ecx, [edx + eax + 0x5b160c]              # 0044edc9
    mov dword ptr [0x5d1631], ecx                # 0044edd0
    mov dword ptr [0x5d1639], 0x1                # 0044edd6
    movsx edx, word ptr [ebp + arg_8]            # 0044ede0
    mov dword ptr [0x5c39e5], edx                # 0044ede4
    mov eax, dword ptr [ebp - local_8]           # 0044edea
    mov cx, word ptr [ebp + arg_c]               # 0044eded
    mov word ptr [eax + field_30], cx            # 0044edf1
L_0044edf5:
    # block 0x0044edf5: entered by jmp at 0x0044ed2b; jne at 0x0044ed78; jne at 0x0044ed81; jge at 0x0044ed96, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 0044edf5
    pop ebp                                      # 0044edf7
    ret 0x8                                      # 0044edf8

