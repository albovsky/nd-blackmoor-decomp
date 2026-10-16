# FUN_00486725
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00486725
# extent:       0x00486725-0x004867bd (152 code bytes)
# span:         0x00486725-0x004867bd (code 152, tables 0, padding 0)
# sha256:       a1bdcd83e0540a10a1494cec790ec67b6dfd6a00488342849cdbe5b55b9488ab
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00486725
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_26, field_ab; [ecx + n] field_21, field_4b, field_a3, field_bac; [edx + n] field_bb0
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 44 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_21, 0x21  # offset +0x21
.equ field_26, 0x26  # offset +0x26
.equ field_4b, 0x4b  # offset +0x4b
.equ field_a3, 0xa3  # offset +0xa3
.equ field_ab, 0xab  # offset +0xab
.equ field_bac, 0xbac  # offset +0xbac
.equ field_bb0, 0xbb0  # offset +0xbb0

# --- external targets -----------------------------------------------

.org 0x00486725 - 0x401000
.globl FUN_00486725
FUN_00486725:
    # block 0x00486725: entry, 11 instruction(s), ends with forward jump to 0x00486756
    push ebp                                     # 00486725
    {load} mov ebp, esp                          # 00486726
    sub esp, 0xc                                 # 00486728
    mov dword ptr [ebp - local_c], ecx           # 0048672b
    mov eax, dword ptr [ebp - local_c]           # 0048672e
    movsx ecx, word ptr [eax + field_26]         # 00486731
    imul ecx, ecx, 0x8d                          # 00486735
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0048673b
    mov dword ptr [ebp - local_8], edx           # 00486741
    mov dword ptr [ebp - local_4], 0x0           # 00486744
    jmp.d8 L_00486756                            # 0048674b
L_0048674d:
    # block 0x0048674d: entered by jmp at 0x004867a0, 3 instruction(s), falls into the block at 0x00486756
    mov eax, dword ptr [ebp - local_4]           # 0048674d
    add eax, 0x1                                 # 00486750
    mov dword ptr [ebp - local_4], eax           # 00486753
L_00486756:
    # block 0x00486756: entered by jmp at 0x0048674b, 4 instruction(s), ends with jge to 0x004867a2 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00486756
    movsx edx, word ptr [ecx + field_21]         # 00486759
    cmp dword ptr [ebp - local_4], edx           # 0048675d
    jge.d8 L_004867a2                            # 00486760
    # block 0x00486762: entered by fall-through of jge at 0x00486760, 7 instruction(s), ends with jne to 0x004867a0 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00486762
    imul eax, eax, 0x85                          # 00486765
    mov ecx, dword ptr [ebp - local_c]           # 0048676b
    {load} xor edx, edx                          # 0048676e
    mov dl, byte ptr [ecx + eax + field_4b]      # 00486770
    test edx, edx                                # 00486774
    jne.d8 L_004867a0                            # 00486776
    # block 0x00486778: entered by fall-through of jne at 0x00486776, 5 instruction(s), ends with jne to 0x0048679e (forward)
    mov eax, dword ptr [ebp - local_4]           # 00486778
    imul eax, eax, 0x42                          # 0048677b
    mov ecx, dword ptr [ebp - local_8]           # 0048677e
    cmp dword ptr [ecx + eax + field_a3], 0x0    # 00486781
    jne.d8 L_0048679e                            # 00486789
    # block 0x0048678b: entered by fall-through of jne at 0x00486789, 5 instruction(s), ends with je to 0x004867a0 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0048678b
    imul edx, edx, 0x42                          # 0048678e
    mov eax, dword ptr [ebp - local_8]           # 00486791
    cmp dword ptr [eax + edx + field_ab], 0x0    # 00486794
    je.d8 L_004867a0                             # 0048679c
L_0048679e:
    # block 0x0048679e: entered by jne at 0x00486789; fall-through of je at 0x0048679c, 1 instruction(s), ends with forward jump to 0x004867b9
    jmp.d8 L_004867b9                            # 0048679e
L_004867a0:
    # block 0x004867a0: entered by jne at 0x00486776; je at 0x0048679c, 1 instruction(s), ends with backward jump to 0x0048674d
    jmp.d8 L_0048674d                            # 004867a0
L_004867a2:
    # block 0x004867a2: entered by jge at 0x00486760, 4 instruction(s), falls into the block at 0x004867b9
    mov ecx, dword ptr [ebp - local_c]           # 004867a2
    mov dword ptr [ecx + field_bac], 0x6         # 004867a5
    mov edx, dword ptr [ebp - local_c]           # 004867af
    mov byte ptr [edx + field_bb0], 0x1          # 004867b2
L_004867b9:
    # block 0x004867b9: entered by jmp at 0x0048679e, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004867b9
    pop ebp                                      # 004867bb
    ret                                          # 004867bc

