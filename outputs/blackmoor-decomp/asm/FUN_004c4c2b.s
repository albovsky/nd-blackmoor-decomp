# FUN_004c4c2b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c4c2b
# extent:       0x004c4c2b-0x004c4d4a (287 code bytes)
# span:         0x004c4c2b-0x004c4d4a (code 287, tables 0, padding 0)
# sha256:       d3705535eddad3134b1d7ab1158ca5f1df98a56a14c431b7614c796c5a0395b9
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4c4c2b_lifted
# naming:       native port src/original_methods_fl41.c:m4c4c2b_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 15 seeds; oracle: 79/79 instructions, 8/8 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_e
# fields:       [eax + n] field_e86, field_e88, field_e8a, field_f84, field_f88; [ecx + n] field_c; [edx + n] field_8
# callees:      calls FUN_004c9805, FUN_004c500c, FUN_004c94ec
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4c4c2b_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 79 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_e, 0xe  # offset -0xe
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_e86, 0xe86  # offset +0xe86
.equ field_e88, 0xe88  # offset +0xe88
.equ field_e8a, 0xe8a  # offset +0xe8a
.equ field_f84, 0xf84  # offset +0xf84
.equ field_f88, 0xf88  # offset +0xf88

# --- external targets -----------------------------------------------
.set FUN_004c500c, .text + (0x004c500c - 0x401000)
.set FUN_004c94ec, .text + (0x004c94ec - 0x401000)
.set FUN_004c9805, .text + (0x004c9805 - 0x401000)

.org 0x004c4c2b - 0x401000
.globl FUN_004c4c2b
FUN_004c4c2b:
    # block 0x004c4c2b: entry, 12 instruction(s), calls FUN_004c9805, ends with forward jump to 0x004c4c63
    push ebp                                     # 004c4c2b
    {load} mov ebp, esp                          # 004c4c2c
    sub esp, 0x10                                # 004c4c2e
    mov dword ptr [ebp - local_c], ecx           # 004c4c31
    mov word ptr [ebp - local_4], 0x0            # 004c4c34
    mov eax, dword ptr [0x63a8dc]                # 004c4c3a
    add eax, 0x1                                 # 004c4c3f
    mov dword ptr [0x63a8dc], eax                # 004c4c42
    mov ecx, dword ptr [ebp - local_c]           # 004c4c47
    call FUN_004c9805                            # 004c4c4a
    mov word ptr [ebp - local_8], 0x0            # 004c4c4f
    jmp.d8 L_004c4c63                            # 004c4c55
L_004c4c57:
    # block 0x004c4c57: entered by jmp at 0x004c4ce7, 3 instruction(s), falls into the block at 0x004c4c63
    mov cx, word ptr [ebp - local_8]             # 004c4c57
    add cx, 0x1                                  # 004c4c5b
    mov word ptr [ebp - local_8], cx             # 004c4c5f
