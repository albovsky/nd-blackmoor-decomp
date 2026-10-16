# FUN_00449bff
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00449bff
# extent:       0x00449bff-0x00449cfc (253 code bytes)
# span:         0x00449bff-0x00449cfc (code 253, tables 0, padding 0)
# sha256:       c27f5aa0b42dfbc2f8981e50b6e9e1e2e604177d0c0a3805bad9e32774e0846c
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00449bff
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_28, field_36; [ecx + n] field_36, field_42; [edx + n] field_3a
# callees:      calls KERNEL32.dll!ResumeThread, FUN_0050ca3e, FUN_0044a2b7, FUN_004264e8, FUN_004c97b4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 77 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_28, 0x28  # offset +0x28
.equ field_36, 0x36  # offset +0x36
.equ field_3a, 0x3a  # offset +0x3a
.equ field_42, 0x42  # offset +0x42

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x00449bff - 0x401000
.globl FUN_00449bff
FUN_00449bff:
    # block 0x00449bff: entry, 7 instruction(s), ends with je to 0x00449cf8 (forward)
    push ebp                                     # 00449bff
    {load} mov ebp, esp                          # 00449c00
    sub esp, 0x10                                # 00449c02
    mov dword ptr [ebp - local_10], ecx          # 00449c05
    mov eax, dword ptr [ebp - local_10]          # 00449c08
    cmp dword ptr [eax + field_36], 0x0          # 00449c0b
    je.d32 L_00449cf8                            # 00449c0f
    # block 0x00449c15: entered by fall-through of je at 0x00449c0f, 11 instruction(s), calls KERNEL32.dll!ResumeThread, ends with je to 0x00449c6a (forward)
    mov ecx, dword ptr [ebp - local_10]          # 00449c15
    mov edx, dword ptr [ecx + field_36]          # 00449c18
    mov dword ptr [ebp - local_8], edx           # 00449c1b
    mov eax, dword ptr [ebp - local_8]           # 00449c1e
    mov ecx, dword ptr [eax + field_28]          # 00449c21
    push ecx                                     # 00449c24
    call dword ptr [0x52a284]                    # 00449c25
    mov dword ptr [ebp - local_4], eax           # 00449c2b
    movsx edx, word ptr [0x63a4cd]               # 00449c2e
    test edx, edx                                # 00449c35
    je.d8 L_00449c6a                             # 00449c37
    # block 0x00449c39: entered by fall-through of je at 0x00449c37, 15 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00449c6a
    mov eax, dword ptr [ebp - local_4]           # 00449c39
    push eax                                     # 00449c3c
    mov ecx, dword ptr [ebp - local_10]          # 00449c3d
    add ecx, 0x4                                 # 00449c40
    push ecx                                     # 00449c43
    mov edx, dword ptr [ebp - local_10]          # 00449c44
    mov eax, dword ptr [edx + field_3a]          # 00449c47
    push eax                                     # 00449c4a
    push 0x5489e4                                # 00449c4b
    push 0x63888b                                # 00449c50
    call FUN_0050ca3e                            # 00449c55
    add esp, 0x14                                # 00449c5a
    push 0x63888b                                # 00449c5d
    call FUN_0044a2b7                            # 00449c62
    add esp, 0x4                                 # 00449c67
L_00449c6a:
    # block 0x00449c6a: entered by je at 0x00449c37, 2 instruction(s), ends with jne to 0x00449c8b (forward)
    cmp dword ptr [ebp - local_4], -0x1          # 00449c6a
    jne.d8 L_00449c8b                            # 00449c6e
    # block 0x00449c70: entered by fall-through of jne at 0x00449c6e, 6 instruction(s), calls FUN_004264e8, FUN_004c97b4, ends with forward jump to 0x00449cf8
    push 0x548a38                                # 00449c70
    mov ecx, 0x583979                            # 00449c75
    call FUN_004264e8                            # 00449c7a
    mov ecx, 0x5cf659                            # 00449c7f
    call FUN_004c97b4                            # 00449c84
    jmp.d8 L_00449cf8                            # 00449c89
L_00449c8b:
    # block 0x00449c8b: entered by jne at 0x00449c6e, 2 instruction(s), ends with jbe to 0x00449cee (forward)
    cmp dword ptr [ebp - local_4], 0x1           # 00449c8b
    jbe.d8 L_00449cee                            # 00449c8f
L_00449c91:
    # block 0x00449c91: entered by jmp at 0x00449cec; fall-through of jbe at 0x00449c8f, 2 instruction(s), ends with jbe to 0x00449cee (forward)
    cmp dword ptr [ebp - local_4], 0x1           # 00449c91
    jbe.d8 L_00449cee                            # 00449c95
    # block 0x00449c97: entered by fall-through of jbe at 0x00449c95, 11 instruction(s), calls KERNEL32.dll!ResumeThread, ends with je to 0x00449cec (forward)
    mov ecx, dword ptr [ebp - local_10]          # 00449c97
    mov edx, dword ptr [ecx + field_36]          # 00449c9a
    mov dword ptr [ebp - local_c], edx           # 00449c9d
    mov eax, dword ptr [ebp - local_c]           # 00449ca0
    mov ecx, dword ptr [eax + field_28]          # 00449ca3
    push ecx                                     # 00449ca6
    call dword ptr [0x52a284]                    # 00449ca7
    mov dword ptr [ebp - local_4], eax           # 00449cad
    movsx edx, word ptr [0x63a4cd]               # 00449cb0
    test edx, edx                                # 00449cb7
    je.d8 L_00449cec                             # 00449cb9
    # block 0x00449cbb: entered by fall-through of je at 0x00449cb9, 15 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00449cec
    mov eax, dword ptr [ebp - local_4]           # 00449cbb
    push eax                                     # 00449cbe
    mov ecx, dword ptr [ebp - local_10]          # 00449cbf
    add ecx, 0x4                                 # 00449cc2
    push ecx                                     # 00449cc5
    mov edx, dword ptr [ebp - local_10]          # 00449cc6
    mov eax, dword ptr [edx + field_3a]          # 00449cc9
    push eax                                     # 00449ccc
    push 0x548a54                                # 00449ccd
    push 0x63888b                                # 00449cd2
    call FUN_0050ca3e                            # 00449cd7
    add esp, 0x14                                # 00449cdc
    push 0x63888b                                # 00449cdf
    call FUN_0044a2b7                            # 00449ce4
    add esp, 0x4                                 # 00449ce9
L_00449cec:
    # block 0x00449cec: entered by je at 0x00449cb9, 1 instruction(s), ends with backward jump to 0x00449c91
    jmp.d8 L_00449c91                            # 00449cec
L_00449cee:
    # block 0x00449cee: entered by jbe at 0x00449c8f; jbe at 0x00449c95, 2 instruction(s), falls into the block at 0x00449cf8
    mov ecx, dword ptr [ebp - local_10]          # 00449cee
    mov dword ptr [ecx + field_42], 0x2          # 00449cf1
L_00449cf8:
    # block 0x00449cf8: entered by je at 0x00449c0f; jmp at 0x00449c89, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00449cf8
    pop ebp                                      # 00449cfa
    ret                                          # 00449cfb

