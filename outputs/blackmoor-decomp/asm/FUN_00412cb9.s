# FUN_00412cb9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00412cb9
# extent:       0x00412cb9-0x00412db8 (255 code bytes)
# span:         0x00412cb9-0x00412db8 (code 255, tables 0, padding 0)
# sha256:       dace0f4096c000670008a7aceb491b5f47fcd23a7420b137905cde02138203bf
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00412cb9
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       10 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_19, local_1a, local_20, local_24
# fields:       [eax + n] field_1; [ecx + n] field_23; [edx + n] field_1
# callees:      calls FUN_0042ba3a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m412cb9_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 72 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_19, 0x19  # offset -0x19
.equ local_1a, 0x1a  # offset -0x1a
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ field_1, 0x1  # offset +0x1
.equ arg_8, 0x8  # offset +0x8
.equ field_23, 0x23  # offset +0x23

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)

.org 0x00412cb9 - 0x401000
.globl FUN_00412cb9
FUN_00412cb9:
    # block 0x00412cb9: entry, 14 instruction(s), ends with forward jump to 0x00412cf6
    push ebp                                     # 00412cb9
    {load} mov ebp, esp                          # 00412cba
    sub esp, 0x24                                # 00412cbc
    mov dword ptr [ebp - local_10], ecx          # 00412cbf
    movsx eax, word ptr [ebp + arg_8]            # 00412cc2
    imul eax, eax, 0x8d                          # 00412cc6
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00412ccc
    mov dword ptr [ebp - local_8], ecx           # 00412cd2
    mov edx, dword ptr [ebp - local_8]           # 00412cd5
    movsx eax, word ptr [edx]                    # 00412cd8
    sub eax, 0x3                                 # 00412cdb
    mov word ptr [ebp - local_c], ax             # 00412cde
    mov word ptr [ebp - local_4], 0x0            # 00412ce2
    jmp.d8 L_00412cf6                            # 00412ce8
L_00412cea:
    # block 0x00412cea: entered by jmp at 0x00412da0, 3 instruction(s), falls into the block at 0x00412cf6
    mov cx, word ptr [ebp - local_4]             # 00412cea
    add cx, 0x1                                  # 00412cee
    mov word ptr [ebp - local_4], cx             # 00412cf2
L_00412cf6:
    # block 0x00412cf6: entered by jmp at 0x00412ce8, 5 instruction(s), ends with jge to 0x00412da5 (forward)
    movsx edx, word ptr [ebp - local_4]          # 00412cf6
    movsx eax, word ptr [ebp - local_c]          # 00412cfa
    movsx ecx, word ptr [2*eax + 0x59fbdb]       # 00412cfe
    {load} cmp edx, ecx                          # 00412d06
    jge.d32 L_00412da5                           # 00412d08
    # block 0x00412d0e: entered by fall-through of jge at 0x00412d08, 9 instruction(s), falls into the block at 0x00412d32
    mov edx, dword ptr [ebp - local_8]           # 00412d0e
    add edx, 0x2                                 # 00412d11
    mov dword ptr [ebp - local_14], edx          # 00412d14
    movsx eax, word ptr [ebp - local_c]          # 00412d17
    imul eax, eax, 0x3390                        # 00412d1b
    movsx ecx, word ptr [ebp - local_4]          # 00412d21
    imul ecx, ecx, 0x21                          # 00412d25
    lea edx, [eax + ecx + 0x5957cb]              # 00412d28
    mov dword ptr [ebp - local_18], edx          # 00412d2f
L_00412d32:
    # block 0x00412d32: entered by jne at 0x00412d64, 6 instruction(s), ends with jne to 0x00412d6f (forward)
    mov eax, dword ptr [ebp - local_18]          # 00412d32
    mov cl, byte ptr [eax]                       # 00412d35
    mov byte ptr [ebp - local_19], cl            # 00412d37
    mov edx, dword ptr [ebp - local_14]          # 00412d3a
    cmp cl, byte ptr [edx]                       # 00412d3d
    jne.d8 L_00412d6f                            # 00412d3f
    # block 0x00412d41: entered by fall-through of jne at 0x00412d3f, 2 instruction(s), ends with je to 0x00412d66 (forward)
    cmp byte ptr [ebp - local_19], 0x0           # 00412d41
    je.d8 L_00412d66                             # 00412d45
    # block 0x00412d47: entered by fall-through of je at 0x00412d45, 6 instruction(s), ends with jne to 0x00412d6f (forward)
    mov eax, dword ptr [ebp - local_18]          # 00412d47
    mov cl, byte ptr [eax + field_1]             # 00412d4a
    mov byte ptr [ebp - local_1a], cl            # 00412d4d
    mov edx, dword ptr [ebp - local_14]          # 00412d50
    cmp cl, byte ptr [edx + field_1]             # 00412d53
    jne.d8 L_00412d6f                            # 00412d56
    # block 0x00412d58: entered by fall-through of jne at 0x00412d56, 4 instruction(s), ends with jne to 0x00412d32 (backward)
    add dword ptr [ebp - local_18], 0x2          # 00412d58
    add dword ptr [ebp - local_14], 0x2          # 00412d5c
    cmp byte ptr [ebp - local_1a], 0x0           # 00412d60
    jne.d8 L_00412d32                            # 00412d64
L_00412d66:
    # block 0x00412d66: entered by je at 0x00412d45; fall-through of jne at 0x00412d64, 2 instruction(s), ends with forward jump to 0x00412d77
    mov dword ptr [ebp - local_20], 0x0          # 00412d66
    jmp.d8 L_00412d77                            # 00412d6d
L_00412d6f:
    # block 0x00412d6f: entered by jne at 0x00412d3f; jne at 0x00412d56, 3 instruction(s), falls into the block at 0x00412d77
    {load} sbb eax, eax                          # 00412d6f
    sbb eax, -0x1                                # 00412d71
    mov dword ptr [ebp - local_20], eax          # 00412d74
L_00412d77:
    # block 0x00412d77: entered by jmp at 0x00412d6d, 4 instruction(s), ends with jne to 0x00412da0 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 00412d77
    mov dword ptr [ebp - local_24], ecx          # 00412d7a
    cmp dword ptr [ebp - local_24], 0x0          # 00412d7d
    jne.d8 L_00412da0                            # 00412d81
    # block 0x00412d83: entered by fall-through of jne at 0x00412d81, 6 instruction(s), falls into the block at 0x00412da0
    movsx edx, word ptr [ebp - local_c]          # 00412d83
    imul edx, edx, 0x320                         # 00412d87
    movsx eax, word ptr [ebp - local_4]          # 00412d8d
    mov ecx, dword ptr [ebp - local_8]           # 00412d91
    mov cx, word ptr [ecx + field_23]            # 00412d94
    mov word ptr [edx + 2*eax + 0x59f27b], cx    # 00412d98
L_00412da0:
    # block 0x00412da0: entered by jne at 0x00412d81, 1 instruction(s), ends with backward jump to 0x00412cea
    jmp.d32 L_00412cea                           # 00412da0
L_00412da5:
    # block 0x00412da5: entered by jge at 0x00412d08, 7 instruction(s), calls FUN_0042ba3a, ends with ret 0x4
    mov dx, word ptr [ebp + arg_8]               # 00412da5
    push edx                                     # 00412da9
    call FUN_0042ba3a                            # 00412daa
    add esp, 0x4                                 # 00412daf
    {load} mov esp, ebp                          # 00412db2
    pop ebp                                      # 00412db4
    ret 0x4                                      # 00412db5

