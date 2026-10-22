# FUN_0041df05
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041df05
# extent:       0x0041df05-0x0041dfd2 (205 code bytes)
# span:         0x0041df05-0x0041dfd2 (code 205, tables 0, padding 0)
# sha256:       05958a9d30971bd330808a674480efb2d6db597954b016add129c7d0fdc65e1a
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m41df05_lifted
# naming:       native port src/original_methods_fl40.c:m41df05_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py) over the 32-bit address space, 2 seeds; oracle: 58/58 instructions executed, 6/6 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_6, field_1e; [ecx + n] field_1e; [edx + n] field_1c, field_696
# callees:      calls FUN_0051dc6c, FUN_004c2e5b
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m41df05_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 58 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_6, 0x6  # offset +0x6
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_696, 0x696  # offset +0x696

# --- external targets -----------------------------------------------
.set FUN_004c2e5b, .text + (0x004c2e5b - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0041df05 - 0x401000
.globl FUN_0041df05
FUN_0041df05:
    # block 0x0041df05: entry, 6 instruction(s), ends with forward jump to 0x0041df22
    push ebp                                     # 0041df05
    {load} mov ebp, esp                          # 0041df06
    sub esp, 0x10                                # 0041df08
    mov dword ptr [ebp - local_10], ecx          # 0041df0b
    mov word ptr [ebp - local_8], 0x0            # 0041df0e
    jmp.d8 L_0041df22                            # 0041df14
L_0041df16:
    # block 0x0041df16: entered by jmp at 0x0041dfc9, 3 instruction(s), falls into the block at 0x0041df22
    mov ax, word ptr [ebp - local_8]             # 0041df16
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041df1a
    mov word ptr [ebp - local_8], ax             # 0041df1e
L_0041df22:
    # block 0x0041df22: entered by jmp at 0x0041df14, 5 instruction(s), ends with jge to 0x0041dfce (forward)
    movsx ecx, word ptr [ebp - local_8]          # 0041df22
    mov edx, dword ptr [ebp - local_10]          # 0041df26
    movsx eax, word ptr [edx + field_696]        # 0041df29
    {load} cmp ecx, eax                          # 0041df30
    jge.d32 L_0041dfce                           # 0041df32
    # block 0x0041df38: entered by fall-through of jge at 0x0041df32, 9 instruction(s), ends with je to 0x0041df89 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 0041df38
    imul ecx, ecx, 0x16                          # 0041df3c
    mov edx, dword ptr [ebp - local_10]          # 0041df3f
    mov word ptr [edx + ecx + field_1c], 0xffff  # 0041df42
    movsx eax, word ptr [ebp - local_8]          # 0041df49
    imul eax, eax, 0x16                          # 0041df4d
    mov ecx, dword ptr [ebp - local_10]          # 0041df50
    cmp dword ptr [ecx + eax + field_1e], 0x0    # 0041df53
    je.d8 L_0041df89                             # 0041df58
    # block 0x0041df5a: entered by fall-through of je at 0x0041df58, 13 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0041df89
    movsx edx, word ptr [ebp - local_8]          # 0041df5a
    imul edx, edx, 0x16                          # 0041df5e
    mov eax, dword ptr [ebp - local_10]          # 0041df61
    mov ecx, dword ptr [eax + edx + field_1e]    # 0041df64
    mov dword ptr [ebp - local_c], ecx           # 0041df68
    mov edx, dword ptr [ebp - local_c]           # 0041df6b
    push edx                                     # 0041df6e
    call FUN_0051dc6c                            # 0041df6f
    add esp, 0x4                                 # 0041df74
    movsx eax, word ptr [ebp - local_8]          # 0041df77
    imul eax, eax, 0x16                          # 0041df7b
    mov ecx, dword ptr [ebp - local_10]          # 0041df7e
    mov dword ptr [ecx + eax + field_1e], 0x0    # 0041df81
L_0041df89:
    # block 0x0041df89: entered by je at 0x0041df58, 2 instruction(s), ends with forward jump to 0x0041df9d
    mov word ptr [ebp - local_4], 0x0            # 0041df89
    jmp.d8 L_0041df9d                            # 0041df8f
L_0041df91:
    # block 0x0041df91: entered by jmp at 0x0041dfc7, 3 instruction(s), falls into the block at 0x0041df9d
    mov dx, word ptr [ebp - local_4]             # 0041df91
    add dx, 0x1                                  # 0041df95
    mov word ptr [ebp - local_4], dx             # 0041df99
L_0041df9d:
    # block 0x0041df9d: entered by jmp at 0x0041df8f, 3 instruction(s), ends with jge to 0x0041dfc9 (forward)
    movsx eax, word ptr [ebp - local_4]          # 0041df9d
    cmp eax, 0x4                                 # 0041dfa1
    jge.d8 L_0041dfc9                            # 0041dfa4
    # block 0x0041dfa6: entered by fall-through of jge at 0x0041dfa4, 10 instruction(s), calls FUN_004c2e5b, ends with backward jump to 0x0041df91
    movsx ecx, word ptr [ebp - local_8]          # 0041dfa6
    imul ecx, ecx, 0x16                          # 0041dfaa
    mov edx, dword ptr [ebp - local_10]          # 0041dfad
    lea eax, [edx + ecx + field_1c]              # 0041dfb0
    movsx ecx, word ptr [ebp - local_4]          # 0041dfb4
    mov edx, dword ptr [eax + 4*ecx + field_6]   # 0041dfb8
    push edx                                     # 0041dfbc
    mov ecx, 0x5cf659                            # 0041dfbd
    call FUN_004c2e5b                            # 0041dfc2
    jmp.d8 L_0041df91                            # 0041dfc7
L_0041dfc9:
    # block 0x0041dfc9: entered by jge at 0x0041dfa4, 1 instruction(s), ends with backward jump to 0x0041df16
    jmp.d32 L_0041df16                           # 0041dfc9
L_0041dfce:
    # block 0x0041dfce: entered by jge at 0x0041df32, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0041dfce
    pop ebp                                      # 0041dfd0
    ret                                          # 0041dfd1

