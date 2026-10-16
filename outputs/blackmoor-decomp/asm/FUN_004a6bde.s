# FUN_004a6bde
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a6bde
# extent:       0x004a6bde-0x004a6c61 (131 code bytes)
# span:         0x004a6bde-0x004a6c61 (code 131, tables 0, padding 0)
# sha256:       82df94e30b00e762290bc2bbb78bd6e0e98eff28193d9e9a14233561afc88607
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a6bde
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1e, field_8b; [edx + n] field_21, field_94, field_298, field_29a
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 36 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_21, 0x21  # offset +0x21
.equ field_8b, 0x8b  # offset +0x8b
.equ field_94, 0x94  # offset +0x94
.equ field_298, 0x298  # offset +0x298
.equ field_29a, 0x29a  # offset +0x29a

# --- external targets -----------------------------------------------

.org 0x004a6bde - 0x401000
.globl FUN_004a6bde
FUN_004a6bde:
    # block 0x004a6bde: entry, 11 instruction(s), ends with forward jump to 0x004a6c11
    push ebp                                     # 004a6bde
    {load} mov ebp, esp                          # 004a6bdf
    sub esp, 0xc                                 # 004a6be1
    mov dword ptr [ebp - local_c], ecx           # 004a6be4
    mov eax, dword ptr [ebp - local_c]           # 004a6be7
    movsx ecx, word ptr [eax + field_1e]         # 004a6bea
    imul ecx, ecx, 0x8d                          # 004a6bee
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004a6bf4
    mov dword ptr [ebp - local_4], edx           # 004a6bfa
    mov word ptr [ebp - local_8], 0x0            # 004a6bfd
    jmp.d8 L_004a6c11                            # 004a6c03
L_004a6c05:
    # block 0x004a6c05: entered by jmp at 0x004a6c47, 3 instruction(s), falls into the block at 0x004a6c11
    mov ax, word ptr [ebp - local_8]             # 004a6c05
    .insn 0x66, 0x05, 0x0001{:u16}               # 004a6c09
    mov word ptr [ebp - local_8], ax             # 004a6c0d
L_004a6c11:
    # block 0x004a6c11: entered by jmp at 0x004a6c03, 5 instruction(s), ends with jge to 0x004a6c49 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 004a6c11
    mov edx, dword ptr [ebp - local_4]           # 004a6c15
    movsx eax, word ptr [edx + field_298]        # 004a6c18
    {load} cmp ecx, eax                          # 004a6c1f
    jge.d8 L_004a6c49                            # 004a6c21
    # block 0x004a6c23: entered by fall-through of jge at 0x004a6c21, 8 instruction(s), ends with je to 0x004a6c47 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 004a6c23
    mov edx, dword ptr [ebp - local_c]           # 004a6c27
    movsx eax, word ptr [edx + 2*ecx + field_94] # 004a6c2a
    movsx ecx, word ptr [ebp - local_8]          # 004a6c32
    mov edx, dword ptr [ebp - local_4]           # 004a6c36
    movsx ecx, word ptr [edx + 2*ecx + field_29a] # 004a6c39
    {load} cmp eax, ecx                          # 004a6c41
    je.d8 L_004a6c47                             # 004a6c43
    # block 0x004a6c45: entered by fall-through of je at 0x004a6c43, 1 instruction(s), ends with forward jump to 0x004a6c5d
    jmp.d8 L_004a6c5d                            # 004a6c45
L_004a6c47:
    # block 0x004a6c47: entered by je at 0x004a6c43, 1 instruction(s), ends with backward jump to 0x004a6c05
    jmp.d8 L_004a6c05                            # 004a6c47
L_004a6c49:
    # block 0x004a6c49: entered by jge at 0x004a6c21, 4 instruction(s), falls into the block at 0x004a6c5d
    mov edx, dword ptr [ebp - local_c]           # 004a6c49
    mov dword ptr [edx + field_21], 0x5          # 004a6c4c
    mov eax, dword ptr [ebp - local_c]           # 004a6c53
    mov byte ptr [eax + field_8b], 0x1           # 004a6c56
L_004a6c5d:
    # block 0x004a6c5d: entered by jmp at 0x004a6c45, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004a6c5d
    pop ebp                                      # 004a6c5f
    ret                                          # 004a6c60

