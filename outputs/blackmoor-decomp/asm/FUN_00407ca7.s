# FUN_00407ca7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00407ca7
# extent:       0x00407ca7-0x00407d70 (201 code bytes)
# span:         0x00407ca7-0x00407d70 (code 201, tables 0, padding 0)
# sha256:       9f3f46139484ba1003031705850a77d2141f28eb6895dac65fcf114414da6435
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m407ca7_lifted
# naming:       native port src/original_methods_fl40.c:m407ca7_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 2 seeds; oracle: 60/60 instructions executed, 6/6 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_14, local_18, local_1c, local_20
# fields:       [ecx + n] field_8c
# callees:      calls FUN_0051d48c, FUN_005193ca, FUN_0051d58b
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m407ca7_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 60 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ field_8c, 0x8c  # offset +0x8c

# --- external targets -----------------------------------------------
.set FUN_005193ca, .text + (0x005193ca - 0x401000)
.set FUN_0051d48c, .text + (0x0051d48c - 0x401000)
.set FUN_0051d58b, .text + (0x0051d58b - 0x401000)

.org 0x00407ca7 - 0x401000
.globl FUN_00407ca7
FUN_00407ca7:
    # block 0x00407ca7: entry, 7 instruction(s), ends with je to 0x00407cd3 (forward)
    push ebp                                     # 00407ca7
    {load} mov ebp, esp                          # 00407ca8
    sub esp, 0x20                                # 00407caa
    mov dword ptr [ebp - local_20], ecx          # 00407cad
    movsx eax, word ptr [0x5ec28c]               # 00407cb0
    test eax, eax                                # 00407cb7
    je.d8 L_00407cd3                             # 00407cb9
    # block 0x00407cbb: entered by fall-through of je at 0x00407cb9, 7 instruction(s), calls FUN_0051d48c, ends with forward jump to 0x00407ce9
    push 0x0                                     # 00407cbb
    push 0x1                                     # 00407cbd
    push 0xf1                                    # 00407cbf
    push 0x4b7                                   # 00407cc4
    mov ecx, dword ptr [ebp - local_20]          # 00407cc9
    call FUN_0051d48c                            # 00407ccc
    jmp.d8 L_00407ce9                            # 00407cd1
L_00407cd3:
    # block 0x00407cd3: entered by je at 0x00407cb9, 6 instruction(s), calls FUN_0051d48c, falls into the block at 0x00407ce9
    push 0x0                                     # 00407cd3
    push 0x0                                     # 00407cd5
    push 0xf1                                    # 00407cd7
    push 0x4b7                                   # 00407cdc
    mov ecx, dword ptr [ebp - local_20]          # 00407ce1
    call FUN_0051d48c                            # 00407ce4
L_00407ce9:
    # block 0x00407ce9: entered by jmp at 0x00407cd1, 2 instruction(s), ends with forward jump to 0x00407cfd
    mov word ptr [ebp - local_1c], 0x0           # 00407ce9
    jmp.d8 L_00407cfd                            # 00407cef
L_00407cf1:
    # block 0x00407cf1: entered by jmp at 0x00407d6a, 3 instruction(s), falls into the block at 0x00407cfd
    mov cx, word ptr [ebp - local_1c]            # 00407cf1
    add cx, 0x1                                  # 00407cf5
    mov word ptr [ebp - local_1c], cx            # 00407cf9
L_00407cfd:
    # block 0x00407cfd: entered by jmp at 0x00407cef, 3 instruction(s), ends with jge to 0x00407d6c (forward)
    movsx edx, word ptr [ebp - local_1c]         # 00407cfd
    cmp edx, 0x6                                 # 00407d01
    jge.d8 L_00407d6c                            # 00407d04
    # block 0x00407d06: entered by fall-through of jge at 0x00407d04, 2 instruction(s), ends with forward jump to 0x00407d1a
    mov word ptr [ebp - local_18], 0x0           # 00407d06
    jmp.d8 L_00407d1a                            # 00407d0c
L_00407d0e:
    # block 0x00407d0e: entered by jmp at 0x00407d68, 3 instruction(s), falls into the block at 0x00407d1a
    mov ax, word ptr [ebp - local_18]            # 00407d0e
    .insn 0x66, 0x05, 0x0001{:u16}               # 00407d12
    mov word ptr [ebp - local_18], ax            # 00407d16
L_00407d1a:
    # block 0x00407d1a: entered by jmp at 0x00407d0c, 3 instruction(s), ends with jge to 0x00407d6a (forward)
    movsx ecx, word ptr [ebp - local_18]         # 00407d1a
    cmp ecx, 0x6                                 # 00407d1e
    jge.d8 L_00407d6a                            # 00407d21
    # block 0x00407d23: entered by fall-through of jge at 0x00407d21, 20 instruction(s), calls FUN_005193ca, FUN_0051d58b, ends with backward jump to 0x00407d0e
    push 0xa                                     # 00407d23
    lea edx, [ebp - local_14]                    # 00407d25
    push edx                                     # 00407d28
    movsx eax, word ptr [ebp - local_1c]         # 00407d29
    imul eax, eax, 0xc                           # 00407d2d
    movsx ecx, word ptr [ebp - local_18]         # 00407d30
    movsx edx, word ptr [eax + 2*ecx + 0x5ec28e] # 00407d34
    push edx                                     # 00407d3c
    call FUN_005193ca                            # 00407d3d
    add esp, 0xc                                 # 00407d42
    push eax                                     # 00407d45
    movsx eax, word ptr [ebp - local_1c]         # 00407d46
    imul eax, eax, 0x180                         # 00407d4a
    mov ecx, dword ptr [ebp - local_20]          # 00407d50
    lea ecx, [ecx + eax + field_8c]              # 00407d53
    movsx edx, word ptr [ebp - local_18]         # 00407d5a
    shl edx, 0x6                                 # 00407d5e
    {load} add ecx, edx                          # 00407d61
    call FUN_0051d58b                            # 00407d63
    jmp.d8 L_00407d0e                            # 00407d68
L_00407d6a:
    # block 0x00407d6a: entered by jge at 0x00407d21, 1 instruction(s), ends with backward jump to 0x00407cf1
    jmp.d8 L_00407cf1                            # 00407d6a
L_00407d6c:
    # block 0x00407d6c: entered by jge at 0x00407d04, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00407d6c
    pop ebp                                      # 00407d6e
    ret                                          # 00407d6f

