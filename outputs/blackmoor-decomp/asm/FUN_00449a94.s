# FUN_00449a94
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00449a94
# extent:       0x00449a94-0x00449ba5 (273 code bytes)
# span:         0x00449a94-0x00449ba5 (code 273, tables 0, padding 0)
# sha256:       720b11933709f732ac47abd039c5a915bfaf66ae6ce5a9d33cdefba8cab57d1f
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m449a94_stop_thread
# naming:       native port src/original_methods_fl27b.c:m449a94_stop_thread (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m449a94_stop_thread: the oracle runs every instruction and both directions of every conditional jump (untaken edges only as listed in the handoff). See tasks/fl27b-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_68, local_6c
# fields:       [eax + n] field_36, field_3e; [ecx + n] field_28, field_36, field_3a, field_42; [edx + n] field_24, field_36, field_42, field_78
# callees:      calls FUN_00449bff, KERNEL32.dll!Sleep, KERNEL32.dll!GetExitCodeThread, FUN_00426367, FUN_0044a2b7, FUN_0050ca3e; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      outputs/blackmoor-decomp/src/action_family_3f_runtime.c:phase0 (function ledger class native_oracle_verified; also phase2; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 84 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_68, 0x68  # offset -0x68
.equ local_6c, 0x6c  # offset -0x6c
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_36, 0x36  # offset +0x36
.equ field_3a, 0x3a  # offset +0x3a
.equ field_3e, 0x3e  # offset +0x3e
.equ field_42, 0x42  # offset +0x42
.equ field_78, 0x78  # offset +0x78

