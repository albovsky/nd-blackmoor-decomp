# FUN_004cb9d1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cb9d1
# extent:       0x004cb9d1-0x004cbb00 (303 code bytes)
# span:         0x004cb9d1-0x004cbb00 (code 303, tables 0, padding 0)
# sha256:       64cd145431893efa99e7edc6f888b35762c57286d5d9f795e6419be5727449fa
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004cb9d1
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_9, field_c, field_10, field_12, field_126, field_132, field_15c; [ecx + n] field_8, field_c, field_12, field_16, field_126, field_132, field_15c; [edx + n] field_2, field_4, field_8, field_10, field_12, field_16, field_126, field_15c
# callees:      calls FUN_004c0c69
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 79 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_9, 0x9  # offset +0x9
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_12, 0x12  # offset +0x12
.equ field_16, 0x16  # offset +0x16
.equ field_126, 0x126  # offset +0x126
.equ field_132, 0x132  # offset +0x132
.equ field_15c, 0x15c  # offset +0x15c

# --- external targets -----------------------------------------------
.set FUN_004c0c69, .text + (0x004c0c69 - 0x401000)

.org 0x004cb9d1 - 0x401000
.globl FUN_004cb9d1
FUN_004cb9d1:
    # block 0x004cb9d1: entry, 7 instruction(s), ends with jne to 0x004cb9e6 (forward)
    push ebp                                     # 004cb9d1
    {load} mov ebp, esp                          # 004cb9d2
    push ecx                                     # 004cb9d4
    mov dword ptr [ebp - local_4], ecx           # 004cb9d5
    mov eax, dword ptr [ebp - local_4]           # 004cb9d8
    cmp dword ptr [eax + field_12], 0x0          # 004cb9db
    jne.d8 L_004cb9e6                            # 004cb9df
    # block 0x004cb9e1: entered by fall-through of jne at 0x004cb9df, 1 instruction(s), ends with forward jump to 0x004cbafc
    jmp.d32 L_004cbafc                           # 004cb9e1
L_004cb9e6:
    # block 0x004cb9e6: entered by jne at 0x004cb9df, 7 instruction(s), calls FUN_004c0c69, ends with jne to 0x004cba0a (forward)
    mov ecx, 0x637fcf                            # 004cb9e6
    call FUN_004c0c69                            # 004cb9eb
    mov ecx, dword ptr [ebp - local_4]           # 004cb9f0
    mov dword ptr [ecx + field_15c], eax         # 004cb9f3
    mov edx, dword ptr [ebp - local_4]           # 004cb9f9
    cmp dword ptr [edx + field_15c], 0x0         # 004cb9fc
    jne.d8 L_004cba0a                            # 004cba03
    # block 0x004cba05: entered by fall-through of jne at 0x004cba03, 1 instruction(s), ends with forward jump to 0x004cbafc
    jmp.d32 L_004cbafc                           # 004cba05
L_004cba0a:
    # block 0x004cba0a: entered by jne at 0x004cba03, 3 instruction(s), ends with forward jump to 0x004cba2e
    mov eax, dword ptr [ebp - local_4]           # 004cba0a
    mov dword ptr [eax + field_132], 0x0         # 004cba0d
    jmp.d8 L_004cba2e                            # 004cba17
L_004cba19:
    # block 0x004cba19: entered by jmp at 0x004cbaf7, 5 instruction(s), falls into the block at 0x004cba2e
    mov ecx, dword ptr [ebp - local_4]           # 004cba19
    mov edx, dword ptr [ecx + field_132]         # 004cba1c
    add edx, 0x1                                 # 004cba22
    mov eax, dword ptr [ebp - local_4]           # 004cba25
    mov dword ptr [eax + field_132], edx         # 004cba28