L_004c4c63:
    # block 0x004c4c63: entered by jmp at 0x004c4c55, 5 instruction(s), ends with jge to 0x004c4cec (forward)
    movsx edx, word ptr [ebp - local_8]          # 004c4c63
    mov eax, dword ptr [ebp - local_c]           # 004c4c67
    movsx ecx, word ptr [eax + field_e88]        # 004c4c6a
    {load} cmp edx, ecx                          # 004c4c71
    jge.d8 L_004c4cec                            # 004c4c73
    # block 0x004c4c75: entered by fall-through of jge at 0x004c4c73, 6 instruction(s), ends with jne to 0x004c4ce7 (forward)
    movsx edx, word ptr [ebp - local_8]          # 004c4c75
    mov eax, dword ptr [ebp - local_c]           # 004c4c79
    {load} xor ecx, ecx                          # 004c4c7c
    mov cl, byte ptr [eax + edx + field_e8a]     # 004c4c7e
    cmp ecx, 0x1                                 # 004c4c85
    jne.d8 L_004c4ce7                            # 004c4c88
    # block 0x004c4c8a: entered by fall-through of jne at 0x004c4c88, 27 instruction(s), calls FUN_004c500c, falls into the block at 0x004c4ce7
    push 0x554670                                # 004c4c8a
    movsx edx, word ptr [ebp - local_8]          # 004c4c8f
    shl edx, 0x4                                 # 004c4c93
    mov eax, dword ptr [ebp - local_c]           # 004c4c96
    lea ecx, [eax + edx + field_f84]             # 004c4c99
    push ecx                                     # 004c4ca0
    movsx edx, word ptr [ebp - local_8]          # 004c4ca1
    shl edx, 0x4                                 # 004c4ca5
    mov eax, dword ptr [ebp - local_c]           # 004c4ca8
    mov ecx, dword ptr [eax + edx + field_f88]   # 004c4cab
    push ecx                                     # 004c4cb2
    movsx edx, word ptr [ebp - local_8]          # 004c4cb3
    shl edx, 0x4                                 # 004c4cb7
    mov eax, dword ptr [ebp - local_c]           # 004c4cba
    mov ecx, dword ptr [eax + edx + field_f84]   # 004c4cbd
    push ecx                                     # 004c4cc4
    mov edx, dword ptr [ebp - local_c]           # 004c4cc5
    mov eax, dword ptr [edx + field_8]           # 004c4cc8
    push eax                                     # 004c4ccb
    mov ecx, dword ptr [ebp - local_c]           # 004c4ccc
    mov edx, dword ptr [ecx + field_c]           # 004c4ccf
    push edx                                     # 004c4cd2
    mov ecx, dword ptr [ebp - local_c]           # 004c4cd3
    call FUN_004c500c                            # 004c4cd6
    mov ax, word ptr [ebp - local_4]             # 004c4cdb
    .insn 0x66, 0x05, 0x0001{:u16}               # 004c4cdf
    mov word ptr [ebp - local_4], ax             # 004c4ce3
L_004c4ce7:
    # block 0x004c4ce7: entered by jne at 0x004c4c88, 1 instruction(s), ends with backward jump to 0x004c4c57
    jmp.d32 L_004c4c57                           # 004c4ce7
L_004c4cec:
    # block 0x004c4cec: entered by jge at 0x004c4c73, 4 instruction(s), ends with je to 0x004c4d3e (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004c4cec
    movsx edx, word ptr [0x63a8d8]               # 004c4cf0
    {load} cmp ecx, edx                          # 004c4cf7
    je.d8 L_004c4d3e                             # 004c4cf9
    # block 0x004c4cfb: entered by fall-through of je at 0x004c4cf9, 5 instruction(s), ends with jle to 0x004c4d1d (forward)
    mov eax, dword ptr [ebp - local_c]           # 004c4cfb
    movsx ecx, word ptr [eax + field_e86]        # 004c4cfe
    movsx edx, word ptr [ebp - local_4]          # 004c4d05
    {load} cmp ecx, edx                          # 004c4d09
    jle.d8 L_004c4d1d                            # 004c4d0b
    # block 0x004c4d0d: entered by fall-through of jle at 0x004c4d0b, 4 instruction(s), ends with forward jump to 0x004c4d25
    mov eax, dword ptr [ebp - local_c]           # 004c4d0d
    mov cx, word ptr [eax + field_e86]           # 004c4d10
    mov word ptr [ebp - local_e], cx             # 004c4d17
    jmp.d8 L_004c4d25                            # 004c4d1b
L_004c4d1d:
    # block 0x004c4d1d: entered by jle at 0x004c4d0b, 2 instruction(s), falls into the block at 0x004c4d25
    mov dx, word ptr [ebp - local_4]             # 004c4d1d
    mov word ptr [ebp - local_e], dx             # 004c4d21
L_004c4d25:
    # block 0x004c4d25: entered by jmp at 0x004c4d1b, 5 instruction(s), falls into the block at 0x004c4d3e
    mov eax, dword ptr [ebp - local_c]           # 004c4d25
    mov cx, word ptr [ebp - local_e]             # 004c4d28
    mov word ptr [eax + field_e86], cx           # 004c4d2c
    mov dx, word ptr [ebp - local_4]             # 004c4d33
    mov word ptr [0x63a8d8], dx                  # 004c4d37
L_004c4d3e:
    # block 0x004c4d3e: entered by je at 0x004c4cf9, 5 instruction(s), calls FUN_004c94ec, ends with ret
    mov ecx, dword ptr [ebp - local_c]           # 004c4d3e
    call FUN_004c94ec                            # 004c4d41
    {load} mov esp, ebp                          # 004c4d46
    pop ebp                                      # 004c4d48
    ret                                          # 004c4d49

