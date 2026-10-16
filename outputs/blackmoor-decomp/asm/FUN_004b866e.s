# FUN_004b866e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b866e
# extent:       0x004b866e-0x004b8783 (277 code bytes)
# span:         0x004b866e-0x004b8783 (code 277, tables 0, padding 0)
# sha256:       135100aec276a05a45bb48891e43448ee0a2b83ac30f4ac4c251d6a7830445a1
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b866e
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_8, field_5e, field_179; [ecx + n] field_8, field_5a, field_7d, field_173, field_175; [edx + n] field_8, field_173
# callees:      calls FUN_0050cd50
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 71 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_8, 0x8  # offset +0x8
.equ field_5a, 0x5a  # offset +0x5a
.equ field_5e, 0x5e  # offset +0x5e
.equ field_7d, 0x7d  # offset +0x7d
.equ field_173, 0x173  # offset +0x173
.equ field_175, 0x175  # offset +0x175
.equ field_179, 0x179  # offset +0x179

# --- external targets -----------------------------------------------
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x004b866e - 0x401000
.globl FUN_004b866e
FUN_004b866e:
    # block 0x004b866e: entry, 12 instruction(s), calls FUN_0050cd50, falls into the block at 0x004b8697
    push ebp                                     # 004b866e
    {load} mov ebp, esp                          # 004b866f
    sub esp, 0x10                                # 004b8671
    mov dword ptr [ebp - local_10], ecx          # 004b8674
    call FUN_0050cd50                            # 004b8677
    mov ecx, dword ptr [ebp - local_10]          # 004b867c
    mov edx, dword ptr [ecx + field_8]           # 004b867f
    movsx ecx, word ptr [edx + field_173]        # 004b8682
    cdq                                          # 004b8689
    idiv ecx                                     # 004b868a
    mov word ptr [ebp - local_8], dx             # 004b868c
    mov dword ptr [ebp - local_4], 0x1           # 004b8690
L_004b8697:
    # block 0x004b8697: entered by jmp at 0x004b8776, 2 instruction(s), ends with je to 0x004b877b (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 004b8697
    je.d32 L_004b877b                            # 004b869b
    # block 0x004b86a1: entered by fall-through of je at 0x004b869b, 3 instruction(s), ends with forward jump to 0x004b86bc
    mov dword ptr [ebp - local_4], 0x0           # 004b86a1
    mov word ptr [ebp - local_c], 0x0            # 004b86a8
    jmp.d8 L_004b86bc                            # 004b86ae
L_004b86b0:
    # block 0x004b86b0: entered by jmp at 0x004b8752, 3 instruction(s), falls into the block at 0x004b86bc
    mov dx, word ptr [ebp - local_c]             # 004b86b0
    add dx, 0x1                                  # 004b86b4
    mov word ptr [ebp - local_c], dx             # 004b86b8
L_004b86bc:
    # block 0x004b86bc: entered by jmp at 0x004b86ae, 5 instruction(s), ends with jge to 0x004b8757 (forward)
    movsx eax, word ptr [ebp - local_c]          # 004b86bc
    mov ecx, dword ptr [0x61ee76]                # 004b86c0
    movsx edx, word ptr [ecx + field_173]        # 004b86c6
    {load} cmp eax, edx                          # 004b86cd
    jge.d32 L_004b8757                           # 004b86cf
    # block 0x004b86d5: entered by fall-through of jge at 0x004b86cf, 5 instruction(s), ends with je to 0x004b8752 (forward)
    movsx eax, word ptr [ebp - local_c]          # 004b86d5
    imul eax, eax, 0x37                          # 004b86d9
    mov ecx, dword ptr [ebp - local_10]          # 004b86dc
    cmp dword ptr [ecx + eax + field_7d], 0x0    # 004b86df
    je.d8 L_004b8752                             # 004b86e4
    # block 0x004b86e6: entered by fall-through of je at 0x004b86e4, 11 instruction(s), ends with jne to 0x004b8752 (forward)
    movsx edx, word ptr [ebp - local_c]          # 004b86e6
    imul edx, edx, 0x37                          # 004b86ea
    mov eax, dword ptr [ebp - local_10]          # 004b86ed
    mov ecx, dword ptr [eax + edx + field_5e]    # 004b86f0
    sub ecx, dword ptr [0x58318a]                # 004b86f4
    mov edx, dword ptr [ebp - local_10]          # 004b86fa
    mov eax, dword ptr [edx + field_8]           # 004b86fd
    movsx edx, word ptr [ebp - local_8]          # 004b8700
    shl edx, 0x4                                 # 004b8704
    cmp ecx, dword ptr [eax + edx + field_179]   # 004b8707
    jne.d8 L_004b8752                            # 004b870e
    # block 0x004b8710: entered by fall-through of jne at 0x004b870e, 11 instruction(s), ends with jne to 0x004b8752 (forward)
    movsx eax, word ptr [ebp - local_c]          # 004b8710
    imul eax, eax, 0x37                          # 004b8714
    mov ecx, dword ptr [ebp - local_10]          # 004b8717
    mov edx, dword ptr [ecx + eax + field_5a]    # 004b871a
    sub edx, dword ptr [0x583186]                # 004b871e
    mov eax, dword ptr [ebp - local_10]          # 004b8724
    mov ecx, dword ptr [eax + field_8]           # 004b8727
    movsx eax, word ptr [ebp - local_8]          # 004b872a
    shl eax, 0x4                                 # 004b872e
    cmp edx, dword ptr [ecx + eax + field_175]   # 004b8731
    jne.d8 L_004b8752                            # 004b8738
    # block 0x004b873a: entered by fall-through of jne at 0x004b8738, 4 instruction(s), falls into the block at 0x004b8752
    mov dword ptr [ebp - local_4], 0x1           # 004b873a
    mov ecx, dword ptr [0x61ee76]                # 004b8741
    mov dx, word ptr [ecx + field_173]           # 004b8747
    mov word ptr [ebp - local_c], dx             # 004b874e
L_004b8752:
    # block 0x004b8752: entered by je at 0x004b86e4; jne at 0x004b870e; jne at 0x004b8738, 1 instruction(s), ends with backward jump to 0x004b86b0
    jmp.d32 L_004b86b0                           # 004b8752
L_004b8757:
    # block 0x004b8757: entered by jge at 0x004b86cf, 2 instruction(s), ends with je to 0x004b8776 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 004b8757
    je.d8 L_004b8776                             # 004b875b
    # block 0x004b875d: entered by fall-through of je at 0x004b875b, 7 instruction(s), calls FUN_0050cd50, falls into the block at 0x004b8776
    call FUN_0050cd50                            # 004b875d
    mov ecx, dword ptr [ebp - local_10]          # 004b8762
    mov edx, dword ptr [ecx + field_8]           # 004b8765
    movsx ecx, word ptr [edx + field_173]        # 004b8768
    cdq                                          # 004b876f
    idiv ecx                                     # 004b8770
    mov word ptr [ebp - local_8], dx             # 004b8772
L_004b8776:
    # block 0x004b8776: entered by je at 0x004b875b, 1 instruction(s), ends with backward jump to 0x004b8697
    jmp.d32 L_004b8697                           # 004b8776
L_004b877b:
    # block 0x004b877b: entered by je at 0x004b869b, 4 instruction(s), ends with ret
    mov ax, word ptr [ebp - local_8]             # 004b877b
    {load} mov esp, ebp                          # 004b877f
    pop ebp                                      # 004b8781
    ret                                          # 004b8782