L_004cba2e:
    # block 0x004cba2e: entered by jmp at 0x004cba17, 6 instruction(s), ends with jge to 0x004cbafc (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004cba2e
    mov edx, dword ptr [ecx + field_12]          # 004cba31
    movsx eax, word ptr [edx + field_2]          # 004cba34
    mov ecx, dword ptr [ebp - local_4]           # 004cba38
    cmp dword ptr [ecx + field_132], eax         # 004cba3b
    jge.d32 L_004cbafc                           # 004cba41
    # block 0x004cba47: entered by fall-through of jge at 0x004cba41, 46 instruction(s), ends with backward jump to 0x004cba19
    mov edx, dword ptr [ebp - local_4]           # 004cba47
    mov eax, dword ptr [edx + field_12]          # 004cba4a
    mov ecx, dword ptr [ebp - local_4]           # 004cba4d
    mov edx, dword ptr [ecx + field_132]         # 004cba50
    imul edx, edx, 0x18                          # 004cba56
    mov eax, dword ptr [eax + field_9]           # 004cba59
    {load} add eax, edx                          # 004cba5c
    mov ecx, dword ptr [ebp - local_4]           # 004cba5e
    mov dword ptr [ecx + field_126], eax         # 004cba61
    mov edx, dword ptr [ebp - local_4]           # 004cba67
    mov eax, dword ptr [edx + field_126]         # 004cba6a
    mov ecx, dword ptr [ebp - local_4]           # 004cba70
    mov edx, dword ptr [ecx + field_15c]         # 004cba73
    mov eax, dword ptr [eax + field_4]           # 004cba79
    add eax, dword ptr [edx + field_12]          # 004cba7c
    mov ecx, dword ptr [ebp - local_4]           # 004cba7f
    mov edx, dword ptr [ecx + field_126]         # 004cba82
    mov dword ptr [edx + field_4], eax           # 004cba88
    mov eax, dword ptr [ebp - local_4]           # 004cba8b
    mov ecx, dword ptr [eax + field_126]         # 004cba8e
    mov edx, dword ptr [ebp - local_4]           # 004cba94
    mov eax, dword ptr [edx + field_15c]         # 004cba97
    mov ecx, dword ptr [ecx + field_c]           # 004cba9d
    add ecx, dword ptr [eax + field_12]          # 004cbaa0
    mov edx, dword ptr [ebp - local_4]           # 004cbaa3
    mov eax, dword ptr [edx + field_126]         # 004cbaa6
    mov dword ptr [eax + field_c], ecx           # 004cbaac
    mov ecx, dword ptr [ebp - local_4]           # 004cbaaf
    mov edx, dword ptr [ecx + field_126]         # 004cbab2
    mov eax, dword ptr [ebp - local_4]           # 004cbab8
    mov ecx, dword ptr [eax + field_15c]         # 004cbabb
    mov edx, dword ptr [edx + field_8]           # 004cbac1
    add edx, dword ptr [ecx + field_16]          # 004cbac4
    mov eax, dword ptr [ebp - local_4]           # 004cbac7
    mov ecx, dword ptr [eax + field_126]         # 004cbaca
    mov dword ptr [ecx + field_8], edx           # 004cbad0
    mov edx, dword ptr [ebp - local_4]           # 004cbad3
    mov eax, dword ptr [edx + field_126]         # 004cbad6
    mov ecx, dword ptr [ebp - local_4]           # 004cbadc
    mov edx, dword ptr [ecx + field_15c]         # 004cbadf
    mov eax, dword ptr [eax + field_10]          # 004cbae5
    add eax, dword ptr [edx + field_16]          # 004cbae8
    mov ecx, dword ptr [ebp - local_4]           # 004cbaeb
    mov edx, dword ptr [ecx + field_126]         # 004cbaee
    mov dword ptr [edx + field_10], eax          # 004cbaf4
    jmp.d32 L_004cba19                           # 004cbaf7
L_004cbafc:
    # block 0x004cbafc: entered by jmp at 0x004cb9e1; jmp at 0x004cba05; jge at 0x004cba41, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004cbafc
    pop ebp                                      # 004cbafe
    ret                                          # 004cbaff

