# FUN_004ebe90
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ebe90
# extent:       0x004ebe90-0x004ec005 (373 code bytes)
# span:         0x004ebe90-0x004ec005 (code 373, tables 0, padding 0)
# sha256:       3a419cedf371bf863c347e0d35922ed8f915bef392f48bae926ee70905f58e30
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ebe90
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_fc6, field_fca, field_fda, field_28da; [ecx + n] field_691, field_fd2, field_fd6; [edx + n] field_691, field_fc6, field_fd2, field_fde, field_fe2, field_fe6
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 82 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_691, 0x691  # offset +0x691
.equ field_fc6, 0xfc6  # offset +0xfc6
.equ field_fca, 0xfca  # offset +0xfca
.equ field_fd2, 0xfd2  # offset +0xfd2
.equ field_fd6, 0xfd6  # offset +0xfd6
.equ field_fda, 0xfda  # offset +0xfda
.equ field_fde, 0xfde  # offset +0xfde
.equ field_fe2, 0xfe2  # offset +0xfe2
.equ field_fe6, 0xfe6  # offset +0xfe6
.equ field_28da, 0x28da  # offset +0x28da

# --- external targets -----------------------------------------------

.org 0x004ebe90 - 0x401000
.globl FUN_004ebe90
FUN_004ebe90:
    # block 0x004ebe90: entry, 7 instruction(s), ends with jne to 0x004ec001 (forward)
    push ebp                                     # 004ebe90
    {load} mov ebp, esp                          # 004ebe91
    sub esp, 0x8                                 # 004ebe93
    mov dword ptr [ebp - local_8], ecx           # 004ebe96
    mov eax, dword ptr [ebp - local_8]           # 004ebe99
    cmp dword ptr [eax + field_fca], 0x2         # 004ebe9c
    jne.d32 L_004ec001                           # 004ebea3
    # block 0x004ebea9: entered by fall-through of jne at 0x004ebea3, 6 instruction(s), ends with forward jump to 0x004ebee0
    mov word ptr [ebp - local_4], 0x0            # 004ebea9
    mov ecx, dword ptr [ebp - local_8]           # 004ebeaf
    mov dword ptr [ecx + field_691], 0xffffffff  # 004ebeb2
    mov edx, dword ptr [ebp - local_8]           # 004ebebc
    mov dword ptr [edx + field_fc6], 0x0         # 004ebebf
    jmp.d8 L_004ebee0                            # 004ebec9
L_004ebecb:
    # block 0x004ebecb: entered by jmp at 0x004ebffc, 5 instruction(s), falls into the block at 0x004ebee0
    mov eax, dword ptr [ebp - local_8]           # 004ebecb
    mov ecx, dword ptr [eax + field_fc6]         # 004ebece
    add ecx, 0x1                                 # 004ebed4
    mov edx, dword ptr [ebp - local_8]           # 004ebed7
    mov dword ptr [edx + field_fc6], ecx         # 004ebeda
