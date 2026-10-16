# FUN_004f2640
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f2640
# extent:       0x004f2640-0x004f2710 (208 code bytes)
# span:         0x004f2640-0x004f2710 (code 208, tables 0, padding 0)
# sha256:       a0efa583d498e267a1103819803b04aaad7a1ee86951796bbcc6453cd3c7411c
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f2640
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_198, field_3ca, field_3d2; [ecx + n] field_19c, field_1a0, field_3c2, field_3d6; [edx + n] field_194, field_2b6, field_2ba, field_3c6, field_3ce
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 43 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_194, 0x194  # offset +0x194
.equ field_198, 0x198  # offset +0x198
.equ field_19c, 0x19c  # offset +0x19c
.equ field_1a0, 0x1a0  # offset +0x1a0
.equ field_2b6, 0x2b6  # offset +0x2b6
.equ field_2ba, 0x2ba  # offset +0x2ba
.equ field_3c2, 0x3c2  # offset +0x3c2
.equ field_3c6, 0x3c6  # offset +0x3c6
.equ field_3ca, 0x3ca  # offset +0x3ca
.equ field_3ce, 0x3ce  # offset +0x3ce
.equ field_3d2, 0x3d2  # offset +0x3d2
.equ field_3d6, 0x3d6  # offset +0x3d6

# --- external targets -----------------------------------------------

.org 0x004f2640 - 0x401000
.globl FUN_004f2640
FUN_004f2640:
    # block 0x004f2640: entry, 30 instruction(s), ends with forward jump to 0x004f26f0
    push ebp                                     # 004f2640
    {load} mov ebp, esp                          # 004f2641
    sub esp, 0x8                                 # 004f2643
    mov dword ptr [ebp - local_8], ecx           # 004f2646
    mov eax, dword ptr [ebp - local_8]           # 004f2649
    mov dword ptr [eax + field_3ca], 0x0         # 004f264c
    mov ecx, dword ptr [ebp - local_8]           # 004f2656
    mov dword ptr [ecx + field_3c2], 0x3e8       # 004f2659
    mov edx, dword ptr [ebp - local_8]           # 004f2663
    mov dword ptr [edx + field_3c6], 0x3e8       # 004f2666
    mov eax, dword ptr [ebp - local_8]           # 004f2670
    mov byte ptr [eax], 0x0                      # 004f2673
    mov ecx, dword ptr [ebp - local_8]           # 004f2676
    mov dword ptr [ecx + field_1a0], 0x0         # 004f2679
    mov edx, dword ptr [ebp - local_8]           # 004f2683
    mov dword ptr [edx + field_194], 0x0         # 004f2686
    mov eax, dword ptr [ebp - local_8]           # 004f2690
    mov dword ptr [eax + field_198], 0x0         # 004f2693
    mov ecx, dword ptr [ebp - local_8]           # 004f269d
    mov dword ptr [ecx + field_19c], 0x0         # 004f26a0
    mov edx, dword ptr [ebp - local_8]           # 004f26aa
    mov dword ptr [edx + field_2b6], 0x0         # 004f26ad
    mov eax, dword ptr [ebp - local_8]           # 004f26b7
    mov dword ptr [eax + field_3d2], 0x0         # 004f26ba
    mov ecx, dword ptr [ebp - local_8]           # 004f26c4
    mov dword ptr [ecx + field_3d6], 0x0         # 004f26c7
    mov edx, dword ptr [ebp - local_8]           # 004f26d1
    mov dword ptr [edx + field_3ce], 0x0         # 004f26d4
    mov dword ptr [ebp - local_4], 0x0           # 004f26de
    jmp.d8 L_004f26f0                            # 004f26e5
L_004f26e7:
    # block 0x004f26e7: entered by jmp at 0x004f2707, 3 instruction(s), falls into the block at 0x004f26f0
    mov eax, dword ptr [ebp - local_4]           # 004f26e7
    add eax, 0x1                                 # 004f26ea
    mov dword ptr [ebp - local_4], eax           # 004f26ed
L_004f26f0:
    # block 0x004f26f0: entered by jmp at 0x004f26e5, 2 instruction(s), ends with jge to 0x004f2709 (forward)
    cmp dword ptr [ebp - local_4], 0x40          # 004f26f0
    jge.d8 L_004f2709                            # 004f26f4
    # block 0x004f26f6: entered by fall-through of jge at 0x004f26f4, 4 instruction(s), ends with backward jump to 0x004f26e7
    mov ecx, dword ptr [ebp - local_4]           # 004f26f6
    mov edx, dword ptr [ebp - local_8]           # 004f26f9
    mov dword ptr [edx + 4*ecx + field_2ba], 0x0 # 004f26fc
    jmp.d8 L_004f26e7                            # 004f2707
L_004f2709:
    # block 0x004f2709: entered by jge at 0x004f26f4, 4 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_8]           # 004f2709
    {load} mov esp, ebp                          # 004f270c
    pop ebp                                      # 004f270e
    ret                                          # 004f270f

