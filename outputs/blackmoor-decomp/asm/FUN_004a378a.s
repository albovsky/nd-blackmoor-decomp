# FUN_004a378a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a378a
# extent:       0x004a378a-0x004a3884 (250 code bytes)
# span:         0x004a378a-0x004a3884 (code 250, tables 0, padding 0)
# sha256:       f39bf871c7f63f18e806ad991a5ec12d6435c6a3e34e043cdfb08bae23f590d4
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a378a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1e, field_210, field_216, field_266, field_276, field_27f; [ecx + n] field_1c, field_200, field_212, field_258, field_260, field_278; [edx + n] field_214, field_25c, field_26e, field_272, field_27a
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m4a371a_construct_base_set_vtable (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 51 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_200, 0x200  # offset +0x200
.equ field_210, 0x210  # offset +0x210
.equ field_212, 0x212  # offset +0x212
.equ field_214, 0x214  # offset +0x214
.equ field_216, 0x216  # offset +0x216
.equ field_258, 0x258  # offset +0x258
.equ field_25c, 0x25c  # offset +0x25c
.equ field_260, 0x260  # offset +0x260
.equ field_266, 0x266  # offset +0x266
.equ field_26e, 0x26e  # offset +0x26e
.equ field_272, 0x272  # offset +0x272
.equ field_276, 0x276  # offset +0x276
.equ field_278, 0x278  # offset +0x278
.equ field_27a, 0x27a  # offset +0x27a
.equ field_27f, 0x27f  # offset +0x27f

# --- external targets -----------------------------------------------

.org 0x004a378a - 0x401000
.globl FUN_004a378a
FUN_004a378a:
    # block 0x004a378a: entry, 38 instruction(s), ends with forward jump to 0x004a3863
    push ebp                                     # 004a378a
    {load} mov ebp, esp                          # 004a378b
    sub esp, 0x8                                 # 004a378d
    mov dword ptr [ebp - local_8], ecx           # 004a3790
    mov eax, dword ptr [ebp - local_8]           # 004a3793
    mov word ptr [eax + field_1e], 0xffff        # 004a3796
    mov ecx, dword ptr [ebp - local_8]           # 004a379c
    mov word ptr [ecx + field_1c], 0xffff        # 004a379f
    mov edx, dword ptr [ebp - local_8]           # 004a37a5
    mov dword ptr [edx + field_26e], 0x0         # 004a37a8
    mov eax, dword ptr [ebp - local_8]           # 004a37b2
    mov word ptr [eax + field_276], 0xffff       # 004a37b5
    mov ecx, dword ptr [ebp - local_8]           # 004a37be
    mov word ptr [ecx + field_278], 0xffff       # 004a37c1
    mov edx, dword ptr [ebp - local_8]           # 004a37ca
    mov byte ptr [edx + field_27a], 0x0          # 004a37cd
    mov eax, dword ptr [ebp - local_8]           # 004a37d4
    mov byte ptr [eax + field_27f], 0x0          # 004a37d7
    mov ecx, dword ptr [ebp - local_8]           # 004a37de
    mov dword ptr [ecx + field_260], 0x0         # 004a37e1
    mov edx, dword ptr [ebp - local_8]           # 004a37eb
    mov dword ptr [edx + field_272], 0x0         # 004a37ee
    mov eax, dword ptr [ebp - local_8]           # 004a37f8
    mov word ptr [eax + field_210], 0xffff       # 004a37fb
    mov ecx, dword ptr [ebp - local_8]           # 004a3804
    mov word ptr [ecx + field_212], 0xffff       # 004a3807
    mov edx, dword ptr [ebp - local_8]           # 004a3810
    mov word ptr [edx + field_214], 0xffff       # 004a3813
    mov eax, dword ptr [ebp - local_8]           # 004a381c
    mov word ptr [eax + field_216], 0xffff       # 004a381f
    mov ecx, dword ptr [ebp - local_8]           # 004a3828
    mov dword ptr [ecx + field_258], 0x0         # 004a382b
    mov edx, dword ptr [ebp - local_8]           # 004a3835
    mov dword ptr [edx + field_25c], 0x0         # 004a3838
    mov eax, dword ptr [ebp - local_8]           # 004a3842
    mov dword ptr [eax + field_266], 0x0         # 004a3845
    mov word ptr [ebp - local_4], 0x0            # 004a384f
    jmp.d8 L_004a3863                            # 004a3855
L_004a3857:
    # block 0x004a3857: entered by jmp at 0x004a387e, 3 instruction(s), falls into the block at 0x004a3863
    mov cx, word ptr [ebp - local_4]             # 004a3857
    add cx, 0x1                                  # 004a385b
    mov word ptr [ebp - local_4], cx             # 004a385f
L_004a3863:
    # block 0x004a3863: entered by jmp at 0x004a3855, 3 instruction(s), ends with jge to 0x004a3880 (forward)
    movsx edx, word ptr [ebp - local_4]          # 004a3863
    cmp edx, 0x4                                 # 004a3867
    jge.d8 L_004a3880                            # 004a386a
    # block 0x004a386c: entered by fall-through of jge at 0x004a386a, 4 instruction(s), ends with backward jump to 0x004a3857
    movsx eax, word ptr [ebp - local_4]          # 004a386c
    mov ecx, dword ptr [ebp - local_8]           # 004a3870
    mov dword ptr [ecx + 4*eax + field_200], 0x0 # 004a3873
    jmp.d8 L_004a3857                            # 004a387e
L_004a3880:
    # block 0x004a3880: entered by jge at 0x004a386a, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004a3880
    pop ebp                                      # 004a3882
    ret                                          # 004a3883