# --- external targets -----------------------------------------------
.set FUN_00426367, .text + (0x00426367 - 0x401000)
.set FUN_00449bff, .text + (0x00449bff - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x00449a94 - 0x401000
.globl FUN_00449a94
FUN_00449a94:
    # block 0x00449a94: entry, 8 instruction(s), ends with jne to 0x00449ab2 (forward)
    push ebp                                     # 00449a94
    {load} mov ebp, esp                          # 00449a95
    sub esp, 0x6c                                # 00449a97
    mov dword ptr [ebp - local_6c], ecx          # 00449a9a
    mov dword ptr [ebp - local_4], 0x0           # 00449a9d
    mov eax, dword ptr [ebp - local_6c]          # 00449aa4
    cmp dword ptr [eax + field_36], 0x0          # 00449aa7
    jne.d8 L_00449ab2                            # 00449aab
    # block 0x00449aad: entered by fall-through of jne at 0x00449aab, 1 instruction(s), ends with forward jump to 0x00449ba1
    jmp.d32 L_00449ba1                           # 00449aad
L_00449ab2:
    # block 0x00449ab2: entered by jne at 0x00449aab, 3 instruction(s), ends with je to 0x00449ad4 (forward)
    mov ecx, dword ptr [ebp - local_6c]          # 00449ab2
    cmp dword ptr [ecx + field_36], 0x0          # 00449ab5
    je.d8 L_00449ad4                             # 00449ab9
    # block 0x00449abb: entered by fall-through of je at 0x00449ab9, 3 instruction(s), ends with jne to 0x00449ad4 (forward)
    mov edx, dword ptr [ebp - local_6c]          # 00449abb
    cmp dword ptr [edx + field_42], 0x1          # 00449abe
    jne.d8 L_00449ad4                            # 00449ac2
    # block 0x00449ac4: entered by fall-through of jne at 0x00449ac2, 4 instruction(s), calls FUN_00449bff, KERNEL32.dll!Sleep, falls into the block at 0x00449ad4
    mov ecx, dword ptr [ebp - local_6c]          # 00449ac4
    call FUN_00449bff                            # 00449ac7
    push 0x0                                     # 00449acc
    call dword ptr [0x52a2b0]                    # 00449ace
L_00449ad4:
    # block 0x00449ad4: entered by je at 0x00449ab9; jne at 0x00449ac2, 4 instruction(s), calls KERNEL32.dll!Sleep, falls into the block at 0x00449ae6
    mov eax, dword ptr [ebp - local_6c]          # 00449ad4
    mov dword ptr [eax + field_3e], 0x1          # 00449ad7
    push 0x0                                     # 00449ade
    call dword ptr [0x52a2b0]                    # 00449ae0
L_00449ae6:
    # block 0x00449ae6: entered by jmp at 0x00449b37, 3 instruction(s), ends with je to 0x00449b39 (forward)
    mov ecx, dword ptr [ebp - local_6c]          # 00449ae6
    cmp dword ptr [ecx + field_36], 0x0          # 00449ae9
    je.d8 L_00449b39                             # 00449aed
    # block 0x00449aef: entered by fall-through of je at 0x00449aed, 9 instruction(s), calls KERNEL32.dll!GetExitCodeThread, ends with je to 0x00449b11 (forward)
    lea edx, [ebp - local_4]                     # 00449aef
    push edx                                     # 00449af2
    mov eax, dword ptr [ebp - local_6c]          # 00449af3
    mov ecx, dword ptr [eax + field_36]          # 00449af6
    mov edx, dword ptr [ecx + field_28]          # 00449af9
    push edx                                     # 00449afc
    call dword ptr [0x52a280]                    # 00449afd
    test eax, eax                                # 00449b03
    je.d8 L_00449b11                             # 00449b05
    # block 0x00449b07: entered by fall-through of je at 0x00449b05, 2 instruction(s), ends with jne to 0x00449b0f (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 00449b07
    jne.d8 L_00449b0f                            # 00449b0b
    # block 0x00449b0d: entered by fall-through of jne at 0x00449b0b, 1 instruction(s), ends with forward jump to 0x00449b39
    jmp.d8 L_00449b39                            # 00449b0d
L_00449b0f:
    # block 0x00449b0f: entered by jne at 0x00449b0b, 1 instruction(s), ends with forward jump to 0x00449b2f
    jmp.d8 L_00449b2f                            # 00449b0f
L_00449b11:
    # block 0x00449b11: entered by je at 0x00449b05, 3 instruction(s), ends with je to 0x00449b2f (forward)
    movsx eax, word ptr [0x63a4cd]               # 00449b11
    test eax, eax                                # 00449b18
    je.d8 L_00449b2f                             # 00449b1a
    # block 0x00449b1c: entered by fall-through of je at 0x00449b1a, 5 instruction(s), calls FUN_00426367, FUN_0044a2b7, falls into the block at 0x00449b2f
    mov ecx, 0x583979                            # 00449b1c
    call FUN_00426367                            # 00449b21
    push eax                                     # 00449b26
    call FUN_0044a2b7                            # 00449b27
    add esp, 0x4                                 # 00449b2c
L_00449b2f:
    # block 0x00449b2f: entered by jmp at 0x00449b0f; je at 0x00449b1a, 3 instruction(s), calls KERNEL32.dll!Sleep, ends with backward jump to 0x00449ae6
    push 0x0                                     # 00449b2f
    call dword ptr [0x52a2b0]                    # 00449b31
    jmp.d8 L_00449ae6                            # 00449b37
L_00449b39:
    # block 0x00449b39: entered by je at 0x00449aed; jmp at 0x00449b0d, 16 instruction(s), calls indirect dword ptr [edx + 0x78], ends with je to 0x00449ba1 (forward)
    mov ecx, dword ptr [ebp - local_6c]          # 00449b39
    mov edx, dword ptr [ecx + field_36]          # 00449b3c
    mov dword ptr [edx + field_24], 0x1          # 00449b3f
    mov eax, dword ptr [ebp - local_6c]          # 00449b46
    mov ecx, dword ptr [eax + field_36]          # 00449b49
    mov edx, dword ptr [ebp - local_6c]          # 00449b4c
    mov eax, dword ptr [edx + field_36]          # 00449b4f
    mov edx, dword ptr [eax]                     # 00449b52
    call dword ptr [edx + field_78]              # 00449b54
    mov eax, dword ptr [ebp - local_6c]          # 00449b57
    mov dword ptr [eax + field_36], 0x0          # 00449b5a
    mov ecx, dword ptr [ebp - local_6c]          # 00449b61
    mov dword ptr [ecx + field_42], 0x3          # 00449b64
    movsx edx, word ptr [0x63a4cd]               # 00449b6b
    test edx, edx                                # 00449b72
    je.d8 L_00449ba1                             # 00449b74
    # block 0x00449b76: entered by fall-through of je at 0x00449b74, 15 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00449ba1
    mov eax, dword ptr [ebp - local_6c]          # 00449b76
    add eax, 0x4                                 # 00449b79
    push eax                                     # 00449b7c
    mov ecx, dword ptr [ebp - local_6c]          # 00449b7d
    mov edx, dword ptr [ecx + field_3a]          # 00449b80
    push edx                                     # 00449b83
    push 0x5489a0                                # 00449b84
    lea eax, [ebp - local_68]                    # 00449b89
    push eax                                     # 00449b8c
    call FUN_0050ca3e                            # 00449b8d
    add esp, 0x10                                # 00449b92
    lea ecx, [ebp - local_68]                    # 00449b95
    push ecx                                     # 00449b98
    call FUN_0044a2b7                            # 00449b99
    add esp, 0x4                                 # 00449b9e
L_00449ba1:
    # block 0x00449ba1: entered by jmp at 0x00449aad; je at 0x00449b74, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00449ba1
    pop ebp                                      # 00449ba3
    ret                                          # 00449ba4

