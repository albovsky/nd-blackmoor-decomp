# FUN_004eba54
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004eba54
# extent:       0x004eba54-0x004ebb5b (263 code bytes)
# span:         0x004eba54-0x004ebb5b (code 263, tables 0, padding 0)
# sha256:       d1a3a6b57e8553dbdcf5fc3cd91bf52352750187945ef72184c3fd3d6b43e609
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004eba54
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_fc6, field_28da; [ecx + n] field_985, field_ca8, field_fc6; [edx + n] field_b85, field_fc6
# callees:      calls FUN_004e1d34, FUN_004eb9c8
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl17.c:m4eb96e_close (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 62 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_985, 0x985  # offset +0x985
.equ field_b85, 0xb85  # offset +0xb85
.equ field_ca8, 0xca8  # offset +0xca8
.equ field_fc6, 0xfc6  # offset +0xfc6
.equ field_28da, 0x28da  # offset +0x28da

# --- external targets -----------------------------------------------
.set FUN_004e1d34, .text + (0x004e1d34 - 0x401000)
.set FUN_004eb9c8, .text + (0x004eb9c8 - 0x401000)

.org 0x004eba54 - 0x401000
.globl FUN_004eba54
FUN_004eba54:
    # block 0x004eba54: entry, 8 instruction(s), ends with forward jump to 0x004eba87
    push ebp                                     # 004eba54
    {load} mov ebp, esp                          # 004eba55
    sub esp, 0x8                                 # 004eba57
    mov dword ptr [ebp - local_8], ecx           # 004eba5a
    mov word ptr [ebp - local_4], 0x0            # 004eba5d
    mov eax, dword ptr [ebp - local_8]           # 004eba63
    mov dword ptr [eax + field_fc6], 0x0         # 004eba66
    jmp.d8 L_004eba87                            # 004eba70
L_004eba72:
    # block 0x004eba72: entered by jmp at 0x004ebacd, 5 instruction(s), falls into the block at 0x004eba87
    mov ecx, dword ptr [ebp - local_8]           # 004eba72
    mov edx, dword ptr [ecx + field_fc6]         # 004eba75
    add edx, 0x1                                 # 004eba7b
    mov eax, dword ptr [ebp - local_8]           # 004eba7e
    mov dword ptr [eax + field_fc6], edx         # 004eba81
L_004eba87:
    # block 0x004eba87: entered by jmp at 0x004eba70, 3 instruction(s), ends with jge to 0x004ebacf (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004eba87
    cmp dword ptr [ecx + field_fc6], 0x2         # 004eba8a
    jge.d8 L_004ebacf                            # 004eba91
    # block 0x004eba93: entered by fall-through of jge at 0x004eba91, 6 instruction(s), ends with je to 0x004ebacd (forward)
    mov edx, dword ptr [ebp - local_8]           # 004eba93
    mov eax, dword ptr [edx + field_fc6]         # 004eba96
    imul eax, eax, 0xf7                          # 004eba9c
    mov ecx, dword ptr [ebp - local_8]           # 004ebaa2
    cmp dword ptr [ecx + eax + field_985], 0x0   # 004ebaa5
    je.d8 L_004ebacd                             # 004ebaad
    # block 0x004ebaaf: entered by fall-through of je at 0x004ebaad, 6 instruction(s), calls FUN_004e1d34, falls into the block at 0x004ebacd
    mov edx, dword ptr [ebp - local_8]           # 004ebaaf
    mov eax, dword ptr [edx + field_fc6]         # 004ebab2
    imul eax, eax, 0x18f                         # 004ebab8
    mov ecx, dword ptr [ebp - local_8]           # 004ebabe
    lea ecx, [ecx + eax + field_ca8]             # 004ebac1
    call FUN_004e1d34                            # 004ebac8
L_004ebacd:
    # block 0x004ebacd: entered by je at 0x004ebaad, 1 instruction(s), ends with backward jump to 0x004eba72
    jmp.d8 L_004eba72                            # 004ebacd
L_004ebacf:
    # block 0x004ebacf: entered by jge at 0x004eba91, 3 instruction(s), ends with forward jump to 0x004ebaf3
    mov edx, dword ptr [ebp - local_8]           # 004ebacf
    mov dword ptr [edx + field_fc6], 0x0         # 004ebad2
    jmp.d8 L_004ebaf3                            # 004ebadc
L_004ebade:
    # block 0x004ebade: entered by jmp at 0x004ebb4d, 5 instruction(s), falls into the block at 0x004ebaf3
    mov eax, dword ptr [ebp - local_8]           # 004ebade
    mov ecx, dword ptr [eax + field_fc6]         # 004ebae1
    add ecx, 0x1                                 # 004ebae7
    mov edx, dword ptr [ebp - local_8]           # 004ebaea
    mov dword ptr [edx + field_fc6], ecx         # 004ebaed
L_004ebaf3:
    # block 0x004ebaf3: entered by jmp at 0x004ebadc, 5 instruction(s), ends with jge to 0x004ebb4f (forward)
    mov eax, dword ptr [ebp - local_8]           # 004ebaf3
    movsx ecx, word ptr [eax + field_28da]       # 004ebaf6
    mov edx, dword ptr [ebp - local_8]           # 004ebafd
    cmp dword ptr [edx + field_fc6], ecx         # 004ebb00
    jge.d8 L_004ebb4f                            # 004ebb06
    # block 0x004ebb08: entered by fall-through of jge at 0x004ebb06, 7 instruction(s), ends with jne to 0x004ebb4d (forward)
    movsx eax, word ptr [ebp - local_4]          # 004ebb08
    imul eax, eax, 0x320                         # 004ebb0c
    mov ecx, dword ptr [ebp - local_8]           # 004ebb12
    mov edx, dword ptr [ecx + field_fc6]         # 004ebb15
    movsx eax, word ptr [eax + 2*edx + 0x59f27b] # 004ebb1b
    cmp eax, 0x8                                 # 004ebb23
    jne.d8 L_004ebb4d                            # 004ebb26
    # block 0x004ebb28: entered by fall-through of jne at 0x004ebb26, 7 instruction(s), falls into the block at 0x004ebb4d
    movsx ecx, word ptr [ebp - local_4]          # 004ebb28
    imul ecx, ecx, 0x320                         # 004ebb2c
    mov edx, dword ptr [ebp - local_8]           # 004ebb32
    mov eax, dword ptr [edx + field_fc6]         # 004ebb35
    mov edx, dword ptr [ebp - local_8]           # 004ebb3b
    mov dx, word ptr [edx + field_b85]           # 004ebb3e
    mov word ptr [ecx + 2*eax + 0x59f27b], dx    # 004ebb45
L_004ebb4d:
    # block 0x004ebb4d: entered by jne at 0x004ebb26, 1 instruction(s), ends with backward jump to 0x004ebade
    jmp.d8 L_004ebade                            # 004ebb4d
L_004ebb4f:
    # block 0x004ebb4f: entered by jge at 0x004ebb06, 5 instruction(s), calls FUN_004eb9c8, ends with ret
    mov ecx, dword ptr [ebp - local_8]           # 004ebb4f
    call FUN_004eb9c8                            # 004ebb52
    {load} mov esp, ebp                          # 004ebb57
    pop ebp                                      # 004ebb59
    ret                                          # 004ebb5a