L_004ebee0:
    # block 0x004ebee0: entered by jmp at 0x004ebec9, 5 instruction(s), ends with jge to 0x004ec001 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004ebee0
    movsx ecx, word ptr [eax + field_28da]       # 004ebee3
    mov edx, dword ptr [ebp - local_8]           # 004ebeea
    cmp dword ptr [edx + field_fc6], ecx         # 004ebeed
    jge.d32 L_004ec001                           # 004ebef3
    # block 0x004ebef9: entered by fall-through of jge at 0x004ebef3, 8 instruction(s), ends with jl to 0x004ebffc (forward)
    mov eax, dword ptr [ebp - local_8]           # 004ebef9
    mov ecx, dword ptr [eax + field_fc6]         # 004ebefc
    shl ecx, 0x4                                 # 004ebf02
    mov edx, dword ptr [ebp - local_8]           # 004ebf05
    mov eax, dword ptr [ebp - local_8]           # 004ebf08
    mov edx, dword ptr [edx + field_fd2]         # 004ebf0b
    cmp edx, dword ptr [eax + ecx + field_fda]   # 004ebf11
    jl.d32 L_004ebffc                            # 004ebf18
    # block 0x004ebf1e: entered by fall-through of jl at 0x004ebf18, 9 instruction(s), ends with jg to 0x004ebffc (forward)
    mov eax, dword ptr [ebp - local_8]           # 004ebf1e
    mov ecx, dword ptr [eax + field_fc6]         # 004ebf21
    shl ecx, 0x4                                 # 004ebf27
    mov edx, dword ptr [ebp - local_8]           # 004ebf2a
    mov eax, dword ptr [edx + ecx + field_fe2]   # 004ebf2d
    add eax, 0x14                                # 004ebf34
    mov ecx, dword ptr [ebp - local_8]           # 004ebf37
    cmp dword ptr [ecx + field_fd2], eax         # 004ebf3a
    jg.d32 L_004ebffc                            # 004ebf40
    # block 0x004ebf46: entered by fall-through of jg at 0x004ebf40, 8 instruction(s), ends with jl to 0x004ebffc (forward)
    mov edx, dword ptr [ebp - local_8]           # 004ebf46
    mov eax, dword ptr [edx + field_fc6]         # 004ebf49
    shl eax, 0x4                                 # 004ebf4f
    mov ecx, dword ptr [ebp - local_8]           # 004ebf52
    mov edx, dword ptr [ebp - local_8]           # 004ebf55
    mov ecx, dword ptr [ecx + field_fd6]         # 004ebf58
    cmp ecx, dword ptr [edx + eax + field_fde]   # 004ebf5e
    jl.d32 L_004ebffc                            # 004ebf65
    # block 0x004ebf6b: entered by fall-through of jl at 0x004ebf65, 8 instruction(s), ends with jg to 0x004ebffc (forward)
    mov edx, dword ptr [ebp - local_8]           # 004ebf6b
    mov eax, dword ptr [edx + field_fc6]         # 004ebf6e
    shl eax, 0x4                                 # 004ebf74
    mov ecx, dword ptr [ebp - local_8]           # 004ebf77
    mov edx, dword ptr [ebp - local_8]           # 004ebf7a
    mov ecx, dword ptr [ecx + field_fd6]         # 004ebf7d
    cmp ecx, dword ptr [edx + eax + field_fe6]   # 004ebf83
    jg.d8 L_004ebffc                             # 004ebf8a
    # block 0x004ebf8c: entered by fall-through of jg at 0x004ebf8a, 9 instruction(s), ends with jne to 0x004ebffc (forward)
    movsx edx, word ptr [ebp - local_4]          # 004ebf8c
    imul edx, edx, 0x320                         # 004ebf90
    mov eax, dword ptr [ebp - local_8]           # 004ebf96
    movsx ecx, word ptr [eax + field_28da]       # 004ebf99
    mov eax, dword ptr [ebp - local_8]           # 004ebfa0
    sub ecx, dword ptr [eax + field_fc6]         # 004ebfa3
    movsx ecx, word ptr [edx + 2*ecx + 0x59f279] # 004ebfa9
    cmp ecx, 0x7                                 # 004ebfb1
    jne.d8 L_004ebffc                            # 004ebfb4
    # block 0x004ebfb6: entered by fall-through of jne at 0x004ebfb4, 13 instruction(s), ends with forward jump to 0x004ec001
    mov dword ptr [0x5b44f4], 0x1                # 004ebfb6
    mov edx, dword ptr [ebp - local_8]           # 004ebfc0
    mov eax, dword ptr [ebp - local_8]           # 004ebfc3
    mov ecx, dword ptr [eax + field_fc6]         # 004ebfc6
    mov dword ptr [edx + field_691], ecx         # 004ebfcc
    mov dword ptr [0x5c39e5], 0x27dc             # 004ebfd2
    mov edx, dword ptr [0x5b44f0]                # 004ebfdc
    shl edx, 0x5                                 # 004ebfe2
    mov eax, dword ptr [0x5b44f4]                # 004ebfe5
    shl eax, 0x4                                 # 004ebfea
    lea ecx, [edx + eax + 0x5b160c]              # 004ebfed
    mov dword ptr [0x5d1631], ecx                # 004ebff4
    jmp.d8 L_004ec001                            # 004ebffa
L_004ebffc:
    # block 0x004ebffc: entered by jl at 0x004ebf18; jg at 0x004ebf40; jl at 0x004ebf65; jg at 0x004ebf8a; jne at 0x004ebfb4, 1 instruction(s), ends with backward jump to 0x004ebecb
    jmp.d32 L_004ebecb                           # 004ebffc
L_004ec001:
    # block 0x004ec001: entered by jne at 0x004ebea3; jge at 0x004ebef3; jmp at 0x004ebffa, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004ec001
    pop ebp                                      # 004ec003
    ret                                          # 004ec004

