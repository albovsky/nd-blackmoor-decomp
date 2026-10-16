# FUN_0048a70a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048a70a
# extent:       0x0048a70a-0x0048a7e5 (219 code bytes)
# span:         0x0048a70a-0x0048a7e5 (code 219, tables 0, padding 0)
# sha256:       8cb76421ffc302f7a1e3e9ee74f03048e3e1d24e257a157a09590fd317df100f
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0048a70a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1e, field_4e, field_1ae, field_1b0, field_1ba; [ecx + n] field_1c, field_2e, field_42, field_1a6, field_1af; [edx + n] field_20, field_24, field_44, field_192, field_1aa
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 50 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_2e, 0x2e  # offset +0x2e
.equ field_42, 0x42  # offset +0x42
.equ field_44, 0x44  # offset +0x44
.equ field_4e, 0x4e  # offset +0x4e
.equ field_192, 0x192  # offset +0x192
.equ field_1a6, 0x1a6  # offset +0x1a6
.equ field_1aa, 0x1aa  # offset +0x1aa
.equ field_1ae, 0x1ae  # offset +0x1ae
.equ field_1af, 0x1af  # offset +0x1af
.equ field_1b0, 0x1b0  # offset +0x1b0
.equ field_1ba, 0x1ba  # offset +0x1ba

# --- external targets -----------------------------------------------

.org 0x0048a70a - 0x401000
.globl FUN_0048a70a
FUN_0048a70a:
    # block 0x0048a70a: entry, 28 instruction(s), ends with forward jump to 0x0048a79a
    push ebp                                     # 0048a70a
    {load} mov ebp, esp                          # 0048a70b
    sub esp, 0x8                                 # 0048a70d
    mov dword ptr [ebp - local_8], ecx           # 0048a710
    mov eax, dword ptr [ebp - local_8]           # 0048a713
    mov word ptr [eax + field_1e], 0xffff        # 0048a716
    mov ecx, dword ptr [ebp - local_8]           # 0048a71c
    mov word ptr [ecx + field_1c], 0xffff        # 0048a71f
    mov edx, dword ptr [ebp - local_8]           # 0048a725
    mov dword ptr [edx + field_1aa], 0x0         # 0048a728
    mov eax, dword ptr [ebp - local_8]           # 0048a732
    mov byte ptr [eax + field_1ae], 0x0          # 0048a735
    mov ecx, dword ptr [ebp - local_8]           # 0048a73c
    mov byte ptr [ecx + field_1af], 0x0          # 0048a73f
    mov edx, dword ptr [ebp - local_8]           # 0048a746
    mov dword ptr [edx + field_20], 0x0          # 0048a749
    mov eax, dword ptr [ebp - local_8]           # 0048a750
    mov word ptr [eax + field_1b0], 0xffff       # 0048a753
    mov ecx, dword ptr [ebp - local_8]           # 0048a75c
    mov word ptr [ecx + field_42], 0x0           # 0048a75f
    mov edx, dword ptr [ebp - local_8]           # 0048a765
    mov dword ptr [edx + field_44], 0x0          # 0048a768
    mov eax, dword ptr [ebp - local_8]           # 0048a76f
    mov dword ptr [eax + field_4e], 0x1          # 0048a772
    mov ecx, dword ptr [ebp - local_8]           # 0048a779
    mov dword ptr [ecx + field_1a6], 0x0         # 0048a77c
    mov word ptr [ebp - local_4], 0x0            # 0048a786
    jmp.d8 L_0048a79a                            # 0048a78c
L_0048a78e:
    # block 0x0048a78e: entered by jmp at 0x0048a7df, 3 instruction(s), falls into the block at 0x0048a79a
    mov dx, word ptr [ebp - local_4]             # 0048a78e
    add dx, 0x1                                  # 0048a792
    mov word ptr [ebp - local_4], dx             # 0048a796
L_0048a79a:
    # block 0x0048a79a: entered by jmp at 0x0048a78c, 3 instruction(s), ends with jge to 0x0048a7e1 (forward)
    movsx eax, word ptr [ebp - local_4]          # 0048a79a
    cmp eax, 0xa                                 # 0048a79e
    jge.d8 L_0048a7e1                            # 0048a7a1
    # block 0x0048a7a3: entered by fall-through of jge at 0x0048a7a1, 13 instruction(s), ends with backward jump to 0x0048a78e
    movsx ecx, word ptr [ebp - local_4]          # 0048a7a3
    mov edx, dword ptr [ebp - local_8]           # 0048a7a7
    mov byte ptr [edx + ecx + field_24], 0x0     # 0048a7aa
    movsx eax, word ptr [ebp - local_4]          # 0048a7af
    mov ecx, dword ptr [ebp - local_8]           # 0048a7b3
    mov word ptr [ecx + 2*eax + field_2e], 0xffff # 0048a7b6
    movsx edx, word ptr [ebp - local_4]          # 0048a7bd
    mov eax, dword ptr [ebp - local_8]           # 0048a7c1
    mov word ptr [eax + 2*edx + field_1ba], 0xffff # 0048a7c4
    movsx ecx, word ptr [ebp - local_4]          # 0048a7ce
    mov edx, dword ptr [ebp - local_8]           # 0048a7d2
    mov word ptr [edx + 2*ecx + field_192], 0xffff # 0048a7d5
    jmp.d8 L_0048a78e                            # 0048a7df
L_0048a7e1:
    # block 0x0048a7e1: entered by jge at 0x0048a7a1, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0048a7e1
    pop ebp                                      # 0048a7e3
    ret                                          # 0048a7e4

